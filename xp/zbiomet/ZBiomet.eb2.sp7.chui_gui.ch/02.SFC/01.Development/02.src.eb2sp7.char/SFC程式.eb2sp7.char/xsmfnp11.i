/* mfnp11.i - INCLUDE FILE FOR NEXT/PREV LOGIC                          */
/* REVISION: 1.0         Last Modified: 2008/12/26   By: Roger   ECO:*xp001*  */
/*-Revision end---------------------------------------------------------------*/


/* Don't hide message for Desktop HELP triggers */
   hide message no-pause.

/* FIND NEXT RECORD */
if lastkey = keycode("F10")
   or keyfunction(lastkey) = "CURSOR-DOWN"
then do:
   if recno = ? then
      find first {1} use-index {2} where {3} > {4} no-lock no-error.
   else
      find next {1} use-index {2} where {3} > {4} no-lock no-error.

   if not available {1} then do:
      message "end".
      find last {1} use-index {2} where {3} >= {4} no-lock no-error.
      input clear.
   end.

   recno = recid({1}).
end.

/* FIND PREVIOUS RECORD  */
else
if lastkey = keycode("F9")
   or keyfunction(lastkey) = "CURSOR-UP"
then do:
   if recno = ? then
      find last {1} use-index {2} where {3} < {4} no-lock no-error.
   else
      find prev {1} use-index {2} where {3} < {4} no-lock no-error.
   if not available {1} then do:
      message "begin".
      find first {1} use-index {2} where {3} <= {4} no-lock no-error.
      input clear.
   end.
   recno = recid({1}).
end.

/* INPUT PROMPT FIELD */
else do:
   if not (recno <> ? and not available({1})) then  recno = ?.
   apply lastkey.
end.
