/* icintr.p - COMMON PROGRAM FOR MISC INVENTORY TRANSACTIONS                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*K1Q4*/ /*V8:WebEnabled=No                                                  */
/* Type of transaction:  "RCT-UNP" (unplanned receipts)                      */
/*                       "RCT-SOR" (s.o. returns)                            */
/*                       "RCT-RS"  (return to stock)                         */
/*                       "RCT-WO"  (unplanned receipts backward exploded)    */
/*                       "ISS-UNP" (unplanned isue)                          */
/*                       "ISS-RV"  (return to vendor)                        */
/*                       "ISS-PRV" (PO rtn to vendor)                        */
/* REVISION: 2.1      LAST MODIFIED: 10/01/87   BY: wug                      */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: wug *D015*               */
/* REVISION: 6.0      LAST MODIFIED: 04/09/90   BY: wug *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 07/30/90   BY: ram *D030*               */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: wug *D619*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: wug *D569*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: wug *D575*               */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*               */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*               */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: wug *D920*               */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: wug *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 05/22/92   BY: pma *F522*               */
/* REVISION: 7.0      LAST MODIFIED: 05/27/92   BY: emb *F541*               */
/* REVISION: 7.0      LAST MODIFIED: 05/27/92   BY: jjs *F681*               */
/* REVISION: 7.0      LAST MODIFIED: 07/07/92   BY: pma *F735*               */
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: pma *F772*               */
/* REVISION: 7.3      LAST MODIFIED: 10/02/92   BY: mpp *G011*               */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: rwl *G264*               */
/* REVISION: 7.3      LAST MODIFIED: 11/30/92   BY: pma *G366*               */
/* REVISION: 7.3      LAST MODIFIED: 03/20/93   BY: pma *G852*               */
/* REVISION: 7.3      LAST MODIFIED: 03/31/93   BY: ram *G886*               */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*               */
/* REVISION: 7.4      LAST MODIFIED: 09/01/93   BY: dpm *H075*               */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM10*               */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   BY: ljm *GM02*               */
/* REVISION: 7.4      LAST MODIFIED: 10/11/94   BY: dpm *GN25*               */
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   by: rwl *GO25*               */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*               */
/* REVISION: 8.5      LAST MODIFIED: 12/21/94   BY: ktn *J041*               */
/* REVISION: 7.4      LAST MODIFIED: 12/22/94   by: pxd *F0BK*               */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   by: pxd *F0LZ*               */
/* REVISION: 8.5      LAST MODIFIED: 05/17/95   BY: sxb *J04D*               */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   by: rmh *J04R*               */
/* REVISION: 7.4      LAST MODIFIED: 07/13/95   by: dzs *G0S3*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/95   BY: ais *G0V9*               */
/* REVISION: 8.5      LAST MODIFIED: 03/05/96   BY: sxb *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 05/01/96   BY: jym *G1MN*               */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *G1VC* Julie Milligan    */
/* REVISION: 8.6      LAST MODIFIED: 10/19/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *J1CZ* Russ Witt         */
/* REVISION: 8.6      LAST MODIFIED: 01/27/97   BY: *H0QP* Julie Milligan    */
/* REVISION: 8.6      LAST MODIFIED: 04/15/96   BY: *K08N* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/22/97   BY: *H1HN* Jean Miller       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
          /* DISPLAY TITLE */
