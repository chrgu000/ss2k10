/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110915.1   created on: 20110901   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "111013.1"}
{xxmrpporpa.i}
define variable site like si_site.
define variable site1 like si_site.
define variable key1 as character INITIAL "xxmrpporp0.p" no-undo.
define variable part like pt_part INITIAL "MHSE02-407-0-LX".
define variable part1 like pt_part.
define variable due as date.
define variable duek as date.
define variable duee as date.
define variable duef as date.
define variable duet as date.
define variable vend like vd_addr INITIAL "C02C016".
define variable buyer like pt_buyer INITIAL "4RSA".
define variable area as character format "x(1)".
define variable areaDesc as character format "x(40)".
define variable sendDate as date.
define variable tmpDate as date.
define variable qty_nextMth like pod_qty_ord.
define variable qtytemp as decimal.
define variable qtytemp1 as decimal.
define variable xRule AS CHARACTER.
define variable xCyc as INTEGER.
define variable xType AS CHARACTER.

define temp-table tmp_po
    fields tpo_nbr like po_nbr
    fields tpo_vend like vd_addr
    fields tpo_part like pt_part
    fields tpo_type as character
    fields tpo_due  like po_due_date
    fields tpo_mrp_date like po_due_date
    fields tpo_start  as date
    fields tpo_end  as date
    fields tpo_qty like pod_qty_ord
    fields tpo_rule as character
    index tpo_part_vend is primary tpo_part tpo_vend tpo_due.

define temp-table tmp_rule_date
    fields trd_rule AS CHARACTER
    fields trd_datef AS DATE
    fields trd_datet AS DATE.

define temp-table tmp_tmd
   fields tm_vend like vd_addr
   fields tm_part like pt_part
   fields tm_rule0 as character
   fields tm_rule as character
   fields tm_month as integer
   fields tm_sdate as date  /* mrp_due_date */
   fields tm_adate as date  /* first available send date */
   fields tm_edate as date  /* end send date*/
   fields tm_qty like mrp_qty
   index tm_rule is primary tm_rule
   index tm_vpa tm_vend tm_part tm_adate.

define buffer md for mrp_det.

