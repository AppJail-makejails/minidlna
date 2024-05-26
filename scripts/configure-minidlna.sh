#!/bin/sh

. /scripts/lib.subr

flush

info "Configuring ..."

env | grep -Ee '^MINIDLNA_[A-Z_]+=.+$' | while IFS= read -r env; do
	name=`printf "%s" "${env}" | cut -d= -f1 | tr '[:upper:]' '[:lower:]'`
	name=`printf "%s" "${name}" | sed -Ee 's/^minidlna_(.+)/\1/'`
	value=`printf "%s" "${env}" | cut -d= -f2-`

	info "Configuring ${name} -> ${value}"

	option "${name}" "${value}"
done
