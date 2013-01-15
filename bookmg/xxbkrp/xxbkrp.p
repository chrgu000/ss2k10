/* xxbkrp.p - book report                                                     */
/*V8:ConvertMode=FullGUIReport                                                */

/* DISPLAY TITLE */
{mfdtitle.i "120115.1"}
{xxbkmg.i}
/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable v_book like xxbk_id.
define variable v_book1 like xxbk_id.
define variable v_bktype as character format "x(20)".
define variable v_bkstat as character format "x(10)".
define variable v_lendcnt as integer.
define variable v_days as integer.
define variable v_avail like mfc_logical.
define variable v_start as date.
define variable v_start1 as date.
define variable v_bc like xxbc_id.
define variable v_bcname like xxbc_name.
define variable v_blstart as date.
define variable v_end like xxbl_end.

form
   v_book   colon 12
   v_book1  colon 40 label {t001.i}  
   v_start  colon 12
   v_start1 colon 40  label {t001.i} skip 
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

   if v_book1 = hi_char then v_book1 = "".
	 if v_start = low_date then v_start = ?.
	 if v_start1 = hi_date then v_start1 = ?.
   if c-application-mode <> 'web' then
      update v_book v_book1 v_start v_start1 with frame a.

   {wbrp06.i &command = update 
   					 &fields = " v_book v_book1 v_start v_start1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if v_book1 = "" then v_book1 = hi_char.       
      if v_start = ? then v_start = low_date.
      if v_start1 = ? then v_start1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}


   for each xxbk_lst no-lock
      where xxbk_id >= v_book and xxbk_id <= v_book1
   with frame b width 320 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
			assign v_bktype = ""
			       v_bkstat = ""
			       v_days  = 0
			       v_avail = no
			       v_bc = "" 
			       v_bcname = "" 
			       v_blstart = ?
			       v_end = ?.
			find first usrw_wkfl no-lock where usrw_key1 = v_key_book01
                      and usrw_key2 = xxbk_type no-error.
      if available usrw_wkfl then do:
         assign v_bktype = usrw_key3
         			  v_days = usrw_intfld[1].
      end.
			find first usrw_wkfl no-lock where usrw_key1 = v_key_book02
                      and usrw_key2 = xxbk_stat no-error.
      if available usrw_wkfl then do:
         assign v_bkstat = usrw_key3
         				v_avail = usrw_logfld[1].
      end.             
      assign v_lendcnt = 0.
      for each xxbl_hst no-lock where xxbl_bkid = xxbk_id 
      		 and xxbl_start >= v_start and xxbl_start <= v_start1
      		 break by xxbl_bkid by xxbl_start:
      		 assign v_lendcnt = v_lendcnt + 1.
      		 if last-of(xxbl_bkid) then do:
      				assign v_bc = xxbl_bcid
      							 v_blstart = xxbl_start
      							 v_end = xxbl_end.   
      		 end.
    	end.        
    	if v_avail then do:
    		 find last xxbl_hst no-lock where xxbl_bkid = xxbk_id no-error.
    		 if available xxbl_hst then do:
    		 	 if xxbl_end = ? then v_avail = no.
      	 end.           
      end.
    	assign v_bcname = "".
    	find first xxbc_lst no-lock where xxbc_id = v_bc no-error.
    	if available xxbc_lst then do:
      	 assign v_bcname = xxbc_name.
      end.
			display xxbk_id xxbk_name xxbk_desc xxbk_type v_bktype v_days 
							xxbk_stat v_bkstat v_avail xxbk_price xxbk_reg_date
							v_lendcnt v_bc v_bcname v_blstart v_end.
			
      {mfrpchk.i}

   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
