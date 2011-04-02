
/* xsfiforp.p - BARCODE SYSTEM FIFO AUDIT REPORT -- Softspeed                */
/* Copyright 2005 Softspeed Conusltant Ltd.,                       */
/**Ver: 1******************************Sam Song 20050801 ***********/

{mfdtitle.i "b+ "}

define variable part           like ld_part        no-undo.
define variable part1          like ld_part        no-undo.
define variable user_from        like tr_userid      no-undo.
define variable user_to        like tr_userid      no-undo.
define variable effdate        like tr_effdate     no-undo.
define variable effdate1       like tr_effdate     no-undo.


/* DEFINE SELECTION FRAME */
form
   user_from      colon 25 label "用戶"
   user_to        colon 50 label {t001.i}
   part           colon 25 label "料品"
   part1          colon 50 label {t001.i}
   effdate        colon 25 label "發料日期"
   effdate1       colon 50 label {t001.i}  skip (1)

with frame a width 80 side-labels.
 setFrameLabels(frame a:handle).
 
{wbrp01.i}

repeat:

   /* RESET HI CHARACTER VALUES */
   if part1     = hi_char  then part1   = "".
   if user_to   = hi_char  then user_to   = "".
   if effdate   = low_date then effdate = ?.
   if effdate1  = hi_date  then effdate1 = ?.

   if c-application-mode <> "WEB" then
   update
      user_from
      user_to
      part
      part1
      effdate
      effdate1
   with frame a.

   {wbrp06.i &command = update
      &fields = "user_from   user_to
                 part      part1
		 effdate   effdate1"
      &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:
      /* ALLOCATION DETAIL NOT ALLOWED WITH SUMMARY REPORT */

      bcdparm = "".
      {mfquoter.i user_from       }
      {mfquoter.i user_to       }
      {mfquoter.i part          }
      {mfquoter.i part1         }
      {mfquoter.i effdate       }
      {mfquoter.i effdate1      }

      if part1     = "" then part1     = hi_char.
      if user_to   = "" then user_to   = hi_char.
      if effdate   = ?  then effdate   = low_date.
      if effdate1  = ?  then effdate1 = hi_date.

   end.  /* if c-application-mode <> "WEB" ... */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = " "
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

   {mfphead.i}

   /* CALL APPROPRIATE PROGRAM TO PRINT REPORT:                   */
   /* ICRLRPA.P -- SUMMARY REPORT SORTED BY ITEM/SITE             */
   /* ICRLRPB.P -- SUMMARY REPORT SORTED BY SITE/ITEM             */
   /* ICRLRPC.P -- DETAIL  REPORT SORTED BY ITEM/SITE             */
   /* ICRLRPD.P -- DETAIL  REPORT SORTED BY SITE/ITEM             */
	for each tr_hist where tr_type = "ISS-WO" and  tr__chr01 <> "" and tr_qty_loc < 0 
	                   and tr_part >= part and tr_part <= part1 and tr_userid >= user_from and tr_userid <= user_to
			   and tr_effdate >= effdate and tr_effdate <= effdate1  use-index tr_eff_trnbr no-lock : 
	display tr_userid  label "用戶"  
		tr_effdate column-label "發料日期" 
		tr_trnbr   column-label "交易號"
		trim( tr_nbr )     label "工單" 
		tr_lot	   label "ID" 
		trim( tr_part )   label "料號" format "x(18)"
		tr_loc     column-label "發料庫位"
		tr_serial  label "實發批號"  format "X(15)"
		( - tr_qty_loc ) label "實發數量"  
		substring(tr__chr01,1,18) label "最小批號" format "X(15)"
		substring (tr__chr01,19,20) label "批號數量" 
		if decimal( substring (tr__chr01,19,20) ) > ( - tr_qty_loc ) then "*" else "" column-label "LV" format "x(2)"
		"" label "原因分析" with width 200.
	
        end.
	   {mfrtrail.i}
	end.  /* repeat */

{wbrp04.i &frame-spec = a}
