
param (
        [string]$PATH,
 )




#inorder to run the scripts inside a folder we must set the location to the folder
Set-Location -Path $PATH

#initialize parameters for the loop
$fileDirectory = $PATH

$parse_results = New-Object System.Collections.ArrayList;

#running on all the files in the directory in question with the operator "&"
foreach($script in Get-ChildItem $fileDirectory){ & .\$script}