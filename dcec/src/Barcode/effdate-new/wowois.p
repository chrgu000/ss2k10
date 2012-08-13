/* wowois.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0     LAST MODIFIED: 07/28/86    BY: pml                 */
/* REVISION: 1.0     LAST MODIFIED: 06/30/86    BY: emb                 */
/* REVISION: 1.0     LAST MODIFIED: 10/30/86    BY: emb *39*            */
/* REVISION: 1.0     LAST MODIFIED: 03/03/87    BY: emb *A25*           */
/* REVISION: 1.0     LAST MODIFIED: 02/13/87    BY: pml *A26*           */
/* REVISION: 2.0     LAST MODIFIED: 03/20/87    BY: emb *A45*           */
/* REVISION: 2.1     LAST MODIFIED: 06/15/87    BY: wug *A66*           */
/* REVISION: 2.1     LAST MODIFIED: 11/20/87    BY: emb *A75*           */
/* REVISION: 2.1     LAST MODIFIED: 07/23/87    BY: wug *A77*           */
/* REVISION: 2.1     LAST MODIFIED: 08/31/87    BY: wug *A94*           */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*           */
/* REVISION: 2.1     LAST MODIFIED: 11/04/87    BY: wug *A102*          */
/* REVISION: 2.1     LAST MODIFIED: 01/18/88    BY: wug *A151*          */
/* REVISION: 4.0     LAST MODIFIED: 02/01/88    BY: emb *A170*          */
/* REVISION: 4.0     LAST MODIFIED: 02/29/88    BY: flm *A179*          */
/* REVISION: 4.0     LAST MODIFIED: 03/14/88    BY: rl  *A171*          */
/* REVISION: 4.0     LAST MODIFIED: 03/28/88    BY: wug *A187*          */
/* REVISION: 4.0     LAST MODIFIED: 07/25/88    BY: wug *A360*          */
/* REVISION: 4.0     LAST MODIFIED: 08/31/88    BY: flm *A417*          */
/* REVISION: 4.0     LAST MODIFIED: 02/09/89    BY: emb *A643*          */
/* REVISION: 5.0     LAST MODIFIED: 06/22/89    BY: rl  *B157*          */
/* REVISION: 5.0     LAST MODIFIED: 06/23/89    BY: mlb *B159*          */
/* REVISION: 5.0     LAST MODIFIED: 07/06/89    BY: wug *B175*          */
/* REVISION: 5.0     LAST MODIFIED: 07/07/89    BY: wug *B176*          */
/* REVISION: 5.0     LAST MODIFIED: 01/22/90    BY: wug *B515*          */
/* REVISION: 5.0     LAST MODIFIED: 02/26/90    BY: emb *B589*          */
/* REVISION: 5.0     LAST MODIFIED: 04/13/90    BY: emb *B664*          */
/* REVISION: 5.0     LAST MODIFIED: 07/19/90    BY: emb *B734*          */
/* REVISION: 6.0     LAST MODIFIED: 03/14/90    BY: emb *D002*          */
/* REVISION: 6.0     LAST MODIFIED: 04/20/90    BY: wug *D002*          */
/* REVISION: 6.0     LAST MODIFIED: 05/07/90    BY: mlb *D024*          */
/* REVISION: 6.0     LAST MODIFIED: 06/26/90    BY: emb *D024*          */
/* REVISION: 6.0     LAST MODIFIED: 05/11/90    BY: emb *D025*          */
/* REVISION: 6.0     LAST MODIFIED: 12/11/90    BY: emb *D242*          */
/* REVISION: 6.0     LAST MODIFIED: 12/17/90    BY: wug *D619*          */
/* REVISION: 6.0     LAST MODIFIED: 09/12/91    BY: wug *D858*          */
/* REVISION: 6.0     LAST MODIFIED: 10/02/91    BY: emb *D886*          */
/* REVISION: 6.0     LAST MODIFIED: 10/07/91    BY: alb *D887*          */
/* REVISION: 7.0     LAST MODIFIED: 10/16/91    BY: pma *F003*          */
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: wug *D920*          */
/* REVISION: 6.0     LAST MODIFIED: 11/29/91    BY: ram *D954*          */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*          */
/* REVISION: 7.3     LAST MODIFIED: 09/30/92    BY: ram *G115*          */
/* REVISION: 7.3     LAST MODIFIED: 10/21/92    BY: emb *G216*          */
/* REVISION: 7.3     LAST MODIFIED: 10/22/92    BY: emb *G223*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G247*          */
/* REVISION: 7.3     LAST MODIFIED: 01/08/93    BY: emb *G527*          */
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: emb *G656*          */
/* REVISION: 7.3     LAST MODIFIED: 03/04/93    BY: ram *G782*          */
/* REVISION: 7.3     LAST MODIFIED: 03/25/93    BY: emb *G872*          */
/* REVISION: 7.3     LAST MODIFIED: 04/21/93    BY: pma *GA01*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 09/01/93    BY: emb *GE69*          */
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039*          */
/* REVISION: 7.4     LAST MODIFIED: 11/10/93    BY: ais *H216*          */
/* REVISION: 7.4     LAST MODIFIED: 12/21/93    BY: pxd *GI21*          */
/* REVISION: 7.4     LAST MODIFIED: 04/11/94    BY: ais *GJ31*          */
/* REVISION: 7.4     LAST MODIFIED: 05/18/94    BY: ais *FO22*          */
/* REVISION: 7.4     LAST MODIFIED: 07/26/94    BY: emb *FP55*          */
/* REVISION: 7.4     LAST MODIFIED: 08/12/94    BY: pxd *GL28*          */
/* REVISION: 7.4     LAST MODIFIED: 08/12/94    BY: pxd *FQ74*          */
/* REVISION: 7.4     LAST MODIFIED: 09/12/94    by: slm *GM61*          */
/* REVISION: 7.4     LAST MODIFIED: 09/19/94    by: pxd *FR60*          */
/* REVISION: 7.4     LAST MODIFIED: 09/22/94    by: jpm *GM78*          */
/* REVISION: 7.4     LAST MODIFIED: 09/27/94    by: emb *GM78*          */
/* REVISION: 7.4     LAST MODIFIED: 09/30/94    by: pxd *FR98*          */
/* REVISION: 8.5     LAST MODIFIED: 10/02/94    by: dzs *J046*          */
/* REVISION: 7.4     LAST MODIFIED: 10/06/94    by: pxd *FS17*          */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    by: WUG *GN76*          */
/* REVISION: 7.4     LAST MODIFIED: 11/11/94    by: rwl *GO34*          */
/* REVISION: 8.5     LAST MODIFIED: 11/21/94    by: tmf *J040*          */
/* REVISION: 8.5     LAST MODIFIED: 12/08/94    by: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    by: taf *J038*          */
/* REVISION: 8.5     LAST MODIFIED: 12/27/94    by: ktn *J041*          */
/* REVISION: 7.4     LAST MODIFIED: 01/30/95    by: pxe *F0FQ*          */
/* REVISION: 8.5     LAST MODIFIED: 03/24/95    by: tjs *J046*          */
/* REVISION: 8.5     LAST MODIFIED: 04/18/95    by: sxb *J04D*          */
/* REVISION: 8.5     LAST MODIFIED: 07/24/95    by: tjs *J060*          */
/* REVISION: 8.5     LAST MODIFIED: 09/14/95    by: kxn *J07X*          */
/* REVISION: 7.4     LAST MODIFIED: 09/28/95    by: str *F0VL*          */
/* REVISION: 7.3     LAST MODIFIED: 11/01/95    by: ais *G0V9*          */
/* REVISION: 7.3     LAST MODIFIED: 08/24/95    by: dzs *G0SY*          */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*          */
/* REVISION: 8.5     LAST MODIFIED: 04/11/96    BY: *J04C* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 04/11/96    BY: *J04C* Markus Barone      */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: *G1MN*  Julie Milligan    */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: bjl *K001*          */
/* REVISION: 8.5     LAST MODIFIED: 07/31/96    BY: *J137* Sue Poland         */
/* REVISION: 8.6     LAST MODIFIED: 03/14/97    BY: *G2JJ* Murli Shastri      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 07/17/00   BY: *M0PQ* falguni Dalal      */
/******************************************************************************/
/*J040*/  /*DISPLAY TITLE */
/*J040*/  {mfdtitle.i "0+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowois_p_1 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowois_p_2 "发放"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowois_p_3 "包括备料量"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowois_p_4 "包括领料量"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowois_p_5 "工序"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowois_p_6 "发放代用品"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowois_p_7 "生效日期"
/* ********** End Translatable Strings Definitions ********* */


/*K001*/  {gldydef.i new}
/*K001*/  {gldynrm.i new}

         define new shared variable part like wod_part .
         define variable fill_all like mfc_logical
            label {&wowois_p_3} initial no.
         define variable fill_pick like mfc_logical
            label {&wowois_p_4} initial yes.
         define variable nbr like wo_nbr .
/*H216*  define variable qopen like wod_qty_all label "Qty Open".     */
/*G1MN /*H216*/ define variable qopen like wod_qty_all column-label
            "Qty Open". */
         define variable yn like mfc_logical.
         define new shared variable eff_date like glt_effdate LABEL "生效日期".
/*G1MN*         define variable ref like glt_ref. */
         define variable desc1 like pt_desc1.
/*G1MN*         define variable i as integer. */
/*G1MN*         define variable trqty like tr_qty_chg. */
/*G1MN*         define variable trlot like tr_lot. */
/*G1MN*         define variable qty_left like tr_qty_chg. */
         define new shared variable wopart_wip_acct like pl_wip_acct.
         define new shared variable wopart_wip_cc like pl_wip_cc.
         define variable del-yn like mfc_logical initial no.
/*G1MN*         define variable j as integer. */
/*       define shared variable mfguser as character.           *G247* */
         define new shared variable wo_recno as recid.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotref like sr_ref format "x(8)" no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
      /* define new shared variable multi_entry as logical              **M0PQ*/
         define new shared variable multi_entry like mfc_logical        /*M0PQ*/
            label {&wowois_p_1}
            no-undo.
         define new shared variable lotserial_control as character.
         define new shared variable cline as character.
         define new shared variable row_nbr as integer.
         define new shared variable col_nbr as integer.
         define new shared variable issue_or_receipt as character
            initial {&wowois_p_2}.
         define new shared variable total_lotserial_qty like wod_qty_chg.
         define new shared variable trans_um like pt_um.
         define new shared variable trans_conv like sod_um_conv.
         define new shared variable transtype as character initial "ISS-WO".
         define new shared variable wo_recid as recid.
         define variable tot_lad_all like lad_qty_all.
         define variable ladqtychg like lad_qty_all.

         define variable sub_comp like mfc_logical label {&wowois_p_6}.
         define new shared variable wod_recno as recid.
         define variable firstpass like mfc_logical.
/*G1MN*         define variable cancel_bo as logical label "Cancel B/O". */

         define variable undo-input like mfc_logical.
/*G1MN* /*G656*/ define variable op like wod_op. */
/*G656*/ define variable wo-op like wod_op label {&wowois_p_5}.
/*G1MN* /*G656*/ define buffer woddet for wod_det. */
/*G1MN* /*G872*/ define variable msg-counter as integer no-undo. */
/*G2JJ*/ define variable msg-counter as integer no-undo.
/*J046*/ define variable base like mfc_logical initial no.
/*J046*/ define variable base_id like wo_base_id.
/*J046*/ define variable parent_lot like wo_lot.
/*J046*/ define variable jp like mfc_logical initial no.

/*J040*/ define variable wolot like wo_lot .
/*J040*/ define variable issue_component like mfc_logical.
/*J041*/ define new shared variable lotnext like wo_lot_next .
/*J041*/ define new shared variable lotprcpt like wo_lot_rcpt no-undo.

/*G1MN* /*H039*/ {gpglefdf.i} */
/*G1MN*/ {gpglefv.i}


         /* INPUT OPTION FORM */
         form
            wo_nbr LABEL "工单号"  colon 12 wo_lot  colon 36 
/*G656*/                            wo-op      colon 50 

                                             eff_date    colon 68 LABEL {&wowois_p_7}
            wo_part LABEL "零件号"   colon 12 wo_status LABEL " 状态"   fill_all    colon 68
            desc1       at 14 no-label       fill_pick   colon 68
         with frame a THREE-D side-labels width 80 attr-space.

/*G1MN* * * BEGIN DELETED SECTION * * * MOVED TO wowoisc.p * * *
.         form with frame c 5 down no-attr-space width 80.
.
.         form
.            part           colon 13
./*G656*/    op label "Op"
./*G656*     pt_um */
.            site           colon 53
.            location       colon 68   label "Loc"
.            pt_desc1       colon 13
.            lotserial      colon 53
.            lotserial_qty  colon 13
./*G656*/    pt_um          colon 31
.            lotref         colon 53
.            sub_comp       colon 13
.            cancel_bo
./*G656*/                   colon 31
.            multi_entry    colon 53
.         with frame d side-labels width 80 attr-space.
**G1MN * * * END DELETE SECTION */

/*K001*/  if daybooks-in-use then
/*K001*/     {gprun.i ""nrm.p"" "persistent set h-nrm"}.

/*J04D*/ find first clc_ctrl no-lock no-error.
/*J060*/ if not available clc_ctrl then do:
/*J060*/    {gprun.i ""gpclccrt.p""}
/*J060*/    find first clc_ctrl no-lock no-error.
/*J060*/ end.
         eff_date = today.

         /* DISPLAY */
         mainloop:
         repeat:
/*F0VL*/    part = "".
            nbr = "".
            display eff_date fill_all fill_pick with frame a.
            prompt-for wo_nbr wo_lot
/*G656*/    wo-op
             fill_all fill_pick
            with frame a editing:
               if frame-field = "wo_nbr" then do:
                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i wo_mstr wo_nbr wo_nbr wo_nbr wo_nbr wo_nbr}
                  if recno <> ? then do:
