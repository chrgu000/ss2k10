/***********************************************************************/
/*                                                                     */
/*                   DO NOT MODIFY THIS PROGRAM.                       */
/*                                                                     */
/*    Name       : tijscroll.i                                         */
/*                                                                     */
/*    Function   : Generic scrolling template for                      */
/*                 Triumph International Japan.                        */
/*                                                                     */
/*    Programmer : Raphael Thoppil                                     */
/*                                                                     */
/*    Usage      : {tijscroll.i                                        */
/*                   &argument = " value "                             */
/*                   &argument = " value "}                            */
/*                 See bellow for arguments, some are mandatory.       */
/*                                                                     */
/***********************************************************************/
/* MODID   USER       REASONS                                          */
/* -----   --------   -------                                          */
/*                                                                     */
/***********************************************************************/
/*    scroll.i Arguments                                               */
/*    ==================                                               */
/*                                                                     */
/*  Mandatory Arguments:                                               */
/*    &file        Database table-name to scroll.                      */
/*    &where       Where clause for record selection. If no where      */
/*                 clause aplies use "where true".                     */
/*    &fieldlist   List of fields and variables to be displayed.       */
/*    &prompt      The fieldname to highlight and select on.           */
/*    &frame       The down frame to use for scrolling records.        */
/*                                                                     */
/*  Optional Arguments:                                                */
/*  If an argument is not to be used, do not define it.                */
/*    &index       Index name to force ordering of records. If no      */
/*                 index is to be used do not define argument.         */
/*    &prestart    Code to be executed before initiating scrolling.    */
/*    &predisplay  Code to be executed just prior to displaying a      */
/*                 line on the scroller.                               */
/*    &postdisplay Code to be executed just after displaying a line on */
/*                 the scroller.                                       */
/*    &prechoose   Code to be executed just before choose.             */
/*    &midchoose   Extra options to be used by the choose statement.   */
/*    &postchoose  Code to be executed just after choose.              */
/*    &gokeys      Additional keys to GO ON from within the choose.    */
/*    &exit        Code to be executed on exiting scroller.            */
/*    &homekey     Keylabel of home key.                               */
/*    &endkey      Keylabel of end key.                                */
/*    &pgupkey     Keylabel for page up key.                           */
/*    &pgdnkey     Keylabel for page down key.                         */
/*    &inskey      Keylabel for insert function.                       */
/*    &inscode     Code to be executed by insert function.             */
/*    &delkey      Keylabel for delete function.                       */
/*    &delcode     Code to be executed by delete function.             */
/*    &updkey      Keylabel for update function.                       */
/*    &updcode     Code to be executed by update function.             */
/*    &key1..5     Additional keys, 1 to 5, pass Keylabel as argument. */
/*    &code1..5    Code to be executed on respective additional key.   */
/*                                                                     */
/***********************************************************************/



{&nodef} /* Option to remove variable definitions. */

define variable w-rid      as recid extent 500 no-undo.
define variable w-i        as integer no-undo.
define variable w-offset   as integer no-undo.
define variable w-newrecid as recid no-undo.
define variable w-prvrecid as recid no-undo.

/* {&nodef}  End option to remove variable definitions. */


release {&file}.  /* Scope file to here. */
find first {&file} {&where} {&index} no-lock no-error.

{&prestart}

clear frame {&frame} all.

