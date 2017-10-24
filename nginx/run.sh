
if [ "${UPLOAD_SIZE}" == "" ]; then
   export UPLOAD_SIZE="8M"
fi

if [ "${BODY_BUFFER_SIZE}" == "" ]; then
   export BODY_BUFFER_SIZE="128K"
fi

if [ -f "${CONFIG_FILE}" ]; then
    cp ${CONFIG_FILE} /etc/nginx/default.conf
fi

echo "max file size ${UPLOAD_SIZE}"
echo "max body buffer size ${BODY_BUFFER_SIZE}"

envsubst '$UPLOAD_SIZE,$BODY_BUFFER_SIZE' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf

nginx -g 'daemon off;'