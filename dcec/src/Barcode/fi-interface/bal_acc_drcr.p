DEF temp-table bal_kmye FIELD acct AS CHAR FORMAT "x(10)"
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
DEF temp-table bal_jzpz FIELD acct AS CHAR FORMAT "x(10)"
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
    FIELD mdate AS CHAR
    FIELD mdoc AS CHAR
    FIELD mline AS CHAR.
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
DEF VAR pre_doc AS CHAR.
DEF VAR nline AS INT.
DEF VAR dr_tot_bal LIKE bal_kmye.dr_bal.
DEF VAR cr_tot_bal LIKE bal_kmye.cr_bal.
DEF VAR beg_tot_bal LIKE bal_kmye.dr_bal.
DEF VAR end_tot_bal LIKE bal_kmye.cr_bal.
DEF VAR dr_curr_tot_bal LIKE dr_tot_bal.
DEF VAR cr_curr_tot_bal LIKE cr_tot_bal.
DEF VAR macct LIKE mstr1.
DEF VAR macc_typ LIKE mstr1.
DEF BUFFER balkmye FOR bal_kmye.

DEF VAR pre_period AS CHAR.
DEF VAR iscal AS LOGICAL.
INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\kmye.txt".
REPEAT :
    CREATE bal_kmye.
    IMPORT DELIMITER "	" acct mstr2 mstr3 bal_kmye.beg_bal mstr5 bal_kmye.beg_curr_bal bal_kmye.dr_bal mstr7 bal_kmye.dr_curr_bal bal_kmye.cr_bal mstr9 bal_kmye.cr_curr_bal bal_kmye.END_bal mstr10 bal_kmye.END_curr_bal bal_kmye.period .

    END.

    INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\jzpz.txt".
REPEAT :
    CREATE bal_jzpz.
    IMPORT DELIMITER "	" bal_jzpz.mdate mstr2 bal_jzpz.mdoc bal_jzpz.mline mstr5 bal_jzpz.acct bal_jzpz.dr_bal bal_jzpz.cr_bal bal_jzpz.curr bal_jzpz.dr_curr_bal bal_jzpz.cr_curr_bal .
END.
    
    
    INPUT FROM "E:\Personal DOC\huade0702\huade0702_0716_081007\kjkm.txt".
REPEAT :
    IMPORT DELIMITER "	" macct mstr1 mstr2 mstr3 mstr4 mstr5 mstr6  macc_typ .
    FIND FIRST bal_kmye WHERE bal_kmye.acct = macct AND bal_kmye.period = '1' EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE bal_kmye THEN bal_kmye.acc_typ = macc_typ.
     FIND FIRST bal_kmye WHERE bal_kmye.acct = macct AND bal_kmye.period = '2' EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE bal_kmye THEN bal_kmye.acc_typ = macc_typ.

    END.
preacct = ''.
isfirst = YES.
dr_tot_bal = 0.
 cr_tot_bal = 0.
     beg_tot_bal = 0.
  end_tot_bal = 0.
  dr_curr_tot_bal = 0.
 cr_curr_tot_bal = 0.

 /* OUTPUT TO c:\bal_check.txt. */  
  
  
  
  FOR EACH bal_jzpz BREAK BY bal_jzpz.acct + SUBSTR(bal_jzpz.mdate,1,6) :


dr_tot_bal = dr_tot_bal + bal_jzpz.dr_bal.
cr_tot_bal = cr_tot_bal + bal_jzpz.cr_bal.
dr_curr_tot_bal = dr_curr_tot_bal + bal_jzpz.dr_curr_bal.
cr_curr_tot_bal = cr_curr_tot_bal + bal_jzpz.cr_curr_bal.
IF LAST-OF(bal_jzpz.acct + SUBSTR(bal_jzpz.mdate,1,6)) THEN DO:
   FIND FIRST  bal_kmye WHERE bal_kmye.acct = bal_jzpz.acct AND bal_kmye.period = SUBSTR(bal_jzpz.mdate,6,1) NO-LOCK NO-ERROR.
   IF AVAILABLE bal_kmye THEN
         IF dr_tot_bal <> bal_kmye.dr_bal OR cr_tot_bal <> bal_kmye.cr_bal OR dr_curr_tot_bal <> bal_kmye.dr_curr_bal OR cr_curr_tot_bal <> bal_kmye.cr_curr_bal THEN
                             DISP bal_kmye.acct dr_tot_bal bal_kmye.dr_bal cr_tot_bal bal_kmye.cr_bal.

