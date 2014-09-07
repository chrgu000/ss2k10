/* xxgettab.p - get table descript                                            */
/*V8:ConvertMode=FullGUIReport                                                */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "820"}

define variable table1 as characte format "x(30)".
define variable table2 as characte format "x(30)".

form 
   skip (.1)
   table1  colon 14 view-as fill-in size 18 by 1
   table2  colon 40 view-as fill-in size 18 by 1 label {t001.i} skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{mfdemo.i date(8,1,2014) date(2,28,2015)}
{wbrp01.i}
repeat:

   if table2 = hi_char then table2 = "".

   if c-application-mode <> 'web' then
      update table1 table2 with frame a.

   {wbrp06.i &command = update &fields = " table1 table2" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if table2 = "" then table2 = hi_char.
   end.

 {mfselprt.i "printer" 120}
 {mfphead2.i}  /* PRINT PAGE HEADING FOR REPORTS 80 COLUMNS */

   for each qaddb._File no-lock where
            _FILE-NAME >= table1 and _FILE-NAME <= table2 + hi_char
   with frame b width 120 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}

      display _FILE-NAME format "x(30)" _file._desc format "x(84)".

   end.

    {mftrl080.i}  /* REPORT TRAILER */

end.

{wbrp04.i &frame-spec = a}
