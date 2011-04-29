/* Creation: eB2SP11.Chui   Modified: ??    By: Davild??    *????* */
/* Revision: eB2SP11.Chui   Modified: 08/15/06      By: Kaine Zhang     *ss-20060815.1* */
/* Revision: eB2SP11.Chui   Modified: 08/17/06      By: Kaine Zhang     *ss-20060817.1* */
/* Revision: eB2SP11.Chui   Modified: 08/23/06      By: Kaine Zhang     *ss-20060823.1* */
/* Revision: eB2SP11.Chui   Modified: 08/30/06      By: Kaine Zhang     *ss-20060830.1* */
/* Revision: eB2SP11.Chui   Modified: 09/18/06      By: Kaine Zhang     *ss - 20060918.1* */
/* Revision: eB2SP11.Chui   Modified: 10/11/06      By: Kaine Zhang     *ss - 20061011.1* */
/* Revision: eB2SP11.Chui   Modified: 11/14/06      By: Kaine Zhang     *ss - 20061114.1* */
/* Revision: eB2SP11.Chui   Modified: 09/23/2008   By: Kaine Zhang     Eco: *ss_20080923* */


/* *ss_20080923* All sales order must have same shipto address. */
/*ss - 20061114.1* repeat invoice number */
/*ss - 20061011.1*  tmp_so_qty(link.xxshd_so_qty)'s DEFAULT VALUE change.  */
/*ss - 20060918.1*  IF invice belongs TO "CS", THEN dose NOT CHECK terms.  */
/*ss-20060817.1*  Lock the co.cp TYPE record that have shipment  */
/*ss-20060815.1*  ADD shipment amount IN mstr TABLE  */
/*mage */ define variable preship like abs_id  . 

/*mage */ define variable  xxcust  like so_cust  . 
/*mage */ define variable  xxpart1  like sod_part  . 
/*mage */ define variable  xxpart2  like sod_part  . 

/*mage */ define variable xsonbr1  like so_nbr  . 
/*mage */ define variable xsonbr2  like so_nbr  . 

/*********************************************************
/*mage */ define variable xsonbr3  like so_nbr  . 
/*mage */ define variable xsonbr4  like so_nbr  . 
/*mage */ define variable xsonbr5  like so_nbr  . 
/*mage */ define variable xsonbr6  like so_nbr  . 
/*mage */ define variable xsonbr7  like so_nbr  . 
/*mage */ define variable xsonbr9  like so_nbr  . 
/*mage */ define variable xsonbr10  like so_nbr  . 
/*mage */ define variable xsonbr11  like so_nbr  . 
/*mage */ define variable xsonbr12  like so_nbr  . 
/*mage */ define variable xsonbr13  like so_nbr  . 
/*mage */ define variable xsonbr14  like so_nbr  . 
/*mage */ define variable xsonbr15  like so_nbr  . 
/*mage */ define variable xsonbr16  like so_nbr  . 
*******************************************************************/

{mfdtitle.i "2+ "}
{xxshdefinex.i "new" }
{xxshformx.i}
define variable del-yn like mfc_logical initial no. /*sam Song Add  Delete Function */

/* *ss_20080923* */  define variable strShipTo like so_ship no-undo.
procedure cutdot:
    DEF INPUT-OUTPUT PARAM pro_integer AS char.
    DEF VAR ii AS INTE.
    DEF VAR tmpchar AS CHAR INIT "".
    assign pro_integer = trim(pro_integer) .
    repeat:
		ii = INDEX(pro_integer,".0") .
	    IF ii <> 0  THEN DO:
		assign tmpchar = substring(pro_integer,1, ii - 1) + substr(pro_integer,ii + 2, length(pro_integer) - ii - 1) .
		assign pro_integer = tmpchar. 
	    END.
	    else do: 		
		leave .  
	    end.
    End.
end procedure.


VIEW FRAME a .