dr_tot_bal = 0.
 cr_tot_bal = 0.
 dr_curr_tot_bal = 0.
 cr_curr_tot_bal = 0.




END.



  END.
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  FOR EACH bal_kmye  WHERE /*LENGTH(acct) = 4 *//*BREAK BY substr(acct,1,4)*/ BY bal_kmye.acct:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/

    /* dr_tot_bal = dr_tot_bal + dr_bal.
     cr_tot_bal = cr_tot_bal + cr_bal.
    
     IF LAST-OF(substr(acct,1,4)) THEN DO:
     DISP  SUBSTR(acct,1,4) dr_tot_bal cr_tot_bal .
         dr_tot_bal = 0.
  cr_tot_bal = 0.
     
      END.
  */
   /*   FOR EACH bal_jzpz WHERE bal_jzpz.acc
      END.*/
      
      
      
      IF bal_kmye.acc_typ = "½è" THEN DO:
    
      
        IF  bal_kmye.beg_bal + bal_kmye.dr_bal - bal_kmye.cr_bal <> bal_kmye.END_bal THEN DISP bal_kmye.acct.
   IF bal_kmye.beg_curr_bal + bal_kmye.dr_curr_bal - bal_kmye.cr_curr_bal <> bal_kmye.END_curr_bal THEN DISP bal_kmye.acct.
       
        
        
        END.
          
        IF bal_kmye.acc_typ = "´û" THEN DO:
       
          IF  bal_kmye.beg_bal - bal_kmye.dr_bal + bal_kmye.cr_bal <> bal_kmye.END_bal THEN DISP bal_kmye.acct.
          IF  bal_kmye.beg_curr_bal - bal_kmye.dr_curr_bal + bal_kmye.cr_curr_bal <> bal_kmye.END_curr_bal THEN DISP bal_kmye.acct.

          END.
          
   END.
  /* DISP dr_tot_bal cr_tot_bal.
   OUTPUT CLOSE.*/




   FOR EACH bal_kmye WHERE bal_kmye.period = '1':

     FOR EACH balkmye WHERE balkmye.acct = bal_kmye.acct AND balkmye.period = '2':
             IF bal_kmye.END_bal <> balkmye.beg_bal OR bal_kmye.END_curr_bal <> balkmye.beg_curr_bal THEN DISP bal_kmye.acct.



     END.



   END.



   dr_tot_bal = 0.
   cr_tot_bal = 0.
   beg_tot_bal = 0.
   END_tot_bal = 0.
isfirst = YES.
 FOR EACH bal_kmye  WHERE LENGTH(bal_kmye.acct) = 4 BREAK BY bal_kmye.period + bal_kmye.acc_typ  :
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/

     dr_tot_bal = dr_tot_bal + bal_kmye.dr_bal.
     cr_tot_bal = cr_tot_bal + bal_kmye.cr_bal.
     beg_tot_bal = beg_tot_bal + bal_kmye.beg_bal.
    end_tot_bal = end_tot_bal + bal_kmye.end_bal.

   
    
    IF LAST-OF( bal_kmye.period + bal_kmye.acc_typ) THEN DO:
     DISP bal_kmye.period LABEL 'period' beg_tot_bal LABEL "beg4"  END_tot_bal LABEL "end4".
         beg_tot_bal = 0.
  end_tot_bal = 0.
     END.
 /* DISP acct dr_bal cr_bal.*/

IF  NOT isfirst AND pre_period <> bal_kmye.period THEN DO:

   DISP pre_period LABEL 'period' dr_tot_bal LABEL "dr4" cr_tot_bal LABEL "cr4".
dr_tot_bal = 0.
   cr_tot_bal = 0.
END.
    pre_period = bal_kmye.period.
isfirst = NO.
   END.
DISP pre_period LABEL 'period' dr_tot_bal LABEL "dr4" cr_tot_bal LABEL "cr4".


 dr_tot_bal = 0.
   cr_tot_bal = 0.
   beg_tot_bal = 0.
   END_tot_bal = 0.
