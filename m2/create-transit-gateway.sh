# Make sure to run the create-peering steps first
# You're going to need the EC2 key and AMI ID

# Deploy our transit gateway setup

aws cloudformation create-stack --stack-name TransitGateway \
  --template-body file://transit-gateway.json \
  --parameters ParameterKey=ImageId,ParameterValue="$ami_id" \
  ParameterKey=KeyName,ParameterValue="Peering"

# Get the public IP address of one of the mgmt instance

 public_ip_address=$(aws ec2 describe-instances --filters Name="tag:Name",Values="mgmt-transit-test" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# Get the private IP address of the App1 instance
aws ec2 describe-instances --filters Name="tag:Name",Values="app1-transit-test" \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text

# Connect via SSH

ssh ec2-user@$public_ip_address -i ~/.ssh/Peering.pem

# Now try to connect to the app server using SSH
