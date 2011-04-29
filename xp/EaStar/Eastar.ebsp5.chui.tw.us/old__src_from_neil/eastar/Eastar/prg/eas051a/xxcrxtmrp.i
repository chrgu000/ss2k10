/* eB SP5 Linux US    Created By: Kaine Zhang 11/28/05 *eas051a* */

	FOR EACH si_mstr NO-LOCK WHERE si_site >= strSiteA AND si_site <= strSiteB,
	EACH pt_mstr NO-LOCK WHERE CAN-FIND(FIRST xtpar_mstr WHERE xtpar_part = pt_part NO-LOCK)
		OR CAN-FIND(FIRST xtsub_mstr WHERE xtsub_part = pt_part NO-LOCK)
		:
		
		IF (pt_prod_line = strPdLn OR strPdLn = "")
			AND (pt_group = strPtGroup OR strPtGroup = "")
		THEN DO:
			FIND ptp_det NO-LOCK WHERE ptp_part = pt_part AND ptp_site = si_site NO-ERROR.
            IF AVAILABLE ptp_det THEN DO:
				IF (ptp_buyer <> strBuyer and strBuyer <> "" )
					OR (ptp_vend <> strVendor AND strVendor <> "" )
					OR (ptp_pm_code <> strPMcode AND strPMcode <> "" )
				THEN NEXT.
			END.
			ELSE DO:
				IF (pt_buyer <> strBuyer and strBuyer <> "" )
					OR (pt_vend <> strVendor and strVendor <> "" )
					OR (pt_pm_code <> strPMcode and strPMcode <> "" )
				THEN NEXT.
			END.
			
			IF blnZero = YES THEN DO:
				FIND FIRST xtmrp_tmp WHERE xtmrp_part = pt_part
					AND xtmrp_site = si_site NO-ERROR.
				IF NOT AVAILABLE xtmrp_tmp THEN DO:
					CREATE xtmrp_tmp.
					ASSIGN
						xtmrp_part = pt_part
						xtmrp_site = si_site
						.
					FOR FIRST in_mstr WHERE in_part = pt_part
						AND in_site = si_site NO-LOCK:
					END.
					IF AVAILABLE in_mstr THEN xtmrp_qty_oh = in_qty_oh.
				END.
			END.
			
			FOR EACH mrp_det WHERE mrp_part = pt_part
				AND mrp_site = si_site
				AND mrp_due_date <= datEd
				USE-INDEX mrp_site_due
				NO-LOCK:
				
				FIND FIRST xtmrp_tmp WHERE xtmrp_part = mrp_part
					AND xtmrp_site = mrp_site NO-ERROR.
				
				IF NOT AVAILABLE xtmrp_tmp THEN DO:
					CREATE xtmrp_tmp.
					ASSIGN
						xtmrp_part = mrp_part
						xtmrp_site = mrp_site
						.
					FOR FIRST in_mstr WHERE in_part = xtmrp_part
						AND in_site = xtmrp_site NO-LOCK:
					END.
					IF AVAILABLE in_mstr THEN xtmrp_qty_oh = in_qty_oh.
				END.
				
				IF mrp_due_date < datBg THEN DO:
					IF LOOKUP(mrp_dataset, "sod_det,wod_det,fcs_sum,pfc_det,wo_scrap,demand") > 0
					THEN DO:
						xtmrp_req_ps = xtmrp_req_ps + mrp_qty.
					END.
					
					IF mrp_type = "supply" THEN DO:
						IF mrp_dataset = "pod_det" THEN DO:
							xtmrp_recpts_ps = xtmrp_recpts_ps + mrp_qty.
							FOR FIRST pod_det WHERE pod_nbr = mrp_nbr AND STRING(pod_line) = mrp_line NO-LOCK:    END.
							IF AVAILABLE pod_det THEN DO:
								xtmrp_rmks = xtmrp_rmks + TRIM(pod_nbr) + "#" + TRIM(STRING(pod_qty_ord, "->>>>>>9"))
									+ "#" + STRING(pod_due_date) + "#" + STRING(pod_per_date) + ",".
							END.
						END.
						ELSE IF mrp_dataset = "wo_mstr" THEN DO:
							FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
							IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
								xtmrp_recpts_ps = xtmrp_recpts_ps + mrp_qty.
						END.
					END.
					ELSE IF (mrp_type = "supplyf" OR mrp_type = "supplyp") THEN DO:
						IF mrp_dataset = "wo_mstr" THEN DO:
							FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
							IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
								xtmrp_recpts_ps = xtmrp_recpts_ps + mrp_qty.
						END.
						ELSE IF mrp_dataset = "req_det" THEN DO:
							xtmrp_pr_ps = xtmrp_pr_ps + mrp_qty.
						END.
					END.
				END.
				ELSE DO:
					DO i = 1 TO 8:
						IF mrp_due_date >= datWeekBg[i] AND mrp_due_date <= datWeekBg[i] + 6
						THEN DO:
							IF LOOKUP(mrp_dataset, "sod_det,wod_det,fcs_sum,pfc_det,wo_scrap,demand") > 0
							THEN DO:
								xtmrp_reqwk[i] = xtmrp_reqwk[i] + mrp_qty.
							END.
							
							IF mrp_type = "supply" THEN DO:
								IF mrp_dataset = "pod_det" THEN DO:
									xtmrp_podwk[i] = xtmrp_podwk[i] + mrp_qty.
									FOR FIRST pod_det WHERE pod_nbr = mrp_nbr AND STRING(pod_line) = mrp_line NO-LOCK:    END.
									IF AVAILABLE pod_det THEN DO:
										xtmrp_rmks = xtmrp_rmks + TRIM(pod_nbr) + "#" + TRIM(STRING(pod_qty_ord, "->>>>>>9"))
											+ "#" + STRING(pod_due_date) + "#" + STRING(pod_per_date) + ",".
									END.
								END.
								ELSE IF mrp_dataset = "wo_mstr" THEN DO:
									FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
									IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
										xtmrp_podwk[i] = xtmrp_podwk[i] + mrp_qty.
								END.
							END.
							ELSE IF (mrp_type = "supplyf" OR mrp_type = "supplyp") THEN DO:
								IF mrp_dataset = "req_det" THEN
									xtmrp_prwk[i] = xtmrp_prwk[i] + mrp_qty.
								ELSE IF mrp_dataset = "wo_mstr" THEN DO:
									FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
									IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
										xtmrp_podwk[i] = xtmrp_podwk[i] + mrp_qty.
								END.
							END.
						END.
					END.
					
					IF mrp_due_date >= datMthBg[1] THEN DO:
						DO i = 1 TO 35:
							IF mrp_due_date >= datMthBg[i] AND mrp_due_date < datMthBg[i + 1]
							THEN DO:
								IF LOOKUP(mrp_dataset, "sod_det,wod_det,fcs_sum,pfc_det,wo_scrap,demand") > 0
								THEN DO:
									xtmrp_reqmth[i] = xtmrp_reqmth[i] + mrp_qty.
								END.
								
								IF mrp_type = "supply" THEN DO:
									IF mrp_dataset = "pod_det" THEN DO:
										xtmrp_podmth[i] = xtmrp_podmth[i] + mrp_qty.
										FOR FIRST pod_det WHERE pod_nbr = mrp_nbr AND STRING(pod_line) = mrp_line NO-LOCK:    END.
										IF AVAILABLE pod_det THEN DO:
											xtmrp_rmks = xtmrp_rmks + TRIM(pod_nbr) + "#" + TRIM(STRING(pod_qty_ord, "->>>>>>9"))
												+ "#" + STRING(pod_due_date) + "#" + STRING(pod_per_date) + ",".
										END.
									END.
									ELSE IF mrp_dataset = "wo_mstr" THEN DO:
										FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
										IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
											xtmrp_podmth[i] = xtmrp_podmth[i] + mrp_qty.
									END.
								END.
								ELSE IF (mrp_type = "supplyf" OR mrp_type = "supplyp") THEN DO:
									IF mrp_dataset = "req_det" THEN
										xtmrp_prmth[i] = xtmrp_prmth[i] + mrp_qty.
									ELSE IF mrp_dataset = "wo_mstr" THEN DO:
										FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
										IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
											xtmrp_podmth[i] = xtmrp_podmth[i] + mrp_qty.
									END.
								END.
							END.
						END.
						
						IF mrp_due_date >= datMthBg[36] THEN DO:
							IF LOOKUP(mrp_dataset, "sod_det,wod_det,fcs_sum,pfc_det,wo_scrap,demand") > 0
							THEN DO:
								xtmrp_reqmth[36] = xtmrp_reqmth[36] + mrp_qty.
							END.
								
							IF mrp_type = "supply" THEN DO:
								IF mrp_dataset = "pod_det" THEN DO:
									xtmrp_podmth[36] = xtmrp_podmth[36] + mrp_qty.
									FOR FIRST pod_det WHERE pod_nbr = mrp_nbr AND STRING(pod_line) = mrp_line NO-LOCK:    END.
									IF AVAILABLE pod_det THEN DO:
										xtmrp_rmks = xtmrp_rmks + TRIM(pod_nbr) + "#" + TRIM(STRING(pod_qty_ord, "->>>>>>9"))
											+ "#" + STRING(pod_due_date) + "#" + STRING(pod_per_date) + ",".
									END.
								END.
								ELSE IF mrp_dataset = "wo_mstr" THEN DO:
									FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
									IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
										xtmrp_podmth[36] = xtmrp_podmth[36] + mrp_qty.
								END.
							END.
							ELSE IF (mrp_type = "supplyf" OR mrp_type = "supplyp") THEN DO:
								IF mrp_dataset = "req_det" THEN
									xtmrp_prmth[36] = xtmrp_prmth[36] + mrp_qty.
								ELSE IF mrp_dataset = "wo_mstr" THEN DO:
									FOR FIRST wo_mstr WHERE wo_lot = mrp_line NO-LOCK:    END.
									IF AVAILABLE wo_mstr AND wo_status <> "P" THEN
										xtmrp_podmth[36] = xtmrp_podmth[36] + mrp_qty.
								END.
							END.

						END.
					END.
					
				END.
			END.
			
			FOR EACH wo_mstr WHERE wo_part = pt_part AND wo_site = si_site
				AND wo_due_date <= datEd
				AND wo_status = "P"
				AND wo_joint_type = ""
				USE-INDEX wo_part
				NO-LOCK:
				
				FIND FIRST xtmrp_tmp WHERE xtmrp_part = wo_part
					AND xtmrp_site = wo_site NO-ERROR.
				
				IF NOT AVAILABLE xtmrp_tmp THEN DO:
					CREATE xtmrp_tmp.
					ASSIGN
						xtmrp_part = wo_part
						xtmrp_site = wo_site
						.
					FOR FIRST in_mstr WHERE in_part = xtmrp_part
						AND in_site = xtmrp_site NO-LOCK:
					END.
					IF AVAILABLE in_mstr THEN xtmrp_qty_oh = in_qty_oh.
				END.
				
				IF wo_due_date < datBg THEN DO:
					xtmrp_pr_ps = xtmrp_pr_ps + wo_qty_ord.
				END.
				ELSE DO:
					DO i = 1 TO 8:
						IF wo_due_date >= datWeekBg[i] AND wo_due_date <= datWeekBg[i] + 6
						THEN DO:
							xtmrp_prwk[i] = xtmrp_prwk[i] + wo_qty_ord.
						END.
					END.
					
					IF wo_due_date >= datMthBg[1] THEN DO:
						DO i = 1 TO 35:
							IF wo_due_date >= datMthBg[i] AND wo_due_date < datMthBg[i + 1]
							THEN DO:
								xtmrp_prmth[i] = xtmrp_prmth[i] + wo_qty_ord.
							END.
						END.
						
						IF wo_due_date >= datMthBg[36] THEN DO:
							xtmrp_prmth[36] = xtmrp_prmth[36] + wo_qty_ord.
						END.
					END.
					
				END.
			END.
			
		END.
	END.
	