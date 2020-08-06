import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AdminDashboardRoutingModule } from './admin-dashboard-routing.module';
import { AdminDashboardComponent } from './admin-dashboard.component';
import { LayoutAdminComponent } from './layout-admin/layout-admin.component';
import { AdminDashboardLandingComponent } from './admin-dashboard-landing/admin-dashboard-landing.component';
import { PostBankingPerBranchComponent } from './post-banking-per-branch/post-banking-per-branch.component';
import { PostInvestmentPerBranchComponent } from './post-investment-per-branch/post-investment-per-branch.component';
import { ViewBranchInvestmentsComponent } from './view-branch-investments/view-branch-investments.component';
import { ViewAndEditUsersComponent } from './view-and-edit-users/view-and-edit-users.component';
import { NgxSpinnerModule } from 'ngx-spinner';
import { AlertModule } from 'ngx-alerts';
import { ReactiveFormsModule } from '@angular/forms';
import { AgGridModule } from 'ag-grid-angular';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { ViewBranchBankingsComponent } from './view-branch-bankings/view-branch-bankings.component';
import { VbbLayoutComponent } from './view-branch-bankings/vbb-layout/vbb-layout.component';
import { VbbViewPortComponent } from './view-branch-bankings/vbb-view-port/vbb-view-port.component';
import { VbbViewPortBranchesComponent } from './view-branch-bankings/vbb-view-port-branches/vbb-view-port-branches.component';
import { DatepickerModule, BsDatepickerModule } from 'ngx-bootstrap/datepicker';
import { VbiViewPortComponent } from './view-branch-investments/vbi-view-port/vbi-view-port.component';
import { VbiLayoutComponent } from './view-branch-investments/vbi-layout/vbi-layout.component';
import { VbiViewPortBranchesComponent } from './view-branch-investments/vbi-view-port-branches/vbi-view-port-branches.component';
@NgModule({
  declarations: [
    AdminDashboardComponent,
     LayoutAdminComponent,
      AdminDashboardLandingComponent,
       PostBankingPerBranchComponent,
       PostInvestmentPerBranchComponent,
        ViewBranchInvestmentsComponent,
         ViewAndEditUsersComponent,
         ViewBranchBankingsComponent,
         VbbLayoutComponent,
         VbbViewPortComponent,
         VbbViewPortBranchesComponent,
         VbiViewPortComponent,
         VbiLayoutComponent,
         VbiViewPortBranchesComponent

         ],
  imports: [
    CommonModule,
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    AdminDashboardRoutingModule,
    ReactiveFormsModule,
    BsDatepickerModule,
    DatepickerModule,
    NgxSpinnerModule,
    AlertModule.forRoot({maxMessages: 5, timeout: 7000, position: 'left'}),
    AgGridModule.withComponents([]),
  ]
})
export class AdminDashboardModule { }
