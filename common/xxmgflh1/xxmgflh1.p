/* xxmgflh1.p - import program help                                          */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 0BYJ LAST MODIFIED: 05/27/11 BY: zy                             */
/* REVISION END                                                              */

{mfdtitle.i "15YQ"}

&SCOPED-DEFINE mgbdpro_p_14 "Input File Name"

define variable file_name as character format "x(36)"
   label {&mgbdpro_p_14}.
define variable l_delete  like mfc_logical   label "Delete"  no-undo.

define variable i as integer.
define variable beffld as character.
define variable befpg  as character.
DEFINE TEMP-TABLE tt1
       FIELD tt1_lang LIKE flhd_lang
       FIELD tt1_field LIKE flhd_field
       FIELD tt1_call_pg LIKE flhd_call_pg
       FIELD tt1_line LIKE flhd_line
       FIELD tt1_text LIKE flhd_text
       INDEX i1 is primary tt1_lang tt1_field tt1_call_pg tt1_line
       .

form
   file_name colon 12 skip(1)
   l_delete  colon 12
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   tt1_lang
   tt1_field
   tt1_call_pg
   tt1_line
   tt1_text
with frame b side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


/* Display Utility Information */
{gpcdget.i "UT"}

repeat:

   view frame a.

   display
      file_name l_delete
   with frame a.

   set
      file_name l_delete
   with frame a.

    IF search(file_name) = ? THEN DO:
      /* 找不到文件:# */
      {pxmsg.i &MSGNUM=391 &ERRORLEVEL=3 &MSGARG1=file_name}
      UNDO,RETRY.
   END.
   {mfquoter.i file_name }
    EMPTY TEMP-TABLE tt1 no-error.
    INPUT FROM VALUE(file_name).
    REPEAT:
       CREATE tt1.
       IMPORT DELIMITER "~011" tt1_lang tt1_field tt1_call_pg tt1_text no-error.
    END.
    INPUT CLOSE.

    for each tt1 exclusive-lock by recid(tt1):
        if tt1_LANG = "" THEN DO:
           DELETE TT1.
           NEXT.
        END.
        if tt1_field <> beffld or tt1_call_pg <> befpg then do:
            assign i = 1.
        end.
        assign tt1_line = i.
        assign beffld = tt1_field
               befpg = tt1_call_pg.
        i = i + 1.
    end.

  FOR EACH tt1 NO-LOCK BREAK BY tt1_lang
     BY tt1_field BY tt1_call_pg BY tt1_line:
     IF FIRST-OF(tt1_call_pg) THEN DO:
        FIND FIRST flhm_mst WHERE flhm_lang = tt1_lang AND
                   flhm_field = tt1_field AND flhm_call_pg = tt1_call_pg
             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE flhm_mst THEN DO:
           CREATE flhm_mst.
           ASSIGN
              flhm_lang = tt1_lang
              flhm_field = tt1_field
              flhm_call_pg = tt1_call_pg
              .
        END.
        assign i = 1.
        if l_delete then do:
           FOR EACH flhd_det WHERE flhd_lang = tt1_lang AND
                    flhd_field = tt1_field AND
                    flhd_call_pg = tt1_call_pg AND
                    flhd_type = "user":
              DELETE flhd_det.
           END.
        end.
        else do:
          find last flhd_det WHERE flhd_lang = tt1_lang AND
                    flhd_field = tt1_field AND
                    flhd_call_pg = tt1_call_pg no-error.
          if available flhd_det then do:
             assign i = flhd_line + 1.
          end.
        end.
     END. /* IF FIRST-OF(tt1_call_pg) THEN DO: */

     CREATE flhd_det.
     ASSIGN
        flhd_lang = tt1_lang
        flhd_field = tt1_field
        flhd_call_pg = tt1_call_pg
        flhd_type = "user"
        flhd_line = i
        flhd_text = tt1_text
        .
        i = i + 1.
  END.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

for each tt1 no-lock with frame b:
    display tt1.
end.

   /* REPORT TRAILER */
   {mfrtrail.i}

end. /* REPEAT */
