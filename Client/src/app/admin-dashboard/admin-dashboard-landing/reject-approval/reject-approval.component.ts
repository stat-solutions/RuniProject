import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { Observable } from 'rxjs';
import { AllocationTotalStatement } from 'src/app/models/allocation-total-statement';
import { ActivatedRoute } from '@angular/router';
import { AdminUserService } from 'src/app/services/admin-user.service';

@Component({
  selector: 'app-reject-approval',
  templateUrl: './reject-approval.component.html',
  styleUrls: ['./reject-approval.component.scss']
})
export class RejectApprovalComponent implements OnInit {


    userForm: FormGroup;

    approvalIdNow: string;

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

   this.approvalIdNow = params.get('approvalId');

          });

      this.userForm = this.createFormGroup();

    }

    createFormGroup() {
      return new FormGroup({
        rejection_reason: new FormControl(''),
      });
    }

    get fval() {
      return this.userForm.controls;
    }




rejectWithReason(){



}





}