/*G872*/             nbr = wo_nbr.
                     desc1 = "".
                     find pt_mstr where pt_part = wo_part
                     no-lock no-error.
                     if available pt_mstr then desc1 = pt_desc1.
                     display wo_nbr wo_lot wo_part wo_status desc1
                     with frame a.
                  end.
/*J040*/          else do:
/*J040*/            nbr = input wo_nbr.
/*J040*/          end.
               end.
               else if frame-field = "wo_lot" then do:

                  /* FIND NEXT/PREVIOUS RECORD */


/*FQ74            if nbr > "" then do:                                       */
/*FQ74               {mfnp01.i wo_mstr wo_lot wo_lot nbr wo_nbr wo_nbr}      */
/*FQ74            end.                                                       */
/*FQ74            else do:                                                   */
/*FQ74               {mfnp.i wo_mstr wo_lot wo_lot wo_lot wo_lot wo_lot}     */
/*FQ74            end.                                                       */

/*FQ74*/          if input wo_nbr =  "" then do:
/*FQ74*/             {mfnp01.i wo_mstr wo_lot wo_lot wo_nbr wo_nbr wo_lot}
/*FQ74*/          end.
/*FQ74*/          else do:
/*FQ74*/             nbr = input wo_nbr.
/*FQ74*/            {mfnp01.i wo_mstr wo_lot wo_lot nbr wo_nbr wo_nbr}
/*FQ74*/          end.

                  if recno <> ? then do:
                     desc1 = "".
