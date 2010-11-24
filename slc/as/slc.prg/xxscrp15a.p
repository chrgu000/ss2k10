/*By: Neil Gao 08/12/29 ECO: *SS 20081229* */

{mfdeclre.i}
{gplabel.i}

{pxmaint.i}

define input parameter iptnbr like so_nbr.

define shared variable release_all       like mfc_logical.
define variable nbr             like req_nbr           no-undo.
define variable dwn             like pod_line          no-undo.
define variable yn              like mfc_logical column-label "Approve" no-undo.
define variable flag            as integer initial 0   no-undo.
define variable line            like req_line          no-undo.
define variable i               as integer             no-undo.

{xxscrp15.i}

define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var cmmt4 as char format "x(76)".
define var cmmt5 as char format "x(76)".
/*SS 20080324 - E*/

define var xxentry as char.

form
   tt2_f1 format ">>>"
   ad_name no-label
   skip
   cmmt1 no-label
   cmmt2 no-label
   cmmt3 no-label
   cmmt4 no-label
   cmmt5 no-label
with frame d side-labels width 80 attr-space .


setFrameLabels(frame d:handle).

   	scroll_loop:
   	repeat:
   		view frame dd.
      /*V8-*/
			{xuview.i
         &buffer = tt2
         &scroll-field = tt2_f1
         &framename = "bb"
         &framesize = 8
         &display1     = tt2_f1
         &display2     = tt2_f2
         &display3     = tt2_f3
         &display4     = tt2_f4
         &display5     = tt2_f5
         &display6     = tt2_f6
         &display7 		 = tt2_f7
         &searchkey    = "tt2_f2 = iptnbr "
         &logical1     = false
         &first-recid  = first-recid
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &cursorup =  "  {xxscrp1501.i}
         							"
         &cursordown = " {xxscrp1501.i}
         							 "
       	}
       
       	if not avail tt2 then do:
       		leave.
       	end.
       	if keyfunction(lastkey) = "return" then do:
       		
       	end. 
       	else if keyfunction(lastkey) = "go" then do:
       		
				end. /*else if keyfunction(lastkey) = "go" */	
				if keyfunction(lastkey) = "end-error" then do:
   			end.
   	end.
   	hide frame d  no-pause.
   	hide frame bb no-pause.