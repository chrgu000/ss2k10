/*zzcarpbom.i for 合同评审报表计算	BOM展开											*/

/*LAST MODIFIED BY *LB01*             LONG BO   2004-7-14                            
  LAST MODIFIED BY *phi*              Philips Li 2008-4-11
------------------------------------------------------------------------------------*/
	
define NEW shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as integer
                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
        field pkbombatch like bom_batch
        field pkltoff like ps_lt_off
        FIELD pkdate1 LIKE pk_start.
define new shared variable transtype as character format "x(4)".
define new shared variable errmsg as integer .
transtype = "BM" . 

	for each xxwk:
		delete xxwk.
	end.

	FOR EACH pkdet:
        DELETE pkdet.
        END.
	
	for each yyusrw_wkfl no-lock where yyusrw_domain = global_domain 
			 and yyusrw_key1 = nbr 
	     and yyusrw_key3 = "ORDER-TEST-DET" BREAK by yyusrw_key2 by yyusrw_datefld[1]:

         if first-of(yyusrw_key2) then do:
		assign
		level = 1
		comp = yyusrw_key2
		maxlevel = min(maxlevel,99).
		
		if site = "DCEC-B" then
			comp = yyusrw_key2 + "ZZ".

                date1 = yyusrw_datefld[1].

       {gprun.i ""zzbmpkiqbnew.p"" "(input comp,
                               INPUT site,
                               INPUT TODAY,
                               INPUT date1)"}
           end.


         for each pkdet BREAK BY pkpart BY pkdate1 :
              message yyusrw_key2 yyusrw_datefld[1] pkpart pkdate1.  
              find pt_mstr where pt_domain = global_domain and pt_part = pkpart no-lock no-error.
				find ptp_det where ptp_domain = global_domain and  ptp_site = site  and ptp_part = pkpart  no-lock no-error.
		
				if available pt_mstr 
	/*				((available ptp_det and not ptp_phantom)
				or
				(not available ptp_det and not pt_phantom)) then do:
				 */ then do:
				 
                                     
					find first xxwk where xxpart = pkpart AND xxdate1 = yyusrw_datefld[1] no-error.
					if not available xxwk then do:
						
						if (available ptp_det and ptp_pm_code = "P")
						or (not available ptp_det and pt_pm_code = "P") then do:
							create xxwk.
							assign 
								xxpart = pkpart
								xxdesc1 = pt_desc2
								xxum  = pt_um
								xxqtytest = xxqtytest + pkqty  * yyusrw_decfld[1].
   /*phi*/                      xxpar = yyusrw_key2 .
                                xxdate1 = yyusrw_datefld[1].
							/*	xxwk.st	 = ps__chr01.  site*/
						end.
					end.
				    ELSE DO:
                       IF LOOKUP (yyusrw_key2,xxpar) = 0 THEN
   /*phi*/                           xxpar = xxpar + "," + yyusrw_key2 .
						xxqtytest = xxqtytest + pkqty * yyusrw_decfld[1].
                         END.
				end.

           end. 

 
	end. /*each usew_wkfl */


