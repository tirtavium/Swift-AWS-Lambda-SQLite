# Swift AWS Lambda with SQLite
This project is swift sample for AWS Lambda connect with sqlite DB.

#### Related Article

see [Swift-AWS-SQLite](https://tirtavium.medium.com/swift-aws-lambda-sqlite-ae471f08b31f)

# How to run the project

  - Clone this project and run it on Xcode 12
  - Verify with curl
  ```sh
$ curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"id": 1}' \
  http://localhost:7000/invoke
```
it will response with
  ```sh
{
   "account":{
      "ID":1,
      "dateOfBirth":"10-12-1991",
      "Name":"Hanif",
      "email":"hanif@gmail.com"
   },
   "message":"success"
}
```

# How to compile for AWS
  - Upload accountData.db into your S3
 ```sh
 Sources/AccountServiceAWS/DB/accountData.db
 ```
 - Change S3 bucket name and AWS Client on SharedResource.swift with your S3 account key 
  ```sh
static public let s3BucketName = "your bucket name"

static public let awsClient = AWSClient(
credentialProvider: .static(accessKeyId: "xxxx", secretAccessKey: "xxxxx"),
httpClientProvider: .createNew)
 ```

  - Go to project directory on terminal
  - Run docker command
 ```sh
$ docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    swift:5.3.1-amazonlinux2 \
   /bin/bash -c "yum -y install sqlite-devel && swift build --product AccountServiceAWS -c release -Xswiftc -static-stdlib" 
```
  - Run the script for creating lambda.zip
   ```sh
$ ./scripts/package.sh AccountServiceAWS
```
- Result will be available on :
```sh
.build/lambda/AccountServiceAWS/lambda.zip
```
 
 - Upload your lambda.zip to S3 bucket
 - when on Lambda use that S3 link to compile the function.
 




