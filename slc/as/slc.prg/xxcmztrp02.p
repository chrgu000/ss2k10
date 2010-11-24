/*By: Neil Gao 08/12/02 ECO: *SS 20081202* */

{mfdeclre.i}  
{gplabel.i} 

define new shared frame d.
define shared frame c.
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset     like mfc_logical. 
define var tcmmt1 as char format "x(76)".
define var tcmmt2 as char format "x(76)".
define var tcmmt3 as char format "x(76)".
define var tcmmt4 as char format "x(76)".
define var tcmmt5 as char format "x(76)".
define var tcmmt6 as char format "x(76)".
define var tcmmt7 as char format "x(76)".
define var tcmmt8 as char format "x(76)".

define shared temp-table xxtt1 
	field xxtt1_f1 as char format "x(6)"
	field xxtt1_f2 like ps_comp
	field xxtt1_f3 like pt_desc1
	field xxtt1_f4 like ps_qty_per
	field xxtt1_f5 like pt_um
	field xxtt1_f6 like pt_phantom
	field xxtt1_f7 like pt_pm_code
	field xxtt1_f8 like pt_iss_pol.

form
	tcmmt1 no-label
	tcmmt2 no-label
	tcmmt3 no-label
	tcmmt4 no-label
	tcmmt5 no-label
	tcmmt6 no-label
	tcmmt7 no-label
	tcmmt8 no-label
with frame c width 80 .

form
	xxtt1_f1 column-label "层级"
	xxtt1_f2 column-label "组件"
	xxtt1_f3 column-label "说明"
	xxtt1_f4 column-label "每件需求量"
	xxtt1_f5 column-label "UM"
	xxtt1_f6 column-label "虚"
	xxtt1_f7 column-label "PM"
	xxtt1_f8 column-label "发"
with frame d width 80 no-attr-space scroll 1.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

scroll_loop:
do :
			{xuview.i
    	     &buffer = xxtt1
    	     &scroll-field = xxtt1_f1
    	     &framename = "d"
    	     &framesize = 6
    	     &display1     = xxtt1_f1
    	     &display2     = xxtt1_f3
    	     &display3     = xxtt1_f2
    	     &display4     = xxtt1_f4
    	     &display5     = xxtt1_f5
    	     &display6     = xxtt1_f6
    	     &display7     = xxtt1_f7
    	     &display8     = xxtt1_f8
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = scroll_loop
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 	if avail xxtt1 then run dispcmmt(xxtt1_f2 ).
                         "
    	     &cursorup   = "  if avail xxtt1 then run dispcmmt(xxtt1_f2 ).
                         "
    	     }


end.

hide frame d no-pause.

procedure dispcmmt:

	define input parameter iptpart like pt_part.
	
	tcmmt1 = "".
	tcmmt2 = "".
	tcmmt3 = "".
	tcmmt4 = "".	
	tcmmt5 = "".
	tcmmt6 = "".
	tcmmt7 = "".
	tcmmt8 = "".

	find first cd_det where cd_domain = global_domain and cd_ref = iptpart and cd_lang = "ch"
 		and cd_type = "SC" no-lock no-error.
	if avail cd_det then do:
		tcmmt1 = cd_cmmt[1] .
		tcmmt2 = cd_cmmt[2] .
		tcmmt3 = cd_cmmt[3] .
		tcmmt4 = cd_cmmt[4] .
		tcmmt5 = cd_cmmt[5] .
		tcmmt6 = cd_cmmt[6] .
		tcmmt7 = cd_cmmt[7] .
		tcmmt8 = cd_cmmt[8] .
	end.
	disp tcmmt1 tcmmt2 tcmmt3 tcmmt4 tcmmt5 tcmmt6 tcmmt7 tcmmt8 with frame c.

end.