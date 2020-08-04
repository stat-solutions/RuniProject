import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpHeaders, HttpErrorResponse, HttpClient, HttpParams } from '@angular/common/http';
import { FormGroup } from '@angular/forms';
import { Tokens } from '../models/tokens';
import { Observable, throwError } from 'rxjs';
import { map, tap, catchError, mapTo } from 'rxjs/operators';
import { UserRole } from '../models/user-role';
import { TheBranches } from '../models/the-branches';

@Injectable({
  providedIn: 'root'
})
export class AuthServiceService {


  private API_URL = environment.apiUrl;
  private readonly JWT_TOKEN = 'JWT_TOKEN';
  private readonly REFRESH_TOKEN = 'REFRESH_TOKEN';
  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  constructor(private http: HttpClient) { }




  loginNormalUser(postData: FormGroup): Observable<boolean> {

    return this.http.post<any>(`${this.API_URL}/api/auth/login`, postData.value, this.httpOptions)

      .pipe(
        // tap(tokens => console.log(`${tokens}`)),
        tap(tokens => this.doLoginUser(tokens)),
        mapTo(true),

        catchError(this.handleLoginError)

      );
  }


  getUserRoles(): Observable<UserRole[]> {

    return this.http.get<UserRole[]>(`${this.API_URL}/api/auth/getUserRoles`, this.httpOptions)

      .pipe(

        catchError(this.OtherErrors)
      );
  }




  getTheBranches(): Observable<TheBranches[]> {

    return this.http.get<TheBranches[]>(`${this.API_URL}/api/auth/getTheBranches`, this.httpOptions)

      .pipe(

        // tap(response => console.log(`${response}`)),

        catchError(this.OtherErrors)
      );
  }

  testingTheTablePost(postData: FormGroup): Observable<string> {

    return this.http.post<string>(`${this.API_URL}/api/auth/testTableData`, postData.value, this.httpOptions)

      .pipe(
        // tap(tokens => console.log(`${tokens}`)),
        // tap(tokens => this.doLoginUser(postData.value.main_contact_number, tokens)),
        // mapTo(true),

        catchError(this.handleLoginError)

      );
  }




  getThePetrolStations(id: string) {

    const options1 = { params: new HttpParams().set('id', id) };

    return this.http.get<TheBranches[]>(`${this.API_URL}/api/auth/allThePetrolStations`, options1)

      .pipe(

        // tap(response => console.log(`${response}`)),

        catchError(this.OtherErrors)
      );

  }

  // logout() {

  //   return this.http.post<any>(`${this.API_URL}/api/auth/logout`, { refreshToken: this.getRefreshToken() })

  //     .pipe(
  //       tap(() => this.doLogoutUser()),
  //       mapTo(true),

  //       catchError(error => {
  //         this.handleLoginError(error);
  //         return of(false);

  //       }
  //       )
  //     );
  // }

  registerUser(postData: FormGroup) {

    return this.http.post<string>(`${this.API_URL}/api/auth/register`, postData.value, this.httpOptions)

      .pipe(
        map((res: string) => res),
        // tap(res => console.log(`AFTER MAP: ${res}`)),
        catchError(this.handleRegisterError)
      );
  }


  registerMobileNumberPasswordAdmin(postData: FormGroup) {

    return this.http.post<string>(`${this.API_URL}/api/auth/registerAdmin`, postData.value, this.httpOptions)

      .pipe(
        map((res: string) => res),
        // tap(res => console.log(`AFTER MAP: ${res}`)),
        catchError(this.handleRegisterError)
      );
  }

  doLoginUser(tokens: Tokens) {
    this.storeTokens(tokens);

  }

  doLogoutUser() {
    this.removeTokens();
  }

  private removeTokens() {

    // console.log('In it');

    localStorage.removeItem(this.JWT_TOKEN);

    localStorage.removeItem(this.REFRESH_TOKEN);
  }


  isLoggedIn() {
    return !!this.getJwtToken();
  }


  getJwtToken() {

    return localStorage.getItem(this.JWT_TOKEN);
  }


  refreshToken() {
    // console.log('am refreshing');
    return this.http.post<any>(`${this.API_URL}/api/auth/refresh`, {
      refreshToken: this.getRefreshToken()
    }).pipe(tap((tokens: Tokens) => {
      this.storeJwtToken(tokens.jwt);
    }));
  }

  storeJwtToken(jwt: string) {
    localStorage.setItem(this.JWT_TOKEN, jwt);
  }

  getRefreshToken() {
    return localStorage.getItem(this.REFRESH_TOKEN);
  }

  private storeTokens(tokens: Tokens) {
    localStorage.setItem(this.JWT_TOKEN, tokens.jwt);
    localStorage.setItem(this.REFRESH_TOKEN, tokens.refreshToken);
  }


  private handleLoginError(errorResponse: HttpErrorResponse) {

    if (errorResponse.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', errorResponse.error.message);
    } else {
      // The backend returned an uninfoful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${errorResponse.status},` +
        `body was: ${errorResponse.error}`);
    }
    // return an observable with a user-facing error message
    return throwError(`Authorisation Failed!!
    ${(errorResponse.status === 0 || errorResponse.status === 500 || errorResponse.status === 200) ?
        'The Back End was not able to Handle this Request' : errorResponse.error}
!!`);
  }


  private handleRegisterError(errorResponse: HttpErrorResponse) {

    if (errorResponse.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', errorResponse.error.message);
    } else {
      // The backend returned an uninfoful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${errorResponse.status}, ` +
        `body was: ${errorResponse.error}`);
    }
    // return an observable with a user-facing error message
    return throwError(`User Registration failed!!
    ${(errorResponse.status === 500 || errorResponse.status === 0 || errorResponse.status === 200) ?
        'The Back End was not able to Handle this Request' : errorResponse.error}
!!`);
  }



  private OtherErrors(errorResponse: HttpErrorResponse) {

    if (errorResponse.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', errorResponse.error.message);
    } else {
      // The backend returned an uninfoful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${errorResponse.status}, ` +
        `body was: ${errorResponse.error}`);
    }
    // return an observable with a user-facing error message
    return throwError('Something bad happened; please try again later.');
  }


}
