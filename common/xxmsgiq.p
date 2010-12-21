/* xxmsgiq.p - MESSAGE INQUIRY                                               */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* DISPLAY TITLE */
{mfdtitle.i "09Y1"}

define variable nbr    as   integer  format ">>>>>>9".
define variable lang   like msg_lang.
define variable lngdesc like lng_desc.
define variable incl   as   character format "x(24)".
define variable dcount as   integer.
DEFINE BUTTON   bfree  LABEL "œ–÷√".
/* DISPLAY TITLE */

form
   space(1)
   lang  colon 10 format "x(4)" lngdesc
   nbr   colon 10
   incl  colon 28 bfree
with frame a side-labels width 80.
enable bfree with frame a.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
on "choose":U of bfree do:
  define variable i as integer.
  define variable v as character format "x(78)".
  assign lang.
  for each msg_mstr where msg_lang = lang break by msg_lang:
  i = i + 1.
   if i <> msg_nbr and not last-of (msg_lang) then do:
      assign v = v + " " + string(i,"->>>>>>9").
      if length(v) >= 72 then do:
          display v column-label
                  "                           °æœ–÷√œ˚œ¢∫≈¬Î√˜œ∏°ø"
                  with frame x 17 down.
          assign v = "".
      end.
   end.
  end.
end.
lang = global_user_lang.

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
      update nbr incl with frame a.

   {wbrp06.i &command = update &fields = " lang nbr incl" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   dcount = 0.

   for each msg_mstr where
            msg_lang = lang and
            msg_nbr >= nbr and (index(msg_desc,incl) > 0 or incl = "")
   no-lock with frame f-a:

      {mfrpchk.i}

      setFrameLabels(frame f-a:handle). /* SET EXTERNAL LABELS */

      display
         msg_nbr format "->>>>>9"
         msg_desc
      with width 80.

      dcount = dcount + 1.

      if dev <> "terminal" and dcount modulo 5 = 0 then
         put skip(1).

   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