/*J04R*/  {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icintr_p_1 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_2 "发放"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_3 "生效日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_4 "换算因子"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_5 "总成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_6 "累计数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_7 "单位成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_8 "收货"
/* MaxLen: Comment: */

&SCOPED-DEFINE icintr_p_9 "参考"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/** define shared variable mfguser as character. **/                    /*G264*/
         define shared variable transtype as character format "x(7)".
         define new shared variable yn like mfc_logical.
         define new shared variable part like tr_part.
         define new shared variable um like pt_um no-undo.
         define new shared variable conv like um_conv
            label {&icintr_p_4} no-undo.
         define new shared variable ref like glt_ref.
         define new shared variable eff_date like glt_effdate label {&icintr_p_3}.
         define new shared variable trlot like tr_lot.
         define new shared variable qty_loc like tr_qty_loc.
         define new shared variable qty_loc_label as character format "x(12)".
         define new shared variable issrct as character format "x(3)".
         define new shared variable issuereceipt as character format "x(7)".
         define new shared variable unit_cost like tr_price label {&icintr_p_7}.
         define new shared variable total_amt like tr_gl_amt label {&icintr_p_5}.
         define new shared variable ordernbr like tr_nbr.
         define new shared variable orderline like tr_line.
         define new shared variable so_job like tr_so_job.
         define new shared variable addr like tr_addr.
         define new shared variable rmks like tr_rmks.
         define new shared variable serial like tr_serial.
         define new shared variable dr_acct like trgl_dr_acct.
         define new shared variable dr_cc like trgl_dr_cc.
         define new shared variable cr_acct like trgl_cr_acct.
         define new shared variable cr_cc like trgl_cr_cc.
         define new shared variable trqty like tr_qty_loc.
         define new shared variable i as integer.
         define new shared variable tot_units as character format "x(16)".
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable null_ch as character initial "".
         define new shared variable reject_qty_label as character
            format "x(11)".
         define new shared variable qty_reject like tr_qty_loc.
         define new shared variable qty_iss_rcv like qty_loc.
         define new shared variable pt_recid as recid.
         define variable lotum as character.
         define variable dr_desc like ac_desc.
         define variable cr_desc like ac_desc.
         define new shared variable dr_proj like wo_proj.
         define new shared variable cr_proj like wo_proj.
/*F003*/ define new shared variable project like wo_proj.
         define new shared variable multi_entry like mfc_logical
            label {&icintr_p_1} no-undo.
         define new shared variable lotserial_control as character.
         define new shared variable cline as character.
         define new shared variable issue_or_receipt as character.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable total_lotserial_qty like sr_qty
            label {&icintr_p_6}.
         define new shared variable trans_um like pt_um.
         define new shared variable trans_conv like sod_um_conv.
         define new shared variable lotref like sr_ref format "x(8)" no-undo.
/*G011*/ define variable valid_acct like mfc_logical.

/*H075*/ define new shared variable tr_recno as recid.
/*J038*/ define variable undo-input like mfc_logical.

/*J04D*/ define variable lotnext like wo_lot_next .
/*J04D*/ define variable lotprcpt like wo_lot_rcpt no-undo.
/*G0V9*/ define variable error-found like mfc_logical.
/*J053*/ define variable total_amt_fmt as character.
/*K003*/ define variable shipnbr    like tr_ship_id no-undo.
/*K003*/ define variable inv_mov    like tr_ship_inv_mov no-undo.
/*K003*/ define variable ship_date  like tr_ship_date no-undo.

         /* DISPLAY TITLE */
/*J04R*  /*H075*/ {mfdtitle.i "e+ "}     */

/*G1MN* /*H039*/ {gpglefdf.i} */
/*G1MN*/ {gpglefv.i}

         form
            pt_part        colon 17 LABEL "零件号"  
            pt_lot_ser     colon 57 LABEL "批/序号控制"  
            pt_um         pt_um LABEL "单位"
            pt_desc1       colon 17 LABEL "零件描述" 
            pt_desc2       at 19 no-label
            lotserial_qty  colon 17  LABEL " 数量" 
            site           colon 57 LABEL "地点" 
            um             colon 17  LABEL "单位"  
            location       colon 57 LABEL "库位"     
            conv           colon 17 LABEL "换算因子"    
            lotserial      colon 57 LABEL "批/序号" 
            lotref         colon 57 label "参考"
            multi_entry    colon 57 LABEL "多记录"   
            skip(1)
            unit_cost      colon 17 LABEL "单位成本"
            total_lotserial_qty colon 57
/*F0LZ*/                                 format "->>>,>>>,>>9.9<<<<<<<<<" LABEL "累计数量"
            ordernbr       colon 17 LABEL "订单"
            total_amt      colon 57 LABEL "总成本"
            orderline      colon 17 LABEL "序号"
            so_job         colon 17 LABEL "销售/定制品"
            addr           colon 17 LABEL "地址" 
            rmks           colon 17  LABEL "备注" 
            project        colon 17 LABEL "项目代码" 
/*GM02*     dr_acct */
/*GM02*/    dr_acct        at 28 LABEL "借方帐户"
            dr_cc          no-label
            dr_desc        no-label
            eff_date       colon 17 LABEL "生效日期"  
/*GM02*     cr_acct */
/*GM02*/    cr_acct        at 28 LABEL "贷方帐户"
            cr_cc          no-label
            cr_desc        no-label
         with frame a THREE-D side-labels width 80 attr-space.


         if transtype = "ISS-RV" then do:
/*H0QP*     if can-find(first po_mstr) and can-find(first ap_mstr) then do: */
/*H0QP*/    if can-find(first po_mstr where po_nbr >= "")
/*H0QP*/    and can-find(first ap_mstr where ap_type >= "" and ap_ref >= "")
/*H0QP*/    then do:
               {mfmsg.i 350 2} /* USE PO RTS ISSUE */
               pause.
               leave.
            end.
         end.

         issrct = substring(transtype,1,3).
         if issrct = "RCT" then issue_or_receipt = {&icintr_p_8}.
         else issue_or_receipt = {&icintr_p_2}.
/*J041*/ lotnext = "".
/*J041*/ lotprcpt = no.

/*K030*/ {gprun.i ""socrshc.p""}
/*K003*/ find first shc_ctrl no-lock.

         mainloop:
         repeat:
            do trans:
/*GM10*        for each sr_wkfl where sr_userid = mfguser: */
/*GM10*/       for each sr_wkfl where sr_userid = mfguser
/*G0S3*/       exclusive-lock:
                  delete sr_wkfl.
               end.
/*J038*/       {gprun.i ""gplotwdl.p""}
            end.

/*H1HN*     prompt-for pt_part with frame a editing:  */
/*H1HN*/    prompt-for pt_part with frame a no-validate editing:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
               if recno <> ? then display pt_part pt_desc1 pt_um
/*F522*/          pt_lot_ser pt_desc2
               with frame a.
            end.
            status input.

            display "" @ total_lotserial_qty "" @ total_amt with frame a.

            find pt_mstr using pt_part no-lock
/*F522*/    no-error.
/*F522*/    if not available pt_mstr then do:
/*F522*/       {mfmsg.i 16 3} /* ITEM IS NOT AVAILABLE */
/*F522*/       undo, retry.
/*F522*/    end.

            pt_recid = recid(pt_mstr).


/*G852*******************MOVED SECTION**********************************
/*F003*/    find in_mstr where in_part = pt_part and in_site = pt_site
/*F003*/    no-lock no-error.
/*F003*/    if transtype = "ISS-RV" or transtype = "ISS-PRV" then do:
/*F003*/       {gpsct03.i &cost=sct_mtl_tl}
/*F003*/    end.
/*F003*/    else do:
/*F003*/       {gpsct03.i &cost=sct_cst_tot}
/*F003*/    end.
/*F003*/    unit_cost = glxcst.
**G852*******************END MOVED SECTION*****************************/

            um = pt_um.
            conv = 1.
            if eff_date = ? then eff_date = today.

            find pl_mstr where pl_prod_line = pt_prod_line no-lock.

            do transaction:
               /* GET NEXT LOT */
/*J04R*               {mfnctrl.i woc_ctrl woc_lot wo_mstr wo_lot trlot} */
/*J04R*/       {mfnxtsq.i wo_mstr wo_lot woc_sq01 trlot}
            end.

            /* SET GLOBAL PART VARIABLE */
            global_part = pt_part.
/*G366*/    part = pt_part.

            um = pt_um.
            conv = 1.

            display
            pt_part
            pt_lot_ser
            pt_um
            pt_desc1
            pt_desc2
            um
            conv
            with frame a.

            total_lotserial_qty = 0.
            lotserial_control = pt_lot_ser.

            setd:
            repeat on endkey undo mainloop, retry mainloop:

/*G852/*F541*/ unit_cost = glxcst.  */

               site = "".
               location = "".
               lotserial = "".
               lotref = "".
               lotserial_qty = total_lotserial_qty.
               cline = "".
               global_part = pt_part.
               i = 0.
               for each sr_wkfl no-lock where sr_userid = mfguser
               and sr_lineid = cline:
                  i = i + 1.
                  if i > 1 then leave.
               end.
               if i = 0 and available pt_mstr then do:
                  site = pt_site.
                  location = pt_loc.
               end.
               else
               if i = 1 then do:
                  find first sr_wkfl where sr_userid = mfguser
                  and sr_lineid = cline no-lock.
                  site = sr_site.
                  location = sr_loc.
                  lotserial = sr_lotser.
                  lotref = sr_ref.
               end.

               do on error undo, retry on endkey undo mainloop, retry mainloop:
                  update
                     lotserial_qty um conv site location
                     lotserial multi_entry
                  with frame a
                  editing:
                     global_site = input site.
                     global_loc = input location.
                     global_lot = input lotserial.
                     readkey.
                     apply lastkey.
                  end.
                  if um <> pt_um then do:
                     if not conv entered then do:
                        {gprun.i ""gpumcnv.p""
                        "(input um, input pt_um, input pt_part, output conv)"}
                        if conv = ? then do:
                           {mfmsg.i 33 2} /* NO UOM CONVERSION EXISTS */
                           conv = 1.
                        end.
                        display conv with frame a.
                     end.
                  end.

/*G852*/          find in_mstr where in_part = pt_part and in_site = site
/*G852*/          no-lock no-error.
/*G852*/          if transtype = "ISS-RV" or transtype = "ISS-PRV" then do:
/*G852*/             {gpsct03.i &cost=sct_mtl_tl}
/*G852*/          end.
/*G852*/          else do:
/*G852*/             {gpsct03.i &cost=sct_cst_tot}
/*G852*/          end.
/*G852*/          unit_cost = glxcst.

                  i = 0.
                  for each sr_wkfl no-lock where sr_userid = mfguser
                  and sr_lineid = cline:
                     i = i + 1.
                     if i > 1 then do:
                        multi_entry = yes.
                        leave.
                     end.
                  end.

                  trans_um = um.
                  trans_conv = conv.

                  if multi_entry then do:
                     if i >= 1 then do:
                        site = "".
                        location = "".
                        lotserial = "".
                        lotref = "".
                     end.
/*F190               {gprun.i ""icsrup.p""}            */
/*J038* /*F190*/     {gprun.i ""icsrup.p"" "(?)"}                    */
/*J038* ADDED BLANKS FOR INPUTS TRNBR AND TRLINE TO ICSRUP.P CALL            */
/*J04D*/             {gprun.i ""icsrup.p"" "(input ?,
                                             input """",
                                             input """",
                                             input-output lotnext,
                                             input lotprcpt)"}
                  end.
                  else do:
/*G366*/             /*PART BELOW WAS GLOBAL_PART*/
/*J038*              {icedit.i
      *                 &transtype=transtype
      *                 &site=site
      *                 &location=location
      *                 &lotref=lotref
      *                 &part=part
      *                 &lotserial=lotserial
      *                 &quantity="lotserial_qty * trans_conv"
      *                 &um=trans_um
      *              }                  */

/*J038* ADDED BLANKS FOR INPUTS TRNBR AND TRLINE TO ICEDIT.P CALL            */
/*J038*/             {gprun.i ""icedit.p"" "(transtype,
                                             site,
                                             location,
                                             part,
                                             lotserial,
                                             lotref,
                                             lotserial_qty * trans_conv,
                                             trans_um,
                                             """",
                                             """",
                                             output undo-input)"
                     }
