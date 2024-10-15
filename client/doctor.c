#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"



static void show_pending_boxes(char *prodotto, char *ditta, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];
	int status;
	
	//lista per le scatole pendenti di una determinato prodotto

	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_scatole_pendenti(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show pending boxes statement\n", false);
	}

	
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = strlen(prodotto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for show pending boxes\n", true);
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
		
		dump_result_set(conn, prepared_stmt, "\nList of Pending Boxes");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while show pending boxes", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	

	
}

static void show_all_categories(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;

	//lista di tutte le categorie

	
	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_categorie()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show categories statement\n", false);
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
		
		dump_result_set(conn, prepared_stmt, "\nList of Categories");

		
	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while show categories", true);
		
	} while (status == 0);


	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");

}



static void show_all_suppliers(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;

	//lista delle ditte

	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_ditte()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show suppliers statement\n", false);
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
		
		dump_result_set(conn, prepared_stmt, "\nList of Suppliers");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while show suppliers", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	

	
}



static void register_prof_sale(char *prodotto, char *ditta, int sale_id, MYSQL *conn)
{


	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[4];
	
	int serial;

	//gestione vendita scatole di prodotti di profumeria


	show_pending_boxes(prodotto, ditta, conn);

	while(1){


reinsert_sale_box:

		printf("\nPlease insert the Box Serial of One Box:");
		scanf("%d", &serial);


		if(!setup_prepared_stmt(&prepared_stmt, "call vendita_scatola_prof(?, ?, ?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize sale statement\n", false);
		}


		
		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = prodotto;
		param[0].buffer_length = strlen(prodotto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = ditta;
		param[1].buffer_length = strlen(ditta);

		param[2].buffer_type = MYSQL_TYPE_LONG;
		param[2].buffer = &serial;
		param[2].buffer_length = sizeof(serial);

		param[3].buffer_type = MYSQL_TYPE_LONG;
		param[3].buffer = &sale_id;
		param[3].buffer_length = sizeof(sale_id);



		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for the sale\n", true);
		}


		
		if (mysql_stmt_execute(prepared_stmt) != 0) {
			

			if(generic_error_handler(prepared_stmt, "Sale box"))


				goto reinsert_sale_box;
			

			if(specific_error_handler(prepared_stmt, "45011")){
				printf("The selected box is not pending/existing or is related to another product, please reinsert:\n");

				goto reinsert_sale_box;

			}

			finish_with_stmt_error(conn, prepared_stmt, "Could not handle the sale error\n", true);
		}



		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		flush(stdin);
		printf("Box with serial %d correctly registered wit the sale %d", serial, sale_id);
		printf("\nOther boxes of this product to register for this sale [y/n]?\n");
		if(choice())
			continue;
		else
			break;
		



	}
	
}

static int insert_venditarr(char *prodotto, char *ditta, int sale_id, MYSQL* conn)
{

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[6];

	MYSQL_TIME prescription_date;
	int sale_id_rr, day, month, year, stat;

	char doctor[46];

	//inserimento di una vendita di medicinali richiedenti ricetta

	
	printf("Please insert the necessary informations!\n");

reinsert_salerr:

	printf("Prescription Date:\nDay:");
	scanf("%2d", &day);
	printf("Month:");
	scanf("%2d", &month);
	printf("Year:");
	scanf("%4d", &year);
	prescription_date.day = day;
	prescription_date.month = month;
	prescription_date.year = year;

	flush(stdin);

	printf("Please insert the name of the doctor:");
	getInput(46, doctor, false);

	

	if(!setup_prepared_stmt(&prepared_stmt, "call registra_vendita_rr(?, ?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize insert sale rr statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = strlen(prodotto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);

	param[2].buffer_type = MYSQL_TYPE_LONG;
	param[2].buffer = &sale_id;
	param[2].buffer_length = sizeof(sale_id);

	param[3].buffer_type = MYSQL_TYPE_DATE;
	param[3].buffer = &prescription_date;
	param[3].buffer_length = sizeof(prescription_date);

	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = doctor;
	param[4].buffer_length = strlen(doctor);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for sale rr insertion\n", true);
	}


	
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		
		if(generic_error_handler(prepared_stmt, "Prescription/Doctor")){
			memset(doctor, 0, 46);

			goto reinsert_salerr;
		}


		if(specific_error_handler(prepared_stmt, "45012")){
			printf("Prescription Date is not valid(30 days max validity), please reinsert:\n");

			goto reinsert_salerr;

		}

		finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve the informations\n", true);

	}


	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &sale_id_rr;
	param[0].buffer_length = sizeof(sale_id_rr);


	if(mysql_stmt_bind_result(prepared_stmt, param)) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve output parameter", true);
	}
	

	if((stat = mysql_stmt_fetch(prepared_stmt))) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not buffer results", true);
	}


	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");


	return sale_id_rr;


}

