#!/bin/bash
set -eux
# usage
cmdname=`basename $0`
function usage()
{
  echo "Usage: ${cmdname} operation env lambda-func-name " 1>&2
  echo 'operation: "create" or "update" or "changeset"' 1>&2
  echo 'env: "dev" or "stg" or "prod"' 1>&2
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

LAMBDA_FUNC_NAME="$2-$3"
CF_STACK_NAME="lambda-func-create-${LAMBDA_FUNC_NAME}"

aws cloudformation $CFN_SUB \
--stack-name ${CF_STACK_NAME} \
--template-body ${CF_FILE_NAME} \
--parameters \
ParameterKey=LambdaName,ParameterValue=${LAMBDA_FUNC_NAME} \
| jq .