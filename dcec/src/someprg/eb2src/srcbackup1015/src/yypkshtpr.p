/* SUNMAN AS OF 2001-10-25*/
/* kangjian as of 2001-11-6 */
/* kangjian not page with different work center*/
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*J094*/  {mfdtitle.i "99 "}

define variable pknbr1 like short-pknbr label "领料单" .
define variable pknbr2   like short-pknbr label {t001.i}.
define variable keeper1 like pt_article label "库管员" format "x(8)".
define variable keeper2 like pt_article label {t001.i} format "x(8)".
define variable delyn as logical label "删除".
define variable dcount as integer.

/* DISPLAY TITLE */
/*J094*  {mfdtitle.i "99 "}     */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(1)  /*GUI*/
   pknbr1     colon 25
   pknbr2       colon 46
   keeper1	colon 25
   keeper2	colon 46
   skip (1)
   delyn 	colon 38 format "Y/N"
 SKIP(.4)  /*GUI*/
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

setframelabels(frame a:handle) .


/*GUI*/ {mfguirpa.i true  "printer" 80 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if pknbr2 = hi_char then pknbr2 = "".
   if keeper2 = hi_char then keeper2 = "".
   delyn = no.
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   bcdparm = "".
   {mfquoter.i pknbr1}
   {mfquoter.i pknbr2}
   {mfquoter.i keeper1}
   {mfquoter.i keeper2}

   if  pknbr2 = "" then pknbr2 = hi_char.
   if  keeper2 = "" then keeper2 = hi_char.

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 80}
/*GUI*/



   {mfphead2.i}

		     FORM /*GUI*/ 
			skip(1) space(19)
			wo_site wr_wkctr
			wc_desc no-label
			short-pknbr label "领料单号"
		     with STREAM-IO /*GUI*/  frame shortage /*page-top*/ width 132 side-labels
		     title color normal " 短 缺 清 单 ".

		     for each short-pklst use-index short-pknbr exclusive-lock
		     where short-pknbr >= pknbr1 and short-pknbr <= pknbr2,
		     each pt_mstr where pt_part = short-part
		     and pt_article >= keeper1 and pt_article <= keeper2
		     break by short-site by short-pknbr by short-wkctr by pt_article
		     with frame short width 132 no-attr-space:
		
                   if first-of (short-wkctr) then do:	
		     display 
		     short-site @ wo_site
		     short-wkctr @ wr_wkctr
		     short-wcdesc @ wc_desc
			short-pknbr
		     with frame shortage STREAM-IO /*GUI*/ .
		end. /* IF FIRST-OF */


			if page-size - line-counter < 1 then do:
			 page.
		     display 
		     short-site @ wo_site
		     short-wkctr @ wr_wkctr
		     short-wcdesc @ wc_desc
			short-pknbr
		     with frame shortage STREAM-IO /*GUI*/ .			 
			 end.

			display space(19)
			   short-part @ ps_comp
			   pt_desc1 when (available pt_mstr)
			   short-qty label "短缺量"
			   pt_um when (available pt_mstr)
			   short-deliv label "送至"
			   short-assy @ ps_par
			   pt_article label "库管员"
			with frame short STREAM-IO /*GUI*/ .

			down 1.
			 display pt_desc2 @ pt_desc1
				  with frame short STREAM-IO /*GUI*/ .
                     if delyn then
			delete short-pklst.
		    
		     hide frame shortage.

		  end.    

   


/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


{mfreset.i}

/*GUI*/ end procedure. /*p-report*/

/*GUI*/ {mfguirpb.i &flds=" pknbr1 pknbr2 keeper1 keeper2 delyn "} /*Drive the Report*/




