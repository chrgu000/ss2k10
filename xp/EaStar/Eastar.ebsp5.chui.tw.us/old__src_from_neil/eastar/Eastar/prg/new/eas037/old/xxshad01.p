/* xxshad01.p  -- Shipping Advice Print */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS037A* Apple Tam */


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
    define variable page_yn as logical initial yes.

    define variable title1 as character format "x(40)".
    define variable title2 as character format "x(65)".
    define variable title3 as character format "x(65)".

    define variable loc           as character format "x(16)".
    define variable loc_line      as character format "x(16)".
    define variable nbr           like shah_sanbr.
    define variable sold-to       as character format "x(30)" extent 5.
    define variable etdate        as character format "x(11)".
    define variable ship-to       as character format "X(30)" extent 5.
    define variable consig        as character format "x(22)".
    define variable consig_line   as character format "x(22)".
    define variable nbr2          as character format "x(12)".
    define variable nbr3          as character format "x(12)".
    define variable pages as integer.
    define variable etdate2        as character format "x(11)".
    define variable etdate3        as character format "x(11)".
    define variable pinbr           like shah_pinbr.

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


         {xxshad01.i}   
         {xxshad05.i}   
         {xxshad02.i}   
         {xxshad03.i}   

      pages = 0.
      page_yn = yes.
      for each shah_hdr where shah_sanbr >= sanbr and shah_sanbr <= sanbr1 no-lock:
	  assign
	  title1       = ""
	  title2       = ""
	  title3       = ""
	  loc          = ""
	  loc_line     = ""
	  nbr          = ""
	  sold-to      = ""
	  etdate       = ""
	  ship-to      = ""
	  consig       = ""
	  pinbr        = ""
	  consig_line  = "".
	  if print_yn then do:
	     title1 = "E A S T A R (HONG KONG) L I M I T E D".
	     title2 = "UNIT G, 19/F.,WORLD TECH CENTRE, 95 HOW MING STREET,KWUN TONG,".
	     title3 = "HONG KONG,   TEL:(852)2342-7688 FAX:(852)2343-8078,2763-7223".
	  end.
	  if shah_loc = "DC" then do:
	     loc = "DC ITEMS".
	     loc_line = "--------".
	  end.
	  if shah_loc = "MAIN" then do:
	     loc = "MAIN PLANT ITEMS".
	     loc_line = "----------------".
	  end.
	  nbr = shah_sanbr.
	  pinbr = shah_pinbr.
	  if shah_consig = "C" then do:
	     consig = "CONSIGNMENT MODELS".
	     consig_line = "------------------".
	  end.
	  if shah_consig = "N" then do:
	     consig = "NON-CONSIGNMENT MODELS".
	     consig_line = "----------------------".
	  end.

	  nbr = shah_sanbr.
          j = 1.
	  repeat j = 1 to 12:
              k = month(shah_etdhk).
		  if k = j then do:
		     etdate = string(day(shah_etdhk)) + " " + months[j] + " " + string(year(shah_etdhk)).
		  end.
          end.
	  etdate2 = etdate.
          j = 1.
	  etdate3 = "".
	  repeat j = 1 to 12:
              k = month(shah_eta_date).
		  if k = j then do:
		     etdate3 = string(day(shah_eta_date)) + " " + months[j] + " " + string(year(shah_eta_date)).
		  end.
          end.

	  find first ad_mstr where ad_addr = shah_shipto no-lock no-error.
	  if available ad_mstr then do:
	     sold-to[1] = ad_name.
	     sold-to[2] = ad_line1.
	     sold-to[3] = ad_line2.
	     sold-to[4] = ad_line3.
	     sold-to[5] = ad_city.
	  end.
	  find first ad_mstr where ad_addr = shah_notify no-lock no-error.
	  if available ad_mstr then do:
	     ship-to[1] = ad_name.
	     ship-to[2] = ad_line1.
	     ship-to[3] = ad_line2.
	     ship-to[4] = ad_line3.
	     ship-to[5] = ad_city.
	  end.
	  if page_yn = no then page.
          if print_yn then do:
	     view frame phead1.
	  end.
	  else do:
	    view frame phead2.
	  end.
	     ctn-tt = 0.
	     qty-tt = 0.
	     gw-tt  = 0.
	     cbm-tt = 0.
	  for each xx_tmp:
	      delete xx_tmp.
	  end.
	  for each shad_det where shad_sanbr = shah_sanbr and shad_plt_nbr > 0 no-lock break by shad_plt_nbr :
	       if last-of(shad_plt_nbr) then do:
		   jj = 0.
		   cbm# = 0.
	             for each snh_ctn_hdr where snh_sn_nbr = shad_snnbr and snh_plt_nbr = shad_plt_nbr and snh_ctn_status <> "D" no-lock:
		         jj = jj + 1.
	             end.				          
		  if jj = 1 then do:
		     find first snp_totals where snp_sn_nbr = shad_snnbr and snp_nbr = shad_plt_nbr and snp_status <> "D" no-lock no-error.
		     if available snp_totals then do:
		        create xx_tmp.
		        assign
		            xx_sanbr = shad_sanbr
			    xx_snnbr = shad_snnbr
			    xx_plt_nbr = shad_plt_nbr
			    xx_cbm = snp_cbm.
			    xx_sq = shad_sq.
		     end.
		  end.
	       end.
	  end.

	  for each shad_det where shad_sanbr = shah_sanbr and shad_line > 0 no-lock break by shad_sanbr by shad_type desc :
		 cbm# = shad_ctn_qty * shad_ctn_cbm.
		 find first xx_tmp where xx_sanbr = shad_sanbr and xx_plt_nbr = shad_plt_nbr no-error.
		 if available xx_tmp then cbm# = xx_cbm.

	     if shah_shipvia = "S" then do:
	         if shad_type = "P" then do:
		    nbr2 = "    " + string(shad_plt_nbr).
		 end.
		 else do:
		       nbr2 = "C/No" + string(shad_ctnnbr_fm,"999") + "-" + string(shad_ctnnbr_to,"999").
		 end.
                  	if page-size - line-counter < 2 then page.
	          display
	                 nbr2          
	  	         shad_part     
