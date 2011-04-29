/* poporcc1.p - PO RECEIPT CREATE glt_det IN DISTRIBUTED DB             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.20 $                                                         */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*          */
/* REVISION: 7.0     LAST MODIFIED: 02/04/92    BY: RAM *F163*          */
/* REVISION: 7.0     LAST MODIFIED: 07/09/92    BY: pma *F748*          */
/* REVISION: 7.3     LAST MODIFIED: 09/18/92    BY: pma *G073*          */
/*           7.3                    10/29/94    BY: bcm *GN73*          */
/*           7.3                    11/10/94    BY: bcm *GO37*          */
/* REVISION: 9.0     LAST MODIFIED: 03/25/99    BY: *J37F* Poonam Bahl      */
/*           9.0                    03/26/99    BY: *M0BG* Jeff Wootton     */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kapoor     */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* Patti Gaultney   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* REVISION: 9.1     LAST MODIFIED: 09/28/00    BY: *N0W9* Mudit Mehta      */
/* Revision: 1.18  BY: Niranjan R.  DATE: 07/12/01 ECO: *P00L*   */
/* Revision: 1.19     BY: Paul Donnelly    DATE: 12/13/01 ECO: *N16J*       */
/* $Revision: 1.20 $       BY: John Corda       DATE: 08/08/02 ECO: *N1QP*       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                            */

/*****************************************************************************/
/*      SUB-ACCOUNT FIELD ADDED; WILL BE USED IN CONJUNCTION WITH ACCT AND   */
/*      COST CENTER. SUB-ACCOUNT IS NO LONGER CONCATENATED TO ACCT AND IS A  */
/*      SEPARATE 8 CHARACTER FIELD.                                          */
/*****************************************************************************/

{mfdeclre.i}
{cxcustom.i "POPORCC1.P"}

/* INTER-COMPANY ACCOUNT PROCEDURES */
{pxpgmmgr.i}

define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define     shared variable cr_acct     like trgl_cr_acct extent 6.
define     shared variable cr_sub      like trgl_cr_sub extent 6.
define     shared variable cr_cc       like trgl_cr_cc extent 6.
define     shared variable cr_proj     like trgl_cr_proj extent 6.
define     shared variable dr_acct     like trgl_dr_acct extent 6.
define     shared variable dr_sub      like trgl_dr_sub extent 6.
define     shared variable dr_cc       like trgl_dr_cc extent 6.
define     shared variable dr_proj     like trgl_dr_proj extent 6.
define     shared variable eff_date    like glt_effdate.
define     shared variable entity      like si_entity extent 6.
define     shared variable gl_amt      like trgl_gl_amt extent 6.
define     shared variable podnbr      like pod_nbr.
define     shared variable podpart     like pod_part.
define     shared variable podtype     like pod_type.
define     shared variable ref         like glt_ref.
define     shared variable same-ref    like mfc_logical.
define     shared variable transtype   as character.
define shared variable exch_rate   like exr_rate.
define shared variable exch_rate2  like exr_rate.

define variable l_curr           like glt_curr  no-undo.
define variable l_mc_errno       like msg_nbr   no-undo.
define variable l_cmb_exch_rate  like exr_rate  no-undo.
define variable l_cmb_exch_rate2 like exr_rate2 no-undo.
define variable dftRCPTAcct       like pl_rcpt_acct  no-undo.
define variable dftRCPTSubAcct    like pl_rcpt_sub   no-undo.
define variable dftRCPTCostCenter like pl_rcpt_cc    no-undo.

{gldydef.i new} /* DEFINE NEW INSTANCE OF DAYBOOKS VARIABLES */
{gldynrm.i new} /* DEFINE NEW INSTANCE OF NRM FOR THIS DATABASE */

for first gl_ctrl
      fields(gl_base_curr gl_rcptx_acct
      gl_rcptx_sub
      gl_rcptx_cc) no-lock:
end. /* FOR FIRST GL_CTRL */

for first icc_ctrl
      fields( icc_gl_tran
      icc_mirror ) no-lock:
end. /* FOR FIRST ICC_CTRL */

for first pt_mstr
      fields(pt_part pt_prod_line)
      where pt_part = podpart no-lock:
end. /* FOR FIRST PT_MSTR */

if available pt_mstr then

