/* clsismt.p - SITE SECURITY MAINTENANCE                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                     */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                   */
/* REVISION:  7.5     LAST MODIFIED: 09/26/94   BY: MWD  *J034*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* Revision: 1.4.1.7  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.4.1.8  BY: Michael Hansen       DATE: 02/25/03 ECO: *Q04K*     */
/* $Revision: 1.4.1.9 $ BY: Michael Hansen       DATE: 01/19/04 ECO: *Q058*     */


/*-Revision end---------------------------------------------------------------*/

/**************************************************************************/
/* SS - 081209.1 By: Bill Jiang */

      /* DISPLAY TITLE */
      /*
          {mfdtitle.i "1+ "}
          */
          {mfdtitle.i "081209.1"}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0F3
 * &SCOPED-DEFINE clsismt_p_1 "Groups:"
 * /* MaxLen: Comment: */
 *N0F3*/

/* ********** End Translatable Strings Definitions ********* */

 define variable invalid-entry as character no-undo.
      define variable apassword     as character.
      define variable canrun    as character format "x(72)".
      define variable i         as integer.
      define variable iloc      as integer no-undo.
/*N0F3*/ define variable disp-char1 as character format "x(30)".
      assign disp-char1 = getTermLabel("USER_IDS/GROUPS",30) + ":".


      form
          si_site            colon 9
          si_desc            at 21    no-label skip(1)
/*N0F3   {&clsismt_p_1}          at 3 */
/*N0F3*/ disp-char1 no-label     at 3
          canrun         at 5     no-label
      with frame a width 80 side-labels attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

      mainloop:
      repeat with frame a:

/*N0F3*/     display disp-char1 with frame a.
             prompt-for si_site editing:

                /* FIND NEXT/PREVIOUS RECORD */
                {mfnp.i si_mstr si_site  " si_mstr.si_domain = global_domain
                and si_site "  si_site si_site si_site}
                if recno <> ? then do:

                    display si_site si_desc si_canrun @ canrun with frame a.
                 end. /* IF RECNO <> ? */
             end. /* PROMPT-FOR...EDITING */

         /* CHECK FOR EXISTENCE OF SITE, THEN LOCK IT.  ALLOW FOR     */
         /* POSSIBILITY THAT ANOTHER USER COULD DELETE SITE AFTER     */
         /* THIS CAN-FIND */
if not can-find (si_mstr using  si_site where si_mstr.si_domain = global_domain
) then do:
         {mfmsg.i 708 3}            /* SITE DOES NOT EXIST */
         undo, retry.
             end.

find si_mstr using  si_site where si_mstr.si_domain = global_domain
exclusive-lock no-error.
         if not available si_mstr then undo, retry.

         status input.
         assign canrun    = si_canrun.
         display canrun with frame a.

         setgroup: do on error undo, retry:
        set canrun with frame a.

            /* STRIP OUT EXTRA BLANKS */
            si_canrun = "".
            if canrun > "" then repeat:

            iloc = index(canrun,",").
            if iloc = 0 and canrun > "" then iloc = length(canrun) + 1.
            if iloc = 0 then leave.

            assign apassword = substring(canrun,1,iloc - 1)
                       canrun = substring(canrun,iloc + 1).

            if apassword > "" then repeat:
               if apassword = "" or (substring(apassword,1,1) <> ""
                  and substring(apassword,length(apassword)) <> "")
                  then leave.
               if (substring(apassword,1,1) = "")
                  then apassword = substring(apassword,2).
               if substring(apassword,length(apassword)) = "" then
                  apassword =
                  substring(apassword,1,length(apassword) - 1).
            end.

            if apassword > "" then
            si_canrun = si_canrun + "," + apassword.
            end. /* IF SI_CANRUN > "" */

            /* SS - 081209.1 - B */
            /*
            /* VALIDATE THE CANRUN VALUE ENTERED FOR USER GROUPS AND/OR */
            /* USER ID'S */
            {gprun.i ""mgvalgrp.p"" "(input si_canrun,
                                      input no,
                                      input si_mstr.si_domain,
                                      output invalid-entry)"}

            /* DISPLAY ERROR MESSAGE IF AN INVALID VALIDATION IS FOUND */
            if invalid-entry <> "" then
            do:
               /* GROUP NAME / USER ID DOES NOT EXIST <INVALID-ENTRY> */
               {pxmsg.i &MSGNUM=6071 &ERRORLEVEL=3 &MSGARG1=invalid-entry}
               undo, retry.
            end.     /* END IF INVALID-ENTRY <> "" */
            */
            /* SS - 081209.1 - E */

            if substring(si_canrun,1,1) = "," then
            si_canrun = substring(si_canrun,2).
             end. /* SETGROUP */
      end.  /* MAINLOOP: REPEAT: */
