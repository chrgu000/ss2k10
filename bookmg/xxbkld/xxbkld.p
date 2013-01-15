 /* xxbkreg.p - book reg                                                      */
 /*V8:ConvertMode=Maintenance                                                 */
 /* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
 /* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
 /* REVISION END                                                              */

{mfdtitle.i "130110.1"}
{xxbkmg.i}
/* DISPLAY SELECTION FORM */
define variable vstat as character.
define variable vavail like mfc_logical.
define variable venddate as date.
define variable vmsg as character.
define variable vname as character.
form
   xxbl_bkid     colon 20
   xxbk_name     colon 20
   xxbk_stat     colon 20
   xxbk_price    colon 20
   xxbl_start    colon 20 skip(1)
   xxbl_bcid     colon 20 vname no-label
   xxbl_end      colon 20
   xxbl_ret      colon 20
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
               assign vstat = "".
               find first usrw_wkfl no-lock where usrw_key1 = v_key_book02
                      and usrw_key2 = xxbk_stat no-error.
               if available usrw_wkfl then do:
                  assign vstat = usrw_key3.
               end.
               display xxbk_id @ xxbl_bkid xxbk_name vstat @ xxbk_stat xxbk_price
                       with frame a.
            end.
         end.
         if frame-field = "xxbl_start" then do:
            /* FIND NEXT/PREVIOUS RECORD */
         {mfnp06.i xxbl_hst xxbl_start " xxbl_bkid  = input xxbl_bkid"
            xxbl_start "input xxbl_start" xxbl_start "input xxbl_start"}

            if recno <> ? then do:
               vname = "".
               find first xxbc_lst no-lock where xxbc_id = xxbl_bcid no-error.
               if available xxbc_lst then do:
                  assign vname = xxbc_name.
               end.
               display xxbl_bkid xxbl_start xxbl_bcid vname
                       xxbl_end xxbl_ret with frame a.
            end.
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end.
    find first xxbk_lst no-lock where xxbk_id = input xxbl_bkid no-error.
    if not available xxbk_lst then do:
       {mfmsg.i 7776 3}
       next-prompt xxbl_bkid with frame a.
       undo,retry.
    end.
    find first usrw_wkfl no-lock where usrw_key1 = v_key_book02
           and usrw_key2 = xxbk_stat no-error.
    if available usrw_wkfl and not usrw_logfld[1] then do:
       {mfmsg.i 7777 3}
       next-prompt xxbl_bkid with frame a.
       undo,retry.
    end.
    find last xxbl_hst no-lock where xxbl_bkid = input xxbl_bkid no-error.
    if available xxbl_hst and xxbl_ret = ? then do:
       assign vmsg = "".
       find first xxbc_lst no-lock where xxbc_id = xxbl_bcid no-error.
       if available xxbc_lst then do:
          assign vmsg = xxbc_id + " " + xxbc_name.
       end.
      {pxmsg.i &MSGNUM=7778
               &MSGARG1=vmsg
               &ERRORLEVEL=3}
       next-prompt xxbl_bkid with frame a.
       undo,retry.
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
             xxbl_end = getPlanReturnDay(xxbl_bkid,xxbl_start).
   end.
   display xxbl_bcid xxbl_end with frame a.

   ststatus = stline[2].
   status input ststatus.
   repeat with frame a:
          assign vmsg = getmsg(7781).
          update xxbl_bcid xxbl_end validate(xxbl_ret = ?,vmsg) go-on(F5 CTRL-D).
          if xxbl_bcid = "" then do:
            {mfmsg.i 40 3}
             next-prompt xxbl_bcid.
             undo,retry.
          end.
          if xxbl_end = ? then do:
          	 {mfmsg.i 40 3}
             next-prompt xxbl_end.
             undo,retry.
          end.
   end.
       /* DELETE */
       if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
       then do:
         {mfmsg.i 7780 3}

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
       end.

/*       if del-yn then do:              */
/*          delete xxbl_hst.             */
/*          clear frame a.               */
/*       end.                            */

end.

status input.
