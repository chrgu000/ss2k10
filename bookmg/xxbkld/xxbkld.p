 /* xxbkreg.p - book reg                                                      */
 /*V8:ConvertMode=Maintenance                                                 */
 /* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
 /* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
 /* REVISION END                                                              */

{mfdtitle.i "130110.1"}

/* DISPLAY SELECTION FORM */
form
   xxbl_bkid     colon 20
   xxbl_start    colon 20 skip(1)
   xxbl_bcid     colon 20
   xxbl_end      colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
	    prompt-for xxbl_bkid xxbl_start with frame a
	    editing:

	       if frame-field = "xxbl_bkid" then do:
	          /* FIND NEXT/PREVIOUS RECORD */
	           {mfnp.i xxbk_lst xxbl_bkid xxbk_id xxbl_bcid xxbk_id xxbk_id}
	          if recno <> ? then do:
	             display xxbk_id @ xxbl_bkid with frame a.
	          end.
	       end.
	       if frame-field = "xxbl_start" then do:
	          /* FIND NEXT/PREVIOUS RECORD */

         {mfnp06.i xxbl_hst xxbl_start " xxbl_bkid  = input xxbl_bkid"
            xxbl_start "input xxbl_start" xxbl_start "input xxbl_start"}

	          if recno <> ? then do:
	             display xxbl_bkid xxbl_start with frame a.
	          end.
	       end.
	       else do:
	          status input.
	          readkey.
	          apply lastkey.
	       end.
	    end.
    if input xxbl_start = ? then do:
    	 display today @ xxbl_start.
    end.
   /* ADD/MOD/DELETE  */
   find first xxbl_hst using xxbl_start where xxbl_bkid = input xxbl_bkid
          and xxbl_start = input xxbl_start no-error.
   if not available xxbl_hst then do:
      {mfmsg.i 1 1}
      create xxbl_hst.
      assign xxbl_bkid
      		   xxbl_start.
   end.

   ststatus = stline[2].
   status input ststatus.

   update xxbl_bcid xxbl_end go-on(F5 CTRL-D).

/*     /* DELETE */                                                          */
/*     if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")             */
/*     then do:                                                              */
/*        find first xxbl_hst where xxbl_bkid = xxbl_bkid and xxbl_end = ?   */
/*             no-lock no-error.                                             */
/*        if available xxbl_hst then do:                                     */
/*  /* ---CANNOT DELETE. LEND HISTORY DETAIL RECORDS EXIST"---*/             */
/*           {pxmsg.i &MSGNUM = 7770 &ERRORLEVEL = 3}                        */
/*           next.                                                           */
/*           del-yn = no.                                                    */
/*        end.                                                               */
/*        else do:                                                           */
/*             del-yn = yes.                                                 */
/*             {mfmsg01.i 11 1 del-yn}                                       */
/*        end.                                                               */
/*     end.                                                                  */
/*                                                                           */
/*     if del-yn then do:                                                    */
/*        delete xxbl_hst.                                                   */
/*        clear frame a.                                                     */
/*     end.                                                                  */

end.

status input.
