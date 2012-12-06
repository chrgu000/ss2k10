/* xxsoivcr1.p                                                       */
/* REVISION: 1.0      Create : 08/12/06   BY: mage chen             */

         {mfdtitle.i "1.0"}
         define new shared variable nbr like so_nbr.
         define new shared variable nbr1 like so_nbr.
         define new shared variable rcpdate like so_ship_date.
         define new shared variable rcpdate1 like so_ship_date.
         define new shared variable cust  like so_cust.
         define new shared variable cust1 like so_cust.
         define new shared variable bill  like so_bill.
         define new shared variable bill1 like so_bill.
	 define variable process1  like mfc_logical no-undo.
	 define variable firstplan  like mfc_logical no-undo.

         define variable errfile as char format "x(40)" initial "/home/pur/po.prn" no-undo.
	 define variable outfile as char format "x(40)" initial "/home/pur/pe.txt" no-undo.
	 define variable errfile1 as char format "x(40)" initial "/home/pur/so.prn" no-undo.
	 define variable outfile1 as char format "x(40)" initial "/home/pur/se.txt" no-undo.
	 define variable sodqtychg like sod_qty_chg no-undo.
	 define variable process2  like mfc_logical no-undo.

         define variable poderr  like mfc_logical no-undo.

         define variable soderr  like mfc_logical no-undo.

	 define variable file as char format "x(14)" label "导入文件名".
	 define variable modelyr like scx_modelyr label "模型年".
         
	 define variable l_col as char format "x(184)"   no-undo.
	 define variable shipfrom like scx_shipfrom label "货物发自" no-undo.	
	 define variable shipto like scx_shipto label "货物发往" no-undo.	 
	 define variable pnbr like po_nbr label "采购单" no-undo.
	 define variable custref like scx_custref label "客户参考号" no-undo.
	 define variable rlse_id like sch_rlse_id label "版本 ID" no-undo.
	 define variable pre_date like sch_pcs_date no-undo.
	 define variable iss_date like sch_eff_start no-undo.
	 define variable end_date like sch_eff_end no-undo.
         define variable first_date as date no-undo.
         define variable l_desc1 like pt_desc1 no-undo.
         define variable l_type as char format "x(1)" no-undo.
	 define variable l_date as date no-undo.
	 define variable l_qty as decimal format "->>>>>>>>9" no-undo.
	 	 
         define variable i as integer format ">9".
	 define variable j like i.
	 define variable error_file as char format "x(24)" no-undo.
	 define variable cppart like pt_part label "零件号" no-undo.
	 define variable del_yn like mfc_logical no-undo.
	 define variable add_yn like mfc_logical no-undo.

	 define temp-table temp1
		field t1_col1 as char format "x(184)" 
		field t1_ln as integer format ">9".

         define variable quote as char initial '"' no-undo.
	 define variable discr_qty like schd_discr_qty  no-undo.

form
   nbr                 colon 15     skip
   rcpdate             colon 15
   rcpdate1            label {t001.i} colon 50 skip
   firstplan            colon 30  label  "订单的首月计划"
   skip     
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/*修改global_domain*******/

         mainloop:
         repeat:
   if nbr1 = hi_char then nbr1 = "".
   if rcpdate = low_date then rcpdate = ?.
   if rcpdate1 = hi_date then rcpdate1 = ?.
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".

 update nbr rcpdate rcpdate1
           firstplan      
   with frame a.

    
      if nbr1 = "" then nbr1 = hi_char.
      if rcpdate = ? then rcpdate = low_date.
      if rcpdate1 = ? then rcpdate1 = hi_date.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.

    outfile = "/home/temp/" + string(global_domain)  + string(year(today))  + string(month(today))  + string(day(today))  + string(time) + "m.txt".
    errfile = "/home/temp/" + string(global_domain)  + string(year(today))  + string(month(today))  + string(day(today))  + string(time) + "me.prn".
    process1 = no.
    poderr   = no.
    soderr   = no.
    process1 = no.

