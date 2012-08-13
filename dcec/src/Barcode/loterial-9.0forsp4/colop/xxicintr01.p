/*xxicintr01.p - COMMON PROGRAM FOR MISC INVENTORY TRANSACTIONS                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.28 $                                                          */
/* Type of transaction: "RCT-WO"  (receipts backward exploded)                */
/* $Revision: 1.29.3.6 $                                                       */
/* REVISION: 6.0     LAST MODIFIED: 04/03/90    BY: wug *D015*                */
/* REVISION: 6.0     LAST MODIFIED: 04/09/90    BY: wug *D002*                */
/* REVISION: 6.0     LAST MODIFIED: 06/21/90    BY: emb *D033*                */
/* REVISION: 6.0     LAST MODIFIED: 09/20/90    BY: emb *####*                */
/* REVISION: 6.0     LAST MODIFIED: 12/17/90    BY: wug *D227*                */
/* REVISION: 6.0     LAST MODIFIED: 01/15/91    BY: emb *D299*                */
/* REVISION: 6.0     LAST MODIFIED: 03/19/91    BY: wug *D472*                */
/* REVISION: 6.0     LAST MODIFIED: 06/11/91    BY: emb *D690*                */
/* REVISION: 6.0     LAST MODIFIED: 08/01/91    BY: emb *D800*                */
/* REVISION: 6.0     LAST MODIFIED: 09/19/91    BY: pma *D866*                */
/* REVISION: 6.0     LAST MODIFIED: 09/20/91    BY: wug *D858*                */
/* REVISION: 7.0     LAST MODIFIED: 10/01/91    BY: pma *F003*                */
/* REVISION: 6.0     LAST MODIFIED: 10/16/91    BY: wug *D899*                */
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: wug *D920*                */
/* REVISION: 6.0     LAST MODIFIED: 11/11/91    BY: wug *D887*                */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*                */
/* REVISION: 7.0     LAST MODIFIED: 05/22/92    BY: pma *F522*                */
/* REVISION: 7.0     LAST MODIFIED: 05/22/92    BY: pma *F524*                */
/* REVISION: 7.0     LAST MODIFIED: 06/12/92    BY: emb *F604*                */
/* REVISION: 7.0     LAST MODIFIED: 06/18/92    BY: jjs *F672*(rev only)      */
/* REVISION: 7.0     LAST MODIFIED: 06/24/92    BY: jjs *F681*                */
/* REVISION: 7.3     LAST MODIFIED: 07/28/92    BY: mpp *G011*                */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G247*                */
/* REVISION: 7.3     LAST MODIFIED: 11/18/92    BY: emb *G335*                */
/* REVISION: 7.3     LAST MODIFIED: 11/30/92    BY: pma *G366*                */
/* REVISION: 7.3     LAST MODIFIED: 12/29/92    BY: pma *G382*                */
/* REVISION: 7.3     LAST MODIFIED: 01/07/93    BY: pma *G520*(rev only)      */
/* REVISION: 7.3     LAST MODIFIED: 03/31/93    BY: ram *G886*                */
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039*                */
/* REVISION: 7.2     LAST MODIFIED: 07/18/94    BY: ais *FO73*                */
/* REVISION: 7.4     LAST MODIFIED: 07/27/94    BY: pmf *FP59*                */
/* REVISION: 7.2     LAST MODIFIED: 09/09/94    BY: ais *FQ90*                */
/* REVISION: 7.2     LAST MODIFIED: 09/21/94    BY: ljm *GM77*                */
/* REVISION: 7.4     LAST MODIFIED: 10/31/94    BY: ame *GN79*                */
/* REVISION: 8.5     LAST MODIFIED: 10/31/94    BY: mwd *J034*                */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    BY: taf *J038*                */
/* REVISION: 8.5     LAST MODIFIED: 12/21/94    BY: ktn *J041*                */
/* REVISION: 8.5     LAST MODIFIED: 03/14/95    BY: dzs *J047*                */
/* REVISION: 8.5     LAST MODIFIED: 05/17/95    BY: sxb *J04D*                */
/* REVISION: 8.5     LAST MODIFIED: 06/16/95    BY: rmh *J04R*                */
/* REVISION: 8.5     LAST MODIFIED: 10/06/95    BY: tjs *J08C*                */
/* REVISION: 7.2     LAST MODIFIED: 03/29/95    BY: qzl *F0PK*                */
/* REVISION: 7.3     LAST MODIFIED: 11/01/95    BY: ais *G0V9*                */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*                */
/* REVISION: 7.3     LAST MODIFIED: 11/22/95    BY: bcm *G1D7*                */
/* REVISION: 8.5     LAST MODIFIED: 01/04/96    BY: kxn *J09L*                */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: jym *G1MN*                */
/* REVISION: 8.5     LAST MODIFIED: 06/28/96    BY: taf *J0WS*                */
/* REVISION: 8.5     LAST MODIFIED: 03/19/97    BY: *H0V1* Julie Milligan     */
/* REVISION: 7.4     LAST MODIFIED: 12/22/97    BY: *H1HN* Jean Miller        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 04/15/98    BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* Paul Johnson       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 07/31/00    BY: *L123* Mark Christian     */
/* REVISION: 9.1     LAST MODIFIED: 09/05/00    BY: *N0RF* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 08/11/00    BY: *N0K2* Phil DeRogatis     */
/* REVISION: 9.1     LAST MODIFIED: 01/10/01    BY: *M0ZQ* Vandna Rohira      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *F073*                    */
/* Revision: 1.21    BY: Niranjan R.        DATE: 07/12/01  ECO: *P00L*       */
/* Revision: 1.22    BY: Jean Miller        DATE: 04/06/02  ECO: *P056*       */
/* Revision: 1.25    BY: Jeff Wootton       DATE: 05/14/02  ECO: *P03G*       */
/* Revision: 1.26    BY: Jeff Wootton       DATE: 06/04/02  ECO: *P07K*       */
/* $Revision: 1.28 $ BY: Ashish Maheshwari  DATE: 07/17/02  ECO: *N1GJ*     */
/* Revision: 1.28      BY: Ashish Maheshwari  DATE: 07/17/02  ECO: *N1GJ*     */
/* Revision: 1.29      BY: Deepak Rao         DATE: 12/27/02  ECO: *N22Y*     */
/* Revision: 1.29.3.2  BY: Anitha Gopal       DATE: 09/29/03  ECO: *P14L*     */
/* Revision: 1.29.3.3  BY: Inna Fox           DATE: 05/19/04  ECO: *P22P*     */
/* $Revision: 1.29.3.6 $  BY: Shivanand H        DATE: 08/30/04  ECO: *P2HL*     */
/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* THIS PROGRAM WAS CLONED TO kbintr01.p 05/14/02, REMOVING UI.               */
/* CHANGES TO THIS PROGRAM MAY ALSO NEED TO BE APPLIED TO kbintr01.p          */
/******************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* DISPLAY TITLE */
{mfdtitle.i "99 "}
define new shared variable comp like ps_comp.
define new shared variable yn like mfc_logical.
define new shared variable part like tr_part.
define new shared variable um like pt_um no-undo.
define new shared variable conv like um_conv label "Conversion" no-undo.
define new shared variable ref like glt_ref.
define new shared variable eff_date like glt_effdate label "Effective".
define new shared variable trlot like tr_lot.
define new shared variable qty_loc like tr_qty_loc.
define new shared variable qty_loc_label as character format "x(12)".
define new shared variable issrct as character format "x(3)".
define new shared variable issuereceipt as character format "x(7)".
define new shared variable total_amt like tr_gl_amt label "Total Cost".
define new shared variable nbr like tr_nbr.
define new shared variable so_job like tr_so_job.
define new shared variable addr like tr_addr.
define new shared variable rmks like tr_rmks.
define new shared variable serial like tr_serial.
define new shared variable dr_acct like trgl_dr_acct.
define new shared variable dr_sub like trgl_dr_sub.
define new shared variable dr_cc like trgl_dr_cc.
define new shared variable cr_acct like trgl_cr_acct.
define new shared variable cr_sub like trgl_cr_sub.
define new shared variable cr_cc like trgl_cr_cc.
define new shared variable trqty like tr_qty_loc.
define new shared variable i as integer.
define new shared variable tot_units as character format "x(16)".
define new shared variable del-yn like mfc_logical initial no.
define new shared variable null_ch as character initial "".
define new shared variable reject_qty_label as character format "x(11)".
define new shared variable qty_reject like tr_qty_loc.
define new shared variable qty_iss_rcv like qty_loc.
define new shared variable pt_recid as recid.
define new shared variable accum_wip like tr_gl_amt.
define new shared variable multi_entry like mfc_logical
   label "Multi Entry" no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline as character.
