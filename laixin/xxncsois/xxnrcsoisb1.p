/* rcsoisb1.p - Release Management Customer Schedules                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.1.33 $         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3    LAST MODIFIED: 08/13/93           BY: WUG *GE19*          */
/* REVISION: 7.3    LAST MODIFIED: 01/27/94           BY: afs *FL76*          */
/* REVISION: 7.3    LAST MODIFIED: 08/05/94           BY: dpm *GL13*          */
/* REVISION: 7.3    LAST MODIFIED: 09/15/94           BY: rmh *GM22*          */
/* REVISION: 7.3    LAST MODIFIED: 11/01/94           BY: ame *GN84*          */
/* REVISION: 7.3    LAST MODIFIED: 01/26/95           BY: WUG *G0BY*          */
/* REVISION: 7.3    LAST MODIFIED: 09/05/95           BY: vrn *G0WD*          */
/* REVISION: 7.3    LAST MODIFIED: 10/10/95           BY: vrn *G0YW*          */
/* REVISION: 7.3    LAST MODIFIED: 02/01/96           BY: ais *G1M1*          */
/* REVISION: 8.5    LAST MODIFIED: 10/18/95           BY: taf *J053*          */
/* REVISION: 8.5    LAST MODIFIED: 02/28/96           BY: dxk *G1MY*          */
/* REVISION: 8.5    LAST MODIFIED: 05/16/96           BY: GWM *J0MS*          */
/* REVISION: 8.5    LAST MODIFIED: 06/04/96           BY: rxm *G1WN*          */
/* REVISION: 8.5    LAST MODIFIED: 07/12/96           BY: dxk *G1YS*          */
/* REVISION: 8.6    LAST MODIFIED: 08/09/96 BY: *K003* Vinay Nayak-Sujir      */
/* REVISION: 8.6    LAST MODIFIED: 10/04/96 BY: *K003* forrest mori           */
/* REVISION: 8.6    LAST MODIFIED: 11/19/96 BY: *H0PF* Suresh Nayak           */
/* REVISION: 8.6    LAST MODIFIED: 04/02/97 BY: *K09G* Vinay Nayak-Sujir      */
/* REVISION: 8.6    LAST MODIFIED: 11/16/97 BY: *K18W* Taek-Soo Chang         */
/* REVISION: 8.6    LAST MODIFIED: 12/08/97 BY: *J27M* Seema Varma            */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan             */
/* REVISION: 8.6    LAST MODIFIED: 12/15/98 BY: *K1YG* Seema Varma            */
/* REVISION: 8.6e   LAST MODIFIED: 04/13/99 BY: *J3BP* Santosh Rao            */
/* REVISION: 8.6e   LAST MODIFIED: 08/12/99 BY: *J3KJ* Bengt Johansson        */
/* REVISION: 9.0    LAST MODIFIED: 10/26/99 BY: *K23Z* Surekha Joshi          */
/* REVISION: 9.0    LAST MODIFIED: 01/11/00 BY: *J3N7* Reetu Kapoor           */
/* REVISION: 9.1    LAST MODIFIED: 04/24/00 BY: *L0PR* Kedar Deherkar         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00 BY: *N0KP* myb                    */
/* REVISION: 9.1    LAST MODIFIED: 10/04/00 BY: *N0WD* Mudit Mehta            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.1.13   BY: Rajiv Ramaiah  DATE: 08/06/01  ECO: *M1GQ*       */
/* Revision: 1.13.1.18   BY: Ashwini G.     DATE: 08/06/01  ECO: *M1GW*       */
/* Revision: 1.13.1.24   BY: Kirti Desai    DATE: 12/13/01  ECO: *M12R*       */
/* Revision: 1.13.1.25   BY: Ashwini G.     DATE: 12/15/01  ECO: *M1LD*       */
/* Revision: 1.13.1.26   BY: Nikita Joshi   DATE: 01/18/02  ECO: *M1K6*       */
/* Revision: 1.13.1.28  BY: Sandeep Parab      DATE: 06/04/02  ECO: *M1XH*    */
/* Revision: 1.13.1.30  BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00K*    */
/* Revision: 1.13.1.31  BY: Rajinder Kamra     DATE: 07/28/03  ECO: *Q017*    */
/* Revision: 1.13.1.32  BY: Orlando D'Abreo    DATE: 08/07/03 ECO: *P0Z7*     */
/* $Revision: 1.13.1.33 $  BY: Binoy John       DATE: 12/15/04  ECO: *P2ZR*     */
/* $Revision: 1.13.1.28.3.1 $  BY: Bill Jiang  DATE: 03/06/06  ECO: *SS - 20060306*     */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* SHIPPER CONFIRM SUBPROGRAM                                                 */

