# recive PATH to local service folder from master script
param (
        [string]$Bucket_Data_Output_Path,
        [string]$Bucket_Data_Input_Path,
        [string]$Local_input_Path,
 )




#copy files to local service input folder from the s3 data bucket input folder that they are located in
aws s3 cp $Bucket_algo_bin_path $Local_bin_path
aws s3 cp $Bucket_program_data_Path $Local_program_data_Path





# # inorder to run the scripts inside a folder we must set the location to the folder
# Set-Location -Path $PATH

# # initialize parameters for the loop
# $fileDirectory = $PATH

# $parse_results = New-Object System.Collections.ArrayList;

# # run the scripts in the service script folder
# foreach($script in Get-ChildItem $fileDirectory){ 
    
#     & .\$script
    
# }