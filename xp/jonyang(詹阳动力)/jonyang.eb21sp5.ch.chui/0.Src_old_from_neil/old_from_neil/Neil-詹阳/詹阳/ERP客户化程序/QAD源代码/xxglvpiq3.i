/* xxglvpiq3.i - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY SUBROUTINE TO*/
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*                          DISPLAY INDIVIDUAL LINE ITEMS.               */
/* REVISION: 7.0         LAST MODIFIED:  10/17/91   by: jms   *F058*     */
/*                                       05/22/92   by: jms   *F506*     */
/*                                       05/27/92   by: jms   *F535*     */
/* REVISION: 8.5         LAST MODIFIED:  11/15/95   by: sxb   *J053*     */
/*************************************************************************/
/*!
This include file displays the individual line items for the unposted
transaction inquiry.
*/
/*************************************************************************/

      /* DISPLAY INDIVIDUAL TRANSACTION INFORMATION */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

      find ac_mstr where ac_domain = global_domain and ac_code = gltr_acc no-lock no-error.
      if available ac_mstr then accurr = ac_curr.
      
      amt = gltr_amt.
/*F506*/  if curr <> base_curr then do:
/*F535*/      if (gltr_curr = curr or accurr = curr)
              then amt = gltr_curramt.
              else amt = 0.
/*F535*/  end.
      {glacct.i &acc=gltr_acc &sub=gltr_sub &cc=gltr_ctr &acct=account}
      desc1 = substring(gltr_desc, 1, 22).
      display gltr_line
          account
          gltr_project
          gltr_entity
          desc1
/*J053*********** amt ******************************/
/*J053*/      amt format "->>,>>>,>>>,>>9.99<<<<"
/*F535*/          curr WITH STREAM-IO /*GUI*/ . /*gltr_curr*/.
/*F535*//*if curr = base_curr then disp base_curr @ gltr_curr.
/*F506*/  else do:
/*F506*/     if curr = accurr then disp accurr @ gltr_curr.
/*F506*/     else if curr = gltr_curr then disp gltr_curr.
/*F506*/     else disp base_curr @ gltr_curr.
/*F535*/  end.       */
      if gltr_error <> "" then do:
         down 1.
         disp gltr_error @ amt WITH STREAM-IO /*GUI*/ .
      end.
