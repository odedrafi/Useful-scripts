# script that installs an algorithm by copying the bin and program date to our local machine
# we do this by bucket name and algorithm name as env variables defined when the ec2 instance is build at the start of the workflow
# detailed in the main script

Write-Host "install_algo_script has started." -ForegroundColor green #-BackgroundColor white

$ErrorActionPreference = 'stop'

Write-Host "Creating folders and defining variables for algorithm install." -ForegroundColor green
# define local path directories in variables
$Local_algo_bin_path = New-Item "C:\nucleix\bin" -Itemtype directory
$Local_progdata_path = New-Item "C:\ProgramData\nucleix" -Itemtype directory


Write-Host "Copying bin directory from the algorithm bucket to our local machine." -ForegroundColor green
#copy the algoritem bin folder from s3 algo bucket to ec2 instance(installation of algorithm)
aws s3 cp s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_NAME/bin $Local_algo_bin_path --recursive



Write-Host "Copying program-data directory from the algorithm bucket to our local machine.." -ForegroundColor green
#copy the algoritem program-data folder from s3 algo bucket to ec2 instance(installation of algorithm)
aws s3 cp s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_NAME/program-data $Local_progdata_path --recursive

