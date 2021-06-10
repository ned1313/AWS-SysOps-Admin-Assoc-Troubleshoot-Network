# Have AWS CLI already install
# Have Access Key and Secret Key ready
# Recommend using us-east-1 by default
aws configure

region=us-east-1

export AWS_DEFAULT_REGION=$region

# Create the CloudFormation stack for the basic VPC
aws cloudformation create-stack --stack-name Globomantics --template-body file://basic-network.json

# Once the VPC is in place, we'll stand up an EC2 instance

# Get the subnets for the web instance
vpc_id=$(aws ec2 describe-vpcs --filters Name="tag:Name",Values="globo-primary" \
  --query 'Vpcs[0].VpcId' --output text)

subnet1_id=$(aws ec2 describe-subnets --filter Name="tag:Name",Values="subnet-1" \
  Name="vpc-id",Values="$vpc_id" --query 'Subnets[0].SubnetId' --output text)

# Create a key-pair for your instance

aws ec2 create-key-pair --key-name Trouble --query 'KeyMaterial' --output text > Trouble.pem

# Create a security group for your web instance

aws ec2 create-security-group --description "default-sg-for-Trouble" \
  --group-name "Trouble" --vpc-id $vpc_id

sg_id=$(aws ec2 describe-security-groups --filter Name="group-name",Values="Trouble" \
  --query 'SecurityGroups[0].GroupId' --output text)

# Get the latest Amazon Linux 2 AMI 

ami_id=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
  --region $region | jq .Parameters[].Value -r)

# Spin up the web-1 instance

aws ec2 run-instances --image-id $ami_id --count 1 \
  --instance-type t2.micro --key-name Trouble \
  --security-group-ids $sg_id --subnet-id $subnet1_id \
  --user-data file://install-web-server.txt \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=web-1},{Key=Company,Value=Globomantics}]' \
  'ResourceType=volume,Tags=[{Key=Name,Value=web-1},{Key=Company,Value=Globomantics}]'

web_url=$(aws ec2 describe-instances --filters Name="tag:Name",Values="web-1" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)

curl http://$web_url

dig $web_url

aws ec2 describe-instances --filters Name="tag:Name",Values="web-1" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
