#!/usr/bin/env bash
set -e

function start_postgresql {
	su -c '/usr/lib/postgresql/$POSTGRESQL_VERSION/bin/postgres "-p" $POSTGRESQL_PORT "-D" "/var/lib/postgresql/$POSTGRESQL_VERSION/data" "-c" "config_file=/etc/postgresql/$POSTGRESQL_VERSION/main/postgresql.conf"' $USER
}

function usage {
	echo "usage: entrypoint.sh [start]"
}

if [ "$1" != "" ]; then
	case $1 in
		-s | --server )     start_postgresql
			                exit
			                ;;
		-h | --help )       usage
                			exit
                			;;
	esac
	shift
fi

exec "$@"
