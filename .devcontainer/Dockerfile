FROM amazonlinux:2

RUN yum install -y tar gzip jq; \
    curl -o "/tmp/get-pip.py" -LO "https://bootstrap.pypa.io/get-pip.py";  \
    python /tmp/get-pip.py; \
    pip install awscli;