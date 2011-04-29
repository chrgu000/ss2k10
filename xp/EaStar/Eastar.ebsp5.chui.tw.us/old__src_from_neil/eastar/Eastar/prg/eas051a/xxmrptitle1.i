/* eB SP5 Linux US    Created By: Kaine Zhang 11/28/05 *eas051a* */

			IF blnFormat = YES THEN DO:
				PUT
					"Past    " AT 151 SPACE(33)
					datWeekBg[1] SPACE(33)
					datWeekBg[2] SPACE(33)
					datWeekBg[3] SPACE(33)
					datWeekBg[4] SPACE(33)
					datWeekBg[5] SPACE(33)
					datWeekBg[6] SPACE(33)
					datWeekBg[7] SPACE(33)
					datWeekBg[8]
					.
				IF blnOnlyWeek = NO THEN DO:
					DO i = 1 TO intMaxMth:
						PUT SPACE(33) datMthBg[i].
					END.
				END.

				PUT
					"Part" AT 1 SPACE(15)
					"Description" SPACE(38)
					"UM" SPACE(1)
					"Pur Lead   " SPACE(1)
					"客供" SPACE(1)
					"No Plan" SPACE(1)
					"Iss Policy" SPACE(1)
					"Min Order    " SPACE(1)
					"In Warehouse   " SPACE(1)
					"WH100 Qty   " SPACE(1)
					FILL("Gross Qty   Qty On Order Scheduled Stock ", 9) FORMAT "x(369)"
					.

				IF blnOnlyWeek = NO THEN DO:
					DO i = 1 TO intMaxMth:
						PUT "Gross Qty   Qty On Order Scheduled Stock ".
					END.
				END.
				
				PUT "Remark" SKIP.
				
				PUT
					"------------------ " AT 1
					FILL("-", 48) FORMAT "x(48)" SPACE(1)
					"-- "
					"----------- "
					"---- ------- ---------- "
					"------------- "
					"--------------- "
					"------------ "
					FILL("----------- ------------ --------------- ", 9) FORMAT "x(369)"
					.
				
				IF blnOnlyWeek = NO THEN DO:
					DO i = 1 TO intMaxMth:
						PUT "----------- ------------ --------------- ".
					END.
				END.
				
				PUT "------" SKIP.
			END.
			ELSE DO:
				PUT
					"Past    " AT 151 SPACE(45)
					datWeekBg[1] SPACE(45)
					datWeekBg[2] SPACE(45)
					datWeekBg[3] SPACE(45)
					datWeekBg[4] SPACE(45)
					datWeekBg[5] SPACE(45)
					datWeekBg[6] SPACE(45)
					datWeekBg[7] SPACE(45)
					datWeekBg[8]
					.

				IF blnOnlyWeek = NO THEN DO:
					DO i = 1 TO intMaxMth:
						PUT SPACE(45) datMthBg[i].
					END.
				END.

				PUT
					"Part" AT 1 SPACE(15)
					"Description" SPACE(38)
					"UM" SPACE(1)
					"Pur Lead   " SPACE(1)
					"客供" SPACE(1)
					"No Plan" SPACE(1)
					"Iss Policy" SPACE(1)
					"Min Order    " SPACE(1)
					"In Warehouse   " SPACE(1)
					"WH100 Qty   " SPACE(1)
					FILL("Gross Qty   Qty On Order PR Qty      Scheduled Stock ", 9) FORMAT "x(477)"
					.

				IF blnOnlyWeek = NO THEN DO:
					DO i = 1 TO intMaxMth:
						PUT "Gross Qty   Qty On Order PR Qty      Scheduled Stock ".
					END.
				END.
				
				PUT "Remark".
				
				PUT
					"------------------ " AT 1
					FILL("-", 48) FORMAT "x(48)" SPACE(1)
					"-- "
					"----------- "
					"---- ------- ---------- "
					"------------- "
					"--------------- "
					"------------ "
					FILL("----------- ------------ ----------- --------------- ", 9) FORMAT "x(477)"
					.
				
				IF blnOnlyWeek = NO THEN DO:
					DO i = 1 TO intMaxMth:
						PUT "----------- ------------ ----------- --------------- ".
					END.
				END.
				
				PUT "------".
			END.
			