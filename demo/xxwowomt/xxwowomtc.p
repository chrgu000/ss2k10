/* wowomtc.p - WORK ORDER MAINTENANCE CREATE wo_mstr SUBROUTINE               */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 8.5      LAST EDIT: 03/03/95      MODIFIED BY: tjs *J027*        */
/* REVISION: 8.5      LAST EDIT: 03/13/95      MODIFIED BY: ktn *J034*        */
/* REVISION: 8.3      LAST EDIT: 03/27/95      MODIFIED BY: srk *G0JB*        */
/* REVISION: 8.5      LAST EDIT: 04/26/95      MODIFIED BY: sxb *J04D*        */
/* REVISION: 8.5      LAST EDIT: 09/12/95      MODIFIED BY: tjs *J07F*        */
/* REVISION: 8.5      LAST EDIT: 09/26/95      MODIFIED BY: srk *J081*        */
/* REVISION: 8.5      LAST EDIT: 06/07/96      MODIFIED BY: jxz *J0RF*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *J2WR* Santhosh Nair      */
/* REVISION: 9.1      LAST MODIFIED: 02/17/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 12/01/00   BY: *M0XD* Vandna Rohira      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13         BY: Niranjan R.        DATE: 07/23/01  ECO: *P00L*  */
/* Revision: 1.14         BY: Irine D'Mello      DATE: 09/10/01  ECO: *M164*  */
/* Revision: 1.16         BY: Jean Miller        DATE: 04/03/02  ECO: *P053*  */
/* Revision: 1.19         BY: Narathip W.        DATE: 04/19/03  ECO: *P0Q7*  */
/* Revision: 1.21         BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00N*  */
/* Revision: 1.22         BY: Bhagyashri Shinde  DATE: 08/25/04  ECO: *P2H1*  */
/* $Revision: 1.23 $         BY: Ruma Bibra         DATE: 05/22/06  ECO: *P4RT*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{cxcustom.i "WOWOMTC.P"}
/*110106.1*/ {xxpartbomfunc.i}
{pxphdef.i wocmnrtn}

define shared variable comp            like ps_comp.
define shared variable eff_date        as date.
define shared variable wo_recno        as recid.
define shared variable wo_recno1       as recid.
define shared variable qty             like wo_qty_ord.
define shared variable leadtime        like pt_mfg_lead.
define shared variable prev_status     like wo_status.
define shared variable prev_release    like wo_rel_date.
define shared variable prev_due        like wo_due_date.
define shared variable prev_qty        like wo_qty_ord.
define shared variable rel_date        like wo_rel_date.
define shared variable due_date        like wo_due_date.
define shared variable wonbr           like wo_nbr.
define shared variable wolot           like wo_lot.
define shared variable wopart          like wo_part.
define shared variable cmtindx         like wo_cmtindx.
define shared variable prev_site       like wo_site.
define shared variable prev_routing    like wo_routing.
define shared variable prev_bomcode    like wo_bom_code.
define shared variable deliv           like wod_deliver.
define shared variable any_issued      like mfc_logical.
define shared variable any_feedbk      like mfc_logical.
define shared variable del-yn          like mfc_logical initial no.
define shared variable new_wo          like mfc_logical initial no.
define shared variable add_2_joint     like mfc_logical.
define shared variable screen_used     like mfc_logical.
define shared variable undo_all        like mfc_logical no-undo.
define shared variable joint_type      like wo_joint_type.
define shared variable base_lot        like wo_lot.
define shared variable base_qty        like wo_qty_ord.
define shared variable base_um         like bom_batch_um.
define shared variable qty_type        like wo_qty_type.
define shared variable prod_pct        like wo_prod_pct.
define shared variable jpwo_recno      as recid.
define shared variable undoleavemain   as logical.

define variable i as integer.
define variable nonwdays as integer.
define variable workdays as integer.
define variable overlap as integer.
define variable know_date as date.
define variable find_date as date.
define variable interval as integer.
define variable frwrd as integer.
define variable yn like mfc_logical initial no.
define variable wocmmts like woc_wcmmts label "Comments".
define variable conv like ps_um_conv.
define variable ptstatus like pt_status.
define variable msg-counter as integer.
define variable valid_mnemonic like mfc_logical.
define variable joint_code  like wo_joint_type.
define variable joint_label like lngd_translation.
define variable base_recno as recid initial 0.
define variable yield_pct like wo_yield_pct no-undo.
define variable use_op_yield as logical     no-undo.
define variable l_errorno    as integer     no-undo.
{&WOWOMTC-P-TAG1}

