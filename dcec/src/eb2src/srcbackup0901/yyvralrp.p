
/* xxvralrp.p - Varience Detail REPORT - By Shop Order not only By Production Line                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      Developed: 01/28/02   BY: RHB                 */
/* REVISION: 2.0        Modified: 04/08/02 BY: RHB                  */



/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f "}  /*GA14*/ /*GUI moved to top.*/
define variable varacct like gltr_acc label "差异帐户". 
define variable site like pt_site.
define variable site1 like pt_site.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable part like pt_part.
define variable part1 like pt_part.
define variable effdate like tr_effdate.
define variable effdate1 like tr_effdate.
define variable pldesc like pl_desc.
define variable prod_var_ic as decimal label "产品类差异合计-ic" format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_var_ic as decimal label "差异合计-ic" format "->,>>>,>>>,>>9.99" initial 0.
define variable prod_var_wo as decimal label "产品类差异合计-wo" format "->,>>>,>>>,>>9.99" initial 0.
define variable sum_var_wo as decimal label "差异合计-wo" format "->,>>>,>>>,>>9.99" initial 0.


define workfile so_sum field so_part like pt_part
                        field so_var_ic as decimal  label "差异-ic"  format "->,>>>,>>>,>>9.99"
                        field so_var_wo as decimal  label "差异-wo"  format "->,>>>,>>>,>>9.99".
                        
/* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

/* SELECT FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
 	    varacct	colon 20 skip
            site           colon 20
            site1          label {t001.i} colon 49 skip
	    line           colon 20
            line1          label {t001.i} colon 49 skip
            part           colon 20
            part1          label {t001.i} colon 49 skip
            effdate           colon 20
            effdate1          label {t001.i} colon 49 skip
/*GL58   with frame a side-labels. */
/*GL58*/  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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

   if varacct = hi_char then varacct = "".
   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if site1 = hi_char then site1 = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.



   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   bcdparm = "".
   {mfquoter.i line   }
   {mfquoter.i line1  }
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i site   }
   {mfquoter.i site1  }
   {mfquoter.i effdate }
   {mfquoter.i effdate1}
   {mfquoter.i varacct }

   if varacct = "" then varacct = hi_char.
   if  part1 = "" then part1 = hi_char.
   if  line1 = "" then line1 = hi_char.
   if  site1 = "" then site1 = hi_char.
   if  effdate = ?  then effdate  = low_date.
   if  effdate1 = ?  then effdate1  = hi_date.

   /* PRINTER SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}


for each gltr_hist use-index gltr_acc_ctr where gltr_acc = varacct and gltr_eff_dt >= effdate and gltr_eff_dt <=effdate1
    ,each trgl_det use-index trgl_ref_nbr where trgl_gl_ref = gltr_ref
    ,each tr_hist use-index tr_trnbr where tr_trnbr = trgl_trnbr no-lock:

	if not tr_type = "iss-wo" then do:
		find first so_sum where so_part = tr_part no-error.
		if available so_sum then do:
		so_var_ic = so_var_ic + gltr_amt.
		end.
		else do:
		create so_sum.
		so_part = tr_part.
		so_var_ic = gltr_amt.
		end.
	end.
	else do:
		find first wo_mstr where wo_lot = tr_lot no-error.
		find first so_sum where so_part = wo_part no-error.
		if available so_sum then do:
		so_var_ic = so_var_ic + gltr_amt.
		end.
		else do:
		create so_sum.
		so_part = wo_part.
		so_var_ic = gltr_amt.
		end.
	end.
end.


for each gltr_hist use-index gltr_acc_ctr where gltr_acc = varacct and gltr_eff_dt >= effdate and gltr_eff_dt <=effdate1
    ,each opgl_det use-index opgl_ref_nbr where opgl_gl_ref = gltr_ref
    ,each op_hist use-index op_trnbr where op_trnbr = opgl_trnbr no-lock:

find first so_sum where so_part = op_part no-error.
if available so_sum then do:
so_var_wo = so_var_wo + gltr_amt.
end.
else do:
create so_sum.
so_part = op_part.
so_var_wo = gltr_amt.
end.
end.


   for each pt_mstr where (pt_prod_line >= line and pt_prod_line <= line1)
   and (pt_part >= part and pt_part <= part1)
   and (pt_site >= site and pt_site <= site1)
   no-lock use-index pt_prod_part break by pt_prod_line by pt_part
   with frame b down width 132 STREAM-IO:


      if first-of (pt_prod_line) then do:
	 if page-size - line-counter < 7 then page.
	 find pl_mstr where pl_prod_line = pt_prod_line no-lock.
	 pldesc = pl_desc.
	 display skip(1) pt_prod_line pl_desc no-label
	 with frame a2 side-labels no-box STREAM-IO /*GUI*/ .
/*cj*/ setFrameLabels(frame a2:handle).

	 prod_var_ic = 0.
	 prod_var_wo = 0.
      end.


      FORM /*GUI*/ 
       header
      skip(1)
      pt_prod_line pldesc " (继续)"
      with STREAM-IO /*GUI*/  frame a1 page-top side-labels.
      view frame a1.
/*cj*/ setFrameLabels(frame a1:handle).

      if page-size - line-counter < 2 then page.

for each so_sum where so_part = pt_part.
disp pt_part LABEL "零件" pt_desc2 LABEL "描述" so_var_ic so_var_wo so_var_ic + so_var_wo column-label "差异合计" format "->>,>>>,>>>,>>9.99" with width 132 STREAM-IO.
prod_var_ic = prod_var_ic + so_var_ic.
sum_var_ic = sum_var_ic + so_var_ic.
prod_var_wo = prod_var_wo + so_var_wo.
sum_var_wo = sum_var_wo + so_var_wo.
end.

if last-of (pt_prod_line) then do:
disp pt_prod_line COLUMN-LABEL "产品类" prod_var_ic prod_var_wo prod_var_ic + prod_var_wo column-label "差异合计" format "->>,>>>,>>>,>>9.99"with width 132 STREAM-IO.
prod_var_ic = 0.
prod_var_wo = 0.
end.

/*judy 07/05/05*/  IF LAST(pt_prod_line) THEN DO:
/*judy 07/05/05*/  disp sum_var_ic  sum_var_wo sum_var_ic + sum_var_wo column-label "差异合计" format "->>,>>>,>>>,>>9.99" with width 132 STREAM-IO FRAME cc.
 /*judy 07/05/05*/   sum_var_ic = 0.
/*judy 07/05/05*/    sum_var_wo = 0.
/*judy 07/05/05*/ END.


end.

 
/*judy 07/05/05*/  /*disp sum_var_ic  sum_var_wo sum_var_ic + sum_var_wo column-label "差异合计" format "->>,>>>,>>>,>>9.99" with width 132 STREAM-IO.*/
/*judy 07/05/05*/  /*sum_var_ic = 0.*/
/*judy 07/05/05*/ /*    sum_var_wo = 0.*/
    
 


   /* REPORT TRAILER */

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" varacct site site1 line line1 part part1  effdate effdate1 "} /*Drive the Report*/
