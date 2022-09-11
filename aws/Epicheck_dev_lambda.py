import boto3
import json
import os


AMI = os.environ['AMI'] # the image of the instanace
INSTANCE_TYPE = os.environ['INSTANCE_TYPE'] # the size of the instanace 
KEY_NAME = os.environ['KEY_NAME'] # the pem key for the instance 
REGION = os.environ['REGION']
SG = os.environ['SG'] 
SUBNET = os.environ['SUBNET']
IAM_ROLE_NAME=os.environ['IAM_ROLE_NAME'] # the name of the s3 full accesss role to associate to the ec2

ec2 = boto3.client('ec2', region_name=REGION)
iam_client = boto3.client('iam')

def handler(event, context):
    
     #get s3  data 
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    file_name=key[key.rfind("/")+1:]
    algorithm_name=key.split("/")
    
    if algorithm_name[2] == "input":

        # function to get role Name and ARN
        def get_instance_profile(instance_profile_name):
            response = iam_client.get_instance_profile(
            InstanceProfileName=instance_profile_name
        )
            return response['InstanceProfile']

        instance_profile = get_instance_profile(IAM_ROLE_NAME) 
        
        instance = ec2.run_instances(
            UserData=f"""<powershell>
    $env:BUCKET_ALGO_NAME="{bucket_name}"
    $env:BUCKET_INPUT_NAME="{bucket_name}"
    $env:FILE_NAME="{file_name}"
    $env:ALGORITHM_NAME="{algorithm_name[1]}"
    $env:ALGORITHM_PATH="algorithm/{algorithm_name[1]}"
    $env:FILE_PATH="{key}"
    $env:EXE_NAME="{algorithm_name[1]}.exe"
    $script_path = "C:\\test_scripts"
    aws s3 cp s3://{bucket_name}/installation_scripts $script_path --recursive
    Set-Location $script_path
    $ErrorActionPreference = 'stop'
    .\master_script.ps1
    </powershell> """,
            ImageId=AMI,
            InstanceType=INSTANCE_TYPE,
            KeyName=KEY_NAME,
            MaxCount=1,
            MinCount=1,
            IamInstanceProfile={ 
            'Arn': instance_profile['Arn'],
        }, 
            NetworkInterfaces=[
        {
            'DeviceIndex': 0,
            'SubnetId' : SUBNET,
            'Groups': [
                SG,
            ],
            'AssociatePublicIpAddress': True            
        }],
            TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [
                    {
                        'Key': 'Name',
                        'Value':  algorithm_name[1]+"_"+file_name,
                    },
                ],
            },
        ],)
        
        print ("New instance created:")
        instance_id = instance['Instances'][0]['InstanceId']
        
        print (instance_id)
        
    elif algorithm_name[1] == "input":
 
        prefix="algorithm/"
        copy_location="input/" + file_name

        
        s3_client = boto3.resource('s3')
        bucket=bucket_name
        source = {
        'Bucket': bucket,
        'Key': key
        }
        
        # get the names of all algorithms  
        client = boto3.client('s3')
        result = client.list_objects(Bucket=bucket_name, Prefix=prefix, Delimiter='/')
            
        # copy input file to all alogrithm folder 
        for input_file in result.get('CommonPrefixes'):
            print('sub folder : ', input_file.get('Prefix'))
            if input_file.get('Prefix') != "algorithm/input/":
              s3_client.meta.client.copy(source,bucket_name, input_file.get('Prefix') + copy_location)
        # renmove the fie from input folder 
        s3_client.Object(bucket_name,key).delete()


        