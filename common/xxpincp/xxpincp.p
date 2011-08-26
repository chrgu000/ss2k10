/* xxpincp - pin_mstr Copy                                                   */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/* revision: 110725.1   created on: 20110725   by: SamSong                   */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110725.1"}

define variable cp-yn  like mfc_logical initial no.
define variable s_prod like pin_product.
define variable d_prod like pin_product.
define variable s_desc like pin_desc.
define variable d_desc like pin_desc.
define variable vf     as   character.

/* DISPLAY SELECTION FORM */

form
   s_prod colon 20
   s_desc colon 40  no-label skip(1)
   d_prod colon 20
   d_desc colon 20 skip(1)
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   prompt-for s_prod editing:
     /* FIND NEXT/PREVIOUS RECORD */
     if frame-field = "s_prod" then do:
      {mfnp.i pin_mstr s_prod pin_product s_prod pin_product pin_product}
        if recno <> ? then do:
           display pin_product @ s_prod pin_desc @ s_desc with frame a.
        end.
     end.
     else do:
          readkey.
          apply lastkey.
     end.
   end.
  assign s_prod.
  if s_prod = "" then do:
     {pxmsg.i &MSGNUM= 4452 &ERRORLEVEL=3 &MSGARG1=""s_prod""}
     undo,retry.
  end.
  if not can-find(first pin_mstr no-lock where pin_product = s_prod) then do:
     /*源数据不存在*/
     {pxmsg.i &MSGNUM= 4482 &ERRORLEVEL=3 &MSGARG1=s_prod}
     undo, retry.
  end.
  do on error undo, retry:
     update d_prod
            d_desc.
      if d_prod = "" then do:
         {pxmsg.i &MSGNUM= 4452 &ERRORLEVEL=3 &MSGARG1=""d_prod""}
         undo,retry.
      end.
      if s_prod = d_prod then do:
         {pxmsg.i &MSGNUM= 8923 &ERRORLEVEL=3}
         undo, retry.
      end.
      if can-find(first pin_mstr no-lock where pin_product = d_prod ) then do:
         /*目标数据已存在*/
         {pxmsg.i &MSGNUM= 8922 &ERRORLEVEL=3
                  &MSGARG1=d_prod}
         undo, retry.
      end.
  end.

  cp-yn = yes.

  /* Please confirm copy */
  {pxmsg.i &MSGNUM=3058  &ERRORLEVEL=1 &CONFIRM=cp-yn}

  if cp-yn then do:
      define buffer pin for pin_mstr.
      for first pin no-lock where pin_product = s_prod :
      create pin_mstr.
      assign
          pin_mstr.pin_product    = d_prod
          pin_mstr.pin_desc       = d_desc
          pin_mstr.pin_hwm        = pin.pin_hwm
          pin_mstr.pin_control1   = pin.pin_control1
          pin_mstr.pin_control2   = pin.pin_control2
          pin_mstr.pin_control3   = pin.pin_control3
          pin_mstr.pin_control4   = pin.pin_control4
          pin_mstr.pin_control5   = pin.pin_control5
          pin_mstr.pin_inst_date  = pin.pin_inst_date
          pin_mstr.pin_user1      = pin.pin_user1
          pin_mstr.pin_user2      = pin.pin_user2
          pin_mstr.pin__qadc01    = pin.pin__qadc01
          pin_mstr.pin__qadi01    = pin.pin__qadi01
          pin_mstr.pin__qadd01    = pin.pin__qadd01
          pin_mstr.pin__qadl01    = pin.pin__qadl01
          pin_mstr.pin__qadt01    = pin.pin__qadt01
          pin_mstr.pin_control6   = pin.pin_control6
          pin_mstr.pin_inst_time  = pin.pin_inst_time
          pin_mstr.pin_mod_userid = pin.pin_mod_userid
          pin_mstr.pin_mod_date   = pin.pin_mod_date
          pin_mstr.pin_aud_days   = pin.pin_aud_days
          pin_mstr.pin_aud_ddate  = pin.pin_aud_ddate
          pin_mstr.pin_aud_date   = pin.pin_aud_date
          pin_mstr.pin_aud_user   = pin.pin_aud_user
          pin_mstr.pin_aud_pswd   = pin.pin_aud_pswd
          pin_mstr.pin_aud_nbr    = pin.pin_aud_nbr.
      end.

      assign vf = "tmp" + string(today,"99999999") + string(time).
      output to value(vf + ".in").
      put unformat global_userid skip.
      put "-" skip.
      put "-" skip.
      put unformat '"' d_prod '"' skip.
      put unformat "yes" skip.
      put unformat "." skip.
      put unformat "yes" skip.
      output close.

      batchrun  = yes.
      input from value(vf + ".in").
      output to value(vf + ".ou") keep-messages.
      hide message no-pause.
      {gprun.i ""mgurmt.p""}
      hide message no-pause.
      output close.
      input close.
      batchrun  = no.

      os-delete value(vf + "*") no-error.

     {pxmsg.i &MSGNUM=7 &ERRORLEVEL=1}
  end.
end.

status input.
