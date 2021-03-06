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




exports.rejectThatTxn = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL rejectTxnNowS("+"'"+JSON.stringify(data)+"'"+")";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0]);

      resolve(Boolean(results[0][0].posted_successfully>0));
    }
  });
}); }



exports.postTheTxnNow = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL postTheTxnNow("+ "'" + JSON.stringify(data) + "'" +")";
  // console.log(sql);
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





exports.makeAllocationsNow = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL postTheTxnNow("+ "'" + JSON.stringify(data) + "'" +")";
  // console.log(sql);
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



exports.getTheALLLedgerStatementBank = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL getTheALLLedgerStatementBank()";
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

exports.getTheSummuryBank = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL summuryBanksPerBranch()";
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


exports.getTheSummuryTotalInvestemnts = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL theSummuryTotalInvestments()";
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


exports.getTheSummuryTotalBankings = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL theSummuryTotalBankings()";
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


exports.getAllocationsSummuryNowBranch = function (branchName) {
  // console.log(userId);
    return new Promise(function (resolve,next) {
      // console.log(userId);
      var sql = "CALL allocationsTotalBranch("+"'"+branchName+"'"+")";
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


  


    
  exports.getTheApprovalDetails = function () {

    return new Promise(function (resolve,next) {
  
      var sql = "CALL theApprovalDetailsNow()";
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



exports.getTheSummuryTotalAllocations = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL theSummuryTotalAllocations()";
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


exports.getTheSummuryInvest = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL summuryInvestmentPerBranch()";
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



exports.getTheapproveThatTxnNow = function (txnId) {
  // console.log(userId);
    return new Promise(function (resolve,next) {
      // console.log(userId);
      var sql = "CALL approveTheDetailsNow("+"'"+txnId+"'"+")";
    console.log(sql);
    dbconnection.query(sql, null, function (error, results, fields) {
      if (error) {
        return next(error);
      } else {
          console.log(Boolean(results[0][0].posted_successfully>0));
          resolve(Boolean(results[0][0].posted_successfully>0));
      }
    });
  });
  
  }

  exports.getTheAllocationsLedgerState = function (branchName) {
    // console.log(userId);
      return new Promise(function (resolve,next) {
        // console.log(userId);
        var sql = "CALL allocationsLedgerStatement("+"'"+branchName+"'"+")";
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


    

exports.getTheTotalAllocationsState = function () {

  return new Promise(function (resolve,next) {

    var sql = "CALL allocationsTotalStatement()";
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





exports.getallocationTotalStatementBranch = function (branchName) {
  // console.log(userId);
    return new Promise(function (resolve,next) {
      // console.log(userId);
      var sql = "CALL allocationsTotalStatementBranch("+"'"+branchName+"'"+")";
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



  exports.getallocationMadeStatementBranch = function (branchName) {
    // console.log(userId);
      return new Promise(function (resolve,next) {
        // console.log(userId);
        var sql = "CALL allocationsIndivitualStatement("+"'"+branchName+"'"+")";
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
  
  



  exports.checkInvestablility = function (data) {


  return new Promise(function (resolve,next) {

    var sql = "CALL isBranchInvestmentViable("+ "'" + JSON.stringify(data) + "'" +")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0][0]);

      resolve(Boolean(results[0][0].viability>0));
    }
  });
});

  }