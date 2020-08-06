import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { LedgerStatement } from 'src/app/models/ledger-statement';
import { AdminUserService } from 'src/app/services/admin-user.service';

@Component({
  selector: 'app-vbi-view-port',
  templateUrl: './vbi-view-port.component.html',
  styleUrls: ['./vbi-view-port.component.scss']
})
export class VbiViewPortComponent implements OnInit {



        userForm: FormGroup;
        branchName: string;
        investmentStatementBranchFull$: Observable<LedgerStatement[]>;
        private gridApi: any;

       columnDefs: any[] = [];


        constructor(
                    private adminUserService: AdminUserService
                    ) { }

        ngOnInit(): void {

          this. columnDefs = [
            {headerName: '#', field: 'id', sortable: true, filter: true, resizable: true},
            {headerName: 'Txn Date', field: 'dateX', sortable: true, filter: true, resizable: true},
            {headerName: 'Narration', field: 'narration', sortable: true, filter: true,
             checkboxSelection: true, resizable: true},
            {headerName: 'Branch', field: 'branch', sortable: true, filter: true, resizable: true},
            {headerName: 'AmntRemoved', field: 'debit_amount', sortable: true, filter: true, resizable: true},
            {headerName: 'AmntAdded', field: 'credit_amount', sortable: true, filter: true, resizable: true},
            {headerName: 'Balance', field: 'balance',
              sortable: true, filter: true, resizable: true},
            {headerName: 'PostedBy', field: 'user_name', sortable: true, filter: true, resizable: true},

        ];

          this.investmentStatementBranchFull$ = this.adminUserService.investmentStatementAll();
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
