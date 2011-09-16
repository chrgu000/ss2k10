/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110915.1   created on: 20110901   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110915.1"}
{xxmrpporpa.i}
define variable site like si_site.
define variable site1 like si_site.
define variable key1 as character initial "xxmrpporp0.p" no-undo.
define variable part like pt_part /* INITIAL "M30623-260-50-CK" */.
define variable part1 like pt_part /* INITIAL "MHTA03-NE0-10-CK" */.
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
define variable act as logical initial yes.
define variable qtytemp as decimal.
define variable qtytemp1 as decimal.
define variable xvpweek like xvp_week.
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
   act   colon 25 skip(1)

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
      update site site1 part part1 due vend area buyer act with frame a.

   {wbrp06.i &command = update
      &fields = " site site1 part part1 due vend area buyer act"
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
  for each qad_wkfl exclusive-lock where qad_key1 = key1: delete qad_wkfl. end.
/*
   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det WHERE mrp_part = pt_part and
            mrp_detail = "�ƻ���" USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> ""
       break by vd__chr03 by mrp_due_date:
       if first-of(vd__chr03) then do:
          assign sendDate = mrp_due_date - day(mrp_due_date).
          run getParams(input pt_site, input sendDate,input vd__chr03,
                   output xRule,output xCyc,output xType,
                   output duef, output duet).
          create tmp_datearea.
          assign td_rule = vd__chr03
                 td_date = duef.
          create tmp_datearea.
          assign td_rule = vd__chr03
                 td_date = duet.
       end.
       if last-of(vd__chr03) then do:
          run getParams(input pt_site, input due,input vd__chr03,
                   output xRule,output xCyc,output xType,
                   output duef, output duet).
          create tmp_datearea.
          assign td_rule = vd__chr03
                 td_date = duet.
          create tmp_datearea.
          assign td_rule = vd__chr03
                 td_date = duet.
       end.
    end.
*/
   assign sendDate = date(month(due),1,year(due)) - 10.
   for each code_mstr no-lock where code_fldname = "vd__chr03":
      run getParams(input "GSA01", input sendDate,input code_value,
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

   for each qad_wkfl exclusive-lock where qad_key1 = key1
        and qad_charfld[2] = "KEY":
        for each tmp_datearea exclusive-lock where td_rule = qad_charfld[1]
             and td_date < qad_datefld[3]:
/*           assign td_key = "Delete".  */
             delete tmp_datearea.
        end.
   end.
/*
   for each qad_wkfl no-lock where qad_key1 = key1  :
        display qad_charfld[1] qad_charfld[2] qad_datefld[1] qad_datefld[3].
   end.

   for each tmp_datearea NO-LOCK BREAK BY td_rule BY td_date:
       display td_rule td_date td_key weekday(td_date) - 1 column-label "week".
   end.
*/
   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det WHERE mrp_part = pt_part and
            mrp_detail = "�ƻ���" USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> ""
       break by pt_vend by mrp_part by mrp_due_date:
       if first-of(pt_vend) then do:
          find first tmp_datearea where td_rule = vd__chr03
                 and td_key = "Key" no-lock no-error.
          if available(tmp_datearea) then do:
             assign duek = td_date.
          end.
          find last tmp_datearea where td_rule = vd__chr03 no-lock no-error.
          if available(tmp_datearea) then do:
             assign duee = td_date.
          end.
       end.
       if mrp_due_date >= duee then do:
          next.
       end.
       if mrp_due_date < duek then do:
          find first tmp_datearea where td_rule = vd__chr03
                 and td_date < duek no-lock no-error.
          if available(tmp_datearea) then do:
             find first tmp_po exclusive-lock where tpo_part = pt_part
                   and tpo_vend = pt_vend and tpo_due = td_date no-error.
             if available tmp_po then do:
                assign tpo_qty = tpo_qty + mrp_qty .
             end.
             else do:
                 create tmp_po.
                 assign tpo_vend = pt_vend
                        tpo_part = pt_part
                        tpo_due = td_date
                        tpo_qty = mrp_qty
                        tpo_mrp_date = mrp_due_date
                        tpo_start = duek
                        tpo_end = duee - 1
                        tpo_rule = vd__chr03.
               end.
          end.    /* if available(tmp_datearea) then do: */
       end.
       else do:
            find last tmp_datearea where td_rule = vd__chr03
                  and mrp_due_date >= td_date no-lock no-error.
            if available tmp_datearea then do:
               assign duef = td_date.
            end.
            find first tmp_datearea where td_rule = vd__chr03
                  and mrp_due_date < td_date no-lock no-error.
             if available tmp_datearea then do:
               assign duet = td_date.
            end.
            find first tmp_po exclusive-lock where tpo_part = pt_part
                   and tpo_vend = pt_vend and tpo_due = duef no-error.
             if available tmp_po then do:
                assign tpo_qty = tpo_qty + mrp_qty .
             end.
             else do:
                 create tmp_po.
                 assign tpo_vend = pt_vend
                        tpo_part = pt_part
                        tpo_due = duef
                        tpo_qty = mrp_qty
                        tpo_mrp_date = mrp_due_date
                        tpo_start = duek
                        tpo_end = duee - 1
                        tpo_rule = vd__chr03.
               end.
       end.
    /*    {mfrpchk.i} */
   END. /* FOR EACH PT_MSTR,XVP_CTRL,MRP_DET */

for each tmp_po exclusive-lock,each pt_mstr no-lock where pt_part = tpo_part:
     find first xvp_ctrl where xvp_vend = pt_vend
           and xvp_part = pt_part no-lock no-error.
     if availabl xvp_ctrl then do:
       assign tpo_type = "T".
     end.
end.

/*��������*/
assign areaDesc = "".
for each tmp_po exclusive-lock where tpo_vend <> ""
    break by tpo_vend :
    if first-of(tpo_vend) then do:
       run getPoNumber(input today,input tpo_vend,output areaDesc).
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
    export delimiter "~011" tpo_nbr tpo_vend tpo_part tpo_qty tpo_due tpo_type
                            weekday(tpo_due) - 1 tpo_rule areaDesc.
/*                          tpo_start tpo_end tpo_mrp_date.                  */
end.

/* REPORT TRAILER  */
/*   {mfrtrail.i} */
  {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

FUNCTION i2c RETURNS CHARACTER (iNumber AS INTEGER):
/*------------------------------------------------------------------------------
    Purpose: ������ת��Ϊ0~9,a~z.
      Notes: �����������0-36֮��MOUELO.
------------------------------------------------------------------------------*/
    assign iNumber = iNumber MODULO 36.
    IF iNumber < 10 THEN
       RETURN CHR(48 + iNumber).
    ELSE
       RETURN CHR(87 + iNumber).
END FUNCTION.

PROCEDURE getPoNumber:
/*------------------------------------------------------------------------------
    Purpose: ����PO����
      Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER iDate AS DATE.
  DEFINE INPUT PARAMETER iVendor LIKE VD_ADDR.
  DEFINE OUTPUT PARAMETER oNbr as character.

  DEFINE Variable intI as integer.

  find first vd_mstr no-lock where vd_addr = ivendor no-error.
  if available vd_mstr then do:
     assign oNbr = substring(vd_sort,1,2).
  end.
  else do:
     assign oNbr = substring(iVendor,1,2).
  end.
  assign oNbr = "P" + i2c(YEAR(iDate) - 2010) + i2c(month(iDate)) + oNbr.
 /*******************
  find last po_mstr no-lock where po_nbr begins oNbr no-error.
  if available po_mstr then do:
      find first qad_wkfl exclusive-lock where qad_key1 = "xxmrpporp0.p" and
                  qad_key2 = oNbr no-error.
      if available qad_wkfl then do:
         assign qad_intfld[1] = integer(substring(po_nbr,6))
                qad_key3 = substring(po_nbr,6).
      end.
  end.
  else do:
        find first qad_wkfl exclusive-lock where qad_key1 = "xxmrpporp0.p" and
                  qad_key2 = oNbr no-error.
        if not available qad_wkfl then do:
            create qad_wkfl.
            assign qad_key1 = "xxmrpporp0.p"
                   qad_key2 = oNbr.
        end.
        assign qad_intfld[1] = 0
               qad_key3 = "0".
  end.
  **********/
  find first qad_wkfl exclusive-lock where qad_key1 = "xxmrpporp0.p" and
       qad_key2 = oNbr no-error.
  if available qad_wkfl then do:
     assign intI = qad_intfld[1].
     assign oNbr = oNbr + substring("0000" + string(inti),
                       length("0000" + string(inti)) - 2).
     find first po_mstr no-lock where po_nbr = oNbr no-error.
     if not available po_mstr then do:
         assign intI = qad_intfld[1] + 1
                qad_intfld[1] = qad_intfld[1] + 1
                qad_key3 = string(qad_intfld[1] + 1).
         assign oNbr = oNbr + substring("0000" + string(inti),
                     length("0000" + string(inti)) - 2).
     end.
  end.
  else do:
     assign intI = 0.
     assign oNbr = oNbr + substring("0000" + string(inti),
                       length("0000" + string(inti)) - 2).
     find first po_mstr no-lock where po_nbr = oNbr no-error.
     if not available po_mstr then do:
      create qad_wkfl.
      assign qad_key1 = "xxmrpporp0.p"
             qad_key2 = oNbr
             qad_intfld[1] = 0
             qad_key3 = "0".
     end.
  end.
  release qad_wkfl.
END PROCEDURE.