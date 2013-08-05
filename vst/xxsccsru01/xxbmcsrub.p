/* bmcsrub.p - BILL OF MATERIAL ROLL-UP FOR RANGE OF ITEMS              */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
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
/* REVISION: 9.1      LAST MODIFIED: 04/24/01   BY: *K26M* Rajesh Thomas      */

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
 *  phantoms.                                                                 */

         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

         define variable comp like ps_comp
/*G700*/    no-undo.
         define variable record as integer extent 100 no-undo.
/*G1CY*/ define variable ptroute like pt_routing extent 100 no-undo.
/*J0H0*/ define variable bom_code like pt_bom_code no-undo.
/*G681   define variable mtl_ll as decimal extent 100 no-undo.          */
/*G681   define variable lbr_ll as decimal extent 100 no-undo.          */
/*G681   define variable bdn_ll as decimal extent 100 no-undo.          */
/*G681   define variable ovh_ll as decimal extent 100 no-undo.          */
/*G681   define variable sub_ll as decimal extent 100 no-undo.          */
         define variable labor_time as decimal extent 100 no-undo.
         define variable setup_time as decimal extent 100 no-undo.
/*G700*  define variable pt_recid as recid.     */
         define variable low_level like pt_ll_code
/*G700*/    no-undo.
         define variable max_level like pt_ll_code
/*G700*/    no-undo.
/*FT70**
 *       define variable level like pt_ll_code
 *G700*     no-undo.
**FT70**/
/*FT70*/ define new shared variable level like pt_ll_code no-undo.
         define variable parent like ps_par
/*G700*/    no-undo.

/*J054*/ define variable oldcst like sct_cst_tot no-undo.

/*J2YM*/ define variable oldmtl_ll like sct_mtl_tl no-undo.
/*J2YM*/ define variable oldlbr_ll like sct_lbr_tl no-undo.
/*J2YM*/ define variable oldbdn_ll like sct_bdn_tl no-undo.
/*J2YM*/ define variable oldovh_ll like sct_ovh_tl no-undo.
/*J2YM*/ define variable oldsub_ll like sct_sub_tl no-undo.

         define shared variable site like si_site.
         define shared variable part like pt_part.
         define shared variable part1 like pt_part.

/*F345*/ define shared variable line like pt_prod_line.
/*F345*/ define shared variable line1 like pt_prod_line.
/*F345*/ define shared variable type like pt_part_type.
/*F345*/ define shared variable type1 like pt_part_type.
/*F345*/ define shared variable grp like pt_group.
/*F345*/ define shared variable grp1 like pt_group.

/*GH69*  define shared variable eff_date like glt_effdate initial today. */
/*GH69*/ define shared variable eff_date as date initial today.

         define shared variable mtl_flag like mfc_logical.
         define shared variable lbr_flag like mfc_logical.
         define shared variable bdn_flag like mfc_logical.
         define shared variable ovh_flag like mfc_logical.
         define shared variable sub_flag like mfc_logical.
/*G681   define shared variable std_sub like mfc_logical.              */
         define shared variable labor_flag like mfc_logical.
         define shared variable setup_flag like mfc_logical.
         define shared variable csset like sct_sim.
/*F542   define shared variable audit_yn as logical. */
/*F542*/ define shared variable audit_yn like mfc_logical.

/*J054*  /*DE-COUPLE PROGRAMS FOR OBJECTS*/
 *       define new shared variable sct_recno as recid.
 *       define new shared variable cracct as character.
 *       define new shared variable insite like in_site initial ?.
 *       define new shared variable oldcst like sct_cst_tot.
 *J054*/

         define
/*G681*/ new shared
         workfile sctold
/*G700*/    no-undo
         field oldmtl like sct_mtl_tl
         field oldlbr like sct_lbr_tl
         field oldbdn like sct_bdn_tl
         field oldovh like sct_ovh_tl
         field oldsub like sct_sub_tl.

/*F116*/ define shared variable cst_flag like mfc_logical.

/*F345*/ define buffer ptmstr for pt_mstr.
/*F345*/ define buffer ps_mstr1 for ps_mstr.

/*K21S*/ define buffer ptpdet   for ptp_det .
/*K21S*/ define buffer ptmstr1  for pt_mstr .

/*F542*/ define shared variable yield_flag like mfc_logical.
/*G700*
/*F345*/ define variable yield_pct like pt_yield.  *
/*F779*/ define variable item_yield like pt_yield. */

/*L0YY*/ /* VARIABLE YIELD_PCT COMMENTED AS IT IS NO LONGER USED IN YIELD   */
/*L0YY*/ /* CALCULATIONS. ONLY VARIABLE ITEM_YIELD IS USED  FOR YIELD WHICH */
/*L0YY*/ /* IS SET TO ROUTING YIELD IF IT EXISTS ELSE SET TO 100 PERCENT    */

/*L0YY** BEGIN DELETE
 * /*G700*/ define
 * /*J036*/ new shared
 * /*G700*/ variable yield_pct like pt_yield_pct no-undo.
 *L0YY* END DELETE */

/*FT70* /*G700*/ define variable item_yield as decimal no-undo.        */
/*FT70*/ define new shared variable item_yield as decimal no-undo.
/*G1CY** /*F779*/ define variable routing like ro_routing             **
**G1CY** /*G700*/    no-undo.                                         **/
/*G681*/ define new shared frame b.
/*G681*/ define variable m_level like max_level.

/*FT70***                                           *
 * /*G681*/ define variable w13_flag like mfc_logical. *
 * /*G681*/ define variable w30_flag like mfc_logical. *
 * /*G681*/ define variable w45_flag like mfc_logical. *
 * /*G681*/ define variable w99_flag like mfc_logical. *
**FT70***/
/*FT70*/ define new shared variable w13_flag like mfc_logical.
/*FT70*/ define new shared variable w30_flag like mfc_logical.
/*FT70*/ define new shared variable w45_flag like mfc_logical.
/*FT70*/ define new shared variable w99_flag like mfc_logical.

/*G681*/ define variable i as integer.
/*G681*/ define shared variable rollup_id like qad_key3.
/*G681*/ define variable rolled_yn as logical.
/*FT70***
 *G681*  define variable sptcsttl like spt_cst_tl.  *
 *G681*  define variable sptcstll like spt_cst_ll.  *
**FT70**/
/*FT70*/ define new shared variable sptcsttl like spt_cst_tl.
/*FT70*/ define new shared variable sptcstll like spt_cst_ll.
/*FT70*/ define new shared variable pt_recid as recid.
/*FT70*/ define new shared variable ps_recid as recid.

/*J036*/ /************************************************************/
/*J036*/ /*PROGRAM NEEDS TO BE DIVIDED DUE TO R-CODE.                */
/*J036*/ /*MOVE CALLS TO BMCSRUB2.I & BMCSRUB3. TO .P PROGRAMS.      */
/*J036*/ /*THIS WILL REQUIRE WKFL-13, -30, -45, AND -99 TO BE SHARED */
/*J036*/ /************************************************************/

/*FT70* /*G681*/ define workfile wkfl-13 no-undo       */
/*FT70*/ define new shared workfile wkfl-13 no-undo
/*G681*/    field element like spt_element
/*G681*/    field cat     as integer
/*G681*/    field cst_ll  like spt_cst_ll extent 13.

/*FT70* /*G681*/ define workfile wkfl-30 no-undo       */
/*FT70*/ define new shared workfile wkfl-30 no-undo
/*G681*/    field element like spt_element
/*G681*/    field cat     as integer
/*G681*/    field cst_ll  like spt_cst_ll extent 30.

/*FT70* /*G681*/ define workfile wkfl-45 no-undo       */
/*FT70*/ define new shared workfile wkfl-45 no-undo
/*G681*/    field element like spt_element
/*G681*/    field cat     as integer
/*G681*/    field cst_ll  like spt_cst_ll extent 45.

/*FT70* /*G681*/ define workfile wkfl-99 no-undo       */
/*FT70*/ define new shared workfile wkfl-99 no-undo
/*G681*/    field element like spt_element
/*G681*/    field cat     as integer
/*G681*/    field cst_ll  like spt_cst_ll extent 99.

/*J34B*/ define buffer sctdet for sct_det.
/*J34B*/ define variable sctdet_cnt as integer init 0 no-undo.
/*J34B*/ define variable ptmstr_cnt as integer init 0 no-undo.
/*J34B*/ define query q_sctdet for sctdet
         fields(sct_site sct_sim sct_part sct_rollup_id sct_rollup).
/*J34B*/ define query q_pt_mstr for pt_mstr
/*J34B*/ fields(pt_part pt_prod_line pt_part_type pt_group
                pt_bom_code pt_routing pt_yield_pct).
/*J34B*/ define variable from_part like sct_part no-undo.

/*K21S*/ define variable chk_phantom as logical no-undo.

/*J34B*/ assign
            glxcst = 0
            curcst = 100000.

         /*! FIND THE FIRST ITEM WITHIN THE SELECTION RANGE */
/*J34B** BEGIN DELETE
 *       find first pt_mstr where pt_part >= part and pt_part <= part1
 * /*F345*/ and pt_prod_line >= line and pt_prod_line <= line1
 * /*F345*/ and pt_part_type >= type and pt_part_type <= type1
 * /*F345*/ and pt_group >= grp and pt_group <= grp1
 *       no-lock no-error.
 *J34B** END DELETE */

/*G681*/ form
/*G681*/    pt_part format "x(25)" csset no-label oldmtl oldlbr oldbdn
/*G681*/    oldovh oldsub oldcst
/*G681*/ with frame b width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

         /*! LOOP THROUGH ALL ITEMS IN SELECTION RANGE */
/*G1CY*/ itemloop:
         repeat with frame b width 132 down: /* nest level 1 */

/*J34B*/ if sctdet_cnt mod 10000 = 0 then do:
/*J34B*/    if sctdet_cnt > 0 then from_part = sctdet.sct_part.
/*J34B*/    else from_part = part.

/*J34B*/    close query q_sctdet.
/*J34B*/    if sctdet_cnt > 0 then
/*J34B*/       open query q_sctdet for each sctdet
               where sctdet.sct_site = site and sctdet.sct_sim = csset
                 and sctdet.sct_part > from_part and sctdet.sct_part <= part1
                 no-lock use-index sct_sim_pt_site.
/*J34B*/    else /* full range */
/*J34B*/       open query q_sctdet for each sctdet
               where sctdet.sct_site = site and sctdet.sct_sim = csset
                 and sctdet.sct_part >= from_part and sctdet.sct_part <= part1
                 no-lock use-index sct_sim_pt_site.

/*J34B*/    get first q_sctdet.
/*J34B*/ end.
/*J34B*/ else
/*J34B*/    get next q_sctdet.

/*J34B*/ if not available sctdet then leave itemloop.
/*J34B*/ sctdet_cnt = sctdet_cnt + 1.

/*J34B*/ for each pt_mstr
/*J34B*/ fields(pt_part pt_prod_line pt_part_type pt_group pt_bom_code
/*K21S*/        pt_site pt_phantom
/*J34B*/        pt_routing pt_yield_pct)
/*J34B*/ where pt_part = sctdet.sct_part
/*J34B*/ and pt_prod_line >= line and pt_prod_line <= line1
/*J34B*/ and pt_part_type >= type and pt_part_type <= type1
/*J34B*/ and pt_group >= grp and pt_group <= grp1
/*J34B*/ no-lock:

            /*! IF THERE AREN'T ANY ITEMS LEFT, LEAVE THE ITEMLOOP */
/*J34B**    if not available pt_mstr then leave. */

            /*! ROLL UP ALL COSTS FOR THE TOP-LEVEL ITEM */