isfirst = YES.
 FOR EACH bal_kmye  WHERE LENGTH(bal_kmye.acct) = 6  BREAK BY  bal_kmye.period + bal_kmye.acc_typ:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/

    dr_tot_bal = dr_tot_bal + bal_kmye.dr_bal.
     cr_tot_bal = cr_tot_bal + bal_kmye.cr_bal.
     beg_tot_bal = beg_tot_bal + bal_kmye.beg_bal.
    end_tot_bal = end_tot_bal + bal_kmye.end_bal.

   
    
    IF LAST-OF( bal_kmye.period + bal_kmye.acc_typ) THEN DO:
     DISP bal_kmye.period LABEL 'period' beg_tot_bal LABEL "beg6"  END_tot_bal LABEL "end6".
         beg_tot_bal = 0.
  end_tot_bal = 0.
     END.   
 /* DISP acct dr_bal cr_bal.*/

IF  NOT isfirst AND pre_period <> bal_kmye.period THEN DO:

   DISP pre_period LABEL 'period' dr_tot_bal LABEL "dr6" cr_tot_bal LABEL "cr6".
dr_tot_bal = 0.
   cr_tot_bal = 0.
END.
    pre_period = bal_kmye.period.
isfirst = NO.
   END. 
DISP pre_period LABEL 'period' dr_tot_bal LABEL "dr6" cr_tot_bal LABEL "cr6".


FOR EACH bal_kmye WHERE LENGTH(bal_kmye.acct) = 4  BY bal_kmye.period  BY bal_kmye.acct:
dr_tot_bal = 0.
cr_tot_bal = 0.
beg_tot_bal = 0.
END_tot_bal = 0.
iscal = NO.
FOR EACH balkmye  WHERE length(balkmye.acct) = 6 AND substr(balkmye.acct,1,4) = bal_kmye.acct AND balkmye.period = bal_kmye.period:
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/

     dr_tot_bal = dr_tot_bal + balkmye.dr_bal.
     cr_tot_bal = cr_tot_bal + balkmye.cr_bal.
   beg_tot_bal = beg_tot_bal + balkmye.beg_bal.
   END_tot_bal = END_tot_bal + balkmye.END_bal.
    
  iscal = YES.
   END.
   IF iscal THEN
   IF dr_tot_bal <> bal_kmye.dr_bal OR cr_tot_bal <> bal_kmye.cr_bal OR beg_tot_bal <> bal_kmye.beg_bal OR END_tot_bal <> bal_kmye.END_bal THEN

        DISP bal_kmye.acct.



END.


FOR EACH bal_kmye WHERE LENGTH(bal_kmye.acct) = 6  BY bal_kmye.period BY bal_kmye.acct :
dr_tot_bal = 0.
cr_tot_bal = 0.
beg_tot_bal = 0.
END_tot_bal = 0.
iscal = NO.
FOR EACH balkmye  WHERE length(balkmye.acct) = 8 AND substr(balkmye.acct,1,6) = bal_kmye.acct AND balkmye.period = bal_kmye.period :
/*IF NOT isfirst  AND acct <> preacct THEN DO:
     DISP preacct dr_tot_bal cr_tot_bal.
     
     END.*/ /*DISP acct acc_typ.*/

     dr_tot_bal = dr_tot_bal + balkmye.dr_bal.
     cr_tot_bal = cr_tot_bal + balkmye.cr_bal.
   beg_tot_bal = beg_tot_bal + balkmye.beg_bal.
   END_tot_bal = END_tot_bal + balkmye.END_bal.
    iscal = YES.
  
   END.
   IF iscal THEN
   IF dr_tot_bal <> bal_kmye.dr_bal OR cr_tot_bal <> bal_kmye.cr_bal OR beg_tot_bal <> bal_kmye.beg_bal OR END_tot_bal <> bal_kmye.END_bal THEN

        DISP bal_kmye.acct.



END.

isfirst = YES.
pre_doc = ''.
FOR EACH bal_jzpz WHERE bal_jzpz.mdoc = '07010038' BY bal_jzpz.mdate BY bal_jzpz.mdoc BY integer(bal_jzpz.mline):

IF isfirst OR pre_doc <> bal_jzpz.mdoc THEN nline = 1.


IF nline <> integer(bal_jzpz.mline) THEN DISP bal_jzpz.mdoc nline bal_jzpz.mline.

nline = nline + 1.
isfirst = NO.
pre_doc = bal_jzpz.mdoc.






END.
