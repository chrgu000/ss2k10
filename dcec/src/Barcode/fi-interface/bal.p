DEF temp-table bal FIELD acct AS CHAR FORMAT "x(10)"
    FIELD beg_bal  AS DECIMAL FORMAT ">>>>>>>>>>9.99"
     FIELD end_bal  AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD dr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD curr AS CHAR FORMAT "x(4)"
    FIELD dr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD beg_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD end_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
FIELD acc_typ AS CHAR FORMAT "x(4)"
FIELD period AS CHAR.
DEF  VAR mstr1 AS CHAR  .
DEF  VAR mstr2 AS CHAR.
DEF  VAR mstr3 AS CHAR.
DEF  VAR mstr4 AS CHAR.
DEF  VAR mstr5 AS CHAR.
DEF  VAR mstr6 AS CHAR.
DEF  VAR mstr7 AS CHAR.
DEF  VAR mstr8 AS CHAR.
DEF  VAR mstr9 AS CHAR.
DEF  VAR mstr10 AS CHAR.
DEF VAR preacct AS CHAR.
DEF VAR isfirst AS LOGICAL.
DEF VAR dr_tot_bal LIKE dr_bal.
DEF VAR cr_tot_bal LIKE cr_bal.
DEF VAR beg_tot_bal LIKE dr_bal.
DEF VAR end_tot_bal LIKE cr_bal.
DEF VAR macct LIKE mstr1.
DEF VAR macc_typ LIKE mstr1.
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\kmye.txt".
REPEAT :
    CREATE bal.
    IMPORT DELIMITER "	" acct mstr2 mstr3 beg_bal mstr5 beg_curr_bal dr_bal mstr7 dr_curr_bal cr_bal mstr9 cr_curr_bal END_bal mstr10 END_curr_bal period .

    END.
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\kjkm.txt".
REPEAT :
    IMPORT DELIMITER "	" macct mstr1 mstr2 mstr3 mstr4 mstr5 mstr6  macc_typ .
   
     
    FIND FIRST bal WHERE acct = macct AND period = '1'EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE bal THEN  acc_typ = macc_typ.
     FIND FIRST bal WHERE acct = macct AND period = '2'EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE bal THEN  acc_typ = macc_typ.
     
     END.
    
preacct = ''.
isfirst = YES.
dr_tot_bal = 0.
dr_bal = 0.
cr_bal = 0.
cr_tot_bal = 0.
     beg_tot_bal = 0.
  end_tot_bal = 0.
   
  FOR EACH bal  WHERE LENGTH(acct) = 4 AND period = '1' BREAK BY acc_typ :
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/

     dr_tot_bal = dr_tot_bal + dr_bal.
     cr_tot_bal = cr_tot_bal + cr_bal.
     beg_tot_bal = beg_tot_bal + beg_bal.
    end_tot_bal = end_tot_bal + end_bal.
IF LAST-OF(acc_typ) THEN DO:
     DISP beg_tot_bal dr_tot_bal cr_tot_bal END_tot_bal.
         beg_tot_bal = 0.
  end_tot_bal = 0.
     END.
 /* DISP acct dr_bal cr_bal.*/
   
   END.