/*J038*/             if undo-input then undo, retry.

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
/*GM10*                    recno = recid(sr_wkfl). */
                           assign
                           sr_userid = mfguser
                           sr_lineid = cline
                           sr_site = site
                           sr_loc = location
                           sr_lotser = lotserial
                           sr_ref = lotref
                           sr_qty = lotserial_qty.
/*GO25*/                   if recid(sr_wkfl) = -1 then .
                           total_lotserial_qty = total_lotserial_qty
                                                + lotserial_qty.
                        end.
                     end.
                  end.
               end.

               display total_lotserial_qty with frame a.
               display "" @ total_amt with frame a.
               unit_cost = unit_cost * conv.

               if issrct = "RCT" then do:
                  dr_acct = "".
                  dr_cc = "".
                  dr_desc = "".
                  if transtype = "RCT-SOR" then do:
/*F772               cr_acct = pl_cog_acct. */
/*F772               cr_cc = pl_cog_cc.     */
/*F772*/             find first gl_ctrl no-lock.
/*F772*/             cr_acct = gl_rtns_acct.
/*F772*/             cr_cc = gl_rtns_cc.
                  end.
                  else
                  if transtype = "RCT-UNP" then do:
                     cr_acct = pl_pur_acct.
                     cr_cc = pl_pur_cc.
                  end.
                  else
                  if transtype = "RCT-RS" then do:
