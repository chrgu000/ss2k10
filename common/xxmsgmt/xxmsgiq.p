/* xxmsgrp.p - Message REPORT                                                */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 09Y1 LAST MODIFIED: 09/20/10   BY: zy                           */
/* REVISION: 0CYK LAST MODIFIED: 12/17/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "4CYK"}

define variable nbr_from as integer  format ">>>>>>9".
define variable lang    like msg_lang.
define variable lngdesc like lng_desc.
define variable ans_include as character format "x(120)".
define variable ipd_include as character format "x(120)".
define variable dcount as integer.
define variable idle  as logical.

form
   lang        colon 10 format "x(4)" lngdesc colon 32
   nbr_from    colon 10
   ans_include colon 32 view-as fill-in size 34 by 1
   ipd_include colon 32 view-as fill-in size 34 by 1 skip(1)
   idle        colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
  assign lang = global_user_lang.
 find first lng_mstr no-lock where lng_lang = lang no-error.
 if available lng_mstr then do:
    display lng_lang @ lang lng_desc @ lngdesc with frame a.
 end.
 prompt-for lang with frame a editing:
   {mfnp05.i lng_mstr lng_lang yes lng_lang "input lang"}
    if recno <> ? then do:
         assign lang = lng_lang
                lngdesc = lng_desc.
       display lng_lang @ lang lng_desc @ lngdesc with frame a.
    end.
 end.
 assign lang.
 find first lng_mstr no-lock where lng_lang = lang no-error.
 if available lng_mstr then do:
    display lng_lang @ lang lng_desc @ lngdesc with frame a.
 end.

   if c-application-mode <> 'web' then
      update nbr_from ans_include ipd_include idle with frame a.

   {wbrp06.i &command = update
             &fields = " nbr_from ans_include ipd_include idle"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

   end.

  /* OUTPUT DESTINATION SELECTION */
 {mfselprt.i "page" 80}
 {mfphead2.i}  /* PRINT PAGE HEADING FOR REPORTS 80 COLUMNS */

    dcount = 0.
if idle then do:
  define variable i as integer.
  define variable v as character format "x(78)".
  for each msg_mstr where msg_lang = lang break by msg_lang:
  i = i + 1.
   if i <> msg_nbr and not last-of (msg_lang) then do:
      assign v = v + " " + string(i,"->>>>>>9").
      if length(v) >= 70 then do:
          display v column-label
                  "                           ¡¾¿ÕÏÐÏûÏ¢ºÅÂëÃ÷Ï¸¡¿"
                  with frame x 17 down.
          assign v = "".
      end.
   end.
  end.
end.
else do:
   for each msg_mstr where msg_lang = lang and msg_nbr >= nbr_from and
           (index(msg_desc,ans_include) > 0 or ans_include = "") and
           (index(msg_desc,ipd_include) > 0 or ipd_include = "")
           no-lock with frame f-a width 80:
      {mfrpchk.i}
      setFrameLabels(frame f-a:handle). /* SET EXTERNAL LABELS */
      display
         msg_nbr format "->>>>>9"
         msg_desc format 'x(70)'.
      dcount = dcount + 1.
      if dev <> "terminal" and dcount modulo 5 = 0 then
         put skip(1).
   end.
end.
   {mftrl080.i}  /* REPORT TRAILER */
end.

{wbrp04.i &frame-spec = a}