/* INCLUDE FILE SHARED VARIABLES */
{mfdeclre.i}

/* THE LOCALIZATION CONTROL FILE */
{cxcustom.i "RCSOISB1.P"}

/* DEFINE INPUT/OUTPUT PARAMETER */
define input      parameter auto_inv        as   logical.
define input      parameter sonbr           like sod_nbr      no-undo.
define input      parameter sodline         like sod_line     no-undo.
define input      parameter shipper_id      as   character.
define input      parameter absid           like abs_id       no-undo.
define input      parameter shp_date        like abs_shp_date no-undo.
define input      parameter inv_mov         like abs_inv_mov  no-undo.
define input      parameter item_absid      like abs_id       no-undo.

/* DEFINE SHARED VARIABLES/WORKFILE */
define     shared variable  rndmthd         like rnd_rnd_mthd.
define     shared variable  std_cost        like sod_std_cost.
define     shared variable  qty_all         like sod_qty_all.
define     shared variable  qty_pick        like sod_qty_pick.
define     shared variable  eff_date        as   date.
define     shared variable  prev_qty_ord    like sod_qty_ord.
define     shared variable  prev_due        like sod_due_date.
define     shared variable  prev_consume    like sod_consume.
define     shared variable  prev_site       like sod_site.
define     shared variable  prev_type       like sod_type.
define     shared variable  qty_iss_rcv     like tr_qty_loc.
define     shared variable  confirm_mode    like mfc_logical  no-undo.
define     shared variable  l_unconfm_shp   like mfc_logical  no-undo.
define     shared variable  l_multi_ln_item like mfc_logical  no-undo.
define     shared variable  l_undo          like mfc_logical  no-undo.

define     shared workfile  work_sr_wkfl    like sr_wkfl.

/* DEFINE NEW SHARED VARIABLES */
define new shared variable  site_to         like sod_site.
define new shared variable  loc_to          like sod_loc.

{&RCSOISB1-P-TAG1}

/* DEFINE LOCAL VARIABLES/BUFFER */
define            variable  l_abs_pick_qty  like sod_qty_pick no-undo.
define            variable  l_in_qty_all    like in_qty_all   no-undo.
define            variable  l_pick_qty      like sod_qty_pick no-undo.
define            variable  l_ship_qty      like sod_qty_pick no-undo.
define            variable  l_sum_tr_item   like mfc_logical  no-undo.

/* SHIPPER TEMP TABLE DEFINITION */
{rcwabsdf.i}

define            buffer    b_in_mstr       for  in_mstr.
define            buffer    b_work_abs_mstr for  work_abs_mstr.

/* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/* INVOICE POST.                                                  */

for first sod_det
   fields( sod_domain sod_cfg_type sod_consume sod_due_date sod_fsm_type
   sod_line
          sod_nbr sod_part sod_qty_all sod_qty_chg sod_qty_ord sod_qty_pick
          sod_qty_ship sod_sched sod_site sod_type sod_um_conv sod__qadl01)
    where sod_det.sod_domain = global_domain and  sod_nbr  = sonbr
   and   sod_line = sodline
   no-lock:
end. /* FOr FIRST sod_det */

assign
   /* ADDED FOR SUMMARIZATION ITEM RECORDS */
   l_sum_tr_item = can-find(first mfc_ctrl
                            where mfc_domain = global_domain
                            and   mfc_field  = "shc_sum_tr_item"
                            and   mfc_logical)
   prev_due      = sod_due_date
   prev_qty_ord  = sod_qty_ord * sod_um_conv
   prev_consume  = sod_consume
   prev_site     = sod_site
   prev_type     = sod_type.

for first work_sr_wkfl
   fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
          sr_ref sr_site sr_userid sr__qadc01)
   no-lock:
end. /* FOR FIRST work_sr_wkfl */

for first sr_wkfl
    where sr_wkfl.sr_domain = global_domain and  sr_wkfl.sr_userid =
    work_sr_wkfl.sr_userid
   and   sr_wkfl.sr_lineid = work_sr_wkfl.sr_lineid
   and   sr_wkfl.sr_site   = work_sr_wkfl.sr_site
   and   sr_wkfl.sr_loc    = work_sr_wkfl.sr_loc
   and   sr_wkfl.sr_lotser = work_sr_wkfl.sr_lotser
   and   sr_wkfl.sr_ref    = work_sr_wkfl.sr_ref
   exclusive-lock:
end. /* FOR FIRST sr_wkfl */

