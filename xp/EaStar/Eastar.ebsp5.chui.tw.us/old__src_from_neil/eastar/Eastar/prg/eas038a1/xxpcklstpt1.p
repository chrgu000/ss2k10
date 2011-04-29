/* REVISION: EB SP5 Char   LAST MODIFIED: 03/19/04   BY: Kaine Zhang  *eas038* */

	{mfdeclre.i "  "}
	{gplabel.i}
	
	DEFINE SHARED VARIABLE strNbr		LIKE shah_pinbr.
	DEFINE SHARED VARIABLE strNbra		LIKE shah_pinbr.
	DEFINE SHARED VARIABLE blnPrtComp	AS   LOGICAL.
	
	DEFINE VARIABLE strTitle1	AS CHARACTER FORMAT "x(45)".
	DEFINE VARIABLE strTitle2	AS CHARACTER FORMAT "x(65)".
	DEFINE VARIABLE strTitle3	AS CHARACTER FORMAT "x(65)".
	DEFINE VARIABLE strTitle4	AS CHARACTER FORMAT "x(23)".
	DEFINE VARIABLE strTitle5	AS CHARACTER FORMAT "x(16)".
	DEFINE VARIABLE strTitle6	AS CHARACTER FORMAT "x(24)".
	DEFINE VARIABLE strTitle5_1	AS CHARACTER FORMAT "x(16)".
	DEFINE VARIABLE strTitle6_1	AS CHARACTER FORMAT "x(24)".
	DEFINE VARIABLE strTitle7	AS CHARACTER FORMAT "x(58)".
	
	DEFINE VARIABLE strL1		AS CHARACTER FORMAT "x(23)".
	DEFINE VARIABLE strL2		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL3		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL4		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL5		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL6		AS CHARACTER FORMAT "x(14)".
	DEFINE VARIABLE strL7		AS CHARACTER FORMAT "x(14)".
	
	DEFINE VARIABLE strR1		AS CHARACTER FORMAT "x(8)".
	DEFINE VARIABLE strR2		AS CHARACTER FORMAT "x(15)".
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
    define variable ctn-tt like shad_ctn_qty format ">>,>>9".
    define variable qty-tt like shad_ext_qty format ">>>,>>>,>>9.9".
    define variable gw-tt  like shad_plt_gw  format ">>>,>>9.99".
    define variable cbm-tt like shad_plt_cbm format ">>>,>>9.999".
    define VARIABLE eta_date as character format "x(11)".
define variable jj as integer.
define variable pages as integer.
define variable cbm# like shad_plt_cbm.
define temp-table xx_tmp
                  field xx_snnbr   like shad_snnbr
		  field xx_plt_nbr like shad_plt_nbr
		  field xx_sq      like shad_sq
		  field xx_sanbr   like shad_sanbr
		  field xx_cbm     like shad_plt_cbm
        index xx_nbr IS PRIMARY UNIQUE xx_plt_nbr ascending
		  .
	
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
			strR2		= "EX-FACTORY ATE:"
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
	ELSE IF global_user_lang = "CH" THEN DO:
		ASSIGN
			strTitle1	= "²âÊÔ±êÌâ1"
			strTitle2	= "²âÊÔ±êÌâ2"
			strTitle3	= "²âÊÔ±êÌâ3"
			strTitle4	= "²âÊÔ±êÌâ4"
			strTitle7	= "²âÊÔ±êÌâ7"
			strL1		= "×ó1"
			strL2		= "×ó2"
			strL3		= "×ó3"
			strL4		= "×ó4"
			strL5		= "×ó5"
			strL6		= "×ó6"
			strL7		= "×ó7"
			strR1		= "ÓÒ1"
			strR2		= "ÓÒ2"
			strR3		= "ÓÒ3"
			strL2a		= "×ó2a"
			strL3a		= "×ó3a"
			strL4a		= "×ó4a"
			strL5a		= "×ó5a"
			strL6a		= "×ó6a"
			strTTLa		= "×Ü"
			.
	END.
	*lang test*/
	
	FORM HEADER
        skip(2)
		strTitle1	AT 22
		strTitle2	AT 9
		strTitle3	AT 10
		SKIP(1)
	WITH FRAME pheadcomp PAGE-TOP WIDTH 80 NO-BOX.
    DEFINE VARIABLE t_title1 as CHARACTER init "".
    DEFINE VARIABLE t_title2 as CHARACTER init "".
    form header
        t_title1 at 2 no-label
        t_title2 at 2 no-label
    with frame pheadcomp1 page-top width 80 no-box.
	
	FORM
		strPlt COLUMN-LABEL "Pallet#" format "x(12)"
		shad_part COLUMN-LABEL "Part No."
		shad_qtyper FORMAT ">,>>>,>>9" COLUMN-LABEL "QTY/CTN"
		shad_ctn_qty FORMAT ">>>9" COLUMN-LABEL "CTN"
		shad_ext_qty FORMAT ">>,>>>,>>9.9" COLUMN-LABEL "QTY"
		shad_plt_gw FORMAT ">>,>>9.99" COLUMN-LABEL "GW(KGS)"
		shad_plt_cbm FORMAT ">>9.999" COLUMN-LABEL "Meas(CBM)"