define new shared buffer wo_mstr1 for wo_mstr.

define shared frame a.

form
   wo_nbr         colon 25
   wo_lot
   wo_part        colon 25
   pt_desc1       at 47 no-label
   wo_type        colon 25
   pt_desc2       at 47 no-label
   wo_site        colon 25
   joint_label    at 47 no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   joint_code     colon 20
   joint_label    at 25 no-label
   qty_type       colon 20
   prod_pct       colon 20
with frame b1 overlay side-labels centered.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).

find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock.

find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock.
end.

undo_all = yes.

ctrans:
do transaction with frame a:

   /* Adding new record */
   {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

   {&WOWOMTC-P-TAG2}
   new_wo = yes.
   create wo_mstr. wo_mstr.wo_domain = global_domain.
   assign
      wo_nbr  = wonbr
      wo_lot  = wolot
      wo_part = wopart
      wo_lot_rcpt = clc_wolot_rcpt
      jpwo_recno = recid(wo_mstr).

   if screen_used
   then do:
      display
         wo_nbr
         wo_lot
         "" @ pt_desc1
         "" @ pt_desc2
         "" @ joint_label.
   end.

   do on error undo, retry:

      if retry and batchrun
      then do:
         undoleavemain = yes.
         leave.
      end.

      if screen_used
      then do:

         set
            wo_part wo_type wo_site
         editing:

            if frame-field = "wo_part"
            then do:

               {mfnp.i pt_mstr wo_part  " pt_mstr.pt_domain = global_domain and
               pt_part "  wo_part
                  pt_part pt_part}
               if recno <> ? then
                  display pt_part @ wo_part pt_desc1 pt_desc2.
            end.
            else do:
               readkey.
               apply lastkey.
            end.
         end.

         assign
            wo_part
            wo_type = caps(input wo_type).
      end.

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wo_part no-lock no-error.

/*110106.1*/    if not(canAccessPart(wo_part)) then do:
/*110106.1*/        {pxmsg.i &msgnum = 90010}
/*110106.1*/        undo, retry.
/*110106.1*/    end.

      if available pt_mstr
      then
         pt_recno = recid(pt_mstr).

      do for wo_mstr1:

         find first wo_mstr1  where wo_mstr1.wo_domain = global_domain and
         wo_mstr1.wo_nbr  = wo_mstr.wo_nbr
                               and wo_mstr1.wo_joint_type <> ""
         no-lock no-error.

         if available wo_mstr1
         then do:

            find first ps_mstr  where ps_mstr.ps_domain = global_domain and
            ps_comp = wo_mstr.wo_part
                                 and ps_ps_code = "J"
            no-lock no-error.

            if available ps_mstr
               and wo_mstr1.wo_part <> wo_mstr.wo_part
            then do:
               /* Joint W.Orders may have only one base order */
               {pxmsg.i &MSGNUM=6542 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.  /*if available wo_mstr1 */

         /* Check if this item already a joint product on this WO */
         find first wo_mstr1
             where wo_mstr1.wo_domain = global_domain and  wo_mstr1.wo_nbr  =
             wo_mstr.wo_nbr
              and wo_mstr1.wo_part = wo_mstr.wo_part
              and wo_mstr1.wo_joint_type <> ""
         no-lock no-error.

         if available wo_mstr1
         then do:

            /* Remove  Adding new record  message */
            hide message no-pause.
            if wo_mstr1.wo_joint_type = "1"
            then do:
               /* Already defined as a co-product for base process */
               {pxmsg.i &MSGNUM=6508 &ERRORLEVEL=4}
            end.

            else do:
               /* Already defined as a by-product for base process */
               {pxmsg.i &MSGNUM=6507 &ERRORLEVEL=4}
            end.

            if screen_used then undo, retry.
            leave ctrans.

         end.

      end.

      if screen_used then do:

         if not available pt_mstr
         then do:
            /* Item number does not exist */
            {pxmsg.i &MSGNUM=17 &ERRORLEVEL=3}
            undo, retry.
         end.

         display pt_desc1 pt_desc2.
         pause 0.

         ptstatus = pt_status.
         substring(ptstatus,9,1) = "#".

         if can-find(isd_det  where isd_det.isd_domain = global_domain and
         isd_status = ptstatus
                               and isd_tr_type = "ADD-WO")
         then do:
            /* Restricted procedure for item status code */
            {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
            undo, retry.
         end.

         add_2_joint = no.
         joint_type = "".

         do for wo_mstr1:

            if wo_mstr.wo_nbr <> ""
               and wo_mstr.wo_lot <> ""
               and wo_mstr.wo_type = ""
            then do:

               /* See if there's a Base Process */
               find first wo_mstr1  where wo_mstr1.wo_domain = global_domain
               and  wo_mstr1.wo_nbr = input wo_mstr.wo_nbr
                                     and wo_mstr1.wo_joint_type = "5"
               no-lock no-error.

               if available wo_mstr1
               then do:

                  if wo_mstr1.wo_status = "F"
                  then do:
                     /*Joint Orders may not be added when status is F*/
                     {pxmsg.i &MSGNUM=6543 &ERRORLEVEL=3}
                     undo, retry.
                  end.

                  if wo_mstr1.wo_site <> wo_mstr.wo_site
                  then do:
                     /* Joint Order exists at site # */
                     {pxmsg.i &MSGNUM=6539 &ERRORLEVEL=3
                              &MSGARG1=wo_mstr.wo_site}
                     undo, retry.
                  end.

                  /* Lock all the joint WOs in the set. */
                  /* If any in group locked undo, give msg & leave */
                  /* Record is locked. Please try again later */
                  {gplock1.i &domain="wo_mstr.wo_domain = global_domain and "
                     &file-name="wo_mstr"
                     &group-criteria=
                     "wo_mstr.wo_nbr = wonbr and wo_mstr.wo_type = """""
                     &find-criteria="wo_mstr.wo_lot = wolot"
                     &undo-block=ctrans
                     &retry="leave"
                     &record-id=wo_recno}

                  /* Save base data */
                  assign
                     add_2_joint    = yes
                     base_lot       = wo_mstr1.wo_lot
                     prev_site      = wo_mstr1.wo_site
                     prev_routing   = wo_mstr1.wo_routing
                     prev_bomcode   = wo_mstr1.wo_bom_code
                     prev_status    = wo_mstr1.wo_status
                     base_qty       = wo_mstr1.wo_qty_ord
                     base_um        = ""
                     rel_date       = wo_mstr1.wo_rel_date
                     due_date       = wo_mstr1.wo_due_date
                     base_recno     = recid(wo_mstr1).

                  find bom_mstr  where bom_mstr.bom_domain = global_domain and
                  bom_parent = wo_mstr1.wo_bom_code
                  no-lock no-error.

                  if available bom_mstr then
                     base_um = bom_batch_um.

                  joint_code = "1". /* default to co-product */

                  /* Convert joint_code alpha joint_code & label */
                  {gplngn2a.i &file     = ""wo_mstr""
                     &field    = ""wo_joint_type""
                     &code     = joint_code
                     &mnemonic = joint_code
                     &label    = joint_label}

                  update
                     joint_code
                  with frame b1.

                  /* Validate alpha joint_code mnemonic */
                  {gplngv.i &file     = ""wo_mstr""
                     &field    = ""wo_joint_type""
                     &mnemonic = joint_code
                     &isvalid  = valid_mnemonic}

                  if not valid_mnemonic
                  then do:
                     /* Invalid joint type */
                     {pxmsg.i &MSGNUM=6501 &ERRORLEVEL=3}
                     next-prompt joint_code with frame b1.
                     undo, retry.
                  end.

                  /* Alpha joint_code returns num joint_type & label*/
                  {gplnga2n.i &file     = ""wo_mstr""
                     &field    = ""wo_joint_type""
                     &mnemonic = joint_code
                     &code     = joint_type
                     &label    = joint_label}

                  if joint_type = "5"
                  then do:
                     /* Joint W.Orders may have only one base order */
                     {pxmsg.i &MSGNUM=6542 &ERRORLEVEL=3}
                     next-prompt joint_code with frame b1.
                     undo, retry.
                  end.

                  display joint_label with frame b1.

                  conv = 0.
                  if available pt_mstr
                  then do:

                     if pt_um <> base_um
                     then do:
                        {gprun.i ""gpumcnv.p""
                           "(pt_um, base_um, wo_part, output conv)"}
                        if conv = ? then conv = 0.
                     end.
                     else
                        conv = 1.
                  end.

                  /* Qty Type P(ercent) B(atch) or blank */
                  if conv <> 0 then do:
                     qty_type = "B".
                     update qty_type with frame b1.
                  end.
                  else
                     qty_type = "".

                  if qty_type <> "" and index("BP",qty_type) = 0
                  then do:
                     /* Invalid type */
                     {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
                     next-prompt qty_type with frame b1.
                     undo, retry.
                  end.

                  /* Percent of Production */
                  prod_pct = 0.
                  if qty_type <> "" and conv <> 0
                  then
                     update prod_pct with frame b1.

                  clear frame b1 no-pause.
                  hide frame b1 no-pause.

                  display joint_label with frame a.

                  wonbr = wo_nbr.

               end. /* available wo_mstr1 */

            end. /* wo_nbr <> "" and wo_lot <> "" and wo_type = "" */

         end. /* do for wo_mstr1 */

         if new wo_mstr
            or new_wo
         then do :

            /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG.        */
            {pxrun.i &PROC    = 'get_default_wo_rctstat'
                     &PROGRAM = 'wocmnrtn.p'
                     &HANDLE  = ph_wocmnrtn
                     &PARAM   = "(input  wo_part,
                                  input  wo_site,
                                  output wo_rctstat,
                                  output wo_rctstat_active,
                                  output l_errorno)"}

         end. /* if new wo_mstr */

         if available wo_mstr
         then do:

            {gprun.i ""gpsiver.p""
               "(input wo_site, input ?, output return_int)"}

            if return_int = 0
            then do:

               display
                  wo_nbr
                  wo_lot
                  wo_part
                  wo_type
                  wo_site
               with frame a.

               /* User does not have access to this site */
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
               undo ctrans, retry ctrans.

            end.  /* IF return_int = 0 */

         end.  /* IF AVAILABLE wo_mstr THEN DO */

         assign
            leadtime      = pt_mfg_lead
            wo_yield_pct  = pt_yield_pct
            wo_routing    = (if wo_type = "R" then "" else pt_routing)
            wo_bom_code   = (if wo_type = "R" then "" else pt_bom_code)
            wo_joint_type = pt_joint_type.

         if wo_site = ""
         then
            wo_site       = pt_site.

         find ptp_det no-lock
             where ptp_det.ptp_domain = global_domain and  ptp_part = wo_part
              and ptp_site = wo_site no-error.

         if available ptp_det then
         assign
            wo_yield_pct  = ptp_yld_pct
            leadtime      = ptp_mfg_lead
            wo_routing    = (if wo_type = "R" then "" else ptp_routing)
            wo_joint_type = ptp_joint_type
            wo_bom_code   = (if wo_type = "R" then "" else ptp_bom_code).

         if add_2_joint
         then
            wo_joint_type = joint_type.

         if index("125",wo_joint_type) = 0
         then
            wo_joint_type = "".

         joint_type = wo_joint_type.
         if wo_joint_type = "5" and wo_type <> ""
         then do:
            /* Invalid type */
            {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
            next-prompt qty_type with frame b1.
            undo, retry.
         end.

         if wo_joint_type = "5" and wo_bom_code = ""
         then
            wo_bom_code = wo_part.

         /* Co-product's leadtime from Base */
         if wo_joint_type = "1"
         then do:

            find ptp_det no-lock
                where ptp_det.ptp_domain = global_domain and  ptp_part =
                wo_bom_code
                 and ptp_site = wo_site no-error.

            if available ptp_det
            then
               leadtime = ptp_mfg_lead.

            else do:
               find pt_mstr no-lock
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wo_bom_code
                  no-error.

               if available pt_mstr
               then
                  leadtime = pt_mfg_lead.
            end.
         end.
      end.
      else do: /* not screen_used */
         wo_type = "".
         wo_site = prev_site.
      end.

      /* Joint WOs can't be Expensed, Rework, etc. */
      if wo_type <> ""
      then
         assign
            wo_joint_type = ""
            joint_type = "".

      if wo_joint_type <> ""
      then do for wo_mstr1:

         find first wo_mstr1  where wo_mstr1.wo_domain = global_domain and
         wo_mstr1.wo_nbr = wo_mstr.wo_nbr
                               and wo_mstr1.wo_joint_type = ""
         no-lock no-error.

         if available wo_mstr1
         then do:
            /* Work order number in use by non-joint work order */
            {pxmsg.i &MSGNUM=6550 &ERRORLEVEL=3}
            undo, retry.
         end.
      end.

      /* WO added to set of existing joint WOs */
      if add_2_joint
      then do:

         if base_recno = 0
         then do for wo_mstr1:

            find first wo_mstr1
                where wo_mstr1.wo_domain = global_domain and  wo_mstr1.wo_nbr =
                wo_mstr.wo_nbr
                 and wo_mstr1.wo_joint_type = "5"
            no-lock no-error.

            base_recno = recid(wo_mstr1).
            base_lot = wo_mstr1.wo_lot.

         end.

         wo_recno  = base_recno.
         wo_recno1 = recid(wo_mstr).

         /* Copy fields from base wo to joint product wo */
         {gprun.i ""wowomtf1.p""}

         assign
            wo_base_id    = base_lot
            wo_joint_type = joint_type
            wo_prod_pct   = prod_pct
            wo_qty_type   = qty_type
            wo_ord_date   = today.

         if available pt_mstr
         then do:

            find pl_mstr  where pl_mstr.pl_domain = global_domain and
            pl_prod_line = pt_prod_line
            no-lock no-error.

            if available pl_mstr
            then do:
               {gprun.i ""glactdft.p"" "(input ""WO_XVAR_ACCT"",
                                         input pt_prod_line,
                                         input wo_site,
                                         input """",
                                         input """",
                                         input no,
                                         output wo_xvar_acct,
                                         output wo_xvar_sub,
                                         output wo_xvar_cc)"}

            end.
         end.
      end.

      else do:

         assign
            wo_status   = "F"
            wo_ord_date = today
            wo_rel_date = today
            wo_due_date = ?.

         {mfdate.i wo_rel_date wo_due_date leadtime wo_site}

      end.

      /* If this is a base process or co/by product */
      /* default yield to 100 % always... */
      if wo_joint_type <> ""
      then
         wo_yield_pct = 100.

      /* Determine if operation yield is needed, and if so override    */
      /* wo_yield_pct.                                                 */
      else do:
         run check-component-yield
            (output use_op_yield,
             output yield_pct).

         if use_op_yield
         then
            wo_yield_pct = yield_pct.
      end.

      if wo_type <> "" and (index("RE",wo_type) = 0)
      then do:
         /* Invalid Type Code */
         {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
         next-prompt wo_type.
         undo, retry.
      end.

      if wo_joint_type <> ""
      then do:

         /* Numeric wo_joint_type returns alpha code, label */
         {gplngn2a.i &file     = ""wo_mstr""
            &field    = ""wo_joint_type""
            &code     = wo_joint_type
            &mnemonic = joint_code
            &label    = joint_label}

         /* Calculate Order Qty */
         if prod_pct <> 0
         then do:
            if base_qty <> 0 and conv <> 0 and
               (qty_type = "P" or qty_type = "B") then
               wo_qty_ord = base_qty * (prod_pct / 100) * conv.
         end.
      end. /* wo_joint_type <> "" */

      else do:
         joint_code = "".
         joint_label = "".
      end.

   end. /* do on error undo, retry: */

   if screen_used
   then
      display
         joint_label.

   wo_var = woc_var.
   wo_recno = recid(wo_mstr).
   undo_all = no.

end.

PROCEDURE check-component-yield:

   define output parameter op_use_op_yield          as logical no-undo.
   define output parameter op_yield_pct             as decimal no-undo.

   define variable routing as character no-undo.
   define variable op      like wod_op  no-undo.

   if available ptp_det then
      op_use_op_yield = ptp_det.ptp_op_yield.
   else
      op_use_op_yield  = pt_mstr.pt_op_yield.

   if op_use_op_yield = yes then do:

      for first mrpc_ctrl
      fields( mrpc_domain mrpc_op_yield)
       where mrpc_ctrl.mrpc_domain = global_domain no-lock: end.

      if available mrpc_ctrl and mrpc_op_yield = yes
      then do:

         /* Determine if Routing code or part should be used...   */
         if wo_mstr.wo_routing <> "" then
            routing = wo_routing.
         else
            routing = wo_part.

         /* pass 9's as operation so all operations are used.. */
         op = 999999999.

         /* calculate yield percentage... */
         {gprun.i ""gpcmpyld.p""
            "(input routing,
              input wo_rel_date,
              input op,
              output op_yield_pct)"}

      end. /* if available mrpc_ctrl... */

      else
         op_use_op_yield = no.

   end. /* if use_op_yield... */

END PROCEDURE.
