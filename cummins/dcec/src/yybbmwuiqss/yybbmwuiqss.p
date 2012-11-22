/*$Revision:eb21   $by:Sandler	DATE:2012/10/29		ECO:*ss20121029.1*/
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
{mfdtitle.i "20121029.1"}

define variable comp like ps_comp.
define variable level as integer.
DEFINE VARIABLE xxstatus LIKE pt_status .
define variable l_parent1 like ps_comp no-undo.
define variable desc1 like pt_desc1.
define variable um like pt_um.
define variable phantom like mfc_logical format "yes" .
define variable iss_pol like pt_iss_pol format "/no" .
define variable record as integer extent 100.
define variable lvl as character format "x(7)".

define variable l_level   as integer initial 0 no-undo.
define variable l_psrecid as recid no-undo.
define variable l_next    like mfc_logical initial yes no-undo.
define variable l_nextptp like mfc_logical initial no  no-undo.
define variable l_phantom as   character      format "x(3)" no-undo.
define variable l_iss_pol as   character      format "x(3)" no-undo.

define buffer ptmstr1 for pt_mstr.
define buffer psmstr  for ps_mstr.

define temp-table xxbom
field part1			like pt_part
field xxlvl			as char format "x(7)"
field part2			like pt_part
field xxdesc		as char
field xxstat		like pt_status
field xxps_qty_per	like ps_qty_per
field xxum			like pt_um
field xxl_phantom	as char
field xxps_ps_code	like ps_ps_code
field xxl_iss_pol	as char
field xxpsrmks	like ps_rmks
.

define variable pp1 like pt_part label "子零件".
define variable pp2 like pt_part label "子零件".
define variable pp3 like pt_part label "子零件".
define variable des1 like pt_desc1 label "Description".
define variable des2 like pt_desc1 label "Description".
define variable des3 like pt_desc1 label "Description".
define variable um1 like pt_um label  "UM".
define variable um2 like pt_um label  "UM".
define variable um3 like pt_um label  "UM".
define variable effdate as date label "eff_date".
define variable xxlevel as integer format ">>>" label "层次".
/*hj01*/ DEFINE VARIABLE o_char AS CHAR FORMAT "x(3)" INIT "ALL" LABEL "零件状态".
/*hj01*/ DEFINE VARIABLE yn AS LOG INIT NO .

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

form
pp1 des1 um1 skip
pp2 des2 um2 skip
pp3 des3 um3 skip
effdate xxlevel o_char
     with frame a side-labels width 80 /* attr-space no-underline */ THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

effdate = today.
FOR EACH qad_wkfl NO-LOCK where qad_key1 = "PT_STATUS" :
    o_char:ADD-LAST(qad_key2,qad_key2).
END. 
o_char:ADD-LAST("非O","非O") .

pp1 = global_part.


 {wbrp02.i}