static void show_related_salesrr(char *prodotto,char *ditta,int sale_id,MYSQL* conn)
{

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];

	int status;
	

	
	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_venditerr_relative(?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show related sales statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = strlen(prodotto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);

	param[2].buffer_type = MYSQL_TYPE_LONG;
	param[2].buffer = &sale_id;
	param[2].buffer_length = sizeof(sale_id);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for show rel sales\n", true);
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
		
		dump_result_set(conn, prepared_stmt, "\nList of Related Operations");

		
	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition for show rel sales", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	
}


static void register_med_sale(char *prodotto, char *ditta, int sale_id, int is_rr, MYSQL* conn)
{

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[6];

	int serial;
	char cf[21];
	bool flag_cf_n, flag_rr_n;
	
	int idr;

	//register medicinal sale

	show_pending_boxes(prodotto, ditta, conn);


	while(1){

reinsert_sale_med_box:

		printf("\nPlease insert the Box Serial of One Box:");
		scanf("%d", &serial);

		flush(stdin);

		printf("Has the client decided to register his CF for this box? [y/n]\n");
		if(choice()){
			printf("Please insert it: ");
			getInput(21, cf, false);

			flag_cf_n = false;
		}else
			flag_cf_n = true;


		if(is_rr){

reinsert_related:

			flag_rr_n = false;
			show_related_salesrr(prodotto, ditta, sale_id, conn);
			printf("Is this box related to one of this operations?[y/n]\n");
			if(choice()){
				printf("Please insert the idr of the operation: ");
				scanf("%d", &idr);
				flush(stdin);
			}else{
				idr = insert_venditarr(prodotto, ditta, sale_id, conn);
			}
			
		}else{
			flag_rr_n = true;
		}

		

		if(!setup_prepared_stmt(&prepared_stmt, "call vendita_scatola_med(?, ?, ?, ?, ?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize sale statement\n", false);
		}

		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = prodotto;
		param[0].buffer_length = strlen(prodotto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = ditta;
		param[1].buffer_length = strlen(ditta);

		param[2].buffer_type = MYSQL_TYPE_LONG;
		param[2].buffer = &serial;
		param[2].buffer_length = sizeof(serial);

		param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[3].buffer = cf;
		param[3].buffer_length = strlen(cf);
		param[3].is_null = &flag_cf_n;

		param[4].buffer_type = MYSQL_TYPE_LONG;
		param[4].buffer = &sale_id;
		param[4].buffer_length = sizeof(sale_id);

		param[5].buffer_type = MYSQL_TYPE_LONG;
		param[5].buffer = &idr;
		param[5].buffer_length = sizeof(idr);
		param[5].is_null = &flag_rr_n;



		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for sale insertion\n", true);
		}


		if (mysql_stmt_execute(prepared_stmt) != 0) {
			
			if(generic_error_handler(prepared_stmt, "Box/CF")){
				memset(cf, 0, 21);

				goto reinsert_sale_med_box;
			}


			if(specific_error_handler(prepared_stmt, "45011")){
				printf("The selected box is not pending/existing or is related to another product, please reinsert:\n");
				memset(cf, 0, 21);

				goto reinsert_sale_med_box;

			}
				


			if(specific_error_handler(prepared_stmt, "45012")){
				printf("The selected idr is not related to this sale or to this product, please reinsert:\n");
				memset(cf, 0, 21);

				goto reinsert_related;

			}

			finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve informations\n", true);

		}



		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");


		if(is_rr)
			printf("Box with serial %d correctly registered wit the sale RR %d related to the general sale %d", serial, idr, sale_id);
		else
			printf("Box with serial %d correctly registered wit the sale %d", serial, sale_id);


		printf("\nOther boxes of this product to register for this sale [y/n]?\n");
		if(choice()){
			memset(cf, 0, 21);
			continue;
		}
		else
			break;


	}

}



