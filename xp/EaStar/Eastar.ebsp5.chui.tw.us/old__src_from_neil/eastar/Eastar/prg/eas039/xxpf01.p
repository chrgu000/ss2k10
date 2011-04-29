/* xxpf01.p  -- Proforma Invoice Print */
/* REVISION: eb SP5 create 06/02/04 BY: *EAS039A4* Apple Tam */


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
    define shared variable print_yn as logical initial yes.
    define shared variable pinbr like shah_pinbr.
    define shared variable pinbr1 like shah_pinbr.
    define variable page_yn as logical initial yes.

    define variable title1 as character format "x(40)".
    define variable title2 as character format "x(65)".
    define variable title3 as character format "x(65)".

    define variable loc           as character format "x(16)".
    define variable loc_line      as character format "x(16)".
    define variable nbr           like shah_sanbr.
    define variable bill-to       as character format "x(28)" extent 6.   /* micho */
    define variable etdate        as character format "x(11)".
    define variable ship-to       as character format "X(28)" extent 6.   /* micho */
    define variable consig        as character format "x(22)".
    define variable consig_line   as character format "x(22)".
    define variable nbr2          as character format "x(12)".
    define variable nbr3          as character format "x(12)".
    define variable pages as integer.
    define variable etdate2        as character format "x(11)".
    define variable etdate3        as character format "x(11)".
    define variable pinbr# like shah_pinbr.
    define variable bill-attn like ad_attn.
    define variable ship-attn like ad_attn.
    define variable price like sod_list_pr format ">>>>,>>9.9999".
    define variable amount like sod_list_pr format ">>>>,>>9.9999".
    define variable ext_qty like shad_ext_qty.
    define variable um like sod_um.
    define variable total like sod_list_pr format ">,>>>,>>9.9999".
    define variable term_desc like ct_desc.
    define variable lines as integer.
    define variable curr1 like so_curr.
    define variable curr2 like so_curr.

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


         {xxpf01.i}   
         {xxpf05.i}   
         {xxpf02.i}   

      pages = 0.
      page_yn = yes.
      for each shah_hdr where shah_sanbr >= sanbr and shah_sanbr <= sanbr1 and shah_pinbr >= pinbr and shah_pinbr <= pinbr1 no-lock break by shah_sanbr:
	  assign
	  title1       = ""
	  title2       = ""
	  title3       = ""
	  loc          = ""
	  loc_line     = ""
	  nbr          = ""
	  term_desc    = ""
	  pinbr#       = ""
	  bill-to      = ""
	  etdate       = ""
	  ship-to      = ""
	  consig       = ""
	  bill-attn    = ""
	  curr1        = ""
	  curr2        = ""
	  ship-attn    = ""
	  consig_line  = "".
	  if print_yn then do:
	     title1 = "E A S T A R (HK) L I M I T E D".
	     title2 = "UNIT G, 19/F.,WORLD TECH CENTRE, 95 HOW MING STREET,KWUN TONG,HONG KONG".
	     title3 = "TEL:(852)2342-7688 FAX:(852)2343-8078,2763-7223".
	  end.
	  if shah_loc = "DC" then do:
	     loc = "DC ITEMS".
	     loc_line = "--------".
	  end.
	  if shah_loc = "MAIN" then do:
	     loc = "MAIN PLANT ITEMS".
	     loc_line = "----------------".
	  end.
	  pinbr# = shah_pinbr.
	  if shah_consig = "C" then do:
	     consig = "CONSIGNMENT MODELS".
	     consig_line = "------------------".
	  end.
	  if shah_consig = "N" then do:
	     consig = "NON-CONSIGNMENT MODELS".
	     consig_line = "----------------------".
	  end.

          /* micho B */
	  /*
          j = 1.
	  repeat j = 1 to 12:
              k = month(shah_etdhk).
		  if k = j then do:
		     etdate = string(day(shah_etdhk)) + months[j] + string(year(shah_etdhk)).
		     etdate2 = string(day(shah_etdhk)) + " " + months[j] + " " + string(year(shah_etdhk)).
		  end.
          end.
	  */
          j = 1.
	  repeat j = 1 to 12:
              k = month(shah_dte01).
		  if k = j then do:
		     etdate = string(day(shah_dte01)) + months[j] + string(year(shah_dte01)).
		  end.
          end.

	  j = 1.
	  repeat j = 1 to 12:
              k = month(shah_etdhk).
		  if k = j then do:
		     etdate2 = string(day(shah_etdhk)) + " " + months[j] + " " + string(year(shah_etdhk)).
		  end.
          end.
          /* micho E */

	  find first ad_mstr where ad_addr = shah_shipto no-lock no-error.
	  if available ad_mstr then do:
	     ship-to[1] = ad_name.
	     ship-to[2] = ad_line1.
	     ship-to[3] = ad_line2.
	     ship-to[4] = ad_line3.
	     ship-to[5] = ad_city.
	     ship-to[6] = ad_country.   /* micho */
	     ship-attn  = ad_attn.
	  end.

	  find first shad_det where shad_sanbr = shah_sanbr and shad_line > 0 no-lock no-error.
	  if available shad_det then do:
	      find first so_mstr where so_nbr = shad_so_nbr no-lock no-error.
	      if available so_mstr then do:
	          curr1 = so_curr.
		  curr2 = so_curr.
		  find first ad_mstr where ad_addr = so_bill no-lock no-error.
	          if available ad_mstr then do:
	     	 	 bill-to[1] = ad_name.
	     	 	 bill-to[2] = ad_line1.
	     	 	 bill-to[3] = ad_line2.
	     	 	 bill-to[4] = ad_line3.
	     	 	 bill-to[5] = ad_city.
			 bill-to[6] = ad_country.   /* micho */
	     	 	 bill-attn  = ad_attn.
	          end.
		  find first ct_mstr where ct_code = so_cr_terms no-lock no-error.
		  if available ct_mstr then term_desc = ct_desc.
	      end.
	  end.
             if page_yn = no then page.
	  if print_yn then do:
	     view frame phead1.
	  end.
	  else do:
	    view frame phead2.
	  end.
	     total = 0.
	     lines = 0.
	  for each shad_det where shad_sanbr = shah_sanbr and shad_line > 0 no-lock break by shad_sanbr + shad_ponbr + shad_part :
	      ext_qty = ext_qty + shad_ext_qty.
	      if last-of(shad_sanbr + shad_ponbr + shad_part) then do:
	      find first sod_det where sod_nbr = shad_so_nbr and sod_part = shad_part no-lock no-error.
	      if available sod_det then do:
	         um = sod_um.
		 price = sod_list_pr.
		 amount = ext_qty * sod_list_pr.
	      end.
	      find first pt_mstr where pt_part = shad_part no-lock no-error.
	      if available pt_mstr then do:
	         if pt_desc1 <> "" or pt_desc2 <> "" then lines = lines + 1.
	         if pt__chr01 <> ""  or pt__chr02 <> "" then lines = lines + 1.
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
	         if pt_desc2 <> "" then put pt_desc2 at 40.
	         if pt__chr01 <> "" then put pt__chr01 at 14 format "x(24)".
	         if pt__chr02 <> "" then put pt__chr02 at 40 format "x(24)".
	      end.
	      put skip(1).
                um = "".
	      	price = 0.
	      	amount = 0.
	      	ext_qty = 0.
		lines = 0.
	      end. /*last-of*/
	   end.
	   page_yn = no.
