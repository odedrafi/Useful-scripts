# this script will copy the file from input folder to service local input folder
# wait until processing is completed
# copy the file back to s3, shutdown the ec2.
# aws s3 cp => recives two parameters first is the path to copy from then the path to copy to



param (
        [string]$Bucket_Data_Output_Path,
        [string]$Bucket_Data_Input_Path,
        [string]$Local_input_Path,
        [string]$local_output_path,
 )

.\Nucleix.BladderEpicheck.V1_9_51.exe $file_name $algo_name $local_output_path
.\Nucleix.Nsa.V1_1_25.exe $file_name $algo_name $local_output_path


#wait for service output(files in local service output folder) and copy it back to s3 bucket
aws s3 cp $local_output_path $Bucket_Data_Output_Path


#shut down the ec2 instance
aws terminate-instances --instance-id $Instance_id