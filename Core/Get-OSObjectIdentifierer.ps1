function Get-OSObjectIdentifierer
{
  [CmdLetBinding(DefaultParameterSetName = 'Default')]
  Param
  (
    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    $Object,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [string]$PropertyHint,

    [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
    [string]$DefaultPropertyPath
  )

  try 
  {
    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'start'

    if($Object)
    {
      $IdentityRelationConfig = @(
        #region Server
        [PSCustomObject]@{Type='OS.Server'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region ServerAction
        [PSCustomObject]@{Type='OS.ServerAction'; PropertyHint=$null; PropertyPath='request_id'; Default=$true}
        #endregion

        #region Image
        [PSCustomObject]@{Type='OS.Image'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        [PSCustomObject]@{Type='OS.Server'; PropertyHint='OS.Image'; PropertyPath='image.id'; Default=$false} #get Image from Server object
        #endregion

        #region Volume
        [PSCustomObject]@{Type='OS.Volume'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        [PSCustomObject]@{Type='OS.Server'; PropertyHint='OS.Volume'; PropertyPath='"os-extended-volumes:volumes_attached".id'; Default=$false} #get Volume from Server object
        [PSCustomObject]@{Type='OS.ServerVolumeAttachment'; PropertyHint='OS.Volume'; PropertyPath='volumeId'; Default=$false} #get Volume from ServerVolumeAttachment object
        #endregion

        #region VolumeSnapshot
        [PSCustomObject]@{Type='OS.VolumeSnapshot'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region VolumeBackup
        [PSCustomObject]@{Type='OS.VolumeBackup'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region Port
        [PSCustomObject]@{Type='OS.Port'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        [PSCustomObject]@{Type='OS.ServerInterface'; PropertyHint='OS.Port'; PropertyPath='port_id'; Default=$false} #get Port from ServerInterface object
        #endregion

        #region Flavor
        [PSCustomObject]@{Type='OS.Flavor'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region SecurityGroup
        [PSCustomObject]@{Type='OS.SecurityGroup'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        [PSCustomObject]@{Type='OS.Server'; PropertyHint='OS.SecurityGroup'; PropertyPath='flavor.id'; Default=$false} #get SecurityGroup from Server object
        #endregion

        #region User
        [PSCustomObject]@{Type='OS.User'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region Group
        [PSCustomObject]@{Type='OS.Group'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region CreateGroup
        [PSCustomObject]@{Type='OS.CreateGroup'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        [PSCustomObject]@{Type='OS.CreateGroup'; PropertyHint='OS.Group'; PropertyPath='id'; Default=$true}
        #endregion

        #region Domain
        [PSCustomObject]@{Type='OS.Domain'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region Region
        [PSCustomObject]@{Type='OS.Region'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region Service
        [PSCustomObject]@{Type='OS.Service'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region Endpoint
        [PSCustomObject]@{Type='OS.Endpoint'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion

        #region Hypervisor
        [PSCustomObject]@{Type='OS.Hypervisor'; PropertyHint=$null; PropertyPath='id'; Default=$true}
        #endregion
      )

      $Type = $Object.pstypenames[0]
      #required if object is piped to Seelct-Object: Get-OSLoggingManager | Select -First 1 | Get-PWSWindowsServiceRunspace
      if($Type -eq 'Selected.System.Management.Automation.PSCustomObject')
      {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "piped object, Type [$Type]"
        $Type = $Object.pstypenames[1]
      }

      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "get identifierer property for Type [$Type], PropertyHint [$PropertyHint]"

      $IdentityRelationConfigItem = $IdentityRelationConfig | ?{$_.Type -eq $Type -and $_.PropertyHint -eq $PropertyHint -and !$_.Default}
      if($IdentityRelationConfigItem)
      {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "{$Type} identifierer property [$($IdentityRelationConfigItem.PropertyPath)], PropertyHint [$PropertyHint]"
        $Identity = Invoke-Expression "`$Object.$($IdentityRelationConfigItem.PropertyPath)"

        if(!$Identity)
        {
          throw "cannot find Identity on object [$Type], PropertyHint [$PropertyHint]"
        }
      }
      else 
      {
        $IdentityRelationConfigItem = $IdentityRelationConfig | ?{$_.Type -eq $Type -and $_.Default}
        if($IdentityRelationConfigItem)
        {
          #DefaultPropertyPath is defined and will override the default PropertyPath
          if($DefaultPropertyPath)
          {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "{$Type} default identifierer property [$DefaultPropertyPath] overrides [$($IdentityRelationConfigItem.PropertyPath)], "
            $Identity = @(Invoke-Expression "`$Object.$DefaultPropertyPath")
          }
          else 
          {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "{$Type} default identifierer property [$($IdentityRelationConfigItem.PropertyPath)], "
            $Identity = @(Invoke-Expression "`$Object.$($IdentityRelationConfigItem.PropertyPath)")
          }
        }
        else 
        {
          Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "no identifierer property found, use original object"
          $Identity = $Object
        }
      }

      foreach($IdentityItem in $Identity)
      {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "Identity [$IdentityItem]"
        Write-Output $IdentityItem
      }
    }
    else 
    {
      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type DEBUG -Message "object is empty]"
    }
  }
  catch 
  {
    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type ERROR -Exception $_
    throw
  }
  finally
  {
      Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'end'
  } 
}