/*G1VC*/             find first ptp_det where ptp_part = pt_part
/*G1VC*/             and ptp_site = in_site no-lock no-error.
/*G1VC*/             if ((available ptp_det and ptp_iss_pol = no)
/*G1VC*/                or (not available ptp_det and available pt_mstr
/*G1VC*/                and pt_iss_pol = no)) then do:
/*G1VC*/                cr_acct = pl_flr_acct.
/*G1VC*/                cr_cc = pl_flr_cc.
/*G1VC*/             end.
/*G1VC*/             else do:
                       cr_acct = pl_cop_acct.
                       cr_cc = pl_cop_cc.
/*G1VC*/             end.
                  end.
                  find ac_mstr no-lock
/*F681*/          where ac_code = substring(cr_acct,1,(8 - global_sub_len))
                  no-error.
                  if available ac_mstr then cr_desc = ac_desc.
                  else cr_desc = "".
               end.
               else
               if issrct = "ISS" then do:
                  cr_acct = "".
                  cr_cc = "".
                  cr_desc = "".
                  if transtype = "ISS-RV" or transtype = "ISS-PRV" then do:
                     dr_acct = pl_pur_acct.
                     dr_cc = pl_pur_cc.
                  end.
                  else
                  if transtype = "ISS-UNP" then do:
