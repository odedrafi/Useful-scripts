# in this script we will set our location to the bin directory in it we will run our algorithm
# we will start the EXE process on the sample files located in the input folder
# after producing an output, we will copy it back to the s3 bucket
# at the end we will terminate the ec2 intance
Write-Host "executer_script has started." -ForegroundColor green
Set-ExecutionPolicy RemoteSigned -Force
$ErrorActionPreference = 'stop'

Write-Host "Creating local folders for algorithm installation, sample file & output." -ForegroundColor green

$Local_input_path = New-Item "C:\nucleix\input" -Itemtype directory
$Local_output_path = New-Item "C:\nucleix\output" -Itemtype directory
$Local_algo_bin_path = "C:\nucleix\bin"
$Local_in_Progres_path = New-Item "C:\nucleix\in_progres" -Itemtype directory
$Local_failed_path = New-Item "C:\nucleix\failed" -Itemtype directory

Write-Host "Copying sample file from bucket_input." -ForegroundColor green
# copy the input samples for test run
aws s3 cp s3://$env:BUCKET_INPUT_NAME/$env:FILE_PATH $Local_input_path 

Write-Host "Setting directory location inorder to run the algorithm." -ForegroundColor green
# setting location to the directory were the EXE process is lcated so we could run the process
Set-Location -Path $Local_algo_bin_path

Write-Host "Executing the algorithm on the sample file" -ForegroundColor green
# run the algo with the sample file from $Local_input_path and put the output at $Local_output_path 
.\Nucleix.BladderEpicheck.V1_9_51.exe $Local_input_path\$env:FILE_NAME $env:ALGORITHM_NAME $Local_in_Progres_path

Write-Host "Copying output from in progres to output after algorithm succesful run." -ForegroundColor green
Copy-Item -Path $Local_in_Progres_path/$env:ALGORITHM_NAME -Destination $Local_output_path -recurse -Force

Write-Host "Copying the output of the algorithm to the output directory in the bucket." -ForegroundColor green
#wait for algo output, and copy it back to s3 bucket
aws s3 cp $Local_output_path s3://$env:BUCKET_INPUT_NAME/output --recursive

# #shut down the ec2 instance
# aws terminate-instances --instance-id $Instance_id



