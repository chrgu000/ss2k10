/* xxcg01.p  -- Consignment Invoice Print */
/* REVISION: eb SP5 create 06/07/04 BY: *EAS041A2* Apple Tam */
/* Revision eB SP5 Linux  Last Modified: 12/01/05   By: Kaine  *easnew* */


         {mfdeclre.i}
         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

&SCOPED-DEFINE month1 "Jan"
/* MaxLen: Comment: */

&SCOPED-DEFINE month2 "Feb"
/* MaxLen: Comment: */

&SCOPED-DEFINE month3 "Mar"
/* MaxLen: Comment: */

&SCOPED-DEFINE month4 "Apr"
/* MaxLen: Comment: */

&SCOPED-DEFINE month5 "May"
/* MaxLen: Comment: */

&SCOPED-DEFINE month6 "Jun"
/* MaxLen: Comment: */

&SCOPED-DEFINE month7 "Jul"
/* MaxLen: Comment: */

&SCOPED-DEFINE month8 "Aug"
/* MaxLen: Comment: */

&SCOPED-DEFINE month9 "Sep"
/* MaxLen: Comment: */

&SCOPED-DEFINE month10 "Oct"
/* MaxLen: Comment: */

&SCOPED-DEFINE month11 "Nov"
/* MaxLen: Comment: */

&SCOPED-DEFINE month12 "Dec"
/* MaxLen: Comment: */

    
    define shared variable sanbr like shah_sanbr.
    define shared variable sanbr1 like shah_sanbr.
    define shared variable charge_yn as logical initial yes.
    define shared variable return_yn as logical initial yes.
    define shared variable print_yn as logical initial yes.
    define shared variable mar1 as integer format ">9".
    define shared variable mar2 as integer format ">9".
    define variable page_yn as logical initial yes.
    define shared variable update_yn as logical initial yes.
	 define shared variable sort_yn as logical format "1/2" initial yes.

    define variable title1 as character format "x(40)".
    define variable title2 as character format "x(65)".
    define variable title3 as character format "x(65)".
    define shared variable xx_yn as logical initial yes.

    define variable loc           as character format "x(16)".
    define variable loc_line      as character format "x(16)".
    define variable nbr           like shah_sanbr.
    define variable bill-to       as character format "x(28)" extent 5.
    define variable etdate        as character format "x(11)".
    define variable ship-to       as character format "X(28)" extent 5.
    define variable consig        as character format "x(22)".
    define variable consig_line   as character format "x(22)".
    define variable nbr2          as character format "x(12)".
    define variable nbr3          as character format "x(12)".
    define variable pages as integer.
    define variable etdate2        as character format "x(11)".
    define variable etdate3        as character format "x(11)".
    define variable feedback like shah_feedback.
    define shared variable pinbr# like shah_pinbr.
    define variable bill-attn like ad_attn.
    define variable ship-attn like ad_attn.
    define variable price like sod_list_pr format ">>>>,>>9.9999".
    define variable amount like sod_list_pr format ">>>>,>>9.9999".
    define variable ext_qty like shad_ext_qty.
    define variable um like sod_um.
    define variable total like sod_list_pr format ">,>>>,>>9.9999".
    define variable term_desc like ct_desc.
    define shared variable number# like doc_ci_last.
    define shared variable m as char format "x(9)".
    define shared variable first_number like doc_ci_last.
    define shared variable last_number like doc_ci_last.
    define shared variable type# like doc_type.
    define shared variable invdate# like shah_etdhk.
     define variable curr1 like so_curr.
    define variable curr2 like so_curr.
    define variable lines as integer.
    define variable lines2 as integer.

    define variable ctn-tt like shad_ctn_qty format ">>,>>9".
    define variable qty-tt like shad_ext_qty format ">>>,>>>,>>9.9".
    define variable gw-tt  like shad_plt_gw  format ">>>,>>9.99".
    define variable cbm-tt like shad_plt_cbm format ">>>,>>9.999".