/*G0S3*/             find first ptp_det where ptp_part = pt_part
/*G0S3*/             and ptp_site = in_site no-lock no-error.
/*G0S3*/             if ((available ptp_det and ptp_iss_pol = no)
/*G0S3*/                or (not available ptp_det and available pt_mstr
/*G0S3*/                and pt_iss_pol = no)) then do:
/*G0S3 /*F003*/      if available pt_mstr and pt_iss_pol = no then do:*/
/*F003*/                dr_acct = pl_flr_acct.
/*F003*/                dr_cc = pl_flr_cc.
/*F003*/             end.
/*F003*/             else do:
/*F003*/                dr_acct = pl_cop_acct.
/*F003*/                dr_cc = pl_cop_cc.
/*F003*/             end.
                  end.
                  find ac_mstr no-lock
/*F681*/          where ac_code = substring(dr_acct,1,(8 - global_sub_len))
                  no-error.
                  if available ac_mstr then dr_desc = ac_desc.
                  else dr_desc = "".
               end.

               display dr_desc cr_desc with frame a.

               if eff_date = ? then eff_date = today.

/*G1MN*/       seta:
               do on endkey undo mainloop, retry mainloop on error undo, retry
/*F735*/       with frame a:

/*F0BK*/       /*  IF THIS IS A BATCH RUN AND WE ARE DOING A RETRY, UNDO   */
/*F0BK*/       /*  AND LEAVE MAINLOOP (mfglef.i ERROR WAS INEFFECTIVE)     */
/*F0BK*/          {gpcimex.i "mainloop"}

                  display unit_cost eff_date with frame a.
                  update ordernbr orderline so_job addr rmks project
/*G0S3            dr_acct when issrct = "ISS"    */
/*G0S3            dr_cc when issrct = "ISS"      */
/*G0S3*/          dr_acct when (issrct = "ISS")
/*G0S3*/          dr_cc when (issrct = "ISS")
                  /*eff_date*/
/*G0S3            cr_acct when issrct <> "ISS"   */
/*G0S3            cr_cc when issrct <> "ISS"     */
/*G0S3*/          cr_acct when (issrct <> "ISS")
/*G0S3*/          cr_cc when (issrct <> "ISS")
                  with frame a.

