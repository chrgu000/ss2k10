/* yyglout.p - GL REPORT                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "120920.1"}
define variable effdate like gltr_eff_dt.
define variable effdate2 like gltr_eff_dt.
define variable usr like gltr_user.
define variable usr2 like gltr_user.
define variable tpe like gltr_tr_type.
define variable tpe2 like gltr_tr_type.

form
   effdate  colon 20
   effdate2 colon 40 label {t001.i}
   usr      colon 20
   usr2     colon 40 label {t001.i}
   tpe      colon 20
   tpe2     colon 40 label {t001.i}

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K1D1*/ {wbrp01.i}

repeat:
   if effdate = low_date then effdate = ?.
   if effdate2 = hi_date then effdate2 = ?.
   if tpe2 = hi_char then tpe2 = "".
   if usr2 = hi_char then usr2 = "".

/*K1D1*/ if c-application-mode <> 'web' then
   update effdate effdate2 usr usr2 tpe tpe2 with frame a.

/*K1D1*/ {wbrp06.i &command = update
                   &fields = " effdate effdate2 tpe tpe2 usr usr2"
                   &frm = "a"}

/*K1D1*/ if (c-application-mode <> 'web') or
/*K1D1*/ (c-application-mode = 'web' and
/*K1D1*/ (c-web-request begins 'data')) then do:

   if effdate = ? then effdate = low_date.
   if effdate2 = ? then effdate2 = hi_date.
   if tpe2 = "" then tpe2 = hi_char.
   if usr2 = "" then usr2 = hi_char.

/*K1D1*/ end.

   /* SELECT PRINTER */
   {mfselprt.i "printer" 80}
   {mfphead2.i}

   for each  gltr_hist no-lock where gltr_domain = global_domain and
             gltr_eff_dt >= effdate and gltr_eff_dt <= effdate2 and
             gltr_tr_type >= tpe and gltr_tr_type <= tpe2 and
             gltr_user >= usr and gltr_user <= usr2
   use-index gltr_eff_dt with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}         /*G348*/

      display gltr_eff_dt gltr_ref gltr_user gltr_tr_type.

   end.
   {mftrl080.i}
end.

/*K1D1*/ {wbrp04.i &frame-spec = a}
