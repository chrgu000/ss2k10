/* GUI CONVERTED from repkupd.p (converter v1.76) Wed Dec 18 20:55:28 2002    */
/* repkupd.p - REPETITIVE PICKLIST CALCULATION                                */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxrepkup0.i "new"}
{xxrepkup1.i "new"}
{xxrepkrp0.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkupd_p_1 "Production Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_2 "Delete When Done"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_3 "Picklist Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_4 "Detail Requirements"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_7 "Release Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_9 "Qty Required"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_10 "Use Work Center Inventory"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_11 "Qty Short"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_12 "Qty to Transfer"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkupd_p_13 "WC Net Avail"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable site like si_site.
define shared variable site1 like si_site.
define shared variable wkctr like op_wkctr.
define shared variable wkctr1 like op_wkctr.
define shared variable part like ps_par.
define shared variable part1 like ps_par.
define shared variable comp1 like ps_comp.
define shared variable comp2 like ps_comp.
define shared variable desc1 like pt_desc1.
define shared variable desc2 like pt_desc1.
define shared variable issue like wo_rel_date
   label {&repkupd_p_1}.
define shared variable issue1 like wo_rel_date.
define shared variable reldate like wo_rel_date
   label {&repkupd_p_7}.
define shared variable reldate1 like wo_rel_date.
define shared variable nbr as character format "x(10)"
   label {&repkupd_p_3}.
define shared variable delete_pklst like mfc_logical initial no
   label {&repkupd_p_2}.
define shared variable nbr_replace  as character format "x(10)".
define shared variable qtyneed like wod_qty_chg
   label {&repkupd_p_9}.
define shared variable netgr like mfc_logical initial yes
   label {&repkupd_p_10}.
define shared variable detail_display like mfc_logical
   label {&repkupd_p_4}.
define shared variable um like pt_um.

define shared variable wc_qoh like ld_qty_oh.
define shared variable temp_qty like wod_qty_chg.
define shared variable temp_nbr like lad_nbr.
define shared variable ord_max like pt_ord_max.
define shared variable comp_max like wod_qty_chg.
define shared variable pick-used like mfc_logical.
define shared variable isspol like pt_iss_pol.
define variable vwkline as character.
define variable wk_rate as decimal no-undo.

define variable ladqtyall like lad_qty_all no-undo.
define variable aviqty as decimal no-undo.
define variable vqty as decimal no-undo.
define variable vtype as character no-undo.
define variable multqty as decimal no-undo.
define variable errorst as character no-undo.
define variable errornum as integer  no-undo.
define variable i        as integer  no-undo.
define variable j        as integer  no-undo.
define variable startTime as integer no-undo.
define variable endTime as integer no-undo.

/* USE TEMP-TABLE IN PLACE OF WORKFILE TO IMPROVE PERFORMANCE     */
/* 使用临时表代替工作文件提高性能                                 */
define var  iii as int no-undo.

define temp-table shortages no-undo
   field short-part  like ps_comp
   field short-assy  like ps_par
   field short-qty   like wod_qty_chg column-label {&repkupd_p_11}
   field short-date  like wr_start
   index shortages short-part short-date short-assy.

define variable v_lead_minus as integer no-undo.

/* TEMP-TABLE TO STORE NET AVAILABLE QUANTITY FOR EACH COMPONENT */
/* TO PRINT SHORTAGE LIST                                        */
/* 临时表用于存放净可用量，并打印短缺列表                        */

define temp-table net_comp no-undo
   field net_part like ps_comp
   field net_qty  like wod_qty_chg
   index net net_part.

define temp-table xx_ld
  fields xl_recid as integer
  fields xl_qty   as decimal
  index xl_recid is primary xl_recid.

assign
   nbr_replace = ""
   wc_qoh      = 0
   pick-used   = no
   temp_nbr    = nbr.

run gett0(input reldate, input reldate1,
          input site, input site1,
          input wkctr, input wkctr1).
  {xxrepkdis1.i}

/* FIND AND DISPLAY                                                         */
/* rps_mstr 重复生产排程表                                                  */

/* for each qad_wkfl no-lock where qad_key1 = "xxpsref":                    */
/*    delete qad_wkfl.                                                      */
/* end.                                                                     */
/* assign errornum = 1.                                                     */

for each usrw_wkfl exclusive-lock where usrw_key1 = "xxrepkup0.p":
delete usrw_wkfl.
end.

/*删除缺料明细资料*/
for each usrw_wkfl exclusive-lock where usrw_key1 = "XXMRPPORP0.P-SHORTAGELIST"
     and usrw_datefld[1] >= issue and usrw_datefld[1] <= issue1:
     delete usrw_wkfl.
end.

assign i = 1
       j = 1.
for each rps_mstr no-lock
where rps_part >= part and rps_part <= part1
  and rps_site >= site and rps_site <= site1
  and (rps_due_date >= issue and rps_due_date <= issue1)
  and (rps_rel_date >= reldate and rps_rel_date <= reldate1),
each wo_mstr no-lock where wo_lot = string(rps_record)
  and wo_part = rps_part and wo_type = "S"
  and wo_site = rps_site and wo_status <> "C",
each wr_route no-lock where wr_lot = wo_lot,
first wc_mstr no-lock
where wc_wkctr = wr_wkctr
  and wc_mch = wr_mch
  and wc_wkctr >= wkctr and wc_wkctr <= wkctr1,
each wod_det no-lock where wod_lot = wr_lot
  and wod_op = wr_op
  and wod_part >= comp1 and wod_part <= comp2
  and not can-find (first qad_wkfl where qad_key1 = "pt_kanban"
  and qad_key2 = wod_part)
break by wo_site by wr_wkctr by wod_part by wod_deliver
by wr_start by wr_part by wr_op
   with frame c width 132 no-attr-space down no-box:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

   if first-of(wr_wkctr) then do:

      pick-used = yes.

      do on error undo, retry:

         do while can-find (first lad_det
            where lad_dataset = "rps_det"
              and lad_nbr begins
              trim(string(wo_site,"x(8)") + string(nbr,"x(10)"))):
            {gprun.i ""gpnbr.p"" "(16,input-output nbr)"}
            /* gpnbr.p 加密程序 */
         end. /* do while can-find */

         create lad_det.
         assign
            lad_dataset = "rps_det"
            lad_nbr     = string(wo_site,"x(8)") + string(nbr,"x(10)")
            lad_line    = "rps_det"
            lad_part    = "rps_det"
            lad_site    = string(mfguser,"x(10)")
            lad_loc     = "rps_det"
            lad_lot     = "rps_det"
            lad_ref     = "rps_det".
      end. /* do on error undo, retry */

      /* ADDED frame b DEFINITION */
      FORM /*GUI*/
         wo_site
         wr_wkctr
         wc_desc no-label
         nbr
         skip(1)
      with  /*GUI*/  frame b width 132 side-labels page-top.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display
         wo_site
         wr_wkctr
         wc_desc no-label    when (available wc_mstr)
         string(nbr,"x(10)") when (not delete_pklst) @ nbr
         nbr_replace         when (delete_pklst) @ nbr
         skip(1)
      with frame b width 132 side-labels page-top  /*GUI*/ .
   end. /* if first-of(wr_wkctr) */

   view frame b.
   /* isspol = Yes 发放原则 */
   isspol = yes.
   find ptp_det no-lock
   where ptp_site = wod_site
     and ptp_part = wod_part no-error.
   if available ptp_det then
      isspol = ptp_iss_pol.
   else do:
      find pt_mstr no-lock where pt_part = wod_part no-error.
      if available pt_mstr then
         isspol = pt_iss_pol.
   end.

   if isspol then do:
      accumulate max(wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss,0)
         (total by wod_deliver).

      if first-of (wod_deliver) then do with frame c:
         assign
            desc1 = ""
            desc2 = ""
            um    = "".
         find pt_mstr no-lock where pt_part = wod_part no-error.
         if available pt_mstr then
            assign
               desc1 = pt_desc1
               desc2 = pt_desc2
               um    = pt_um.
         if detail_display then
            display wod_part @ ps_comp desc1 WITH  /*GUI*/ .

      end. /* if first-of (wod_deliver) do */
      else
      if desc2 <> "" and detail_display then do with frame c:
         display
            desc2 @ desc1 WITH  /*GUI*/ .
         desc2 = "".
      end. /* if first-of (wod_deliver) else */
      create xx_pklst.
      assign xx_site = wo_site
             xx_line = wr_wkctr
             xx_nbr = string(nbr)
             xx_comp = wod_part
/*           xx_qty_req = max(wod_qty_req - wod_qty_iss,0)                */
             xx_qty_req = wod_qty_req       /* 总需求量 */
             xx_qty_need = max(wod_qty_req - wod_qty_iss,0)  /* 缺料量 */
             xx_qty_iss = wod_qty_iss
             xx_um = um
             xx_par = wr_part
             xx_due_date = wo_due_date
             xx_op = wr_op
             xx_mch = wr_mch
             xx_start = wr_start.
/*      create qad_wkfl.                                          */
/*      assign qad_key1 = "xxpsref"                               */
/*             qad_key2 = string(errnumber)                       */
/*             qad_key3 = wod_part                                */
/*             qad_key5 = wr_part                                 */
/*             qad_decfld[1] = max(wod_qty_req - wod_qty_iss,0).  */
      if detail_display then do:
         display
            max(wod_qty_req - wod_qty_iss,0) @ wod_qty_req
            um
            wr_part @ ps_par
            wo_due_date
            wr_op
            wr_mch
            wr_start WITH  /*GUI*/ .
      end.
      /* CREATE RECORDS IN shortage TABLE FOR EACH COMPONENT'S DEMAND */
      run store_demand (buffer wod_det, buffer wr_route).

      if last-of (wod_deliver) then do:

         ord_max = 0.
         find ptp_det no-lock
         where ptp_part = wo_part and ptp_site = wo_site no-error.
         if available ptp_det then
            ord_max = ptp_ord_max.
         else do:
            find pt_mstr no-lock where pt_part = wo_part no-error.
            if available pt_mstr then
               ord_max = pt_ord_max.
         end. /* if available ptp_det */
         comp_max = 0.
         if ord_max <> 0 then
            comp_max = wod_qty_req / wo_qty_ord * ord_max.
         /* qtyneed 为需求数量，从Wod表进行合计汇总 */
         qtyneed = (accum total by wod_deliver
                   (max(wod_qty_req - wod_qty_all -
                    wod_qty_pick - wod_qty_iss,0))).

         /* netgr = yes  考虑工作中心在库 */

   if netgr then do:
            /* Added wo_lot as input parameter */
            {gprun.i ""repkupb.p"" "(wo_site,
                                     wr_wkctr,
                                     wod_part,
                                     issue1,
                                     qtyneed,
                                     wo_lot,
                                     input-output wc_qoh)"}
    end.   /* if netgr then do: */

         temp_qty = 0.
         if netgr then
            assign
               temp_qty = min(qtyneed, wc_qoh)
               qtyneed  = qtyneed - temp_qty.
         /* 如果考虑车间在库，则减去车间在库wc_qoh */
         nbr = string(wo_site,"x(8)") + nbr.

         {gprun.i ""xxrepkall.p"" "(nbr,
                                  wod_part,
                                  wo_site,
                                  wr_wkctr,
                                  wod_deliver,
                                  comp_max,
                                  input-output qtyneed)" }

         if detail_display then do
            with frame dd width 132 no-attr-space down no-box:

            display
               skip
            with frame e  /*GUI*/ .

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame dd:handle).

            display
               "" @ ps_comp no-label
               "" @ desc1 no-label WITH  /*GUI*/ .

            display
               accum total by wod_deliver
               (max(wod_qty_req - wod_qty_all -
               wod_qty_pick - wod_qty_iss,0)) @ wod_qty_req
               um WITH  /*GUI*/ .

            display
               wc_qoh @ ld_qty_oh column-label {&repkupd_p_13} WITH  /*GUI*/ .

            wc_qoh = wc_qoh - temp_qty.

            for each lad_det no-lock
            where lad_dataset = "rps_det"
              and lad_nbr = nbr and lad_line = wr_wkctr
              and lad_part = wod_part and lad_site = wo_site
              and lad_user1 = wod_deliver
            break by lad_dataset by lad_nbr by lad_line
            by lad_part by lad_site with frame dd:

               display
                  lad_loc
                  lad_lot
                  lad_qty_all column-label {&repkupd_p_12}
                  lad_user1 @ wod_deliver WITH  /*GUI*/ .

               accumulate lad_qty_all (total).

               if last-of (lad_site) = no then
                  down 1.
            end.

            if qtyneed > 0 then do with frame dd:
               if can-find
                  (first lad_det where lad_dataset = "rps_det"
                  and lad_nbr = nbr and lad_line = wr_wkctr
                  and lad_part = wod_part
                  and lad_site = wo_site) then
                  down 1.

               display
                  "" @ lad_lot
                  qtyneed @ lad_qty_all /* WITH  GUI*/ .

            end.

            down 1.

         end.  /* detail_display 详细显示 */
               /* 简略显示 Start */
         else do with frame d width 132 no-attr-space down no-box:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame d:handle).
            display
               wod_part @ ps_comp desc1 WITH  /*GUI*/ .

            display
               accum total by wod_deliver
               (max(wod_qty_req - wod_qty_all -
               wod_qty_pick - wod_qty_iss,0)) @ wod_qty_req
               um WITH  /*GUI*/ .

            display
               wc_qoh @ ld_qty_oh column-label {&repkupd_p_13} WITH  /*GUI*/ .

            wc_qoh = wc_qoh - temp_qty.
            for each lad_det no-lock
            where lad_dataset = "rps_det"
              and lad_nbr = nbr and lad_line = wr_wkctr
              and lad_part = wod_part and lad_site = wo_site
              and lad_user1 = wod_deliver
            break by lad_dataset by lad_nbr by lad_line
            by lad_part by lad_site with frame d:
                create usrw_wkfl.
                assign usrw_key1 = "xxrepkup0.p"
                       usrw_key2 = string(i)
                       usrw_key3 = wod_part
                       usrw_key4 = nbr
                       usrw_key5 = wo_site
                       usrw_key6 = wr_wkctr
                       usrw_charfld[1] = lad_lot
                       usrw_charfld[2] = lad_lot
                       usrw_decfld[1] = max(wod_qty_req - wod_qty_all -
                                        wod_qty_pick - wod_qty_iss,0)
                       usrw_decfld[2] = lad_qty_all.
                assign i = i + 1.
               display
                  lad_loc
                  lad_lot
                  lad_qty_all column-label {&repkupd_p_12}
                  lad_user1 @ wod_deliver WITH  /*GUI*/ .

               accumulate lad_qty_all (total).

               if last-of (lad_site) = no
                  or (detail_display = no and desc2 <> "") then
                  down 1.

               if detail_display = no and desc2 <> "" then
                  display
                     desc2 @ desc1 WITH  /*GUI*/ .

               desc2 = "".
            end.

            if qtyneed > 0 then do with frame d:
               if can-find (first lad_det
                  where lad_dataset = "rps_det"
                    and lad_nbr = nbr and lad_line = wr_wkctr
                    and lad_part = wod_part
                    and lad_site = wo_site)
                     or (detail_display = no and desc2 <> "") then
                  down 1.

               if detail_display = no and desc2 <> "" then
                  display
                     desc2 @ desc1 WITH  /*GUI*/ .

               desc2 = "".

               display
                  "" @ lad_lot
                  qtyneed @ lad_qty_all WITH  /*GUI*/ .

            end.

            down 1.

         end. /* 简略显示 */

         /* STORE AVAILABLE QUANTITY IN shortages TABLE */

         run store_avail_qty (input (accum total by wod_deliver
                                    (max(wod_qty_req  - wod_qty_all -
                                     wod_qty_pick - wod_qty_iss,0))),
                              input wod_part).

         nbr = substring(nbr,9).
      end.

   end.  /* if isspol */

   /* FOR SHORTAGE LIST PRINTING, DELETE THOSE COMPONENT DEMANDS */
   /* FOR WHICH AVAILABLE QTY CAN BE ADJUSTED. AND SUMMARIZE     */
   /* DEMANDS BY PARENT ITEMS.                                   */

   if last-of(wod_part) then
      run adjust_demand (input wod_part).

   if last-of (wr_wkctr) then do:

      find first lad_det
      where lad_dataset = "rps_det"
        and lad_nbr begins trim(string(wo_site,"x(8)") + string(nbr,"x(10)"))
        and lad_part <> "rps_det" no-lock no-error.

      find first shortages no-error.
      if available shortages then do:

         hide frame b.

         page.

         /* 打印物料短缺清单 */
         FORM /*GUI*/
            skip(1) space(19)
            wo_site wr_wkctr
            wc_desc no-label
            nbr_replace label {&repkupd_p_3}
         with  /*GUI*/  frame shortage page-top width 132 side-labels
         title color normal (getFrameTitle("S_H_O_R_T_A_G_E___L_I_S_T",36)).

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame shortage:handle).

         display
            wo_site
            wo_site
            wr_wkctr
            wc_desc             when (available wc_mstr)
            string(nbr,"x(10)") when (not delete_pklst) @ nbr_replace
            nbr_replace         when (delete_pklst)
         with frame shortage  /*GUI*/ .

         /* PRINT DESCRIPTION OF PART ONLY ONCE. */

         for each shortages exclusive-lock
         break by short-part by short-date
         with frame short width 132 no-attr-space:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame short:handle).

            find pt_mstr no-lock
            where pt_part = short-part no-error.

            if page-size - line-counter < 1 then
               page.

            display
               space(19)
            with frame short  /*GUI*/ .

            if first-of(short-part) then
               display
                  short-part @ ps_comp
                  pt_desc1 when (available pt_mstr)
               with frame short  /*GUI*/ .

            display
               short-qty
               pt_um when (available pt_mstr)
               short-assy @ ps_par
            with frame short  /*GUI*/ .

            create xx_pklst.
            assign xx_site = wo_site
                   xx_line = wr_wkctr
                   xx_nbr = string(nbr,"x(10)") when (not delete_pklst)
                   xx_comp = short-part
