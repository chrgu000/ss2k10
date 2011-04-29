	  assign
	  title1       = ""
	  title2       = ""
	  title3       = ""
	  loc          = ""
	  loc_line     = ""
	  nbr          = ""
	  term_desc    = ""
	  pinbr#       = ""
	  curr1        = ""
	  curr2        = ""
	  bill-to      = ""
	  etdate       = ""
	  ship-to      = ""
	  consig       = ""
	  bill-attn    = ""
	  ship-attn    = ""
	  consig_line  = "".
	  if print_yn then do:
	     title1 = "E A S T A R (HK) L I M I T E D".
	     title2 = "UNIT G, 19/F.,WORLD TECH CENTRE, 95 HOW MING STREET,KWUN TONG,HONG KONG".
	     title3 = "TEL:(852)2342-7688 FAX:(852)3101-9202".
	  end.
	  if shah_loc = "DC" then do:
	     loc = "DC ITEMS".
	     loc_line = "--------".
	  end.
	  if shah_loc = "MAIN" then do:
	     loc = "MAIN PLANT ITEMS".
	     loc_line = "----------------".
	  end.
	  if shah_consig = "C" then do:
	     consig = "CONSIGNMENT MODELS".
	     consig_line = "------------------".
	  end.
	  if shah_consig = "N" then do:
	     consig = "NON-CONSIGNMENT MODELS".
	     consig_line = "----------------------".
	  end.

          j = 1.
	  repeat j = 1 to 12:
              k = month(shah_etdhk).
		  if k = j then do:
		     etdate = string(day(shah_etdhk)) + months[j] + string(year(shah_etdhk)).
		     etdate2 = string(day(shah_etdhk)) + " " + months[j] + " " + string(year(shah_etdhk)).
		  end.
          end.

	  find first ad_mstr where ad_addr = shah_shipto no-lock no-error.
	  if available ad_mstr then do:
	     ship-to[1] = ad_name.
	     ship-to[2] = ad_line1.
	     ship-to[3] = ad_line2.
	     ship-to[4] = ad_line3.
	     ship-to[5] = ad_city.
	     ship-attn  = ad_attn.
	  end.

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
	     	 	 bill-attn  = ad_attn.
	          end.
		  find first ct_mstr where ct_code = so_cr_terms no-lock no-error.
		  if available ct_mstr then term_desc = ct_desc.
	      end.
