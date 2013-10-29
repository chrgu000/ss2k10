/* sosomtc2.p - SO TRAILER UPDATE LOWER FRAME AND CANADIAN TAX          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*N014*/ /*V8:RunMode=Character,Windows                                 */
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

/*J053* INDENTED ENTIRE PROGRAM TO BRING UP TO STANDARD       */
         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define shared variable prepaid_fmt as character no-undo.
         define shared variable  so_recno    as   recid.
         define shared variable  undo_mtc2   like mfc_logical.
         define shared variable  new_order   like mfc_logical.
         define shared frame     d.
         define        variable  valid_acct  like mfc_logical.
         define        variable  old_rev     like so_rev.
/*J053*/ define variable retval as integer no-undo.


/*J053** SHOULD NOT BE DEFINED AS NEW ***************************************
* /*H009*/ {mfsotrla.i "NEW"} /*Define common variable for sales order trailer*/
**J053***********************************************************************/
/*J053*/ {mfsotrla.i}
         {sosomt01.i}  /* Define shared form for frame d */
/*J053*/ so_prepaid:format = prepaid_fmt.

/*L15F** find so_mstr where recid(so_mstr) = so_recno. */
/*L15F*/ for first so_mstr
/*L15F*/    fields(so_ar_acct so_ar_cc so_bol so_cr_card so_cr_init
/*L15F*/           so_curr so_disc_pct so_inv_mthd
/*L15F*/           so_fob so_fst_id so_partial
/*L15F*/           so_prepaid so_print_pl so_to_inv
/*L15F*/           so_print_so so_pst_id so_pst_pct so_rev so_shipvia
/*L15F*/           so_stat so_tax_pct so_tr1_amt so_trl3_cd
/*L15F*/           so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt)
/*L15F*/    where recid(so_mstr) = so_recno no-lock:
/*L15F*/ end. /* FOR FIRST so_mstr */

/*N0CG**         find first gl_ctrl no-lock. */
/*N0CG*/         for first gl_ctrl
/*N0CG*/            fields(gl_can) no-lock:
/*N0CG*/         end. /* FOR FIRST GL_CTRL   */

                 old_rev = so_rev.

         do transaction on error undo, retry:
    
/*L15F*/    find first so_mstr
/*L15F*/       where recid(so_mstr) = so_recno exclusive-lock no-error.

/*J1P5*/    hide frame setd_sub no-pause.
            /*GB74 ADDED FOLLOWING 2 LINES*/
/*GN67*
 * print_ih = (so_inv_mthd = "b" or so_inv_mthd = "p" or so_inv_mthd = "").
 * edi_ih = (so_inv_mthd = "b" or so_inv_mthd = "e").
 *GN67*/


/*GN67*/     print_ih =
/*GN67*/      ( substr(so_inv_mthd,1,1) = "b" or
/*GN67*/        substr(so_inv_mthd,1,1) = "p" or substr(so_inv_mthd,1,1) = "").
/*GN67*/     edi_ih = (substr(so_inv_mthd,1,1) = "b" or
/*GN67*/              substr(so_inv_mthd,1,1) = "e").
/*G0CW*/     edi_ack = substr(so_inv_mthd,3,1) = "e".
/*131023.1*/ find first code_mstr no-lock where code_fldname = "WHEN_SO_HOLD_DISABL_SHIP" no-error.
/*131023.1*/ if available code_mstr and substring(code_value,1,1) = "Y" then do:
/*131023.1*/    assign so_stat = "HD" when so_stat = "".
/*131023.1*/    display so_stat with frame d.
/*131023.1*/ end.
            /*GB74 REVISED FOLLOWING STATEMENT*/
/*FT44*  update */
/*FT44*/    set
              so_cr_init
              so_cr_card
              so_stat when (so_stat =  "")
              so_rev

              edi_ack       /*G0CW*/

              so_print_so
              so_print_pl
              print_ih
              edi_ih
              so_partial

              so_ar_acct
/*N014*/      so_ar_sub
              so_ar_cc
              so_prepaid
              so_fob
              so_shipvia
              so_bol
            with frame d.

/*J053*/    if (so_prepaid <> 0 ) then do:
/*J053*/       /* VALIDATE SO_PREPAID ACCORDING TO THE DOC CURRENCY ROUND MTHD*/
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_prepaid,
                     input rndmthd,
                     output retval)"}
/*J053*/       if (retval <> 0) then do:
/*J053*/          next-prompt so_prepaid with frame d.
/*J053*/          undo, retry.
/*J053*/       end.
/*J053*/    end.

