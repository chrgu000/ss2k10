{mfdtitle.i "++ "}
DEFINE VAR itpart LIKE tr_part.
DEFINE VAR bedate LIKE tr_date INIT TODAY.
DEFINE VAR eddate LIKE tr_date INIT TODAY.
DEFINE VAR partsum LIKE tr_qty_loc INIT 0.
DEFINE VAR sosum LIKE tr_qty_loc INIT 0.
DEFINE WORKFILE xxwkpt
       FIELD part LIKE  tr_part
       FIELD lot LIKE  tr_lot
       FIELD qty LIKE  tr_qty_loc. /*part*/


DEFINE WORKFILE xxwkso
       FIELD partpt LIKE tr_part
       FIELD partsum LIKE tr_qty_loc
       FIELD partso LIKE  tr_part
       FIELD qty LIKE  tr_qty_loc
       FIELD lot LIKE  tr_lot. /*so */

/* 查询零件回冲的数量和冲到的发动机*/

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 itpart colon 22   LABEL "零件号"
 bedate colon 22 LABEL "开始日期"  eddate colon 49 label "结束日期"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .

REPEAT:
    update itpart bedate eddate with frame a.
    {mfquoter.i itpart}
    {mfquoter.i bedate}
    {mfquoter.i eddate}
    {mfselbpr.i "printer" 132}
   FOR EACH xxwkpt.
       DELETE xxwkpt.
   END.
   FOR EACH xxwkso.
       DELETE xxwkso.
   END.

   FOR EACH tr_hist WHERE  tr_type = "iss-wo" AND tr_effdate >= bedate AND tr_effdate <= eddate AND tr_part =itpart AND (tr_userid = "admin" OR tr_userid = "mrp")
       USE-INDEX tr_type BREAK BY tr_lot .
    IF FIRST-OF (tr_lot) THEN partsum =0.
    partsum= partsum + tr_qty_loc.
    IF LAST-OF(tr_lot) THEN do:
           CREATE xxwkpt.
           ASSIGN xxwkpt.part = tr_part
                  xxwkpt.qty = partsum
                  xxwkpt.lot = tr_lot.
    END.
   END.

   FOR EACH xxwkpt.
    FOR EACH tr_hist WHERE tr_type ="rct-wo" AND  tr_effdate >= bedate AND tr_effdate <=eddate AND tr_lot = xxwkpt.lot AND (tr_userid = "admin" OR tr_userid = "mrp")
        USE-INDEX tr_type BREAK BY tr_lot. 
        IF FIRST-OF (tr_lot) THEN sosum =0.
        sosum= sosum + tr_qty_loc.
        IF LAST-OF(tr_lot) THEN do:
           CREATE xxwkso.
           ASSIGN xxwkso.partpt = xxwkpt.part
                  xxwkso.partsum = xxwkpt.qty
                  xxwkso.partso = tr_part
                  xxwkso.qty = sosum
                  xxwkso.lot = xxwkpt.lot.
        END.
    END.
  END.

  PUT "零件号           ;零件回冲数量  ;发动机号          ;发动机回冲数量 ;事务号" skip.
  PUT "________________________________________________________________________" skip.
  FOR EACH xxwkso.
    PUT xxwkso.partpt ";" xxwkso.partsum ";" xxwkso.partso ";" xxwkso.qty ";" xxwkso.lot SKIP.
  END.

    {mfguitrl.i} 
    {mfreset.i}  
    {mfgrptrm.i}

END.




