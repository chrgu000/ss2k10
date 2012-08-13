/*{mfdtitle.i}*/
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
DEF VAR mdesc LIKE gltr_desc.
DEF VAR  mexh LIKE gltr_ex_rate2.
DEF VAR  mdrcurramt LIKE dr_curr_amount.
   DEF VAR     mcrcurramt LIKE cr_curr_amount.
      DEF VAR    mdrbaseamt like dr_base_amount.
            DEF VAR    mcrbaseamt LIKE cr_base_amount.
            DEF VAR mcurr  AS CHAR FORMAT "x(4)".
            DEF VAR mdate AS CHAR FORMAT "x(8)".
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
  .
    dr_base_amount = 0.
    cr_base_amount = 0.
    dr_curr_amount = 0.
    cr_curr_amount = 0.
    FIND qad_wkfl WHERE qad_key1 = 'cas' and  qad_wkfl.qad_charfld[2] = gltr_hist.gltr_acc NO-LOCK NO-ERROR.
    FIND FIRST ac_mstr WHERE ac_code = gltr_acc NO-LOCK NO-ERROR.
    FIND FIRST gl_ctrl NO-LOCK NO-ERROR. 
  IF AVAILABLE qad_wkfl THEN macc = qad_key2.
     ELSE macc = gltr_acc + 'q'.
    IF gltr_curr = gl_base_curr THEN DO:
        IF gltr_amt > 0 THEN  dr_base_amount = gltr_amt.
           ELSE cr_base_amount = abs(gltr_amt).
        
        
        END.
        ELSE DO:
            IF gltr_amt > 0 THEN  dr_base_amount = gltr_amt.
           ELSE cr_base_amount = abs(gltr_amt).
            IF gltr_curramt > 0 THEN dr_curr_amount = gltr_curramt.
               ELSE   cr_curr_amount = abs(gltr_curramt).
        END.
       
        IF mpreref <> gltr_ref THEN DO:
        mcount = mcount + 1.
        IF LENGTH(STRING(mcount)) = 1 THEN mzero = '000'.
        IF LENGTH(STRING(mcount)) = 2 THEN mzero = '00'.
        IF LENGTH(STRING(mcount)) = 3 THEN mzero = '0'.
        IF LENGTH(STRING(mcount)) = 4 THEN mzero = ''.
        mdoc = '0701' + mzero + STRING(mcount). 
       
        END.  
      mdesc = gltr_desc.
     
      IF mdesc = '' THEN mdesc = qad_wkfl.qad_charfld[1].
      mdesc = REPLACE(mdesc,'"','').
      mdesc = REPLACE(mdesc,"'","").
   IF ac_curr <> gl_base_curr THEN DO: 
       mexh = gltr_ex_rate2 .
       mdrcurramt = ROUND(dr_base_amount / mexh,2).
       mcrcurramt = ROUND(cr_base_amount / mexh,2).
       mdrbaseamt = dr_base_amount.
       mcrbaseamt = cr_base_amount.
     IF ac_curr = 'usd'then  mcurr = "美元".
     IF ac_curr = 'eur' THEN mcurr = "欧元".
                    END.
            ELSE do:
                mexh = 1.
            mdrcurramt = 0.
              mcrcurramt = 0.  
                mdrbaseamt = dr_base_amount.
                mcrbaseamt = cr_base_amount.
                mcurr = ''.
                END.
                mdate = string(YEAR(gltr_eff_dt)) + STRING(MONTH(gltr_eff_dt),"99") + STRING(DAY(gltr_eff_dt),"99").
                it = '"' + mdate + '"' + CHR(09) + '"' + '记账' + '"' + chr(09) + '"' + string(mdoc) + '"' + CHR(09)
        + string(gltr_line) + CHR(09) + '"' + mdesc + '"' + CHR(09) + '"' + string(macc) + '"' + CHR(09)
        + string(mdrbaseamt) + CHR(09) + STRING(mcrbaseamt) + CHR(09) + '"' + mcurr + '"' + CHR(09) + 
        STRING(mdrcurramt) + CHR(09) + STRING(mcrcurramt) + CHR(09) + STRING(mexh) + CHR(09) + 
        STRING(0.00) + CHR(09) + STRING(0.00) + CHR(09) + '""' + CHR(09) + '""' + CHR(09) + 
        '""' + CHR(09) + '""' + CHR(09) + '""' + CHR(09) + '1' + CHR(09) + '"' + creater + '"' + CHR(09)
        + '"' + auditor + '"' + CHR(09) + '"' + accounter + '"' + CHR(09) + '"' + casher + '"' + CHR(09) + 
        '"' + '1' + '"' + CHR(09) + '"' + '0' + '"'.
    PUT SKIP.
    PUT UNFORMAT it.
     mpreref = gltr_ref.
     
    END.
    OUTPUT CLOSE.
 MESSAGE "JZPZ has built!" VIEW-AS ALERT-BOX BUTTON OK. 
    
    END.
