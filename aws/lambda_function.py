import boto3
import json
import re
import os
import time


AMI = os.environ['AMI'] # the image of the instanace
INSTANCE_TYPE = os.environ['INSTANCE_TYPE'] # the size of the instanace 
KEY_NAME = os.environ['KEY_NAME'] # the pem key for the instance 
REGION = os.environ['REGION']
NSG = os.environ['NSG'] 
SUBNET = os.environ['SUBNET']

ec2 = boto3.client('ec2', region_name=REGION)

def lambda_handler(event, context):
    
    #get sns data 
    message = json.loads(event['Records'][0]['Sns']['Message'])
    bucket_name = message['Records'][0]['s3']['bucket']['name']
    key = message['Records'][0]['s3']['object']['key']
    file_name=key[key.rfind("/")+1:]
    algorithm_name=key.split("/")

    instance = ec2.run_instances(
        UserData=f"""<powershell>
        
$env:BUCKET_ALGO_NAME="{bucket_name}"
$env:BUCKET_INPUT_NAME="{bucket_name}"
$env:FILE_NAME="{file_name}"
$env:ALGORITHM_NAME="{algorithm_name[1]}"
$env:ALGORITHM_PATH="algorithm/{algorithm_name[1]}"
$env:FILE_PATH="{key}"

$script_path = "C:\\test_scripts"
aws s3 cp s3://project-230622/Installation_scripts $script_path --recursive

Set-Location $script_path
.\master_script.ps1

</powershell> """,
        ImageId=AMI,
        InstanceType=INSTANCE_TYPE,
        KeyName=KEY_NAME,
        MaxCount=1,
        MinCount=1,
        NetworkInterfaces=[
    {
        'DeviceIndex': 0,
        'SubnetId' : SUBNET,
        'Groups': [
            NSG,
        ],
        'AssociatePublicIpAddress': True            
    }],
        TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [
                {
                    'Key': 'Name',
                    'Value': file_name,
                },
            ],
        },
    ],)
    
    print ("New instance created:")
    instance_id = instance['Instances'][0]['InstanceId']
    
    time.sleep(10) # wait 5 seconds until the instace is in running state then attach s3 role 
    # attach S3 FullAccess role to ec2 instance
    response = ec2.associate_iam_instance_profile(
    IamInstanceProfile={
        'Arn': 'arn:aws:iam::138182066483:instance-profile/AllowS3FullAccess',
        'Name': 'AllowS3FullAccess'
    },
    InstanceId=instance_id
)
  
    print (instance_id)
    print(algorithm_name)
    print(instance['Instances'][0]['State']['Name'])
    return instance_id