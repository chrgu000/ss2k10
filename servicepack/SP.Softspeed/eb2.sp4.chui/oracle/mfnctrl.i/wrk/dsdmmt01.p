/* dsdmmt01.p - INTER-SITE REQUISITION ACKNOWLEDGEMENT                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15.1.13 $                                                  */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/* NOTES:   1. in_level is set to a value of 99999 when in_mstr is created or */
/*             when any structure or network changes are made that affect the */
/*             low level codes.                                               */
/*          2. The in_levels are recalculated when MRP is run or can be       */
/*             resolved by running the mrllup.p utility program.              */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: emb                       */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: emb *F225*                */
/* REVISION: 7.0      LAST MODIFIED: 05/13/92   BY: emb *F485*                */
/* REVISION: 7.0      LAST MODIFIED: 05/14/92   BY: emb *F611*                */
/* REVISION: 7.0      LAST MODIFIED: 09/18/92   BY: emb *G074*                */
/* Revision: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 10/13/92   BY: emb *G526*                */
/* REVISION: 7.3      LAST MODIFIED: 05/22/93   BY: pma *GB27*                */
/* REVISION: 7.3      LAST MODIFIED: 09/10/93   BY: emb *GF06*                */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*                */
/* REVISION: 7.4      LAST MODIFIED: 08/10/94   BY: dpm *FP97*                */
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/10/95   BY: pxd *F0PZ*                */
/* REVISION: 8.5      LAST MODIFIED: 10/19/94   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 05/25/95   BY: emb *F0S7*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/95   BY: qzl *G1DH*                */
/* REVISION: 7.3      LAST MODIFIED: 03/25/96   BY: rvw *G1RF*                */
/* REVISION: 8.5      LAST MODIFIED: 01/07/97   BY: *H0QN* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 07/07/97   BY: *J1PS* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/10/98   BY: *J2RN* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 08/25/00   BY: *M0RH* Mark Christian     */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *N0MX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *M0Y9* Vandna Rohira      */
/* Revision: 1.15.1.11     BY: Vivek Gogte        DATE: 03/29/01 ECO: *M10G*  */
/* Revision: 1.15.1.12     BY: Robin McCarthy     DATE: 07/31/01 ECO: *P009*  */
/* $Revision: 1.15.1.13 $  BY: Saurabh Chaturvedi DATE: 09/17/01 ECO: *M1KP*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

define new shared variable ds_recno as recid.
define new shared variable ds_db like dc_name.
define new shared variable undo-all like mfc_logical.
define new shared variable totallqty like ds_qty_all.
define new shared variable totpkqty like ds_qty_pick.
define new shared variable del-yn like mfc_logical initial no.
define new shared variable cmtindx like dsr_cmtindx.
define new shared variable pacct like pl_inv_acct.
define new shared variable psub  like pl_inv_sub .
define new shared variable pacc  like pl_inv_cc.
define new shared variable qty_to_all like ds_qty_all.

/* THE FOLLOWING SHARED VARIABLES ARE USED BY dsdmmtv2.p WHEN        */
/* CREATING AN INTERSITE REQUEST IN DO MAINT. THEY WILL NOT BE USED  */
/* BY OTHER PROGRAMS CALLING dsdmmtv2.p, SO THEY WILL ALWAYS BE ?,   */
/* BLANK, NO AND 0 WHEN REFERENCED OUTSIDE OF DISTRIB. ORDER MAINT.  */
define new shared variable order_date like dsr_ord_date no-undo.
define new shared variable sales_job like dsr_so_job no-undo.
define new shared variable rcpt_loc like dsr_loc no-undo.
define new shared variable del-req like mfc_logical no-undo.
define new shared variable qty_ord like ds_qty_ord no-undo.

