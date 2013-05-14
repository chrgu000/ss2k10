/* GUI CONVERTED from xxcsticrp.p  (converter v1.78) Fri Oct 29 14:37:07 2004 */
/*V8:ConvertMode=FullGUIReport                                                */
 
/* DISPLAY TITLE */
{mfdtitle.i "13410.1"}

define variable key1 like code_fldname initial "INVTR" no-undo.
define variable loc  like loc_loc.
define variable loc1 like loc_loc.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

define temp-table tmploc01
       fields t01_site like loc_site
       fields t01_loc like loc_loc
       fields t01_stat as logical initial yes.

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
    key1  colon 25  skip(1)
    loc   colon 25
    loc1  colon 42 label {t001.i}
    skip(2)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF
&ELSE
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
 

{wbrp01.i}

/*GUI*/ {mfguirpa.i false "printer" 80 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if c-application-mode <> 'web' then

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = " key1 loc loc1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
   end.

   /* OUTPUT DESTINATION SELECTION */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 80 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

   {mfphead.i}
empty temp-table tmploc01 no-error.

   for each code_mstr no-lock where code_domain = global_domain
        and code_fldname = key1,
       each pld_det no-lock where pld_domain = global_domain and
            pld_inv_acct = code_value
       break by pld_site by pld_loc:  
     if first-of(pld_loc) then do:
        find first tmploc01 exclusive-lock where t01_site = pld_site
               and t01_loc = pld_loc no-error.
        if not available tmploc01 then do:
           create tmploc01.
           assign t01_site = pld_site
                  t01_loc  = pld_loc.
        end.
     end.
   end.

   for each loc_mstr no-lock where loc_domain = global_domain 
        and loc_loc >= loc and (loc_loc <= loc1 or loc1 = "")
   with frame b width 80 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      find first tmploc01 where t01_site = loc_site and t01_loc = loc_loc no-error.
      display loc_site loc_loc loc_desc t01_stat when available tmploc01 with stream-io .
   
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

end.

/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" key1 loc loc1 "} /*Drive the Report*/
