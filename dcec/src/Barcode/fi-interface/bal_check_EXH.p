DEF temp-table  acccheck FIELD acct AS CHAR FORMAT "x(10)"
    FIELD dr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD curr AS CHAR FORMAT "x(4)"
    FIELD dr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
FIELD exch AS DECIMAL FORMAT ">>>>>>>>>>9.9999"
FIELD doc AS CHAR FORMAT "x(15)"
FIELD mline AS CHAR FORMAT "x(4)".
DEF  VAR mstr1 AS CHAR  .
DEF  VAR mstr2 AS CHAR.
DEF  VAR mstr3 AS CHAR.
DEF  VAR mstr4 AS CHAR.
DEF  VAR mstr5 AS CHAR.
DEF VAR preacct AS CHAR.
DEF VAR isfirst AS LOGICAL.
DEF VAR dr_tot_bal LIKE dr_bal.
DEF VAR cr_tot_bal LIKE cr_bal.
DEF VAR dr_curr_tot_bal LIKE dr_bal.
DEF VAR cr_curr_tot_bal LIKE cr_bal.
DEF VAR m_dr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99".
DEF VAR M_cr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99".
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\jzpz.txt".
DEF VAR PRE_DOC AS CHAR FORMAT "X(15)".
DEF VAR PRE_USEXH LIKE EXCH.
DEF VAR PRE_EUREXH LIKE EXCH.

REPEAT :
    CREATE acccheck.
    IMPORT DELIMITER "	" mstr1 mstr2 doc mline mstr5 acct dr_bal cr_bal curr dr_curr_bal cr_curr_bal exch .
END.
preacct = ''.
isfirst = YES.
dr_tot_bal = 0.
     cr_tot_bal = 0.
    dr_curr_tot_bal = 0.
    cr_curr_tot_bal = 0.
    PRE_DOC = ''.
     OUTPUT TO 'c:\bal_check_curr.txt'.
    FOR EACH acccheck  WHERE curr <> ''  BY DOC BY acct:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/
         IF ISFIRST OR PRE_DOC <> DOC THEN DO:
       PRE_USEXH = ?.
       PRE_EUREXH = ?.
    PRE_DOC = DOC.
   IF CURR = '美元' THEN  PRE_USEXH = EXCH.
   IF CURR = '欧元' THEN  PRE_EUREXH = EXCH.
      ISFIRST = NO. 
   END.
       ELSE DO:
       
       IF CURR = '美元'  THEN 
           IF PRE_USEXH <> ? THEN
                IF PRE_USEXH <> EXCH THEN DISP DOC.
           ELSE PRE_USEXH = EXCH.
   IF CURR = '欧元' THEN  
       IF PRE_EUREXH <> ? THEN
                IF PRE_EUREXH <> EXCH THEN DISP DOC.
           ELSE PRE_EUREXH = EXCH.
           
           
           END.
   
   
           
           
          
        
     
   END.
   OUTPUT CLOSE.

 
