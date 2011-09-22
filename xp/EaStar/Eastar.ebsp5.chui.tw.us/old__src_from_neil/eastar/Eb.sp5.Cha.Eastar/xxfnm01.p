/* xxcg01.p  -- Consignment Invoice Print */
/* REVISION: eb SP5 create 06/07/04 BY: *EAS041A2* Apple Tam */
/* Revision eB SP5 Linux  Last Modified: 12/01/05   By: Kaine  *easnew* */
/* Revision eB SP5 Linux  Last Modified: 01/01/06   By: Kaine  *eas053a* */


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

    define variable loc           as character format "x(16)".
    define variable loc_line      as character format "x(16)".
    define variable nbr           like shah_sanbr.
    define variable bill-to       as character format "x(40)" extent 6.
    define variable etdate        as character format "x(11)".
    define variable ship-to       as character format "X(40)" extent 6.
    define variable consig        as character format "x(22)".
    define variable consig_line   as character format "x(22)".
    define variable nbr2          as character format "x(12)".
    define variable nbr3          as character format "x(12)".
    define variable pages as integer.
    define variable etdate2        as character format "x(11)".
    define variable etdate3        as character format "x(11)".
    define shared variable pinbr# like shah_pinbr.
    define variable bill-attn like ad_attn.
    define variable ship-attn like ad_attn.
    define variable price like sod_list_pr format ">>>>,>>9.9999".
    define variable amount like sod_list_pr format ">>>>,>>9.9999".
    define variable ext_qty like shad_ext_qty.
/*neil-060714*/ define variable ext_qty1 like shad_ext_qty.  
/*neil-060714*/ define variable ext_price like sod_price .     
    define variable um like sod_um.
    define variable total like sod_list_pr format ">,>>>,>>9.9999".
    define variable term_desc like ct_desc.
    define shared variable number# like doc_ci_last.
    define shared variable m as char format "x(9)".
    define shared variable first_number like doc_ci_last.
    define shared variable last_number like doc_ci_last.
    define shared variable type# like doc_type.
     define variable curr1 like so_curr.
    define variable curr2 like so_curr.
    define variable lines as integer.
    define variable lines2 as integer.
    define shared variable xx_yn as logical initial yes.

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
		  

