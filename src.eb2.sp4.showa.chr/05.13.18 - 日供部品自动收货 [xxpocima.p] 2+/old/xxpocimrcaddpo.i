     /*取得ERP 图号 B 据供应商，供应商图号*/
     tmp_part = "".
     FIND FIRST vp_mstr WHERE xx_inv_vend = vp_vend AND xx_ship_part = vp_vend_part NO-LOCK NO-ERROR.
     IF AVAIL vp_mstr THEN tmp_part = vp_part .
     
     find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
     IF AVAIL vd_mstr THEN curr = vd_curr .

     /*生成PO B */
     usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "por3" .
     output to value( trim(usection) + ".i") .
	   PUT UNFORMATTED tmp_ponbr skip.
	   PUT UNFORMATTED xx_inv_vend skip.

	   PUT UNFORMATTED " - " skip.
	   do i = 1 to 11:
	    put UNFORMATTED "- ".
	   end.
	   PUT UNFORMATTED xx_inv_site skip.

       if curr <> "rmb" then do:
	      PUT UNFORMATTED  " - " skip.
	   end.

       /*
       FIND FIRST ad_mstr WHERE ad_addr = xx_inv_vend AND ad_taxable = YES NO-LOCK NO-ERROR.
       IF AVAIL ad_mstr THEN PUT UNFORMATTED " - " SKIP.
         */

       PUT UNFORMATTED " - " skip.          /* 税 */
	   PUT UNFORMATTED " - " skip.          /* 项次 */   
	   PUT UNFORMATTED xx_inv_site skip.    /* 地点 */
	   put UNFORMATTED " - " skip.
	   put UNFORMATTED tmp_part skip.
	   put UNFORMATTED string(xx_ship_qty - xx_ship_rcvd_qty - tmp_order_qty)  skip.
        /* 汇率问题要等财务AP模块上线后才确定 */
       /*
	   put UNFORMATTED tmp_cost skip.
       */
       put UNFORMATTED " - " skip.
	   put UNFORMATTED " - " skip.

       /*
       FIND FIRST pt_mstr WHERE pt_part = tmp_part AND pt_taxable = YES NO-LOCK NO-ERROR.
       IF AVAIL pt_mstr THEN PUT UNFORMATTED " - " SKIP.
         */

       put "." skip.
	   put "." skip.
	   put " - " skip.
	   put " - " skip.   
	   put "." skip.   
      output close.

      input from value ( usection + ".i") .
      output to  value ( usection + ".o") .
      batchrun = yes. 
      {gprun.i ""popomt.p""}
	  batchrun = no. 
      input close.
      output close.

      errstr="".
	  ciminputfile = usection + ".i".
      cimoutputfile = usection + ".o".
      {xserrlg5.i}

	/*if errstr = "" then do:
          unix silent value ( "rm -f "  + Trim(usection) + ".i").
          unix silent value ( "rm -f "  + Trim(usection) + ".o").
      end.*/


 
