/* xxmecm.p - convert menu to cim_load file.                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* display title */
{mfdtitle.i "09Y1"}

define variable lang    like lng_lang.
define variable lngdesc like lng_desc.
define variable mndnbr  like mnd_nbr.
define variable mndexec like mnt_label.

form
   lang    colon 12
           validate (can-find(first lng_mstr no-lock where lng_lang = lang),
                     "请输入正确的语言")
   lngdesc colon 46 skip
   mndnbr  colon 12
           validate (can-find(first mnd_det no-lock where mnd_exec = mndnbr),
                    "请输入正确的菜单选项")
   mndexec colon 46 format "x(30)"
with frame a no-underline side-label width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign lang = global_user_lang.
repeat:
/*       update lang mndnbr with frame a. */
   find first lng_mstr no-lock where lng_lang = lang no-error.
   if avail lng_mstr then do:
      display lang lng_desc @ lngdesc with frame a.
   end.
   prompt-for lang mndnbr with frame a editing:
      if frame-field = "lang" then do:
       {mfnp05.i lng_mstr lng_lang yes lng_lang "input lang"}
        if recno <> ? then do:
             assign lang = lng_lang
                    lngdesc = lng_desc.
           display lng_lang @ lang lng_desc @ lngdesc with frame a.
        end.
      end.
      else do:
        {mfnp05.i mnd_det mnd_exec yes mnd_exec "input mndnbr"}
         if recno <> ? then do:
            assign mndnbr = mnd_exec.
            display lang mndnbr with frame a.

            find mnt_det where mnt_nbr = mnd_nbr and mnt_select = mnd_select
               and mnt_lang = lang no-lock no-error.
            if available mnt_det then
               display mnt_label @ mndexec with frame a.
            else
               display "" @ mndexec with frame a.
         end.
      end.
   end.
   assign lang mndnbr.
   find first mnd_det where mnd_exec = mndnbr no-error.
   if avail mnd_det then do:
      find mnt_det where mnt_nbr = mnd_nbr and mnt_select = mnd_select
         and mnt_lang = lang no-lock no-error.
      if available mnt_det then
         display mnt_label @ mndexec with frame a.
      else
         display "" @ mndexec with frame a.
   end.
   /* SELECT PRINTER */
{mfselprt.i "printer" 80}

FOR EACH mnt_det NO-LOCK WHERE mnt_lang = lang AND mnt_nbr BEGINS mndnbr,
    EACH mnd_det NO-LOCK WHERE mnd_nbr = mnt_nbr AND mnd_select = mnt_select
    BREAK BY mnd_nbr :
    IF FIRST-OF (mnd_nbr) THEN DO:
        put unformat "@@batchload mgmemt.p" skip.
        put unformat "ch" skip.
        put unformat '"' mnt_nbr '"' skip.
    END.
        put unformat mnt_select skip.
        put unformat '"' mnt_label '" - "' mnd_exec '"' skip.
    IF LAST-OF(mnd_nbr) THEN DO:
        PUT UNFORMAT "." SKIP.
        PUT UNFORMAT "." SKIP.
        PUT UNFORMAT "." SKIP.
        put unformat "@@end" skip.
    END.
END.
  {mfreset.i}
end.