/*FT70*/    rollup_loop: do:
/*J34B**       BEGIN DELETE
 * /*FT70*/    if not can-find (first sct_det where sct_sim = csset and
 * /*FT70*/       sct_part = pt_part and sct_site = site)
 * /*FT70*/    then leave rollup_loop.
 *J34B**       END DELETE */

/*J34B*/       assign
                  parent = pt_part
                  comp   = pt_part.

/*G681*/       {bmcssct.i &comp=comp}
/*G681*/       if not rolled_yn then
/*G681*/       parcost: do:

/*G1CY*/          ptroute[1] = pt_part.

                  /*! IDENTIFY THE BOM AND ROUTING */
/*J34B**          BEGIN DELETE
 * /*F345*/       find ptp_det no-lock where ptp_part = pt_part
 * /*F345*/       and ptp_site = site no-error.
 *J34B**          END DELETE */

/*K21S** BEGIN DELETE
 *
 * /*J34B*/          for first ptp_det no-lock where ptp_part = pt_part
 * /*J34B*/          and ptp_site = site: end.
 * /*F345*/          if available ptp_det then do:
 * /*F345*/             if ptp_bom_code <> "" then comp = ptp_bom_code.
 *
 *                  /*! ASSIGN THE ROUTING EVEN IF IT'S A TOP LEVEL PHANTOM */
 * /*G1CY*/             if ptp_routing <> "" then ptroute[1] = ptp_routing.
 * /*F345*/          end.
 *
 *K21S** END DELETE */

 /*G1CY** /*F345*/ else if pt_bom_code <> "" then comp = pt_bom_code. */

/*K21S** BEGIN DELETE
 * /*G1CY*/          else do:
 * /*G1CY*/             if pt_bom_code <> "" then comp = pt_bom_code.
 *
 *                   /*! ASSIGN THE ROUTING EVEN IF IT'S A TOP LEVEL PHANTOM */
 * /*G1CY*/             if pt_routing <> "" then ptroute[1] = pt_routing.
 * /*G1CY*/          end.
 *
 *K21S** END DELETE */

/*K21S*/          /* BEGIN ADD SECTION */

                  /* CALLED PROCEDURE GET-BOMCODE-ROUTING TO GET CORRECT */
                  /* BOMCODE AND ROUTING FOR PARENT                      */

                  do for ptpdet :

                     /* GETTING RECORD FOR PARENT IN BUFFER */

                     for first ptpdet
                        fields( ptp_bom_code ptp_part ptp_phantom
                                ptp_pm_code ptp_routing ptp_run
                                ptp_run_ll ptp_setup ptp_setup_ll
                                ptp_site ptp_yld_pct)
                        where ptp_part = parent
                        and   ptp_site = site
                        no-lock :
                     end. /*FOR FIRST PTPDET*/


                     /* ASSIGN THE ROUTING EVEN IF IT'S A TOP LEVEL PHANTOM */

                     chk_phantom = no  .

                     /* IDENTIFY THE BOM AND ROUTING */

/*K26M*/             /* CHANGED SEVENTH PARAMETER comp IN PROCEDURE           */
/*K26M*/             /* get-bomcode-routing TO INPUT-OUPUT PARAM. FROM OUTPUT */
/*K26M*/             /* PARAMETER AS IT RETURNED BLANK FOR A VALID BOM CODE.  */

                     run get-bomcode-routing0( input  parent     ,
                                              input  site       ,
                                              input  chk_phantom,
                                              input  eff_date   ,
                                              buffer ptpdet     ,
                                              buffer pt_mstr    ,
                                              input-output comp ,
                                              output ptroute[1]).
                  end. /*DO FOR PTPDET*/

/*K21S*/          /* END ADD SECTION */
                  assign setup_time[1] = 0
                         labor_time[1] = 0.

/*G681*           sub_ll [1] = 0    */
/*G681*           ovh_ll [1] = 0    */
/*G681*           bdn_ll [1] = 0    */
/*G681*           lbr_ll [1] = 0    */
/*G681*           mtl_ll [1] = 0.   */


                  /*! DELETE WORKFILES */
/*FS91* /*G681*/  for each wkfl-13:*/
/*FS91*/          for each wkfl-13 exclusive-lock:
/*G681*/             delete wkfl-13.
/*G681*/          end.
/*G681*/          w13_flag = no.


/*FS91* /*G681*/  for each wkfl-30:*/
/*FS91*/          for each wkfl-30 exclusive-lock:
/*G681*/             delete wkfl-30.
/*G681*/          end.
/*G681*/          w30_flag = no.


/*FS91* /*G681*/  for each wkfl-45:*/
/*FS91*/          for each wkfl-45 exclusive-lock:
/*G681*/             delete wkfl-45.
/*G681*/          end.
/*G681*/          w45_flag = no.


/*FS91* /*G681*/  for each wkfl-99:*/
/*FS91*/          for each wkfl-99 exclusive-lock:
/*G681*/             delete wkfl-99.
/*G681*/          end.
/*G681*/          w99_flag = no.

/*G681*/          for each sc_mstr where sc_sim = csset by sc_category:
/*G681*/             if  (mtl_flag or sc_category <> "1")
/*G681*/             and (lbr_flag or sc_category <> "2")
/*G681*/             and (bdn_flag or sc_category <> "3")
/*G681*/             and (ovh_flag or sc_category <> "4")
/*G681*/             and (sub_flag or sc_category <> "5")
/*G681*/             then do:
/*G681*/                create wkfl-13.
/*G681*/                assign element = sc_element
/*G681*/                           cat = integer(sc_category)
/*G681*/                        cst_ll = 0.
/*G681*/             end.
/*G681*/          end. /* for each sc_mstr */
/*G681*/          w13_flag = yes.

                  /*! MFG/PRO ONLY LOOKS 99 LEVELS DEEP. WE START AT LEVEL 2  *
                   *  SINCE WE ARE LOOKING FOR COMPONENT COSTS TO ROLL-UP     *
                   *  INTO THE PARENT                                         */
/*J34B*/          assign
                     max_level = 99
                     level     = 2
/*G681*/             level     = 2.

                  /*! LOOK FOR A BOM RECORD WHERE THIS ITEM IS THE PARENT */
/*J34B**          BEGIN DELETE
 *                find first ps_mstr use-index ps_parcomp where ps_par = comp
 *                no-lock no-error.
 *J34B**          END DELETE */

/*J34B*/          for first ps_mstr use-index ps_parcomp where ps_par = comp
/*J34B*/          no-lock: end.

                  /*! LOOP THROUGH ALL COMPONENTS FOR THE PARENT PART.  THE   *
                   *  FIRST TIME THROUGH WE WILL DROP DOWN TO THE LOWER BLOCK *
                   *  OF CODE TO FIND THE NEXT COMPONENT.  THE UPPER BLOCK OF *
                   *  CODE IS EXECUTED WHEN WE HAVE REACHED THE END OF A      *
                   *  BRANCH IN THE STRUCTURE TREE.                           */
/*G1CY*/          comploop:
                  repeat with frame b: /* nest level 2 */

                     /*! IF THIS ITEM IS NOT THE PARENT OF ANOTHER OR WE HAVE *
                      *  REACHED THE MAXIMUM LEVEL, THEN PROCESS THE COST     *
                      *  OF THE ITEM.                                         */

                      if not available ps_mstr or level > max_level then do:

                         /*! DRILL DOWN PRODUCT STRUCTURE */
                         psloop:
                         repeat with frame b: /* nest level 3 */

                            /*! BACK UP TO THE LEVEL INTO WHICH WE ARE ROLLING *
                             *  THE COSTS                                     */
                            level = level - 1.

                            /*! IF WE ARE AT THE TOP LEVEL THEN WE ARE DONE  */
                            if level < 2 then leave.

                            /*! FIND THE BOM RECORD FOR THE LEVEL INTO WHICH
                             *  WE ARE ROLLING THE COSTS            */
/*J34B**                    BEGIN DELETE
 *                          find ps_mstr where recid(ps_mstr) = record[level]
 *                          no-lock no-error.
 *J34B**                    END DELETE */

/*J34B*/                    for first ps_mstr where
/*J34B*/                    recid(ps_mstr) = record[level] no-lock: end.

                            if available ps_mstr then do:
/*G2QC********                /* Moved down to be closer to where it's used */
/*G681*/     *                 {bmcssct.i &comp=ps_comp}
             ****G2QC*/
/*F779*/                      /* Added section */
                              /*DETERMINE LOSS DUE TO YIELD OF COMPONENT ITEMS*/
                              /*(LOSS FOR LABOR ETC IS CALCULATED IN          */
                              /*ROUTING ROLL-UP)                              */
/*G1CY**                      routing = "".        **/
                              item_yield = 100.

                              /*! CALCULATE YIELD PERCENTAGES.                */
                              if yield_flag then do:

/*G1CY*/                         /* SINCE WE STORE THE ROUTING, WE DON'T      *
                                  * NEED TO LOOK UP THESE RECORDS AGAIN.      */
/*G1CY** BEGIN DELETE            find ptp_det no-lock where ptp_part = ps_par
.                                and ptp_site = site no-error.
.
.                                if not available ptp_det then do:
.                                   find pt_mstr no-lock where
.                                   pt_part = ps_par no-error.
.                                   if available pt_mstr then do:
.                                      if pt_routing <> "" then
.                                         routing = pt_routing.
.                                      else routing = pt_part.
.                                   end. /* if available pt_mstr */
.                                end. /* if not available ptp_det */
.                                else do:
.                                   if ptp_routing <> "" then
.                                      routing = ptp_routing.
.                                   else routing = ptp_part.
.                                end. /* else do */
**G1CY** END DELETED SECTION ***/

                                 /*! IF A ROUTING EXISTS FOR THE PARENT       *
                                     ACCUMULATE YIELD PERCENTAGE FOR ITEM     *
                                     CONSIDERING ALL OPERATIONS STARTING      *
                                     WITH THE COMPONENTS FIRST OPERATION      */
/*G1CY**                         if routing <> "" then do:  **/
/*G1CY*/                         if ptroute[level - 1] <> "" then do:
                                    for each ro_det
/*G700*/                            no-lock
/*G1CY**                            where ro_routing = routing  **/
/*G1CY*/                            where ro_routing = ptroute[level - 1]
                                    and (ro_start <= eff_date or ro_start = ?)
                                    and (ro_end   >= eff_date or ro_end   = ?)
                                    and ro_op >= ps_op:
/*G700*                             by ro_op desc: */
                                       item_yield = item_yield
                                                  * ro_yield_pct * .01.
                                    end. /* for each ro_det */
                                 end. /* if ptroute[level - 1] <> "" */

/*G1CY**                         if item_yield = 0 then item_yield = 100. **/
/*G1CY*/                         if item_yield = 0 or item_yield = ? then
/*G1CY*/                            item_yield = 100.
                              end.  /* if yield_flag */
/*F779*/                      /* End of added section */

                              /*! IF CALCULATING SETUP OR LABOR TIMES         *
                               *  FIND THE COMPONENT'S PLANNING DATA          */
/*G700*/                      if setup_flag or labor_flag then
/*F345*/                         find ptp_det exclusive-lock
                                 where ptp_part = ps_comp
/*F345*/                         and ptp_site = site no-error.
/*G700*/                      else
/*J34B**                         BEGIN DELETE
 * /*G700*/                      find ptp_det no-lock where ptp_part = ps_comp
 * /*G700*/                      and ptp_site = site no-error.
 *J34B**                         END DELETE */

/*J34B*/                         for first ptp_det no-lock where
/*J34B*/                         ptp_part = ps_comp
/*J34B*/                         and ptp_site = site: end.

