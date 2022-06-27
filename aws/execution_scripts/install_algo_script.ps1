# script that installs an algorithm by copying the bin and program date to our local machine
# we do this by bucket name and algorithm name as env variables defined when the ec2 instance is build at the start of the workflow
# detailed in the main script

# define local path directories in variables
$Local_output_path = "C:\nucleix\output"
$Local_input_path = "C:\nucleix\input"
$Local_algo_bin_path = "C:\nucleix\bin"
$Local_progdata_path = "C:\ProgramData\nucleix"


#copy the algoritem bin folder from s3 algo bucket to ec2 instance(installation of algorithm)

aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/bin $Local_algo_bin_path --recursive

# copy the input samples for test run
aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/input C:\nucleix\input --recursive


#copy the algoritem program-data folder from s3 algo bucket to ec2 instance(installation of algorithm)
aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/program-data $Local_progdata_path --recursive

