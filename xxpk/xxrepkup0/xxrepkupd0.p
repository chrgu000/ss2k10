/* GUI CONVERTED from repkupd.p (converter v1.76) Wed Dec 18 20:55:28 2002 */
/* repkupd.p - REPETITIVE PICKLIST CALCULATION                                */



/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxrepkup0.i "new"}
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

/* USE TEMP-TABLE IN PLACE OF WORKFILE TO IMPROVE PERFORMANCE     */
/* 使用临时表代替工作文件提高性能                                 */

define temp-table shortages no-undo
   field short-part  like ps_comp
   field short-assy  like ps_par
   field short-qty   like wod_qty_chg column-label {&repkupd_p_11}
   field short-date  like wr_start
   index shortages short-part short-date short-assy.

/* TEMP-TABLE TO STORE NET AVAILABLE QUANTITY FOR EACH COMPONENT */
/* TO PRINT SHORTAGE LIST                                        */
/* 临时表用于存放净可用量，并打印短缺列表                        */

define temp-table net_comp no-undo
   field net_part like ps_comp
   field net_qty  like wod_qty_chg
   index net net_part.

/*临时表用于记录成品对应物料领料关系*/
define temp-table xx_pklst no-undo
	fields xx_site like si_site
	fields xx_line like op_wkctr
	fields xx_nbr  as character format "x(10)"
	fields xx_comp like wod_part
	fields xx_qty_req like wod_qty_req
	fields xx_um like pt_um
	fields xx_par  like wo_part
	fields xx_due_date like wo_due_date
	fields xx_op  like wr_op
	fields xx_mch like wr_mch
	fields xx_start like wr_start.


assign
   nbr_replace = getTermLabel("TEMPORARY",10)
   wc_qoh      = 0
   pick-used   = no
   temp_nbr    = nbr.

      
run gett0(input reldate, input reldate1,
				  input site, input site1,
				  input wkctr, input wkctr1).

/* FIND AND DISPLAY */
/* rps_mstr 重复生产排程表 */
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
      with STREAM-IO /*GUI*/  frame b width 132 side-labels page-top.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display
         wo_site
         wr_wkctr
         wc_desc no-label    when (available wc_mstr)
         string(nbr,"x(10)") when (not delete_pklst) @ nbr
         nbr_replace         when (delete_pklst) @ nbr
         skip(1)
      with frame b width 132 side-labels page-top STREAM-IO /*GUI*/ .
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
            display wod_part @ ps_comp desc1 WITH STREAM-IO /*GUI*/ .

      end. /* if first-of (wod_deliver) do */
      else
      if desc2 <> "" and detail_display then do with frame c:
         display
            desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
         desc2 = "".
      end. /* if first-of (wod_deliver) else */

      if detail_display then do:      		
         display
            max(wod_qty_req - wod_qty_iss,0) @ wod_qty_req
            um
            wr_part @ ps_par
            wo_due_date
            wr_op
            wr_mch
            wr_start WITH STREAM-IO /*GUI*/ .
         
         create xx_pklst.
         assign xx_site = wo_site                                 
	              xx_line = wr_wkctr                                
	              xx_nbr = string(nbr)                                  
	              xx_comp = wod_part                                 
	              xx_qty_req =  max(wod_qty_req - wod_qty_iss,0)                       
	              xx_um = um                             
	              xx_par = wr_part                        
	              xx_due_date = wo_due_date
	              xx_op = wr_op
	              xx_mch = wr_mch
	              xx_start =wr_start.
            
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
         end.

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
            with frame e STREAM-IO /*GUI*/ .

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame dd:handle).

            display
               "" @ ps_comp no-label
               "" @ desc1 no-label WITH STREAM-IO /*GUI*/ .

            display
               accum total by wod_deliver
               (max(wod_qty_req - wod_qty_all -
               wod_qty_pick - wod_qty_iss,0)) @ wod_qty_req
               um WITH STREAM-IO /*GUI*/ .

            display
               wc_qoh @ ld_qty_oh column-label {&repkupd_p_13} WITH STREAM-IO /*GUI*/ .

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
                  lad_user1 @ wod_deliver WITH STREAM-IO /*GUI*/ .

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
                  getTermLabelRtColon("QUANTITY_SHORT",18) @ lad_lot
                  qtyneed @ lad_qty_all WITH STREAM-IO /*GUI*/ .

            end.

            down 1.

         end.  /* detail_display 详细显示 */
               /* 简略显示 Start */
         else do with frame d width 132 no-attr-space down no-box:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame d:handle).
            display
               wod_part @ ps_comp desc1 WITH STREAM-IO /*GUI*/ .

            display
               accum total by wod_deliver
               (max(wod_qty_req - wod_qty_all -
               wod_qty_pick - wod_qty_iss,0)) @ wod_qty_req
               um WITH STREAM-IO /*GUI*/ .

            display
               wc_qoh @ ld_qty_oh column-label {&repkupd_p_13} WITH STREAM-IO /*GUI*/ .

            wc_qoh = wc_qoh - temp_qty.

            for each lad_det no-lock
            where lad_dataset = "rps_det"
              and lad_nbr = nbr and lad_line = wr_wkctr
              and lad_part = wod_part and lad_site = wo_site
              and lad_user1 = wod_deliver
            break by lad_dataset by lad_nbr by lad_line
            by lad_part by lad_site with frame d:

               display
                  lad_loc
                  lad_lot
                  lad_qty_all column-label {&repkupd_p_12}
                  lad_user1 @ wod_deliver WITH STREAM-IO /*GUI*/ .

               accumulate lad_qty_all (total).

               if last-of (lad_site) = no
                  or (detail_display = no and desc2 <> "") then
                  down 1.

               if detail_display = no and desc2 <> "" then
                  display
                     desc2 @ desc1 WITH STREAM-IO /*GUI*/ .

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
                     desc2 @ desc1 WITH STREAM-IO /*GUI*/ .

               desc2 = "".

               display
                  getTermLabelRtColon("QUANTITY_SHORT",18) @ lad_lot
                  qtyneed @ lad_qty_all WITH STREAM-IO /*GUI*/ .

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
         with STREAM-IO /*GUI*/  frame shortage page-top width 132 side-labels
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
         with frame shortage STREAM-IO /*GUI*/ .

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
            with frame short STREAM-IO /*GUI*/ .

            if first-of(short-part) then
               display
                  short-part @ ps_comp
                  pt_desc1 when (available pt_mstr)
               with frame short STREAM-IO /*GUI*/ .

            display
               short-qty
               pt_um when (available pt_mstr)
               short-assy @ ps_par
            with frame short STREAM-IO /*GUI*/ .

            if first-of(short-part) then do:
               down 1.
               if available pt_mstr and pt_desc2 <> "" then
                  display
                     pt_desc2 @ pt_desc1
                  with frame short STREAM-IO /*GUI*/ .
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

