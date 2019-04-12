<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Direction

    Ingress or egress, which is the direction in which the security group rule is applied.

    .PARAMETER SecurityGroup

    The security group ID to associate with this security group rule.

    .PARAMETER Protocol

    The IP protocol can be represented by a string, an integer, or null. Valid string or integer values are any or 0, ah or 51, dccp or 33, egp or 8, esp or 50, gre or 47, icmp or 1, icmpv6 or 58, igmp or 2, ipip or 4, ipv6-encap or 41, ipv6-frag or 44, ipv6-icmp or 58, ipv6-nonxt or 59, ipv6-opts or 60, ipv6-route or 43, ospf or 89, pgm or 113, rsvp or 46, sctp or 132, tcp or 6, udp or 17, udplite or 136, vrrp or 112. Additionally, any integer value between [0-255] is also valid. The string any (or integer 0) means all IP protocols. See the constants in neutron_lib.constants for the most up-to-date list of supported strings.

    .PARAMETER EthernetType
    
    Must be IPv4 or IPv6, and addresses represented in CIDR must match the ingress or egress rules.

    .PARAMETER PortRangeMin
    
    The minimum port number in the range that is matched by the security group rule. If the protocol is TCP, UDP, DCCP, SCTP or UDP-Lite this value must be less than or equal to the port_range_max attribute value. If the protocol is ICMP, this value must be an ICMP type.

    .PARAMETER PortRangeMax

    The maximum port number in the range that is matched by the security group rule. If the protocol is TCP, UDP, DCCP, SCTP or UDP-Lite this value must be greater than or equal to the port_range_min attribute value. If the protocol is ICMP, this value must be an ICMP code.
    
    .PARAMETER RemoteSecurityGroup
    
    The remote group UUID to associate with this security group rule. You can specify either the remote_group_id or remote_ip_prefix attribute in the request body.

    .PARAMETER Description

    A human-readable description for the resource. Default is an empty string.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/?expanded=create-security-group-rule-detail

    .NOTES
#>
function New-OSSecurityGroupRule
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Ingress', 'Egress')]
        [string]$Direction,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $SecurityGroup,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('any', 'ah', 'dccp', 'egp', 'esp', 'gre', 'icmp', 'icmpv6', 'igmp', 'ipip', 'ipv6-encap', 'ipv6-frag', 'ipv6-icmp', 'ipv6-nonxt', 'ipv6-opts', 'ipv6-route', 'ospf', 'pgm', 'rsvp', 'sctp', 'tcp', 'udp', 'udplite', 'vrrp')]
        [string]$Protocol,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('IPv4', 'IPv6')]
        [string]$EthernetType,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$PortRangeMin,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$PortRangeMax,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $RemoteSecurityGroup,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create SecurityGroup [$Name]"
                
            $BodyProperties = @{
                direction=$Direction
                security_group_id = (Get-OSObjectIdentifierer -Object $SecurityGroup -PropertyHint 'OS.SecurityGroup')
            }
            
            if($Protocol){$BodyProperties.Add('protocol', $Protocol)}
            if($EthernetType){$BodyProperties.Add('ethertype', $EthernetType)}
            if($PortRangeMin){$BodyProperties.Add('port_range_min', $PortRangeMin)}
            if($PortRangeMax){$BodyProperties.Add('port_range_max', $PortRangeMax)}
            if($RemoteSecurityGroup){$Properties.Add('remote_group_id', (Get-OSObjectIdentifierer -Object $RemoteSecurityGroup -PropertyHint 'OS.SecurityGroup'))}
            if($Description){$BodyProperties.Add('description', $Description)}
            [PSCustomObject]@{security_group_rule=$BodyProperties}

            Write-Output (Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "/v2.0/security-group-rules" -Property 'security_group_rule' -ObjectType 'OS.CreateSecurityGroupRule' -Body $Body)
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