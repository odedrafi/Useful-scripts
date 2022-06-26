# parameters will be updated in the machine env through the lambda function 
# and the creation of the machine in the start of the process
# these tow variables will build the yrl the command needs to copy the bucket folder

# BUCKET_NAME=>the name of the bucket containing the service and scripts to run
# 
# SERVICE_NAME=> the service name we want to download and install it wi represent also the name of the folder
# aws cp s3://bucketname/foldername <path on local machine download files to> --recursive
# --recursive =>copy all the files inside the folder on the bucket



# set execution policy inorder to exexute scripts
Set-ExecutionPolicy RemoteSigned

#copy folder from s3 bucket the parameters of bucket name and service folder name will be updated by user parameters
aws s3 cp s3://$Env:BUCKET_NAME/$Env:SERVICE_NAME C:\Users\Administrator\Desktop\$Env:SERVICE_NAME --recursive

#####################################################################################
#inorder to run the scripts inside a folder we must set the location to the folder
Set-Location -Path "C:\Users\Administrator\Desktop\$Env:SERVICE_NAME\scripts\input"

#initialize parameters for the loop
$fileDirectory = "C:\Users\Administrator\Desktop\$Env:SERVICE_NAME\scripts\input"

$parse_results = New-Object System.Collections.ArrayList;

#running on all the files in the directory in question with the operator "&"
foreach($file in Get-ChildItem $fileDirectory){ & .\$file}
#####################################################################################