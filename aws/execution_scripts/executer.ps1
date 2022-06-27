# in this script we will set our location to the bin directory in it we will run our algorithm
# we will start the EXE process on the samples located in the input folder
# after we will recise the output of the algorithm run we will copy it to the s3 bucket were the output will be stored
# in the end we will terminate the ec2 intance to save cost.



# setting location to the directory were the EXE process is lcated
Set-Location -Path C:\nucleix\bin

# looping over the samples in the local input folder
foreach($SampleFile in Get-ChildItem "C:\nucleix\input"){ 
    
.\Nucleix.BladderEpicheck.V1_9_51.exe C:\nucleix\input\$SampleFile $env:ALGORITHM_NAME C:\nucleix\output
    
}


# #wait for service output(files in local service output folder) and copy it back to s3 bucket
# aws s3 cp C:\nucleix\output $Bucket_Data_Output_Path


# #shut down the ec2 instance
# aws terminate-instances --instance-id $Instance_id