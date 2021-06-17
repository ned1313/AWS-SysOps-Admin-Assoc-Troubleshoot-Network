# Recommend using us-east-1 by default
region=us-east-1

export AWS_DEFAULT_REGION=$region

# Create the CloudFormation stack for the secondary VPC and peering
aws ec2 create-key-pair --key-name Peering --query 'KeyMaterial' --output text > Peering.pem

account_id=$(aws ec2 describe-vpcs --filters Name="tag:Name",Values="globo-primary" \
  --query 'Vpcs[0].OwnerId' --output text)

vpc1_id=$(aws ec2 describe-vpcs --filters Name="tag:Name",Values="globo-primary" \
  --query 'Vpcs[0].VpcId' --output text)

ami_id=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
  --region $region | jq .Parameters[].Value -r)

aws cloudformation create-stack --stack-name Globomantics2 \
  --template-body file://basic-network-2.json \
  --parameters ParameterKey=PeerName,ParameterValue="globo-peering" \
  ParameterKey=PeerOwnerId,ParameterValue="$account_id" \
  ParameterKey=PeerVPCID,ParameterValue="$vpc1_id" \
  ParameterKey=PeerVPCCIDR,ParameterValue="10.0.0.0/16" \
  ParameterKey=ImageId,ParameterValue="$ami_id"

# Get the public IP for SSH
public_ip_address=$(aws ec2 describe-instances --filters Name="tag:Name",Values="vpc2-peering" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# Get the private IP for the web instance
aws ec2 describe-instances --filters Name="tag:Name",Values="web-1" \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text

# Copy your ssh key and update permissions
cp Peering.pem ~/.ssh/
chmod 600 ~/.ssh/Peering.pem

# Connect to the vpc2-peering instance
ssh ec2-user@$public_ip_address -i ~/.ssh/Peering.pem

# Try to curl to the private IP address of web-1

# Use the reachability analyzer in the Console to troubleshoot the issue