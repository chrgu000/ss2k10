/* mgpwmt.p - PASSWORD MAINTENANCE                                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.8 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 05/05/86   BY: pml                       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0      LAST MODIFIED: 05/25/88   BY: pml *A255*                */
/* REVISION: 4.0      LAST MODIFIED: 11/09/88   BY: emb *A528*                */
/* REVISION: 4.0      LAST MODIFIED: 03/27/89   BY: WUG *A686*                */
/* REVISION: 4.0      LAST MODIFIED: 04/04/89   BY: flm *A693*                */
/* REVISION: 5.0      LAST MODIFIED: 07/20/89   BY: WUG *B195*                */
/* REVISION: 6.0      LAST MODIFIED: 07/09/90   BY: WUG *D050*                */
/* REVISION: 6.0      LAST MODIFIED: 05/17/91   BY: emb *D652*                */
/* REVISION: 6.0      LAST MODIFIED: 08/15/91   BY: emb *D831*                */
/* REVISION: 6.0      LAST MODIFIED: 10/11/91   BY: WUG *7.0**                */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: WUG *F222*                */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY  SKK *G707*                */
/* REVISION: 7.3      LAST MODIFIED: 03/02/94   BY: jzs *FM71*                */
/* REVISION: 7.3      LAST MODIFIED: 09/19/94   BY: jpm *GM74*                */
/* REVISION: 7.3      LAST MODIFIED: 03/23/95   BY: yep *F0NW*                */
/* REVISION: 8.5      LAST MODIFIED: 12/01/95   BY: *J094* Tom Vogten         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/27/98   BY: *H1KR* *Viji Pakala       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.3      BY: Jean Miller        DATE: 04/16/02  ECO: *P05H*  */
/* Revision: 1.9.1.7    BY: Jean Miller        DATE: 06/24/02  ECO: *P09H*  */
/* $Revision: 1.9.1.8 $  BY: Michael Hansen  DATE: 02/25/03  ECO: *Q04K* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 081210.1 By: Bill Jiang */

/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "081210.1"}

{pxsevcon.i}

define variable del-yn like mfc_logical no-undo.
define variable i as integer no-undo.
define variable passwords as character no-undo.
define variable apassword as character no-undo.
define variable parent-label like mnt_label no-undo.
define variable child-label  like mnt_label no-undo.
define variable canrun       like mnd_canrun extent 15 no-undo.
define variable iloc     as integer no-undo.
define variable pwprompt as logical initial false no-undo.
define variable msgprint as logical no-undo.
define variable sec-label as character format "x(24)" no-undo.

define variable invalid-entry as character no-undo.
define variable x as character no-undo.


define buffer mndbuffer for mnd_det.

sec-label = getTermLabel("USER_IDS/GROUPS",24) + ":".

{gpaud.i &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file   = mnd_det
   &db_field  = mnd_nbr
   &db_field1 = mnd_select}

form
   mnd_nbr        colon 15
   parent-label   at 36    no-label
   mnd_select     colon 15
   child-label    at 36    no-label
   sec-label      at 2     no-label
   canrun[1]      at 17    no-label
   canrun[2]      at 17    no-label
   canrun[3]      at 17    no-label
   canrun[4]      at 17    no-label
   canrun[5]      at 17    no-label
   canrun[6]      at 17    no-label
   canrun[7]      at 17    no-label
   canrun[8]      at 17    no-label
   canrun[9]      at 17    no-label
   canrun[10]     at 17    no-label
   canrun[11]     at 17    no-label
   canrun[12]     at 17    no-label
   canrun[13]     at 17    no-label
   canrun[14]     at 17    no-label
   canrun[15]     at 17    no-label
