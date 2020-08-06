import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { LedgerStatementBranch } from 'src/app/models/ledger-statement-branch';
import { ActivatedRoute } from '@angular/router';
import { AdminUserService } from 'src/app/services/admin-user.service';

@Component({
  selector: 'app-vbi-view-port-branches',
  templateUrl: './vbi-view-port-branches.component.html',
  styleUrls: ['./vbi-view-port-branches.component.scss']
})
export class VbiViewPortBranchesComponent implements OnInit {



    userForm: FormGroup;
    branchName: string;
  investmentStatementBranch$: Observable<LedgerStatementBranch[]>;
    private gridApi: any;

   columnDefs: any[] = [];


    constructor(
                private actRoute: ActivatedRoute,
                private adminUserService: AdminUserService
                ) { }

    ngOnInit(): void {

      this. columnDefs = [
        {headerName: '#', field: 'id', sortable: true, filter: true, resizable: true},
        {headerName: 'TxnDate', field: 'dateX', sortable: true, filter: true, resizable: true},
        {headerName: 'Narration', field: 'narration', sortable: true, filter: true,
         checkboxSelection: true, resizable: true},
        {headerName: 'AmountRemoved', field: 'debit_amount', sortable: true, filter: true, resizable: true},
        {headerName: 'AmountAdded', field: 'credit_amount', sortable: true, filter: true, resizable: true},
        {headerName: 'Balance', field: 'balance',
          sortable: true, filter: true, resizable: true},
        {headerName: 'PostedBy', field: 'user_name', sortable: true, filter: true, resizable: true},

    ];


      this.actRoute.paramMap.subscribe(
        params => {

   this.branchName = params.get('branch');

          });

      this.investmentStatementBranch$ = this.adminUserService.investmentStatementByBranch(this.branchName);

    }


    onGridReady(params) {

      // this.rfqR.getAllProductDetails().subscribe(data => this.dataset = data);
      this.gridApi = params.api;
      this.gridApi.sizeColumnsToFit();

      }

  exportExcel(params) {
    console.log(params);
    this.gridApi = params.api;
    this.gridApi.exportDataAsCsv(params);
  }

  createFormGroup() {
    return new FormGroup({
      branch_name: new FormControl(''),
    });
  }







}
