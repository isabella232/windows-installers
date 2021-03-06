$currentDir = Split-Path -parent $MyInvocation.MyCommand.Path
Set-Location $currentDir

# mapped sync folder for common scripts
. $currentDir\..\common\Utils.ps1
. $currentDir\..\common\CommonTests.ps1
. $currentDir\..\common\Artifact.ps1

Get-Version
Get-PreviousVersions

Describe "Silent Install with no plugins $(($Global:Version).Description)" {

    Invoke-SilentInstall -Exeargs @("PLUGINS=")

    Context-PingNode

    Context-PluginsInstalled -Expected @{ Plugins=@() }

    Context-ClusterNameAndNodeName

	Copy-ElasticsearchLogToOut
}

Describe "Silent Uninstall with no plugins $(($Global:Version).Description)" {

	$configDirectory = Get-ConfigEnvironmentVariableForVersion | Get-MachineEnvironmentVariable
	$dataDirectory = $configDirectory | Split-Path | Join-Path -ChildPath "data"
	$logsDirectory = $configDirectory | Split-Path | Join-Path -ChildPath "logs"

    Invoke-SilentUninstall

	Context-NodeNotRunning

	Context-EsConfigEnvironmentVariableNull

	Context-EsHomeEnvironmentVariableNull

	Context-MsiNotRegistered

	Context-ElasticsearchServiceNotInstalled

	Context-EmptyInstallDirectory

	Context-DataDirectories -Path @($configDirectory, $dataDirectory, $logsDirectory) -DeleteAfter
}