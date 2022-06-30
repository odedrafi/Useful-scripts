# master script
# this script is as part of a workflow that includes :
# a SNS trigger by a file upload to a s3 bucket building a ec2 instance with env variables defind with 
# parameters nedded for the script to run
# resulte=> installing an algorithm and executing it with a sample file inorder to produce an output 
# and then copying it to a s3 bucket
# 
# to echieve that the master script wil run two sub scripts
# 1. install_algo_script.ps1 - this script will install(copy) the relevent algo to the local instance
# 2. executer.ps1- this script will copy the sample file from the s3 bucket and execute the algo on the sample file
# produce an output, copy it back to the s3 bucket and terminate the instance.

$ErrorActionPreference = 'stop'
# set execution policy inorder to execute scripts
# Set-ExecutionPolicy RemoteSigned -Force
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
    Write-Host "Script failed: "$Error[0]"" -ForegroundColor red
    
}