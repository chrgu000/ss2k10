/* xxpincp - pin_mstr Copy                                                   */
/* revision: 110827.1   created on: 20110827   by: zhang yun                 */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "24YJ"}

define variable cLoadFile  like mfc_logical initial no.
define variable s_prod like pin_product.
define variable d_prod like pin_product.
define variable s_desc like pin_desc.
define variable d_desc like pin_desc.
define variable vf     as   character.
define variable l_appl_desc like lpm_desc label "Description" no-undo.
define variable l-err-nbr   like msg_nbr no-undo.
define variable filename as character format "x(40)".

/* DISPLAY SELECTION FORM */

form
   s_prod colon 20
   s_desc colon 40  no-label skip(1)
   d_prod colon 20
   d_desc colon 20 skip(1)
   filename colon 20 skip(1)
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
{xxchklv.i 'MODEL-CAN-RUN' 10}
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
  end.
end.
    assign d_prod d_desc.
    assign filename = "xx" + lower(d_prod) + ".p".
    display filename with frame a.
  set filename.
/*  if not can-find(first pin_mstr no-lock where pin_product = d_prod ) then do:*/
/*     {pxmsg.i &MSGNUM= 8922 &ERRORLEVEL=3 &MSGARG1=d_prod}                    */
/*     undo, retry.                                                             */
/*  end.                                                                        */
  /* Please confirm copy */


  run genPinfile(input filename).  
  if not can-find(first pin_mstr no-lock where pin_product = d_prod ) then do:     
     assign cLoadFile = yes.                                 
    {pxmsg.i &MSGNUM=7193  &ERRORLEVEL=1 &CONFIRM=cLoadFile}
    if cLoadFile then do:
       assign vf = "xxpincp" + string(today,"99999999") + string(time).
       output to value(vf + ".bpi").
              put unformat "yes" skip.
       output close.
    
         batchrun  = yes.
         input from value(vf + ".bpi").
         output to value(vf + ".bpo") keep-messages.
         hide message no-pause.
         run value(filename).
         hide message no-pause.
         output close.
         input close.
         batchrun  = no.
         {pxmsg.i &MSGNUM=2044 &ERRORLEVEL=1}  /*已安装*/
    
       os-delete value(filename) no-error.
       os-delete value(vf + ".bpi").
       os-delete value(vf + ".bpo").
    end.
    else do:
         {pxmsg.i &MSGNUM=1856 &ERRORLEVEL=1} /*未安装*/
         {pxmsg.i &MSGNUM=4804 &ERRORLEVEL=1 &MSGARG1=filename} /*生产文件*/
    end.
  end.
  else do:
      {pxmsg.i &MSGNUM=2044 &ERRORLEVEL=1}  /*已安装*/
      {pxmsg.i &MSGNUM=4804 &ERRORLEVEL=1 &MSGARG1=filename}
  end.
