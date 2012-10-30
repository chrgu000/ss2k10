{mfdtitle.i}
def var effdate as date label "AS Of Date" init today.
def var old_part 		like pt_part label "旧结构代码".
def var New_part  	like pt_part label "新结构代码".
def var disp_all as logical label "Display All" format "Y/N".
def var exist_yn as log.
def var msg_content	 as char.
define new shared variable ps_recno as recid.
define new shared variable parent like ps_par.
define new shared variable comp like ps_comp.
define variable unknown_char as character initial ?.
define buffer psmstr  for ps_mstr.
define temp-table copyps like ps_mstr.

def temp-table tmpps 
		field tmpps_recno as recid
		field tmpps_rmks as char.

form	 effdate colon 15 
			 old_part colon 15 New_part colon 45 
			 with frame a side-label three-d width 80.
			 
setframelabels(frame a:handle).
effdate = today + 1.
MainLoop:
repeat:

message "子零件替代功能".

update effdate
			 old_part 				
			 New_part
			 with frame a side-label three-d.
exist_yn = no.

if not(effdate > today) then do:
			msg_content		= "输入的生效日必须大于今天".
			{pxmsg.i &MSGTEXT =msg_content &ERRORLEVEL = 3}
			undo,retry.
end.

find first bom_mstr where bom_par = old_part no-lock no-error.
if not avail bom_mstr then do:
	find first pt_mstr where pt_part = old_part no-lock no-error.
	if not avail pt_mstr then do:
			msg_content		= "旧的结构代码: " + old_part + " 不存在".
			{pxmsg.i &MSGTEXT =msg_content &ERRORLEVEL = 3}
			undo,retry.
	end.
end.

find first bom_mstr where bom_par = new_part no-lock no-error.
if not avail bom_mstr then do:
	find first pt_mstr where pt_part = new_part no-lock no-error.
	if not avail pt_mstr then do:
			msg_content		= "新的结构代码: " + new_part + " 不存在".
			{pxmsg.i &MSGTEXT =msg_content &ERRORLEVEL = 3}
			undo,retry.
	end.