/*                 xx_qty_req = max(wod_qty_req - wod_qty_iss,0)             */
                   xx_qty_req = short-qty       /* 总需求量 */
                   xx_qty_need = short-qty  /* 缺料量 */
                   xx_qty_iss = 0
                   xx_um = pt_um when (available pt_mstr)
                   xx_par = short-assy
                   xx_due_date = wo_due_date
                   xx_op = wr_op
                   xx_mch = wr_mch
                   xx_start =wr_start
                   xx_short = yes.
/*6.25*/
            create usrw_wkfl.
            assign usrw_key1 = "XXMRPPORP0.P-SHORTAGELIST"
                   usrw_key2 = string(today) + string(time) + string(j)
                   usrw_key3 = wo_site
                   usrw_key4 = wr_wkctr
                   usrw_key5 = string(nbr,"x(10)") when (not delete_pklst)
                   usrw_key6 = short-part
                   usrw_decfld[1] = short-qty
                   usrw_charfld[1] = pt_um when (available pt_mstr)
                   usrw_charfld[2] = short-assy
                   usrw_charfld[3] = wr_mch
                   usrw_intfld[1] = wr_op
                   usrw_datefld[1] = wo_due_date
                   usrw_datefld[2] = wr_start
                   usrw_charfld[10] = "NUMBER".
					  find first tmp_file0 where t0_date = wo_due_date and
                                       t0_site = wo_site and
                                       t0_line = wr_wkctr and 
                                       t0_part  = short-assy no-error.
            if available tmp_file0 then do:
            	assign usrw_intfld[2] = t0_start.
            end.
            assign j = j + 1.
            if first-of(short-part) then do:
               down 1.
               if available pt_mstr and pt_desc2 <> "" then
                  display
                     pt_desc2 @ pt_desc1
                  with frame short  /*GUI*/ .
            end. /* FIRST-OF(short-part) */

            if last-of(short-part) then
               down 1.

            delete shortages.
         end.
         hide frame shortage.
         view frame b.
         if not last (wr_wkctr) then page.
      end.
   end.