end.
status input.
Procedure genPinfile:
    define input parameter iFile as character.
    define buffer pin for pin_mstr.
    output to value(iFile).
        put unformat '~/*V8:ConvertMode=Maintenance' fill(" ",50) '*~/' skip.
        put unformat '~{mfdtitle.i "' string(today,"999999") '.1"~}' skip.
        put unformat '~{gpcdget.i "UT"~}' skip(1).
        put unformat 'define variable l_listVers as character no-undo.' skip.
        put unformat 'define variable l_thisVers as character no-undo.' skip.
        put unformat "define variable vf as character no-undo." skip.
        put unformat 'define variable yn like mfc_logical no-undo.' skip.
        put unformat 'Form yn colon 40' skip.
        put unformat 'with frame a side-labels width 80 attr-space.' skip.
        put unformat 'setFrameLabels(frame a:handle).' skip(1).
        put unformat 'repeat with frame a:' skip.
        put unformat 'update yn.' skip.
        put unformat 'if not yn then leave.' skip(1).
        put unformat '~/* Get Versions List *~/' skip.
        put unformat '~{gprunp.i "lvgenpl" "p" "getVersionList"' skip.
        put unformat '"(output l_listVers,output l_thisVers)" ~}' skip.

   for first pin no-lock where pin_product = s_prod:
       put unformat 'create pin_mstr.' skip.
       put unformat 'assign' skip.
       put unformat '    pin_mstr.pin_product    = "' d_prod '"' skip.
       put unformat '    pin_mstr.pin_desc       = "' d_desc '"'skip.
       put unformat '    pin_mstr.pin_hwm        = ' pin.pin_hwm skip.
       put unformat '    pin_mstr.pin_control1   = "' pin.pin_control1 '"' skip.
       put unformat '    pin_mstr.pin_control2   = "' pin.pin_control2 '"' skip.
       put unformat '    pin_mstr.pin_control3   = "' pin.pin_control3 '"' skip.
       put unformat '    pin_mstr.pin_control4   = "' pin.pin_control4 '"' skip.
       put unformat '    pin_mstr.pin_control5   = "' pin.pin_control5 '"' skip.
       if pin.pin_inst_date <> ? then do:
          put unformat '    pin_mstr.pin_inst_date  = date('.
          put unformat month(pin.pin_inst_date) ',' day(pin.pin_inst_date).
          put unformat ',' year(pin.pin_inst_date) ')' skip.
       end.
       put unformat '    pin_mstr.pin_user1      = "' pin.pin_user1 '"' skip.
       put unformat '    pin_mstr.pin_user2      = "' pin.pin_user2 '"' skip.
       put unformat '    pin_mstr.pin__qadc01    = "' pin.pin__qadc01 '"' skip.
       put unformat '    pin_mstr.pin__qadi01    = ' pin.pin__qadi01 skip.
       put unformat '    pin_mstr.pin__qadd01    = ' pin.pin__qadd01 skip.
       put unformat '    pin_mstr.pin__qadl01    = ' pin.pin__qadl01 skip.
       if pin.pin__qadt01 <> ? then do:
          put unformat '    pin_mstr.pin__qadt01    = date('.
          put unformat month(pin.pin__qadt01) ',' day(pin.pin__qadt01).
          put unformat ',' year(pin.pin__qadt01) ')' skip.
       end.
       put unformat '    pin_mstr.pin_control6   = "' pin.pin_control6 '"' skip.
       put unformat '    pin_mstr.pin_inst_time  = ' pin.pin_inst_time skip.
       put unformat '    pin_mstr.pin_mod_userid = global_userid' skip.
       put unformat '    pin_mstr.pin_mod_date   = today' skip.
       put unformat '    pin_mstr.pin_aud_days   = ' pin.pin_aud_days skip.
       if pin.pin_aud_ddate <> ? then do:
          put unformat '    pin_mstr.pin_aud_ddate  = date('.
          put unformat month(pin.pin_aud_ddate) ',' day(pin.pin_aud_ddate).
          put unformat ',' year(pin.pin_aud_ddate) ')'  skip.
       end.
       if pin.pin_aud_date <> ? then do:
          put unformat '    pin_mstr.pin_aud_date   = date('.
          put unformat month(pin.pin_aud_date) ',' day(pin.pin_aud_date).
          put unformat ',' year(pin.pin_aud_date) ')'  skip.
       end.
       put unformat '    pin_mstr.pin_aud_user   = "' pin.pin_aud_user '"' skip.
       put unformat '    pin_mstr.pin_aud_pswd   = "' pin.pin_aud_pswd '"' skip.
       put unformat '    pin_mstr.pin_aud_nbr    = ' pin.pin_aud_nbr "." skip.
   end. /* for first pin no-lock where pin_product = s_prod: */

      put skip.
      put unformat 'assign vf = "tmp.xxpincp." + string(today,"99999999")'.
      put unformat '+ string(time).' skip.
      put unformat 'output to value(vf + ".bpi").' skip.
      put unformat '  if l_thisVers = "eB2" then do:' skip.
      put unformat '       put unformat global_userid skip.' skip.
      put unformat '       put "-" skip.' skip.
      put unformat '       put "-" skip.' skip.
      put unformat '       put unformat "' d_prod '" skip.' skip.
      put unformat '       put unformat "yes" skip.' skip.
      put unformat '       put unformat "." skip.' skip.
      put unformat '       put unformat "yes" skip.' skip.
      put unformat '  end.' skip.
      put unformat '  else do:' skip.
      put unformat '      put unformat global_userid skip.' skip.
      put unformat '      put "-" skip.' skip.
      put unformat '      put "-" skip.' skip.
      put unformat '      put "-" skip.' skip.
      put unformat '      put "." skip.' skip.
      put unformat '      put unformat "' d_prod '" skip.' skip.
      put unformat '      put unformat "yes" skip.' skip.
      put unformat '      put unformat "." skip.' skip.
      put unformat '      put unformat "yes" skip.' skip.
      put unformat '  end.' skip.
      put unformat 'output close.' skip.
      put skip.
      put unformat 'batchrun  = yes.' skip.
      put unformat 'input from value(vf + ".bpi").' skip.
      put unformat 'output to value(vf + ".bpo") keep-messages.' skip.
      put unformat 'hide message no-pause.' skip.
      put unformat '\{gprun.i ""mgurmt.p""}' skip.
      put unformat 'hide message no-pause.' skip.
      put unformat 'output close.' skip.
      put unformat 'input close.' skip.
      put unformat 'batchrun  = no.' skip.
      put unformat 'os-delete value(vf + ".bpi") no-error.' skip.
      put unformat 'os-delete value(vf + ".bpo") no-error.' skip.
      put unformat 'leave.' skip.
      put unformat 'end.' skip.
    output close.
end procedure.