if not available sr_wkfl
then do:
   create sr_wkfl. sr_wkfl.sr_domain = global_domain.
   assign
      sr_wkfl.sr_userid  = work_sr_wkfl.sr_userid
      sr_wkfl.sr_lineid  = work_sr_wkfl.sr_lineid
      sr_wkfl.sr_site    = work_sr_wkfl.sr_site
      sr_wkfl.sr_loc     = work_sr_wkfl.sr_loc
      sr_wkfl.sr_lotser  = work_sr_wkfl.sr_lotser
      sr_wkfl.sr_ref     = work_sr_wkfl.sr_ref
      sr_wkfl.sr__qadc01 = work_sr_wkfl.sr__qadc01.
end. /* IF NOT AVAILABLE sr_wkfl */

assign
   sr_wkfl.sr_qty = work_sr_wkfl.sr_qty
   recno          = recid(sr_wkfl).

/* HERE in_qty_all IS UPDATED ONLY WHEN IT'S A DISCRETE ORDER AND */
/* IT'S NOT A RMA RECEIPT LINE. THE VALIDATION HAS BEEN COPIED    */
/* FROM mfivtr.i WHICH IS INVOKED BY sosoisu3.p. in_qty_req FIELD */
/* IS UPDATED IN mfivtr.i AND THEREBY IN sosoisu3.p.              */