end.

/* 资料写入xxwa_det. */
/* SS lambert 20120311 begin */
       for each xxwd_det exclusive-lock where xxwd_date >= issue :
           if xxwd_type = "P" then  do:
             create tt1pwddet.
             assign
               tt1pwd_ladnbr    = xxwd_ladnbr
               tt1pwd_nbr       = xxwd_nbr
               tt1pwd_part      = xxwd_part
               tt1pwd_site      = xxwd_site
               tt1pwd_line      = xxwd_line
               tt1pwd_date      = xxwd_date
               tt1pwd_time      = xxwd_time
               tt1pwd_loc       = xxwd_loc
               tt1pwd_sn        = xxwd_sn
               tt1pwd_lot       = xxwd_lot
               tt1pwd_ref       = xxwd_ref
               tt1pwd_qty_plan  = xxwd_qty_plan
               tt1pwd_ok        = yes
             .
           end.
           if xxwd_type = "S" then  do:
             create tt1swddet.
             assign
               tt1swd_ladnbr    = xxwd_ladnbr
               tt1swd_nbr       = xxwd_nbr
               tt1swd_part      = xxwd_part
               tt1swd_site      = xxwd_site
               tt1swd_line      = xxwd_line
               tt1swd_date      = xxwd_date
               tt1swd_time      = xxwd_time
               tt1swd_loc       = xxwd_loc
               tt1swd_sn        = xxwd_sn
               tt1swd_lot       = xxwd_lot
               tt1swd_ref       = xxwd_ref
               tt1swd_qty_plan  = xxwd_qty_plan
               tt1swd_ok        = yes
             .
           end.
       end.
/* SS lambert 20120311 end */

 for each xxwa_det exclusive-lock where
          xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
          xxwa_site >= site and xxwa_site <= site1 and
          xxwa_line >= wkctr and xxwa_line <= wkctr1
     break by xxwa_nbr:
     /*
     if first-of(xxwa_nbr) then do:
       for each xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr:
         delete xxwd_det. /*备料明细*/
       end.
     end.
     */
     delete xxwa_det.   /*明细表*/
 end.

for each tmp_file0 no-lock , each xx_pklst no-lock
    where xx_due_date = t0_date
      and xx_line = t0_line
      and xx_site = t0_site
      and xx_par = t0_part break by t0_date by t0_site by t0_line
                                 by t0_start by xx_comp:
      if first-of(xx_comp) then do:
         assign aviqty = 0
                vqty = 0.
      end.
      assign vqty = vqty + xx_qty_req
             aviqty = aviqty +  round((t0_tttime / t0_wktime)  * xx_qty_req,0).
      if last-of(xx_comp) then do:
         create xxwa_det.
         assign xxwa_date = t0_date
                xxwa__dte01 = t0_date
                xxwa_site = t0_site
                xxwa_line = t0_line
                xxwa_par  = t0_par
                xxwa_part = xx_comp
                xxwa_ladnbr = xx_nbr
                xxwa_sn = t0_sn
                xxwa_rtime = t0_start
                xxwa_qty_req = vqty
                xxwa_qty_pln = aviqty
                xxwa__dec01 = xx_qty_need
                xxwa_recid = recid(xxwa_det)
                .
      end.
 /*   {xxrepkdis2.i}   */
 /*
    display t0_date t0_site t0_line t0_part
            t0_wktime
            t0_tttime
            string(t0_start,"hh:mm:ss") @ t0_start
            string(t0_end,"hh:mm:ss") @ t0_end
            t0_qtya
            t0_qty
            xx_comp
            xx_qty_req
            xx_nbr
            xx_op
            xx_start
            t0_tttime / t0_wktime * xx_qty_req @ t0_time
            t0_qty / t0_qtya * xx_qty_req @ xx_start
            with width 300 .
 */
end.

  for each xxwa_det exclusive-lock where xxwa_rtime >= 0 and xxwa_rtime < 32399:
      assign xxwa_date = xxwa__dte01 + 1.
  end.

 /*计算取料,发料时间区间*/
  for each xxwa_det exclusive-lock where
           xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_rtime:
        find first xxlnw_det no-lock where xxlnw_site = xxwa_site
               and xxlnw_line = xxwa_line and xxlnw_ptime = xxwa_rtime no-error.
        if available xxlnw_det then do:
           assign xxwa_pstime = xxlnw_pstime
                  xxwa_petime = xxlnw_petime
                  xxwa_sstime = xxlnw_sstime
                  xxwa_setime = xxlnw_setime.
        end.
        else do:
           assign xxwa_pstime = xxwa_rtime - 16200
                  xxwa_petime = xxwa_rtime - 14400
                  xxwa_sstime = xxwa_rtime - 9000
                  xxwa_setime = xxwa_rtime - 7200.
        end.


