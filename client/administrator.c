#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"



static void show_addresses(char* ditta, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;
	MYSQL_BIND param[2];

	//mostra indirizzi di una ditta
	
	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_indirizzi_ditta(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show addresses statement\n", false);
	}

	
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = ditta;
	param[0].buffer_length = strlen(ditta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for show addresses\n", true);
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
		
		dump_result_set(conn, prepared_stmt, "\nList of Addresses");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	
}

static void show_communication_methods(char* ditta, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;
	MYSQL_BIND param[2];

	
	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_com_ditta(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show com methods statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = ditta;
	param[0].buffer_length = strlen(ditta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for com methods\n", true);
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
		
		dump_result_set(conn, prepared_stmt, "\nList of Communication Methods");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");

	
}




static void set_fav_rec(char* ditta, MYSQL* conn){


	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[6];

	char via[46];
	char citta[46];
	char civico[11];
	int cap;

	show_addresses(ditta, conn);

	//imposta recapito preferito nel caso non sia stato impostato durante l'inserimento vero e proprio
	
	printf("Please insert the Main Logistic Address\n");
	fflush(stdout);

reinsert_addr_2:

	printf("\nCity: ");
	getInput(46, citta, false);
	printf("\nStreet: ");
	getInput(46, via, false);
	printf("\nCivic: ");
	getInput(11, civico, false);
	printf("\nCAP:");
	scanf("%d", &cap);


	flush(stdin);

	if(!setup_prepared_stmt(&prepared_stmt, "call imposta_recapito(?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize set favorite statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = citta;
	param[0].buffer_length = strlen(citta);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = via;
	param[1].buffer_length = strlen(via);

	param[2].buffer_type = MYSQL_TYPE_STRING;
	param[2].buffer = &civico;
	param[2].buffer_length = strlen(civico);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &cap;
	param[3].buffer_length = sizeof(cap);

	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = ditta;
	param[4].buffer_length = strlen(ditta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for favorite rec\n", true);

	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {

		if(generic_error_handler(prepared_stmt, "City/Street/Civic")){
			memset(citta, 0, 46);
			memset(via, 0, 46);
			memset(civico, 0, 11);

			goto reinsert_addr_2;
		}

		if(specific_error_handler(prepared_stmt, "45014")){
			printf("Address not found, please reinsert\n");
			

			goto reinsert_addr_2;

		}


			
		finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition", true);

	}else{

		printf("Address correctly set for supplier %s!\n", ditta);
		fflush(stdout);
	}

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("error closing");


}



static void set_fav_fat(char* ditta, MYSQL* conn){


	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[6];

	char via[46];
	char citta[46];
	char civico[11];
	int cap;

	show_addresses(ditta, conn);

	//imposta indirizzo fatturazione preferito nel caso non sia stato impostato nell'inserimento
	
	printf("Please insert the Main Billing Address\n");
	fflush(stdout);

reinsert_addr_3:

	printf("\nCity: ");
	getInput(46, citta, false);
	printf("\nStreet: ");
	getInput(46, via, false);
	printf("\nCivic: ");
	getInput(11, civico, false);
	printf("\nCAP:");
	scanf("%d", &cap);


	flush(stdin);

	if(!setup_prepared_stmt(&prepared_stmt, "call imposta_fatturazione(?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize set favorite fatt statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = citta;
	param[0].buffer_length = strlen(citta);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = via;
	param[1].buffer_length = strlen(via);

	param[2].buffer_type = MYSQL_TYPE_STRING;
	param[2].buffer = &civico;
	param[2].buffer_length = strlen(civico);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &cap;
	param[3].buffer_length = sizeof(cap);

	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = ditta;
	param[4].buffer_length = strlen(ditta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for favorite fatt\n", true);

	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {

		if(generic_error_handler(prepared_stmt, "City/Street/Civic")){
			memset(citta, 0, 46);
			memset(via, 0, 46);
			memset(civico, 0, 11);

			goto reinsert_addr_3;
		}

		if(specific_error_handler(prepared_stmt, "45014")){
			printf("Address not found, please reinsert\n");
			

			goto reinsert_addr_3;

		}


			
		finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while setting the address", true);

	}else{

		printf("Address correctly set for supplier %s!\n", ditta);
		fflush(stdout);
	}

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("error closing");



}

static void set_fav_com(char* ditta, MYSQL* conn){

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[4];

	char contatto[46];

	//imposto contatto preferito nel caso non sia stato impostato in  inserimento
	

	show_communication_methods(ditta, conn);

	
	printf("Please insert the Main Communication Method\n");
	fflush(stdout);

reinsert_com_2:

	printf("\nContact: ");
	getInput(46, contatto, false);

	if(!setup_prepared_stmt(&prepared_stmt, "call imposta_preferito(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize set fav com statement\n", false);
	}

	
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = contatto;
	param[0].buffer_length = strlen(contatto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for set fav com\n", true);

	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {

		if(generic_error_handler(prepared_stmt, "Contact")){
			memset(contatto, 0, 46);
			
			goto reinsert_com_2;
		}

		if(specific_error_handler(prepared_stmt, "45015")){
			printf("Communication Method not found, please reinsert\n");
			memset(contatto, 0, 46);

			goto reinsert_com_2;

		}


			
		finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while setting the communication method", true);

	}else{

		printf("Communication Method correctly set for supplier %s!\n", ditta);
		fflush(stdout);
	}

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("error closing");

}


static void insert_address(char *ditta, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[7];

	/*inserimento indirizzo di una ditta
	  posso settare solo una volta il recapito e/o l'indirizzo di fatturazione preferito.
	  se non lo imposto almeno una volta prima di terminare l'inserimento, viene chiesto esplicitamente in modo
	  da rispettare la regola aziendale.
		*/

	char via[46];
	char citta[46];
	char civico[11];
	int cap;
	bool recapito, recapito_n, fatturazione, fatturazione_n;
	bool first = true, logistic = false, billing = false;


	

	printf("Please insert informations about new Addresses\n");


	while(1){

		if(first){
			first = false;

			printf("Please insert the supplier's address\n");
		}else{
			printf("Do you want to add another address for this supplier?\n");
			if(!choice())
				break;
		}


reinsert_addr:

		printf("\nCity: ");
		getInput(46, citta, false);
		printf("\nStreet: ");
		getInput(46, via, false);
		printf("\nCivic: ");
		getInput(11, civico, false);
		printf("\nCAP:");
		scanf("%d", &cap);


		flush(stdin);




		if(!logistic){
			printf("\nIs this the main Logistic Address[Y,N]?\n");
			if(choice()){
				recapito = true;
				logistic = true;
			}
			else
				recapito = false;

		}else
			recapito = false;

		recapito_n = !recapito;



		if(!billing){
			printf("Is this the main Billing Address[Y/N]?\n");
			if(choice()){
				fatturazione = true;
				billing = true;
			}
			else
				fatturazione = false;

		}else
			fatturazione = false;

		fatturazione_n = !fatturazione;

		
		if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuovo_indirizzo(?, ?, ?, ?, ?, ?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize insert address statement\n", false);
		}

		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = citta;
		param[0].buffer_length = strlen(citta);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = via;
		param[1].buffer_length = strlen(via);

		param[2].buffer_type = MYSQL_TYPE_STRING;
		param[2].buffer = &civico;
		param[2].buffer_length = strlen(civico);

		param[3].buffer_type = MYSQL_TYPE_LONG;
		param[3].buffer = &cap;
		param[3].buffer_length = sizeof(cap);

		param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[4].buffer = ditta;
		param[4].buffer_length = strlen(ditta);


		param[5].buffer_type = MYSQL_TYPE_TINY;
		param[5].buffer = &fatturazione;
		param[5].buffer_length = sizeof(fatturazione);
		param[5].is_null = &fatturazione_n;

		param[6].buffer_type = MYSQL_TYPE_TINY;
		param[6].buffer = &recapito;
		param[6].buffer_length = sizeof(recapito);
		param[6].is_null = &recapito_n;


		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for insert address\n", true);
		}


		if (mysql_stmt_execute(prepared_stmt) != 0) {

			if(generic_error_handler(prepared_stmt, "City/Street/Civic")){
				memset(citta, 0, 46);
				memset(via, 0, 46);
				memset(civico, 0, 11);

				goto reinsert_addr;
			}
				
			finish_with_stmt_error(conn, prepared_stmt, "Error while insert address\n", true);

		}else{

			printf("Address correctly added for supplier %s!\n", ditta);
			fflush(stdout);
		}

		
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

	}

	if(!logistic)
		set_fav_rec(ditta, conn);

	if(!billing)
		set_fav_fat(ditta, conn);
	
}



static void insert_com(char *ditta, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

	char contatto[46];
	char tipologia[46];
	bool preferito, preferito_n;

	bool first = true, favorite = false;

	/*inserimento metodo comunicativo di una ditta
	  posso settare solo una volta il contatto preferito.
	  se non lo imposto almeno una volta prima di terminare l'inserimento, viene chiesto esplicitamente in modo
	  da rispettare la regola aziendale.
		*/

	

	while(1){

		if(first){
			first = false;
			printf("Please insert the supplier's communication method:\n");
		}else{
			printf("Do you want to add another communication method for this supplier?\n");
			fflush(stdout);
			if(!choice())
				break;
		}


reinsert_com:

		printf("\nContact: ");
		getInput(46, contatto, false);
		printf("\nType: ");
		getInput(46, tipologia, false);


	

		if(!favorite){
			printf("\nIs this the main Communication Method[Y,N]?\n");
			if(choice()){
				preferito = true;
				favorite = true;
			}
			else
				preferito = false;

			
		}else
			preferito = false;
			
		
		preferito_n = !preferito;
		

		if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuovo_com(?, ?, ?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize com insertion statement\n", false);
		}

		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = contatto;
		param[0].buffer_length = strlen(contatto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = tipologia;
		param[1].buffer_length = strlen(tipologia);

		param[2].buffer_type = MYSQL_TYPE_STRING;
		param[2].buffer = ditta;
		param[2].buffer_length = strlen(ditta);

		param[3].buffer_type = MYSQL_TYPE_TINY;
		param[3].buffer = &preferito;
		param[3].buffer_length = sizeof(preferito);
		param[3].is_null = &preferito_n;


		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for com insertion\n", true);
		}


		if (mysql_stmt_execute(prepared_stmt) != 0) {

			if(generic_error_handler(prepared_stmt, "Contact/Type")){
				memset(contatto, 0, 46);
				memset(tipologia, 0, 46);

				goto reinsert_com;
			}

			finish_with_stmt_error(conn, prepared_stmt, "Error while insert com\n", true);

		}else{

			printf("Communication method correctly added for supplier %s!\n", ditta);
			fflush(stdout);

		}


		

		
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

	}


	if(!favorite)
		set_fav_com(ditta, conn);

}



static void insert_supplier(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	//inserimento di una nuova ditta

	char ditta[46];

reinsert_s:

	printf("Supplier name: ");
	getInput(46, ditta, false);

	if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuova_ditta(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize supplier insertion statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = ditta;
	param[0].buffer_length = strlen(ditta);

	
	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for supplier insertion\n", true);
	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {

		if(generic_error_handler(prepared_stmt, "Supplier")){
			memset(ditta, 0, 46);

			goto reinsert_s;
		}else
			finish_with_stmt_error(conn, prepared_stmt, "Error while inserting supplier\n", true);

	}else{

		printf("Supplier correctly created!\n");
		fflush(stdout);

	}

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("error closing");

	insert_address(ditta, conn);

	insert_com(ditta, conn);

	
}

static void create_order(MYSQL *conn, bool value)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[4];

	char prodotto[46];
	char ditta[46];
	int how;
	int prog_number;

	if(value)
		show_all_products(conn);

	//creazione di un ordine

reinsert:

	printf("\nProduct name: ");
	getInput(46, prodotto, false);
	printf("Supplier name: ");
	getInput(46, ditta, false);

reinsert_q:

	printf("Desired quantity: ");
	scanf("%d", &how);

	
	if(!setup_prepared_stmt(&prepared_stmt, "call crea_ordine(?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize order creation statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = strlen(prodotto);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = strlen(ditta);

	param[2].buffer_type = MYSQL_TYPE_LONG;
	param[2].buffer = &how;
	param[2].buffer_length = sizeof(how);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &prog_number;
	param[3].buffer_length = sizeof(prog_number);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for order creation\n", true);
	}

	if (mysql_stmt_execute(prepared_stmt) != 0) {

		if(generic_error_handler(prepared_stmt, "Supplier/Product")){
			memset(prodotto, 0, 46);
			memset(ditta, 0, 46);
			flush(stdin);


			goto reinsert;
		}
		if(specific_error_handler(prepared_stmt, "45000")){
			printf("The selected quantity is wrong, please reinsert\n");

			goto reinsert_q;

		}


		print_stmt_error (prepared_stmt, "An error occurred while creating the order");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;
			
	} 


	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &prog_number;
	param[0].buffer_length = sizeof(prog_number);
	
	if(mysql_stmt_bind_result(prepared_stmt, param)) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve output parameter", true);
	}
	
	if(mysql_stmt_fetch(prepared_stmt)) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not buffer results", true);
	}


	printf("Order correctly created with progressive number: %d\n", prog_number);
	fflush(stdout);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("error closing");

	flush(stdin);
}



static void register_prof_order(char* prodotto,char* ditta,int how,int prog_number, MYSQL* conn){

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];
	MYSQL_TIME expiration_date;
	int i, day, month, year;
	
	//registrazione di un ordine riguardante un prodotto di profumeria

	printf("Please insert the necessary informations: \n");
	for(i = 0;i < how; i++){

		printf("Box number %d", i+1);
		fflush(stdout);	

reinsert_prof_exp:

		printf("Expiration Date:\nDay:");

		scanf("%2d", &day);
		printf("Month:");
		scanf("%2d", &month);
		printf("Year:");
		scanf("%4d", &year);
		expiration_date.day = day;
		expiration_date.month = month;
		expiration_date.year = year;

		flush(stdin);
		
		
		
		if(!setup_prepared_stmt(&prepared_stmt, "call registra_scatola_profumeria(?,?,?,?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize order register statement\n", false);
		}

		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = prodotto;
		param[0].buffer_length = strlen(prodotto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = ditta;
		param[1].buffer_length = strlen(ditta);

		param[2].buffer_type = MYSQL_TYPE_DATE;
		param[2].buffer = &expiration_date;
		param[2].buffer_length = sizeof(expiration_date);

		param[3].buffer_type = MYSQL_TYPE_LONG;
		param[3].buffer = &prog_number;
		param[3].buffer_length = sizeof(prog_number);

		


		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for order register\n", true);
		}

		if (mysql_stmt_execute(prepared_stmt) != 0) {


			if(generic_error_handler(prepared_stmt, "Date"))

				goto reinsert_prof_exp;
			
		

			if(specific_error_handler(prepared_stmt, "45001")){
				printf("Expiration Date is wrong, please reinsert:\n");

				goto reinsert_prof_exp;

			}

			finish_with_stmt_error(conn, prepared_stmt, "Error registering the order\n", true);



		}else{

			printf("Box successfully added!\n");
			fflush(stdout);

		}


		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

	}


	

}

static void show_free_positions(char* categoria, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];
	int status;

	//lista posizioni disponibili per scatole riferenti un farmaco di una determinata categoria
	
	if(!setup_prepared_stmt(&prepared_stmt, "call mostra_posizioni_disponibili(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize show free positions statement\n", false);
	}

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = categoria;
	param[0].buffer_length = strlen(categoria);

	


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for show positions\n", true);
	}

	
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "An error occurred while retrieving informations.");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;
	} 

	printf("Category %s, ", categoria);
	fflush(stdout);

	do {

		if(conn->server_status & SERVER_PS_OUT_PARAMS) {
			goto next;
		}
		
		dump_result_set(conn, prepared_stmt, "List of Available Positions");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition show positions", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	
}



static void register_med_order(char* prodotto,char* ditta,int how,int prog_number, char* categoria, MYSQL* conn){
	
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[8];
	MYSQL_TIME expiration_date;
	int i, day, month, year, scaffale, cassetto;

	//registrazione ordine di medicinali


	printf("Please insert the necessary informations: \n");
	for(i = 0;i < how; i++){

		printf("Box number %d\n", i+1);
		fflush(stdout);

reinsert_exp:

		printf("Expiration Date:\nDay:");
		scanf("%2d", &day);
		printf("Month:");
		scanf("%2d", &month);
		printf("Year:");
		scanf("%4d", &year);
		expiration_date.day = day;
		expiration_date.month = month;
		expiration_date.year = year;


		flush(stdin);



		show_free_positions(categoria, conn);

reinsert_pos:

		printf("Position:\n");
		printf("\nScaffale:");
		scanf("%d", &scaffale);
		printf("\nCassetto:");
		scanf("%d", &cassetto);

		flush(stdin);

		
		if(!setup_prepared_stmt(&prepared_stmt, "call registra_scatola_medicinale(?,?,?,?,?,?,?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize order list statement\n", false);
		}

		
		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = prodotto;
		param[0].buffer_length = strlen(prodotto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = ditta;
		param[1].buffer_length = strlen(ditta);

		
		param[2].buffer_type = MYSQL_TYPE_DATE;
		param[2].buffer = &expiration_date;
		param[2].buffer_length = sizeof(expiration_date);

		param[3].buffer_type = MYSQL_TYPE_LONG;
		param[3].buffer = &prog_number;
		param[3].buffer_length = sizeof(prog_number);

		param[4].buffer_type = MYSQL_TYPE_LONG;
		param[4].buffer = &cassetto;
		param[4].buffer_length = sizeof(cassetto);

		param[5].buffer_type = MYSQL_TYPE_LONG;
		param[5].buffer = &scaffale;
		param[5].buffer_length = sizeof(scaffale);

		param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[6].buffer = categoria;
		param[6].buffer_length = strlen(categoria);

		


		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for register\n", true);
		}

		if (mysql_stmt_execute(prepared_stmt) != 0) {


			if(generic_error_handler(prepared_stmt, "Box/Category/Position"))
				goto reinsert_exp;
			

			if(specific_error_handler(prepared_stmt, "45001")){
				printf("Expiration Date is wrong, please reinsert:\n");

				goto reinsert_exp;

			}

			if(specific_error_handler(prepared_stmt, "45002")){
				printf("Position already occupated, please reinsert:\n");

				goto reinsert_pos;

			}


			finish_with_stmt_error(conn, prepared_stmt, "Error while registering\n", true);

			
		}else{

			printf("Box successfully added!\n");
			fflush(stdout);
		
		}


		
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

	}


}


static void register_order(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[6];

	
	//registrazione di un ordine

	
	char prodotto[46];
	int is_med;
	char ditta[46];
	char categoria[46];
	int prog_number;
	int how, status, stat;

	if(!setup_prepared_stmt(&prepared_stmt, "call lista_ordini_pendenti()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize pending list statement\n", false);
	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve the pending list\n", true);
	}

	do {

		if(conn->server_status & SERVER_PS_OUT_PARAMS) {
			goto next;
		}
		
		dump_result_set(conn, prepared_stmt, "\nList of Pending orders");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while show pending boxes", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");


	printf("Please insert the progressive number of the registering order\n");

reinsert_prog:

	scanf("%d", &prog_number);



	if(!setup_prepared_stmt(&prepared_stmt, "call get_order_info(?,?,?,?,?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize order info statement\n", false);
	}

	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &prog_number;
	param[0].buffer_length = sizeof(prog_number);

	


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for order info\n", true);
	}


	if (mysql_stmt_execute(prepared_stmt) != 0) {


		if(specific_error_handler(prepared_stmt, "45006")){
			printf("Order already registered, please reinsert:\n");

			goto reinsert_prog;

		}

		if(specific_error_handler(prepared_stmt, "45007")){
			printf("Wrong progressive number, please reinsert:\n");

			goto reinsert_prog;

		}

		finish_with_stmt_error(conn, prepared_stmt, "Error while getting product info\n", true);
	}


	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = prodotto;
	param[0].buffer_length = 46;

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = ditta;
	param[1].buffer_length = 46;

	param[2].buffer_type = MYSQL_TYPE_LONG;
	param[2].buffer = &how;
	param[2].buffer_length = sizeof(how);

	param[3].buffer_type = MYSQL_TYPE_LONG;
	param[3].buffer = &is_med;
	param[3].buffer_length = sizeof(is_med);

	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = categoria;
	param[4].buffer_length = 46;

	if(mysql_stmt_bind_result(prepared_stmt, param)) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not retrieve output parameter", true);
	}

	if((stat = mysql_stmt_fetch(prepared_stmt))) {
		printf("stat %d", stat);
		finish_with_stmt_error(conn, prepared_stmt, "Could not buffer results", true);
	}


	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	

	if(is_med)
		register_med_order(prodotto, ditta, how, prog_number, categoria, conn);
	else
		register_prof_order(prodotto, ditta, how, prog_number, conn);

}


static void insert_previsions(char* use, MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];

	
	//inserimento di previsioni tra prodotti e utilizzi

	char prodotto[46];
	char ditta[46];

	

	show_all_products(conn);


	while(true){


reinsert_prevision:

		printf("Please insert the name of the related product:");
		getInput(46, prodotto, false);
		printf("Please insert the name of the product's supplier:");
		getInput(46, ditta, false);

		if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_previsione(?, ?, ?)", conn)) {
			finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize prevision insertion statement\n", false);
		}

		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[0].buffer = prodotto;
		param[0].buffer_length = strlen(prodotto);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[1].buffer = ditta;
		param[1].buffer_length = strlen(ditta);

		param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
		param[2].buffer = use;
		param[2].buffer_length = strlen(use);

	
		if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
			finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for prevision insertion\n", true);
		}


		if (mysql_stmt_execute(prepared_stmt) != 0) {


			if(generic_error_handler(prepared_stmt, "Prevision")){
				memset(prodotto, 0, 46);
				memset(ditta, 0, 46);


				goto reinsert_prevision;
			}else{
				print_stmt_error (prepared_stmt, "An error occurred while adding previsions.");
				if(mysql_stmt_close(prepared_stmt) != 0)
					printf("Error closing");

				return;
			}

		}else{

			printf("Prevision correctly added!");
			fflush(stdout);
		}



		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("error closing");

		
		printf("\n Other interactions to add for the use %s?[Y/N]\n", use);
		fflush(stdout);
		


		if(choice()){
			memset(prodotto, 0, 46);
			memset(ditta, 0, 46);
			continue;
		}else{
			return;
		}



	}

	
	
	
}

