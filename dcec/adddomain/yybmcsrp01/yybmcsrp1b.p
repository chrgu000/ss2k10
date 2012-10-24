/* GUI CONVERTED from bmcsrp1b.p (converter v1.78) Wed Dec 20 14:07:58 2006 */
/* bmcsrp1b.p - BILL OF MATERIAL COST REPORT BY COST ELEMENT            */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: pma *G032*          */
/* REVISION: 7.2      LAST MODIFIED: 09/11/94   BY: rwl *FR15*          */
/* REVISION: 7.3      LAST MODIFIED: 10/27/94   BY: ame *FS91*          */
/* REVISION: 7.3      LAST MODIFIED: 02/17/95   BY: cpp *G0FJ*          */
/* REVISION: 7.3      LAST MODIFIED: 03/08/95   BY: pxd *F0JP*          */
/* REVISION: 7.3      LAST MODIFIED: 03/10/95   BY: pxd *F0MK*          */
/* REVISION: 7.3      LAST MODIFIED: 03/15/95   BY: pxd *G0HG*          */
/* REVISION: 8.5      LAST MODIFIED: 01/19/95   BY: tjs *J027*          */
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G2BK*  Russ Witt   */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: ays *K10Q*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00 BY: *N0F3* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.6.1.6      BY: Samir Bavkar       DATE: 04/12/02 ECO: *P000* */
/* Revision: 1.6.1.8      BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.6.1.9      BY: Manish Dani        DATE: 06/28/05 ECO: *P3QQ* */
/* Revision: 1.6.1.10     BY: Munira Savai       DATE: 07/11/06 ECO: *P4WX* */
/* $Revision: 1.6.1.11 $ BY: Gaurav Kerkar      DATE: 12/14/06 ECO: *P5JD* */
/* ss - 121011.1 by: Steven */ 
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                       */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmcsrp1b_p_4 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1b_p_5 "/no"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1b_p_7 "Levels"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1b_p_9 "Cat"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1b_p_11 "Ph"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1b_p_12 "Extended Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define input parameter formula_only like mfc_logical no-undo.

define shared variable site like si_site.
define shared variable transtype as character.
define shared variable csset like sct_sim.
define shared variable eff_date as date.
define shared variable part like pt_part.
define shared variable part1 like pt_part.
define shared variable numlevels as integer format ">>>".
define shared variable newpage like mfc_logical.

define buffer ptmstr for pt_mstr.
define buffer pt_mstr1 for pt_mstr.
define buffer bommstr for bom_mstr.

define variable comp like ps_comp no-undo.
define variable level as integer no-undo.
define variable maxlevel as integer format ">>>" label {&bmcsrp1b_p_7}
   no-undo.
define variable record as integer extent 100 no-undo.
define variable des as character format "x(24)" no-undo extent 10.
define variable scrp_pct like ps_scrp_pct no-undo.
define variable qty_type like ps_qty_type.
define variable part_type like pt_part_type no-undo.
define variable parent like ps_par no-undo.
define variable um like pt_um no-undo.
define variable phantom like mfc_logical label {&bmcsrp1b_p_11} no-undo.
define variable iss_pol like pt_iss_pol format {&bmcsrp1b_p_5} no-undo.
define variable lvl as character format "x(6)" label {&bmcsrp1b_p_4} no-undo.
define variable dpart like pt_part no-undo.
define variable dingbats as character initial "temp!@#$".

define variable bom_code like pt_bom_code.
define variable yield_pct like pt_yield.

define variable par_qty like ps_qty_per.
define variable spt_tot like sct_cst_tot.
define variable spt_xtd like sct_cst_tot
   format "->>>,>>>,>>9.99<<<"  label {&bmcsrp1b_p_12}.
define variable batch_qty like bom_batch.
define variable batch_um like bom_batch_um.
define variable usr_val as character format "x(12)" extent 5.
define variable usr_elm like sc_element extent 5.
define variable cat_desc as character format "x(4)" label {&bmcsrp1b_p_9}.
define variable i as integer.
define variable j as integer.
define variable k as integer.
define variable joint_label like lngd_translation.
define variable joint_code like wo_joint_type.
define variable joint_type like wo_joint_type.
define variable l_gl_std like mfc_logical no-undo.
define variable l_linked like mfc_logical no-undo.

