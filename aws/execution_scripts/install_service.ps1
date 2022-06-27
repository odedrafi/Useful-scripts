# recive PATH to local service folder from master script
param (
        [string]$PATH,
 )




# inorder to run the scripts inside a folder we must set the location to the folder
Set-Location -Path $PATH

# initialize parameters for the loop
$fileDirectory = $PATH

$parse_results = New-Object System.Collections.ArrayList;

# run the scripts in the service script folder
foreach($script in Get-ChildItem $fileDirectory){ 
    
    & .\$script
    
}