for each tmp_file0 no-lock , each xx_pklst no-lock
	  where xx_due_date = t0_date 
		  and xx_line = t0_line
		  and xx_site = t0_site
		  and xx_par = t0_part by t0_date by t0_site by t0_line by t0_start:
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
						with width 300 stream-io.
end.

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

EMPTY TEMP-TABLE tmp_file0 NO-ERROR.
 
for each rps_mstr no-lock where rps_rel_date >= idate
     and rps_rel_date <= idate1
     and rps_line >= iLine
     and rps_line <= iline1 
     AND rps_qty_req - rps_qty_comp > 0,
    each lnd_det no-lock where lnd_line = rps_line
     and lnd_site = rps_site and
        lnd_part = rps_part 
 BREAK BY rps_rel_date BY rps_site BY rps_line BY rps_part BY rps_user1:
       IF FIRST-OF(rps_line) THEN DO:
           EMPTY TEMP-TABLE tmp_file1.
           FOR EACH xxlnw_det NO-LOCK WHERE xxlnw_site = rps_site
               AND xxlnw_line = rps_line AND xxlnw_on:
               CREATE tmp_file1.
               ASSIGN t1_sn = xxlnw_sn
                      t1_avli = xxlnw_wktime
                      t1_start = xxlnw_stime
                      t1_end = xxlnw_etime.
           END.
          
       END.
       ASSIGN vtime = (rps_qty_req - rps_qty_comp) / lnd_rate.
       FOR EACH tmp_file1 EXCLUSIVE-LOCK WHERE 
       			    t1_avli > 0 AND vtime > 0 BY t1_sn:
          IF t1_avli >= vtime THEN DO:
               CREATE tmp_file0.
               ASSIGN t0_record = rps_record
                   t0_date = rps_rel_date
                   t0_site = rps_site
                   t0_line = rps_line
                   t0_part  = rps_part
                   t0_user1 = rps_user1
                   t0_sn = t1_sn
                   t0_start = t1_start
                   t0_end   = t1_end
                   t0_wktime = (rps_qty_req - rps_qty_comp) / lnd_rate
                   t0_qtya = rps_qty_req - rps_qty_comp
                   t0_qty =truncate(t0_qtya * (vtime / t0_wktime),0)
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
                  t0_user1 = rps_user1
                  t0_start = t1_start
                  t0_end   = t1_end
                  t0_qtya = rps_qty_req - rps_qty_comp
                  t0_wktime = (rps_qty_req - rps_qty_comp) / lnd_rate
                  t0_tttime = t1_avli
                  t0_qty = truncate(t0_qtya * (t1_avli / t0_wktime),0)
                  .
               ASSIGN vtime = vtime - t1_avli.
               ASSIGN t1_avli = 0.
           END.
       END.
end.

END PROCEDURE.