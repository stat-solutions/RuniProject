
/*  USER ROLES DATA */

--  INSERT INTO the_company_datails VALUES(NULL,'RUNICORP HOLDINGS LTD',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());



--  INSERT INTO branch VALUES(NULL,'RuniCorp Liquor Supermarket',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Shoppers',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Distributors',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Liquors',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RuniCorp Farm',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

-- INSERT INTO user_roles VALUES(1000,'Branch User',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1001,'Admin User',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1002,'Other User',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()); 

-- INSERT INTO  account_types VALUES(NULL,'BANK',100000),(NULL,'INVESTMENT',200000);

--UPDATE users SET  fk_user_role_id_users=1002 WHERE  users_id=100000000;

-- UPDATE users SET users_active_status ='Approved' WHERE users_id=100000002;


--INSERT INTO sms_management VALUES(NULL,5);

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







/* CREATE EVENTS*/


CREATE EVENT manage_interest ON SCHEDULE EVERY 120 MINUTE STARTS CURRENT_TIMESTAMP  DO CALL manage_interest(CURRENT_TIMESTAMP());

CREATE EVENT change_daily_balances ON SCHEDULE EVERY 24 HOUR STARTS TIMESTAMP(CURRENT_DATE)  DO CALL changeBalance(CURRENT_TIMESTAMP());




/* GET SHIFT DETAILS */

DROP PROCEDURE IF EXISTS changeBalance;

DELIMITER ##

CREATE PROCEDURE   changeBalance(IN timeLStampIN TIMESTAMP) 

BEGIN



DECLARE newBalance DOUBLE;

DECLARE balanceId,balExists,stationId,l_done INT;

DECLARE forStations CURSOR FOR SELECT petrol_station_id  FROM petrol_station;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 

 OPEN forStations;

accounts_loop: LOOP 

 FETCH  forStations INTO stationId;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 
 
SELECT COUNT(balance_per_day_id) INTO balExists FROM balance_per_day W HHERE fk_petrol_station_id_balance_per_day=stationId  ORDER BY balance_per_day_id DESC LIMIT 1;

IF balExists>0 THEN

 SELECT the_balance INTO newBalance FROM balance_per_day WHERE fk_petrol_station_id_balance_per_day=stationId ORDER BY balance_per_day_id DESC LIMIT 1;

INSERT INTO balance_per_day VALUES(NULL,newBalance,stationId,CURRENT_TIMESTAMP);

ELSEIF balExists<=0 THEN

INSERT INTO balance_per_day VALUES(NULL,0,stationId,CURRENT_TIMESTAMP);

END IF;

SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forStations;
 
END ##
DELIMITER ;




/* GET SHIFT DETAILS */
DROP PROCEDURE IF EXISTS manage_interestOld;

DELIMITER ##

CREATE PROCEDURE   manage_interestOld(IN timeStatmp TIMESTAMP) 
BEGIN



  DECLARE lcId,noPAccruals, maxNoPAccruals,interestRateAccrual,interestId,n,newnoPAccruals INT;

    DECLARE newexpirelyTime ,expirelyTime TIMESTAMP;

   DECLARE loanAmountR,interestCPMPU,existInterestAmountRemain,NewExistInterestAmountRemain,existingInterest,NewExistingInterest DOUBLE;


  DECLARE l_done INTEGER DEFAULT 0;
  
 DECLARE selectTrnIds CURSOR FOR SELECT lc.lc_manager_id  FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_status=1 AND l.loan_status=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;

 OPEN selectTrnIds;


LedgerIds_loop: LOOP 

 FETCH selectTrnIds into lcId;

 IF l_done=1 THEN

LEAVE LedgerIds_loop;

 END IF;
SELECT timeStatmp;
 
SELECT lc.lc_manager_expirely_time, psl.ps_l_accrual_p_number,lc.lc_manager_no_accruals,psr.petrol_station_interest,i.interest_amount,i.interest_id INTO expirelyTime,maxNoPAccruals,noPAccruals,interestRateAccrual,existingInterest,interestId FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id INNER JOIN petrol_station_rates psr ON psr.fk_petrol_station_id_petrol_station_rates=ps.petrol_station_id INNER JOIN ps_l_accrual_p psl ON psl.fk_petrol_station_id_ps_l_accrual_p=ps.petrol_station_id  INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id  WHERE lc.lc_manager_id=lcId;


SELECT lp.loan_amount_remaining INTO loanAmountR FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc. fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY lp.loan_payments_id DESC LIMIT 1;

SELECT ip.interest_amount_remaining,ip.no_days_paid INTO existInterestAmountRemain,n FROM interest_payments ip INNER JOIN interest i ON ip. fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY ip.interest_payments_id DESC LIMIT 1;


IF expirelyTime<=timeStatmp THEN

SET interestCPMPU=ROUND(((loanAmountR*interestRateAccrual)/100));
SELECT interestCPMPU;
SET NewExistInterestAmountRemain=existInterestAmountRemain+interestCPMPU;

SET NewExistingInterest=existingInterest+interestCPMPU;
SELECT NewExistingInterest;

SET newnoPAccruals=noPAccruals+1;
SELECT newnoPAccruals;
SET newexpirelyTime=expirelyTime + INTERVAL 24 HOUR;
SELECT newexpirelyTime;
UPDATE interest SET interest_amount=NewExistingInterest WHERE interest_id=interestId;


INSERT INTO interest_payments VALUES(NULL,interestCPMPU,0,NewExistInterestAmountRemain,CURRENT_TIMESTAMP,n,interestId);


UPDATE lc_manager SET lc_manager_expirely_time=newexpirelyTime,lc_manager_no_accruals=newnoPAccruals WHERE lc_manager_id=lcId;

IF newnoPAccruals>=maxNoPAccruals THEN

UPDATE lc_manager SET lc_manager_status=2 WHERE lc_manager_id=lcId;

END IF;


END IF;


SET l_done=0;

 END LOOP LedgerIds_loop;



CLOSE selectTrnIds;

END ##
DELIMITER ;










/* GET SHIFT DETAILS */
DROP PROCEDURE IF EXISTS manage_interest;

DELIMITER ##

CREATE PROCEDURE   manage_interest(IN timeStatmp TIMESTAMP) 
BEGIN



  DECLARE lcId,noPAccruals, maxNoPAccruals,interestRateAccrual,interestId,n,newnoPAccruals INT;

    DECLARE newexpirelyTime ,expirelyTime TIMESTAMP;

   DECLARE loanAmountR,interestCPMPU,existInterestAmountRemain,NewExistInterestAmountRemain,existingInterest,NewExistingInterest DOUBLE;


  DECLARE l_done INTEGER DEFAULT 0;
  
 DECLARE selectTrnIds CURSOR FOR SELECT lc.lc_manager_id  FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_status=1 AND l.loan_status=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;

 OPEN selectTrnIds;


LedgerIds_loop: LOOP 

 FETCH selectTrnIds into lcId;

 IF l_done=1 THEN

LEAVE LedgerIds_loop;

 END IF;
 
SELECT timeStatmp;
 
SELECT lc.lc_manager_expirely_time, psl.ps_l_accrual_p_number,lc.lc_manager_no_accruals,psr.petrol_station_interest,i.interest_amount,i.interest_remaining,i.no_days_accrued,i.interest_id,l.loan_amount_remaining INTO expirelyTime,maxNoPAccruals,noPAccruals,interestRateAccrual,existingInterest,existInterestAmountRemain,n,interestId,loanAmountR FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id INNER JOIN petrol_station_rates psr ON psr.fk_petrol_station_id_petrol_station_rates=ps.petrol_station_id INNER JOIN ps_l_accrual_p psl ON psl.fk_petrol_station_id_ps_l_accrual_p=ps.petrol_station_id  INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id  WHERE lc.lc_manager_id=lcId;


-- SELECT lp.loan_amount_remaining INTO loanAmountR FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc. fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY lp.loan_payments_id DESC LIMIT 1;

-- SELECT ip.interest_amount_remaining,ip.no_days_paid INTO existInterestAmountRemain,n FROM interest_payments ip INNER JOIN interest i ON ip. fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY ip.interest_payments_id DESC LIMIT 1;


IF expirelyTime<=timeStatmp THEN

SET interestCPMPU=ROUND(((loanAmountR*interestRateAccrual)/100));
SELECT interestCPMPU;

SET NewExistInterestAmountRemain=existInterestAmountRemain+interestCPMPU;

SET NewExistingInterest=existingInterest+interestCPMPU;

SELECT NewExistingInterest;

SET newnoPAccruals=noPAccruals+1;
SELECT newnoPAccruals;
SET newexpirelyTime=expirelyTime + INTERVAL 24 HOUR;
SELECT newexpirelyTime;

UPDATE interest SET interest_amount=NewExistingInterest,interest_remaining=NewExistInterestAmountRemain WHERE interest_id=interestId;


INSERT INTO interest_payments VALUES(NULL,interestCPMPU,0,NewExistInterestAmountRemain,CURRENT_TIMESTAMP,interestId);


UPDATE lc_manager SET lc_manager_expirely_time=newexpirelyTime,lc_manager_no_accruals=newnoPAccruals WHERE lc_manager_id=lcId;

IF newnoPAccruals>=maxNoPAccruals THEN

UPDATE lc_manager SET lc_manager_status=2 WHERE lc_manager_id=lcId;

END IF;


END IF;


SET l_done=0;

 END LOOP LedgerIds_loop;



CLOSE selectTrnIds;

END ##
DELIMITER ;








