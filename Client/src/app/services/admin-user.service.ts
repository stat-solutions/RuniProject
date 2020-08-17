import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpHeaders, HttpClient, HttpParams, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, mapTo } from 'rxjs/operators';
import { FormGroup } from '@angular/forms';
import { LedgerStatementBranch } from '../models/ledger-statement-branch';
import { LedgerStatement } from '../models/ledger-statement';

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



    bankStatementAllBank(): Observable<LedgerStatement[]> {

      return this.http.get<LedgerStatement[]>( `${this.API_URL}/api/adminUser/bankLedgerStatement`, this.httpOptions)

        .pipe(

          catchError(this.handleError)
        );
    }


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


}
