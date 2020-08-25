import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Observable } from 'rxjs';
import { TheBranches } from 'src/app/models/the-branches';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { AdminUserService } from 'src/app/services/admin-user.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import * as jwt_decode from 'jwt-decode';
@Component({
  selector: 'app-post-investment-per-branch',
  templateUrl: './post-investment-per-branch.component.html',
  styleUrls: ['./post-investment-per-branch.component.scss']
})
export class PostInvestmentPerBranchComponent implements OnInit {

    userForm: FormGroup;
    errored: boolean;
    ValidatedNow: boolean;
    serviceErrors: string;
    theBranch: string;
    userName: string;
    values: any;
    numberValue: number;
    theBranches$: Observable<TheBranches[]>;
    txntypeNow = [ {txnType: 'DEPOSIT' }, { txnType: 'WITHDRAWAL' } ];
    // ShiftDetails[]
    constructor(
      private authService: AuthServiceService,
      private adminUserService: AdminUserService,
      private spinner: NgxSpinnerService,
      private router: Router,
      private alertService: AlertService
    ) { }

    ngOnInit() {
      this.theBranch = jwt_decode(this.authService.getJwtToken()).user_branch_name;
      this.userName = jwt_decode(this.authService.getJwtToken()).user_name;
      this.userForm = this.createFormGroup();
      this.theBranches$ = this.authService.getTheBranches();
    }



    createFormGroup() {
      return new FormGroup({
        user_id: new FormControl(''),
        txn_family: new FormControl(''),
        narration: new FormControl('', Validators.compose([Validators.required])),
        branch_name: new FormControl('', Validators.compose([Validators.required])),
        origination: new FormControl(''),
        txn_type: new FormControl('', Validators.compose([Validators.required])),
        txn_amount: new FormControl('', Validators.compose([Validators.required
        // CustomValidator.patternValidator(/^\d+$/, { hasNumber: true }
          // )
        ]))
      });
    }

    revert() {
      this.userForm.reset();
    }
    get fval() { return this.userForm.controls; }

    onKey(event: any) {
// console.log(event.target.value);
      this.values = event.target.value.replace(/[\D\s\._\-]+/g, '');

      this.numberValue = this.values ? parseInt(this.values, 10) : 0;

      // tslint:disable-next-line:no-unused-expression
      this.values =
        this.numberValue === 0 ? '' : this.numberValue.toLocaleString('en-US');

      this.userForm.controls.txn_amount.setValue(this.values);
    }


    checTheValidityOfAmount(){


if ( this.userForm.controls.txn_type.value === 'DEPOSIT'){

  this.userForm.patchValue({
    txn_amount: parseInt( this.userForm.controls.txn_amount.value.replace(/[\D\s\._\-]+/g, ''), 10 )
  });


  // console.table(this.userForm.controls.txn_amount.value);

  this.adminUserService
      .investementViabilityNow(this.userForm)
      .subscribe(
       () => {

          this.ValidatedNow = true;
          this.alertService.success({
            html: '<b>' + 'Ohikire nokurenga warenga' + '</b>' + '<br/>'

          });
        },

        (error: string) => {
          this.errored = true;
          this.serviceErrors = error;
          this.alertService.warning({
            html: '<b>' + this.serviceErrors + '</b>' + '<br/>'

          });

          setTimeout(() => {
            location.reload();
          }, 3000);
        }
      );
    }else{

      this.ValidatedNow = true;
    }
    }

    setSelectedChanges(selectedChange: any) {
      if ( selectedChange.target.value === 'Select TXN Type'){
       this.fval.txn_type.setValidators([Validators.required]);
  }

      if (selectedChange.target.value === 'Select The Branch'){
    this.fval.branch_name.setValidators([Validators.required]);
}

         }

    postTxn() {


      this.spinner.show();

      if ( this.userForm.controls.txn_type.value === 'WITHDRAWAL'){

        this.userForm.patchValue({
          txn_amount: parseInt( this.userForm.controls.txn_amount.value.replace(/[\D\s\._\-]+/g, ''), 10 )
        });
      }
      if (this.userForm.invalid === true) {
        return;
      } else {

        this.userForm.patchValue({
          user_station: jwt_decode(this.authService.getJwtToken()).user_station,
          txn_family: 'INVESTMENT',
          user_id: jwt_decode(this.authService.getJwtToken()).user_id,
          origination: 'HEADOFFICE',
        });


        this.adminUserService.postTheTxn(this.userForm)
          .subscribe(

            (infoe: boolean) => {
              if (infoe) {

                this.spinner.hide();
                this.alertService.warning({ html: '<b>' + 'Investment was successfully made!!' + '</b>' + '<br/>' });


                setTimeout(() => {
                  this.router.navigate(['dashboardadmin/viewbranchinvestemnts/viewportinvestments']);
                }, 3000);
              } else {

                this.spinner.hide();
                this.errored = true;

              }
            },

            (error: string) => {

              this.spinner.hide();
              this.errored = true;
              this.alertService.danger({ html: '<b>' + error + '</b>' + '<br/>' });

              this.spinner.hide();
            }

          );
      }

    }













}
