# this script will copy the file from input folder to service local input folder
# wait until processing is completed
# copy the file back to s3, shutdown the ec2.
# aws s3 cp => recives two parameters first is the path to copy from then the path to copy to



param (
        [string]$Bucket_Path,
        [string]$Local_input_Path,
 )


#copy files to local service input folder from the s3 bucket input folder that they are located in
aws s3 cp $Bucket_Path $Local_input_Path

#wait for service output(files in local service output folder) and copy it back to s3 bucket
aws s3 cp $Local_input_Path s3://$Env:BUCKET_NAME/$Env:SERVICE_NAME


#shut down the ec2 instance
aws terminate-instances --instance-id $Instance_id