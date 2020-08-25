import { Component, OnInit, ViewChild } from '@angular/core';
import { TabsetComponent } from 'ngx-bootstrap/tabs';
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
import { AdminUserService } from 'src/app/services/admin-user.service';
import { AllocationTotalStatement } from 'src/app/models/allocation-total-statement';
import { LedgerStatement } from 'src/app/models/ledger-statement';
import { SummuryLedger } from 'src/app/models/summury-ledger';
import { SummuryAllocations } from 'src/app/models/summury-allocations';
import { ApprovalDetails } from 'src/app/models/approval-details';

@Component({
  selector: 'app-admin-dashboard-landing',
  templateUrl: './admin-dashboard-landing.component.html',
  styleUrls: ['./admin-dashboard-landing.component.scss']
})
export class AdminDashboardLandingComponent implements OnInit {
  count: number;
  items = [];
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
      allocationsToal$: Observable<AllocationTotalStatement[]>;
      investmentStatementBranchFull$: Observable<LedgerStatement[]>;
      summuryInvestment$: Observable<SummuryLedger[]>;
      summuryBanking$: Observable<SummuryLedger[]>;
      summuryTotalAllocations$: Observable<SummuryAllocations[]>;
      summuryInvestmentTotal$: Observable<SummuryAllocations[]>;
      summuryBankingTotal$: Observable<SummuryAllocations[]>;
      approvalDetailsNow$: Observable<ApprovalDetails[]>;

  // @ViewChild('staticTabs', { static: false }) staticTabs: TabsetComponent;



    constructor(
        private authService: AuthServiceService,
        private spinner: NgxSpinnerService,
        private router: Router,
        private alertService: AlertService,
        private adminUserService: AdminUserService
      ) {}

      ngOnInit() {
        this.myDateValue = new Date();

        this.userForm = this.createFormGroup();

        this.userRoleInfo$ = this.authService.getUserRoles();

        this.theBranches$ = this.authService.getTheBranches();

        this. allocationsToal$ = this.adminUserService.allocationsTotalState();

        this.investmentStatementBranchFull$ = this.adminUserService.investmentStatementAll();


        this. summuryInvestment$ = this.adminUserService.theSummuryInvestNow();

        this.summuryBanking$ = this.adminUserService.theSummuryBankingNow();


        this.summuryTotalAllocations$ = this.adminUserService.theSummuryTotalAllocations();


        this. summuryInvestmentTotal$ = this.adminUserService.summuryTotalInvestments();

        this.summuryBankingTotal$ = this.adminUserService.summuryTotalBanking();


        this.approvalDetailsNow$ = this.adminUserService.getTheApprovalDetailsNow();
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
          password: new FormControl(
            '',
            Validators.compose([
              // 1. Password Field is Required

              Validators.required,

              // 2. check whether the entered password has a number
              CustomValidator.patternValidator(/^(([1-9])([1-9])([1-9])([0-9]))$/, {
                hasNumber: true
              }),
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


      approvePostedTxn(txnIdNow: string){
        this.spinner.show();
        this.adminUserService
        .approveTheTxnNow(txnIdNow)
        .subscribe(
         () => {
          this.spinner.hide();
// console.log('Txn was successfully Approved');
          this.alertService.success({
              html: '<b>' + 'Txn was successfully Approved' + '</b>' + '<br/>'

            });

          setTimeout(() => {
              location.reload();
            }, 1000);
          },

          (error: string) => {
            this.errored = true;
            this.serviceErrors = error;
            this.spinner.hide();
            this.alertService.warning({
              html: '<b>' + this.serviceErrors + '</b>' + '<br/>'

            });

            setTimeout(() => {
              location.reload();
            }, 3000);
          }
        );


      }
      rejectPostedTxn(txnIdNowR: number){



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
      }
    }



























