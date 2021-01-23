# Swift SQLite on AWS Lambda

A description of this package.

docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    swift:5.3.1-amazonlinux2 \
   /bin/bash -c "yum -y install sqlite-devel && swift build --product AccountServiceAWS -c release -Xswiftc -static-stdlib" 

./scripts/package.sh AccountServiceAWS
