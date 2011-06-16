/* SS - 090806.1 By: Neil Gao */
/* SS - 090902.1 By: Neil Gao */

/* SS 090806.1 - B */
/*
增加删除记录的功能,
同步修改7.1.1 的记录
*/
/* SS 090806.1 - E */

/* SS 090902.1 - B */
/*
删除空so_mstr记录
*/
/* SS 090902.1 - E */

{mfdtitle.i "090902.1"}


define variable xxsodaddr like xxsod_addr.
define variable xxsodaddr1 like xxsod_addr.
define variable xxsoduedate  AS DATE  .
define variable xxsoduedate1 AS DATE  .
define variable xxsoduedate2 AS DATE  .
define variable xxsoduetime as char format "99:99" init "0000".
define variable xxsoduetime1 as char format "99:99" init "2400".
define variable xxsoduetime2 as char format "99:99".
define variable xxsoduetime3 as CHAR .

define variable xxsodinvnbr like xxsod_invnbr.
define variable xxsodinvnbr1 like xxsod_invnbr.
define variable xxsodqtyord like  xxsod_qty_ord.
define variable xxsodrmks2 like xxsod_rmks2.
define variable ifupdate as logical.

DEF VAR v_del AS LOGICAL INIT NO .
DEF VAR v_due_date AS CHAR.
DEF VAR v_due_time AS CHAR.

DEF VAR i AS INTEGER .

/* SS 090806.1 - B */
define var tnbr1 as char.
define variable tmonth as char.
define variable tpart like pt_part.
define var v_tax LIKE pt_taxable .
define var v_tax1 LIKE pt_taxable .
define var tqty01 as deci.
define var fn_i as char init "xxinsomtn2".
/* SS 090806.1 - E */

form 
   xxsodaddr  colon 12   label "收货地点"
   xxsodaddr1 colon 40   label "至"
   xxsoduedate colon 12  label "送货日期"
   xxsoduedate1 colon 40 label "至"
   xxsoduetime  colon 12 label "送货时间"
   xxsoduetime1 colon 40 label "至"
   xxsodinvnbr  colon 12 label "传票号码"
   xxsodinvnbr1 colon 40 label "至"
   skip(1)
   "修改后的值(未输入项不做修改):"  colon 8   skip(1)
   xxsoduedate2 colon 30 label "送货日期"
   xxsoduetime2 colon 30 label "送货时间"
   xxsodqtyord  colon 30 label "数量"
   xxsodrmks2   colon 30 label "备注"
   v_del        COLON 30 LABEL "是否删除" 
with frame a side-label width 80 .
setFrameLabels(frame a:handle).
  
