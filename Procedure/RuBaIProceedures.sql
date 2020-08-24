
/*  USER ROLES DATA */

--  INSERT INTO the_company_datails VALUES(NULL,'RUNICORP HOLDINGS LTD',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());



--  INSERT INTO branch VALUES(NULL,'RuniCorp Liquor Supermarket',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Shoppers',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Distributors',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Liquors',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Farm',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

-- INSERT INTO user_roles VALUES(1000,'Branch User',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1001,'Admin User',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1002,'Other User',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()); 

-- INSERT INTO  account_types VALUES(NULL,'BANK',100000),(NULL,'INVESTMENT',200000);

--UPDATE users SET  fk_user_role_id_users=1002 WHERE  users_id=100000000;

-- UPDATE users SET users_active_status ='Approved' WHERE users_id=100000002;


--INSERT INTO sms_management VALUES(NULL,5);

-- INSERT INTO branch_constants VALUES (NULL,10, 500,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,20, 501,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,30, 502,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,30, 503,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,10, 504,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

/*SELECT THE INITIAL SETUP */
/* ALL BRANCHES*/


DROP PROCEDURE IF EXISTS getTheBranchesNow;

DELIMITER ##

CREATE PROCEDURE   getTheBranchesNow() 

BEGIN

SELECT branch_id,branch_name FROM branch;

END ##

DELIMITER ;

 


/* ALL USER ROLES */

DROP PROCEDURE IF EXISTS getTheUserRoles;

DELIMITER ##

CREATE PROCEDURE   getTheUserRoles() 

BEGIN

SELECT user_roles_id,user_roles_name FROM user_roles;

END ##

DELIMITER ;




/* TEST WHETHER USER EXISTS */
DROP PROCEDURE IF EXISTS userExists;
DELIMITER ##
CREATE PROCEDURE   userExists(IN email VARCHAR(45),IN user_role VARCHAR(45)) 
BEGIN

SELECT  COUNT(u.users_id) AS user_exists FROM  users u INNER JOIN user_roles ul ON u.fk_user_roles_id_users=ul.user_roles_id WHERE u.users_email=email AND ul.user_roles_name=user_role;

END ##
DELIMITER ;


/* CREATE INITIAL USER DETAILS/register user using phone number*/
DROP PROCEDURE IF EXISTS registerTheUsersDetails;
DELIMITER ##
CREATE PROCEDURE   registerTheUsersDetails(IN data JSON,IN email VARCHAR(45),IN password VARCHAR(200)) 
BEGIN

DECLARE branchId,roleId,userId INT;

SELECT user_roles_id INTO roleId FROM  user_roles  WHERE user_roles_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_role'));

SELECT branch_id INTO branchId FROM branch  WHERE branch_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.branch_name'));

INSERT INTO  users VALUES(NULL,email,password,'Created',branchId,roleId,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

SET userId=LAST_INSERT_ID();


INSERT INTO common_bio_data VALUES(NULL,JSON_UNQUOTE(JSON_EXTRACT(data, '$.full_name')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.main_contact_number')),userId,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

SELECT u.users_id,cbd.mobile_contact,u.fk_user_roles_id_users FROM users u INNER JOIN common_bio_data cbd ON u.users_id=cbd.fk_users_id_common_bio_data where u.users_id=userId;


END ##
DELIMITER ;



/*GET THE AVAILABLE SMSs*/

DROP PROCEDURE IF EXISTS getTheNumberOfSMSs;

DELIMITER ##
CREATE PROCEDURE   getTheNumberOfSMSs() 
BEGIN
SELECT number_of_sms  FROM sms_management;


END ##
DELIMITER ;


/*PURCHASE SMSs*/

DROP PROCEDURE IF EXISTS purchaseSMSs;

DELIMITER ##
CREATE PROCEDURE   purchaseSMSs(IN data JSON) 
BEGIN

DECLARE existingSmsBalance,newSmsBalance INT;
SELECT number_of_sms FROM sms_management INTO existingSmsBalance;

SET newSmsBalance=existingSmsBalance+JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_of_SMSs'));

UPDATE sms_management SET number_of_sms=newSmsBalance;

END ##
DELIMITER ;




/*REDUCE SMSs*/

DROP PROCEDURE IF EXISTS reduceSMSs;

DELIMITER ##
CREATE PROCEDURE   reduceSMSs() 
BEGIN

DECLARE existingSmsBalance,newSmsBalance INT;

SELECT number_of_sms FROM sms_management INTO existingSmsBalance;

SET newSmsBalance=existingSmsBalance-1;

UPDATE sms_management SET number_of_sms=newSmsBalance;

END ##
DELIMITER ;


/* GET user_id,password,email and role OF THE USER */
DROP PROCEDURE IF EXISTS getNormaUserLogInDetails;
DELIMITER ##
CREATE PROCEDURE   getNormaUserLogInDetails(IN email VARCHAR(45),IN user_role VARCHAR(45)) 
BEGIN

SELECT u.users_id,u.users_email,u.users_password,u.users_active_status,u.fk_branch_id_users,u.fk_user_roles_id_users, cbd.full_name,cbd.mobile_contact,b.branch_name FROM  users u INNER JOIN user_roles ul ON u.fk_user_roles_id_users=ul.user_roles_id INNER JOIN common_bio_data cbd ON u.users_id=cbd.fk_users_id_common_bio_data INNER JOIN branch b ON b.branch_id=u.fk_branch_id_users WHERE u.users_email=email AND ul.user_roles_name=user_role;
END ##
DELIMITER ;





/* USER NAME FUNCTION USING USER ID */
DROP FUNCTION IF EXISTS UserName;
DELIMITER ##
CREATE FUNCTION UserName(user_id INT) 
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
DECLARE userName VARCHAR(60);
SELECT name INTO userName FROM common_bio_data WHERE fk_users_id_common_bio_data=user_id;
RETURN userName;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS postTheTxnNow;
DELIMITER ##
CREATE PROCEDURE   postTheTxnNow(IN data JSON) 
BEGIN

DECLARE posted_successfully INT;

SELECT JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')) ;

IF  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')) = 'DEPOSIT' THEN

  
  
  
    
CALL postDepositTxn(
    JSON_UNQUOTE(JSON_EXTRACT(data, '$.narration')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_family')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_amount')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.branch_name')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id'))
    ) ;

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')) = 'WITHDRAWAL' THEN

CALL postWithdrawTxn(
    JSON_UNQUOTE(JSON_EXTRACT(data, '$.narration')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_family')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_amount')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.branch_name')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id'))
    ) ;

    ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')) = 'ALLOCATE' THEN

    SELECT  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_amount')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id'));

