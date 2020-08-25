var dbconnection = require('../../connectors/dbConnector');




exports.getAllocationsSummuryNowBranch = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL theSummuryTotalAllocationsBranches("+"'"+station+"'"+")";
  // console.log(sql);
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





exports.getAllInvestmentsSummuryNowBranch = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL theSummuryTotalInvestmentsBranches("+"'"+station+"'"+")";
  // console.log(sql);
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

exports.getAllBankingSummuryNowBranch = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL theSummuryTotalBankingsBranches("+"'"+station+"'"+")";
  // console.log(sql);
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