main:
repeat :

  if xxsodaddr1 = hi_char then xxsodaddr1 = "".
  if xxsoduedate  = low_date then xxsoduedate = ? .
  if xxsoduedate1 = hi_date then xxsoduedate1 = ? .
  if xxsodinvnbr1 = hi_char then xxsodinvnbr1 = "".
        
  xxsoduetime = "0000".
  xxsoduetime1 = "2400".

  update  xxsodaddr   xxsodaddr1 
          xxsoduedate xxsoduedate1
          xxsoduetime xxsoduetime1
          xxsodinvnbr xxsodinvnbr1
  with frame a.
  
  if xxsodaddr1 = "" then xxsodaddr1 = hi_char.
  if xxsoduedate  = ? then xxsoduedate = low_date.
  if xxsoduedate1 = ? then xxsoduedate1 = hi_date. 
  if xxsodinvnbr1 = "" then xxsodinvnbr1 = hi_char.
     
  update xxsoduedate2 xxsoduetime2 
         xxsodqtyord  xxsodrmks2 
         v_del
         with frame a.
           
  xxsoduetime = SUBSTRING(xxsoduetime,1,2) + ":" + SUBSTRING(xxsoduetime,3,2) .
  xxsoduetime1 = SUBSTRING(xxsoduetime1,1,2) + ":" + SUBSTRING(xxsoduetime1,3,2) .

  {mfselprt.i "printer" 120}

  i = 1.
  PUT "客户代码" AT i . i = i + 10 .
  PUT "客户图号" AT i . i = i + 20.
  PUT "传票号码" AT i . i = i + 20.
  PUT "送货日期" AT i . i = i + 12.
  PUT "送货时间" AT i . i = i + 10 .
  PUT "订货数量" AT i . i = i + 16.
  PUT "备注1"    AT i .
  for each xxsod_det no-lock where xxsod_addr >= xxsodaddr 
                               and xxsod_addr <= xxsodaddr1 
                               and date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= xxsoduedate 
                               and date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 
                               and xxsod_invnbr >= xxsodinvnbr 
                               AND xxsod_invnbr <= xxsodinvnbr1
                               AND int(entry(1,xxsod_due_time1,":")) * 60 + INT(ENTRY(2,xxsod_due_time1,":")) >= int(entry(1,xxsoduetime,":")) * 60 + INT(ENTRY(2,xxsoduetime,":"))  
                               AND int(entry(1,xxsod_due_time1,":")) * 60 + INT(ENTRY(2,xxsod_due_time1,":")) <= int(entry(1,xxsoduetime1,":")) * 60 + INT(ENTRY(2,xxsoduetime1,":")) :

       xxsoduetime3 = "".
       IF xxsoduedate2 = ?  THEN v_due_date = xxsod_due_date1 .

      /* MESSAGE xxsoduetime2 + "----" + xxsod_due_time1  VIEW-AS ALERT-BOX.  */
       
       IF xxsoduetime2 = "" THEN v_due_time = string(INT(ENTRY(1,xxsod_due_time1,":")),"99") + ":" + STRING(INT(ENTRY(2,xxsod_due_time1,":")),"99").
                            ELSE xxsoduetime3 = substring(xxsoduetime2,1,2) + ":" + SUBSTRING(xxsoduetime2,3,2)  .

      /* MESSAGE v_due_time + "----" xxsoduetime3  VIEW-AS ALERT-BOX. */
                                                    
       i = 1.
       PUT UNFORMATTED xxsod_cust AT i . i = i + 10.
       PUT UNFORMATTED xxsod_part AT i . i = i + 20.
       PUT UNFORMATTED xxsod_invnbr AT i . i = i + 20.
       IF xxsoduedate2 <> ? THEN DO:
           PUT UNFORMATTED (string(year(xxsoduedate2)) + "-" + STRING(MONTH(xxsoduedate2)) + "-" + STRING(DAY(xxsoduedate2)) ) AT i .
           i = i + 12 .
       END.
       ELSE DO:
           PUT UNFORMATTED v_due_date AT i .
           i = i + 12.
       END.

       IF xxsoduetime2 <> "" THEN DO:
           PUT UNFORMATTED xxsoduetime3 AT i .
           i = i + 10 .
       END.
       ELSE DO:
           PUT UNFORMATTED v_due_time AT i .
           i = i + 10.
       END.
       IF xxsodqtyord <> 0 THEN DO:
           PUT UNFORMATTED xxsodqtyord AT i .
           i = i + 16.
       END.
       ELSE DO:
           PUT UNFORMATTED xxsod_qty_ord AT i .
           i = i + 16.
       END.
       IF xxsodrmks2 <> "" THEN DO:
           PUT UNFORMATTED xxsodrmks2 AT i.
       END.
       ELSE DO:
           PUT UNFORMATTED xxsod_rmks1 AT i.
       END.
       PUT SKIP.
  end.  
  
  /*
  xxsoduetime = "0000".
  xxsoduetime1 = "2400".
  DISP xxsoduetime xxsoduetime1 WITH FRAME a .
  */

  {mfreset.i} 
  {mfgrptrm.i}

  message "是否更新 ？"  update ifupdate  .
   
  if ifupdate then 
  do transaction on error undo , retry :
      for each xxsod_det where xxsod_addr >= xxsodaddr 
                           AND xxsod_addr <= xxsodaddr1
                           AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= xxsoduedate 
                           AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 
                           AND xxsod_invnbr >= xxsodinvnbr 
                           AND xxsod_invnbr <= xxsodinvnbr1 
                           AND int(entry(1,xxsod_due_time1,":")) * 60 + INT(ENTRY(2,xxsod_due_time1,":")) >= int(entry(1,xxsoduetime,":")) * 60 + INT(ENTRY(2,xxsoduetime,":"))  
                           AND int(entry(1,xxsod_due_time1,":")) * 60 + INT(ENTRY(2,xxsod_due_time1,":")) <= int(entry(1,xxsoduetime1,":")) * 60 + INT(ENTRY(2,xxsoduetime1,":"))
                           :
          
          if xxsoduedate2 <> ? then do:
	         ASSIGN xxsod_due_date1 = string(year(xxsoduedate2),"9999") + "-" + STRING(MONTH(xxsoduedate2),"99") + "-" + STRING(DAY(xxsoduedate2),"99") .
	      end.

          if xxsoduetime2 <> "" then do:
             ASSIGN xxsod_due_time1 = xxsoduetime3 .
          END.

          if xxsodqtyord  <> 0  then ASSIGN xxsod_qty_ord = xxsodqtyord.
          if xxsodrmks2   <> "" then ASSIGN xxsod_rmks1 = xxsodrmks2 .           
     end.   
     ifupdate = NO.
  end.  /*do */                              

  IF v_del = YES THEN DO:
      for each xxsod_det where xxsod_addr >= xxsodaddr
                           AND xxsod_addr <= xxsodaddr1
                           AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= xxsoduedate
                           AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 
                           AND xxsod_invnbr >= xxsodinvnbr 
                           AND xxsod_invnbr <= xxsodinvnbr1 
                           AND int(entry(1,xxsod_due_time1,":")) * 60 + INT(ENTRY(2,xxsod_due_time1,":")) >= int(entry(1,xxsoduetime,":")) * 60 + INT(ENTRY(2,xxsoduetime,":"))  
                           AND int(entry(1,xxsod_due_time1,":")) * 60 + INT(ENTRY(2,xxsod_due_time1,":")) <= int(entry(1,xxsoduetime1,":")) * 60 + INT(ENTRY(2,xxsoduetime1,":"))
                           :
