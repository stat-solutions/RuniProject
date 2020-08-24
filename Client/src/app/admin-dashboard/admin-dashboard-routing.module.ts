import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AdminDashboardComponent } from './admin-dashboard.component';
import { AdminDashboardLandingComponent } from './admin-dashboard-landing/admin-dashboard-landing.component';
import { PostBankingPerBranchComponent } from './post-banking-per-branch/post-banking-per-branch.component';
import { PostInvestmentPerBranchComponent } from './post-investment-per-branch/post-investment-per-branch.component';
import { ViewBranchBankingsComponent } from './view-branch-bankings/view-branch-bankings.component';
import { ViewBranchInvestmentsComponent } from './view-branch-investments/view-branch-investments.component';
import { ViewAndEditUsersComponent } from './view-and-edit-users/view-and-edit-users.component';
import { VbbViewPortComponent } from './view-branch-bankings/vbb-view-port/vbb-view-port.component';
import { VbbViewPortBranchesComponent } from './view-branch-bankings/vbb-view-port-branches/vbb-view-port-branches.component';
import { VbiViewPortComponent } from './view-branch-investments/vbi-view-port/vbi-view-port.component';
import { VbiViewPortBranchesComponent } from './view-branch-investments/vbi-view-port-branches/vbi-view-port-branches.component';



const routes: Routes = [
  { path: 'dashboardadmin', redirectTo: '/dashboardadmin/landing', pathMatch: 'full' },
  {
    path: 'dashboardadmin', component: AdminDashboardComponent, children: [
      { path: 'landing', component: AdminDashboardLandingComponent },
      { path: 'postbanking', component: PostBankingPerBranchComponent },
      { path: 'postinvestment', component: PostInvestmentPerBranchComponent },

      { path: 'viewbankings', component: ViewBranchBankingsComponent , children: [

        { path: 'viewportbankings', component: VbbViewPortComponent },
        { path: 'viewportbankings/:branch', component: VbbViewPortBranchesComponent },

      ]},

      { path: 'viewinvestments', component: ViewBranchInvestmentsComponent , children: [

        { path: 'viewportinvestments', component: VbiViewPortComponent },
        { path: 'viewportinvestments/:branch', component: VbiViewPortBranchesComponent },

      ]},

      { path: 'viewEditusers', component: ViewAndEditUsersComponent }
    ]
  }


];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminDashboardRoutingModule { }
