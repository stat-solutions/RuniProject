import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import * as jwt_decode from 'jwt-decode';
import { AdminUserService } from '../../services/admin-user.service';
import { Observable } from 'rxjs';
import { TheBranches } from 'src/app/models/the-branches';
@Component({
  selector: 'app-post-banking-per-branch',
  templateUrl: './post-banking-per-branch.component.html',
  styleUrls: ['./post-banking-per-branch.component.scss']
})
export class PostBankingPerBranchComponent implements OnInit {

    userForm: FormGroup;
    errored: boolean;
    serviceErrors: string;
    theBranch: string;
    theCompany: string;
    values: any;
    numberValue: number;
    theBranches$: Observable<TheBranches[]>;

    txntypeNow = [ {txnType: 'Deposit' }, { txnType: 'Withdrawal' } ];
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
      this.theCompany = jwt_decode(this.authService.getJwtToken()).user_station_company;
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
    setSelectedChanges(selectedChange: any) {
      if ( selectedChange.target.value === 'Select TXN Type'){
       this.fval.txn_type.setValidators([Validators.required]);
  }

      if (selectedChange.target.value === 'Select The Branch'){
    this.fval.branch_name.setValidators([Validators.required]);
}

         }
    postTxn() {

      this.userForm.patchValue({
        txn_amount: parseInt( this.userForm.controls.txn_amount.value.replace(/[\D\s\._\-]+/g, ''), 10 )
      });

      this.spinner.show();

      if (this.userForm.invalid === true) {
        return;
      } else {

        this.userForm.patchValue({
          user_station: jwt_decode(this.authService.getJwtToken()).user_station,
          txn_family: 'BANK',
          user_id: jwt_decode(this.authService.getJwtToken()).user_id,
          origination: 'HEADOFFICE'
        });


        this.adminUserService.postTheTxn(this.userForm)
          .subscribe(

            (success: boolean) => {
              if (success) {

                this.spinner.hide();
                this.alertService.warning({ html: '<b>' + 'Txn was successfully posted!!' + '</b>' + '<br/>' });
                this.router.navigate(['dashboardpump/shiftmanagement']);

                setTimeout(() => {
                  location.reload();
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