/*F345*                       find pt_mstr where pt_part = ps_comp no-error. */
/*F345*/                      if available ptp_det
/*G700*/                      or (setup_flag = no and labor_flag = no)
/*J34B**                      BEGIN DELETE
 * /*F345*/                   then find pt_mstr no-lock where
 *                            pt_part = ps_comp no-error.
 * /*F345*/                   else find pt_mstr exclusive-lock
 *                            where pt_part = ps_comp
 * /*F345*/                        no-error.
 *J34B**                      END DELETE */

/*J34B*/                      then for first ptmstr
/*J34B*/                      fields (pt_bom_code pt_group pt_part pt_part_type
/*J34B*/                      pt_phantom pt_pm_code pt_prod_line pt_routing
/*J34B*/                      pt_run pt_run_ll pt_setup pt_setup_ll
/*J34B*/                      pt_yield_pct)
/*J34B*/                      no-lock where ptmstr.pt_part = ps_comp: end.
/*J34B*/                      else find ptmstr exclusive-lock
/*J34B*/                      where ptmstr.pt_part = ps_comp no-error.

/*G2QC*/                      /* Added section */
                              /* Decide if ps_comp has already had its costs
                                 rolled up for this site and cost set. */
                              {bmcssct.i &comp=ps_comp}
/*G2QC*/                      /* End of added section */

                              /*! IF THE COMPONENT IS AN ITEM AND WE HAVEN'T  *
                               *  ROLLED UP THE COSTS ALREADY, THEN FIND THE  *
                               *  ITEM'S COST.                                */
/*J34B**                      if available pt_mstr */
/*J34B*/                      if available ptmstr
/*G681*/                      and not rolled_yn
                              then do:

/*L0YY** BEGIN DELETE
 * /*F345*/                         if available ptp_det then
 *                                  yield_pct = ptp_yld_pct.
 * /*J34B** /*F345*/                else yield_pct = pt_yield. */
 * /*J34B*/                         else yield_pct = ptmstr.pt_yield.
 *
 * /*F542*/                         if not yield_flag or yield_pct = 0 then
 *                                  yield_pct = 100.
 *L0YY** END DELETE */

/*J34B*/                         /* MODIFIED THE FIRST PARAMETER FROM     */
/*J34B*/                         /* &part=pt_part TO &part=ptmstr.pt_part */
                                 {gpsct01.i &part=ptmstr.pt_part &set=csset
                        &site=site}
                                 oldcst = sct_cst_tot.


/*FS91*                          for each sctold:*/
/*FS91*/                         for each sctold exclusive-lock:
                                    delete sctold.
                                 end.

                                 create sctold.
                                 assign
/*F116*                             oldmtl = sct_mtl_tl + sct_mtl_ll */
/*F116*                             oldlbr = sct_lbr_tl + sct_lbr_ll */
/*F116*                             oldbdn = sct_bdn_tl + sct_bdn_ll */
/*F116*                             oldovh = sct_ovh_tl + sct_ovh_ll */
/*F116*                             oldsub = sct_sub_tl + sct_sub_ll.*/
/*F116*/                            oldmtl = sct_mtl_ll
/*F116*/                            oldlbr = sct_lbr_ll
/*F116*/                            oldbdn = sct_bdn_ll
/*F116*/                            oldovh = sct_ovh_ll
/*F116*/                            oldsub = sct_sub_ll.

                                 /*! CALCULATE SETUP TIME */
                                 if setup_flag then do:
/*F345*/                            if available ptp_det then do:
/*F345*/                               ptp_setup_ll = setup_time[level].
/*F345*/                               if ps_ps_code <> "O"
/*F345*/                               and ptp_pm_code <> "P" and
/*F345*/                               ptp_pm_code <> "D" then
/*F345*/                                  setup_time[level - 1] =
/*F345*/                                     setup_time[level - 1]
/*F345*                                      + ptp_setup_ll + ptp_setup. */
/*F345*/                                     + ptp_setup_ll + if not ptp_phantom
                                               then ptp_setup else 0.
/*F345*/                            end. /* if available ptp_det */
/*F345*/                            else do:
/*J34B**                               pt_setup_ll = setup_time[level]. */
/*J34B*/                               ptmstr.pt_setup_ll = setup_time[level].
/*F345*                                if caps(pt_pm_code) = "P" then
      *                                   pt_setup_ll = 0.
**F345*/
                                       if ps_ps_code <> "O"
/*J34B**                               BEGIN DELETE
 * /*F345*/                            and pt_pm_code <> "P" and
 * /*F345*/                            pt_pm_code <> "D"
 *J34B**                               END DELETE */
/*J34B*/                               and ptmstr.pt_pm_code <> "P" and
/*J34B*/                               ptmstr.pt_pm_code <> "D"
                                       then
                                       setup_time[level - 1] =
                                             setup_time[level - 1]
/*F345*                                      + pt_setup_ll + pt_setup. */
/*J34B**                                     BEGIN DELETE
 * /*F345*/                                  + pt_setup_ll +
 * /*F345*/                                  if not pt_phantom then
 * /*F345*/                                  pt_setup else 0.
 *J34B**                                     END DELETE */
/*J34B*/                                     + ptmstr.pt_setup_ll +
/*J34B*/                                     if not ptmstr.pt_phantom then
/*J34B*/                                     ptmstr.pt_setup else 0.
/*F345*/                            end. /* else do */
                                    setup_time[level] = 0.
                                 end. /* if setup_flag */

                                 /*! CALCULATE LABOR TIME */
                                 if labor_flag then do:
/*F345*/                            if available ptp_det then do:
/*F345*/                               ptp_run_ll = labor_time[level].
/*F345*/                               if ps_ps_code <> "O"
/*F345*/                               and ptp_pm_code <> "P" and
/*F345*/                               ptp_pm_code <> "D" then
/*F345*/                                  labor_time[level - 1] =
/*F345*/                                     labor_time[level - 1] +
/*F345*/                                     (ptp_run_ll
/*F345*/                                     + if not ptp_phantom then
/*F345*/                                     ptp_run else 0) * ps_qty_per.
/*F345*/                            end. /* if available ptp_det */
/*F345*/                            else do:
/*J34B**                               pt_run_ll = labor_time[level]. */
/*J34B*/                               ptmstr.pt_run_ll = labor_time[level].

/*F345*                                if caps(pt_pm_code) = "P" then
      *                                   pt_run_ll = 0.
**F345*/
                                       if ps_ps_code <> "O"
/*J34B**                               BEGIN DELETE
 * /*F345*/                            and pt_pm_code <> "P" and
 * /*F345*/                            pt_pm_code <> "D"
 *J34B**                               END DELETE */
/*J34B*/                               and ptmstr.pt_pm_code <> "P" and
/*J34B*/                               ptmstr.pt_pm_code <> "D"
                                       then
                                       labor_time[level - 1] =
                                          labor_time[level - 1] +
/*F345*                                   (pt_run_ll + pt_run) * ps_qty_per.*/
/*J34B**                                  BEGIN DELETE
 * /*F345*/                               (pt_run_ll
 * /*F345*/                             + if not pt_phantom then
 * /*F345*/                                  pt_run else 0) * ps_qty_per.
 *J34B**                                  END DELETE */
/*J34B*/                                  (ptmstr.pt_run_ll
/*J34B*/                                + if not ptmstr.pt_phantom then
/*J34B*/                                     ptmstr.pt_run else 0) * ps_qty_per.
/*F345*/                            end. /* else do */
                                    labor_time[level] = 0.
                                 end. /* if labor_flag */

/*G681*******************DELETED FOLLOWING SECTIONS************************
            *     if sub_flag then do:
/*F542*/    *        sub_ll[level] = sub_ll[level] / (yield_pct * .01).
            *        sct_sub_ll = sub_ll [level].
/*F345*/    *        if available ptp_det then
/*F345*/    *           if ptp_pm_code = "P" or ptp_pm_code = "D"
/*F345*/    *           then sct_sub_ll = 0.
/*F345*/    *        if not available ptp_det then
            *           if caps(pt_pm_code) = "P"
/*F345*/    *           or pt_pm_code = "D"
            *           then sct_sub_ll = 0.
            *        if ps_ps_code <> "O" then
            *        sub_ll [level - 1] = sub_ll [level - 1] +
/*F345*     *           ((sct_sub_ll + sct_sub_tl) * ps_qty_per */
/*F345*/    *           ((sct_sub_ll
/*F345*/    *           + if (available ptp_det and not ptp_phantom)
/*F345*/    *             or (not available ptp_det and not pt_phantom)
/*F345*/    *             then sct_sub_tl else 0) * ps_qty_per
            *           * (100 /  (100 - ps_scrp_pct))).
/*F345*     *           / (pt_yield_pct * .01). */
/*F542/*F345*/          / (yield_pct * .01).    */
            *        sub_ll [level] = 0.
            *     end.
            *
            *     if ovh_flag then do:
/*F542*/    *        ovh_ll[level] = ovh_ll[level] / (yield_pct * .01).
            *        sct_ovh_ll = ovh_ll [level].
/*F345*/    *        if available ptp_det then
/*F345*/    *           if ptp_pm_code = "P" or ptp_pm_code = "D"
/*F345*/    *           then sct_ovh_ll = 0.
/*F345*/    *        if not available ptp_det then
            *           if caps(pt_pm_code) = "P"
/*F345*/    *           or pt_pm_code = "D"
            *           then sct_ovh_ll = 0.
            *        if ps_ps_code <> "O" then
            *        ovh_ll [level - 1] = ovh_ll [level - 1] +
/*F345*     *           ((sct_ovh_ll + sct_ovh_tl) * ps_qty_per */
/*F345*/    *           ((sct_ovh_ll
/*F345*/    *           + if (available ptp_det and not ptp_phantom)
/*F345*/    *             or (not available ptp_det and not pt_phantom)
/*F345*/    *             then sct_ovh_tl else 0) * ps_qty_per
            *           * (100 /  (100 - ps_scrp_pct))).
/*F345*     *           / (pt_yield_pct * .01). */
/*F542/*F345*/          / (yield_pct * .01).    */
            *        ovh_ll [level] = 0.
            *     end.
            *
            *     if bdn_flag then do:
/*F542*/    *        bdn_ll[level] = bdn_ll[level] / (yield_pct * .01).
            *        sct_bdn_ll = bdn_ll [level].
/*F345*/    *        if available ptp_det then
/*F345*/    *           if ptp_pm_code = "P" or ptp_pm_code = "D"
/*F345*/    *           then sct_bdn_ll = 0.
/*F345*/    *        if not available ptp_det then
            *           if caps(pt_pm_code) = "P"
/*F345*/    *           or pt_pm_code = "D"
            *           then sct_bdn_ll = 0.
            *        if ps_ps_code <> "O" then
            *        bdn_ll [level - 1] = bdn_ll [level - 1] +
/*F345*     *           ((sct_bdn_ll + sct_bdn_tl) * ps_qty_per */
/*F345*/    *           ((sct_bdn_ll
/*F345*/    *           + if (available ptp_det and not ptp_phantom)
/*F345*/    *             or (not available ptp_det and not pt_phantom)
/*F345*/    *             then sct_bdn_tl else 0) * ps_qty_per
            *           * (100 /  (100 - ps_scrp_pct))).
/*F345*     *           / (pt_yield_pct * .01). */
/*F542/*F345*/          / (yield_pct * .01).    */
            *        bdn_ll [level] = 0.
            *     end.
            *
            *     if lbr_flag then do:
/*F542*/    *        lbr_ll[level] = lbr_ll[level] / (yield_pct * .01).
            *        sct_lbr_ll = lbr_ll [level].
