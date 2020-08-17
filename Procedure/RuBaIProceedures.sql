
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
  id,
  dateX,
  narration,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,FORMAT(l.trn_debit,0) AS debit_amount,FORMAT(l.trn_credit,0) AS credit_amount,FORMAT(runningBal(l.trn_debit,l.trn_credit),0),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN account_types ats ON l.fk_account_types_id_trn_general_ledger= ats.account_types_id WHERE b.branch_name=branchName AND ats.account_type_name='INVESTMENT' LIMIT 30;

SELECT * FROM investmentbranchledger;

END ##
DELIMITER ;




/* GET THE BRANCH BANK LEDGER STATEMENT*/

DROP PROCEDURE IF EXISTS getTheBranchLedgerStatementBank;

DELIMITER ##

CREATE PROCEDURE   getTheBranchLedgerStatementBank(IN branchName VARCHAR(45)) 
BEGIN

DROP TABLE IF EXISTS bankbranchledger;

CREATE TEMPORARY TABLE bankbranchledger(
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
  id,
  dateX,
  narration,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,FORMAT(l.trn_debit,0) AS debit_amount,FORMAT(l.trn_credit,0) AS credit_amount,FORMAT(runningBal(l.trn_debit,l.trn_credit),0),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN account_types ats ON l.fk_account_types_id_trn_general_ledger= ats.account_types_id WHERE b.branch_name=branchName AND ats.account_type_name='BANK' LIMIT 30;

SELECT * FROM bankbranchledger;

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
/* SELECT NULL, the_balance  FROM  balance_per_day_total WHERE fk_account_types_id_balance_per_day_total=1 ORDER BY balance_per_day_total_id DESC LIMIT 1; */



INSERT INTO bankbranchledger(
  id,
  dateX,
  narration,
  branch,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,b.branch_name AS branch,FORMAT(l.trn_debit,0) AS debit_amount,FORMAT(l.trn_credit,0) AS credit_amount,FORMAT(runningBal(l.trn_debit,l.trn_credit),0),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN  account_types ats ON l.fk_account_types_id_trn_general_ledger=ats.account_types_id WHERE  ats.account_type_name='BANK' LIMIT 30;

SELECT * FROM bankbranchledger;


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
/* SELECT NULL, the_balance  FROM  balance_per_day_total WHERE fk_account_types_id_balance_per_day_total=1 ORDER BY balance_per_day_total_id DESC LIMIT 1; */



INSERT INTO investmentBranchledger(
  id,
  dateX,
  narration,
  branch,
  debit_amount,
  credit_amount,
  balance,
  user_name
  ) SELECT NULL,DATE_FORMAT(DATE(l.trn_date),"%d/%m/%Y") AS dateX,l.trn_narration AS narration,b.branch_name AS branch,FORMAT(l.trn_debit,0) AS debit_amount,FORMAT(l.trn_credit,0) AS credit_amount,FORMAT(runningBal(l.trn_debit,l.trn_credit),0),cbd.full_name FROM trn_general_ledger l  INNER JOIN  branch b ON l.fk_branch_id_trn_general_ledger=b.branch_id INNER JOIN users u ON l.fk_user_id_posted_by_trn_general_ledger_id=u. users_id INNER JOIN common_bio_data cbd ON u.users_id =cbd.fk_users_id_common_bio_data INNER JOIN  account_types ats ON l.fk_account_types_id_trn_general_ledger=ats.account_types_id WHERE  ats.account_type_name='INVESTMENT' LIMIT 30;

SELECT * FROM investmentBranchledger;


END ##
DELIMITER ;



/* 
 DESCRIBE allocations_total;
+--------------------------------+-----------+------+-----+---------+----------------+
| Field                          | Type      | Null | Key | Default | Extra          |
+--------------------------------+-----------+------+-----+---------+----------------+
| allocations_total_id           | int(11)   | NO   | PRI | NULL    | auto_increment |
| allocations_total_made         | double    | YES  |     | NULL    |                |
| allocations_total_deposited    | double    | YES  |     | NULL    |                |
| allocations_total_balance      | double    | YES  |     | NULL    |                |
| fk_branch_id_allocations_total | int(11)   | YES  | MUL | NULL    |                |
| created_at                     | timestamp | YES  |     | NULL    |                |
| update_at                      | timestamp | YES  |     | NULL    |                |

*/



/* ALLOCATIONS COMPUTATIONS */
DROP FUNCTION IF EXISTS alloTotalComp;
DELIMITER ##
CREATE FUNCTION alloTotalComp(totalAlloc DOUBLE,percBranchId INT,typeC VARCHAR (45) ) 
RETURNS DOUBLE 
DETERMINISTIC
BEGIN
DECLARE allocMade, runningBal,newRunningBal,branchPercent DOUBLE;


SELECT branch_percentages INTO branchPercent FROM branch_constants WHERE fk_branch_id_branch_constants=percBranchId;
IF typeC='ALLOCTOTALMADE' THEN

SELECT allocations_total_made INTO runningBal FROM allocations_total WHERE fk_branch_id_allocations_total=percBranchId;

SET allocMade=((totalAlloc)*(branchPercent/100));

SET newRunningBal=runningBal+allocMade;

END IF;



IF typeC='ALLOCBALANCE' THEN

SELECT allocations_total_balance INTO runningBal FROM allocations_total WHERE fk_branch_id_allocations_total=percBranchId;

SET allocMade=((totalAlloc)*(branchPercent/100));

SET newRunningBal=runningBal+allocMade;

END IF;



RETURN newRunningBal;
END ##
DELIMITER ;
/* mysql> SHOW COLUMNS FROM branch_constants;
+-------------------------------+-----------+------+-----+---------+----------------+
| Field                         | Type      | Null | Key | Default | Extra          |
+-------------------------------+-----------+------+-----+---------+----------------+
| branch_constants_id           | int(11)   | NO   | PRI | NULL    | auto_increment |
| branch_percentages            | double    | YES  |     | NULL    |                |
| fk_branch_id_branch_constants | int(11)   | YES  | MUL | NULL    |                |
| created_at                    | timestamp | YES  |     | NULL    |                |
| update_at                     | timestamp | YES  |     | NULL    | */

/* GET SHIFT DETAILS */

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

UPDATE allocations_total AS ft, (SELECT alloTotalComp(amount,branch_id,'ALLOCTOTALMADE') AS totalAllocation,alloTotalComp(amount,branch_id,'ALLOCBALANCE') AS balanceAllocation,branch_id as idX  FROM branch ) AS b SET ft.allocations_total_made=b.totalAllocation,ft.allocations_total_balance=b.balanceAllocation WHERE ft.fk_branch_id_allocations_total=b.idX;


 
END ##
DELIMITER ;


/* UPDATE allocations_total AS ft, (SELECT branch_id FROM branch  )AS b  SET ft.allocations_total_made=20000.0 WHERE ft.fk_branch_id_allocations_total= b.branch_id; */



