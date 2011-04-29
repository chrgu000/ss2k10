/* REVISION: EB SP5 Char   LAST MODIFIED: 03/19/04   BY: Kaine Zhang  *eas038* */

	{mfdeclre.i "  "}
	{gplabel.i}
	
	DEFINE SHARED VARIABLE strNbr		LIKE shah_pinbr.
	DEFINE SHARED VARIABLE strNbra		LIKE shah_pinbr.
	DEFINE SHARED VARIABLE strLang		AS   CHARACTER.
	
	DEFINE VARIABLE strTitle1	AS CHARACTER FORMAT "x(45)".
	DEFINE VARIABLE strTitle2	AS CHARACTER FORMAT "x(65)".
	DEFINE VARIABLE strTitle3	AS CHARACTER FORMAT "x(65)".
	DEFINE VARIABLE strTitle4	AS CHARACTER FORMAT "x(23)".
	DEFINE VARIABLE strTitle5	AS CHARACTER FORMAT "x(16)".
	DEFINE VARIABLE strTitle6	AS CHARACTER FORMAT "x(18)".
	DEFINE VARIABLE strTitle7	AS CHARACTER FORMAT "x(58)".
	
	DEFINE VARIABLE strL1		AS CHARACTER FORMAT "x(23)".
	DEFINE VARIABLE strL2		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL3		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL4		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL5		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL6		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL7		AS CHARACTER FORMAT "x(14)".
	
	DEFINE VARIABLE strR1		AS CHARACTER FORMAT "x(8)".
	DEFINE VARIABLE strR2		AS CHARACTER FORMAT "x(5)".
	DEFINE VARIABLE strR3		AS CHARACTER FORMAT "x(5)".
	
	DEFINE VARIABLE strL2a		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL3a		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL4a		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL5a		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL6a		AS CHARACTER FORMAT "x(14)".
	
	DEFINE VARIABLE strDateL	AS CHARACTER FORMAT "x(11)".
	DEFINE VARIABLE strDateR	AS CHARACTER FORMAT "x(11)".
	DEFINE VARIABLE strEta		AS CHARACTER FORMAT "x(34)".
	
	DEFINE VARIABLE strMonth	AS CHARACTER.
	DEFINE VARIABLE strPlt		AS CHARACTER FORMAT "x(7)".
	DEFINE VARIABLE strCtn		AS CHARACTER FORMAT "x(7)".
	
	DEFINE VARIABLE strTTLa		AS CHARACTER FORMAT "x(6)".
	DEFINE VARIABLE strTTLb		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE intTTL		LIKE shah_ttl_ctn.
	
	DEFINE VARIABLE intPage		AS INTEGER FORMAT ">>9".
	
	IF global_user_lang = "US" OR global_user_lang = "TW" THEN DO:
		ASSIGN
			strTitle1	= "E A S T A R (HONG KONG) L I M I T E D"
			strTitle2	= "UNIT G, 19/F.,WORLD TECH CENTRE, 95 HOW MING STREET,KWUN TONG,"
			strTitle3	= "HONG KONG,   TEL:(852)2342-7688 FAX:(852)2343-8078,2763-7223"
			strTitle4	= "P A C K I N G   L I S T"
			strTitle7	= "(THIS SHIPMENT CONTAINS NO SOLID WOOD PACKING MATERIALS)"
			strL1		= "SHIPMENT PACKING STATUS"
			strL2		= "SHIPPING CO  :"
			strL3		= "VESSEL NAME  :"
			strL4		= "B/L NO.      :"
			strL5		= "ETD HK       :"
			strL6		= "ETA          :"
			strL7		= "CONTAINER NO.:"
			strR1		= "P/I NO.:"
			strR2		= "DATE:"
			strR3		= "PAGE:"
			strL2a		= "AIR FORWARDER:"
			strL3a		= "HOUSING AWB  :"
			strL4a		= "MASTER AWB   :"
			strL5a		= "FLIGHT NO.   :"
			strL6a		= "ETD HK       :"
			strTTLa		= "TOTAL:"
			.
	END.
	/*lang test*
	ELSE IF global_user_lang = "CH" THEN DO:	/*test* "TW" */
		ASSIGN
			strTitle1	= "≤‚ ‘±ÍÃ‚1"
			strTitle2	= "≤‚ ‘±ÍÃ‚2"
			strTitle3	= "≤‚ ‘±ÍÃ‚3"
			strTitle4	= "≤‚ ‘±ÍÃ‚4"
			strTitle7	= "≤‚ ‘±ÍÃ‚7"
			strL1		= "◊Û1"
			strL2		= "◊Û2"
			strL3		= "◊Û3"
			strL4		= "◊Û4"
			strL5		= "◊Û5"
			strL6		= "◊Û6"
			strL7		= "◊Û7"
			strR1		= "”“1"
			strR2		= "”“2"
			strR3		= "”“3"
			strL2a		= "◊Û2a"
			strL3a		= "◊Û3a"
			strL4a		= "◊Û4a"
			strL5a		= "◊Û5a"
			strL6a		= "◊Û6a"
			strTTLa		= "◊‹"
			.
	END.
	*lang test*/
	
	FORM
		strPlt COLUMN-LABEL "Pallet#"
		shad_part COLUMN-LABEL "Part No."
		shad_ponbr COLUMN-LABEL "P/O #"
		shad_qtyper FORMAT ">,>>>,>>9" COLUMN-LABEL "QTY/CTN"
		shad_ctn_qty FORMAT ">>>9" COLUMN-LABEL "CTN"
		shad_ext_qty FORMAT ">>,>>>,>>9.9<" COLUMN-LABEL "QTY"
		shad_ctn_gw FORMAT ">>,>>>,>>9.9<" COLUMN-LABEL "KGS/CTN"
		shad_plt_gw FORMAT ">>,>>>,>>9.9<" COLUMN-LABEL "GW(KGS)"
		shad_plt_cbm FORMAT ">>,>>9.999" COLUMN-LABEL "Meas(CBM)"
	WITH FRAME frmbs DOWN WIDTH 106.
	
	FORM
		strCtn COLUMN-LABEL "Carton#"
		shad_part COLUMN-LABEL "Part No."
		shad_ponbr COLUMN-LABEL "P/O #"
		shad_qtyper FORMAT ">,>>>,>>9" COLUMN-LABEL "QTY/CTN"
		shad_ctn_qty FORMAT ">>>9" COLUMN-LABEL "CTN"
		shad_ext_qty FORMAT ">>,>>>,>>9.9<" COLUMN-LABEL "QTY"
		shad_ctn_gw FORMAT ">>,>>>,>>9.9<" COLUMN-LABEL "KGS/CTN"
		shad_plt_gw FORMAT ">>,>>>,>>9.9<" COLUMN-LABEL "GW(KGS)"
		shad_plt_cbm FORMAT ">>,>>9.999" COLUMN-LABEL "Meas(CBM)"
	WITH FRAME frmba DOWN WIDTH 106.
	
	FORM
		"----------------------------------------------" TO 106
		shah_ttl_ctn	TO 64	FORMAT ">>,>>9"
		shah_ttl_qty	TO 78	FORMAT ">>>,>>>,>>9.9<"
		shah_ttl_gw		TO 92	FORMAT ">>>,>>>,>>9.9<"
		shah_ttl_cmb	TO 106	FORMAT ">>>,>>9.999"
		"==============================================" TO 106
		SKIP(1)
		strTTLa	TO 14
		intTTL
		strTTLb
		SKIP(1)
		"TOTAL PAGE(S):"	TO 60
		intPage SKIP
	WITH FRAME pbottom NO-LABELS /*test* PAGE-BOTTOM*/ WIDTH 106.		/* or with xx down frame c */
	
	FOR EACH shah_hdr NO-LOCK WHERE shah_pinbr >= strNbr AND shah_pinbr <= strNbra
		AND (shah_shipvia = "s" OR shah_shipvia = "a")
		BREAK BY shah_pinbr:

		IF NOT FIRST(shah_pinbr) THEN PAGE.
		intPage = PAGE-NUMBER.
		
		IF shah_loc = "dc" THEN
			strTitle5 = "DC ITEMS".
		ELSE IF shah_loc = "main" THEN
			strTitle5 = "MAIN PLANT ITEMS".
		ELSE IF shah_loc = "" THEN
			strTitle5 = "".
		
		IF shah_etdhk <> ? THEN DO:
			strMonth = ENTRY(MONTH(shah_etdhk), "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").
			strDateR = STRING(DAY(shah_etdhk), "99") + " " + strMonth
				+ " " + STRING(YEAR(shah_etdhk), "9999").
		END.
		ELSE strDateR = "Invalid".
		strDateL = strDateR.
		strEta = shah_eta + " - " + strDateR.
		
		IF shah_consig = "C" THEN
			strTitle6 = "CONSIGNMENT MODELS".
		ELSE IF shah_consig = "" THEN
			strTitle6 = "".
		
		FORM HEADER
			strTitle1	TO 75
			strTitle2	TO 83
			strTitle3	TO 83
			SKIP(1)
			strTitle4	TO 65
			SKIP(1)
			strTitle5	TO 62
			"----------------"	TO 62
			strL1	TO 23	strR1	TO 81	shah_pinbr
			SKIP(1)
			strL2	TO 14	shah_forwarder	strR2	TO 81	strDateR
			strL3	TO 14	shah_desc_line1
			strL4	TO 14	shah_desc_line2	strR3	TO 81	PAGE-NUMBER FORMAT ">>9"
			strL5	TO 14	strDateL
			strL6	TO 14	strEta
			strL7	TO 14	shah_container	SKIP
			strTitle6	TO 64
			"------------------"	TO 64
			SKIP(1)
			strTitle7	TO 83
		WITH FRAME pheads PAGE-TOP WIDTH 106 NO-BOX.
		/*Kaine*  WITH STREAM-IO FRAME pheahs PAGE-TOP WIDTH 106 NO-BOX.  */
		
		FORM HEADER
			strTitle1	TO 75
			strTitle2	TO 83
			strTitle3	TO 83
			SKIP(1)
			strTitle4	TO 65
			SKIP(1)
			strTitle5	TO 62
			"----------------"	TO 62
			strL1	TO 23	strR1	TO 81	shah_pinbr
			SKIP(1)
			strL2a	TO 14	shah_forwarder	strR2	TO 81	strDateR
			strL3a	TO 14	shah_desc_line1
			strL4a	TO 14	shah_desc_line2	strR3	TO 81	PAGE-NUMBER
			strL5a	TO 14	shah_desc_line4
			strL6a	TO 14	strDateL	SKIP
			strTitle6	TO 64
			"------------------"	TO 64
			SKIP(1)
			strTitle7	TO 83
		WITH FRAME pheada PAGE-TOP WIDTH 106 NO-BOX.
		
		IF shah_shipvia = "s" THEN DO:
			VIEW FRAME pheads.
		END.
		ELSE IF shah_shipvia = "a" THEN DO:
			VIEW FRAME pheada.
		END.
		
		IF shah_shipvia = "s" THEN DO:
			FOR EACH shad_det WHERE shad_sanbr = shah_sanbr NO-LOCK:
				IF shad_type = "p" THEN DO:
					strPlt = STRING(shad_plt_nbr).
					DISPLAY
						shad_plt_gw
						shad_plt_cbm
					WITH FRAME frmbs.
				END.
				ELSE IF shad_type = "c" THEN DO:
					strPlt = STRING(shad_ctnnbr_fm) + "-" + STRING(shad_ctnnbr_to).
					DISPLAY
						shad_ctn_gw  @ shad_plt_gw
						shad_ctn_cbm @ shad_plt_cbm
					WITH FRAME frmbs.
				END.
				ELSE strPlt = "PPP".
				
				DISPLAY
					strPlt
					shad_part
					shad_ponbr
					shad_qtyper
					shad_ctn_qty
					shad_ext_qty
					shad_ctn_gw
				WITH FRAME frmbs.
				
				DOWN WITH FRAME frmbs.
			END.
			
			IF global_user_lang = "US" OR global_user_lang = "TW" THEN strTTLb = "PALLET(S) ONLY".
			/*lang*  ELSE IF global_user_lang = "CH" THEN strTTLb = "≈Ã".  */
			intTTL = shah_ttl_plt.
		END.
		ELSE IF shah_shipvia = "a" THEN DO:
			FOR EACH shad_det WHERE shad_sanbr = shah_sanbr NO-LOCK:
				IF shad_type = "p" THEN DO:
					strCtn = STRING(shad_plt_nbr).
					DISPLAY
						shad_plt_gw
						shad_plt_cbm
					WITH FRAME frmba.
				END.
				ELSE IF shad_type = "c" THEN DO:
					strCtn = STRING(shad_ctnnbr_fm) + "-" + STRING(shad_ctnnbr_to).
					DISPLAY
						shad_ctn_gw  @ shad_plt_gw
						shad_ctn_cbm @ shad_plt_cbm
					WITH FRAME frmba.
				END.
				ELSE strCtn = "CCC".

				DISPLAY
					strCtn
					shad_part
					shad_ponbr
					shad_qtyper
					shad_ctn_qty
					shad_ext_qty
					shad_ctn_gw
				WITH FRAME frmba.
				
				DOWN WITH FRAME frmba.
			END.
			
			IF global_user_lang = "US" OR global_user_lang = "TW" THEN strTTLb = "CARTON(S) ONLY".
			/*lang*  ELSE IF global_user_lang = "CH" THEN strTTLb = "∫–".  */
			intTTL = shah_ttl_ctn.
		END.
		
		intPage = PAGE-NUMBER - intPage + 1.
		
		DISPLAY
			shah_ttl_ctn
			shah_ttl_qty
			shah_ttl_gw
			shah_ttl_cmb
			strTTLa
			intTTL
			strTTLb
			/*test*  intPage  */  PAGE-NUMBER @ intPage
		WITH FRAME pbottom.
	END.