CALL makeAllocationsNow(

  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_amount')),
  JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id'))
    ) ;

END IF;

SET posted_successfully=1;

SELECT posted_successfully;

END ##
DELIMITER ;



/* POST DEPOSIT TRANSACTIONS */

DROP PROCEDURE IF EXISTS postDepositTxn ;

DELIMITER ##

CREATE PROCEDURE   postDepositTxn(IN narration VARCHAR(500),IN txnFamily VARCHAR(45),IN txnType VARCHAR(45),IN amount DOUBLE,IN branchNameNow VARCHAR(45),IN userId INT) 
BEGIN

DECLARE typeId,branchId,balExits,totalBalExists,dailybalExits,dailytotalBalExists,balDId,balDTotalId INT;

DECLARE closingBalBranch,newClosingBalBranch,closingBalTotal,newClosingBalTotal,closingBalBranchDaily,closingBalTotalDaily DOUBLE;

--  SELECT narration,txnFamily,txnType,amount,branchNameNow;

SELECT  account_types_id  INTO typeId FROM  account_types WHERE account_type_name=txnFamily;

SELECT branch_id INTO branchId FROM branch WHERE branch_name=branchNameNow;




IF txnFamily='INVESTMENT' THEN

CALL adjustAllocations(amount,branchId,userId);

END IF;

SELECT COUNT(bb.the_balance) INTO  balExits FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date<=DATE(NOW());

SELECT COUNT(bt.the_balance) INTO totalBalExists FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date<=DATE(NOW());

IF balExits <=0 THEN 

INSERT INTO balance_per_day VALUES(NULL,DATE(NOW()),0.0,branchId,typeId);


END IF;


IF totalBalExists <=0 THEN

INSERT INTO balance_per_day_total VALUES(NULL,DATE(NOW()),0.0,typeId);

END IF;


SELECT COUNT(bb.the_balance) INTO  dailybalExits FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date=DATE(NOW());

SELECT COUNT(bt.the_balance) INTO dailytotalBalExists FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date=DATE(NOW());

/* SELECT dailybalExits,totalBalExists; */
IF dailybalExits <=0 THEN 

SELECT bb.the_balance INTO  closingBalBranchDaily FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date<=DATE(NOW()) ORDER BY bb.balance_per_day_id DESC LIMIT 1;

INSERT INTO balance_per_day VALUES(NULL,DATE(NOW()),closingBalBranchDaily,branchId,typeId);


END IF;


IF dailytotalBalExists <=0 THEN

SELECT bt.the_balance INTO closingBalTotalDaily FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date<=DATE(NOW()) ORDER BY bt.balance_per_day_total_id DESC LIMIT 1;

INSERT INTO balance_per_day_total VALUES(NULL,DATE(NOW()),closingBalTotalDaily,typeId);

END IF;


SELECT bb. balance_per_day_id, bb.the_balance INTO balDId, closingBalBranch FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date=DATE(NOW()) ORDER BY bb.balance_per_day_id DESC LIMIT 1;

SELECT bt.balance_per_day_total_id, bt.the_balance INTO balDTotalId,closingBalTotal FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date=DATE(NOW()) ORDER BY bt.balance_per_day_total_id DESC LIMIT 1;

/* SELECT balDTotalId,closingBalTotal; */

-- SELECT balDId, closingBalBranch;

SET  newClosingBalBranch=closingBalBranch+amount;

SET newClosingBalTotal=closingBalTotal+amount;
-- SELECT DATE(NOW()),narration,0.0,amount,branchId,typeId,userId;
INSERT INTO trn_general_ledger VALUES(NULL,DATE(NOW()),narration,0.0,amount,branchId,typeId,userId);

UPDATE balance_per_day SET the_balance=newClosingBalBranch WHERE balance_per_day_id=balDId;


UPDATE balance_per_day_total SET the_balance=newClosingBalTotal WHERE balance_per_day_total_id=balDTotalId;



END ##
DELIMITER ;





/* POST DEPOSIT TRANSACTIONS */
DROP PROCEDURE IF EXISTS postWithdrawTxn;

DELIMITER ##

CREATE PROCEDURE   postWithdrawTxn(IN narration VARCHAR(500),IN txnFamily VARCHAR(45),IN txnType VARCHAR(45),IN amount DOUBLE,IN branchNameNow VARCHAR(45),IN userId INT) 
BEGIN

DECLARE typeId,branchId,balExits,totalBalExists,dailybalExits,dailytotalBalExists,balDId,balDTotalId INT;

DECLARE closingBalBranch,newClosingBalBranch,closingBalTotal,newClosingBalTotal,closingBalBranchDaily,closingBalTotalDaily DOUBLE;



SELECT  account_types_id  INTO typeId FROM  account_types WHERE account_type_name=txnFamily;

SELECT branch_id INTO branchId FROM branch WHERE branch_name=branchNameNow;

SELECT COUNT(bb.the_balance) INTO  balExits FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date<=DATE(NOW());

