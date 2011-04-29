/* ss - 100611.1 by:jack */
/* ss - 100623.1 by: jack */
/* ss - 100714.1 by: jack */
/* ss - 100809.1 by: jack */
/* ss - 100810.1 by: jack */
/* SS - 101208.1  By: Roger Xiao */ /*原版本为100809.1,现与100810.1整合, 所有本子程式的修改同时影响3.5.1和3.5.2!! */

{mfdeclre.i}  
{gplabel.i} 

 DEFINE  INPUT PARAMETER v_rcvno  LIKE xxrt_nbr .

 {xxricrt1var1.i new}
define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.


DEFINE VARIABLE inv_recid as recid.

rcvno = v_rcvno .

form

   rcvno          colon 25 label "退料单号码"
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
p-type = "RT".
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
        {mfnp05.i xxrt_det xxrt_nbr  " xxrt_det.xxrt_domain = global_domain and xxrt_type = p-type "   xxrt_nbr   " input rcvno" }

        if recno <> ? then do:
	   display xxrt_nbr @ rcvno  with frame a.
	   rcvno = xxrt_nbr.
	end. /* if recno<>? */
         end.

      end.

         
	 
   /*  display prodline   with frame a.    */
		  
      bcdparm = "".

       
      {mfquoter.i rcvno     }
      
   /* OUTPUT DESTINATION SELECTION */
      /* SELECT PRINTER */
          /*
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
                  */
           {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 0
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

		{gprun.i ""xxricrt1a.p""}

      {mfreset.i}

   end.

end.