define variable dsr-recid as recid.
define variable detail_all like soc_det_all.
define variable i as integer.
define variable nonwdays as integer.
define variable workdays as integer.
define variable overlap as integer.
define variable know_date as date.
define variable find_date as date.
define variable interval as integer.
define variable frwrd as integer.
define variable yn like mfc_logical initial no.
define variable req_nbr like dsr_req_nbr.
define variable dsrcmmts like woc_wcmmts label "Comments".
define variable eff_date like glt_effdate initial today.
define variable leadtime like pt_mfg_lead.
define variable open_qty like mrp_qty.
define variable network like ssd_network.
define variable prevstatus like dsr_status.
define variable git_acct like si_git_acct.
define variable git_sub  like si_git_sub.
define variable git_cc   like si_git_cc.
define variable prev_qty_all like ds_qty_all.
define variable l_prev_ds_status like ds_status no-undo.
define variable l_prev_ds_qty like ds_qty_conf no-undo.
define variable inrecno as recid no-undo.

/* SELECTION FORM */
form
   ds_shipsite   colon 25 ds_req_nbr    colon 55
   ds_site       colon 25 skip(1)
   ds_part       colon 25 pt_desc1 at 47 no-label
   pt_desc2      at 47 no-label
   ds_trans_id   colon 25 ds_qty_ord    colon 55 pt_um no-label
   ds_shipdate   colon 25 ds_qty_conf   colon 55
   ds_due_date   colon 25 ds_qty_ship   colon 55
   detail_all    colon 25 ds_qty_all    colon 55
   ds_qty_pick   colon 55
   ds_git_site   colon 25
   ds_project    colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat:
   do transaction with frame a:

      prompt-for ds_shipsite ds_req_nbr
      editing:
         if frame-field = "ds_shipsite"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i ds_det ds_shipsite ds_shipsite ds_shipsite
               ds_shipsite ds_det}

            if recno <> ?
            then do:
               find pt_mstr where pt_part = ds_part no-lock no-error.

               display
                  ds_shipsite
                  ds_req_nbr
                  ds_part
                  ds_site
                  ds_qty_ord
                  ds_trans_id
                  ds_due_date
                  ds_shipdate
                  ds_git_site
                  ds_project
                  ds_qty_conf
                  ds_qty_ship
                  ds_qty_all
                  ds_qty_pick
               with frame a.

               if can-find (first lad_det where lad_dataset = "ds_det"
                  and lad_nbr = ds_req_nbr
                  and lad_line = ds_site
                  and lad_part = ds_part
                  and lad_site = ds_shipsite)
               then
                  display true @ detail_all.
               else
                  display false @ detail_all.

               if available pt_mstr
               then
                  display
                     pt_desc1
                     pt_desc2
                     pt_um.
               else
                  display
                     " " @ pt_desc1
                     " " @ pt_desc2
                     " " @ pt_um.
            end.
         end.
         else
            if frame-field = "ds_req_nbr"
            then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i ds_det ds_req_nbr ds_req_nbr ds_req_nbr
                  ds_req_nbr ds_req_nbr}

               if recno <> ?
               then do:
                  find pt_mstr where pt_part = ds_part no-lock no-error.

                  display
                     ds_shipsite
                     ds_req_nbr
                     ds_part
                     ds_site
                     ds_qty_ord
                     ds_trans_id
                     ds_due_date
                     ds_shipdate
                     ds_git_site
                     ds_project
                     ds_qty_conf
                     ds_qty_ship
                     ds_qty_all
                     ds_qty_pick
                  with frame a.

                  if can-find (first lad_det where lad_dataset = "ds_det"
                     and lad_nbr = ds_req_nbr
                     and lad_line = ds_site
                     and lad_part = ds_part
                     and lad_site = ds_shipsite)
                  then
                     display true @ detail_all.
                  else
                     display false @ detail_all.

                  if available pt_mstr then
                     display
                        pt_desc1
                        pt_desc2
                        pt_um.
                  else
                     display
                        " " @ pt_desc1
                        " " @ pt_desc2
                        " " @ pt_um.
               end.
            end.
         else do:
            readkey.
            apply lastkey.
         end.
      end.

      find si_mstr no-lock where si_site = input ds_shipsite no-error.
      if available si_mstr then
         if si_db <> global_db then do:
            /* SITE IS NOT ASSIGNED TO THIS DATABASE */
            {pxmsg.i &MSGNUM = 5421 &ERRORLEVEL = 3}
            undo, retry.
         end.

      /* CHECK SITE SECURITY */
      if available si_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input si_site, input recid(si_mstr), output return_int)"}
      end.
      else do:
         {gprun.i ""gpsiver.p""
            "(input (input ds_shipsite), input ?, output return_int)"}
      end.
      if return_int = 0 then do:
         /*USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
         next-prompt ds_shipsite with frame a.
         undo, retry.
      end.

     /* GET NEXT REQUEST NUMBER FROM CONTROL FILE */
      if input ds_req_nbr = "" then do:
         find first drp_ctrl no-lock no-error.
         if available drp_ctrl then do:
            if not drp_auto_req then do:
               {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3}   /* BLANK NOT ALLOWED */
                next-prompt ds_req_nbr with frame a.
                undo mainloop, retry mainloop.
            end.
            {mfnctrl.i drp_ctrl drp_req_nbr ds_det ds_req_nbr req_nbr}
         end.
         if req_nbr = "" then undo, retry.
         display req_nbr @ ds_req_nbr with frame a.
      end.

      /* ADD/MOD/DELETE */
      find first ds_det no-lock use-index ds_det
         using ds_shipsite and ds_req_nbr no-error.

      if available ds_det then do:
         display ds_site.
         find pt_mstr no-lock where pt_part = ds_part no-error.
         if available pt_mstr then
            display
               ds_part
               pt_desc1
               pt_desc2
               pt_um.
         else
            display
               " " @ ds_part
               " " @ pt_desc1
               " " @ pt_desc2
               " " @ pt_um.
      end.
   end.
   /* TRANSACTION */

   repeat transaction with frame a:
      prompt-for
         ds_site
      editing:
         {mfnp05.i ds_det ds_det
            "ds_req_nbr = input ds_req_nbr
                   and ds_shipsite = input ds_shipsite"
            ds_site "input ds_site" }

         if recno <> ? then do:
            display
               ds_site
               ds_qty_ord
               ds_trans_id
               ds_due_date
               ds_shipdate
               ds_git_site
               ds_project
               ds_qty_conf
               ds_qty_ship
               ds_qty_all
               ds_qty_pick
            with frame a.

            if can-find (first lad_det where lad_dataset = "ds_det"
               and lad_nbr = ds_req_nbr
               and lad_line = ds_site
               and lad_part = ds_part
               and lad_site = ds_shipsite)
            then
               display true @ detail_all.
            else
               display false @ detail_all.

            find pt_mstr no-lock where pt_part = ds_part no-error.
            if available pt_mstr then
               display
                  ds_part
                  pt_desc1
                  pt_desc2 pt_um.
            else
               display
                  " " @ ds_part
                  " " @ pt_desc1
                  " " @ pt_desc2
                  " " @ pt_um.
         end.
      end.

      find ds_det exclusive-lock using ds_shipsite
         and ds_req_nbr and ds_site no-error.

      if not available ds_det then do:

         assign
            l_prev_ds_status = "F"
            l_prev_ds_qty    = 0
            git_acct = ""
            git_sub  = ""
            git_cc   = "".

         {pxmsg.i &MSGNUM = 1 &ERRORLEVEL = 1}   /* ADDING NEW RECORD */
         create ds_det.
         assign
            ds_req_nbr
            ds_site
            ds_shipsite
            ds_part
            ds_due_date = today
            ds_git_site = input ds_site
            ds_status = "E"
            ds_shipdate = today
            ds_git_acct = git_acct
            ds_git_sub  = git_sub
            ds_git_cc   = git_cc.
      end.
      else do:
         find pt_mstr where pt_part = ds_part no-lock no-error.
         if not available pt_mstr then do:
            /* ITEM NUMBER DOES NOT EXIST */
            {pxmsg.i &MSGNUM = 16 &ERRORLEVEL = 3}
            undo, retry.
         end.

         l_prev_ds_status = ds_status.
         run get_ds_open_qty (buffer ds_det,
                              output l_prev_ds_qty).

         display
            ds_part
            pt_desc1
            pt_desc2
            pt_um
         with frame a.
      end.

      display
         ds_site
         ds_qty_ord
         ds_trans_id
         ds_due_date
         ds_shipdate
         ds_git_site
         ds_project
         ds_qty_conf
         ds_qty_ship
         ds_qty_all
         ds_qty_pick
      with frame a.

      prev_qty_all = ds_qty_all + ds_qty_pick.

      if can-find (first lad_det where lad_dataset = "ds_det"
         and lad_nbr = ds_req_nbr
         and lad_line = ds_site
         and lad_part = ds_part
         and lad_site = ds_shipsite)
      then
         display true @ detail_all.
      else
         display false @ detail_all.

      do on error undo, retry with frame a:
         status input stline[3].

         set
            ds_part when (new(ds_det)).

         for first pt_mstr
               fields (pt_abc  pt_avg_int      pt_bom_code
               pt_cyc_int      pt_desc1        pt_desc2
               pt_insp_lead    pt_insp_rqd     pt_joint_type
               pt_loc          pt_mfg_lead     pt_mrp
               pt_network      pt_ord_max      pt_ord_min
               pt_ord_mult     pt_ord_per      pt_ord_pol
               pt_ord_qty      pt_part         pt_plan_ord
               pt_pm_code      pt_prod_line    pt_pur_lead
               pt_rctpo_active pt_rctpo_status pt_rctwo_active
               pt_rctwo_status pt_routing      pt_sfty_time
               pt_timefence    pt_um           pt_yield_pct)
               where pt_part = ds_part no-lock:
         end. /* FOR FIRST pt_mstr */
         if not available pt_mstr then do:
            /* ITEM NUMBER DOES NOT EXIST */
            {pxmsg.i &MSGNUM = 16 &ERRORLEVEL = 3}
            undo, retry.
         end. /* IF NOT AVAILABLE pt_mstr */

         display
            pt_desc1
            pt_desc2
            pt_um
         with frame a.

         status input stline[2].

         set
            ds_trans_id
            ds_shipdate
            ds_due_date
            detail_all
            ds_qty_conf
            ds_qty_ship
            ds_qty_all
            ds_git_site
            ds_project
         go-on ("F5" "CTRL-D").

         if not can-find(first tm_mstr where tm_code = ds_trans_id) and
            can-find(first tm_mstr where tm_code >= "") and
            ds_trans_id <> "" then do:
            /* TRANSPORTATION MASTER DOES NOT EXIST */
            {pxmsg.i &MSGNUM = 1503 &ERRORLEVEL = 3}
            next-prompt ds_trans_id with frame a.
            undo, retry.
         end.

         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.
            /* PLEASE CONFIRM DELETE */
            {pxmsg.i &MSGNUM = 11 &ERRORLEVEL = 1 &CONFIRM = del-yn
                     &CONFIRM-TYPE = 'LOGICAL'}

            if del-yn = no then undo.

            ds_qty_conf = 0.
            display ds_qty_conf.

         end.
         ds_loc = pt_loc.

         if git_acct = "" then do:
            for  first pld_det fields(pld_prodline pld_site pld_loc
                  pld_inv_acct
                  pld_inv_sub
                  pld_inv_cc)
                  where pld_prodline = pt_prod_line
                  and pld_site     = input ds_git_site
                  and pld_loc      = input ds_trans_id
                  no-lock:
            end.
            if available pld_det and pld_inv_acct <> "" then
               assign
                  git_acct = pld_inv_acct
                  git_sub  = pld_inv_sub
                  git_cc   = pld_inv_cc.
            else do:
               find pld_det no-lock where pld_prodline = pt_prod_line
                  and pld_site = input ds_git_site and pld_loc = ""
                  no-error.
               if available pld_det and pld_inv_acct <> "" then
                  assign
                     git_acct = pld_inv_acct
                     git_sub  = pld_inv_sub
                     git_cc   = pld_inv_cc.
               else do:
                  find pl_mstr no-lock
                     where pl_prod_line = pt_prod_line no-error.
                  if available pl_mstr and pl_inv_acct <> "" then
                     assign
                        git_acct = pl_inv_acct
                        git_sub  = pl_inv_sub
                        git_cc   = pl_inv_cc.
                  else do:
                     for  first si_mstr fields(si_site
                           si_git_acct
                           si_git_sub
                           si_git_cc)
                           where si_site = input ds_git_site
                           no-lock.
                     end.
                     if available si_mstr and si_git_acct <> "" then
                        assign
                           git_acct = si_git_acct
                           git_sub  = si_git_sub
                           git_cc   = si_git_cc.
                     else do:
                        find first gl_ctrl no-lock no-error.
                        if available gl_ctrl then
                           assign
                              git_acct = gl_inv_acct
                              git_sub  = gl_inv_sub
                              git_cc   = gl_inv_cc.
                     end.
                  end.
               end. /* IF AVAILABLE PLD_DET */
            end. /* IF AVAILABLE PLD_DET */
         end.

         assign
            ds_git_acct = git_acct
            ds_git_sub  = git_sub
            ds_git_cc   = git_cc.

         ds_recno = recid(ds_det).

         /* INVENTORY ALLOCATIONS */
         {gprun.i ""dsdoall.p""
                  "(input detail_all,
                    input (if ds_qty_conf entered then true
                           else false),
                    input prev_qty_all)"}

         /* TO CHECK QTY CONFIRMED IS NOT LESS THAN ALLOCATED + */
         /* PICKED + SHIPPED FOR GENERAL AND DETAIL ALLOCATION */

         if ((ds_qty_all + ds_qty_pick + ds_qty_ship > ds_qty_conf )or
            ((totpkqty + totallqty > ds_qty_conf) and
            (totpkqty    <> 0 or
            totallqty   <> 0 )))
         then do with frame a:
            /* QTY CONFIRMED CANNOT BE < ALLOC + PICKED + SHIPPED */
             {pxmsg.i &MSGNUM = 4576 &ERRORLEVEL = 3}
             next-prompt ds_qty_conf.
             undo, retry.
          end. /* IF ds_qty_conf < ds_qty_all */

         if ds_qty_ord >= 0 then
            open_qty = max(ds_qty_conf - max(ds_qty_ship, 0), 0).
         else
            open_qty = min(ds_qty_conf - min(ds_qty_ship, 0), 0).

         if ds_nbr = "" and index("PF",ds_status) <> 0 then
            ds_status = "E".

         if (ds_qty_all <> 0 or ds_qty_pick <> 0)
            and index("PFE",ds_status) <> 0
            and ds_nbr = ""
         then
            ds_status = "A".

         if ds_status = "C" then
            open_qty = 0.

         /* UPDATE MRP FILES */
         {mfmrw.i "ds_det" ds_part ds_req_nbr ds_shipsite
            ds_site ? ds_shipdate open_qty "DEMAND"
            INTERSITE_DEMAND ds_shipsite}

         /* UPDATE in_qty_req */
         run update_in_qty_req
           (input l_prev_ds_status,
            input l_prev_ds_qty,
            input ds_status,
            input open_qty,
            input ds_part,
            input ds_shipsite).

         /* UPDATE dsd_det RECORD FOR REQUESTING SITE */
         assign
            ds_recno = recid(ds_det)
            ds_db = global_db
            undo-all = true.

         /* UPDATE dsd_det RECORD FOR REQUESTING SITE */
         {gprun.i ""dsdmmtv1.p""}
         if undo-all then undo.

      end.  /* DO ON ERROR UNDO, RETRY */
   end. /* REPEAT TRANSACTION WITH FRAME a */
end. /* REPEAT */

/* INCLUDE FILE CONTAINING COMMON PROCEDURES FOR DRP */
{dsopnqty.i}
