/* GUI CONVERTED from bmcsrp1a.p (converter v1.78) Wed Dec 20 14:07:58 2006 */
/* bmcsrp1a.p - BILL OF MATERIAL COST REPORT BY CATEGORY                */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 12/19/91   BY: emb                 */
/* REVISION: 7.0      LAST MODIFIED: 05/30/92   BY: pma *F542*          */
/* REVISION: 7.2      LAST MODIFIED: 03/08/93   BY: pma *G032*          */
/* REVISION: 7.3      LAST MODIFIED: 09/03/93   BY: pxd *GE64*          */
/* REVISION: 7.3      LAST MODIFIED: 10/27/94   BY: ame *FS91*          */
/* REVISION: 7.3      LAST MODIFIED: 02/08/95   BY: cpp *F0HL*          */
/* REVISION: 7.3      LAST MODIFIED: 03/08/95   BY: pxd *F0JP*          */
/* REVISION: 7.3      LAST MODIFIED: 03/10/95   BY: pxd *F0MK*          */
/* REVISION: 8.5      LAST MODIFIED: 12/06/94   BY: tjs *J027*          */
/* REVISION: 7.3      LAST MODIFIED: 11/02/95   BY: bcm *G1BZ*          */
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G2BK*  Russ Witt   */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: GYK *K0ZG*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Mudit Mehta  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *K0ZG*                  */
/* Revision: 1.7.1.6    BY: Tiziana Giustozzi   DATE: 10/23/01 ECO: *N14W* */
/* Revision: 1.7.1.7    BY: Samir Bavkar        DATE: 04/12/02 ECO: *P000* */
/* Revision: 1.7.1.9    BY: Paul Donnelly (SB)  DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.7.1.10   BY: Rajaneesh S.        DATE: 08/27/03 ECO: *N2KC* */
/* Revision: 1.7.1.12   BY: Manish Dani         DATE: 06/28/05 ECO: *P3QQ* */
/* Revision: 1.7.1.12   BY: Munira Savai        DATE: 07/11/06 ECO: *P4WX* */
/* $Revision: 1.7.1.13 $ BY: Gaurav Kerkar      DATE: 12/14/06 ECO: *P5JD* */
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

