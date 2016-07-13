#!/bin/bash

export KRB5CCNAME=krb5-$(uuidgen)
/usr/bin/kinit -k -t ${KEYTAB_LOCATION} ${KEYTAB_PRINC}
if [[ $? != 0 ]]; then
  echo "Failed to obtain Kerberos ticket" >&2
  exit 2
fi
echo "Successfully obtained Kerberos ticket"

unset HADOOP_TOKEN_FILE_LOCATION

/usr/bin/hadoop --config yarn-conf jar distcp-5.7.0.jar -libjars distcp_acllib-5.7.0.jar -sourceconf source-conf ${FROM_LOC} ${TO_LOC}

/usr/bin/kdestroy
rm -rf ${KRB5CCNAME}
