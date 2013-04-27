/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110915.1   created on: 20110901  by: zhang yun                  */
/* V8:ConvertMode=Report                                                     */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/
/* T����PO����һ������������ƽ�⡣                                  /*628*/  */
/* T����PO����һ������������ʾ�ڱ�����                              /*629*/  */
/* ������Բ���ɶ�������                                             /*630*/  */
/* ������Բ���ɶ��������ļ����������                               /*719*/  */
/* ���˵����õ�����                                                 /*831*/  */
/* DISPLAY TITLE */
{mfdtitle.i "121227.1"}

define variable site like si_site.
define variable site1 like si_site.
define variable key1 as character INITIAL "xxmrpporp0.p" no-undo.
define variable vkey1 like usrw_key1 no-undo
                  initial "XXMRPPORP0.P-ITEM-ORDER-POLICY".
define variable vkey0 like usrw_key1 initial "xxmrpporp0.p.dataset.121218.1" no-undo.
define variable part like pt_part.
define variable part1 like pt_part.
define variable due as date.
define variable duek as date.
define variable duee as date.
define variable duef as date.
define variable duet as date.
define variable vend like vd_addr.
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
define variable act as logical initial yes.
define variable tpoqty  like mrp_qty.
define variable tpoqtys like mrp_qty.
define variable tpopo   like mrp_qty.
define variable tpotpo  like mrp_qty.
define variable i as integer.
define variable T       as   logical initial "YES".
define variable tpo1date as date.
define variable aqty as decimal.
define variable adjqty as decimal.
define stream bf.
define temp-table tmp_po1
       fields tp1_part like pt_part
       fields tp1_po as decimal format "->>>,>>>,>>>,>>>,9.9<"
       fields tp1_tpo as decimal format "->>>,>>>,>>>,>>>,9.9<"
       fields tp1_apo as decimal format "->>>,>>>,>>>,>>>,9.9<"
       index tp1_part tp1_part.

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

/*��2��Ԥʾ��*/
define temp-table tmp_n2po
       fields tn2_part like pt_part
       fields tn2_qty as decimal.

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
   fields tm_sdate as date  /* mrp_due_date              */
   fields tm_adate as date  /* first available send date */
   fields tm_edate as date  /* end send date             */
   fields tm_mrp_qty like mrp_qty
   fields tm_qty like mrp_qty
   index tm_rule is primary tm_rule
   index tm_vpa tm_vend tm_part tm_adate
   index tm_pm tm_part tm_month.
