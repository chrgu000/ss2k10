     /*取得基本货币B*/
     find first gl_ctrl no-lock no-error.
     If AVAILABLE (gl_ctrl) then assign glbasecurr = gl_base_curr.    
      
      /*取得LOC B*/
     tmp_loc = "".
     find first pt_mstr where pt_part = tmp_part no-lock no-error.
     tmp_loc = if avail pt_mstr then pt_loc else "".


     /*判断是否固定汇率* B*/
     find first pomst where pomst.po_nbr = tmp_ponbr 
                        and pomst.po_vend = xx_inv_vend no-lock no-error.
     if avail pomst then do:
        tmp_fix_rate = if pomst.po_fix_rate = yes then "Y" else "N".
     end.                                                       
     
     /*取得ERP 图号 B 据供应商，供应商图号*/
     tmp_part = "".
     FIND FIRST vp_mstr WHERE xx_inv_vend = vp_vend 
                          AND xx_ship_part = vp_vend_part NO-LOCK NO-ERROR.
     IF AVAIL vp_mstr THEN tmp_part = vp_part .

     /*取得项次* B*/
     find LAST podde where podde.pod_nbr = tmp_ponbr 
                        and podde.pod_part = tmp_part 
                        and podde.pod_status = "" 
                        and podde.pod_site = xx_inv_site 
                        and podde.pod_qty_ord > podde.pod_qty_rcvd no-lock no-error.
     if avail podde then assign tmp_line =podde.pod_line.
 
     usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "por3" .
     output to value( trim(usection) + ".i") .
      PUT  UNFORMATTED   trim ( tmp_ponbr )  format "x(50)"  skip .

      PUT  UNFORMATTED   xx_ship_no + " - " + string(rcvddate) +  " N N N " format "x(50)" skip .
      /* 判断采购币与本位币是否相同，是否固定汇率*/
      If xx_inv_curr <> glbasecurr AND tmp_fix_rate  = "N" then 
      put UNFORMATTED skip(1) .  
      PUT  UNFORMATTED trim ( string(tmp_line) )  format "x(50)" skip .
      PUT  UNFORMATTED trim ( string((xx_ship_qty - xx_ship_rcvd_qty) ) ) + " - N - - - " + trim (xx_inv_site) + " " +  trim( tmp_loc ) + " " + """" + trim(tmp_lot) + """" + " - - N N N "   format "X(50)"   skip.
      PUT  UNFORMATTED "." skip .
      PUT  UNFORMATTED "Y" skip .
      PUT  UNFORMATTED "Y" skip .
      PUT  UNFORMATTED "." .
     output close.

     input from value ( usection + ".i") .
     output to  value ( usection + ".o") .
     batchrun = yes. 
     {gprun.i ""poporc.p""}
	 batchrun = no. 
     input close.
     output close.     

	/*收完货后回写客户货表B*/
	V9000="0".
	find last tr_hist where tr_trnbr >= 0 no-lock no-error.
	If AVAILABLE ( tr_hist ) THEN V9000 = string(tr_trnbr).

	find last tr_hist where tr_date = today  
                        and tr_trnbr >= integer ( V9000 ) 
                        and tr_nbr = trim(tmp_ponbr)     
                        and tr_type = "RCT-PO"  
                        and tr_site = trim(xx_inv_site) 
                        and tr_part = trim(tmp_part) 
                        and tr_serial = trim(tmp_lot)  
                        and tr_time  + 15 >= TIME  
                        and tr_qty_chg = (xx_ship_qty - xx_ship_rcvd_qty)
                        AND tr_line = tmp_line
	                    use-index tr_date_trn no-lock no-error.
	If AVAILABLE ( tr_hist ) then do:
        /*
        MESSAGE "tr_hist 1. " + STRING(tmp_qty) VIEW-AS ALERT-BOX.
          */
        assign 	
            xx_ship_rcvd_qty = xx_ship_rcvd_qty + (xx_ship_qty - xx_ship_rcvd_qty)
            xx_ship_rcvd_date = rcvddate.
	                
        if xx_ship_rcvd_qty >= xx_ship_qty then xx_ship_status = 'close'. 
	end.
 
    errstr="".
	ciminputfile = usection + ".i".
    cimoutputfile = usection + ".o".
    {xserrlg5.i}

        /*
	if errstr = "" then do:
          unix silent value ( "rm -f "  + Trim(usection) + ".i").
          unix silent value ( "rm -f "  + Trim(usection) + ".o").
    end.
    */
