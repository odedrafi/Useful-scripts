# master script
# this script is as part of a workflow that includes :
# a SNS trigger by a file upload to a s3 bucket building a ec2 instance with env variables defind with 
# parameters nedded for the script to run
# resulte=> installing an algorithm and executing it with a sample file inorder to produce an output 
# and then copying it to a s3 bucket
# 
# to achieve that the master script wil run two sub scripts
# 1. install_algo_script.ps1 - this script will install(copy) the relevent algo to the local instance
# 2. executer.ps1- this script will copy the sample file from the s3 bucket and execute the algo on the sample file
#    produce an output, copy it back to the s3 bucket and terminate the instance.
#    has a use case for failed process by creating a log file and sending it back to the bucket for debugging

$ErrorActionPreference = 'stop'
Write-Host "master_script has started." -ForegroundColor green



try {


    #####################################################################################
    # service installation script.will copy the algoritem from s3 bucket to ec2 instance
    & .\install_algo_script.ps1
    #####{################################################################################

    #####################################################################################
    # running the script that will excute the algoritem on the samplesfrom s3 bucket inpput folder and return the service output to the s3 bucket
    & .\executer.ps1
    #####################################################################################

}
catch {
    $date = Get-Date -Format G
    $Date_Array = Get-Date -Format "yyyy/MM/dd" # use to set the folder convention on the failed directory in the bucket
    Write-Host " $date : Script failed: "$Error[0]" " -ForegroundColor red
    Write-Output  " $date : Script failed: "$Error[0]" " >> C:\"$env:FILE_NAME"_logFile.txt
    aws s3 cp  C:\"$env:FILE_NAME"_logFile.txt s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/failed/$Date_Array/"$env:FILE_NAME"_logFile.txt
    aws s3 cp  C:\nucleix\in_progres\$env:FILE_NAME s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/failed/$Date_Array/$env:FILE_NAME

}