SELECT COUNT(bt.the_balance) INTO totalBalExists FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date<=DATE(NOW());

IF balExits <=0 THEN 

INSERT INTO balance_per_day VALUES(NULL,DATE(NOW()),0.0,branchId,typeId);


END IF;


IF totalBalExists <=0 THEN

INSERT INTO balance_per_day_total VALUES(NULL,DATE(NOW()),0.0,typeId);

END IF;


SELECT COUNT(bb.the_balance) INTO  dailybalExits FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date=DATE(NOW());

SELECT COUNT(bt.the_balance) INTO dailytotalBalExists FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date=DATE(NOW());


IF dailybalExits <=0 THEN 

SELECT bb.the_balance INTO  closingBalBranchDaily FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date<=DATE(NOW()) ORDER BY bb.balance_per_day_id DESC LIMIT 1;

INSERT INTO balance_per_day VALUES(NULL,DATE(NOW()),closingBalBranchDaily,branchId,typeId);


END IF;


IF dailytotalBalExists <=0 THEN

SELECT bt.the_balance INTO closingBalTotalDaily FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date<=DATE(NOW()) ORDER BY bt.balance_per_day_total_id DESC LIMIT 1;

INSERT INTO balance_per_day_total VALUES(NULL,DATE(NOW()),closingBalTotalDaily,typeId);

END IF;


SELECT bb. balance_per_day_id, bb.the_balance INTO balDId, closingBalBranch FROM balance_per_day  bb INNER JOIN branch b ON bb.fk_branch_id_balance_per_day=b.branch_id INNER JOIN account_types act ON bb.fk_account_types_id_balance_per_day=act.account_types_id WHERE b.branch_name=branchNameNow AND act.account_type_name=txnFamily AND bb.trn_date=DATE(NOW());

SELECT bt.balance_per_day_total_id, bt.the_balance INTO balDTotalId,closingBalTotal FROM balance_per_day_total bt INNER JOIN account_types act ON bt.fk_account_types_id_balance_per_day_total=act.account_types_id
WHERE act.account_type_name=txnFamily AND  bt.trn_date=DATE(NOW());

/* SELECT balDTotalId,closingBalTotal; */

SET  newClosingBalBranch=closingBalBranch-amount;

SET newClosingBalTotal=closingBalTotal-amount;

/* SELECT newClosingBalBranch,newClosingBalTotal; */

INSERT INTO trn_general_ledger VALUES(NULL,DATE(NOW()),narration,amount,0.0,branchId,typeId,userId);

UPDATE balance_per_day SET the_balance=newClosingBalBranch WHERE balance_per_day_id=balDId;


UPDATE balance_per_day_total SET the_balance=newClosingBalTotal WHERE balance_per_day_total_id=balDTotalId;



END ##
DELIMITER ;






/* GET THE BRANCH BANK LEDGER STATEMENT*/

DROP PROCEDURE IF EXISTS getTheBranchLedgerStatementInvestment;

DELIMITER ##

CREATE PROCEDURE   getTheBranchLedgerStatementInvestment(IN branchName VARCHAR(45)) 
BEGIN

DROP TABLE IF EXISTS investmentbranchledger;