with frame a width 80 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat with frame a:

   innerloop:
   do with frame a on endkey undo, leave mainloop:

      display sec-label with frame a.

      prompt-for mnd_nbr mnd_select
      editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i mnd_det mnd_nbr mnd_nbr mnd_select mnd_select mnd_nbr}

         if recno <> ? then do:

            do for mndbuffer:
               find first mndbuffer where mnd_exec = mnd_det.mnd_nbr
               no-lock no-error.
               {mgmntlab.i &label="parent-label" &table="mndbuffer"}.
            end.

            canrun = "".
            i = 1.
            passwords = mnd_canrun.

            if passwords > "" then
            repeat:
               iloc = index(passwords,",").
               if iloc = 0 and passwords > "" then
                  iloc = length(passwords) + 1.
               if iloc = 0 then leave.

               apassword = substring(passwords,1,iloc - 1).

               if apassword > "" then do:

                  if length(canrun[i]) + length(apassword) +
                     (if length(canrun[i]) > 0 then 1 else 0) >  60 then do:
                     if i >= 15 then leave.
                     i = i + 1.
                  end.
                  if canrun[i] > "" then canrun[i] =canrun[i] + ",".
                  canrun[i] = canrun[i] + apassword.
               end.

               passwords = substring(passwords,iloc + 1).
            end.

            /* Now show THIS menu's translated detail */
            display mnd_nbr mnd_select canrun.

            {mgmntlab.i &label="child-label" &table="mnd_det"}.
         end.

      end.

      find mnd_det using mnd_nbr and mnd_select exclusive-lock no-error.
      if not available mnd_det then do:
         /* Menu/Selection not available */
         {pxmsg.i &MSGNUM=288 &ERRORLEVEL=1}
         next mainloop.
      end.

      {gpaud1.i &uniq_num1 = 01
         &uniq_num2 = 02
         &db_file   = mnd_det
         &db_field  = mnd_nbr
         $db_field1 = mnd_select}

      /* MODIFY */
      status input.

      do for mndbuffer:
         find first mndbuffer where mnd_exec = mnd_det.mnd_nbr
         no-lock no-error.
         {mgmntlab.i &label="parent-label" &table="mndbuffer"}.
      end.

      find mnd_det where mnd_nbr = input mnd_nbr and
         mnd_select = input mnd_select.

      del-yn = no.
      recno = recid(mnd_det).

      /* Now show THIS menu's translated detail */
      display
         mnd_nbr
         mnd_select.

      {mgmntlab.i &label="child-label" &table="mnd_det"}.

      canrun = "".

      i = 1.
      passwords = mnd_canrun.

      if passwords > "" then
      repeat:

         iloc = index(passwords,",").
         if iloc = 0 and passwords > ""
            then iloc = length(passwords) + 1.
         if iloc = 0 then leave.

         apassword = substring(passwords,1,iloc - 1).

         if apassword > "" then do:

            if length(canrun[i]) + length(apassword) +
               (if canrun[i] > "" then 1 else 0) >  60
            then do:
               if i >= 15 then leave.
               i = i + 1.
            end.

            if canrun[i] > "" then
               canrun[i] = canrun[i] + ",".
            canrun[i] = canrun[i] + apassword.

         end.

         passwords = substring(passwords,iloc + 1).

      end.

      if passwords > "" then do:
         /* Product line or accounts must be blank */
         {pxmsg.i &MSGNUM=140 &ERRORLEVEL=2}
      end.

      display canrun.

      ststatus = stline[2].
      status input ststatus.
      msgprint = true.

      repeat with frame a:

         set canrun go-on ("F5" "CTRL-D" ).

         if canrun[1] = " " then do:
            /* Blank not allowed */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=2}
            msgprint = false.
         end.

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /* Please confirm delete */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no then next mainloop.
            mnd_canrun = "*".
            clear frame a.
            del-yn = no.
            leave innerloop.
         end.

         else do:
            mnd_canrun = "".

            repeat with frame a while mnd_canrun = "":

               if pwprompt = true then do:
                  set canrun.
               end.

               do i = 1 to 15:

                  if canrun[i] > "" then
                  repeat:

                     iloc = index(canrun[i],",").
                     if iloc = 0 and canrun[i] > "" then
                        iloc = length(canrun[i]) + 1.
                     if iloc = 0 then leave.

                     apassword = substring(canrun[i],1,iloc - 1).
                     canrun[i] = substring(canrun[i],iloc + 1).

                     if apassword > "" then
                     repeat:
                        if apassword = "" or
                           (substring(apassword,1,1) <> "" and
                            substring(apassword,length(apassword)) <> "")
                        then leave.
                        if (substring(apassword,1,1) = "") then
                           apassword = substring(apassword,2).
                        if substring(apassword,length(apassword)) = ""
                        then
                           apassword = substring(apassword,1,
                                                 length(apassword) - 1).
                     end.

                     if apassword > "" then
                        mnd_canrun = mnd_canrun + "," + apassword.
                  end.

               end.

               if mnd_canrun = "" then do:
                  if msgprint then
                     /* Blank not allowed */
                     {pxmsg.i &MSGNUM=40 &ERRORLEVEL=2}
                  assign
                     msgprint = true
                     pwprompt = true.
               end.
               else do:
                  pwprompt = false.
               end.

            end. /* repeat with frame a */

            if passwords > "" then
               mnd_canrun = mnd_canrun + "," + passwords.

            if substring(mnd_canrun,1,1) = "," then
               mnd_canrun = substring(mnd_canrun,2).

         end.

         /* SS - 081210.1 - B */
         /*
         /* VALIDATE THE MND_CANRUN VALUE ENTERED FOR USER GROUPS */
         /* AND/OR USER ID'S */
         {gprun.i ""mgvalgrp.p""
            "(input mnd_canrun,
              input no,
              input '',
              output invalid-entry)"}

         /* DISPLAY ERROR MESSAGE IF AN INVALID VALIDATION IS FOUND */
         if invalid-entry <> "" then
         do:
            /* GROUP NAME / USER ID DOES NOT EXIST <PINVALIDENTRY> */
            {pxmsg.i &MSGNUM=6071
                     &ERRORLEVEL={&APP-ERROR-RESULT}
                     &MSGARG1="invalid-entry"}
            undo, retry.
         end.     /* END IF PINVALIDENTRY <> "" */
         */
         /* SS - 081210.1 - E */

         leave.
      end.

   end. /* innerloop */

   {gpaud2.i &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file   = mnd_det
      &db_field  = mnd_nbr
      &db_field1 = mnd_select}

end. /* mainloop */

{gpaud3.i  &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file   = mnd_det
   &db_field  = mnd_nbr
   &db_field  = mnd_select}

status input.
