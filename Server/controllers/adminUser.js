var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var serviceU = require('../services/db_services/adminUserDashboardService');
router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());






  router.post('/postTheTxn', function(req, res,next) {
    // console.log("ddddddddddddddddddddddddddddddddddddddd");
    serviceU.postTheTxnNow(req.body).then( function(results) {
      res.status(200).json(results);
    }
    ).catch(next);
    });


    

    

    router.post('/makeAllocation', function(req, res,next) {
      // console.log("ddddddddddddddddddddddddddddddddddddddd");
      serviceU.makeAllocationsNow(req.body).then( function(results) {
        res.status(200).json(results);
      }
      ).catch(next);
      });
     

      


      router.post ('/rejectTxn', function(req, res,next) {
        
        serviceU.rejectThatTxn(req.body).then( function(results) {

          console.log(results);

            if(results){
       
          res.status(200).json(results);

        }else{

          res.status(700).json(results);
        }

        } ).catch(next);
       
       
       });
    

      router.post ('/investementViability', function(req, res,next) {
        
        serviceU.checkInvestablility(req.body).then( function(results) {

          console.log(results);

            if(results){
       
          res.status(200).json(results);

        }else{

          res.status(700).json(results);
        }

        } ).catch(next);
       
       
       });
    
    

       router.get('/theApprovalDetails', function(req, res,next) {

        
        
        serviceU.getTheApprovalDetails(req.query.id).then( function(results) {
          res.setHeader('Content-Type', 'application/json');
          res.json(results);
        } ).catch(next);
      
       });

       router.get('/approveThatTxnNow', function(req, res,next) {
        serviceU.getTheapproveThatTxnNow(req.query.id).then( function(results) {
          // console.log("results");
          // console.log(results);

            if(results){
              console.log(results);
          res.status(200).json(results);

        }else{

          res.status(700).json(results);
        }

        } ).catch(next);
           
           
           });

router.get('/summuryTotalInvestmentsNow', function(req, res,next) {
        
  serviceU.getTheSummuryTotalInvestemnts().then( function(results) {
    res.setHeader('Content-Type', 'application/json');
    res.json(results);
  } ).catch(next);
 });

 



 router.get('/summuryTotalBankingNow', function(req, res,next) {
        
  serviceU.getTheSummuryTotalBankings().then( function(results) {
    res.setHeader('Content-Type', 'application/json');
    res.json(results);
  } ).catch(next);
 });

       
       
       router.get('/summuryTotalAllocations', function(req, res,next) {
        
        serviceU.getTheSummuryTotalAllocations().then( function(results) {
          res.setHeader('Content-Type', 'application/json');
          res.json(results);
        } ).catch(next);
       });


       router.get('/bankingSummuryLedger', function(req, res,next) {
        
        serviceU.getTheSummuryBank().then( function(results) {
          res.setHeader('Content-Type', 'application/json');
          res.json(results);
        } ).catch(next);
       
       
       });


       router.get('/investSummuryLedger', function(req, res,next) {
        
        serviceU.getTheSummuryInvest().then( function(results) {
          res.setHeader('Content-Type', 'application/json');
          res.json(results);
        } ).catch(next);
       
       
       });


         router.get('/allocationLedgerStatement', function(req, res,next) {
        
           serviceU.getTheAllocationsLedgerState(req.query.id).then( function(results) {
             res.setHeader('Content-Type', 'application/json');
             res.json(results);
           } ).catch(next);
          
          
          });

          
       
          

      router.get('/allocationTotalStatement', function(req, res,next) {
        // console.log(req.query.id);
         serviceU.getTheTotalAllocationsState().then( function(results) {
           res.setHeader('Content-Type', 'application/json');
           res.json(results);
         } ).catch(next);});


         
      
         


         router.get('/allocationMadeStatement', function(req, res,next) {
          console.log(req.query.id);
           serviceU.getallocationMadeStatementBranch(req.query.id).then( function(results) {
             res.setHeader('Content-Type', 'application/json');
             res.json(results);
           } ).catch(next);});
   
         router.get('/allocationTotalStatementBranch', function(req, res,next) {
          console.log(req.query.id);
           serviceU.getallocationTotalStatementBranch(req.query.id).then( function(results) {
             res.setHeader('Content-Type', 'application/json');
             res.json(results);
           } ).catch(next);});


    router.get('/bankLedgerStatement', function(req, res,next) {
      // console.log(req.query.id);
       serviceU.getTheALLLedgerStatementBank().then( function(results) {
         res.setHeader('Content-Type', 'application/json');
         res.json(results);
       } ).catch(next);});
    

       router.get('/investmentLedgerStatement', function(req, res,next) {
        console.log(req.query.id);
         serviceU.getTheALLLedgerStatementInvestment().then( function(results) {
           res.setHeader('Content-Type', 'application/json');
           res.json(results);
         } ).catch(next);});



  router.get('/branchLedgerStatementBank', function(req, res,next) {
   console.log(req.query.id);
    serviceU.getThebranchLedgerStatementBank(req.query.id).then( function(results) {
      res.setHeader('Content-Type', 'application/json');
      res.json(results);
    } ).catch(next);});

    
    


    router.get('/branchLedgerStatementInvestment', function(req, res,next) {
      console.log(req.query.id);
       serviceU.getThebranchLedgerStatementInvestment(req.query.id).then( function(results) {
         res.setHeader('Content-Type', 'application/json');
         res.json(results);
       } ).catch(next);});

module.exports = router;