/********************************************************************
/*         assign vtype = "*".                                     */
/*         if first-of(xxwa_part) then do:                         */
/*            find first pt_mstr where pt_mstr.pt_part = xxwa_part */
/*                 no-lock no-error.                               */
/*            if available pt_mstr then do:                        */
/*               assign vtype = pt_mstr.pt__chr10.                 */
/*            end.                                                 */
/*         end.                                                    */
/*         find last xxlnm_det where xxlnm_line = xxwa_line        */
/*                and xxlnm_site = xxwa_site                       */
/*                and (xxlnm_type = vtype or xxlnm_type = "*")     */
/*                no-lock no-error.                                */
/*         if not available xxlnm_det then do:                     */
/*            find first xxlnm_det no-lock no-error.               */
/*         end.                                                    */
/*         if available xxlnm_det then do:                         */
/*            find first xxlnw_det where xxlnw_site = xxwa_site    */
/*                   and xxlnw_line = xxwa_line                    */
/*                   and xxlnw_sn = xxwa_sn no-lock no-error.      */
/*            if available xxlnw_det then do:                      */
/*            assign xxwa_pstime = xxwa_rtime - xxlnm_pkstart * 60 */
/*                   xxwa_petime = xxwa_rtime - xxlnm_pkend * 60   */
/*                   xxwa_sstime = xxwa_rtime - xxlnm_sdstart * 60 */
/*                   xxwa_setime = xxwa_rtime - xxlnm_sdend * 60.  */
/*            end.                                                 */
/*         end.                                                    */
/*         else do:                                                */
/*             assign xxwa_pstime = -1.                            */
/*         end.                                                    */
********************************************************************/
  end. /* for each xxwa_det exclusive-lock where  */

  /* D类(线外做的)物料在做个提前时间需要提前做 */
  assign v_lead_minus = 0.
  find first code_mstr no-lock where code_fldname = "PACK-ITEM-LEAD-MINS" and
             code_value = "DEFAULT-MINUTS" no-error.
  if available code_mstr then do:
     assign v_lead_minus = integer(code_cmmt) * 60 no-error.
  end.
  for each xxwa_det exclusive-lock where
           xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = ""),
      each usrw_wkfl no-lock where usrw_key1 = "PACK-ITEM-LEAD-LIST" and
           usrw_key2 = xxwa_part
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_rtime:
        assign xxwa_pstime = xxwa_pstime - v_lead_minus
               xxwa_petime = xxwa_petime - v_lead_minus
               xxwa_sstime = xxwa_sstime - v_lead_minus
               xxwa_setime = xxwa_setime - v_lead_minus.
  end.

  for each xxwa_det exclusive-lock where
           xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_rtime by xxwa_part:
      display xxwa_date xxwa_site xxwa_line xxwa_part xxwa_qty_pln
              string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime
              string(xxwa_pstime,"hh:mm:ss") @ xxwa_pstime
              string(xxwa_petime,"hh:mm:ss") @ xxwa_petime
              string(xxwa_sstime,"hh:mm:ss") @ xxwa_sstime
              string(xxwa_setime,"hh:mm:ss") @ xxwa_setime
              xxwa__log01 with width 300.
  end.


  /* 按最小包装量计算需求到 xxwa_ord_mult
/*   for each xxwa_det exclusive-lock:                                               */
/*     assign xxwa_ord_mult = xxwa_qty_pln.                                          */
/*   end.                                                                            */
/*   for each xxwa_det EXCLUSIVE-LOCK where                                          */
/*            xxwa_date >= issue and xxwa_date <= issue1 and                         */
/*            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and            */
/*            xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and        */
/*            xxwa_qty_pln > 0,                                                      */
/*       EACH pt_mstr NO-LOCK WHERE pt_part = xxwa_part AND                          */
/*           (pt__chr10 = "A" OR pt__chr10 = "C") AND                                */
/*            pt__qad19 <> 0                                                         */
/*            break by xxwa_date by xxwa_site by xxwa_line                           */
/*                  by xxwa_part by xxwa_rtime:                                      */
/*       IF FIRST-OF(xxwa_part) THEN DO:                                             */
/*            ASSIGN xxwa_ord_mult = getmult(xxwa_qty_pln,pt__qad19).                */
/*            aviqty = xxwa_ord_mult - xxwa_qty_pln.                                 */
/*       END.                                                                        */
/*       ELSE DO:                                                                    */
/*           IF aviqty >= xxwa_qty_pln THEN DO:                                      */
/*               ASSIGN xxwa_ord_mult = 0.                                           */
/*               ASSIGN aviqty = aviqty - xxwa_qty_pln.                              */
/*           END.                                                                    */
/*           ELSE DO:                                                                */
/*               ASSIGN xxwa_ord_mult = getmult((xxwa_qty_pln - aviqty),pt__qad19).  */
/*               aviqty = xxwa_ord_mult - xxwa_qty_pln.                              */
/*           END.                                                                    */
/*       END.                                                                        */
/*   END.                                                                            */
/*                                                                                   */
/*  /* 按最小包装量计算需求到 xxwa_ord_mult*/                                          */
/*   for each xxwa_det exclusive-lock:                                               */
/*     assign xxwa_ord_mult = xxwa_qty_pln.                                          */
/*   end.                                                                            */
/*   for each xxwa_det EXCLUSIVE-LOCK where                                          */
/*            xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and                     */
/*            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and            */
/*            xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and        */
/*            xxwa_qty_pln > 0,                                                      */
/*       EACH pt_mstr NO-LOCK WHERE pt_part = xxwa_part AND                          */
/*           (pt__chr10 = "A" OR pt__chr10 = "C") AND                                */
/*            pt__qad19 <> 0                                                         */
/*            break by xxwa_date by xxwa_site by xxwa_line                           */
/*                  by xxwa_part by xxwa_rtime:                                      */
/*       IF FIRST-OF(xxwa_part) THEN DO:                                             */
/*            assign aviqty = 0.                                                     */
/*            ASSIGN xxwa_ord_mult = getmult(xxwa_qty_pln - aviqty,pt__qad19).       */
/*            aviqty = xxwa_ord_mult - xxwa_qty_pln.                                 */
/*       END.                                                                        */
/*       ELSE DO:                                                                    */
/*           IF aviqty >= xxwa_qty_pln THEN DO:                                      */
/*               ASSIGN xxwa_ord_mult = 0.                                           */
/*               ASSIGN aviqty = aviqty - xxwa_qty_pln.                              */
/*           END.                                                                    */
/*           ELSE DO:                                                                */
/*               ASSIGN xxwa_ord_mult = getmult((xxwa_qty_pln - aviqty),pt__qad19).  */
/*               aviqty = xxwa_ord_mult - xxwa_qty_pln.                              */
/*           END.                                                                    */
/*       END.                                                                        */
/*   END.                                                                            */
/*                                                                                   */
/*  /* 按托数计算需求到 xxwa_pka_mult*/                                               */
/*   for each xxwa_det exclusive-lock:                                               */
/*     assign xxwa_pka_mult = xxwa_qty_pln.                                          */
/*   end.                                                                            */
/*   for each xxwa_det EXCLUSIVE-LOCK where                                          */
/*            xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and                     */
/*            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and            */
/*            xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and        */
/*            xxwa_qty_pln > 0,                                                      */
/*       EACH pt_mstr NO-LOCK WHERE pt_part = xxwa_part AND                          */
/*            (pt__chr10 = "A" OR pt__chr10 = "C") and pt__qad20 <> 0                */
/*            break by xxwa_date by xxwa_site by xxwa_line                           */
/*                  by xxwa_part by xxwa_rtime:                                      */
/*       IF FIRST-OF(xxwa_part) THEN DO:                                             */
/*            assign aviqty = 0.                                                     */
/*            ASSIGN xxwa_pka_mult = getmult(xxwa_qty_pln - aviqty,pt__qad20).       */
/*            aviqty = xxwa_pka_mult - xxwa_qty_pln.                                 */
/*       END.                                                                        */
/*       ELSE DO:                                                                    */
/*           IF aviqty >= xxwa_qty_pln THEN DO:                                      */
/*               ASSIGN xxwa_pka_mult = 0.                                           */
/*               ASSIGN aviqty = aviqty - xxwa_qty_pln.                              */
/*           END.                                                                    */
/*           ELSE DO:                                                                */
/*               ASSIGN xxwa_pka_mult = getmult((xxwa_qty_pln - aviqty),pt__qad20).  */
/*               aviqty = xxwa_pka_mult - xxwa_qty_pln.                              */
/*           END.                                                                    */
/*       END.                                                                        */
/*   END.                                                                            */
*/
/*计算单号,序号*/
for each xxwa_det exclusive-lock where
         xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
         xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
         xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
break by xxwa_date by xxwa_site by xxwa_line by xxwa_pstime by xxwa_part:
    if first-of(xxwa_pstime) then do:
      assign vtype = "".
      {gprun.i ""gpnrmgv.p"" "(""xxwa_det"",input-output vtype
                               ,output errorst,output errornum)" }
    end.
    assign xxwa_nbr = vtype .
end.

for each usrw_wkfl exclusive-lock where usrw_key1 = "XXMRPPORP0.P-SHORTAGELIST"
    and usrw_charfld[10] = "NUMBER"
    break by usrw_key3 by usrw_key4 by usrw_intfld[2]:
 if first-of(usrw_key4) then do:
   assign vtype = "".
   {gprun.i ""gpnrmgv.p"" "(""xxwa_det"",input-output vtype
                            ,output errorst,output errornum)" }
 end.
 assign usrw_charfld[10] = "N" + vtype . 
end.

for each xxwa_det no-lock where
          xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
          xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
          xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and
          xxwa_qty_pln > 0
          break by xxwa_date by xxwa_site by xxwa_line
                by xxwa_part by xxwa_rtime:
    find first tiss1 where
       tiss1_sdate    = xxwa_date and
       tiss1_rtime    = xxwa_rtime and
       tiss1_line     = xxwa_line and
       tiss1_part     = xxwa_part
       no-error.
     if not avail tiss1 then do:
       create tiss1.
       assign
         tiss1_sdate    = xxwa_date
         tiss1_nbr      = xxwa_nbr
         tiss1_pdate    = xxwa_date
         tiss1_ptime    = xxwa_pstime
         tiss1_stime    = xxwa_sstime
         tiss1_rtime    = xxwa_rtime
         tiss1_line     = xxwa_line
         tiss1_part     = xxwa_part
         tiss1_qty      = 0
       .
     end.
     tiss1_qty = tiss1_qty + xxwa_qty_pln.
