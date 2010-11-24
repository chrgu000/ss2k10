/* Revision: 1.31        BY: Ken Casey          DATE: 02/19/04 ECO: *N2GM*    */
/* $Revision: 1.32 $      BY: Sukhad Kulkarni    DATE: 02/08/05 ECO: *P37G*    */
/* $Revision: 1.32 $      BY: ken    chen        DATE: 08/06/08 ECO: *SS - 100607.1*    */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*DISPLAY TITLE          */

{mfdtitle.i "100607.1"}

DEFINE NEW SHARED VARIABLE nbr AS CHARACTER FORMAT "x(12)".
DEFINE NEW SHARED VARIABLE loc_from LIKE loc_loc.
DEFINE NEW SHARED VARIABLE loc_to   LIKE loc_loc.
DEFINE NEW SHARED VARIABLE eff_date  AS DATE.
DEFINE NEW SHARED VARIABLE site        LIKE pt_site.
DEFINE NEW SHARED VARIABLE site1        LIKE pt_site.

DEFINE NEW SHARED VARIABLE Hash     AS DECIMAL FORMAT "->>>>>>>>.9999".

define variable peryr         as character .


DEFINE NEW SHARED TEMP-TABLE iss    
                  FIELD iss_part      LIKE tr_part
                  FIELD iss_site      LIKE tr_site
                  FIELD iss_loc       LIKE tr_loc
                  FIELD iss_serial    LIKE tr_serial
                  FIELD iss_ref       LIKE tr_ref
                  FIELD iss_locto     LIKE tr_loc
                  FIELD iss_loc_qty   AS DECIMAL FORMAT "->>>>>>9.9999"
                  FIELD iss_um        LIKE pt_um
                  FIELD iss_trnbr     AS INTEGER FORMAT "->9"
                  INDEX iss_part iss_part .


DEFINE NEW SHARED TEMP-TABLE isslog    
                  FIELD isslog_part      LIKE tr_part
                  FIELD isslog_site      LIKE tr_site
                  FIELD isslog_loc       LIKE tr_loc
                  FIELD isslog_serial    LIKE tr_serial
                  FIELD isslog_ref       LIKE tr_ref
                  FIELD isslog_loc_qty   AS DECIMAL FORMAT "->>>>>>9.9999"
                  FIELD isslog_um        LIKE pt_um
                  FIELD isslog_ok        AS LOGICAL
                  FIELD isslog_trnbr     AS INTEGER FORMAT "->9"
                  INDEX isslog_part isslog_part .



/* INPUT OPTION FORM */
form
   nbr           colon 10
   site          COLON 29
   loc_from      COLON 49
   eff_date      colon 10
   site1         COLON 29
   loc_to        colon 49  
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



eff_date = today.
site = GLOBAL_site.

