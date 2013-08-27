 /* $Revision:ebsp4   $by:Sandler DATE:2012/10/24   ECO:*ss20121024.1*/

{mfdtitle.i "130821"}

DEF VAR talb AS CHAR FORMAT "x(300)".
define variable cSpec as char FORMAT "x(64)" EXTENT 18 no-undo.
DEF VAR n AS INT.
DEFINE variable test  like mp_nbr.
DEFINE variable test1 like mp_nbr.
DEF VAR part LIKE ip_part.
DEF VAR part1 LIKE ip_part.

form
        test          colon 15 label "單據"
        test1         colon 50 label "至"
        part          colon 15 label "料號"
        part1         colon 50 label "至"
with frame a side-labels width 80.

/*setFrameLabels(frame a:handle).*/

mainloop:
 repeat :

        if test1 = hi_char then test1 = "".
        if part1 = hi_char then part1 = "".

        IF c-application-mode <> 'web' then

        update test test1 part part1
        with frame a.

         /*{wbrp06.i &command = update &fields = "  test test1 part part1 "
           &frm = "a"} */

     /*K0Q4*/
     if (c-application-mode <> 'web':u) THEN do:


        bcdparm = "".
        {mfquoter.i test}
        {mfquoter.i test1}
        {mfquoter.i part}
        {mfquoter.i part1}

     END.

   {mfselbpr.i "printer" 800 nopage }           /*ss20130308.1 add nopage */
   /*output to /home/ecqyan/a.*/
    if test1 = "" then test1 = hi_char.
    if part1 = "" then part1 = hi_char.

    for each pt_mstr no-lock where pt_part >= part and pt_part <= part1:

        find first ip_mstr where ip_nbr >= test AND ip_nbr <= test1
        and ip_part = pt_part no-lock no-error.
        if avail ip_mstr then /*ss-20121227.1*/
        find first mp_mstr WHERE mp_nbr = ip_nbr NO-LOCK no-error.

        if not avail ip_mstr and (test <> "" or test1 <> "") then next. /*ss-20121227.1*/

        talb = ''.
        {xxgetspec.i pt_part 64 cSpec 18 hi_date hi_date}.
        REPEAT n = 1 to 18:
           IF trim(cSpec[n])<>"" then talb = talb + cSpec[n].
        end.

        put  pt_part "$" pt_desc1 "$" pt_desc2 "$" pt_added  "$"
              /*ss20120926 B*/
              pt_um "$" talb "$"
              if avail mp_mstr then mp_nbr else ""   /*ss-20121227.1*/
              "$" pt_break_cat "$"
              /*ss20120926 e*/
              pt_status "$" pt_draw "$" pt_prod_line
              skip.

    end.

    /*   end.  FOR EACH xxtemp
             /* REPORT TRAILER  */
    {mfrtrail.i}  */
    {mfreset.i}

end. /* REPEAT */
/*{wbrp04.i &frame-spec = a} */
