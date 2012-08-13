/* xxpidfrp01.p  - Physical Inventroy Difference Report                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1                 Developped: 06/15/01      BY: Rao Haobin          */
/* Rev: eb2+ sp7      Last Modified: 05/06/28      BY: judy Liu         */
/* 本报表用于输出两次盘点的差异报表供复核所用 */

{mfdtitle.i } 

define variable tag like tag_nbr init ?.
define variable tag1 like tag_nbr init ?.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     tag           colon 18
	     tag1          label {t001.i} colon 49
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
/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).



	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if tag = 0 then tag = ?.
   if tag1 = 99999999 then tag1 = ?.
	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i tag }
	     {mfquoter.i tag1   }
	     
   if tag = ? then tag = 0.
   if tag1 = ? then tag1 = 99999999.
   	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}

/*judy 05/06/29*/ /*for each tag_mstr no-lock where tag_cnt_qty <> tag_rcnt_qty:*/
/*judy 05/06/29*/  for each tag_mstr no-lock where tag_cnt_qty <> tag_rcnt_qty AND tag_nbr >= tag AND tag_nbr <= tag1:
disp tag_nbr column-label "盘点卡号" tag_part column-label "零件号" tag_cnt_qty column-label "初盘数量" tag_rcnt_qty column-label "复盘数量"  with width 132 STREAM-IO.
end.

{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
/*judy 06/29/05*/ {mfreset.i}
end procedure.



/*GUI*/ {mfguirpb.i &flds=" tag tag1  "} /*Drive the Report*/


 
