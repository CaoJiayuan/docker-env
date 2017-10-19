
if [ "${UPLOAD_SIZE}" == "" ]; then
   export UPLOAD_SIZE="8M"
fi

echo "max file size ${UPLOAD_SIZE}"

envsubst '$UPLOAD_SIZE' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf

nginx -g 'daemon off;'