# Set some basics

region=us-east-1

export AWS_DEFAULT_REGION=$region

# AMI for new web instances

ami_id=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
  --region $region | jq .Parameters[].Value -r)

# Deploy the CF template

aws cloudformation create-stack --stack-name ALBDeploy \
  --template-body file://alb-deployment.yaml \
  --parameters ParameterKey=ImageId,ParameterValue="$ami_id" \
  ParameterKey=SSHKeyName,ParameterValue="Trouble"