static void insert_use(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	
	//inserimento di un utilizzo

	char utilizzo[46];

reinsert_use:

	printf("\nUse name: ");
	getInput(46, utilizzo, false);
	
	if(!setup_prepared_stmt(&prepared_stmt, "call inserisci_nuovo_utilizzo(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize use insertion statement\n", false);
	}

	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = utilizzo;
	param[0].buffer_length = strlen(utilizzo);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for use insertion\n", true);
	}

	if (mysql_stmt_execute(prepared_stmt) != 0) {

		if(generic_error_handler(prepared_stmt, "Use")){
			memset(utilizzo, 0, 46);

			goto reinsert_use;
		}else{
			print_stmt_error (prepared_stmt, "An error occurred while adding the use.");
			if(mysql_stmt_close(prepared_stmt) != 0)
				printf("Error closing");

			return;
		}

	}else{

		printf("Use correctly added!");
		fflush(stdout);
	}
	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("error closing");

	printf("\nIs this use intended with some products' categories? [y/n]?\n");
	fflush(stdout);

	if(choice())
		insert_previsions(utilizzo,conn);
}

static void report_dismissed_boxes(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;

	//report delle scatole di medicinali in scadenza e quindi dismesse

	if(!setup_prepared_stmt(&prepared_stmt, "call report_scatole_scadenza()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize report dis box statement\n", false);
	}

	
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "An error occurred while report dis box.");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;
	} 

	do {

		if(conn->server_status & SERVER_PS_OUT_PARAMS) {
			goto next;
		}
		
		dump_result_set(conn, prepared_stmt, "\nList of Dismissed Boxes");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition while reporting", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");
	

	
}

