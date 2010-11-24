/* xxsor001.p - TRANSACTION BY qc REPORT                                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*SS - BY ken 100607.1 */

{mfdtitle.i "100607.1"}

define variable site like si_site .
define variable site1 like si_site .
define variable part1 like pt_part .
define variable part like pt_part .
DEFINE VARIABLE from_date AS DATE.
DEFINE VARIABLE to_date AS DATE.
DEFINE VARIABLE from_trnbr LIKE tr_trnbr.
DEFINE VARIABLE to_trnbr LIKE tr_trnbr.
DEFINE VARIABLE loc LIKE tr_loc.
DEFINE VARIABLE loc1 LIKE tr_loc.
DEFINE VARIABLE loc_from LIKE tr_loc.
DEFINE VARIABLE loc_to LIKE tr_loc.
DEFINE VARIABLE effdate LIKE tr_effdate.
DEFINE VARIABLE effdate1 LIKE tr_effdate.
DEFINE VARIABLE nbr LIKE tr_nbr.
DEFINE VARIABLE nbr1 LIKE tr_nbr.
define variable type like glt_tr_type format "x(8)".
define variable desc1 like pt_desc1 format "x(49)" no-undo.
DEFINE VARIABLE amt AS DECIMAL.
DEFINE VARIABLE lot LIKE tr_lot.
DEFINE VARIABLE lot1 LIKE tr_lot.

DEFINE VARIABLE lotser_from LIKE tr_serial.
DEFINE VARIABLE lotser_to LIKE tr_serial.

FORM   
      nbr        COLON 15    nbr1      LABEL {t001.i} COLON 45

      effdate    COLON 15    effdate1  LABEL {t001.i} COLON 45
      site       COLON 15    site1     LABEL {t001.i} COLON 45
      loc        COLON 15    loc1      LABEL {t001.i} COLON 45
      loc_from   COLON 15    loc_to    LABEL {t001.i} COLON 45
      part       COLON 15    part1     LABEL {t001.i} COLON 45
      lotser_from COLON 15   lotser_to LABEL {t001.i} COLON 45
 with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if site1 = hi_char then site1 = "" .
   if part1 = hi_char then part1 = "".
   IF FROM_date = low_date THEN  from_date = ?.
   IF TO_date = hi_date  THEN TO_date = ?.
   IF loc1 = hi_char THEN loc1 = "".
   IF loc_to = hi_char THEN loc_to = "".
   IF effdate1 = hi_date THEN effdate1 = ?.
   IF nbr1 = hi_char THEN nbr1 = "".
   IF lot1 = hi_char THEN lot1 = "".
   IF lotser_to = hi_char THEN lotser_to = "".
   IF effdate = low_date THEN effdate = ?.
   if c-application-mode <> 'web' then
   
   update  nbr nbr1 site effdate effdate1 site1 loc loc1 loc_from loc_to part part1 lotser_from lotser_to with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 site effdate effdate1 site1 loc loc1 loc_from loc_to part part1  lotser_from lotser_to " &frm = "a"}

   
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site       }
      {mfquoter.i site1      }
      {mfquoter.i part       }
      {mfquoter.i part1      }
    

       
      if part1 = "" then part1 = hi_char .
      if site1 = "" then site1 = hi_char .
      IF FROM_date = ? THEN   FROM_date = low_date.
      IF TO_date = ? THEN   TO_date = hi_date.
      IF loc1 = "" THEN loc1 = hi_char.
      IF loc_to = "" THEN loc_to = hi_char.
      IF effdate1 = ? THEN effdate1 = hi_date.
      IF effdate = ? THEN effdate = low_date.
      IF nbr1 = "" THEN nbr1 = hi_char.
      IF lot1 = "" THEN lot1 = hi_char.
      IF lotser_to = "" THEN lotser_to = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printnbr = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementnbr = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
               

   DEFINE  TEMP-TABLE tt1
       FIELD tt1_date AS DATE
       FIELD tt1_nbr LIKE prh_receiver
       FIELD tt1_locto AS CHARACTER
       FIELD tt1_locfrom AS CHARACTER
       FIELD tt1_line LIKE prh_line
       FIELD tt1_part AS CHARACTER
       FIELD tt1_part_name AS CHARACTER
       FIELD tt1_part_gg AS CHARACTER
       FIELD tt1_um AS CHARACTER
       FIELD tt1_qty AS DECIMAL
       FIELD tt1_lot AS CHARACTER
       FIELD tt1_rmks AS CHARACTER.

   /*
   {mfphead.i}
   */
   EMPTY TEMP-TABLE tt1.
	FOR EACH usrw_wkfl WHERE usrw_domain = GLOBAL_domain 
      AND usrw_key1 = "SS-ICTR"
      AND usrw_key3 >= nbr
      AND usrw_key3 <= nbr1
      AND usrw_datefld[1] >= effdate
      AND usrw_datefld[1] <= effdate1
      AND usrw_charfld[1] >= site
      AND usrw_charfld[1] <= site1
      AND usrw_charfld[2] >= loc
      AND usrw_charfld[2] <= loc1
      AND usrw_charfld[3] >= loc_from
      AND usrw_charfld[3] <= loc_to
      AND usrw_charfld[6] >= part 
      AND usrw_charfld[6] <= part1
      AND usrw_charfld[4] >= lotser_from
      AND usrw_charfld[4] <= lotser_to
      AND usrw_key5 = "ICTR"
      NO-LOCK BY usrw_key3 BY usrw_intfld[1]:
       /*
       DISP 
          usrw_key3      COLUMN-LABEL "领料单号"
          usrw_intfld[1] COLUMN-LABEL "项次" 
          usrw_charfld[6] COLUMN-LABEL "料号" 
          usrw_charfld[2] COLUMN-LABEL "申请库位"
          usrw_charfld[3] COLUMN-LABEL "发出库位"
          usrw_charfld[4] COLUMN-LABEL "批号"
          usrw_charfld[5] COLUMN-LABEL "参考"
          usrw_decfld[1] COLUMN-LABEL "数量"
          usrw_key4 COLUMN-LABEL "是否发放" WITH WIDTH 200 STREAM-IO. 
       */
       FIND FIRST tt1 WHERE tt1_nbr = usrw_key3
          AND tt1_line = usrw_intfld[1]
          NO-LOCK NO-ERROR.
       IF NOT AVAIL tt1 THEN DO:
          CREATE tt1.
          ASSIGN tt1_date = usrw_datefld[1]
                 tt1_nbr = usrw_key3
                 tt1_locto = usrw_charfld[2]
                 tt1_locfrom = usrw_charfld[3]
                 tt1_line = usrw_intfld[1]
                 tt1_part = usrw_charfld[6]
                 tt1_qty = usrw_decfld[1]
                 tt1_lot = usrw_charfld[4]
                 .
          FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
             AND pt_part = usrw_charfld[6] NO-LOCK NO-ERROR.
          IF AVAIL pt_mstr THEN DO:
             tt1_part_name = pt_desc1 + pt_desc2.
             tt1_part_gg = pt__chr01.
             tt1_um = pt_um.
          END.
       END.
   END.


   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   FOR EACH tt1 BY tt1_nbr:
      EXPORT DELIMITER ";" tt1.
   END.
       
   /* REPORT TRAILER */
   /*
   {mfrtrail.i}
   */
    {mfreset.i}
end.

{wbrp04.i &frame-spec = a}