/*J040*/             wolot = wo_lot.
                     find pt_mstr where pt_part = wo_part
                     no-lock no-error.
                     if available pt_mstr then desc1 = pt_desc1.
                     display wo_nbr wo_lot wo_part wo_status desc1
                     with frame a.
                  end.
               end.
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.
            end.

            assign
/*G656*/    wo-op
            eff_date fill_all fill_pick.
            if eff_date = ? then eff_date = today.

            /* CHECK EFFECTIVE DATE */
/*H039*     {mfglef.i eff_date} */
/*G1MN* /*H039*/    {gpglef.i ""IC"" glentity eff_date} */

            nbr = input wo_nbr.
            if input wo_nbr <> "" then
            if not can-find(first wo_mstr using wo_nbr)
            then do:
               {mfmsg.i 503 3}
               undo, retry.
            end.

            if nbr = "" and input wo_lot = "" then undo, retry.
            if nbr <> "" and input wo_lot <> "" then
            find wo_mstr
/*G872*/    no-lock
            where wo_nbr = nbr using wo_lot no-error.
            if nbr = "" and input wo_lot <> "" then
            find wo_mstr
/*G872*/    no-lock
            using wo_lot no-error.
            if nbr <> "" and input wo_lot = "" then
            find first wo_mstr
/*G872*/    no-lock
            where wo_nbr = nbr no-error.
            if not available wo_mstr then do:
               {mfmsg.i 510 3}
               /*  WORK ORDER DOES NOT EXIST.*/
               undo, retry.
            end.
            /*VALIDATE THE GL EFFECTIVE DATE */
/*G1MN*/    find si_mstr where si_site = wo_site no-lock.
/*G1MN*/    {gpglef1.i &module = ""WO""
                     &entity = si_entity
                     &date = eff_date
                     &prompt = "eff_date"
                     &frame = "a"
                     &loop = "mainloop"
                     }

/*J040*/    if input wo_lot <> "" then do:
/*J040*/       wolot = input wo_lot.
/*J040*/    end.
/*J040*/    else do:
/*J040*/       wolot = wo_lot.
/*J040*/    end.

            if lookup(wo_status,"A,R") = 0 then do:
/*FS17         {mfmsg.i 523 3}    */
/*FS17*/       {mfmsg.i 541 3}
               /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
               {mfmsg02.i 525 1 wo_status}
               /* CURRENT WORK ORDER STATUS: */
               undo, retry.
            end.

            /* DON'T ALLOW CALL ACTIVITY RECORDING WORK ORDERS */
/*J04C*/    if wo_fsm_type = "FSM-RO" then do:
/*J04C*/        {mfmsg.i 7492 3}    /* FIELD SERVICE CONTROLLED */
/*J04C*/        undo, retry.
/*J04C*/    end.

            /*GN76 ADDED FOLLOWING SECTION*/
            if wo_type = "c" and wo_nbr = "" then do:
               {mfmsg.i 5123 3}
               undo, retry.
            end.
            /*GN76 END SECTION*/

/*J034*/    {gprun.i ""gpsiver.p""
             "(input wo_site, input ?, output return_int)"}
/*J034*/    if return_int = 0 then do:
/*J034*/       {mfmsg02.i 2710 3 wo_site}  /* USER DOES NOT HAVE  */
/*J034*/                                   /* ACCESS TO SITE XXXX */
/*J034*/       undo mainloop, retry.
/*J034*/    end.