/* ***********************eas053a B Add********************** */
DEFINE VARIABLE strDateInHead	AS		CHARACTER	FORMAT "x(11)".
DEFINE VARIABLE strRefNo		LIKE	so_bol.
DEFINE VARIABLE intItem			AS		INTEGER		FORMAT ">>>9".
DEFINE VARIABLE strPtDesc		AS		CHARACTER	FORMAT "x(48)".
/* ***********************eas053a E Add********************** */

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


         /*eas053a*  {xxnm01.i}     */
         /*eas053a*  {xxnm05.i}     */
         /*eas053a*  {xxnm02.i}     */
         /*eas053a*/ {xxfnmhd.i}

      pages = 0.
      page_yn = yes.
      /*eas053a*  type# = "NI".  */
      /*eas053a*/ type# = "VV".
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
	                     and shad_inv_qty < 0 and shad_ni_nbr = "" no-lock:
	          xx_yn = no.
	 end.         
       /*0924***********************************************************/

      if sort_yn = yes then do:
	 for each shad_det where shad_sanbr >= sanbr and shad_sanbr <= sanbr1 and shad_line > 0
          and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ni_nbr = "")) no-lock break by shad_sanbr + shad_ponbr + shad_part:
	    if last-of(shad_sanbr + shad_ponbr + shad_part) then do:
               if shad_ni_nbr = "" then do:
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
	                     and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ni_nbr = "")) no-lock 
			     break by shad_sanbr by shad_sanbr + shad_ponbr + shad_part:
	    if last-of(shad_sanbr) then do:
               if shad_ni_nbr = "" then do:
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
		each shad_det  where shad_sanbr = shah_sanbr and shad_line > 0 AND
			((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ni_nbr = "")) no-lock 
		break by shad_sanbr + shad_ponbr + shad_part:
			/*eas053a*  {xxnm11.i}  */
			/*eas053a*/ {xxfnm9val.i}
			
			/******************/
			pinbr# = shad_ni_nbr.
			if last-of(shad_sanbr + shad_ponbr + shad_part) and shad_ni_nbr = "" then do:
				/*eas053a*/  intItem = 0.
				number# = number# + 1.
				m = "".
				m = fill("0",5 - length(string(number#))).
				m = m + string(number#).
				/*easnew*  pinbr# = "3" +  substr(string(year(today)),3,2) + m.  */
				/*easnew*/  mm = fill("0", 6 - length(string(number#))).
				/*easnew*/  mm = mm + string(number#).
				/*easnew*/  strYearChr = strYear2Let(STRING(YEAR(TODAY))).
				/*easnew*/  strYrChr = strYr2Lt(STRING(YEAR(TODAY))).
				/*eas053a*  /*easnew*/ pinbr# = "3" +  strYrChr + mm.  */
				/*eas053a*/   pinbr# = "5" +  strYrChr + mm.
			end.
			/******************/

			IF last-of(shad_sanbr + shad_ponbr + shad_part) and page_yn = no then page.
			
			if print_yn then do:
				/*eas053a*  view frame phead1.  */
			end.
			else do:
				/*eas053a*  view frame phead2.  */
			end.
			
			/*eas053a*/  VIEW FRAME phead1.
			
			ext_qty = ext_qty + shad_inv_qty.
		  ext_qty1 = 0.
	    ext_price = 0.
			if last-of(shad_sanbr + shad_ponbr + shad_part) then do:
				/*eas053a*/  intItem = intItem + 1 .
			
			/*******************************neil-060714-b*******************************/
			
			for each sod_det where sod_nbr = shad_so_nbr and sod_part = shad_part no-lock break by sod_line  :	            
              if first(sod_line) then ext_price = sod_list_pr.
	            
	            if ext_price <> sod_list_pr then do: 
	         /*eas053a*/  strPtDesc = "".
	         find first pt_mstr where pt_part = shad_part no-lock no-error.
	         if available pt_mstr then do:
	            if pt_desc1 <> "" then lines = lines + 1.
	            if pt_desc2 <> "" then lines = lines + 1.
	            if pt__chr01 <> "" then lines = lines + 1.
	            if pt__chr02 <> "" then lines = lines + 1.
	            /*eas053a*/  strPtDesc = pt_desc1 + pt_desc2.
	         end.
	         if page-size - line-counter <= 5 then do: {xxfnmbtm.i}  page. end.
        DISPLAY
					STRING(intItem) @ intItem
					shad_ponbr
					shad_part
					strPtDesc
					ext_qty
					price
					amount
				WITH FRAME c.
				DOWN WITH FRAME c.
	      total = total + amount.	
	      intItem = intItem + 1 .
          um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = ext_qty - ext_qty1 .
	      	ext_qty1 = 0.
		      lines = 0.
             /* {xxim12.i}*/
	        end. /*if ext_price <> sod_list_pr*/

	        ext_qty1 = ext_qty1 + min( ext_qty - ext_qty1, sod_qty_inv ).
	        um = sod_um.
	        price = sod_list_pr.	            	 
	        amount = ext_qty1 * sod_list_pr.
	        if ext_qty1 >= ext_qty then leave .	        
	        end. /*for each sod_det */
	      
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if avail pt_mstr then strPtDesc = pt_desc1 + pt_desc2.   
	        if page-size - line-counter < 5 then do: {xxfnmbtm.i} .  page. end.
	      				DISPLAY
					STRING(intItem) @ intItem
					shad_ponbr
					shad_part
					strPtDesc
					ext_qty
					price
					amount
				WITH FRAME c.
				DOWN WITH FRAME c.
	      total = total + amount.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	        um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = ext_qty - ext_qty1 .
	      	ext_qty1 = 0.
		      lines = 0.
              {xxfnm12.i}      
	        
	      ext_qty = 0.     
	      end. /*last-of*/	   
/*******************************neil-060714-e******************************************/  	
				
				
 	end.
	end. /* if sort_yn = yes*/
	else do:
		for each shah_hdr where shah_sanbr >= sanbr and shah_sanbr <= sanbr1 no-lock ,
		each shad_det  where shad_sanbr = shah_sanbr and shad_line > 0 and ((xx_yn = yes and shad_inv_qty > 0) or (xx_yn = no and shad_inv_qty < 0 and shad_ni_nbr = "")) no-lock 
		break by shad_sanbr by shad_sanbr + shad_ponbr + shad_part:
			/*eas053a*  {xxnm11.i}  */
			/*eas053a*/ {xxfnm9val.i}
			
			/******************/
			pinbr# = shad_ni_nbr.
       
			if first-of(shad_sanbr) and shad_ni_nbr = "" then do:
				/*eas053a*/  intItem = 0.
				number# = number# + 1.
				m = "".
				m = fill("0",5 - length(string(number#))).
				m = m + string(number#).
				/*easnew*  pinbr# = "3" +  substr(string(year(today)),3,2) + m.  */
				/*easnew*/  mm = fill("0", 6 - length(string(number#))).
				/*easnew*/  mm = mm + string(number#).
				/*easnew*/  strYearChr = strYear2Let(STRING(YEAR(TODAY))).
				/*easnew*/  strYrChr = strYr2Lt(STRING(YEAR(TODAY))).
				/*easnew*/ pinbr# = "3" +  strYrChr + mm.
			end.
			/******************/

			IF first-of(shad_sanbr) and page_yn = no then page.
			IF print_yn then do:
				/*eas053a*  view frame phead1.  */
			end.
			else do:
				/*eas053a*  view frame phead2.  */
			end.
			/*eas053a*/  VIEW FRAME phead1.
	    
			ext_qty = ext_qty + shad_inv_qty.
			if last-of(shad_sanbr + shad_ponbr + shad_part) then do:
				/*eas053a*/  intItem = intItem + 1.
				
			/*******************************neil-060714-b*******************************/
			
			for each sod_det where sod_nbr = shad_so_nbr and sod_part = shad_part no-lock break by sod_line  :	            
              if first(sod_line) then ext_price = sod_list_pr.
	            
	            if ext_price <> sod_list_pr then do: 
	         /*eas053a*/  strPtDesc = "".
	         find first pt_mstr where pt_part = shad_part no-lock no-error.
	         if available pt_mstr then do:
	            if pt_desc1 <> "" then lines = lines + 1.
	            if pt_desc2 <> "" then lines = lines + 1.
	            if pt__chr01 <> "" then lines = lines + 1.
	            if pt__chr02 <> "" then lines = lines + 1.
	            /*eas053a*/  strPtDesc = pt_desc1 + pt_desc2.
	         end.
	         if page-size - line-counter <= 5 then do: {xxfnmbtm.i}  page. end.
        DISPLAY
					STRING(intItem) @ intItem
					shad_ponbr
					shad_part
					strPtDesc
					ext_qty
					price
					amount
				WITH FRAME c.
				DOWN WITH FRAME c.
	      total = total + amount.	
	      intItem = intItem + 1 .
          um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = ext_qty - ext_qty1 .
	      	ext_qty1 = 0.
		      lines = 0.
             /* {xxim12.i}*/
	        end. /*if ext_price <> sod_list_pr*/

	        ext_qty1 = ext_qty1 + min( ext_qty - ext_qty1, sod_qty_inv ).
	        um = sod_um.
	        price = sod_list_pr.	            	 
	        amount = ext_qty1 * sod_list_pr.
	        if ext_qty1 >= ext_qty then leave .	        
	        end. /*for each sod_det */
	      
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if avail pt_mstr then strPtDesc = pt_desc1 + pt_desc2.   
	        if page-size - line-counter < 5 then do: {xxfnmbtm.i} .  page. end.
	      				DISPLAY
					STRING(intItem) @ intItem
					shad_ponbr
					shad_part
					strPtDesc
					ext_qty
					price
					amount
				WITH FRAME c.
				DOWN WITH FRAME c.
	      total = total + amount.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	        um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = ext_qty - ext_qty1 .
	      	ext_qty1 = 0.
		      lines = 0.	        
	      ext_qty = 0.     
	      end. /*last-of*/	   
/*******************************neil-060714-e******************************************/  	

			if last-of(shad_sanbr) then do:
				/*eas053a*  {xxnm12.i}  */
				/*eas053a*/ {xxfnm12.i}
			end.
		end.
	end. /* else do*/

/**********************************************************************/
