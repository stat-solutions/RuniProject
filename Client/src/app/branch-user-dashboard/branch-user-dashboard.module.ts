import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BranchUserDashboardRoutingModule } from './branch-user-dashboard-routing.module';
import { BranchUserDashboardComponent } from './branch-user-dashboard.component';
import { LayoutBranchUserComponent } from './layout-branch-user/layout-branch-user.component';
import { BranchUserDashboardLandingComponent } from './branch-user-dashboard-landing/branch-user-dashboard-landing.component';
import { NgxSpinnerModule } from 'ngx-spinner';
import { AlertModule } from 'ngx-alerts';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { PostBankingComponent } from './post-banking/post-banking.component';
import { PostInvestmentsComponent } from './post-investments/post-investments.component';
import { ViewInvestmentsComponent } from './view-investments/view-investments.component';
import { ViewBankingsComponent } from './view-bankings/view-bankings.component';
import { AgGridModule } from 'ag-grid-angular';
import { ReactiveFormsModule } from '@angular/forms';
import { BsDatepickerModule, DatepickerModule } from 'ngx-bootstrap/datepicker';



@NgModule({
  declarations: [
    BranchUserDashboardComponent,
    LayoutBranchUserComponent,
    BranchUserDashboardLandingComponent,
    PostBankingComponent,
    PostInvestmentsComponent,
    ViewInvestmentsComponent,
    ViewBankingsComponent,
  ],
  imports: [
    CommonModule,
    BranchUserDashboardRoutingModule,
    ReactiveFormsModule,
    BsDatepickerModule,
    DatepickerModule,
    NgxSpinnerModule,
    TooltipModule.forRoot(),
    AlertModule.forRoot({ maxMessages: 5, timeout: 7000, position: 'left' }),
    AgGridModule.withComponents([])
  ],
})
export class BranchUserDashboardModule {}
