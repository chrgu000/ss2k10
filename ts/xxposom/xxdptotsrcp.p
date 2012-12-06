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

form
   nbr                  colon 15     skip
   rcpdate             colon 15
   rcpdate1            label {t001.i} colon 50 skip
   cust           colon 15
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
      cust 
      
   with frame a.

    
      if nbr1 = "" then nbr1 = hi_char.
      if rcpdate = ? then rcpdate = low_date.
      if rcpdate1 = ? then rcpdate1 = hi_date.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.

    outfile = "/home/pur/" + string(global_domain)  + string(year(today))  + string(month(today))  + string(day(today))  + string(time) + "m.txt".
    errfile = "/home/pur/" + string(global_domain)  + string(year(today))  + string(month(today))  + string(day(today))  + string(time) + "me.prn".
    process1 = no.
    poderr   = no.
    soderr   = no.
    process1 = no.

 OUTPUT TO VALUE(outfile).
/*产生预开票文本文件*/
do transaction :
  for each sod_det no-lock where sod_det.sod_domain = global_domain 
      and sod_nbr = nbr,
       each so_mstr  no-lock where so_mstr.so_domain = global_domain 
       and  so_nbr = sod_nbr  and so_cust = cust break by sod_site by sod_nbr by sod_line:


       find first  pod_det no-lock where pod_det.pod_domain = "TS" and pod_nbr = custnbr and pod_part = sod_part  
       and pod_start <= rcpdate and (pod_due_date <= rcpdate1 or pod_due_date = ? ) no-lock no-error.
      if not available pod_det then do: message "在TS数据库中找不到对应的采购单, 请检查数据!!" view-as alert-box.
                                        poderr = yes.
                                        leave .
                                    end.

    for  each pod_det no-lock
      where pod_det.pod_domain = "TS"  and pod_nbr = custnbr and pod_part = sod_part 
       and pod_start <= rcpdate and (pod_due_date <= rcpdate1 or pod_due_date = ? ),
      each po_mstr no-lock
      where po_domain = "TS" and po_nbr = pod_nbr,
      each pt_mstr no-lock
      where pt_domain = "TS"  and pt_part = pod_part:


   find first  sch_mstr where  sch_domain = global_domain and sch_type = 4
   and sch_nbr = pod_nbr and sch_line = pod_line
   and sch_rlse_id = pod_curr_rlse_id[1]
   no-lock no-error.
   

for each schd_det no-lock
   where  schd_domain = global_domain and schd_type = 4
   and schd_nbr = sch_nbr
   and schd_line = sch_line
   and schd_interval = "d"
   and schd_rlse_id = sch_rlse_id
   and schd_date >= rcpdate and schd_date <= rcpdate1 break by schd_date:
   if first-of(schd_date) then do:
      discr_qty = 0.
   end.
   discr_date = discr_date + schd_discr_qty .

   if last-of(schd_date) then put  schd_date 
    
   end. /*for each schd_det *****************/

end.  /*for each pod_det **********************/
 
      if last-of(sod_line) then  do:

      end.
end. /*for each sod_det ***************************/

      process1 = yes.

        if first-of(prh_ps_nbr) then  do:
                    put UNFORMATTED quote pod_nbr       quote skip.
                    if prh_ps_nbr <> "" then       put UNFORMATTED quote  prh_ps_nbr   quote .
	                   else put UNFORMATTED    "-"   space   .
                    put  UNFORMATTED      prh_rcp_date     space        .
		    put  UNFORMATTED 	"-"   space                
                                        "-"   space
                                        "-"   space
			                "-"   space  skip .
			.
 		   end.  /*if first-of(sod_nbr)*/

                  PUT UNFORMATTED
                         quote pod_line     quote space  
                         quote  prh_qty_rcvd  quote space
                        "-"  space  "-"  space "-"  space "-"  
			space "-"  space "-"  space "-"  space "-"  
			space "-"  space  quote prh_receiver quote space   skip.
.
  	         prh__log01 = yes.

                 if last-of(prh_ps_nbr) then  do:
                    PUT UNFORMATTED
			"_"                         space  skip
			"-"                         space  skip
			"-"                         space  skip
			"-"                         space  skip  .
                 put unformatted  "."               space skip. /*程序退出*/
                 end.  /*if last-of(sod_nbr) **************/         
          end. /*for each so_mstr *******/
	if   poderr = yes then  do: undo,  leave .   end.
 end .  /*do transaction */
               OUTPUT CLOSE.

/*产生销售发货文本*/
if not poderr then do:
 OUTPUT TO VALUE(outfile1).
 do transaction :
  for each prh_hist  where prh_hist.prh_domain = global_domain 
      and prh_rcp_date >= rcpdate and prh_rcp_date <= rcpdate1
      and (prh_nbr >= nbr) and (prh_nbr <= nbr1)
      and (prh_cust >= cust and prh_cust <= cust1),
      each po_mstr where po_mstr.po_domain = global_domain 
      and  po_nbr = prh_nbr :
      break by prh_nbr by prh_rcp_date by prh_ps_nbr :
      find first sod_det where  sod_domin = "ts" and sod_nbr = po_contract and sod_part = prh_part no-error.
      if not available sod_det then do: soderr = yes.
                                        leave .
                                    end.
		    process2 = yes.

        if first-of(prh_ps_nbr) then  do:
                    put UNFORMATTED quote sod_nbr       quote .
                    put  UNFORMATTED      prh_rcp_date     space         .
		    put  UNFORMATTED 	"-"   space                
                                        "-"   space
			                "-"   space  skip .
			.
 		   end.  /*if first-of(sod_nbr)*/

                  PUT UNFORMATTED
                         quote sod_line     quote space   skip
                         quote  prh_qty_rcvd  quote space
                        "-"  space  "-"  space "-"  space "-"  
			  skip.  
			
                       prh__log02 = yes.
                 if last-of(sod_nbr) then  do:
                    PUT UNFORMATTED
			"_"                         space  skip
			"-"                         space  skip
			"-"                         space  skip
			"-"                         space  skip
			"-"                         space  skip  .
                 put unformatted  "."               space  skip. /*程序退出*/
                 end.  /*if last-of(sod_nbr) **************/         
          end. /*for each so_mstr *******/
	  if soderr then do: undo, leave . end.
    end.
               OUTPUT CLOSE.
end.  /*if not poderr then do:********/

if not poderr and not soderr then do:

               if process1 then 
               DO TRANSACTION ON ERROR UNDO,RETRY:
                  batchrun = YES.
                  INPUT FROM VALUE (outfile).
                  output to  value (errfile) .

                  {gprun.i ""poporc.p""}


                  INPUT CLOSE.
  	          output close.
               END.  /** do transaction ***/

  if process1 then 
               DO TRANSACTION ON ERROR UNDO,RETRY:
                  batchrun = YES.
                  INPUT FROM VALUE (outfile1).
                  output to  value (errfile1) .

                  {gprun.i ""sosois.p""}


                  INPUT CLOSE.
  	          output close.
               END.  /** do transaction ***/
end.

            message "已发货未开票数量回填已完成!" view-as alert-box.


end. /*if not poderr and not soderr then do: */

         end.
	 
