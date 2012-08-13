/* mfworlb.i - PRINT PICKLISTS                                          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0     LAST MODIFIED: 05/06/86    BY: EMB                 */
/* REVISION: 1.0     LAST MODIFIED: 09/02/86    BY: EMB *12*            */
/* REVISION: 1.0     LAST MODIFIED: 02/05/87    BY: EMB *35*            */
/* REVISION: 2.0     LAST MODIFIED: 07/24/87    BY: EMB *A75*           */
/* REVISION: 2.0     LAST MODIFIED: 09/03/87    BY: EMB *A88*           */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: WUG *A94*           */
/* REVISION: 4.0     LAST MODIFIED: 01/29/88    BY: PML *A119*          */
/* REVISION: 4.0     LAST MODIFIED: 06/08/88    BY: FLM *A268*          */
/* REVISION: 4.0     LAST MODIFIED: 06/16/88    BY: EMB *A288*          */
/* REVISION: 4.0     LAST MODIFIED: 07/15/88    BY: WUG *A324*          */
/* REVISION: 4.0     LAST MODIFIED: 07/26/88    BY: WUG *A363*          */
/* REVISION: 4.0     LAST MODIFIED: 09/22/88    BY: EMB *A451*          */
/* REVISION: 4.0     LAST MODIFIED: 11/18/88    BY: EMB *A539*          */
/* REVISION: 4.0     LAST MODIFIED: 12/13/88    BY: RL  *B001*          */
/* REVISION: 4.0     LAST MODIFIED: 03/16/89    BY: MLB *A672*          */
/* REVISION: 4.0     LAST MODIFIED: 01/22/90    BY: EMB *A802*          */
/* REVISION: 6.0     LAST MODIFIED: 05/03/90    BY: MLB *D024*          */
/* REVISION: 6.0     LAST MODIFIED: 07/03/90    BY: WUG *D043*          */
/* REVISION: 6.0     LAST MODIFIED: 07/31/90    BY: WUG *D051*          */
/* REVISION: 6.0     LAST MODIFIED: 07/31/90    BY: WUG *D054*          */
/* REVISION: 6.0     LAST MODIFIED: 04/09/91    BY: RAM *D508*          */
/* REVISION: 6.0     LAST MODIFIED: 04/16/91    BY: RAM *D530*          */
/* REVISION: 6.0     LAST MODIFIED: 10/05/91    BY: SMM *D887*          */
/* REVISION: 7.0     LAST MODIFIED: 04/01/92    BY: ram *F351*          */
/* REVISION: 7.0     LAST MODIFIED: 08/18/92    BY: ram *F858*          */
/* REVISION: 7.3     LAST MODIFIED: 02/03/93    BY: emb *G656*          */
/* REVISION: 7.3     LAST MODIFIED: 04/29/93    BY: ksp *GA63*          */
/* Oracle changes (share-locks)    09/12/94           BY: rwl *FR19*    */
/* REVISION: 7.5     LAST MODIFIED: 10/14/94    BY: TAF *J035*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/28/98   BY: *J330* Mugdha Tambe */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworlb_i_1 "WORK ORDER PICKLIST"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_2 "Work Order Due Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_3 "Site!Location"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_4 "Quantity"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_5 "Required!Qty to Issue"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_6 "Rv"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_7 "Rev"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_8 "*** Cont ***"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_9 "Lot/Serial!Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_10 " Issued"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_11 "Floor Stock"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_12 "Not Available:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable description like pt_desc1.
     define variable um like pt_um.
     define variable loc like pt_loc.
     define variable issued as character initial "(      )"
        label {&mfworlb_i_10}.
     define variable com_rev like pt_rev label {&mfworlb_i_6}.
     define workfile floorstk no-undo
        field fs_part as character label {&mfworlb_i_11} format "x(28)"
        field fs_qty like wod_qty_req.
     define variable issue-date like wod_iss_date.
     define new shared variable wod_recno as recid.
