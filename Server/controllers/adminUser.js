var express = require('express');
var request = require('request');
var router = express.Router();
var bodyParser = require('body-parser');
var serviceU = require('../services/db_services/adminUserDashboardService');
var authDbService = require('../services/db_services/authService');
router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());
var SMS = require('../services/other_services/smsService');






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


    

    router.get('/bankLedgerStatement', function(req, res,next) {
      console.log(req.query.id);
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