#!/bin/bash


SNAP_PATH=/home/user/Desktop/loadgen/snap
export SNAP_PATH

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

die () {
    echo >&2 "${red} $@ ${reset}"
    exit 1
}

dockerkill

#start containers
docker-compose up -d

#echo -n "waiting for influxdb and grafana to start"

# wait for influxdb to start up
while ! curl --silent -G "http://${dm_ip}:8086/query?u=admin&p=admin" --data-urlencode "q=SHOW DATABASES" 2>&1 > /dev/null ; do
  sleep 1
#  echo -n "."
done
#echo ""

#influxdb IP
influx_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' influxdbgrafana_influxdb_1)
#echo "influxdb ip: ${influx_ip}"

# create snap database in influxdb
curl -G "http://${dm_ip}:8086/ping"
#echo -n ">>deleting snap influx db (if it exists) => "
curl -G "http://${dm_ip}:8086/query?u=admin&p=admin" --data-urlencode "q=DROP DATABASE snap"
#echo ""
#echo -n "creating snap influx db => "
curl -G "http://${dm_ip}:8086/query?u=admin&p=admin" --data-urlencode "q=CREATE DATABASE snap"
#echo ""

# create influxdb datasource in grafana
echo -n "${green}adding influxdb datasource to grafana => ${reset}"
COOKIEJAR=$(mktemp)
curl -H 'Content-Type: application/json;charset=UTF-8' \
	--data-binary '{"user":"admin","email":"","password":"admin"}' \
    --cookie-jar "$COOKIEJAR" \
    "http://${dm_ip}:3000/login"

curl --cookie "$COOKIEJAR" \
	-X POST \
	--silent \
	-H 'Content-Type: application/json;charset=UTF-8' \
	--data-binary "{\"name\":\"influx\",\"type\":\"influxdb\",\"url\":\"http://${influx_ip}:8086\",\"access\":\"proxy\",\"isDefault\":\"true\",\"database\":\"snap\",\"user\":\"admin\",\"password\":\"admin\"}" \
	"http://${dm_ip}:3000/api/datasources"
echo ""

dashboard=$(cat $SNAP_PATH/influxdb-grafana/grafana/blank.json)
curl --cookie "$COOKIEJAR" \
	-X POST \
	--silent \
	-H 'Content-Type: application/json;charset=UTF-8' \
	--data "$dashboard" \
	"http://${dm_ip}:3000/api/dashboards/db"
echo ""

#echo "${green}getting and building snap-plugin-publisher-influxdb${reset}"
#go get github.com/intelsdi-x/snap-plugin-publisher-influxdb
# try and build; If the build first fails try again also getting deps else stop with an error
#(cd $SNAP_PATH/../../plugin/snap-plugin-publisher-influxdb && make all) || (cd $SNAP_PATH/../../plugin/snap-plugin-publisher-influxdb && make) || die "Error: failed to get and compile influxdb plugin"

#echo "${green}getting and building snap-plugin-collector-psutil${reset}"
#go get github.com/intelsdi-x/snap-plugin-collector-psutil
# try and build; If the build first fails try again also getting deps else stop with an error
#(cd $SNAP_PATH/../../snap-plugin-collector-psutil && make all) || (cd $SNAP_PATH/../../plugin/snap-plugin-collector-psutil && make) || die "Error: failed to get and compile psutil plugin"

echo Done.
