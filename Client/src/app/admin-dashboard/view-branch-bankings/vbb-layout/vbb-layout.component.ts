import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Observable } from 'rxjs';
import { UserRole } from 'src/app/models/user-role';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { NgxSpinnerService } from 'ngx-spinner';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
import { TheBranches } from 'src/app/models/the-branches';
import { CustomValidator } from 'src/app/validators/custom-validator';

@Component({
  selector: 'app-vbb-layout',
  templateUrl: './vbb-layout.component.html',
  styleUrls: ['./vbb-layout.component.scss']
})
export class VbbLayoutComponent implements OnInit {

    registered = false;
    submitted = false;
    errored = false;
    posted = false;
    userForm: FormGroup;
    serviceErrors: any = {};
    value: string;
    mySubscription: any;
    myDateValue: Date;
    userRoleInfo$: Observable< UserRole[]>;
    theBranches$: Observable<TheBranches[]>;

    constructor(
      private authService: AuthServiceService,
      private spinner: NgxSpinnerService,
      private router: Router,
      private alertService: AlertService
    ) {}

    ngOnInit() {
      this.myDateValue = new Date();
      this.userForm = this.createFormGroup();
      this.userRoleInfo$ = this.authService.getUserRoles();

      this.theBranches$ = this.authService.getTheBranches();
    }

    createFormGroup() {
      return new FormGroup({
        full_name: new FormControl('', Validators.compose([Validators.required])),
        branch_name: new FormControl(
          '',
          Validators.compose([Validators.required])
        ),

        email: new FormControl('',
        Validators.compose([
          Validators.required,
          Validators.email
        ])),
         user_role: new FormControl(
          '',
          Validators.compose([
            Validators.required

          ])
        ),

        main_contact_number: new FormControl(
          '',
          Validators.compose([
            Validators.required,
            CustomValidator.patternValidator(
              /^(([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9]))$/,
              { hasNumber: true }
            )
          ])
        ),


        // sex: new FormControl('', Validators.compose([Validators.required])),
        // date_of_birth: new FormControl(
        //   '',
        //   Validators.compose([Validators.required])
        // ),
        // user_image: new FormControl('', Validators.compose([Validators.required])),
        password: new FormControl(
          '',
          Validators.compose([
            // 1. Password Field is Required

            Validators.required,

            // 2. check whether the entered password has a number
            CustomValidator.patternValidator(/^(([1-9])([1-9])([1-9])([0-9]))$/, {
              hasNumber: true
            }),
            // 3. check whether the entered password has upper case letter
            // CustomValidatorInitialCompanySetup.patternValidator(/[A-Z]/, { hasCapitalCase: true }),
            // 4. check whether the entered password has a lower-case letter
            // CustomValidatorInitialCompanySetup.patternValidator(/[a-z]/, { hasSmallCase: true }),
            // 5. check whether the entered password has a special character
            // CustomValidatorInitialCompanySetup.
            //   patternValidator(/[!@#$%^&*_+-=;':"|,.<>/?/<mailto:!@#$%^&*_+-=;':"|,.<>/?]/, { hasSpecialCharacters: true }),

            // 6. Has a minimum length of 8 characters
            Validators.minLength(4),
            Validators.maxLength(4)
          ])
        )
      });
    }

    revert() {
      this.userForm.reset();
    }

    revertPetrol() {
      this.userForm.controls.petrol_station.reset();
    }

    get fval() {
      return this.userForm.controls;
    }

    setSelectedChanges(selectedChange: any) {
 if ( selectedChange.target.value === 'Select The Branch'){
  this.fval.branch_name.setValidators([Validators.required]);

 }else{
this.router.navigate([
        '/dashboardadmin/viewbranchbankings/viewportbankingsbranches',
        selectedChange.target.value]);
      }

    }



    onSubmit() {

    //   this.submitted = true;
    //   this.spinner.show();

    //   if (this.userForm.invalid === true) {
    //     return;
    //   } else {

        // console.log(this.userForm);

        // this.authService.registerUser(this.userForm).subscribe(
        //   () => {
        //     this.posted = true;
        //     this.spinner.hide();

        //     this.alertService.info({
        //       html:
        //         '<b>User Registration was successful!!</b>' +
        //         '</br>' +
        //         'Please proceed to the login page'
        //     });

        //     setTimeout(() => {
        //       this.router.navigate(['authpage/loginpage']);
        //     }, 3000);
        //   },

          // (error: string) => {
            //       this.spinner.hide();
            // this.errored = true;
            // this.serviceErrors = error;
            // this.alertService.danger({
            //   html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
            // });
            //       setTimeout(() => {

            //         // location.reload();

            //       }, 3000);
            // console.log(error);
        //     this.spinner.hide();
        //   }
        // );

        //   // this.registered = true;
    //   }
    }
  }









