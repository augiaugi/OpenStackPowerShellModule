Roadmap (TODOs)

    -New-OSServer
    -New-OSPort
    -OSPortAllowedAddress (Get, Add, Remove)
    -New-Volume
    -New-VolumeSnapshot
    -New-VolumeBackup
    -set id as default property if exists (all have id property?? --> metadata???) on Get-OSObjectIdentifierer
    -Identity
        -all Set commands
        -Region management
        -Policy management

Command Guidlines

    Alias

        all Get Commands have alias (ID,Identity,<ObjectName, e.g. Flavor>)

    Parameter pass object

        Get-OSFlavor -Identity (Get-OSFlavor -ID w1-16384)

    Pipeline - describes basic pipline functionality

        Get-OSFlavor -ID "w1-16384", "w1-16384"
        "w1-16384", "w1-16384" | Get-OSFlavor

    Cross Object Pipline
        Get-OSServer -ID ce847820-4d6b-47f0-b0e5-486457fe1044 | Get-OSFlavor
        Get-OSServer | Select -First 1 | Get-OSFlavor

    inteligent Pipline

        allows not only one type of object beeing piped to a command
        
        e.g. not only pipe Get-OSGroup to Get-OSGroupMember
        Get-OSUser -ImputObject 8de3aad02306495d8683d9fc94479b07 | Get-OSGroupMember

Known Issues

    Pipline get Port from Server is not working because relation data "addresses" is custom object and has no id
        Example: Get-OSServer -ID 7606ec9a-78d6-40ca-aee0-abf05c11edde | Get-OSPort
        Workaround: Get-OSPort -Server (Get-OSServer -ID 7606ec9a-78d6-40ca-aee0-abf05c11edde)

    Get-OSServer -ID 7606ec9a-78d6-40ca-aee0-abf05c11edde | Get-OSSecurityGroup