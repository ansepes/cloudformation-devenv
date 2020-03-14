#!/bin/bash
set -eux
# usage
cmdname=`basename $0`
function usage()
{
  echo "Usage: ${cmdname} operation s3-bucket-name " 1>&2
  echo 'operation: "create" or "update" or "changeset"' 1>&2
  echo 's3-bucket-name: ' 1>&2
  return 0
}

# check options
case $1 in
  'create')
    CFN_SUB=create-stack;;
  'update')
    CFN_SUB=update-stack;;
  'changeset')
    CFN_SUB=create-change-set;; # より慎重にするにはこちら。
  * )
    usage
    exit 1;;
esac

if [ $# -ne 2 ]; then
  usage
  exit 1
fi

SCRIPT_FILE="cf-template.yml"
SCRIPT_DIR=$(cd $(dirname $(readlink $0 || echo $0));pwd)
CF_FILE_NAME="file://${SCRIPT_DIR}/${SCRIPT_FILE}"

S3_BUCKET_NAME=$2
CF_STACK_NAME="s3-buckect-create-${S3_BUCKET_NAME}"


aws cloudformation $CFN_SUB \
--stack-name ${CF_STACK_NAME} \
--template-body ${CF_FILE_NAME} \
--parameters \
ParameterKey=S3BucketName,ParameterValue=${S3_BUCKET_NAME} \
| jq .