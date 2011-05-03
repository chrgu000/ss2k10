/* mfphead.i - INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/*F0PN*/ /*V8:ConvertMode=Report                                           */
/*  REVISION: 1.0          LAST EDIT: 02/13/86       MODIFIED BY: EMB      */
/*  REVISION: 5.0          LAST EDIT: 11/29/90       MODIFIED BY: emb *B828*/
/*  REVISION: 7.3          LAST EDIT: 03/24/95       MODIFIED BY: jzs *G0FB*/
/*  REVISION: 7.3          LAST EDIT: 01/24/96       MODIFIED BY: dzn *G1KT*/
/*  REVISION: 8.6          LAST EDIT: 09/17/97       MODIFIED BY: kgs *K0J0*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/*  REVISION: 8.6E         LAST EDIT: 05/15/98   BY: *H1L9*  Vijaya Pakala */
/*  REVISION: 8.6E         LAST EDIT: 10/04/98   BY: *J314* Alfred Tan     */
/***************************************************************************/
/*!
{1} "STREAM stream-name" (optional - but if used must include STREAM keyword)
{2} "(stream-name)"      (optional - needed if {1} is used (omit keyword)
*/
/***************************************************************************/


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfphead_i_1 "时间:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfphead_i_2 "日期："
/* MaxLen: Comment: */

&SCOPED-DEFINE mfphead_i_3 "页号:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define variable rtitle as character format "X(100)".
         define variable co_name as character format "X(30)".

         define variable len_raw as integer.    /*H1L9*/

         find ls_mstr where ls_addr = "~~reports" and ls_type = "company"
            no-lock no-error.

         if available ls_mstr then
        find ad_mstr where ad_addr = ls_addr no-lock no-error.

         if available ad_mstr then
           co_name = fill(" ",
/*G1KT*        max( (15 - integer(length(ad_name) / 2)), 1) ) +              */
/*G1KT*/       max( (15 - integer( {gprawlen.i &strng=ad_name} / 2)), 1) ) +
               ad_name.
           len_raw = {gprawlen.i &strng=substr(dtitle,16,50)}.   /*H1L9*/

         /* GUI has a different dtitle,
       ** so we need to adjust rtitle differently.
      */
/*G0FB*/ /*V8-*/
         rtitle = substring(dtitle,1,15) +
            fill(" ",25) +
            substring(dtitle,16,50 - (len_raw - 50)).  /*H1L9*/
         /*  substring(dtitle,16,50).                   *H1L9*/
/*G0FB*/ /*V8+*/

/*G0FB*/ /*V8!
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
/*G0FB*/ */
      
         
         form
           
            header    
            rtitle
            {&mfphead_i_2}        to 123
            today          skip
            {&mfphead_i_3}        at 1
            string         (page-number {2}) format "X(8)"
            co_name        at 53
            {&mfphead_i_1}        to 123
            string         (Time,"hh:mm:ss")
            with frame phead  width 160 no-box.

/*K0J0*/ {wbgp03.i}

/*K0J0*/ if c-application-mode = 'WEB':U and c-web-request = 'DATA':U then do:
/*K0J0*/   put stream webstream
/*K0J0*/     skip {&WEB-LABEL-HEADER-TAG} skip
/*K0J0*/     rtitle
/*K0J0*/     {&mfphead_i_2} to 123
/*K0J0*/     today skip
/*K0J0*/     co_name at 53
/*K0J0*/     {&mfphead_i_1}        to 123
/*K0J0*/     string         (Time,"hh:mm:ss")
/*K0J0*/     skip {&WEB-END-HEADER-TAG} skip.
/*K0J0*/   form
/*K0J0*/     header
/*K0J0*/     {&mfphead_i_3}        at 1
/*K0J0*/     string         (page-number {2}) format "x(8)"
/*K0J0*/   with frame pwebhead page-top width 132 no-box.
/*K0J0*/   /* view {1} frame pwebhead. */
/*K0J0*/ end.
/*K0J0*/ else
          
         /* view {1} frame phead. */

/*end mfphead.i*/
