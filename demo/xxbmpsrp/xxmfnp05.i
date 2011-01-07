/* mfnp05.i - INCLUDE FILE FOR NEXT/PREV LOGIC                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 2.1      LAST MODIFIED: 11/01/87   BY: WUG                 */
/* REVISION: 4.0      LAST MODIFIED: 12/23/87   BY: WUG                 */
/* REVISION: 7.3      LAST MODIFIED: 05/23/95   BY: STR *G0N9*          */
/* REVISION: 8.6      LAST MODIFIED: 09/30/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/13/96   BY: *K03C* Vinay Nayak-Sujir  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.11     BY: Katie Hilbert  DATE: 03/22/01 ECO: *P008*      */
/* $Revision: 1.12 $   BY: John Pison     DATE: 10/24/02   ECO: *N1Y4*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* SS - 110105.1 By: Kaine Zhang */

/************************************************************************/

/*!
This version browses on a field within an index.
*/

/*!
{1}  the name of the file
{2}  the name of the index
{3}  a relation in which index fields of higher
order than {4} are set equal to something
{4}  the index field to browse on
{5}  variable containing the value to start browse
{6}  status line NOTE: ststatus would remain unchanged
{7}  added relation -- kaine.20110105

Note: if the starting variable is an input
variable, then it must be passed as
"input variablename".
*/
/************************************************************************/

if "{6}" <> "" then
   status input {6}.
else do:
   ststatus = stline[1].
   status input ststatus.
end.

readkey.

/* Don't hide message for Desktop HELP triggers */
if not ({gpiswrap.i} and keyfunction(lastkey) = "HELP") then
   hide message no-pause.

/* FIND NEXT RECORD */
if lastkey = keycode("F10")
   or keyfunction(lastkey) = "CURSOR-DOWN"
then do:
   if recno = ? then
      find first {1}
      where {3}
      and {4} > {5}
      use-index {2} no-lock no-error.
   else
      find next {1}
      where {3}
      use-index {2} no-lock no-error.

    /* SS - 110105.1 - B */
    repeat while available({1}) and not({7}):
        find next {1} where {3} use-index {2} no-lock no-error.
    end.
    /* SS - 110105.1 - E */
   
   if not available {1} then do:
      {pxmsg.i &MSGNUM=20 &ERRORLEVEL=2} /*"End of file"*/

      if recno <> ? then
         find {1} where recid({1}) = recno
         no-lock no-error.
      else find last {1} where {3} use-index {2} no-lock no-error.
      input clear.
   end.

    /* SS - 110105.1 - B */
    repeat while available({1}) and not({7}):
        find prev {1} where {3} use-index {2} no-lock no-error.
    end.
    /* SS - 110105.1 - E */

   recno = recid({1}).
end.

/* FIND PREVIOUS RECORD  */
else
if lastkey = keycode("F9")
   or keyfunction(lastkey) = "CURSOR-UP"
then do:
   if recno = ? then
      find last {1}
      where {3}
      and {4} < {5}
      use-index {2} no-lock no-error.
   else
      find prev {1}
      where {3}
      use-index {2} no-lock no-error.

    /* SS - 110105.1 - B */
    repeat while available({1}) and not({7}):
        find prev {1} where {3} use-index {2} no-lock no-error.
    end.
    /* SS - 110105.1 - E */

   if not available {1} then do:
      {pxmsg.i &MSGNUM=21 &ERRORLEVEL=2} /* "Beginning of file"*/

      if recno <> ? then
         find {1} where recid({1}) = recno
         no-lock no-error.
      else find first {1} where {3} use-index {2} no-lock no-error.
      input clear.
   end.

    /* SS - 110105.1 - B */
    repeat while available({1}) and not({7}):
        find next {1} where {3} use-index {2} no-lock no-error.
    end.
    /* SS - 110105.1 - E */

   recno = recid({1}).
end.

/* INPUT PROMPT FIELD */
else do:
   /* Don't reset recno for Desktop HELP triggers - only exception
    * is when the recno is already set but no record is available */
   if not ({gpiswrap.i} and keyfunction(lastkey) = "HELP") or
      (recno <> ? and not available({1})) then
      recno = ?.
   if keyfunction(lastkey) = "end-error" then do:
      ststatus = stline[3].
      status input ststatus.
   end.
   apply lastkey.
end.
