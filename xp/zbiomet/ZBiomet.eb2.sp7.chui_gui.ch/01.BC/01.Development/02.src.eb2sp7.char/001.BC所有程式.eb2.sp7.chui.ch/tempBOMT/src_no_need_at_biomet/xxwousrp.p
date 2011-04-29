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
     wo_lot_yn label  "1. 硄筁WO琩тLOT戈"    colon  25
     skip(1)
     nbr      colon  20
     nbr1    colon  50
     skip(1)
     lot_wo_yn label "2. 硄筁LOT琩тWO戈"      colon  25
     skip(1)
     part     colon  20
     lot2       label "у腹"  colon  20 
     skip(1)
      
   "ㄏノよ猭:  1) ノめ匡拒ㄤい琩高よΑ                             " at 2 skip
   "           2) 狦匡拒材2贺琩高よΑ碞﹚璶块琩高兵ン            " at 2 skip
   "           3) 赣厨ぃ穝ヴMFG/PRO戈                            " at 2 skip(1)
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
               message "唉匡拒ㄢい""YES"",叫穝匡拒兵ン! "
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
                    message "叫块匡拒兵ン! "
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
      put "<< 虫ㄏノ薄猵戈 >>" at 1 skip .
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
	                  tr_hist.tr_effdate column-label "祇ら戳"
			  tr_hist.tr_nbr     column-label "虫"
			  tr_hist.tr_lot     column-label "ID"
			  tr_hist.tr_part    column-label "腹"
			  tr_hist.tr_serial  column-label "у腹"
			  -(tr_hist.tr_qty_loc) column-label "祇计秖"
			  wpo  column-label "蹦潦虫"
			  wrm  column-label "RM 虫"

		         with width 200    .	 
      end. /* for each tr_hist */
  end.  /* if wo_lot_yn = yes */

  if lot_wo_yn = yes and wo_lot_yn = no then do:
       put "<< 蹦潦Μ砯戈 >>" at 1 skip .
      for each tr_hist where  tr_part  = part  and tr_serial = lot2   and tr_type = "RCT-PO"  use-index tr_serial no-lock  :
           find first ad_mstr where ad_addr = tr_addr no-lock no-error.
	   if available ad_mstr then do:
		  display 
	                  tr_hist.tr_addr	column-label "ㄑ莱坝"
                          ad_name		column-label "嘿"
			  tr_hist.tr_nbr	column-label "蹦潦虫"
			  tr_hist.tr_lot	column-label "RM 虫"
 			  tr_hist.tr_part	column-label "珇"
			  tr_hist.tr_effdate	column-label "Μ砯ら戳"
			  tr_hist.tr_serial     column-label "у腹"
			  tr_hist.tr_qty_loc	column-label "Μ砯计秖" at 117
		         with  width 200    .	

	   end. /*  if available ad_mstr */ 
     end. /* for each */

     SUMISSQTY = 0.
     put  SKIP(1) "<< 虫ㄏノ薄猵戈 >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and tr_type = "ISS-WO"  use-index tr_serial no-lock  :
         SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.

         find first wo_mstr where wo_lot =  tr_hist.tr_lot  no-lock no-error .
                  display 
	                  tr_hist.tr_effdate column-label "祇ら戳" at 3
			  tr_hist.tr_nbr     column-label "虫"
			  tr_hist.tr_lot     column-label "ID"
                 if available wo_mstr then wo_so_job else "" column-label "綪扳璹虫"

		 if available wo_mstr then wo_part else "" column-label   "Θ珇"  format "x(18)"
			  tr_hist.tr_part    column-label "腹"
			  tr_hist.tr_serial  column-label "у腹"
			  -(tr_hist.tr_qty_loc) column-label "祇计秖"
			  SUMISSQTY          column-label "仓璸ㄏノ计秖" at 117
		          with  width 200    .	

     end. /* for each tr_hist */


     put SKIP(1) "<< -ㄤ虫沮-ㄏノ薄猵戈 >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and ( tr_type <> "RCT-TR" and  tr_type <> "ISS-TR"   and 
                                                                         tr_type <> "RCT-PO" and  tr_type <> "ISS-WO" ) and
									 tr_qty_loc <> 0  use-index tr_serial no-lock  :

          SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.
                 display 
	                  tr_hist.tr_effdate column-label "ユら戳" at 3
			  tr_hist.tr_trnbr   column-label "ユ腹絏"
			  tr_hist.tr_type    column-label "ユ摸"
                          tr_hist.tr_userid  column-label "矪瞶ID"
			  tr_hist.tr_nbr     column-label "虫沮腹絏"
			  tr_hist.tr_part    column-label "腹"
			  tr_hist.tr_serial  column-label "у腹"
			  - tr_hist.tr_qty_loc column-label "ユ计秖"
  			  SUMISSQTY          column-label "仓璸ㄏノ计秖" at 117
	          with  width 200    .	

     end. /* for each tr_hist */




  end.   /* if lot_wo_yn = yes */



         /* REPORT TRAILER */
         {mfrtrail.i}

