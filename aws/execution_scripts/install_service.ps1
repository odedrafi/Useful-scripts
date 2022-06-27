
#copy the algoritem bin folder from s3 algo bucket to ec2 instance(installation of algorithm)

aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/bin C:\nucleix\bin --recursive

# copy the input samples for test run
aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/input C:\nucleix\input --recursive


#copy the algoritem program-data folder from s3 algo bucket to ec2 instance(installation of algorithm)
aws s3 cp s3://$env:BUCKET_NAME/$env:ALGORITHM_NAME/program-data C:\ProgramData\nucleix --recursive
