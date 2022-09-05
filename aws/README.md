<img src="" width="130" height="100"/>

---

![This is an image]()

---

# Description

In this work we build a workflow that icludes the following technologies in AWS.

- s3 bucket - 
- SNS - 
- LAMBDA - 
- Ec2 instanc - aws virtual machine



---

## Notes

Our workflow will begain when a file is uploaded to a s3 bucket.
that upload will use the SNS inordeer to trigger the Lambda function.
The Lambda fuction will be used to deploy a vm (ec2 instance). 
the instance will then on startup (with the use of user data in the lambda function) copy installation scripts, and an algorithm , all the paramaters needed for the connectivity between the aws services are transfered by the SNS to the lamda function and then to the instance.
then the instance will download the file that triggered the procces and run it through the algorithm to produce an output. 
send the output back to s3 bucket and then shut down.
in the future this process will be templated in CDK for automation.



---

### Work Flow Goal

![Enviroment goals picture]()