define variable jj as integer.
define variable cbm# like shad_plt_cbm.
define temp-table xx_tmp
                  field xx_snnbr   like shad_snnbr
		  field xx_plt_nbr like shad_plt_nbr
		  field xx_sq      like shad_sq
		  field xx_sanbr   like shad_sanbr
		  field xx_cbm     like shad_plt_cbm
        index xx_nbr IS PRIMARY UNIQUE xx_plt_nbr ascending
		  .
/*easnew*/  DEFINE VARIABLE mm as char format "x(9)".
      /*easnew*/  DEFINE VARIABLE strYearChr AS CHARACTER FORMAT "x(1)".
      /*easnew*/  DEFINE VARIABLE strYrChr AS CHARACTER FORMAT "x(1)".
      /*easnew*/  {xxyr2let.i}
          
 define variable j as integer.
 define variable k as integer.
    define variable months as character format "X(3)" extent 12
          initial
          [

           {&month1},
           {&month2},
           {&month3},
           {&month4},
           {&month5},
           {&month6},
           {&month7},
           {&month8},
           {&month9},
           {&month10},
           {&month11},
           {&month12}
          ]  no-undo.


         {xxim01.i}   
         {xxim05.i}   
         {xxim02.i}   

      pages = 0.
      page_yn = yes.
      type# = "IV".
      first_number = 0.
      last_number = 0.
      number# = 0.

       /******************/
	       find first doc_nbr_ctl where doc_year = string(year(today)) and doc_type = type# 
	                  EXCLUSIVE-LOCK no-error.
	            if available doc_nbr_ctl then do:
		       first_number = doc_sn_last .
		       number# = first_number.
		    end.
       /******************/
       /*0924***********************************************************/
	 xx_yn = yes.
	 for each shad_det where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0
	                     and shad_inv_qty < 0 and shad_ii_nbr = "" no-lock:
	          xx_yn = no.
	 end.         
       /*0924***********************************************************/
      if sort_yn = yes then do:
	 for each shad_det where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0 
	                     and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ii_nbr = "")) no-lock break by shad_ponbr + shad_part:
	    if last-of(shad_ponbr + shad_part) then do:
               if shad_ii_nbr = "" then do:
                  do transaction on error undo, retry:
	            find first doc_nbr_ctl where doc_year = string(year(today)) and doc_type = type# 
	                  EXCLUSIVE-LOCK no-error.
	            if available doc_nbr_ctl then do:
		       doc_sn_last = doc_sn_last + 1.
		       last_number = doc_sn_last.
		    end.
		    else do:
		       create doc_nbr_ctl.
		       assign
		          doc_sn_last = 0
		          last_number = doc_sn_last
			  doc_year = string(year(today))
			  doc_type = type#.
		    end.
                    if recid(doc_nbr_ctl) = ? then .
                    release doc_nbr_ctl.
                 end. /*do transaction*/
	      end.
	    end.
         end.
      end.
      else do:
	 for each shad_det where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0 
	                     and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ii_nbr = "")) no-lock break by shad_sanbr by shad_sanbr + shad_ponbr + shad_part:
	    if last-of(shad_sanbr) then do:
               if shad_ii_nbr = "" then do:
                  do transaction on error undo, retry:
	            find first doc_nbr_ctl where doc_year = string(year(today)) and doc_type = type# 
	                  EXCLUSIVE-LOCK no-error.
	            if available doc_nbr_ctl then do:
		       doc_sn_last = doc_sn_last + 1.
		       last_number = doc_sn_last.
		    end.
		    else do:
		       create doc_nbr_ctl.
		       assign
		          doc_sn_last = 0
		          last_number = doc_sn_last
			  doc_year = string(year(today))
			  doc_type = type#.
		    end.
                    if recid(doc_nbr_ctl) = ? then .
                    release doc_nbr_ctl.
                 end. /*do transaction*/
	      end.
	    end.
         end.
      end.
       /******************/
   if sort_yn = yes then do:
      for each shah_hdr where shah_sanbr >= sanbr and shah_sanbr <= sanbr1 no-lock ,
      each shad_det  where shad_sanbr = shah_sanbr and shad_line > 0 and 
      ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ii_nbr = "")) no-lock 
      break by shad_ponbr + shad_part:
        {xxim11.i}
       /******************/
       pinbr# = shad_ii_nbr.
       feedback = shah_feedback.
       if last-of(shad_ponbr + shad_part) and shad_ii_nbr = "" then do:
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
       /******************/

          if last-of(shad_ponbr + shad_part) and page_yn = no then page.
	  if print_yn then do:
	     view frame phead1.
	  end.
	  else do:
	    view frame phead2.
	  end.
	      ext_qty = ext_qty + shad_inv_qty.
	      if last-of(shad_ponbr + shad_part) then do:
	      find first sod_det where sod_nbr = shad_so_nbr and sod_part = shad_part no-lock no-error.
	      if available sod_det then do:
	         um = sod_um.
		 price = sod_list_pr.
		 amount = ext_qty * sod_list_pr.
	      end.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if available pt_mstr then do:
	         if pt_desc1 <> "" then lines = lines + 1.
	         if pt_desc2 <> "" then lines = lines + 1.
	         if pt__chr01 <> "" then lines = lines + 1.
	         if pt__chr02 <> "" then lines = lines + 1.
	      end.
	      if page-size - line-counter < lines + 2 then page.
	          display
	                 shad_ponbr   
	  	         shad_part    
			 ext_qty 
			 um           
			 price        
			 amount          
	                 with frame c.
	      total = total + amount.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if available pt_mstr then do:
	         if pt_desc1 <> "" then put pt_desc1 at 14.
	         if pt_desc2 <> "" then put pt_desc2 at 14.
	         if pt__chr01 <> "" then put pt__chr01 at 14 format "x(24)".
	         if pt__chr02 <> "" then put pt__chr02 at 14 format "x(24)".
	      end.
	      put skip(1).
                um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = 0.
		lines = 0.
                      {xxim12.i}
	      end. /*last-of*/
	   end.
	   end. /* if sort_yn = yes*/

	   else do:

      for each shah_hdr where shah_sanbr >= sanbr and shah_sanbr <= sanbr1 no-lock ,
      each shad_det  where shad_sanbr = shah_sanbr and shad_line > 0 
      and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ii_nbr = "")) no-lock 
      break by shad_sanbr  by shad_sanbr + shad_ponbr + shad_part:
         {xxim11.i}
       /******************/
       pinbr# = shad_ii_nbr.
       feedback = shah_feedback.
       if first-of(shad_sanbr) and shad_ii_nbr = "" then do:
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
       /******************/

          if first-of(shad_sanbr) and page_yn = no then page.
	  if print_yn then do:
	     view frame phead1.
	  end.
	  else do:
	    view frame phead2.
	  end.
	      ext_qty = ext_qty + shad_inv_qty.
	      if last-of(shad_sanbr + shad_ponbr + shad_part) then do:
	      find first sod_det where sod_nbr = shad_so_nbr and sod_part = shad_part no-lock no-error.
	      if available sod_det then do:
	         um = sod_um.
		 price = sod_list_pr.
		 amount = ext_qty * sod_list_pr.
	      end.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if available pt_mstr then do:
	         if pt_desc1 <> "" then lines = lines + 1.
	         if pt_desc2 <> "" then lines = lines + 1.
	         if pt__chr01 <> "" then lines = lines + 1.
	         if pt__chr02 <> "" then lines = lines + 1.
	      end.
	      if page-size - line-counter < lines + 2 then page.
	          display
	                 shad_ponbr   
	  	         shad_part    
			 ext_qty 
			 um           
			 price        
			 amount          
	                 with frame c.
	      total = total + amount.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if available pt_mstr then do:
	         if pt_desc1 <> "" then put pt_desc1 at 14.
	         if pt_desc2 <> "" then put pt_desc2 at 14.
	         if pt__chr01 <> "" then put pt__chr01 at 14 format "x(24)".
	         if pt__chr02 <> "" then put pt__chr02 at 14 format "x(24)".
	      end.
	      put skip(1).
                um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = 0.
		lines = 0.
	      end. /*last-of*/ 
	      if last-of(shad_sanbr) then do:
                      {xxim12.i}
	      end.
	   end.
	   end. /* else do*/

/**********************************************************************/
/**********************************************************************/
