/* mgmsgiq.p - MESSAGE INQUIRY                                               */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */
/* REVISION: 1.0      LAST MODIFIED: 04/28/11   BY: zy                    *4R*/

/* DISPLAY TITLE */
{mfdtitle.i "14YR"}
define variable lang     like lbl_lang.
define variable lblterm  like lbl_term format "x(42)".
define variable cdref  as character format "x(42)".
define variable dcount as integer.
define variable showdet as logical.
/* DISPLAY TITLE */

form
   space(1)
   lang    colon 14 format "x(4)" skip(1)
   lblterm colon 14
   cdref   colon 14 skip(1)
   showdet colon 34 skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

lang = global_user_lang.

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update lang lblterm cdref showdet with frame a.

{wbrp06.i &command = update &fields = " lang lblterm cdref showdet" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
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

   for each lbl_mstr where
            lbl_lang = lang and (lbl_term = lblterm or lblterm = "") and
           (index(lbl_long,cdref) > 0 or cdref = "")
   no-lock with frame b width 320 no-attr-space:

      {mfrpchk.i}

      setFrameLabels(frame b:handle). /* SET EXTERNAL LABELS */
      display lbl_term lbl_long lbl_medium lbl_short.
/*4R*/ IF showdet THEN DO:
/*4R*/    if can-find (first lbld_det no-lock where lbld_term = lbl_term)
/*4R*/    then do:
/*4R*/       down 1.
/*4R*/    end.
/*4R*/    for each lbld_det no-lock where lbld_term = lbl_term with frame b:
/*4R*/        display lbld_fieldname @ lbl_long format "x(42)"
/*4R*/                lbld_execname @ lbl_medium format "x(42)".
/*4R*/        down 1.
/*4R*/    end.
/*4R*/ END.
      dcount = dcount + 1.

      if dev <> "terminal" and dev <> "page" and dev<> "printer"
         and dcount modulo 5 = 0 then
         put skip(1).

   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
