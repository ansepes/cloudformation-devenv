#!/bin/bash
set -eux
# usage
cmdname=`basename $0`
function usage()
{
  echo "Usage: ${cmdname} operation api-resource-name lambda-func-name " 1>&2
  echo 'operation: "create" or "update" or "changeset"' 1>&2
  echo 's3-bucket-name: ' 1>&2
  echo 'lambda-func-name: ' 1>&2
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

if [ $# -ne 3 ]; then
  usage
  exit 1
fi

SCRIPT_FILE="cf.yml"
SCRIPT_DIR=$(cd $(dirname $(readlink $0 || echo $0));pwd)
CF_FILE_NAME="file://${SCRIPT_DIR}/${SCRIPT_FILE}"

API_RESOURCE_NAME=$2
CF_STACK_NAME="api-gw-create-${API_RESOURCE_NAME}2"
LAMBDA_FUNC_NAME=$3

aws cloudformation $CFN_SUB \
--stack-name ${CF_STACK_NAME} \
--template-body ${CF_FILE_NAME} \
--parameters \
ParameterKey=ResourceName,ParameterValue=${API_RESOURCE_NAME} \
ParameterKey=FunctionName,ParameterValue=${LAMBDA_FUNC_NAME} \
| jq .