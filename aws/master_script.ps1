

Install-Module -name AWSPowerShell.NetCore
Set-ExecutionPolicy RemoteSigned 
#setting aws credential for coneectivity
Set-AWSCredentials -AccessKey $MyAccesKey `
    -SecretKey $MySecretKey `
    -StoreAs $MyMainUserProfile
Initialize-AWSDefaults -ProfileName $MyMainUserProfile `
    -Region $MyRegion

    