/*F345*/    *        if available ptp_det then
/*F345*/    *           if ptp_pm_code = "P" or ptp_pm_code = "D"
/*F345*/    *           then sct_lbr_ll = 0.
/*F345*/    *        if not available ptp_det then
            *           if caps(pt_pm_code) = "P"
/*F400/*F345*/          or ptp_pm_code = "D"       */
/*F400*/    *           or pt_pm_code = "D"
            *           then sct_lbr_ll = 0.
            *        if ps_ps_code <> "O" then
            *        lbr_ll [level - 1] = lbr_ll [level - 1] +
/*F345*     *           ((sct_lbr_ll + sct_lbr_tl) * ps_qty_per */
/*F345*/    *           ((sct_lbr_ll
/*F345*/    *           + if (available ptp_det and not ptp_phantom)
/*F345*/    *             or (not available ptp_det and not pt_phantom)
/*F345*/    *             then sct_lbr_tl else 0) * ps_qty_per
            *           * (100 /  (100 - ps_scrp_pct))).
/*F345*     *           / (pt_yield_pct * .01). */
/*F542/*F345*/          / (yield_pct * .01).    */
            *        lbr_ll [level] = 0.
            *     end.
            *
            *     if mtl_flag then do:
/*F542*/    *        mtl_ll[level] = mtl_ll[level].
/*F779      *                      / (yield_pct * .01). */
            *        sct_mtl_ll = mtl_ll [level].
/*F345*/    *        if available ptp_det then
/*F345*/    *           if ptp_pm_code = "P" or ptp_pm_code = "D"
/*F345*/    *           then sct_mtl_ll = 0.
/*F345*/    *        if not available ptp_det then
            *           if caps(pt_pm_code) = "P"
/*F400/*F345*/          or ptp_pm_code = "D"       */
/*F400*/    *           or pt_pm_code = "D"
            *           then sct_mtl_ll = 0.
            *        if ps_ps_code <> "O" then
            *        mtl_ll [level - 1] = mtl_ll [level - 1] +
/*F345*     *           ((sct_mtl_ll + sct_mtl_tl) * ps_qty_per */
/*F345*/    *           ((sct_mtl_ll
/*F345*/    *           + if (available ptp_det and not ptp_phantom)
/*F345*/    *             or (not available ptp_det and not pt_phantom)
/*F345*/    *             then sct_mtl_tl else 0) * (ps_qty_per
/*F779*/    *           / (item_yield * .01))
            *           * (100 /  (100 - ps_scrp_pct))).
/*F345*     *           / (pt_yield_pct * .01). */
/*F542/*F345*/          / (yield_pct * .01).    */
            *        mtl_ll [level] = 0.
            *     end.
**G681*******************DELETED PRECEDING SECTIONS***********************/

/*G681*/                         /******ADDED FOLLOWING SECTIONS*****/

/*J036*/                        /*CONVERTED THE FOLLOWING .I CALLS TO .P CALLS*/
                                 if w99_flag then do for wkfl-99:
/*J036                               for each wkfl-99:    **/
/*J036                                  {bmcsrub2.i}      **/
/*J036                               end.                 **/
/*J34B*/                             /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                             /* FROM pt_mstr TO ptmstr             */
/*J036*/                             {gprun.i ""bmcsruc.p""
                                     "(input recid(sct_det),
                                       input recid(ps_mstr),
                                       input recid(ptmstr ),
                                       input recid(ptp_det),
                                       input level,
                                       input ""99"",
                                       input ""2"")"}
                                 end.

                                 else if w45_flag then do for wkfl-45:
/*J036                               for each wkfl-45:    **/
/*J036                                  {bmcsrub2.i}      **/
/*J036                               end.                 **/
/*J34B*/                            /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                            /* FROM pt_mstr TO ptmstr             */
/*J036*/                            {gprun.i ""bmcsruc.p""
                                    "(input recid(sct_det),
                                      input recid(ps_mstr),
                                      input recid(ptmstr ),
                                      input recid(ptp_det),
                                      input level,
                                      input ""45"",
                                      input ""2"")"}
                                 end.

                                 else if w30_flag then do for wkfl-30:
/*J036                               for each wkfl-30:    **/
/*J036                                  {bmcsrub2.i}      **/
/*J036                               end.                 **/
/*J34B*/                            /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                            /* FROM pt_mstr TO ptmstr             */
/*J036*/                            {gprun.i ""bmcsruc.p""
                                    "(input recid(sct_det),
                                      input recid(ps_mstr),
                                      input recid(ptmstr ),
                                      input recid(ptp_det),
                                      input level,
                                      input ""30"",
                                      input ""2"")"}
                                 end.

                                 else do:
/*J036                               for each wkfl-13:    **/
/*J036                                  {bmcsrub2.i}      **/
/*J036                               end.                 **/
/*J34B*/                             /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                             /* FROM pt_mstr TO ptmstr             */
/*J036*/                             {gprun.i ""bmcsruc.p""
                                     "(input recid(sct_det),
                                       input recid(ps_mstr),
                                       input recid(ptmstr ),
                                       input recid(ptp_det),
                                       input level,
                                       input ""13"",
                                       input ""2"")"}
                                 end.

/*G681*/                         sct_rollup_id = rollup_id.

/*J2YM*/                         /* BEGIN ADD SECTION */

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

/*J2YM*/                         /* END ADD SECTION */

/*J0H0*/                         /* BEGIN ADDED SECTION*/
                                 do for ps_mstr1:
                                    /* UPDATE THIS LEVEL COSTS ON CO-PRODUCTS */
                                    bom_code =
                                       if available ptp_det then ptp_bom_code
/*J34B**                               else pt_bom_code. */
/*J34B*/                               else ptmstr.pt_bom_code.

/*J34B**                            find first ps_mstr1 where */
/*J34B*/                            for  first ps_mstr1 where
/*J34B**                            ps_mstr1.ps_par = pt_part */
/*J34B*/                            ps_mstr1.ps_par = ptmstr.pt_part
                                    and ps_mstr1.ps_comp = bom_code
                                    and ps_mstr1.ps_joint_type = "1"
                                    and (eff_date = ?
                                    or (eff_date <> ?
                                       and (ps_mstr1.ps_start = ? or
                                            ps_mstr1.ps_start <= eff_date)
                                       and (ps_mstr1.ps_end = ? or
                                            eff_date <= ps_mstr1.ps_end)))
/*J34B**                            no-lock no-error. */
/*J34B*/                            no-lock: end.

                                    if available ps_mstr1 then do:
                                       /* THIS LVL COSTS ALREADY IN spt_det, */
                                       /* COPY TO sct_det.                   */
                                       assign
                                       sct_mtl_tl = 0
                                       sct_lbr_tl = 0
                                       sct_bdn_tl = 0
                                       sct_ovh_tl = 0
                                       sct_sub_tl = 0.

                                       for each spt_det where
                                       spt_site = sct_site
                                       and spt_sim = sct_sim
                                       and spt_part = sct_part:
                                           if (not spt_ao and
                                           spt_cst_tl = 0 and spt_cst_ll = 0
                                           and spt_pct_ll
                                               <> truncate(spt_pct_ll,0))
                                           then delete spt_det.

                                           /* spt_pct_ll INDICATES TL & LL */
                                           /* MAT,LAB,BDN,OHD,SUB          */
                                           else if truncate(spt_pct_ll,0) = 1
                                           then sct_mtl_tl = sct_mtl_tl
                                                           + spt_cst_tl.
                                           else if truncate(spt_pct_ll,0) = 2
                                           then sct_lbr_tl = sct_lbr_tl
                                                           + spt_cst_tl.
                                           else if truncate(spt_pct_ll,0) = 3
                                           then sct_bdn_tl = sct_bdn_tl
                                                           + spt_cst_tl.
                                           else if truncate(spt_pct_ll,0) = 4
                                           then sct_ovh_tl = sct_ovh_tl
                                                           + spt_cst_tl.
                                           else if truncate(spt_pct_ll,0) = 5
                                           then sct_sub_tl = sct_sub_tl
                                                           + spt_cst_tl.
                                       end.
                                    end.
                                 end. /* do for */
/*J0H0*/                         /* END ADDED SECTION*/

/*J34B*/                         assign
                                    sct_mtl_ll = 0
                                    sct_lbr_ll = 0
                                    sct_bdn_ll = 0
                                    sct_ovh_ll = 0
                                    sct_sub_ll = 0.

                                 /*! INTERPRET COST ELEMENT TYPE FOR spd_det  *
                                  *  AND ADD THE COST TO THE APPROPRIATE      *
                                  *  FIELD IN sct_det.                        */
                                 for each spt_det where spt_site = sct_site
                                 and spt_sim = sct_sim and spt_part = sct_part:
                                    if (not spt_ao and spt_cst_tl = 0
                                    and spt_cst_ll = 0
                                    and spt_pct_ll <> truncate(spt_pct_ll,0))
                                    then delete spt_det.

                                    else if truncate(spt_pct_ll,0) = 1 then
                                       sct_mtl_ll = sct_mtl_ll + spt_cst_ll.
                                    else if truncate(spt_pct_ll,0) = 2 then
                                       sct_lbr_ll = sct_lbr_ll + spt_cst_ll.
                                    else if truncate(spt_pct_ll,0) = 3 then
                                       sct_bdn_ll = sct_bdn_ll + spt_cst_ll.
                                    else if truncate(spt_pct_ll,0) = 4 then
                                       sct_ovh_ll = sct_ovh_ll + spt_cst_ll.
                                    else if truncate(spt_pct_ll,0) = 5 then
                                       sct_sub_ll = sct_sub_ll + spt_cst_ll.
                                 end.  /* for each spd_det */
/*G681*/                         /*** ADDED PRECEDING SECTIONS***********/

                                 /*! UPDATE TOTAL IF ANY ELEMENT AMOUNT HAS   *
                                  *  CHANGED.                                 */
/*J2YM** BEGIN DELETE SECTION
 * /*F116*/                      if ((oldmtl <> sct_mtl_ll)
 * /*F116*/                      or (oldlbr <> sct_lbr_ll)
 * /*F116*/                      or (oldbdn <> sct_bdn_ll)
 * /*F116*/                      or (oldovh <> sct_ovh_ll)
 * /*F116*/                      or (oldsub <> sct_sub_ll))
 * /*F116*/                      or (cst_flag) then do:
 *J2YM** END DELETE SECTION */

/*J2YM*/                         if ((oldmtl_ll <> sct_mtl_ll)
/*J2YM*/                         or (oldlbr_ll <> sct_lbr_ll)
/*J2YM*/                         or (oldbdn_ll <> sct_bdn_ll)
/*J2YM*/                         or (oldovh_ll <> sct_ovh_ll)
/*J2YM*/                         or (oldsub_ll <> sct_sub_ll))
/*J2YM*/                         or (cst_flag) then do:
                                    sct_cst_tot = sct_mtl_tl + sct_lbr_tl
                                                + sct_bdn_tl + sct_ovh_tl
                                                + sct_sub_tl + sct_mtl_ll
                                                + sct_lbr_ll + sct_bdn_ll
                                                + sct_ovh_ll + sct_sub_ll.
/*F116*/                            sct_cst_date = today.
/*F116*/                         end. /* if ((oldmtl . . . */

