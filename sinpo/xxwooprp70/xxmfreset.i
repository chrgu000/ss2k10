/* mfreset.i - RESET PRINTER/CLOSE OUTPUT INCLUDE FILE                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 4.0      LAST MODIFIED: 11/24/87   BY: WUG                       */
/* REVISION: 4.0      LAST MODIFIED: 02/10/88   BY: WUG *A175*                */
/* REVISION: 4.0      LAST MODIFIED: 06/23/88   BY: emb *A295*                */
/* REVISION: 4.0      LAST MODIFIED: 07/25/88   BY: WUG *A356*                */
/* REVISION: 5.0      LAST MODIFIED: 04/13/89   BY: WUG *B080*                */
/* REVISION: 5.0      LAST MODIFIED: 05/01/89   BY: WUG *B098*                */
/* REVISION: 5.0      LAST MODIFIED: 05/22/90   BY: EMB *B695*                */
/* REVISION: 5.0      LAST MODIFIED: 11/19/90   BY: WUG *B820*                */
/* REVISION: 5.0      LAST MODIFIED: 11/28/90   BY: emb *B827*                */
/* Revision: 7.3      Last modified: 09/16/92   By: jcd *G058*                */
/* Revision: 7.3      Last modified: 11/30/92   By: jcd *G361*                */
/*           7.3                     09/10/94   By: bcm *GM84*                */
/*           7.3                     09/10/94   By: jzs *G0FB*                */
/*           7.3                     11/06/95   By: rkc *G1CC*                */
/*           7.3                     12/15/95   By: rwl *F0WR*                */
/*           7.3                     02/26/96   By: rkc *G1MR*                */
/* Revision: 8.6      Last modified: 09/17/97   By: kgs *K0J0*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* Revision: 8.6E     Last modified: 05/28/98   By: Mohan CK *K1QW*           */
/* Revision: 8.6E     Last modified: 10/04/98   By: *J314* Alfred Tan         */
/* Revision: 9.1      Last modified: 09/21/99   By: *N03C* Karl Nolan         */
/* REVISION: 9.1      LAST MODIFIED: 07/18/00   BY: *N0GB* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15       BY: Katie Hilbert        DATE: 03/23/01  ECO: *P008*  */
/* $Revision: 1.16 $    BY: Jean Miller          DATE: 09/02/04  ECO: *Q0CP*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*
PURPOSE:
This file has the following responsibilities
    send post report printed control codes to destination device
    close output destination set in printer selection program
    reset terminal width to 80 characters
    delete terminal window (GUI only)
    execute operating system specific post report command
    process output to winprint or email

NOTE:
This file is tightly coupled with the files gpselout.i, gpprsout.i and
gpprtrpa.i. It references variables defined in these files.
*/

/*! {1} "stream ..." if necessary */

runok = yes.

/* Generalized variables required for web-enable mode */
{wbgp03.i}

&IF '{&C-WEBOUT-DEV-VAR}' = '' &THEN
   define variable c-webout-dev as character no-undo.
   &GLOBAL-DEFINE C-WEBOUT-DEV-VAR yes
&ENDIF

if c-application-mode = 'WEB' then
   /*GETS A FIELD VALUE FROM OUTPUT OPTION TOKEN IN "wbgp02.i"*/
   run get-outopt-field in h-wblib
      (input 'OPTION',
       output c-webout-dev).

/* FOR DISPLAY TO SCREEN IN WEB MODE, NEED FINAL DISPLAY TO FORCE */
/* DISPLAY OF LAST FRAME OF DATA AND OUTPUT MESSAGE "End of Report" */
if c-application-mode = 'WEB' and
   c-web-request = 'DATA'
then do:

   display skip " " with frame wbrfoot{&SEQUENCE}.

   put stream webstream unformatted skip {&WEB-BREAK-TAG}
      skip(1) "--- "
      {gplblfmt.i &FUNC=getTermLabel(""END_OF_REPORT"",20)
                  &CONCAT="' ---'"}.
end.

else if c-application-mode <> 'WEB'
     or c-webout-dev = '{&REMOTE-PRINTER}'
then do:
   /*V8! if path <> "terminal" then */
   if available prd_det then
      /*SEND POST PRINT CONTROL CODES TO DEVICE */
      put {*} control prd_det.prd_reset.

   /* CLOSE OUTPUT STREAM, WITH NO PAUSE */
   repeat:
      output {*} close.
      pause 0 no-message.
      leave.
   end.

/*V8!
   if available prd_det and prd_dest_type = 2 then do:
      /*PROCESS OUTPUT TO WINPRINT */
      {gprunp.i "gpwinprt" "p" "processWinprint"
         "(input printWidth, input l_textFile, input batchrun)"}
      /* DELETE PERSISTENT PROCEDURE */
      {gpdelp.i "gpwinprt" "p"}
      /* DELETE FILE USED TO SEND OUTPUT TO WINPRINT */
      {gpfildel.i &filename=l_textfile}
   end.
*/

   if available prd_det and prd_dest_type = 1 then do:
      /* PROCESS OUTPUT TO E-MAIL */
      {gprunp.i "gpemail" "p" "processEmail" "(input l_textFile)"}
      /* DELETE PERSISTENT PROCEDURE */
      {gpdelp.i "gpemail" "p"}
      /* DELETE FILE USED TO SEND E-MAIL */
      {gpfildel.i &filename=l_textfile}
   end.

   /*RESET TERMINAL TO 80 CHARACTER TERMINAL*/
   if printype = "printer" and path = "terminal" then
      {gprun.i ""gpreterm.p""}

/*V8!
   /*DELETE GUI WINDOW*/
   if path = "terminal" then do:
     if valid-handle(terminal-window) then do:
       /* Delete the terminal paged window */
       current-window = save-window.
       if valid-handle(save-proc-window) then
       assign
         THIS-PROCEDURE:CURRENT-WINDOW = save-proc-window
         save-proc-window = ?.

       delete widget terminal-window.
       assign
          save-window = ?
          terminal-window = ?.
     end.
   end.
*/

   /*SEND OPERATING SYSTEM COMMAND TO RESET DEVICE*/
   /* Fully qualified prd_det fields below */
   if available prd_det and prd_det.prd_rset_pro <> "" then do:
      if opsys = "unix" then
         unix silent value(prd_det.prd_rset_pro).
      else
      if opsys = "msdos" or opsys = "win32" then
         dos silent value(prd_det.prd_rset_pro).
   end.

end. /*else if c-application-mode <> 'WEB'...*/


/* If in web mode, do report termination logic and then exit the report */
/* (looping back for another set of user input is suppressed). */
if c-application-mode = 'WEB' then do:
   /*END THE DATA REPLY ( SEND A MESSAGE IF REMOTE PRINTING ) */
   run web-end-data-reply in h-wblib.
   leave.
end.

/*IF "scrollonly" IS NO THEN OUTPUT WILL GO TO "Device Pathname" */
/*SPECIFIED ELSE IF THE "scrollonly" IS YES, THE OUTPUT DEVICE */
/*WILL BE IGNORED AND THE OUTPUT WILL BE DISPLAYED BY QAD's */
/*SCROLLING DISPLAY PROGRAM. */
if scrollonly then do:
   {gprun.i ""gppage.p"" "(input path)"}
end.

/*V8-*/
if 
    /* SS - 100325.1 - B */
    yes or
    /* SS - 100325.1 - E */
    scrollonly or (printype = "printer" and path = "terminal") 
then do:
   hide all.
   view frame dtitle.
end.
/*V8+*/

hide message no-pause.
