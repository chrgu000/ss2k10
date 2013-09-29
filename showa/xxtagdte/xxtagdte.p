/* xxpkditem.p - Pakge D type item list maintenance                          */
/* revision: 120614.1   created on: 20120614   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "130928.1"}
define variable vkey1 like usrw_key1 no-undo
                  initial "TAG-COUNT-DEF_DATE".
define variable del-yn like mfc_logical.
form
   usrw_key1 colon 25 format "x(20)"
   usrw_key2 colon 25 format "x(18)" skip(2)
   usrw_datefld[1] colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   display vkey1 @ usrw_key1 vkey1 @ usrw_key2.
   /* Determine length of field as defined in db schema */

   find usrw_wkfl where usrw_key1 = input usrw_key1 and
                        usrw_key2 = input usrw_key2 no-error.

   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl.
      assign
         usrw_key1 usrw_key2.
   end. /* if not available usrw_wkfl then do: */

   ststatus = stline[2].
   status input ststatus.

  repeat with frame a:
         update usrw_datefld[1]
         go-on(F5 CTRL-D).
        if input usrw_datefld[1] = ? then do:
           {pxmsg.i &MSGTEXT=""日期不可为空"" &ERRORLEVEL=3}
           undo,retry.
        end.
        message "确定要调整盘点日期?" update del-yn.
        if del-yn then do:
           for each tag_mstr exclusive-lock where tag_cnt_dt = ?:
               assign tag_cnt_dt = usrw_datefld[1].
           end.
        end.
        message "更新完成!" view-as alert-box.
        leave.
  end.
   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete usrw_wkfl.
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */
leave.
end. /* repat with frame a. */
status input.