/*J046*/    /* BASE PROCESS WORK ORDER PROCESSING FOR JOINT PRODUCTS  */
/*J046*/    if wo_joint_type <> "" then do:
/*J046*/       jp = yes. /* This is Joint Product/Base Work Order */
/*J046*/       if wo_joint_type = "5" then base = yes.
/*J046*/       else do:
/*J046*/          base = no.
/*J046*/          base_id = wo_base_id.
/*J046*/          parent_lot = wo_base_id.
/*J046*/          find wo_mstr where wo_lot = base_id no-lock no-error.
/*J046*/          if not available wo_mstr then do:
/*J046*/             /* Base Process Work Order not available */
/*J046*/             {mfmsg.i 6530 1}.
/*J046*/             undo, retry.
/*J046*/          end.
/*J046*/       end.
/*J046*/    end.

            wopart_wip_acct = wo_acct.
            wopart_wip_cc = wo_cc.
/*G872*/    wo_recno = recid(wo_mstr).

            desc1 = "".
            find pt_mstr where pt_part = wo_part no-lock no-error.
            if available pt_mstr then do:
               desc1 = pt_desc1.
               find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
               if available(pl_mstr) and wopart_wip_acct = "" then do:
                  wopart_wip_acct = pl_wip_acct.
                  wopart_wip_cc = pl_wip_cc.
               end.
            end.

/*J046*/    if not base and jp then do:
/*J046*/       find wo_mstr where wo_lot = parent_lot no-lock no-error.
/*J046*/       find pt_mstr where pt_part = wo_part no-lock no-error.
/*J046*/       if available pt_mstr then desc1 = pt_desc1.
/*J046*/    end.

            display wo_nbr wo_part wo_lot wo_status desc1 with frame a.
            if eff_date = ? then eff_date = today.

            wopart_wip_acct = wo_acct.
            wopart_wip_cc = wo_cc.
/*G872*/    wo_recno = recid(wo_mstr).

/*G2JJ*     ** BEGIN ADD SECTION **/
        {gplock.i
             &file-name=wo_mstr
             &find-criteria="recid(wo_mstr) = wo_recno"
             &exit-allowed=yes
             &record-id=recno}
/*G2JJ*     ** END ADD SECTION **/

/*GM78*/    {gprun.i ""wowoisb.p""
                "(wo_recno, wo-op, fill_all, fill_pick, output undo-input)"}

/*G2JJ*     AT THIS POINT THE STATUS OF WO_MSTR IS SHARE LOCKED */

/*GM78*/    if undo-input then next mainloop.

/*GM78*     /* Section moved to wowoisb.p */
 *          do transaction:
 *
/*FP55*/       /* Added section */
 *             {gplock.i
 *             &file-name=wo_mstr
 *             &find-criteria="recid(wo_mstr) = wo_recno"
 *             &exit-allowed=yes
 *             &record-id=recno}
 *
 *             if keyfunction(lastkey) = "end-error" then do:
 *                next mainloop.
 *             end.
/*FP55*/       /* End of added section */
 *
/*GM61         for each sr_wkfl where sr_userid = mfguser: */
/*GM61*/       for each sr_wkfl exclusive where sr_userid = mfguser:
 *                delete sr_wkfl.
 *             end.
 *
/*G656*        for each wod_det where wod_lot = wo_lot */
/*G656*/       for each wod_det no-lock where wod_lot = wo_lot
/*G656*/       and (wod_op = wo-op or wo-op = 0):
 *                find pt_mstr where pt_part = wod_part no-lock.
/*G656*/          do for woddet:
/*G656*/             find woddet exclusive where recid(woddet) = recid(wod_det).
 *
 *                   wod_qty_chg = 0.
/*G223*              wod_bo_chg = 0. */
 *
/*G223*/             if wod_qty_req >= 0
/*G223*/             then wod_bo_chg = max(0, wod_qty_req
/*G223*/                             - max(wod_qty_iss,0) - wod_qty_chg).
/*G223*/             else wod_bo_chg = min(0, wod_qty_req
/*G223*/                             - min(wod_qty_iss,0) - wod_qty_chg).
 *
 *                   if fill_all or fill_pick then do:
 *                      tot_lad_all = 0.
 *                      for each lad_det where lad_dataset = "wod_det"
/*G656*                 and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                and lad_nbr = wod_lot and lad_line = string(wod_op)
 *                      and lad_part = wod_part:
 *
 *                         define variable rejected like mfc_logical.
/*G527*                    {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
 *                         input lad_site, input lad_loc, input wod_part,
 *                         input lad_lot, input lad_ref,
 *                         input if fill_all then lad_qty_all else lad_qty_pick,
 *                         input pt_um, output rejected)"} */
 *
/*G527*/                   {gprun.i ""icedit2.p"" "(""ISS-WO"",
 *                         lad_site, lad_loc, wod_part, lad_lot, lad_ref,
 *                         (if fill_all then lad_qty_all else 0)
 *                         + (if fill_pick then lad_qty_pick else 0),
 *                         pt_um, output rejected)"}
 *
 *                         if rejected then do on endkey undo, retry:
 *                            {mfmsg02.i 161 2 wod_part}
 *
/*G223*/                      if wod_qty_req >= 0
/*G223*/                      then wod_bo_chg = max(0, wod_qty_req
/*G223*/                                    - max(wod_qty_iss,0) - wod_qty_chg).
/*G223*/                      else wod_bo_chg = min(0, wod_qty_req
/*G223*/                                    - min(wod_qty_iss,0) - wod_qty_chg).
 *                            next.
 *                         end.
 *
 *                         ladqtychg = 0.
 *                         if fill_all then do:
 *                            ladqtychg = lad_qty_all.
 *                            wod_qty_chg = wod_qty_chg + lad_qty_all.
 *                            tot_lad_all = tot_lad_all + lad_qty_all.
 *                         end.
 *                         if fill_pick then do:
 *                            ladqtychg = ladqtychg + lad_qty_pick.
 *                            wod_qty_chg = wod_qty_chg + lad_qty_pick.
 *                         end.
 *                         if ladqtychg <> 0 then do:
 *                            create sr_wkfl.
 *                            assign sr_userid = mfguser
/*G656*                       sr_lineid = wod_part */
/*G656*/                   sr_lineid = string(wod_part,"x(18)") + string(wod_op)
 *                            sr_site = lad_site
 *                            sr_loc = lad_loc
 *                            sr_lotser = lad_lot
 *                            sr_ref = lad_ref
 *                            sr_qty = ladqtychg.
