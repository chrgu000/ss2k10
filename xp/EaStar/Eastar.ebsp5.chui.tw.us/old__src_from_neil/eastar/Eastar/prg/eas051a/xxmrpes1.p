/* xxmrpes1.p mrp report */
/* eB SP5 Linux US    Created By: Kaine Zhang 11/28/05 *eas051a* */

{mfdtitle.i}

DEFINE VARIABLE i			AS		INTEGER.
DEFINE VARIABLE ii			AS		INTEGER.
DEFINE VARIABLE blnFormat	AS		LOGICAL FORMAT "1/2"	INITIAL YES.

DEFINE VARIABLE blnOnlyWeek	AS		LOGICAL.
DEFINE VARIABLE datWeekBg	AS		DATE	EXTENT 8.
DEFINE VARIABLE datMthBg	AS		DATE	EXTENT 36.
DEFINE VARIABLE datMthEnd	AS		DATE.
DEFINE VARIABLE intMaxWeek	AS		INTEGER.
DEFINE VARIABLE intMaxMth	AS		INTEGER.

DEFINE VARIABLE strKeGong AS CHARACTER FORMAT "x(4)".
DEFINE VARIABLE strNoPlan AS CHARACTER FORMAT "x(7)".
DEFINE VARIABLE strIssPolicy AS CHARACTER FORMAT "x(10)".

DEFINE VARIABLE decReInQtyoh LIKE in_qty_oh.
DEFINE VARIABLE decWh100Qty	AS		DECIMAL	FORMAT "->>>>>>>9.99".

{xxmrpesvar.i}

DEFINE NEW SHARED WORK-TABLE xtpar_mstr
	FIELD xtpar_part	LIKE pt_part
	.
	
DEFINE NEW SHARED WORK-TABLE xtsub_mstr
	FIELD xtsub_part	LIKE pt_part
	.


FORM
	strBomA		LABEL "Bom/Formula"		COLON 15
	strBomB		LABEL "To"				COLON 50
	strPartA	LABEL "Item Number"		COLON 15
	strPartB	LABEL "To"				COLON 50
	strSiteA	LABEL "Site"			COLON 15
	strSiteB	LABEL "To"				COLON 50
	strBuyer	LABEL "Buyer/Planner"	COLON 40
	strPdLn		LABEL "Prod Line"		COLON 40
	strPtGroup	LABEL "Group"			COLON 40
	strVendor	LABEL "Supplier"		COLON 40
	strPMcode	LABEL "Purchase/Manufacture"		COLON 40
	blnZero		LABEL "Include Zero Requirements"	COLON 40
	blnReplace	LABEL "Print Substitute Items"		COLON 40
	blnFormat	LABEL "Report Format"	COLON 40
	datBg		LABEL "Start Date"		COLON 40
	datEd		LABEL "End Date"		COLON 40
WITH FRAME a SIDE-LABEL WIDTH 80 .
setFrameLabels(FRAME a:HANDLE).


FOR FIRST mrpc_ctrl NO-LOCK:    END.
datBg = TODAY.
IF AVAILABLE mrpc_ctrl THEN DO:
	IF (mrpc_sum_def > 0) AND (mrpc_sum_def < 8) THEN
	DO WHILE NOT (WEEKDAY(datBg) = mrpc_sum_def):
		datBg = datBg - 1.
	END.
END.

