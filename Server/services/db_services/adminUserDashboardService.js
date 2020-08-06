var request = require('request');
var dbconnection = require('../../connectors/dbConnector');

exports.updateClient = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL updateCustomerDetails("+"'"+JSON.stringify(data)+"'"+")";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0]);

     resolve(results[0]);
    }
  });
}); }





exports.postTheTxnNow = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL postTheTxnNow("+ "'" + JSON.stringify(data) + "'" +")";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(Boolean(results[0][0].posted_successfully>0));
    }
  });
});

}









// exports.saveCustomerDetails = function (data) {

//     return new Promise(function (resolve,next) {
  
//       var sql = "CALL saveCustomerDetails("+"'"+JSON.stringify(data)+"'"+")";
//     console.log(sql);
//     dbconnection.query(sql, null, function (error, results, fields) {
//       if (error) {
//         return next(error);
//       } else {
  
//         // console.log(results[0]);
  
//        resolve(results[0]);
//       }
//     });
//   }); }
  

  
// exports.saveStageDetails = function (data) {

//   return new Promise(function (resolve,next) {

//     var sql = "CALL saveStageDetails("+"'"+JSON.stringify(data)+"'"+")";
//   // console.log(sql);
//   dbconnection.query(sql, null, function (error, results, fields) {
//     if (error) {
//       return next(error);
//     } else {

//       // console.log(results[0]);

//      resolve(results[0]);
//     }
//   });
// }); }
  

exports.getTheALLLedgerStatementBank = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL getTheALLLedgerStatementBank()";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
        // console.log(results[0]);
     resolve(results[0]);
    }
  });
});

}



exports.getTheALLLedgerStatementInvestment = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL getTheALLLedgerStatementInvestment()";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
        // console.log(results[0]);
     resolve(results[0]);
    }
  });
});

}






exports.getThebranchLedgerStatementInvestment = function (branchName) {
  // console.log(userId);
    return new Promise(function (resolve,next) {
      // console.log(userId);
      var sql = "CALL getTheBranchLedgerStatementInvestment("+"'"+branchName+"'"+")";
    console.log(sql);
    dbconnection.query(sql, null, function (error, results, fields) {
      if (error) {
        return next(error);
      } else {
          // console.log(results[0]);
       resolve(results[0]);
      }
    });
  });
  
  }


exports.getThebranchLedgerStatementBank = function (branchName) {
  // console.log(userId);
    return new Promise(function (resolve,next) {
      // console.log(userId);
      var sql = "CALL getTheBranchLedgerStatementBank("+"'"+branchName+"'"+")";
    console.log(sql);
    dbconnection.query(sql, null, function (error, results, fields) {
      if (error) {
        return next(error);
      } else {
          // console.log(results[0]);
       resolve(results[0]);
      }
    });
  });
  
  }
  
  



  // exports.numberPlateAlreadyExists = function (theNumberPlate) {

  //   return new Promise(function (resolve,next) {
  
  //     var sql = "CALL numberPlateAlreadyExists("+"'"+theNumberPlate+"'"+")";
  //   // console.log(sql);
  //   dbconnection.query(sql, null, function (error, results, fields) {
  //     if (error) {
  //       return next(error);
  //     } else {
  //         // console.log(results[0]);
  //         resolve(Boolean(results[0][0].number_plate_exists>0));
  //     }
  //   });
  // });
  
  // }