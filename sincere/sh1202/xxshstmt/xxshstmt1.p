/* xxshstmt.p - shpment status maintenance                                   */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "120803.1"}

define variable i as integer.
define variable def-stat as character format "x(1)".
define variable operators as character.
define variable yn as logical.
define temp-table tmpsh
        fields tsh_nbr like xxsh_nbr
        fields tsh_site like xxsh_site
        fields tsh_abs_id like xxsh_abs_id
        fields tsh_lgvd like xxsh_lgvd     format "x(8)"
        fields tsh_shipto like xxsh_shipto format "x(8)"
        fields tsh_price like xxsh_price
        fields tsh_stat like xxsh_stat format "x(1)"
        fields tsh_ostat like xxsh_stat format "x(1)"
        index tsh_abs_id is primary tsh_abs_id.

/* DISPLAY SELECTION FORM */
form
   xxsh_nbr  colon 20
   operators colon 20  def-stat  colon 42
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

FORM
     tsh_nbr label "nbr"
     tsh_site label "site"
     tsh_abs_id label "absid"
     tsh_lgvd label "lgvd"
     tsh_shipto label "spto"
     tsh_price label "price"
     tsh_stat label "mod"
     tsh_ostat label "old"
with frame b 10 DOWN scroll 1 width 80 attr-space.
setFrameLabels(frame b:handle).
/* DISPLAY */
assign operators = global_userid.
display operators with frame a.
repeat with frame a:
	 clear frame b.
	 hide frame b.
   prompt-for xxsh_nbr editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i xxsh_mst xxsh_nbr " xxsh_nbr"
      yes "  xxsh_domain = global_domain and yes " xxsh_nbr_abs}
      if recno <> ? then do:
      	 assign operators = global_userid.
         display xxsh_nbr operators.
      end.
   end.

   if input xxsh_nbr = "" then do:
      {mfmsg.i 40 3}
      undo, retry.
   end.

   ststatus = stline[2].
   status input ststatus.
	
   empty temp-table tmpsh no-error.
   for each xxsh_mst no-lock where xxsh_domain = global_domain
        and xxsh_nbr = input xxsh_nbr:
        create tmpsh.
        assign tsh_nbr    = xxsh_nbr
               tsh_site   = xxsh_site
               tsh_abs_id = trim(substring(xxsh_abs_id,2,50))
               tsh_lgvd   = xxsh_lgvd
               tsh_shipto = xxsh_shipto
               tsh_ostat  = xxsh_stat
               tsh_price  = xxsh_price.
   end.
   repeat with frame a:
   update operators def-stat.
   if input operators = "" then do:
   		{mfmsg.i 40 3}
   		next-prompt operators.
   		undo,retry.
   end.
    leave.
   end.
   for each tmpsh exclusive-lock:
   		 assign tsh_stat = input def-stat.
   end.
      {xxselect.i}
   assign yn = no.
	 {pxmsg.i &MSGNUM=12
	          &CONFIRM=yn
	          &ERRORLEVEL=1}
	 if yn then do:
	 		for each tmpsh no-lock,
	 		    each xxsh_mst exclusive-lock where xxsh_domain = global_domain
	 		    			    and xxsh_site = tsh_site and xxsh_nbr = tsh_nbr
	 		    			    and xxsh_abs_id = "S" + tsh_abs_id:
	 		    assign xxsh_stat = tsh_stat 
	 		    			 xxsh_userid = operators.	 				
	 	  end.
	 end.
	 clear frame b.
	 hide frame b.
end.

status input.
