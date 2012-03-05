/* bmcsrub.p - BILL OF MATERIAL ROLL-UP FOR RANGE OF ITEMS              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.21 $                                                        */
/*V8:ConvertMode=Report                                                 */
/*             from bmpsru02.p                                          */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: pma *F116*          */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: emb *F345*          */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: pma *F400*          */
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   BY: pma *F542*          */
/* REVISION: 7.0      LAST MODIFIED: 08/17/92   BY: pma *F857*          */
/* REVISION: 7.0      LAST MODIFIED: 09/10/92   BY: pma *F779*          */
/* REVISION: 7.2      LAST MODIFIED: 11/09/92   BY: emb *G294*          */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: emb *G700*          */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: pma *G681*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: ais *GH69*          */
/* REVISION: 7.3      LAST MODIFIED: 10/27/94   BY: ame *FS91*          */
/* REVISION: 7.2      LAST MODIFIED: 11/16/94   BY: ais *FT70*          */
/* REVISION: 8.5      LAST MODIFIED: 11/29/94   BY: pma *J036*          */
/* REVISION: 7.2      LAST MODIFIED: 07/19/95   BY: ais *G0SD*          */
/* REVISION: 7.3      LAST MODIFIED: 11/08/95   BY: bcm *G1CY*          */
/* REVISION: 8.5      LAST MODIFIED: 08/21/95   BY: wep *J054*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: tjs *J0H0*          */
/* REVISION: 8.5      LAST MODIFIED: 01/11/97   BY: *J1F2* Murli Shastri*/
/* REVISION: 8.5      LAST MODIFIED: 11/17/97   BY: *G2QC* evan bishop  */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6      LAST MODIFIED: 09/02/98   BY: *J2YM* Sandesh Mahagaokar */
/* REVISION: 8.6      LAST MODIFIED: 11/12/98   BY: *J34B* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 10/20/99   BY: *K21S* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *L0YY* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18     BY: Rajesh Thomas    DATE: 04/26/01  ECO: *K26M*        */
/* Revision: 1.19     BY: Katie Hilbert    DATE: 02/25/02  ECO: *N194*        */
/* $Revision: 1.21 $    BY: Samir Bavkar          DATE: 04/12/02  ECO: *P000*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! bmcsrub.p IS CALLED BY BMCSRUB01.P                                        *
 *  THIS PROGRAM PERFORMS THE FOLLOWING FOR ITEMS (PT_MSTR) WITHIN THE        *
 *  SELECTION RANGE:                                                          *
 *                                                                            *
 *  1) LOOP THROUGH ALL COMPONENTS FOR CURRENT ITEM                           *
 *  2) IF THE COMPONENT IS A PARENT (HAS A BOM) THEN THE COMPONENT BECOMES    *
 *     THE CURRENT ITEM.  START AGAIN AT 1)                                   *
 *  3) IF THE COMPONENT IS THE LOWEST LEVEL OF A BRANCH IN THE BOM THEN       *
 *     CALCULATE COSTS BASED UPON THE ROUTING/STRUCTURE AND ROLL THEM UP INTO *
 *     THE PARENT ITEM                                                        *
 *  4) IF ALL OF THE CURRENT PARENT'S COMPONENTS HAVE BEEN PROCESSED THEN     *
 *     ROLL THE CURRENT PARENT'S COSTS UP TO THE NEXT LEVEL; IF WE ARE        *
 *     AT THE TOP LEVEL THEN WE ARE DONE WITH THE ITEM AND WE CAN PROCEED     *
 *     TO THE NEXT ITEM IN THE SELECTION RANGE                                *
 *                                                                            *
 *  THIS PROGRAM USES REPEAT LOOPS TO CONTROL PROCESSING.  THERE ARE THREE    *
 *  LEVELS OF REPEAT LOOP IDENTIFIED AS itemloop, comploop AND psloop WHICH   *
 *  REPRESENT THE SELECTION CRITERIA ITEM SELECTION, COMPONENT DRILL DOWN,    *
 *  AND PRODUCT STRUCTURE/ ROUTING DRILL DOWN RESPECTIVELY.                   *
 *                                                                            *
 *  G1CY - Re-aligned program and added many comments                         *
 *                                                                            *
 *  COSTING & LOCAL/GLOBAL PHANTOMS: When calculating yield percentages,      *
 *  routings are ignored for phantoms; that is, the yield will be 100% at the *
 *  phantom component level and will use the parent item's routing and yield  *
 *  at the phantom part level.  Setup & run-time calculations do not          *
 *  accumulate lower level costs for global phantoms, but do for local        *
 *  phantoms.
 *
 * LINKED-SITE COSTING CHANGES:
 *  -IF THE COST SET SPECIFIED IN THE SELECTION IS OF TYPE GL AND STANDARD
 *   METHOD THEN THE GL COST SOURCE SITE (in_gl_cost_site) IS USED TO GET
 *   COST FOR A PARTICULAR ITEM.
 *  -IF THE COST RECORD FOR THE COST SET AND ITEM DOES NOT EXIST AT THE
 *   SOURCE SITE IT WILL NOT BE CREATED AND A ZERO COST VALUE WILL BE USED.
 *  -IF AN SUB-ASSEMBLY(ITEM WITH COMPONENTS) IS LINKED, ITS COST AT THE
 *   SOURCE SITE WILL BE USED TO CALCULATE PARENT's COST AT THE ROLLUP SITE.
 *   THE PROGRAM WILL NOT ROLUP COSTS FOR A LINKED SUB-ASSEMBLY. IT WILL BE
 *   TREATED LIKE THE LAST ITEM IN THE STRUCTURE TREE WITH NO MORE COMPONENTS.
 *  -THE PROGRAM WILL NOT ROLL-UP COST FOR A LINKED END ITEM.
 *
*/