REPEAT:
	IF strBomB = hi_char THEN strBomB = "".
	IF strPartB = hi_char THEN strPartB = "".
	IF strSiteB = hi_char THEN strSiteB = "".
	IF datBg = ? THEN datBg = TODAY  .
	IF datEd = hi_date THEN datEd = ?  .

	UPDATE
		strBomA
		strBomB
		strPartA
		strPartB
		strSiteA
		strSiteB
		strBuyer
		strPdLn
		strPtGroup
		strVendor
		strPMcode
		blnZero
		blnReplace
		blnFormat
		datBg
		datEd
	WITH FRAME a.

	bcdparm = "".
	{mfquoter.i strBomA		}
	{mfquoter.i strBomB		}
	{mfquoter.i strPartA	}
	{mfquoter.i strPartB	}
	{mfquoter.i strSiteA	}
	{mfquoter.i strSiteB	}
	{mfquoter.i strBuyer	}
	{mfquoter.i strPdLn		}
	{mfquoter.i strPtGroup	}
	{mfquoter.i strVendor	}
	{mfquoter.i strPMcode	}
	{mfquoter.i blnZero		}
	{mfquoter.i blnReplace	}
	{mfquoter.i blnFormat	}
	{mfquoter.i datBg		}
	{mfquoter.i datEd		}

	IF strBomB = "" THEN strBomB = hi_char.
	IF strPartB = "" THEN strPartB = hi_char.
	IF strSiteB = "" THEN strSiteB = hi_char.
	IF datBg = ? THEN datBg = TODAY  .
	IF datEd = ? THEN datEd = hi_date.

	{mfselbpr.i "printer" 132}

	FOR EACH xtpar_mstr:
		DELETE xtpar_mstr.
	END.
	
	FOR EACH xtsub_mstr:
		DELETE xtsub_mstr.
	END.
	
	FOR EACH xtmrp_tmp:
		DELETE xtmrp_tmp.
	END.
	
	FOR EACH xtps_mrp:
		DELETE xtps_mrp.
	END.
	
	FOR EACH pt_mstr FIELDS(pt_part pt_part_type)
		WHERE pt_part_type >= strBomA AND pt_part_type <= strBomB
			AND pt_part >= strPartA AND pt_part <= strPartB
		NO-LOCK:
		CREATE xtpar_mstr.
		xtpar_part = pt_part.
	END.

	IF NOT (strBomA = "" AND strBomB = hi_char AND strPartA = "" AND strPartB = hi_char) THEN DO:
		{gprun.i ""xxmrppsiq.p""}
	END.
	
	blnOnlyWeek = NO.
	intMaxWeek = 8.
	datWeekBg[1] = datBg.
	DO i = 1 TO 7:
		IF datWeekBg[i] + 7 > datEd THEN DO:
			blnOnlyWeek = YES.
			intMaxWeek = i.
			LEAVE.
		END.
		datWeekBg[i + 1] = datWeekBg[i] + 7.
	END.

	datWeekEnd = datBg + 55  .
	IF datWeekEnd >= datEd THEN DO:
		blnOnlyWeek = YES.
	END.


	datMthBg[1] = datWeekEnd + 1.
	DO i = 1 TO 35:
		IF MONTH(datMthBg[i]) = 12 THEN datMthBg[i + 1] = DATE(1, 1, YEAR(datMthBg[i]) + 1).
		ELSE datMthBg[i + 1] = DATE(MONTH(datMthBg[i]) + 1, 1, YEAR(datMthBg[i])).
	END.
	
	intMaxMth = 36.
	DO i = 2 TO 36:
		IF datMthBg[i] > datEd THEN DO:
			intMaxMth = i - 1  .
			LEAVE.
		END.
	END.


	{xxcrxtmrp.i}

	ii = intMaxMth.
	MaxmthLoop:
	DO i = ii TO 1 BY -1:
		IF CAN-FIND(FIRST xtmrp_tmp WHERE xtmrp_reqmth[i] <> 0 OR xtmrp_podmth[i] <> 0
			OR xtmrp_prmth[i] <> 0 NO-LOCK)
		THEN DO:
			LEAVE MaxmthLoop.
		END.
		ELSE DO:
			IF i >= 2 THEN intMaxMth = i - 1.
			ELSE blnOnlyWeek = YES.
		END.
	END.

	
	IF blnReplace = YES THEN DO:
		FOR EACH xtmrp_tmp,
		EACH pts_det WHERE pts_part = xtmrp_part NO-LOCK:
			
			FIND FIRST xtps_mrp WHERE xtps_part = pts_sub_part AND xtps_site = xtmrp_site NO-ERROR.
			
			IF NOT AVAILABLE xtps_mrp THEN DO:
				CREATE xtps_mrp.
				ASSIGN
					xtps_part	= pts_sub_part
					xtps_site	= xtmrp_site
					.
				
				FOR FIRST in_mstr WHERE in_part = xtps_part AND in_site = xtps_site NO-LOCK:    END.
				IF AVAILABLE in_mstr THEN xtps_qtyoh = in_qty_oh.
				
				FOR EACH mrp_det WHERE mrp_part = xtps_part AND mrp_site = xtps_site
					AND mrp_due_date >= datBg AND mrp_due_date <= datEd
					NO-LOCK:
					
					IF LOOKUP(mrp_dataset, "sod_det,wod_det,fcs_sum,pfc_det,wo_scrap,demand") > 0
					THEN DO:
						xtps_req = xtps_req + mrp_qty.
					END.
					
					IF mrp_type = "supply" THEN DO:
						IF mrp_dataset = "pod_det" THEN DO:
							xtps_pod = xtps_pod + mrp_qty.
						END.
						ELSE IF mrp_dataset = "wo_mstr" THEN DO:
							FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
							IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
								xtps_pod = xtps_pod + mrp_qty.
						END.
					END.
					ELSE IF (mrp_type = "supplyf" OR mrp_type = "supplyp") THEN DO:
						IF mrp_dataset = "wo_mstr" THEN DO:
							FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
							IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
								xtps_pod = xtps_pod + mrp_qty.
						END.
					END.
				END.
			END.
			
		END.
	END.

	
	
	
	FOR EACH xtmrp_tmp  /*Kaine*  ,  */  
	/*Kaine*  EACH pt_mstr FIELDS(pt_part pt_desc1 pt_desc2 pt_um pt_pur_lead pt_ord_min) WHERE pt_part = xtmrp_part NO-LOCK  */
	BREAK BY xtmrp_site BY xtmrp_part:
		
		FOR FIRST pt_mstr FIELDS(pt_part pt_desc1 pt_desc2 pt_um pt_pur_lead pt_ord_min pt_group pt_plan_ord pt_ms pt_iss_pol)
			WHERE pt_part = xtmrp_part NO-LOCK:
		END.
		
		IF pt_group = "CS" THEN strKeGong = "CS".
		ELSE strKeGong = "".
		
		IF (pt_plan_ord = NO AND pt_ms = NO) THEN strNoPlan = "N".
		ELSE strNoPlan = "".
		
		IF pt_iss_pol = NO THEN strIssPolicy = "N".
		ELSE strIssPolicy = "".
		
		decWh100Qty = 0.
		FOR EACH ld_det WHERE ld_part = xtmrp_part AND ld_site = xtmrp_site AND ld_loc = "WH100" NO-LOCK:
			decWh100Qty = decWh100Qty + ld_qty_oh.
		END.
		
		xtmrp_qoh_o = xtmrp_qty_oh - xtmrp_req_ps + xtmrp_recpts_ps.
		xtmrp_qohwk[1] = xtmrp_qoh_o - xtmrp_reqwk[1] + xtmrp_podwk[1].
		DO i = 2 TO 8:
			xtmrp_qohwk[i] = xtmrp_qohwk[i - 1] - xtmrp_reqwk[i] + xtmrp_podwk[i].
		END.
		xtmrp_qohmth[1] = xtmrp_qohwk[8] - xtmrp_reqmth[1] + xtmrp_podmth[1].
		DO i = 2 TO 36:
			xtmrp_qohmth[i] = xtmrp_qohmth[i - 1] - xtmrp_reqmth[i] + xtmrp_podmth[i].
		END.

		IF FIRST-OF(xtmrp_site) THEN DO:
			IF NOT FIRST(xtmrp_site) THEN DO:
				PAGE.
			END.

			PUT "Site: " AT 1 xtmrp_site SKIP.
			
			{xxmrptitle1.i}
		END.

		IF PAGE-SIZE - LINE-COUNTER <= 1 THEN DO:
			PAGE.
			{xxmrptitle1.i}
		END.
		
		IF blnFormat = YES THEN DO:
			PUT
				xtmrp_part AT 1 SPACE(1)
				(pt_desc1 + pt_desc2) FORMAT "x(48)" SPACE(1)
				pt_um SPACE(1)
				pt_pur_lead FORMAT ">>>>>>>9.99" SPACE(1)
				strKeGong SPACE(1)
				strNoPlan SPACE(1)
				strIssPolicy SPACE(1)
				pt_ord_min FORMAT "->>>>>>>>9.99" SPACE(1)
				xtmrp_qty_oh FORMAT "->>>>>>>>>>9.99" SPACE(1)
				decWh100Qty SPACE(1)
				.

			PUT
				xtmrp_req_ps FORMAT "->>>>>>9.99" SPACE(1)
				xtmrp_recpts_ps	FORMAT "->>>>>>>9.99" SPACE(1)
				xtmrp_qoh_o		FORMAT "->>>>>>>>>>9.99"
				.
				
			DO i = 1 TO 8:
				PUT
					SPACE(1) xtmrp_reqwk[i] FORMAT "->>>>>>9.99"
					SPACE(1) xtmrp_podwk[i] FORMAT "->>>>>>>9.99"
					SPACE(1) xtmrp_qohwk[i] FORMAT "->>>>>>>>>>9.99"
					.
			END.

			IF blnOnlyWeek = NO THEN DO:
				DO i = 1 TO intMaxMth:
					PUT
						SPACE(1) xtmrp_reqmth[i] FORMAT "->>>>>>9.99"
						SPACE(1) xtmrp_podmth[i] FORMAT "->>>>>>>9.99"
						SPACE(1) xtmrp_qohmth[i] FORMAT "->>>>>>>>>>9.99"
						.
				END.
			END.
		END.
		ELSE DO:
			PUT
				xtmrp_part AT 1 SPACE(1)
				(pt_desc1 + pt_desc2) FORMAT "x(48)" SPACE(1)
				pt_um SPACE(1)
				pt_pur_lead FORMAT ">>>>>>>9.99" SPACE(1)
				strKeGong SPACE(1)
				strNoPlan SPACE(1)
				strIssPolicy SPACE(1)
				pt_ord_min FORMAT "->>>>>>>>9.99" SPACE(1)
				xtmrp_qty_oh FORMAT "->>>>>>>>>>9.99" SPACE(1)
				decWh100Qty SPACE(1)
				.

			PUT
				xtmrp_req_ps FORMAT "->>>>>>9.99" SPACE(1)
				xtmrp_recpts_ps	FORMAT "->>>>>>>9.99" SPACE(1)
				xtmrp_pr_ps FORMAT "->>>>>>9.99" SPACE(1)
				xtmrp_qoh_o		FORMAT "->>>>>>>>>>9.99"
				.
				
			DO i = 1 TO 8:
				PUT
					SPACE(1) xtmrp_reqwk[i] FORMAT "->>>>>>9.99"
					SPACE(1) xtmrp_podwk[i] FORMAT "->>>>>>>9.99"
					SPACE(1) xtmrp_prwk[i] FORMAT "->>>>>>9.99"
					SPACE(1) xtmrp_qohwk[i] FORMAT "->>>>>>>>>>9.99"
					.
			END.

			IF blnOnlyWeek = NO THEN DO:
				DO i = 1 TO intMaxMth:
					PUT
						SPACE(1) xtmrp_reqmth[i] FORMAT "->>>>>>9.99"
						SPACE(1) xtmrp_podmth[i] FORMAT "->>>>>>>9.99"
						SPACE(1) xtmrp_prmth[i] FORMAT "->>>>>>9.99"
						SPACE(1) xtmrp_qohmth[i] FORMAT "->>>>>>>>>>9.99"
						.
				END.
			END.
		END.
		
		PUT SPACE(1) xtmrp_rmks.
		
		IF blnReplace = YES THEN DO:
			FOR EACH pts_det WHERE pts_part = xtmrp_part NO-LOCK:
				IF PAGE-SIZE - LINE-COUNTER <= 1 THEN DO:
					PAGE.
					{xxmrptitle1.i}
				END.
				
				FOR FIRST pt_mstr WHERE pt_part = pts_sub_part NO-LOCK:    END.
				FOR FIRST xtps_mrp WHERE xtps_part = pts_sub_part AND xtps_site = xtmrp_site:    END.

				PUT
					pt_part AT 4 SPACE(1)
					pt_desc1 SPACE(1)
					pt_desc2 SPACE(1)
					pts_qty_per SPACE(1)
					"(Substitute Item)In Warehouse:" AT 91
					xtps_qtyoh FORMAT "->>>>>>>>>>9.99" AT 122 ";" SPACE(1)
					"(Substitute Item)Gross Qty: " xtps_req ";" SPACE(1)
					"(Substitute Item)Qty On Order: " xtps_pod ";" SPACE(1)
					"----par item: "
					.
				
				FIND pt_mstr no-lock where pt_part = pts_par no-error.
				if available pt_mstr then do:
					PUT
						pt_part SPACE(1)
						pt_desc1 SPACE(1)
						pt_desc2
						.
      			END.
			END.
		END.
	END.

	{mfreset.i}
	{mfgrptrm.i}
END.