static void register_sale(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];
	
	int is_rr, is_prof, sale_id, stat;

	char prodotto[46];
	char ditta[46];


	if(!setup_prepared_stmt(&prepared_stmt, "call registra_vendita(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize sale statement\n", false);
	}

	
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &sale_id;
	param[0].buffer_length = sizeof(sale_id);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for sale insertion\n", true);
	}

	if (mysql_stmt_execute(prepared_stmt) != 0) {

		print_stmt_error (prepared_stmt, "An error occurred while retrieving informations.");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;

	}


	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &sale_id;
	param[0].buffer_length = sizeof(sale_id);


	if(mysql_stmt_bind_result(prepared_stmt, param)) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve output parameter", true);
	}
	

	if((stat = mysql_stmt_fetch(prepared_stmt))) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not buffer results", true);
	}


	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	


	show_all_products(conn);


	while(1){


		printf("\nOf which Product do you want to register the sale?\n");

reinsert_prod_sale:

		printf("Product name:");
		getInput(46, prodotto, false);
		printf("\nSupplier name:");
		getInput(46, ditta, false);

		if(!setup_prepared_stmt(&prepared_stmt, "call get_product_info(?, ?, ?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize get info statement\n", false);
		}


		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = prodotto;
		param[0].buffer_length = strlen(prodotto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = ditta;
		param[1].buffer_length = strlen(ditta);


		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for get info\n", true);
		}


		if (mysql_stmt_execute(prepared_stmt) != 0) {
			
			if(generic_error_handler(prepared_stmt, "Product/Supplier")){
				memset(prodotto, 0, 46);
				memset(ditta, 0, 46);


				goto reinsert_prod_sale;
			}


			if(specific_error_handler(prepared_stmt, "45009")){
				printf("Product/Supplier not found or Without Stocks, please reinsert:\n");
				memset(prodotto, 0, 46);
				memset(ditta, 0, 46);

				goto reinsert_prod_sale;

			}
				
			finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve informations\n", true);

		}


		memset(param, 0, sizeof(param));
		param[0].buffer_type = MYSQL_TYPE_LONG;
		param[0].buffer = &is_prof;
		param[0].buffer_length = sizeof(is_prof);


		param[1].buffer_type = MYSQL_TYPE_LONG;
		param[1].buffer = &is_rr;
		param[1].buffer_length = sizeof(is_rr);


		if(mysql_stmt_bind_result(prepared_stmt, param)) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve output parameter", true);
		}

		if((mysql_stmt_fetch(prepared_stmt))) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not buffer results", true);
		}


		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");
	
		if(is_rr != 1)
			is_rr = 0;
		
		/*gestisco differentemente le vendite di scatole di profumerie da quelle di medicinali, oltre a salvarmi l'informazione sul fatto
		  che la scatola riferisca un farmaco che richiede ricetta oppure no*/

		if(is_prof)
			register_prof_sale(prodotto, ditta, sale_id, conn);
		else
			register_med_sale(prodotto, ditta, sale_id, is_rr, conn);	


		printf("Other Boxes of other products to register?[y/n]\n");
		if(choice()){
			memset(prodotto, 0, 46);
			memset(ditta, 0, 46);
			continue;
		}	
		else
			break;


	}


}