CREATE TEMPORARY TABLE investmentbranchledger(
  id1 INT NOT NULL AUTO_INCREMENT ,
  dateX1 VARCHAR(20),
  narration1 VARCHAR(200),
  debit_amount1 VARCHAR(200),
  credit_amount1 VARCHAR(200),
  balance1  VARCHAR(200),
  user_name1   VARCHAR(100),
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

DROP TABLE IF EXISTS investmentbranchledger1;

CREATE TEMPORARY TABLE investmentbranchledger1(
  id INT NOT NULL AUTO_INCREMENT ,
  dateX VARCHAR(20),
  narration VARCHAR(200),
  debit_amount VARCHAR(200),
  credit_amount VARCHAR(200),
  balance  VARCHAR(200),
  user_name   VARCHAR(100),
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

DELETE FROM runningBalHoleder;

INSERT INTO runningBalHoleder VALUES(NULL,0.0);


INSERT INTO investmentbranchledger(
  id1,
  dateX1,
  narration1,
  debit_amount1,
  credit_amount1,
  balance1,
  user_name1
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,l.trn_debit AS debit_amount,l.trn_credit AS credit_amount,runningBal(l.trn_debit,l.trn_credit),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN account_types ats ON l.fk_account_types_id_trn_general_ledger= ats.account_types_id WHERE b.branch_name=branchName AND ats.account_type_name='INVESTMENT' LIMIT 30;

  INSERT INTO investmentbranchledger1(
  id,
  dateX,
  narration,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT * FROM investmentbranchledger ;


    INSERT INTO investmentbranchledger1(
  id,
  dateX,
  narration,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT NULL,NULL,'TOTAL',SUM(debit_amount1),SUM(credit_amount1),NULL,NULL FROM investmentbranchledger ;

SELECT * FROM investmentbranchledger1;

END ##
DELIMITER ;




/* GET THE BRANCH BANK LEDGER STATEMENT*/

DROP PROCEDURE IF EXISTS getTheBranchLedgerStatementBank;

DELIMITER ##

CREATE PROCEDURE   getTheBranchLedgerStatementBank(IN branchName VARCHAR(45)) 
BEGIN

DROP TABLE IF EXISTS bankbranchledger;

CREATE TEMPORARY TABLE bankbranchledger(
  id1 INT NOT NULL AUTO_INCREMENT ,
  dateX1 VARCHAR(20),
  narration1 VARCHAR(200),
  debit_amount1 VARCHAR(200),
  credit_amount1 VARCHAR(200),
  balance1  VARCHAR(200),
  user_name1   VARCHAR(100),
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DROP TABLE IF EXISTS bankbranchledger1;

CREATE TEMPORARY TABLE bankbranchledger1(
  id INT NOT NULL AUTO_INCREMENT ,
  dateX VARCHAR(20),
  narration VARCHAR(200),
  debit_amount VARCHAR(200),
  credit_amount VARCHAR(200),
  balance  VARCHAR(200),
  user_name   VARCHAR(100),
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DELETE FROM runningBalHoleder;

INSERT INTO runningBalHoleder VALUES(NULL,0.0);


INSERT INTO bankbranchledger(
  id1,
  dateX1,
  narration1,
  debit_amount1,
  credit_amount1,
  balance1,
  user_name1
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,l.trn_debit AS debit_amount,l.trn_credit AS credit_amount,runningBal(l.trn_debit,l.trn_credit),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN account_types ats ON l.fk_account_types_id_trn_general_ledger= ats.account_types_id WHERE b.branch_name=branchName AND ats.account_type_name='BANK' LIMIT 30;


  INSERT INTO bankbranchledger1(
  id,
  dateX,
  narration,
  debit_amount,
  credit_amount,
  balance,
  user_name

  ) SELECT * FROM bankbranchledger;


  INSERT INTO bankbranchledger1(
  id,
  dateX,
  narration,
  debit_amount,
  credit_amount,
  balance,
  user_name
  
  ) SELECT NULL, NULL, 'TOTAL',SUM(debit_amount1),SUM(credit_amount1),NULL,NULL FROM bankbranchledger;

SELECT * FROM bankbranchledger1;

END ##
DELIMITER ;


/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS runningBal;
DELIMITER ##
CREATE FUNCTION runningBal(debit DOUBLE,credit DOUBLE ) 
RETURNS DOUBLE 
DETERMINISTIC
BEGIN
DECLARE runningBal,newRunningBal DOUBLE;

SELECT balance INTO runningBal FROM runningBalHoleder;

 IF ISNULL(debit) THEN
 SET debit=0.0;
 END IF;

 IF ISNULL(credit) THEN
 SET credit=0.0;
 END IF;

 IF ISNULL(runningBal) THEN
 SET runningBal=0.0;
 END IF;

SET newRunningBal=runningBal+credit-debit;

update runningBalHoleder SET balance=newRunningBal;

RETURN newRunningBal;
END ##
DELIMITER ;




/* GET THE ALL BANK LEDGER STATEMENT*/

DROP PROCEDURE IF EXISTS getTheALLLedgerStatementBank;

DELIMITER ##

CREATE PROCEDURE   getTheALLLedgerStatementBank() 
BEGIN

DECLARE OPENINGBAL DOUBLE;

DROP TABLE IF EXISTS bankbranchledger;

CREATE TEMPORARY TABLE bankbranchledger(
  id1 INT NOT NULL AUTO_INCREMENT ,
  dateX1 VARCHAR(20),
  narration1 VARCHAR(200),
  branch1   VARCHAR(100),
  debit_amount1 VARCHAR(200),
  credit_amount1 VARCHAR(200),
  balance1  VARCHAR(200),
  user_name1   VARCHAR(100),
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DROP TABLE IF EXISTS bankbranchledger1;

CREATE TEMPORARY TABLE bankbranchledger1(
  id INT NOT NULL AUTO_INCREMENT ,
  dateX VARCHAR(20),
  narration VARCHAR(200),
  branch   VARCHAR(100),
  debit_amount VARCHAR(200),
  credit_amount VARCHAR(200),
  balance  VARCHAR(200),
  user_name   VARCHAR(100),
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DELETE FROM runningBalHoleder;

INSERT INTO runningBalHoleder VALUES(NULL,0.0);

INSERT INTO bankbranchledger(
  id1,
  dateX1,
  narration1,
  branch1,
  debit_amount1,
  credit_amount1,
  balance1,
  user_name1
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,b.branch_name AS branch,l.trn_debit AS debit_amount,l.trn_credit AS credit_amount,runningBal(l.trn_debit,l.trn_credit),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN  account_types ats ON l.fk_account_types_id_trn_general_ledger=ats.account_types_id WHERE  ats.account_type_name='BANK' LIMIT 30;



INSERT INTO bankbranchledger1(
  id,
  dateX,
  narration,
  branch,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT * FROM bankbranchledger;


INSERT INTO bankbranchledger1(
  id,
  dateX,
  narration,
  branch,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT NULL,NULL,NULL,NULL,SUM(debit_amount1) ,SUM(credit_amount1) ,NULL,NULL FROM bankbranchledger;


SELECT * FROM bankbranchledger1;


END ##
DELIMITER ;








/* GET THE ALL INVESTMENT LEDGER STATEMENT*/

DROP PROCEDURE IF EXISTS getTheALLLedgerStatementInvestment;

DELIMITER ##

CREATE PROCEDURE   getTheALLLedgerStatementInvestment() 
BEGIN

DECLARE OPENINGBAL DOUBLE;

DROP TABLE IF EXISTS investmentBranchledger;

CREATE TEMPORARY TABLE investmentBranchledger(
  id1 INT NOT NULL AUTO_INCREMENT ,
  dateX1 VARCHAR(20),
  narration1 VARCHAR(200),
  branch1   VARCHAR(100),
  debit_amount1 VARCHAR(200),
  credit_amount1 VARCHAR(200),
  balance1  VARCHAR(200),
  user_name1   VARCHAR(100),
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;



DROP TABLE IF EXISTS investmentBranchledger1;

CREATE TEMPORARY TABLE investmentBranchledger1(
  id INT NOT NULL AUTO_INCREMENT ,
  dateX VARCHAR(20),
  narration VARCHAR(200),
  branch   VARCHAR(100),
  debit_amount VARCHAR(200),
  credit_amount VARCHAR(200),
  balance  VARCHAR(200),
  user_name   VARCHAR(100),
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DELETE FROM runningBalHoleder;

INSERT INTO runningBalHoleder VALUES(NULL,0.0);


INSERT INTO investmentBranchledger(
  id1,
  dateX1,
  narration1,
  branch1,
  debit_amount1,
  credit_amount1,
  balance1,
  user_name1
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,b.branch_name AS branch,l.trn_debit AS debit_amount,l.trn_credit AS credit_amount,runningBal(l.trn_debit,l.trn_credit),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN  account_types ats ON l.fk_account_types_id_trn_general_ledger=ats.account_types_id WHERE  ats.account_type_name='INVESTMENT' LIMIT 30;

INSERT INTO investmentBranchledger1(
  id,
  dateX,
  narration,
  branch,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT * FROM investmentBranchledger;

  INSERT INTO investmentBranchledger1(
  id,
  dateX,
  narration,
  branch,
  debit_amount,
  credit_amount,
  balance,
  user_name
  )SELECT NULL,NULL,'TOTAL',NULL,SUM(debit_amount1),SUM(credit_amount1),NULL,NULL FROM investmentBranchledger;


  SELECT * FROM investmentBranchledger1;


END ##
DELIMITER ;






/* ALLOCATIONS COMPUTATIONS */
DROP FUNCTION IF EXISTS alloTotalComp;
DELIMITER ##
CREATE FUNCTION alloTotalComp(totalAlloc DOUBLE,percBranchId INT,userId INT,typeC VARCHAR (45),amountAllocId INT,totalAllocId INT ) 
RETURNS DOUBLE 
DETERMINISTIC
BEGIN
DECLARE allocMade, runningBal,newRunningBal,branchPercent DOUBLE;



SELECT branch_percentages INTO branchPercent FROM branch_constants WHERE fk_branch_id_branch_constants=percBranchId;
IF typeC='ALLOCTOTALMADE' THEN

SELECT allocations_total_made INTO runningBal FROM allocations_total WHERE fk_branch_id_allocations_total=percBranchId;

SET allocMade=((totalAlloc)*(branchPercent/100));

SET newRunningBal=runningBal+allocMade;
/* SELECT totalAllocId; */
INSERT INTO allocations_details VALUES(NULL,branchPercent,allocMade,percBranchId,amountAllocId,userId,totalAllocId,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);


INSERT INTO allocations_ledger VALUES(NULL,allocMade,0.0,percBranchId,userId,totalAllocId,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

END IF;



IF typeC='ALLOCBALANCE' THEN

SELECT allocations_total_balance INTO runningBal FROM allocations_total WHERE fk_branch_id_allocations_total=percBranchId;

SET allocMade=((totalAlloc)*(branchPercent/100));

SET newRunningBal=runningBal+allocMade;

END IF;



RETURN newRunningBal;
END ##
DELIMITER ;









DROP PROCEDURE IF EXISTS makeAllocationsNow;

DELIMITER ##

CREATE PROCEDURE   makeAllocationsNow(IN amount DOUBLE,IN userId INT) 

BEGIN

DECLARE lastAmountAllocatedId,lasteTotalAllocations,existingTotalAllocations,branchId INT;

DECLARE allocMadeX,allocBalX DOUBLE;

INSERT INTO amount_allocated VALUES(NULL,amount,userId,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

SET lastAmountAllocatedId=LAST_INSERT_ID();

SELECT COUNT(allocations_total_id) INTO existingTotalAllocations FROM allocations_total;

IF existingTotalAllocations<1 THEN

INSERT INTO allocations_total (allocations_total_id ,
 allocations_total_made,
 allocations_total_deposited  ,
 allocations_total_balance  ,
 fk_branch_id_allocations_total ,
 created_at  ,
 update_at ) SELECT NULL,0.0,0.0,0.0,b.branch_id,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP FROM branch b;

END IF;

UPDATE allocations_total AS ft, (SELECT alloTotalComp(amount,branch.branch_id,userId,'ALLOCTOTALMADE',lastAmountAllocatedId,allocations_total.allocations_total_id) AS totalAllocation,alloTotalComp(amount,branch.branch_id,userId,'ALLOCBALANCE',lastAmountAllocatedId,allocations_total.allocations_total_id) AS balanceAllocation,branch_id as idX  FROM branch INNER JOIN allocations_total ON  branch.branch_id=allocations_total.fk_branch_id_allocations_total) AS b SET ft.allocations_total_made=b.totalAllocation,ft.allocations_total_balance=b.balanceAllocation WHERE ft.fk_branch_id_allocations_total=b.idX;

 
END ##
DELIMITER ;



/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS branchName;
DELIMITER ##
CREATE FUNCTION branchName(branchId INT ) 
RETURNS VARCHAR(50) 
DETERMINISTIC
BEGIN
DECLARE branchNamed VARCHAR(50) ;
SELECT branch_name INTO branchNamed FROM branch WHERE branch_id=branchId;
RETURN branchNamed;
END ##
DELIMITER ;



/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS getBranchId;
DELIMITER ##
CREATE FUNCTION getBranchId(branchName VARCHAR(60) ) 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE branchId INT ;
SELECT branch_id INTO branchId FROM branch WHERE branch_name=branchName;
RETURN branchId;
END ##
DELIMITER ;


DROP PROCEDURE IF EXISTS allocationsTotalStatement;

DELIMITER ##

CREATE PROCEDURE   allocationsTotalStatement() 

BEGIN


DROP TABLE IF EXISTS totalAllocations;

CREATE TEMPORARY TABLE totalAllocations(
  id INT NOT NULL AUTO_INCREMENT ,
  branch_name VARCHAR(200),
  total_allocations_made DOUBLE,
   total_allocations_deposited DOUBLE,
 total_allocations_balance DOUBLE,
  last_updated_date VARCHAR(20),
   last_updated_time VARCHAR(20),
  branch_id   INT,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


INSERT INTO totalAllocations(id,branch_name,total_allocations_made,total_allocations_deposited,total_allocations_balance,last_updated_date,last_updated_time,branch_id) SELECT NULL,branchName(fk_branch_id_allocations_total),allocations_total_made,allocations_total_deposited,allocations_total_balance,DATE_FORMAT(DATE(update_at),"%d/%m/%Y"),TIME(update_at),fk_branch_id_allocations_total FROM allocations_total;

INSERT INTO totalAllocations(id,branch_name,total_allocations_made,total_allocations_deposited,total_allocations_balance,last_updated_date,last_updated_time,branch_id) SELECT 0,'TOTAL',SUM(allocations_total_made),SUM(allocations_total_deposited),SUM(allocations_total_balance),NULL,NULL,0 FROM allocations_total;

SELECT * FROM totalAllocations;
 
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS allocationsTotalStatementBranch;

DELIMITER ##

CREATE PROCEDURE   allocationsTotalStatementBranch(IN branchNameN VARCHAR (60)) 

BEGIN


DROP TABLE IF EXISTS totalAllocations;

CREATE TEMPORARY TABLE totalAllocations(
  id INT NOT NULL AUTO_INCREMENT ,
  branch_name VARCHAR(200),
  total_allocations_made DOUBLE,
   total_allocations_deposited DOUBLE,
 total_allocations_balance DOUBLE,
  last_updated_date VARCHAR(20),
   last_updated_time VARCHAR(20),
  branch_id   INT,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

/* SELECT branchId(branchNameN); */

INSERT INTO totalAllocations(id,branch_name,total_allocations_made,total_allocations_deposited,total_allocations_balance,last_updated_date,last_updated_time,branch_id) SELECT NULL,branchName(fk_branch_id_allocations_total),allocations_total_made,allocations_total_deposited,allocations_total_balance,DATE_FORMAT(DATE(update_at),"%d/%m/%Y"),TIME(update_at),fk_branch_id_allocations_total FROM allocations_total WHERE fk_branch_id_allocations_total=getBranchId(branchNameN);

/* INSERT INTO totalAllocations(id,branch_name,total_allocations_made,total_allocations_deposited,total_allocations_balance,last_updated_date,last_updated_time,branch_id) SELECT 0,'TOTAL',SUM(allocations_total_made),SUM(allocations_total_deposited),SUM(allocations_total_balance),NULL,NULL,0 FROM allocations_total; */

SELECT * FROM totalAllocations;
 
END ##
DELIMITER ;



/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS balanceAlloc;
DELIMITER ##
CREATE FUNCTION balanceAlloc(amount DOUBLE ) 
RETURNS DOUBLE
DETERMINISTIC
BEGIN
DECLARE BAL,OLD_BAL DOUBLE;

SELECT amount_amount_alloc  INTO OLD_BAL FROM amount_alloc_table;

IF ISNULL(OLD_BAL) THEN 

SET OLD_BAL=0;

INSERT INTO amount_alloc_table VALUES(NULL,0);
END IF;

SET BAL=OLD_BAL+amount;

UPDATE amount_alloc_table SET amount_amount_alloc=BAL;
RETURN BAL;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS allocationsIndivitualStatement;

DELIMITER ##

CREATE PROCEDURE   allocationsIndivitualStatement(IN branchId INT) 

BEGIN

DROP TABLE IF EXISTS individualAllocations;

CREATE TEMPORARY TABLE individualAllocations(
  id1 INT NOT NULL AUTO_INCREMENT ,
    date_allocation_made1 VARCHAR(20),
   time_allocation_made1 VARCHAR(20),
  allocatin_made1 DOUBLE,
   percentage_used1 DOUBLE,
 allocation_got1 DOUBLE,
  allocation_total_got1 DOUBLE,
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DROP TABLE IF EXISTS individualAllocations1;

CREATE TEMPORARY TABLE individualAllocations1(
  id INT NOT NULL AUTO_INCREMENT ,
    date_allocation_made VARCHAR(20),
   time_allocation_made VARCHAR(20),
  allocatin_made DOUBLE,
   percentage_used DOUBLE,
 allocation_got DOUBLE,
  allocation_total_got DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

DELETE FROM amount_alloc_table;

INSERT INTO individualAllocations(id1,date_allocation_made1,time_allocation_made1,allocatin_made1,percentage_used1,allocation_got1,allocation_total_got1) SELECT NULL,DATE_FORMAT(DATE(amd.created_at),"%d/%m/%Y"),TIME(amd.created_at),am. amount_allocatedX,amd.allocations_details_percentage,amd.allocations_details_made,balanceAlloc(amd.  allocations_details_made)  FROM  allocations_details amd INNER JOIN amount_allocated am ON amd.fk_amount_allocated_id_allocations_details=am.amount_allocated_id WHERE amd.fk_branch_id_allocations_details=branchId;

DELETE FROM amount_alloc_table;

INSERT INTO individualAllocations1(id,date_allocation_made,time_allocation_made,allocatin_made,percentage_used,allocation_got,allocation_total_got) SELECT * FROM individualAllocations;


INSERT INTO individualAllocations1(id,date_allocation_made,time_allocation_made,allocatin_made,percentage_used,allocation_got,allocation_total_got) SELECT 0,'TOTAL',NULL,SUM(allocatin_made1),NULL,SUM(allocation_got1),NULL FROM individualAllocations;

SELECT * FROM individualAllocations1;
 
END ##

DELIMITER ;






/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS allocLedgerBal;
DELIMITER ##
CREATE FUNCTION allocLedgerBal(amount_removed DOUBLE,amount_added DOUBLE) 
RETURNS DOUBLE
DETERMINISTIC
BEGIN
DECLARE BAL,OLD_BAL DOUBLE;

SELECT amount_amount_alloc  INTO OLD_BAL FROM amount_alloc_table_bal;

IF ISNULL(OLD_BAL) THEN 


SET OLD_BAL=0;

INSERT INTO amount_alloc_table_bal VALUES(NULL,0);
END IF;

SET BAL=OLD_BAL-amount_removed+amount_added;

UPDATE amount_alloc_table_bal SET amount_amount_alloc=BAL;
RETURN BAL;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS allocationsLedgerStatement;

DELIMITER ##

CREATE PROCEDURE   allocationsLedgerStatement(IN branchId INT) 

BEGIN

DROP TABLE IF EXISTS ledgerAllocations;

CREATE TEMPORARY TABLE ledgerAllocations(
  id1 INT NOT NULL AUTO_INCREMENT ,
    date_allocation1 VARCHAR(20),
   time_allocation1 VARCHAR(20),
   allocations_removed1 DOUBLE,
     allocations_added1 DOUBLE,
 allocations_balance1 DOUBLE,
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DROP TABLE IF EXISTS ledgerAllocations1;

CREATE TEMPORARY TABLE ledgerAllocations1(
  id INT NOT NULL AUTO_INCREMENT ,
    date_allocation VARCHAR(20),
   time_allocation VARCHAR(20),

    allocations_removed DOUBLE,
     allocations_added DOUBLE,
 allocations_balance DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

DELETE FROM  amount_alloc_table_bal;
INSERT INTO ledgerAllocations( id1,
    date_allocation1,
   time_allocation1,
      allocations_removed1,
  allocations_added1,
 allocations_balance1) SELECT NULL,DATE_FORMAT(DATE(al.created_at),"%d/%m/%Y"),TIME(al.created_at),al.allocations_ledger_removed,al.allocations_ledger_added,allocLedgerBal (al.allocations_ledger_removed,al.allocations_ledger_added) FROM allocations_ledger al WHERE  al.fk_branch_id_allocations_ledger=branchId;

INSERT INTO ledgerAllocations1( id,
    date_allocation,
   time_allocation,
      allocations_removed,
  allocations_added,
 allocations_balance) SELECT * FROM ledgerAllocations;

INSERT INTO ledgerAllocations1(  id,
    date_allocation,
   time_allocation,
      allocations_removed,
  allocations_added,
 allocations_balance) SELECT NULL,'TOTAL',NULL,SUM(allocations_removed1),SUM(allocations_added1),NULL FROM  ledgerAllocations;

SELECT * FROM ledgerAllocations1;
 
END ##

DELIMITER ;





DROP PROCEDURE IF EXISTS isBranchInvestmentViable;

DELIMITER ##

CREATE PROCEDURE   isBranchInvestmentViable(IN data JSON) 

BEGIN

DECLARE investAmount DOUBLE;

DECLARE viability INT;

SELECT allocations_total_balance INTO investAmount FROM allocations_total WHERE fk_branch_id_allocations_total=getBranchId( JSON_UNQUOTE(JSON_EXTRACT(data, '$.branch_name')));


/* SELECT investAmount; */

IF ISNULL(investAmount) THEN

SET investAmount=0;

END IF;


IF investAmount>JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_amount')) THEN 

SET viability=1;

ELSEIF investAmount<=JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_amount')) THEN

SET viability=0;

END IF;


SELECT viability;


END ##

DELIMITER ;








DROP PROCEDURE IF EXISTS adjustAllocations;

DELIMITER ##

CREATE PROCEDURE   adjustAllocations(IN amount DOUBLE,IN branchIdN INT,IN userId INT) 

BEGIN

DECLARE newAllocDep,oldAllDep,newAllocBal,oldAllocBal DOUBLE ;
DECLARE allocTotalId INT;


SELECT allocations_total_deposited,allocations_total_balance,allocations_total_id INTO oldAllDep,oldAllocBal,allocTotalId FROM allocations_total WHERE fk_branch_id_allocations_total=branchIdN;

IF ISNULL(oldAllDep) THEN  SET oldAllDep=0; END IF;

IF ISNULL(oldAllocBal) THEN SET oldAllocBal=0; END IF;

SET newAllocDep=oldAllDep+amount;

SET newAllocBal=oldAllocBal-amount;


UPDATE allocations_total SET allocations_total_deposited=newAllocDep,allocations_total_balance=newAllocBal,update_at=CURRENT_TIMESTAMP WHERE fk_branch_id_allocations_total=branchIdN;

INSERT INTO allocations_ledger VALUES(NULL,0.0,amount,branchIdN,userId,allocTotalId,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

END ##

DELIMITER ;









/* ALLOCATIONS COMPUTATIONS */
DROP FUNCTION IF EXISTS sumOfDebitsAndCreditsBranch;
DELIMITER ##
CREATE FUNCTION sumOfDebitsAndCreditsBranch(percBranchId INT, typeC VARCHAR (45), familyC VARCHAR(45)) 
RETURNS DOUBLE 
DETERMINISTIC
BEGIN

DECLARE theOfTotals DOUBLE ;


IF familyC='INVESTMENT' THEN


IF typeC='DEBITSMADE' THEN

SELECT SUM(trn_debit) INTO theOfTotals FROM trn_general_ledger WHERE fk_branch_id_trn_general_ledger=percBranchId AND fk_account_types_id_trn_general_ledger=2;

ELSEIF typeC='CREDITSMADE' THEN

SELECT SUM(trn_credit) INTO theOfTotals FROM trn_general_ledger WHERE fk_branch_id_trn_general_ledger=percBranchId AND fk_account_types_id_trn_general_ledger=2;


END IF;

END IF;


 IF familyC='BANK' THEN


IF typeC='DEBITSMADE' THEN

SELECT SUM(trn_debit) INTO theOfTotals FROM trn_general_ledger WHERE fk_branch_id_trn_general_ledger=percBranchId AND fk_account_types_id_trn_general_ledger=1;

ELSEIF typeC='CREDITSMADE' THEN

SELECT SUM(trn_credit) INTO theOfTotals FROM trn_general_ledger WHERE fk_branch_id_trn_general_ledger=percBranchId AND fk_account_types_id_trn_general_ledger=1;


END IF;



END IF;



IF ISNULL(theOfTotals) THEN
SET theOfTotals=0;
END IF;

RETURN theOfTotals;
END ##
DELIMITER ;






DROP PROCEDURE IF EXISTS summuryInvestmentPerBranch;

DELIMITER ##

CREATE PROCEDURE   summuryInvestmentPerBranch() 

BEGIN

DROP TABLE IF EXISTS investmentSummuryNow;

CREATE TEMPORARY TABLE investmentSummuryNow(
  id1 INT NOT NULL AUTO_INCREMENT ,
    brancName1 VARCHAR(60),
   withdraws1 DOUBLE,
     deposits1 DOUBLE,
 balance1 DOUBLE,
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;




DROP TABLE IF EXISTS investmentSummuryNow1;

CREATE TEMPORARY TABLE investmentSummuryNow1(
  id INT NOT NULL AUTO_INCREMENT ,
    brancName VARCHAR(60),
   withdraws DOUBLE,
     deposits DOUBLE,
 balance DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

 
 INSERT INTO investmentSummuryNow(id1,brancName1,withdraws1,deposits1,balance1) SELECT NULL,branchName(b.branch_id),sumOfDebitsAndCreditsBranch(b.branch_id,'DEBITSMADE','INVESTMENT'),sumOfDebitsAndCreditsBranch(b.branch_id,'CREDITSMADE','INVESTMENT'),(sumOfDebitsAndCreditsBranch(b.branch_id,'CREDITSMADE','INVESTMENT')-sumOfDebitsAndCreditsBranch(b.branch_id,'DEBITSMADE','INVESTMENT')) FROM branch b;


INSERT INTO investmentSummuryNow1(id,brancName,withdraws,deposits,balance) SELECT * FROM investmentSummuryNow;


INSERT INTO investmentSummuryNow1(id,brancName,withdraws,deposits,balance) SELECT NULL,'TOTAL',SUM(withdraws1),SUM(deposits1), (SUM(deposits1)-SUM(withdraws1)) FROM investmentSummuryNow;


 SELECT * FROM investmentSummuryNow1;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS summuryBanksPerBranch;

DELIMITER ##

CREATE PROCEDURE   summuryBanksPerBranch() 

BEGIN

DROP TABLE IF EXISTS investmentSummuryNow;

CREATE TEMPORARY TABLE investmentSummuryNow(
  id1 INT NOT NULL AUTO_INCREMENT ,
    brancName1 VARCHAR(60),
   withdraws1 DOUBLE,
     deposits1 DOUBLE,
 balance1 DOUBLE,
  PRIMARY KEY(id1)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;




DROP TABLE IF EXISTS investmentSummuryNow1;

CREATE TEMPORARY TABLE investmentSummuryNow1(
  id INT NOT NULL AUTO_INCREMENT ,
    brancName VARCHAR(60),
   withdraws DOUBLE,
     deposits DOUBLE,
 balance DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;

 
 INSERT INTO investmentSummuryNow(id1,brancName1,withdraws1,deposits1,balance1) SELECT NULL,branchName(b.branch_id),sumOfDebitsAndCreditsBranch(b.branch_id,'DEBITSMADE','BANK'),sumOfDebitsAndCreditsBranch(b.branch_id,'CREDITSMADE','BANK'),(sumOfDebitsAndCreditsBranch(b.branch_id,'CREDITSMADE','BANK')-sumOfDebitsAndCreditsBranch(b.branch_id,'DEBITSMADE','BANK')) FROM branch b;


INSERT INTO investmentSummuryNow1(id,brancName,withdraws,deposits,balance) SELECT * FROM investmentSummuryNow;


INSERT INTO investmentSummuryNow1(id,brancName,withdraws,deposits,balance) SELECT NULL,'TOTAL',SUM(withdraws1),SUM(deposits1), (SUM(deposits1)-SUM(withdraws1)) FROM investmentSummuryNow;


 SELECT * FROM investmentSummuryNow1;
END ##
DELIMITER ;





DROP PROCEDURE IF EXISTS theSummuryTotalAllocations;

DELIMITER ##

CREATE PROCEDURE   theSummuryTotalAllocations() 

BEGIN

 SELECT SUM(allocations_total_made) AS totalAllocations,SUM(allocations_total_deposited) AS totalTransfered,SUM(allocations_total_balance) AS totalBalance FROM allocations_total;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS theSummuryTotalInvestments;

DELIMITER ##

CREATE PROCEDURE   theSummuryTotalInvestments() 

BEGIN

 SELECT SUM(trn_debit) AS totalAllocations,SUM(trn_credit) AS totalTransfered,(SUM(trn_credit)-SUM(trn_debit) ) AS totalBalance FROM trn_general_ledger WHERE fk_account_types_id_trn_general_ledger=2;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS theSummuryTotalBankings;

DELIMITER ##

CREATE PROCEDURE   theSummuryTotalBankings() 

BEGIN

 SELECT SUM(trn_debit) AS totalAllocations,SUM(trn_credit) AS totalTransfered,(SUM(trn_credit)-SUM(trn_debit) ) AS totalBalance FROM trn_general_ledger WHERE fk_account_types_id_trn_general_ledger=1;
END ##
DELIMITER ;


