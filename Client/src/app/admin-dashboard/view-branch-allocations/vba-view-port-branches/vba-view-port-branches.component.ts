import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FormGroup, FormControl } from '@angular/forms';
import { AdminUserService } from 'src/app/services/admin-user.service';
import { Observable } from 'rxjs';
import { LedgerStatementBranch } from 'src/app/models/ledger-statement-branch';
import { AllocationTotalStatement } from 'src/app/models/allocation-total-statement';

@Component({
  selector: 'app-vba-view-port-branches',
  templateUrl: './vba-view-port-branches.component.html',
  styleUrls: ['./vba-view-port-branches.component.scss']
})
export class VbaViewPortBranchesComponent implements OnInit {

  userForm: FormGroup;

  branchId: string;

  totalAllocationBranch$: Observable<AllocationTotalStatement[]>;

  private gridApi: any;

 columnDefs: any[] = [];


  constructor(
              private actRoute: ActivatedRoute,
              private adminUserService: AdminUserService
              ) { }

  ngOnInit(): void {



    this.actRoute.paramMap.subscribe(

      params => {

 this.branchId = params.get('branch');

        });

    this.totalAllocationBranch$ = this.adminUserService.allocationsTotalStateBranchNow(this.branchId);

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
