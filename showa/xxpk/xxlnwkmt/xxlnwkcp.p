/* xxlnwkcp.p - xxlnwkcp.p Assembline work time copy                         */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:9.lD   QAD:eb2sp4    Interface:Character            */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy                             */
/* REVISION END                                                              */


/* DISPLAY TITLE */
{mfdtitle.i "120620"}
define variable del-yn as logical.
define variable where_from like ln_line.
define variable prline like ln_line.
define variable prline1 like ln_line.
define variable l_copy as logical.
define variable site as character initial "gsa01".
define variable vfile as character.
define variable save_rfile as character format "x(40)".
/* DISPLAY SELECTION FORM */
form
   site     colon 20
   where_from      colon 20 skip(1)
   prline     colon 20  prline1 colon 40 skip (1)
   save_rfile colon 20
   l_copy    colon 20
with frame a side-labels width 80 attr-space.
display site with frame a.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for where_from prline prline1 editing:
      /* FIND NEXT/PREVIOUS RECORD */
      if frame-field = "where_from" then do:
         {mfnp.i ln_mstr where_from ln_line site ln_site ln_linesite}
         if recno <> ? then do:
            display ln_line @ where_from
            with frame a.
         end.
      end. /* if frame-field */
      else if frame-field = "prline" then do:
          {mfnp.i ln_mstr prline ln_line site ln_site ln_linesite}
         if recno <> ? then do:
            display ln_line @ prline
            with frame a.
         end.
      end. /* else if */
      else if frame-field = "prline1" then do:
          {mfnp.i ln_mstr prline1 ln_line site ln_site ln_linesite}
         if recno <> ? then do:
            display ln_line @ prline1
            with frame a.
         end.
      end. /* else if */
      else do:
         readkey.
         apply lastkey.
      end.
   end.
   where_from = input where_from.
   prline = input prline.
   prline1 = input prline1.
   if input where_from = "" then do:
      {mfmsg.i 40 3}
      undo, retry.
   end.

   if not can-find(first xxlnw_det no-lock where xxlnw_site= input site 
                     and xxlnw_line = where_from) then do:
      {mfmsg.i 855 3}
      undo,retry.
   end.
   assign save_rfile = "xxlnwkmt." + string(today,"9999-99-99") + "."
                     +  string(time,"hh:mm:ss") + ".bak".
   display save_rfile with frame a.
   set l_copy.
   if not l_copy then do:
      {mfmsg.i 118 3}
      undo,retry.
   end.

   output to value(save_rfile).
   for each xxlnw_det no-lock where xxlnw_site = site and  xxlnw_line >= prLine
        and (xxlnw_line <= prLine1 or prline1 = "")
        break by xxlnw_site by xxlnw_line by xxlnw_sn:
        if first-of(xxlnw_line) then do:
           put unformat "@@BATCHLOAD xxlnwkmt.p" skip.
           put unformat '"' xxlnw_line '" "' xxlnw_site '"' skip.
           put unformat '-' skip.
        end.
           put unformat xxlnw_sn skip.
           put unformat xxlnw_on ' ' xxlnw_start ' ' xxlnw_end ' '
                        xxlnw_pick ' '
                        xxlnw_picks ' ' xxlnw_picke ' '
                        xxlnw_sends ' ' xxlnw_sende ' '
                        xxlnw_rstmin ' '
                        xxlnw_shift skip.
        if last-of(xxlnw_line) then do:
           put unformat "." skip.
           put unformat "@@END" skip.
        end.
   end.
   output close.

   assign vfile = "xxlnwkcp.p" + string(today,"9999-99-99") + string(time).
   output to value(vfile + ".bpi").
   for each ln_mstr no-lock where ln_site = site and ln_line >= prline and
            (ln_line <= prline1 or prline1 = "") break by ln_site by ln_line:
           put unformat '"' ln_line '" "' ln_site '"' skip.
           put unformat '-' skip.
       for each xxlnw_det no-lock where xxlnw_site = site and 
                xxlnw_line = where_from
           break by xxlnw_sn:
           put unformat xxlnw_sn skip.
           put unformat xxlnw_on ' ' xxlnw_start ' ' xxlnw_end ' '
                        xxlnw_pick ' '
                        xxlnw_picks ' ' xxlnw_picke ' '
                        xxlnw_sends ' ' xxlnw_sende ' '
                        xxlnw_rstmin ' '
                        xxlnw_shift skip.
       end.
           put unformat '.' skip.
   end.
   output close.

   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""xxlnwkmt.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
   {mfmsg.i 7 1}

end.

status input.