/* SELECT FORM */
form
   site  colon 15
   site1 label {t001.i} colon 49 skip
   part  colon 15
   part1 label {t001.i} colon 49 skip(1)
   due   colon 25
   vend  colon 25
   area  colon 25 areaDesc no-label
   buyer colon 25 skip(1)

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
      update site site1 part part1 due vend area buyer with frame a.

   {wbrp06.i &command = update
      &fields = " site site1 part part1 due vend area buyer "
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
            index(code_value,"M4") = 0 and code_value <> "":
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

   FOR EACH pt_mstr no-lock where
         pt_part >= part and pt_part <= part1 and
         substring(pt_part,1,1) <> "X"
         and (pt_buyer = buyer or buyer = "")
         and pt_site >= site and (pt_site <= site1 or site1 = "")
         and (pt_vend = vend or vend = "")
         and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det no-lock WHERE mrp_det.mrp_part = pt_part and
            mrp_det.mrp_detail = "计划单" USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> "":
           create tmp_tmd.
           assign tm_vend = pt_vend
              tm_part = pt_part
              tm_rule0 = vd__chr03
              tm_rule = vd__chr03
              tm_sdate = mrp_due_date
              tm_qty = mrp_qty.
   end.
   for each tmp_rule_date no-lock:
       display tmp_rule_date.
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
          if index(xrule,string(weekday(duek) - 1)) > 0 then do:
             assign tm_adate = duek
                    tm_month = month(duek).
             leave.
          end.
          else do:
             assign duek = duek - 1.
          end.
       end.
   end.

   for each tmp_tmd exclusive-lock where substring(tm_rule,1,2) = "M4":
       find first mrp_det use-index mrp_partdate no-lock where
                  mrp_part = tm_part and
                  mrp_detail = "计划单" and
                  mrp_due_date >=
                  date(month(tm_adate),1,year(tm_adate)) no-error.
       if available mrp_det then do:
          if weekday(mrp_due_date) - 1 >= 1 and
             weekday(mrp_due_date) - 1 <= 2 then do:
             assign tm_Rule = "W1".
          end.
          else if weekday(mrp_due_date) - 1 >= 3 and
             weekday(mrp_due_date) - 1 <= 4 then do:
             assign tm_Rule = "W3".
          end.
          else do:
             assign tm_Rule = "W5".
          end.
       end.
   end.

   /*删除不要的月份资料*/
   for each tmp_tmd exclusive-lock,
       each tmp_rule_date no-lock where trd_rule = tm_rule:
       if tm_sdate > trd_datet then do:
          delete tmp_tmd.
       end.
   end.
	 
	 /*计算到货日*/
	 for each tmp_tmd use-index tm_vpa exclusive-lock where tm_rule begins "M"
	     break by tm_vend by tm_part by tm_adate:
	     if first-of(tm_vend) then do:
	     	  assign duek = tm_adate.
	     	  assign tm_edate = tm_adate.
	     end.
	     else do:
	     	  if substring(tm_rule,1,2) = "M1" then do:
	     	     assign tm_edate = duek.
	     	  end.
	     	  else if substring(tm_rule,1,2) = "M2" then do:
	     	  	 if tm_adate > duek + 14 then do:
	     	  	    assign tm_edate = duek + 14.
	     	  	 end.
	     	  	 else do:
	     	  	    assign tm_edate = duek.
	     	  	 end.
	     	  end.
	     end.	 	   
	 end.

   for each tmp_tmd no-lock:
       display tmp_tmd with width 300.
   end.
/*
   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det no-lock WHERE mrp_det.mrp_part = pt_part and
            mrp_det.mrp_detail = "计划单" USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> ""
       break by pt_vend by mrp_det.mrp_part by mrp_det.mrp_due_date:
          if substring(vd__chr03,1,2) <> "M4" then do:
              if first-of(pt_vend) then do:
                 assign xRule = vd__chr03.
              end.
              find first tmp_datearea where td_rule = xRule
                     and td_key = "Key" no-lock no-error.
              if available(tmp_datearea) then do:
                 assign duek = td_date.
              end.
              find last tmp_datearea where td_rule = xRule no-lock no-error.
              if available(tmp_datearea) then do:
                 assign duee = td_date.
              end.
          end.
          else do:
            find first md use-index mrp_partdate no-lock where
                 md.mrp_part = mrp_det.mrp_part and
                 md.mrp_detail = "计划单" and
                 md.mrp_due_date >=
                 date(month(mrp_det.mrp_due_date),1,year(mrp_det.mrp_due_date))
            no-error.
            if available md then do:
               if weekday(md.mrp_due_date) - 1 >= 1 and
                  weekday(md.mrp_due_date) - 1 <= 2 then do:
                  assign xRule = "W1".
               end.
               else if weekday(md.mrp_due_date) - 1 >= 3 and
                  weekday(md.mrp_due_date) - 1 <= 4 then do:
                  assign xRule = "W3".
               end.
               else do:
                  assign xRule = "W5".
               end.
            end.
            find first tmp_datearea where td_rule = xRule
                   and td_key = "Key" no-lock no-error.
            if available(tmp_datearea) then do:
               assign duek = td_date.
            end.
            find last tmp_datearea where td_rule = xRule no-lock no-error.
            if available(tmp_datearea) then do:
               assign duee = td_date.
            end.
          end.

          if mrp_det.mrp_due_date >= duee then do:
             next.
          end.

          find last tmp_datearea where td_rule = xRule
                and mrp_det.mrp_due_date >= td_date no-lock no-error.
          if available tmp_datearea then do:
             assign duef = td_date.
          end.
          find first tmp_datearea where td_rule = xRule
                and mrp_det.mrp_due_date < td_date no-lock no-error.
           if available tmp_datearea then do:
             assign duet = td_date.
          end.
          find first tmp_po exclusive-lock where tpo_part = pt_part
                 and tpo_vend = pt_vend and tpo_due = duef no-error.
          if available tmp_po then do:
             assign tpo_qty = tpo_qty + mrp_det.mrp_qty .
          end.
          else do:
              create tmp_po.
              assign tpo_vend = pt_vend
                     tpo_part = pt_part
                     tpo_due = duef
                     tpo_qty = mrp_det.mrp_qty
                     tpo_mrp_date = mrp_det.mrp_due_date
                     tpo_start = duek
                     tpo_end = duee - 1
                     tpo_rule = vd__chr03.
          end.
    /*    {mfrpchk.i} */
   END. /* FOR EACH PT_MSTR,XVP_CTRL,MRP_DET */
*/
   /*如下2月有计划则产生数量为0的记录*/
   assign duef = date(month(due),28,year(due)) + 5.
   assign duef = date(month(duef),1,year(duef)).
   assign duet = duef + 65.
   assign duet = date(month(duet),1,year(duet)) - 1.
   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det WHERE mrp_det.mrp_part = pt_part and
            mrp_det.mrp_detail = "计划单" and
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
                 tpo_rule = vd__chr03.
       end.
   END.

for each tmp_po exclusive-lock,each pt_mstr no-lock where pt_part = tpo_part:
     find first xvp_ctrl where xvp_vend = pt_vend
           and xvp_part = pt_part no-lock no-error.
     if availabl xvp_ctrl then do:
       assign tpo_type = "T".
     end.
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
assign areaDesc = "".

export delimiter "~011" getTermLabel("PO_NUMBER",12)
                        getTermLabel("SUPPLIER",12)
                        getTermLabel("ITEM_NUMBER",12)
                        getTermLabel("RECEIVED_QTY",12)
                        getTermLabel("DUE_DATE",12)
                        getTermLabel("TYPE",12)
                        getTermLabel("WEEK",12)
                        getTermLabel("SHIP_TERMS",12)
                        getTermLabel("COMMENT",12).
/*                      getTermLabel("START",12)                             */
/*                      getTermLabel("END",12)                               */
/*                      getTermLabel("EXPIRATION_DATE",12).                  */
for each tmp_po no-lock where:
    assign areaDesc = "".
    find first code_mstr no-lock where code_fldname = "vd__chr03"
           and code_value = tpo_rule no-error.
    if available code_mstr then do:
       assign areaDesc = code_cmmt.
    end.
/*    export delimiter "~011" tpo_nbr tpo_vend tpo_part tpo_qty tpo_due tpo_type
                            weekday(tpo_due) - 1 tpo_rule areaDesc.
                          tpo_start tpo_end tpo_mrp_date.                  */
end.

/* REPORT TRAILER  */
/*   {mfrtrail.i} */
  {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

FUNCTION i2c RETURNS CHARACTER (iNumber AS INTEGER):
/*------------------------------------------------------------------------------
    Purpose: 将数字转换为0~9,a~z.
      Notes: 输入的数字在0-36之间MOUELO.
------------------------------------------------------------------------------*/
    assign iNumber = iNumber MODULO 36.
    IF iNumber < 10 THEN
       RETURN CHR(48 + iNumber).
    ELSE
       RETURN CHR(87 + iNumber).
END FUNCTION.

PROCEDURE getPoNumber:
/*------------------------------------------------------------------------------
    Purpose: 计算PO单号
      Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER iDate AS DATE.
  DEFINE INPUT PARAMETER iVendor LIKE VD_ADDR.
  DEFINE OUTPUT PARAMETER oNbr as character.

  DEFINE Variable intI as integer.
  DEFINE VARIABLE KEY1 AS CHARACTER INITIAL "xxmrpporp0.p.getponbr".
  DEFINE VARIABLE KEY2 AS CHARACTER.

  find first vd_mstr no-lock where vd_addr = ivendor no-error.
  if available vd_mstr then do:
     assign KEY2 = substring(vd_sort,1,2).
  end.
  else do:
     assign KEY2 = substring(iVendor,1,2).
  end.
  assign KEY2 = "P" + i2c(YEAR(iDate) - 2010) + i2c(month(iDate)) + KEY2.

  find first qad_wkfl exclusive-lock where qad_key1 = KEY1
         and qad_key2 = KEY2 no-error.
  if available qad_wkfl then do:
    assign intI = qad_intfld[1].
    assign oNbr = KEY2 + substring("0000" + string(inti),
                      length("0000" + string(inti)) - 2).
     repeat:
         find first po_mstr no-lock where po_nbr = oNbr no-error.
         if available po_mstr then do:
             assign intI = qad_intfld[1] + 1
                    qad_intfld[1] = qad_intfld[1] + 1
                    qad_key3 = iVendor
                    qad_user1 = string(intI).
             assign oNbr = oNbr + substring("0000" + string(inti),
                         length("0000" + string(inti)) - 2).
         end.
         else do:
              leave.
         end.
     end.
  end.
  else do:
     assign intI = 0.
     assign oNbr = oNbr + substring("0000" + string(inti),
                       length("0000" + string(inti)) - 2).
     repeat:
         find first po_mstr no-lock where po_nbr = oNbr no-error.
         if available po_mstr then do:
             assign intI = qad_intfld[1] + 1
                    qad_intfld[1] = qad_intfld[1] + 1
                    qad_key3 = string(qad_intfld[1] + 1).
             assign oNbr = KEY2 + substring("0000" + string(inti),
                         length("0000" + string(inti)) - 2).
         end.
         else do:
              create qad_wkfl.
              assign qad_key1 = "xxmrpporp0.p.getponbr"
                     qad_key2 = KEY2
                     qad_key3 = iVendor
                     qad_user1 = "0"
                     qad_intfld[1] = 0.
              leave.
          end.
     end.
  end.
  release qad_wkfl.
END PROCEDURE.