main-loop:
REPEAT :
    hide all no-pause .
    view frame dtitle .
    
    UPDATE invcode  		     
    WITH FRAME a EDITING:
        READKEY.
        APPLY LASTKEY .
    END.
    
    RUN getcodemstr(INPUT "shipmentinvoiceno",INPUT invcode,INPUT "N" , OUTPUT tmpinvno) .
    IF tmpinvno = "" THEN DO:
        {pxmsg.i &MSGNUM=9000 &ERRORLEVEL=3}   /*input error CS CO CP*/
        NEXT main-loop .
    END.

    
    loop-invno:
    REPEAT:
    	MESSAGE "輸入空則產生新的發票號碼." .
    	
        UPDATE invno xxcust  xsonbr1  
		             xsonbr2  go-on(F5 CTRL-D) WITH FRAM a .
    	
    	if invno = "" then do:
            RUN getcodemstr(INPUT "shipmentinvoiceno",INPUT invcode,INPUT "Y" , OUTPUT tmpinvno) .

            ASSIGN invno = substring("00000000",1,((8 - length(trim(invcode))) - length(tmpinvno))) + tmpinvno + caps(invcode) .
            
            disp invno with frame a .
            
            FIND FIRST xxshm_mstr WHERE xxshm_inv_no = invno NO-ERROR.
            
            /*ss - 20061114.1*/   IF NOT AVAILABLE xxshm_mstr THEN DO:
                CREATE xxshm_mstr .
                ASSIGN xxshm_inv_no = invno .
            /*ss - 20061114.1*/   END.
    
    	end.
    	else do:
    
    		FIND FIRST xxshm_mstr WHERE xxshm_inv_no = invno NO-ERROR.
    		
    		/* ***********************ss-20060817.1 B Add********************** */
    		IF ((invno MATCHES "*co") OR (invno MATCHES "*cp"))
    		    AND (AVAILABLE xxshm_mstr)
    		THEN DO:
    		    IF CAN-FIND(FIRST xxshd_det WHERE (xxshd_inv_no = xxshm_inv_no) AND xxshd_log[2] NO-LOCK) THEN DO:
    		        MESSAGE "has shipment, please re-enter.".
    		        UNDO loop-invno, RETRY loop-invno.
    		    END.
            END.
            /* ***********************ss-20060817.1 E Add********************** */
    		
    		IF AVAIL xxshm_mstr THEN DO:

    		    /*Sam Song Add 20080811 - Delete Function */
                FIND FIRST xxshd_det WHERE xxshd_inv_no = invno and xxshd_log[2] = yes NO-ERROR.
                IF AVAIL xxshd_det then do:
                    message "THE SHIPPER ALREADY ISSUE ".
                END.
                ELSE DO:
                    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")  then do:
                       del-yn = yes.
                       {mfmsg01.i 11 1 del-yn}
                       if del-yn then do:
                          delete xxshm_mstr.
                          for each xxshd_det where xxshd_inv_no = invno :
                              delete xxshd_det.
                          end.
                          clear frame a.
                       end.
                    
                    end.
                END.
                /*Sam Song Add 20080811 - Delete Function  END */
                    
    		    {pxmsg.i &MSGNUM=9001 &ERRORLEVEL=1} /* "Modify exist Invoice Data!" .*/
    		END.
    		ELSE DO:
    		if substring (invno,7,2 ) <> invcode then do:
    		    undo,retry.
    		end.
    		    /*{pxmsg.i &MSGNUM=9002 &ERRORLEVEL=1}*/ /* "Add new Invoice Record !" .   */
    			message "ADD RECORDS." .
    		    CREATE xxshm_mstr .
    		    ASSIGN xxshm_inv_no = invno .
     
    		END.
    	end.
   /*mage add **********************************************************************************/
    
	   find first cm_mstr where cm_addr = xxcust no-lock no-error.	  
	   if not available cm_mstr then do:
                  message  "cust:"  xxcust " Is No Available  Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
 
    /*del *****************************************    
        if xsonbr1 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr1 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr1:"  xsonbr1 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/

        if xsonbr2 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr2 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr2:"  xsonbr2 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr3 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr3 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr3:"  xsonbr3 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr4 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr4 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr4:"  xsonbr4 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr5 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr5 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr5:"  xsonbr5 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/

        if xsonbr6 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr6 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr6:"  xsonbr6 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/

        if xsonbr7 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr7 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr7:"  xsonbr7 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr8 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr8 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr8:"  xsonbr8 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr9 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr9 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr9:"  xsonbr9 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr10 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr10 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr10:"  xsonbr10 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
	  
        if xsonbr11 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr11 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr11:"  xsonbr11 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr12 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr12 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr12:"  xsonbr12 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr13 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr13 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr13:"  xsonbr13 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
        if xsonbr14 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr14 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr14:"  xsonbr14 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
       if xsonbr15 <> ""   then do:
	   find first sod_det where sod_nbr = xsonbr15 no-lock no-error.	  
	   if not available sod_det then do:
                  message  "xsonbr15:"  xsonbr15 " Is No Available SO NBR, Retry!" view-as alert-box.
		  undo, retry .  
	    end.  
          end. /*if xsonbr1 <> ""   then do:*/