end.

if netgr then do:
   for each tiss1 break by tiss1_part:
     if first-of(tiss1_part) then do:
       for each ld_det no-lock where ld_site = "gsa01" and
                ld_part = tiss1_part and ld_qty_oh > 0 :
         create tsupp.
         assign
           tsu_loc    =  ld_loc
           tsu_part   =  ld_part
           tsu_lot    =  ld_lot
           tsu_ref    =  ld_ref
           tsu_qty    =  ld_qty_oh
           tsu_flg    =  ""
           tsu_abc    =  ""
           tsu_lpacks =  0
           tsu_ltrail =  0
           tsu_bpacks =  0
           tsu_btrail =  0
           tsu_lit    =  0
           tsu_big    =  0
         .
       end.
     end.
   end.
end.
else do:  /*不考虑车间库存*/
   assign  vwkline = "".
   for each ln_mstr no-lock where ln_site = "gsa01" break by ln_site by ln_line:
       if first-of(ln_line) then do:
          assign  vwkline = vwkLine + ln_line + ",".
       end.
   end.

   for each tiss1 break by tiss1_part:
     if first-of(tiss1_part) then do:
       for each ld_det no-lock use-index ld_part_loc where ld_part = tiss1_part
                and ld_site = "gsa01"  and ld_loc <> "P-all"
                and index(vwkline,ld_loc + ",") = 0
                and ld_qty_oh > 0:
           create tsupp.
           assign
             tsu_loc    =  ld_loc
             tsu_part   =  ld_part
             tsu_lot    =  ld_lot
             tsu_ref    =  ld_ref
             tsu_qty    =  ld_qty_oh
             tsu_flg    =  ""
             tsu_abc    =  ""
             tsu_lpacks =  0
             tsu_ltrail =  0
             tsu_bpacks =  0
             tsu_btrail =  0
             tsu_lit    =  0
             tsu_big    =  0
         .
       end.
     end.
   end.
end.

thmsg = "" .
{gprun.i ""xxrepkupall.p""}
if length(thmsg) > 0 then do:
  display "存在不能执行的单据" with frame errmsg.
  for each ttmsg with frame errmsg:
    display tmsg.
  end.
end.
else do:
  assign i = 1.
  for each trlt1:
    find first xxwd_det where xxwd_nbr = trt1_nbr
       and  xxwd_type = "S"
       and  xxwd_date = trt1_sdate
       and  xxwd_time = trt1_stime
       and  xxwd_part = trt1_part
       and  xxwd_site = "GSA01"
       and  xxwd_line = trt1_line
       and  xxwd_lot  = trt1_lot
       and  xxwd_ref  = trt1_ref no-error.
    if not avail xxwd_det then do:
      CREATE xxwd_det.
      assign xxwd_nbr = trt1_nbr
             /*
             xxwd_ladnbr = "S"
             xxwd_recid = xxwa_recid
             */
             xxwd_type = "S"
             xxwd_date = trt1_sdate
             xxwd_time = trt1_stime
             xxwd__int03 = trt1_stime
             xxwd_part = trt1_part
             xxwd_site = "GSA01"
             xxwd_line = trt1_line
             xxwd_loc = trt1_loc
             xxwd_sn =  trt1_seq
             xxwd_lot = trt1_lot
             xxwd_ref = trt1_ref
             xxwd_qty_plan = 0
             .
    end.
    xxwd_qty_plan  =  xxwd_qty_plan + trt1_qty.
             i = i + 1.
  end.
  assign i = 1.
  for each trlt2:
    find first xxwd_det where xxwd_nbr = trt2_nbr
      and xxwd_type = "P"
      and xxwd_time = trt2_time
      and xxwd_date = trt2_date
      and xxwd_part = trt2_part
      and xxwd_site = "GSA01"
      and xxwd_line = ""
      and xxwd_loc = trt2_loc
      and xxwd_lot = trt2_lot
      and xxwd_ref = trt2_ref no-error.
    if not avail xxwd_det then do:
      CREATE xxwd_det.
      assign xxwd_nbr = trt2_nbr
             /*
             xxwd_ladnbr = "P"
             xxwd_recid = xxwa_recid
             */
             xxwd_type = "P"
             xxwd_time = trt2_time
             xxwd__int03 = trt2_time
             xxwd_date = trt2_date
             xxwd_part = trt2_part
             xxwd_site = "GSA01"
             xxwd_line = ""
             xxwd_loc = trt2_loc
             xxwd_sn =  trt2_seq
             xxwd_lot = trt2_lot
             xxwd_ref = trt2_ref
             xxwd_qty_plan = 0
             .
    end.
             xxwd_qty_plan  = xxwd_qty_plan + trt2_qty.
             i = i + 1.
  end.
end.

for each xxwd_det exclusive-lock break by xxwd_ladnbr by xxwd_line by xxwd_date desc :
    if first-of(xxwd_line) then do:
       find first xxlnw_det no-lock where xxlnw_site = xxwd_site
              and xxlnw_line = xxwd_line and xxlnw_on no-error.
       if available xxlnw_det then do:
          assign i = xxlnw_stime.
       end.
    end.
    if xxwd__int03 >= 0 and xxwd__int03 < i then do:
       assign xxwd_date = xxwd_date + 1.
    end.
end.

for each xxwd_det exclusive-lock break by xxwd_date by xxwd_type by xxwd_line
      by xxwd_time by xxwd_part:
      if first-of(xxwd_time) then do:
         assign startTime = 0
                endtime = 0.
         run getSEtime(input xxwd_type,
                      input xxwd_site,
                      input xxwd_line,
                      input xxwd_time,
                      output startTime,
                      output endTime).
     end.
     find first usrw_wkfl no-lock where usrw_key1 = "PACK-ITEM-LEAD-LIST" and
                usrw_key2 = xxwd_part no-error.
     if available usrw_wkfl then do:
        assign xxwd__int01 = startTime - v_lead_minus
               xxwd__int02 = endTime - v_lead_minus.
     end.
     else do:
        assign xxwd__int01 = startTime
               xxwd__int02 = endTime.
     end.
end.

/*处理没有生成xxwd_det的取料记录*/
find last xxwd_det no-lock use-index xxwd_nbr_recid no-error.
if available xxwd_det then do:
   assign j = xxwd_sn + 1.
end.

for each usrw_wkfl no-lock where usrw_key1 = "XXMRPPORP0.P-SHORTAGELIST"
				 and usrw_datefld[1] >= issue and usrw_datefld[1] <= issue1,
		each xxwa_det no-lock where
          xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
          xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
          xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and
          xxwa_site = usrw_key3 and xxwa_line = usrw_key4 and xxwa_part = usrw_key6
    break by xxwa_site by xxwa_part by xxwa__dte01 by xxwa_rtime:
    if first-of(xxwa_part) then do:
       assign vqty = 0
              aviqty = 0
              .
    end.
    assign vqty = vqty + xxwa_qty_pln.
    if last-of(xxwa_part) then do:
       find first xxwd_det no-lock where xxwd_type = "P" and xxwd_date = xxwa_date
              and xxwd_part = xxwa_part no-error.
       if not available xxwd_det then do:
          assign aviqty = 0
                 i = xxwa_rtime
                 startTime = xxwa_pstime
                 endTime = xxwa_petime.
       end.
       else do:
            assign aviqty = 0.
            for each xxwd_det no-lock where xxwd_type = "P" and xxwd_date = xxwa_date
                 and xxwd_part = xxwa_part:
                 assign aviqty = aviqty + xxwd_qty_plan
                        i = xxwd_time
                        startTime = xxwd__int01
                        endTime = xxwd__int02.
            end.
       end.
       if vqty > aviqty then do:
          create xxwd_det.
          assign xxwd_type = "P"
                 xxwd_nbr = xxwa_nbr
                 xxwd_recid = xxwa_recid
                 xxwd_date = xxwa_date
                 xxwd_time = i
                 xxwd__int03 = i
                 xxwd_part = xxwa_part
                 xxwd_site = "GSA01"
                 xxwd_line = ""
                 xxwd_loc = ""
                 xxwd_sn =  j
                 xxwd_lot = ""
                 xxwd_ref = ""
                 xxwd_qty_plan = vqty - aviqty
                 xxwd__int01 = startTime
                 xxwd__int02 = endTime
                 xxwd_stat = "C"
                 xxwd_pstat = "C"
                 xxwd_pstat = "C".
           assign j = j + 1.
        end. /*  if vqty > qviqty then do: */
    end.
