	#!/bin/sh -eux
	# remove the duplicated hypervisor host from nova
	
	# set the gate :-)
	[ -n "$1" ] || exit 1
	
	mysql -uroot -popenstack<<EOFMYSQL
	USE nova;
	SET FOREIGN_KEY_CHECKS=0;
	#SELECT id, created_at, updated_at, hypervisor_hostname FROM compute_nodes;
	DELETE FROM services WHERE host="$1";
	DELETE FROM compute_nodes WHERE hypervisor_hostname="$1";
	
	USE neutron;
	DELETE FROM agents WHERE host="$1";
	
	USE cinder;
	DELETE FROM services WHERE host="$1";
	SET FOREIGN_KEY_CHECKS=1;
	EOFMYSQL