end. /* repeat */
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
     wo_lot_yn label  "1. 通过WO查找LOT资料"    colon  25
     skip(1)
     nbr      colon  20
     nbr1    colon  50
     skip(1)
     lot_wo_yn label "2. 通过LOT查找WO资料"      colon  25
     skip(1)
     part     colon  20
     lot2       label "批号"  colon  20
 
     skip(1)
      
   "使用方法:  1) 用户选择其中的一个查询方式                             " at 2 skip
   "           2) 如果选择第2种查询方式，就一定要输入查询条件            " at 2 skip
   "           3) 该报表不更新任何MFG/PRO资料                            " at 2 skip(1)
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
               message "支能选择两者中的一个为""YES"",请重新选择条件! "
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
                    message "请输入选择条件! "
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
      put "<< 以下为工单使用情况资料 >>" at 1 skip .
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
	                  tr_hist.tr_effdate column-label "发料日期"
			  tr_hist.tr_nbr     column-label "工单"
			  tr_hist.tr_lot     column-label "ID"
			  tr_hist.tr_part    column-label "料号"
			  tr_hist.tr_serial  column-label "批号"
			  -(tr_hist.tr_qty_loc) column-label "发料数量"
			  wpo  column-label "采购单"
			  wrm  column-label "RM 单"

		         with width 200    .	 
      end. /* for each tr_hist */
  end. 
 /* if wo_lot_yn = yes */

  if lot_wo_yn = yes and wo_lot_yn = no then do:
       put "<< 以下为采购收货资料 >>" at 1 skip .
      for each tr_hist where  tr_part  = part  and tr_serial = lot2   and tr_type = "RCT-PO"  use-index tr_serial no-lock  :
           find first ad_mstr where ad_addr = tr_addr no-lock no-error.
	   if available ad_mstr then do:
		  display 
	                  tr_hist.tr_addr	column-label "供应商"
                          ad_name		column-label "名称"
			  tr_hist.tr_nbr	column-label "采购单"
			  tr_hist.tr_lot	column-label "RM 单"
 			  tr_hist.tr_part	column-label "料品"
			  tr_hist.tr_effdate	column-label "收货日期"
			  tr_hist.tr_serial     column-label "批号"
			  tr_hist.tr_qty_loc	column-label "收货数量" at 117
		         with  width 200    .	

	   end. /*  if available ad_mstr */ 
     end. /* for each */

     SUMISSQTY = 0.
     put  SKIP(1) "<< 以下为工单使用情况资料 >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and tr_type = "ISS-WO"  use-index tr_serial no-lock  :
         SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.

         find first wo_mstr where wo_lot =  tr_hist.tr_lot  no-lock no-error .
                  display 
	                  tr_hist.tr_effdate column-label "发料日期" at 3
			  tr_hist.tr_nbr     column-label "工单"
			  tr_hist.tr_lot     column-label "ID"
                 if available wo_mstr then wo_so_job else "" column-label "销售订单"

		 if available wo_mstr then wo_part else "" column-label   "成品"  format "x(18)"
			  tr_hist.tr_part    column-label "料号"
			  tr_hist.tr_serial  column-label "批号"
			  -(tr_hist.tr_qty_loc) column-label "发料数量"
			  SUMISSQTY          column-label "累计使用数量" at 117
		          with  width 200    .	

     end. /* for each tr_hist */


     put SKIP(1) "<< 以下为-其他单据-使用情况资料 >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and ( tr_type <> "RCT-TR" and  tr_type <> "ISS-TR"   and 
                                                                         tr_type <> "RCT-PO" and  tr_type <> "ISS-WO" ) and
									 tr_qty_loc <> 0  use-index tr_serial no-lock  :

          SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.
                 display 
	                  tr_hist.tr_effdate column-label "交易日期" at 3
			  tr_hist.tr_trnbr   column-label "交易号码"
			  tr_hist.tr_type    column-label "交易类型"
                          tr_hist.tr_userid  column-label "处理ID"
			  tr_hist.tr_nbr     column-label "单据号码"
			  tr_hist.tr_part    column-label "料号"
			  tr_hist.tr_serial  column-label "批号"
			  - tr_hist.tr_qty_loc column-label "交易数量"
  			  SUMISSQTY          column-label "累计使用数量" at 117
	          with  width 200    .	

     end. /* for each tr_hist */




  end. 
  /* if lot_wo_yn = yes */



         /* REPORT TRAILER */
         {mfrtrail.i}

end. /* repeat */