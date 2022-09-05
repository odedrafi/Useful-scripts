

msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi # install aws cli

# aws s3 cp s3://$env:BUCKET_NAME/$env:FOLDER_NAME $LOCAL_FOLDER_LOCATION --recursive