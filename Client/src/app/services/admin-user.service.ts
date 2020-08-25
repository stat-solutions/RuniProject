import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpHeaders, HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, mapTo } from 'rxjs/operators';
import { FormGroup } from '@angular/forms';
import { LedgerStatementBranch } from '../models/ledger-statement-branch';
import { LedgerStatement } from '../models/ledger-statement';
import { AllocationTotalStatement } from '../models/allocation-total-statement';
import { AllocationsMadeStatement } from '../models/allocations-made-statement';
import { AllocationLedgerStatement } from '../models/allocation-ledger-statement';
import { SummuryLedger } from '../models/summury-ledger';
import { SummuryAllocations } from '../models/summury-allocations';
import { ApprovalDetails } from '../models/approval-details';

@Injectable({
  providedIn: 'root'
})
export class AdminUserService {

    private API_URL = environment.apiUrl;

    httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    constructor(private http: HttpClient) {}




    investmentStatementByBranch(id: string): Observable<LedgerStatementBranch[]> {
      const options1 = { params: new HttpParams().set('id', id) };

      return this.http
        .get<LedgerStatementBranch[]>(
          `${this.API_URL}/api/adminUser/branchLedgerStatementInvestment`,
          options1
        )

        .pipe(
          // tap(response => console.log(`${response}`)),

          catchError(this.handleError)
        );
    }


    bankStatementByBranchBank(id: string): Observable<LedgerStatementBranch[]> {
      const options1 = { params: new HttpParams().set('id', id) };

      return this.http
        .get<LedgerStatementBranch[]>(
          `${this.API_URL}/api/adminUser/branchLedgerStatementBank`,
          options1
        )

        .pipe(
          // tap(response => console.log(`${response}`)),

          catchError(this.handleError)
        );
    }


    allocationsMadehNow(id: string): Observable<AllocationsMadeStatement[]> {
      const options1 = { params: new HttpParams().set('id', id) };

      return this.http
        .get<AllocationsMadeStatement[]>(
          `${this.API_URL}/api/adminUser/allocationMadeStatement`,
          options1
        )

        .pipe(
          // tap(response => console.log(`${response}`)),

          catchError(this.handleError)
        );
    }




    // investementViability(id: string): Observable<AllocationLedgerStatement[]> {
    //   const options1 = { params: new HttpParams().set('id', id) };

    //   return this.http
    //     .get<AllocationLedgerStatement[]>(
    //       `${this.API_URL}/api/adminUser/investementViability`,
    //       options1
    //     )

    //     .pipe(
    //       // tap(response => console.log(`${response}`)),

    //       catchError(this.handleError)
    //     );
    // }
    investementViabilityNow(postData: FormGroup) {
      return this.http
        .post<boolean>(
          `${this.API_URL}/api/adminUser/investementViability`,
          postData.value,
          this.httpOptions
        )

        .pipe(mapTo(true), catchError(this.handleAmountValidError));
    }



    allocationsLedgerhNow(id: string): Observable<AllocationLedgerStatement[]> {
      const options1 = { params: new HttpParams().set('id', id) };

      return this.http
        .get<AllocationLedgerStatement[]>(
          `${this.API_URL}/api/adminUser/allocationLedgerStatement`,
          options1
        )

        .pipe(
          // tap(response => console.log(`${response}`)),

          catchError(this.handleError)
        );
    }





    allocationsTotalStateBranchNow(id: string): Observable<AllocationTotalStatement[]> {
      const options1 = { params: new HttpParams().set('id', id) };

      return this.http
        .get<AllocationTotalStatement[]>(
          `${this.API_URL}/api/adminUser/allocationTotalStatementBranch`,
          options1
        )

        .pipe(
          // tap(response => console.log(`${response}`)),

          catchError(this.handleError)
        );
    }

    approveTheTxnNow(id: string) {
      const options1 = { params: new HttpParams().set('id', id) };
      console.log('Second wave is emi');
      return this.http
        .get<boolean[]>(
          `${this.API_URL}/api/adminUser/approveThatTxnNow`,
          options1
        )

        .pipe(
          // tap(response => console.log(`${response}`)),

          catchError(this.handleError)
        );
    }
    



