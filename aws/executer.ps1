# in this script we will set our location to the bin directory in it we will run our algorithm
# we will start the EXE process on the sample files located in the in progress folder
# after producing an output, we will copy it back to the s3 bucket
# at the end we will terminate the ec2 intance
# If the procces will faile the script will provide a log file and copy it back 
# with the faile sample to the bucket for  debuging and reuse

$Date_Array = Get-Date -Format "yyyy/MM/dd" # use to set the folder convention on the output directory in the bucket
# $ErrorActionPreference = 'stop'
$date = Get-Date -Format G
Write-Host "$date :executer_script has started." -ForegroundColor green

# define local path directories in variables
$date = Get-Date -Format G
Write-Host "$date :Creating local folders for algorithm installation, sample file & output." -ForegroundColor green
$Local_input_path = New-Item "C:\nucleix\input" -Itemtype directory -ErrorAction Continue
$Local_output_path = New-Item "C:\nucleix\output" -Itemtype directory -ErrorAction Continue
$Local_algo_bin_path = "C:\nucleix\bin" # no need to create directory it was created in the "install_algo_script.ps1"
$Local_in_Progres_path = New-Item "C:\nucleix\in_progres" -Itemtype directory -ErrorAction Continue
$Local_failed_path = New-Item "C:\nucleix\failed" -Itemtype directory -ErrorAction Continue

# copy the input samples
$date = Get-Date -Format G
Write-Host "$date :Copying sample file from bucket_input." -ForegroundColor green
Write-Output  "$date :Copying sample file from bucket_input." *>> C:\"$env:FILE_NAME"_logFile.txt
#uncomment for manual checks
# Copy-Item -Path "C:\input\$env:FILE_NAME" -Destination $Local_in_Progres_path 
aws s3 cp s3://$env:BUCKET_INPUT_NAME/$env:FILE_PATH $Local_in_Progres_path >> C:\"$env:FILE_NAME"_logFile.txt
# and delete the sample file from the bucket input folder
aws s3 rm s3://$env:BUCKET_INPUT_NAME/$env:FILE_PATH >> C:\"$env:FILE_NAME"_logFile.txt 

# setting location to the directory were the EXE process is lcated so we could run the process
$date = Get-Date -Format G
Write-Host "$date :Setting directory location inorder to run the algorithm." -ForegroundColor green
Write-Output  "$date :Setting directory location inorder to run the algorithm." *>> C:\"$env:FILE_NAME"_logFile.txt
Set-Location -Path $Local_algo_bin_path

$ErrorActionPreference = 'Continue'# let the algorithm run so the process won't stop and we could catch the algorithm exeption if exists
# run the algo with the sample file from $Local_in_Progres_path and put the output at $Local_output_path 
$date = Get-Date -Format G
Write-Host "$date :Executing the algorithm on the sample file" -ForegroundColor green
Write-Output  "$date :Executing the algorithm on the sample file." >> C:\"$env:FILE_NAME"_logFile.txt
& .\$env:EXE_NAME $Local_in_Progres_path\$env:FILE_NAME $Local_output_path $Local_output_path *>> C:\"$env:FILE_NAME"_logFile.txt

# check for invalid run of the algorithm
$Algo_failed_run=0 # invalid run flag
Set-Location -Path $Local_output_path
# loop over the algorithm output files to check for invalid run output
Get-ChildItem $Local_output_path |
ForEach-Object {
    If ( $_.Name -contains "Invalid Parse.txt"){
        cat "Invalid Parse.txt" >> C:\"$env:FILE_NAME"_logFile.txt
        $Algo_failed_run=1
    }
    If ( $_.Name -contains "Invalid Runs.txt"){
        cat "Invalid Runs.txt" >> C:\"$env:FILE_NAME"_logFile.txt
        $Algo_failed_run=1
    }
}
# add a line to describe that the script succeeded with algorithm failure 
if ( $Algo_failed_run -ne 0 ){


    Write-Host " $date : Script failed due to algorithm error" -ForegroundColor red
    Write-Output  " $date : Script failed due to algorithm error" >> C:\"$env:FILE_NAME"_logFile.txt
    # Copying the output of the algorithm to the output directory in the bucket.and the sample file
    # and delete the sample file from the bucket input folder
    aws s3 cp C:\"$env:FILE_NAME"_logFile.txt s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/failed/$Date_Array/"$env:FILE_NAME"_logFile.txt
    #copy sample file to failed run as well
    aws s3 cp $Local_in_Progres_path/$env:FILE_PATH s3://$Env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/failed/$Date_Array/$env:FILE_PATH

}
else{
# Copying the output of the algorithm and the sample file to the output directory in the bucket.
$date = Get-Date -Format G
Write-Host "$date :Copying the output of the algorithm to the output directory in the bucket." -ForegroundColor green
Write-Output  "$date :Copying the output of the algorithm to the output directory in the bucket." *>> C:\"$env:FILE_NAME"_logFile.txt
aws s3 cp $Local_output_path s3://$Env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/output/$Date_Array --recursive #*>> C:\"$env:FILE_NAME"_logFile.txt
aws s3 cp $Local_in_Progres_path/$env:FILE_PATH s3://$Env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/output/$Date_Array


# copy logFile after succes run before instance shutdown to the bucket
aws s3 cp  C:\"$env:FILE_NAME"_logFile.txt s3://$env:BUCKET_ALGO_NAME/$env:ALGORITHM_PATH/succeeded/$Date_Array/"$env:FILE_NAME"_logFile.txt

}



#shut down the ec2 instance
$date = Get-Date -Format G
Write-Output  "$date :shut down the ec2 instance" >> C:\"$env:FILE_NAME"_logFile.txt
$instanceid_url = "http://169.254.169.254/latest/meta-data/instance-id/"
$instanceidobject = Invoke-WebRequest $instanceid_url | Select-Object Content
$instanceid = $instanceidobject.content
aws ec2 terminate-instances --instance-ids $instanceid