/*J2YM** BEGIN DELETE SECTION
 * /*F116*/                      oldmtl = oldmtl + sct_mtl_tl.
 * /*F116*/                      oldlbr = oldlbr + sct_lbr_tl.
 * /*F116*/                      oldbdn = oldbdn + sct_bdn_tl.
 * /*F116*/                      oldovh = oldovh + sct_ovh_tl.
 * /*F116*/                      oldsub = oldsub + sct_sub_tl.
 *J2YM** END DELETE SECTION */

                                 /*! IF THE COST HAS CHANGED THEN REPORT THE  *
                                  *  ITEM AND CREATE ANY NECESSARY G/L        *
                                  *  TRANSACTIONS.                            */
                                 if sct_cst_tot <> oldcst then do:
/*F116                              sct_cst_date = today.    */
                                    if not available icc_ctrl then
/*J34B**                            find first icc_ctrl no-lock. */
/*J34B*/                            for  first icc_ctrl no-lock: end.

/*J34B**                            BEGIN DELETE
 *                                  find in_mstr no-lock where in_part = pt_part
 *                                  and in_site = site no-error.
 *J34B**                            END DELETE */

/*J34B*/                            for first in_mstr no-lock
/*J34B*/                            where in_part = ptmstr.pt_part
/*J34B*/                            and in_site = site: end.

                                    if available in_mstr
                                    and (in_gl_set = sct_sim
                                     or (sct_sim = icc_gl_set
                                         and in_gl_set = ""))
                                    then do:
/*F857                                    cracct = "DSCR".  */
/*J054* *F857*                            cracct = "CCHG".            */
/*J054*                                   insite = in_site.           */
/*J054*                                   sct_recno = recid(sct_det). */
/*J34B** /*J1F2*/                       pt_recno  = recid(pt_mstr).   */
/*J34B*/                                pt_recno  = recid(ptmstr).

/*J054*/                                /*DE-COUPLE PROGRAMS FOR OBJECTS*/
/*J054*                                 {gprun.i ""iccstinv.p""}        */
/*J054*/                                {gprun.i 'iccstinv.p'
                                        "(input oldcst,
                                          input recid(sct_det),
                                          input 'CCHG',
                                          input in_site)" }
                                    end.  /* if available in_mstr */

                                    if audit_yn then do with frame b
                                    width 132 down:
/*G681*/                               /*! MOVED PRINTING ALGORITHM */
/*J34B*/                               /* MODIFIED THE FIRST INPUT PARAMETER */
/*J34B*/                               /* FROM pt_mstr TO ptmstr             */
/*G681*/                               {gprun.i ""bmcsrub1.p""
                                       "(input recid(ptmstr),
                                         input recid(sct_det),
                                         input oldcst)" }
                                    end.  /* if audit_yn */
                                 end.  /* if sct_cst_tot <> oldcst */
                              end.  /* if available pt_mstr and not rolled_yn */

                              /*F345* start of added section */
                              /*! IF WE ARE DEALING WITH A BOM THAT HAS NO    *
                               *  CORRESPONDING ITEM MASTER RECORD, TRACK      *
                               *  COSTS LOCALLY.                              */
                              else do:

/*G2QC*/                         /* Added section */
                                 /* Track the setup time for valid items
                                    already rolled up. */
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
/*J34B**                            else if available pt_mstr then do: */
/*J34B*/                            else if available ptmstr then do:
                                       setup_time[level] = 0.
                                       if ps_ps_code <> "O"
/*J34B**                               BEGIN DELETE
 *                                     and pt_pm_code <> "P"
 *                                     and pt_pm_code <> "D"
 *J34B**                               END DELETE */
/*J34B*/                               and ptmstr.pt_pm_code <> "P"
/*J34B*/                               and ptmstr.pt_pm_code <> "D"
                                       then
/*J34B**                                  BEGIN DELETE
 *                                        setup_time[level] = pt_setup_ll
 *                                           + if not pt_phantom
 *                                             then pt_setup else 0.
 *J34B**                                  END DELETE */
/*J34B*/                                  setup_time[level] = ptmstr.pt_setup_ll
/*J34B*/                                     + if not ptmstr.pt_phantom
/*J34B*/                                       then ptmstr.pt_setup else 0.
                                    end. /* else available pt_mstr */
                                 end. /* if setup_flag */

                                 /* Track the labor time for valid items
                                    already rolled up.  Note that the product
                                    structure quantity will be used down below
                                    this block when it gets rolled into the
                                    next level of the array (instead of here).
                                    */
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
/*J34B**                            else if available pt_mstr then do: */
/*J34B*/                            else if available ptmstr then do:
                                       labor_time[level] = 0.
                                       if ps_ps_code <> "O"
/*J34B**                               BEGIN DELETE
 *                                     and pt_pm_code <> "P"
 *                                     and pt_pm_code <> "D"
 *J34B**                               END DELETE */
/*J34B*/                               and ptmstr.pt_pm_code <> "P"
/*J34B*/                               and ptmstr.pt_pm_code <> "D"
                                       then
/*J34B**                                  BEGIN DELETE
 *                                        labor_time[level] = pt_run_ll
 *                                             + if not pt_phantom
 *                                               then pt_run else 0.
 *J34B**                                  END DELETE */
/*J34B*/                                  labor_time[level] = ptmstr.pt_run_ll
/*J34B*/                                       + if not ptmstr.pt_phantom
/*J34B*/                                         then ptmstr.pt_run else 0.
                                    end. /* else available pt_mstr */
                                 end. /* if labor_flag */
/*G2QC*/                         /* End of added section */

                                 /* Push this level setup and labor time
                                    into the higher level. */
                                 if ps_ps_code <> "O" then
                                 assign
                                 setup_time[level - 1] = setup_time[level - 1]
                                                       + setup_time[level]
                                 labor_time[level - 1] = labor_time[level - 1]
                                                       + labor_time[level]
                                                       * ps_qty_per.

/*G681*                          sub_ll [level - 1] = sub_ll [level - 1]   */
/*G681*                            + (sub_ll [level] * ps_qty_per          */
/*G681*                            * (100 /  (100 - ps_scrp_pct)))         */
/*G681*                          ovh_ll [level - 1] = ovh_ll [level - 1]   */
/*G681*                            + (ovh_ll [level] * ps_qty_per          */
/*G681*                            * (100 /  (100 - ps_scrp_pct)))         */
/*G681*                          bdn_ll [level - 1] = bdn_ll [level - 1]   */
/*G681*                            + (bdn_ll [level] * ps_qty_per          */
/*G681*                            * (100 /  (100 - ps_scrp_pct)))         */
/*G681*                          lbr_ll [level - 1] = lbr_ll [level - 1]   */
/*G681*                            + (lbr_ll [level] * ps_qty_per          */
/*G681*                            * (100 /  (100 - ps_scrp_pct)))         */
/*G681*                          mtl_ll [level - 1] = mtl_ll [level - 1]   */
/*G681*                            + (mtl_ll [level] * ps_qty_per          */
/*G681*                            * (100 /  (100 - ps_scrp_pct))).        */

/*J34B**                         BEGIN DELETE
 * /*FT70*/                      if available pt_mstr then
 * /*FT70*/                         pt_recid = recid(pt_mstr).
 *J34B**                         END DELETE */
/*J34B*/                         if available ptmstr then
/*J34B*/                            pt_recid = recid(ptmstr).
/*G0SD*/                         else pt_recid = ?.
/*FT70*/                         if available ps_mstr then
/*FT70*/                            ps_recid = recid(ps_mstr).
/*G0SD*/                         else ps_recid = ?.

/*FT70*/                         /* program split due to compile size */
/*FT70*/                         {gprun.i ""bmcsrub5.p""}

/*FT70*******************        THE FOLLOWING CODE WAS MOVED TO BMCSRUB5.P
 *                      *
/*G681*/                *        if w99_flag then do:
/*G681*/                *           for each wkfl-99:
/*G681*/                *             {bmcsrub4.i}
/*G681*/                *           end.
/*G681*/                *        end.
                        *
/*G681*/                *        else if w45_flag then do:
/*G681*/                *           for each wkfl-45:
/*G681*/                *             {bmcsrub4.i}
/*G681*/                *           end.
/*G681*/                *        end.
                        *
/*G681*/                *        else if w30_flag then do:
/*G681*/                *           for each wkfl-30:
/*G681*/                *             {bmcsrub4.i}
/*G681*/                *           end.
/*G681*/                *        end.
                        *
/*G681*/                *        else do:
/*G681*/                *           for each wkfl-13:
/*G681*/                *             {bmcsrub4.i}
/*G681*/                *           end.
/*G681*/                *        end.
**FT70*******************/

                                 assign
                                    setup_time[level] = 0
                                    labor_time[level] = 0.

/*G681*                             sub_ll [level] = 0  */
/*G681*                             ovh_ll [level] = 0  */
/*G681*                             bdn_ll [level] = 0  */
/*G681*                             lbr_ll [level] = 0  */
/*G681*                             mtl_ll [level] = 0. */
                              end.  /* else do */
                              /*F345* end of added section */

                           end. /*if avail ps_mstr*/

                           rolled_yn = no.
                           comp = ps_par.

                           find next ps_mstr use-index ps_parcomp
                           where ps_par = comp no-lock no-error.

                           if available ps_mstr then leave.
                        end. /*psloop: repeat with frame b*/ /* nest level 3 */
                     end. /* if not available ps_mstr */

                     /*! IF WE ARE DONE WITH THIS iTEM, THEN LEAVE */
                     if level < 2 then leave.

                     /*! BLOW THROUGH PRODUCT STRUCTURE TO NEXT LEVEL. IF     *
                      *  EFFECTIVE DATE HAS BEEN CHANGED TO ?, INCLUDE ALL    *
                      *  COMPONENTS, REGARDLESS OF DATE RANGES.               */
                     if (eff_date = ? or (eff_date <> ?
                     and (ps_start = ? or ps_start <= eff_date)
                     and (ps_end = ? or eff_date <= ps_end)))
                     and (ps_ps_code = "" or ps_ps_code = "X"
                      or ps_ps_code = "O")
                     then do:

                        record[level] = recid(ps_mstr).

                        if level < max_level or max_level = 0 then do:
                           comp = ps_comp.


/*J34B**                   BEGIN DELETE
 * /*F345*/                find ptp_det no-lock where ptp_part = comp
 * /*F345*/                and ptp_site = site no-error.
 *J34B**                   END DELETE */

/*K21S** BEGIN DELETE
 *
 * /*J34B*/                   for first ptp_det no-lock where ptp_part = comp
 * /*J34B*/                   and ptp_site = site: end.
 *
 *                            /*! IDENTIFY BOM AND ROUTINGS */
 * /*F345*/                   if available ptp_det then do:
 * /*F345*/                      if ptp_bom_code <> "" then comp = ptp_bom_code.
 *
 *                            /*! IGNORE ROUTINGS FOR GLOBAL PHANTOMS */
 * /*G1CY*/                      if ptp_phantom then
 * /*G1CY*/                         ptroute[level] = "".
 * /*G1CY*/                      else if ptp_routing <> "" then
 * /*G1CY*/                         ptroute[level] = ptp_routing.
 * /*G1CY*/                      else
 * /*G1CY*/                         ptroute[level] = ptp_part.
 * /*F345*/                   end.
 * /*F345*/                   else do:
 *K21S** END DELETE */

/*G294*
**F345**                      find ptmstr no-lock where pt_part = comp no-error.
**F345**                      if pt_bom_code <> "" then comp = pt_bom_code. */

/*J34B**                      BEGIN DELETE
 * /*G294*/                   find ptmstr no-lock where
 * /*G294*/                   ptmstr.pt_part = comp no-error.
 *J34B**                      END DELETE */

