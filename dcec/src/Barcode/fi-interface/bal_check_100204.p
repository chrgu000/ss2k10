DEF temp-table  acccheck FIELD acct AS CHAR FORMAT "x(10)"
    FIELD dr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD curr AS CHAR FORMAT "x(4)"
    FIELD dr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99".
DEF  VAR mstr1 AS CHAR  .
DEF  VAR mstr2 AS CHAR.
DEF  VAR mstr3 AS CHAR.
DEF  VAR mstr4 AS CHAR.
DEF  VAR mstr5 AS CHAR.
DEF VAR preacct AS CHAR.
DEF VAR isfirst AS LOGICAL.
DEF VAR dr_tot_bal LIKE dr_bal.
DEF VAR cr_tot_bal LIKE cr_bal.
DEF VAR dr_curr_tot_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99".
DEF VAR cr_curr_tot_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99".
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\jzpz.txt".
REPEAT :
    CREATE acccheck.
    IMPORT DELIMITER "	" mstr1 mstr2 mstr3 mstr4 mstr5 acct dr_bal cr_bal curr dr_curr_bal cr_curr_bal .
END.
preacct = ''.
isfirst = YES.
dr_tot_bal = 0.
     cr_tot_bal = 0.
    dr_curr_tot_bal = 0.
    cr_curr_tot_bal = 0.
    OUTPUT TO 'c:\cur_bal.txt'. 
    FOR EACH acccheck  WHERE ACCT = '100204'  BY acct:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/

     
  
      
           DISP acct DR_BAL DR_CURR_BAL CR_BAL CR_CURR_BAL .
           
     
   END.

 OUTPUT CLOSE.
