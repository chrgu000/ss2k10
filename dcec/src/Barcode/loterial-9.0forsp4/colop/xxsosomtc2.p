/* xxsosomtc2.p - SO TRAILER UPDATE LOWER FRAME                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.14 $                                                */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: afs *G692**/
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: WUG *GB74**/
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009* */
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H208**/
/* REVISION: 7.4      LAST MODIFIED: 10/28/94   BY: dpm *GN67**/
/* REVISION: 7.4      LAST MODIFIED: 11/14/94   BY: str *FT44**/
/* REVISION: 7.3      LAST MODIFIED: 03/16/95   BY: WUG *G0CW**/
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 05/07/97   BY: *J1P5* Ajit Deodhar */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 02/04/00   BY: *N07M* Vijaya Pakala  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 11/03/00   BY: *L15F* Kaustubh K       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *G013*                  */
/* $Revision: 1.14 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable  rndmthd like rnd_rnd_mthd.
define shared variable  prepaid_fmt as character no-undo.
define shared variable  so_recno    as   recid.
define shared variable  undo_mtc2   like mfc_logical.
define shared variable  new_order   like mfc_logical.
define shared frame     d.
define        variable  valid_acct  like mfc_logical.
define        variable  old_rev     like so_rev.
define        variable retval as integer no-undo.

{mfsotrla.i}
{xxsosomt01.i}  /* Define shared form for frame d */
so_prepaid:format = prepaid_fmt.

for first so_mstr
      fields(so_ar_acct so_ar_cc so_bol so_cr_card so_cr_init
             so_curr so_disc_pct so_inv_mthd
             so_fob so_fst_id so_partial
             so_prepaid so_print_pl so_to_inv
             so_print_so so_pst_id so_pst_pct so_rev so_shipvia
             so_stat so_tax_pct so_tr1_amt so_trl3_cd
             so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt
             so__dec01 )
      where recid(so_mstr) = so_recno no-lock:
end. /* FOR FIRST so_mstr */

old_rev = so_rev.

do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


   find first so_mstr
      where recid(so_mstr) = so_recno exclusive-lock no-error.

   hide frame setd_sub no-pause.

   print_ih = ( substring(so_inv_mthd,1,1) = "b" or
                substring(so_inv_mthd,1,1) = "p" or
                substring(so_inv_mthd,1,1) = "").
   edi_ih = (substring(so_inv_mthd,1,1) = "b" or
             substring(so_inv_mthd,1,1) = "e").
   edi_ack = substring(so_inv_mthd,3,1) = "e".
   
/*xx*/ DISPLAY   so__dec01 WITH FRAME d.
 
   set
      so_cr_init
      so_cr_card
      so_stat when (so_stat =  "")
      so_rev
      edi_ack
      so_print_so
      so_print_pl
      print_ih
      edi_ih
      so_partial
      so_ar_acct
      so_ar_sub
      so_ar_cc
      so_prepaid
      so_fob
      so_shipvia
      so_bol
   with frame d.

   if (so_prepaid <> 0 ) then do:
      /* VALIDATE SO_PREPAID ACCORDING TO THE DOC CURRENCY ROUND MTHD*/
      {gprun.i ""gpcurval.p"" "(input so_prepaid,
                     input rndmthd,
                     output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if (retval <> 0) then do:
         next-prompt so_prepaid with frame d.
         undo, retry.
      end.
   end.

   if print_ih then do:
      if edi_ih then substring(so_inv_mthd,1,1) = "b".
      else substring(so_inv_mthd,1,1) = "p".
   end.
   else do:
      if edi_ih then substring(so_inv_mthd,1,1) = "e".
      else substring(so_inv_mthd,1,1) = "n".
   end.
   if edi_ack then substring(so_inv_mthd,3,1) = "e".
   else substring(so_inv_mthd,3,1) = "n".

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* SET PROJECT VERIFICATION TO NO */
   {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

   /* ACCT/SUB/CC/PROJ VALIDATION */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input  so_ar_acct,
        input  so_ar_sub,
        input  so_ar_cc,
        input  """",
        output valid_acct)"}

   if valid_acct = no then do:
      next-prompt so_ar_acct with frame d.
      undo, retry.
   end.

   /* ACCOUNT CURRENCY MUST EITHER BE TRANSACTION CURR OR BASE CURR */
   if so_curr <> base_curr then do:

      for first ac_mstr
            fields(ac_code ac_curr)
            where ac_code = so_ar_acct no-lock:
      end.  /* FOR FIRST AC_MSTR */
      if available ac_mstr and
         ac_curr <> so_curr and ac_curr <> base_curr then do:
         {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
         /*ACCT CURRENCY MUST MATCH TRANSACTION OR BASE CURR*/
         next-prompt so_ar_acct with frame d.
         undo, retry.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF SO_CURR <> BASE_CURR */

   /* Check for new revision and flip the print so flag. */
   if not new_order and old_rev <> so_rev then
      so_print_so = yes.

   undo_mtc2 = false.

end.
hide frame setd_sub no-pause.
