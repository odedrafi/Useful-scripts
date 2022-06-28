# in this script we will set our location to the bin directory in it we will run our algorithm
# we will start the EXE process on the sample files located in the input folder
# after producing an output, we will copy it back to the s3 bucket
# at the end we will terminate the ec2 intance

# define local path directories in variables
$Local_output_path = "C:\nucleix\output"
$Local_input_path = "C:\nucleix\input"
$Local_algo_bin_path = "C:\nucleix\bin"

# copy the input samples for test run
aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/input $Local_input_path --recursive

# setting location to the directory were the EXE process is lcated so we could run the process
Set-Location -Path $Local_algo_bin_path

# looping over the samples in the local input folder
foreach ($SampleFile in Get-ChildItem $Local_input_patht) { 
    
    .\Nucleix.BladderEpicheck.V1_9_51.exe $Local_input_path\$SampleFile $env:ALGORITHM_NAME $Local_output_path
    
}


#wait for algo output, and copy it back to s3 bucket
aws s3 cp C:\nucleix\output s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/output


# #shut down the ec2 instance
# aws terminate-instances --instance-id $Instance_id