for first pl_mstr
      fields(pl_prod_line pl_rcpt_acct
      pl_rcpt_sub
      pl_rcpt_cc)
      where pl_prod_line = pt_prod_line no-lock:
end. /* FOR FIRST PL_MSTR */

/* THE PROGRAM GPICGL.P CREATES GL TRANSACTION IN THE BASE CURRENCY  */
/* OF THE RECEIVING DB (BASE_CURR). TO CREATE GL TRANSACTION IN BASE */
/* CURRENCY OF PO HEADER DB (GL_BASE_CURR) : SET BASE_CURR TO        */
/* GL_BASE_CURR AND CONVERT GL_AMT[6] IN TERMS OF GL_BASE_CURR       */

{&POPORCC1-P-TAG1}
for first po_mstr
   fields (po_site po_vend po_ex_rate po_ex_rate2 po_nbr po_curr)
   {&POPORCC1-P-TAG2}
   where po_nbr = podnbr
no-lock:
end.
for first vd_mstr
      fields(vd_addr vd_type)
      where vd_addr = po_vend no-lock:
end.
{gprun.i ""glactdft.p"" "(input ""PO_RCPT_ACCT"",
                          input pt_mstr.pt_prod_line,
                          input po_site,
                          input if available vd_mstr then
                                vd_type else """",
                          input """",
                          input no,
                          output dftRCPTAcct,
                          output dftRCPTSubAcct,
                          output dftRCPTCostCenter)"}
{&POPORCC1-P-TAG3}
l_curr = base_curr .
if available gl_ctrl and
   gl_base_curr <> base_curr then do:

   {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
      "(input  po_ex_rate,
        input  po_ex_rate2,
        input  exch_rate2,
        input  exch_rate,
        output l_cmb_exch_rate,
        output l_cmb_exch_rate2)" }

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input  base_curr,
        input  gl_base_curr,
        input  l_cmb_exch_rate,
        input  l_cmb_exch_rate2,
        input  gl_amt[6],
        input  false,
        output gl_amt[6],
        output l_mc_errno)" }

   if l_mc_errno <> 0 then do:
      {pxmsg.i &MSGNUM=l_mc_errno &ERRORLEVEL=2}
   end. /* IF L_MC_ERRNO <> 0 */

   assign
      l_curr    = base_curr
      base_curr = gl_base_curr.
end.  /* IF AVAILABLE GL_CTRL AND ... */


/* GET ICO DEBIT ACCOUNT READY FOR GL TRANSACTION */
{glenacex.i &entity=entity[2]
            &type='"DR"'
            &module='"IC"'
            &acct=ico_acct
            &sub=ico_sub
            &cc=ico_cc }

if available pl_mstr and (podtype = "" or podtype = "S")
then do:

   /* REPLACED pl_rcpt_acct, pl_rcpt_sub AND pl_rcpt_cc WITH        */
   /* dftRCPTAcct, dftRCPTSubAcct AND dftRCPTCostCenter             */
   {&POPORCC1-P-TAG4}

   {mficgl02.i
      &gl-amount=gl_amt[6]
      &tran-type=transtype
      &order-no=podnbr
      &dr-acct=ico_acct
      &dr-sub=ico_sub
      &dr-cc=ico_cc
      &drproj=dr_proj[6]
      &cr-acct=dftRCPTAcct
      &cr-sub=dftRCPTSubAcct
      &cr-cc=dftRCPTCostCenter
      &crproj=cr_proj[6]
      &entity=entity[6]
      &find="false"
      &same-ref="same-ref"
      }
{&POPORCC1-P-TAG5}

end.
else do:
{&POPORCC1-P-TAG6}

   {mficgl02.i
      &gl-amount=gl_amt[6]
      &tran-type=transtype
      &order-no=podnbr
      &dr-acct=ico_acct
      &dr-sub=ico_sub
      &dr-cc=ico_cc
      &drproj=dr_proj[6]
      &cr-acct=gl_rcptx_acct
      &cr-sub=gl_rcptx_sub
      &cr-cc=gl_rcptx_cc
      &crproj=cr_proj[6]
      &entity=entity[6]
      &find="false"
      &same-ref="same-ref"
      }
{&POPORCC1-P-TAG7}

end.


/* RESET BASE_CURR TO BASE CURRENCY OF RECEIVING DB */
if available gl_ctrl and
   gl_base_curr <> l_curr then
   base_curr = l_curr .