end.
assign temp_nbr = "".
for each usrw_wkfl no-lock where usrw_key1 = "XXMRPPORP0.P-SHORTAGELIST"
				 and usrw_datefld[1] >= issue and usrw_datefld[1] <= issue1,
		each xxwa_det no-lock where
          xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
          xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
          xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and
          xxwa_site = usrw_key3 and xxwa_line = usrw_key4 and xxwa_part = usrw_key6
    break by xxwa_site by xxwa_line by xxwa_part by xxwa__dte01 by xxwa_rtime:
    if first-of(xxwa_part) then do:
       assign vqty = 0
              aviqty = 0
              .
    end.
    assign vqty = vqty + xxwa_qty_pln.
    if last-of(xxwa_part) then do:
       find first xxwd_det no-lock where xxwd_type = "S" and xxwd_date = xxwa_date
              and xxwd_part = xxwa_part and xxwd_line = xxwa_line no-error.
       if not available xxwd_det then do:
          assign temp_nbr = xxwa_nbr
                 aviqty = 0
                 i = xxwa_rtime
                 startTime = xxwa_pstime
                 endTime = xxwa_petime.
       end.
       else do:
            assign aviqty = 0.
            for each xxwd_det no-lock where xxwd_type = "P" and xxwd_date = xxwa_date
                 and xxwd_part = xxwa_part and xxwd_line = xxwa_line:
                 assign temp_nbr = xxwd_nbr
                        aviqty = aviqty + xxwd_qty_plan
                        i = xxwd_time
                        startTime = xxwd__int01
                        endTime = xxwd__int02.
            end.
       end.
       if vqty > aviqty then do:
          create xxwd_det.
          assign xxwd_type = "S"
                 xxwd_nbr = xxwa_nbr
                 xxwd_recid = xxwa_recid
                 xxwd_date = xxwa_date
                 xxwd_time = i
                 xxwd__int03 = i
                 xxwd_part = xxwa_part
                 xxwd_site = "GSA01"
                 xxwd_line = xxwa_line
                 xxwd_loc = ""
                 xxwd_sn =  j
                 xxwd_lot = ""
                 xxwd_ref = ""
                 xxwd_qty_plan = vqty - aviqty
                 xxwd__int01 = startTime
                 xxwd__int02 = endTime
                 xxwd_stat = "C"
                 xxwd_pstat = "C"
                 xxwd_pstat = "C".
           assign j = j + 1.
        end. /*  if vqty > qviqty then do: */
    end.
end.

for each xxwd_det exclusive-lock break by xxwd_type by xxwd_date
                                       by xxwd_line by xxwd__int01:
    if first-of(xxwd__int01) then do:
       assign temp_nbr = xxwd_nbr.
    end.
    if xxwd_nbr <> vtype then do:
       assign xxwd_nbr = temp_nbr.
    end.
end.

/* for each xxwd_det exclusive-lock where xxwd_type = "S"           */
/*     break by xxwd_type by xxwd_date by xxwd_line by xxwd__int01: */
/*     if first-of(xxwd_line) then do:                              */
/*        assign temp_nbr = xxwd_nbr.                               */
/*     end.                                                         */
/*     if xxwd_nbr <> temp_nbr then do:                             */
/*        assign xxwd_nbr = temp_nbr.                               */
/*     end.                                                         */
/* end.                                                             */

/*  empty temp-table xx_ld no-error.                                          */
/*  assign errornum = 10.                                                     */
/*  for each xxwa_det no-lock where                                           */
/*            xxwa_date >= issue and xxwa_date <= issue1 and                  */
/*            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and     */
/*            xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and */
/*            xxwa_pka_mult > 0                                               */
/*            break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr        */
/*                  by xxwa_part by xxwa_rtime:                               */
/*    if first-of(xxwa_part) then do:                                         */
/*       assign vqty = xxwa_pka_mult.                                         */
/*    end.                                                                    */
/*    for each ld_det use-index ld_part_loc WHERE ld_part = xxwa_part         */
/*         and ld_site = xxwa_site and ld_qty_oh > 0                          */
/*         AND can-find(first loc_mstr no-lock where loc_site = ld_site       */
/*                        and loc_loc = ld_loc and loc_user2 = "Y")           */
/*         and vqty > 0:                                                      */
/*          find first xx_ld where                                            */
/*                     xl_recid = integer(recid(ld_det)) no-error.            */
/*          if available xx_ld then do:                                       */
/*             assign multqty = xl_qty.                                       */
/*          end.                                                              */
/*         if ld_qty_oh - multqty > vqty then do:                             */
/*               CREATE xxwd_det.                                             */
/*               assign xxwd_nbr = xxwa_nbr                                   */
/*                      xxwd_ladnbr = "P"                                     */
/*                      xxwd_recid = xxwa_recid                               */
/*                      xxwd_part = ld_part                                   */
/*                      xxwd_site = ld_site                                   */
/*                      xxwd_line = xxwa_line                                 */
/*                      xxwd_loc = ld_loc                                     */
/*                      xxwd_sn =  errornum                                   */
/*                      xxwd_lot = ld_lot                                     */
/*                      xxwd_ref = ld_ref                                     */
/*                      xxwd_qty_plan  = vqty.                                */
/*                      vqty = 0.                                             */
/*                      errornum = errornum + 1.                              */
/*                find first xx_ld where                                      */
/*                           xl_recid = integer(recid(ld_det)) no-error.      */
/*                if not available xx_ld then do:                             */
/*                   create xx_ld.                                            */
/*                   assign xl_recid = integer(recid(ld_det)).                */
/*                end.                                                        */
/*                   assign xl_qty = xl_qty + vqty.                           */
/*            assign vqty = 0.                                                */
/*         end.                                                               */
/*         else do:  /*库存量小于需求量*/                                     */
/*             if ld_qty_oh - multqty > 0 then do:                            */
/*                                                                            */
/*               CREATE xxwd_det.                                             */
/*               assign xxwd_nbr = xxwa_nbr                                   */
/*                      xxwd_ladnbr = "P"                                     */
/*                      xxwd_recid = xxwa_recid                               */
/*                      xxwd_part = ld_part                                   */
/*                      xxwd_site = ld_site                                   */
/*                      xxwd_line = xxwa_line                                 */
/*                      xxwd_loc = ld_loc                                     */
/*                      xxwd_sn =  errornum                                   */
/*                      xxwd_lot = ld_lot                                     */
/*                      xxwd_ref = ld_ref                                     */
/*                      xxwd_qty_plan  = ld_qty_oh - multqty.                 */
/*                      vqty = vqty - (ld_qty_oh - multqty).                  */
/*                      errornum = errornum + 1.                              */
/*                find first xx_ld where                                      */
/*                           xl_recid = integer(recid(ld_det)) no-error.      */
/*                if not available xx_ld then do:                             */
/*                   create xx_ld.                                            */
/*                   assign xl_recid = integer(recid(ld_det)).                */
/*                end.                                                        */
/*                   assign xl_qty = xl_qty + ld_qty_oh - multqty.            */
/*             end.                                                           */
/*             if ld_qty_oh - multqty > xxwa_qty_pln then leave.              */
/*         end.   /*库存量小于需求量*/                                        */
/*    end.                                                                    */
/*  end.                                                                      */

