/* GUI CONVERTED from chgltiq3.i (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chgltiq3.i - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY SUBROU - CAS      */
/* glutriq3.i - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY SUBROUTINE TO     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7 $                                                           */
/*V8:ConvertMode=Report                                                       */
/*                          DISPLAY INDIVIDUAL LINE ITEMS.                    */
/* REVISION: 7.0         LAST MODIFIED:  10/17/91   by: jms   *F058*          */
/*                                       05/22/92   by: jms   *F506*          */
/*                                       05/27/92   by: jms   *F535*          */
/* REVISION: 8.5         LAST MODIFIED:  11/15/95   by: sxb   *J053*          */
/* REVISION: 9.1         LAST MODIFIED:  08/14/00   by: *N0L1* Mark Brown     */
/* REVISION: 9.1         LAST MODIFIED:   9/22/00   BY: *N0VY* Mudit Mehta    */
/* REVISION: 9.1CH       LAST MODIFIED:  05/03/01   by: *XXCH911* C Yen       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6     BY: Jean Miller           DATE: 04/15/02  ECO: *P05H*    */
/* $Revision: 1.7 $       BY: Rafal Krzyminski   DATE: 04/22/03  ECO: *P0P3*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*************************************************************************/
/* This include file displays the individual line items for the unposted
   transaction inquiry.                                                  */
/*************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{cxcustom.i "GLUTRIQ3.I"}

/* DISPLAY INDIVIDUAL TRANSACTION INFORMATION */
find ac_mstr where ac_code = glt_acc and ac_domain = global_domain no-lock no-error.
if available ac_mstr then
   accurr = ac_curr.

amt = glt_amt.

if curr <> base_curr then do:
   if (glt_curr = curr or accurr = curr) then
      amt = glt_curr_amt.
   else
      amt = 0.
end.

/*XXCH911*/ {chtramt3.i &glamt=amt
                        &coa=glt_correction
                        &drcr=dr_cr
                        &dispamt=amt}
/*XXCH911*/ drcrtxt = getTermLabel(string(dr_cr, "Dr/Cr"), 2).

{glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}

{glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}

{&GLUTRIQ3-I-TAG1}
desc1 = substring(glt_desc, 1, 22).

{&GLUTRIQ3-I-TAG2}
display
   glt_line
   account
   glt_project
   glt_entity
/*CF*   desc1  */
/*XXCH911*/ desc1 format "x(16)" 
/*XXCH911*/ drcrtxt @ dr_cr
/*XXCH911*  amt format "->>,>>>,>>>,>>9.99<<<<" */
/*XXCH911*/ amt
   curr WITH STREAM-IO /*GUI*/ .
{&GLUTRIQ3-I-TAG3}

if glt_error <> "" then do:
   down 1.
   display glt_error @ amt WITH STREAM-IO /*GUI*/ .
end.
