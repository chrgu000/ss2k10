/* xxqccstrp.p - qa cost report                                               */
/*V8:ConvertMode=FullGUIReport                                                */
{mfdtitle.i "111230.1"}

define variable vl as integer.
define variable xap as com-handle.
define variable xwb as com-handle.
define variable xws as com-handle.
define variable vname as character.

define variable dt  as date.
define variable dt1 as date.

form
   dt  colon 20
   dt1 colon 40 label {t001.i}
with frame a side-labels width 80 attr-space.

/* ET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign dt1 = today - day(today).
assign dt = date(month(dt1),1,year(dt1)).

{wbrp01.i}
repeat:

   if dt = low_date then dt = ?.
   if dt1 = hi_date then dt1 = ?.

   if c-application-mode <> 'web' then
      update dt dt1 with frame a.

   {wbrp06.i &command = update &fields = " dt dt1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if dt = ? then dt = low_date.
      if dt1 = ? then dt1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 140
               &pagedFlag = "nopage"
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


session:set-wait-stat("general").
   CREATE "Excel.Application" xap.
   xwb = xap:Workbooks:add().
   xws = xap:sheets:item(1) no-error.
   xwb:Activate.
   xws:cells(1,1) = getTermLabel("DATE",12).
   xws:cells(1,2) = getTermLabel("USER_ID",12).
   xws:cells(1,3) = getTermLabel("USER_NAME",12).
   xws:cells(1,4) = getTermLabel("ITEM_NUMBER",12).
   xws:cells(1,5) = getTermLabel("EFFECTIVE_DATE",12).
   xws:cells(1,6) = getTermLabel("REMARKS",12).
   xws:cells(1,7) = getTermLabel("TRANSACTION_TYPE",12).
   xws:cells(1,8) = getTermLabel("AMOUNT",12).
   assign vl = 2.
FOR EACH tr_hist NO-LOCK use-index tr_type WHERE tr_domain = global_domain
     AND tr_type = "iss-unp"
     AND tr_effdate >= dt AND tr_effdate <= dt1
     AND tr_rmks <> "":
     assign vname = "".
     find first usr_mstr no-lock where usr_userid = tr_userid no-error.
     if available usr_mstr then do:
        assign vname = usr_name.
     end.
      xws:cells(vl,1) = tr_date.
      xws:cells(vl,2) = tr_userid.
      xws:cells(vl,3) = vname.
      xws:cells(vl,4) = tr_part.
      xws:cells(vl,5) = tr_effdate.
      xws:cells(vl,6) = tr_rmks.
      xws:cells(vl,7) = tr_type.
      xws:cells(vl,8) = tr_gl_amt.
      assign vl = vl + 1.
END.
   xap:visible = true.
   xwb:saved = true.
/*    xap:quit. */
   release OBJECT xws.
   release OBJECT xwb.
   release OBJECT xap.
session:set-wait-stat("").
   {mfreset.i}
end.

{wbrp04.i &frame-spec = a}