/*GA63*/ define new shared variable fas_unit_qty as character.
/*F351*/ define variable qtyall like lad_qty_all.
/*F351*/ {mfworlb1.i &row="1"}

     form
        skip (1)
        wo_nbr         colon 13
        wod_iss_date   colon 68
        wo_lot         colon 13
/*J035*/    wo_batch       colon 13
        wo_part        colon 13
        par_rev        colon 40 label {&mfworlb_i_7}
            wo_due_date    colon 68 label {&mfworlb_i_2} skip
        wo_des         no-label format "x(49)" at 15
        wo_rmks        colon 13
        wo_so_job      colon 68
        wo_qty         colon 13
        wo_um          no-label
        deliv          colon 68 skip (1)
     with frame picklist page-top side-labels no-attr-space width 80
     title (getFrameTitle("WORK_ORDER_PICKLIST",25)).

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame picklist:handle).

/*GA63*/ /* Read control file for configured product unit control flag */
     do transaction:
        fas_unit_qty = string(false).      /*DEFAULT VALUE*/
        find first fac_ctrl no-lock no-error.
        if available fac_ctrl then fas_unit_qty = string(fac_unit_qty).
     end.
/*GA63*/ /* End of added section */

     find pt_mstr where pt_part = wo_part no-lock no-error.
     wo_des = "".
     wo_um = "".
     par_rev = "".
     if available pt_mstr then do:
        wo_des = pt_desc1.
        wo_des = wo_des + " " + pt_desc2.
        wo_um = pt_um.

/*J330** par_rev = pt_rev.  */

/*J330*/  /*  REVISION NUMBER IS DISPLAYED FROM PTP_DET TO GET LATEST  */
/*J330*/  /*  MODIFIED REVISION NUMBER                                 */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb                */

/*J330*/          for  first ptp_det
/*J330*/              where ptp_part = wo_part
/*J330*/              and   ptp_site = wo_site
/*J330*/              no-lock:
/*J330*/          end. /* FOR FIRST PTP_DET */

/*J330*/ if available ptp_det then assign par_rev = ptp_rev .
/*J330*/ else assign par_rev =  pt_rev .

     end.

     issue-date = ?.

     for each wod_det where wod_lot = wo_lot no-lock:
        if issue-date = ? or issue-date > wod_iss_date then
           issue-date = wod_iss_date.
/*F351*/    if incl_floor_stk then do:
           find pt_mstr where pt_part = wod_part no-lock no-error.
           find ptp_det where ptp_part = wod_part and ptp_site = wod_site
           no-lock no-error.
           if (available ptp_det and ptp_iss_pol = no)
           or (not available ptp_det
           and available pt_mstr and pt_iss_pol = no)
           then do:
          find last floorstk
          where fs_part < wod_part no-error.
          create floorstk.
          fs_part = wod_part.
          fs_qty = wod_qty_req.
           end.
/*F351*/    end.
     end.

/*FR19*/ for each wod_det exclusive-lock where wod_lot = wo_lot
/*F351   and (wod_qty_req = 0 or wod_qty_all <> 0  */
/*F351   or max(wod_qty_req - wod_qty_iss,0) > 0)  */
/*F351*/ and ((wod_qty_req = 0 and incl_zero_reqd)
/*F351*/ or wod_qty_all <> 0
/*F351*/ or (wod_qty_pick <> 0 and incl_pick_qtys)
/*F351*/ or (max(wod_qty_req - wod_qty_iss,0) = 0 and incl_zero_open)
/*F351*/ or (max(wod_qty_req - wod_qty_iss,0) > 0 and wod_qty_all <> 0))
     break by wod_lot by wod_iss_date by wod_part
     with frame detail no-box down:

        picklistprinted = yes.

        if first-of(wod_iss_date) then do:
           hide frame picklist.
           page.
           display wod_iss_date with frame picklist.
        end.

        if first-of(wod_lot) then do:
           display wo_nbr wo_lot