/*@@@@@@@@		/*Kaine*/  SKIP  "PO No." AT 9  shad_ponbr  NO-LABEL */
	WITH FRAME frmbs DOWN WIDTH 90.
	
	FORM
		strCtn COLUMN-LABEL  /*Kaine* "Carton#" */  "Pallet#" format "x(12)"
		shad_part COLUMN-LABEL "Part No."
		shad_qtyper FORMAT ">,>>>,>>9" COLUMN-LABEL "QTY/CTN"
		shad_ctn_qty FORMAT ">>>9" COLUMN-LABEL "CTN"
		shad_ext_qty FORMAT ">>,>>>,>>9.9" COLUMN-LABEL "QTY"
		shad_plt_gw FORMAT ">>,>>9.99" COLUMN-LABEL "GW(KGS)"
		shad_plt_cbm FORMAT ">>9.999" COLUMN-LABEL "Meas(CBM)"
/*@@@@@@@@		/*Kaine*/  SKIP  "PO No." AT 9  shad_ponbr  NO-LABEL */
	WITH FRAME frmba DOWN WIDTH 90.
	
	FORM
		"------------------------------------------" TO 80
		shah_ttl_ctn	AT 41	FORMAT ">>,>>9"
		shah_ttl_qty	AT 47	FORMAT ">>>,>>>,>>9.9"
		shah_ttl_gw		AT 60	FORMAT ">>>,>>9.99"
		shah_ttl_cmb	AT 73	FORMAT ">>9.999"
		"==========================================" TO 80
		SKIP(1)
		strTTLa	AT 9
		intTTL
		strTTLb
		SKIP(1)
		"TOTAL PAGE(S):"	AT 20
		intPage SKIP
	WITH FRAME pbottom NO-LABELS /*test* PAGE-BOTTOM*/ WIDTH 90.		/* or with xx down frame c */

      pages = 0.
	
	FOR EACH shah_hdr NO-LOCK WHERE shah_pinbr >= strNbr AND shah_pinbr <= strNbra
		AND (shah_shipvia = "s" OR shah_shipvia = "a")
		BREAK BY shah_pinbr:

		IF NOT FIRST(shah_pinbr) THEN PAGE.
		intPage = PAGE-NUMBER.
		
		IF blnPrtComp = YES THEN VIEW FRAME pheadcomp.
        else view frame pheadcomp1.
		
		IF shah_loc = "dc" THEN
			assign strTitle5 = "DC ITEMS" strTitle5_1 = "--------" .
		ELSE IF shah_loc = "main" THEN
			assign strTitle5 = "MAIN PLANT ITEMS" strTitle5_1 = "----------------" .
		ELSE IF shah_loc = "" THEN
			assign strTitle5 = "" strTitle5_1 = "".
		
		/* micho B */
		/*
		IF shah_etdhk <> ? THEN DO:
			strMonth = ENTRY(MONTH(shah_etdhk), "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").
			strDateR = STRING(DAY(shah_etdhk), "99") + " " + strMonth
				+ " " + STRING(YEAR(shah_etdhk), "9999").
		END.
		ELSE strDateR = "Invalid".
		strDateL = strDateR.
		*/

                IF shah_dte01 <> ? THEN DO:
			strMonth = ENTRY(MONTH(shah_dte01), "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").
			strDateR = STRING(DAY(shah_dte01), "99") + " " + strMonth
				+ " " + STRING(YEAR(shah_dte01), "9999").
		END.
		ELSE strDateR = "Invalid".

	        IF shah_etdhk <> ? THEN DO:
			strMonth = ENTRY(MONTH(shah_etdhk), "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").
			strDateL = STRING(DAY(shah_etdhk), "99") + " " + strMonth
				+ " " + STRING(YEAR(shah_etdhk), "9999").
		END.
		ELSE strDateL = "Invalid".
                /* micho E */


		IF shah_etdhk <> ? THEN DO:
			strMonth = ENTRY(MONTH(shah_eta_date), "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").
			eta_date = STRING(DAY(shah_eta_date), "99") + " " + strMonth
				+ " " + STRING(YEAR(shah_eta_date), "9999").
		END.
		ELSE eta_date = "Invalid".
		strEta = shah_eta + " - " + eta_date.
		
		IF shah_consig = "C" THEN
			assign strTitle6 = "CONSIGNMENT MODELS" strTitle6_1 = "------------------".
		ELSE /*IF shah_consig = "" THEN*/
			assign strTitle6 = "" strTitle6_1 = "----------------------".
		
		FORM HEADER
			strTitle4	AT 28
			SKIP(1)
			strTitle5	AT 32
			strTitle5_1	AT 32
			strL1	TO 23	strR1	AT 58	shah_pinbr
			SKIP(1)
			strL2	TO 14	shah_forwarder format "x(28)" /* micho */	
			strR2	AT 51	strDateR
			strL3	TO 14	shah_desc_line1
			strL4	TO 14	shah_desc_line2	strR3	AT 61	PAGE-NUMBER - pages FORMAT ">>9"
			strL5	TO 14	strDateL
			strL6	TO 14	strEta
			strL7	TO 14	shah_container	SKIP
			strTitle6	at 32
			strTitle6_1	at 32
			SKIP(1)
			strTitle7	AT 11
		WITH FRAME pheads PAGE-TOP WIDTH 106 NO-BOX.
		/*Kaine*  WITH STREAM-IO FRAME pheahs PAGE-TOP WIDTH 106 NO-BOX.  */
		
		FORM HEADER
			strTitle4	AT 28
			SKIP(1)
			strTitle5	AT 32
			strTitle5_1	AT 32
			strL1	TO 23	strR1	AT 58	shah_pinbr
			SKIP(1)
			strL2a	TO 14	shah_forwarder format "x(28)" /* micho */	
			strR2	AT 61	strDateR
			strL3a	TO 14	shah_desc_line1
			strL4a	TO 14	shah_desc_line2	strR3	AT 61	PAGE-NUMBER - pages FORMAT ">>9"
			strL5a	TO 14	shah_desc_line4
			strL6a	TO 14	strDateL	SKIP
			strTitle6	TO 48
			strTitle6_1	TO 48
			SKIP(1)
			strTitle7	AT 11
		WITH FRAME pheada PAGE-TOP WIDTH 106 NO-BOX.
		
		IF shah_shipvia = "s" THEN DO:
			VIEW FRAME pheads.
		END.
		ELSE IF shah_shipvia = "a" THEN DO:
			VIEW FRAME pheada.
		END.

