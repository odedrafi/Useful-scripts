
# create vpc (virtual network)=>this command will output the vpc name
# flags:
# --cidr-block as your choise 
aws ec2 create-vpc \
--cidr-block 10.0.0.0/16 \
--query Vpc.VpcId \
--output text

# create subnet
# flags:
# --cidr-block as your choise 
# --vpc-id use the output from last action
aws ec2 create-subnet \
--vpc-id vpc-2f09a348 \
--cidr-block 10.0.1.0/24

# create key to connect like for ssh
aws ec2 create-key-pair \
--key-name NewKeyPair \
--query 'KeyMaterial' \
--output text > NewKeyPair.pem
# makre the key file executable
chmod 400 NewKeyPair.pem


# a command to create the ec2 instance(virtual machine) 
# flags:
# --image-id => choose the image id you want to run on your ec2 instance
# --instance-type => size and power of the ec2
# --security-group-ids => the security group id that will hold the ec2 
# --subnet-id subnet => subnet id
aws ec2 run-instances \
--image-id ami-xxxxxxxx \
--count 1 \
--instance-type t2.micro \
--key-name MyKeyPair \
--security-group-ids sg-903004f8 \
--subnet-id subnet-6e7f829e



#deletion in this order
aws ec2 delete-security-group --group-id sg-XXXXXXXX
aws ec2 delete-subnet --subnet-id subnet-XXXXXXXXXXX
aws ec2 delete-route-table --route-table-id rtb-XXXXXXXXXXXX
aws ec2 detach-internet-gateway --internet-gateway-id igw-XXXXXXXX --vpc-id vpc-XXXXXXXX
aws ec2 delete-internet-gateway --internet-gateway-id igw-XXXXXXXXXX
aws ec2 delete-vpc --vpc-id vpc-XXXXXXXXXXXXX
