export interface LedgerStatementBranch {
  id: number;
  date: Date;
  narration: string;
   debit_amount: number;
   credit_amount: number;
  balance: number;
  user_name: string;

}
