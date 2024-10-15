-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`ditte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ditte` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ditte` (
  `nome_d` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nome_d`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`indirizzi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`indirizzi` ;

CREATE TABLE IF NOT EXISTS `mydb`.`indirizzi` (
  `via` VARCHAR(45) NOT NULL,
  `citta` VARCHAR(45) NOT NULL,
  `civico` VARCHAR(10) NOT NULL,
  `cap` INT NOT NULL,
  `fatturazione` TINYINT NULL,
  `recapito` TINYINT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`via`, `citta`, `civico`, `cap`),
  INDEX `fk_Indirizzo_Ditta_idx` (`ditta` ASC),
  CONSTRAINT `fk_Indirizzo_Ditta`
    FOREIGN KEY (`ditta`)
    REFERENCES `mydb`.`ditte` (`nome_d`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`comunicazioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`comunicazioni` ;

CREATE TABLE IF NOT EXISTS `mydb`.`comunicazioni` (
  `contatto` VARCHAR(45) NOT NULL,
  `tipologia` VARCHAR(45) NOT NULL,
  `preferito` TINYINT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`contatto`, `ditta`),
  INDEX `fk_Comunicazione_Ditta1_idx` (`ditta` ASC),
  CONSTRAINT `fk_Comunicazione_Ditta1`
    FOREIGN KEY (`ditta`)
    REFERENCES `mydb`.`ditte` (`nome_d`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`prodotti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`prodotti` ;

CREATE TABLE IF NOT EXISTS `mydb`.`prodotti` (
  `nome_p` VARCHAR(45) NOT NULL,
  `profumeria` TINYINT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nome_p`, `ditta`),
  INDEX `fk_Prodotto_Ditta1_idx` (`ditta` ASC),
  CONSTRAINT `fk_Prodotto_Ditta1`
    FOREIGN KEY (`ditta`)
    REFERENCES `mydb`.`ditte` (`nome_d`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`utilizzi`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`utilizzi` ;

CREATE TABLE IF NOT EXISTS `mydb`.`utilizzi` (
  `nome_u` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nome_u`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`previsioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`previsioni` ;

CREATE TABLE IF NOT EXISTS `mydb`.`previsioni` (
  `prodotto` VARCHAR(45) NOT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  `utilizzo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`prodotto`, `ditta`, `utilizzo`),
  INDEX `fk_Prodotto_has_Utilizzo_Utilizzo1_idx` (`utilizzo` ASC),
  INDEX `fk_Prodotto_has_Utilizzo_Prodotto1_idx` (`prodotto` ASC, `ditta` ASC),
  CONSTRAINT `fk_Prodotto_has_Utilizzo_Prodotto1`
    FOREIGN KEY (`prodotto` , `ditta`)
    REFERENCES `mydb`.`prodotti` (`nome_p` , `ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prodotto_has_Utilizzo_Utilizzo1`
    FOREIGN KEY (`utilizzo`)
    REFERENCES `mydb`.`utilizzi` (`nome_u`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`categorie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`categorie` ;

CREATE TABLE IF NOT EXISTS `mydb`.`categorie` (
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`medicinali`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`medicinali` ;

CREATE TABLE IF NOT EXISTS `mydb`.`medicinali` (
  `mutuabile` TINYINT NULL,
  `rr` TINYINT NULL,
  `medicinale` VARCHAR(45) NOT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`medicinale`, `ditta`),
  INDEX `fk_Medicinale_Categoria1_idx` (`categoria` ASC),
  CONSTRAINT `fk_Medicinale_Prodotto1`
    FOREIGN KEY (`medicinale` , `ditta`)
    REFERENCES `mydb`.`prodotti` (`nome_p` , `ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Medicinale_Categoria1`
    FOREIGN KEY (`categoria`)
    REFERENCES `mydb`.`categorie` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`interazioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`interazioni` ;

CREATE TABLE IF NOT EXISTS `mydb`.`interazioni` (
  `categoria_uno` VARCHAR(45) NOT NULL,
  `categoria_due` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`categoria_uno`, `categoria_due`),
  INDEX `fk_Categoria_has_Categoria_Categoria2_idx` (`categoria_due` ASC),
  INDEX `fk_Categoria_has_Categoria_Categoria1_idx` (`categoria_uno` ASC),
  CONSTRAINT `fk_Categoria_has_Categoria_Categoria1`
    FOREIGN KEY (`categoria_uno`)
    REFERENCES `mydb`.`categorie` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Categoria_has_Categoria_Categoria2`
    FOREIGN KEY (`categoria_due`)
    REFERENCES `mydb`.`categorie` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`scaffali`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`scaffali` ;

CREATE TABLE IF NOT EXISTS `mydb`.`scaffali` (
  `codice_s` INT NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice_s`, `categoria`),
  INDEX `fk_Scaffale_Categoria1_idx` (`categoria` ASC),
  CONSTRAINT `fk_Scaffale_Categoria1`
    FOREIGN KEY (`categoria`)
    REFERENCES `mydb`.`categorie` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cassetti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cassetti` ;

CREATE TABLE IF NOT EXISTS `mydb`.`cassetti` (
  `codice_c` INT NOT NULL,
  `scaffale` INT NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codice_c`, `scaffale`, `categoria`),
  INDEX `fk_Cassetto_Scaffale1_idx` (`scaffale` ASC, `categoria` ASC),
  CONSTRAINT `fk_Cassetto_Scaffale1`
    FOREIGN KEY (`scaffale` , `categoria`)
    REFERENCES `mydb`.`scaffali` (`codice_s` , `categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ordini`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ordini` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ordini` (
  `progressivo` INT NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `quantita` INT NOT NULL,
  `prodotto` VARCHAR(45) NOT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  `evaso` TINYINT NULL,
  PRIMARY KEY (`progressivo`),
  INDEX `fk_Ordine_Prodotto1_idx` (`prodotto` ASC, `ditta` ASC),
  CONSTRAINT `fk_Ordine_Prodotto1`
    FOREIGN KEY (`prodotto` , `ditta`)
    REFERENCES `mydb`.`prodotti` (`nome_p` , `ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vendite`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vendite` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vendite` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `giorno` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vendite_medicinalirr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vendite_medicinalirr` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vendite_medicinalirr` (
  `idr` INT NOT NULL AUTO_INCREMENT,
  `giorno_p` DATE NOT NULL,
  `medico` VARCHAR(45) NOT NULL,
  `vendita` INT NOT NULL,
  `medicinale` VARCHAR(45) NOT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idr`),
  INDEX `fk_VenditaMedicinaleRR_Vendita1_idx` (`vendita` ASC),
  INDEX `fk_VenditaMedicinaleRR_Medicinale1_idx` (`medicinale` ASC, `ditta` ASC),
  CONSTRAINT `fk_VenditaMedicinaleRR_Vendita1`
    FOREIGN KEY (`vendita`)
    REFERENCES `mydb`.`vendite` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VenditaMedicinaleRR_Medicinale1`
    FOREIGN KEY (`medicinale` , `ditta`)
    REFERENCES `mydb`.`medicinali` (`medicinale` , `ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`scatole`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`scatole` ;

CREATE TABLE IF NOT EXISTS `mydb`.`scatole` (
  `seriale` INT NOT NULL AUTO_INCREMENT,
  `data_scadenza` DATE NOT NULL,
  `prodotto` VARCHAR(45) NOT NULL,
  `ditta` VARCHAR(45) NOT NULL,
  `ordine` INT NOT NULL,
  `vendita` INT NULL,
  `vendita_medicinalerr` INT NULL,
  `cassetto` INT NULL,
  `scaffale` INT NULL,
  `categoria` VARCHAR(45) NULL,
  `cf_cliente` VARCHAR(20) NULL,
  PRIMARY KEY (`seriale`, `prodotto`, `ditta`),
  INDEX `fk_Scatola_Prodotto1_idx` (`prodotto` ASC, `ditta` ASC),
  INDEX `fk_Scatola_Ordine1_idx` (`ordine` ASC),
  INDEX `fk_Scatola_Vendita1_idx` (`vendita` ASC),
  INDEX `fk_Scatola_VenditaMedicinaleRR1_idx` (`vendita_medicinalerr` ASC),
  INDEX `fk_Scatola_Cassetto1_idx` (`cassetto` ASC, `scaffale` ASC, `categoria` ASC),
  CONSTRAINT `fk_Scatola_Prodotto1`
    FOREIGN KEY (`prodotto` , `ditta`)
    REFERENCES `mydb`.`prodotti` (`nome_p` , `ditta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scatola_Ordine1`
    FOREIGN KEY (`ordine`)
    REFERENCES `mydb`.`ordini` (`progressivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scatola_Vendita1`
    FOREIGN KEY (`vendita`)
    REFERENCES `mydb`.`vendite` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scatola_VenditaMedicinaleRR1`
    FOREIGN KEY (`vendita_medicinalerr`)
    REFERENCES `mydb`.`vendite_medicinalirr` (`idr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Scatola_Cassetto1`
    FOREIGN KEY (`cassetto` , `scaffale` , `categoria`)
    REFERENCES `mydb`.`cassetti` (`codice_c` , `scaffale` , `categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`utenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`utenti` ;

CREATE TABLE IF NOT EXISTS `mydb`.`utenti` (
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NULL,
  `ruolo` ENUM("amministratore", "medico") NULL,
  PRIMARY KEY (`username`))
ENGINE = InnoDB;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`login`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `login` (in var_username varchar(45), in var_pass varchar(45), out var_role INT)
BEGIN
	declare var_user_role ENUM('amministratore', 'medico');
    
	select `ruolo` from `utenti`
		where `username` = var_username
        and `password` = md5(var_pass)
        into var_user_role;
        
		if var_user_role = 'amministratore' then
			set var_role = 1;
		elseif var_user_role = 'medico' then
			set var_role = 2;
		else
			set var_role = 3;
		end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crea_ordine
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`crea_ordine`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `crea_ordine` (IN var_prodotto VARCHAR(45),IN var_ditta VARCHAR(45), IN var_quantita int, out var_progressivo int)
BEGIN
	insert into `ordini` (`prodotto`, `ditta`, `quantita`, `data`) values (var_prodotto, var_ditta, var_quantita, curdate());
    
    set var_progressivo = last_insert_id();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure lista_ordini_pendenti
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`lista_ordini_pendenti`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `lista_ordini_pendenti`()
BEGIN
	set transaction isolation level read committed;
    start transaction;
    
		SELECT `progressivo`, `data`, `quantita`, `prodotto`, `ditta` 
        FROM `ordini` 
        WHERE `evaso` is null;
        
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure lista_ordini_evasi
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`lista_ordini_evasi`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `lista_ordini_evasi` ()
BEGIN
    set transaction isolation level read committed;
    start transaction;

		SELECT `progressivo`, `data`, `quantita`, `prodotto`, `ditta` 
        FROM `ordini` 
        WHERE `evaso` = 1;
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_order_info
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`get_order_info`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `get_order_info` (IN var_prog INT, OUT var_prodotto VARCHAR(45), OUT var_ditta VARCHAR(45), OUT var_quantita INT, OUT is_med INT, OUT var_cat varchar(45))
BEGIN
	
    declare var_prof tinyint;
    declare var_evaso tinyint;
    
    declare exit handler for sqlexception
    begin
        rollback; 
        resignal; 
    end;
    
    /*repeatable read per update e due letture*/
    
    set transaction isolation level repeatable read;
    start transaction;

		SELECT `prodotto`, `ditta`, `quantita`, `evaso`
		FROM `ordini`
		WHERE `progressivo` = var_prog
		INTO var_prodotto, var_ditta, var_quantita, var_evaso;
		
		/*order already served*/
		if var_evaso is not null then
			signal sqlstate '45006';
		end if;
		
		/*wrong prog*/
		 if var_prodotto is null then
			signal sqlstate '45007';
		end if;
		
		SELECT `profumeria`
		from `prodotti`
		where `nome_p` = var_prodotto and `ditta` = var_ditta
		into var_prof;
		
		UPDATE `ordini` set `evaso` = 1 WHERE `progressivo` = var_prog;
		
		if var_prof = 1 then
			set is_med = 0;
		else
			set is_med = 1;
			select `categoria`
			from `medicinali`
			where `medicinale` = var_prodotto and `ditta` = var_ditta
			into var_cat;
		end if;
		
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_scatola_profumeria
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`registra_scatola_profumeria`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `registra_scatola_profumeria` (IN var_prodotto VARCHAR(45), in var_ditta varchar(45), in var_data_scadenza date, in var_prog int)
BEGIN
    
	insert into `scatole` (`prodotto`, `ditta`,`data_scadenza`, `ordine`) 
    values (var_prodotto, var_ditta, var_data_scadenza, var_prog);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_scatola_medicinale
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`registra_scatola_medicinale`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `registra_scatola_medicinale` (IN var_prodotto VARCHAR(45), in var_ditta varchar(45), in var_data_scadenza date, in var_prog int, in var_cas int, in var_scaf int, in var_cat varchar(45))
BEGIN
	insert into `scatole` (`prodotto`, `ditta`,`data_scadenza`, `ordine`, `cassetto`, `scaffale`, `categoria`) 
    values (var_prodotto, var_ditta, var_data_scadenza, var_prog, var_cas, var_scaf, var_cat);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuovo_medicinale
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuovo_medicinale`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuovo_medicinale` (IN var_nome varchar(45), IN var_ditta VARCHAR(45), in var_mutuabile int, in var_rr int, in var_cat varchar(45))
BEGIN

	declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    set transaction isolation level read uncommitted;
    start transaction;

		insert into `prodotti` (`nome_p`, `ditta`, `profumeria`) 
		values (var_nome, var_ditta, NULL);
		
		insert into `medicinali` (`medicinale`, `ditta`, `mutuabile`,`rr`, `categoria`)
		values(var_nome, var_ditta, var_mutuabile, var_rr, var_cat);
		
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuovo_profumeria
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuovo_profumeria`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuovo_profumeria` (IN var_nome varchar(45), IN var_ditta VARCHAR(45))
BEGIN
	insert into `prodotti` (`nome_p`, `ditta`, `profumeria`) 
    values (var_nome, var_ditta, true);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuova_categoria
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuova_categoria`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuova_categoria` (IN var_nome varchar(45))
BEGIN
	insert into `categorie` (`nome`) values (var_nome);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_categorie
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_categorie`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_categorie` ()
BEGIN
	set transaction isolation level read committed;
    start transaction;
    
		select `nome`
		from `categorie`;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_interazione
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_interazione`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_interazione` (IN var_nome_uno varchar(45), IN var_nome_due varchar(45))
BEGIN
	insert into `interazioni` (`categoria_uno`, `categoria_due`) values (var_nome_uno, var_nome_due);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuova_ditta
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuova_ditta`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuova_ditta` (IN var_nome varchar(45))
BEGIN
	insert into `ditte` (`nome_d`) values (var_nome);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuovo_indirizzo
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuovo_indirizzo`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuovo_indirizzo` (IN var_citta varchar(45), IN var_via VARCHAR(45), IN var_civico varchar(10), IN var_cap INT, IN var_ditta varchar(45), in var_fat tinyint, in var_rec tinyint)
BEGIN
	insert into `indirizzi` (`citta`, `via`, `civico`, `cap`, `ditta`, `fatturazione`, `recapito`) 
    values (var_citta, var_via, var_civico, var_cap, var_ditta, var_fat, var_rec);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuovo_com
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuovo_com`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuovo_com` (IN var_contatto varchar(45), IN var_tipologia VARCHAR(45), IN var_ditta VARCHAR(45),IN var_pref tinyint)
BEGIN
	insert into `comunicazioni` (`contatto`, `tipologia`, `ditta`, `preferito`) 
    values (var_contatto, var_tipologia, var_ditta, var_pref);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_nuovo_utilizzo
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_nuovo_utilizzo`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_nuovo_utilizzo` (IN var_nome varchar(45))
BEGIN
	insert into `utilizzi` (`nome_u`) values (var_nome);
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_prodotti
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_prodotti`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_prodotti` ()
BEGIN 

	set transaction isolation level read committed;
    start transaction;
    
		select `nome_p`, `ditta`
		from `prodotti`;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_previsione
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`inserisci_previsione`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `inserisci_previsione` (IN var_prodotto varchar(45), IN var_ditta varchar(45), IN var_utilizzo varchar(45))
BEGIN
	insert into `previsioni` (`prodotto`, `ditta`, `utilizzo`) values (var_prodotto, var_ditta, var_utilizzo);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_vendita
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`registra_vendita`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `registra_vendita` (out var_id int)
BEGIN
	insert into `vendite` (`giorno`) 
    values (current_date());
    
    set var_id = last_insert_id();
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_product_info
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`get_product_info`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `get_product_info` (IN var_prodotto VARCHAR(45), IN var_ditta VARCHAR(45), OUT is_prof INT, OUT is_rr INT)
BEGIN
	declare var_prof tinyint;
    declare var_c int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    /*read committed perchè anche se leggo più volte
		quella tabella non viene toccato dopo un inserimento*/
    
    set transaction isolation level read committed;
    start transaction;
    
    /*controllo se prodotto esiste, se sono presenti scatole e se non sono in scadenza*/
		select count(`s`.`seriale`)
		from `prodotti` as `p` right join `scatole` as `s` on 
			`p`.`nome_p` = `s`.`prodotto` and `p`.`ditta` = `s`.`ditta`
		where `s`.`prodotto` = var_prodotto and `s`.`ditta` = var_ditta 
				and `s`.`vendita` is null and (datediff(`s`.`data_scadenza`, current_date()) > 90)
		into var_c;
		
		if var_c = 0 or var_c is null then
			signal sqlstate '45009';
		end if;

		SELECT `profumeria`
		from `prodotti`
		where `nome_p` = var_prodotto and `ditta` = var_ditta
		into var_prof;
		
		if var_prof = 1 then
			set is_prof = 1;
		else
			set is_prof = 0;
			SELECT  `rr`
			FROM `medicinali`
			WHERE `medicinale` = var_prodotto and `ditta` = var_ditta
			INTO is_rr;
		end if;
		
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_scatole_pendenti
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_scatole_pendenti`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_scatole_pendenti` (in var_prod varchar(45), in var_ditta varchar(45))
BEGIN
	
    set transaction isolation level read committed;
    start transaction;

		select `seriale`
		from `scatole`
		where `prodotto` = var_prod and `ditta` = var_ditta
				and `vendita` is null
                and (datediff(`data_scadenza`, current_date()) > 90);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure vendita_scatola_prof
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`vendita_scatola_prof`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `vendita_scatola_prof` (in var_prodotto varchar(45),in var_ditta varchar(45), in var_seriale int, in var_vendita int)
BEGIN

	declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
	set transaction isolation level repeatable read;
    start transaction;

		if var_seriale not in 
						(select `seriale`
						from `scatole`
						where `prodotto` = var_prodotto and `ditta` = var_ditta
							   and `vendita` is null
                               and datediff(`data_scadenza`, current_date()) > 90) then
			signal sqlstate '45011';
		end if;

		 UPDATE `scatole` set `vendita` = var_vendita
		 WHERE `prodotto` = var_prodotto and
				`ditta` = var_ditta and
				`seriale` = var_seriale;
            
	commit;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure vendita_scatola_med
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`vendita_scatola_med`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `vendita_scatola_med` (in var_prodotto varchar(45),in var_ditta varchar(45), in var_seriale int, in cf varchar(20), in var_vendita int, in var_venditarr int)
BEGIN

	declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    
    set transaction isolation level repeatable read;
    start transaction;
    
		if var_seriale not in 
						(select `seriale`
						from `scatole`
						where `prodotto` = var_prodotto and `ditta` = var_ditta
							   and `vendita` is null
                               and datediff(`data_scadenza`, current_date()) > 90) then
			signal sqlstate '45011';
		end if;
		
		if var_venditarr is not null then
			if var_venditarr not in (select `idr`
									from `vendite_medicinalirr`
									where `medicinale` = var_prodotto and `ditta` = var_ditta
											and `vendita` = var_vendita) then
				signal sqlstate '45012';
			
			end if;
		end if;
		
		 UPDATE `scatole` set `vendita` = var_vendita
				, `vendita_medicinalerr` = var_venditarr
				, `cf_cliente` = cf
				, `cassetto` = null
				, `scaffale` = null
				, `categoria` = null
		 WHERE `prodotto` = var_prodotto and
				`ditta` = var_ditta and
				`seriale` = var_seriale;
				
	commit;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_venditerr_relative
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_venditerr_relative`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_venditerr_relative` (in var_prod varchar(45), in var_ditta varchar(45), in var_id int)
BEGIN

	set transaction isolation level read committed;
    start transaction;

		select `idr`, `giorno_p`, `medico`
		from `vendite_medicinalirr`
		where `medicinale` = var_prod and `ditta` = var_ditta
				and `vendita` = var_id;
            
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure registra_vendita_rr
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`registra_vendita_rr`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `registra_vendita_rr` (in var_prod varchar(45), in var_ditta varchar(45), in var_saleid int, IN var_date date, IN var_dottore VARCHAR(45), out var_id int)
BEGIN
	insert into `vendite_medicinalirr` (`giorno_p`, `medico`, `medicinale`, `ditta`, `vendita`) 
    values (var_date, var_dottore, var_prod, var_ditta, var_saleid);
    
    set var_id = last_insert_id();
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure report_scatole_scadenza
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`report_scatole_scadenza`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `report_scatole_scadenza` ()
BEGIN
	declare var_days int;
    declare var_ser int;
    declare var_ditta varchar(45);
    declare var_prodotto varchar(45);
    declare done int default false;
    declare cur cursor for select datediff(`s`.`data_scadenza`, current_date()), `s`.`prodotto`, `s`.`ditta`, `s`.`seriale`
							from `scatole` as `s` 
                            join `medicinali` as `m` on (`s`.`prodotto` = `m`.`medicinale` and `s`.`ditta` = `m`.`ditta`) 
                            where `s`.`vendita` is null;
    
    declare continue handler for not found set done = true;
    
    declare exit handler for sqlexception
    begin
        rollback;  
        resignal; 
    end;
    
    drop temporary table if exists `scatole_scadenza`;
    create temporary table `scatole_scadenza` (
		`seriale` int,
        `prodotto` varchar(45),
        `ditta` varchar(45),
        `cassetto` int,
        `scaffale` int,
        `categoria` varchar(45)
    
    );
    
    
    
    set transaction isolation level repeatable read;
    start transaction;

		open cur;
		
		read_loop: loop
		
			fetch cur into var_days, var_prodotto, var_ditta, var_ser;
			if done then 
				leave read_loop;
			end if;
			
			if (var_days < 90) then
			
				insert into `scatole_scadenza`
				select `seriale`, `prodotto`, `ditta`, `cassetto`, `scaffale`, `categoria`
				from `scatole`
				where `prodotto` = var_prodotto and `ditta` = var_ditta and `seriale` = var_ser;
				
				DELETE FROM `scatole`
				WHERE `prodotto` = var_prodotto and `ditta` = var_ditta and `seriale` = var_ser;

			end if;
		
		end loop;
		close cur;
		
		select * from `scatole_scadenza`;
    
    commit;
    
    drop temporary table `scatole_scadenza`;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure report_vendite_medicinali_rr
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`report_vendite_medicinali_rr`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `report_vendite_medicinali_rr` ()
BEGIN
	declare var_idr int;
    declare done int default false;
    declare cur cursor for select `idr` from `vendite_medicinalirr`;
    declare continue handler for not found set done = true;
    
    declare exit handler for sqlexception
    begin
        rollback;  
        resignal; 
    end;
    
    set transaction isolation level repeatable read;
    start transaction;

		open cur;
		
		read_loop: loop
		
			fetch cur into var_idr;
			if done then 
				leave read_loop;
			end if;
			
			select * 
            from `vendite_medicinalirr` 
            where `idr` = var_idr;
				
			select `seriale`
			from `scatole`
			where `vendita_medicinalerr` = var_idr;

		end loop;
		close cur;
		
    commit;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure report_giacenze_med
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`report_giacenze_med`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `report_giacenze_med` ()
BEGIN
    
    /*faccio vedere anche le scatole di prodotti esauriti*/
    set transaction isolation level read committed;
    start transaction;

		select `m`.`medicinale`, `m`.`ditta`, count(`s`.`seriale`) as `Rimanenti`
		from `scatole` as `s` right join `medicinali` as `m` on 
			`s`.`prodotto` = `m`.`medicinale` and `s`.`ditta` = `m`.`ditta`
		where `s`.`vendita` is null
        group by `m`.`medicinale`, `m`.`ditta`
		having `Rimanenti` < 3
		order by `Rimanenti` desc;
		
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_posizioni_disponibili
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_posizioni_disponibili`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_posizioni_disponibili` (in var_cat varchar(45))
BEGIN     

	set transaction isolation level read committed;
    start transaction;
    
		select `c`.`scaffale` as `Scaffale`, `c`.`codice_c` as `Cassetto`
		from `scatole`as `s` right join `cassetti` as `c` 
			on (`c`.`codice_c` = `s`.`cassetto` and `c`.`scaffale` = `s`.`scaffale`
				and `c`.`categoria` = `s`.`categoria`)
		where `c`.`categoria` = var_cat and (`s`.`cassetto` is null 
											and `s`.`scaffale` is null
											and `s`.`categoria` is null)
		order by `Scaffale`, `Cassetto`;
                                        
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure imposta_recapito
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`imposta_recapito`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `imposta_recapito` (in var_citta varchar(45), in var_via varchar(45), in var_civico varchar(11), in var_cap int, in var_ditta varchar(45))
BEGIN
	
    declare var_addr int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    
    /*read committed*/
    set transaction isolation level read committed;
    start transaction;
    
		select count(*)
		from `indirizzi`
		where `ditta` = var_ditta and `citta` = var_citta
				and `via` = var_via and `civico` = var_civico and `cap` = var_cap
		into var_addr;
		
		if var_addr = 1 then
		
			UPDATE `indirizzi` SET `recapito`= true 
					where `ditta` = var_ditta and `citta` = var_citta
					and `via` = var_via and `civico` = var_civico and `cap` = var_cap;
		else
			signal sqlstate '45014';
		end if;
		
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_indirizzi_ditta
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_indirizzi_ditta`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_indirizzi_ditta` (in var_ditta varchar(45))
BEGIN
    
    set transaction isolation level read committed;
    start transaction;
		
		select `citta`, `via`, `civico`, `cap`
		from `indirizzi`
		where `ditta` = var_ditta;
    commit;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure imposta_fatturazione
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`imposta_fatturazione`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `imposta_fatturazione` (in var_citta varchar(45), in var_via varchar(45), in var_civico varchar(11), in var_cap int, in var_ditta varchar(45))
BEGIN
	
    declare var_addr int;
    
    declare exit handler for sqlexception
    begin
        rollback; 
        resignal;
    end;

    
    set transaction isolation level read committed;
    start transaction;
    
		select count(*)
		from `indirizzi`
		where `ditta` = var_ditta and `citta` = var_citta
				and `via` = var_via and `civico` = var_civico and `cap` = var_cap
		into var_addr;
		
		if var_addr = 1 then
		
			UPDATE `indirizzi` SET `fatturazione`= true 
					where `ditta` = var_ditta and `citta` = var_citta
					and `via` = var_via and `civico` = var_civico and `cap` = var_cap;
		else
			signal sqlstate '45014';
		end if;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_com_ditta
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_com_ditta`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_com_ditta` (in var_ditta varchar(45))
BEGIN
    
     set transaction isolation level read committed;
     start transaction;
    
		select `contatto`, `tipologia`
		from `comunicazioni`
		where `ditta` = var_ditta;
		

	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure imposta_preferito
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`imposta_preferito`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `imposta_preferito` (in var_contatto varchar(45), in var_ditta varchar(45))
BEGIN
	
    declare var_com int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    /*faccio questo solo in inserimento nessuno può interferire*/
    set transaction isolation level read committed;
    start transaction;
    
		select count(*)
		from `comunicazioni`
		where `ditta` = var_ditta and `contatto` = var_contatto
		into var_com;
		
		if var_com = 1 then
			UPDATE `comunicazioni` SET `preferito`= true 
					where `ditta` = var_ditta and `contatto` = var_contatto;
		else
			signal sqlstate '45015';
		end if;
		
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure mostra_ditte
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`mostra_ditte`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mostra_ditte` ()
BEGIN
	set transaction isolation level read committed;
    start transaction;
    
		select `nome_d`
		from `ditte`;
    
    commit;
END$$

DELIMITER ;
USE `mydb`;

DELIMITER $$

USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`interazioni_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`interazioni_BEFORE_INSERT` BEFORE INSERT ON `interazioni` FOR EACH ROW
BEGIN
	declare cat_uno varchar(45);
    declare cat_due varchar(45);
    declare done int default false;
    declare cur cursor for select `categoria_uno`, `categoria_due` from `interazioni`;
    declare continue handler for not found set done = true;
    
	open cur;
	read_loop: loop
	
		fetch cur into cat_uno, cat_due;
		if done then
			leave read_loop;
		end if;
		
		if cat_uno = new.`categoria_due` and cat_due = new.`categoria_uno` then
			signal sqlstate '45008';
		end if;
		
	end loop;
	close cur;

END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`ordini_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`ordini_BEFORE_INSERT` BEFORE INSERT ON `ordini` FOR EACH ROW
BEGIN
	if new.`quantita` > 300 or new.`quantita` < 1 then
		signal sqlstate '45000';
	end if;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`vendite_medicinalirr_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`vendite_medicinalirr_BEFORE_INSERT` BEFORE INSERT ON `vendite_medicinalirr` FOR EACH ROW
BEGIN
	
    declare var_giornov date;
    
    select `giorno`
    from `vendite`
    where `id` = new.`vendita`
    into var_giornov;

	if ((datediff(var_giornov, new.`giorno_p`) > 30) or
		(datediff(new.`giorno_p`, var_giornov) > 0)) then
		signal sqlstate '45012';
	end if;
END$$


USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`scatole_BEFORE_INSERT` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`scatole_BEFORE_INSERT` BEFORE INSERT ON `scatole` FOR EACH ROW
BEGIN
 
	if new.`categoria` is not null then
        
        if (select count(*) 
			from `scatole`
			where `cassetto` = new.`cassetto` and `scaffale` = new.`scaffale`
					and `categoria` = new.`categoria`) = 1 then
              signal sqlstate '45002';
		end if;
       
	end if;
    
    /*anche per prodotti di profumeria*/
   
	 if datediff(new.`data_scadenza`, current_date()) < 90 then
		signal sqlstate '45001';
	 end if;
END$$


DELIMITER ;
SET SQL_MODE = '';
GRANT USAGE ON *.* TO login;
 DROP USER login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'login' IDENTIFIED BY 'login';

GRANT EXECUTE ON procedure `mydb`.`login` TO 'login';
SET SQL_MODE = '';
GRANT USAGE ON *.* TO medico;
 DROP USER medico;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'medico' IDENTIFIED BY 'medico';

GRANT EXECUTE ON procedure `mydb`.`inserisci_nuovo_medicinale` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`inserisci_nuovo_profumeria` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`inserisci_nuova_categoria` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`mostra_categorie` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`inserisci_interazione` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`registra_vendita` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`get_product_info` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`mostra_scatole_pendenti` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`vendita_scatola_prof` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`mostra_venditerr_relative` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`registra_vendita_rr` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`vendita_scatola_med` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`mostra_prodotti` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`report_vendite_medicinali_rr` TO 'medico';
GRANT EXECUTE ON procedure `mydb`.`mostra_ditte` TO 'medico';
SET SQL_MODE = '';
GRANT USAGE ON *.* TO amministratore;
 DROP USER amministratore;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'amministratore' IDENTIFIED BY 'amministratore';

GRANT EXECUTE ON procedure `mydb`.`crea_ordine` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`lista_ordini_pendenti` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`get_order_info` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`registra_scatola_profumeria` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`registra_scatola_medicinale` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`inserisci_nuova_ditta` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`inserisci_nuovo_indirizzo` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`inserisci_nuovo_com` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`inserisci_nuovo_utilizzo` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`mostra_prodotti` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`inserisci_previsione` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`report_scatole_scadenza` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`report_vendite_medicinali_rr` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`report_giacenze_med` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`mostra_posizioni_disponibili` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`imposta_recapito` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`mostra_indirizzi_ditta` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`imposta_fatturazione` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`mostra_com_ditta` TO 'amministratore';
GRANT EXECUTE ON procedure `mydb`.`imposta_preferito` TO 'amministratore';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `mydb`.`ditte`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('pfizer');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('bayer');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('rabanne');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('gucci');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('astrazeneca');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('dior');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('menarini');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('molteni');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('zambon');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('angelini');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('pharma');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('kedrion');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('savio');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('italfarmaco');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('alfasigma');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('recordati');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('mediolanum');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('rottapharm');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('guidotti');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('falqui');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('ogna');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('johnson&johnson');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('moderna');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('collistar');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('avon');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('pupa');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('vichy');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('clinique');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('shiseido');
INSERT INTO `mydb`.`ditte` (`nome_d`) VALUES ('oreal');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`indirizzi`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('canneto di rodi', 'borgo sabotino', '1', 04100, NULL, NULL, 'bayer');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('industriale', 'montoro', '12', 05035, 1, 1, 'bayer');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('ludovico il moro', 'basiglio', '6c', 20080, 1, 1, 'astrazeneca');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('ulivo', 'roma', '22', 00187, 1, 1, 'dior');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('tito speri', 'pomezia', '12', 00040, 1, NULL, 'menarini');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('sette santi', 'firenze', '1', 50131, NULL, 1, 'menarini');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('ilio barontini', 'firenze', '8', 50018, 1, 1, 'molteni');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('lillo del duca', 'bresso', '10', 20091, 1, 1, 'zambon');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('guardapasso', 'aprilia', '1', 04011, 1, NULL, 'angelini');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('francesco angelini', 'pomezia', '1', 00040, NULL, NULL, 'angelini');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('torrenova', 'roma', '435', 00133, NULL, 1, 'angelini');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('reali', 'pomezia', '5', 04011, 1, 1, 'pharma');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('vittorio veneto', 'roma', '7', 00187, 1, NULL, 'kedrion');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('per il ciocco', 'barga', '1', 55051, NULL, 1, 'kedrion');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('del mare', 'pomezia', '36', 00071, 1, 1, 'savio');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('belluno', 'roma', '1', 00161, 1, 1, 'italfarmaco');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('fulvio testi', 'milano', '330', 20126, NULL, NULL, 'italfarmaco');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('enrico fermi', 'alanno', '1', 65020, 1, NULL, 'alfasigma');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('pontinia', 'pomezia', '30', 00071, NULL, 1, 'alfasigma');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('mediana', 'aprilia', '4', 04011, 1, 1, 'recordati');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('giuseppe cottolengo', 'milano', '15', 20143, 1, 1, 'mediolanum');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('valosa di sopra', 'monza', '9', 20900, 1, 1, 'rottapharm');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('guglielmo marconi', 'sustinente', '268', 46030, 1, 1, 'guidotti');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('fabio filzi', 'milano', '8', 20124, 1, NULL, 'falqui');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('roma', 'recco', '8', 16036, NULL, 1, 'falqui');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('figini', 'muggio', '41', 20835, 1, 1, 'ogna');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('ardeatina', 'pomezia', '23', 00071, 1, NULL, 'johnson&johnson');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('janssen', 'latina', '3', 04100, NULL, 1, 'johnson&johnson');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('corso', 'fiuggi', '51', 03014, 1, NULL, 'rabanne');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('vittorio emanuele', 'anagni', '144', 03012, NULL, 1, 'rabanne');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('condotti', 'roma', '8', 00187, 1, 1, 'gucci');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('tritone', 'roma', '61', 00187, NULL, NULL, 'gucci');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('francesco di fuori', 'alatri', '2', 03011, 1, NULL, 'moderna');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('brighindi', 'frosinone', '23', 03100, NULL, 1, 'moderna');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('capo i prati', 'fiuggi', '60', 03014, 1, 1, 'collistar');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('frattarotonda vado largo', 'anagni', '1', 03012, 1, NULL, 'avon');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('del municipio', 'spoleto', '2', 06049, NULL, 1, 'avon');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('della pace', 'valmontone', '1', 00038, 1, NULL, 'pupa');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('ss87', 'marcianise', '3', 81020, NULL, 1, 'pupa');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('del comune', 'trevi nel lazio', '34', 03010, 1, 1, 'vichy');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('tritone', 'roma', '62', 00187, 1, 1, 'clinique');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('fontego dei tedeschi', 'venezia', '4', 30100, NULL, 1, 'shiseido');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('eliseo', 'isola liri', '230', 03036, 1, NULL, 'shiseido');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('della pace', 'valmontone', '23', 00038, NULL, NULL, 'oreal');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('mignanelli', 'roma', '23', 00187, 1, 1, 'oreal');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('valbondione', 'roma', '113', 00188, 1, 1, 'pfizer');
INSERT INTO `mydb`.`indirizzi` (`via`, `citta`, `civico`, `cap`, `fatturazione`, `recapito`, `ditta`) VALUES ('del commercio', 'ascoli piceno', '25', 63100, NULL, NULL, 'pfizer');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`comunicazioni`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('astra@gmail', 'mail', 1, 'astrazeneca');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3343554690', 'telefono', NULL, 'astrazeneca');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('pfizer@hotmail.com', 'mail', 1, 'pfizer');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3324323456', 'telefono', NULL, 'pfizer');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3345235322', 'fax', NULL, 'pfizer');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('bayer@mail.com', 'mail', NULL, 'bayer');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3343234322', 'telefono', 1, 'bayer');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('pacorabanne@gmail.com', 'mail', 1, 'rabanne');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('guccicontacts@mail.com', 'mail', 1, 'gucci');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('diorsales@mail.com', 'mail', 1, 'dior');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('menarini@menarini.it', 'mail', 1, 'menarini');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3343434332', 'telefono', NULL, 'menarini');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('molteni@molteni.it', 'mail', 1, 'molteni');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('zambon@hotmail.com', 'mail', 1, 'zambon');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('angelinicontacts@angelini.it', 'mail', 1, 'angelini');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('angelinisales@angelini.it', 'mail', NULL, 'angelini');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3348909652', 'telefono', NULL, 'angelini');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3423456788', 'fax', NULL, 'angelini');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('pharma@mail.it', 'mail', 1, 'pharma');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('kedrionitaly@gmail.com', 'mail', 1, 'kedrion');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('savio@itmail.it', 'mail', 1, 'savio');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('italfarmacocontacts@italfarmaco.it', 'mail', 1, 'italfarmaco');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('0776876765', 'telefono', NULL, 'italfarmaco');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('alfasigma@gmail.com', 'mail', 1, 'alfasigma');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('recordati@rec.com', 'mail', 1, 'recordati');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('medcontacts@mediolanum.it', 'mail', 1, 'mediolanum');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('rottapharm@mail.com', 'mail', 1, 'rottapharm');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('guidotticontacts@gmail.com', 'mail', 1, 'guidotti');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('falqui@falqui.it', 'mail', 1, 'falqui');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('33456763745', 'telefono', NULL, 'falqui');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3345672345', 'fax', NULL, 'falqui');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('ogna@outlook.com', 'mail', 1, 'ogna');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('johnson&johnson@jj.com', 'mail', 1, 'johnson&johnson');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3343456765', 'telefono', NULL, 'johnson&johnson');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3356765675', 'fax', NULL, 'johnson&johnson');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('moderna@moderna.it', 'mail', 1, 'moderna');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3323434567', 'telefono', NULL, 'moderna');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('collistar@collistar.it', 'mail', 1, 'collistar');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3376876453', 'telefono', NULL, 'collistar');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('avonsales@avon.com', 'mail', 1, 'avon');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3345434566', 'telefono', NULL, 'avon');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('pupamilano@pupa.it', 'mail', 1, 'pupa');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3345434567', 'telefono', NULL, 'pupa');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('vichy@mail.fr', 'mail', 1, 'vichy');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('clinique@gmail.com', 'mail', 1, 'clinique');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('shiseido@shiseido.it', 'mail', 1, 'shiseido');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3345445678', 'telefono', NULL, 'shiseido');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3345677875', 'fax', NULL, 'shiseido');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('oreal@oreal.fr', 'mail', 1, 'oreal');
INSERT INTO `mydb`.`comunicazioni` (`contatto`, `tipologia`, `preferito`, `ditta`) VALUES ('3347657876', 'telefono', NULL, 'oreal');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`prodotti`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('aspirina', NULL, 'bayer');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('one million', 1, 'rabanne');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('comirnaty', NULL, 'pfizer');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('uomo', 1, 'gucci');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('oki', NULL, 'bayer');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('amlodipina', NULL, 'pfizer');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('azitromicina', NULL, 'pfizer');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('xanax', NULL, 'pfizer');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('vaxzevria', NULL, 'astrazeneca');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('elvive wonder', 1, 'oreal');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('revitalift', 1, 'oreal');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('whale', 1, 'pupa');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('bois argent', 1, 'dior');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('prostamol', NULL, 'menarini');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('sustenium plus', NULL, 'menarini');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('vivinduo', NULL, 'menarini');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('tantum verde', NULL, 'angelini');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('moment act', NULL, 'angelini');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('tachipirina', NULL, 'angelini');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('uomo', 1, 'dior');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('decadron', NULL, 'savio');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('inofert plus', NULL, 'italfarmaco');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('biochetasi', NULL, 'alfasigma');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('smoothing body', 1, 'shiseido');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('extra rich', 1, 'shiseido');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('gel anticellulite', 1, 'collistar');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('gel anticellulite', 1, 'vichy');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('superabbronzante', 1, 'collistar');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('crema termale', 1, 'shiseido');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('cargo cardio', NULL, 'recordati');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('glucocare', NULL, 'falqui');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('crema termale', 1, 'collistar');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('janssen', NULL, 'johnson&johnson');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('nizoral', 1, 'johnson&johnson');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('spikevax', NULL, 'moderna');
INSERT INTO `mydb`.`prodotti` (`nome_p`, `profumeria`, `ditta`) VALUES ('crema termale', 1, 'avon');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`utilizzi`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('malattie da raffreddamento');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('dolori alle ossa');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('detergente per viso');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('detergente per corpo');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('stress');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('pressione alta');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('detergente per capelli');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('mal di testa');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('fragranza');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('prevenzione covid');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('scompensi alimentari');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('mal di gola');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('problemi intestinali');
INSERT INTO `mydb`.`utilizzi` (`nome_u`) VALUES ('malattie cardiovascolari');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`previsioni`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('amlodipina', 'pfizer', 'pressione alta');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('azitromicina', 'pfizer', 'malattie da raffreddamento');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('revitalift', 'oreal', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('elvive wonder', 'oreal', 'detergente per capelli');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('whale', 'pupa', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('aspirina', 'bayer', 'malattie da raffreddamento');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('aspirina', 'bayer', 'mal di testa');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('oki', 'bayer', 'mal di testa');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('oki', 'bayer', 'stress');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('one million', 'rabanne', 'fragranza');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('uomo', 'gucci', 'fragranza');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('comirnaty', 'pfizer', 'prevenzione covid');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('vaxzevria', 'astrazeneca', 'prevenzione covid');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('bois argent', 'dior', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('sustenium plus', 'menarini', 'scompensi alimentari');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('prostamol', 'menarini', 'scompensi alimentari');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('vivinduo', 'menarini', 'malattie da raffreddamento');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('tantum verde', 'angelini', 'mal di gola');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('moment act', 'angelini', 'mal di testa');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('moment act', 'angelini', 'stress');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('tachipirina', 'angelini', 'malattie da raffreddamento');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('tachipirina', 'angelini', 'mal di testa');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('uomo', 'dior', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('decadron', 'savio', 'mal di testa');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('inofert plus', 'italfarmaco', 'mal di testa');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('biochetasi', 'alfasigma', 'problemi intestinali');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('smoothing body', 'shiseido', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('extra rich', 'shiseido', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('gel anticellulite', 'vichy', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('gel anticellulite', 'collistar', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('crema termale', 'collistar', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('crema termale', 'shiseido', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('superabbronzante', 'collistar', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('cargo cardio', 'recordati', 'malattie cardiovascolari');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('glucocare', 'falqui', 'malattie cardiovascolari');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('janssen', 'johnson&johnson', 'prevenzione covid');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('nizoral', 'johnson&johnson', 'detergente per corpo');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('spikevax', 'moderna', 'prevenzione covid');
INSERT INTO `mydb`.`previsioni` (`prodotto`, `ditta`, `utilizzo`) VALUES ('crema termale', 'avon', 'detergente per corpo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`categorie`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antibiotico');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('vaccino');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antinfluenzale');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antiinfiammatorio');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('ansiolitico');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antiipertensivo');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('integratore alimentare');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antipiretico');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('vitamina minerale');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antiaggregante');
INSERT INTO `mydb`.`categorie` (`nome`) VALUES ('antidiabetico');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`medicinali`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'aspirina', 'bayer', 'antiinfiammatorio');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'comirnaty', 'pfizer', 'vaccino');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'oki', 'bayer', 'antiinfiammatorio');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'xanax', 'pfizer', 'ansiolitico');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'azitromicina', 'pfizer', 'antibiotico');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'amlodipina', 'pfizer', 'antiipertensivo');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'vaxzevria', 'astrazeneca', 'vaccino');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'prostamol', 'menarini', 'integratore alimentare');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'vivinduo', 'menarini', 'antibiotico');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'sustenium plus', 'menarini', 'integratore alimentare');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'tantum verde', 'angelini', 'antiinfiammatorio');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'moment act', 'angelini', 'antibiotico');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'tachipirina', 'angelini', 'antipiretico');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, NULL, 'decadron', 'savio', 'antiinfiammatorio');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'inofert plus', 'italfarmaco', 'integratore alimentare');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (NULL, NULL, 'biochetasi', 'alfasigma', 'vitamina minerale');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'cargo cardio', 'recordati', 'antiaggregante');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'glucocare', 'falqui', 'antidiabetico');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'janssen', 'johnson&johnson', 'vaccino');
INSERT INTO `mydb`.`medicinali` (`mutuabile`, `rr`, `medicinale`, `ditta`, `categoria`) VALUES (1, 1, 'spikevax', 'moderna', 'vaccino');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`interazioni`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antibiotico', 'antiinfiammatorio');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antibiotico', 'antinfluenzale');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('ansiolitico', 'antiipertensivo');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antiaggregante', 'antidiabetico');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antipiretico', 'antinfluenzale');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antinfluenzale', 'antiinfiammatorio');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('vaccino', 'antinfluenzale');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antiinfiammatorio', 'antiaggregante');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('vitamina minerale', 'integratore alimentare');
INSERT INTO `mydb`.`interazioni` (`categoria_uno`, `categoria_due`) VALUES ('antipiretico', 'antiinfiammatorio');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`scaffali`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'vaccino');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (2, 'antibiotico');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (3, 'antinfluenzale');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (2, 'vaccino');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (3, 'vaccino');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'antiinfiammatorio');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'antibiotico');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'antipiretico');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'antiaggregante');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'vitamina minerale');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'integratore alimentare');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'antiipertensivo');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (2, 'antiipertensivo');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'ansiolitico');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (2, 'ansiolitico');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (2, 'antiinfiammatorio');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (1, 'antidiabetico');
INSERT INTO `mydb`.`scaffali` (`codice_s`, `categoria`) VALUES (3, 'antibiotico');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`cassetti`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 2, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 3, 'antinfluenzale');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 2, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 2, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 2, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 3, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 3, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 3, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (6, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (7, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (8, 1, 'vaccino');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'antipiretico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'antipiretico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'antipiretico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 1, 'antipiretico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 1, 'antipiretico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'antiaggregante');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'antiaggregante');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'antiaggregante');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 1, 'antiaggregante');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 1, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 1, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 2, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 2, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 2, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 2, 'ansiolitico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'vitamina minerale');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'vitamina minerale');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'vitamina minerale');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 2, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 2, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 2, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 2, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 2, 'antiipertensivo');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'integratore alimentare');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'integratore alimentare');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'integratore alimentare');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 1, 'integratore alimentare');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 1, 'integratore alimentare');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (6, 1, 'integratore alimentare');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 2, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 2, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 2, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 2, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 2, 'antiinfiammatorio');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 1, 'antidiabetico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 1, 'antidiabetico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 1, 'antidiabetico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 1, 'antidiabetico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (1, 3, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (2, 3, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (3, 3, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (4, 3, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (5, 3, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (6, 3, 'antibiotico');
INSERT INTO `mydb`.`cassetti` (`codice_c`, `scaffale`, `categoria`) VALUES (7, 3, 'antibiotico');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`ordini`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (1, '2021-07-08', 5, 'comirnaty', 'pfizer', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (2, '2021-06-04', 8, 'one million', 'rabanne', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (3, '2021-07-26', 3, 'aspirina', 'bayer', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (5, '2021-02-20', 6, 'comirnaty', 'pfizer', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (6, '2021-12-08', 5, 'oki', 'bayer', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (7, '2021-04-23', 3, 'uomo', 'gucci', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (8, '2021-03-21', 2, 'crema termale', 'shiseido', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (9, '2021-03-21', 2, 'crema termale', 'collistar', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (10, '2021-03-27', 3, 'bois argent', 'dior', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (4, '2020-09-23', 2, 'xanax', 'pfizer', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (11, '2021-07-21', 2, 'amlodipina', 'pfizer', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (12, '2021-08-20', 3, 'glucocare', 'falqui', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (13, '2021-07-30', 2, 'biochetasi', 'alfasigma', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (14, '2021-08-14', 3, 'prostamol', 'menarini', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (15, '2021-08-24', 2, 'vivinduo', 'menarini', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (16, '2021-08-21', 4, 'tantum verde', 'angelini', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (17, '2021-07-30', 2, 'janssen', 'johnson&johnson', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (18, '2021-08-15', 3, 'sustenium plus', 'menarini', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (19, '2021-08-20', 3, 'tachipirina', 'angelini', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (20, '2021-08-22', 5, 'tachipirina', 'angelini', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (21, '2021-08-23', 2, 'inofert plus', 'italfarmaco', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (22, '2021-07-23', 2, 'superabbronzante', 'collistar', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (23, '2021-06-28', 3, 'nizoral', 'johnson&johnson', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (24, '2021-08-23', 3, 'crema termale', 'avon', NULL);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (25, '2021-07-27', 3, 'extra rich', 'shiseido', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (26, '2021-08-17', 2, 'cargo cardio', 'recordati', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (27, '2021-03-17', 2, 'sustenium plus', 'menarini', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (28, '2021-07-23', 1, 'prostamol', 'menarini', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (29, '2021-08-21', 3, 'moment act', 'angelini', 1);
INSERT INTO `mydb`.`ordini` (`progressivo`, `data`, `quantita`, `prodotto`, `ditta`, `evaso`) VALUES (30, '2021-08-24', 4, 'azitromicina', 'pfizer', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`vendite`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`vendite` (`id`, `giorno`) VALUES (1, '2021-08-17');
INSERT INTO `mydb`.`vendite` (`id`, `giorno`) VALUES (2, '2021-08-15');
INSERT INTO `mydb`.`vendite` (`id`, `giorno`) VALUES (3, '2021-08-23');
INSERT INTO `mydb`.`vendite` (`id`, `giorno`) VALUES (4, '2021-08-24');
INSERT INTO `mydb`.`vendite` (`id`, `giorno`) VALUES (5, '2021-08-25');
INSERT INTO `mydb`.`vendite` (`id`, `giorno`) VALUES (6, '2021-08-25');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`vendite_medicinalirr`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`vendite_medicinalirr` (`idr`, `giorno_p`, `medico`, `vendita`, `medicinale`, `ditta`) VALUES (1, '2021-08-14', 'francini', 1, 'comirnaty', 'pfizer');
INSERT INTO `mydb`.`vendite_medicinalirr` (`idr`, `giorno_p`, `medico`, `vendita`, `medicinale`, `ditta`) VALUES (2, '2021-08-11', 'lorenzi', 2, 'comirnaty', 'pfizer');
INSERT INTO `mydb`.`vendite_medicinalirr` (`idr`, `giorno_p`, `medico`, `vendita`, `medicinale`, `ditta`) VALUES (3, '2021-08-18', 'francesi', 3, 'amlodipina', 'pfizer');
INSERT INTO `mydb`.`vendite_medicinalirr` (`idr`, `giorno_p`, `medico`, `vendita`, `medicinale`, `ditta`) VALUES (4, '2021-08-23', 'lorenzi', 4, 'glucocare', 'falqui');
INSERT INTO `mydb`.`vendite_medicinalirr` (`idr`, `giorno_p`, `medico`, `vendita`, `medicinale`, `ditta`) VALUES (5, '2021-08-24', 'crecco', 6, 'azitromicina', 'pfizer');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`scatole`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-10-24', 'one million', 'rabanne', 2, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-10-24', 'one million', 'rabanne', 2, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (4, '2022-10-24', 'one million', 'rabanne', 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (5, '2022-10-24', 'one million', 'rabanne', 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-10-24', 'one million', 'rabanne', 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-09-08', 'comirnaty', 'pfizer', 1, NULL, NULL, 1, 1, 'vaccino', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-10-02', 'comirnaty', 'pfizer', 1, NULL, NULL, 2, 1, 'vaccino', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-03-09', 'comirnaty', 'pfizer', 1, NULL, NULL, 3, 1, 'vaccino', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (4, '2022-09-08', 'comirnaty', 'pfizer', 1, NULL, NULL, 4, 1, 'vaccino', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-09-06', 'aspirina', 'bayer', 3, NULL, NULL, 1, 2, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-09-09', 'aspirina', 'bayer', 3, NULL, NULL, 2, 2, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-06-02', 'aspirina', 'bayer', 3, NULL, NULL, 3, 2, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (5, '2022-05-21', 'comirnaty', 'pfizer', 5, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (6, '2022-06-23', 'comirnaty', 'pfizer', 5, 1, 1, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (7, '2023-09-12', 'comirnaty', 'pfizer', 5, 1, 2, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (8, '2022-09-03', 'comirnaty', 'pfizer', 5, 1, 2, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-09-23', 'oki', 'bayer', 6, NULL, NULL, 1, 1, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-09-12', 'oki', 'bayer', 6, NULL, NULL, 2, 1, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2023-12-09', 'oki', 'bayer', 6, NULL, NULL, 3, 1, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (9, '2024-09-12', 'comirnaty', 'pfizer', 5, NULL, NULL, 6, 1, 'vaccino', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2023-08-12', 'crema termale', 'shiseido', 8, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-09-21', 'xanax', 'pfizer', 4, NULL, NULL, 1, 1, 'ansiolitico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-09-21', 'xanax', 'pfizer', 4, NULL, NULL, 2, 1, 'ansiolitico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-08-21', 'amlodipina', 'pfizer', 11, 3, 3, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-08-21', 'amlodipina', 'pfizer', 11, 3, 3, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2021-12-12', 'biochetasi', 'alfasigma', 13, 3, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2021-12-12', 'biochetasi', 'alfasigma', 13, 3, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-02-14', 'vivinduo', 'menarini', 15, NULL, NULL, 1, 1, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-02-14', 'vivinduo', 'menarini', 15, NULL, NULL, 2, 1, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-01-14', 'tantum verde', 'angelini', 16, NULL, NULL, 1, 2, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-01-14', 'tantum verde', 'angelini', 16, NULL, NULL, 2, 2, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-01-14', 'tantum verde', 'angelini', 16, NULL, NULL, 3, 2, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (4, '2022-01-14', 'tantum verde', 'angelini', 16, NULL, NULL, 4, 2, 'antiinfiammatorio', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-06-02', 'glucocare', 'falqui', 12, 4, 4, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-06-02', 'glucocare', 'falqui', 12, 4, 4, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-06-02', 'glucocare', 'falqui', 12, NULL, NULL, 1, 1, 'antidiabetico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-02-03', 'tachipirina', 'angelini', 19, 4, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-02-03', 'tachipirina', 'angelini', 19, 4, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-02-03', 'tachipirina', 'angelini', 19, NULL, NULL, 2, 1, 'antipiretico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-09-21', 'superabbronzante', 'collistar', 22, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-09-21', 'superabbronzante', 'collistar', 22, 4, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2023-09-20', 'nizoral', 'johnson&johnson', 23, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2023-09-20', 'nizoral', 'johnson&johnson', 23, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2023-09-20', 'nizoral', 'johnson&johnson', 23, 5, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-09-23', 'extra rich', 'shiseido', 25, 5, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2023-09-23', 'extra rich', 'shiseido', 25, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2023-09-23', 'extra rich', 'shiseido', 25, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2024-08-20', 'cargo cardio', 'recordati', 26, NULL, NULL, 1, 1, 'antiaggregante', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2024-08-20', 'cargo cardio', 'recordati', 26, NULL, NULL, 2, 1, 'antiaggregante', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-02-21', 'sustenium plus', 'menarini', 27, NULL, NULL, 1, 1, 'integratore alimentare', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-02-21', 'sustenium plus', 'menarini', 27, NULL, NULL, 2, 1, 'integratore alimentare', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2023-01-21', 'prostamol', 'menarini', 28, NULL, NULL, 3, 1, 'integratore alimentare', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2022-04-09', 'moment act', 'angelini', 29, NULL, NULL, 1, 3, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2022-04-09', 'moment act', 'angelini', 29, NULL, NULL, 2, 3, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2022-04-09', 'moment act', 'angelini', 29, NULL, NULL, 3, 3, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (1, '2023-09-21', 'azitromicina', 'pfizer', 30, NULL, NULL, 4, 3, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (2, '2023-09-21', 'azitromicina', 'pfizer', 30, NULL, NULL, 5, 3, 'antibiotico', NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (3, '2023-09-21', 'azitromicina', 'pfizer', 30, 6, 5, NULL, NULL, NULL, NULL);
INSERT INTO `mydb`.`scatole` (`seriale`, `data_scadenza`, `prodotto`, `ditta`, `ordine`, `vendita`, `vendita_medicinalerr`, `cassetto`, `scaffale`, `categoria`, `cf_cliente`) VALUES (4, '2023-09-21', 'azitromicina', 'pfizer', 30, 6, 5, NULL, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`utenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('ludovico', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('valerio', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'medico');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('giovanni', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('luca', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('marta', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('giulia', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('rebecca', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'medico');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('carlotta', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'medico');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('lorenzo', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('giuseppe', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'amministratore');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('enzo', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'medico');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('bianca', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'medico');
INSERT INTO `mydb`.`utenti` (`username`, `password`, `ruolo`) VALUES ('alessandro', 'c5c3cf1ef4ad9222a9a1203e94b5b4d7', 'medico');

COMMIT;