/* DISPLAY */
mainloop:
repeat:

         clear frame c all no-pause.

         clear frame d no-pause.



   nbr = "".

   display site eff_date  with frame a.




   SET
      nbr 
      eff_date 
      site
      loc_from
      site1
      loc_to
   with frame a
   editing:

        ASSIGN GLOBAL_site = INPUT site .
        IF frame-field = "loc_to" THEN  DO:
           ASSIGN GLOBAL_site = INPUT site1 .
        END.
         status input.
         readkey.
         apply lastkey.
   end.

   assign
      nbr loc_to loc_from
      eff_date
      site 
      site1
       .
  


   /* Check Site Security */
   /*
   {gprun.i ""gpsiver.p""
            "(site,recid(si_mstr), output return_int)"}
   if return_int = 0 then do:
          {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}    /* USER DOES NOT HAVE */
          /* ACCESS TO THIS SITE*/
          next-prompt site with frame a.
         undo , retry .
   end.


   /* Check LOC Security */
   {gprun.i ""xxgploca.p""
            "(site,loc_to,recid(si_mstr), output return_int)"}
   if return_int = 0 then do:
          {pxmsg.i &MSGNUM=7099 &ERRORLEVEL=3}    /* USER DOES NOT HAVE */
          /* ACCESS TO THIS loc*/
          next-prompt loc_to with frame a.
         undo , retry .
   end.
   */



    /*
    IF eff_date > TODAY THEN  DO:

        {pxmsg.i &MSGNUM=91019 &ERRORLEVEL=3}  
        next-prompt eff_date with frame a.
        undo,RETRY.
    END.
    */
   
   IF nbr = "" THEN DO:
       {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
           UNDO,RETRY.
   END.
   ELSE DO:
      FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
         AND usrw_key1 = "SS-ICTR"
         AND usrw_key3 = nbr 
         AND usrw_key4 = "YES"
         NO-LOCK NO-ERROR.
      IF AVAIL usrw_wkfl THEN DO:
         MESSAGE("领料单号已经确认,重新输入领料单号").
         UNDO,RETRY.
      END.
      ELSE DO:
         FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
            AND usrw_key3 = nbr 
            AND usrw_key6 = "YES"
            NO-LOCK NO-ERROR.
         IF AVAIL usrw_wkfl THEN DO:
            MESSAGE("领料单号已经批准,不能修改,重新输入领料单号").
            UNDO,RETRY.
         END.      
      END.

      MESSAGE nbr.
      FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
         AND usrw_key1 = "SS-ICTR"
         AND usrw_key3 = nbr 
      NO-LOCK NO-ERROR.
      IF AVAIL usrw_wkfl THEN DO:      
         EMPTY TEMP-TABLE iss.
         FOR EACH usrw_wkfl WHERE usrw_domain = GLOBAL_domain
            AND usrw_key1 = "SS-ICTR"
            AND usrw_key3 = nbr NO-LOCK:
            CREATE iss.
            ASSIGN iss_site = usrw_charfld[1]
                   iss_locto = usrw_charfld[2]
                   iss_loc = usrw_charfld[3]
                   iss_serial = usrw_charfld[4]
                   iss_ref = usrw_charfld[5]
                   iss_loc_qty = usrw_decfld[1]
                   iss_trnbr = usrw_intfld[1]
                   iss_part = usrw_charfld[6]
                   .
            site = usrw_charfld[1].
            loc_from = usrw_charfld[3].
            loc_to = usrw_charfld[2].
            eff_date = usrw_datefld[1].
            site1 = usrw_charfld[10].
         END.
      END.
      ELSE DO:
         EMPTY TEMP-TABLE iss.
      END.
   END.



   IF NOT CAN-FIND(FIRST loc_mstr WHERE loc_domain = GLOBAL_domain AND loc_site = site1 AND loc_loc = loc_to)  OR loc_to = "" THEN DO:
           
           {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}

           UNDO,RETRY.
   END.


   IF NOT CAN-FIND(FIRST loc_mstr WHERE loc_domain = GLOBAL_domain AND loc_site = site AND loc_loc = loc_from)  OR loc_from = "" THEN DO:
           {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
           UNDO,RETRY.
   END.

   IF loc_from = loc_to THEN DO:

       MESSAGE "错误:库位相同".
       UNDO,RETRY.

   END.

   if eff_date = ? then eff_date = today.

   {glper1.i eff_date peryr}

   if peryr = "" then do:
        {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}  /* INVALID PERIOD/YEAR */
        next-prompt eff_date with frame a.
        undo,RETRY.
   end. /* IF PERYR = "" */

   display
      nbr
      site
      loc_from
      site1
      loc_to
      eff_date
   with frame a.

   if eff_date = ? then eff_date = today.

/* 
FOR EACH iss :
     FIND FIRST isslog WHERE isslog_trnbr = iss_trnbr  NO-LOCK NO-ERROR.
     IF AVAIL isslog  THEN DO:
         IF isslog_ok = TRUE THEN
             DELETE iss.
     END.
     ELSE DO:

         DELETE iss.
     END.
END.
*/
   {gprun.i ""xxwowoisc01.p"" }



end.
