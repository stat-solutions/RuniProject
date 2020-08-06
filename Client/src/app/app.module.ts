import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TooltipModule } from 'ngx-bootstrap/tooltip';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AuthModule } from './auth/auth.module';
import { BranchUserDashboardModule } from './branch-user-dashboard/branch-user-dashboard.module';
import { AdminDashboardModule } from './admin-dashboard/admin-dashboard.module';
import { AgGridModule } from 'ag-grid-angular';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { BsDatepickerModule, DatepickerModule } from 'ngx-bootstrap/datepicker';
@NgModule({
  declarations: [AppComponent],
  imports: [
    CommonModule,
    BrowserModule,
    AppRoutingModule,
    AuthModule,
    BranchUserDashboardModule,
    AdminDashboardModule,
    BrowserAnimationsModule,
    HttpClientModule,
    DatepickerModule.forRoot(),
    BsDatepickerModule.forRoot(),
    AgGridModule.withComponents([]),
    ReactiveFormsModule,
    FormsModule,
    TooltipModule.forRoot()
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