/*G886*/          /* VALIDATE PROJECT */
/*G886*/          {gpglprj2.i
                     &project=project
                     &with_frame="with frame a"
                  }

                  /* CHECK EFFECTIVE DATE */
/*H039*           {mfglef.i eff_date} */
/*G1MN* /*H039*/          {gpglef.i ""IC"" glentity eff_date} */
/*G1MN*/          find si_mstr where si_site = site no-lock.
/*G1MN*/          {gpglef1.i
                     &module = ""IC""
                     &entity = si_entity
                     &date = eff_date
                     &prompt = "eff_date"
                     &frame = "a"
                     &loop = "seta"
                     }

                  /*VALIDATE ACCOUNTS*/
/*H039*/          find first gl_ctrl no-lock no-error.
/*F735*/          if gl_verify then do with frame a:
/*F735*/             if issrct = "ISS" then do:

/*GN25*/                if batchrun then do:
/*GN25*/                   {gpglver1.i
                              &acc = dr_acct
                              &sub = ?
                              &cc  = dr_cc
                              &frame = a
                              &loop = mainloop }
/*GN25*/                end.
/*GN25*/                else do:
/*G011*/                   {gpglver1.i
                              &acc = dr_acct
                              &sub = ?
                              &cc  = dr_cc
                              &frame = a }
/*GN25*/                end.

/*G011* section commented out
 *F735*        if not can-find(ac_mstr where
 *F735*        ac_code = substring(dr_acct,1,(8 - global_sub_len))) then do:
 *F735*           {mfmsg.i 3052 3} /*invalid account code*/
 *F735*           next-prompt dr_acct.
 *F735*           undo, retry.
 *F735*        end.
 *F735*        if not can-find(cc_mstr where cc_ctr = dr_cc) then do:
 *F735*           {mfmsg.i 3057 3} /*invalid cost center*/
 *F735*           next-prompt dr_cc.
 *F735*           undo, retry.
 *F735*        end.
 *F735*        yn = false.
 *F735*        if input dr_cc <> "" then do:
 *F735*           {gpicacct.i &acct=dr_acct &cc=dr_cc}
 *F735*           if not yn then do:
 *F735*              {mfmsg.i 3014 3} /*invalid acct/cc combination*/
 *F735*              next-prompt dr_acct.
 *F735*              undo, retry.
 *F735*           end.
 *F735*        end.
 *G011* section commented out */

/*F735*/             end.
/*F735*/             else do:

/*GN25*/                if batchrun then do:
/*G011*/                   {gpglver1.i
                              &acc = cr_acct
                              &sub = ?
                              &cc  = cr_cc
                              &frame = a
                              &loop = mainloop }
/*GN25*/                end.
/*GN25*/                else do:
/*G011*/                   {gpglver1.i
                              &acc = cr_acct
                              &sub = ?
                              &cc  = cr_cc
                              &frame = a }
/*GN25*/                end.

/*G011* section commented out
 *F735*        if not can-find(ac_mstr where
 *F735*        ac_code = substring(cr_acct,1,(8 - global_sub_len))) then do:
 *F735*           {mfmsg.i 3052 3} /*invalid account code*/
 *F735*           next-prompt cr_acct.
 *F735*           undo, retry.
 *F735*        end.
 *F735*        if not can-find(cc_mstr where cc_ctr = cr_cc) then do:
 *F735*           {mfmsg.i 3057 3} /*invalid cost center*/
 *F735*           next-prompt cr_cc.
 *F735*           undo, retry.
 *F735*        end.
 *F735*        yn = false.
 *F735*        if input cr_cc <> "" then do:
 *F735*           {gpicacct.i &acct=cr_acct &cc=cr_cc}
 *F735*           if not yn then do:
 *F735*              {mfmsg.i 3014 3} /*invalid acct/cc combination*/
 *F735*              next-prompt cr_acct.
 *F735*              undo, retry.
 *F735*           end.
 *F735*        end.
 *G011* section commented out */

                     end.
/*F735*/          end.
               end.

               find ac_mstr no-lock
