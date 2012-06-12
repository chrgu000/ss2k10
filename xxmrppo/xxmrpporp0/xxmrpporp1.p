/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110915.1   created on: 20110901   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120608.2"}

define variable site like si_site.
define variable site1 like si_site.
define variable key1 as character INITIAL "xxmrpporp0.p" no-undo.
define variable part like pt_part.
define variable part1 like pt_part.
define variable due as date.
define variable due1 as date.
define variable duek as date.
define variable duee as date.
define variable duef as date.
define variable duet as date.
define variable grp like pt_group.
define variable grp1 like pt_group.
define variable pm like pt_pm_code initial "P".
define variable vend like vd_addr.
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
define variable T as logical.
define variable vT as character.
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

define buffer md for mrp_det.

/* SELECT FORM */
form
   site  colon 15
   site1 label {t001.i} colon 49 skip
   part  colon 15
   part1 label {t001.i} colon 49
   grp   colon 25
   grp1  colon 49
   due   colon 25
   due1  colon 49
   vend  colon 25
   area  colon 25 areaDesc no-label
   buyer colon 25
   pm    colon 25
   t     colon 25
   skip(1)

with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

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
   if grp1 = hi_char then grp1 = "".
   if due = low_date then due = ?.
   if due1 = hi_date then due1 = ?.

   if c-application-mode <> 'web' then
      update site site1 part part1 grp grp1 due due1 vend area buyer pm t with frame a.

   {wbrp06.i &command = update
      &fields = " site site1 part part1 grp grp1 due due1 vend area buyer pm t"
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      {mfquoter.i site }
      {mfquoter.i site1}
      {mfquoter.i part }
      {mfquoter.i part1}
      {mfquoter.i grp}
      {mfquoter.i grp1}
      {mfquoter.i due  }
      {mfquoter.i due1 }
      {mfquoter.i vend }
      {mfquoter.i buyer}
      {mfquoter.i pm}
      {mfquoter.i t}

      if site1 = "" then site1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if grp1 = "" then grp1 = hi_char.
      if due = ? then due = low_date.
      if due1 = ? then due1 = hi_date.

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
   empty temp-table tmp_po no-error.
   for each tmp_po exclusive-lock: delete tmp_po. end.
   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_group >= grp and (pt_group <= grp1 or grp1 = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and pt_pm_code = pm
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det no-lock WHERE mrp_det.mrp_part = pt_part and
            mrp_det.mrp_detail = "计划单" and
            mrp_det.mrp_due_date >= due and
           (mrp_det.mrp_due_date <= due1 or due1 = ?)
            USE-INDEX mrp_part:
       assign vt = "".
       find first xvp_ctrl no-lock where xvp_part = pt_part
              and xvp_vend = pt_vend no-error.
       if available xvp_ctrl then do:
          assign vt = xvp__chr01.
       end.
          create tmp_po.
          assign tpo_vend = pt_vend
                 tpo_part = pt_part
                 tpo_due = mrp_due
                 tpo_qty = mrp_qty
                 tpo_type = vt.
   END.
if t then vt = "T". else vt = "".
for each tmp_po exclusive-lock where tpo_type <> vt:
    delete tmp_po.
end.

/*产生单号*/
assign areaDesc = "".
for each tmp_po exclusive-lock where tpo_vend <> ""
    break by tpo_vend:
    if first-of(tpo_vend) then do:
       run getPoNumber(input today,input tpo_vend,output areaDesc).
    end.
    assign tpo_nbr = areaDesc.
end.
assign areaDesc = "".

export delimiter "~011" getTermLabel("PO_NUMBER",12)
                        getTermLabel("SUPPLIER",12)
                        getTermLabel("ITEM_NUMBER",12)
                        getTermLabel("QUANTITY_ON_ORDER",12)
                        getTermLabel("DUE_DATE",12).
/*                      getTermLabel("TYPE",12).                             */
/*                        getTermLabel("WEEK",12)                            */
/*                        getTermLabel("SHIP_TERMS",12)                      */
/*                        getTermLabel("COMMENT",12).                        */
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
    export delimiter "~011" tpo_nbr tpo_vend tpo_part tpo_qty tpo_due.
/*                          weekday(tpo_due) - 1 tpo_rule areaDesc.          */
/*                          tpo_start tpo_end tpo_mrp_date.                  */
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
     assign oNbr = KEY2 + substring("0000" + string(inti),
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
