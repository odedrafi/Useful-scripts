#set a parameter name for bucket filltering
###########################################################################################
$Params = @{

BucketName = $BucketName

Key = ‘how to assign specific services to users in office 365 using powershell/final.mp4’

File = ‘D:\TechSnips\tmp\final.mp4’

}
###########################################################################################

$PARAMETERS @{
DocumentName = "AWS-RunRemoteScript"
Targets = "Key=InstanceIds,Values=<instance ID>"
Parameter = @{
    sourceType="S3"
    sourceInfo='{"path": "https://s3.<aws-api-domain/script path>"}',;"commandLine"="script name and arguments"
}
}
# aws cli for downloading scripts from bycket and running them
# replace the content in the <place holder> with your parameters

Send-SSMCommand PARAMETERS