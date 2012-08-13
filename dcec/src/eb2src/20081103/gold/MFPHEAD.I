/* GUI CONVERTED from mfphead.i (converter v1.69) Sat Mar 30 01:16:18 1996 */
/* mfphead.i - INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/*F0PN*/ /*V8:ConvertMode=Report                                           */
/*  REVISION: 1.0          LAST EDIT: 02/13/86       MODIFIED BY: EMB      */
/*  REVISION: 5.0          LAST EDIT: 11/29/90       MODIFIED BY: emb *B828*/
/*  REVISION: 7.3          LAST EDIT: 03/24/95       MODIFIED BY: jzs *G0FB*/
/*  REVISION: 7.3          LAST EDIT: 01/24/96       MODIFIED BY: dzn *G1KT*/
/***************************************************************************/
/*!
{1} "STREAM stream-name" (optional - but if used must include STREAM keyword)
{2} "(stream-name)"      (optional - needed if {1} is used (omit keyword)
*/
/***************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         define variable rtitle as character format "X(100)".
         define variable co_name as character format "X(30)".

         find ls_mstr where ls_addr = "~~reports" and ls_type = "company"
            no-lock no-error.

         if available ls_mstr then
	    find ad_mstr where ad_addr = ls_addr no-lock no-error.

         if available ad_mstr then
            co_name = fill(" ",
/*G1KT*        max( (15 - integer(length(ad_name) / 2)), 1) ) +              */
/*G1KT*/       max( (15 - integer( {gprawlen.i &strng=ad_name} / 2)), 1) ) +
               ad_name.

         /* GUI has a different dtitle,
	 ** so we need to adjust rtitle differently.
	 */
/*G0FB*/ /*V8+*/

/*G0FB*/      
/*G1KT*
**       rtitle = execname +
**          fill(" ", 15 - integer(length(execname) ) ) +
**          fill(" ", 52 - integer(length(dtitle) / 2)) +
**          dtitle.
**G1KT*/
/*G1KT*/ {gprtitle.i
	    &rpt_title=rtitle
	    &exec_name=execname
            &exec_length=15
	    &def_titl_col=52
	    &def_title=dtitle}
/*G0FB*/   

         FORM /*GUI*/ 
            header
            rtitle
            "日期:"        to 123
            today          skip
            "页号:"        at 1
            string         (page-number {2}) format "X(8)"
            co_name        at 53
            "时间:"        to 123
            string         (Time,"hh:mm:ss")
            with STREAM-IO /*GUI*/  frame phead page-top width 132 no-box.

         view {1} frame phead.

/*end mfphead.i*/
