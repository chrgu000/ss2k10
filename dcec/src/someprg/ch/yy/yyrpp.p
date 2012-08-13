

{mfdtitle.i "e+ "}
DEFINE VAR minpack LIKE pod_ord_mult.
DEFINE VAR sume LIKE tr_qty_loc.
DEFINE VAR v_date1 LIKE tr_effdate.
DEFINE VAR v_date2 LIKE tr_effdate.


Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 v_date1 colon 22       v_date2 colon 49 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/



REPEAT:
   IF v_date1 = hi_date THEN v_date1 = low_date.
   
   UPDATE  v_date1 v_date2 WITH FRAME a.

   IF v_date2 = low_date THEN v_date2 = hi_date.


   {mfselbpr.i "printer" 132}
 FOR EACH tr_hist WHERE tr_type = "RCT-PO" AND tr_effdate >= v_date1 AND tr_effdate <= v_date2 BREAK BY tr_part BY tr_nbr.
    IF FIRST-OF(tr_part) OR FIRST-OF(tr_nbr) THEN sume = 0.
    sume = sume + tr_qty_loc.
    IF LAST-OF(tr_part) OR LAST-OF(tr_nbr) THEN DO:
       FIND LAST pod_det WHERE pod_part = tr_part and pod_site = tr_site and pod_nbr = tr_nbr no-lock no-error.
       IF AVAIL pod_det THEN minpack = pod_ord_mult.
       else minpack = 0.
       
       FIND LAST qad_wkfl WHERE qad_key1 = "poa_det" AND qad_datefld[1]<= v_date2 AND qad_charfld[1] = tr_nbr and qad_charfld[2] = tr_part NO-ERROR.
       IF AVAIL (qad_wkfl) THEN DISP tr_part sume tr_addr tr_nbr minpack qad_datefld[1] qad_decfld[1] WITH WIDTH 180 STREAM-IO.
       ELSE DISP tr_part sume tr_addr tr_nbr  minpack  WITH WIDTH 180 STREAM-IO.
    END.
 END.

     {mfreset.i}
     {mfgrptrm.i}
END.
