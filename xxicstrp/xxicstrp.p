/* xxicstrp.p - LOCATION MASTER STATUS REPORT                                */
/* revision: 110624.1  created on: 20110624   by: zy                         */
/* REVISION: 0CYH LAST MODIFIED:   06/24/11   BY: zy                         */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110624.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable vfind as logical.
/* SELECT FORM */
form
   site  colon 19
   site1 label {t001.i} colon 49 skip
   loc   colon 19
   loc1  label {t001.i} colon 49 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}
*/
/* REPORT BLOCK */
{wbrp01.i}

repeat:

   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".

   if c-application-mode <> 'web' then
   update site site1 loc loc1
   with frame a.

   {wbrp06.i &command = update &fields = "site site1 loc loc1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site }
      {mfquoter.i site1}
      {mfquoter.i loc  }
      {mfquoter.i loc1 }

      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = "nopage"
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

/*   {mfphead.i}   */

   form
      loc_site
      loc_loc
      ld_part
      pt_desc1
      pt_desc2
      ld_lot
      loc_perm
      loc_single
      loc_status
      ld_qty_oh
      is_avail
      is_nettable
      is_overissue
   with frame b width 162 no-attr-space down.

   /* SET EXTERNAL LABELS\ */
   setFrameLabels(frame b:handle).

   for each loc_mstr no-lock
      where loc_site >= site
      and loc_site <= site1
      and (loc_loc >= loc and loc_loc <= loc1),
      each si_mstr no-lock where si_site = loc_site,
      each is_mstr no-lock where is_status = loc_status
   break by loc_site by loc_loc
   with frame b width 162:
assign vfind = no.
/*      if page-size - line-counter < 2 then page. */

for each ld_det no-lock where ld_site = loc_site and ld_loc = loc_loc
     and ld_qty_oh <> 0:
    find first pt_mstr no-lock where pt_part = ld_part no-error.
    if available pt_mstr then do:
         assign vfind = yes.
         display
            loc_site
            loc_loc
            ld_part
            pt_desc1
            pt_desc2
            ld_lot
            loc_perm
            loc_single
            loc_status
            ld_qty_oh
            is_avail
            is_nettable
            is_overissue with frame b.
      down 1.
     end.
end.
if vfind = no then do:
     down 1.
     display loc_site
             loc_loc
             "" @ ld_part
             "" @ pt_desc1
             "" @ pt_desc2
             "" @ ld_lot
             loc_perm
             loc_single
             loc_status
             is_avail
             is_nettable
             is_overissue
             with frame b.
      down 1.
end.
/*
      if last-of (loc_site) and page-size - line-counter > 1
         then down 1.
*/
/*      {mfrpchk.i}        */

end.

   /* REPORT TRAILER  */
/*  {mfrtrail.i}   */
 {mfreset.i}

end.

{wbrp04.i &frame-spec = a}
