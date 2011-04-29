/* mfnp01.i - INCLUDE FILE FOR NEXT/PREV LOGIC WITH =                   */
/* REVISION: 1.0         Last Modified: 2008/12/26   By: Roger   ECO:*xp001*  */
/*-Revision end---------------------------------------------------------------*/



/* Don't hide message for Desktop HELP triggers */
   hide message no-pause.

/* FIND NEXT RECORD */
if lastkey = keycode("F10")
   or keyfunction(lastkey) = "CURSOR-DOWN"
then do:
   if recno = ? then
      find first {1} where {3} > input {2}
      and {5} = {4}
      use-index {6} no-lock no-error.
   else
      find next {1} where {5} = {4}
      use-index {6} no-lock no-error.
   if not available {1} then do:
      message "end".

      if recno <> ? then
         find {1} where recid({1}) = recno
         no-lock no-error.
      else
         find last {1} where {5} = {4} use-index {6}
         no-lock no-error.
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
      find last {1} where {3} < input {2}
      and {5} = {4}
      use-index {6} no-lock no-error.
   else
      find prev {1} where {5} = {4}
      use-index {6} no-lock no-error.
   if not available {1} then do:
      message "begin".

      if recno <> ? then
         find {1} where recid({1}) = recno
         no-lock no-error.
      else
         find first {1} where {5} = {4} use-index {6}
         no-lock no-error.
      input clear.
   end.
   recno = recid({1}).
end.

/* INPUT PROMPT FIELD */
else do:
   if not (recno <> ? and not available({1})) then  recno = ?.
   apply lastkey.
end.