{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable level like pt_ll_code no-undo.
/* VARIABLE ITEM_YIELD IS USED FOR YIELD CALCULATIONS WHICH */
/* IS SET TO ROUTING YIELD IF IT EXISTS ELSE SET TO 100 PERCENT    */
define new shared variable item_yield as decimal no-undo.
define new shared variable w13_flag like mfc_logical.
define new shared variable w30_flag like mfc_logical.
define new shared variable w45_flag like mfc_logical.
define new shared variable w99_flag like mfc_logical.
define new shared variable sptcsttl like spt_cst_tl.
define new shared variable sptcstll like spt_cst_ll.

define variable comp        like ps_comp no-undo.
define variable record      as integer extent 100 no-undo.
define variable ptroute     like pt_routing extent 100 no-undo.
define variable bom_code    like pt_bom_code no-undo.
define variable labor_time  as decimal extent 100 no-undo.
define variable setup_time  as decimal extent 100 no-undo.
define variable low_level   like pt_ll_code no-undo.
define variable max_level   like pt_ll_code no-undo.
define variable parent      like ps_par no-undo.
define variable oldcst      like sct_cst_tot no-undo.
define variable oldmtl_ll   like sct_mtl_tl no-undo.
define variable oldlbr_ll   like sct_lbr_tl no-undo.
define variable oldbdn_ll   like sct_bdn_tl no-undo.
define variable oldovh_ll   like sct_ovh_tl no-undo.
define variable oldsub_ll   like sct_sub_tl no-undo.
define variable m_level     like max_level.
define variable i           as integer.
define variable rolled_yn   as logical.
define variable sctdet_cnt  as integer initial 0 no-undo.
define variable ptmstr_cnt  as integer initial 0 no-undo.
define variable from_part   like sct_part no-undo.
define variable chk_phantom as logical no-undo.
define variable rndmthd     like gl_rnd_mthd no-undo.

define new shared variable l_gl_std like mfc_logical no-undo.
define new shared variable l_linked like mfc_logical no-undo.

define shared variable rollup_id like qad_key3.
define shared variable site like si_site.
define shared variable part like pt_part.
define shared variable part1 like pt_part.
define shared variable line like pt_prod_line.
define shared variable line1 like pt_prod_line.
define shared variable type like pt_part_type.
define shared variable type1 like pt_part_type.
define shared variable grp like pt_group.
define shared variable grp1 like pt_group.
define shared variable eff_date as date initial today.
define shared variable mtl_flag like mfc_logical.
define shared variable lbr_flag like mfc_logical.
define shared variable bdn_flag like mfc_logical.
define shared variable ovh_flag like mfc_logical.
define shared variable sub_flag like mfc_logical.
define shared variable labor_flag like mfc_logical.
define shared variable setup_flag like mfc_logical.
define shared variable csset like sct_sim.
define shared variable audit_yn like mfc_logical.
define shared variable cst_flag like mfc_logical.
define shared variable yield_flag like mfc_logical.

define
   new shared
   workfile sctold
   no-undo
   field oldmtl like sct_mtl_tl
   field oldlbr like sct_lbr_tl
   field oldbdn like sct_bdn_tl
   field oldovh like sct_ovh_tl
   field oldsub like sct_sub_tl.

define buffer ptmstr   for pt_mstr.
define buffer ps_mstr1 for ps_mstr.
define buffer ptpdet   for ptp_det.
define buffer ptmstr1  for pt_mstr.

define new shared frame b.

/************************************************************/
/*PROGRAM NEEDS TO BE DIVIDED DUE TO R-CODE.                */
/*MOVE CALLS TO BMCSRUB2.I & BMCSRUB3. TO .P PROGRAMS.      */
/*THIS WILL REQUIRE WKFL-13, -30, -45, AND -99 TO BE SHARED */
/************************************************************/

define new shared workfile wkfl-13 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 13.

define new shared workfile wkfl-30 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 30.

define new shared workfile wkfl-45 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 45.

define new shared workfile wkfl-99 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 99.

define buffer sctdet for sct_det.
define buffer spt_det-del for spt_det.
define query q_sctdet for sctdet
   fields(sct_site sct_sim sct_part sct_rollup_id sct_rollup).

assign
   glxcst = 0
   curcst = 100000.

form
   pt_part format "x(25)"
   csset no-label
   oldmtl oldlbr oldbdn
   oldovh oldsub oldcst
with frame b width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

for first icc_ctrl no-lock:
end.
for first gl_ctrl fields(gl_rnd_mthd) no-lock:
end.
if available gl_ctrl then rndmthd = gl_rnd_mthd.

/* RECOGNIZE SITE LINKS FOR GL COST WHEN A GL STANDARD COST SET IS SPECIFIED */
/* CHECK IF THE COST SET ENTERED IS OF TYPE GL AND STANDARD METHOD */
l_gl_std = false.

if can-find (first cs_mstr where cs_set = csset
             and cs_type = "GL" and cs_method = "STD") then
   l_gl_std = true.

/*! LOOP THROUGH ALL ITEMS IN SELECTION RANGE */
itemloop:
repeat with frame b width 132 down: /* nest level 1 */

   if sctdet_cnt modulo 10000 = 0 then do:
      if sctdet_cnt > 0 then
         from_part = sctdet.sct_part.
      else
         from_part = part.

      close query q_sctdet.
      if sctdet_cnt > 0 then
         open query q_sctdet
            for each sctdet
               where sctdet.sct_site = site
                 and sctdet.sct_sim = csset
                 and sctdet.sct_part > from_part
                 and sctdet.sct_part <= part1
            no-lock use-index sct_sim_pt_site.
      else /* full range */
         open query q_sctdet
            for each sctdet
               where sctdet.sct_site = site
                 and sctdet.sct_sim = csset
                 and sctdet.sct_part >= from_part
                 and sctdet.sct_part <= part1
         no-lock use-index sct_sim_pt_site.

      get first q_sctdet.
   end.
   else
      get next q_sctdet.

   if not available sctdet then leave itemloop.
   sctdet_cnt = sctdet_cnt + 1.

   for each pt_mstr
         fields(pt_part pt_prod_line pt_part_type pt_group pt_bom_code
                pt_site pt_phantom pt_routing pt_yield_pct pt_um)
         where pt_part = sctdet.sct_part
           and pt_prod_line >= line and pt_prod_line <= line1
           and pt_part_type >= type and pt_part_type <= type1
           and pt_group >= grp and pt_group <= grp1
         no-lock:

      /* IF A GL STANDARD COST-SET IS SPECIFIED AND IF THIS ITEM IS LINKED */
      /* TO ANOTHER SITE FOR COST, DO NOT ROLLUP COST FOR THIS ITEM        */
      if l_gl_std then
         if can-find( first in_mstr
                      where in_part = pt_part
                        and in_site = site
                        and in_site <> in_gl_cost_site) then
            next.

      /*! ROLL UP ALL COSTS FOR THE TOP-LEVEL ITEM */
      rollup_loop: do:

         assign
            parent = pt_part
            comp   = pt_part.

         {bmcssct.i &comp=comp}
         if not rolled_yn then
         parcost: do:

            ptroute[1] = pt_part.

            /*! IDENTIFY THE BOM AND ROUTING */

            /* CALLED PROCEDURE GET-BOMCODE-ROUTING TO GET CORRECT */
            /* BOMCODE AND ROUTING FOR PARENT                      */

            do for ptpdet:

               /* GETTING RECORD FOR PARENT IN BUFFER */

               for first ptpdet
                     fields( ptp_bom_code ptp_part ptp_phantom
                             ptp_pm_code ptp_routing ptp_run
                             ptp_run_ll ptp_setup ptp_setup_ll
                             ptp_site ptp_yld_pct)
                     where ptp_part = parent
                     and   ptp_site = site
                     no-lock:
               end. /*FOR FIRST PTPDET*/

               /* ASSIGN THE ROUTING EVEN IF IT'S A TOP LEVEL PHANTOM */
               chk_phantom = no.

               /* IDENTIFY THE BOM AND ROUTING */

               /* CHANGED SEVENTH PARAMETER comp IN PROCEDURE           */
               /* get-bomcode-routing TO INPUT-OUPUT PARAM. FROM OUTPUT */
               /* PARAMETER AS IT RETURNED BLANK FOR A VALID BOM CODE.  */

               run get-bomcode-routing(
                  input  parent     ,
                  input  site       ,
                  input  chk_phantom,
                  input  eff_date   ,
                  buffer ptpdet     ,
                  buffer pt_mstr    ,
                  input-output comp ,
                  output ptroute[1]).
            end. /*DO FOR PTPDET*/

            assign
               setup_time[1] = 0
               labor_time[1] = 0.

            /*! DELETE WORKFILES */

            for each wkfl-13 exclusive-lock:
               delete wkfl-13.
            end.
            w13_flag = no.

            for each wkfl-30 exclusive-lock:
               delete wkfl-30.
            end.
            w30_flag = no.

            for each wkfl-45 exclusive-lock:
               delete wkfl-45.
            end.
            w45_flag = no.

            for each wkfl-99 exclusive-lock:
               delete wkfl-99.
            end.
            w99_flag = no.

            for each sc_mstr where sc_sim = csset by sc_category:
               if     (mtl_flag or sc_category <> "1")
                  and (lbr_flag or sc_category <> "2")
                  and (bdn_flag or sc_category <> "3")
                  and (ovh_flag or sc_category <> "4")
                  and (sub_flag or sc_category <> "5")
               then do:
                  create wkfl-13.
                  assign
                     element = sc_element
                     cat = integer(sc_category)
                     cst_ll = 0.
               end.
            end. /* for each sc_mstr */
            w13_flag = yes.

            /*! MFG/PRO ONLY LOOKS 99 LEVELS DEEP. WE START AT LEVEL 2  */
            /*  SINCE WE ARE LOOKING FOR COMPONENT COSTS TO ROLL-UP     */
            /*  INTO THE PARENT                                         */

            assign
               max_level   = 99
               level       = 2
               m_level     = 2.

            /*! LOOK FOR A BOM RECORD WHERE THIS ITEM IS THE PARENT */

            for first ps_mstr use-index ps_parcomp where ps_par = comp
                  no-lock:
            end.

            /*! LOOP THROUGH ALL COMPONENTS FOR THE PARENT PART.  THE   */
            /*  FIRST TIME THROUGH WE WILL DROP DOWN TO THE LOWER BLOCK */
            /*  OF CODE TO FIND THE NEXT COMPONENT.  THE UPPER BLOCK OF */
            /*  CODE IS EXECUTED WHEN WE HAVE REACHED THE END OF A      */
            /*  BRANCH IN THE STRUCTURE TREE.                           */

            comploop:
            repeat with frame b: /* nest level 2 */

               /* IF A GL STANDARD COST-SET IS SPECIFIED CHECK  IF THIS ITEM */
               /* IS LINKED FOR COST                                         */
               l_linked = false.

               if l_gl_std then
                  if can-find( first in_mstr
                               where in_part = comp
                                 and in_site = site
                                 and in_site <> in_gl_cost_site) then
                     l_linked = true.

               /*! IF THIS ITEM IS NOT THE PARENT OF ANOTHER OR WE HAVE */
               /*  REACHED THE MAXIMUM LEVEL, THEN PROCESS THE COST     */
               /*  OF THE ITEM.                                         */
               /*! IF THIS IS THE PARENT OF ANOTHER AND IT IS LINKED    */
               /*  FOR COSTS TO ANOTHER SITE THEN PROCESS THE COST,     */
               /*  DO NOT DROP DOWN TO ITS COMPONENTS AS WE WILL NOT    */
               /*  ITS COSTS, INSTEAD THE COST AT THE SOURCE SITE WILL  */
               /*  BE USED.                                             */

               if not available ps_mstr or level > max_level
                  or l_linked then do:

                  /*! DRILL DOWN PRODUCT STRUCTURE */
                  psloop:
                  repeat with frame b: /* nest level 3 */

                     /*! BACK UP TO THE LEVEL INTO WHICH WE ARE ROLLING */
                     /*  THE COSTS                                      */

                     level = level - 1.

                     /*! IF WE ARE AT THE TOP LEVEL THEN WE ARE DONE  */
                     if level < 2 then leave.

                     /*! FIND THE BOM RECORD FOR THE LEVEL INTO WHICH */
                     /*  WE ARE ROLLING THE COSTS                     */

                     for first ps_mstr where
                        recid(ps_mstr) = record[level] no-lock:
                     end.

                     l_linked = false.

                     if available ps_mstr then do:
                        if l_gl_std then
                           for first in_mstr no-lock
                           where in_part = ps_comp
                           and in_site = site:
                           end. /* FOR FIRST IN_MSTR */

                        if available in_mstr and
                           (in_gl_cost_site <> in_site) then do:
                           l_linked = true.

                           /*! CALCULATE YIELD PERCENTAGES */
                           run calculate-yield-percentage(
                                  input-output item_yield,
                                  input        yield_flag,
                                  input        ptroute[level - 1],
                                  input        eff_date,
                                  input        ps_op).

                           for first ptp_det no-lock where
                              ptp_part = ps_comp
                              and ptp_site = site:
                           end.

                           for first ptmstr
                           fields (pt_bom_code pt_group pt_part pt_part_type
                               pt_phantom pt_pm_code pt_prod_line pt_routing
                               pt_run pt_run_ll pt_setup pt_setup_ll
                               pt_yield_pct pt_site pt_um pt_desc1 pt_desc2)
                           no-lock where ptmstr.pt_part = ps_comp:
                           end.

                           if w99_flag then do for wkfl-99:
                              {gprun.i ""bmcsrub6.p""
                                 "(buffer ps_mstr,
                                   buffer ptmstr ,
                                   buffer ptp_det,
                                   input in_part,
                                   input in_gl_cost_site,
                                   input level,
                                   input ""99"")"}
                           end.

                           else
                              if w45_flag then do for wkfl-45:
                                 {gprun.i ""bmcsrub6.p""
                                    "(buffer ps_mstr,
                                      buffer ptmstr ,
                                      buffer ptp_det,
                                      input in_part,
                                      input in_gl_cost_site,
                                      input level,
                                      input ""45"")"}
                              end.

                           else
                              if w30_flag then do for wkfl-30:
                                 {gprun.i ""bmcsrub6.p""
                                    "(buffer ps_mstr,
                                      buffer ptmstr ,
                                      buffer ptp_det,
                                      input in_part,
                                      input in_gl_cost_site,
                                      input level,
                                      input ""30"")"}
                              end.

                           else
                           do:
                              {gprun.i ""bmcsrub6.p""
                                 "(buffer ps_mstr,
                                   buffer ptmstr ,
                                   buffer ptp_det,
                                   input in_part,
                                   input in_gl_cost_site,
                                   input level,
                                   input ""13"")"}
                           end.
                        end. /* IF AVAIL IN_MSTR AND GL_COST_SITE <> IN_SITE */
                     end. /* IF AVAILABLE PS_MSTR  */

                     if available ps_mstr and (not l_linked) then do:

                        /*! CALCULATE YIELD PERCENTAGES */
                        run calculate-yield-percentage(
                               input-output item_yield,
                               input        yield_flag,
                               input        ptroute[level - 1],
                               input        eff_date,
                               input        ps_op).

                        /*! IF CALCULATING SETUP OR LABOR TIMES         */
                        /*  FIND THE COMPONENT'S PLANNING DATA          */

                        if setup_flag or labor_flag then
                           find ptp_det exclusive-lock
                           where ptp_part = ps_comp
                           and ptp_site = site no-error.
                        else
                           for first ptp_det no-lock where
                              ptp_part = ps_comp
                              and ptp_site = site:
                           end.

                        if available ptp_det
                           or (setup_flag = no and labor_flag = no)
                        then
                           for first ptmstr
                              fields (pt_bom_code pt_group pt_part pt_part_type
                                  pt_phantom pt_pm_code pt_prod_line pt_routing
                                  pt_run pt_run_ll pt_setup pt_setup_ll
                                  pt_yield_pct pt_site pt_um pt_desc1 pt_desc2)
                              no-lock where ptmstr.pt_part = ps_comp:
                           end.
                        else
                           find ptmstr exclusive-lock
                           where ptmstr.pt_part = ps_comp no-error.
                        /* DECIDE IF ps_comp HAS ALREADY HAD ITS COSTS */
                        /* ROLLED UP FOR THIS SITE AND COST SET.       */

                        {bmcssct.i &comp=ps_comp}

                        /*! IF THE COMPONENT IS AN ITEM AND WE HAVEN'T  */
                        /*  ROLLED UP THE COSTS ALREADY, THEN FIND THE  */
                        /*  ITEM'S COST.                                */

                        if available ptmstr
                           and not rolled_yn
                        then do:

                           {gpsct08.i &part=ptmstr.pt_part &set=csset
                                      &site=site}
                           oldcst = sct_cst_tot.

                           for each sctold exclusive-lock:
                              delete sctold.
                           end.

                           create sctold.
                           assign
                              oldmtl = sct_mtl_ll
                              oldlbr = sct_lbr_ll
                              oldbdn = sct_bdn_ll
                              oldovh = sct_ovh_ll
                              oldsub = sct_sub_ll.

                           /*! CALCULATE SETUP TIME */
                           if setup_flag then do:
                              if available ptp_det then do:
                                 ptp_setup_ll = setup_time[level].
                                 if  ps_ps_code <> "O"
                                 and ptp_pm_code <> "P" and
                                     ptp_pm_code <> "D"
                                 then
                                    setup_time[level - 1] =
                                    setup_time[level - 1]
                                  + ptp_setup_ll + if not ptp_phantom
                                    then ptp_setup else 0.
                              end. /* if available ptp_det */
                              else do:

                                 ptmstr.pt_setup_ll = setup_time[level].

                                 if  ps_ps_code <> "O"
                                 and ptmstr.pt_pm_code <> "P" and
                                     ptmstr.pt_pm_code <> "D"
                                 then
                                    setup_time[level - 1] =
                                    setup_time[level - 1]
                                  + ptmstr.pt_setup_ll +
                                 if not ptmstr.pt_phantom then
                                    ptmstr.pt_setup else 0.
                              end. /* else do */
                              setup_time[level] = 0.
                           end. /* if setup_flag */

                           /*! CALCULATE LABOR TIME */
                           if labor_flag then do:
                              if available ptp_det then do:
                                 ptp_run_ll = labor_time[level].
                                 if  ps_ps_code <> "O"
                                 and ptp_pm_code <> "P" and
                                     ptp_pm_code <> "D"
                                 then
                                    labor_time[level - 1] =
                                    labor_time[level - 1] +
                                    (ptp_run_ll
                                  + if not ptp_phantom then
                                    ptp_run else 0) * ps_qty_per.
                              end. /* if available ptp_det */
                              else do:

                                 ptmstr.pt_run_ll = labor_time[level].

                                 if  ps_ps_code <> "O"
                                 and ptmstr.pt_pm_code <> "P" and
                                     ptmstr.pt_pm_code <> "D"
                                 then
                                    labor_time[level - 1] =
                                    labor_time[level - 1] +
                                    (ptmstr.pt_run_ll
                                  + if not ptmstr.pt_phantom then
                                    ptmstr.pt_run else 0) * ps_qty_per.
                              end. /* else do */
                              labor_time[level] = 0.
                           end. /* if labor_flag */

                           /* CONVERTED THE FOLLOWING .I CALLS TO .P CALLS */
                           if w99_flag then do for wkfl-99:

                              {gprun.i ""bmcsruc.p""
                                 "(buffer sct_det,
                                   buffer ps_mstr,
                                   buffer ptmstr ,
                                   buffer ptp_det,
                                   input level,
                                   input ""99"",
                                   input ""2"")"}
                           end.

                           else if w45_flag then do for wkfl-45:

                              {gprun.i ""bmcsruc.p""
                                 "(buffer sct_det,
                                   buffer ps_mstr,
                                   buffer ptmstr ,
                                   buffer ptp_det,
                                   input level,
                                   input ""45"",
                                   input ""2"")"}
                           end.

                           else if w30_flag then do for wkfl-30:

                              {gprun.i ""bmcsruc.p""
                                 "(buffer sct_det,
                                   buffer ps_mstr,
                                   buffer ptmstr ,
                                   buffer ptp_det,
                                   input level,
                                   input ""30"",
                                   input ""2"")"}
                           end.

                           else do:

                              {gprun.i ""bmcsruc.p""
                                 "(buffer sct_det,
                                   buffer ps_mstr,
                                   buffer ptmstr ,
                                   buffer ptp_det,
                                   input level,
                                   input ""13"",
                                   input ""2"")"}
                           end.

                           sct_rollup_id = rollup_id.

                           assign
                              oldmtl_ll = oldmtl
                              oldlbr_ll = oldlbr
                              oldbdn_ll = oldbdn
                              oldovh_ll = oldovh
                              oldsub_ll = oldsub.

                           assign
                              oldmtl = oldmtl + sct_mtl_tl
                              oldlbr = oldlbr + sct_lbr_tl
                              oldbdn = oldbdn + sct_bdn_tl
                              oldovh = oldovh + sct_ovh_tl
                              oldsub = oldsub + sct_sub_tl.

                           do for ps_mstr1:
                              assign
                                 sct_mtl_ll = 0
                                 sct_lbr_ll = 0
                                 sct_bdn_ll = 0
                                 sct_ovh_ll = 0
                                 sct_sub_ll = 0.

                              bom_code = if available ptp_det then ptp_bom_code
                                         else ptmstr.pt_bom_code.

                              for  first ps_mstr1
                                 where ps_mstr1.ps_par = ptmstr.pt_part
                                   and ps_mstr1.ps_comp = bom_code
                                   and ps_mstr1.ps_joint_type = "1"
                                   and (eff_date = ?
                                    or (eff_date <> ?
                                   and (ps_mstr1.ps_start = ? or
                                        ps_mstr1.ps_start <= eff_date)
                                   and (ps_mstr1.ps_end = ? or
                                        eff_date <= ps_mstr1.ps_end)))
                                 no-lock: end.

                              if available ps_mstr1 then
                                 assign
                                    sct_mtl_tl = 0
                                    sct_lbr_tl = 0
                                    sct_bdn_tl = 0
                                    sct_ovh_tl = 0
                                    sct_sub_tl = 0.

                              /*! INTERPRET COST ELEMENT TYPE FOR spd_det  */
                              /*  AND ADD THE COST TO THE APPROPRIATE      */
                              /*  FIELD IN sct_det.                        */

                              for each spt_det
                                 fields(spt_site spt_sim spt_part spt_ao
                                        spt_cst_tl spt_cst_ll spt_pct_ll)
                              no-lock
                                 where spt_site = sct_site
                                   and spt_sim = sct_sim
                                   and spt_part = sct_part:
                                 if (not spt_ao and spt_cst_tl = 0
                                     and spt_cst_ll = 0
                                     and spt_pct_ll <> truncate(spt_pct_ll,0))
                                 then do for spt_det-del:
                                    /* USE A BUFFER */
                                    find spt_det-del where
                                       recid(spt_det-del) = recid(spt_det)
                                    exclusive-lock no-error.

                                    if available(spt_det-del) then
                                       delete spt_det-del.

                                    next.
                                 end.

                                 else
                                 if truncate(spt_pct_ll,0) = 1 then
                                    sct_mtl_ll = sct_mtl_ll + spt_cst_ll.
                                 else
                                 if truncate(spt_pct_ll,0) = 2 then
                                    sct_lbr_ll = sct_lbr_ll + spt_cst_ll.
                                 else
                                 if truncate(spt_pct_ll,0) = 3 then
                                    sct_bdn_ll = sct_bdn_ll + spt_cst_ll.
                                 else
                                 if truncate(spt_pct_ll,0) = 4 then
                                    sct_ovh_ll = sct_ovh_ll + spt_cst_ll.
                                 else
                                 if truncate(spt_pct_ll,0) = 5 then
                                    sct_sub_ll = sct_sub_ll + spt_cst_ll.

                                 if available ps_mstr1 then do:
                                    if truncate(spt_pct_ll,0) = 1
                                    then
                                       sct_mtl_tl = sct_mtl_tl + spt_cst_tl.
                                    else if truncate(spt_pct_ll,0) = 2
                                    then
                                       sct_lbr_tl = sct_lbr_tl + spt_cst_tl.
                                    else if truncate(spt_pct_ll,0) = 3
                                    then
                                       sct_bdn_tl = sct_bdn_tl + spt_cst_tl.
                                    else if truncate(spt_pct_ll,0) = 4
                                    then
                                       sct_ovh_tl = sct_ovh_tl + spt_cst_tl.
                                    else if truncate(spt_pct_ll,0) = 5
                                    then
                                       sct_sub_tl = sct_sub_tl + spt_cst_tl.
                                 end.

                              end.  /* for each spd_det */
                           end. /*do for ps_mstr1*/

                           /*! UPDATE TOTAL IF ANY ELEMENT AMOUNT HAS   */
                           /*  CHANGED.                                 */

                           if ((oldmtl_ll <> sct_mtl_ll)
                            or (oldlbr_ll <> sct_lbr_ll)
                            or (oldbdn_ll <> sct_bdn_ll)
                            or (oldovh_ll <> sct_ovh_ll)
                            or (oldsub_ll <> sct_sub_ll))
                            or (cst_flag)
                           then
                              assign
                                 sct_cst_tot = sct_mtl_tl + sct_lbr_tl
                                             + sct_bdn_tl + sct_ovh_tl
                                             + sct_sub_tl + sct_mtl_ll
                                             + sct_lbr_ll + sct_bdn_ll
                                             + sct_ovh_ll + sct_sub_ll
                                 sct_cst_date = today.

                           /*! IF THE COST HAS CHANGED THEN REPORT THE  */
                           /*  ITEM AND CREATE ANY NECESSARY G/L        */
                           /*  TRANSACTIONS.                            */

                           if sct_cst_tot <> oldcst then do:

                              for first in_mstr no-lock
                                  where in_part = ptmstr.pt_part
                                    and in_site = site:
                              end.

                              if available in_mstr
                              and (in_gl_set = sct_sim
                               or (sct_sim = icc_gl_set
                                   and in_mstr.in_gl_set = ""))
                              then do:

                                 /*DE-COUPLE PROGRAMS FOR OBJECTS*/
                                 {gprun.i 'iccstinv.p'
                                    "(input oldcst,
                                      buffer sct_det,
                                      input 'CCHG',
                                      input in_site,
                                      input icc_cogs,
                                      input icc_gl_sum,
                                      input icc_gl_tran,
                                      input icc_mirror,
                                      input icc_jrnl,
                                      input rndmthd,
                                      input pt_part,
                                      input pt_prod_line,
                                      input pt_site,
                                      input pt_um)" }
                              end.  /* if available in_mstr */

                              if audit_yn then do with frame b
                                 width 132 down:

                                 {gprun.i ""bmcsrub1.p""
                                             "(buffer ptmstr,
                                               buffer sct_det,
                                               input oldcst)" }
                              end.  /* if audit_yn */
                           end.  /* if sct_cst_tot <> oldcst */
                        end.  /* if available pt_mstr and not rolled_yn */

                        /*! IF WE ARE DEALING WITH A BOM THAT HAS NO    */
                        /*  CORRESPONDING ITEM MASTER RECORD, TRACK     */
                        /*  COSTS LOCALLY.                              */

                        else do:

                           /* TRACK THE SETUP TIME FOR VALID ITEMS */
                           /* ALREADY ROLLED UP.                   */

                           if setup_flag then do:
                              if available ptp_det then do:
                                 setup_time[level] = 0.
                                 if ps_ps_code <> "O"
                                 and ptp_pm_code <> "P"
                                 and ptp_pm_code <> "D"
                                 then
                                    setup_time[level] = ptp_setup_ll
                                                + if not ptp_phantom
                                                then ptp_setup else 0.
                              end. /* if available ptp_det */

                              else if available ptmstr then do:
                                 setup_time[level] = 0.
                                 if ps_ps_code <> "O"
                                 and ptmstr.pt_pm_code <> "P"
                                 and ptmstr.pt_pm_code <> "D"
                                 then
                                   setup_time[level] = ptmstr.pt_setup_ll
                                                + if not ptmstr.pt_phantom
                                                then ptmstr.pt_setup else 0.
                              end. /* else available pt_mstr */
                           end. /* if setup_flag */

                           /* TRACK THE LABOR TIME FOR VALID ITEMS      */
                           /* ALREADY ROLLED UP.  NOTE THAT THE PRODUCT */
                           /* STRUCTURE QUANTITY WILL BE USED DOWN BELOW*/
                           /* THIS BLOCK WHEN IT GETS ROLLED INTO THE   */
                           /* NEXT LEVEL OF THE ARRAY (INSTEAD OF HERE).*/

                           if labor_flag then do:
                              if available ptp_det then do:
                                 labor_time[level] = 0.
                                 if ps_ps_code <> "O"
                                 and ptp_pm_code <> "P"
                                 and ptp_pm_code <> "D"
                                 then
                                    labor_time[level] = ptp_run_ll
                                                + if not ptp_phantom
                                                then ptp_run else 0.
                              end. /* if available ptp_det */

                              else if available ptmstr then do:
                                 labor_time[level] = 0.
                                 if ps_ps_code <> "O"
                                 and ptmstr.pt_pm_code <> "P"
                                 and ptmstr.pt_pm_code <> "D"
                                 then
                                    labor_time[level] = ptmstr.pt_run_ll
                                                + if not ptmstr.pt_phantom
                                                then ptmstr.pt_run else 0.
                              end. /* else available pt_mstr */
                           end. /* if labor_flag */

                           /* Push this level setup and labor time
                              into the higher level. */
                           if ps_ps_code <> "O" then
                              assign
                                 setup_time[level - 1] = setup_time[level - 1]
                                                       + setup_time[level]
                                 labor_time[level - 1] = labor_time[level - 1]
                                                       + labor_time[level]
                                                       * ps_qty_per.

                           {gprun.i ""bmcsrub5.p""
                              "(buffer ptmstr,
                                buffer ps_mstr)"}

                           assign
                              setup_time[level] = 0
                              labor_time[level] = 0.

                        end.  /* else do */

                     end. /*if avail ps_mstr and not l_linked */

                     l_linked = false.

                     rolled_yn = no.
                     comp = ps_par.

                     find next ps_mstr use-index ps_parcomp
                     where ps_par = comp no-lock no-error.

                     if available ps_mstr then leave.
                  end. /*psloop: repeat with frame b*/ /* nest level 3 */
               end. /* if not available ps_mstr */

               l_linked = false.

               /*! IF WE ARE DONE WITH THIS ITEM, THEN LEAVE */
               if level < 2 then leave.

               /*! BLOW THROUGH PRODUCT STRUCTURE TO NEXT LEVEL. IF     */
               /*  EFFECTIVE DATE HAS BEEN CHANGED TO ?, INCLUDE ALL    */
               /*  COMPONENTS, REGARDLESS OF DATE RANGES.               */

               if  (eff_date = ? or (eff_date <> ?
                    and (ps_start = ? or ps_start <= eff_date)
                    and (ps_end = ? or eff_date <= ps_end)))
               and (ps_ps_code = "" or ps_ps_code = "X"
                    or ps_ps_code = "O")
               then do:

                  record[level] = recid(ps_mstr).

                  if level < max_level or max_level = 0 then do:
                     comp = ps_comp.

                     /* CALLED PROCEDURE GET-BOMCODE-ROUTING TO GET CORRECT */
                     /* BOMCODE AND ROUTING FOR COMPONENT                   */

                     do for ptpdet:

                       /* GET RECORD FROM PTPDET IN BUFFER FOR COMPONENT */
                       /* IF RECORD NOT AVAILABLE IN PTPDET THEN BUFFER  */
                       /* FOR PTMSTR WILL BE RETURNED                    */

                        run get-buffer( input  comp     ,
                                        input  site     ,
                                        buffer ptmstr1  ,
                                        buffer ptpdet ) .

                        /* IGNORE ROUTINGS FOR GLOBAL PHANTOMS */

                        chk_phantom =  yes .

                        /* IDENTIFY THE BOM AND ROUTING */

                        run get-bomcode-routing( input  comp       ,
                                                 input  site       ,
                                                 input  chk_phantom,
                                                 input  eff_date   ,
                                                 buffer ptpdet     ,
                                                 buffer ptmstr1    ,
                                                 input-output comp ,
                                                 output ptroute[level]).
                     end. /*DO FOR PTPDET*/

                     /*! IGNORE ROUTINGS FOR LOCAL PHANTOMS */
                     if ps_ps_code = "x" then ptroute[level] = "".

                     assign
                        level = level + 1
                        m_level = max(m_level, level).

                     /*! WHEN LEVEL > 12 SWITCH FROM WKFL-13 TO WKFL-30 */
                     if (m_level > 12 and m_level <= 29)
                         and w13_flag
                         and not w30_flag
                         and not w45_flag
                         and not w99_flag
                     then do:

                        for each wkfl-13 exclusive-lock:
                           create wkfl-30.
                           assign
                              wkfl-30.element = wkfl-13.element
                              wkfl-30.cat     = wkfl-13.cat.
                           do i = 1 to 13:
                              wkfl-30.cst_ll[i]  = wkfl-13.cst_ll[i].
                           end.
                           delete wkfl-13.
                        end. /* for each wkfl-13 */
                        w30_flag = yes.
                     end. /* if m_level > 12 */

                     /*! WHEN LEVEL > 29 SWITCH FROM WKFL-30 TO WKFL-45 */
                     else
                     if (m_level > 29 and m_level <= 45)
                         and w30_flag
                         and not w45_flag
                         and not w99_flag
                     then do:

                        for each wkfl-30 exclusive-lock:
                           create wkfl-45.
                           assign
                              wkfl-45.element = wkfl-30.element
                              wkfl-45.cat     = wkfl-30.cat.
                           do i = 1 to 30:
                              wkfl-45.cst_ll[i]  = wkfl-30.cst_ll[i].
                           end.
                           delete wkfl-30.
                        end. /* for eack wkfl-30 */
                        w45_flag = yes.
                     end. /* else if m_level > 29 */

                     /*WHEN LEVEL > 44 SWITCH FROM WKFL-45 TO WKFL-99*/
                     else
                     if (m_level > 44)
                         and w45_flag
                         and not w99_flag
                     then do:

                        for each wkfl-45 exclusive-lock:
                           create wkfl-99.
                           assign
                              wkfl-99.element = wkfl-45.element
                              wkfl-99.cat     = wkfl-45.cat.
                           do i = 1 to 45:
                              wkfl-99.cst_ll[i]  = wkfl-45.cst_ll[i].
                           end.
                           delete wkfl-45.
                        end. /* for each wkfl-45 */
                        w99_flag = yes.
                     end. /* else if m_level > 44 */

                     /*! IF THE COMPONENT HAS ALREADY BEEN ROLLED UP, */
                     /*! GUARANTEE THAT                               */
                     /*! A PS_MSTR RECORD IS NOT AVAILABLE            */

                     /* DECIDE IF ps_comp HAS ALREADY HAD ITS COSTS    */
                     /* ROLLED UP FOR THIS SITE AND COST SET. NOTE THAT*/
                     /* IT IS THE COMPONENT ITEM NUMBER THAT IS CHECKED*/
                     /* INSTEAD OF ITS BOM CODE.  IF WE NEED TO BLOW   */
                     /* DOWN THROUGH A COMPONENT, ITS BOM CODE IS USED,*/
                     /* BUT HAVING CALCULATED THE COST OF THE BOM CODE */
                     /* DOES NOT AUTOMATICALLY UPDATE THE COST OF THE  */
                     /* COMPONENT.                                     */

                     {bmcssct.i &comp=ps_comp}

                     if rolled_yn
                     then
                        release ps_mstr.
                     else
                        find first ps_mstr use-index ps_parcomp
                           where ps_par = comp no-lock no-error.
                  end. /* if level < max_level */
                  else
                     find next ps_mstr use-index ps_parcomp
                        where ps_par = comp no-lock no-error.

               end. /* if eff_date = ? */

               else
                  find next ps_mstr use-index ps_parcomp
                     where ps_par = comp no-lock no-error.

            end. /* comploop: repeat with frame b */ /* nest level 2 */

            /*! ROLL UP SETUP AND LABOR TIMES */
            if (setup_flag or labor_flag)
            and not can-find (ptp_det where ptp_part = parent
            and ptp_site = site)
            then
               find ptmstr exclusive-lock where ptmstr.pt_part = parent
               no-error.

            else
               for first ptmstr
                  fields (pt_bom_code pt_group pt_part pt_part_type
                          pt_phantom pt_pm_code pt_prod_line pt_routing
                          pt_run pt_run_ll pt_setup pt_setup_ll pt_yield_pct
                          pt_site pt_um pt_desc1 pt_desc2)
                  no-lock where ptmstr.pt_part = parent:
               end.

            if available ptmstr then do:

               if (setup_flag or labor_flag) then
                  for first ptp_det exclusive-lock where
                     ptp_part = ptmstr.pt_part
                     and ptp_site = site:
                  end.
               else
                  for first ptp_det no-lock
                     where ptp_part = ptmstr.pt_part
                     and ptp_site = site:
                  end.

               {gpsct08.i &part=ptmstr.pt_part &set=csset &site=site}

               oldcst = sct_cst_tot.

               for each sctold exclusive-lock:
                  delete sctold.
               end.

               create sctold.
               assign
                  oldmtl = sct_mtl_ll
                  oldlbr = sct_lbr_ll
                  oldbdn = sct_bdn_ll
                  oldovh = sct_ovh_ll
                  oldsub = sct_sub_ll.

               if available ptp_det then do:
                  if setup_flag then ptp_setup_ll = setup_time[1].
                  if labor_flag then ptp_run_ll = labor_time[1].
               end.
               else do:
                  if setup_flag then ptmstr.pt_setup_ll = setup_time[1].
                  if labor_flag then ptmstr.pt_run_ll   = labor_time[1].
               end.

               if sct_rollup_id = rollup_id or sct_rollup then
                  leave parcost.

                if w99_flag then do for wkfl-99:

                   {gprun.i ""bmcsruc.p""
                        "(buffer sct_det,
                          buffer ps_mstr,
                          buffer ptmstr,
                          buffer ptp_det,
                          input level,
                          input ""99"",
                          input ""3"")"}
                end.

                else if w45_flag then do for wkfl-45:

                   {gprun.i ""bmcsruc.p""
                        "(buffer sct_det,
                          buffer ps_mstr,
                          buffer ptmstr,
                          buffer ptp_det,
                          input level,
                          input ""45"",
                          input ""3"")"}
                end.

                else if w30_flag then do for wkfl-30:

                   {gprun.i ""bmcsruc.p""
                        "(buffer sct_det,
                          buffer ps_mstr,
                          buffer ptmstr,
                          buffer ptp_det,
                          input level,
                          input ""30"",
                          input ""3"")"}
                end.

                else do:

                   {gprun.i ""bmcsruc.p""
                        "(buffer sct_det,
                          buffer ps_mstr,
                          buffer ptmstr,
                          buffer ptp_det,
                          input level,
                          input ""13"",
                          input ""3"")"}
                end.

                assign
                   oldmtl_ll = oldmtl
                   oldlbr_ll = oldlbr
                   oldbdn_ll = oldbdn
                   oldovh_ll = oldovh
                   oldsub_ll = oldsub.

                assign
                   oldmtl = oldmtl + sct_mtl_tl
                   oldlbr = oldlbr + sct_lbr_tl
                   oldbdn = oldbdn + sct_bdn_tl
                   oldovh = oldovh + sct_ovh_tl
                   oldsub = oldsub + sct_sub_tl.

                /* UPDATE THIS LEVEL COSTS ON CO-PRODUCTS */
                bom_code = if available ptp_det then
                              ptp_bom_code
                           else ptmstr.pt_bom_code.

                for first ps_mstr where ps_par = ptmstr.pt_part
                                    and ps_comp = bom_code
                                    and ps_joint_type = "1"
                                    and (eff_date = ? or (eff_date <> ?
                                    and (ps_start = ? or ps_start <= eff_date)
                                    and (ps_end = ? or eff_date <= ps_end)))
                no-lock:
                end.

                assign
                   sct_mtl_ll = 0
                   sct_lbr_ll = 0
                   sct_bdn_ll = 0
                   sct_ovh_ll = 0
                   sct_sub_ll = 0.

                if available ps_mstr then
                   assign
                      sct_mtl_tl = 0
                      sct_lbr_tl = 0
                      sct_bdn_tl = 0
                      sct_ovh_tl = 0
                      sct_sub_tl = 0.

                for each spt_det
                   fields(spt_site spt_sim spt_part spt_ao
                          spt_cst_tl spt_cst_ll spt_pct_ll)
                   no-lock
                     where spt_site = sct_site
                       and spt_sim = sct_sim
                       and spt_part = sct_part:

                   if (not spt_ao and spt_cst_tl = 0 and spt_cst_ll = 0
                       and spt_pct_ll <> truncate(spt_pct_ll,0))
                   then do for spt_det-del:
                       /* USE A BUFFER */
                      find spt_det-del where
                         recid(spt_det-del) = recid(spt_det)
                      exclusive-lock no-error.

                      if available(spt_det-del) then
                         delete spt_det-del.

                      next.
                   end.

                   else
                   if truncate(spt_pct_ll,0) = 1
                      then sct_mtl_ll = sct_mtl_ll + spt_cst_ll.
                   else
                   if truncate(spt_pct_ll,0) = 2
                      then sct_lbr_ll = sct_lbr_ll + spt_cst_ll.
                   else
                   if truncate(spt_pct_ll,0) = 3
                      then sct_bdn_ll = sct_bdn_ll + spt_cst_ll.
                   else
                   if truncate(spt_pct_ll,0) = 4
                      then sct_ovh_ll = sct_ovh_ll + spt_cst_ll.
                   else
                   if truncate(spt_pct_ll,0) = 5
                      then sct_sub_ll = sct_sub_ll + spt_cst_ll.

                   if available ps_mstr then do:
                      if truncate(spt_pct_ll,0) = 1
                      then
                         sct_mtl_tl = sct_mtl_tl + spt_cst_tl.
                      else if truncate(spt_pct_ll,0) = 2
                      then
                         sct_lbr_tl = sct_lbr_tl + spt_cst_tl.
                      else if truncate(spt_pct_ll,0) = 3
                      then
                         sct_bdn_tl = sct_bdn_tl + spt_cst_tl.
                      else if truncate(spt_pct_ll,0) = 4
                      then
                         sct_ovh_tl = sct_ovh_tl + spt_cst_tl.
                      else if truncate(spt_pct_ll,0) = 5
                      then
                         sct_sub_tl = sct_sub_tl + spt_cst_tl.
                   end.
                end.

                if ((oldmtl_ll <> sct_mtl_ll)
                 or (oldlbr_ll <> sct_lbr_ll)
                 or (oldbdn_ll <> sct_bdn_ll)
                 or (oldovh_ll <> sct_ovh_ll)
                 or (oldsub_ll <> sct_sub_ll))
                 or (cst_flag) then
                assign
                   sct_cst_tot = sct_mtl_tl + sct_lbr_tl
                               + sct_bdn_tl + sct_ovh_tl
                               + sct_sub_tl + sct_mtl_ll
                               + sct_lbr_ll + sct_bdn_ll
                               + sct_ovh_ll + sct_sub_ll
                   sct_cst_date = today.

                /*! IF THE COST HAS CHANGED THEN REPORT THE ITEM AND */
                /*  CREATE ANY NECESSARY G/L TRANSACTIONS.           */

                if sct_cst_tot <> oldcst then do:

                   for first in_mstr no-lock
                      where in_part = ptmstr.pt_part
                        and in_site = site:
                   end.

                   if available in_mstr and (in_mstr.in_gl_set = sct_sim or
                      (sct_sim = icc_gl_set and in_mstr.in_gl_set = ""))
                   then do:

                      /* DE-COUPLE PROGRAMS FOR OBJECTS */
                      {gprun.i 'iccstinv.p'
                         "(input oldcst,
                           buffer sct_det,
                           input 'CCHG',
                           input in_site,
                           input icc_cogs,
                           input icc_gl_sum,
                           input icc_gl_tran,
                           input icc_mirror,
                           input icc_jrnl,
                           input rndmthd,
                           input ptmstr.pt_part,
                           input ptmstr.pt_prod_line,
                           input ptmstr.pt_site,
                           input ptmstr.pt_um)" }
                   end.

                   if audit_yn then do with frame b width 132 down:

                      {gprun.i ""bmcsrub1.p"" "(buffer ptmstr,
                                                buffer sct_det,
                                                input oldcst)" }
                   end.  /*if audit_yn*/
                end.  /*if sct_cst_tot <> oldcst*/
             end.  /*if available pt_mstr*/
          end. /*parcost*/
       end.  /*rollup_loop*/

   /*! FIND NEXT ITEM MATCHING SELECTION CRITERIA */

   end. /* for each pt_mstr */
end. /* itemloop: repeat with frame b */

/* BEGIN PROCEDURE get-buffer */

/* PURPOSE :                                               */
/* TO RETURN BUFFERS FOR PTPDET/PTMSTR FOR ITEM.           */

/* INPUT PARAMETERS :                                      */
/* 1. ITEM - TO FIND IN BUFFER OF PTPDET/PTMSTR            */
/* 2. SITE - ITEM SPECIFIC                                 */

/* OUTPUT PARAMETERS :                                     */
/* 1. BUFFER PTPDET  - BUFFER OF PTP_DET FOR ITEM AT SITE  */
/* 2. BUFFER PTMSTR1 - BUFFER OF PT_MSTR FOR ITEM          */

/* LOGIC :                                                 */
/* THIS PROCEDURE SEARCHES IN BUFFER OF PTPDET WITH BOTH   */
/* INPUT PARAMETERS. IF PTPDET RECORD IS UNAVAILABLE THEN  */
/* IT SEARCHES IN BUFFER OF PTMSTR FOR ITEM. AFTER SEARCHING*/
/* PROCEDURE RETURNS BOTH BUFFERS FOR PTPDET AND PTMSTR .  */

PROCEDURE get-buffer:

   define input parameter item like  pt_part no-undo .
   define input parameter site like  pt_site no-undo .

   define parameter buffer ptmstr1 for pt_mstr .
   define parameter buffer ptpdet  for ptp_det .

   for first ptpdet
      fields( ptp_bom_code ptp_part ptp_phantom
              ptp_pm_code ptp_routing ptp_run
              ptp_run_ll ptp_setup ptp_setup_ll
              ptp_site ptp_yld_pct)
      where ptpdet.ptp_part = item
      and   ptpdet.ptp_site = site
      no-lock:
   end. /*FOR FIRST PTPDET*/
   if not available ptpdet then do:
      for first ptmstr1
         fields( pt_bom_code pt_group pt_part
                 pt_part_type pt_phantom pt_pm_code
                 pt_prod_line pt_routing pt_run
                 pt_run_ll pt_setup pt_setup_ll
                 pt_site pt_yield_pct pt_um)
         where ptmstr1.pt_part =  item
         no-lock:
      end. /*FOR FIRST PTMSTR1*/
   end. /*IF NOT AVAILABLE PTPDET*/
   return.
END PROCEDURE.

/* BEGIN PROCEDURE is-coproduct  */

/* PURPOSE :                                                */
/* TO DECIDE WHETHER GIVEN ITEM IS A CO-PRODUCT ITEM        */

/* INPUT PARAMETERS :                                       */
/* 1. ITEM1 - TO FIND  WHETHER THIS IS CO-PRODUCT ITEM      */
/* 2. SITE1 - ITEM SPECIFIC                                 */
/* 3. EFFDATE1 - USE TO CHECK IN PS_MSTR                    */

/* OUTPUT PARAMETERS :                                      */
/* 1. BUFFER PTPDET - BUFFER OF PTP_DET FOR ITEM AT SITE    */

/* LOGIC :                                                  */
/* THIS PROCEDURE SEARCHES ON PS_MSTR USING INPUT PARAMETERS*/
/* AND CHECKS WHETHER ITEM IS A COPRODUCT ITEM. IF ITEM FOUND */
/* TO BE A COPRODUCT ITEM THEN A FLAG COFLAG1 IS SET TO YES */
/* AND IS RETURNED BACK TO THE CALLING ROUTINE.             */

PROCEDURE is-coproduct:

   define input  parameter item1    like pt_part            no-undo .
   define input  parameter bomcode1 like pt_bom_code        no-undo .
   define input  parameter effdate1 as   date               no-undo .
   define output parameter coflag1  as   logical initial no no-undo .

   define buffer ps_mstr1 for ps_mstr.

   for first ps_mstr1
      fields( ps_comp  ps_end  ps_joint_type
              ps_op ps_par ps_ps_code
              ps_qty_per ps_start ps_scrp_pct)
      where ps_mstr1.ps_par   = item1
      and   ps_mstr1.ps_comp  = bomcode1
      and   ps_mstr1.ps_joint_type = "1"
      and   (effdate1 = ?
      or    (effdate1 <> ?
      and   (ps_mstr1.ps_start = ? or
             ps_mstr1.ps_start <= effdate1)
      and   (ps_mstr1.ps_end = ? or
             ps_mstr1.ps_end >= effdate1)))
      no-lock:
   end. /* FOR FIRST PS_MSTR */
   if available ps_mstr1 then
      coflag1 = yes .
   return.

END PROCEDURE.


/* BEGIN PROCEDURE get-bomcode-routing */

/* PURPOSE :                                                */
/* THIS PROCEDURE IS USED TO GET CORRECT ROUTING AND BOMCODE*/
/* FOR THE ITEM AT SITE . THIS PROCEDURE ACCEPTS FOLLOWING  */
/* I/P PARAM. AND RETURNS VALID BOMCODE AND ROUTING for ITEM*/

/* INPUT PARAMETERS :                                       */
/* 1. ITEM - FOR WHICH CORRECT ROUTING WILL BE SEARCHED     */
/* 2. SITE - ITEM SPECIFIC                                  */
/* 3. CHKPHANTOM  - FLAG ENSURES ASSIGNING ROUTING BLANK    */
/*    EVEN FOR TOP LEVEL PHANTOM AND IGNORING ROUTING FOR   */
/*    GLOBAL PHANTOM.                                       */
/* 4. EFFDATE - USED FOR CHECKING CO-PRODUCT ITEM           */
/* 5. BUFFER PTPDET - BUFFER OF PTP_DET FOR ITEM AT SITE    */
/* 6. BUFFER PTMSTR - BUFFER OF PT_MSTR FOR ITEM AT SITE    */

/* OUTPUT PARAMETERS :                                      */
/* 1. BOMCODE  - CORRECT BOMCODE FOR ITEM                   */
/* 2. ROUTING  - CORRECT ROUTING FOR ITEM                   */

/* LOGIC :                                                  */
/* THIS PROCEDURE ASSUMES THAT PTPDET AND PTMASTER BUFF. ARE*/
/* AVAILABLE FOR ITEM AND SITE. WITH ITEM AND SITE AS INPUT */
/* PARAMETERS,IT SEARCHES IN PTPDET BUFF. IF NOT AVAILABLE  */
/* THEN IT SEARCHES IN PT_MSTR FOR GETTING BOMCODE AND      */
/* ROUTING FOR ITEM.                                        */
/* AFTER THIS,PROCEDURE IS-COPRODUCT IS CALLED TO CHECK IF  */
/* CURRENT ITEM IS A CO-PRODUCT ITEM. IF THE ITEM IS A      */
/* COPRODUCT ITEM THEN ROUTING OF IT'S BASE PROCESS WILL BE */
/* RETURNED AS A VALID ROUTING.                             */

PROCEDURE get-bomcode-routing:

   define input  parameter item    like pt_part       no-undo .
   define input  parameter site    like pt_site       no-undo .
   define input  parameter chkphantom as logical      no-undo .
   define input  parameter effdate    as date         no-undo .
   define parameter buffer ptpdet  for  ptp_det .
   define parameter buffer ptmstr  for  pt_mstr .

   define input-output parameter bomcode like pt_bom_code      no-undo.
   define output parameter routing like pt_routing  initial "" no-undo .

   define variable  coflag as logical initial no      no-undo .

   define buffer ptmstr2 for pt_mstr .
   define buffer ptpdet2 for ptp_det .

   /* GET BOMCODE AND ROUTING */

   if available ptpdet then do:

      if ptpdet.ptp_bom_code <> "" then
         bomcode = ptpdet.ptp_bom_code .
      else
         bomcode = ptpdet.ptp_part .

      if ptpdet.ptp_phantom and chk_phantom  then
         routing = "" .
      else
      if ptpdet.ptp_routing <> "" then
         routing = ptpdet.ptp_routing .
      else
         routing = ptpdet.ptp_part .

   end. /* IF AVAILABLE PTP_DET */
   else if available ptmstr then do:

      if ptmstr.pt_bom_code <> "" then
         bomcode = ptmstr.pt_bom_code .
      else
         bomcode = ptmstr.pt_part.

      if ptmstr.pt_phantom and chk_phantom then
         routing = "" .
      else
      if ptmstr.pt_routing <> "" then
         routing = ptmstr.pt_routing .
      else
         routing = ptmstr.pt_part.

   end. /*ELSE IF AVAILABLE PTMSTR1*/

   /* TO CHECK IF ITEM IS A COPRODUCT ITEM */

   run is-coproduct( input item    ,
                     input bomcode ,
                     input effdate ,
                     output coflag ) .

   /* GETTING VALID ROUTING FOR BASE-PROCESS  */

   if coflag then do:

      for first ptpdet2
         fields( ptp_bom_code ptp_part ptp_phantom
                 ptp_pm_code ptp_routing ptp_run
                 ptp_run_ll ptp_setup ptp_setup_ll
                 ptp_site ptp_yld_pct)
         where ptpdet2.ptp_part = bomcode
         and   ptpdet2.ptp_site = site
         no-lock:
      end. /* FOR FIRST PTPDET */

      if available ptpdet2 then do:
         if ptpdet2.ptp_routing <> "" then
            routing = ptpdet2.ptp_routing .
         else
            routing = ptpdet2.ptp_part .
      end. /* IF AVAILABLE PTPDET2 */
      else do:

         for first ptmstr2
            fields( pt_bom_code pt_group pt_part
                    pt_part_type pt_phantom pt_pm_code
                    pt_prod_line pt_routing pt_run
                    pt_run_ll pt_setup pt_setup_ll
                    pt_site pt_yield_pct)
            where ptmstr2.pt_part =  bomcode
            no-lock:
         end. /* FOR FIRST PTMSTR1 */

         if ptmstr2.pt_routing <> "" then
            routing = ptmstr2.pt_routing .
         else
            routing = ptmstr2.pt_part .

      end. /*IF NOT AVAILABLE PTPDET*/

   end. /*IF COFLAG THEN*/

   return .

END PROCEDURE.

PROCEDURE calculate-yield-percentage:
   /* DETERMINE LOSS DUE TO YIELD OF COMPONENT ITEMS        */
   /* (LOSS FOR LABOR ETC IS CALCULATED IN ROUTING ROLL-UP) */

   define input-output parameter item_yield as decimal no-undo.
   define input        parameter yield_flag like mfc_logical no-undo.
   define input        parameter ptrouting like pt_routing no-undo.
   define input        parameter effdate as date no-undo.
   define input        parameter psop like ps_op no-undo.

   define buffer rodet for ro_det.

   item_yield = 100.

   if yield_flag then do:

      /* SINCE WE STORE THE ROUTING, WE DON'T NEED TO LOOK UP THESE     */
      /* RECORDS AGAIN.                                                 */

      /* PTROUTE[LEVEL - 1] IS PASSED AS A INPUT PARAMTER IN PTROUTING  */

      /* IF A ROUTING EXISTS FOR THE PARENT ACCUMULATE YIELD PERCENTAGE */
      /* FOR ITEM CONSIDERING ALL OPERATIONS STARTING WITH THE          */
      /* COMPONENTS FIRST OPERATION                                     */


      if ptrouting <> "" then do:
         for each rodet
               no-lock
             where ro_routing = ptrouting
               and (ro_start <= eff_date or ro_start = ?)
               and (ro_end   >= eff_date or ro_end   = ?)
               and ro_op >= psop:

            item_yield = item_yield
                       * ro_yield_pct * .01.
         end. /* for each rodet */
      end. /* if ptrouting <> "" */

      if item_yield = 0 or item_yield = ? then
         item_yield = 100.
   end.  /* if yield_flag */
   return.
END PROCEDURE. /* CALCULATE-YIELD-PERCENTAGE */
