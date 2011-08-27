/* xxpincp - pin_mstr Copy                                                   */
/* revision: 110827.1   created on: 20110827   by: zhang yun                 */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "18YR"}

define variable cp-yn  like mfc_logical initial no.
define variable s_prod like pin_product.
define variable d_prod like pin_product.
define variable s_desc like pin_desc.
define variable d_desc like pin_desc.
define variable vf     as   character.
define variable l_listVers as character no-undo.
define variable l_thisVers as character no-undo.
define variable l_appl_desc like lpm_desc label "Description" no-undo.
define variable l-err-nbr   like msg_nbr no-undo.
/* Get Versions List */
{gprunp.i "lvgenpl" "p" "getVersionList"
          "(output l_listVers,output l_thisVers)" }
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
           {gprunp.i "lvgenpl" "p" "validateApplicationRegistered"
            "(input  pin_product,
              input  no,
              output l_appl_desc,
              output l-err-nbr)"}
           display pin_product @ s_prod l_appl_desc @ s_desc with frame a.
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
     /*source data not fond.*/
     {pxmsg.i &MSGNUM= 4482 &ERRORLEVEL=3 &MSGARG1=s_prod}
     undo, retry.
  end.

  do on error undo,retry:
     prompt-for d_prod editing:
     /* FIND NEXT/PREVIOUS RECORD */
     if frame-field = "d_prod" then do:
      {mfnp.i lpm_mstr d_prod lpm_product d_prod lpm_product lpm_product}
        if recno <> ? then do:
           display lpm_prod @ d_prod  lpm_desc @ d_desc with frame a.
           assign d_prod d_desc.
        end.
     end.
     else do:
          readkey.
          apply lastkey.
     end.

      if d_prod = "" then do:
         {pxmsg.i &MSGNUM= 4452 &ERRORLEVEL=3 &MSGARG1=""d_prod""}
         undo,retry.
      end.
      if s_prod = d_prod then do:
         {pxmsg.i &MSGNUM= 8923 &ERRORLEVEL=3}
         undo, retry.
      end.
      if can-find(first pin_mstr no-lock where pin_product = d_prod ) then do:
         {pxmsg.i &MSGNUM= 8922 &ERRORLEVEL=3
                  &MSGARG1=d_prod}
         undo, retry.
      end.
  end.
end.
    assign d_prod d_desc.
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

      assign vf = "tmp.xxpincp." + string(today,"99999999") + string(time).
      output to value(vf + ".in").
        if l_thisVers = "eB2" then do:
             put unformat global_userid skip.
             put "-" skip.
             put "-" skip.
             put unformat '"' d_prod '"' skip.
             put unformat "yes" skip.
             put unformat "." skip.
             put unformat "yes" skip.
        end.
        else do:
            put unformat global_userid skip.
            put "-" skip.
            put "-" skip.
            put "-" skip.
            put "." skip.
            put unformat '"' d_prod '"' skip.
            put unformat "yes" skip.
            put unformat "." skip.
            put unformat "yes" skip.
        end.
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
      os-delete value(vf + ".in") no-error.
      os-delete value(vf + ".ou") no-error.

     {pxmsg.i &MSGNUM=7 &ERRORLEVEL=1}
  end.
end.
status input.
