DEF temp-table bal FIELD acct AS CHAR FORMAT "x(10)"
    FIELD beg_bal  AS DECIMAL FORMAT ">>>>>>>>>>9.99"
     FIELD end_bal  AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD dr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD curr AS CHAR FORMAT "x(4)"
    FIELD dr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
    FIELD cr_curr_bal AS DECIMAL FORMAT ">>>>>>>>>>9.99"
FIELD acc_typ AS CHAR FORMAT "x(4)"
FIELD TYP AS  CHAR FORMAT "x(30)" .
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
DEF VAR macc_typ LIKE TYP.
DEF VAR MTYP LIKE MSTR1.
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\kmye.txt".
REPEAT :
    CREATE bal.
    IMPORT DELIMITER "	" acct mstr2 mstr3 beg_bal mstr5 mstr6 dr_bal mstr7 mstr8 cr_bal mstr9 mstr10 END_bal .

    END.
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\kjkm.txt".
REPEAT :
    IMPORT DELIMITER "	" macct mstr1 mstr2 mstr3 mstr4 MTYP mstr6  macc_typ .
    FIND FIRST bal WHERE acct = macct EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE bal THEN DO: 
           acc_typ = macc_typ.
           TYP = MTYP.
       END.
    

    END.
preacct = ''.
isfirst = YES.
dr_tot_bal = 0.
     beg_tot_bal = 0.
  end_tot_bal = 0.
     FOR EACH bal  WHERE LENGTH(acct) = 6  BREAK BY TYP:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/
 IF TYP = '资产' OR TYP = '成本' THEN DO:

     
     beg_tot_bal = beg_tot_bal + IF ACC_TYP = '借' THEN beg_bal ELSE BEG_BAL * (-1).
    end_tot_bal = end_tot_bal + IF ACC_TYP = '借' THEN END_bal ELSE END_BAL * (-1).
     IF LAST-OF(typ) THEN DO:
     DISP beg_tot_bal  END_tot_bal.
        
     END.
  
    END.
   
    
   END.
    beg_tot_bal = 0.
  end_tot_bal = 0.
   FOR EACH bal  WHERE LENGTH(acct) = 6  BREAK BY TYP:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/
 IF TYP = '负债' OR TYP = '所有者权益' OR TYP = '损益' THEN DO:

     
     beg_tot_bal = beg_tot_bal + IF ACC_TYP = '贷' THEN beg_bal ELSE BEG_BAL * (-1).
    end_tot_bal = end_tot_bal + IF ACC_TYP = '贷' THEN END_bal ELSE END_BAL * (-1).
     IF LAST-OF(typ) THEN DO:
     DISP beg_tot_bal  END_tot_bal.
        
     END.
  
    END.
   
    
   END.
  



