#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"


bool generic_error_handler(MYSQL_STMT * prepared_stmt, char *object){


	if(strcmp("22001", mysql_stmt_sqlstate(prepared_stmt)) == 0){
		printf("%s name is too long, please reinsert:\n", object);

		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

		return true;
	}

	if(strcmp("23000", mysql_stmt_sqlstate(prepared_stmt)) == 0){
		
		if(mysql_stmt_errno (prepared_stmt) == (unsigned int)1062)
			printf("%s duplicate entry, please reinsert:\n", object);

		if(mysql_stmt_errno (prepared_stmt) == (unsigned int)1452)
			printf("%s error on foreign key, please reinsert:\n", object);

		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

		return true;
	}

	if(strcmp("22007", mysql_stmt_sqlstate(prepared_stmt)) == 0){
		printf("%s date is in wrong format, please reinsert:\n", object);

		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

		return true;
	}

	return false;
}

bool specific_error_handler(MYSQL_STMT * prepared_stmt, char * error){


	if(strcmp(error, mysql_stmt_sqlstate(prepared_stmt)) == 0){
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

		return true;
	}

	return false;
}



