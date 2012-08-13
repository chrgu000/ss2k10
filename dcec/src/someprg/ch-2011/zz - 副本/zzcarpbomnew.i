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
	
	for each usrw_wkfl no-lock where usrw_key1 = nbr
	and usrw_key3 = "ORDER-TEST-DET":

		assign
		level = 1
		comp = usrw_key2
		maxlevel = min(maxlevel,99).
		
		if site = "DCEC-B" then
			comp = usrw_key2 + "ZZ".

                date1 = usrw_datefld[1].

       {gprun.i ""zzbmpkiqbnew.p"" "(input comp,
                               INPUT site,
                               INPUT TODAY,
                               INPUT date1)"}
         for each pkdet BREAK BY pkpart BY pkdate1 :
              find pt_mstr where pt_part = pkpart no-lock no-error.
				find ptp_det where ptp_site = site  and ptp_part = pkpart  no-lock no-error.
		
				if available pt_mstr 
	/*				((available ptp_det and not ptp_phantom)
				or
				(not available ptp_det and not pt_phantom)) then do:
				 */ then do:
				 
                                     
					find first xxwk where xxpart = pkpart AND xxdate1 = pkdate1 no-error.
					if not available xxwk then do:
						
						if (available ptp_det and ptp_pm_code = "P")
						or (not available ptp_det and pt_pm_code = "P") then do:
							create xxwk.
							assign 
								xxpart = pkpart
								xxdesc1 = pt_desc2
								xxum  = pt_um
								xxqtytest = xxqtytest + pkqty  * usrw_decfld[1].
   /*phi*/                      xxpar = usrw_key2 .
                                xxdate1 = pkdate1.
							/*	xxwk.st	 = ps__chr01.  site*/
						end.
					end.
				    ELSE DO:
                       IF LOOKUP (usrw_key2,xxpar) = 0 THEN
   /*phi*/                           xxpar = xxpar + "," + usrw_key2 .
						xxqtytest = xxqtytest + pkqty * usrw_decfld[1].
                         END.
				end.

           end. 

 
	end. /*each usew_wkfl */
	
