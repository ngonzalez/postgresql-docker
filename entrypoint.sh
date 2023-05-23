#!/usr/bin/env bash
set -e

function start_postgresql {
	/usr/lib/postgresql/$POSTGRESQL_VERSION/bin/postgres "-p" $POSTGRESQL_PORT "-D" "/var/lib/postgresql/$POSTGRESQL_VERSION/data" "-c" "config_file=/etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf" > /dev/null 2>&1
}

function usage {
	echo "usage: entrypoint.sh [start]"
}

if [ "$1" != "" ]; then
	case $1 in
		start | start_postgresql )  start_postgresql
			exit
			;;
		-h | --help )               usage
			exit
			;;
	esac
	shift
fi

exec "$@"