*del **************************************************************/

      if new xxshm_mstr then do:
	   
		
	   for each so_mstr where so_cust = xxcust and  (so_nbr >= xsonbr1 or xsonbr1 = "")  
	       and  (so_nbr <= xsonbr2        or   xsonbr2 = "" )    no-lock,    
	       each sod_det where sod_nbr = so_nbr 
	         and sod_qty_all > 0 no-lock :
		 xxshm_orderno = so_nbr.
 		find first tmp where tmp_so_nbr = sod_nbr and tmp_so_line = sod_line no-error.
		if avail tmp then tmp_so_qty = tmp_so_qty + sod_qty_all.
		    else do:
			create tmp.
			assign  tmp_sele = "Y"
				tmp_so_nbr = sod_nbr
				tmp_so_line = sod_line
				tmp_sort = 10
				tmp_so_part = sod_part
				tmp_so_qty  = sod_qty_all
				tmp_so_price = sod_price .

 			/*計算此項未結數量--BEGIN*/
			
			/* ********************ss - 20061011.1 B Del*******************
			 *  for each xxshd_det where xxshd_so_nbr = sod_nbr and xxshd_so_line = sod_line 
			 *  		and xxshd_inv_no <> invno no-lock:
			 *  	assign tmp_so_qty = tmp_so_qty - xxshd_so_qty .
			 *  end.
			 * ********************ss - 20061011.1 E Del*******************/
			
			/* ***********************ss - 20061011.1 B Add********************** */
			for each xxshd_det where xxshd_so_nbr = sod_nbr and xxshd_so_line = sod_line 
                            and xxshd_inv_no <> invno AND (NOT xxshd_inv_no MATCHES "*CS") no-lock:
				assign tmp_so_qty = tmp_so_qty - xxshd_so_qty .
			end.
			/* ***********************ss - 20061011.1 E Add********************** */
			
			/*計算此項未結數量--END*/
			
			
			/*計算卡通及卡板數及找座椅料號-BEGIN*/

			find first xxpt_mstr where xxpt_part = sod_part no-lock no-error.
			if avail xxpt_mstr then do:
				if xxpt_ct_pcs > 0 then 
					assign tmp_carton = tmp_so_qty / xxpt_ct_pcs .
				else	assign tmp_carton = 0 .
				run getinteger(input-output tmp_carton) .

				if tmp_carton = 0 then
					assign tmp_pallet = 0 .
				else do:
					if xxpt_pt_maxcheng = 0 or xxpt_pt_pcscheng = 0 or xxpt_ct_pcs = 0 then
						assign tmp_pallet = 0 .
					else	do:
                                                 /* pallet ji suan  --by ching 20060727--begin*/    
						 tmp_pallet = round(tmp_carton /  (xxpt_pt_maxcheng * xxpt_pt_pcscheng ),2) .
						 /*run getinteger(input-output tmp_pallet) .*/
						  /* pallet ji suan  --by ching 20060727--end*/ 

					  /* assign tmp_pallet = round(tmp_so_qty / ( xxpt_ct_pcs * xxpt_pt_maxcheng * xxpt_pt_pcscheng ) ,2) . */
					end.
				end.
				/*找座椅料號-BEGIN*/
				if xxpt_custseat_part  = "" then tmp_seat_part = "".
				else do:
					find first cp_mstr where cp_cust_part = xxpt_custseat_part no-lock no-error.
					if avail cp_mstr then tmp_seat_part = xxpt_custseat_part .
					else tmp_seat_part = "".
				end.
				/*找座椅料號-END*/

			end.
			else do:
				assign  tmp_carton = 0
					tmp_pallet = 0 .
			end.
			assign tmp_dec[1] = tmp_pallet .   /*保存原始卡板數量*/
			/*計算卡通及卡板數及找座椅料號-END*/

		 end.
 	      
              end.  /*for each so_mstr *********************/



                /*把選中的TMP資料存入XXSHD_DET表中--BEGIN*/
                  {xxshmt0302x.i}
                /*把選中的TMP資料存入XXSHD_DET表中--END*/

	     
	  
      end. /*if new xxshm_mstr then do:*******/
   /*mage add **********************************************************************************/
   
        VIEW FRAME finv .
        /*ss-20060830.1*  here ss-20060830.1 USE xxshmt01.i too  */
        /*ss-20060823.1*  here ss-20060823.1 USE xxshmt01.i too  */
        /*ss-20060815.1*  here ss-20060815.1 USE xxshmt01.i too  */
        {xxshmt01x.i}    /*update header data*/

        LEAVE loop-invno .
    END.   /*loop-invno*/
    
