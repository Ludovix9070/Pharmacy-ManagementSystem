#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"



void show_all_products(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;

	//lista di tutti i prodotti

	
	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_prodotti()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show products statement\n", false);
	}

	
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "An error occurred while retrieving informations.");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;
	} 

	do {

		if(conn->server_status & SERVER_PS_OUT_PARAMS) {
			goto next;
		}
		
		dump_result_set(conn, prepared_stmt, "\nList of Products");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while showing products", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	

}


void report_sales_rr(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;

	bool serials = false;

	//report sulle vendite di scatole di medicinali richiedenti ricetta
	
	if(!setup_prepared_stmt(&prepared_stmt, "call report_vendite_medicinali_rr()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize report statement\n", false);
	}

	
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "An error occurred while retrieving informations.");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;
	} 

	do {

		if(conn->server_status & SERVER_PS_OUT_PARAMS) {
			goto next;
		}

		if(serials){
			dump_result_set(conn, prepared_stmt, "\nSerials of saled Boxes in this sale");
			serials = false;
		}else{
			dump_result_set(conn, prepared_stmt, "\nSale Info");
			serials = true;
		}

		
	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while report sales", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	

	
}