    getTheApprovalDetailsNow(): Observable<ApprovalDetails[]> {

      return this.http.get<ApprovalDetails[]>( `${this.API_URL}/api/adminUser/theApprovalDetails`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }



    theSummuryInvestNow(): Observable<SummuryLedger[]> {

      return this.http.get<SummuryLedger[]>( `${this.API_URL}/api/adminUser/investSummuryLedger`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }


    theSummuryBankingNow(): Observable<SummuryLedger[]> {

      return this.http.get<SummuryLedger[]>( `${this.API_URL}/api/adminUser/bankingSummuryLedger`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }


    theSummuryTotalAllocations(): Observable<SummuryAllocations[]> {

      return this.http.get<SummuryAllocations[]>( `${this.API_URL}/api/adminUser/summuryTotalAllocations`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }


    summuryTotalBanking(): Observable<SummuryAllocations[]> {

      return this.http.get<SummuryAllocations[]>( `${this.API_URL}/api/adminUser/summuryTotalBankingNow`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }

    summuryTotalInvestments(): Observable<SummuryAllocations[]> {

      return this.http.get<SummuryAllocations[]>( `${this.API_URL}/api/adminUser/summuryTotalInvestmentsNow`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }






    bankStatementAllBank(): Observable<LedgerStatement[]> {

      return this.http.get<LedgerStatement[]>( `${this.API_URL}/api/adminUser/bankLedgerStatement`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }

    allocationsTotalState(): Observable<AllocationTotalStatement[]> {

      return this.http.get<AllocationTotalStatement[]>( `${this.API_URL}/api/adminUser/allocationTotalStatement`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }




    // allocationsTotalStateBranch(id: string): Observable<AllocationTotalStatement[]> {
    //   const options1 = { params: new HttpParams().set('id', id) };

    //   return this.http
    //     .get<AllocationTotalStatement[]>(
    //       `${this.API_URL}/api/adminUser/allocationTotalStatementBranch`,
    //       options1
    //     )

    //     .pipe(
    //       // tap(response => console.log(`${response}`)),

    //       catchError(this.handleError)
    //     );
    // }





    investmentStatementAll(): Observable<LedgerStatement[]> {

      return this.http.get<LedgerStatement[]>( `${this.API_URL}/api/adminUser/investmentLedgerStatement`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }





    makeAllocationTxn(postData: FormGroup) {
      return this.http
        .post<boolean>(
          `${this.API_URL}/api/adminUser/makeAllocation`,
          postData.value,
          this.httpOptions
        )

        .pipe(mapTo(true), catchError(this.handleError));
    }




    postTheTxn(postData: FormGroup) {
      return this.http
        .post<boolean>(
          `${this.API_URL}/api/adminUser/postTheTxn`,
          postData.value,
          this.httpOptions
        )

        .pipe(mapTo(true), catchError(this.handleError));
    }



    private handleError(errorResponse: HttpErrorResponse) {
      if (errorResponse.error instanceof ErrorEvent) {
        // A client-side or network error occurred. Handle it accordingly.
        console.error('An error occurred:', errorResponse.error.message);
      } else {
        // The backend returned an unsuccessful response code.
        // The response body may contain clues as to what went wrong,
        console.error(
          `Backend returned code ${errorResponse.status}, ` +
            `body was: ${errorResponse.error}`
        );
      }
      // return an observable with a user-facing error message
      return throwError(`Get Error!!
         ${
           errorResponse.status === 500 ||
           errorResponse.status === 0 ||
           errorResponse.status === 200
             ? 'The Back End was not able to Handle this Request'
             : errorResponse.error
         }
     !!`);
    }



    private handleAmountValidError(errorResponse: HttpErrorResponse) {
      if (errorResponse.error instanceof ErrorEvent) {
        // A client-side or network error occurred. Handle it accordingly.
        console.error('An error occurred:', errorResponse.error.message);
      } else {
        // The backend returned an unsuccessful response code.
        // The response body may contain clues as to what went wrong,
        console.error(
          `Backend returned code ${errorResponse.status}, ` +
            `body was: ${errorResponse.error}`
        );
      }
      // return an observable with a user-facing error message
      return throwError(`Runimba Please...Beramu!!
         ${
           errorResponse.status === 700 ||
           errorResponse.status === 0 ||
           errorResponse.status === 200
             ? 'The Amount being transferred is more than the amount allocated for that branch!!'
             : errorResponse.error
         }
     !!`);
    }

}