/* SS 090809.1 - B */
							find first cm_mstr where cm_addr = xxsod_cust no-lock no-error.
							if not avail cm_mstr then next.
           		find first cp_mstr where cp_cust = xxsod_cust and cp_cust_part = xxsod_part no-lock no-error.
							if not avail cp_mstr then do:
								message "错误: 客户零件不存在".
								next.
							end.
							else tpart = cp_part.
							FIND FIRST pt_mstr WHERE pt_part = tpart no-lock no-error.
  						IF AVAIL pt_mstr THEN v_tax = pt_taxable .
  						find first ad_mstr where ad_addr = xxsod_cust no-lock no-error.
  						if avail ad_mstr then v_tax1 = ad_taxable.
							IF SUBSTRING(xxsod_rmks,11,2) = "10" THEN tmonth = "A".
							else if SUBSTRING(xxsod_rmks,11,2) = "11" then tmonth = "B".
							else if SUBSTRING(xxsod_rmks,11,2) = "12" then tmonth = "C".
							else tmonth = SUBSTRING(xxsod_rmks,12,1).
							tnbr1  = SUBSTRING(cm_sort,1,2) + substring(xxsod_type,1,1) + substring(xxsod_due_date1,4,1)
									+ tmonth + SUBSTRING(xxsod_project,1,1) + string(xxsod_week).
							find first sod_det where sod_nbr = tnbr1 and sod_part = tpart no-error.
							if not avail sod_det then do:
								message "错误: 订单号不存在" tnbr1. 
								undo,retry.
							end.
           		tqty01 = sod_qty_ord.
           		if sod_qty_ord = xxsod_qty_ord then do:
           			if sod_qty_inv = 0 and sod_qty_ship = 0 then do:
           				for each mrp_det where mrp_det.mrp_dataset = "sod_det" and mrp_det.mrp_part = sod_part
         						and mrp_det.mrp_nbr = sod_nbr and mrp_det.mrp_line = string(sod_line):
  						 			delete mrp_det.
  						 		end.
           				for each cmt_det where cmt_indx = sod_det.sod_cmtindx exclusive-lock:
      				  	 delete cmt_det.
   								end.
   								for each lad_det where lad_dataset = "sod_det" and lad_nbr = sod_nbr and lad_line = string(sod_det.sod_line) exclusive-lock:
     								 find ld_det where ld_site = lad_site and ld_loc  = lad_loc and ld_lot  = lad_lot and ld_ref  = lad_ref
                    	and ld_part = lad_part exclusive-lock no-error.
      							if available ld_det then ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
      								delete lad_det.
   								end.
   								for each tx2d_det where tx2d_tr_type = "41" and tx2d_ref = sod_nbr and tx2d_line = sod_line exclusive-lock:
      							delete tx2d_det.
   								end.
   								for each sodr_det exclusive-lock   where sodr_nbr  = sod_nbr and sodr_line = sod_line:
   									delete sodr_det.
									end.
									delete sod_det.
