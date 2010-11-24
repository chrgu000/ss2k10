/*By: Neil Gao 08/12/22 ECO: *SS 20081222* */

{mfdtitle.i}
{gplabel.i}

define input parameter iptnbr like pt_part.
define output parameter optnbr like pt_part.
define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var cmmt4 as char format "x(76)".
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset     like mfc_logical. 


form
	pt_part
	pt_um
	pt_desc1
	pt_desc2
with frame ol1 overlay 5 down scroll 1 row 6 width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame ol1:handle).

form
	cmmt1  no-label
	cmmt2  no-label
	cmmt3  no-label
	cmmt4  no-label
with frame ol2 overlay side-labels row 15 width 80.

find first pt_mstr where pt_domain = global_domain and pt_part >= iptnbr no-lock no-error.
if not avail pt_mstr then leave.

view frame ol1.
view frame ol2.

if avail pt_mstr then run dispcmt ( input pt_part) .

scroll_loop:
do with frame b:
	tt_recid = ?.
	first-recid = ?.

    	{xuview.i
    	     &buffer = pt_mstr
    	     &scroll-field = pt_part
    	     &framename = "ol1"
    	     &framesize = 5
    	     &display1     = pt_part
    	     &display2     = pt_um
    	     &display3     = pt_desc1
    	     &display4     = pt_desc2
    	     &searchkey    = "pt_domain = global_domain and pt_part >= iptnbr"
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = scroll_loop
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " if avail pt_mstr then run dispcmt ( input pt_part) ."
    	     &cursorup   = " if avail pt_mstr then run dispcmt ( input pt_part) ."
         }

end.

if avail pt_mstr then optnbr = pt_part.

hide frame ol1 no-pause.
hide frame ol2 no-pause.


procedure dispcmt:
	define input parameter iptpart like pt_part.
	
	find first cd_det where cd_domain = global_domain and cd_ref = iptpart and cd_lang = "ch"
		and cd_type = "SC" no-lock no-error.
	if avail cd_det then do:
		disp cd_cmmt[1] @ cmmt1
		     cd_cmmt[2] @ cmmt2
		     cd_cmmt[3] @ cmmt3
		     cd_cmmt[4] @ cmmt4 with frame ol2.
	end.

end procedure.