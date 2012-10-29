/* $Revision: eb21sp3 $ BY: Jordan Lin  DATE: 06/28/12 ECO: *ss - 20120628.1 */
/* $Revision: eB21SP3 $  BY: Jordan Lin       DATE: 07/16/12  ECO: *SS-20120716.1* */


{mfdeclre.i }





define   variable usection as char format "x(36)" .  
define shared  variable errstr as char no-undo .
define   variable ciminputfile   as char .
define   variable cimoutputfile  as char .
define   variable c  as char .
define   variable c2  as char .



DEFINE shared TEMP-TABLE tmp_det no-undo
    FIELD tmp_req_nbr LIKE drp_req_nbr   /*申请号*/
    FIELD tmp_nbr LIKE dss_nbr
    FIELD tmp_part LIKE ds_part            /*零件号*/
    FIELD tmp_qty_ord LIKE ds_qty_ord      /*数量*/
    FIELD tmp_req_date LIKE dss_due_date  /*需求日*/
    FIELD tmp_due_date LIKE dss_due_date   /*截止日*/
    FIELD tmp_rec_site LIKE dss_rec_site   /*需求地*/
    FIELD tmp_shipsite LIKE dss_shipsite   /*发运地*/
    FIELD tmp_trloc LIKE pt_loc           /*在途库位*/
    FIELD tmp_xls_line LIKE drp_req_nbr   /*excel行号*/  
    FIELD tmp_err as char                    /*导入报错*/  
     index tmp_index is primary tmp_req_nbr .

loadloop:
   do  on error undo, LEAVE :


        errstr = "".
	usection = TRIM ("c:\upload.in") .
	output to value( trim(usection) ) .

       for each tmp_det no-lock BREAK by tmp_nbr by tmp_req_nbr :
            if FIRST(tmp_nbr) then do:
               	put trim(tmp_nbr) + " " +  trim(tmp_shipsite)  FORMAT "x(50)" skip.
		put trim(tmp_rec_site) FORMAT "x(50)" skip.
		put trim(string(tmp_req_date)) + " "+ trim(string(tmp_req_date)) + " "+ trim(string(tmp_due_date)) + " ok " FORMAT "x(50)" skip.
	    end.
            put string(tmp_req_nbr) FORMAT "x(50)" skip.
            put trim(tmp_part) FORMAT "x(50)"  skip.
            put string(tmp_qty_ord) FORMAT "x(50)"  skip.
            put "- - - " + trim(tmp_trloc) FORMAT "x(100)"  skip.
            put "-"  skip.
            
	    if last(tmp_nbr) then do:
                put "." skip.
		put "." skip.
	    end.
       end.

	output close.

	input from value ( usection ) .
	output to  value ( "c:/upload.in.out") .
        batchrun = yes. 
		{gprun.i ""dsdomt.p""}
        batchrun = no.  
	input close.
	output close.

	ciminputfile = usection .
	cimoutputfile = "c:/upload.in.out".
	{yyinputdrp_err.i}

        if errstr <> "" then do:
	  message  errstr .          
	  undo loadloop.
        end.


   end.