/**********************************************************************/
/*TRAILER*/
                  
		  if shah_shipvia = "A" then do:
                  	if page-size - line-counter < 14 then page.
                  	do while page-size - line-counter > 14:
                  	   put skip(1).
                  	end.
                  	put "---------------" to 79.
			put "Total:" to 63.
                        put total  to 79  format ">,>>>,>>9.9999".
		  	put "===============" to 79.		  	
			put skip(1).
		  	put "AIR FORWARDER: " at 2.
			put shah_forwarder.
		  	put "HOUSING AWB# : " at 2.
			put shah_desc_line1.
		  	put "MASTER AWB#  : " at 2.
			put shah_desc_line2.
		  	put "FLIGHT NO.   : " at 2.
			put shah_desc_line4.
		  	put "ETD HK       : " at 2.
			put etdate2.
			put skip(2).
			put "***** END ***** "  at 32 .
			put skip(1).
			put "THIS IS A COMPUTER-GENERATED DOCUMENT AND NO SIGNATURE REQUIRED".
                  end.
		  else do:
                  	if page-size - line-counter < 15 then page.
                  	do while page-size - line-counter > 15:
                  	   put skip(1).
                  	end.
                  	put "---------------" to 79.
			put "Total:" to 63.
                        put total  to 79  format ">,>>>,>>9.9999".
		  	put "===============" to 79.		  	
			put skip(1).
		  	put "SHIPPING CO      : " at 2.
			put shah_forwarder.
		  	put "VESSEL NAME      : " at 2.
			put shah_desc_line1.
		  	put "B/L NO.          : " at 2.
			put shah_desc_line2.
			put "COUNTRY OF ORIGIN: " at 2.
			put shah_desc_line3.
		  	put "ETD HK           : " at 2.
			put etdate2.
		  	put "CONTAINER NO.    : " at 2.
			put shah_container.
			put skip(2).
			put "***** END ***** "  at 32 .
			put skip(1).
			put "THIS IS A COMPUTER-GENERATED DOCUMENT AND NO SIGNATURE REQUIRED".
		  end.
          pages = page-number .
      end. /*for each shah_hdr*/