end.
empty temp-table copyps.
empty temp-table tmpps.
copy:
do transaction on error undo,retry:
		for each ps_mstr where ps_par 		= old_part 
											 and (ps_start	<= effdate or ps_start = ?)
											 and (ps_end		>= effdate or ps_end = ?):
				find first psmstr where psmstr.ps_par = ps_mstr.ps_comp
														and psmstr.ps_comp = new_part 
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
				if not avail psmstr then
				find first psmstr where psmstr.ps_par = new_part
														and psmstr.ps_comp = ps_mstr.ps_comp
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
														
				create tmpps.
				assign tmpps_recno = recid(ps_mstr).
				if avail psmstr then do:
						tmpps_rmks = string(recid(psmstr)).
           {pxmsg.i &MSGNUM=260 &ERRORLEVEL=3}
           /* Product structure already exists */
           undo copy, leave copy.
				end.
				if not avail psmstr then do:
						create copyps.
						buffer-copy ps_mstr to copyps.
						assign ps_mstr.ps_end  = effdate - 1.
                  ps_mstr.ps_mod_date = today.
                  ps_mstr.ps_userid = global_userid.

                  copyps.ps_start = effdate.
                  copyps.ps_par = new_part.
                  copyps.ps_mod_date = today.
                  copyps.ps_userid = global_userid.
				end.
				exist_yn = yes.
		end.
		for each ps_mstr where ps_comp 		= old_part 
											 and (ps_start	<= effdate or ps_start = ?)
											 and (ps_end		>= effdate or ps_end = ?):
				find first psmstr where psmstr.ps_par = ps_mstr.ps_par 
														and psmstr.ps_comp = new_part 
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
				if not avail psmstr then
				find first psmstr where psmstr.ps_par = new_part
														and psmstr.ps_comp = ps_mstr.ps_par
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
				create tmpps.
				assign tmpps_recno = recid(ps_mstr).
				if avail psmstr then do:
						tmpps_rmks = string(recid(psmstr)).
           {pxmsg.i &MSGNUM=260 &ERRORLEVEL=3}
           /* Product structure already exists */
           undo copy, leave copy.
				end.
				if not avail psmstr then do:
						create copyps.
						buffer-copy ps_mstr to copyps.
						assign ps_mstr.ps_end  = effdate - 1.
                  ps_mstr.ps_mod_date = today.
                  ps_mstr.ps_userid = global_userid.
                  copyps.ps_start = effdate.
                  copyps.ps_comp = new_part.
                  copyps.ps_mod_date = today.
                  copyps.ps_userid = global_userid.
					
				end.
				exist_yn = yes.
		end.

		for each copyps:
				create ps_mstr.
				buffer-copy copyps to ps_mstr.
				ps_recno = recid(ps_mstr).
				{gprun.i ""bmpsmta.p""}
	       if ps_recno = 0 then do:
	          {pxmsg.i &MSGNUM=206 &ERRORLEVEL=3}
	          /* CYCLIC PRODUCT STRUCTURE NOT ALLOWED. */
	          undo copy, leave copy.
	       end.
         for each in_mstr exclusive-lock where in_part = ps_mstr.ps_comp
            and not can-find (ptp_det where ptp_part = in_part
                                        and ptp_site = in_site):
            if available in_mstr then
               in_level = 99999.
         end.

         for each ptp_det where ptp_part = ps_mstr.ps_comp:
            find in_mstr where in_part = ptp_part and
                               in_site =  ptp_site
            exclusive-lock no-error.
            if available in_mstr then
               in_level = 99999.
         end.
		end.
		
		for each ps_mstr where ps_mstr.ps_comp 		= old_part 
											 and (ps_mstr.ps_start	> effdate):
				find first psmstr where psmstr.ps_par = ps_mstr.ps_par 
														and psmstr.ps_comp = new_part 
														and (psmstr.ps_start > effdate)
														no-lock no-error.
				if not avail psmstr then
				find first psmstr where psmstr.ps_par = new_part
														and psmstr.ps_comp = ps_mstr.ps_par
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
				create tmpps.
				assign tmpps_recno = recid(ps_mstr).
				if avail psmstr then do:
						tmpps_rmks = string(recid(psmstr)).
           {pxmsg.i &MSGNUM=260 &ERRORLEVEL=3}
           /* Product structure already exists */
           undo copy, leave copy.
				end.
				if not avail psmstr then do:
						assign ps_mstr.ps_mod_date = today.
                  ps_mstr.ps_userid = global_userid.
                  ps_mstr.ps_par = new_part.
                  ps_mstr.ps_userid = global_userid.
					
				end.
				exist_yn = yes.
				ps_recno = recid(ps_mstr).
				{gprun.i ""bmpsmta.p""}
	       if ps_recno = 0 then do:
	          {pxmsg.i &MSGNUM=206 &ERRORLEVEL=3}
	          /* CYCLIC PRODUCT STRUCTURE NOT ALLOWED. */
	          undo copy, leave copy.
	       end.
         for each in_mstr exclusive-lock where in_part = ps_mstr.ps_comp
            and not can-find (ptp_det where ptp_part = in_part
                                        and ptp_site = in_site):
            if available in_mstr then
               in_level = 99999.
         end.

         for each ptp_det where ptp_part = ps_mstr.ps_comp:
            find in_mstr where in_part = ptp_part and
                               in_site =  ptp_site
            exclusive-lock no-error.
            if available in_mstr then
               in_level = 99999.
         end.
         {inmrp.i &part=ps_mstr.ps_par  &site=unknown_char}

         /* ADDED CALL TO bmpsmtd.p TO SET THE in_mrp FLAG OF THE PARENT OF */
         /* A LOCAL PHANTOM WHEN ITS COMPONENT IS ADDED/DELETED/REPLACED.   */
         {gprun.i ""bmpsmtd.p"" "(ps_mstr.ps_par)" }
		end.
		for each ps_mstr where ps_mstr.ps_par 		= old_part 
											 and (ps_mstr.ps_start	> effdate ):
				find first psmstr where psmstr.ps_par = ps_mstr.ps_comp
														and psmstr.ps_comp = new_part 
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
				if not avail psmstr then
				find first psmstr where psmstr.ps_par = new_part
														and psmstr.ps_comp = ps_mstr.ps_comp
														and (psmstr.ps_start <= effdate or psmstr.ps_start = ?)
														and (psmstr.ps_end		>= effdate or psmstr.ps_end = ?)
														no-lock no-error.
														
				create tmpps.
				assign tmpps_recno = recid(ps_mstr).
				if avail psmstr then do:
						tmpps_rmks = string(recid(psmstr)).
           {pxmsg.i &MSGNUM=260 &ERRORLEVEL=3}
           /* Product structure already exists */
           undo copy, leave copy.
				end.
				if not avail psmstr then do:
						assign ps_mstr.ps_mod_date = today.
                  ps_mstr.ps_userid = global_userid.
                  ps_mstr.ps_par = new_part.
                  ps_mstr.ps_userid = global_userid.
				end.

				exist_yn = yes.
				ps_recno = recid(ps_mstr).
				{gprun.i ""bmpsmta.p""}
	       if ps_recno = 0 then do:
	          {pxmsg.i &MSGNUM=206 &ERRORLEVEL=3}
	          /* CYCLIC PRODUCT STRUCTURE NOT ALLOWED. */
	          undo copy, leave copy.
	       end.
         for each in_mstr exclusive-lock where in_part = ps_mstr.ps_comp
            and not can-find (ptp_det where ptp_part = in_part
                                        and ptp_site = in_site):
            if available in_mstr then
               in_level = 99999.
         end.

         for each ptp_det where ptp_part = ps_mstr.ps_comp:
            find in_mstr where in_part = ptp_part and
                               in_site =  ptp_site
            exclusive-lock no-error.
            if available in_mstr then
               in_level = 99999.
         end.
         {inmrp.i &part=ps_mstr.ps_par  &site=unknown_char}

         /* ADDED CALL TO bmpsmtd.p TO SET THE in_mrp FLAG OF THE PARENT OF */
         /* A LOCAL PHANTOM WHEN ITS COMPONENT IS ADDED/DELETED/REPLACED.   */
         {gprun.i ""bmpsmtd.p"" "(ps_mstr.ps_par)" }
		end.
		if exist_yn = no then do:
					msg_content		= "不存在需要替换的结构".
					{pxmsg.i &MSGTEXT =msg_content &ERRORLEVEL = 3}
		end.
		
end. /* End Replace*/

/*
{mfselprt.i "printer" 80}

{mfreset.i}
{mfgrptrm.i}
*/
end.