/*@@@@@@@@ add begin         */
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

/*@@@@@@@@ add end */         



		IF shah_shipvia = "s" THEN DO:
			FOR EACH shad_det WHERE shad_sanbr = shah_sanbr and shad_ctn_line > 0 NO-LOCK break by shad_sanbr by shad_type desc :
           		 cbm# = shad_ctn_qty * shad_ctn_cbm.
                 find first xx_tmp where xx_sanbr = shad_sanbr and xx_plt_nbr = shad_plt_nbr no-error.
                 if available xx_tmp then cbm# = xx_cbm.

				IF shad_type = "p" THEN DO:
					strPlt = "    " + trim(STRING(shad_plt_nbr)).
					DISPLAY
						shad_ctn_ext_gw @ shad_plt_gw
						cbm#  @ shad_plt_cbm
					WITH FRAME frmbs.
				END.
				ELSE IF shad_type = "c" THEN DO:
					strPlt = "C/No" + STRING(shad_ctnnbr_fm,"999") + "-" + STRING(shad_ctnnbr_to,"999").
					DISPLAY
						shad_ctn_ext_gw @ shad_plt_gw
						cbm#  @ shad_plt_cbm
					WITH FRAME frmbs.
				END.
				ELSE strPlt = "PPP".
				
				DISPLAY
					strPlt
					shad_part
					shad_qtyper
					shad_ctn_qty
					shad_ext_qty
