/* wowamt.p - WORK ORDER BILL MAINTENANCE                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 01/02/86   BY: pml                       */
/* REVISION: 1.0      LAST MODIFIED: 06/20/86   BY: EMB                       */
/* REVISION: 1.0      LAST MODIFIED: 02/17/87   BY: EMB *A25*                 */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0      LAST MODIFIED: 08/09/88   BY: EMB *A390*                */
/* REVISION: 4.0      LAST MODIFIED: 01/05/89   BY: emb *A583*                */
/* REVISION: 4.0      LAST MODIFIED: 02/09/89   BY: emb *A643*                */
/* REVISION: 5.0      LAST MODIFIED: 10/04/88   BY: JLC *B004*                */
/* REVISION: 5.0      LAST MODIFIED: 04/12/90   BY: emb *B661*                */
/* REVISION: 5.0      LAST MODIFIED: 07/19/90   BY: emb *B734*                */
/* REVISION: 5.0      LAST MODIFIED: 02/19/91   BY: emb *B899*                */
/* REVISION: 6.0      LAST MODIFIED: 05/04/90   BY: MLB *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 06/25/90   BY: emb *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: EMB *D040*                */
/* REVISION: 6.0      LAST MODIFIED: 05/28/91   BY: emb *D660*                */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*                */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: WUG *D920*                */
/* REVISION: 6.0      LAST MODIFIED: 11/14/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: emb *F295*                */
/* REVISION: 7.3      LAST MODIFIED: 10/19/92   BY: emb *G208*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/93   BY: pma *GE81*                */
/* REVISION: 7.3      LAST MODIFIED: 09/23/93   BY: ram *GF81*                */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*                */
/* REVISION: 7.2      LAST MODIFIED: 04/26/94   BY: ais *FN64*                */
/* REVISION: 7.2      LAST MODIFIED: 04/27/94   BY: ais *FN73*                */
/* REVISION: 7.2      LAST MODIFIED: 05/02/94   BY: ais *FN85* (delete FN64)  */
/* Oracle changes (share-locks)    09/13/94           BY: rwl *GM56*          */
/* REVISION: 7.5      LAST MODIFIED: 10/20/94   BY: mwd *J034*                */
/* REVISION: 7.5      LAST MODIFIED: 02/15/95   BY: taf *J040*                */
/* REVISION: 7.5      LAST MODIFIED: 10/07/94   BY: tjs *J027*                */
/* REVISION: 7.4      LAST MODIFIED: 01/24/95   BY: pxe *F0G3*                */
/* REVISION: 7.3      LAST MODIFIED: 08/04/95   BY: emb *F0TL*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 05/06/96   BY: *J0LS* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *G2B8* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 01/21/97   BY: *H0R8* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *G2KT* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 04/07/97   BY: *G2LG* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 09/29/97   BY: *J1PS* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/03/98   BY: *J338* Thomas Fernandes   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0SX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.21       BY: Katie Hilbert        DATE: 04/01/01 ECO: *P008*   */
/* Revision: 1.22  BY: Jean Miller                 DATE: 05/17/02 ECO: *P05V* */
/* Revision: 1.24  BY: Paul Donnelly (SB)          DATE: 06/28/03 ECO: *Q00N* */
/* Revision: 1.25  BY: Rajiv Ramaiah               DATE: 08/02/03 ECO: *P0V1* */
/* $Revision: 1.26 $    BY: Vivek Gogte                 DATE: 09/23/03 ECO: *P13R* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100907.1  By: Roger Xiao */  /*输入被替代料,单位用量不可为零*/

