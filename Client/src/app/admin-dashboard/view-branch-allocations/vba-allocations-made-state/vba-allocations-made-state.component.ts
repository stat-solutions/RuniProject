import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { AllocationTotalStatement } from 'src/app/models/allocation-total-statement';
import { ActivatedRoute } from '@angular/router';
import { AdminUserService } from 'src/app/services/admin-user.service';
import { AllocationsMadeStatement } from 'src/app/models/allocations-made-statement';

@Component({
  selector: 'app-vba-allocations-made-state',
  templateUrl: './vba-allocations-made-state.component.html',
  styleUrls: ['./vba-allocations-made-state.component.scss']
})
export class VbaAllocationsMadeStateComponent implements OnInit {



    userForm: FormGroup;

    branchId: string;

    allocationMadeN$: Observable<AllocationsMadeStatement[]>;


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
          });

      this.allocationMadeN$ = this.adminUserService.allocationsMadehNow(this.branchId);

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
