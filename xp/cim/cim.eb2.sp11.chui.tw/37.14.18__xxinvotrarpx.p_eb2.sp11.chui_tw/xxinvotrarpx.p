/* xxinvotrarp.p - CS INVOINCE AUTO TRANSFER                  */
/* Copyright SOFTSPEED Inc.   */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: eB2SP11.Chui   Modified: 09/12/06      By: Kaine Zhang     *ss-20060912.1* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090826.1  By: Roger Xiao */


/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090826.1 - RNB
Just modify the xxinvotrarpux.i
1. cimload format changed
2. if error occurs, cimload tempfiles not deleted
SS - 090826.1 - RNE */

{mfdtitle.i "090826.1"}

 /* {xxinvotraa.i "new"} */

define var invno like xxshm_inv_no.
define var site_from like pt_site init "2000".
define var site_to like pt_site init "2000".
define var loc_from  like pt_loc init "CFG001".
define var loc_to like pt_loc.

define var trtotal_qty as integer init 0.
define var trsucc_qty as integer init 0.
define var trallsuccess as logical init true.
define var yn as logical init true.

define var tmpqty like sr_qty.
define var i as integer init 0.
define var j as integer init 0.
/*mage*/   define var totladqty like sr_qty.

define  temp-table tm1mstr
		field	tm1_part like pt_part
		field tm1_site like si_site
		field tm1_loc like pt_loc
/*mage*/        field tm1_lot like lad_lot 
/*mage*/        field tm1_ref like lad_ref 
		field tm1_qty like sr_qty
		field tm1_isenou as logical
		.


/*Kaine*/  DEF VAR decUmConv LIKE sod_um_conv NO-UNDO.


form invno colon 15  skip(1)
 	"from"    colon 16
	"to"	  colon 42
/*mage	site_from colon 15  */
	site_to colon 40
/*mage	loc_from colon 15  */
	loc_to colon 40
with frame a side-labels attr-space width 80.
setFrameLabels(frame a:handle).




mainloop:
        /*Kaine*  REPEAT with frame a:  */
        /*Kaine*/ REPEAT TRANSACTION with frame a:


		CLEAR frame a all no-pause.
		VIEW frame a.
		display
		    invno
		      site_to
		      loc_to
		with frame a.

		update invno with frame a .


		if not invno matches("*cs") then do:
			{pxmsg.i &MSGNUM=8113 &ERRORLEVEL=3}
			/* message "Not available this CS Invoice, please retry again.". */
			NEXT-PROMPT invno with frame a.
			undo, retry.
		end.		/* end if not input xxshm_inv_no matches("*cs") */

		FIND FIRST xxshm_mstr where xxshm_inv_no = invno and xxshm_log[3] = false AND xxshm_inv_no matches("*cs") no-lock no-error.
		if not available xxshm_mstr then do:
			{pxmsg.i &MSGNUM=8113 &ERRORLEVEL=3}
			next-prompt invno with frame a.
			UNDO, retry.
		end.	/* END if not available xxshm_mstr */

		loop1:
		do on error undo, retry with frame a:
			
			/* ********************Kaine B Del*******************
			 *  set
			 *      site_from site_to
			 *      loc_from loc_to
			 *  WITH frame a.
			 * ********************Kaine E Del*******************/
			
			/* ***********************Kaine B Add********************** */
			SET
/*mage			    site_from 
			    loc_from  */
			    site_to
			    loc_to
			WITH FRAME a.
			/* ***********************Kaine E Add********************** */
			 
