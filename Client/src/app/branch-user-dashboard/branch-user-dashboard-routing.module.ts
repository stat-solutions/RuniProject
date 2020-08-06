import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { BranchUserDashboardComponent } from './branch-user-dashboard.component';
import { BranchUserDashboardLandingComponent } from './branch-user-dashboard-landing/branch-user-dashboard-landing.component';
import { PostBankingComponent } from './post-banking/post-banking.component';
import { PostInvestmentsComponent } from './post-investments/post-investments.component';
import { ViewInvestmentsComponent } from './view-investments/view-investments.component';
import { ViewBankingsComponent } from './view-bankings/view-bankings.component';



const routes: Routes = [
  { path: 'branchuser', redirectTo: '/branchuser/landing', pathMatch: 'full' },
  {
    path: 'branchuser', component: BranchUserDashboardComponent, children: [
      { path: 'landing', component: BranchUserDashboardLandingComponent },
      { path: 'postbanking', component: PostBankingComponent },
      { path: 'postinvestments', component: PostInvestmentsComponent },
      { path: 'viewinvestments', component: ViewInvestmentsComponent },
      { path: 'viewbankings', component: ViewBankingsComponent },


    ]
  }


];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class BranchUserDashboardRoutingModule { }