/*K21S** BEGIN DELETE
 *
 * /*J34B*/                   for first ptmstr
 * /*J34B*/                   fields (pt_bom_code pt_group pt_part pt_part_type
 * /*J34B*/                      pt_phantom pt_pm_code pt_prod_line pt_routing
 * /*J34B*/                      pt_run pt_run_ll pt_setup pt_setup_ll
 * /*J34B*/                      pt_yield_pct)
 * /*J34B*/                      no-lock where ptmstr.pt_part = ps_comp: end.
 *
 *K21S** END DELETE */

/*G1CY** /*G294*/                      if available ptmstr then **/

/*K21S** BEGIN DELETE
 * /*G1CY*/                      if available ptmstr then do:
 * /*G294*/                         if ptmstr.pt_bom_code <> "" then
 * /*G294*/                            comp = ptmstr.pt_bom_code.
 *
 *                                  /*! IGNORE ROUTINGS FOR GLOBAL PHANTOMS */
 * /*G1CY*/                         if pt_phantom then
 * /*G1CY*/                            ptroute[level] = "".
 * /*G1CY*/                         else if ptmstr.pt_routing <> "" then
 * /*G1CY*/                            ptroute[level] = ptmstr.pt_routing.
 * /*G1CY*/                         else
 * /*G1CY*/                            ptroute[level] = ptmstr.pt_part.
 * /*G1CY*/                      end.
 *                          /*! IGNORE ROUTING IF BOM CODE AND NO ITEM MSTR */
 * /*G1CY*/                      else
 * /*G1CY*/                         ptroute[level] = "".
 * /*F345*/                   end. /* else do */
 *
 *K21S** END DELETE */

/*K21S*/             /* BEGIN ADD SECTION */

                     /* CALLED PROCEDURE GET-BOMCODE-ROUTING TO GET CORRECT */
                     /* BOMCODE AND ROUTING FOR COMPONENT                   */

                     do for ptpdet :

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

                        run get-bomcode-routing0( input  comp       ,
                                                 input  site       ,
                                                 input  chk_phantom,
                                                 input  eff_date   ,
                                                 buffer ptpdet     ,
                                                 buffer ptmstr1    ,
                                                 input-output comp ,
                                                 output ptroute[level]).
                     end. /*DO FOR PTPDET*/

/*K21S*/             /* END ADD SECTION */

                           /*! IGNORE ROUTINGS FOR LOCAL PHANTOMS */
/*G1CY*/                   if ps_ps_code = "x" then ptroute[level] = "".

/*J34B*/                   assign
                              level = level + 1
/*G681*/                      m_level = max(m_level, level).

/*G681*/                   /*! WHEN LEVEL > 12 SWITCH FROM WKFL-13 TO WKFL-30*/
/*G681*/                   if
/*G681*/                   (m_level > 12 and m_level <= 29)
/*G681*/                   and w13_flag
/*G681*/                   and not w30_flag
/*G681*/                   and not w45_flag
/*G681*/                   and not w99_flag then do:

/*FS91* /*G681*/              for each wkfl-13:*/
/*FS91*/                      for each wkfl-13 exclusive-lock:
/*G681*/                         create wkfl-30.
/*G681*/                         assign wkfl-30.element = wkfl-13.element
/*G681*/                                wkfl-30.cat     = wkfl-13.cat.
/*G681*/                         do i = 1 to 13:
/*G681*/                            wkfl-30.cst_ll[i]  = wkfl-13.cst_ll[i].
/*G681*/                         end.
/*G681*/                         delete wkfl-13.
/*G681*/                      end. /* for each wkfl-13 */
/*G681*/                      w30_flag = yes.
/*G681*/                   end. /* if m_level > 12 */

/*G681*/                   /*! WHEN LEVEL > 29 SWITCH FROM WKFL-30 TO WKFL-45*/
/*G681*/                   else if
/*G681*/                   (m_level > 29 and m_level <= 45)
/*G681*/                   and w30_flag
/*G681*/                   and not w45_flag
/*G681*/                   and not w99_flag then do:

/*FS91* /*G681*/              for each wkfl-30:*/
/*FS91*/                      for each wkfl-30 exclusive-lock:
/*G681*/                         create wkfl-45.
/*G681*/                         assign wkfl-45.element = wkfl-30.element
/*G681*/                                wkfl-45.cat     = wkfl-30.cat.
/*G681*/                         do i = 1 to 30:
/*G681*/                            wkfl-45.cst_ll[i]  = wkfl-30.cst_ll[i].
/*G681*/                         end.
/*G681*/                         delete wkfl-30.
/*G681*/                      end. /* for eack wkfl-30 */
/*G681*/                      w45_flag = yes.
/*G681*/                   end. /* else if m_level > 29 */

/*G681*/                   /*WHEN LEVEL > 44 SWITCH FROM WKFL-45 TO WKFL-99*/
/*G681*/                   else if
/*G681*/                   (m_level > 44)
/*G681*/                   and w45_flag
/*G681*/                   and not w99_flag then do:

/*FS91* /*G681*/              for each wkfl-45:*/
/*FS91*/                      for each wkfl-45 exclusive-lock:
/*G681*/                         create wkfl-99.
/*G681*/                         assign wkfl-99.element = wkfl-45.element
/*G681*/                                wkfl-99.cat     = wkfl-45.cat.
/*G681*/                         do i = 1 to 45:
/*G681*/                            wkfl-99.cst_ll[i]  = wkfl-45.cst_ll[i].
/*G681*/                         end.
/*G681*/                         delete wkfl-45.
/*G681*/                      end. /* for each wkfl-45 */
/*G681*/                      w99_flag = yes.
/*G681*/                   end. /* else if m_level > 44 */

/*G681*/                   /*! IF THE COMPONENT HAS ALREADY BEEN ROLLED UP, */
/*G681*/                   /*! GUARANTEE THAT                               */
/*G681*/                   /*! A PS_MSTR RECORD IS NOT AVAILABLE            */
/*G2QC****
/*G681*/ *                 {bmcssct.i &comp=comp}
**G2QC****/
                           /* Decide if ps_comp has already had its costs
                              rolled up for this site and cost set. Note that
                              it is the component item number that is checked
                              instead of its BOM code.  If we need to blow
                              down through a component, its BOM code is used,
                              but having calculated the cost of the BOM code
                              does not automatically update the cost of the
                              component. */
/*G2QC*/                   {bmcssct.i &comp=ps_comp}

/*G681*/                   if rolled_yn
/*G681*/                   then
/*G681*/                      release ps_mstr.
/*G681*/                   else
                           find first ps_mstr use-index ps_parcomp
                           where ps_par = comp no-lock no-error.
                        end. /* if level < max_level */
                        else do:
                           find next ps_mstr use-index ps_parcomp
                           where ps_par = comp no-lock no-error.
                        end.
                     end. /* if eff_date = ? */

                     else do:

                        find next ps_mstr use-index ps_parcomp
                        where ps_par = comp no-lock no-error.
                     end.
                  end. /* comploop: repeat with frame b */ /* nest level 2 */

                  /*! ROLL UP SETUP AND LABOR TIMES */
/*G700*/          if (setup_flag or labor_flag)
/*G700*/          and not can-find (ptp_det where ptp_part = parent
/*G700*/          and ptp_site = site) then
/*J34B**          find pt_mstr exclusive-lock where pt_part = parent */
/*J34B*/          find ptmstr exclusive-lock where ptmstr.pt_part = parent
                  no-error.
/*J34B** /*G700*/ else find pt_mstr no-lock where pt_part = parent no-error. */
/*J34B*/          else for first ptmstr
/*J34B*/               fields (pt_bom_code pt_group pt_part pt_part_type
/*J34B*/               pt_phantom pt_pm_code pt_prod_line pt_routing
/*J34B*/               pt_run pt_run_ll pt_setup pt_setup_ll pt_yield_pct)
/*J34B*/               no-lock where ptmstr.pt_part = parent: end.
/*J34B**          if available pt_mstr then do: */
/*J34B*/          if available ptmstr then do:

/*G700*/             if (setup_flag or labor_flag) then
/*J34B**                BEGIN DELETE
 * /*F345*/             find ptp_det exclusive-lock where ptp_part = pt_part
 * /*F345*/             and ptp_site = site no-error.
 *J34B**                END DELETE */
/*J34B*/                for first ptp_det exclusive-lock where
/*J34B*/                ptp_part = ptmstr.pt_part
/*J34B*/                and ptp_site = site: end.
/*G700*/             else
/*J34B**                BEGIN DELETE
 * /*G700*/             find ptp_det no-lock where ptp_part = pt_part
 * /*G700*/             and ptp_site = site no-error.
 *J34B**                END DELETE */

/*J34B*/                for first ptp_det no-lock
/*J34B*/                where ptp_part = ptmstr.pt_part
/*J34B*/                and ptp_site = site: end.

/*L0YY** BEGIN DELETE
 * /*F542*/             if available ptp_det then yield_pct = ptp_yld_pct.
 * /*J34B** /*F542*/    else yield_pct = pt_yield. */
 * /*J34B*/             else yield_pct = ptmstr.pt_yield.
 * /*F542*/             if not yield_flag or yield_pct = 0 then
 *                         yield_pct = 100.
 *L0YY** END DELETE */

/*J34B*/             /* MODIFIED THE FIRST PARAMETER FROM     */
/*J34B*/             /* &part=pt_part TO &part=ptmstr.pt_part */
                     {gpsct01.i &part=ptmstr.pt_part &set=csset &site=site}

                     oldcst = sct_cst_tot.

/*FS91*              for each sctold:*/
/*FS91*/             for each sctold exclusive-lock:
                        delete sctold.
                     end.

                     create sctold.
                     assign
/*F116*                 oldmtl = sct_mtl_tl + sct_mtl_ll */
/*F116*                 oldlbr = sct_lbr_tl + sct_lbr_ll */
/*F116*                 oldbdn = sct_bdn_tl + sct_bdn_ll */
/*F116*                 oldovh = sct_ovh_tl + sct_ovh_ll */
/*F116*                 oldsub = sct_sub_tl + sct_sub_ll.*/
/*F116*/                oldmtl = sct_mtl_ll
/*F116*/                oldlbr = sct_lbr_ll
/*F116*/                oldbdn = sct_bdn_ll
/*F116*/                oldovh = sct_ovh_ll
/*F116*/                oldsub = sct_sub_ll.

/*F345*/             if available ptp_det then do:
/*F345*/                if setup_flag then ptp_setup_ll = setup_time[1].
/*F345*/                if labor_flag then ptp_run_ll = labor_time[1].
/*F345*/             end.
/*F345*/             else do:
/*J34B**                BEGIN DELETE
 *                      if setup_flag then pt_setup_ll = setup_time[1].
 *                      if labor_flag then pt_run_ll = labor_time[1].
 *J34B**                END DELETE */
/*J34B*/                if setup_flag then ptmstr.pt_setup_ll = setup_time[1].
/*J34B*/                if labor_flag then ptmstr.pt_run_ll   = labor_time[1].
/*F345*/             end.

/*G681*******************DELETED FOLLOWING SECTIONS************************
./*F345*  if pt_pm_code <> "P" then do: */
./*F345*/ if (available ptp_det and ptp_pm_code <> "P" and ptp_pm_code <> "D")
./*F345*/ or (not available ptp_det and pt_pm_code <> "P" and pt_pm_code <> "D")
./*F345*/ then do:
.            if sub_flag then sct_sub_ll = sub_ll [1]
./*F542*/                                / (yield_pct * .01).
.            if ovh_flag then sct_ovh_ll = ovh_ll [1]
./*F542*/                                / (yield_pct * .01).
.            if bdn_flag then sct_bdn_ll = bdn_ll [1]
./*F542*/                                / (yield_pct * .01).
.            if lbr_flag then sct_lbr_ll = lbr_ll [1]
./*F542*/                                / (yield_pct * .01).
.            if mtl_flag then sct_mtl_ll = mtl_ll [1].
./*F779/*F542*/                          / (yield_pct * .01). */
.         end.
.         else do:
.            if sub_flag then sct_sub_ll = 0.
.            if ovh_flag then sct_ovh_ll = 0.
.            if bdn_flag then sct_bdn_ll = 0.
.            if lbr_flag then sct_lbr_ll = 0.
.            if mtl_flag then sct_mtl_ll = 0.
.         end.
**G681*******************DELETED PRECEDING SECTIONS***********************/