/*GO34*                       recno = recid(sr_wkfl). */
/*GO34*/                      if recid(sr_wkfl) = -1 then .
 *                         end.
 *                      end.
 *                      if fill_all and tot_lad_all <> wod_qty_all then do:
 *                       find pt_mstr where pt_part = wod_part no-lock no-error.
 *                         if not available pt_mstr or pt_lot_ser = "" then do:
 *                            find sr_wkfl where sr_userid = mfguser
/*G656*                       and sr_lineid = wod_part */
/*G656*/                      and sr_lineid = string(wod_part,"x(18)")
/*G656*/                          + string(wod_op)
 *                            and sr_site = wod_site
 *                            and sr_loc = wod_loc and sr_lotser = ""
 *                            and sr_ref = "" no-error.
 *
/*G782                        {gprun.i ""icedit2.p"" "(input ""ISS-WO"",      */
/*G782                        input wod_site, input wod_loc, input wod_part,  */
/*G782                        input """", input """",                         */
/*G782                        input ((wod_qty_all - tot_lad_all)              */
/*G782                           + if available sr_wkfl then sr_qty else 0),  */
/*G782                        input pt_um, output rejected)"}                 */
 *
/*G782*/                      {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
 *                            input wod_site, input wod_loc, input wod_part,
 *                            input """", input """",
 *                            input ((wod_qty_all - tot_lad_all)
 *                               + if available sr_wkfl then sr_qty else 0),
 *                            input if available pt_mstr then pt_um else """",
 *                            output rejected)"}
 *
 *                            if rejected then do on endkey undo, retry:
 *                               {mfmsg02.i 161 2 wod_part}
 *
/*G223*/                         if wod_qty_req >= 0
/*G223*/                         then wod_bo_chg = max(0, wod_qty_req
/*G223*/                                    - max(wod_qty_iss,0) - wod_qty_chg).
/*G223*/                         else wod_bo_chg = min(0, wod_qty_req
/*G223*/                                    - min(wod_qty_iss,0) - wod_qty_chg).
 *                               next.
 *                            end.
 *
 *                            if not available sr_wkfl then do:
 *                               create sr_wkfl.
 *                               assign
 *                               sr_userid = mfguser
/*G656*                          sr_lineid = wod_part */
/*G656*/                         sr_lineid = string(wod_part,"x(18)")
/*G656*/                           + string(wod_op)
 *                               sr_site = wod_site
 *                               sr_loc = wod_loc
 *                               sr_lotser = ""
 *                               sr_ref = "".
/*GO34*                          recno = recid(sr_wkfl). */
/*GO34*/                         if recid(sr_wkfl) = -1 then .
 *                            end.
 *                            sr_qty = sr_qty + (wod_qty_all - tot_lad_all).
 *                            wod_qty_chg = wod_qty_chg
 *                                        + (wod_qty_all - tot_lad_all).
 *                         end.
 *                      end.
 *                   end.
/*G223*              wod_bo_chg = max(0, wod_qty_req
 *                              - wod_qty_iss - wod_qty_chg). */
/*G223*/             if wod_qty_req >= 0
/*G223*/             then wod_bo_chg = max(0, wod_qty_req
/*G223*/                             - max(wod_qty_iss,0) - wod_qty_chg).
/*G223*/             else wod_bo_chg = min(0, wod_qty_req
/*G223*/                             - min(wod_qty_iss,0) - wod_qty_chg).
/*G656*/          end. /* do for woddet */
 *             end. /*for each wod_det*/
 *
 *          end. /* transaction */
**GM78*/    /* End of section moved to wowoisb.p */

/*J137*     Added wo-op as an input parm */
/*G1MN*/    {gprun.i ""wowoisc.p""
                "(input wo-op, output undo-input)"}
/*G1MN*/    if undo-input then next mainloop.

/*G1MN* * * MOVED TO wowoisc.p DUE TO R-CODE SIZE WAS TOO LARGE * *
.            do transaction:
.
.               setd:
.               do while true:
.
.                  /* DISPLAY DETAIL */
./*J060*/          select-part:
.                  repeat:
.                     clear frame c all no-pause.
./*J04C*               clear frame d all no-pause.  */
./*J04C*/              clear frame d no-pause.
.                     view frame c.
.                     view frame d.
.                     for each wod_det no-lock
.                     where wod_lot = wo_lot and wod_part >= part
./*G656*/             and (wod_op = wo-op or wo-op = 0) by wod_lot
.                     by wod_part:
.
./*G223*                 qopen = wod_qty_req - wod_qty_iss. */
./*G223*/                if wod_qty_req >= 0
./*G223*/                then qopen = max(0, wod_qty_req - max(wod_qty_iss,0)).
./*G223*/                else qopen = min(0, wod_qty_req - min(wod_qty_iss,0)).
.
.                        display
.                        wod_part
.                        qopen          format "->>>>>>>9.9<<<<<<<"
.                                       label "Qty Open"
.                        wod_qty_all    format "->>>>>>>9.9<<<<<<<"
.                                       label "Qty Alloc"
.                        wod_qty_pick   format "->>>>>>>9.9<<<<<<<"
.                                       label "Qty Picked"
.                        wod_qty_chg    format "->>>>>>>9.9<<<<<<<"
.                                       label "Qty to Iss"
.                        wod_bo_chg     format "->>>>>>>9.9<<<<<<<"
.                                       label "Qty B/O"
.                        with frame c.
.                        if frame-line(c) = frame-down(c) then leave.
.                        down 1 with frame c.
.                     end.
.
.                     input clear.
.
.                     part = "".
./*G656*/             op = 0.
.
.                     do on error undo, retry:
.
.                        set part
./*G656*/                op
.                        with frame d editing:
.                           if frame-field = "part" then do:
.
.                              /* FIND NEXT/PREVIOUS RECORD */
./*G656*                       {mfnp01.i wod_det part wod_part wo_lot wod_lot
.                                 wod_det} */
./*GL28   replaced part with "input part"  */
./*G656*/                      {mfnp05.i wod_det wod_det
.                              "wod_lot = wo_lot
.                               and (wod_op = wo-op or wo-op = 0)"
.                               wod_part
.                               "input part" }
./*GL28                         part}         */
.
.                              if recno <> ? then do:
.                                 part = wod_part.
./*G656*/                         op = wod_op.
.                                 disp part
./*G656*/                            op
.                                 with frame d.
.                                 find pt_mstr
.                                 where pt_part = wod_part no-lock no-error.
.                                 if available pt_mstr then do:
.                                    disp pt_um pt_desc1 with frame d.
.                                 end.
.
.                                 display wod_qty_chg @ lotserial_qty
.                                 no @ sub_comp no @ cancel_bo
.                                 "" @ lotserial wod_loc @ location
.                                 wod_site @ site "" @ multi_entry
.                                 with frame d.
.
.                              end.
.                           end.
./*G656*/                   /* Added section */
.                           else if frame-field = "op" then do:
.                              /* FIND NEXT/PREVIOUS RECORD */
./*J060*/                      /* "input op"  was  op  in mfnp05.i below. */
.                              {mfnp05.i wod_det wod_det
.                              "wod_lot = wo_lot and wod_part = input part
.                               and (wod_op = wo-op or wo-op = 0)"
.                               wod_op "input op"}
.                              if recno <> ? then do:
.                                 op = wod_op.
.
.                                 display op with frame d.
.
.                                 display wod_qty_chg @ lotserial_qty
.                                 no @ sub_comp no @ cancel_bo
.                                 "" @ lotserial wod_loc @ location
.                                 wod_site @ site "" @ multi_entry
.                                 with frame d.
.
.                              end.
.                           end.
./*G656*/                   /* End of added section */
.                           else do:
.                              status input.
.                              readkey.
.                              apply lastkey.
.                           end.
.                        end.
.                        status input.
.
.                        if part = "" then leave.
.
./*G656*/                /* Added section */
.                        if wo-op <> 0 and op <> wo-op then do:
.                           {mfmsg.i 13 3}
.                           next-prompt op with frame d.
.                           undo, retry.
.                        end.
./*G656*/                /* End of added section */
.
.                        firstpass = yes.
.
.                        frame-d-loop:
.                        repeat:
.
.                           cancel_bo = no.
.                           sub_comp = no.
.                           multi_entry = no.
.
.                           find wod_det where wod_lot = wo_lot
./*J07X*                    and wod_part = input part                       */
./*J07X*/                   and wod_part =  part
./*G656*/                   and wod_op = op
.                           no-error.
.                           if not available wod_det then do:
.
.                              find pt_mstr
./*J07X*                       where pt_part = input part no-lock no-error.  */
./*J07X*/                      where pt_part =  part no-lock no-error.
.                              if not available pt_mstr then do:
.                                 {mfmsg.i 16 3}
.                                 undo, retry.
.                              end.
./*J060***********************************************************************
./*J040*/   *                  if wo_type <> "r" and wo_type <> "e" then do:
./*J04D*/   *                     if not clc_comp_issue then do:
./*J040*/   *                        {gprun.i ""gpveriss.p"" "(input nbr,
.           *                                                  input wolot,
.          *                                           output issue_component)"}
./*J040*/   *                        if not issue_component then do:
./*J040*/   *                           {mfmsg.i 517 3} /*COMPONENT DOES NOT*/
./*J040*/   *                          undo, retry. /*EXIST ON THIS WORK ORDER*/
./*J040*/   *                        end. /* IF NOT ISSUE_COMPONENT */
./*J040*/   *                     end. /* IF NOT CLC_COMP_ISSUE */
./*J040*/   *                  end. /* IF WO_TYPE <> "R" AND */
./*J04D*/   *                  if clc_comp_issue then do:
.           *                     {mfmsg.i 517 2}
.           *                   /* COMPONENT DOES NOT EXIST ON THIS WORK ORDER*/
./*J040*/   *                  end.
. *J060***********************************************************************/
.
./*J060*/                      /* Begin added block */
.                              if firstpass then do:
.                                 /*UNRESTRICTED COMPONENT ISSUES*/
.                                 if clc_comp_issue
.                                 or wo_type = "R" or wo_type = "E" then do:
.                                 /* ITEM DOES NOT EXIST ON THIS BILL OF MAT'L
.*/                                     {mfmsg.i 547 2}
.                                 end.
.                                 /*COMPLIANCE MODULE RESTRICTS COMP ISSUE*/
.                                 else do:
.                                 /* ITEM DOES NOT EXIST ON THIS BILL OF MAT'L
.*/                                     {mfmsg.i 547 3}
.                                    undo select-part, retry.
.                                 end.
.                              end.
./*J060*/                      /* End added block */
.
.                              create wod_det.
.                              assign
.                              wod_lot = wo_lot
.                              wod_nbr = wo_nbr
./*J07X*                       wod_part = input part                   */
./*J07X*/                      wod_part = part
./*G656*/                      wod_op = input op
.                              wod_site = wo_site.
.                              wod_iss_date = wo_rel_date.
./*GO34*                       recno = recid(wod_det). */
./*GO34*/                      if recid(wod_det) = -1 then .
.                           end. /*NOT AVAILABLE WOD_DET*/
.                           find pt_mstr
.                           where pt_part = wod_part no-lock no-error.
.                           if not available pt_mstr then do:
.                              {mfmsg.i 16 2}
.                              display part " " @ pt_um " " @ pt_desc1
.                              with frame d.
.                           end.
.                           else do:
.                              if new wod_det then
.                              assign wod_loc = pt_loc
.                                wod_critical = pt_critical.
./*F003                           wod_tot_std = pt_mtl_stdtl + pt_mtl_stdll. */
.
./*G216*                       if wod_site = "" then wod_site = pt_site. */
.
.                              display pt_part @ part pt_um pt_desc1
.                              with frame d.
.                           end.
.
.                           qopen = wod_qty_req - wod_qty_iss.
.
.                           lotserial_control = "".
.                           if available pt_mstr then
.                              lotserial_control = pt_lot_ser.
.                           site = "".
.                           location = "".
.                           lotserial = "".
.                           lotref = "".
.
./*G115                     if not firstpass then                           */
./*G115                        lotserial_qty = wod_qty_chg + lotserial_qty. */
./*G115                     else                                            */
./*G115*/                   if firstpass then
.                              lotserial_qty = wod_qty_chg.
.
./*G216*/                   if not firstpass then
./*G216*/                      lotserial_qty = wod_qty_chg + lotserial_qty.
.
./*G656*                    cline = wod_part. */
./*G656*/                   cline = string(wod_part,"x(18)") + string(wod_op).
.                           global_part = wod_part.
.
.                           if not can-find (first sr_wkfl
.                           where sr_userid = mfguser
.                           and sr_lineid = cline) then do:
.                              site = wod_site.
.                              location = wod_loc.
.                           end.
.                           else do:
.                              find sr_wkfl where sr_userid = mfguser
.                              and sr_lineid = cline no-lock no-error.
.                              if available sr_wkfl then do:
.                                 site = sr_site.
.                                 location = sr_loc.
.                                 lotserial = sr_lotser.
.                                 lotref = sr_ref.
.                              end.
.                              else multi_entry = yes.
.                           end.
.
./*F190*/                   locloop:
./*GE69*                    do on error undo, retry on endkey undo, leave: */
./*GE69*/                   do on error undo, retry
./*J060*                    on endkey undo frame-d-loop, leave frame-d-loop: */
./*J060*/                   on endkey undo select-part, retry:
.
.                              wod_recno = recid(wod_det).
.
.                              update lotserial_qty
.                              sub_comp cancel_bo
.                              site location lotserial lotref multi_entry
.                              with frame d
.                              editing:
.                                 global_site = input site.
.                                 global_loc = input location.
.                                 global_lot = input lotserial.
.                                 readkey.
.                                 apply lastkey.
.                              end.
.
.                              if sub_comp then do:
.                                 if can-find (first pts_det where
.                                    pts_part = wod_part and pts_par = "")
.                                 or can-find (first pts_det where
.                                    pts_part = wod_part and pts_par = wo_part)
.                                 then do:
.                                    {gprun.i ""wosumt.p""}
.                                    if keyfunction(lastkey) = "end-error" then
.                                       undo, retry.
.                                    firstpass = no.
.                                    next frame-d-loop.
.                                 end.
.                                 else do with frame d:
.                                    {mfmsg.i 545 3}
.                                    next-prompt sub_comp.
.                                    undo, retry.
.                                 end.
.                              end.
.
.                              i = 0.
.                              for each sr_wkfl no-lock
.                              where sr_userid = mfguser
.                              and sr_lineid = cline:
.                                 i = i + 1.
.                                 if i > 1 then do:
.                                    multi_entry = yes.
.                                    leave.
.                                 end.
.                              end.
.
.                              total_lotserial_qty = wod_qty_chg.
.                              trans_um = if available pt_mstr then pt_um
.                                          else "".
.                              trans_conv = 1.
.
.                              if multi_entry then do:
.                                 if i >= 1 then do:
.                                    site = "".
.                                    location = "".
.                                    lotserial = "".
.                                    lotref = "".
.                                 end.
./*J041*/                         lotnext = "".
./*J041*/                         lotprcpt = no.
./*F190                           {gprun.i ""icsrup.p""}            */
./*J038* /*F190*/                 {gprun.i ""icsrup.p"" "(wo_site)"   */
./*J038*  Add blanks for wo_nbr and wo_lot as inputs to icsrup.p call         */
./*J060*****
./*J038*/  *                      {gprun.i ""icsrup.p"" "(wo_site,
.          *                                              """",
.          *                                              """")"}
. *J060*****/
./*J060*/                         {gprun.i ""icsrup.p"" "(input wo_site,
.                                                         input """",
.                                                         input """",
.                                                         input-output lotnext,
.                                                         input lotprcpt)"}
.                              end.
.                              else do:
./*G0SY*/                         if lotserial_qty <> 0 then do:
./*J038* Add blank as inputs wo_nbr and wo_lot to icedit.p call             */
.                                    {gprun.i ""icedit.p""
.                                        "(""ISS-WO"",
.                                          site,
.                                          location,
.                                          global_part,
.                                          lotserial,
.                                          lotref,
.                                          lotserial_qty,
.                                          trans_um,
.                                          """",
.                                          """",
.                                          output undo-input)" }
.
.                                    if undo-input then undo, retry.
.
./*F190*/                            if wo_site <> site then do:
./*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
./*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
./*F0TC*/ /*************************** Delete: Begin ***********************
./*FO22*/         *                 /* CHANGED ISS_WO TO ISS-WO              */
./*J038* Add blanks as inputs wo_nbr and wo_lot to icedit3.p call             */
./*GI21*//*FI90*/ *                 {gprun.i ""icedit3.p"" "(input ""ISS-WO"",
.                 *                                         input site,
.                 *                                         input location,
.                 *                                         input global_part,
.                 *                                         input lotserial,
.                 *                                         input lotref,
.                 *                                         input lotserial_qty,
.                 *                                         input trans_um,
.                 *                                         input """",
.                 *                                         input """",
.                 *                                         output yn)"
.                 *                  }
./*F190*/         *                  if yn then undo locloop, retry.
.                 *
./*J038* Add blanks as inputs wo_nbr and wo_lot to icedit3.p call            */
./*F190*/         *                  {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
.                 *                                         input site,
.                 *                                         input location,
.                 *                                         input global_part,
.                 *                                         input lotserial,
.                 *                                         input lotref,
.                 *                                         input lotserial_qty,
.                 *                                         input trans_um,
.                 *                                         input """",
.                 *                                         input """",
.                 *                                         output yn)"
.                 *                  }
./*F190*/         *                  if yn then undo locloop, retry.
.                 *
./*FR98*/ /*FR60*/* /*changed input wo_site back to to wo_site */
./*J038* Add blanks as input wo_nbr and wo_lot to icedit3.p call              */
./*F190*/         *                  {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
.                 *                                         input wo_site,
.                 *                                         input location,
.                 *                                         input global_part,
.                 *                                         input lotserial,
.                 *                                         input lotref,
.                 *                                         input lotserial_qty,
.                 *                                         input trans_um,
.                 *                                         input """",
.                 *                                         input """",
.                 *                                         output yn)"
.                 *                  }
./*F0TC*/ **************************** Delete: End *************************/
./*J038* Add blanks as inputs wo_nbr and wo_lot.   Done during 12/5/95 merge. */
./*F0TC*/                             {gprun.i ""icedit4.p"" "(input ""ISS-WO"",
.                                                           input wo_site,
.                                                           input site,
.                                                           input pt_loc,
.                                                           input location,
.                                                           input global_part,
.                                                           input lotserial,
.                                                           input lotref,
.                                                           input lotserial_qty,
.                                                           input trans_um,
.                                                           input """",
.                                                           input """",
.                                                           output yn)"
.                                       }
./*F190*/                               if yn then undo locloop, retry.
./*F190*/                            end.
./*G0SY*/                         end.
.
.                                 find first sr_wkfl where sr_userid = mfguser
.                                 and sr_lineid = cline no-error.
.                                 if lotserial_qty = 0 then do:
.                                    if available sr_wkfl then do:
.                                       total_lotserial_qty =
.                                          total_lotserial_qty - sr_qty.
.                                       delete sr_wkfl.
.                                    end.
.                                 end.
.                                 else do:
.                                    if available sr_wkfl then do:
.                                       assign
.                                       total_lotserial_qty =
.                                          total_lotserial_qty - sr_qty
.                                          + lotserial_qty
.                                       sr_site = site
.                                       sr_loc = location
.                                       sr_lotser = lotserial
.                                       sr_ref = lotref
.                                       sr_qty = lotserial_qty.
.                                    end.
.                                    else do:
.                                       create sr_wkfl.
.                                       assign
.                                       sr_userid = mfguser
.                                       sr_lineid = cline
.                                       sr_site = site
.                                       sr_loc = location
.                                       sr_lotser = lotserial
.                                       sr_ref = lotref
.                                       sr_qty = lotserial_qty.
.                                       total_lotserial_qty =
.                                          total_lotserial_qty + lotserial_qty.
./*GO34*                                recno = recid(sr_wkfl). */
./*GO34*/                               if recid(sr_wkfl) = -1 then .
.                                    end.
.                                 end.
.                              end.
.
.                              wod_qty_chg = total_lotserial_qty.
.                              if cancel_bo then
.                                 wod_bo_chg = 0.
.                              else
.                                 wod_bo_chg = wod_qty_req
.                                             - wod_qty_iss - wod_qty_chg.
.                              if wod_qty_req >= 0 then
.                                 wod_bo_chg = max(wod_bo_chg,0).
.                              if wod_qty_req < 0  then
.                                 wod_bo_chg = min(wod_bo_chg,0).
./*GJ31*/                      if cancel_bo and
./*GJ31*/                         not can-find (first sr_wkfl where
./*GJ31*/                               sr_userid = mfguser and
./*GJ31*/                               sr_lineid = cline)
./*GJ31*/                      then do:
./*GJ31*/                         create sr_wkfl.
./*GJ31*/                         assign
./*GJ31*/                            sr_userid = mfguser
./*GJ31*/                            sr_lineid = cline
./*GJ31*/                         sr_qty = 0.
./*GM61*/                         recno = recid(sr_wkfl).
./*GJ31*/                      end.
.
.                           end.
.
.                           leave.
.                        end.
.                     end.
./*F0VL* /*F0FQ*/     part = "". */
.                  end.
.
.                  do on endkey undo mainloop, retry mainloop:
.                     yn = yes.
./*GM78*/ /*V8-*/
.                     {mfmsg01.i 636 1 yn} /* Display wo lines being shipped? */
./*GM78*/ /*V8+*/
./*GM78*/ /*V8!       {mfgmsg10.i 636 1 yn} */ /* Display wo lns being shippd?
.*/                      if yn = yes then do:
.                        hide frame c no-pause.
.                        hide frame d no-pause.
.                        for each wod_det no-lock where wod_lot = wo_lot,
.                        each sr_wkfl no-lock where sr_userid = mfguser
./*G656*                 and sr_lineid = wod_part */
./*G656*/                and sr_lineid = string(wod_part,"x(18)")
./*G656*/                    + string(wod_op)
.                        with width 80:
.                           display wod_part sr_site sr_loc sr_lotser
.                           sr_ref format "x(8)" column-label "Ref"
.                           sr_qty.
.                        end.
.                     end.
./*GM78*/ /*V8!     else if yn = ? then                 */
./*GM78*/ /*V8!       undo mainloop, retry mainloop.    */
.                  end.
.
.                  do on endkey undo mainloop, retry mainloop:
./*GM78*/ /*V8-*/
.                     yn = yes.
.                     {mfmsg01.i 12 1 yn} /* "Is all info correct?" */
./*GM78*/ /*V8+*/
./*GM78*/ /*V8!       yn = ?. */
./*GM78*/ /*V8!       {mfgmsg10.i 12 1 yn} */ /* "Is all info correct?" */
.
.                     if yn then do:
.
./*G872*/                /* Added section */
.                        {gplock.i
.                        &file-name=wo_mstr
.                        &find-criteria="recid(wo_mstr) = wo_recno"
.                        &exit-allowed=yes
.                        &record-id=recno}
.
./*GM78*/ /*V8-*/
.                        if keyfunction(lastkey) = "end-error" then do:
.                           find wo_mstr no-lock where recid(wo_mstr) =
.wo_recno.                            next setd.
.                        end.
./*GM78*/ /*V8+*/
.
.                        if not available wo_mstr then do:
.                           {mfmsg.i 510 4} /*  WORK ORDER DOES NOT EXIST.*/
.                           next mainloop.
.                        end.
.
./*FP55*                 release wo_mstr. */
./*G872*/                /* End of added section */
.
./*G0V9*/                /* ADDED SECTION TO DO FINAL ISSUE CHECK */
./*G0V9*/                {icintr2.i "sr_userid = mfguser"
.                                   transtype
.                                   substring(sr_lineid,1,18)
.                                   trans_um
.                                   undo-input
.                                   """"
.                        }
./*G0V9*/
./*G0V9*/                if undo-input
./*G0V9*/                then do:
./*G0V9*/                   /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
./*G0V9*/                   {mfmsg02.i 161 3 substring(sr_lineid,1,18)}
./*G0V9*/                   next setd.
./*G0V9*/                end.
./*G0V9*/                /* END OF ADDED SECTION */
.                        hide frame c.
.                        hide frame d.
.                        leave setd.
.                     end.
./*GM78*/ /*V8!     else if yn = no then do:
.                           find wo_mstr no-lock where recid(wo_mstr) =
.wo_recno.                            next setd.
.                     end.
.                   else
.                     undo mainloop, retry mainloop.  */
.                  end.
.               end.
.               /* setd */
.            end.
**G1MN* * * END DELETE FOR wowoisc.p * * * * */

/*G872*     wo_recno = recid(wo_mstr). */
            {gprun.i ""wowoisa.p""}
         end.
/*K001*/  if daybooks-in-use then delete procedure h-nrm no-error.
