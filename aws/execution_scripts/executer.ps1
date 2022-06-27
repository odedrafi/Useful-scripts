# this script will copy the file from input folder to service local input folder
# wait until processing is completed
# copy the file back to s3, shutdown the ec2.
# aws s3 cp => recives two parameters first is the path to copy from then the path to copy to



Set-Location -Path C:\nucleix\bin

foreach($file in Get-ChildItem "C:\nucleix\input"){ 
    
.\Nucleix.BladderEpicheck.V1_9_51.exe C:\nucleix\input\$file $env:ALGORITHM_NAME C:\nucleix\output
    
}

C:\Nucleix\bladder-epicheck-1.9.51\bin> Nucleix.BladderEpiCheck.V1_9_51.exe

#wait for service output(files in local service output folder) and copy it back to s3 bucket
aws s3 cp C:\nucleix\output $Bucket_Data_Output_Path


#shut down the ec2 instance
aws terminate-instances --instance-id $Instance_id