/* for each xxwa_det no-lock where                                            */
/*           xxwa_date >= issue and xxwa_date <= issue1 and                   */
/*           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and      */
/*           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and  */
/*           xxwa_qty_pln > 0                                                 */
/*           break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr         */
/*                 by xxwa_part by xxwa_rtime:                                */
/*   if first-of(xxwa_part) then do:                                          */
/*      assign vqty = xxwa_ord_mult.                                          */
/*   end.                                                                     */
/*    FOR EACH ld_det use-index ld_part_loc WHERE ld_part = xxwa_part         */
/*         and ld_site = xxwa_site                                            */
/*         AND can-find(first loc_mstr no-lock where loc_site = ld_site       */
/*                        and loc_loc = ld_loc and loc_user2 = "Y")           */
/*         and vqty > 0                                                       */
/*                 NO-LOCK BY ld_lot :                                        */
/*        find first xx_ld where                                              */
/*                   xl_recid = integer(recid(ld_det)) no-error.              */
/*        if available xx_ld then do:                                         */
/*           assign aviqty = ld_qty_oh - ld_qty_all - xl_qty.                 */
/*        end.                                                                */
/*        else do:                                                            */
/*           assign aviqty = ld_qty_oh - ld_qty_all.                          */
/*        end.                                                                */
/*        if aviqty <= 0 then next.                                           */
/*        IF vqty > 0 THEN DO:                                                */
/*          IF vqty >= aviqty THEN DO:                                        */
/*              CREATE xxwd_det.                                              */
/*              assign xxwd_nbr = xxwa_nbr                                    */
/*                     xxwd_ladnbr = ""                                       */
/*                     xxwd_recid = xxwa_recid                                */
/*                     xxwd_part = ld_part                                    */
/*                     xxwd_site = ld_site                                    */
/*                     xxwd_line = xxwa_line                                  */
/*                     xxwd_loc = ld_loc                                      */
/*                     xxwd_sn =  errornum                                    */
/*                     xxwd_lot = ld_lot                                      */
/*                     xxwd_ref = ld_ref                                      */
/*                     xxwd_qty_plan  = aviqty.                               */
/*                     vqty = vqty - aviqty.                                  */
/*               errornum = errornum + 1.                                     */
/*               find first xx_ld where                                       */
/*                          xl_recid = integer(recid(ld_det)) no-error.       */
/*               if not available xx_ld then do:                              */
/*                  create xx_ld.                                             */
/*                  assign xl_recid = integer(recid(ld_det)).                 */
/*               end.                                                         */
/*                  assign xl_qty = xl_qty + aviqty.                          */
/*               if aviqty > xxwa_qty_pln then leave.                         */
/*          END.                                                              */
/*          ELSE DO:                                                          */
/*              CREATE xxwd_det.                                              */
/*              assign xxwd_nbr = xxwa_nbr                                    */
/*                     xxwd_ladnbr = ""                                       */
/*                     xxwd_recid = xxwa_recid                                */
/*                     xxwd_part = ld_part                                    */
/*                     xxwd_site = ld_site                                    */
/*                     xxwd_line = xxwa_line                                  */
/*                     xxwd_loc = ld_loc                                      */
/*                     xxwd_sn =  errornum                                    */
/*                     xxwd_lot = ld_lot                                      */
/*                     xxwd_ref = ld_ref                                      */
/*                     xxwd_qty_plan = vqty.                                  */
/*                     vqty = 0.                                              */
/*               errornum = errornum + 1.                                     */
/*               find first xx_ld where                                       */
/*                          xl_recid = integer(recid(ld_det)) no-error.       */
/*               if not available xx_ld then do:                              */
/*                  create xx_ld.                                             */
/*                  assign xl_recid = integer(recid(ld_det)).                 */
/*               end.                                                         */
/*                  xl_qty = xl_qty + vqty.                                   */
/*          END.                                                              */
/*      END.                                                                  */
/*    end.   /* FOR EACH ld_det */                                            */
/*    if vqty = 0 then next.                                                  */
/*  end.                                                                      */


/*     empty temp-table xx_ld no-error.                                      */
/*     assign errornum = 10.                                                 */
/*                                                                           */
/*     for each xxwa_det no-lock where                                       */
/*          xxwa_date >= issue and xxwa_date <= issue1 and                   */
/*          xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and      */
/*          xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "") and  */
/*          xxwa_qty_pln > 0                                                 */
/*          break by xxwa_date by xxwa_site by xxwa_line by xxwa_nbr         */
/*                by xxwa_part by xxwa_rtime:                                */
/*     if first-of(xxwa_part) then do:                                       */
/*        assign vqty = xxwa_qty_pln.                                        */
/*     end.                                                                  */
/*     for each lad_det exclusive-lock where lad_dataset = "rps_det"         */
/*              and lad_site = xxwa_site                                     */
/*              and lad_line = xxwa_line                                     */
/*              and lad_part = xxwa_part                                     */
/*              and index(lad_nbr,xxwa_ladnbr) > 0                           */
/*         AND can-find(first loc_mstr no-lock where loc_site = lad_site     */
/*                        and loc_loc = lad_loc and loc_user2 = "Y")         */
/*         by lad_lot:                                                       */
/*         find first xx_ld where                                            */
/*                    xl_recid = integer(recid(lad_det)) no-error.           */
/*         if available xx_ld then do:                                       */
/*            assign aviqty = lad_qty_all - xl_qty.                          */
/*         end.                                                              */
/*         else do:                                                          */
/*            assign aviqty = lad_qty_all.                                   */
/*         end.                                                              */
/*      if aviqty <= 0 then next.                                            */
/*           IF vqty > 0 THEN DO:                                            */
/*             IF vqty >= aviqty THEN DO:                                    */
/*                 CREATE xxwd_det.                                          */
/*                 assign xxwd_nbr = xxwa_nbr                                */
/*                        xxwd_ladnbr = lad_nbr                              */
/*                        xxwd_recid = xxwa_recid                            */
/*                        xxwd_part = lad_part                               */
/*                        xxwd_site = lad_site                               */
/*                        xxwd_line = xxwa_line                              */
/*                        xxwd_loc = lad_loc                                 */
/*                        xxwd_sn =  errornum                                */
/*                        xxwd_lot = lad_lot                                 */
/*                        xxwd_ref = lad_ref                                 */
/*                        xxwd_qty_plan  = aviqty.                           */
/*                        vqty = vqty - aviqty.                              */
/*                  errornum = errornum + 1.                                 */
/*                  find first xx_ld where                                   */
/*                             xl_recid = integer(recid(lad_det)) no-error.  */
/*                  if not available xx_ld then do:                          */
/*                     create xx_ld.                                         */
/*                     assign xl_recid = integer(recid(lad_det)).            */
/*                  end.                                                     */
/*                     assign xl_qty = xl_qty + aviqty.                      */
/*             END.                                                          */
/*             ELSE DO:                                                      */
/*                 CREATE xxwd_det.                                          */
/*                 assign xxwd_nbr = xxwa_nbr                                */
/*                        xxwd_ladnbr = lad_nbr                              */
/*                        xxwd_recid = xxwa_recid                            */
/*                        xxwd_part = lad_part                               */
/*                        xxwd_site = lad_site                               */
/*                        xxwd_line = xxwa_line                              */
/*                        xxwd_loc = lad_loc                                 */
/*                        xxwd_sn =  errornum                                */
/*                        xxwd_lot = lad_lot                                 */
/*                        xxwd_ref = lad_ref                                 */
/*                        xxwd_qty_plan = vqty.                              */
/*                        vqty = 0.                                          */
/*                  errornum = errornum + 1.                                 */
/*                  find first xx_ld where                                   */
/*                             xl_recid = integer(recid(lad_det)) no-error.  */
/*                  if not available xx_ld then do:                          */
/*                     create xx_ld.                                         */
/*                     assign xl_recid = integer(recid(lad_det)).            */
/*                  end.                                                     */
/*                     xl_qty = xl_qty + vqty.                               */
/*             END.                                                          */
/*         END.    /* IF vqty > 0 THEN DO: */                                */
/*     end.  /*for each lad_det*/                                            */
/*     end.                                                                  */


/*计算需要物料的项次,时间点 ------- 扣减在线库存                              */
/* for each xxwa_det exclusive-lock where                                     */
/*          xxwa_date >= issue and xxwa_date <= issue1 and                    */
/*          xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and       */
/*          xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")       */
/* break by xxwa_date by xxwa_site by xxwa_line by xxwa_part  by xxwa_rtime:  */
/*       if first-of (xxwa_part) then do:                                     */
/*          assign aviqty = 0.                                                */
/*         /*****  考虑在线库存                                               */
/*           for each ld_det no-lock where ld_site = xxwa_site and            */
/*                   ld_loc = xxwa_line and ld_part = xxwa_part:              */
/*                   aviqty = aviqty + ld_qty_oh.                             */
/*           end.                                                             */
/*          *******/                                                          */
/*       end.                                                                 */
/*       if aviqty > xxwa_qty_pln then do:                                    */
/*          assign xxwa_qty_loc = aviqty                                      */
/*                 xxwa_ord_mult = aviqty - xxwa_qty_pln                      */
/*                 xxwa_qty_need = 0                                          */
/*                 xxwa__dec01 = 0.                                           */
/*          assign aviqty = aviqty - xxwa_qty_pln.                            */
/*       end.                                                                 */
/*       else do:                                                             */
/*           assign xxwa_qty_loc = aviqty                                     */
/*                  xxwa_ord_mult = 0                                         */
/*                  xxwa_qty_need =  xxwa_qty_pln - aviqty                    */
/*                  xxwa__dec01 = xxwa_qty_pln - aviqty.                      */
/*                  aviqty = 0.                                               */
/*       end.                                                                 */
/* end.                                                                       */


/* ========================================================= */
/* PROCEDURE TO STORE COMPONENT DEMAND FOR EACH PARENT ITEM. */
/* UNIQUE RECORDS ARE CREATED FOR EACH SCHEDULE DATE.        */

PROCEDURE store_demand:

   define parameter buffer wod_det  for wod_det.
   define parameter buffer wr_route for wr_route.

   if (wod_qty_req - wod_qty_iss) > 0 then
   do:
      find first shortages where
         short-part  = wod_part and
         short-date  = wr_start and
         short-assy  = wr_part
         exclusive-lock no-error.
      if not available shortages then
      do:
         create shortages.
         assign
            short-part  = wod_part
            short-date  = wr_start
            short-assy  = wr_part.
      end. /* IF NOT AVAILABLE shortages */

      short-qty   = short-qty + (wod_qty_req - wod_qty_iss).

   end. /* IF (wod_qty_req - wod_qty_iss) > 0 */