B-Redraw:
repeat with frame {&frame}:

  if not available {&file} then
    find first {&file} {&where} {&index} no-lock no-error.
    view frame {&frame}.
    
    	

    color display normal {&prompt}.
    up frame-line - 1.
    w-rid = ?.

    /* Draw available records on this screen. */
    do while available({&file})
    and frame-line({&frame}) <= frame-down({&frame}):

      {&predisplay}
      display {&fieldlist}.
      {&postdisplay}

      w-rid[frame-line({&frame})] = recid({&file}).
      find next {&file} {&where} {&index} no-lock no-error.
      down.
    end.

    /* Clear any remaining lines. */
    do while frame-line({&frame}) <= frame-down({&frame}):
      clear frame {&frame} no-pause.
      down.
    end.
    up frame-line - 1.

    if w-offset > 0 then do:
      down w-offset - 1 with frame {&frame}.
      w-offset = 0.
    end.


    B-Action:
    /*tarun*    do while true on error undo, leave B-Redraw: */
    do while true on error undo, leave on endkey undo,leave B-Redraw:


      {&prechoose}

    choose
      row {&prompt}
           go-on({&gokeys} F4 CTRL-E PF4)
          {&midchoose}
            no-error
        with frame {&frame}.


        {&postchoose}


   if keylabel(lastkey) = "F4" or keyfunction(lastkey) = "END-ERROR"
       then do:
            {&exit}
         leave B-Redraw.
     end.


    if keyfunction(lastkey) = "CURSOR-UP" then
      B-UP: do:

           find {&file}
                where recid({&file}) = w-rid[frame-line({&frame})]
              no-lock no-error.

           if available({&file}) then
          find prev {&file} {&where} {&index} no-lock no-error.

       if not available({&file}) then do:
          bell.
           next B-Action.
      end.

            color display normal {&prompt}.

         scroll from-current down.

	    {&predisplay}
           display {&fieldlist}.
           {&postdisplay}

          do w-i = frame-down({&frame}) to 2 by -1:
           w-rid[w-i] = w-rid[w-i - 1].
        end.
            w-rid[1] = recid({&file}).

  end. /* B-Up */


 if keyfunction(lastkey) = "CURSOR-DOWN" then
    B-Down: do:

         find {&file}
                where recid({&file}) = w-rid[frame-line({&frame})]
              no-lock no-error.

           if available({&file}) then
          find next {&file} {&where} {&index} no-lock no-error.

       if not available({&file}) then do:
          bell.
           next B-Action.
      end.

            color display normal {&prompt}.

         scroll from-current up.

      {&predisplay}
           display {&fieldlist}.
           {&postdisplay}

          do w-i = 1 to frame-down({&frame}) - 1:
             w-rid[w-i] = w-rid[w-i + 1].
        end.
            w-rid[frame-down({&frame})] = recid({&file}).

         next B-Redraw. /*lb01*/

       end. /* B-Down */

       /* HOME */
      if "{&homekey}" <> "" and
           lookup(keylabel(lastkey),"{&homekey}") <> 0
 then do:
            find first {&file} {&where} {&index} no-lock no-error.
          next B-Redraw.
      end.

    /* END */
       if "{&endkey}" <> "" and
            lookup(keylabel(lastkey),"{&endkey}") <> 0
  then do:
            find last {&file} {&where} {&index}
         no-lock no-error.
           w-i = 0.
        do while w-i < (frame-down - 1) and available {&file}:
              w-i = w-i + 1.
          find prev {&file} {&where} {&index}
                 no-lock no-error.
       end.

            w-offset = w-i + (if available({&file}) then 1 else 0).
         next B-Redraw.
      end.


    /* PAGE UP */
   if "{&pgupkey}" <> "" and
           lookup(keylabel(lastkey),"{&pgupkey}") <> 0
 then do:
            if w-rid[1] <> ? then do:
           find {&file}
                where recid({&file}) = w-rid[1]
                 no-lock no-error.
           do w-i = 1 to frame-down({&frame}) while available {&file}:
                 find prev {&file} {&where} {&index}
                 no-lock no-error.
               end.
        end.
            else
                w-i = 0.
            if available {&file} or w-i > 2 then
                next B-Redraw.
      bell.
           next B-Action.
      end.


    /* PAGE DOWN */
 if "{&pgdnkey}" <> "" and
           lookup(keylabel(lastkey),"{&pgdnkey}") <> 0
 then do:
            if w-rid[frame-down({&frame})] <> ? then do:
                find {&file}
                where recid({&file}) = w-rid[frame-down({&frame})]
              no-lock no-error.
           find next {&file} {&where} {&index}
                 no-lock no-error.
           if available({&file}) then next B-Redraw.
           end.
        end.

    /* INSERT */
    if "{&inskey}" <> "" and
            lookup(keylabel(lastkey),"{&inskey}") <> 0
  then do:
            hide message no-pause.
          assign
              w-newrecid = ?
          w-offset   = frame-line({&frame}).

          {&inscode}

      if w-newrecid <> ? then do:
         find {&file}
                where recid({&file}) = w-newrecid
               no-lock no-error.
           w-offset = 0.
       end.
            else do:
            find {&file}
                where recid({&file}) = w-rid[1]
                 no-lock no-error.
       end.

            next B-Redraw.
      end.


    /* DELETE */
    if "{&delkey}" <> "" and
            lookup(keylabel(lastkey),"{&delkey}") <> 0
  then do
   on endkey undo B-Action, next B-Action:

           hide message no-pause.
          assign
              w-offset   = frame-line({&frame})
               w-prvrecid = ?.

     find {&file}
                where recid({&file}) = w-rid[1]
         no-lock no-error.
           if available({&file}) and frame-line({&frame}) = 1
      then do:
            find prev {&file} {&where} {&index} no-lock no-error.
           w-prvrecid = (if available({&file})
                             then recid({&file})
                             else ?).
            end.

            find {&file}
                where recid({&file}) = w-rid[frame-line({&frame})]
              no-lock no-error.
           if not available({&file}) then do:
          bell.
           next B-Action.
      end.

            {&delcode}

      find {&file}
                where recid({&file}) = w-rid[1]
         no-lock no-error.
           if not available({&file}) and w-prvrecid <> ? then
          find {&file}
                where recid({&file}) = w-prvrecid
               no-lock no-error.
       next B-Redraw.
      end.


    /* UPDATE */
    if "{&updkey}" <> "" and
            lookup(keylabel(lastkey),"{&updkey}") <> 0
  then do
   on endkey undo B-Action, next B-Action:

           w-offset = frame-line({&frame}).
        hide message no-pause.

          find {&file}
                where recid({&file}) = w-rid[frame-line({&frame})]
              no-lock no-error.

           if not available({&file})
       then do:
            bell.
           next B-Action.
      end.

            {&updcode}
	
	
	   find {&file}
                where recid({&file}) = w-rid[1]
         no-lock no-error.

           next B-Redraw.

	end.
    
    /* KEY 1 */
     if "{&key1}" <> "" and
      lookup(keylabel(lastkey),"{&key1}") <> 0
    then do:
            {&code1}
        next B-Action.
      end.


    /* KEY 2 */
     if "{&key2}" <> "" and
      lookup(keylabel(lastkey),"{&key2}") <> 0
    then do:
            {&code2}
        next B-Action.
      end.


    /* KEY 3 */
     if "{&key3}" <> "" and
      lookup(keylabel(lastkey),"{&key3}") <> 0
    then do:
            {&code3}
        next B-Action.
      end.


    /* KEY 4 */
     if "{&key4}" <> "" and
      lookup(keylabel(lastkey),"{&key4}") <> 0
    then do:
            {&code4}
        next B-Action.
      end.


    /* KEY 5 */
     if "{&key5}" <> "" and
      lookup(keylabel(lastkey),"{&key5}") <> 0
    then do:
            {&code5}
        next B-Action.
      end.

    end. /* B-Action */

end. /* B-Redraw */
