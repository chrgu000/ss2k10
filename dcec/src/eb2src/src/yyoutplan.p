/*Zzictrcfcrp2.p for report the transaction of the items during a period*/
/*Last modify: 12/25/2003, By: Kevin, copy from zzictrcfcrp.p*/

/* DISPLAY TITLE */
{mfdtitle.i "e+ "}

def var effdate like tr_effdate label "生效日期".
def var effdate1 like tr_effdate.

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes 
     LABEL "Suppress Zero" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 NO-UNDO.

DEF VAR I AS INTE.
DEF VAR LINECOUNT AS INTE.

Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 effdate colon 22       effdate1 colon 49 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:

    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
        
    update effdate effdate1  /*site site1*/
            with frame a.
    
    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
        
    {mfselbpr.i "printer" 132}
        
    status input "Waiting for report process...".
        
  FOR each tr_hist WHERE  tr_type = 'ISS-UNP'
                 and tr_effdate >= effdate
                 and tr_effdate <= effdate1 NO-LOCK ,
    each trgl_det where trgl_trnbr =tr_trnbr   NO-LOCK break by  tr_trnbr :
    find first pt_mstr where pt_part = tr_part no-lock no-error.
    disp tr_trnbr label "事务号" tr_nbr label "订单" tr_part label "零件号"
      pt_desc2 label "中文描述" tr_site label "地点" pt_prod_line
      tr_type tr_so_job label "销售/定制品" tr_qty_chg label "数量"
      trgl_cr_acct trgl_dr_acct trgl_gl_amt label "价格" 
      tr_effdate with width 180 stream-io.
 end.            
    {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
    
    status input.
    
end. /*repeat*/