/* SS 090902.1 - B */
									/* 删除空so_mstr*/
									find first sod_det where sod_nbr = tnbr1 no-lock no-error.
									if not avail sod_det then do:
										find first so_mstr where so_nbr = tnbr1 no-error.
										if avail so_mstr then do:
											for each ied_det where ied_type = "1" and	ied_nbr = so_nbr exclusive-lock:
   											delete ied_det.
											end.
											for each ie_mstr where ie_type = "1" and ie_nbr = so_nbr exclusive-lock:
   											delete ie_mstr.
											end.
											for each cmt_det where cmt_indx = so_cmtindx exclusive-lock:
   											delete cmt_det.
											end.
											{gprun.i ""gppihdel.p"" "(1, so_nbr, 0)"}
											{gprun.i ""sosoapm3.p"" "(input so_nbr)"}
											delete so_mstr.
										end. /* if avail so_mstr then do */
									end. /* if not avail sod_det */
/* SS 090902.1 - E */

/* SS 090821.1 - B */
									DELETE xxsod_det .
/* SS 090821.1 - E */
           			end.
           			else do:
           				message "错误: 不能删除订单" tnbr1.
           				undo,retry.
           			end.    			
           		end. /* if sod_qty_ord = xxsod_qty_ord */
           		else do:
           			OUTPUT TO VALUE(fn_i + ".inp").
								put unformat """" + trim(tnbr1) + """" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put unformat string(sod_line) skip.
								put "-" skip.
								put unformat string(sod_qty_ord - xxsod_qty_ord) skip.
								put "-" skip.
								put "-" skip.
								IF v_tax = YES AND v_tax1 = YES THEN DO:
        					put "-" skip.
        				END.
								put "." skip.
								put "." skip.
								put "-" skip.
								put "-" skip.
								put "." skip.
								OUTPUT CLOSE .
								
								INPUT FROM VALUE(fn_i + ".inp") .
        				OUTPUT TO VALUE(fn_i + ".cim") .
        				batchrun = YES.
        				{gprun.i ""sosomt.p""}
       					batchrun = NO.
        				INPUT CLOSE .
        				OUTPUT CLOSE .
              	
								find first sod_det where sod_nbr = tnbr1 and sod_part = tpart no-lock no-error.
								if not avail sod_det or sod_qty_ord <> tqty01 - xxsod_qty_ord then do:
									message "错误:更新失败".
									undo ,retry.
								end.
								unix silent value("del " + trim(fn_i)  + ".inp").
								unix silent value("del " + trim(fn_i)  + ".cim").
/* SS 090821.1 - B */
								DELETE xxsod_det .
/* SS 090821.1 - E */

           		end.
/* SS 090809.1 - E */
/* SS 090821.1 - B */
/*
          DELETE xxsod_det .
*/
/* SS 090821.1 - E */
      END.
  END. /* if v_del = yes */

end.  /* main:  repeat :  */
