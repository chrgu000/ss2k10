/* xxvifile.p - View file                                                    */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110712.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable file_name as character format "x(50)".
define variable lngdir    like lng_dir.
define temp-table tf
    fields tf_txt as character format "x(200)" column-label "CONTENT".

form
   lngdir    colon 15
   file_name colon 15 skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

ON LEAVE OF lngdir IN FRAME a /* Fill 1 */
DO:
  assign lngdir.
  for each qad_wkfl exclusive-lock where qad_key1 = "xxvifile.p":
      delete qad_wkfl.
  end.
  if lngdir = "" then assign lngdir:screen-value = ".".
  assign lngdir.
  INPUT FROM OS-DIR(lngdir).
  REPEAT:
      CREATE qad_wkfl.
      IMPORT qad_key4 qad_key2 qad_key5.
      assign qad_key1 = "xxvifile.p"
             qad_key3 = global_userid.
  END.
  INPUT CLOSE.

  for each qad_wkfl exclusive-lock where qad_key1 = "xxvifile.p"
       and qad_key5 <> "F":
      delete qad_wkfl.
  end.
END.

ON CTRL-D OF file_name IN FRAME a /* Fill 1 */
DO:
  define variable yn as logical initial no.
  {pxmsg.i &MSGNUM=7169 &ERRORLEVEL=2 &CONFIRM=yn}
  if yn then do:
    for each qad_wkfl exclusive-lock where qad_key1 = "xxvifile.p" and
           qad_key3 = global_userid:
      delete qad_wkfl.
	  end.
	end.
END.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
      update lngdir file_name with frame a.

   {wbrp06.i &command = update &fields = "  file_name" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " nopage "
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
	  empty temp-table tf no-error.
/*    {mfphead.i}     */
    for each qad_wkfl no-lock where qad_key1 = "xxvifile.p" and
             qad_key3 = global_userid and
             index(qad_key4,file_name) > 0:
        create tf.
        assign tf_txt = "-- File:[" + trim(qad_key4) + "] Beging "
                      + fill("-", 71 - length(trim(qad_key4))).
        input from value(qad_key2).
        repeat:
          create tf.
          import unformat tf_txt.
        end.
        input close.
        create tf.
        assign tf_txt = "-- File:[" + trim(qad_key4) + "] End "
                      + fill("-", 74 - length(trim(qad_key4))).
    end.

    for each tf no-lock with frame b:
        display tf_txt no-label with width 220.
    end.

    setFrameLabels(frame b:handle).
    {mfreset.i}
/*  {mfrtrail.i}  */
end.

{wbrp04.i &frame-spec = a}