&SCOPED-DEFINE bmcsrp1a_p_1 "Levels"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1a_p_2 "Ph"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1a_p_4 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmcsrp1a_p_9 "/no"
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
define variable maxlevel as integer format ">>>" label {&bmcsrp1a_p_1} no-undo.
define variable record as integer extent 100 no-undo.
define variable des2 as character format "x(40)" no-undo.
define variable des3 as character format "x(40)" no-undo.
define variable des4 as character format "x(40)" no-undo.
define variable des5 as character format "x(40)" no-undo.
define variable des6 as character format "x(40)" no-undo.
define variable des7 as character format "x(40)" no-undo.
define variable des8 as character format "x(40)" no-undo.
define variable scrp_pct like ps_scrp_pct no-undo.
define variable qty_type like ps_qty_type.
define variable part_type like pt_part_type no-undo.
define variable parent like ps_par no-undo.
define variable desc1 like pt_desc1 no-undo.
define variable um like pt_um no-undo.
define variable phantom like mfc_logical format "yes" label {&bmcsrp1a_p_2} no-undo.
define variable iss_pol like pt_iss_pol format {&bmcsrp1a_p_9} no-undo.
define variable lvl as character format "x(6)" label {&bmcsrp1a_p_4} no-undo.
define variable dpart like pt_part no-undo.
define variable mtl_tl like sct_mtl_tl format "->>>>>>>9.99<<<<<<" no-undo.
define variable lbr_tl like sct_lbr_tl format "->>>>>>>9.99<<<<<<" no-undo.
define variable bdn_tl like sct_bdn_tl format "->>>>>>>9.99<<<<<<" no-undo.
define variable ovh_tl like sct_ovh_tl format "->>>>>>>9.99<<<<<<" no-undo.
define variable sub_tl like sct_sub_tl format "->>>>>>>9.99<<<<<<" no-undo.
define variable total_tl like sct_cst_tot format "->>>>>>>9.99<<<<<<" no-undo.
/* ss - 121011.1 -b */
define variable mtl_ll like sct_mtl_ll format "->>>>>>>9.99<<<<<<" no-undo.
define variable lbr_ll like sct_lbr_ll format "->>>>>>>9.99<<<<<<" no-undo.
define variable bdn_ll like sct_bdn_ll format "->>>>>>>9.99<<<<<<" no-undo.
define variable ovh_ll like sct_ovh_ll format "->>>>>>>9.99<<<<<<" no-undo.
define variable sub_ll like sct_sub_ll format "->>>>>>>9.99<<<<<<" no-undo.
/* ss - 121011.1 -e */
define variable mtl_tot like mtl_tl no-undo.
define variable lbr_tot like lbr_tl no-undo.
define variable bdn_tot like bdn_tl no-undo.
define variable ovh_tot like ovh_tl no-undo.
define variable sub_tot like sub_tl no-undo.
define variable total_ll like total_tl no-undo.
define variable mtl_ext like mtl_tl no-undo.
define variable lbr_ext like sub_tl no-undo.
define variable bdn_ext like bdn_tl no-undo.
define variable ovh_ext like ovh_tl no-undo.
define variable sub_ext like sub_tl no-undo.
define variable total_ext like total_tl no-undo.
define variable dingbats as character initial "temp!@#$".
define variable bom_code like pt_bom_code.
define variable yield_pct like pt_yield.
define variable joint_label like lngd_translation.
define variable joint_code like wo_joint_type.
define variable joint_type like wo_joint_type.
define variable batch_qty like bom_batch.
define variable batch_um like bom_batch_um.
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

   assign
      comp = pt_part
      bom_code = if pt_bom_code <> "" then pt_bom_code else pt_part
      maxlevel = min(numlevels,99)
      yield_pct = pt_yield_pct
      scrp_pct = 0
      level = 1.

   find ptp_det no-lock  where ptp_det.ptp_domain = global_domain
      and  ptp_part = pt_part
      and ptp_site = site no-error.

   if available ptp_det
   then do:
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

   /* CHECK IF THIS ITEM IS LINKED TO ANOTHER SITE FOR GL COST  */
   l_linked = false.
   if l_gl_std then
   for first in_mstr no-lock
       where in_mstr.in_domain = global_domain and  in_part = pt_part
      and in_site = site:
      if in_gl_cost_site <> in_site then
      assign
         l_linked = true
         des8 = "  " + getTermLabel("GL_COST_SOURCE_SITE",12) + ": "
                + string(in_gl_cost_site).
   end. /* FOR FIRST IN_MSTR */

   if l_linked then
      find sct_det  where sct_det.sct_domain = global_domain and  sct_sim =
      csset and sct_part = pt_part
       and sct_site = in_gl_cost_site no-lock no-error.
   else
      find sct_det  where sct_det.sct_domain = global_domain and  sct_sim =
      csset and sct_part = pt_part
       and sct_site = site no-lock no-error.

   FORM /*GUI*/ 
      lvl ps_comp format "x(18)" qty_per qty_type um ps_ps_code
      mtl_tl lbr_tl bdn_tl ovh_tl sub_tl total_tl 
      /* ss - 121011.1 -b */      
      mtl_ll lbr_ll bdn_ll ovh_ll sub_ll total_ll sct_cst_tot total_ext
      /* ss - 121011.1 -e */
   with STREAM-IO /*GUI*/  frame det2 width 320 no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame det2:handle).

   /* START DISPLAY */
   if available sct_det then
   assign
      total_tl = sct_mtl_tl + sct_lbr_tl + sct_bdn_tl + sct_sub_tl + sct_ovh_tl
      total_ll = sct_mtl_ll + sct_lbr_ll + sct_bdn_ll + sct_sub_ll + sct_ovh_ll
      mtl_tot = sct_mtl_tl + sct_mtl_ll
      lbr_tot = sct_lbr_tl + sct_lbr_ll
      bdn_tot = sct_bdn_tl + sct_bdn_ll
      ovh_tot = sct_ovh_tl + sct_ovh_ll
      sub_tot = sct_sub_tl + sct_sub_ll
      des2 = pt_desc2
      des3 = "".

   else
   assign
      total_tl = 0
      total_ll = 0
      mtl_tot = 0
      lbr_tot = 0
      bdn_tot = 0
      ovh_tot = 0
      sub_tot = 0
      des2 = pt_desc2
      des3 = "".

   if available sct_det and sct_cst_date <> ?
   then do:
      if des2 = "" then des2 = string(sct_cst_date).
      else des3 = string(sct_cst_date).
   end.

   assign
      des4 = ""
      des5 = "".
   /* ss - 121011.1 -b */
   /*if scrp_pct      <> 0
      and yield_pct = 100
   then
      des4 = getTermLabel("SCRAP",6) + ": " + string(scrp_pct, ">>9.99") + "%".

   else
   if scrp_pct      = 0
      and yield_pct <> 100
   then
      des4 = des4 + getTermLabel("YIELD",5) + ": " + string(yield_pct) + "%".

   else
      if scrp_pct      <> 0
         and yield_pct <> 100
      then
         assign
            des4 = (getTermLabel("SCRAP",6)     + ": "
                   + string(scrp_pct, ">>9.99") + "%")
            des5 = (getTermLabel("YIELD",5) + ": " + string(yield_pct) + "%").

   if des3 = ""
   then do:
      assign
         des3 = des4
         des4 = des5
         des5 = "".
   end.*/
   /* ss - 121011.1 -b */
   if page-size - line-counter < 10 then page.

   find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
   bom_parent = pt_part no-error.

   if available bom_mstr
   then do:
      assign
         batch_qty = bom_batch
         batch_um  = bom_batch_um.
   end.

   display getTermLabel("PARENT",6) @ lvl parent @ ps_comp WITH STREAM-IO /*GUI*/ .

   if transtype = "BM"
   then do:
      display
         " " @ mtl_tl
         " " @ lbr_tl
         " " @ bdn_tl
         " " @ ovh_tl
         " " @ sub_tl
         " " @ total_tl 
         /* ss - 121011.1 -b */ 
         " " @ mtl_ll
         " " @ lbr_ll
         " " @ bdn_ll
         " " @ ovh_ll
         " " @ sub_ll
         " " @ total_ll    
         " " @ total_ext
         /* ss - 121011.1 -e */ 
         WITH STREAM-IO /*GUI*/ .
   end.

   else do:
      if batch_qty <> 1 then
      /*display
         getTermLabelRtColon("BATCH_QTY",11) @ mtl_tl
         batch_qty @ lbr_tl
         batch_um @ bdn_tl
         " " @ ovh_tl
         " " @ sub_tl
         " " @ total_tl WITH STREAM-IO  121011.1 */ /*GUI*/ .
      else
      display
         " " @ mtl_tl
         " " @ lbr_tl
         " " @ bdn_tl
         " " @ ovh_tl
         " " @ sub_tl
         " " @ total_tl 
         /* ss - 121011.1 -b */    
         " " @ mtl_ll              
         " " @ lbr_ll              
         " " @ bdn_ll              
         " " @ ovh_ll              
         " " @ sub_ll              
         " " @ total_ll  
         " " @ total_ext           
         /* ss - 121011.1 -e */         
         WITH STREAM-IO /*GUI*/ .
   end.
   /* ss - 121011.1 -b */ 
   /*
   down 1.   
   display
      "  " + pt_desc1 @ ps_comp
      getTermLabelRt("THIS_LEVEL",12) format "x(12)" @ qty_per
      total_tl
   with frame det2 STREAM-IO*/ /*GUI*/ .
   /* ss - 121011.1 -e */
   if available sct_det then
   display
      sct_mtl_tl @ mtl_tl
      sct_lbr_tl @ lbr_tl
      sct_bdn_tl @ bdn_tl
      sct_ovh_tl @ ovh_tl
      sct_sub_tl @ sub_tl 
      /* ss - 121011.1 -b */  
      total_tl
      sct_mtl_ll @ mtl_ll
      sct_lbr_ll @ lbr_ll
      sct_bdn_ll @ bdn_ll
      sct_ovh_ll @ ovh_ll
      sct_sub_ll @ sub_ll 
      total_ll      
      /* ss - 121011.1 -e */ 
      with frame det2 STREAM-IO /*GUI*/ .

   else
   display
      0          @ mtl_tl
      0          @ lbr_tl
      0          @ bdn_tl
      0          @ ovh_tl
      0          @ sub_tl 
      /* ss - 121011.1 -b */ 
      0          @ total_tl 
      0          @ mtl_ll
      0          @ lbr_ll
      0          @ bdn_ll
      0          @ ovh_ll
      0          @ sub_ll 
      0          @ total_ll
      /* ss - 121011.1 -e */    
      with frame det2 STREAM-IO /*GUI*/ .
   /* ss - 121011.1 -b */
   /*
   down 1.    
   display
      "  " + des2 @ ps_comp
      getTermLabelRt("LOWER_LEVEL",12) format "x(12)" @ qty_per  
      total_ll  @ total_tl 
   with frame det2 STREAM-IO  .*/  /*GUI*/
   /* ss - 121011.1 -e */
   if available sct_det then
   display
      sct_mtl_ll @ mtl_tl
      sct_lbr_ll @ lbr_tl
      sct_bdn_ll @ bdn_tl
      sct_ovh_ll @ ovh_tl
      sct_sub_ll @ sub_tl       
      /* ss - 121011.1 -b */ 
      total_tl
      sct_mtl_ll @ mtl_ll
      sct_lbr_ll @ lbr_ll
      sct_bdn_ll @ bdn_ll
      sct_ovh_ll @ ovh_ll
      sct_sub_ll @ sub_ll  
      total_ll
      /* ss - 121011.1 -e */ 
      with frame det2 STREAM-IO /*GUI*/ .

   else
   display
      0          @ mtl_tl
      0          @ lbr_tl
      0          @ bdn_tl
      0          @ ovh_tl
      0          @ sub_tl 
      /* ss - 121011.1 -b */ 
      0          @ total_tl 
      0          @ mtl_ll
      0          @ lbr_ll
      0          @ bdn_ll
      0          @ ovh_ll
      0          @ sub_ll 
      0          @ total_ll
      /* ss - 121011.1 -e */   
      with frame det2 STREAM-IO /*GUI*/ .
   
   /* ss - 121011.1 -b */
   /*
   down 1.     
   display
      "  " + des3 @ ps_comp
      getTermLabelRt("UNIT_TOTAL",12) format "x(12)" @ qty_per
      mtl_tot @ mtl_tl
      lbr_tot @ lbr_tl
      bdn_tot @ bdn_tl
      ovh_tot @ ovh_tl
      sub_tot @ sub_tl
   with frame det2 STREAM-IO /*GUI*/ .   
   if available sct_det then
   display
      sct_cst_tot @ total_tl with frame det2 STREAM-IO /*GUI*/ .
   else
   display
      0 @ total_tl with frame det2 STREAM-IO /*GUI*/ .   
   if des4 <> ""
   then do:
      down 1.
      display "  " + des4 @ ps_comp with frame det2 STREAM-IO /*GUI*/ .
   end.
   if des5 <> ""
   then do:
      down 1.
      display "  " + des5 @ ps_comp with frame det2 STREAM-IO /*GUI*/ .
   end.
   if bom_code <> parent
      then do with frame det2:
      if des3 <> "" then down 1.
      display
         "  " + getTermLabel("BOM",4) + ": " + bom_code @ ps_comp WITH STREAM-IO /*GUI*/ .
   end.
   
   joint_label = "".

   if available ptp_det then
      joint_type = ptp_joint_type.

   else
      joint_type = pt_joint_type.

   if joint_type <> ""
      then do with frame det2:
      /* Numeric ps_joint_type returns alpha code, label */
      {gplngn2a.i &file     = ""wo_mstr""
         &field    = ""wo_joint_type""
         &code     = joint_type
         &mnemonic = joint_code
         &label    = joint_label}

      if bom_code <> parent or des3 <> "" then down 1.

      display "  " + joint_label @ ps_comp WITH STREAM-IO /*GUI*/ .

   end.

   /* IF THIS PARENT IS LINKED DISPLAY THE GL COST SITE */
   if l_linked then do with frame det2:
      display des8 @ ps_comp WITH STREAM-IO /*GUI*/ .
   end.
   */
   /* ss - 121011.1 -e */

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
            find ps_mstr where recid(ps_mstr) = record[level] no-lock no-error.
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
         and (ps_end = ? or eff_date <= ps_end))
      then do:

         assign
            desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24)
            des2 = ""
            des3 = ""
            um = ""
            iss_pol = no
            phantom = no
            dpart = ps_comp
            bom_code = ps_comp
            batch_qty = 1
            yield_pct = 100.

         find ptmstr  where ptmstr.pt_domain = global_domain and
         ptmstr.pt_part = ps_comp no-lock no-error.

         if available ptmstr
         then do:
            assign
               um = ptmstr.pt_um
               desc1 = ptmstr.pt_desc1
               des2 = ptmstr.pt_desc2
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
               bom_code = if ptp_bom_code <> "" then ptp_bom_code else ptp_part.
         end.

         find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
         bom_parent = ps_comp no-error.

         if available bom_mstr
         then do:
            assign
               batch_qty = bom_batch
               batch_um  = bom_batch_um.

            if not available ptmstr
            then do:
               assign
                  desc1 = bom_desc
                  um    = bom_batch_um.
            end.

         end.

         assign
            record[level] = recid(ps_mstr)
            lvl = "......"
            lvl = substring(lvl,1,min(level - 1,5)) + string(level).

         if length(lvl) > 6 then lvl = substring(lvl,length(lvl) - 5,6).

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

         if ps_scrp_pct = 100 then
            net_qty = 0.

         else
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
               and (ps_end = ? or eff_date <= ps_end))
            then do:
               find first pswkfl where pscode = ps_ps_code
                  and psstart = ps_start
                  and psqtype = ps_qty_type
                  no-error.

               if not available pswkfl
               then do:
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

               if ps_scrp_pct = 100 then
                  net_qty = 0.

               else
                  net_qty = net_qty + ps_qty_per * (100 / (100 - ps_scrp_pct)).

            end.

         end.

         for each pswkfl with frame det2:
            find ps_mstr where recid(ps_mstr) = psrecid no-lock no-error.

            if available ptmstr
            then do:

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
                           des8 = "  " + getTermLabel("GL_COST_SOURCE_SITE",12)
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
                  and sct_site = site no-lock no-error.

            end.

            else do:                 /*create a temporary 0.00 record*/
               {gpsct08.i &part=dingbats &set=csset &site=site}
            end.

            if available sct_det then
            assign
               total_tl = sct_mtl_tl + sct_lbr_tl + sct_bdn_tl
               + sct_sub_tl + sct_ovh_tl
               total_ll = sct_mtl_ll + sct_lbr_ll + sct_bdn_ll
               + sct_sub_ll + sct_ovh_ll
               mtl_tot = sct_mtl_tl + sct_mtl_ll
               lbr_tot = sct_lbr_tl + sct_lbr_ll
               bdn_tot = sct_bdn_tl + sct_bdn_ll
               ovh_tot = sct_ovh_tl + sct_ovh_ll
               sub_tot = sct_sub_tl + sct_sub_ll.

            else
            assign
               total_tl = 0
               total_ll = 0
               mtl_tot = 0
               lbr_tot = 0
               bdn_tot = 0
               ovh_tot = 0
               sub_tot = 0.

            assign
               mtl_ext = (mtl_tot * qty_per)
               lbr_ext = (lbr_tot * qty_per)
               bdn_ext = (bdn_tot * qty_per)
               ovh_ext = (ovh_tot * qty_per)
               sub_ext = (sub_tot * qty_per)
               scrp_pct = 0.

            if net_qty <> 0 then scrp_pct = 100 * (net_qty - qty_per) / net_qty.

            if scrp_pct <> 100
            then do:
               assign
                  mtl_ext = mtl_ext * (100 / (100 - scrp_pct))
                  lbr_ext = lbr_ext * (100 / (100 - scrp_pct))
                  bdn_ext = bdn_ext * (100 / (100 - scrp_pct))
                  ovh_ext = ovh_ext * (100 / (100 - scrp_pct))
                  sub_ext = sub_ext * (100 / (100 - scrp_pct)).
            end.

            assign
               total_ext = mtl_ext + lbr_ext + bdn_ext + sub_ext + ovh_ext
               des4 = ""
               des5 = "".

            if scrp_pct      <> 0
               and yield_pct = 100
            then
               des4 = getTermLabel("SCRAP",6)      + ": "
                      + string(scrp_pct, ">>9.99") + "%".

            else
               if scrp_pct      = 0
                  and yield_pct <> 100
               then
                 des4 = des4 + getTermLabel("YIELD",5) + ": "
                        + string(yield_pct) + "%".

            else
               if scrp_pct      <> 0
                  and yield_pct <> 100
               then
                  assign
                     des4 = (getTermLabel("SCRAP",6)     + ": "
                            + string(scrp_pct, ">>9.99") + "%")
                     des5 = (getTermLabel("YIELD",5) + ": "
                            + string(yield_pct)      + "%").

            if available sct_det and sct_cst_date <> ? then
               des3 = string(sct_cst_date).

            if des2 = ""
            then do:
               assign
                  des2 = des3
                  des3 = "".
            end.

            if des2 = des3 then des3 = "".

            if des3 = ""
            then do:
               assign
                  des3 = des4
                  des4 = des5
                  des5 = "".
            end.

            des6 = "".

            if bom_code <> ps_comp then
               des6 = getTermLabel("BOM",4) + ": " + bom_code.

            if page-size - line-counter < 6 then page.
            else down 1. 

            if transtype = "BM"
            then do:
               display
                  lvl ps_comp qty_per um ps_ps_code
                  " " @ mtl_tl
                  " " @ lbr_tl
                  " " @ bdn_tl
                  " " @ ovh_tl
                  " " @ sub_tl
                  " " @ total_tl 
                  /* ss - 121011.1 -b */ 
                  " " @ mtl_ll
                  " " @ lbr_ll
                  " " @ bdn_ll
                  " " @ ovh_ll
                  " " @ sub_ll
                  " " @ total_ll    
                  " " @ total_ext
                  /* ss - 121011.1 -e */ 
                  
                  WITH STREAM-IO /*GUI*/ .
            end.

            else do:
               display
                  lvl ps_comp
                  qty_per_b @ qty_per
                  ps_qty_type @ qty_type
                  um ps_ps_code WITH STREAM-IO /*GUI*/ .

               if batch_qty <> 0 and batch_qty <> 1 then
               display
                  getTermLabelRtColon("BATCH_QTY",12) @ mtl_tl
                  batch_qty @ lbr_tl
                  batch_um @ bdn_tl
                  " " @ ovh_tl
                  " " @ sub_tl
                  " " @ total_tl 
                  /* ss - 121011.1 -b */ 
                  " " @ mtl_ll
                  " " @ lbr_ll
                  " " @ bdn_ll
                  " " @ ovh_ll
                  " " @ sub_ll
                  " " @ total_ll    
                  " " @ total_ext
                  /* ss - 121011.1 -e */  
                  WITH STREAM-IO /*GUI*/ .
               else
               display
                  " " @ mtl_tl
                  " " @ lbr_tl
                  " " @ bdn_tl
                  " " @ ovh_tl
                  " " @ sub_tl
                  " " @ total_tl 
                  /* ss - 121011.1 -b */ 
                  " " @ mtl_ll
                  " " @ lbr_ll
                  " " @ bdn_ll
                  " " @ ovh_ll
                  " " @ sub_ll
                  " " @ total_ll    
                  " " @ total_ext
                  /* ss - 121011.1 -e */                   
                  WITH STREAM-IO /*GUI*/ .
            end.
            /* ss - 121011.1 -b */ 
            /*
            down 1.
            /*Display first level amounts */
            display
               "  " + desc1 @ ps_comp
               getTermLabelRt("THIS_LEVEL",12) format "x(12)" @ qty_per
               total_tl WITH STREAM-IO /*GUI*/ .
            */
            /* ss - 121011.1 -e */ 
            if available sct_det then
            display
               sct_mtl_tl @ mtl_tl
               sct_lbr_tl @ lbr_tl
               sct_bdn_tl @ bdn_tl
               sct_ovh_tl @ ovh_tl
               sct_sub_tl @ sub_tl 
               /* ss - 121011.1 -b */ 
               total_tl
               sct_mtl_ll @ mtl_ll
               sct_lbr_ll @ lbr_ll
               sct_bdn_ll @ bdn_ll
               sct_ovh_ll @ ovh_ll
               sct_sub_ll @ sub_ll  
               total_ll
               total_ext
               /* ss - 121011.1 -e */ 
               WITH STREAM-IO /*GUI*/ .
            /* ss - 121011.1 -b */ 
            /*
             down 1.
            /*Display second level amounts. */
            display
               "  " + des2 @ ps_comp
               getTermLabelRt("LOWER_LEVEL",12) format "x(12)" @ qty_per
               total_ll @ total_tl WITH STREAM-IO /*GUI*/ .
            */
            /* ss - 121011.1 -e */
            if available sct_det then
            display
               sct_mtl_ll @ mtl_tl
               sct_lbr_ll @ lbr_tl
               sct_bdn_ll @ bdn_tl
               sct_ovh_ll @ ovh_tl
               sct_sub_ll @ sub_tl 
               /* ss - 121011.1 -b */ 
               total_tl
               sct_mtl_ll @ mtl_ll
               sct_lbr_ll @ lbr_ll
               sct_bdn_ll @ bdn_ll
               sct_ovh_ll @ ovh_ll
               sct_sub_ll @ sub_ll  
               total_ll
               total_ext
               /* ss - 121011.1 -e */  
               WITH STREAM-IO /*GUI*/ .
            else
            display
               0          @ mtl_tl
               0          @ lbr_tl
               0          @ bdn_tl
               0          @ ovh_tl
               0          @ sub_tl 
               /* ss - 121011.1 -b */ 
               0          @ mtl_ll
               0          @ lbr_ll
               0          @ bdn_ll
               0          @ ovh_ll
               0          @ sub_ll
               0          @ total_ll    
               0          @ total_ext
               /* ss - 121011.1 -e */  
               WITH STREAM-IO /*GUI*/ .

            /*down 1. 121011.1 */

            if des3 = ""
            then do:
               assign
                  des3 = des4
                  des4 = des5
                  des5 = "".

               if des3 = ""
               then do:
                  assign
                     des3 = des5
                     des5 = "".

               end.

               if des3 = ""
               then do:
                  assign
                     des3 = des6
                     des6 = "".

               end.

            end.

            /* Display totals */
            /* ss - 121011.1 -b */   
            /*
            display
               "  " + des3 @ ps_comp
               getTermLabelRt("UNIT_TOTAL",12) format "x(12)" @ qty_per
               mtl_tot @ mtl_tl
               lbr_tot @ lbr_tl
               bdn_tot @ bdn_tl
               ovh_tot @ ovh_tl
               sub_tot @ sub_tl 
               WITH STREAM-IO   /*GUI*/ .
             
            if available sct_det then
            display
               sct_cst_tot @ total_tl WITH STREAM-IO /*GUI*/ .

            else display 0 @ total_tl WITH STREAM-IO /*GUI*/ .

            down 1.

            if des4 = ""
            then do:
               assign
                  des4 = des6
                  des6 = "".
            end.

            /* Display extended totals */
            display
               "  " + des4 @ ps_comp
               getTermLabelRt("EXT_TOTAL",12) format "x(12)" @ qty_per
               mtl_ext @ mtl_tl
               lbr_ext @ lbr_tl
               bdn_ext @ bdn_tl
               ovh_ext @ ovh_tl
               sub_ext @ sub_tl
               total_ext @ total_tl WITH STREAM-IO /*GUI*/ .

            if des5 <> ""
            then do:
               if des4 <> "" then down 1.
               display
                  "  " + des5 @ ps_comp WITH STREAM-IO /*GUI*/ .
            end.

            if des6 <> ""
            then do:
               if des4 <> "" or des5 <> "" then down 1.
               display
                  "  " + des6 @ ps_comp WITH STREAM-IO /*GUI*/ .
            end.

            /* IF THIS ITEM IS LINKED DISPLAY THE GL COST SITE */
            if l_linked then do with frame det2:
               display des8 @ ps_comp with frame det2 STREAM-IO /*GUI*/ .
            end.

            assign
               joint_type = ""
               joint_label = "".

            find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
            ptp_part = ps_comp
               and ptp_site = site no-error.

            if available ptp_det then joint_type = ptp_joint_type.

            else do:
               find pt_mstr1 no-lock  where pt_mstr1.pt_domain = global_domain
               and  pt_mstr1.pt_part = ps_comp no-error.
               if available pt_mstr1 then joint_type = pt_mstr1.pt_joint_type.

            end.

            if joint_type <> ""
            then do:
               /* Numeric ps_joint_type returns alpha code, label */
               {gplngn2a.i &file     = ""wo_mstr""
                  &field    = ""wo_joint_type""
                  &code     = joint_type
                  &mnemonic = joint_code
                  &label    = joint_label}

               if des4 <> "" or des6 <> "" then down 1.

               display "  " + joint_label @ ps_comp with frame det2 STREAM-IO /*GUI*/ .
            end.

            if (total_tl + total_ll = 0)
               and available ptmstr
               and ptmstr.pt_pm_code = "P"
            then do:
               find msg_mstr where msg_nbr = 55 and msg_lang = global_user_lang
               no-lock no-error.
               if available msg_mstr
               then
                  put msg_desc at 10 skip.

            end.
            */
            /* ss - 121011.1 -b */
         end. /*for each pswkfl*/

         find ps_mstr where recid(ps_mstr) = record[level] no-lock no-error.

         if level < maxlevel or maxlevel = 0
         then do:
            assign
               comp = bom_code
               level = level + 1.
            find first ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
            no-lock no-error.

         end.

         else do:
            find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
            global_domain and  ps_par = comp
            no-lock no-error.

         end.

         if available sct_det and sct_part = dingbats then delete sct_det.

      end.

      else do:
         find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
         global_domain and  ps_par = comp
         no-lock no-error.

      end.

      
/*GUI*/ {mfguirex.i  "false"} /*Replace mfrpexit*/

   end.

   if newpage then page.
   /*else put skip(1).*/

   
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


 end. /* IF AVAILABLE bom_mstr */

end. /* FOR EACH pt_mstr */

{wbrp04.i}
