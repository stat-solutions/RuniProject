import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpHeaders, HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { LedgerStatementBranch } from '../models/ledger-statement-branch';
import { catchError, mapTo } from 'rxjs/operators';
import { AllocationsMadeStatement } from '../models/allocations-made-statement';
import { FormGroup } from '@angular/forms';
import { AllocationLedgerStatement } from '../models/allocation-ledger-statement';
import { AllocationTotalStatement } from '../models/allocation-total-statement';
import { SummuryLedger } from '../models/summury-ledger';
import { SummuryAllocations } from '../models/summury-allocations';
import { LedgerStatement } from '../models/ledger-statement';

@Injectable({
  providedIn: 'root'
})
export class BranchUserService {



      private API_URL = environment.apiUrl;

      httpOptions = {
        headers: new HttpHeaders({
          'Content-Type': 'application/json'
        })
      };



      constructor(private http: HttpClient) {}




      allocationPerBranchNow(id: string): Observable<SummuryAllocations[]> {

        const options1 = { params: new HttpParams().set('id', id) };

        return this.http
          .get<SummuryAllocations[]>(
            `${this.API_URL}/api/branchUser/allocationBranchNow`,
            options1
          )

          .pipe(
            // tap(response => console.log(`${response}`)),

            catchError(this.handleError)
          );
      }


      investmentPerBranchNow(id: string): Observable<SummuryAllocations[]> {

        const options1 = { params: new HttpParams().set('id', id) };

        return this.http
          .get<SummuryAllocations[]>(
            `${this.API_URL}/api/branchUser/investmentTBranchNow`,
            options1
          )

          .pipe(
            // tap(response => console.log(`${response}`)),

            catchError(this.handleError)
          );
      }


     bankingPerBranchNow(id: string): Observable<SummuryAllocations[]> {

        const options1 = { params: new HttpParams().set('id', id) };

        return this.http
          .get<SummuryAllocations[]>(
            `${this.API_URL}/api/branchUser/bankingTBranchNow`,
            options1
          )

          .pipe(
            // tap(response => console.log(`${response}`)),

            catchError(this.handleError)
          );
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