/*J035*/       wo_batch
           wo_part
           par_rev
           wod_iss_date
           wo_due_date wo_des wo_rmks wo_so_job
           wo_qty wo_um deliv with frame picklist.

           for each sod_det where sod_nbr = wo_so_job no-lock:
          if sod_fa_nbr = wo_nbr and sod_lot = wo_lot then do:
             {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
          end.
/*GA63*/          else if sod_fa_nbr = wo_nbr and sod_lot = "" and
/*GA63*/             fas_unit_qty = string(true) then do:
/*GA63*/             find pt_mstr where pt_part = sod_part no-lock no-error.
/*GA63*/             if available pt_mstr and pt_lot_ser = "S" then do:
/*GA63*/                {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
/*GA63*/             end.
/*GA63*/          end.
           end.

        end.
        else view frame picklist.

        /*DISPLAY COMMENTS */
        if first-of(wod_iss_date) then do:
           {gpcmtprt.i &type=RP &id=wo_cmtindx &pos=3}
        end.

        um = "".
        loc = "".
        com_rev = "".
        loc = wod_loc.
/*G656*     description = "Item Not in Inventory". */
/*G656*/    description = "".
        find pt_mstr where pt_part = wod_part no-lock no-error.
        find ptp_det where ptp_part = wod_part and ptp_site = wod_site
        no-lock no-error.
        if (available ptp_det and ptp_iss_pol = no)
        or (not available ptp_det
        and available pt_mstr and pt_iss_pol = no) then next.

        if available pt_mstr then do:
           um = pt_um.
           if loc = "" then
           loc = pt_loc.
           description = pt_desc1.
           description = description + " " + pt_desc2.

/*J330*/   if available ptp_det then assign com_rev = ptp_rev .
/*J330*/   else assign com_rev = pt_rev .

/*J330**   com_rev = pt_rev.   */

        end.

        if page-size - line-counter < 4 then page.

        /* SET EXTERNAL LABELS */
        setFrameLabels(frame detail:handle).
        display
           wod_part
           com_rev
/*F351         wod_site @ lad_loc */
/*F351*/       wod_site @ lad_loc column-label {&mfworlb_i_3}
           "" @ lad_lot column-label {&mfworlb_i_9}
           MIN(wod_qty_req - wod_qty_iss,0) @ wod_qty_all
          column-label {&mfworlb_i_5}
           um
           "" @ issued
        with frame detail width 80 no-attr-space.

        down 1 with frame detail.
        if available pt_mstr and pt_desc1 <> "" then do:
           if page-size - line-counter < 1 then do:
          page.
          /*DISPLAY CONTINUED*/
          display wod_part {&mfworlb_i_8}
          @ lad_lot with frame detail.
          down 1 with frame detail.
           end.
           put space(3) pt_desc1 skip.
        end.
        if available pt_mstr and pt_desc2 <> "" then do:
           if page-size - line-counter < 1 then do:
          page.
          /*DISPLAY CONTINUED*/
          display wod_part {&mfworlb_i_8}
          @ lad_lot with frame detail.
          down 1 with frame detail.
           end.
           put space(3) pt_desc2 skip.
        end.

        /*DISPLAY ALLOCATION DETAIL*/
        for each lad_det where lad_dataset = "wod_det"
/*G656*     and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/    and lad_nbr = wod_lot and lad_line = string(wod_op)
        and lad_part = wod_part with frame detail:
           find ld_det where ld_site = lad_site and ld_loc = lad_loc
           and ld_part = lad_part and ld_lot = lad_lot and ld_ref = lad_ref
           no-lock no-error.

           accumulate lad_qty_all (total).
           if page-size - line-counter < 1 then do:
          page.
          /*DISPLAY CONTINUED*/
          display wod_part {&mfworlb_i_8}
          @ lad_lot with frame detail.
          down 1 with frame detail.
           end.

/*F351         display lad_loc lad_lot lad_qty_all @ wod_qty_all  */
/*F351            issued                                          */
/*F351         with frame detail.                                 */
/*F351*/       if incl_pick_qtys then
/*F351*/          qtyall = lad_qty_all + lad_qty_pick.
/*F351*/       else
/*F351*/          qtyall = lad_qty_all.
/*F351*/       display
/*F351*/          lad_loc
/*F351*/          lad_lot
/*F351*/          qtyall @ wod_qty_all
/*F351*/          issued
/*F351*/       with frame detail.

           down 1 with frame detail.
           display lad_ref @ lad_lot with frame detail.
           if available ld_det and ld_expire <> ? then do:
          display ld_expire @ lad_loc  with frame detail.
           end.

           down 1 with frame detail.

           /*IF QTY OH - QTY ALL TO OTHER ORDERS < QTY ALL TO THIS ORDER*/
           if not available ld_det
           or ld_qty_oh - ld_qty_all + lad_qty_all < lad_qty_all then do:
          if page-size - line-counter < 1 then do:
             page.
             /*DISPLAY CONTINUED*/
             display wod_part {&mfworlb_i_8}
             @ lad_lot with frame detail.
             down 1 with frame detail.
          end.
          find msg_mstr where msg_lang = global_user_lang
          and msg_nbr = 4992 no-lock no-error.
          if available msg_mstr then put msg_desc at 20 skip.
          /*Quantity not available at this location*/
           end.

           /*UPDATE QTY PICKED*/
           lad_qty_pick = lad_qty_pick + lad_qty_all.
           lad_qty_all = 0.

        end.
        if wod_qty_all > accum total(lad_qty_all)
        then do with frame detail:
           if page-size - line-counter < 1 then do:
          page.
          /*DISPLAY CONTINUED*/
          display wod_part {&mfworlb_i_8}
          @ lad_lot with frame detail.
          down 1 with frame detail.
           end.

           display
/*F351*/          "      ********" @ wod_part
          {&mfworlb_i_4} @ lad_loc {&mfworlb_i_12} @ lad_lot
          wod_qty_all - accum total (lad_qty_all) @ wod_qty_all
/*F351*/          "********" @ issued
           with frame detail.

        end.

        put skip(1).

        wod_qty_pick = wod_qty_pick + accum total(lad_qty_all).
        wod_qty_all = wod_qty_all - accum total(lad_qty_all).

     end. /*FOR EACH*/

/*F351*/ if incl_floor_stk then do:
        find first floorstk no-error.
        if available floorstk then do:
           if picklistprinted = no then do:
          hide frame picklist.
          page.

          display wo_nbr wo_lot
/*J035*/          wo_batch
          wo_part
          par_rev
          wo_due_date
          issue-date @ wod_iss_date
          wo_des wo_rmks wo_so_job
          wo_qty wo_um deliv with frame picklist.

          for each sod_det where sod_nbr = wo_so_job no-lock:
             if sod_fa_nbr = wo_nbr and sod_lot = wo_lot then do:
            {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
             end.
          end.

/*F858*/          /* DISPLAY COMMENTS */
/*F858*/          {gpcmtprt.i &type=RP &id=wo_cmtindx &pos=3}

          picklistprinted = yes.
           end. /*if picklistprinted = no.*/
           display skip(1) with frame floorstk1.
        end.
        if available floorstk then
        for each floorstk with frame floorstk
        width 80 no-attr-space down:
           find pt_mstr where pt_part = fs_part no-lock no-error.
           if (pt_desc1 <> "" or pt_desc2 <> "")
           and (page-size - line-counter < 2) then page.
           else if (pt_desc1 <> "" and pt_desc2 <> "")
           and (page-size - line-counter < 3) then page.
           /* SET EXTERNAL LABELS */
           setFrameLabels(frame floorstk:handle).
           display space(3) fs_part fs_qty pt_um.
           if pt_desc1 <> "" then down 1.
           if pt_desc1 <> "" then display "   " + pt_desc1 @ fs_part.
           if pt_desc2 <> "" then down 1.
           if pt_desc2 <> "" then display "   " + pt_desc2 @ fs_part.
           delete floorstk.
        end.
/*F351*/ end.

     page.
     hide frame picklist.
