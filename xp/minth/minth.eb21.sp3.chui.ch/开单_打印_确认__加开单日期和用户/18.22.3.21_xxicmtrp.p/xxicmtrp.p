/* xxpptrmt.p  -- 入库单列印 */
/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090915.1  By: Roger Xiao */ /*增加打印标识*/

/* DISPLAY TITLE */
{mfdtitle.i "090915.1"}

 {xxicmtvar1.i new}
define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.

DEFINE VARIABLE inv_recid as recid.

p-type = "MT".
form
/*   prodline	  colon 25 label "生产线(生产线仓库)"
   p-type         colon 50 label "单号类型" */
   rcvno          colon 25 label "车间转移单号码"
/*   loc-to         colon 50 label  "入库仓位" */
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat with frame a:

   seta:

   do on error undo, retry:

      if batchrun then do
      with frame aatch 2 columns width 80 no-attr-space:

         prompt-for
      
          rcvno
 
         with frame aatch.

         assign
          
          rcvno
 .

         display
          
          rcvno
	  
         .

      end.

      else do:

         update
          rcvno
         with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp05.i xic_det xic_nbr  " xic_det.xic_domain = global_domain and xic_type = p-type "   xic_nbr   " input rcvno" }

        if recno <> ? then do:
	   display xic_nbr @ rcvno  with frame a.
	   rcvno = xic_nbr.
	end. /* if recno<>? */
         end.

      end.

         
	 
	display prodline   with frame a.
		  
      bcdparm = "".

       
      {mfquoter.i rcvno     }
      
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

		{gprun.i ""xxicmtrpa.p""}
/* SS - 090915.1 - B */
for each xic_det 
    where xic_det.xic_domain = global_domain 
    and xic_nbr = rcvno :
    xic_print = yes .
    if xic_date  = ?  then xic_date  = today.
    if xic_user1 = "" then xic_user1 = global_userid .
end. 
/* SS - 090915.1 - E */    
      {mfreset.i}

   end.

end.
