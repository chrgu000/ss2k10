/* xxmrpporp0.i - vender mrp po report                                       */
/* revision: 110901.1   created on: 20110901   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110909.1"}
{xxmrpporpa.i}
define variable site like si_site.
define variable site1 like si_site.
define variable part like pt_part /*INITIAL "MHTA03-NE0-10-CK"*/.
define variable part1 like pt_part /*INITIAL "MHTA03-NE0-10-CK"*/.
define variable due as date.
define variable duef as date.
define variable duet as date.
define variable vend like vd_addr.
define variable buyer like pt_buyer INITIAL "4RSA".
define variable area as character format "x(1)".
define variable areaDesc as character format "x(40)".
define variable sendDate as date.
define variable qty_nextMth like pod_qty_ord.
define variable act as logical initial yes.
define variable qtytemp as decimal.
define variable qtytemp1 as decimal.
define variable xvpweek like xvp_week.
define temp-table tmp_po
    fields tpo_nbr like po_nbr
    fields tpo_vend like vd_addr
    fields tpo_part like pt_part
    fields tpo_type as character
    fields tpo_due  like po_due_date
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
 
assign areaDesc = getTermLabel("XVP_AREA_DESC",40).
display areaDesc with frame a.
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
  empty temp-table tmp_po no-error. 

   FOR EACH pt_mstr no-lock where
            pt_part >= part and pt_part <= part1 and
            substring(pt_part,1,1) <> "X"
            and (pt_buyer = buyer or buyer = "")
            and pt_site >= site and (pt_site <= site1 or site1 = "")
            and (pt_vend = vend or vend = "")
            and (substring(pt_vend,1,1) = area or area = ""),
       EACH mrp_det WHERE mrp_part = pt_part and 
            mrp_detail = "计划单" USE-INDEX mrp_part,
       EACH vd_mstr no-lock where vd_addr = pt_vend and vd__chr03 <> "" :
      run getDateArea(input due,input vd__chr03,output duef, output duet).
 	    if mrp_due_date < duef or mrp_due_date > duet then do:
 	    	 next.
 	    end.
      run getOrdDay(input site,input vd__chr03,input due,input mrp_due_date, 
      					    output sendDate).
      find first tmp_po exclusive-lock where tpo_part = pt_part
             and tpo_vend = pt_vend and tpo_due = sendDate no-error.
      if available tmp_po then do:
         assign tpo_qty = tpo_qty + mrp_qty .
      end.
      else do:
        create tmp_po.
        assign tpo_vend = pt_vend
               tpo_part = pt_part
               tpo_due = sendDate 
               tpo_qty = mrp_qty
               tpo_start = duef
               tpo_end = duet
               tpo_rule = vd__chr03.
        find first xvp_ctrl where xvp_vend = pt_vend
        			 and xvp_part = pt_part no-lock no-error.
        if availabl xvp_ctrl then do:
        	 assign tpo_type = "T".
        end.
      end.
  /*    {mfrpchk.i} */
    END. /* FOR EACH PT_MSTR,XVP_CTRL,MRP_DET */


/*产生单号
assign areaDesc = "".
for each tmp_po exclusive-lock where tpo_qty > 0 and tpo_flag <> ""
     and tpo_vend <> ""
    break by tpo_vend by tpo_flag by tpo_due:
    if first-of(tpo_flag) then do:
       run getPoNumber(input today,input tpo_vend,output areaDesc).
    end.
    assign tpo_nbr = areaDesc.
end.
assign areaDesc = "".
*/

export delimiter "~011" getTermLabel("PO_NUMBER",12)
											  getTermLabel("TYPE",12)
                        getTermLabel("SUPPLIER",12)
                        getTermLabel("ITEM_NUMBER",12)
                        getTermLabel("RECEIVED_QTY",12)
                        getTermLabel("DUE_DATE",12)
                        getTermLabel("WEEK",12)
                        getTermLabel("SHIP_TERMS",12)
                        getTermLabel("COMMENT",12)
                        getTermLabel("START",12)
                        getTermLabel("END",12).
for each tmp_po no-lock where:
		assign areaDesc = "".
		find first code_mstr no-lock where code_fldname = "vd__chr03"
					 and code_value = tpo_rule no-error.
		if available code_mstr then do:
			 assign areaDesc = code_cmmt.
	  end.
    export delimiter "~011" tpo_nbr tpo_type tpo_vend tpo_part tpo_qty 
    											  tpo_due weekday(tpo_due) - 1 tpo_rule areaDesc 
    											  tpo_start tpo_end.
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
     assign intI = qad_intfld[1] + 1
            qad_intfld[1] = qad_intfld[1] + 1
            qad_key3 = string(qad_intfld[1] + 1).
  end.
  else do:
      create qad_wkfl.
      assign qad_key1 = "xxmrpporp0.p"
             qad_key2 = oNbr
             qad_intfld[1] = 0
             qad_key3 = "0".
  end.
  release qad_wkfl.
  assign oNbr = oNbr + substring("0000" + string(inti),
                       length("0000" + string(inti)) - 2).
END PROCEDURE.