/*     CREATE xxshm_mstr.                         */
/*     ASSIGN xxshm_inv_no = INPUT xxshm_inv_no . */

/*     IF "1" = "1" THEN DO:               */
/*         UNDO main-loop,RETRY main-loop . */
/*     END.                                 */
    invno="".

END.  /*main-loop*/


PROCEDURE getcodemstr:
    DEF INPUT PARAM pro_fldname AS CHAR .
    DEF INPUT PARAM pro_value AS CHAR .
    DEF INPUT PARAM pro_update AS CHAR .
    DEF OUTPUT PARAM pro_cmmt AS CHAR .
    FIND FIRST CODE_mstr WHERE CODE_fldname = pro_fldname AND CODE_value = pro_value
         NO-ERROR.
    IF AVAIL CODE_mstr  THEN DO:
        ASSIGN pro_cmmt = CODE_cmmt .
       	if pro_update = "Y" then do:   /* samsong Add 20080808 */
            ASSIGN CODE_cmmt = STRING(INTEGER(CODE_cmmt) + 1) .
    	end.
    END.
    ELSE ASSIGN pro_cmmt = "" .
    RELEASE CODE_mstr .
END PROCEDURE .

PROCEDURE getinteger:
    DEF INPUT-OUTPUT PARAM pro_integer AS DEC.
    DEF VAR ii AS INTE.
    DEF VAR tmpchar AS CHAR INIT "".
    DO ii = 1 TO LENGTH(STRING(pro_integer)):
        IF SUBSTR(STRING(pro_integer) ,ii,1) <> "." THEN DO:
            tmpchar = tmpchar + SUBSTR(STRING(pro_integer) ,ii,1) .
        END.
        ELSE LEAVE .
    END.
    IF pro_integer > DEC(tmpchar)  THEN
        ASSIGN pro_integer = DEC(tmpchar) + 1 .
    ELSE 
        ASSIGN pro_integer = DEC(tmpchar) .
END PROCEDURE .

