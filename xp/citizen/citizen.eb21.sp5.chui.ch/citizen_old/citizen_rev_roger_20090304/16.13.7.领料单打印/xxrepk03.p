/* xxrepk02.p  -- 领料单列印 */
/* $Revision: 1.23 $   BY: Apple Tam          DATE: 03/01/06 ECO: *SS-MIN001* */

{mfdtitle.i "1+ "}
 {xxrevar03.i new}

define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.
DEFINE VARIABLE inv_recid as recid.


v_ordertype = "LS" .

form
   rcvno          colon 12 label "领料单号"   
   p-type         colon 50 label "单号类别"
   site	          colon 12 label "转入地点"
   prodline label "车间库位"
   line2          colon 50 label "项数"
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS 
setFrameLabels(frame a:handle).
*/


repeat with frame a:

   seta:

   do on error undo, retry:


		update	rcvno with frame a editing:
            {mfnp05.i xic_det
                      xic_line
                     " xic_det.xic_domain = global_domain and xic_flag = no "
                      xic_nbr 
                     " input rcvno "}

            if recno <> ? then
               display
                  substring(xic_nbr,1,8) @ rcvno
                  substring(xic_site_to,1,8) @ site
				  substring(xic_loc_to,1,8) @ prodline
               with frame a.
		end. /*update	rcvno */

		if rcvno <> "" then do:
			find first xic_det where xic_domain = global_domain and xic_nbr = rcvno and xic_flag = no no-lock no-error .
			if not avail xic_det then do:
				message "无此单号或已确认,请重新输入." .
				undo,retry.
			end.
			else do:
				p-type = xic_type .
				prodline = xic_loc_to .
				site = xic_site_to .

				find loc_mstr no-lock  
					where loc_mstr.loc_domain = global_domain 
					and loc_site = site 
					and	loc_loc = prodline no-error.
				if available loc_mstr then do:
					wcdesc = loc_desc.
				end.

				{gprun.i ""gpsiver.p"" 
					"(input site,
					input ?,
					output return_int)"}

				if return_int = 0 then do:
					{pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
					undo, retry.
				end. /* IF return_int = 0 */

			end.
			message "修改已有记录" .
		end.
		else do:
			newloop:
			do on error undo,retry :
				message "新增记录" .
				p-type = "" .
				site = "" .
				prodline = "" .
				update p-type site prodline line2 with frame a .

				find loc_mstr no-lock  
					where loc_mstr.loc_domain = global_domain 
					and loc_site = site 
					and	loc_loc = prodline no-error.
				if available loc_mstr then do:
					wcdesc = loc_desc.
				end.
				else do:  
				   message "错误：车间库位不存在，请重新输入".
				   undo, retry.	     
				end.

				{gprun.i ""gpsiver.p"" 
					"(input site,
					input ?,
					output return_int)"}

				if return_int = 0 then do:
					{pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
					undo, retry.
				end. /* IF return_int = 0 */

				find first xdn_ctrl 
					where xdn_ctrl.xdn_domain = global_domain 
					and xdn_ordertype = v_ordertype
					and xdn_type = p-type 
				no-lock no-error.
				if available xdn_ctrl then do:
				   p-prev = xdn_prev.
				   p-next = xdn_next.
				end. 
				else do:
				   message "错误：单号类别不存在，请重新输入".
				   undo, retry.
				end.
				
				do transaction on error undo, retry:
					find first xdn_ctrl 
							where xdn_ctrl.xdn_domain = global_domain 
							and xdn_ordertype = v_ordertype
							and xdn_type = p-type 			
					exclusive-lock no-error.
					if available xdn_ctrl then do:
						k = integer(p-next) + 1.
						m2 = fill("0",length(p-next) - length(string(k))) + string(k).
						rcvno = trim(p-prev) + trim(m2).
						xdn_next = m2.
					end.
					if recid(xdn_ctrl) = ? then .
					release xdn_ctrl.
				end. /*do transaction*/
			end.

		end.
 



	    display  rcvno site prodline p-type line2 with frame a.


	{gprun.i ""xxrepka03.p""}
	{gprun.i ""xxrepkb03.p""}


	bcdparm = "".

	{mfquoter.i prodline  }
	{mfquoter.i p-type    }
	{mfquoter.i rcvno     }
	{mfquoter.i line2     }

   /* OUTPUT DESTINATION SELECTION */
      /* SELECT PRINTER */
      {gpselout.i &printType = "printer"
                  &printWidth = 80
                  &pagedFlag  = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "yes"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}

		{gprun.i ""xxrepkp03.p""}



      {mfreset.i}

   end.

end.