/*			 shad_ponbr    */
			 shad_qtyper   
			 shad_ctn_qty  
			 shad_ext_qty  
			 shad_ctn_ext_gw   
			 shad_ctn_cbm  
	                 with frame c.
			 display cbm# @ shad_ctn_cbm with frame c.
			 put "PO No. " at 15 shad_ponbr.
	     ctn-tt = ctn-tt + shad_ctn_qty.
	     qty-tt = qty-tt + shad_ext_qty .
	     gw-tt  = gw-tt  + shad_ctn_ext_gw.
	     cbm-tt = cbm-tt + cbm# .
	     end.
	     else do:
	         if shad_type = "P" then do:
		    nbr3 = " " + string(shad_plt_nbr).
		 end.
		 else do:
		       nbr3 = "C/No" + string(shad_ctnnbr_fm,"999") + "-" + string(shad_ctnnbr_to,"999").
		 end.
                  	if page-size - line-counter < 2 then page.
	          display
	                 nbr3          
	  	         shad_part     
			 shad_qtyper   
			 shad_ctn_qty  
			 shad_ext_qty  
			 shad_ctn_ext_gw   
			 shad_ctn_cbm  
	                 with frame c2.
			 display cbm# @ shad_ctn_cbm with frame c2.
			 put "PO No. " at 15 shad_ponbr.
/*			 down 1 with frame c2.*/
	     ctn-tt = ctn-tt + shad_ctn_qty.
	     qty-tt = qty-tt + shad_ext_qty .
	     gw-tt  = gw-tt  + shad_ctn_ext_gw.
	     cbm-tt = cbm-tt + cbm#.
	     end.
	  end.
	  page_yn = no.
/**********************************************************************/
/*TRAILER*/
                  
		  if shah_shipvia = "A" then do:
                  	if page-size - line-counter < 15 then page.
                  	do while page-size - line-counter > 15:
                  	   put skip(1).
                  	end.
                  	put "---------------------------------------" at 38.
                        put ctn-tt  to 45 format ">>,>>9".
			put qty-tt  to 56 format ">>>,>>>,>>9".
			put gw-tt   to 66 format ">>,>>9.99".
			put cbm-tt  to 76 format ">9.999".
		  	put "=======================================" at 38.
		  	
			put skip(1).
		  	put "TOTAL: " to 16.
			put shah_ttl_ctn.
		  	put " CARTON(S) ONLY".
			put skip(1).
		  	put "AIR FORWARDER: " at 2.
			put shah_forwarder.
		  	put "HOUSING AWB# : " at 2.
			put shah_desc_line1.
		  	put "MASTER AWB#  : " at 2.
			put shah_desc_line2.
		  	put "FLIGHT NO.   : " at 2.
			put shah_desc_line4.
/*		  	put "B/L NO.      : " at 2.
			put shah_desc_line4.*/
		  	put "ETD HK       : " at 2.
			put etdate2.
		  	put "ETA          : " at 2.
			put shah_eta format "x(20)".
			put skip(1).
			put "TOTAL PAGE(s): "  at 30 page-number - pages format ">9".
                  end.
		  else do:
                  	if page-size - line-counter < 14 then page.
                  	do while page-size - line-counter > 14:
                  	   put skip(1).
                  	end.
                  	put "---------------------------------------" at 38.
                        put ctn-tt  to 45 format ">>,>>9".
			put qty-tt  to 56 format ">>>,>>>,>>9".
			put gw-tt   to 66 format ">>,>>9.99".
			put cbm-tt  to 76 format ">9.999".
		  	put "=======================================" at 38.
		  	
		  	put skip(1).
		  	put "TOTAL: " to 16.
			put shah_ttl_plt.
		  	put " PALLET(S) ONLY".
			put skip(1).
		  	put "SHIPPING CO  : " at 2.
			put shah_forwarder.
		  	put "VESSEL NAME  : " at 2.
			put shah_desc_line1.
		  	put "B/L NO.      : " at 2.
			put shah_desc_line2.
		  	put "ETD HK       : " at 2.
			put etdate2.
		  	put "ETA          : " at 2.
			put shah_eta format "x(20)".
			put  " - ".
			put etdate3 format "x(11)".
		  	put "CONTAINER NO.: " at 2.
			put shah_container.
			put skip(1).
			put "TOTAL PAGE(s): "  at 30 page-number - pages format ">9".
		  end.
          pages = page-number .
      end. /*for each shah_hdr*/