/*GN67*
 * /*GB74 ADDED FOLLOWING SECTION*/
 * if print_ih then do:
 *    if edi_ih then so_inv_mthd = "b".
 *    else so_inv_mthd = "p".
 * end.
 * else do:
 *    if edi_ih then so_inv_mthd = "e".
 *    else so_inv_mthd = "n".
 * end.
 * /*GB74 END SECTION*/
 *GN67*/

/*GN67*/    if print_ih then do:
/*GN67*/       if edi_ih then substr(so_inv_mthd,1,1) = "b".
/*GN67*/       else substr(so_inv_mthd,1,1) = "p".
/*GN67*/    end.
/*GN67*/    else do:
/*GN67*/       if edi_ih then substr(so_inv_mthd,1,1) = "e".
/*GN67*/       else substr(so_inv_mthd,1,1) = "n".
/*GN67*/    end.
/*G0CW*/    if edi_ack then substr(so_inv_mthd,3,1) = "e".
/*G0CW*/    else substr(so_inv_mthd,3,1) = "n".

/*N014* /*G013*/    {gpglver1.i &acc = so_ar_acct                       */
/*N014*               &sub = ?                                           */
/*N014*              &cc  = so_ar_cc                                    */
/*N014*              &frame = d}                                        */

            /* INITIALIZE SETTINGS */
/*N014*/    {gprunp.i "gpglvpl" "p" "initialize"}

/*N07M*/    /* SET PROJECT VERIFICATION TO NO */
/*N07M*/    {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

            /* ACCT/SUB/CC/PROJ VALIDATION */
/*N014*/    {gprunp.i "gpglvpl" "p" "validate_fullcode"
                "(input  so_ar_acct,
                  input  so_ar_sub,
                  input  so_ar_cc,
                  input  """",
                  output valid_acct)"}

/*N014*     THE FOLLOWING CODE WAS PREVIOUSLY HANDLED WITHIN gpglver1.i;
 *          NOW IT NEEDS TO BE INCORPORATED BACK INTO THE
 *          PROGRAM WHICH CALLS gpglver1.i                              */
/*N014*/    if valid_acct = no then do:
/*N014*/        next-prompt so_ar_acct with frame d.
/*N014*/        undo, retry.
/*N014*/    end.


   /* ACCOUNT CURRENCY MUST EITHER BE TRANSACTION CURR OR BASE CURR */
            if so_curr <> base_curr then do:
/*N0CG**       find ac_mstr where ac_code = so_ar_acct no-lock no-error. */
/*N0CG*/       for first ac_mstr
/*N0CG*/          fields(ac_code ac_curr)
/*N0CG*/          where ac_code = so_ar_acct no-lock:
/*N0CG*/       end.  /* FOR FIRST AC_MSTR */
               if available ac_mstr and
                  ac_curr <> so_curr and ac_curr <> base_curr then do:
              {mfmsg.i 134 3}
              /*ACCT CURRENCY MUST MATCH TRANSACTION OR BASE CURR*/
              next-prompt so_ar_acct with frame d.
              undo, retry.
               end.
            end. /* IF SO_CURR <> BASE_CURR */

/*H208*/    {txcanid.i &frame="d" &fst_id=so_fst_id &pst_id=so_pst_id}

/*H208** MOVED TO txcanid.i **   /* Set Tax id numbers */
 * if gl_can then
 * setd_sub:
 *    do on error undo, retry:
 *       form
 *         so_fst_id colon 12 label "GST ID"
 *         so_pst_id colon 12
 *       with frame setd_sub attr-space overlay side-labels
 *       centered row frame-row(d) + 2.
 *
 *       update so_fst_id so_pst_id with frame setd_sub.
 *
 *       if not gst_taxed and so_fst_id = "" then do:
 *          {mfmsg.i 8001 3}
 *          next-prompt so_fst_id with frame setd_sub.
 *          undo setd_sub, retry.
 *       end.
 *       if not pst_taxed and so_pst_id = "" then do:
 *          {mfmsg.i 8002 3}
 *          next-prompt so_pst_id with frame setd_sub.
 *          undo setd_sub, retry.
 *       end.
 * end.  /*setd_sub*/  ** END MOVED **/

            /* Check for new revision and flip the print so flag. */
            if not new_order and old_rev <> so_rev then do:
              so_print_so = yes.
            end.

            undo_mtc2 = false.

         end.
/*J1P5*/ hide frame setd_sub no-pause.