/*mage
			FOR first si_mstr where si_site =  site_from no-lock:
			end. /* FOR FIRST si_mstr */

			if not available si_mstr then do :
				{pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
				undo loop1 ,retry.
			end.	 /*end if not available si_mstr */
*/			
			/* ***********************Kaine B Add********************** */
			/*Kaine*  todo: site security  */
			/* ***********************Kaine E Add********************** */

			for first si_mstr where si_site =  site_to no-lock:
			end. /* FOR FIRST si_mstr */
			if not available si_mstr then do :
				{pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
				undo loop1 ,retry.
			END.	 /*end if not available si_mstr  */

/*mage			for first loc_mstr where loc_site = site_from and loc_loc = loc_from no-lock:
			end.
			if not available loc_mstr then do :
				{pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
				undo loop1 ,retry.
			END.	 /* end if not available loc_mstr */
*/
			for first loc_mstr where loc_site = site_to and loc_loc = loc_to no-lock:
			end.
			if not available loc_mstr then do :
				 {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
				 undo loop1 ,retry.
			end.	 /* end if not available loc_mstr */

			if site_from = site_to and loc_from = loc_to then do :
				 {pxmsg.i &MSGNUM=1919 &ERRORLEVEL=3}
				undo loop1 ,retry.
			end.	 /* end if not available loc_mstr */

		end.   /*end do on error */
/*mage add*************************************************************************************/

   for each xxshd_det where xxshm_inv_no = xxshd_inv_no use-index xxshd_inv_so:
	        totladqty = 0.
		           decUmConv = 1.
			    FOR FIRST sod_det
			        WHERE sod_nbr = xxshd_so_nbr 
			            AND sod_line = xxshd_so_line
			        NO-LOCK
			        :
			    END.
			    
			    IF AVAILABLE sod_det THEN DO:
			        decUmConv = sod_um_conv.
			    END.

                for each lad_det where lad_dataset = "sod_det" and lad_nbr = xxshd_so_nbr 
		   and lad_line = string(xxshd_so_line)
			      and lad_part = xxshd_so_part and  lad_ref = xxshd_inv_no 
			      and (lad_qty_all > 0 ) no-lock:
			       
				      totladqty = totladqty + lad_qty_all .
               end.
	       if totladqty <>  xxshd_so_qty * decUmConv  then do:
                  message xxshd_so_part "�o���ƶq�O:"  xxshd_so_qty * decUmConv   "�ƮƼƶq�O:"  totladqty  "����T�{" view-as alert-box.
                  undo mainloop,retry mainloop .
		  
               end.
        end.
/*mage add*************************************************************************************/

		for each tm1mstr:
			delete tm1mstr.
		end.
		
		i = 0.
		j = 0.
		
 		for each xxshd_det where xxshm_inv_no = xxshd_inv_no use-index xxshd_inv_so:
			if not xxshd_log[1]  then do:
			    
			    /* ***********************Kaine B Add********************** */
			    /*Kaine*  decUmConv  */

			    decUmConv = 1.
			    FOR FIRST sod_det
			        WHERE sod_nbr = xxshd_so_nbr 
			            AND sod_line = xxshd_so_line
			        NO-LOCK
			        :
			    END.
			    
			    IF AVAILABLE sod_det THEN DO:
			        decUmConv = sod_um_conv.
			    END.
			    ELSE DO:
			        FOR FIRST idh_hist
    			        WHERE idh_nbr = xxshd_so_nbr 
    			            AND idh_line = xxshd_so_line
    			        NO-LOCK
    			        :
    			    END.
    			    IF AVAILABLE idh_hist THEN decUmConv = idh_um_conv.
			    END.
			    /* ***********************Kaine E Add********************** */
/*mage del****************************************************************************************			    
				i = i + 1.
				find first tm1mstr where tm1_part  = xxshd_so_part no-error .
				if not available tm1mstr then do:
					create tm1mstr.
					ASSIGN
					    tm1_part = xxshd_so_part
					    tm1_site = site_from
					    tm1_loc = loc_from
					    /*Kaine*  tm1_qty = xxshd_so_qty  */
					    /*Kaine*/ tm1_qty = xxshd_so_qty * decUmConv
					    tm1_isenou = FALSE
					    .
				end.	/* end if not available tm1mstr */
				else do:
					/*Kaine*  tm1_qty = tm1_qty + xxshd_so_qty.  */
					/*Kaine*/ tm1_qty = tm1_qty + xxshd_so_qty * decUmConv.
				end.
*mage del****************************************************************************************/			    
/*mage add****************************************************************************************/			    
				

			        i = i + 1.
				def var xxshdsoqty like xxshd_so_qty .
				def var xxshipqty like xxshd_so_qty .
				xxshdsoqty = xxshd_so_qty * decUmConv.
                                if decUmConv  = 0 then decUmConv  = 1 .

			  for each lad_det where lad_dataset = "sod_det" and lad_nbr = xxshd_so_nbr 
			      and lad_line = string(xxshd_so_line)
			      and lad_part = xxshd_so_part 
			      and lad_ref  = xxshd_inv_no and lad_qty_all > 0 no-lock:
                                  
				find first tm1mstr where tm1_part = xxshd_so_part
					   and tm1_site = lad_site
					   and tm1_loc =  lad_loc
					    /*Kaine*  tm1_qty = xxshd_so_qty  */
					  and tm1_lot  = lad_lot
					  and tm1_ref  = lad_ref no-error .
				if not available tm1mstr then do:
					create tm1mstr.
					ASSIGN
					    tm1_part = xxshd_so_part
					    tm1_site = lad_site
					    tm1_loc =  lad_loc
					    tm1_lot  = lad_lot
					    tm1_ref  = lad_ref 
					    /*Kaine*/ tm1_qty = min(xxshdsoqty , lad_qty_all) 
					    tm1_isenou = FALSE
					    .
				end.	/* end if not available tm1mstr */
				else do:
					/*Kaine*  tm1_qty = tm1_qty + xxshd_so_qty.  */
					/*Kaine*/ tm1_qty = tm1_qty +  min(xxshdsoqty   , lad_qty_all) .
				end.
                                xxshdsoqty = xxshdsoqty -  lad_qty_all .
				if xxshdsoqty <= 0 then leave .
                        end.  /*for each lad_det **************/
/*mage add****************************************************************************************/			    

			end. /*if not xxshd_log[1]  then do: */
			else do:
				j = j + 1.
			end.
		end.	/* for each xxshd_det */
		
		/* ********************Kaine B Del*******************
		 *  trtotal_qty = 0.
		 *  FOR each tm1mstr ,
		 *  EACH ld_det
		 *      where tm1_site = ld_site
		 *          and tm1_part = ld_part 
		 *          and tm1_loc = ld_loc
		 *      NO-LOCK
		 *      :
		 *  	trtotal_qty = trtotal_qty + 1.
		 *  	if tm1_qty <= ld_qty_oh then tm1_isenou = true.
		 *  END.	/* for each tm1mstr */
		 * ********************Kaine E Del*******************/
		
		/* ***********************Kaine B Add********************** */
		/*Kaine*  did NOT think about ld's (lot ref)  */
		trtotal_qty = 0.
		FOR each tm1mstr:
		    trtotal_qty = trtotal_qty + 1.
		    
		    FOR FIRST ld_det
    		    where   tm1_site = ld_site
    		        and tm1_part = ld_part 
    		        and tm1_loc = ld_loc
/*mage add*/            and tm1_lot = ld_lot
                        and tm1_ref = ld_ref
    		    NO-LOCK
    		    :
    		   END.
			IF AVAILABLE ld_det AND tm1_qty <= ld_qty_oh THEN tm1_isenou = true.
/*			message  tm1_site
				 tm1_part
				 tm1_loc 
				 tm1_lot tm1_ref tm1_isenou  view-as alert-box. */
		END.	/* for each tm1mstr */
		/* ***********************Kaine E Add********************** */

		if trtotal_qty > 0 THEN do:
			
			for first tm1mstr where tm1_isenou = false:
			end.
			if  available tm1mstr then do :
				message tm1_part + "�w�s����,�ާ@�פ�".
				undo mainloop,retry.
			end.	/* if  available tm1mstr */

			else do:
				message "�w����" + string(j) + "��," + "�٦�" + string(i) + "��," + "�@��" + string(trtotal_qty) + "���ݭn���," + "�O�_�~��?" update yn.
				if yn then do:
					message "Processing ......".
					{xxinvotrarpux.i}
				end.
			end.

			for each tm1mstr  no-lock :
				
				/* ********************Kaine B Del*******************
				 *  find last tr_hist
				 *      where tr_trnbr > 0 
    			 *  	    and tr_part = tm1_part 
    			 *  	    and tr_type = "RCT-TR" 
    			 *  	    and tr_date = today 
    			 *  	    and tr_site = site_to 
    			 *  	    and tr_loc = loc_to 
    			 *  	    and tr_qty_chg = tm1_qty
				 *      NO-LOCK
				 *      no-error.
				 * ********************Kaine E Del*******************/
				 
				 for each lad_det where lad_part = tm1_part and lad_site = tm1_site 
				    and lad_loc = tm1_loc   and tm1_lot = lad_lot
				    and lad_ref = tm1_ref:
                                     
				    for each sod_det where sod_nbr = lad_nbr and string(sod_line) = lad_line :
				        sod_qty_all = max(sod_qty_all - lad_qty_all, 0 ).
				    end.
				    find first ld_det where ld_site = lad_site  and ld_loc = lad_loc 
				       and ld_part = lad_part and ld_lot = lad_lot 
				         no-error.
                                    if available ld_det then ld_qty_all = max(ld_qty_all - lad_qty_all , 0).
				    find first in_mstr  where in_site = lad_site and in_part = lad_part no-error.
				    if available in_mstr then in_qty_all = max(in_qty_all - lad_qty_all,0).

				    delete lad_det .

				 end.
 				
				FOR FIRST tr_hist
				    WHERE tr_type = "RCT-TR"
				        AND tr_rmks = invno
				        AND tr_part = tm1_part
				    NO-LOCK:
				END.
				if  not available tr_hist then do:
					trallsuccess = false.
					
					/* ***********************Kaine B Add********************** */
					{pxmsg.i &MSGNUM=9101 &ERRORLEVEL=3}
					UNDO mainloop, RETRY mainloop.
					/* ***********************Kaine E Add********************** */
				end.	/* end if  not available tr_hist*/
				else if available tr_hist then do:
					for each xxshd_det where xxshd_inv_no = invno and xxshd_so_part = tm1_part :
						xxshd_log[1] = true.
					end.
				end.
			end.  /* end for each tm1mstr */

			for first  xxshd_det where xxshd_inv_no matches("*cs") and xxshd_inv_no = invno and xxshd_log[1] = false no-lock:
			end.
			if available xxshd_det then trallsuccess = false.


			if trallsuccess then do :
				message "�����������!".
				find first xxshm_mstr where xxshm_inv_no = invno .
				xxshm_log[3] = true.
			end.
			else message "����������S����!".

		end. /*end if trtotal_qty > 0 */

		else do:
			message "�S������ݭn!" .
			undo , retry mainloop.
		end.
	end.
