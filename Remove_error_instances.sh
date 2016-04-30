		#!/bin/sh
		
		mysql -uroot -popenstack<<EOFMYSQL
		USE nova;
		SET FOREIGN_KEY_CHECKS=0;
		DELETE from instances where vm_state='error';
		SET FOREIGN_KEY_CHECKS=1;
		EOFMYSQL
