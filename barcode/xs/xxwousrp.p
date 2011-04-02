/* REVISION: eb    BY: Micho Yang  Date: 09/05/05    */



 {mfdtitle.i "a+ "}

define var  wo_lot_yn like mfc_logical init yes .
define var nbr like wo_nbr.
define var nbr1 like wo_nbr.

define var  lot_wo_yn like mfc_logical init no .
define var part like wo_part.
define var part1 like wo_part.
define var lot2 like tr_serial.
define var lot1 like tr_serial.
define var v_flag like mfc_logical.
define var wpo like po_nbr.
define var wrm like tr_lot.
define var SUMISSQTY like tr_qty_loc.

define buffer trhist for tr_hist.

Form
     wo_lot_yn label  "1. 通過WO查找LOT資料"    colon  25
     skip(1)
     nbr      colon  20
     nbr1    colon  50
     skip(1)
     lot_wo_yn label "2. 通過LOT查找WO資料"      colon  25
     skip(1)
     part     colon  20
     lot2       label "批號"  colon  20 
     skip(1)
      
   "使用方法:  1) 用戶選擇其中的一個查詢方式                             " at 2 skip
   "           2) 如果選擇第2種查詢方式，就一定要輸入查詢條件            " at 2 skip
   "           3) 該報表不更新任何MFG/PRO資料                            " at 2 skip(1)
with frame a side-labels .

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K0PW*/ {wbrp01.i}

repeat:

           if nbr1 = hi_char then nbr1 = "".
	    
           update
	           wo_lot_yn 
		   lot_wo_yn  
           with frame a. 

	   if lot_wo_yn = yes and wo_lot_yn = yes then do:
               message "隻能選擇兩者中的一個為""YES"",請重新選擇條件! "
                              view-as alert-box INFORMATION BUTTONS OK  TITLE  "Message"   .
               undo , retry .
           end .   /* if lot_wo_yn = yes and wo_lot_yn = yes */

	   if wo_lot_yn = YES then do:
               update
	                   nbr
			   nbr1 
			   with frame a.
	   end. /* if wo_lot_yn = yes */


	   if lot_wo_yn = YES then do:  
	       loopb:
	       repeat:
                   update
	                   part
			   lot2
			   with frame a.

		if part = "" or  lot2 = ""  then do:
                    message "請輸入選擇條件! "
                            view-as alert-box INFORMATION BUTTONS OK  TITLE  "Message"   .
                    undo loopb  ,retry loopb  .
		end. 
		leave.
		end.
	   end. /* if lot_wo_yn = yes */

            {mfquoter.i wo_lot_yn   }
            {mfquoter.i nbr     }
            {mfquoter.i nbr1   }
            {mfquoter.i lot_wo_yn   }
            {mfquoter.i part     }
            {mfquoter.i lot2    }

            if  nbr1 = "" then nbr1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

  if wo_lot_yn = yes and lot_wo_yn = no then do:
      put "<< 以下為工單使用情況資料 >>" at 1 skip .
     for each tr_hist where  tr_nbr >= nbr and tr_nbr <= nbr1 and tr_type = "ISS-WO"  use-index tr_nbr_eff  no-lock  :
         wpo = "".
	 wrm = "".

         if length(tr_hist.tr_serial) = 13 then  do: 
            find first trhist where trhist.tr_serial = tr_hist.tr_serial  and trhist.tr_type = "RCT-PO" and trhist.tr_part = tr_hist.tr_part use-index tr_serial no-lock no-error.
            if available trhist then do:
	       wpo = trhist.tr_nbr.
	       wrm = trhist.tr_lot.
	    end.
	 end.

	 display 
	                  tr_hist.tr_effdate column-label "發料日期"
			  tr_hist.tr_nbr     column-label "工單"
			  tr_hist.tr_lot     column-label "ID"
			  tr_hist.tr_part    column-label "料號"
			  tr_hist.tr_serial  column-label "批號"
			  -(tr_hist.tr_qty_loc) column-label "發料數量"
			  wpo  column-label "採購單"
			  wrm  column-label "RM 單"

		         with width 200    .	 
      end. /* for each tr_hist */
  end.  /* if wo_lot_yn = yes */

  if lot_wo_yn = yes and wo_lot_yn = no then do:
       put "<< 以下為採購收貨資料 >>" at 1 skip .
      for each tr_hist where  tr_part  = part  and tr_serial = lot2   and tr_type = "RCT-PO"  use-index tr_serial no-lock  :
           find first ad_mstr where ad_addr = tr_addr no-lock no-error.
	   if available ad_mstr then do:
		  display 
	                  tr_hist.tr_addr	column-label "供應商"
                          ad_name		column-label "名稱"
			  tr_hist.tr_nbr	column-label "採購單"
			  tr_hist.tr_lot	column-label "RM 單"
 			  tr_hist.tr_part	column-label "料品"
			  tr_hist.tr_effdate	column-label "收貨日期"
			  tr_hist.tr_serial     column-label "批號"
			  tr_hist.tr_qty_loc	column-label "收貨數量" at 117
		         with  width 200    .	

	   end. /*  if available ad_mstr */ 
     end. /* for each */

     SUMISSQTY = 0.
     put  SKIP(1) "<< 以下為工單使用情況資料 >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and tr_type = "ISS-WO"  use-index tr_serial no-lock  :
         SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.

         find first wo_mstr where wo_lot =  tr_hist.tr_lot  no-lock no-error .
                  display 
	                  tr_hist.tr_effdate column-label "發料日期" at 3
			  tr_hist.tr_nbr     column-label "工單"
			  tr_hist.tr_lot     column-label "ID"
                 if available wo_mstr then wo_so_job else "" column-label "銷售訂單"

		 if available wo_mstr then wo_part else "" column-label   "成品"  format "x(18)"
			  tr_hist.tr_part    column-label "料號"
			  tr_hist.tr_serial  column-label "批號"
			  -(tr_hist.tr_qty_loc) column-label "發料數量"
			  SUMISSQTY          column-label "累計使用數量" at 117
		          with  width 200    .	

     end. /* for each tr_hist */


     put SKIP(1) "<< 以下為-其他單據-使用情況資料 >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and ( tr_type <> "RCT-TR" and  tr_type <> "ISS-TR"   and 
                                                                         tr_type <> "RCT-PO" and  tr_type <> "ISS-WO" ) and
									 tr_qty_loc <> 0  use-index tr_serial no-lock  :

          SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.
                 display 
	                  tr_hist.tr_effdate column-label "交易日期" at 3
			  tr_hist.tr_trnbr   column-label "交易號碼"
			  tr_hist.tr_type    column-label "交易類型"
                          tr_hist.tr_userid  column-label "處理ID"
			  tr_hist.tr_nbr     column-label "單據號碼"
			  tr_hist.tr_part    column-label "料號"
			  tr_hist.tr_serial  column-label "批號"
			  - tr_hist.tr_qty_loc column-label "交易數量"
  			  SUMISSQTY          column-label "累計使用數量" at 117
	          with  width 200    .	

     end. /* for each tr_hist */




  end.   /* if lot_wo_yn = yes */



         /* REPORT TRAILER */
         {mfrtrail.i}

end. /* repeat */
