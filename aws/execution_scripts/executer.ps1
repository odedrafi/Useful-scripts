# this script will copy the file from input folder to service local input folder
# wait until processing is completed
# copy the file back to s3, shutdown the ec2.



#copy files from local output folder back to input folder on s3 bucket
aws s3 cp C:\Users\Administrator\Desktop\$Env:SERVICE_NAME\output "service local input folder"

#wait for service output and copy it back to s3 instance
aws s3 cp "service local output folder" s3://$Env:BUCKET_NAME/$Env:SERVICE_NAME


#shut down the ec2 instance
aws stop-instances --instance-id "i-XXXXXXX"