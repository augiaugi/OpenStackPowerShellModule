<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Volume

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    https://docs.openstack.org/api-ref/image/v2/?expanded=update-image-detail#update-image

    .NOTES
#>
function Set-OSImage
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Image')]
        $ImputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('add', 'remove', 'replace')]
        [string]$Operation = 'replace',

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -like '/*'})]
        #400 Bad Request Pointer `billing_info` does not start with "/".
        [string]$Path,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Value
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($ImputObject in $ImputObject)
            {
                $ImputObject = Get-OSObjectIdentifierer -Object $ImputObject -PropertyHint 'OS.Image'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "set Image [$ImputObject] [$Path] to [$Value]"

                #400 Bad Request Request body must be a JSON array of operation objects.
                $Body = @([PSCustomObject]@{
                    op=$Operation
                    path=$Path
                    value=$Value
                })
                #415 Unsupported Media Type The request media type application/json is not supported by this server. --> The media type descriptor for the request body. Use application/openstack-images-v2.1-json-patch. (You can also use application/openstack-images-v2.0-json-patch, but keep in mind that it’s deprecated.)
                Invoke-OSApiRequest -HTTPVerb Patch -Type image -ContentType 'application/openstack-images-v2.1-json-patch' -Uri "/v2/images/$ImputObject" -Body $Body -NoOutput
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
}