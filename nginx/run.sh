
if [ "${UPLOAD_SIZE}" == "" ]; then
   export UPLOAD_SIZE="8M"
fi

envsubst "$UPLOAD_SIZE" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

cat /etc/nginx/nginx.conf

nginx -g 'daemon off;'