define workfile pswkfl no-undo
   field psrecid as recid
   field pscode  like ps_ps_code
   field psstart like ps_start
   field psqtype like ps_qty_type
   field qty_per like ps_qty_per
   field qty_per_b like ps_qty_per_b
   field net_qty like ps_qty_per.

for each lngd_det no-lock where lngd_dataset = "sc_mstr"
      and lngd_key1 = ""
      and lngd_key2 = ""
      and lngd_key3 = ""
      and lngd_field = "sc_category"
      and lngd_lang = global_user_lang:
   usr_val[integer(lngd_key4)] = lngd_translation.
   usr_elm[integer(lngd_key4)] = substring(lngd_translation,1,3).
end.

FORM /*GUI*/  site csset
with STREAM-IO /*GUI*/  frame pageheader width 80 side-labels no-attr-space page-top.

/* SET EXTERNAL LABELS */
setFrameLabels(frame pageheader:handle).

display site csset with frame pageheader STREAM-IO /*GUI*/ .

/* RECOGNIZE SITE LINKS FOR GL COST WHEN A GL STANDARD COST SET IS SPECIFIED */

/* CHECK IF THE COST SET ENTERED IS OF TYPE GL AND STANDARD METHOD */
for first cs_mstr no-lock
    where cs_mstr.cs_domain = global_domain and  cs_set = csset:
   if cs_type = "GL" and cs_method = "STD" then
      l_gl_std = true.
end. /* FOR FIRST CS_MSTR */