for each sod_det no-lock where sod_det.sod_domain = global_domain 
      and sod_nbr = nbr,
       each so_mstr  no-lock where so_mstr.so_domain = global_domain 
       and  so_nbr = sod_nbr  and so_cust = cust break by sod_site by sod_nbr by sod_line:

       find first cp_mstr no-lock where cp_mstr.cp_domain = global_domain and cp_cust = so_cust and 
	    cp_part = sod_part no-error.
       
       if not available cp_mstr then do: message  sod_part "对应的客户零件号没有维护! 请核对!" view-as alert-box.
                                        poderr = yes.
                                    end.
        else do:
             find first  pod_det no-lock where pod_det.pod_domain = "TS" and pod_nbr = sod_contr_id and pod_part = cp_cust_partd
                  no-error.
             if not available pod_det then do: message "在TS数据库中找不到对应的采购单, 请检查数据!!" view-as alert-box.
                                        poderr = yes.
                                    end.
       end.  /*else do: */
end. /*for each sod_det ********/
if poderr then undo, retry.

 OUTPUT TO VALUE(outfile).
/*产生月度交货计划文本文件*/
do transaction :

  for each sod_det no-lock where sod_det.sod_domain = global_domain 
      and sod_nbr = nbr,
       each so_mstr  no-lock where so_mstr.so_domain = global_domain 
       and  so_nbr = sod_nbr  break by sod_site by sod_nbr by sod_line:

       find first cp_mstr no-lock where cp_mstr.cp_domain = global_domain and cp_cust = so_cust and 
	    cp_part = sod_part no-error.
       
       if not available cp_mstr then do: message  sod_part "对应的客户零件号没有维护! 请核对!" view-as alert-box.
                                        poderr = yes.
					leave .
                                    end.
        else do:
          find first  pod_det no-lock where pod_det.pod_domain = "TS" and pod_nbr = sod_contr_id and pod_part = cp_cust_partd 
                   no-error.
          if not available pod_det then do: message "在TS数据库中找不到对应的采购单, 请检查数据!!" view-as alert-box.
                                        poderr = yes.
                                        leave .
                                    end.
      end.  /*else do: */

   find first  sch_mstr where  sch_domain = "ts"  and sch_type = 4
   and sch_nbr = pod_nbr and sch_line = pod_line
   and sch_rlse_id = pod_curr_rlse_id[1]
   no-lock no-error.

for each schd_det no-lock
   where  schd_domain = "ts" and schd_type = 4
   and schd_nbr = sch_nbr
   and schd_line = sch_line
   and schd_rlse_id = sch_rlse_id
   and schd_date >= rcpdate and schd_date <= rcpdate1 
   break by schd_nbr by schd_line by schd_date:
   
   if first-of(schd_date) then discr_qty = 0.

/*输入头栏**/
 if first-of(schd_line) then do:
     put UNFORMATTED  " - - - - - - "  quote sod_nbr quote  space   quote sod_line quote space  skip .
     put  UNFORMATTED    quote string(year(today))  + string(month(today))  + string(day(today))  + string(time)  quote  skip .
      If Not firstplan Then  Put  UNFORMATTED  quote "Y" quote space  skip .
     put  UNFORMATTED quote "N" quote space  "  - -  -  -  -  "  .
     If  firstplan Then  Put  UNFORMATTed   rcpdate space   .
                   else  put  " - "  .   
     put "- - " skip .
     put " . "  skip .
 end.
 

     discr_qty = discr_qty + schd_discr_qty .
    /*** 输出明细3 **/

     if last-of(schd_date) then do:
        put  UNFORMATTED schd_date   " -  - -  " skip .
	put  UNFORMATTED quote   discr_qty quote space   quote "F" quote space   " - - " skip .
     end.


    if last-of(schd_line) then do:
       put  UNFORMATTED "." skip.
       put UNFORMATTED  "-" skip.
       put UNFORMATTED quote "Y" quote space skip .
       process1 = yes.
    end.


   end. /*for each schd_det *****************/
 


end. /*for each sod_det ***************************/
output  close .

end.  /*do transsction*/


if not poderr  then do:
               if process1 then 
               DO TRANSACTION ON ERROR UNDO,RETRY:
                  batchrun = YES.
                  INPUT FROM VALUE (outfile).
                  output to  value (errfile) .

                  {gprun.i ""rcpsmt.p""}


                  INPUT CLOSE.
  	          output close.
               END.  /** do transaction ***/



            message "月度供货计划已导入已完成!" view-as alert-box.


end. /*if not poderr and not soderr then do: */

         end.
	 
