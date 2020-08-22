

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema rubai

-- Arrange company setup,continent,continental region,branch,busin ess branch,branch region.

-- user,user roles,next of kin, address,

-- constants
-- --------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rubai` DEFAULT CHARACTER SET utf8 ;
USE `rubai` ;


/*==============PART ZERO:DB DROPS=============*/
DROP TABLE IF EXISTS the_company_datails;
DROP TABLE IF EXISTS branch;
DROP TABLE IF EXISTS branch_constants;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS users;

/*==============PART ONE:COMPANY SETUP=============*/

-- Table `the_company_datails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `the_company_datails` (
  `the_company_datails_id` INT(11) NOT NULL AUTO_INCREMENT,
  `the_company_name` VARCHAR(100) NULL DEFAULT 'Runicort Corp Ltd',
  `created_at` TIMESTAMP,
  `updated_at` TIMESTAMP,
  PRIMARY KEY (`the_company_datails_id`)
  )
ENGINE = InnoDB
AUTO_INCREMENT = 16000
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `branch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `branch` (
  `branch_id` INT(11) NOT NULL AUTO_INCREMENT,
  `branch_name` VARCHAR(100) NULL DEFAULT 'William Street',
  `fk_the_company_details_id_branch` INT(11) NULL ,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`branch_id`),
  CONSTRAINT `fk_the_company_details_id_branch` 
  FOREIGN KEY (`fk_the_company_details_id_branch`) 
  REFERENCES `the_company_datails`(`the_company_datails_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 500
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_the_company_details_id_branch_idx` ON `branch`(`fk_the_company_details_id_branch` ASC) VISIBLE;





-- -----------------------------------------------------
-- Table `branch_constants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `branch_constants` (
  `branch_constants_id` INT(11) NOT NULL AUTO_INCREMENT,
    `branch_percentages` DOUBLE NULL,
  `fk_branch_id_branch_constants` INT(11) NULL ,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`branch_constants_id`),

  CONSTRAINT `fk_branch_id_branch_constants` 
  FOREIGN KEY (`fk_branch_id_branch_constants`) 
  REFERENCES `branch`(`branch_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 5000
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_branch_id_branch_constants_idx` ON `branch_constants`(`fk_branch_id_branch_constants` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `allocations_total`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `allocations_total` (
  `allocations_total_id` INT(11) NOT NULL AUTO_INCREMENT,
      `allocations_total_made` DOUBLE NULL,
       `allocations_total_deposited` DOUBLE NULL,
        `allocations_total_balance` DOUBLE NULL,
  `fk_branch_id_allocations_total` INT(11) NULL ,-- The branch whose an allocation is made

   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`allocations_total_id`),
  CONSTRAINT `fk_branch_id_allocations_total` 
  FOREIGN KEY (`fk_branch_id_allocations_total`) 
  REFERENCES `branch`(`branch_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION
   
   )
ENGINE = InnoDB
AUTO_INCREMENT = 76000
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_branch_id_allocations_total_idx` ON `allocations_total`(`fk_branch_id_allocations_total` ASC) VISIBLE;




-- -----------------------------------------------------
-- Table `allocations_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `allocations_details` (
  `allocations_details_id` INT(11) NOT NULL AUTO_INCREMENT,
    `allocations_details_percentage` DOUBLE NULL,
      `allocations_details_made` DOUBLE NULL,
  `fk_branch_id_allocations_details` INT(11) NULL ,-- Branch being allocated the funds
    `fk_amount_allocated_id_allocations_details` INT(11) NULL ,  --  Table containing the original amount being allocated
        `fk_users_id_allocations_details` INT(11) NULL ,  --  The id of the user making the allocation
          `fk_allocations_total_id_allocations_details` INT(11) NULL , 
   `created_at` TIMESTAMP,   
  `update_at` TIMESTAMP,
  PRIMARY KEY (`allocations_details_id`),

  CONSTRAINT `fk_branch_id_allocations_details` 
  FOREIGN KEY (`fk_branch_id_allocations_details`) 
  REFERENCES `branch`(`branch_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION,
   
     CONSTRAINT `fk_amount_allocated_id_allocations_details` 
  FOREIGN KEY (`fk_amount_allocated_id_allocations_details`) 
  REFERENCES `amount_allocated`(`amount_allocated_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION,

     CONSTRAINT `fk_users_id_allocations_details` 
  FOREIGN KEY (`fk_users_id_allocations_details`) 
  REFERENCES `users`(`users_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION,

   
     CONSTRAINT `fk_allocations_total_id_allocations_details` 
  FOREIGN KEY (`fk_allocations_total_id_allocations_details`) 
  REFERENCES `allocations_total`(`allocations_total_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION
   
   )
ENGINE = InnoDB
AUTO_INCREMENT = 76000
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_branch_id_branch_allocations_idx` ON `allocations_details`(`fk_branch_id_allocations_details` ASC) VISIBLE;

  CREATE INDEX `fk_amount_allocated_id_allocations_details_idx` ON `allocations_details`(`fk_amount_allocated_id_allocations_details` ASC) VISIBLE;


  CREATE INDEX `fk_users_id_allocations_details_idx` ON `allocations_details`(`fk_users_id_allocations_details` ASC) VISIBLE;


  CREATE INDEX `fk_allocations_total_id_allocations_details_idx` ON `allocations_details`(`fk_allocations_total_id_allocations_details` ASC) VISIBLE;


  

-- -----------------------------------------------------
-- Table `allocations_ledger`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `allocations_ledger` (
  `allocations_ledger_id` INT(11) NOT NULL AUTO_INCREMENT,
      `allocations_ledger_added` DOUBLE NULL,
        `allocations_ledger_removed` DOUBLE NULL,
  `fk_branch_id_allocations_ledger` INT(11) NULL ,-- Branch being allocated the funds
        `fk_users_id_allocations_ledger` INT(11) NULL ,  --  The id of the user making the allocation
          `fk_allocations_total_id_allocations_ledger` INT(11) NULL , 
   `created_at` TIMESTAMP,   
  `update_at` TIMESTAMP,
  PRIMARY KEY (`allocations_ledger_id`),

  CONSTRAINT `fk_branch_id_allocations_ledger` 
  FOREIGN KEY (`fk_branch_id_allocations_ledger`) 
  REFERENCES `branch`(`branch_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION,
   

     CONSTRAINT `fk_users_id_allocations_ledger` 
  FOREIGN KEY (`fk_users_id_allocations_ledger`) 
  REFERENCES `users`(`users_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION,

   
     CONSTRAINT `fk_allocations_total_id_allocations_ledger` 
  FOREIGN KEY (`fk_allocations_total_id_allocations_ledger`) 
  REFERENCES `allocations_total`(`allocations_total_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION
   
   )
ENGINE = InnoDB
AUTO_INCREMENT = 89000
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_branch_id_allocations_ledger_idx` ON `allocations_ledger`(`fk_branch_id_allocations_ledger` ASC) VISIBLE;


  CREATE INDEX `fk_users_id_allocations_ledger_idx` ON `allocations_ledger`(`fk_users_id_allocations_ledger` ASC) VISIBLE;


  CREATE INDEX `fk_allocations_total_id_allocations_ledger_idx` ON `allocations_ledger`(`fk_allocations_total_id_allocations_ledger` ASC) VISIBLE;



  

-- -----------------------------------------------------
-- Table `amount_available`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amount_allocated` (
  `amount_allocated_id` INT(11) NOT NULL AUTO_INCREMENT,
    `amount_allocatedX` DOUBLE NULL,
 
`fk_users_id_amount_allocated` INT(11) NULL ,
   
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`amount_allocated_id`),

  CONSTRAINT `fk_users_id_amount_allocated` 
  FOREIGN KEY (`fk_users_id_amount_allocated`) 
  REFERENCES `users`(`users_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION
   
   )
ENGINE = InnoDB
AUTO_INCREMENT = 8800
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_users_id_amount_allocated_idx` ON `amount_allocated`(`fk_users_id_amount_allocated` ASC) VISIBLE;
 

 
-- -----------------------------------------------------
-- Table `amount_alloc_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amount_alloc_table` (
  `amount_alloc_table_id` INT(11) NOT NULL AUTO_INCREMENT,
    `amount_amount_alloc` DOUBLE NULL,
  PRIMARY KEY (`amount_alloc_table_id`)

   )
ENGINE = InnoDB
AUTO_INCREMENT = 8800
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `amount_alloc_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amount_alloc_table_bal` (
  `amount_alloc_table_id` INT(11) NOT NULL AUTO_INCREMENT,
    `amount_amount_alloc` DOUBLE NULL,
  PRIMARY KEY (`amount_alloc_table_id`)

   )
ENGINE = InnoDB
AUTO_INCREMENT = 8800
DEFAULT CHARACTER SET = utf8;


/*==============PART TWO:USER DETAILS SETUPS=============*/

-- ---------------------------------------------------
-- Table `user_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_roles_id` INT NOT NULL AUTO_INCREMENT,
  `user_roles_name` VARCHAR(45) NULL,
  `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`user_roles_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1000;


-- ---------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS  `users`;

CREATE TABLE IF NOT EXISTS `users` (
  `users_id` INT(11) NOT NULL AUTO_INCREMENT,
  `users_email` VARCHAR(45) NULL DEFAULT 'augbazi@gmail.com',
  `users_password` VARCHAR(500) NULL DEFAULT 'XXXXXX',
  `users_active_status` VARCHAR(20) NULL DEFAULT 'XXXXXX', -- Created,Approved,Deactivated
    `fk_branch_id_users` INT(11) NULL,
  `fk_user_roles_id_users` INT(11) NULL,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`users_id`),

  CONSTRAINT `fk_user_roles_id_users`
    FOREIGN KEY (`fk_user_roles_id_users`)
    REFERENCES `user_roles` (`user_roles_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,

     CONSTRAINT `fk_branch_id_users`
    FOREIGN KEY (`fk_branch_id_users`)
    REFERENCES `branch` (`branch_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 100000000
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_user_roles_id_users_idx` ON `users` (`fk_user_roles_id_users` ASC) VISIBLE;
 CREATE INDEX `fk_branch_id_users_idx` ON `users` (`fk_branch_id_users` ASC) VISIBLE;




-- ---------------------------------------------------
-- Table `common_bio_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS  `common_bio_data`;
CREATE TABLE IF NOT EXISTS `common_bio_data`(
  
 `common_bio_data_id` INT(11) NOT NULL AUTO_INCREMENT,
`full_name` VARCHAR(100) NULL,
`mobile_contact` VARCHAR(60) NULL DEFAULT '0782231039',
`fk_users_id_common_bio_data` INT(11) NULL,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  
   PRIMARY KEY(common_bio_data_id),
   
   CONSTRAINT `fk_users_id_common_bio_data`
   FOREIGN KEY (`fk_users_id_common_bio_data`)
   REFERENCES `users`(`users_id`)
   ON DELETE CASCADE
   ON UPDATE NO ACTION)
ENGINE=InnoDB
AUTO_INCREMENT=202020
DEFAULT CHARACTER SET=utf8;

CREATE INDEX `fk_users_id_common_bio_data_indx` ON `common_bio_data`(`fk_users_id_common_bio_data` ASC) VISIBLE;




/*==============PART ZERO:GENERAL BUSINESS LOGIC=============*/



-- ---------------------------------------------------
-- Table `trn_general_ledger`
-- ---------------------------------------------------
DROP TABLE IF EXISTS `trn_general_ledger`;

CREATE TABLE IF NOT EXISTS `trn_general_ledger` (
  `trn_general_ledger_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trn_date` DATE NULL DEFAULT NULL,
  `trn_narration` VARCHAR(500) NULL DEFAULT NULL,
  `trn_debit` DOUBLE NULL DEFAULT NULL,
  `trn_credit` DOUBLE NULL DEFAULT NULL,
   `fk_branch_id_trn_general_ledger` INT(11) NULL DEFAULT NULL,
    `fk_account_types_id_trn_general_ledger` INT(11) NULL DEFAULT NULL,
  `fk_user_id_posted_by_trn_general_ledger_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`trn_general_ledger_id`),

  CONSTRAINT `fk_branch_id_trn_general_ledger`
  FOREIGN KEY (`fk_branch_id_trn_general_ledger`)
  REFERENCES `branch`(`branch_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION,
  
   CONSTRAINT `fk_account_types_id_trn_general_ledger`
  FOREIGN KEY (`fk_account_types_id_trn_general_ledger`)
  REFERENCES `account_types`(`account_types_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION,

  CONSTRAINT `fk_user_id_posted_by_trn_general_ledger_id`
  FOREIGN KEY (`fk_user_id_posted_by_trn_general_ledger_id`)
  REFERENCES `users`(`users_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION )

ENGINE = InnoDB
AUTO_INCREMENT = 4000
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_branch_id_trn_general_ledger_indx` ON `trn_general_ledger`(`fk_branch_id_trn_general_ledger` ASC);

CREATE INDEX `fk_account_types_id_trn_general_ledger_indx` ON `trn_general_ledger`(`fk_account_types_id_trn_general_ledger` ASC);


CREATE INDEX `fk_user_id_posted_by_trn_general_ledger_id_indx` ON `trn_general_ledger`(`fk_user_id_posted_by_trn_general_ledger_id` ASC);



-- -----------------------------------------------------
-- Table `balance_per_day`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `balance_per_day`;
CREATE TABLE IF NOT EXISTS `balance_per_day` (
  `balance_per_day_id` INT(11) NOT NULL AUTO_INCREMENT,
   `trn_date` DATE,
  `the_balance` DOUBLE NULL,
  `fk_branch_id_balance_per_day` INT NULL,
  `fk_account_types_id_balance_per_day` INT NULL,
 
  PRIMARY KEY (`balance_per_day_id`),
  
  CONSTRAINT `fk_branch_id_balance_per_day`
  FOREIGN KEY (`fk_branch_id_balance_per_day`)
  REFERENCES `branch`(`branch_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION,
  
    CONSTRAINT `fk_account_types_id_balance_per_day`
  FOREIGN KEY (`fk_account_types_id_balance_per_day`)
  REFERENCES `account_types`(`account_types_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 4750
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_branch_id_balance_per_day_indx` ON `balance_per_day` (`fk_branch_id_balance_per_day` ASC) VISIBLE;

 CREATE INDEX `fk_account_types_id_balance_per_day_indx` ON `balance_per_day` (`fk_account_types_id_balance_per_day` ASC) VISIBLE;






-- -----------------------------------------------------
-- Table `balance_per_day_total`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `balance_per_day_total`;

CREATE TABLE IF NOT EXISTS `balance_per_day_total` (
  
  `balance_per_day_total_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trn_date` DATE,
  `the_balance` DOUBLE NULL,
  `fk_account_types_id_balance_per_day_total` INT NULL,
  
  PRIMARY KEY (`balance_per_day_total_id`),
  
  CONSTRAINT `fk_account_types_id_balance_per_day_total`
  FOREIGN KEY (`fk_account_types_id_balance_per_day_total`)
  REFERENCES `account_types`(`account_types_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 47501
DEFAULT CHARACTER SET = utf8;

 CREATE INDEX `fk_account_types_id_balance_per_day_total_indx` ON `balance_per_day_total` (`fk_account_types_id_balance_per_day_total` ASC) VISIBLE;





-- -----------------------------------------------------
-- Table `account_types` 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `account_types` (
  `account_types_id` INT NOT NULL AUTO_INCREMENT,
  `account_type_name` VARCHAR(100) NULL,
   `account_type_number` INT(11) NULL,
  PRIMARY KEY (`account_types_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET=utf8;


-- -----------------------------------------------------
-- Table `sms_management` a table holding the counter for the SMSs that the company has bought
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sms_management` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `number_of_sms` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET=utf8;


-- -----------------------------------------------------
-- Table `runningBalHoleder`
-- -----------------------------------------------------

DROP TABLE IF EXISTS runningBalHoleder;

CREATE TABLE runningBalHoleder(
  id INT NOT NULL AUTO_INCREMENT ,
  balance  DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;





SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




CREATE EVENT test_event_03 ON SCHEDULE EVERY 1 MINUTE STARTS CURRENT_TIMESTAMP ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR DO INSERT INTO messages(message,created_at) VALUES('Test MySQL recurring Event',NOW());