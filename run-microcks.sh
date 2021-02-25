#!/bin/bash

mkdir -p keystore || exit 1

echo "Generating local keys, certs and keystore into ./keystore folder ..."
echo

podman run -v $PWD/keystore:/certs:z -e JKS_PASSWORD=server -e SERVER_HOSTNAMES="microcks.dns.podman microcks-keycloak.dns.podman" -t docker.io/nmasse/mkcert:0.1

echo
echo "Renaming stuffs to match Microcks and Keycloak constraints ..."
echo

mv keystore/server.crt keystore/tls.crt
mv keystore/server.key keystore/tls.key
mv keystore/server.p12 keystore/microcks.p12
cp keystore/server.jks keystore/https-keystore.jks

mkdir -p microcks-data || exit 1
chmod -R ugo+rX config || exit 1

echo
echo "Starting Microcks using podman-compose ..."
echo "------------------------------------------"
echo "Stop it with: sudo podman-compose -f microcks.yml --transform_policy=identity stop"
echo "Re-launch it with: sudo podman-compose -f microcks.yml --transform_policy=identity start"
echo "Clean everything with: sudo podman-compose -f microcks.yml --transform_policy=identity down"
echo "------------------------------------------"
echo "Go to https://microcks.dns.podman - first login with admin/123"
echo "Having issues? Check you have changed microcks.yml to your platform"
echo

podman-compose -f microcks.yml --transform_policy=identity up -d