/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "100907.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowamt_p_4 "Qty Per Unit"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable desc1 like pt_desc1.
define new shared variable desc2 like pt_desc1.
define new shared variable wodesc1 like pt_desc1.
define new shared variable wodesc2 like pt_desc1.
define new shared variable part like wo_part.
define new shared variable nbr like wod_nbr.
define new shared variable lot like wod_lot.
define new shared variable status_name like wo_status format "x(12)".
define new shared variable detail_all like soc_det_all.
define new shared variable wod_recno as recid.
define new shared variable totallqty like wod_qty_all.
define new shared variable totpkqty like wod_qty_pick.
define new shared variable undo_all like  mfc_logical initial no no-undo.
define variable prev_site like wod_site.
define variable nextcomp as logical initial no.
define variable prev_bom_qty like wod_bom_qty.
define variable wostatus like wo_status.
define variable open_ref like mrp_qty.
define variable del-yn like mfc_logical.
define variable iss_pol like pt_iss_pol no-undo.
define variable inrecno as recid no-undo.

define new shared frame a.

/* DISPLAY SELECTION FORM */
form
   wo_nbr         colon 25
   wo_lot         colon 50
   part           colon 25
   wodesc1        no-label at 47 no-attr-space
   status_name    colon 25
   wodesc2        no-label at 47 no-attr-space
   skip(1)
   wod_part       colon 25 label "Component Item"
   desc1          no-label at 47 no-attr-space
   wod_op         colon 25
   desc2          no-label at 47 no-attr-space
   skip(1)
   wod_qty_req    colon 25
   wod_bom_qty    colon 55 label "Qty Per Unit"
   wod_qty_all    colon 25
   wod_bom_amt    colon 55 label "Unit Cost" format ">>>>,>>>,>>9.99<<<"
   wod_qty_pick   colon 25
   detail_all     colon 25
   wod_qty_iss    colon 25
   skip(1)
   wod_site       colon 25
   wod_loc        colon 25
   wod_critical   colon 25 label "Key Item"
   wod_iss_date   colon 25
   wod_deliver    colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


/* SS - 100907.1 - B */
define var v_rep     as logical format "Yes/No" .
define var v_partold like wo_part .
form 
    v_rep     colon 20 label "是否替代料" skip
    v_partold colon 20 label "被替代的物料" skip
    pt_desc1  colon 20 label "说明" skip 
    pt_desc2  colon 20 no-label
with frame x1 side-labels overlay row 10 centered width 50 no-attr-space.

/* SS - 100907.1 - E */


