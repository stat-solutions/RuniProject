import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { AllocationsMadeStatement } from 'src/app/models/allocations-made-statement';
import { ActivatedRoute } from '@angular/router';
import { AdminUserService } from 'src/app/services/admin-user.service';
import { AllocationLedgerStatement } from 'src/app/models/allocation-ledger-statement';

@Component({
  selector: 'app-vba-allocations-ledger-state',
  templateUrl: './vba-allocations-ledger-state.component.html',
  styleUrls: ['./vba-allocations-ledger-state.component.scss']
})
export class VbaAllocationsLedgerStateComponent implements OnInit {





      userForm: FormGroup;

      branchId: string;

      allocationLedgerN$: Observable<AllocationLedgerStatement[]>;


      theBranch: string;

      private gridApi: any;

     columnDefs: any[] = [];


      constructor(
                  private actRoute: ActivatedRoute,
                  private adminUserService: AdminUserService
                  ) { }

      ngOnInit(): void {



        this.actRoute.paramMap.subscribe(

          params => {

     this.branchId = params.get('branchId');
     this.theBranch = params.get('branchName');

     console.log( this.branchId);
            });

        this.allocationLedgerN$ = this.adminUserService.allocationsLedgerhNow(this.branchId);

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