/*G681*/             /**********ADDED FOLLOWING SECTIONS**************/
                     if sct_rollup_id = rollup_id or sct_rollup then
                     leave parcost.

/*J036*/             /*CONVERTED THE FOLLOWING .I CALLS TO .P CALLS*/
                     if w99_flag then do for wkfl-99:
/*J036                   for each wkfl-99:    **/
/*J036                      {bmcsrub3.i}      **/
/*J036                   end.                 **/
/*J34B*/                /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                /* FROM pt_mstr TO ptmstr             */
/*J036*/                {gprun.i ""bmcsruc.p"" "(input recid(sct_det),
                         input recid(ps_mstr),
                         input recid(ptmstr ),
                         input recid(ptp_det),
                         input level,
                         input ""99"",
                         input ""3"")"}
                     end.

                     else if w45_flag then do for wkfl-45:
/*J036                   for each wkfl-45:    **/
/*J036                      {bmcsrub3.i}      **/
/*J036                   end.                 **/
/*J34B*/                /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                /* FROM pt_mstr TO ptmstr             */
/*J036*/                {gprun.i ""bmcsruc.p"" "(input recid(sct_det),
                         input recid(ps_mstr),
                         input recid(ptmstr ),
                         input recid(ptp_det),
                         input level,
                         input ""45"",
                         input ""3"")"}
                     end.

                     else if w30_flag then do for wkfl-30:
/*J036                    for each wkfl-30:     **/
/*J036                       {bmcsrub3.i}       **/
/*J036                    end.                  **/
/*J34B*/                /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                /* FROM pt_mstr TO ptmstr             */
/*J036*/                {gprun.i ""bmcsruc.p"" "(input recid(sct_det),
                         input recid(ps_mstr),
                         input recid(ptmstr ),
                         input recid(ptp_det),
                         input level,
                         input ""30"",
                         input ""3"")"}
                     end.

                     else do:
/*J036                   for each wkfl-13:      **/
/*J036                      {bmcsrub3.i}        **/
/*J036                   end.                   **/
/*J34B*/                /* MODIFIED THE THIRD INPUT PARAMETER */
/*J34B*/                /* FROM pt_mstr TO ptmstr             */
/*J036*/                {gprun.i ""bmcsruc.p"" "(input recid(sct_det),
                         input recid(ps_mstr),
                         input recid(ptmstr ),
                         input recid(ptp_det),
                         input level,
                         input ""13"",
                         input ""3"")"}
                     end.

/*J2YM*/             /* BEGIN ADD SECTION */

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

/*J2YM*/             /* END ADD SECTION */

/*J0H0*/             /* BEGIN ADDED SECTION*/
                     /* UPDATE THIS LEVEL COSTS ON CO-PRODUCTS */
                     bom_code = if available ptp_det then ptp_bom_code
/*J34B**                        else pt_bom_code. */
/*J34B*/                        else ptmstr.pt_bom_code.
/*J34B**             find first ps_mstr where ps_par = pt_part */
/*J34B*/             for first ps_mstr where ps_par = ptmstr.pt_part
                     and ps_comp = bom_code
                     and ps_joint_type = "1"
                     and (eff_date = ? or (eff_date <> ?
                     and (ps_start = ? or ps_start <= eff_date)
                     and (ps_end = ? or eff_date <= ps_end)))
/*J34B**             no-lock no-error. */
/*J34B*/             no-lock: end.

                     if available ps_mstr then do:
                        /*THIS LVL COSTS ALREADY IN spt_det, COPY TO sct_det.*/
                        assign
                           sct_mtl_tl = 0
                           sct_lbr_tl = 0
                           sct_bdn_tl = 0
                           sct_ovh_tl = 0
                           sct_sub_tl = 0.

                        for each spt_det where spt_site = sct_site
                        and spt_sim = sct_sim and spt_part = sct_part:
                           if (not spt_ao and spt_cst_tl = 0 and spt_cst_ll = 0
                           and spt_pct_ll <> truncate(spt_pct_ll,0))
                           then delete spt_det.

                           /* spt_pct_ll INDICATES TL & LL MAT,LAB,BDN,OHD,SUB*/
                           else if truncate(spt_pct_ll,0) = 1
                              then sct_mtl_tl = sct_mtl_tl + spt_cst_tl.
                           else if truncate(spt_pct_ll,0) = 2
                              then sct_lbr_tl = sct_lbr_tl + spt_cst_tl.
                           else if truncate(spt_pct_ll,0) = 3
                              then sct_bdn_tl = sct_bdn_tl + spt_cst_tl.
                           else if truncate(spt_pct_ll,0) = 4
                              then sct_ovh_tl = sct_ovh_tl + spt_cst_tl.
                           else if truncate(spt_pct_ll,0) = 5
                              then sct_sub_tl = sct_sub_tl + spt_cst_tl.
                        end.
                     end.
/*J0H0*/             /* END ADDED SECTION*/

/*J34B*/             assign
                        sct_mtl_ll = 0
                        sct_lbr_ll = 0
                        sct_bdn_ll = 0
                        sct_ovh_ll = 0
                        sct_sub_ll = 0.

                     for each spt_det where spt_site = sct_site
                     and spt_sim = sct_sim and spt_part = sct_part:
                        if (not spt_ao and spt_cst_tl = 0 and spt_cst_ll = 0
                        and spt_pct_ll <> truncate(spt_pct_ll,0))
                        then delete spt_det.

                        else if truncate(spt_pct_ll,0) = 1
                           then sct_mtl_ll = sct_mtl_ll + spt_cst_ll.
                        else if truncate(spt_pct_ll,0) = 2
                           then sct_lbr_ll = sct_lbr_ll + spt_cst_ll.
                        else if truncate(spt_pct_ll,0) = 3
                           then sct_bdn_ll = sct_bdn_ll + spt_cst_ll.
                        else if truncate(spt_pct_ll,0) = 4
                           then sct_ovh_ll = sct_ovh_ll + spt_cst_ll.
                        else if truncate(spt_pct_ll,0) = 5
                           then sct_sub_ll = sct_sub_ll + spt_cst_ll.
                     end.
/*G681*/             /******ADDED PRECEDING SECTIONS************************/

/*J2YM** BEGIN DELETE SECTION
 * /*F116*/          if ((oldmtl <> sct_mtl_ll) or (oldlbr <> sct_lbr_ll)
 * /*F116*/          or  (oldbdn <> sct_bdn_ll) or (oldovh <> sct_ovh_ll)
 * /*F116*/          or  (oldsub <> sct_sub_ll)) or (cst_flag) then do:
 *J2YM* END DELETE SECTION */

/*J2YM*/             if ((oldmtl_ll <> sct_mtl_ll)
/*J2YM*/             or (oldlbr_ll <> sct_lbr_ll)
/*J2YM*/             or (oldbdn_ll <> sct_bdn_ll)
/*J2YM*/             or (oldovh_ll <> sct_ovh_ll)
/*J2YM*/             or (oldsub_ll <> sct_sub_ll))
/*J2YM*/             or (cst_flag) then do:
                        sct_cst_tot = sct_mtl_tl + sct_lbr_tl
                                    + sct_bdn_tl + sct_ovh_tl
                                    + sct_sub_tl + sct_mtl_ll
                                    + sct_lbr_ll + sct_bdn_ll
                                    + sct_ovh_ll + sct_sub_ll.
/*F116*/                sct_cst_date = today.
/*F116*/             end.

/*J2YM** BEGIN DELETE SECTION
 * /*F116*/          oldmtl = oldmtl + sct_mtl_tl.
 * /*F116*/          oldlbr = oldlbr + sct_lbr_tl.
 * /*F116*/          oldbdn = oldbdn + sct_bdn_tl.
 * /*F116*/          oldovh = oldovh + sct_ovh_tl.
 * /*F116*/          oldsub = oldsub + sct_sub_tl.
 *J2YM** END DELETE SECTION */

                     /*! IF THE COST HAS CHANGED THEN REPORT THE ITEM AND     *
                      *  CREATE ANY NECESSARY G/L TRANSACTIONS.               */
                     if sct_cst_tot <> oldcst then do:
/*F116                  sct_cst_date = today.  */

                        if not available icc_ctrl
                        then find first icc_ctrl no-lock.

/*J34B**                BEGIN DELETE
 *                      find in_mstr no-lock where in_part = pt_part
 *                      and in_site = site no-error.
 *J34B**                END DELETE */
/*J34B*/                for first in_mstr no-lock where in_part = ptmstr.pt_part
/*J34B*/                and in_site = site: end.

                        if available in_mstr and (in_gl_set = sct_sim or
                        (sct_sim = icc_gl_set and in_gl_set = "")) then do:
/*F857                       cracct = "DSCR".  */
/*J054* *F857*               cracct = "CCHG".        */
/*J054*                      insite = in_site.           */
/*J054*                      sct_recno = recid(sct_det). */

/*J34B** /*J1F2*/           pt_recno  = recid(pt_mstr).  */
/*J34B*/                    pt_recno  = recid(ptmstr).

/*J054*/                    /*DE-COUPLE PROGRAMS FOR OBJECTS*/
/*J054*                     {gprun.i ""iccstinv.p""}        */
/*J054*/                    {gprun.i 'iccstinv.p'
                            "(input oldcst,
                              input recid(sct_det),
                              input 'CCHG',
                              input in_site)" }
                        end.

                        if audit_yn then do with frame b width 132 down:
/*G681*/                   /*MOVED PRINTING ALGORITHM TO BMCSRUB1.P*/
/*J34B*/                   /* MODIFIED THE FIRST PARAMETER FROM */
/*J34B*/                   /* pt_mstr TP ptmstr                 */
/*G681*/                   {gprun.i ""bmcsrub1.p"" "(input recid(ptmstr),
                             input recid(sct_det),
                             input oldcst)" }
                        end.  /*if audit_yn*/
                     end.  /*if sct_cst_tot <> oldcst*/
                  end.  /*if available pt_mstr*/
               end. /*parcost*/
/*FT70*/    end.  /*rollup_loop*/

            /*! FIND NEXT ITEM MATCHING SELECTION CRITERIA */
/*J34B**    BEGIN DELETE
 *          find next pt_mstr where pt_part >= part and pt_part <= part1
 * /*F345*/    and pt_prod_line >= line and pt_prod_line <= line1
 * /*F345*/    and pt_part_type >= type and pt_part_type <= type1
 * /*F345*/    and pt_group >= grp and pt_group <= grp1
 *          no-lock no-error.
 *J34B**    END DELETE */
/*J34B*/   end. /* for each pt_mstr */
         end. /* itemloop: repeat with frame b */

