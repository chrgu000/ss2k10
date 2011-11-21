/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110915.1   created on: 20110901  by: zhang yun                  */
/* V8:ConvertMode=Report                                                     */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "111121.1"}

define variable site like si_site.
define variable site1 like si_site.
define variable key1 as character INITIAL "xxmrpporp0.p" no-undo.
define variable part like pt_part. /* INITIAL "MHSE02-407-0-LX". */
define variable part1 like pt_part.
define variable due as date.
define variable duek as date.
define variable duee as date.
define variable duef as date.
define variable duet as date.
define variable vend like vd_addr. /* INITIAL "C02C016".         */
define variable buyer like pt_buyer INITIAL "4RSA".
define variable area as character format "x(1)".
define variable areaDesc as character format "x(40)".
define variable sendDate as date.
define variable tmpDate as date.
define variable qty_nextMth like pod_qty_ord.
define variable qty_tpod like pod_qty_ord.
define variable qty_pod like pod_qty_ord.
define variable qtytemp as decimal.
define variable xRule AS CHARACTER.
define variable xCyc as INTEGER.
define variable xType AS CHARACTER.
define variable detsum like mfc_logical
       label "Detail/Summary" format "Detail/Summary" initial NO.
define variable act as logical initial YES.
define variable tpoqty  like mrp_qty.
define variable tpoqtys like mrp_qty.
define variable tpopo   like mrp_qty.
define variable tpotpo  like mrp_qty.

define temp-table tmp_po
    fields tpo_nbr like po_nbr
    fields tpo_vend like vd_addr
    fields tpo_part like pt_part
    fields tpo_type as character
    fields tpo_due  like po_due_date
    fields tpo_mrp_date like po_due_date
    fields tpo_start  as date
    fields tpo_end  as date
    fields tpo_mrp_qty like mrp_qty
    fields tpo_qty like mrp_qty
    fields tpo_qtys like mrp_qty
    fields tpo_qty0 like mrp_qty
    fields tpo_po like pod_qty_ord
    fields tpo_tpo like pod_qty_ord
    fields tpo_rule as character
    fields tpo_rule0 as character
    fields tpo_fut as logical initial no
    index tpo_part_vend is primary tpo_part tpo_vend tpo_due.

define temp-table tmp_rule_date
    fields trd_rule AS CHARACTER
    fields trd_datef AS DATE
    fields trd_datet AS DATE.

define temp-table tmp_datearea
    fields td_rule as character
    fields td_key as character
    fields td_date as date
    index td_rule is primary td_rule td_date.

define temp-table tmp_tmd
   fields tm_vend like vd_addr
   fields tm_part like pt_part
   fields tm_rule0 as character
   fields tm_rule as character
   fields tm_month as character
   fields tm_sdate as date  /* mrp_due_date */
   fields tm_adate as date  /* first available send date */
   fields tm_edate as date  /* end send date*/
   fields tm_mrp_qty like mrp_qty
   fields tm_qty like mrp_qty
   index tm_rule is primary tm_rule
   index tm_vpa tm_vend tm_part tm_adate
   index tm_pm tm_part tm_month.

define buffer md for mrp_det.

/* SELECT FORM */
form
   site   colon 15
   site1  label {t001.i} colon 49 skip
   part   colon 15
   part1  label {t001.i} colon 49 skip(1)
   due    colon 25
   vend   colon 25
   area   colon 25 areaDesc no-label
   buyer  colon 25 skip(1)
   detsum colon 25
   act    colon 25 skip(1)

with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign due = date(month(today),28,year(today)).
assign due = date(month(due + 5),1,year(due + 5)).
assign due = date(month(due),28,year(due)).
assign due = date(month(due + 5),1,year(due + 5)) - 1.

assign areaDesc = getTermLabel("XVP_AREA_DESC",40).
display areaDesc with frame a.
display part @ part1 with frame a.
find first si_mstr no-lock no-error.
if available si_mstr then do:
   assign site = si_site
          site1 = si_site.
