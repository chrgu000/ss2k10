/* xxpptrmt.p  -- 调拨单列印 */
/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */



/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090915.1  By: Roger Xiao */ /*增加打印标识*/

/* DISPLAY TITLE */
{mfdtitle.i "090915.1"}

 {xxicuivar1.i new}
define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.

DEFINE VARIABLE inv_recid as recid.


form
/*   prodline	  colon 25 label "生产线(生产线仓库)"
   p-type         colon 50 label "单号类型" */
   rcvno          colon 25 label "入库单号码"
   prodline       colon 50 label "库位"
/*   loc-to         colon 50 label  "入库仓位" */
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


repeat with frame a:

   seta:

   do on error undo, retry:

      if batchrun then do
      with frame aatch 2 columns width 80 no-attr-space:

         prompt-for rcvno  with frame aatch.

         assign rcvno .

         display   rcvno .
	 
      end.

      else do:

         update
          rcvno
         with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */
       /* {mfnp05.i xic_det xic_nbr  " xic_det.xic_domain = global_domain and xic_type = p-type "   xic_nbr   " input rcvno" } */
       {mfnp.i xic_det rcvno  " xic_det.xic_domain = global_domain and xic_nbr "  rcvno xic_nbr  xic_nbr }

        if recno <> ? then do:
	   display xic_nbr @ rcvno  xic_loc_from @ prodline with frame a.
	   rcvno = xic_nbr.
	end. /* if recno<>? */
         end.

      end.

      
       find first xic_det where xic_det.xic_domain = global_domain and xic_nbr = rcvno no-lock no-error .
	 if available xic_det then do :
	   find first xxicm_mstr where xxicm_domain = global_domain and  xxicm_type = xic_type and xxicm_confirm = 1 no-lock no-error .
	     if available xxicm_mstr then do :	 
         	display xic_nbr @ rcvno xic_loc_from @ prodline   with frame a.
	      end .
	      else do :
	       message "请输入计划外入库资料" view-as alert-box .
	       undo seta ,retry seta .
	       end .
	  end .
	  else do :
	     message "所输入单号不存在!" view-as alert-box .
             undo seta ,retry seta .
	  end .
		
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

		{gprun.i ""xxicuirpa01.p""}

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
