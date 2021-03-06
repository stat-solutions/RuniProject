import { Observable } from 'rxjs';
import { SummuryAllocations } from 'src/app/models/summury-allocations';
import { Component, OnInit } from '@angular/core';
import { BranchUserService } from 'src/app/services/branch-user.service';
import * as jwt_decode from 'jwt-decode';
import { AuthServiceService } from 'src/app/services/auth-service.service';
@Component({
  selector: 'app-branch-user-dashboard-landing',
  templateUrl: './branch-user-dashboard-landing.component.html',
  styleUrls: ['./branch-user-dashboard-landing.component.scss'],
})
export class BranchUserDashboardLandingComponent implements OnInit {


  SummuryAllocationsBranch$: Observable<SummuryAllocations[]>;

  SummuryInvestmentBranch$: Observable<SummuryAllocations[]>;


  SummuryBankingtBranch$: Observable<SummuryAllocations[]>;

  count: number;
items=[];

bankTable = [
  {
    TxnDate: '23/10/20',
    Deposit: 1300000,
    Withdrawal: 500000
  },
  {
    TxnDate: '24/10/20',
    Deposit: 1200000,
    Withdrawal: 0
  },
  {
    TxnDate: '26/10/20',
    Deposit: 2000000,
    Withdrawal: 0
  },
  {
    TxnDate: '27/10/20',
    Deposit: 1300000,
    Withdrawal: 1500000
  },
  {
    TxnDate: '29/10/20',
    Deposit: 300000,
    Withdrawal: 0
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

bankingsTable = [
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


  constructor(   private authService: AuthServiceService,

                 private branchUser: BranchUserService

    ) {}

  ngOnInit(): void {

    this. SummuryAllocationsBranch$ = this.branchUser.allocationPerBranchNow(jwt_decode(this.authService.getJwtToken()).user_branch_name);

    this. SummuryInvestmentBranch$ = this.branchUser.investmentPerBranchNow(jwt_decode(this.authService.getJwtToken()).user_branch_name);

    this. SummuryBankingtBranch$ = this.branchUser.bankingPerBranchNow(jwt_decode(this.authService.getJwtToken()).user_branch_name);
  }


    }
