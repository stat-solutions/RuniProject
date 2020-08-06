var express = require('express');
var router = express.Router();
var request = require('request');
var SMS = require('../services/other_services/smsService');
const  jwt  =  require('jsonwebtoken');
const  bcrypt  =  require('bcrypt'); 
const randtoken = require('rand-token');
const passport = require('passport');
const JwtStrategy = require('passport-jwt').Strategy;
const ExtractJwt = require('passport-jwt').ExtractJwt;
var bodyParser = require('body-parser');
const saltRounds=14;
const CRYPITOL_KEY = "secretkey23456";
var authDbService = require('../services/db_services/authService');
const refreshTokens = {};
const passportOpts = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: CRYPITOL_KEY
};

passport.use(new JwtStrategy(passportOpts, function (jwtPayload, done) {
  const expirationDate = new Date(jwtPayload.exp * 1000);
  if(expirationDate < new Date()) {
    return done(null, false);
  }
  done(null, jwtPayload);
}))

passport.serializeUser(function (user, done) {
  done(null, user.main_contact_number)
});

router.use(bodyParser.urlencoded({ extended: false }));

router.use(bodyParser.json());



router.get('/getUserRoles', function(req, res,next) {
  //  console.log("ddddddddddddddddddddddddddddddddddddddd");
  authDbService.getTheUserRoles().then( function(results) {
    res.setHeader('Content-Type', 'application/json');
    res.json(results);

    
  }
  
  ).catch(next);
  
  });

  router.get('/getTheBranches', function(req, res,next) {
    // console.log("ddddddddddddddddddddddddddddddddddddddd");
    authDbService.getTheBrachesDb().then( function(results) {
      res.setHeader('Content-Type', 'application/json');
      res.json(results);
  
      
    }
    
    ).catch(next);
    
    });


     
router.get('/allThePetrolStations', function(req, res,next) {

  authDbService.getThePetrolStations(req.query.id,next).then( function(results) {
    res.setHeader('Content-Type', 'application/json');
    res.json(results);
  }
  
  ).catch(next);

 } );
  
router.post('/login', function(req, res,next) {

  authDbService.theUserExists(req.body.email,req.body.user_role11,next).then( function(results1){
// console.log(results1);
 if(results1){

  authDbService.getDbCredentialsNormalUser(req.body.email,req.body.user_role11,next).then(function(results) {
// console.log(req.body.password);
// console.log(results.users_password);
    if(bcrypt.compareSync(req.body.password, results.users_password)){

    const payload = {
     "user_id": results.users_id,
     "user_contact": results. mobile_contact,
     "user_role": results. fk_user_roles_id_users,
     "user_email": results. users_email,
     "user_branch_id": results.fk_branch_id_users,
     "user_status": results. users_active_status,
     "user_name": results. full_name,
     "user_branch_name": results.branch_name
   }
    // console.log(payload);
   const token = jwt.sign(payload, CRYPITOL_KEY, {expiresIn: 10000});
   const refreshToken = randtoken.uid(256);
   refreshTokens[refreshToken] = results.user_name;
   res.json({jwt: token, refreshToken: refreshToken});

    }else{

      res.status(405).json('Invalid email or password');
   
    }
   
  

     
   }
   
   ).catch(next);

 }else{

  res.status(407).json('User Not Registered');

 }
  
}

).catch(next);

});




router.post('/testTableData', function(req, res,next) {

  // console.log(JSON.stringify(req.body));
  authDbService.registerPhoneNumberPassword(req.body).then( function(results) {


    res.json('Received');
  })
 


});



router.post('/register', function(req, res,next) {
   
    const  main_email  =  req.body.email;
  
      const  password  = bcrypt.hashSync(req.body.password, saltRounds);
       
      const refreshToken = randtoken.uid(256);

      authDbService.theUserExists(req.body.email,req.body.user_role, next).then( function(results1){
        // console.log(results1);
         if(results1){
  
          res.status(401).json('User email already exists!!!');
  
         }else{

          
          authDbService.registerTheUser(req.body,main_email,password,refreshToken,next).then( function(results) {
  
// console.log('before'+results.mobile_contact);

            const payload = {
              "user_id": results.users_id,
              "user_contact":results.mobile_contact,
              "user_role": results.fk_user_roles_id_users
            }

const sms={
  'contanct_number':results.mobile_contact,
  'message':'Welcome to RUBAI APP!!. You have successfully registered. Please contact admin for approval and then login!!'
  
}


authDbService.checkSMSBalance(next).then(function(result){

  if(result){


    // console.log('First'+' '+sms);
    
    SMS.sendSMS(sms,next);
  }

}).catch(next);


            const token = jwt.sign(payload, CRYPITOL_KEY, { expiresIn: 600 })

  res.json({jwt: token, refreshToken: refreshToken});
            
          }
          
          ).catch(next);
       
  
         }
      }).catch(next);;
  
  
  
  
  });  

  router.post('/registerAdmin', function(req, res,next) {
   
    const  main_contact_number  =  req.body.main_contact_number;
  
      const  password  = bcrypt.hashSync(req.body.password, saltRounds);
       
      const refreshToken = randtoken.uid(256);

      authDbService.theUserExists(req.body.main_contact_number,next).then( function(results1){
        // console.log(results1);
         if(results1){
  
          res.status(401).json('User mobile number already exists!!!');
  
         }else{

          
          authDbService.registerPhoneNumberPasswordAdmin(main_contact_number,password,refreshToken,next).then( function(results) {
  
            const payload = {
              "user_id": results.user_id,
              "user_contact":results.user_name,
              "user_role": results.fk_users_roles_id_users
            }

            const token = jwt.sign(payload, CRYPITOL_KEY, { expiresIn: 600 })

  res.json({jwt: token, refreshToken: refreshToken});
            
          }
          
          ).catch(next);
       
  
         }
      }).catch(next);;
  
  
  
  
  });  
  router.post('/logout', function (req, res) { 
    const refreshToken = req.body.refreshToken;
    if (refreshToken in refreshTokens) { 
      delete refreshTokens[refreshToken];
    } 
    res.sendStatus(204); 
  });
  
  router.post('/refresh', function (req, res) {
      const refreshToken = req.body.refreshToken;
      
  
      if (refreshToken in refreshTokens) {
        const payload = {
              "user_id": results.user_id,
              "user_contact":results.user_name,
              "user_role": results.fk_users_roles_id_users
            }
        const token = jwt.sign(payload, CRYPITOL_KEY, { expiresIn: 600 });
        res.json({jwt: token})
      }
      else {
        res.sendStatus(401);
      }
  });


module.exports = router;













