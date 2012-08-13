/* xxpirp01.p  - Production Issue Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1                 Developped: 20/05/02      BY: Rao Haobin          */
/* V1.1               Developped: 16/06/02      BY: Rao Haobin          */
/* RHB 生产材料领用报表，按零件-产成品分类统计 */

{mfdtitle.i } 

define variable site like pt_site.
define variable site1 like pt_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable line like tr_prod_line.
define variable line1 like tr_prod_line.
define variable date like tr_effdate.
define variable date1 like tr_effdate.
define variable so_prodline like pt_prod_line.
define variable part_prodline like pt_prod_line.
define variable ws_sum_all as decimal  label "发放金额合计"  format "->,>>>,>>>,>>9.99" initial 0.
define TEMP-TABLE wo_sum field ws_part like pt_part
			field ws_prod_line like pt_prod_line
			field ws_so like wo_part label "SO号"
			field ws_qty like tr_qty_chg label "数量"
			field ws_sum as decimal label "金额" format "->,>>>,>>>,>>9.99".
                        
DEF VAR trnbr LIKE tr_trnbr .
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     site           colon 18
	     site1          label {t001.i} colon 49 skip
	     line 	    colon 18
	     line1          label {t001.i} colon 49 skip
	     part           colon 18
	     part1          label {t001.i} colon 49 skip
             date            colon 18
             date1           label {t001.i} colon 49 skip
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).

	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if part1 = hi_char then part1 = "".
	     if date = low_date then date = ?.
	     if date1 = hi_date then date1 = ?.
	     if site1 = hi_char then site1 = "".
	     if line1 = hi_char then line1 = "".
	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i part   }
	     {mfquoter.i part1   }
	     {mfquoter.i date   }
	     {mfquoter.i date1   }
	     {mfquoter.i site   }
	     {mfquoter.i site1   }
	     {mfquoter.i line   }
	     {mfquoter.i line1   }
	     
	     if  part1 = "" then part1 = hi_char.
	     if  site1 = "" then site1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
	     /* SELECT PRINTER */   
	     
/*GUI*/ end procedure. /* p-report-quote */
FIND FIRST tr_hist NO-LOCK WHERE tr_effdate >= date1 NO-ERROR .
IF AVAIL tr_hist THEN trnbr = tr_trnbr .
/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}


for each tr_hist no-lock where tr_type = "iss-wo" and tr_effdate >= date and tr_effdate <= date1 and tr_site >= site and tr_site <= site1 
    /*cj*/ AND tr_part >= part AND tr_part <= part1 AND tr_prod_line >= LINE AND tr_prod_line <= line1 AND tr_trnbr >= trnbr
,each wo_mstr no-lock where wo_lot = tr_lot /*cj*/ USE-INDEX wo_lot :

find first wo_sum where ws_part = tr_part and ws_so = wo_part no-error.
if not available wo_sum then do:
create wo_sum.
ws_part = tr_part.
ws_so = wo_part.
ws_prod_line = tr_prod_line.
ws_qty = 0.
ws_sum = 0.
end.

ws_qty = ws_qty + tr_qty_chg.
ws_sum = ws_sum + round(tr_qty_chg * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std),2).

end. /* for each tr_hist */

ws_sum_all = 0.
for each wo_sum where ws_part >= part and ws_part <= part1 and ws_prod_line >=line and ws_prod_line <=line1 break by ws_part :
ACCUMULATE ws_sum (TOTAL BY ws_part).
ACCUMULATE ws_qty (TOTAL BY ws_part).
find pt_mstr where pt_part = ws_part NO-LOCK no-error.
  if available pt_mstr then do:
  	part_prodline = pt_prod_line.
  end.
  if not available pt_mstr then do:
  	part_prodline = "null" .
  end.
find pt_mstr where pt_part = ws_so NO-LOCK no-error.
     if available pt_mstr then do:
  	so_prodline = pt_prod_line.
     end.
     if not available pt_mstr then do:
  	so_prodline = "null" .
     end.

/*judy 07/05/05*/ /* disp ws_part part_prodline ws_so  so_prodline ws_qty ws_sum with width 180.*/
/*judy 07/05/05*/  disp ws_part part_prodline ws_so  so_prodline ws_qty ws_sum    with width 180 STREAM-IO. 
if last-of(ws_part) then do:
down 1.
display accum total by ws_part ws_qty label "数量合计" accum total by ws_part ws_sum label "金额合计" format "->,>>>,>>>,>>9.99"  .
down 1.
end.
ws_sum_all = ws_sum_all + ws_sum.

/*judy 07/05/05*/ IF LAST(ws_part) THEN DO:
/*judy 07/05/05*/     disp ws_sum_all WITH FRAME cc STREAM-IO.
/*judy 07/05/05*/     ws_sum_all = 0.
/*judy 07/05/05*/  END.
end. /* for each wo_sum */


/*judy 07/05/05*/   /*disp ws_sum_all. */



{mfguitrl.i}


for each wo_sum:
delete wo_sum.
end.

/*judy 07/05/05*/  {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end procedure.



/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 "} /*Drive the Report*/


/*judy 07/05/05*/ /* {mfreset.i}*/
