/* xxlvr.p - lv report                                                        */
/*V8:ConvertMode=FullGUIReport                                                */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "23YO"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable l_prod as character format 'x(30)'.
define variable l_prod1 as character format 'x(30)'.
define variable loc_phys_addr as character format "x(20)".
define variable sub1          as character format "x(20)".
define variable fg      as character format "x(76)".
define variable del-yn  as logical.
form
   skip(.1)
   l_prod  colon 20
   l_prod1 colon 20 label {t001.i}
   loc_phys_addr colon 20  
   sub1          colon 20 label {t001.i} skip(2)
   del-yn  colon 32
   skip(2)
with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
    skip(.1)
       usrw_key1  colon  20 format "x(20)"
       usrw_key2  colon  54 format "x(20)"
       usrw_key3  colon  20 format "x(20)"
       usrw_key4  colon  54 format "x(20)"
       usrw_key5  colon  20 format "x(20)"
       usrw_key6  colon  54 format "x(20)"
       usrw_intfld[1] colon 20
       usrw_datefld[1] colon 54
       usrw_charfld[10] colon 20 format "x(56)"
       usrw_datefld[2] colon 20
       usrw_intfld[2] colon 54
       fg no-label
with frame b side-labels width 80 attr-space.
setFrameLabels(frame b:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:

   if l_prod1 = hi_char then l_prod1 = "".
   if sub1 = hi_char then sub1 = "".
   if c-application-mode <> 'web' then
      update l_prod l_prod1 loc_phys_addr sub1 del-yn with frame a.

   {wbrp06.i &command = update 
             &fields = " l_prod l_prod1 loc_phys_addr sub1 del-yn" 
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if l_prod1 = "" then l_prod1 = hi_char.
      if sub1 = "" then sub1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "Printer"
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

  {mfphead2.i}
  assign fg = fill("-",80).
   for each usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}
            usrw_key1 >= l_prod and usrw_key1 <= l_prod1 and
            usrw_key2 >= loc_phys_addr and usrw_key2 <= sub1:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display usrw_key1
              usrw_key2
              usrw_key3
              usrw_key4
              usrw_key5
              usrw_key6
              usrw_intfld[1]
              usrw_datefld[1]
              usrw_datefld[2]
              usrw_charfld[10]
              string(usrw_intfld[2],"HH:MM:SS") @ usrw_intfld[2]
              fg
               with frame b.
      {mfrpchk.i}
      down with frame b.
   end.
   {mftrl080.i}
   if del-yn then do:
    for each usrw_wkfl exclusive-lock where {xxusrwdom1.i} {xxand.i}
            usrw_key1 >= l_prod and usrw_key1 <= l_prod1 and
            usrw_key2 >= loc_phys_addr and usrw_key2 <= sub1:
        delete usrw_wkfl.
    end.
    {mfmsg.i 22 1}
   end.
end.

{wbrp04.i &frame-spec = a}