define new shared variable issue_or_receipt as character.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable total_lotserial_qty like sr_qty label "Total Qty".
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable dr_proj like wo_proj.
define new shared variable cr_proj like wo_proj.
define new shared variable back_assy like pt_part label "Backflush Assy".
define new shared variable back_qty  like sr_qty.
define new shared variable back_um   like pt_um.
define new shared variable back_conv like um_conv.
define new shared variable back_site like sr_site.
define new shared variable back_loc  like sr_loc.
define new shared variable wip_site like si_site label "WIP Site".
/* WIP_LOC NOT USED HERE, DEFINE NEEDED FOR KBINTR01.P */
define new shared variable wip_loc like sr_loc no-undo.
define new shared variable wip_entity like si_entity.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable assy_qty like ps_qty_per.
define new shared variable pick_logic like mfc_logical initial true.
define new shared variable anyrejected like mfc_logical.
define new shared variable filter_loc like ld_loc.
define new shared variable filter_status like is_status.
define new shared variable filter_expire like ld_expire.
define new shared variable err_part like pk_part.
define new shared variable continue-yn like mfc_logical.
/* KANBAN DEFINED IN KBINTR01.P HAS INITIAL YES */
define new shared variable kanban as logical no-undo initial no.
define new shared variable kbtransnbr as integer no-undo.
define shared variable transtype as character format "x(7)".
define variable lotum as character.
define variable stock_um like pt_um.
define variable dr_desc like ac_desc.
define variable cr_desc like ac_desc.
define variable project like wo_proj.
define variable back_mod like mfc_logical label "Modify Backflush".
define variable wo_entity like en_entity.
define variable to_entity like en_entity.
define variable gl_amt like glt_amt.
define variable valid_acct like mfc_logical.
define variable rejected like mfc_logical.
define variable qty_to_all like pk_qty.
define variable jp like mfc_logical.
define variable jprod like mfc_logical.
define variable base like mfc_logical.
define variable regular like mfc_logical.
define variable lotnext like wo_lot_next .
define variable lotprcpt like wo_lot_rcpt no-undo.
define variable l_trans_ok as logical no-undo.
define buffer ptmstr for pt_mstr.
define buffer ptmstr2 for pt_mstr.
define new shared workfile pkdet
   field pkdet_user like pk_user
   field pkdet_part like pk_part
   field pkdet_qty  like pk_qty
   field pkdet_loc  like pk_loc
   field pkdet_not_alloc like pk_qty
   field pkdet_allocate  like mfc_logical.