/*F681*/       where ac_code = substring(dr_acct,1,(8 - global_sub_len))
               no-error.
               if available ac_mstr then dr_desc = ac_desc.
               else dr_desc = "".

               find ac_mstr no-lock
/*F681*/       where ac_code = substring(cr_acct,1,(8 - global_sub_len))
               no-error.
               if available ac_mstr then cr_desc = ac_desc.
               else cr_desc = "".

               display dr_desc cr_desc with frame a.

               total_amt = unit_cost * total_lotserial_qty.
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output total_amt,
                                         input gl_rnd_mthd)"}
/*J053*/       total_amt_fmt = total_amt:format.
/*J053*/       {gprun.i ""gpcurfmt.p"" "(input-output total_amt_fmt,
                                         input gl_rnd_mthd)"}
/*J053*/       total_amt:format = total_amt_fmt.
               display total_amt with frame a.

               i = 0.
               for each sr_wkfl no-lock where sr_userid = mfguser
               and sr_lineid = cline:
                  i = i + 1.
                  if i > 1 then do:
                     leave.
                  end.
               end.

               if i > 1 then do on endkey undo mainloop, retry mainloop:
                  yn = yes.
                  {mfmsg01.i 359 1 yn}  /* DISPLAY LOTSERIALS BEING RECEIVED? */
                  if yn then do:
                     hide frame a.
                     form
                        pt_part
                     with frame b side-labels width 80.
                     display pt_part with frame b.
                     for each sr_wkfl no-lock where sr_userid = mfguser
                     with width 80:
                        display sr_site sr_loc sr_lotser
                        sr_ref format "x(8)" column-label {&icintr_p_9}
/*F0LZ                  sr_qty. */
/*F0LZ*/               sr_qty  format "->>>,>>>,>>9.9<<<<<<<<<".
                     end.
                  end.
               end.

/*K003*/       assign shipnbr = ""
/*K003*/              ship_date = ?
/*K003*/              inv_mov = "".

/*K003*/       /* Pop-up to collect shipment information */
/*K003*/       if transtype = "RCT-UNP" or
/*K003*/          transtype = "RCT-SOR" or
/*K003*/          transtype = "RCT-RS"  then do:
/*K003*/          ship_date = eff_date.
/*K003*/          pause 0.
/*K003*/          if shc_ship_rcpt then do:
/*K003*/             {gprun.i ""icshup.p"" "(input-output shipnbr,
                                             input-output ship_date,
                                             input-output inv_mov,
                                             input transtype, yes,
                                             input 10, input 20)"}
/*K003*/          end. /* if shc_ship_rcpt */
/*K003*/       end. /* if transtype = "RCT-UNP" or ... */

               do on endkey undo mainloop, retry mainloop:
                  yn = yes.
                  {mfmsg01.i 12 1 yn} /* IS ALL INFO CORRECT? */
/*G0V9*           if yn then leave setd.   */
/*G0V9*/          /* ADDED SECTION TO DO FINAL ISSUE CHECK */
/*G0V9*/          if yn then do:
/*G0V9*/             release ld_det.
/*G0V9*/             {icintr2.i "sr_userid = mfguser"
                                transtype
                                pt_part
                                trans_um
                                error-found
                                """"
                     }
/*G0V9*/
/*G0V9*/             if error-found
/*G0V9*/             then do:
/*G0V9*/                /* UNABLE TO ISSUE OR RECEIVE FOR ITEM*/
/*G0V9*/                {mfmsg02.i 161 3 part}
/*G0V9*/                next setd.
/*G0V9*/             end.
/*G0V9*/             leave setd.
/*G0V9*/          end.
/*G0V9*/                   /* END OF ADDED SECTION */
               end.
            end. /*setd*/

/*F003*/    /*MOVED SECTION TO ICINTRA.P DUE TO R-CODE LIMIT*/

/*K08N*/ /* Added input param "i_addship" to execute shipper-creation code */
/*K003* /*F003*/ {gprun.i ""icintra.p""}  */
/*K003*/    {gprun.i ""icintra.p"" "(shipnbr, ship_date, inv_mov, true)" }

/*J1CZ*/    hide frame b.
         end.
         /* mainloop */
