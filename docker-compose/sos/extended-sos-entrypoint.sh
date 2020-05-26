#!/bin/sh

set -e

# set the URL of the API in the Helgoland settings
if [ -n "${EXTERNAL_URL}" ]; then
  TEMP="$(mktemp)"
  jq --arg value "${EXTERNAL_URL}" \
      '(.datasetApis[] | select(.name = "localhost")).url |= $value' \
      < ${HELGOLAND_CONFIG} \
      > ${TEMP}
  mv -f "${TEMP}" "${HELGOLAND_CONFIG}"
fi


# change the context path if required
if [ -n "${SOS_CONTEXT_PATH}" -a ${SOS_CONTEXT_PATH} != "/" ]; then
  envsubst '${SOS_CONTEXT_PATH}' \
    < "${WEBAPP}/WEB-INF/jetty-web.xml.template" \
    > "${WEBAPP}/WEB-INF/jetty-web.xml"
fi

exec "$@"