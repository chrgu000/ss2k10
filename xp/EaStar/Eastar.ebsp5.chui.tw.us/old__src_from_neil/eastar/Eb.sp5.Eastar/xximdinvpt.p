/* xximdinvpt.p  -- Immediate Invoice Print */
/* REVISION: eb SP5 create 06/07/04 BY: *EAS041A2* Apple Tam */

         /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}
        	{xxsoisdef.i "new"}


         define new shared variable sanbr like shah_sanbr.
         define new shared variable sanbr1 like shah_sanbr.
	 define new shared variable charge_yn as logical initial yes.
	 define new shared variable return_yn as logical initial yes.
	 define new shared variable print_yn as logical initial yes.
	 define new shared variable mar1 as integer format ">9".
	 define new shared variable mar2 as integer format ">9".
	 define new shared variable sort_yn as logical format "1/2" initial yes.
    define new shared variable update_yn as logical initial yes.
    define new shared variable number# like doc_ci_last.
    define new shared variable m as char format "x(9)".
    define variable mm as char format "x(9)".
    define new shared variable first_number like doc_ci_last.
    define new shared variable last_number like doc_ci_last.
    define new shared variable type# like doc_type.
    define new shared variable pinbr# like shah_pinbr.
    define new shared variable invdate# like shah_etdhk.
    define new shared variable xx_yn as logical initial yes.
    define variable yn as logical init yes.
    define variable to_inv_qty as decimal.
          /*easnew*/  DEFINE VARIABLE strYearChr AS CHARACTER FORMAT "x(1)".
      /*easnew*/  DEFINE VARIABLE strYrChr AS CHARACTER FORMAT "x(1)".
	DEFINE VARIABLE vchr_status AS INTEGER.  
    define variable inv_post as logical.
    {xxyr2let.i}
	 form
            sanbr            colon 30 label "Shipping Advice No."
            sanbr1           label {t001.i} colon 50    
	    invdate#            colon 30 label "Invoice Date"
	    sort_yn          label "Invoice Print by" colon 30 
	    "1 - Customer PO / Item" at 35
	    "2 - Shipping Advise"    at 35
	    skip(1)
	    charge_yn        label "Print Service Charge statement" colon 35
	    mar1             label "Service Charge Percentage" colon 72
	    return_yn        label "Print Return & Claims statement" colon 35
	    mar2             label "No. of Days" colon 72
	    print_yn         label "Print Company Address" colon 35
	    skip(1)
         with frame a width 80 attr-space side-labels.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
         mainloop:
         repeat:
            mar1 = 2.
	    mar2 = 30.
	    invdate# = today.
	    if sanbr1 = hi_char then sanbr1 = "".
            update sanbr sanbr1 invdate# sort_yn charge_yn mar1 return_yn mar2 print_yn
            with frame a.
	    if charge_yn = yes and mar1 <= 0 then do:
	       message "ERROR: The Service Charge Percentage must greater than zero. Please re-enter.".
	       undo, retry.
	    end.
	    if return_yn = yes and mar2 <= 0 then do:
	       message "ERROR: The No. of Days must greater than zero. Please re-enter.".
	       undo, retry.
	    end.


            bcdparm = "".
            {mfquoter.i sanbr    }
            {mfquoter.i sanbr1   }
            {mfquoter.i invdate#   }
            {mfquoter.i sort_yn    }
            {mfquoter.i charge_yn    }
            {mfquoter.i mar1   }
            {mfquoter.i return_yn }
            {mfquoter.i mar2 }
            {mfquoter.i print_yn }

            if sanbr1 = "" then sanbr1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}


           {gprun.i  ""xxim01.p""}

               {mfreset.i}

       /******************/
      update_yn = yes.
      message "Immediate Invoice Print accepted?" update update_yn.
      number# = first_number.
      if update_yn = yes then do:
       if sort_yn = yes then do:
        for each shad_det  where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0 
	                     and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ii_nbr = "")) EXCLUSIVE-LOCK break by shad_ponbr + shad_part:
            if first-of(shad_ponbr + shad_part) and shad_ii_nbr= "" then do:
              /*number# = number# + 1.
 *                        m = "".
 * 		       m = fill("0",5 - length(string(number#))).
 * 		       m = m + string(number#).
 * 		       pinbr# = "4" +  substr(string(year(today)),3,2) + m.*/
            /*davild20060104*/
            
                          number# = number# + 1.
                       m = "".
		       m = fill("0",5 - length(string(number#))).
		       m = m + string(number#).
		       /*easnew*  pinbr# = "4" +  substr(string(year(today)),3,2) + m.  */
		       /*easnew*/  mm = fill("0", 6 - length(string(number#))).
		       /*easnew*/  mm = mm + string(number#).
		       /*easnew*/  strYearChr = strYear2Let(STRING(YEAR(TODAY))).
		       /*easnew*/  strYrChr = strYr2Lt(STRING(YEAR(TODAY))).
		       /*easnew*/ pinbr# = "4" +  strYrChr + mm.
	    end.
	    if shad_ii_nbr= "" then do:
		       shad_ii_nbr= pinbr#.
            end.
         end.
       end.

       else do:
        for each shad_det  where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0 
	                     and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ii_nbr = "")) EXCLUSIVE-LOCK break by shad_sanbr :
            if first-of(shad_sanbr) and shad_ii_nbr= "" then do:
/*              number# = number# + 1.
 *                        m = "".
 * 		       m = fill("0",5 - length(string(number#))).
 * 		       m = m + string(number#).
 * 		       pinbr# = "4" +  substr(string(year(today)),3,2) + m.*/
                           number# = number# + 1.
                       m = "".
		       m = fill("0",5 - length(string(number#))).
		       m = m + string(number#).
		       /*easnew*  pinbr# = "4" +  substr(string(year(today)),3,2) + m.  */
		       /*easnew*/  mm = fill("0", 6 - length(string(number#))).
		       /*easnew*/  mm = mm + string(number#).
		       /*easnew*/  strYearChr = strYear2Let(STRING(YEAR(TODAY))).
		       /*easnew*/  strYrChr = strYr2Lt(STRING(YEAR(TODAY))).
		       /*easnew*/ pinbr# = "4" +  strYrChr + mm.
	    end.
	    if shad_ii_nbr= "" then do:
		       shad_ii_nbr= pinbr#.
            end.
         end.
       end.

/* begin invoice post*/
         {xximdpst.i}
/* invoice post end.*/


      end.
      else do:
          if first_number < last_number then do:
/*               do transaction on error undo, retry:*/
	       find first doc_nbr_ctl where doc_year = string(year(today)) and doc_type = type# 
	                  and doc_sn_last = last_number EXCLUSIVE-LOCK no-error.
	            if available doc_nbr_ctl then do:
		       doc_sn_last = first_number.
		    end.
                    if recid(doc_nbr_ctl) = ? then .
                    release doc_nbr_ctl.
/*                end. /*do transaction*/*/
         end.
      end.
      /******************/


     end.