/*K21S*/ /* BEGIN ADD PROEDURE get-buffer */

         /* PURPOSE :                                                   */
         /* TO RETURN BUFFERS FOR PTPDET/PTMSTR FOR ITEM.               */

         /* INPUT PARAMETERS :                                          */
         /* 1. ITEM - TO FIND IN BUFFER OF PTPDET/PTMSTR                */
         /* 2. SITE - ITEM SPECIFIC                                     */

         /* OUTPUT PARAMETERS :                                         */
         /* 1. BUFFER PTPDET  - BUFFER OF PTP_DET FOR ITEM AT SITE      */
         /* 2. BUFFER PTMSTR1 - BUFFER OF PT_MSTR FOR ITEM              */

         /* LOGIC :                                                     */
         /* THIS PROCEDURE SEARCHES IN BUFFER OF PTPDET WITH BOTH INPUT */
         /* PARAMETERS. IF PTPDET RECORD  IS  UNAVAILABLE THEN IT       */
         /* SEARCHES IN BUFFER OF PTMSTR FOR ITEM. AFTER SEARCHIING ,   */
         /* PROCEDURE RETURNS BOTH BUFFERS FOR PTPDET AND PTMSTR .      */

         PROCEDURE get-buffer :


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
         if not available ptpdet then do :
            for first ptmstr1
               fields( pt_bom_code pt_group pt_part
                       pt_part_type pt_phantom pt_pm_code
                       pt_prod_line pt_routing pt_run
                       pt_run_ll pt_setup pt_setup_ll
                       pt_site pt_yield_pct)
               where ptmstr1.pt_part =  item
               no-lock:
            end. /*FOR FIRST PTMSTR1*/
         end. /*IF NOT AVAILABLE PTPDET*/
         return.
         END PROCEDURE.

/*K21S*/ /* END   ADD PROEDURE get-buffer */

/*K21S*/ /* BEGIN ADD PROEDURE is-coproduct  */


         /* PURPOSE :                                                  */
         /* TO DECIDE WHETHER GIVEN ITEM IS A CO-PRODUCT ITEM          */

         /* INPUT PARAMETERS :                                         */
         /* 1. ITEM1 - TO FIND  WHETHER THIS IS CO-PRODUCT ITEM        */
         /* 2. SITE1 - ITEM SPECIFIC                                   */
         /* 3. EFFDATE1 - USE TO CHECK IN PS_MSTR                      */

         /* OUTPUT PARAMETERS :                                        */
         /* 1. BUFFER PTPDET - BUFFER OF PTP_DET FOR ITEM AT SITE      */

         /* LOGIC :                                                    */
         /* THIS PROCEDURE SEARCHES ON PS_MSTR USING INPUT PARAMETERS  */
         /* AND CHECKS WHETHER ITEM IS A COPRODUCT ITEM. IF ITEM FOUND */
         /* TO BE A COPRODUCT ITEM THEN A FLAG COFLAG1 IS SET TO YES   */
         /* AND IS RETURNED BACK TO THE CALLING ROUTINE.               */

         PROCEDURE is-coproduct :

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
            no-lock  :
         end. /* FOR FIRST PS_MSTR */
         if available ps_mstr1 then
            coflag1 = yes .
         return.

         END PROCEDURE.

/*K21S*/ /* END ADD PROEDURE is-coproduct */

/*K21S*/ /* BEGIN ADD PROEDURE get-bomcode-routing */

         /* PURPOSE :                                                      */
         /* THIS PROCEDURE IS USED TO GET CORRECT ROUTING AND BOMCODE      */
         /* FOR THE ITEM AT SITE . THIS PROCEDURE ACCEPTS FOLLOWING INPUT  */
         /* PARAMETER AND RETURNS VALID BOMCODE AND ROUTING  for ITEM .    */

         /* INPUT PARAMETERS :                                             */
         /* 1. ITEM - FOR WHICH CORRECT ROUTING WILL BE SEARCHED           */
         /* 2. SITE - ITEM SPECIFIC                                        */
         /* 3. CHKPHANTOM  - FLAG ENSURES ASSIGNING ROUTING BLANK EVEN FOR */
         /*    TOP LEVEL PHANTOM AND IGNORING ROUTING FOR GLOBAL PHANTOM.  */
         /* 4. EFFDATE - USED FOR CHECKING CO-PRODUCT ITEM                 */
         /* 5. BUFFER PTPDET - BUFFER OF PTP_DET FOR ITEM AT SITE          */
         /* 6. BUFFER PTMSTR - BUFFER OF PT_MSTR FOR ITEM AT SITE          */

         /* OUTPUT PARAMETERS :                                            */
         /* 1. BOMCODE  - CORRECT BOMCODE FOR ITEM                         */
         /* 2. ROUTING  - CORRECT ROUTING FOR ITEM                         */

         /* LOGIC :                                                        */
         /* THIS PROCEDURE ASSUMES THAT PTPDET AND PTMASTER BUFFERS ARE    */
         /* AVAILABLE FOR THE ITEM AND SITE. WITH ITEM AND SITE AS INPUT   */
         /* PARAMETERS,IT SEARCHES IN PTPDET BUFFER . IF NOT AVAILABLE THEN*/
         /* IT SEARCHES IN PT_MSTR FOR GETTING BOMCODE AND ROUTING FOR     */
         /* ITEM.                                                          */
         /* AFTER THIS,PROCEDURE IS-COPRODUCT IS CALLED TO CHECK IF THE    */
         /* CURRENT ITEM IS A CO-PRODUCT ITEM. IF THE ITEM HPPENS TO BE A  */
         /* COPRODUCT ITEM THEN ROUTING OF IT'S BASE PROCESS WILL BE       */
         /* RETURNED AS A VALID ROUTING.                                   */

 /*0719
  * 不管PTP_BOM_CODE是否为空,BOM_CODE都取PT_PART
  */
         PROCEDURE get-bomcode-routing0 :

         define input  parameter item    like pt_part       no-undo .
         define input  parameter site    like pt_site       no-undo .
         define input  parameter chkphantom as logical      no-undo .
         define input  parameter effdate    as date         no-undo .
         define parameter buffer ptpdet  for  ptp_det .
         define parameter buffer ptmstr  for  pt_mstr .

/*K26M** define output parameter bomcode like pt_bom_code initial "" no-undo. */

/*K26M*/ define input-output parameter bomcode like pt_bom_code      no-undo.
         define output parameter routing like pt_routing  initial "" no-undo .

         define variable  coflag as logical initial no      no-undo .

         define buffer ptmstr2 for pt_mstr .
         define buffer ptpdet2 for ptp_det .

         /* GET BOMCODE AND ROUTING */


         if available ptpdet then do:

 /*0719           if ptpdet.ptp_bom_code <> "" then                 */
 /*0719              bomcode = ptpdet.ptp_bom_code .                */
 /*0719           else                                              */
               bomcode = ptpdet.ptp_part .

            if ptpdet.ptp_phantom and chk_phantom  then
               routing = "" .
            else if ptpdet.ptp_routing <> "" then
               routing = ptpdet.ptp_routing .
            else
               routing = ptpdet.ptp_part .

         end. /* IF AVAILABLE PTP_DET */
         else if available ptmstr then do:

  /*0719          if ptmstr.pt_bom_code <> "" then                  */
  /*0719             bomcode = ptmstr.pt_bom_code .                 */
  /*0719          else                                              */
               bomcode = ptmstr.pt_part.

            if ptmstr.pt_phantom and chk_phantom then
               routing = "" .
            else if ptmstr.pt_routing <> "" then
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

         if coflag then do :

            for first ptpdet2
               fields( ptp_bom_code ptp_part ptp_phantom
                       ptp_pm_code ptp_routing ptp_run
                       ptp_run_ll ptp_setup ptp_setup_ll
                       ptp_site ptp_yld_pct)
               where ptpdet2.ptp_part = bomcode
               and   ptpdet2.ptp_site = site
               no-lock:
            end. /* FOR FIRST PTPDET */

            if available ptpdet2 then do :
               If ptpdet2.ptp_routing <> "" then
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

/**0719 屏蔽标准过程**************************
 *          PROCEDURE get-bomcode-routing :
 *
 *          define input  parameter item    like pt_part       no-undo .
 *          define input  parameter site    like pt_site       no-undo .
 *          define input  parameter chkphantom as logical      no-undo .
 *          define input  parameter effdate    as date         no-undo .
 *          define parameter buffer ptpdet  for  ptp_det .
 *          define parameter buffer ptmstr  for  pt_mstr .
 *
 * /*K26M** define output parameter bomcode like pt_bom_code initial "" no-undo. */
 *
 * /*K26M*/ define input-output parameter bomcode like pt_bom_code      no-undo.
 *          define output parameter routing like pt_routing  initial "" no-undo .
 *
 *          define variable  coflag as logical initial no      no-undo .
 *
 *          define buffer ptmstr2 for pt_mstr .
 *          define buffer ptpdet2 for ptp_det .
 *
 *          /* GET BOMCODE AND ROUTING */
 *
 *
 *          if available ptpdet then do:
 *
 *             if ptpdet.ptp_bom_code <> "" then
 *                bomcode = ptpdet.ptp_bom_code .
 *             else
 *                bomcode = ptpdet.ptp_part .
 *
 *             if ptpdet.ptp_phantom and chk_phantom  then
 *                routing = "" .
 *             else if ptpdet.ptp_routing <> "" then
 *                routing = ptpdet.ptp_routing .
 *             else
 *                routing = ptpdet.ptp_part .
 *
 *          end. /* IF AVAILABLE PTP_DET */
 *          else if available ptmstr then do:
 *
 *             if ptmstr.pt_bom_code <> "" then
 *                bomcode = ptmstr.pt_bom_code .
 *             else
 *                bomcode = ptmstr.pt_part.
 *
 *             if ptmstr.pt_phantom and chk_phantom then
 *                routing = "" .
 *             else if ptmstr.pt_routing <> "" then
 *                routing = ptmstr.pt_routing .
 *             else
 *                routing = ptmstr.pt_part.
 *
 *          end. /*ELSE IF AVAILABLE PTMSTR1*/
 *
 *          /* TO CHECK IF ITEM IS A COPRODUCT ITEM */
 *
 *          run is-coproduct( input item    ,
 *                            input bomcode ,
 *                            input effdate ,
 *                            output coflag ) .
 *
 *          /* GETTING VALID ROUTING FOR BASE-PROCESS  */
 *
 *          if coflag then do :
 *
 *             for first ptpdet2
 *                fields( ptp_bom_code ptp_part ptp_phantom
 *                        ptp_pm_code ptp_routing ptp_run
 *                        ptp_run_ll ptp_setup ptp_setup_ll
 *                        ptp_site ptp_yld_pct)
 *                where ptpdet2.ptp_part = bomcode
 *                and   ptpdet2.ptp_site = site
 *                no-lock:
 *             end. /* FOR FIRST PTPDET */
 *
 *             if available ptpdet2 then do :
 *                If ptpdet2.ptp_routing <> "" then
 *                   routing = ptpdet2.ptp_routing .
 *                else
 *                   routing = ptpdet2.ptp_part .
 *             end. /* IF AVAILABLE PTPDET2 */
 *             else do:
 *
 *                for first ptmstr2
 *                   fields( pt_bom_code pt_group pt_part
 *                           pt_part_type pt_phantom pt_pm_code
 *                           pt_prod_line pt_routing pt_run
 *                           pt_run_ll pt_setup pt_setup_ll
 *                           pt_site pt_yield_pct)
 *                   where ptmstr2.pt_part =  bomcode
 *                   no-lock:
 *                end. /* FOR FIRST PTMSTR1 */
 *
 *                if ptmstr2.pt_routing <> "" then
 *                   routing = ptmstr2.pt_routing .
 *                else
 *                   routing = ptmstr2.pt_part .
 *
 *             end. /*IF NOT AVAILABLE PTPDET*/
 *
 *          end. /*IF COFLAG THEN*/
 *
 *          return .
 *
 *          END PROCEDURE.
**0719*****************/
/*K21S*/ /* END ADD PROEDURE get-bomcode-routing */