/*@@@@@@@@					/*Kaine*/  shad_ponbr */
				WITH FRAME frmbs.
				
				DOWN WITH FRAME frmbs.
                put "Po No.: " + shad_ponbr format "x(20)" at 14.
	     ctn-tt = ctn-tt + shad_ctn_qty.
	     qty-tt = qty-tt + shad_ext_qty .
	     gw-tt  = gw-tt  + shad_ctn_ext_gw.
	     cbm-tt = cbm-tt + cbm#.
			END.
			
			IF global_user_lang = "US" OR global_user_lang = "TW" THEN strTTLb = "PALLET(S) ONLY".
			/*lang*  ELSE IF global_user_lang = "CH" THEN strTTLb = "ÅÌ".  */
			intTTL = shah_ttl_plt.
		END.
		ELSE IF shah_shipvia = "a" THEN DO:
			FOR EACH shad_det WHERE shad_sanbr = shah_sanbr and shad_ctn_line > 0 NO-LOCK break by shad_sanbr by shad_type desc :
           		 cbm# = shad_ctn_qty * shad_ctn_cbm.
                 find first xx_tmp where xx_sanbr = shad_sanbr and xx_plt_nbr = shad_plt_nbr no-error.
                 if available xx_tmp then cbm# = xx_cbm.

				IF shad_type = "p" THEN DO:
					strCtn = "    " + STRING(shad_plt_nbr).
					DISPLAY
						shad_ctn_ext_gw @ shad_plt_gw
						cbm#  @ shad_plt_cbm
					WITH FRAME frmba.
				END.
				ELSE IF shad_type = "c" THEN DO:
					strCtn = "C/No" + STRING(shad_ctnnbr_fm,"999") + "-" + STRING(shad_ctnnbr_to,"999").
					DISPLAY
						shad_ctn_ext_gw @ shad_plt_gw
						cbm#  @ shad_plt_cbm
					WITH FRAME frmba.
				END.
				ELSE strCtn = "CCC".

				DISPLAY
					strCtn
					shad_part
					shad_qtyper
					shad_ctn_qty
					shad_ext_qty
/*@@@@@@@@					/*Kaine*/  shad_ponbr */
				WITH FRAME frmba.
				
				DOWN WITH FRAME frmba.
                put "Po No.: " + shad_ponbr format "x(20)" at 14.
	     ctn-tt = ctn-tt + shad_ctn_qty.
	     qty-tt = qty-tt + shad_ext_qty .
	     gw-tt  = gw-tt  + shad_ctn_ext_gw.
	     cbm-tt = cbm-tt + cbm#.
			END.
			
			IF global_user_lang = "US" OR global_user_lang = "TW" THEN strTTLb = "PALLET(S) ONLY".
			/*lang*  ELSE IF global_user_lang = "CH" THEN strTTLb = "ºÐ".  */
			intTTL = shah_ttl_plt.
		END.
		
/*@@@@@@@@		intPage = PAGE-NUMBER - intPage + 1. */
		
		DISPLAY
			ctn-tt @ shah_ttl_ctn
			qty-tt @ shah_ttl_qty
			gw-tt  @ shah_ttl_gw
			cbm-tt @ shah_ttl_cmb
			strTTLa
			intTTL
			strTTLb
			/*test*  intPage  */  PAGE-NUMBER - pages @ intPage
		WITH FRAME pbottom.
        pages = page-number .
	END.