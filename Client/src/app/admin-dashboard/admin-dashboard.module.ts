import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AdminDashboardRoutingModule } from './admin-dashboard-routing.module';
import { AdminDashboardComponent } from './admin-dashboard.component';
import { LayoutAdminComponent } from './layout-admin/layout-admin.component';
import { AdminDashboardLandingComponent } from './admin-dashboard-landing/admin-dashboard-landing.component';
import { PostBankingPerBranchComponent } from './post-banking-per-branch/post-banking-per-branch.component';
import { PostInvestmentPerBranchComponent } from './post-investment-per-branch/post-investment-per-branch.component';
import { ViewBranchBankingsComponent } from './view-branch-bankings/view-branch-bankings.component';
import { ViewBranchInvestmentsComponent } from './view-branch-investments/view-branch-investments.component';
import { ViewAndEditUsersComponent } from './view-and-edit-users/view-and-edit-users.component';
import { NgxSpinnerModule } from 'ngx-spinner';
import { AlertModule } from 'ngx-alerts';
import { ReactiveFormsModule } from '@angular/forms';
import { BsDatepickerModule } from 'ngx-bootstrap/datepicker';


@NgModule({
  declarations: [
    AdminDashboardComponent,
     LayoutAdminComponent,
      AdminDashboardLandingComponent,
       PostBankingPerBranchComponent,
       PostInvestmentPerBranchComponent,
        ViewBranchBankingsComponent,
        ViewBranchInvestmentsComponent,
         ViewAndEditUsersComponent
         ],
  imports: [
    CommonModule,
    AdminDashboardRoutingModule,
    ReactiveFormsModule,
    BsDatepickerModule,
    NgxSpinnerModule,
    AlertModule.forRoot({maxMessages: 5, timeout: 7000, position: 'left'})
  ]
})
export class AdminDashboardModule { }