/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   ststatus = stline[1].
   status input ststatus.

   undo_all = no.
   {gprun.i ""wowamta.p""}
   if keyfunction(lastkey) = "END-ERROR" then leave.
   if keyfunction(lastkey) = "." then leave.
   if undo_all then do:
      undo mainloop, retry.
   end.

   find wo_mstr
      where wo_mstr.wo_domain = global_domain
      and   wo_nbr            = nbr
      and   wo_lot            = lot
      exclusive-lock no-error.

   comp-loop:
   repeat with frame a:

      prompt-for
         wod_part validate (true,"")
         wod_op
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i wod_det wod_part wod_part lot  " wod_det.wod_domain =
         global_domain and wod_lot "  wod_det}

         if recno <> ? then do:

            assign
               desc1 = ""
               desc2 = "".

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wod_part no-lock no-error.
            if available pt_mstr then
            assign
               desc1 = pt_desc1
               desc2 = pt_desc2.

            display
               wod_part
               wod_op
               desc1 desc2 wod_qty_req
               wod_bom_qty wod_bom_amt
               wod_qty_all wod_qty_pick wod_qty_iss
               wod_critical wod_iss_date wod_deliver.

            /* SEE IF DETAIL ALLOCATIONS*/
            if can-find(first lad_det  where lad_det.lad_domain = global_domain
            and  lad_dataset = "wod_det"
                                        and lad_nbr = wod_lot
                                        and lad_line = string(wod_op)
                                        and lad_part = wod_part)
            then
               detail_all = yes.
            else
               detail_all = no.

            display detail_all wod_site wod_loc.
         end.
      end.

      if lookup(wo_status,"P,F,B,C,") <> 0
      then do:
         {pxmsg.i &MSGNUM=523 &ERRORLEVEL=3}
         /* MODIFICATION TO PLANNED AND FIRM PLANNED COMPONENTS NOT ALLOWED */
         undo, retry.
      end.


    /* SS - 100907.1 - B */
    v_rep     = No.
    v_partold = "" . 
    find wod_det  
        where wod_det.wod_domain = global_domain 
        and wod_nbr = wo_nbr
        and wod_lot = wo_lot
        and wod_part = input wod_part
        and wod_op   = input wod_op
    exclusive-lock no-error.
    if not avail wod_det then do:
        find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
        input wod_part no-lock no-error.
        if not available pt_mstr then do:
            {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
            undo, retry.
        end.
        pause 0.
        view frame x1.
        reploop:
        do on error undo,retry :
            update v_rep with frame x1 .
            if v_rep = Yes then do on error undo,retry:
                update 
                    v_partold /*validate (can-find(first wod_det where wod_domain = global_domain and wod_lot = wo_lot and wod_part = input v_partold  no-lock),"错误:非此工单物料清单的现有物料")*/
                with frame x1 editing:
                    if frame-field = "v_partold" then do:
                        {mfnp01.i wod_det v_partold wod_part lot  " wod_det.wod_domain = global_domain and wod_lot "  wod_det}
                        if recno <> ? then do:
                            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wod_part no-lock no-error.
                            if available pt_mstr then
                                 disp wod_part @ v_partold pt_desc1 pt_desc2 with frame x1 .
                            else disp wod_part @ v_partold "" @ pt_desc1 "" @ pt_desc2 with frame x1 .
                        end . /* if recno <> ? then  do: */
                    end.
                    else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                    end.
                end. /*update*/

                find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wod_part no-lock no-error.
                if not available pt_mstr then do:
                    {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                    undo,retry .
                end.
                find first wod_det where wod_domain = global_domain and wod_lot = wo_lot and wod_part = v_partold no-lock no-error .
                if not avail wod_det then do:
                    message "错误:非此工单物料清单的现有物料" .
                    undo,retry .
                end.
            end. /*if v_rep = Yes*/
        end. /*reploop:*/
    end. /*if not avail wod_det*/

    hide frame x1 no-pause .

    detail-loop:
    do on error undo,retry on endkey undo,leave:

    /* SS - 100907.1 - E */

      /* ADD/MODIFY/DELETE */
      find wod_det  where wod_det.wod_domain = global_domain and  wod_nbr =
      wo_nbr
                     and wod_lot = wo_lot
                     and wod_part = input wod_part
                     and wod_op = input wod_op
      exclusive-lock no-error.

      if not available wod_det then do:

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         input wod_part no-lock no-error.
         if not available pt_mstr then do:
            {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
            undo, retry.
         end.

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create wod_det. wod_det.wod_domain = global_domain.
         assign
            wod_nbr = wo_nbr
            wod_lot = wo_lot
            wod_part
            wod_op
/* SS - 100907.1 - B */
            wod__chr01 = if v_partold <> "" then v_partold else wod__chr01
/* SS - 100907.1 - E */
            wod_iss_date = wo_rel_date
            wod_site = wo_site
            wod_recno = recid(wod_det).

         assign
            wod_part = pt_part
            desc1 = pt_desc1
            desc2 = pt_desc2
            wod_loc = pt_loc
            wod_critical = pt_critical.

         if not can-find (wr_route  where wr_route.wr_domain = global_domain
         and  wr_lot = wod_lot
                                     and wr_nbr = wod_nbr
                                     and wr_op = wod_op)
            and wod_op <> 0
         then do:
            {pxmsg.i &MSGNUM=511 &ERRORLEVEL=2}
         end.

         find in_mstr  where in_mstr.in_domain = global_domain and  in_site =
         wod_site
            and in_part = wod_part no-lock no-error.
         if available in_mstr then do:
            {gpsct03.i &cost=sct_cst_tot}
            wod_bom_amt = glxcst.
         end.
      end. /* IF NOT AVAILABLE WOD_DET */

      {gprun.i ""gpsiver.p""
         "(input wod_site, input ?, output return_int)"}
      if return_int = 0 then do:
         display wod_site with frame a.
         /* USER DOES NOT HAVE ACCESS TO DETAIL SITE XXXX  */
         {pxmsg.i &MSGNUM=2736 &ERRORLEVEL=3 &MSGARG1=wod_site}
         undo comp-loop, retry.
      end.

      ststatus = stline[2].
      status input ststatus.

      assign
         del-yn = no
         desc1 = ""
         desc2 = "".

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock no-error.
      if available pt_mstr then
      assign
         desc1 = pt_desc1
         iss_pol = pt_iss_pol
         desc2 = pt_desc2.

      find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
      wod_part and in_site = wod_site
      exclusive-lock no-error.

      if available in_mstr then do:
         if wod_qty_req >= 0 then
            in_qty_req = in_qty_req - max(wod_qty_req - wod_qty_iss,0).
         else
            in_qty_req = in_qty_req - min(wod_qty_req - wod_qty_iss,0).
         in_qty_all = in_qty_all - (wod_qty_all + wod_qty_pick).
      end.

      if can-find(first lad_det  where lad_det.lad_domain = global_domain and
      lad_dataset = "wod_det"
                                  and lad_nbr = wod_lot
                                  and lad_line = string(wod_op)
                                  and lad_part = wod_part)
      then
         detail_all = yes.
      else
         detail_all = no.

      /* SET GLOBAL ITEM VARIABLE */
      global_part = wod_part.

      display
         wod_part
         wod_op
         desc1 desc2 wod_qty_req
         wod_bom_qty wod_bom_amt
         wod_qty_all wod_qty_pick wod_qty_iss detail_all wod_critical
         wod_iss_date wod_deliver wod_site wod_loc.

      assign
         prev_site = wod_site
         prev_bom_qty = wod_bom_qty.

      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      wod_part and
                         ptp_site = wod_site
      no-lock no-error.
      if available ptp_det then iss_pol = ptp_iss_pol.

      update
         wod_qty_req wod_qty_all wod_qty_pick
         detail_all
         wod_bom_qty wod_bom_amt
         wod_site wod_loc
         wod_critical wod_iss_date wod_deliver
      editing:

         assign
            global_site = input wod_site
            global_loc = input wod_loc.

         readkey.
         nextcomp = no.

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:

            if wod_qty_iss <> 0 or wod_mtl_totx <> 0
            then do:
               del-yn = no.
               {pxmsg.i &MSGNUM=529 &ERRORLEVEL=3}
               nextcomp = yes.
            end.

            else do:

               if wod_mtl_totx <> 0 or wod_mvrte_accr <> 0 or
                  wod_mvrte_post <> 0 or wod_mvrte_rval <> 0 or
                  wod_mvuse_accr <> 0 or wod_mvuse_post <> 0 or
                  wod_mvuse_rval <> 0 or wod_tot_std <> 0
               then do:
                  del-yn = no.
                  /* DELETE NOT ALLOWED, OUTSTANDING WIP VALUE FOR */
                  /* COMPONENT */
                  {pxmsg.i &MSGNUM=1459 &ERRORLEVEL=3}
                  nextcomp = yes.
               end.

               else do:
                  del-yn = yes.
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                  if del-yn then leave.
               end.

            end.

            if nextcomp then leave.

         end.
         else
            apply lastkey.

      end. /* EDITING */

      if iss_pol = no
         and index("AR",wo_status) > 0
         and wo_type = "R"
      then do:
         wod_qty_iss = wod_qty_req.
         display wod_qty_iss.
      end.

/* SS - 100907.1 - B */
      if wod_bom_qty = 0  then do:
          message "错误:单位用量不可为零,请重新输入" .
          next-prompt wod_bom_qty.
          undo,retry.
      end.

    if v_rep then do:
        /*新增替代料时,新增替代关系表*/
        {gprun.i ""xxbmsub001.p"" "(input wod_lot,input wod_nbr, input wod_part, input v_partold , input wod_bom_qty)"}
    end. /*if v_rep then*/
    else if wod__chr01 <> "" and prev_bom_qty <> wod_bom_qty then do:
        /*是替代料,且后来修改了单位用量,重算所有的替代关系表*/
        {gprun.i ""xxbmsub002.p"" "(input wod_lot,input wod_nbr, input wod_part, input wod_bom_qty)"}        
    end.
/* SS - 100907.1 - E */

      {gprun.i ""gpsiver.p"" "(input wod_site, input ?, output return_int)"}
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE ACCESS TO THIS SITE  */
         next-prompt wod_site with frame a.
         undo, retry.
      end.

      if del-yn
      then do:

         /* Work order components */
         {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

         {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
            ? wod_iss_date 0 "DEMAND" WORK_ORDER_COMPONENT wod_site}

         for each lad_det  where lad_det.lad_domain = global_domain and
         lad_dataset = "wod_det"
                            and lad_nbr = wod_lot
                            and lad_line = string(wod_op)
                            and lad_part = wod_part
         exclusive-lock:

            find ld_det  where ld_det.ld_domain = global_domain and  ld_site =
            lad_site
               and ld_loc = lad_loc and ld_lot = lad_lot
               and ld_part = lad_part and ld_ref = lad_ref
            exclusive-lock no-error.

            if available ld_det then
               ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).

            delete lad_det.

         end.

         clear frame a.

         find qad_wkfl exclusive-lock  where qad_wkfl.qad_domain =
         global_domain and  qad_key1 = "MFWORLA"
            and qad_key2 = wod_lot + wod_part + string(wod_op) no-error.

         if available qad_wkfl then delete qad_wkfl.

         /* WORK ORDER REQUIREMENT DELETED */
         {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
         del-yn = no.

         display
            wo_nbr
            wo_lot
            part
            wodesc1
            status_name
            wod_part
            wod_op
         with frame a.

         /* DELETE RELATED RECORDS THAT MAY EXIST */
         if wod_cmtindx <> 0 then do:
            for each cmt_det
                  exclusive-lock
                   where cmt_det.cmt_domain = global_domain and  cmt_indx =
                   wod_cmtindx:
               delete cmt_det.
            end.
         end.


        /* SS - 100907.1 - B */
        if wod__chr01 <> "" then do:  /*删除替代关系*/
            {gprun.i ""xxbmsub003.p"" "(input wod_lot,input wod_part)"}
        end. 
        /* SS - 100907.1 - E */

         delete wod_det.
         next comp-loop.
      end.
      else do:

         if prev_site <> wod_site then do:

            if can-find(first lad_det  where lad_det.lad_domain = global_domain
            and
               lad_dataset = "wod_det"
               and lad_nbr = wod_lot and lad_line = string(wod_op)
               and lad_part = wod_part)
            then do:

               /* SITE CHANGED, DELETING DETAIL ALLOCATIONS */
               {pxmsg.i &MSGNUM=4991 &ERRORLEVEL=2}

               for each lad_det
                   where lad_det.lad_domain = global_domain and  lad_dataset =
                   "wod_det"
                    and lad_nbr = wod_lot and lad_line = string(wod_op)
                    and lad_part = wod_part
               exclusive-lock:

                  find ld_det  where ld_det.ld_domain = global_domain and
                  ld_site = lad_site
                                and ld_loc = lad_loc
                                and ld_lot = lad_lot
                                and ld_part = lad_part
                                and ld_ref = lad_ref
                  exclusive-lock no-error.

                  if available ld_det then
                     ld_qty_all = ld_qty_all - lad_qty_all - lad_qty_pick.

                  delete lad_det.

               end.

            end.

            find in_mstr exclusive-lock  where in_mstr.in_domain =
            global_domain and  in_part = wod_part
               and in_site = wod_site no-error.
         end.

         assign
            totpkqty = 0
            totallqty = 0.

         for each lad_det  where lad_det.lad_domain = global_domain and
         lad_dataset = "wod_det"
            and lad_nbr = wod_lot and lad_line = string(wod_op)
            and lad_part = wod_part:
            assign
               totallqty = totallqty + lad_qty_all
               totpkqty = totpkqty + lad_qty_pick.
         end.

         if detail_all or (wod_qty_req entered
            and can-find(first lad_det  where lad_det.lad_domain =
            global_domain and  lad_dataset = "wod_det"
                                         and lad_nbr = wod_lot
                                         and lad_line = string(wod_op)
                                         and lad_part = wod_part))
         then do:
            wod_recno = recid(wod_det).
            {gprun.i ""wolcal.p""}
         end.

         assign
            totpkqty    =  max(totpkqty,  0)
            totallqty   =  max(totallqty, 0)
            wod_qty_all =  max(wod_qty_all, totallqty).

         if wod_qty_pick <> totpkqty then do:
            {pxmsg.i &MSGNUM=4993 &ERRORLEVEL=1}
            /* UPDATING LINE ITEM QUANTITY PICKED TO TOTAL LOT QUANTITY*/
            wod_qty_pick = totpkqty.
         end.

         if wod_qty_req > 0 then
            wod_qty_all = min(max(wod_qty_req - wod_qty_pick
                        - wod_qty_iss, 0), wod_qty_all).
         else
            wod_qty_all = 0.

         if not available in_mstr then do:
            find si_mstr  where si_mstr.si_domain = global_domain and  si_site
            = wod_site no-lock no-error.

            {gprun.i ""gpincr.p""
               "(input no,
                 input wod_part,
                 input wod_site,
                 input if available si_mstr then
                          si_gl_set
                       else """",
                 input if available si_mstr then
                          si_cur_set
                       else """",
                 input if available pt_mstr then
                          pt_abc
                       else """",
                 input if available pt_mstr then
                          pt_avg_int
                       else 0,
                 input if available pt_mstr then
                          pt_cyc_int
                       else 0,
                 input if available pt_mstr then
                          pt_rctpo_status
                       else """",
                 input if available pt_mstr then
                          pt_rctpo_active
                       else no,
                 input if available pt_mstr then
                          pt_rctwo_status
                       else """",
                 input if available pt_mstr then
                          pt_rctwo_active
                       else no,
                 output inrecno)" }

            find in_mstr where recid(in_mstr) = inrecno
            exclusive-lock.
         end.

         if available in_mstr then do:
            if wod_qty_req >= 0 then
               in_qty_req = in_qty_req + max(wod_qty_req - wod_qty_iss,0).
            else
               in_qty_req = in_qty_req + min(wod_qty_req - wod_qty_iss,0).
            in_qty_all = in_qty_all + (wod_qty_all + wod_qty_pick).
         end.

         find qad_wkfl exclusive-lock  where qad_wkfl.qad_domain =
         global_domain and  qad_key1 = "MFWORLA"
            and qad_key2 = wod_lot + wod_part + string(wod_op) no-error.

         if not available qad_wkfl then do:
            create qad_wkfl.  qad_wkfl.qad_domain = global_domain.
            assign
               qad_key1 = "MFWORLA"
               qad_key2 = wod_lot + wod_part + string(wod_op)
               qad_decfld[1] = wod_bom_qty
               qad_decfld[2] = 1.
         end.

         else
         if wod_bom_qty <> prev_bom_qty
         or qad_decfld[1] = ?
         then do:
            if qad_decfld[2] = 0 or qad_decfld[2] = ? then
               qad_decfld[2] = 1.
            qad_decfld[1] = wod_bom_qty * qad_decfld[2].
         end.

         /* UPDATE MRP_DET WORK ORDER COMPONENTS */
         if wod_qty_req >= 0 then
            open_ref = max(wod_qty_req - max(wod_qty_iss,0),0).
         else
            open_ref = min(wod_qty_req - min(wod_qty_iss,0),0).

         {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

         {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
            ? wod_iss_date open_ref "DEMAND" WORK_ORDER_COMPONENT
            wod_site}
      end.
/* SS - 100907.1 - B */
    end. /*detail-loop*/
/* SS - 100907.1 - E */

      release wod_det.

   end. /*comp-loop:*/

end. /*mainloop:*/

status input.
