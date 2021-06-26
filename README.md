# AWS-SysOps-Admin-Assoc-Troubleshoot-Network

Welcome to AWS SysOps Admin Associate: Troubleshoot Network Connectivity. I'll admit that's an unwieldy title. These exercise files are meant to accompany my course on Pluralsight.

## Using the Files

Each folder represents a module from the course. You will need a VPC for some of the exercises, and I don't want you to use your default VPC. It's better to have a throwaway VPC that you can experiment with, and I **do** encourage you to experiment beyond the commands laid out in the course. The first thing you'll do is go into the `m1` folder and run the CloudFormation template found within to create your VPC. I used `us-east-1` as my default region. The exercises should work for other regions, just remember the difference in DNS naming and AMI IDs used by instances. The SSM command to retrieve a valid AMI ID for your region of choice *should* work, but I haven't tested all regions.

## Pre-requisites

You will want to have the AWS CLI v2.x installed on your system. The commands are all assuming a Linux command line (sorry PowerShell users), so my recommendation is to install WSLv2 if you're running Windows. Personally, I run WSLv2 with an Ubuntu 18.04 instance. There is a practical element on the exam and my assumption is that any CLI tasks will use a similar environment. You'll also need an AWS account and credentials loaded into the CLI configuration. If you'd prefer, you can also use the AWS CloudShell to run commands instead, but you'll have to copy the JSON files or clone this repository to the CloudShell environment.

I also recommend that you create a dedicated AWS account for taking this course. You don't want to accidently mess with your production environment at work! It will also make it easier to delete everything when you're done and track any costs. Maybe your employer will reimburse you! Speaking of cost...

## MONEY!!!

During the examples, you are going to spin up some EC2 instances and use other services which cost some amount of money in AWS. Wherever possible I have chosen to use free-tier sizes and resources. That being said, when you are finished with the course, you should delete all the created CloudFormation stacks and any lingering EC2 instances.

## Troubleshooting

This is a course about troubleshooting network connectivity in AWS. While I give some examples in the course, there are a **lot** of things that can go wrong in an AWS networking environment. I recommend messing around with the environments created by the CloudFormation stacks. Try to break things, and then try to fix them. The best way to understand how networking functions in AWS is to try and fix it when something goes wrong. 

I also encourage you to try and troubleshoot the example deployments before watching the portion of the module where I fix it. Do some sleuthing on your own!

## Conclusion

I hope you enjoy taking this course and that it helps you pass the new version of the AWS SA-Associate exam! Pass or fail, let me know how you did and if the course helped. You can always find me on Twitter ([ned1313](https://twitter.com/Ned1313)) or on [LinkedIn](https://www.linkedin.com/in/ned-bellavance/).

Thanks and good luck!

Ned

