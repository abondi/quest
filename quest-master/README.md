## Generate AWS Credentials
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 340102753460.dkr.ecr.us-east-2.amazonaws.com

## Build Docker Image
docker build -t quest .

## Tag Docker Image
docker tag quest:latest 340102753460.dkr.ecr.us-east-2.amazonaws.com/quest:latest

## Push Docker Image
docker push 340102753460.dkr.ecr.us-east-2.amazonaws.com/quest:latest