static void report_med_stocks(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	int status;
	bool first = true;

	//lista giacenze di magazzino compresi i prodotti esauriti

	
	if(!setup_prepared_stmt(&prepared_stmt, "call report_giacenze_med()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize report med stocks statement\n", false);
	}

	
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "An error occurred while report med stocks.");
		if(mysql_stmt_close(prepared_stmt) != 0)
			printf("Error closing");

		return;
	} 

	do {

		if(conn->server_status & SERVER_PS_OUT_PARAMS) {
			goto next;
		}
		
		dump_result_set(conn, prepared_stmt, "\nList of Depleting Stocks");

	    next:
		status = mysql_stmt_next_result(prepared_stmt);
		if (status > 0)
			finish_with_stmt_error(conn, prepared_stmt, "Unexpected condition reporting med stocks", true);
		
	} while (status == 0);

	
	if(mysql_stmt_close(prepared_stmt) != 0)
		printf("Error closing");


	while(1){

		if(first){

			printf("Do you want to order boxes of one of this products?\n");
			first = false;

		}else
			printf("Do you want to order boxes of other products?");

		if(choice())
			create_order(conn, false);
		else
			break;
	
	}

}






void run_as_administrator(MYSQL *conn)
{
	char options[8] = {'1','2', '3', '4', '5', '6', '7', '8'};
	char op;
	
	printf("Switching to administrative role...\n");

	if(!parse_config("users/amministratore.json", &conf)) {
		fprintf(stderr, "Unable to load administrator configuration\n");
		exit(EXIT_FAILURE);
	}

	mysql_close(conn);
	

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
		printf("1) Create Order\n");
		printf("2) Register Order\n");
		printf("3) Insert a new Supplier\n");
		printf("4) Insert a new product use\n");
		printf("5) Report of dismissed boxes\n");
		printf("6) Report of Sales about Medicinals requiring recipe\n");
		printf("7) Report of Medicinal Depleting Stocks\n");
		printf("8) Quit\n");

		op = multiChoice("Select an option", options, 8);

		switch(op) {
			case '1':
				create_order(conn, true);
				break;

			case '2':
				register_order(conn);
				break;

			case '3':
				insert_supplier(conn);
				break;

			case '4':
				insert_use(conn);
				break;
			
			case '5':
				report_dismissed_boxes(conn);
				break;

			case '6':
				report_sales_rr(conn);
				break;

			case '7':
				report_med_stocks(conn);
				break;

			case '8':
				return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		printf("Do you want to continue operations?\n");
		if(choice())
			continue;
		else
			return;
	}
}
