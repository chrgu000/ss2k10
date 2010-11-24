/* By: Neil Gao Date: 07/05/10 ECO: * ss 20070510.1 * */
/*-Revision end---------------------------------------------------------------*/


     /* DISPLAY TITLE */
     {mfdeclre.i}

     define input parameter inpcomp like ps_comp.
     define input parameter inpdate as date.
     define input parameter inpsite like in_site.
     
     define shared workfile pkdet no-undo
    		field pkpart like ps_comp
    		field pkop as integer  format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
		    field pkbombatch like bom_batch
        field pkltoff like ps_lt_off.

     define new shared variable comp like ps_comp.
	 	 define new shared variable eff_date as date.
		 define new shared variable site like in_site no-undo.
		 define new shared variable phantom like mfc_logical initial yes.

		 {gpxpld01.i "new shared"}
		 
     comp = inpcomp.
     eff_date = inpdate.
     site = inpsite.

     {gprun.i ""woworla2.p""}

/*
        for each pkdet 
        where eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
		    and (pkend = ? or eff_date <= pkend)
        break by pkpart :
					
					disp pkdet.
					
        end.
*/