repeat:


		 if c-application-mode <> 'web':u then
      update pp1 pp2 pp3 effdate xxlevel o_char with frame a editing:

			if frame-field = "pp1" then do:
			  /* FIND NEXT/PREVIOUS RECORD */
			  {mfnp.i ps_mstr pp1 ps_comp pp1 ps_comp ps_comp}

			  if recno <> ? then do:
				 pp1 = ps_comp.
				 des1 = "".

				 find pt_mstr where pt_domain = global_domain and pt_part = pp1 no-lock no-error.
					 if available pt_mstr then des1 = pt_desc1.
						 if not available pt_mstr then do:
							find bom_mstr no-lock where bom_parent = pp1
							no-error.
							if available bom_mstr then des1 = bom_desc.
						 end.
						display pp1 des1 with frame a.
					 recno = ?.
				end.
			end.
			else do:
				  status input.
				  readkey.
				  apply lastkey.
			end.
		

		    if frame-field = "pp2" then do:
				  /* FIND NEXT/PREVIOUS RECORD */
				  {mfnp.i ps_mstr pp2 ps_comp pp2 ps_comp ps_comp}

				if recno <> ? then do:
					 pp2 = ps_comp.
					 des2 = "".

					 find pt_mstr where pt_domain = global_domain and pt_part = pp2 no-lock no-error.
						if available pt_mstr then des2 = pt_desc1.
							if not available pt_mstr then do:
								find bom_mstr no-lock where bom_parent = pp2
								no-error.
								if available bom_mstr then des2 = bom_desc.
						end.
							display pp2 des2 with frame a.
							recno = ?.
				end.
           end.
           else do:
			  status input.
			  readkey.
			  apply lastkey.
           end.
       

			if frame-field = "pp3" then do:
				  /* FIND NEXT/PREVIOUS RECORD */
				  {mfnp.i ps_mstr pp3 ps_comp pp3 ps_comp ps_comp}

				 if recno <> ? then do:
					 pp3 = ps_comp.
					 des3 = "".

					find pt_mstr where pt_domain = global_domain and pt_part = pp3 no-lock no-error.
						if available pt_mstr then des3 = pt_desc1.
							if not available pt_mstr then do:
								find bom_mstr no-lock where bom_parent = pp3
								no-error.
							if available bom_mstr then des3 = bom_desc.
						end.
						display pp3 des3 with frame a.
						recno = ?.
					end.
           end.
           else do:
			  status input.
			  readkey.
			  apply lastkey.
           end.
       end. /* if c-application-mode <> 'web':u then */

		 {wbrp06.i &command = update &fields = "pp1 pp2 pp3 effdate xxlevel"
		&frm = "a"}

		 if (c-application-mode <> 'web':u) or
		 (c-application-mode = 'web':u and
		 (c-web-request begins 'data':u)) then do:

			if input pp1 <> "" then do:
				des1 = "".
				um1 = "".

					
					find pt_mstr use-index pt_part where pt_domain = global_domain and pt_part = pp1 no-lock no-error.					
						if not available pt_mstr then do:
						   find bom_mstr no-lock where bom_domain = global_domain and bom_parent = pp1 no-error.
							   if not available bom_mstr then do:
								  hide message no-pause.
									  {mfmsg.i 17 3}
									  display des1 um1 with frame a.
										 if c-application-mode = 'web':u then return.
										  undo, retry.
							   end.
							   assign um1 = bom_batch_um
							   des1 = bom_desc
								pp1 = bom_parent.
						end.
						else do:
							   des1 = pt_desc1.
							   um1 = pt_um.
							   pp1 = pt_part.
						end.

				display pp1 des1 um1 with frame a.
			end.

			if input pp2 <> "" then do:
					find pt_mstr use-index pt_part where pt_domain = global_domain and pt_part = pp2 no-lock no-error.					
						if not available pt_mstr then do:
						   find bom_mstr no-lock where bom_domain = global_domain and bom_parent = pp2 no-error.
							   if not available bom_mstr then do:
								  hide message no-pause.
									  {mfmsg.i 17 3}
									  display des1 um1 with frame a.
										 if c-application-mode = 'web':u then return.
										  undo, retry.
							   end.
							   assign um2 = bom_batch_um
							   des2 = bom_desc
								pp2 = bom_parent.
						end.
						else do:
							   des2 = pt_desc1.
							   um2 = pt_um.
							   pp2 = pt_part.
						end.

				display pp2 des2 um2 with frame a.

			end.


			if input pp3 <> "" then do:
					find pt_mstr use-index pt_part where pt_domain = global_domain and pt_part = pp3 no-lock no-error.					
						if not available pt_mstr then do:
						   find bom_mstr no-lock where bom_domain = global_domain and bom_parent = pp3 no-error.
							   if not available bom_mstr then do:
								  hide message no-pause.
									  {mfmsg.i 17 3}
									  display des3 um3 with frame a.
										 if c-application-mode = 'web':u then return.
										  undo, retry.
							   end.
							   assign um3 = bom_batch_um
							   des3 = bom_desc
								pp3 = bom_parent.
						end.
						else do:
							   des3 = pt_desc1.
							   um3 = pt_um.
							   pp3 = pt_part.
						end.

				display pp3 des3 um3 with frame a.  
			end.
		end. /*if (c-application-mode <> 'web':u) or */


        /* SELECT PRINTER */
          {mfselprt.i "terminal" 80}.

	for each xxbom:
		delete xxbom.
	end.

	if pp1 <> "" then do:
		run xxget(input pp1,input effdate,input xxlevel ).
	end.

	if pp2 <> "" then do:
		run xxget(input pp2,input effdate,input xxlevel ).
	end.

	if pp3 <> "" then do:
		run xxget(input pp3,input effdate,input xxlevel ).
	end.





	for each xxbom:
		display part1						column-label "子零件"	 
				xxlvl						column-label "层级"
				part2		                column-label "父级物料"
				xxdesc			format "x(50)"     column-label "描述"
				xxps_qty_per                column-label "每件需求量"
				xxum		                column-label "UM"
				xxl_phantom	                column-label "虚"
				xxps_ps_code                column-label "T"
				xxl_iss_pol	                column-label "发"
				xxstat						column-label "状态"
				xxpsrmks					 COLUMN-LABEL "随机带!走  件"  FORMAT "x(1)"
				with width  220.            

	end.
	      {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end. /*repeat*/





PROCEDURE xxget:
define input parameter parent like ps_comp.
define input parameter eff_date as date.
define input parameter maxlevel as int format ">>>" .

        /* OUTPUT DESTINATION SELECTION */
/*        {gpselout.i
           &printType = "terminal"
           &printWidth = 80
           &pagedFlag = " "
           &stream = " "
           &appendToFile = " "
           &streamedOutputToTerminal = " "
           &withBatchOption = "no"
           &displayStatementType = 1
           &withCancelMessage = "yes"
           &pageBottomMargin = 6
           &withEmail = "yes"
           &withWinprint = "yes"
           &defineVariables = "yes"}  */

         assign
            desc1 = ""
            um    = ""
            l_parent1 = ""
           l_next    = yes
           l_nextptp = no
           level     = 0
           comp      = parent
		 
           maxlevel  = min(maxlevel,99)
           level     = 1.

        find first ps_mstr 
           use-index ps_comp
           where ps_domain = global_domain and  ps_comp = comp
           no-lock
           no-error.					  

		repeat:

			if not available ps_mstr then do:
				  repeat:
					 level = level - 1.
					 if level < 1
					 then
						leave.
					 find ps_mstr
						where recid(ps_mstr) = record[level] no-lock no-error.
							comp = ps_comp.
					 find next ps_mstr  use-index ps_comp where ps_domain = global_domain and ps_comp = comp no-lock no-error.
						if available ps_mstr then leave.                   
			 end. /*repeat*/
         end. /*then do */

           if level < 1 then leave.

           if eff_date = ? or (eff_date <> ? and
             (ps_start = ? or ps_start <= eff_date) and
             (ps_end = ? or eff_date <= ps_end))
           then do:

				assign
                 desc1 = ""
                 um    = ""
                 iss_pol = no
				xxstatus = ""
				yn = no.
                 phantom = no.

			find pt_mstr where pt_domain = global_domain and pt_part = ps_par   no-lock no-error.
					if available pt_mstr then do:
						 assign
							desc1   = pt_desc1
							um      = pt_um
							iss_pol = pt_iss_pol
							 xxstatus = pt_status. 
							phantom = pt_phantom.
						CASE o_char :
							WHEN "非O" THEN DO:          
								IF pt_status <> "o" THEN yn = NO .
								ELSE yn = YES .
							END.
							WHEN "ALL" THEN DO: 
								yn = NO.
							END.
							OTHERWISE DO:
								IF pt_status = o_char THEN yn = NO .
								ELSE yn = YES .
							END.
						END.

					end.

					else do:
						find bom_mstr where bom_domain = global_domain and bom_parent = ps_par no-lock no-error.
							if available bom_mstr then
								assign
								   um    = bom_batch_um
								   desc1 = bom_desc.
					end. /*else do*/

              if phantom then l_phantom  = getTermLabel("Yes",3). 
              else l_phantom =  getTermLabel("No",3).
              if iss_pol
              then
                 l_iss_pol  = getTermLabel("Yes",3).
              else
                 l_iss_pol =  getTermLabel("No",3).

              assign
                 record[level] = recid(ps_mstr)
                 lvl           = "......."
                 lvl           = substring(lvl,1,min(level - 1,6))
                                    + string(level).

              if length(lvl) > 7
              then
                 lvl = substring(lvl,length(lvl) - 6,7).
			
				if available pt_mstr and pt_desc2 > "" then desc1 = desc1 + " " + pt_desc2.
					if yn = no then do:
						create xxbom.
							assign
								part1		 = parent
								xxlvl		 =	lvl
								part2		 =	ps_par
								xxdesc		 =	desc1
								xxstat       = xxstatus
								xxps_qty_per =	ps_qty_per
								xxum		 =	um
								xxl_phantom	 =	l_phantom
								xxps_ps_code = 	ps_ps_code
								xxl_iss_pol	 =	l_iss_pol
								xxpsrmks     = ps_rmks
								.
					end.

                 if level < maxlevel or maxlevel = 0
                 then do:
                    assign
                       comp = ps_par
                       level = level + 1.
                    find first ps_mstr use-index ps_comp where ps_domain = global_domain and ps_comp = comp  no-lock no-error.   
						if not available ps_mstr  then                  
							run p-getbom.
                 end.
                 else do:
                    find next ps_mstr use-index ps_comp where ps_domain = global_domain and ps_comp = comp no-lock no-error.
						if not available ps_mstr then                   
							run p-getbom.
                 end.
              end. /*if effdate ..then do*/
              else
                 find next ps_mstr use-index ps_comp where ps_domain = global_domain and ps_comp = comp no-lock no-error.           
        end. /*repeat */
         /*     {mfreset.i} */
END PROCEDURE. /* */

PROCEDURE p-getbom:
   if l_next
   then do:
      for first ptp_det
         fields(ptp_bom_code ptp_part)
         where ptp_det.ptp_domain = global_domain and
		 ptp_det.ptp_bom_code = comp
         no-lock :
      end. /* FOR FIRST PTP_DET */
      if available ptp_det
      then do:
         l_nextptp = yes.
         for first ptmstr1
            fields(pt_bom_code pt_desc1 pt_desc2 pt_iss_pol pt_part pt_phantom)
            where ptmstr1.pt_domain = global_domain and
			ptmstr1.pt_part = ptp_part
            no-lock :
         end. /* FOR FIRST PTMSTR1 */
      end. /* IF AVAILABLE PTP_DET */
      else
         for first ptmstr1
            fields(pt_bom_code pt_desc1 pt_desc2 pt_iss_pol pt_part pt_phantom)
            where  ptmstr1.pt_domain = global_domain and ptmstr1.pt_bom_code = comp
            no-lock :
      end. /* FOR FIRST PTMSTR1 */

      for first psmstr
         fields(ps_comp ps_end ps_lt_off ps_par ps_ps_code ps_qty_per
                ps_qty_per_b ps_qty_type ps_ref ps_scrp_pct ps_start)
         where psmstr.ps_domain = global_domain and  psmstr.ps_par = comp
         no-lock :
      end. /* FOR FIRST PSMSTR */
      if available psmstr
      then
         assign
            l_psrecid = recid(psmstr)
            l_level = level.
      end. /* L_NEXT = YES */
      else do:
         for first psmstr
            fields(ps_comp ps_end ps_lt_off ps_par ps_ps_code ps_qty_per
                   ps_qty_per_b ps_qty_type ps_ref ps_scrp_pct ps_start)
            where psmstr.ps_domain = global_domain and   recid(psmstr) = l_psrecid
            no-lock :
      end. /* FOR FIRST PSMSTR */
      find next ptp_det
         where ptp_det.ptp_domain = global_domain and  ptp_det.ptp_bom_code = psmstr.ps_par
         no-lock
         no-error.
      if available ptp_det
      then do:
         for first ptmstr1
            fields(pt_bom_code pt_desc1 pt_desc2 pt_iss_pol pt_part pt_phantom)
            where ptmstr1.pt_domain = global_domain and ptmstr1.pt_part = ptp_part
            no-lock :
         end. /* FOR FIRST PTMSTR1 */
      end. /* IF AVAIL PTP_DET */
      else do:
         if l_nextptp = yes
         then do:
            for first ptmstr1
               fields(pt_bom_code pt_desc1 pt_desc2 pt_iss_pol pt_part
                      pt_phantom)
               where ptmstr1.pt_domain = global_domain and ptmstr1.pt_bom_code = psmstr.ps_par
               no-lock :
            end. /* FOR FIRST PTMSTR1 */
            l_nextptp = no.
         end. /* IF L_NEXTPTP = YES */
         else do:
            find next ptmstr1
               where ptmstr1.pt_domain = global_domain and ptmstr1.pt_bom_code = psmstr.ps_par
                 and not(can-find (first ptp_det
                                      where ptp_det.ptp_domain = global_domain and ptp_part = pt_part
                                        and ptp_bom_code = ptmstr1.pt_bom_code))
               no-lock
               no-error.
            l_nextptp = no.
         end. /* ELSE IF L_NEXTPTP = NO */
      end. /* IF NOT AVAILABLE PTP_DET */
      if available ptmstr1
      then
         level = l_level.
   end. /* ELSE IF L_NEXT = NO */

   bomloop1:
   do while available ptmstr1:
      l_next = no.
      for first ps_mstr
         fields(ps_comp ps_end ps_lt_off ps_par ps_ps_code ps_qty_per
                ps_qty_per_b ps_qty_type ps_ref ps_scrp_pct ps_start)
         where ps_mstr.ps_domain = global_domain and ps_mstr.ps_comp = ptmstr1.pt_part
         use-index ps_comp
         no-lock :
      end. /* FOR FIRST PS_MSTR */
      if available ps_mstr
      then do:
         comp = ptmstr1.pt_part.
         leave bomloop1.
      end. /* if available ps_mstr */
      else if not available ps_mstr
      then do:
         find next ptp_det
            where ptp_det.ptp_domain = global_domain and ptp_det.ptp_bom_code = comp
            no-lock
            no-error.
         if available ptp_det
         then do:
            find next ptmstr1
               where ptmstr1.pt_domain = global_domain and ptmstr1.pt_part = ptp_part
               no-lock
               no-error.
         end. /* IF AVAIL PTP_DET */
         else  do:
            find next ptmstr1
               where ptmstr1.pt_domain = global_domain and ptmstr1.pt_bom_code = comp
               no-lock
               no-error.
            if not available ptmstr1
            then do:
               for first psmstr
                  fields(ps_comp ps_end ps_lt_off ps_par ps_ps_code ps_qty_per
                         ps_qty_per_b ps_qty_type ps_ref ps_scrp_pct ps_start)
                  where psmstr.ps_domain = global_domain and  recid(psmstr) = l_psrecid
                  no-lock :
               end. /* FOR FIRST PSMSTR */
               find next ptmstr1
                  where ptmstr1.pt_domain = global_domain and ptmstr1.pt_bom_code = psmstr.ps_par
                    and not(can-find (first ptp_det
                                         where ptp_domain = global_domain and ptp_part = pt_part and
                                         ptp_bom_code = ptmstr1.pt_bom_code))
                  no-lock
                  no-error.
            end. /* IF NOT AVAILABLE PTMSTR1 */
         end. /* ELSE DO */
      end. /* IF NOT AVAIL PS_MSTR */
   end. /* IF AVAILABLE PTMSTR BOMLOOP1 */
END PROCEDURE. /* P-GETBOM */
