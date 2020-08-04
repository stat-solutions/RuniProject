import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BranchUserDashboardRoutingModule } from './branch-user-dashboard-routing.module';
import { BranchUserDashboardComponent } from './branch-user-dashboard.component';
import { LayoutBranchUserComponent } from './layout-branch-user/layout-branch-user.component';
import { BranchUserDashboardLandingComponent } from './branch-user-dashboard-landing/branch-user-dashboard-landing.component';
import { NgxSpinnerModule } from 'ngx-spinner';
import { AlertModule } from 'ngx-alerts';


@NgModule({
  declarations: [BranchUserDashboardComponent, LayoutBranchUserComponent, BranchUserDashboardLandingComponent],
  imports: [
    CommonModule,
    BranchUserDashboardRoutingModule,
    NgxSpinnerModule,
    AlertModule.forRoot({maxMessages: 5, timeout: 7000, position: 'left'})
  ]
})
export class BranchUserDashboardModule { }
