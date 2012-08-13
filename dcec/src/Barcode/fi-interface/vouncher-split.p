{mfdtitle.i}
DEFINE VAR entity LIKE acd_entity.
DEFINE VAR mperiod LIKE acd_per.
DEFINE VAR myear AS INT FORMAT "9999".
DEFINE VAR path AS CHAR.
DEFINE VAR it AS CHAR FORMAT "x(1200)".
DEFINE VAR dr_base_amount LIKE gltr_amt INITIAL "0.00".
DEFINE VAR cr_base_amount LIKE gltr_amt INITIAL "0.00".
DEFINE VAR dr_curr_amount LIKE gltr_curramt INITIAL "0.00".
DEFINE VAR cr_curr_amount LIKE gltr_curramt INITIAL "0.00".
DEFINE VAR creater AS CHAR FORMAT "x(10)".
DEFINE VAR casher AS CHAR FORMAT "x(10)".
DEFINE VAR auditor AS CHAR FORMAT "x(10)".
DEFINE VAR accounter AS CHAR FORMAT "x(10)".
DEFINE VAR mcount AS INT FORMAT "9999".
DEFINE VAR mpreref LIKE gltr_ref.
DEFINE VAR mdoc LIKE gltr_doc.
DEFINE VAR mzero AS CHAR .
DEFINE VAR macc LIKE qad_key2.
FORM
    SKIP(0.5)
    entity COLON 12 
    mperiod COLON 35 LABEL "Period"
    myear COLON 50 LABEL "Year"
    SKIP(0.5)
    creater COLON 12 LABEL "creater"
    auditor COLON 35 LABEL "auditor"
    SKIP(0.5)
    accounter COLON 12 LABEL "accconter"
    casher COLON 35 LABEL "casher"
    SKIP(1)
    path COLON 65 LABEL "Output Path"
    WITH FRAME a  WIDTH 80 THREE-D SIDE-LABELS.

ASSIGN /*sys_date = TODAY*/
          myear = YEAR(TODAY).
 FIND FIRST gl_ctrl NO-LOCK NO-ERROR.  
 entity = gl_entity.
 FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY NO-LOCK NO-ERROR.
 mperiod = glc_per.
 DISPLAY myear WITH FRAME a.     
REPEAT:

UPDATE entity mperiod creater accounter casher auditor WITH FRAME a.
/* IF FRAME-FIELD = "entity" THEN DO:*/
      IF entity = '' THEN do:
          entity = gl_entity.
        DISPLAY entity WITH FRAME a.
      END.
      /*  END.*/
/* IF FRAME-FIELD = "mperiod" THEN DO:*/
    IF mperiod = ? THEN do:
        mperiod = glc_per.
     DISPLAY entity WITH FRAME a.
     
         end.
       /*  END.*/
    /* IF FRAME-FIELD = "path" THEN DO:*/
       IF path = "" THEN do:
           path = "c:\".
         DISPLAY path WITH FRAME a.
               end.
              /* END.*/
/* IF FRAME-FIELD = "creater" THEN DO: */
     IF creater = "" THEN do:
         MESSAGE "Creater empty!" VIEW-AS ALERT-BOX ERROR BUTTON OK. 
         PROMPT-FOR creater WITH FRAME a.
         UNDO,RETRY.
     
     
     END.
/* END.*/

/* IF FRAME-FIELD = "auditor" THEN DO: */
     IF auditor = "" OR auditor = creater THEN do:
         MESSAGE "auditor empty or invalid auditor!" VIEW-AS ALERT-BOX ERROR BUTTON OK. 
          PROMPT-FOR auditor WITH FRAME a.
         UNDO,RETRY.
     
     
     END.
 /*END.*/

 /*IF FRAME-FIELD = "accounter" THEN DO: */
      IF accounter = "" THEN do:
          MESSAGE "accounter empty !" VIEW-AS ALERT-BOX ERROR BUTTON OK. 
           PROMPT-FOR accounter WITH FRAME a.
          UNDO,RETRY.


      END.
 /* END.*/