end.
/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".

   if c-application-mode <> 'web' then
      update site site1 part part1 due vend area buyer detsum act with frame a.

   {wbrp06.i &command = update
      &fields = " site site1 part part1 due vend area buyer detsum act "
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      {mfquoter.i site }
      {mfquoter.i site1}
      {mfquoter.i part }
      {mfquoter.i part1}
      {mfquoter.i due  }
      {mfquoter.i vend }
      {mfquoter.i buyer}
      {mfquoter.i detsum}
      {mfquoter.i act}

      if site1 = "" then site1 = hi_char.
      if part1 = "" then part1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 240
               &pagedFlag = "nopage"
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
  /* {mfphead.i} */
  empty temp-table tmp_datearea no-error.
  empty temp-table tmp_po no-error.
  empty temp-table tmp_tmd no-error.
  empty temp-table tmp_rule_date no-error.

  for each qad_wkfl exclusive-lock where qad_key1 = key1: delete qad_wkfl. end.
   assign sendDate = date(month(due),1,year(due)) - 10.
   for each code_mstr no-lock where code_fldname = "vd__chr03" and
            index(code_value,"M4") = 0 and code_value <> "" and
            code_value <> "P":
      run getParams(input "GSA01", input sendDate, input code_value,
                output xRule,output xCyc,output xType,
                output duef, output duet).
      create qad_wkfl.
      assign qad_key1 = key1
             qad_key2 = code_value + " " + string(duef)
             qad_charfld[1] = code_value
             qad_datefld[1] = duef.
      run getParams(input "GSA01", input due,input code_value,
                output xRule,output xCyc,output xType,
                output duef, output duet).
      create qad_wkfl.
      assign qad_key1 = key1
             qad_key2 = code_value + " " + string(duef)
             qad_charfld[1] = code_value
             qad_charfld[2] = "Key"
             qad_datefld[1] = duef.
      create qad_wkfl.
      assign qad_key1 = key1
             qad_key2 = code_value + " " + string(duet)
             qad_charfld[1] = code_value
             qad_datefld[1] = duet + 1.
   end.

   for each qad_wkfl no-lock where qad_key1 = key1
            break by qad_charfld[1] by qad_datefld[1]:
       if not last-of(qad_charfld[1]) and substring(qad_charfld[1],1,2) = "M2"
       then do:
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_key = qad_charfld[2]
                   td_date = qad_datefld[1].
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_date = qad_datefld[1] + 14.
       end.
       if substring(qad_charfld[1],1,2) = "M1" then do:
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_key = qad_charfld[2]
                   td_date = qad_datefld[1].
       end.
       if not last-of(qad_charfld[1]) and
              (substring(qad_charfld[1],1,2) = "M4" or
               substring(qad_charfld[1],1,1) = "W")
       then do:
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_key = qad_charfld[2]
                   td_date = qad_datefld[1].
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_date = qad_datefld[1] + 7.
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_date = qad_datefld[1] + 14.
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_date = qad_datefld[1] + 21.
            create tmp_datearea.
            assign td_rule = qad_charfld[1]
                   td_date = qad_datefld[1] + 28.
       end.
       if last-of(qad_charfld[1]) then do:
            if not can-find(first tmp_datearea where
                   td_rule = qad_charfld[1] and td_date = qad_datefld[1])
            then do:
                 create tmp_datearea.
                 assign td_rule = qad_charfld[1]
                        td_date = qad_datefld[1].
            end.
       end.
   end.

   for each tmp_datearea exclusive-lock:
       find last qad_wkfl where qad_key1 = key1 and qad_charfld[1] = td_rule
       no-error.
       if available(qad_wkfl) and td_date > qad_datefld[1] then do:
          delete tmp_datearea.
       end.
       find first hd_mstr no-lock where hd_site = "gsa01"
              and hd_date = td_date no-error.
       if available(hd_mstr) then do:
          delete tmp_datearea.
       end.
   end.

   for each qad_wkfl exclusive-lock where qad_key1 = key1
        and qad_charfld[2] = "KEY":
        find last tmp_datearea no-lock where td_rule = qad_charfld[1]
              and td_date < qad_datefld[1] no-error.
        if available tmp_datearea then do:
           assign qad_datefld[3] = td_date.
        end.
   end.

   For EACH vd_mstr no-lock where vd__chr03 <> "" break by vd__chr03:
       if first-of(vd__chr03) AND substring(vd__chr03,1,2) <> "M4"
       then do:
            assign duek = ?
                   duee = ?.
            find first tmp_datearea where td_rule = vd__chr03
                     and td_key = "Key" no-lock no-error.
            if available(tmp_datearea) then do:
               assign duek = td_date.
            end.
            find last tmp_datearea where td_rule = vd__chr03 no-lock no-error.
            if available(tmp_datearea) then do:
               assign duee = td_date.
            end.
            create tmp_rule_date.
            assign trd_rule = vd__chr03
                   trd_datef = duek
                   trd_datet = duee - 1.
       end.
   end.

   FOR EACH pt_mstr no-lock where pt_part >= part and pt_part <= part1
         and substring(pt_part,1,1) <> "X"
         and pt_site >= site and pt_site <= site1
         and pt_pm_code = 'P'
         and (pt_buyer = buyer or buyer = "")
         and pt_site >= site and (pt_site <= site1 or site1 = "")
         and (pt_vend = vend or vend = "")
         and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det no-lock WHERE mrp_det.mrp_part = pt_part and
            mrp_det.mrp_detail = "计划单" and
            mrp_site >= site and mrp_site <= site1 USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> "":
           create tmp_tmd.
           assign tm_vend = pt_vend
              tm_part = pt_part
              tm_rule0 = vd__chr03
              tm_rule = vd__chr03
              tm_sdate = mrp_due_date
              tm_qty = mrp_qty
              tm_mrp_qty = mrp_qty.
   end.

   /*计算P之Rule*/
   for each tmp_tmd use-index tm_pm exclusive-lock where tm_rule0 = "P":
       find first xvp_ctrl no-lock where xvp_vend = tm_vend and
                  xvp_part = tm_part no-error.
       if available xvp_ctrl then do:
         assign tm_rule = xvp_rule.
       end.
   end.

   /* 计算可到货日 */
   for each tmp_tmd exclusive-lock break by tm_rule:
       if first-of(tm_rule) then do:
          if substring(tm_rule,1,1) = "M" then do:
              assign xRule = entry(2,tm_rule,";").
          end.
          else do:
              assign xRule = substring(tm_rule,2).
          end.
       end.
       assign duek = tm_sdate.
       repeat:
          if index(xRule,string(weekday(duek) - 1)) > 0 then do:
             assign tm_adate = duek
                    tm_month = string(year(duek)) + string(month(duek)).
             leave.
          end.
          else do:
             assign duek = duek - 1.
          end.
       end.
   end.

   /*计算M4之Rule*/
   for each tmp_tmd use-index tm_pm exclusive-lock where
       substring(tm_rule,1,2) = "M4" break by tm_part by tm_month by tm_sdate:
       if first-of(tm_month) then do:
          find first mrp_det use-index mrp_partdate no-lock where
                     mrp_part = tm_part and
                     mrp_detail = "计划单"and
                     mrp_site >= site and mrp_site <= site1  and
                     mrp_due_date >= tm_adate no-error.
          if available mrp_det then do:
             if weekday(mrp_due_date) - 1 >= 1 and
                weekday(mrp_due_date) - 1 <= 2 then do:
                assign xRule = "W1".
             end.
             else if weekday(mrp_due_date) - 1 >= 3 and
                weekday(mrp_due_date) - 1 <= 4 then do:
                assign xRule = "W3".
             end.
             else do:
                assign xRule = "W5".
             end.
          end.
       end.
       assign tm_rule = xrule.
   end.

   /*删除不要的月份资料*/
   for each tmp_tmd exclusive-lock,
       each tmp_rule_date no-lock where trd_rule = tm_rule:
       if tm_sdate > trd_datet then do:
          delete tmp_tmd.
       end.
   end.

   /*计算到货日月*/
   for each tmp_tmd use-index tm_vpa exclusive-lock where tm_rule begins "M"
       break by tm_vend by tm_month by tm_adate:
       if first-of(tm_month) then do:
          assign duek = tm_adate.
          assign tm_edate = tm_adate.
       end.
       else do:
          if substring(tm_rule,1,2) = "M1" then do:
             assign tm_edate = duek.
          end.
          else if substring(tm_rule,1,2) = "M2" then do:
             if tm_adate >= duek + 14 then do:
                assign tm_edate = duek + 14.
             end.
             else do:
                assign tm_edate = duek.
             end.
          end.
       end.
   end.

   /*计算到货日周*/
   for each tmp_tmd use-index tm_pm exclusive-lock where tm_rule begins "W"
       break by tm_part by tm_month by tm_adate:
       if first-of(tm_month) then do:
          assign duek = tm_adate.
          assign tm_edate = tm_adate.
       end.
       else do:
            if tm_adate >= duek and tm_adate < duek + 7 then do:
                assign tm_edate = duek.
            end.
            else if tm_adate >= duek + 7 and tm_adate < duek + 14 then do:
                assign tm_edate = duek + 7.
            end.
            else if tm_adate >= duek + 14 and tm_adate < duek + 21 then do:
                assign tm_edate = duek + 14.
            end.
            else if tm_adate >= duek + 21 and tm_adate < duek + 28 then do:
                assign tm_edate = duek + 21.
            end.
            else do:
                assign tm_edate = duek + 28.
            end.
       end.
   end.
		
   for each tmp_tmd no-lock break by tm_part by tm_month by tm_edate:
       if first-of(tm_edate) then do:
          qtytemp = tm_qty.
       end.
       else do:
          qtytemp = qtytemp + tm_qty.
       end.
       if last-of(tm_edate) then do:
            create tmp_po.
            assign tpo_vend = tm_vend
                   tpo_part = tm_part
                   tpo_due = tm_edate
                   tpo_qty = qtytemp
                   tpo_qtys = qtytemp
                   tpo_mrp_qty = qtytemp
                   tpo_rule0 = tm_rule0
                   tpo_rule = tm_rule.
       end.
   end.
   
   for each tmp_po exclusive-lock:
   		 find last tmp_datearea where td_rule = tpo_rule and td_date <= tpo_due 
   		 			no-lock no-error.
   		 if available(tmp_datearea) and tpo_due <> td_date then do:	
   		 		assign tpo_due = td_date.
   		 end.
   end.

   /*如下2月有计划则产生数量为0的记录*/
   assign duef = date(month(due),28,year(due)) + 5.
   assign duef = date(month(duef),1,year(duef)).
   assign duet = duef + 65.
   assign duet = date(month(duet),1,year(duet)) - 1.
   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1
            and substring(pt_part,1,1) <> "X"
            and pt_site >= site and pt_site <= site1
            and pt_pm_code = 'P'
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det no-lock WHERE mrp_det.mrp_part = pt_part and
            mrp_det.mrp_detail = "计划单" and
            mrp_site >= site and mrp_site <= site1 and
            mrp_det.mrp_due_date >= duef and mrp_det.mrp_due_date <= duet
            USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> "":
       find first tmp_po no-lock where tpo_vend = pt_vend
              and tpo_part = pt_part no-error.
       if not available tmp_po then do:
          create tmp_po.
          assign tpo_vend = pt_vend
                 tpo_part = pt_part
                 tpo_due = duef - 1
                 tpo_qty = 0
                 tpo_rule = vd__chr03
                 tpo_rule0 = vd__chr03
                 tpo_fut = yes.
       end.
   END.

    for each tmp_po exclusive-lock,each pt_mstr no-lock where
             pt_part = tpo_part:
         find first xvp_ctrl where xvp_vend = pt_vend
               and xvp_part = pt_part no-lock no-error.
         if availabl xvp_ctrl then do:
           assign tpo_type = xvp__chr01.
         end.
    end.

    for each tmp_po exclusive-lock where tpo_type = "T" and tpo_qty > 0:
        find first tmp_datearea where td_rule = tpo_rule and
                   td_date > tpo_due no-error.
        if available tmp_datearea then do:
           assign tpo_end = td_date - 1.
        end.
        else do:
           assign tpo_end = hi_date.
        end.
        assign qty_tpod = 0
               qty_pod = 0.
        for each pod_det no-lock use-index pod_partdue where
                 pod_part = tpo_part and pod_due_date >= tpo_due and
                 pod_due_date <= tpo_end:
            if pod_type = "T" then do:
               assign qty_tpod = qty_tpod + pod_qty_ord.
            end.
            else do:
               assign qty_pod = qty_pod + pod_qty_ord.
            end.
        end.
        assign tpo_po = qty_pod
               tpo_tpo = qty_tpod
               tpo_qty = tpo_qty - qty_tpod.
    end.
	
		for each tmp_po exclusive-lock:
				assign tpo_qty0 = tpo_qty.
	  end.
	
    /*产生单号*/
    for each tmp_po exclusive-lock where tpo_vend <> ""
        break by tpo_vend :
        if first-of(tpo_vend) then do:
           assign areaDesc = "P" + substring(string(year(due),"9999"),3)
                           + string(month(due),"99").
           find first vd_mstr no-lock where vd_addr = tpo_vend no-error.
           if available vd_mstr then do:
              assign areaDesc = areaDesc + substring(vd_sort,1,2).
           end.
           find last po_mstr use-index po_nbr where po_nbr begins(areadesc) and
                                       po_nbr <= areadesc + "9" no-error.
           if available po_mstr then do:
             assign areaDesc = areaDesc
                  + string(int(substring(po_nbr,length(po_nbr))) + 1,"9").
           end.
           else do:
             assign areaDesc = areaDesc + "1".
           end.
        end.
        assign tpo_nbr = areaDesc.
    end.
    if detsum then do:
       export delimiter "~011" getTermLabel("SUPPLIER",12)
                               getTermLabel("ITEM_NUMBER",12)
                               getTermLabel("SHIP_TERMS",12)
                               getTermLabel("AS_OF_DATE",12)
                               getTermLabel("ARRIVE_DATE",12)
                               getTermLabel("QUANTITY_REQUESTED",12)
                               getTermLabel("AS_OF_DATE_Week",12)
                               getTermLabel("ARRIVE_DATE_WEEK",12)
                               getTermLabel("COMMENT",12).
       for each tmp_tmd use-index tm_pm no-lock
                break by tm_part by tm_month by tm_sdate:
            find first code_mstr no-lock where code_fldname = "vd__chr03"
                   and code_value = tm_rule0 no-error.
            export delimiter "~011" tm_vend tm_part tm_rule0 tm_sdate
                             tm_edate tm_qty weekday(tm_sdate) - 1
                             weekday(tm_edate) - 1
                             code_cmmt when available code_mstr tm_rule.
       end.
    end.      /*if detsum then do:    */
    else do:  /* display summary data */
         assign areaDesc = "".
         for each qad_wkfl exclusive-lock where qad_key1 = key1 + "_Det":
             delete qad_wkfl.
         end.
         export delimiter "~011" getTermLabel("PO_NUMBER",12)
                                 getTermLabel("SUPPLIER",12)
                                 getTermLabel("ITEM_NUMBER",12)
                                 getTermLabel("RECEIVED_QTY",12)
                                 getTermLabel("DUE_DATE",12)
                                 getTermLabel("TYPE",12)
                                 getTermLabel("DEMAND_QTY",12)
                                 getTermLabel("PO_QTY",12)
                                 getTermLabel("TEMP_PO_QTY",12)
                                 getTermLabel("WEEK",12)
                                 getTermLabel("SHIP_TERMS",12)
                                 getTermLabel("COMMENT",12).
         /*                      getTermLabel("START",12)                    */
         /*                      getTermLabel("END",12)                      */
         /*                      getTermLabel("EXPIRATION_DATE",12).         */

         for each tmp_po no-lock where tpo_qty < 0 break by tpo_part:
             if first-of(tpo_part) then do:
                create qad_wkfl.
                assign qad_key1 = key1 + "_Det"
                       qad_key2 = tpo_part.
            end.
         end.

         for each qad_wkfl use-index qad_index2 where qad_key1 = key1 + "_Det"
             break by qad_key1 by qad_key2:
             for each tmp_po exclusive-lock where tpo_part = qad_key2
                 break by tpo_part by tpo_due:
                 if first-of(tpo_part) then do:
                    assign qtytemp = 0.
                 end.
                 if qtytemp = 0 and tpo_qty >= 0 then do:
                    next.
                 end.
                 if qtytemp <= 0 then do:
                    assign qtytemp = qtytemp + tpo_qty.
                    if qtytemp >= 0 then do:
                       assign tpo_qty = qtytemp.
                       assign qtytemp = 0.
                    end.
                    else do:
                       assign tpo_qty = 0.
                    end.
                 end.
             end.
         end.

         for each tmp_po no-lock
             where (tpo_qty > 0 or tpo_fut) or not act 
             break by tpo_nbr by tpo_vend by tpo_part by tpo_due: 
             if first-of(tpo_due) then do:
             	  assign tpoqty = 0
             	  			 tpoqtys = 0
             	  			 tpopo = 0
             	  			 tpotpo = 0.
             end.          
             assign tpoqty = tpoqty + tpo_qty
             				tpoqtys = tpoqtys + tpo_qtys
             				tpopo = tpopo + tpo_po
             				tpotpo = tpotpo + tpo_tpo.
             if last-of(tpo_due) then do:
                 assign areaDesc = "".
                 find first code_mstr no-lock where code_fldname = "vd__chr03"
                        and code_value = tpo_rule no-error.
                 if available code_mstr then do:
                    assign areaDesc = code_cmmt.
                 end.
                 export delimiter "~011" tpo_nbr tpo_vend tpo_part tpoqty
                        tpo_due tpo_type tpoqtys tpopo tpotpo 
                        weekday(tpo_due) - 1 
                        tpo_rule0 areaDesc.
                 /*    tpo_end tpo_rule tpo_po tpo_tpo.  tpo_mrp_date. */
            end.
         end.

end.      /*if detsum else do:    */
/* REPORT TRAILER  */
/*   {mfrtrail.i} */
  {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

PROCEDURE getParams:
/*------------------------------------------------------------------------------
    Purpose: 计算日期范围
      Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iSite LIKE SI_SITE.
    DEFINE INPUT PARAMETER iDate AS DATE.
    DEFINE INPUT PARAMETER iRule AS CHARACTER.

    DEFINE OUTPUT PARAMETER oRule AS CHARACTER.
    DEFINE OUTPUT PARAMETER oCyc as INTEGER.
    DEFINE OUTPUT PARAMETER oType AS CHARACTER.
    DEFINE OUTPUT PARAMETER oStart AS DATE.
    DEFINE OUTPUT PARAMETER oEnd AS DATE.

    ASSIGN oType = SUBSTRING(iRule ,1 ,1).
    IF oType = "M" THEN
        ASSIGN oRule = entry(2, iRule , ";")
               oCyc = integer(substring(entry(1, iRule , ";"),2)).
    ELSE
        ASSIGN oRule = substring(iRule,2).
    oStart = date(month(iDate),1,year(iDate)).
    repeat:
       if index(oRule,string(weekday(oStart) - 1)) > 0 and
          not can-find(first hd_mstr no-lock where
                             hd_site = iSite and hd_date = oStart) then do:
            leave.
       end.
       else oStart = oStart + 1.
    end.
    oEnd = DATE(MONTH(oStart),28,YEAR(oStart)) + 5.
    oEnd = DATE(MONTH(oEnd),1,YEAR(oEnd)).
    repeat:
          if index(oRule,string(weekday(oEnd) - 1)) > 0  and
          not can-find(first hd_mstr no-lock where
                             hd_site = isite and hd_date = oEnd) then do:
               leave.
          end.
          else oEnd = oEnd + 1.
    end.
    oEnd = oEnd - 1.
END PROCEDURE.

procedure expTmd:
/*------------------------------------------------------------------------------
  Purpose：Userd to test program , You can delete it when after confrimed.
    Notes: Delete This Procedure.
------------------------------------------------------------------------------*/
   export delimiter "~011"  "tm_vend"
                            "tm_part"
                            "tm_rule0"
                            "tm_rule"
                            "tm_month"
                            "tm_sdate"
                            "tm_adate"
                            "tm_edate"
                            "tm_qty" skip.
   for each tmp_tmd no-lock:
       export delimiter "~011" tmp_tmd.
   end.
end procedure.
