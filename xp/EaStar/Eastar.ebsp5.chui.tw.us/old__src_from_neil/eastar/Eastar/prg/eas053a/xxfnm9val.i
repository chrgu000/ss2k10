/* Revision eB SP5 Linux  Last Modified: 01/01/06   By: Kaine  *eas053a* */

	ASSIGN
		curr1		= ""
		curr2		= ""
		bill-to		= ""
		ship-to 	= ""
		ship-attn	= ""
		bill-attn	= ""
		term_desc	= ""
		pinbr#		= ""
		strRefNo	= ""
		.
	
	strDateInHead = STRING(DAY(shah_dte01), "99") + " "
		+ months[MONTH(shah_dte01)] + " "
		+ STRING(YEAR(shah_dte01), "9999").
	
	FOR FIRST ad_mstr WHERE ad_addr = shah_shipto NO-LOCK:    END.
	IF AVAILABLE ad_mstr THEN DO:
		ship-to[1] = ad_name.
		ship-to[2] = ad_line1.
		ship-to[3] = ad_line2.
		ship-to[4] = ad_line3.
		ship-to[5] = ad_city.
		ship-attn  = ad_attn.
		
		FOR FIRST ctry_mstr WHERE ctry_ctry_code = ad_ctry NO-LOCK:    END.
		IF AVAILABLE ctry_mstr THEN ship-to[6] = ctry_country .
	END.

	FOR FIRST so_mstr WHERE so_nbr = shad_so_nbr NO-LOCK:    END.
	IF AVAILABLE so_mstr THEN do:
		ASSIGN
			curr1		= so_curr
			curr2		= so_curr
			strRefNo	= so_bol
			.
			
		FOR FIRST ad_mstr WHERE ad_addr = so_bill NO-LOCK:    END.
		IF AVAILABLE ad_mstr THEN do:
			bill-to[1] = ad_name.
			bill-to[2] = ad_line1.
			bill-to[3] = ad_line2.
			bill-to[4] = ad_line3.
			bill-to[5] = ad_city.
			bill-attn  = ad_attn.
			
			FOR FIRST ctry_mstr WHERE ctry_ctry_code = ad_ctry NO-LOCK:    END.
			IF AVAILABLE ctry_mstr THEN bill-to[6] = ctry_country .
		END.

		FOR FIRST ct_mstr WHERE ct_code = so_cr_terms NO-LOCK:    END.
		IF AVAILABLE ct_mstr THEN term_desc = ct_desc.
	END.
