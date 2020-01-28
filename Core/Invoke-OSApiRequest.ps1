function Invoke-OSApiRequest
{
  [CmdLetBinding(DefaultParameterSetName = 'Default')]
  Param
  (
    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Get', 'Post', 'Put', 'Patch', 'Delete')]
    [string]$HTTPVerb = 'Get',

    [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('container-infra', 'volumev3', 'volume', 'metering', 'placement', 'image', 'dns', 'compute', 'orchestration', 'cloudformation', 'identity', 'network', 'volumev2')]
    [string]$Type,

    [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    $Body,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [string]$ObjectType,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [string]$Property,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [switch]$NoOutput,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [ValidateSet('application/json', 'application/openstack-images-v2.1-json-patch')]
    [string]$ContentType = 'application/json'
  )

  $StartTimestamp = Get-Date

  try 
  {
   
    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'start'

    if(!$Global:OS_AuthToken -or !$Global:OS_Endpoints)
    {
      throw "please login using Connect-OSAccount"
    }

    $APIRequestHeader = @{
      "X-Auth-Token" = $Global:OS_AuthToken
      "Content-Type" = $ContentType
    }

    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "get Endpoint, Type [$Type]"
    $Endpoint = $Global:OS_Endpoints | ?{$_.type -eq $Type}
    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "Endpoint found, ID [$($Endpoint.id)], Name [$($Endpoint.name)], Type [$($Endpoint.type)]"

    $EndpointUri = ($Endpoint.endpoints | ?{$_.interface -eq $Global:OS_EndpointInterfaceType}).url

    $FullUri = "$EndpointUri/$Uri"

    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "invoke API request [$FullUri], HTTPVerb [$HTTPVerb]"
    if($Body -and (ConvertTo-Json -InputObject $Body -Compress) -ne '{}') 
    {
      $BodyJson = (ConvertTo-Json -InputObject $Body -Depth 99)
      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "use request body [$BodyJson]"
      $Response = @(Invoke-WebRequest -Method $HTTPVerb -Uri $FullUri -Body $BodyJson -Headers $APIRequestHeader -Verbose:$false)
    }
    else 
    {
      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "no request body defined"
      $Response = @(Invoke-WebRequest -Method $HTTPVerb -Uri $FullUri -Headers $APIRequestHeader -Verbose:$false)
    }
    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "invoked API request, StatusCode [$($Response.StatusCode)], StatusDescription [$($Response.StatusDescription)]"

    #output header for debugging purposes 
    foreach($Header in $Response.Headers.GetEnumerator())
    {
      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "Header [$($Header.Key)]=[$($Header.Value)]"
    }

    $Data = $Response.Content | ConvertFrom-Json

    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "Raw Data [$($Data | ConvertTo-Json -Depth 10)]"

    if(!$NoOutput)
    {
      #region output object
      if($ObjectType)
      {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "set ObjectType [$ObjectType]"
      }

      if($Property)
      {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "output data with Property [$Property]"
        $Data = @(Invoke-Expression "`$Data.$Property")
      }

      foreach($DataItem in $Data)
      {
        if($DataItem)
        {
          if($ObjectType)
          {
            $DataItem.pstypenames.Insert(0, $ObjectType)
          }
    
          Write-Output $DataItem 
        }
        else 
        {
          Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "no output data"
        }
      }
      #endregion
    }
  }
  catch 
  {
    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type ERROR -Exception $_

    #if auth token expired, reset all global variables --> requires a re-login
    if($_ -like '*The request you have made requires authentication*')
    {
      $Global:OS_Username = $null
      $Global:OS_Domain = $null
      $Global:OS_Project = $null
      $Global:OS_AuthToken = $null
      $Global:OS_Endpoints = $null
    }

    throw
  }
  finally
  {
      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "end, Duration [$((Get-Date) - $StartTimestamp)]"
  }
}