/*DEFINE VARIABLES FOR BILL OF MATERIAL EXPLOSION*/
{gpxpld01.i "new shared"}
/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "new shared"}

{gpglefv.i}
form
   pt_part        colon 17
   pt_lot_ser     colon 57 pt_um
   pt_desc1       colon 17
   pt_desc2 no-label at 19 skip
   wip_site       colon 17
   site           colon 57
   lotserial_qty  colon 17
   total_lotserial_qty no-label at 33
   location       colon 57
   um             colon 17 stock_um no-label at 33
   lotserial      colon 57
   conv           colon 17
   lotref         colon 57 format "x(8)"
   multi_entry    colon 57
   nbr            colon 17
   so_job         colon 17
   addr           colon 17
   rmks           colon 17
   eff_date       colon 17
   cr_acct        colon 17
   space (1)
   cr_sub                  no-label
   space (1)
   cr_cc                   no-label
   space (1)
   project                 no-label
   space (1)
   cr_desc                 no-label
   skip(1)
   back_mod       colon 17
with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
issrct = substring(transtype,1,3).
if issrct = "RCT" then
   issue_or_receipt = getTermLabel("RECEIPT",8).
else
   issue_or_receipt = getTermLabel("ISSUE",8).
lotnext = "".
lotprcpt = no.
mainloop:
repeat:
   accum_wip = 0.
   do transaction:
      for each sr_wkfl exclusive-lock where sr_userid = mfguser:
         delete sr_wkfl.
      end.
      {gprun.i ""gplotwdl.p""}
   end.
   prompt-for pt_part with frame a no-validate
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
      if recno <> ? then
      display pt_part pt_desc1 pt_um
         pt_lot_ser pt_desc2
      with frame a.
   end.
   status input.
   find pt_mstr using pt_part no-lock no-error.
   if not available pt_mstr then do:
      {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /*ITEM NUMBER IS NOT AVAILABLE */
      undo, retry.
   end.
   /* MAY NOT BACKFLUSH A BASE PROCESS */
   if pt_joint_type = "5" then do:
      {pxmsg.i &MSGNUM=6555 &ERRORLEVEL=3}
      undo, retry.
   end.
   if pt_joint_type = "1"
   then do:
      find ptmstr2 where
         ptmstr2.pt_part = pt_mstr.pt_bom_code and
         ptmstr2.pt_joint_type = "5"
      no-lock no-error.
      if available ptmstr2 then do:
         {pxmsg.i &MSGNUM=6555 &ERRORLEVEL=3}
         /* MAY NOT BACKFLUSH A BASE PROCESS */
         undo, retry.
      end.
   end.
   pt_recid = recid(pt_mstr).
   um = pt_mstr.pt_um.
   conv = 1.
   if eff_date = ? then
      eff_date = today.
   find pl_mstr where pl_prod_line = pt_mstr.pt_prod_line no-lock.
   do transaction:
      /* GET NEXT LOT */
      {mfnxtsq.i wo_mstr wo_lot woc_sq01 trlot}
   end.
   /* SET GLOBAL PART VARIABLE */
   assign
      global_part = pt_mstr.pt_part
      part = pt_mstr.pt_part
      um = pt_mstr.pt_um
      conv = 1
      back_mod = no
      jprod = no
      base = no
      regular = yes.
   display
      pt_mstr.pt_part
      pt_mstr.pt_lot_ser
      pt_mstr.pt_um
      pt_mstr.pt_desc1
      pt_mstr.pt_desc2 um conv
   with frame a.
   total_lotserial_qty = 0.
   lotserial_control = pt_mstr.pt_lot_ser.
   setd:
   repeat on endkey undo mainloop, retry mainloop:
      find pt_mstr no-lock where recid(pt_mstr) = pt_recid.
      assign
         continue-yn = no
         site = ""
         location = ""
         lotserial = ""
         lotref = ""
         lotserial_qty = total_lotserial_qty
         cline = "RCT" + pt_mstr.pt_part
         global_part = pt_mstr.pt_part.
      if not can-find (first sr_wkfl where sr_userid = mfguser
                                       and sr_lineid = cline)
      then do:
         site = pt_mstr.pt_site.
         location = pt_mstr.pt_loc.
      end.
      else
      if can-find (sr_wkfl where sr_userid = mfguser
                             and sr_lineid = cline)
      then do:
         find first sr_wkfl where sr_userid = mfguser
            and sr_lineid = cline no-lock.
         site = sr_site.
         location = sr_loc.
         lotserial = sr_lotser.
         lotref = sr_ref.
      end.
      wip_site = site.
      display
         wip_site
         lotserial_qty
         um
         conv
         site
         location
         lotserial
         lotref
         multi_entry
      with frame a.
      sete:
      do on error undo, retry on endkey undo mainloop, retry mainloop:
         set
            wip_site
            lotserial_qty um conv site location
            lotserial lotref multi_entry
         with frame a editing:
            assign
               global_site = input site
               global_loc = input location
               global_lot = input lotserial.
            readkey.
            apply lastkey.
         end.
        /* If the work order is being received into a warehouse location, set
         * the Reference field to the warehouse's default inventory status
         * unless the user has explicitly entered a Reference value.  This is
         * necessary in order to permit a single warehouse to store inventory
         * with multiple statuses (e.g. good, scrap, inspect) for the same item
         * number.  The primary key structure of ld_det will force the
         * inventory to have the same status unless the quantities can be
         * distinguished through different Lot/Serial or Ref numbers. */
         if lotref = "" and
            can-find(whl_mstr where whl_site = site
                                and whl_loc = location no-lock)
         then do:
            find loc_mstr where loc_site = site
                            and loc_loc = location
            no-lock.
            lotref = loc_status.
         end.
         find si_mstr where si_site = wip_site no-lock no-error.
         if not available si_mstr then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* SITE DOES NOT EXIST */
            next-prompt wip_site with frame a.
            undo sete, retry.
         end.
         if si_db <> global_db then do:
            {pxmsg.i &MSGNUM=5421 &ERRORLEVEL=3}
            /* SITE IS NOT ASSIGNED TO THIS DB*/
            next-prompt wip_site with frame a.
            undo sete, retry.
         end.
         wip_entity = si_entity.
         {gprun.i ""gpsiver.p""
            "(input si_site, input recid(si_mstr), output return_int)"}
         if return_int = 0 then do:
            /* User does not have access to this site */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            next-prompt wip_site with frame a.
            undo sete, retry sete.
         end.
         /**************** END OF SECTION TO VALIDATE WIP-SITE *****/
         /**************** SECTION TO VALIDATE SITE ****************/
         if not can-find (si_mstr where si_site = input site)
         then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /*SITE DOES NOT EXIST*/
            next-prompt site with frame a.
            undo sete, retry.
         end.
         {gprun.i ""gpsiver.p""
            "(input site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* Users does not have access to this site */
            {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=site}
            next-prompt site with frame a.
            undo sete, retry sete.
         end.
         /**************** END OF SECTION TO VALIDATE SITE *********/
         regular = yes.
         /* CHECK WHETHER ITEM IS JOINT PRODUCT / BASE OR REGULAR */
         find ptp_det where ptp_part = pt_mstr.pt_part
                        and ptp_site = pt_mstr.pt_site
         no-lock no-error.
         if available ptp_det and ptp_joint_type <> "" then do:
            regular = no.
            if pt_mstr.pt_joint_type = "5" then base = yes.
            else do:
               jprod = yes.
               back_mod = yes.
            end.
         end.
         if um <> pt_mstr.pt_um then do:
            if um entered and conv not entered then do:
               {gprun.i ""gpumcnv.p""
                  "(input um, input pt_mstr.pt_um, input pt_mstr.pt_part,
                    output conv)"}
               if conv = ? then do:
                  {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                  /*NO UOM CONVERSION EXISTS */
                  conv = 1.
               end.
               display conv with frame a.
            end.
         end.
         if um <> pt_mstr.pt_um or conv <> 1 then
            display
               lotserial_qty * conv @ total_lotserial_qty
               pt_mstr.pt_um @ stock_um
            with frame a.
         else
            display
               "" @ total_lotserial_qty
               "" @ stock_um
            with frame a.
         if not can-find (sr_wkfl where sr_userid = mfguser
            and sr_lineid = cline)     /* (failed or ambiguous) */
            and can-find (first sr_wkfl where sr_userid = mfguser
            and sr_lineid = cline)     /* (found so must be multiples) */
         then
            multi_entry = yes.
         trans_um = um.
         trans_conv = conv.
         if multi_entry then do:
            /* ADDED SIXTH INPUT PARAMETER AS NO */
            {gprun.i ""icsrup.p""
               "(input wip_site,
                 input """",
                 input """",
                 input-output lotnext,
                 input lotprcpt,
                 input no)"}
         end.
         else do:
            {gprun.i ""icedit.p""
               "(transtype,
                 site,
                 location,
                 part,
                 lotserial,
                 lotref,
                 lotserial_qty * trans_conv,
                 trans_um,
                 """",
                 """",
                 output yn)"}
            if yn then undo sete, retry sete.
            if wip_site <> site then do:
               {gprun.i ""icedit4.p""
                  "(input transtype,
                    input wip_site,
                    input site,
                    input pt_mstr.pt_loc,
                    input location,
                    input part,
                    input lotserial,
                    input lotref,
                    input lotserial_qty * trans_conv,
                    input trans_um,
                    """",
                    """",
                    output yn)"}
               if yn then undo sete, retry sete.
            end.
            find first sr_wkfl where sr_userid = mfguser
               and sr_lineid = cline no-error.
            if lotserial_qty = 0 then do:
               if available sr_wkfl then do:
                  total_lotserial_qty = total_lotserial_qty - sr_qty.
                  delete sr_wkfl.
               end.
            end.
            else do:
               if available sr_wkfl then do:
                  assign
                     total_lotserial_qty = total_lotserial_qty - sr_qty
                     + lotserial_qty
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref
                     sr_qty = lotserial_qty.
               end.
               else do:
                  create sr_wkfl.
                  assign
                     sr_userid = mfguser
                     sr_lineid = cline
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref
                     sr_qty = lotserial_qty.
                  total_lotserial_qty = total_lotserial_qty
                  + lotserial_qty.
                  if recid(sr_wkfl) = -1 then.
               end.
            end.
         end.
         lotserial_qty = total_lotserial_qty.
         display
            lotserial_qty
         with frame a.
         if um <> pt_mstr.pt_um or conv <> 1 then
            display
               total_lotserial_qty * conv @ total_lotserial_qty
               pt_mstr.pt_um @ stock_um
            with frame a.
         else
            display
               "" @ total_lotserial_qty
               "" @ stock_um
            with frame a.
         {gprun.i ""glactdft.p""
            "(input ""WO_WIP_ACCT"",
              input pl_prod_line,
              input site,
              input """",
              input """",
              input no,
              output cr_acct,
              output cr_sub,
              output cr_cc)"}
         find ac_mstr where ac_code = cr_acct
         no-lock no-error.
         if available ac_mstr then
            cr_desc = ac_desc.
         else
            cr_desc = "".
         display cr_desc with frame a.
         if eff_date = ? then eff_date = today.
         back_assy = pt_mstr.pt_part.
         find ptp_det where ptp_site = wip_site and
                            ptp_part = pt_mstr.pt_part
         no-lock no-error.
         if available ptp_det and ptp_bom_code <> "" then
            back_assy = ptp_bom_code.
         if not available ptp_det and pt_mstr.pt_bom_code <> "" then
            back_assy = pt_mstr.pt_bom_code.
         assign
            back_qty = total_lotserial_qty
            back_um = um
            back_conv = conv
            back_site = wip_site.

         /* RESTRICTED TRANSACTION VALIDATIONS FOR RCT-WO TRANSACTION */
         /* SIMILAR TO worcat01.p AND icedit FILES                    */
         for each sr_wkfl
             fields (sr_lineid sr_lotser sr_userid sr_loc
                     sr_qty    sr_ref    sr_site)
             where sr_userid = mfguser
             and   sr_lineid = cline
         no-lock:

/*xx*      {gprun.i ""worcat04.p""   **/
/*xx*/    {gprun.i ""xxworcat03.p""
                "(input  part,
                  input  sr_site,
                  input  sr_loc,
                  input  sr_ref,
                  input  sr_lotser,
                  input  eff_date,
                  input  sr_qty * trans_conv,
                  input  chg_assay,
                  input  chg_grade,
                  input  chg_expire,
                  input  chg_status,
                  input  assay_actv,
                  input  grade_actv,
                  input  expire_actv,
                  input  status_actv,
                  output l_trans_ok)"}

            if not l_trans_ok
            then
               undo sete, retry sete.

         end. /* FOR EACH sr_wkfl */

         seta:
         do on endkey undo sete, retry sete on error undo, retry:
            update
               nbr
               so_job
               addr
               rmks
               eff_date
               cr_acct
               cr_sub
               cr_cc
               project
               back_mod
            with frame a.
            if not regular and not back_mod then do:
               back_mod = yes.
               display back_mod with frame a.
            end.
            /* CHECK EFFECTIVE DATE */
            find si_mstr where si_site = site no-lock.
            {gpglef1.i &module = ""IC""
               &entity = si_entity
               &date = eff_date
               &prompt = "eff_date"
               &frame = "a"
               &loop = "seta"}
            find si_mstr where si_site = wip_site no-lock.
            {gpglef1.i &module = ""IC""
               &entity = si_entity
               &date = eff_date
               &prompt = "eff_date"
               &frame = "a"
               &loop = "seta"}
            /* CHECK GL ACCOUNT/COST CENTER */
            if issrct <> "ISS" then do:
               /* INITIALIZE SETTINGS */
               {gprunp.i "gpglvpl" "p" "initialize"}
               /* ACCT/SUB/CC/PROJ VALIDATION */
               {gprunp.i "gpglvpl" "p" "validate_fullcode"
                  "(input cr_acct,
                    input cr_sub,
                    input cr_cc,
                    input project,
                    output valid_acct)"}
               if valid_acct = no then do:
                  next-prompt cr_acct with frame a.
                  undo seta, retry.
               end.
            end.
         end.
         cr_proj = project.
         find ac_mstr where ac_code = cr_acct
         no-lock no-error.
         if available ac_mstr then
            cr_desc = ac_desc.
         else
            cr_desc = "".
         display cr_desc with frame a.
         pause 0.
         if back_mod = no and back_qty <> 0 then do:
            comp = back_assy.
            operation = ?.
            /* THIS SECTION OF CODE WAS ORIGINALLY INTRODUCED IN VERSION 72 */
            /* WITH ECO F892.  SOMEHOW THIS PATCH WAS NOT CARRIED FORWARD   */
            /* INTO VERSION 74.  THIS CODE IS NECESSARY FOR COMPONENTS TO   */
            /* BE PROPERLY ISSUED WHEN A PARENT ITEM HAS A BOM CODE         */
            /* DIFFERENT THAN THE ITEM NUMBER.                              */
            site = back_site.
            find ptp_det no-lock where ptp_part = back_assy
               and ptp_site = back_site no-error.
            if available ptp_det then do:
               if ptp_bom_code <> "" and ptp_joint_type = "" then
                  comp = ptp_bom_code.
            end.
            else do:
               if pt_mstr.pt_bom_code <> "" and pt_mstr.pt_joint_type = "" then
                  comp = pt_mstr.pt_bom_code.
            end.
            {gprun.i ""icisrc1c.p""}
            if anyrejected then do:
               back_mod = true.
               /* Unable to issue or receive */
               {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=err_part}
            end.
         end.
         if back_mod then do:
            {gprun.i ""icisrc01.p""}
            if not continue-yn then next mainloop.
            /*V8-*/
            if keyfunction(lastkey) = "end-error" then next mainloop.
            /*V8+*/
            view frame a.
         end.
      end.
      if not can-find (sr_wkfl where sr_userid = mfguser
         and sr_lineid = cline)     /* (failed or ambiguous) */
         and can-find (first sr_wkfl where sr_userid = mfguser
         and sr_lineid = cline)     /* (found so must be multiples) */
      then
      repeat:
         /*    do on endkey undo mainloop, retry mainloop: */
         yn = yes.
         /* Display lotserials being received? */
         {pxmsg.i &MSGNUM=359 &ERRORLEVEL=1 &CONFIRM=yn}
         if yn then do:
            pause 0.
            for each sr_wkfl no-lock where sr_userid = mfguser
                  and sr_lineid begins "RCT"
            with frame b width 80
            title (getFrameTitle("RECEIPT_DATA_REVIEW",28))
            row 6 overlay
            break by sr_lineid by sr_site by sr_loc by sr_lotser:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
               display
                  sr_site
                  sr_loc
                  sr_lotser
                  sr_ref
                  sr_qty.
            end.
         end.
         leave.
      end.
      do on endkey undo mainloop, retry mainloop:
         yn = yes.
         /* PLEASE CONFIRM UPDATE */
         {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
         if yn then do:
            /*LAST MINUTE EDIT TO SEE IF INVENTORY HAS GONE NEGATIVE */
            {icintr1.i}
            if yn then next setd.
            leave setd.
         end.
         /*V8-*/
         else
            undo mainloop.
         /*V8+*/
         /*V8! else if yn = ?
                    or yn = no
               then
         undo mainloop, retry mainloop. */
      end.
   end.
   /*setd*/
   if back_mod = no and back_qty <> 0 then do:
      for each sr_wkfl
            exclusive-lock
            where sr_userid = mfguser
            and substring(sr_lineid,1,3) = "ISS":
         find first pk_det where pk_user = sr_userid and
            pk_part = substring(sr_lineid,4) no-error.
         if not available pk_det
         then do:
            create pk_det.
            assign
               pk_user = sr_userid
               pk_part = substring(sr_lineid,4)
               pk_loc = sr_loc
               pk_lot = sr_lotser.
            if recid(pk_det) = -1 then .
         end.
         pk_qty = pk_qty + sr_qty.
      end.
   end.
   
   
   do transaction:

      /* GENERATE COMPONENT ISSUE TRANSACTIONS */
      {gprun.i ""icisrc02.p""}

      {gprun.i ""icisrc03.p""
     "(input yes)"}

   end. /* DO TRANSACTION */
   do transaction:
      for each sr_wkfl exclusive-lock where sr_userid = mfguser:
         delete sr_wkfl.
      end.
   end.
end.
/* DELETING TEMPORARY pk_det RECORDS */
{mfdel.i "pk_det" "where pk_user = mfguser"}
