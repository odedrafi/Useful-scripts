


# set execution policy inorder to execute scripts
Set-ExecutionPolicy RemoteSigned


#####################################################################################
# service installation script.will copy the algoritem from s3 bucket to ec2 instance
 & .\install_algo_script.ps1
#####################################################################################

#####################################################################################
# running the script that will excute the algoritem on the samplesfrom s3 bucket inpput folder and return the service output to the s3 bucket
 & .\executer.ps1
#####################################################################################