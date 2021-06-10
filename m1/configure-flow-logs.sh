# Create an S3 bucket

bucket_name=$(echo globo-logs-$RANDOM)

bucket=$(aws s3api create-bucket --bucket $bucket_name)

# Create a flow log for the VPC to S3

# Create a flow log for public subnets to S3

public_subnets=$(aws ec2 describe-subnets --filter Name="tag:Network",Values="Public" \
  Name="vpc-id",Values="$vpc_id" --query 'Subnets[].SubnetId' --output text)

aws ec2 create-flow-logs \
--resource-type Subnet \
--resource-ids $public_subnets \
--traffic-type ALL \
--log-destination-type s3 \
--log-destination "arn:aws:s3:::$bucket_name/flow_logs/" \
--max-aggregation-interval 60

for i in {1..100}
do
curl http://$web_url
done