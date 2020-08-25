var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var serviceU = require('../services/db_services/branchUserDashboardService');
router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());





         router.get('/allocationBranchNow', function(req, res,next) {
        
           serviceU.getAllocationsSummuryNowBranch(req.query.id).then( function(results) {
             res.setHeader('Content-Type', 'application/json');
             res.json(results);
           } ).catch(next);
          
          
          });


          router.get('/investmentTBranchNow', function(req, res,next) {
        
            serviceU.getAllInvestmentsSummuryNowBranch(req.query.id).then( function(results) {
              res.setHeader('Content-Type', 'application/json');
              res.json(results);
            } ).catch(next);
           
           
           });



           router.get('/bankingTBranchNow', function(req, res,next) {
        
            serviceU.getAllBankingSummuryNowBranch(req.query.id).then( function(results) {
              res.setHeader('Content-Type', 'application/json');
              res.json(results);
            } ).catch(next);
           
           
           });


module.exports = router;