static void insert_medicinal(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

	char prodotto[46];
	char ditta[46];
	char categoria[46];
	bool mut_flag, rr_flag;
	bool mut_flag_n, rr_flag_n;

	//inserimento nuovo medicinale


reinsert_med:

	printf("\nProduct name: ");
	getInput(46, prodotto, false);


	show_all_suppliers(conn);

	printf("Supplier name: ");
	getInput(46, ditta, false);


	show_all_categories(conn);


	printf("Category: ");
	getInput(46, categoria, false);


	
	printf("Is it loanable [y/n]?\n");

	if(choice()){
		mut_flag = 1;
		mut_flag_n = 0;
	}else{
		mut_flag = 0;
		mut_flag_n = 1;
	}

	printf("Requires it recipe? [y/n]?\n");

	if(choice()){
		rr_flag = 1;
		rr_flag_n= 0;
	}else{
		rr_flag = 0;
		rr_flag_n = 1;
	}

	
	if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuovo_medicinale(?, ?, ?, ?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize insert statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = strlen(prodotto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);

	param[2].buffer_type = MYSQL_TYPE_TINY;
	param[2].buffer = &mut_flag;
	param[2].buffer_length = sizeof(mut_flag);
	param[2].is_null = &mut_flag_n;

	param[3].buffer_type = MYSQL_TYPE_TINY;
	param[3].buffer = &rr_flag;
	param[3].buffer_length = sizeof(rr_flag);
	param[3].is_null = &rr_flag_n;

	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = categoria;
	param[4].buffer_length = strlen(categoria);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for medicinal insertion\n", true);
	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {


		if(generic_error_handler(prepared_stmt, "Supplier/Product/Category")){
			memset(prodotto, 0, 46);
			memset(ditta, 0, 46);
			memset(categoria, 0, 46);


			goto reinsert_med;
		}else
			finish_with_stmt_error(conn, prepared_stmt, "Error adding the medicinal\n", true);

	}else{

		printf("Medicinal correctly added!");
		fflush(stdout);
	}

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");



}

static void insert_prof(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];

	char prodotto[46];
	char ditta[46];

	//inserimento nuovo prodotto di profumeria

reinsert_prof:

	printf("\nProduct name: ");
	getInput(46, prodotto, false);


	show_all_suppliers(conn);

	printf("Supplier name: ");
	getInput(46, ditta, false);

	
	if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuovo_profumeria(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize insert prof statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = strlen(prodotto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for prof product insertion\n", true);
	}

	if (mysql_stmt_execute(prepared_stmt) != 0) {


			if(generic_error_handler(prepared_stmt, "Supplier/Product")){
				memset(prodotto, 0, 46);
				memset(ditta, 0, 46);


				goto reinsert_prof;
			}else
				finish_with_stmt_error(conn, prepared_stmt, "Error adding the perfumery product\n", true);

		}else{

			printf("Perfumery Product correctly added!");
			fflush(stdout);
		}


	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");


}



static void insert_category_interactions(char* category, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

	//inserimento interazioni tra categorie

	char categoria[46];

	

	show_all_categories(conn);

	while(true){

		
		printf("Please insert the name of the related category:");


reinsert_int:

		getInput(46, categoria, false);

		if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_interazione(?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize interaction insertion statement\n", false);
		}

		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = category;
		param[0].buffer_length = strlen(category);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = categoria;
		param[1].buffer_length = strlen(categoria);
	
		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for interaction insertion\n", true);
		}


		if (mysql_stmt_execute(prepared_stmt) != 0) {


			if(generic_error_handler(prepared_stmt, "Interaction")){
				memset(categoria, 0, 46);
				//duplicate entry

				goto reinsert_int;
			}

			if(specific_error_handler(prepared_stmt, "45008")){
				printf("interaction already inserted, other interactions to add[Y/N]?:\n");

				if(choice()){
					memset(categoria, 0, 46);
					continue;
				}else{
					return;
				}

			}

			
			finish_with_stmt_error(conn, prepared_stmt, "Could not retreive informations\n", true);

		}else{
			
			printf("Interaction correctly added!\n Other interactions to add for the category %s?[Y/N]", category);
			fflush(stdout);
		}

		

		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");


		

		if(choice()){
			memset(categoria, 0, 46);
			continue;
		}else{
			return;
		}

	}

	
	
	
}

static void insert_category(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

	//inserimento nuova categoria

	char categoria[46];

	
reinsert_cat:

	printf("\nCategory name: ");
	getInput(46, categoria, false);

	
	if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuova_categoria(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize insert category statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = categoria;
	param[0].buffer_length = strlen(categoria);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for category insertion\n", true);
	} 


	if (mysql_stmt_execute(prepared_stmt) != 0) {


		if(generic_error_handler(prepared_stmt, "Category")){
			memset(categoria, 0, 46);

			goto reinsert_cat;
		}
		
		finish_with_stmt_error(conn, prepared_stmt, "Could not insert informations\n", true);

	}else{

		printf("Category correctly added!");
		fflush(stdout);
	}

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error inserting");

	
	printf("Does this category have interactions with other categories? [y/n]?\n");

	if(choice())
		insert_category_interactions(categoria,conn);
	else
		return;
	


}








void run_as_doctor(MYSQL *conn)
{
	char options[6] = {'1','2', '3', '4', '5', '6'};
	char op;
	
	printf("Switching to professor role...\n");

	if(!parse_config("users/dottore.json", &conf)) {
		fprintf(stderr, "Unable to load professor configuration\n");
		exit(EXIT_FAILURE);
	}

	mysql_close (conn);


	conn = mysql_init (NULL);
	if (conn == NULL) {
		fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
		exit(EXIT_FAILURE);
	}

	if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
		fprintf (stderr, "mysql_real_connect() failed\n");
		fprintf(stderr, "Failed to change user.  Error: %s\n",mysql_error(conn));
		mysql_close (conn);
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf("*** What should I do for you? ***\n\n");
		printf("1) Insert a new medicinal\n");
		printf("2) Insert a new perfumery product\n");
		printf("3) Insert a new Category\n");
		printf("4) Register a Sale\n");
		printf("5) Report of Sales about Medicinals requiring recipe\n");
		printf("6) Quit\n");

		op = multiChoice("Select an option", options, 6);

		switch(op) {
			case '1':
				insert_medicinal(conn);
				break;
				
			case '2':
				insert_prof(conn);
				break;

			case '3':
				insert_category(conn);
				break;

			case '4':
				register_sale(conn);
				break;


			case '5':
				report_sales_rr(conn);
				break;

			case '6':
				return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		printf("\nDo you want to continue operations?\n");
		if(choice())
			continue;
		else
			return;
	}
}
