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
import { ViewBranchAllocationsComponent } from './view-branch-allocations/view-branch-allocations.component';
import { VbaViewPortComponent } from './view-branch-allocations/vba-view-port/vba-view-port.component';
import { VbaViewPortBranchesComponent } from './view-branch-allocations/vba-view-port-branches/vba-view-port-branches.component';
import { MakeAllocationsPerBranchComponent } from './make-allocations-per-branch/make-allocations-per-branch.component';
import { VbaAllocationsLedgerStateComponent } from './view-branch-allocations/vba-allocations-ledger-state/vba-allocations-ledger-state.component';
import { VbaAllocationsMadeStateComponent } from './view-branch-allocations/vba-allocations-made-state/vba-allocations-made-state.component';



const routes: Routes = [
  { path: 'dashboardadmin', redirectTo: '/dashboardadmin/landing', pathMatch: 'full' },
  {
    path: 'dashboardadmin', component: AdminDashboardComponent, children: [
      { path: 'landing', component: AdminDashboardLandingComponent },
      { path: 'postbankingperbranch', component: PostBankingPerBranchComponent },
      { path: 'postinvestmentperbranch', component: PostInvestmentPerBranchComponent },
      { path: 'allocateperbranch', component: MakeAllocationsPerBranchComponent },
      { path: 'viewbranchbankings', component: ViewBranchBankingsComponent , children: [

        { path: 'viewportbankings', component: VbbViewPortComponent },
        { path: 'viewportbankingsbranches/:branch', component: VbbViewPortBranchesComponent },

      ]},

      { path: 'viewbranchinvestemnts', component: ViewBranchInvestmentsComponent , children: [

        { path: 'viewportinvestments', component: VbiViewPortComponent },
        { path: 'viewportinvestemnentsbranches/:branch', component: VbiViewPortBranchesComponent },

      ]},


      { path: 'viewbranchallocations', component: ViewBranchAllocationsComponent , children: [

        { path: 'viewportallocations', component: VbaViewPortComponent },

        { path: 'viewportallocationsbranches/:branch', component: VbaViewPortBranchesComponent },

        { path: 'viewportallocationsledger/:branchId/:branchName', component: VbaAllocationsLedgerStateComponent },

        { path: 'viewportallocationsmade/:branchId/:branchName', component:  VbaAllocationsMadeStateComponent},

      ]},

      { path: 'viewandeditusers', component: ViewAndEditUsersComponent }
    ]
  }


];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AdminDashboardRoutingModule { }
