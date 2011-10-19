/*----rev history-------------------------------------------------------------------------------------*/
/*原版{mfdtitle.i "2+ "}*/
/* SS - 110307.1  By: Roger Xiao */ /* vp_mstr 区分保税非保税,vp_part : P,M开头区分 */
/*-Revision end---------------------------------------------------------------*/

     
find first gl_ctrl no-lock no-error.
If AVAILABLE (gl_ctrl) then assign glbasecurr = gl_base_curr.    

if pod_det.pod_part begins "P" then do:
	 assign tmp_loc = "PT".
end.
else do:
	 find first code_mstr no-lock where code_fldname = "xxpocima.p" 
	 			  and code_value = "DefRcLoc" no-error.
	 if available code_mstr then do:
	 		assign tmp_loc = code_cmmt.
	 end.
end.

tmp_fix_rate = if po_mstr.po_fix_rate = yes then "Y" else "N".
usection = "porc" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100)))  .

output to value( trim(usection) + ".i") .
      PUT  UNFORMATTED   trim ( po_mstr.po_nbr )  format "x(50)"  skip .

      PUT  UNFORMATTED   xxship_nbr + " - " + string(rcvddate) +  " N N N " format "x(50)" skip .
      /* 判断采购币与本位币是否相同，是否固定汇率*/
      If po_curr <> glbasecurr AND tmp_fix_rate  = "N" then PUT UNFORMATTED " - " SKIP.  
      PUT  UNFORMATTED trim ( string(pod_det.pod_line) )  format "x(50)" skip .
      PUT  UNFORMATTED trim ( string(v_qty_rct) ) + " - N - - - " + trim (xxinv_site) + " " +  trim( tmp_loc ) + " " + """" + trim(tmp_lot) + """" + " - - N N N "   format "X(50)"   skip.
      PUT  UNFORMATTED "." skip .
      PUT  UNFORMATTED "Y" skip .
      PUT  UNFORMATTED "Y" skip .
      PUT  UNFORMATTED "." .
output close.


for each vv : delete vv . end .
on create of tr_hist do:
    find first vv where vv_rec = recid(tr_hist) no-lock no-error.
    if not available vv then do:
        create vv. vv_rec = recid(tr_hist).
    end.
end.


input from value ( usection + ".i") .
output to  value ( usection + ".o") .
    batchrun = yes. 
    {gprun.i ""poporc.p""}
    batchrun = no. 
input close.
output close.     

errstr = "".
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
{xserrlg5.i}

/**/
if errstr = "" then do:
    unix silent value ( "rm -f "  + Trim(usection) + ".i").
    unix silent value ( "rm -f "  + Trim(usection) + ".o").
end.  

for each vv:
	find tr_hist where recid(tr_hist) = vv_rec no-error .
	if avail tr_hist
        and tr_nbr     = trim(po_mstr.po_nbr)     
        and tr_line    = pod_det.pod_line
        and tr_type    = "rct-po"  
        and tr_part    = trim(pod_det.pod_part)  
        and tr_site    = trim(xxinv_site)    
        and tr_loc     = trim(tmp_loc )
        and tr_serial  = trim(tmp_lot)   
        and tr_qty_chg = v_qty_rct 
    then do:

        assign 
            xxship_rcvd_qty     = xxship_rcvd_qty + v_qty_rct   
            xxship_rcvd_effdate = rcvddate  
            xxship_rcvd_date    = v_rctdate   
            xxship_rcvd_loc     = ""  /*在条码打印时分配*/
            .
        if xxship_rcvd_qty >= xxship_qty then xxship_status = 'RCT-PO'.   /*xxship_status 可以等于:收货OK'RCT-PO',转仓OK'RCT-TR',未收货留空 */      
	end.
end.  /*for each vv*/ 

 
    
