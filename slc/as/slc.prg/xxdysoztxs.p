/*By: Neil Gao 08/12/30 ECO: *SS 20081230* */

{mfdtitle.i}
{gplabel.i}

define input parameter iptf1 like so_nbr.
define output parameter optf1 like sod_line.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var cmmt4 as char format "x(76)".
define var cmmt5 as char format "x(76)".

form
	sod_nbr
	sod_line
	sod_part
	pt_desc1
	sod_qty_ord
	sod_due_date
with frame bb down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bb:handle).

form
  so_cust 
  ad_name
  cmmt1 no-label
  cmmt2 no-label
  cmmt3 no-label
  cmmt4 no-label
  cmmt5 no-label
with frame d side-labels width 80 attr-space .

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

find first sod_det where sod_domain = global_domain and sod_nbr = iptf1 no-lock no-error.
if not avail sod_det then return.

   	scroll_loop:
   	do:
   		view frame dd.
      /*V8-*/
			{xuview.i
         &buffer = sod_det
         &scroll-field = sod_nbr
         &framename = "bb"
         &framesize = 8
         &display1     = sod_nbr
         &display2     = sod_line
         &display3     = sod_part
         &display4     = sod_qty_ord
         &display5     = sod_due_date
         &searchkey    = " sod_domain = global_domain and sod_nbr = iptf1"
         &logical1     = false
         &first-recid  = first-recid
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &fdispexe1 = "	
         								if avail sod_det then 
         								find first pt_mstr where pt_domain = global_domain and sod_part = pt_part no-lock no-error.
         								if avail pt_mstr then disp pt_desc1.
         							"
         &cursorup =  " if avail sod_det then 
         								run dispfd (input sod_nbr,input sod_part).
         							"
         &cursordown = " 
         								if avail sod_det then 
         								run dispfd (input sod_nbr,input sod_part).
         							 "
       	}
														
     	if not avail sod_det then leave.
			else optf1 = sod_line.
		end.
		
		hide frame d no-pause.
    hide frame bb no-pause.
     	

procedure dispfd:
	define input parameter iptnbr  like so_nbr.
	define input parameter iptpart like pt_part.
	
		find first so_mstr where so_domain = global_domain and so_nbr = iptnbr no-lock no-error.
		find first ad_mstr where ad_domain = global_domain and ad_addr = so_cust no-lock no-error.
		disp so_cust ad_name with frame d.
		find first cd_det where cd_domain = global_domain and cd_ref = iptpart and cd_type = 'sc'
		and cd_lang = 'ch' no-lock no-error.
		if avail cd_det then do:
			cmmt1 = cd_cmmt[1].
			cmmt2 = cd_cmmt[2].
			cmmt3 = cd_cmmt[3].
			cmmt4 = cd_cmmt[4].
			cmmt5 = cd_cmmt[5].
			disp cmmt1 cmmt2 cmmt3 cmmt4 cmmt5 with frame d.
		end.

end. /* dispfd */