define buffer usrwwkfl for usrw_wkfl.
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
   act    colon 25
   t      colon 25 skip(1)

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
      update site site1 part part1 due vend area buyer detsum act t
      with frame a.

   {wbrp06.i &command = update
      &fields = " site site1 part part1 due vend area buyer detsum act t "
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
  empty temp-table tmp_po1 no-error.
  empty temp-table tmp_tmd no-error.
  empty temp-table tmp_rule_date no-error.
  empty temp-table tmp_n2po no-error.

  for each qad_wkfl exclusive-lock where qad_key1 = key1: delete qad_wkfl. end.
  for each usrw_wkfl exclusive-lock where usrw_key1 = vkey0: delete usrw_wkfl. end.
   assign sendDate = today - 3.
   for each code_mstr no-lock where code_fldname = "vd__chr03" and
            index(code_value,"M4") = 0 and code_value <> "" and
            code_value <> "P" and code_value <> "1":
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

   /* �ų��ڼ��� */
   for each tmp_datearea exclusive-lock:
       find last qad_wkfl where qad_key1 = key1 and qad_charfld[1] = td_rule
       no-error.
       if available(qad_wkfl) and td_date > qad_datefld[1] then do:
          delete tmp_datearea.
          next.
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

   for each code_mstr no-lock where code_fldname = "vd__chr03" and
            code_value <> "" and substring(code_value,1,2) <> "M4" and
            code_value <> "P":
            assign duek = ?
                   duee = ?.
            find first tmp_datearea where td_rule = code_value
                     and td_key = "Key" no-lock no-error.
            if available(tmp_datearea) then do:
               assign duek = td_date.
            end.
            find last tmp_datearea where td_rule = code_value no-lock no-error.
            if available(tmp_datearea) then do:
               assign duee = td_date.
            end.
            create tmp_rule_date.
            assign trd_rule = code_value
                   trd_datef = duek
                   trd_datet = duee - 1.
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
            mrp_det.mrp_detail = "�ƻ���" and
            mrp_site >= site and mrp_site <= site1 USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> "":
           create tmp_tmd.
           assign tm_vend = pt_vend
              tm_part = pt_part
              tm_rule0 = vd__chr03
              tm_rule = vd__chr03
              tm_sdate = mrp_due_date
              tm_edate = mrp_due_date
              tm_qty = mrp_qty
              tm_mrp_qty = mrp_qty.
   end.

   /*�Ϻ���rule���Ϻ��趨��ruleΪ׼  ����P֮Rule */
   for each tmp_tmd use-index tm_pm exclusive-lock:
       find first usrw_wkfl no-lock where usrw_key1 = vkey1 and
                  usrw_key2 = tm_part and usrw_key3 <> "" and usrw_key3 <> "1"
                  no-error.
       if available usrw_wkfl and
            can-find(first code_mstr where code_fldname = "vd__chr03"
                       and code_value = usrw_key2) then do:
          assign tm_rule0 = usrw_key3
                 tm_rule = usrw_key3.
       end.
/*       find first pt_mstr no-lock where pt_part = tm_part and pt_rev <> ""  */
/*              and pt_rev <> "1"                                             */
/*            no-error.                                                       */
/*       if available pt_mstr and                                             */
/*            can-find(first code_mstr where code_fldname = "pt_rev"          */
/*                      and code_value = pt_rev) then do:                     */
/*          assign tm_rule0 = pt_rev                                          */
/*                 tm_rule = pt_rev.                                          */
/*       end.                                                                 */
   end.

/*  ����P֮Rule
   for each tmp_tmd use-index tm_pm exclusive-lock where tm_rule0 = "P":
       find first xvp_ctrl no-lock where xvp_vend = tm_vend and
                  xvp_part = tm_part no-error.
       if available xvp_ctrl then do:
         assign tm_rule = xvp_rule.
       end.
   end.
*/
   /* ����ɵ����� */
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

   /*����M4֮Rule*/
   for each tmp_tmd use-index tm_pm exclusive-lock where
       substring(tm_rule,1,2) = "M4" break by tm_part by tm_month by tm_sdate:
       if first-of(tm_month) then do:
          find first mrp_det use-index mrp_partdate no-lock where
                     mrp_part = tm_part and
                     mrp_detail = "�ƻ���"and
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

   /*ɾ����Ҫ���·�����*/
   for each tmp_tmd exclusive-lock,
       each tmp_rule_date no-lock where trd_rule = tm_rule:
       if tm_sdate > trd_datet then do:
          delete tmp_tmd.
       end.
   end.

/**************************
   /*���㵽������*/
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

   /*���㵽������*/
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

   put unformat "tmp_datearea" skip.
   for each tmp_datearea no-lock:
       display tmp_datearea with width 200.
   end.

   put unformat skip(2) "tmp_rule_date" skip.
   for each tmp_rule_date no-lock:
       display tmp_rule_date with width 300.
   end.

   put unformat skip(2) "tmp_tmd" skip.
   for each tmp_tmd no-lock:
   display tmp_tmd with width 300.
   end.
*************************/

   /* ���㵽����  */
   for each tmp_tmd exclusive-lock:
       find last tmp_datearea where td_rule = tm_rule
             and td_date <= tm_sdate no-error.
       if available tmp_datearea then do:
          assign tm_edate = td_date.
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
/*
   for each tmp_po exclusive-lock:
       find last tmp_datearea where td_rule = tpo_rule and td_date <= tpo_due
            no-lock no-error.
       if available(tmp_datearea) and tpo_due <> td_date then do:
          assign tpo_due = td_date.
       end.
   end.
*/
   /*    �ϲ��ǵ�һ�����ڵ���һ������.   */
   for each tmp_po exclusive-lock,
       each usrw_wkfl no-lock where usrw_key1 = vkey1 and
            usrw_key2 = tpo_part and usrw_key3 = "1"
/*       each pt_mstr no-lock where pt_part = tpo_part              */
/*        and pt_rev = "1"                                          */
            break by tpo_part by tpo_due:
          if first-of(tpo_part) then do:
              assign duef = tpo_due.
          end.
          else do:
               assign tpo_due = duef.
          end.
   end.

   /* ����2���мƻ����������Ϊ0�ļ�¼ */
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
            mrp_det.mrp_detail = "�ƻ���" and
            mrp_site >= site and mrp_site <= site1 and
            mrp_det.mrp_due_date >= duef and mrp_det.mrp_due_date <= duet
            USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> "":
       find first tmp_po no-lock where tpo_vend = pt_vend
              and tpo_part = pt_part /* and tpo_due = duef - 1 */ no-error.
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
       find first tmp_n2po exclusive-lock where tn2_part = pt_part no-error.
       if not available tmp_n2po then do:
          create tmp_n2po.
          assign tn2_part = pt_part.
       end.
       assign tn2_qty = tn2_qty + mrp_qty.
      /* else do:                          */
      /*     assign tpo_fut = yes.         */
      /* end.                              */
   END.

    for each tmp_po exclusive-lock,each pt_mstr no-lock where
             pt_part = tpo_part:
         find first xvp_ctrl where xvp_vend = pt_vend
               and xvp_part = pt_part no-lock no-error.
         if availabl xvp_ctrl then do:
           assign tpo_type = xvp__chr01.
         end.
    end.

    for each tmp_po no-lock where tpo_type = "T" break by tpo_part:
        if first-of(tpo_part) then do:
           assign tpo1date = ?
                  tpoqty = 0
                  tpoqtys = 0.
           for each pod_det no-lock use-index pod_partdue where
                 pod_part = tpo_part break by pod_part by pod_due_date:
               if pod_type = "T" then do:
                  assign tpo1date = pod_due_date.
               end.
               if pod_due_date >= tpo1date then do:
                  if pod_type = "T" then do:
                     assign tpoqtys = tpoqtys + pod_qty_ord.
                  end.
                  if pod_type = "" then do:
                     assign tpoqty = tpoqty + pod_qty_ord.
                  end.
               end. /* if pod_due_date >= tpo1date then do: */
           end. /* for each pod_det no-lock  */
/*628*/    assign adjqty = 0.
/*628*/    find first usrw_wkfl no-lock where
/*628*/               usrw_key1 = "XXMRPPORP0.P-ITEM-TTYPEPO-QTYADJ" and
/*628*/               usrw_key2 = tpo_part no-error.
/*628*/    if available usrw_wkfl then do:
/*628*/       assign adjqty = usrw_decfld[1].
/*628*/    end.
           find first tmp_po1 no-lock where tp1_part = tpo_part no-error.
           if not available tmp_po1 then do:
              create tmp_po1.
              assign tp1_part = tpo_part.
           end.
/*628*/    assign tp1_tpo = tpoqtys - adjqty
                  tp1_po = tpoqty.
        end. /* if first-of(tmp_part) then do: */
    end.

    for each tmp_po exclusive-lock where tpo_type = "T" and tpo_qty > 0:
        /* find first tmp_datearea where td_rule = tpo_rule and           */
        /*            td_date > tpo_due no-error.                         */
        /* if available tmp_datearea then do:                             */
        /*    assign tpo_end = td_date - 1.                               */
        /* end.                                                           */
        /* else do:                                                       */
        /*    assign tpo_end = hi_date.                                   */
        /* end.                                                           */
        /* assign qty_tpod = 0                                            */
        /*        qty_pod = 0.                                            */
        /* for each pod_det no-lock use-index pod_partdue where           */
        /*          pod_part = tpo_part and pod_due_date >= tpo_due and   */
        /*          pod_due_date <= tpo_end:                              */
        /*     if pod_type = "T" then do:                                 */
        /*        assign qty_tpod = qty_tpod + pod_qty_ord.               */
        /*     end.                                                       */
        /*     else do:                                                   */
        /*        assign qty_pod = qty_pod + pod_qty_ord.                 */
        /*     end.                                                       */
        /* end.                                                           */
        find first tmp_po1 where tp1_part = tpo_part no-error.
        if available tmp_po1 then do:
        assign tpo_po = tp1_po
               tpo_tpo = tp1_tpo
               tpo_qty = tpo_qty - qty_tpod.
        end.
    end.
    for each tmp_po1 exclusive-lock:
        if tp1_tpo - tp1_po >= 0 then assign tp1_apo = tp1_tpo - tp1_po.
                                 else assign tp1_apo = 0.
    end.
    for each tmp_po exclusive-lock:
        assign tpo_qty0 = tpo_qty.
    end.

    /*��������*/
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

         for each tmp_po no-lock where tpo_qty < 0 break by tpo_part:
             if first-of(tpo_part) then do:
                create qad_wkfl.
                assign qad_key1 = key1 + "_Det"
                       qad_key2 = tpo_part.
            end.
         end.
         if t then do:
            for each qad_wkfl use-index qad_index2
               where qad_key1 = key1 + "_Det"
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
         end.       /** if t then do:   */
         assign i = 0.
         for each tmp_po no-lock
             where (tpo_qty > 0 or tpo_fut) or not act
             break by tpo_nbr by tpo_vend by tpo_part by tpo_due:
/*628*/      if first-of(tpo_part) then do:
/*628*/         assign adjqty = 0.
/*628*/         find first usrw_wkfl no-lock where
/*628*/                    usrw_key1 = "XXMRPPORP0.P-ITEM-TTYPEPO-QTYADJ" and
/*628*/                    usrw_key2 = tpo_part no-error.
/*628*/         if available usrw_wkfl then do:
/*628*/            assign adjqty = usrw_decfld[1].
/*628*/         end.
/*628*/      end.
             if first-of(tpo_due) then do:
                assign tpoqty = 0
                       tpoqtys = 0
                       tpopo = 0
                       tpotpo = 0
/*719*/                aqty = 0.
             end.
             assign tpoqty = tpoqty + tpo_qty
                    tpoqtys = tpoqtys + tpo_qtys
                    tpopo = tpopo + tpo_po
                    tpotpo = tpotpo + tpo_tpo.
             if last-of(tpo_due) then do:
/*719*/          assign aqty = 0
                        areaDesc = "".
                 find first code_mstr no-lock where code_fldname = "vd__chr03"
                        and code_value = tpo_rule no-error.
                 if available code_mstr then do:
                    assign areaDesc = code_cmmt.
                 end.
                 find first tmp_po1 no-lock where tp1_part = tpo_part no-error.
                 if available tmp_po1 then do:
                    assign aqty = tp1_apo.
                 end.
                 if aqty <= tpoqty
                    then assign tpoqty = tpoqty - aqty.
                    else assign tpoqty = 0.
/*630*/          if tpoqty <> 0 then do:
/*630*/             find first pt_mstr no-lock where pt_part = tpo_part
/*630*/                   and pt_ord_mult <> 0 no-error.
/*630*/             if available pt_mstr then do:
/*719*/                if tpoqty mod pt_ord_mult <> 0 then
/*630*/                 assign tpoqty = tpoqty + pt_ord_mult - tpoqty mod pt_ord_mult .
/*630*/             end.
/*630*/          end.
/*121218.1*********************************************************************/
/*121218.1*     if tpoqty > 0 or (tpo_fut and tpoqty = 0) then do:            */
/*121218.1*           /*����ʾ������Ϊ0����Ԥʾ����*/                         */
/*121218.1*        export delimiter "~011"                                    */
/*121218.1*               tpo_nbr tpo_vend tpo_part tpoqty                    */
/*121218.1*               tpo_due tpo_type tpoqtys                            */
/*121218.1*               if first-of(tpo_part) then tpopo else 0             */
/*121218.1*               if first-of(tpo_part) then tpotpo else 0            */
/*121218.1*               if first-of(tpo_part) then adjqty else 0            */
/*121218.1*               weekday(tpo_due) - 1                                */
/*121218.1*               tpo_rule0 areaDesc                                  */
/*121218.1*               tpo_fut                                             */
/*121218.1*               .                                                   */
/*121218.1*     end. /* if first-of(tpo_part) or tpoqty > 0 then do: */       */
/*121218.1*********************************************************************/
                if tpoqty > 0 or (tpo_fut and tpoqty = 0) then do:
/*121218.1*/    create usrw_wkfl.
/*121218.1*/    assign usrw_key1 = vkey0
/*121218.1*/           usrw_key2 = string(i)
/*121218.1*/           usrw_charfld[1] = tpo_nbr
/*121218.1*/           usrw_charfld[2] = tpo_vend
/*121218.1*/           usrw_charfld[3] = tpo_part
/*121218.1*/           usrw_decfld[1]  = tpoqty
/*121218.1*/           usrw_datefld[1] = tpo_due
/*121218.1*/           usrw_charfld[4] = tpo_type
/*121218.1*/           usrw_decfld[2]  = tpoqtys
/*121218.1*/           usrw_decfld[3]  = (if first-of(tpo_part) then tpopo else 0)
/*121218.1*/           usrw_decfld[4]  = (if first-of(tpo_part) then tpotpo else 0)
/*121218.1*/           usrw_intfld[1]  = weekday(tpo_due) - 1
/*121218.1*/           usrw_charfld[5] = tpo_rule0
/*121218.1*/           usrw_charfld[6] = areaDesc
/*121218.1*/           usrw_logfld[1] = tpo_fut
/*121218.1*/           usrw_datefld[2] = tpo_due.
                 end.
                 find first tmp_po1 exclusive-lock where tp1_part = tpo_part
                            no-error.
                 if available tmp_po1 then do:
                    if tp1_apo >= tpoqtys
                    then assign tp1_apo = tp1_apo - tpoqtys.
                    else assign tp1_apo = 0.
                 end.
                 /*    tpo_end tpo_rule tpo_po tpo_tpo.  tpo_mrp_date. */
            end.  /*if last-of(tpo_due) then do:*/
            assign i = i + 1.
         end. /*for each tmp_po no-lock*/

/*121218.1*/  for each usrw_wkfl exclusive-lock where
/*121218.1*/           usrw_key1 = vkey0 and usrw_charfld[4] = "T"
/*121218.1*/           break by usrw_charfld[3] by usrw_datefld[2]:
/*121218.1*/      if first-of(usrw_charfld[3]) then do:
/*121218.1*/         assign qty_pod = 0.
/*121218.1*/      end.
/*121218.1*/      if usrw_decfld[1] <> 0 then qty_pod = usrw_decfld[1].
/*121218.1*/      if last-of(usrw_charfld[3]) then do:
/*121218.1*/         if qty_pod = 0 then do:
/*121218.1*/            assign usrw_datefld[1] = duef - 1
/*121218.1*/                   usrw_logfld[1] = yes.
/*121218.1*/         end.
/*121218.1*/      end.
/*121218.1*/  end.
assign sendDate = ?.
for each pod_det no-lock use-index pod_partdue where pod_part <> ""
		 and pod_due_date > low_date break by pod_due_date:
		 if pod_type = "T" then do:
		 		assign sendDate = pod_due_date when sendDate = ?.
		 end.
		 if sendDate <> ? then leave.
end.
/*output stream bf to xxmrppo.txt.*/
for each usrw_wkfl exclusive-lock where usrw_wkfl.usrw_key1 = vkey0
     and usrw_charfld[4] = "T" and usrw_decfld[1] = 0 and usrw_decfld[2] = 0:
     assign qty_tpod = 0
            qty_pod = 0
            tmpDate = ?.
     find first tmp_n2po no-lock where tn2_part = usrw_charfld[3] no-error.
     if not available tmp_n2po then do:
        delete usrw_wkfl.
        next.
     end.
     else if tn2_qty = 0 then do:
        delete usrw_wkfl.
        next.
     end.
     /*���T����PO������������������2���µ�Ԥʾ��ɾ����Ԥʾ*/
     for each pod_det no-lock use-index pod_partdue where
         pod_part = usrw_charfld[3] and pod_due_date >= sendDate
         break by pod_part by pod_due_date:
              if pod_type = "T" then do:
                 assign tmpDate = pod_due_date
                        qty_tpod = qty_tpod + pod_qty_ord.
              end.
              else do:
                  if tmpDate <> ? then do:
                     qty_pod = qty_pod + pod_qty_ord.
                  end.
              end.
     end.
    /* put stream bf unformat usrw_charfld[3] "~011" qty_tpod "~011" qty_pod.*/
     qty_tpod = qty_tpod - qty_pod.
     if qty_tpod > 0 then do:
        find first tmp_n2po no-lock where tn2_part = usrw_charfld[3] no-error.
        if available tmp_n2po then do:
           assign qty_tpod = qty_tpod - tn2_qty.
/*					 put stream bf unformat "~011" tn2_qty.*/
        end.
     end.
/*     put stream bf skip.*/
     if qty_tpod > 0 then do:
        delete usrw_wkfl.
     end.
end.
/*output stream bf close.*/
         export delimiter "~011" getTermLabel("PO_NUMBER",12)
                                 getTermLabel("SUPPLIER",12)
                                 getTermLabel("ITEM_NUMBER",12)
                                 getTermLabel("RECEIVED_QTY",12)
                                 getTermLabel("DUE_DATE",12)
                                 getTermLabel("TYPE",12)
                                 getTermLabel("DEMAND_QTY",12)
                                 getTermLabel("PO_QTY",12)
                                 getTermLabel("TEMP_PO_QTY",12)
/*629*                           getTermLabel("ADJUSTMENT_QUANTITY",12)      */
                                 getTermLabel("WEEK",12)
                                 getTermLabel("SHIP_TERMS",12)
                                 getTermLabel("COMMENT",12).
         /*                      getTermLabel("START",12)                    */
         /*                      getTermLabel("END",12)                      */
         /*                      getTermLabel("EXPIRATION_DATE",12).         */


/*121218.1*/  for each usrw_wkfl no-lock where usrw_wkfl.usrw_key1 = vkey0
/*121218.1*/  break by usrw_key1 by usrw_charfld[1] by usrw_charfld[2]
/*121218.1*/        by usrw_charfld[3] by usrw_datefld[1]:
/*121218.1*/       export delimiter "~011"
/*121218.1*/              usrw_charfld[1]
/*121218.1*/              usrw_charfld[2]
/*121218.1*/              usrw_charfld[3]
/*121218.1*/              usrw_decfld[1]
/*121218.1*/              usrw_datefld[1]
/*121218.1*/              usrw_charfld[4]
/*121218.1*/              usrw_decfld[2]
/*121218.1*/              usrw_decfld[3]
/*121218.1*/              usrw_decfld[4]
/*121218.1*/              usrw_intfld[1]
/*121218.1*/              usrw_charfld[5]
/*121218.1*/              usrw_charfld[6]
                          usrw_logfld[1].
/*121218.1*/  end.
end.      /*if detsum else do:    */
/* REPORT TRAILER  */
/*   {mfrtrail.i} */

  {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

PROCEDURE getParams:
/*------------------------------------------------------------------------------
    Purpose: �������ڷ�Χ
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
  Purpose��Userd to test program , You can delete it when after confrimed.
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