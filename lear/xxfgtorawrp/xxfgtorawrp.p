/* xxfgtorawrp.p -  fg to raw report                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "8.7"}

define variable filename as character format "x(100)"
   label "Read From" no-undo.
define variable vqty like ld_qty_oh no-undo.
{gpcdget.i "UT"}

define temp-table tmpfg
    fields tf1_site like si_site
    fields tf1_loc  like loc_loc
    fields tf1_part like ps_par
    fields tf1_qty  like ld_qty_oh
    fields tf1_chk  as character format "x(28)".

define temp-table temp3
        field t3_part    like pt_part
        field t3_comp    like ps_comp
        field t3_qty_per like ps_qty_per.

define temp-table tmpcomp
    fields tc1_site like si_site
    fields tc1_loc like loc_loc
    fields tc1_part like ps_comp
    fields tc1_qty_per like ps_qty_per.

/* SELECT FORM */
form
   filename view-as fill-in size 40 by 1
   skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:
   for each tmpfg exclusive-lock: delete tmpfg. end.
   for each tmpcomp exclusive-lock: delete tmpcomp. end.
   for each temp3 exclusive-lock: delete temp3. end.

   if c-application-mode <> 'web' then
      update filename with frame a.

   {wbrp06.i &command = update
      &fields = " filename" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i filename}

   end.

   if search(filename) = "" or search(filename) = ? then do:
      {mfmsg.i 53 3}
      undo,retry.
   end.

   input from value(filename).
   repeat:
     create tmpfg.
     import delimiter "," tmpfg.
   end.
   input close.
   find first tmpfg exclusive-lock.
   if available tmpfg then delete tmpfg.

   for each tmpfg exclusive-lock:
       if tf1_qty = 0 then delete tmpfg.
   end.

   for each tmpfg exclusive-lock:
       find first si_mstr no-lock where si_domain = global_domain
              and si_site = tf1_site no-error.
       if not available si_mstr then do:
          assign tf1_chk = "地点不存在".
       end.
   end.

   for each tmpfg exclusive-lock where tf1_chk = "":
       find first loc_mstr no-lock where loc_domain = global_domain
              and loc_site = tf1_site and loc_loc = tf1_loc no-error.
       if not available loc_mstr then do:
          assign tf1_chk = "库位不存在".
       end.
   end.

   if not can-find(first tmpfg where tf1_chk <> "") then do:
      for each tmpfg no-lock break by tf1_part:
          if first-of(tf1_part) then do:
             run getSubQty (input tf1_part,input today).
          end.
      end.

      for each tmpfg no-lock,
          each temp3 no-lock where t3_part = tf1_part break by tf1_part:
          assign vqty = 0.
          find first tmpcomp no-lock where tc1_site = tf1_site and
               tc1_loc = tf1_loc and tc1_part = t3_comp no-error.
          if not available tmpcomp then do:
             create tmpcomp.
             assign tc1_site = tf1_site
                    tc1_loc = tf1_loc
                    tc1_part = t3_comp
                    tc1_qty_per = t3_qty_per * tf1_qty.
          end.
      end.
   end.
{mfselprt.i "printer" 80}
{mfphead2.i}  /* PRINT PAGE HEADING FOR REPORTS 80 COLUMNS */
   if can-find (first tmpcomp) then do:
       for each tmpcomp no-lock with frame b width 80:
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame b:handle).
          find first pt_mstr no-lock where pt_domain = global_domain and
                     pt_part = tc1_part no-error.
          {mfrpchk.i}
           display tc1_site tc1_loc tc1_part
                   pt_desc1 when available pt_mstr
                   tc1_qty_per.
       end.
    end.
    else do:
         for each tmpfg no-lock with frame c width 80:
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame b:handle).
           {mfrpchk.i}
           display tmpfg .
         end.
    end.
   /* REPORT TRAILER  */

  {mftrl080.i}  /* REPORT TRAILER */
end.

{wbrp04.i &frame-spec = a}


procedure getSubQty:

    define input  parameter vv_part     as character.
    define input  parameter vv_eff_date as date format "99/99/99".

    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.

    assign vv_level = 1
           vv_comp  = vv_part
           vv_save_qty = 0
           vv_qty      = 1 .

find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and
           ps_par = vv_comp  no-lock no-error.
repeat:
       if not avail ps_mstr then do:
             repeat:
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level]
                             no-lock no-error.
                vv_comp  = ps_par.
                vv_qty = vv_save_qty[vv_level].
                find next ps_mstr use-index ps_parcomp where
                          ps_domain = global_domain and
                          ps_par = vv_comp  no-lock no-error.
                if avail ps_mstr then leave .
            end.
        end.  /*if not avail ps_mstr*/

        if vv_level < 1 then leave .
        vv_record[vv_level] = recid(ps_mstr).


        if (ps_end = ? or vv_eff_date <= ps_end) then do:
                vv_save_qty[vv_level] = vv_qty.

                vv_comp  = ps_comp .
                vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                vv_level = vv_level + 1.

                find first temp3 where t3_part = vv_part and
                           t3_comp = ps_comp no-error.
                if not available temp3 then do:
                    create temp3.
                    assign
                        t3_part    = caps(vv_part)
                        t3_comp    = caps(ps_comp)
                        t3_qty_per = vv_qty
                        .
                end.
                else t3_qty_per   = t3_qty_per + vv_qty.

                find first ps_mstr use-index ps_parcomp where
                           ps_domain = global_domain and
                           ps_par = vv_comp  no-lock no-error.
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_parcomp where
                        ps_domain = global_domain and
                        ps_par = vv_comp  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end. /*repeat:*/

end procedure. /*bom_down*/
