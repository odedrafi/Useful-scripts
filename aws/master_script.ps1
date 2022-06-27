# parameters will be updated in the machine env through the lambda function 
# and the creation of the machine in the start of the process
# these tow variables will build the yrl the command needs to copy the bucket folder

# BUCKET_NAME=>the name of the bucket containing the service and scripts to run
# 
# SERVICE_NAME=> the service name we want to download and install it wi represent also the name of the folder
# aws cp s3://bucketname/foldername <path on local machine download files to> --recursive
# --recursive =>copy all the files inside the folder on the bucket



# set execution policy inorder to execute scripts
Set-ExecutionPolicy RemoteSigned

#####################################################################################
# service installation script.will copy the algoritem from s3 bucket to ec2 instance
 & .\install_service.ps1
#####################################################################################

#####################################################################################
# running the script that will excute the algoritem on the samplesfrom s3 bucket inpput folder and return the service output to the s3 bucket
 & .\executer.ps1
#####################################################################################