/* By: Neil Gao Date: 07/12/14 ECO: * ss 20071214 * */
{mfdtitle.i "1"}

define var del-yn as logical.

form
   xxsov_nbr      colon 25
   xxsov_line     colon 25
   xxsov_part     colon 25
   pt_desc1       colon 25 no-label  
   skip(1)
	 xxsov_seqid    colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
view frame a.

mainloop:
repeat:
   do transaction:
   	
      prompt-for xxsov_nbr xxsov_line with frame a
      editing:
         
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i xxsov_mstr xxsov_nbr  " xxsov_domain = global_domain and
         xxsov_nbr "  xxsov_nbr xxsov_nbr xxsov_nbr}

         if recno <> ? then do:

            
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = xxsov_part no-lock no-error.
            
            display xxsov_nbr xxsov_line xxsov_part 
            	pt_desc1
            	xxsov_seqid
              with frame a.
            
         end. /* IF RECNO <> ? */
      end. /* EDITING */
   end.  /* transaction */

   
   do transaction:

      find first xxsov_mstr where xxsov_domain = global_domain and xxsov_nbr = input xxsov_nbr 
      	and xxsov_line = input xxsov_line no-error.
      if not avail xxsov_line then do:
      	find first sod_det where sod_domain = global_domain and sod_nbr = input xxsov_nbr 
      		and sod_line = input xxsov_line no-lock no-error.
      	if not avail sod_det then do:
      		message "¶©µ¥²»´æÔÚ!".
      		next mainloop.
      	end.
      	else do:
      		create 
      	end.
      end.
      
      /* ADD/MODIFY/DELETE */
      seta-2:
      do with frame a on error undo, retry:
         set
            xxsov_seqid
            go-on ("F5" "CTRL-D").

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then undo seta-2, retry seta-2.
         end.
         if del-yn then do:

            delete xxsov_mstr.
            clear frame a.
            {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
            del-yn = no.
            next mainloop.
         end.

      end. /* seta-2 */

   end.  /*transaction*/

   clear frame a.

end. /* repeat */
status input.