END PROCEDURE. /* store_demand */

PROCEDURE store_avail_qty:

   define input parameter demand_qty  like wod_qty_chg no-undo.
   define input parameter demand_part like wod_part    no-undo.

   /* STORE NET AVAILABLE QUANTITY                */
   /* AVAILABLE QTY = (REQUIRED QTY - SHORT QTY)  */

   for first net_comp where
         net_part = demand_part
         exclusive-lock:
   end. /* FOR FIRST net_comp */

   if not available net_comp then
   do:
      create net_comp.
      net_part = demand_part.
   end. /* IF NOT AVAILABLE components */

   net_qty = net_qty + demand_qty - qtyneed.

END PROCEDURE. /* store_avail_qty */

PROCEDURE adjust_demand:
   define input parameter demand_part like wod_part no-undo.

   define variable l_date like wr_start    no-undo.
   define variable l_qty  like wod_qty_chg no-undo initial 0.

   /* TAKE NET AVAILABLE QUANTITY FROM TEMP-TABLE */

   for first net_comp exclusive-lock where
         net_part = demand_part:

      l_qty = net_qty.
      delete net_comp.
   end. /* FOR FIRST net_comp */

   if l_qty > 0 then
   for each shortages exclusive-lock where
         short-part = demand_part:

      /* DELETE THOSE DEMAND RECORDS FOR WHICH AVAILABLE QTY    */
      /* CAN BE ADJUSTED                                        */

      if l_qty - short-qty >= 0 then do:
         l_qty = l_qty - short-qty.
         delete shortages.
      end. /* IF l_qty - short-qty >= 0 */

      else do:

         /* WHEN DEMAND IS MORE THAN AVAILABLE QTY THEN */
         /* DEMAND = DEMAND - REMAINING QTY.            */
         /* NO CHANGE FOR REMAINING RECORDS             */

         assign
            short-qty = short-qty - l_qty
            l_qty     = 0.
      end. /* l_qty <= short-qty */

      if l_qty = 0 then leave.

   end. /* FOR EACH shortages */

   /* SUMMARIZE TOTAL DEMANDS BY PARENT ITEMS AND ASSIGN */
   /* THE FIRST SCHEDULE DATE                             */

   for each shortages exclusive-lock
         where short-part = demand_part
         break by short-assy by short-date:

      if first-of(short-assy) then
         l_date = short-date.

      accumulate short-qty (total by short-assy).

      if last-of(short-assy) then
      assign
         short-qty  = accum total by short-assy short-qty
         short-date = l_date.
      else
         delete shortages.

   end. /* FOR EACH shortages */

END PROCEDURE. /* adjust_demand */


/** 分割时间段 **/
PROCEDURE gett0:

define input parameter iDate as date.
define input parameter iDate1 as date.
define input parameter isite like si_site.
define input parameter isite1 like si_site.
define input parameter iline like ln_line.
define input parameter iline1 like ln_line.

define variable vtime   as decimal.
DEFINE VARIABLE recno   AS RECID.
define variable key2    as character.
define variable qty     as decimal.
EMPTY TEMP-TABLE tmp_file0 NO-ERROR.
/***********
for each qad_wkfl where qad_key1 = "xxrepkup0.p" and qad_datefld[1] >= idate
                    and qad_datefld[1] <= idate1
                    and qad_charfld[1] >= isite and qad_charfld[1] <= isite1
                    and qad_charfld[2] >= iline and qad_charfld[2] <= iline1:
     delete qad_wkfl.
end.
*************/
for each rps_mstr no-lock where rps_rel_date >= idate
     and rps_rel_date <= idate1
     and rps_line >= iLine
     and rps_line <= iline1
     AND rps_qty_req - rps_qty_comp > 0,
    last lnd_det no-lock where lnd_line = rps_line
     and lnd_site = rps_site and
        lnd_part = rps_part and lnd_start <= idate
 BREAK  BY rps_rel_date BY rps_site BY rps_line by integer(rps_user1):
       IF FIRST-OF(rps_line) THEN DO:
           EMPTY TEMP-TABLE tmp_file1.
           FOR EACH xxlnw_det NO-LOCK WHERE xxlnw_site = rps_site
               AND xxlnw_line = rps_line AND xxlnw_on:
               CREATE tmp_file1.
               ASSIGN t1_sn = xxlnw_sn
                      t1_avli = xxlnw_wktime
                      t1_start = xxlnw_stime
                      t1_pick = xxlnw_ptime
                      t1_end = xxlnw_etime.
           END.

       END.
       assign wk_rate = 1.
       find first shft_det no-lock where shft_site = rps_site and
                  shft_wkctr = rps_line and weekday(rps_rel_date) = shft_day
                  no-error.
       if available shft_det then do:
          assign wk_rate = shft_load1 / 100.
       end.
       ASSIGN vtime = (rps_qty_req - rps_qty_comp) / (lnd_rate * wk_rate).
       FOR EACH tmp_file1 EXCLUSIVE-LOCK WHERE
                t1_avli > 0 AND vtime > 0 BY t1_sn:
          IF t1_avli >= vtime THEN DO:
               CREATE tmp_file0.
               ASSIGN t0_record = rps_record
                   t0_date = rps_rel_date
                   t0_site = rps_site
                   t0_line = rps_line
                   t0_part  = rps_part
                   t0_user1 = substring("000000",1,6 - length(trim(rps_user1))) + trim(rps_user1)
                   t0_sn = t1_sn
                   t0_start = t1_pick   /*生产时间*/
                   t0_end   = t1_end
                   t0_wktime = (rps_qty_req - rps_qty_comp) / (lnd_rate * wk_rate)
                   t0_qtya = rps_qty_req - rps_qty_comp
                   t0_qty = truncate(t0_qtya * (vtime / t0_wktime) + 1,0)
                   t0_tttime = vtime.
               ASSIGN t1_avli = t1_avli - vtime.
               LEAVE.
           END.
           ELSE DO:
               CREATE tmp_file0.
               ASSIGN t0_record = rps_record
                  t0_date = rps_rel_date
                  t0_site = rps_site
                  t0_line = rps_line
                  t0_sn = t1_sn
                  t0_part  = rps_part
                  t0_user1 = substring("000000",1,6 - length(trim(rps_user1))) + trim(rps_user1)
                  t0_start = t1_pick
                  t0_end   = t1_end
                  t0_qtya = rps_qty_req - rps_qty_comp
                  t0_wktime = (rps_qty_req - rps_qty_comp) / (lnd_rate * wk_rate)
                  t0_tttime = t1_avli
                  t0_qty = truncate(t0_qtya * (t1_avli / t0_wktime) + 1,0)
                  .
               ASSIGN vtime = vtime - t1_avli.
               ASSIGN t1_avli = 0.
           END.
       END.
       for each tmp_file0 exclusive-lock break by t0_date by t0_part by t0_sn:
           if first-of(t0_part) then do:
              assign qty = t0_qtyA.
           end.
           if not last-of(t0_part) then
              assign qty = qty - t0_qty.
           if last-of(t0_part) then do:
              assign t0_qty = qty.
           end.
       end.
end.
/***********************
/* assign errornum = 1.                                                         */
/* for each tmp_file0 no-lock:                                                  */
/*     assign key2 = string(errornum) + string(today,"99-99-99") + string(time) */
/*                 + string(t0_date,"99-99-99")                                 */
/*                 + string(t0_start,"HH:MM:SS") + t0_part + string(t0_qty).    */
/*     find first qad_wkfl exclusive-lock where qad_key1 = "xxrepkup0.p"        */
/*            and qad_key2 = key2 no-error.                                     */
/*     if not available qad_wkfl then do:                                       */
/*         create qad_wkfl.                                                     */
/*         assign qad_key1 = "xxrepkup0.p"                                      */
/*                qad_key2 = key2.                                              */
/*     end.                                                                     */
/*     assign qad_key3 = t0_part                                                */
/*            qad_datefld[1] = t0_date                                          */
/*            qad_charfld[1] = t0_site                                          */
/*            qad_charfld[2] = t0_line                                          */
/*            qad_intfld[2] = t0_end                                            */
/*            qad_intfld[1] = t0_start                                          */
/*            qad_decfld[1] = t0_tttime / t0_wktime                             */
/*            qad_decfld[2] = t0_qty                                            */
/*            qad_decfld[3] = t0_qtya                                           */
/*            .                                                                 */
/*     assign errornum = errornum + 1.                                          */
/* end.                                                                         */
*********************************/
END PROCEDURE.