for each pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part >= part
and pt_part <= part1 no-lock
   with frame det2:

   assign comp = pt_part
      bom_code = if pt_bom_code <> "" then pt_bom_code else pt_part
      maxlevel = min(numlevels,99)
      yield_pct = pt_yield_pct
      level = 1
      batch_qty = 1.

   find ptp_det no-lock  where ptp_det.ptp_domain = global_domain
      and ptp_part = pt_part
      and ptp_site = site no-error.

   if available ptp_det then do:
      bom_code = if ptp_bom_code <> "" then ptp_bom_code else ptp_part.
      yield_pct = ptp_yld_pct.
   end.

   comp = bom_code.

 for first bom_mstr
    fields(bom_domain bom_batch bom_batch_um bom_desc bom_formula bom_parent)
    where bom_mstr.bom_domain = global_domain
    and   bom_parent = bom_code
    and   (formula_only = no
           or bom_formula)
 no-lock:
 end. /* FOR FIRST bom_mstr */

 if not available bom_mstr
 then
    next.
 else do:

   find first ps_mstr no-lock use-index ps_parcomp
       where ps_mstr.ps_domain = global_domain and  ps_par = comp no-error.
   if not available ps_mstr then next.

   parent = pt_part.


   /* CHECK IF THIS ITEM IS LINKED TO ANOTHER SITE FOR THE COST  */
   l_linked = false.
   if l_gl_std then
   for first in_mstr no-lock
       where in_mstr.in_domain = global_domain and  in_part = pt_part
      and in_site = site:
      if in_gl_cost_site <> in_site then
      assign
         l_linked = true
         des[10] = "  " + getTermLabel("GL_COST_SOURCE_SITE",12) + ": "
                + string(in_gl_cost_site).
   end. /* FOR FIRST IN_MSTR */


   if l_linked then
      find sct_det  where sct_det.sct_domain = global_domain and  sct_sim =
      csset and sct_part = pt_part
       and sct_site = in_gl_cost_site no-lock no-error.
   else
      find sct_det  where sct_det.sct_domain = global_domain and  sct_sim =
      csset  and sct_part = pt_part
       and sct_site =  site no-lock no-error.

   FORM /*GUI*/ 
      lvl ps_comp format "x(26)" qty_per qty_type um ps_ps_code
      spt_element cat_desc spt_cst_tl spt_cst_ll spt_tot spt_xtd
   with STREAM-IO /*GUI*/  frame det2 down width 134 no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame det2:handle).

   do i = 1 to 9:
      des[i] = "".
   end.

   des[1] = pt_desc1.
   des[2] = pt_desc2.

   if available sct_det and sct_cst_date <> ?
      then des[3] = string(sct_cst_date).

   if scrp_pct     <> 0
      or yield_pct <> 100
   then
      assign
         des[4] = (getTermLabel("SCRAP",5)     + ": "
                  + string(scrp_pct, ">>9.99") + "%")
         des[5] = (getTermLabel("YIELD",5) + ": " + string(yield_pct) + "%").

   if page-size - line-counter < 10 then page.

   find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
   bom_parent = pt_part no-error.
   if available bom_mstr then do:
      batch_qty = bom_batch.
      batch_um  = bom_batch_um.
   end.
   par_qty = 1.

   display getTermLabel("PARENT",6) @ lvl parent @ ps_comp WITH STREAM-IO /*GUI*/ .

   if transtype = "FM" then do:
      display
         ""           @ qty_per

         ""          @ qty_type WITH STREAM-IO /*GUI*/ .
      if batch_qty <> 0 and batch_qty <> 1 then
         des[7] = getTermLabel("BATCH_QTY",9) + ": " + string(batch_qty)
               + " " + batch_um.
   end.

   if available ptp_det then joint_type = ptp_joint_type.
   else joint_type = pt_joint_type.
   if joint_type <> "" then do:
      /* Numeric ps_joint_type returns alpha code, label */
      {gplngn2a.i &file     = ""wo_mstr""
         &field    = ""wo_joint_type""
         &code     = joint_type
         &mnemonic = joint_code
         &label    = joint_label}
      des[8] = joint_label.
   end.

   do k = 1 to 7:
      do j = 1 to 7:
         if des[j] = "" then do:
            do i = j to 8:
               des[i] = des[i + 1].
            end.
         end.
      end.
   end.

   if available sct_det then do:

      i = -1.
      for each spt_det no-lock  where spt_det.spt_domain = global_domain and
      spt_site = sct_site
            and spt_sim  = sct_sim
            and spt_part = sct_part
            break by spt_site by spt_sim by spt_part
            by spt_pct_ll by spt_cst_tl descending by spt_element with frame det2:

         i = min(8, i + 1).

         spt_tot = spt_cst_tl + spt_cst_ll.
         spt_xtd = par_qty * (spt_cst_tl + spt_cst_ll).

         display fill(" ",2) + des[i] when (i >= 1) @ ps_comp spt_element
            usr_elm[integer(truncate(spt_pct_ll,0))] @ cat_desc
            spt_cst_tl spt_cst_ll spt_tot spt_xtd WITH STREAM-IO /*GUI*/ .
         down.

         accumulate spt_cst_tl (total by spt_part).
         accumulate spt_cst_ll (total by spt_part).
         accumulate spt_tot    (total by spt_part).
         accumulate spt_xtd    (total by spt_part).

         if last-of(spt_part) then do with frame det2:
            down.
            do j = i + 1 to 9:
               if des[j] <> "" then do:
                  display fill(" ",2) + des[j] @ ps_comp WITH STREAM-IO /*GUI*/ .
                  down.
               end.
            end.
            /* ss - 121011.1 -b */
            /*underline spt_cst_tl spt_cst_ll spt_tot spt_xtd.*/
            display spt_cst_tl spt_cst_ll spt_tot spt_xtd WITH STREAM-IO.
            /* ss - 121011.1 -e */
            down.
            display
               getTermLabelRtColon("TOTAL",8) @ spt_element
               (accum total by spt_part spt_cst_tl) @ spt_cst_tl
               (accum total by spt_part spt_cst_ll) @ spt_cst_ll
               (accum total by spt_part spt_tot) @ spt_tot
               (accum total by spt_part spt_xtd) @ spt_xtd WITH STREAM-IO /*GUI*/ .
            down 1.
         end.
      end.
   end.

   /* IF THIS PARENT IS LINKED DISPLAY THE GL COST SITE */
   if l_linked then do with frame det2:
      display des[10] @ ps_comp WITH STREAM-IO /*GUI*/ .
   end.

   /* IF THIS PARENT IS LINKED DISPLAY THE LINKED COST AND GO TO THE */
   /* NEXT ITEM, DO NOT DISPLAY ITS COMPONENTS COST.                 */
   if l_linked then next.

   repeat with frame det2:

      l_linked = false.

      if l_gl_std then
      for first in_mstr
         fields( in_domain in_site in_gl_cost_site)
          where in_mstr.in_domain = global_domain and  in_part = comp
         and in_site = site no-lock:

         if in_gl_cost_site <> in_site then
            l_linked = true.
      end. /* FOR FIRST IN_MSTR */

      if (not available ps_mstr) or (l_linked) then do:
         repeat:
            level = level - 1.
            if level < 1 then leave.
            find ps_mstr where recid(ps_mstr) = record[level]
            no-lock no-error.
            comp = ps_par.
            find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
            no-lock no-error.
            if available ps_mstr then leave.
         end.
      end.
      if level < 1 then leave.

      if eff_date = ? or (eff_date <> ? and
         (ps_start = ? or ps_start <= eff_date)
         and (ps_end = ? or eff_date <= ps_end)) then do:

         assign um = ""
            iss_pol = no
            phantom = no
            dpart = ps_comp
            bom_code = ps_comp
            yield_pct = 100
            batch_qty = 1.

         do i = 1 to 9:
            des[i] = "".
         end.

         find ptmstr  where ptmstr.pt_domain = global_domain and
         ptmstr.pt_part = ps_comp no-lock no-error.
         if available ptmstr then do:
            assign um = ptmstr.pt_um
               des[1] = ptmstr.pt_desc1
               des[2] = ptmstr.pt_desc2
               iss_pol = ptmstr.pt_iss_pol
               phantom = ptmstr.pt_phantom
               yield_pct = ptmstr.pt_yield_pct
               bom_code = if ptmstr.pt_bom_code <> ""
               then ptmstr.pt_bom_code else ptmstr.pt_part.

            find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
            ptp_part = ptmstr.pt_part
               and ptp_site = site no-error.
            if available ptp_det then
            assign
               iss_pol = ptp_iss_pol
               phantom = ptp_phantom
               yield_pct = ptp_yld_pct
               bom_code = if ptp_bom_code <> ""
               then ptp_bom_code else ptp_part.
         end.

         find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
         bom_parent = ps_comp no-error.
         if available bom_mstr then do:
            batch_qty = bom_batch.
            batch_um  = bom_batch_um.
            if not available ptmstr then do:
               des[1] = bom_desc.
               um     = bom_batch_um.
            end.
         end.

         record[level] = recid(ps_mstr).
         lvl = "......".
         lvl = substring(lvl,1,min(level - 1,5)) + string(level).
         if length(lvl) > 6
            then lvl = substring(lvl,length(lvl) - 5,6).

         for each pswkfl exclusive-lock:
            delete pswkfl.
         end.

         create pswkfl.
         assign
            psrecid = recid(ps_mstr)
            pscode = ps_ps_code
            psstart = ps_start
            psqtype = ps_qty_type.
         if transtype <> "BM" then
            qty_per_b = qty_per_b + ps_qty_per_b.
         net_qty = ps_qty_per * (100 / (100 - ps_scrp_pct)).
         qty_per = ps_qty_per.

         repeat:
            find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
               and ps_comp = dpart no-lock no-error.
            if not available ps_mstr then leave.
            record[level] = recid(ps_mstr).
            if eff_date = ? or (eff_date <> ? and
               (ps_start = ? or ps_start <= eff_date)
               and (ps_end = ? or eff_date <= ps_end)) then do:
               find first pswkfl where pscode = ps_ps_code
                  and psstart = ps_start
                  and psqtype = ps_qty_type
                  no-error.
               if not available pswkfl then do:
                  create pswkfl.
                  assign
                     pscode = ps_ps_code
                     psstart = ps_start
                     psqtype = ps_qty_type.
               end.
               psrecid = recid(ps_mstr).
               if transtype <> "BM" then
                  qty_per_b = qty_per_b + ps_qty_per_b.
               qty_per = qty_per + ps_qty_per.
               net_qty = net_qty
               + ps_qty_per * (100 / (100 - ps_scrp_pct)).
            end.
         end.

         for each pswkfl with frame det2:
            find ps_mstr where recid(ps_mstr) = psrecid
            no-lock no-error.

            if available ptmstr then do:

               l_linked = false.

               if l_gl_std then
               for first in_mstr
                  fields( in_domain in_site in_gl_cost_site)
                   where in_mstr.in_domain = global_domain and  in_part =
                   ptmstr.pt_part
                  and in_site = site no-lock:

                  if in_gl_cost_site <> in_site then
                  assign
                     l_linked = true
                     des[10] = "  " + getTermLabel("GL_COST_SOURCE_SITE",12)
                              + ": " + string(in_gl_cost_site).

               end. /* FOR FIRST IN_MSTR */

               if l_linked then
                  find sct_det  where sct_det.sct_domain = global_domain and
                  sct_sim = csset
                   and sct_part = ptmstr.pt_part
                   and sct_site = in_gl_cost_site no-lock no-error.
               else
                  find sct_det  where sct_det.sct_domain = global_domain and
                  sct_sim = csset
                   and sct_part = ptmstr.pt_part
                   and sct_site =  site no-lock no-error.
            end.
            else do:                 /*create a temporary 0.00 record*/
               {gpsct08.i &part=dingbats &set=csset &site=site}
            end.

            scrp_pct = 0.
            if net_qty <> 0
               then scrp_pct = 100 * (net_qty - qty_per) / net_qty.

            if available sct_det and sct_cst_date <> ?
               then des[3] = string(sct_cst_date).
            if scrp_pct     <> 0
               or yield_pct <> 100
            then
               assign
                  des[4] = (getTermLabel("SCRAP",5)     + ": "
                           + string(scrp_pct, ">>9.99") + "%")
                  des[5] = (getTermLabel("YIELD",5) + ": "
                           + string(yield_pct)      + "%").

            if bom_code <> ps_comp then
               des[6] = getTermLabel("BOM",4) + ": " + bom_code.

            if page-size - line-counter < 6
               then page.
            else down 2.

            display lvl ps_comp qty_per um ps_ps_code WITH STREAM-IO /*GUI*/ .

            if transtype = "FM" then do:
               display
                  qty_per_b @ qty_per
                  ps_qty_type @ qty_type WITH STREAM-IO /*GUI*/ .
               if batch_qty <> 0 and batch_qty <> 1 then
                  des[7] = getTermLabel("BATCH_QTY",9) + ": "
                           + string(batch_qty) + " "
                           + batch_um.
            end.

            joint_type = "".
            joint_label = "".
            find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
            ptp_part = ps_comp
               and ptp_site = site no-error.
            if available ptp_det then joint_type = ptp_joint_type.
            else do:
               find pt_mstr1 no-lock  where pt_mstr1.pt_domain = global_domain
               and  pt_mstr1.pt_part = ps_comp
                  no-error.
               if available pt_mstr1 then
                  joint_type = pt_mstr1.pt_joint_type.
            end.
            if joint_type <> "" then do:
               /* Numeric ps_joint_type returns alpha code, label */
               {gplngn2a.i &file     = ""wo_mstr""
                  &field    = ""wo_joint_type""
                  &code     = joint_type
                  &mnemonic = joint_code
                  &label    = joint_label}
               des[8] = joint_label.
            end.

            do j = 1 to 7:
               do i = j + 1 to 8:
                  if des[i] = des[j] then des[i] = "".
               end.
            end.

            do k = 1 to 7:
               do j = 1 to 7:
                  if des[j] = "" then do:
                     do i = j to 8:
                        des[i] = des[i + 1].
                     end.
                  end.
               end.
            end.

            if available sct_det then do:
               i = -1.
               for each spt_det no-lock  where spt_det.spt_domain =
               global_domain and  spt_site = sct_site
                     and spt_sim  = sct_sim
                     and spt_part = sct_part
                     break by spt_site by spt_sim by spt_part by spt_pct_ll
                     by spt_cst_tl descending by spt_element with frame det2:

                  i = min(8, i + 1).

                  spt_tot = spt_cst_tl + spt_cst_ll.
                  spt_xtd = qty_per * (spt_cst_tl + spt_cst_ll)
                  * (100 / (100 - scrp_pct)).

                  if page-size - line-counter < 4 then page.

                  display fill(" ",2) + des[i] when (i >= 1) @ ps_comp
                     spt_element
                     usr_elm[integer(truncate(spt_pct_ll,0))] @ cat_desc
                     spt_cst_tl spt_cst_ll spt_tot spt_xtd WITH STREAM-IO /*GUI*/ .
                  down.

                  accumulate spt_cst_tl (total by spt_part).
                  accumulate spt_cst_ll (total by spt_part).
                  accumulate spt_tot    (total by spt_part).
                  accumulate spt_xtd    (total by spt_part).

                  if last-of(spt_part) then do with frame det2:
                     down.
                     do j = i + 1 to 9:
                        if fill(" ",2) + des[j] <> "" then do:
                           display fill(" ",2) + des[j] @ ps_comp WITH STREAM-IO /*GUI*/ .
                           down.
                        end.
                     end.
                     /* ss - 121011.1 -b */
                     /*underline spt_cst_tl spt_cst_ll spt_tot spt_xtd.*/
                     display spt_cst_tl spt_cst_ll spt_tot spt_xtd WITH STREAM-IO.
                     /* ss - 121011.1 -e */
                     down.
                     display
                        getTermLabelRtColon("TOTAL",8) @ spt_element
                        (accum total by spt_part spt_cst_tl) @ spt_cst_tl
                        (accum total by spt_part spt_cst_ll) @ spt_cst_ll
                        (accum total by spt_part spt_tot) @ spt_tot
                        (accum total by spt_part spt_xtd) @ spt_xtd WITH STREAM-IO /*GUI*/ .
                     down 1.
                  end. /* IF LAST-OF(spt_part)... */
               end. /* FOR EACH spt_det */
            end. /* IF AVAILABLE spt_det */

            /* IF THIS PARENT IS LINKED DISPLAY THE GL COST SITE */
            if l_linked then do with frame det2:
               display des[10] @ ps_comp WITH STREAM-IO /*GUI*/ .
            end.
         end. /*for each pswkfl*/

         find ps_mstr where recid(ps_mstr) = record[level]
         no-lock no-error.

         if level < maxlevel or maxlevel = 0 then do:
            comp = bom_code.
            level = level + 1.
            find first ps_mstr use-index ps_parcomp
                where ps_mstr.ps_domain = global_domain and  ps_par = comp
                no-lock no-error.
         end.
         else do:
            find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
            no-lock no-error.
         end.

         if available sct_det and sct_part = dingbats then do:
            for each spt_det exclusive-lock
                   where spt_det.spt_domain = global_domain and  spt_site =
                   sct_site
                  and spt_sim = sct_sim and spt_part = sct_part:
               delete spt_det.
            end.
            delete sct_det.
         end.
      end.
      else do:
         find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
         global_domain and  ps_par = comp
         no-lock no-error.
      end.

      
/*GUI*/ {mfguichk.i  "false"} /*Replace mfrpchk*/

   end.

   if newpage then page.
   else put skip(1).

   
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


 end. /* IF AVAILABLE bom_mstr */

end. /* FOR EACH pt_mstr */

{wbrp04.i}