path = path + "JZPZ.TXT".
OUTPUT TO value(path)  .
mcount = 0.
mpreref = ''.
FIND FIRST gl_ctrl NO-LOCK NO-ERROR.  
FOR EACH gltr_hist WHERE month(gltr_eff_dt) = mperiod and year(gltr_eff_dt) = year(today) AND gltr_entity = entity NO-LOCK  BY gltr_eff_dt BY gltr_ref  BY gltr_line :
  .it = ''.
    dr_base_amount = 0.
    cr_base_amount = 0.
    dr_curr_amount = 0.
    cr_curr_amount = 0.
    isadd = NO. 
    mcnt = 0.
   
    IF mpreref <> gltr_ref THEN DO:
    FOR EACH gltrhist1 WHERE gltrhist1.gltr_ref = gltr_hist.gltr_ref  AND (gltrhsit1.gltr_acc BEGINS '1001' OR gltrhsit1.gltr_acc BEGINS '1002' ) AND gltrhsit1.gltr_amt > 0 NO-LOCK:
        FIND gltrhist2 WHERE gltrhist12.gltr_ref = gltr_hist1.gltr_ref  AND (gltrhsit2.gltr_acc BEGINS '1001' OR gltrhsit2.gltr_acc BEGINS '1002' ) AND gltrhsit2.gltr_amt < 0 NO-LOCK:
        IF AVAILABLE gltrhsit2 THEN  DO: 
            CREATE mgltr.
            IF gltrhsit1.gltr_amt > abs(gltrhist2.gltr_amt) THEN DO:
           mgltr.gltr_eff_dt = gltrhist1.gltr_ref.
           mgltr.gltr_desc = gltrhsit1.gltr_desc. 
           mgltr.gltr_ref = gltrhits1.gltr_ref.
            mgltr.gltr_line = gltrhsit1.gltr_line.
            mgltr.gltr_acc = gltrhist1.gltr_acc.
            mgltr.gltr_amt =  gltrhsit1.gltr_amt - abs(gltrhist2.gltr_amt).
           mgltr.gltr_curramt = (gltrhsit1.gltr_amt - abs(gltrhist2.gltr_amt)) / gltrhsit1.gltr_ex_rate2.
           mgltr.gltr_ex_rate2 = gltrhsit1.gltr_ex_rate2.
           mgltr.gltr_curr = gltrhsit1.gltr_curr.
        mgltr.absline = gltrhist2.gltr_line.
           isadd = YES.
           END.
     ELSE
     DO: IF  gltrhsit1.gltr_amt < abs(gltrhist2.gltr_amt) THEN DO:
       mgltr.gltr_eff_dt = gltrhist2.gltr_ref.
         mgltr.gltr_ref = gltrhist2.gltr_ref.
          mgltr.gltr_desc = gltrhist2.gltr_desc.       
         mgltr.gltr_line = gltrhist2.gltr_line .
               mgltr.gltr_acc = gltrhist2.gltr_acc.
               mgltr.gltr_amt =  gltrhist2.gltr_amt + gltrhist1.gltr_amt.
              mgltr.gltr_curramt = (gltrhist2.gltr_amt + gltrhist1.gltr_amt) / gltrhist2.gltr_ex_rate2.
   mgltr.gltr_ex_rate2 = gltrhist2.gltr_ex_rate2.
    mgltr.gltr_curr = gltrhist2.gltr_curr.           
      mgltr.absline = gltrhist1.gltr_line.
    isadd = YES.
 
    END.
         
       IF isadd THEN   DO:
          mcnt = mcnt + 1.
           CREATE mgltr.
           mgltr.gltr_ref = gltrhist1.gltr_ref + "-" + mcnt.
           
           
           
           
           
           END.
         
         
         END.

  

             END.
     
             
             
             
             END.
    
    FIND qad_wkfl WHERE qad_key1 = 'cas' and  qad_wkfl.qad_charfld[2] = gltr_hist.gltr_acc NO-LOCK NO-ERROR.
  IF AVAILABLE qad_wkfl THEN macc = qad_key2.
     ELSE macc = gltr_acc + 'q'.
    IF gltr_hist.gltr_curr = gltr_hist.gl_base_curr THEN DO:
        IF gltr_hist.gltr_amt > 0 THEN  dr_base_amount = gltr_hist.gltr_amt.
           ELSE cr_base_amount = abs(gltr_hist.gltr_amt).
        
        
        END.
        ELSE DO:
            IF gltr_hist.gltr_amt > 0 THEN  dr_base_amount = gltr_hist.gltr_amt.
           ELSE cr_base_amount = abs(gltr_hist.gltr_amt).
            IF gltr_hist.gltr_curramt > 0 THEN dr_curr_amount = gltr_hist.gltr_curramt.
               ELSE   cr_curr_amount = abs(gltr_hist.gltr_curramt).
        END.
     
        
    
        
        
        IF mpreref <> gltr_ref THEN DO:
        
            
            
            
            
            mcount = mcount + 1.
        IF LENGTH(STRING(mcount)) = 1 THEN mzero = '000'.
        IF LENGTH(STRING(mcount)) = 2 THEN mzero = '00'.
        IF LENGTH(STRING(mcount)) = 3 THEN mzero = '0'.
        IF LENGTH(STRING(mcount)) = 4 THEN mzero = ''.
        mdoc = '0702' + mzero + STRING(mcount). 
       
        END.  
       IF (macc BEGINS '1001' OR macc BEGINS '1002') AND AVAILABLE gltrhist2 THEN 

              FIND mgltr WHERE mgltr.gltr_ref = gltr_hist.gltr_ref NO-LOCK NO-ERROR.
                 IF AVAILABLE mgltr THEN   DO:
                
               IF mgltr.gltr_curr = gl_base_curr THEN DO:
        IF mgltr.gltr_amt > 0 THEN  dr_base_amount = mgltr.gltr_amt.
           ELSE cr_base_amount = abs(mgltr.gltr_amt).
        
        
        END.
        ELSE DO:
            IF mgltr.gltr_amt > 0 THEN  dr_base_amount = mgltr.gltr_amt.
           ELSE cr_base_amount = abs(mgltr.gltr_amt).
            IF mgltr.gltr_curramt > 0 THEN dr_curr_amount = mgltr.gltr_curramt.
               ELSE   cr_curr_amount = abs(mgltr.gltr_curramt).
        END.
      
           FOR EACH mgltr1 WHERE mgltr1.gl_ref = mgltr.gltr_ref AND mgltr1.absline < mgltr.gltr_line NO-LOCK:
           linecnt = linecnt + 1.
       END. 
         mglline =  mgltr.gltr_line - linecnt.
        
        it = '"' + STRING(mgltr.gltr_eff_dt) + '"' + CHR(09) + '"' + '╪гук' + '"' + chr(09) + '"' + string(mdoc) + '"' + CHR(09)
        + string(mglline) + CHR(09) + '"' + mgltr.gltr_desc + '"' + CHR(09) + '"' + string(macc) + '"' + CHR(09)
        + string(dr_base_amount) + CHR(09) + STRING(cr_base_amount) + CHR(09) + '"' + mgltr.gltr_curr + '"' + CHR(09) + 
        STRING(dr_curr_amount) + CHR(09) + STRING(cr_curr_amount) + CHR(09) + STRING(mgltr.gltr_ex_rate2) + CHR(09) + 
        STRING(0.00) + CHR(09) + STRING(0.00) + CHR(09) + '""' + CHR(09) + '""' + CHR(09) + 
        '""' + CHR(09) + '""' + CHR(09) + '""' + CHR(09) + '1' + CHR(09) + '"' + creater + '"' + CHR(09)
        + '"' + auditor + '"' + CHR(09) + '"' + accounter + '"' + CHR(09) + '"' + casher + '"' + CHR(09) + 
        '"' + '1' + '"' + CHR(09) + '"' + '0' + '"'.
             
        END.

           ELSE DO:
        
          FOR EACH mgltr1 WHERE mgltr1.gltr_ref = gltr_hist.gltr_ref AND mgltr1.absline < gltr_hist.gltr_line NO-LOCK:
           linecnt = linecnt + 1.
       END. 
         mglline =  mgltr.gltr_line - linecnt.
        
        it = '"' + STRING(gltr_hist.gltr_eff_dt) + '"' + CHR(09) + '"' + '╪гук' + '"' + chr(09) + '"' + string(mdoc) + '"' + CHR(09)
        + string(mglline) + CHR(09) + '"' + gltr_hist.gltr_desc + '"' + CHR(09) + '"' + string(macc) + '"' + CHR(09)
        + string(dr_base_amount) + CHR(09) + STRING(cr_base_amount) + CHR(09) + '"' + gltr_curr + '"' + CHR(09) + 
        STRING(dr_curr_amount) + CHR(09) + STRING(cr_curr_amount) + CHR(09) + STRING(gltr_hist.gltr_ex_rate2) + CHR(09) + 
        STRING(0.00) + CHR(09) + STRING(0.00) + CHR(09) + '""' + CHR(09) + '""' + CHR(09) + 
        '""' + CHR(09) + '""' + CHR(09) + '""' + CHR(09) + '1' + CHR(09) + '"' + creater + '"' + CHR(09)
        + '"' + auditor + '"' + CHR(09) + '"' + accounter + '"' + CHR(09) + '"' + casher + '"' + CHR(09) + 
        '"' + '1' + '"' + CHR(09) + '"' + '0' + '"'.
           END.
        PUT SKIP.
    PUT UNFORMAT it.
     mpreref = gltr_ref.
     
    END.
    OUTPUT CLOSE.
 MESSAGE "JZPZ has built!" VIEW-AS ALERT-BOX BUTTON OK. 
    
    END.
