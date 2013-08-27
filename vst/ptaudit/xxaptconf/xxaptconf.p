/* xxaptconf.p - Item maintance confirm                                      */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */

{mfdtitle.i "130728.1"}

define variable del-yn like mfc_logical initial no no-undo.
define variable var_pmc_conf like mfc_logical initial no.
define variable var_pur_conf like mfc_logical initial no.
define variable var_eng_conf like mfc_logical initial no.
define variable var_doc_conf like mfc_logical initial no.
define variable var_fin_conf like mfc_logical initial no.

define variable old_pmc_conf like mfc_logical initial no.
define variable old_pur_conf like mfc_logical initial no.
define variable old_eng_conf like mfc_logical initial no.
define variable old_doc_conf like mfc_logical initial no.
define variable old_fin_conf like mfc_logical initial no.
/* DISPLAY SELECTION FORM */
form
   xapt_part      colon 18
   pt_desc1       colon 52

   pt_site        colon 18
   pt_pm_code     colon 52
   pt_added       colon 18
   pt_draw        colon 52
   pt_dsgn_grp    colon 18
   pt_um          colon 52 skip(2)

   var_pmc_conf   colon 18
   xapt_pmc_date  colon 40
   xapt_pmc_days  colon 60

   var_pur_conf   colon 18
   xapt_pur_date  colon 40
   xapt_pur_days  colon 60

   var_doc_conf   colon 18
   xapt_doc_date  colon 40
   xapt_doc_days  colon 60

   var_eng_conf   colon 18
   xapt_eng_date  colon 40
   xapt_eng_days  colon 60

   var_fin_conf   colon 18
   xapt_fin_date  colon 40
   xapt_fin_days  colon 60

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for xapt_part editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i xapt_aud xapt_part "yes" xapt_part "input xapt_part"}
      if recno <> ? then do:

         if xapt_pmc_date <> ? then var_pmc_conf = yes. else var_pmc_conf = no.
         if xapt_pur_date <> ? then var_pur_conf = yes. else var_pur_conf = no.
         if xapt_eng_date <> ? then var_eng_conf = yes. else var_eng_conf = no.
         if xapt_doc_date <> ? then var_doc_conf = yes. else var_doc_conf = no.
         if xapt_fin_date <> ? then var_fin_conf = yes. else var_fin_conf = no.

         display xapt_part var_pmc_conf xapt_pmc_date
                          var_pur_conf xapt_doc_date
                          var_eng_conf xapt_eng_date
                          var_doc_conf xapt_fin_date
                          var_fin_conf xapt_pur_date.
         find first pt_mstr no-lock where pt_part = input xapt_part no-error.
         if available pt_mstr then do:
            display pt_desc1 pt_um pt_site pt_pm_code pt_draw
                    pt_added pt_dsgn_grp.
         end.
         if xapt_pmc_date <> ? then display xapt_pmc_days.
                              else display today - xapt_added @ xapt_pmc_days.
         if xapt_pur_date <> ? then display xapt_pur_days.
                              else display today - xapt_added @ xapt_pur_days.
         if xapt_doc_date <> ? then display xapt_doc_days.
                              else display today - xapt_added @ xapt_doc_days.
         if xapt_eng_date <> ? then display xapt_eng_days.
                              else display today - xapt_added @ xapt_eng_days.
         if xapt_fin_date <> ? then display xapt_fin_days.
                              else display today - xapt_added @ xapt_fin_days.
      end.
   end.

   if input xapt_part = "" then do:
      {mfmsg.i 40 3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
   find xapt_aud using xapt_part exclusive-lock
                where xapt_part = input xapt_part no-error.
   if not available xapt_aud then do:
      {mfmsg.i 17 1}
      undo ,retry.
   end.
   else do:
         if xapt_pmc_date <> ? then var_pmc_conf = yes. else var_pmc_conf = no.
         if xapt_pur_date <> ? then var_pur_conf = yes. else var_pur_conf = no.
         if xapt_eng_date <> ? then var_eng_conf = yes. else var_eng_conf = no.
         if xapt_doc_date <> ? then var_doc_conf = yes. else var_doc_conf = no.
         if xapt_fin_date <> ? then var_fin_conf = yes. else var_fin_conf = no.

         display xapt_part var_pmc_conf xapt_pmc_date
                          var_pur_conf xapt_doc_date
                          var_eng_conf xapt_eng_date
                          var_doc_conf xapt_fin_date
                          var_fin_conf xapt_pur_date.
         find first pt_mstr no-lock where pt_part = input xapt_part no-error.
         if available pt_mstr then do:
            display pt_desc1 pt_um pt_site pt_pm_code pt_draw
                    pt_added pt_dsgn_grp.
         end.
         if xapt_pmc_date <> ? then display xapt_pmc_days.
                              else display today - xapt_added @ xapt_pmc_days.
         if xapt_pur_date <> ? then display xapt_pur_days.
                              else display today - xapt_added @ xapt_pur_days.
         if xapt_doc_date <> ? then display xapt_doc_days.
                              else display today - xapt_added @ xapt_doc_days.
         if xapt_eng_date <> ? then display xapt_eng_days.
                              else display today - xapt_added @ xapt_eng_days.
         if xapt_fin_date <> ? then display xapt_fin_days.
                              else display today - xapt_added @ xapt_fin_days.
  
   end.

   assign old_pmc_conf = var_pmc_conf
          old_pur_conf = var_pur_conf
          old_eng_conf = var_eng_conf
          old_doc_conf = var_doc_conf
          old_fin_conf = var_fin_conf.

   update var_pmc_conf when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_pmc_date" and
                            flpw_userid = global_userid) and xapt_pmc_date = ?)
                         or batchrun)
          xapt_pmc_date when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_adm_date" and
                            flpw_userid = global_userid)) or batchrun)
          var_pur_conf when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_pur_date" and
                            flpw_userid = global_userid) and xapt_pur_date = ?)
                         or batchrun)
          xapt_pur_date  when ((can-find(first flpw_mstr no-lock
                       where flpw_field = "xapt_adm_date" and
                            flpw_userid = global_userid)) or batchrun)
          var_doc_conf when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_doc_date" and
                            flpw_userid = global_userid) and xapt_doc_date = ?)
                         or batchrun)
          xapt_doc_date  when (can-find(first flpw_mstr no-lock
                                  where (flpw_field = "xapt_adm_date" and
                                        flpw_userid = global_userid))
                            or can-find(first flpw_mstr no-lock
                                  where (flpw_field = "xapt_doc_date" and
                                        flpw_userid = global_userid))
                            or batchrun)
          var_eng_conf when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_eng_date" and
                            flpw_userid = global_userid) and xapt_eng_date = ?)
                         or batchrun)
          xapt_eng_date  when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_adm_date" and
                            flpw_userid = global_userid))
                         or batchrun)
          var_fin_conf when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_fin_date" and
                            flpw_userid = global_userid) and xapt_fin_date = ?)
                         or batchrun)
          xapt_fin_date when ((can-find(first flpw_mstr no-lock
                      where flpw_field = "xapt_adm_date" and
                            flpw_userid = global_userid)) or batchrun)
          go-on(F5 CTRL-D).

   if input var_pmc_conf <> old_pmc_conf then assign xapt_pmc_date = today.
   if input var_pur_conf <> old_pur_conf then assign xapt_pur_date = today.
   if input var_eng_conf <> old_eng_conf then assign xapt_eng_date = today.
   if input var_doc_conf <> old_doc_conf then assign xapt_doc_date = today.
   if input var_fin_conf <> old_fin_conf then assign xapt_fin_date = today.

   if xapt_pmc_date <> ? and xapt_pmc_date >= xapt_added then do:
      assign xapt_pmc_days = xapt_pmc_date - xapt_added
             xapt_pmc_user = global_userid.
   end.
   if xapt_pur_date <> ? and xapt_pur_date >= xapt_added then do:
      assign xapt_pur_days = xapt_pur_date - xapt_added
             xapt_pur_user = global_userid.
   end.
   if xapt_eng_date <> ? and xapt_eng_date >= xapt_added then do:
      assign xapt_eng_days = xapt_eng_date - xapt_added
             xapt_eng_user = global_userid.
   end.
   if xapt_doc_date <> ? and xapt_doc_date >= xapt_added then do:
      assign xapt_doc_days = xapt_doc_date - xapt_added
             xapt_doc_user = global_userid.
   end.
   if xapt_fin_date <> ? and xapt_fin_date >= xapt_added then do:
      assign xapt_fin_days = xapt_fin_date - xapt_added
             xapt_fin_user = global_userid.
   end.

   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
       find first flpw_mstr no-lock where flpw_field = "xapt_adm_date"
              and flpw_userid = global_userid no-error.
       if not available flpw_mstr then do:
          {mfmsg.i 1021 3}
          next.
       end.
       del-yn = yes.
      {mfmsg01.i 11 1 del-yn}
   end.

   if del-yn then do:
      delete xapt_aud.
      clear frame a.
   end.
   del-yn = no.
end.
status input.
