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

@Component({
  selector: 'app-admin-dashboard-landing',
  templateUrl: './admin-dashboard-landing.component.html',
  styleUrls: ['./admin-dashboard-landing.component.scss']
})
export class AdminDashboardLandingComponent implements OnInit {
  count: number;
  items=[];
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

  @ViewChild('staticTabs', { static: false }) staticTabs: TabsetComponent;

  bankTable = [
    {
      txnDate: '23/10/20',
      deposit: 1300000,
      withdraw: 500000,
      balance: 15550000
    },
    {
      txnDate: '24/10/20',
      deposit: 1200000,
      withdraw: 0,
      balance: 4530000
    },
    {
      txnDate: '26/10/20',
      deposit: 2000000,
      withdraw: 0,
      balance: 8530000
    },
    {
      txnDate: '27/10/20',
      deposit: 1300000,
      withdraw: 1500000,
      balance: 6300000
    },
    {
      txnDate: '29/10/20',
      deposit: 300000,
      withdraw: 0,
      balance: 4500000
    }
  ]

  investTable = [
    {
      TxnDate: '23/10/20',
      Withdrawal: 500000,
      Balance: 4500000
    },
    {
      TxnDate: '24/10/20',
      Withdrawal: 0,
      Balance: 4500000
    },
    {
      TxnDate: '26/10/20',
      Withdrawal: 1000000,
      Balance: 3500000
    },
    {
      TxnDate: '27/10/20',
      Withdrawal: 500000,
      Balance: 5000000
    },
    {
      TxnDate: '29/10/20',
      Withdrawal: 0,
      Balance: 5000000
    }
  ]

  investTrackingTable = [
      {
        txnDate: '23/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '24/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '26/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '27/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '28/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '29/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '30/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '31/10/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
      {
        txnDate: '3/11/20',
        allocation: 1300000,
        deposit: 1300000,
        withdraw: 500000,
        balance: 5000000,
      },
    ];
    investmentsTable = [
      {
        TxnDate: '23/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '24/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '26/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '27/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '28/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '29/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '30/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '31/10/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
      {
        TxnDate: '3/11/20',
        Narration: 'Runicorp supermarket bankings',
        AmountRemoved: 1300000,
        AmountAdded: 500000,
        Balance: 5000000,
        PostedBy: 'Suzan',
      },
    ];

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

    //method for filtering out last banked posting
    lastBanking()  {
      let removed = this.investTrackingTable.pop();
      let item=Object.entries(removed);
      let banked=Object.values(item[3]);
      return banked[1];
  }

    //method for filtering out last investment posting
    lastInvestment() {
      let removed = this.investmentsTable.pop();
      let item=Object.entries(removed);
      let invested=Object.values(item[2]);
      return invested[1];
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



























