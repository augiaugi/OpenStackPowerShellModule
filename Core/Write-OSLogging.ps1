function Write-OSLogging
{
  [CmdLetBinding(DefaultParameterSetName = 'Message')]
  Param
  (
    [Parameter (ParameterSetName = 'Message', Mandatory = $false)]
    [Parameter (ParameterSetName = 'Exception', Mandatory = $false)] 
    [ValidateNotNullOrEmpty()]
    [DateTime] $Timestamp = (Get-Date), 
    
    [Parameter (ParameterSetName = 'Message', Mandatory = $true)]
    [Parameter (ParameterSetName = 'Exception', Mandatory = $true)] 
    [ValidateSet('TRACE', 'DEBUG', 'INFO', 'WARNING', 'ERROR', 'FATAL')]
    [string] $Type, 
    
    [Parameter (ParameterSetName = 'Message', Mandatory = $true)]
    [Parameter (ParameterSetName = 'Exception', Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Source,

    [Parameter (ParameterSetName = 'Message', Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Message,
    
    [Parameter (ParameterSetName = 'Exception', Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    $Exception,

    [Parameter (ParameterSetName = 'Message', Mandatory = $false)]
    [Parameter (ParameterSetName = 'Exception', Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [Switch]$Host
  )

  switch($PSCmdlet.ParameterSetName)
  {
    'Message'
    {
      $Message = $Message
    }
    'Exception'
    {
      $Message = "Exception [$($Exception.Exception.Message)], InnerException [$($Exception.Exception.InnerException.Message)], CategoryInfo [$($Exception.CategoryInfo)], FullyQualifiedErrorId [$($Exception.FullyQualifiedErrorId)]"
    }
  }
  
  $Line =  "$(($Timestamp).ToString('yyyy.MM.dd HH:mm:ss.fff')) - $Type - $Source - $Message"

  if($Host)
  {
    Write-Host $Line
  }
  else 
  {
    Write-Verbose $Line
  }
}