if  sod_type     =  ""
and sod_fsm_type <> "RMA-RCT"
then do:

   for first in_mstr
      fields( in_domain in_part in_site in_qty_all)
       where in_mstr.in_domain = global_domain and  in_part = sod_part
      and   in_site = sod_site
      no-lock:
      l_in_qty_all = in_qty_all.
   end. /* FOR FIRST in_mstr */

   /* CORRECTING IN_QTY_ALL FOR A DISCRETE ORDER WITH NEGATIVE     */
   /* QUANTITY AND FOR OVERSHIPMENTS                               */

   if available in_mstr
   then do:

      assign
         l_abs_pick_qty = 0
         l_pick_qty     = 0
         l_ship_qty     = 0.

      for first work_abs_mstr
         fields (abs_id abs__qad10 abs_order abs_line abs_item abs_loc
                 abs_ref abs_qty)
         where work_abs_mstr.abs_id = item_absid
         no-lock:

         /* UNPACKING ABS__QAD10 FIELD */
         {absupack.i  "work_abs_mstr" 3 22 "l_abs_pick_qty" }

         /* ADDED SUMMARIZATION FOR INVENTORY UPDATE  */
        if l_sum_tr_item
        then do:

           for each b_work_abs_mstr
              where b_work_abs_mstr.abs_order = work_abs_mstr.abs_order
              and   b_work_abs_mstr.abs_line  = work_abs_mstr.abs_line
              and   b_work_abs_mstr.abs_item  = work_abs_mstr.abs_item
              and   b_work_abs_mstr.abs_loc   = work_abs_mstr.abs_loc
              and   b_work_abs_mstr.abs_lot   = work_abs_mstr.abs_lot
              and   b_work_abs_mstr.abs_ref   = work_abs_mstr.abs_ref
              no-lock:

              l_abs_pick_qty = 0.

              {absupack.i  "b_work_abs_mstr" 3 22 "l_abs_pick_qty"}

              assign
                 l_pick_qty = l_pick_qty + l_abs_pick_qty
                 l_ship_qty = l_ship_qty + abs_qty.

           end. /* FOR EACH b_work_abs_mstr */

        end. /*IF l_sum_tr_item */
        else
           assign
              l_pick_qty = l_pick_qty + l_abs_pick_qty
              l_ship_qty = l_ship_qty + abs_qty.

      end. /* FOR FIRST work_abs_mstr */

      if sod_qty_ord <= 0
      then
         if (sod_qty_pick   = 0
         and sod_qty_chg    < 0)
         or (l_abs_pick_qty = 0
         and sod_qty_chg    > 0)
         then do:

            if  sod__qadl01
            and not l_unconfm_shp
            and trim(sod_type)     = ""
            and trim(sod_fsm_type) = ""
            and confirm_mode
            and not l_multi_ln_item
            then
               assign
                  qty_all      = -(sod_qty_all + sod_qty_pick)
                  qty_all      = qty_all * sod_um_conv
                  l_in_qty_all = l_in_qty_all + qty_all.
            else
            if sod_sched
            then do:
               if (sod_qty_chg > 0
               and confirm_mode)
               or (sod_qty_chg < 0
               and not confirm_mode)
               then do:
                  if sod_qty_all >= sr_wkfl.sr_qty
                  then
                     l_in_qty_all = max(l_in_qty_all - sr_wkfl.sr_qty,0).
                  else
                     l_in_qty_all = max(l_in_qty_all -
                                       (min(sod_qty_all,
                                       (l_ship_qty - l_pick_qty)) +
                                        l_pick_qty),0).

               end. /* IF sod_qty_chg > 0 ... */
            end. /* IF sod_sched */
            else
            if (sod_cfg_type <> "2"
                or execname  <> "rcunis.p")
            then
               assign
                  qty_all      = 0
                  l_in_qty_all = l_in_qty_all + qty_all.

         end. /* IF (sod_qty_pick = 0 AND sod_qty_chg < 0) ... */

         else do:
            if (sod_cfg_type <> "2"
                or execname  <> "rcunis.p")
            then
               if sod_qty_all >= sr_wkfl.sr_qty
               then
                  l_in_qty_all = max(l_in_qty_all -
                                     (sr_wkfl.sr_qty * sod_um_conv), 0).
               else
                  l_in_qty_all = max(l_in_qty_all -
                                    (min(sod_qty_all,
                                    (l_ship_qty - l_pick_qty)) +
                                     l_pick_qty),0).
         end. /* ELSE DO */

      else
      if (sod_cfg_type <> "2"
          or execname  <> "rcunis.p")
      then do:
         if sod_qty_ord < sod_qty_ship
         then
            assign
               qty_all = max(0, sod_qty_ord - sod_qty_ship - sr_wkfl.sr_qty)
               qty_all      = qty_all * sod_um_conv
               l_in_qty_all = l_in_qty_all + qty_all.
         else do:

            if  sod_qty_all    > l_in_qty_all
            and sr_wkfl.sr_qty > l_in_qty_all
            then
               l_in_qty_all = max(l_in_qty_all -
                              (sr_wkfl.sr_qty * sod_um_conv), 0).
            else
            if  sod__qadl01
            and not l_unconfm_shp
            and trim(sod_type)     = ""
            and trim(sod_fsm_type) = ""
            and confirm_mode
            and not l_multi_ln_item
            then
               assign
                  qty_all      = -(sod_qty_all + sod_qty_pick)
                  qty_all      = qty_all * sod_um_conv
                  l_in_qty_all = l_in_qty_all + qty_all.
            else do:

               if confirm_mode
               then do:

                  if  (sod_qty_all >= 0
                  and (can-find (first lad_det
                                  where lad_det.lad_domain = global_domain and
                                  (  lad_dataset = "sod_det"
                                 and   lad_nbr     = sod_nbr
                                 and   lad_line    = string(sod_line)
                                 and   lad_part    = sod_part
                                 and   lad_site    = sod_site))))
                  or  (sod_qty_all <> 0
                  and (not can-find (first lad_det
                                      where lad_det.lad_domain = global_domain
                                      and  lad_dataset = "sod_det"
                                     and   lad_nbr     = sod_nbr
                                     and   lad_line    = string(sod_line)
                                     and   lad_part    = sod_part
                                     and   lad_site    = sod_site)))
                  then  do :
                     assign
                        qty_all      = - min((sod_qty_all + sod_qty_pick),
                                       sr_wkfl.sr_qty)
                        qty_all      = qty_all * sod_um_conv
                        l_in_qty_all = max((l_in_qty_all + qty_all),0).
                  end. /* IF (sod_qty_all >= 0 ... */

               end. /* IF confirm_mode */
               else
                  assign
                     qty_all      = - min(sod_qty_ord, sr_wkfl.sr_qty)
                     qty_all      = qty_all * sod_um_conv
                     l_in_qty_all = l_in_qty_all + qty_all.

            end. /* ELSE DO: */

         end. /* ELSE DO */
      end. /* IF sod_cfg_type <> "2" */

      if l_in_qty_all <> in_qty_all
      then do:

         find b_in_mstr
         where recid(b_in_mstr) = recid(in_mstr)
         exclusive-lock no-wait no-error.

         if locked b_in_mstr
         then do:
           /* INVENTORY MASTER IS IN USE FOR SITE # ITEM #. PLEASE RE-CONFIRM */
            {pxmsg.i
               &MSGNUM=5437
               &ERRORLEVEL=4
               &MSGARG1=in_mstr.in_site
               &MSGARG2=in_mstr.in_part}.
            l_undo   = yes.
            undo, leave.
         end. /* IF LOCKED b_in_mstr */

         b_in_mstr.in_qty_all = l_in_qty_all.
      end. /* IF l_in_qty_all <> in_qty_all */

   end.    /* IF AVAILABLE in_mstr */

end. /* IF sod_type =  "" ... */

/* SS - 20060306 - B */
/*
{gprun.i ""sosoisu5.p""
   "(input item_absid,
     input substr(absid,2),
     input shp_date,
     input inv_mov) "}
    */
{gprun.i ""xxnsosoisu5.p""
   "(input item_absid,
     input substr(absid,2),
     input shp_date,
     input inv_mov) "}
    /* SS - 20060306 - E */

if l_undo
then
   undo, leave.

for each work_sr_wkfl exclusive-lock:
   delete work_sr_wkfl.
end.
