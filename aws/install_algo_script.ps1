# script that installs an algorithm by copying the bin and program date to our local machine
# we do this by bucket name and algorithm name as env variables defined when the ec2 instance is build at the start of the workflow
# detailed in the main script
# Set-ExecutionPolicy RemoteSigned -Force

Write-Host "install_algo_script has started." -ForegroundColor green #-BackgroundColor white


$ErrorActionPreference = 'stop'
$date = Get-Date -Format G
Write-Host "$date :install_algo_script has started." -ForegroundColor green 

$date = Get-Date -Format G
Write-Host "$date :Creating folders and defining variables for algorithm install." -ForegroundColor green
Write-Output  "$date :Creating folders and defining variables for algorithm install." >> C:\"$env:ALGORITHM_NAME"_logFile.txt
# define local path directories in variables
$Local_algo_bin_path = New-Item "C:\nucleix\bin" -Itemtype directory -ErrorAction Continue
$Local_progdata_path = New-Item "C:\ProgramData\nucleix" -Itemtype directory -ErrorAction Continue


$date = Get-Date -Format G
Write-Host "$date :Copying bin directory from the algorithm bucket to our local machine." -ForegroundColor green
Write-Output  "$date :Copying bin directory from the algorithm bucket to our local machine." >> C:\"$env:ALGORITHM_NAME"_logFile.txt
#copy the algoritem bin folder from s3 algo bucket to ec2 instance(installation of algorithm)
aws s3 cp s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/bin $Local_algo_bin_path --recursive


$date = Get-Date -Format G
Write-Host "$date :Copying program-data directory from the algorithm bucket to our local machine." -ForegroundColor green
Write-Output  "$date :Copying program-data directory from the algorithm bucket to our local machine." >> C:\"$env:ALGORITHM_NAME"_logFile.txt
#copy the algoritem program-data folder from s3 algo bucket to ec2 instance(installation of algorithm)
aws s3 cp s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/program-data $Local_progdata_path --recursive

