/* iclorp.p - PART LOCATION REPORT                                            */
/*V8:ConvertMode=FullGUIReport                                                */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable part like pt_part.
define variable part1 like pt_part.
define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable um like pt_um.
define variable upd like mfc_logical.
define variable vfile as character.
define stream bf.

/* SELECT FORM */
form
  "此程序用于将选定的物料做变更批序号转移为无批号" colon 2 skip(2)
   part           colon 15
   part1          label "To" colon 49 skip
   site           colon 15
   site1          label "To" colon 49 skip
   loc            colon 15
   loc1           label "To" colon 49 skip
   upd            colon 30
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".

   if c-application-mode <> 'web' then
      update part part1 site site1 loc loc1 upd with frame a.

   {wbrp06.i &command = update
      &fields = "  part part1 site site1 loc loc1 upd" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }

      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.

   end.

if upd then do:
    for each ld_det no-lock
         where ld_det.ld_domain = global_domain
          and (ld_part >= part and ld_part <= part1)
          and (ld_site >= site and ld_site <= site1)
          and (ld_loc >= loc and ld_loc <= loc1)
          and (ld_lot <> "") and ld_qty_oh <> 0:
          assign vfile = 'TMP_' + trim(ld_site) + trim(ld_loc) + trim(ld_part)
                       + trim(ld_lot) + trim(ld_ref).
          output stream bf to value(vfile + ".bpi").
          put stream bf unformat '"' ld_part '"' skip.
          put stream bf unformat ld_qty_oh ' - "' execname '"' skip.
          put stream bf unformat '"' ld_site '" "' ld_loc '" "' ld_lot '" "' ld_ref '"' skip.
          put stream bf unformat '"' ld_site '" "' ld_loc '" "" ""' skip.
          put stream bf unformat 'Y' skip.
          output stream bf close.

          batchrun = yes.
          input from value(vfile + ".bpi").
          output to value(vfile + ".bpo") keep-messages.
          hide message no-pause.
             {gprun.i ""iclotr03.p""}
          hide message no-pause.
          output close.
          input close.
          batchrun = no.
          pause before-hide.
    end.
end.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   for each ld_det no-lock
       where ld_det.ld_domain = global_domain and  (ld_part >= part and ld_part
       <= part1)
      and (ld_site >= site and ld_site <= site1)
      and (ld_loc >= loc and ld_loc <= loc1)
      use-index ld_loc_p_lot,
      each pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = ld_part,
      each loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and
      loc_loc = ld_loc and loc_site = ld_site,
      each is_mstr no-lock  where is_mstr.is_domain = global_domain and
      is_status = ld_status
   break by ld_site by ld_loc by ld_part by ld_lot
   with frame b width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(ld_lot) and last-of(ld_lot) and ld_ref = ""
      then do:
         display
            ld_site
            ld_loc
            ld_part
            ld_lot   column-label "Lot/Serial!Ref"
            pt_um
            ld_qty_oh
            ld_date
            ld_expire
            ld_assay
            ld_grade
            ld_status
            is_avail
            is_nettable
            is_overissue.
      end.

      else do:
         if first-of(ld_lot) then do:
            display ld_site ld_loc ld_part ld_lot.
            down 1.
         end.
         display
            ld_ref @ ld_lot
            pt_um
            ld_qty_oh
            ld_date
            ld_expire
            ld_assay
            ld_grade
            ld_status
            is_avail
            is_nettable
            is_overissue.
      end.

      if last-of(ld_loc) then do:
         down 1.
      end.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
