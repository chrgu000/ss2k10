/* xxvdaxrefrp.p - ax and qad vendor reference                               */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 9.1     LAST MODIFIED: 12/13/13   BY: zy         *N0KS*         */

{mfdtitle.i "131213.1"}
define variable vkey1   as character initial "AX_QAD_VENDOR_REFERENCE" no-undo.
define variable axvd   like vd_addr no-undo.
define variable axvd1  like vd_addr no-undo.
define variable qadvd  like vd_addr no-undo.
define variable qadvd1 like vd_addr no-undo.
define variable curr   as   character format "x(4)" no-undo.
define variable curr1  as   character format "x(4)" no-undo.
define variable vsort  like vd_sort no-undo format "x(44)".

form
   axvd   colon 20
   axvd1  colon 42 label {t001.i}
   qadvd  colon 20
   qadvd1 colon 42 label {t001.i}
   curr   colon 20
   curr1  colon 42 label {t001.i}
with frame a side-labels width 80 attr-space.

 /* SET EXTERNAL LABELS */
 setFrameLabels(frame a:handle).


         {wbrp01.i}
         repeat:

            if axvd1 = hi_char then axvd1 = "".
            if qadvd1 = hi_char then qadvd1 = "".
            if curr1 = hi_char then curr1 = "".

         if c-application-mode <> 'web':u then
         update axvd axvd1 qadvd qadvd1 curr curr1 with frame a.

         {wbrp06.i &command = update &fields = " axvd axvd1 qadvd qadvd1 curr curr1" &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then do:


            if axvd1 = "" then axvd1 = hi_char.
            if qadvd1 = "" then qadvd1 = hi_char.
            if curr1 = "" then  curr1 = hi_char.
        end.

            /* SELECT PRINTER */
            {mfselprt.i "printer" 80}

            {mfphead.i}


            for each usrw_wkfl no-lock where usrw_key1 = vkey1 and
                usrw_key3 >= axvd and usrw_key3 <= axvd1 and
                usrw_key4 >= curr and usrw_key4 <= curr1 and
                usrw_key5 >= qadvd and usrw_key5 <= qadvd1
            with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}                     /*G348*/
                assign vsort = "".
                find first vd_mstr no-lock where vd_addr = usrw_key5 no-error.
                if available vd_mstr then do:
                   assign vsort = vd_sort.
                end.
                display usrw_key3 usrw_key4 usrw_key5 vsort.
            end.
            {mfrtrail.i}
         end.

     {wbrp04.i &frame-spec = a}
