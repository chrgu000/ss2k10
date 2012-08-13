/* xxbmcurlb.p - ROLL-UP BOM FOR RANGE OF ITEMS  COPPER WEIGHT */
/* Copyright 2004 Shanghai e-Steering Inc., Shanghai , CHINA                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *L0YY* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18     BY: Rajesh Thomas    DATE: 04/26/01  ECO: *K26M*        */
/* Revision: 1.19     BY: Katie Hilbert    DATE: 02/25/02  ECO: *N194*        */
/* Revision: 1.21     BY: Samir Bavkar     DATE: 04/12/02  ECO: *P000*        */
/* $Revision: 1.21.3.1 $    BY: Manish Dani      DATE: 06/10/03  ECO: *N2GT*        */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!                                *
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

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define variable cuitem      like ps_comp no-undo.
define variable cuqty       like ps_qty_per .
define variable comp        like ps_comp no-undo.
define variable parent      like ps_par no-undo.
define variable i           as integer.
define variable from_part   like sct_part no-undo.
define variable chk_phantom as logical no-undo.
define variable rndmthd     like gl_rnd_mthd no-undo.

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
define shared variable audit_yn like mfc_logical.


define buffer ptmstr   for pt_mstr.
define buffer ps_mstr1 for ps_mstr.

define new shared frame b.

/************************************************************/
/*PROGRAM NEEDS TO BE DIVIDED DUE TO R-CODE.                */
/************************************************************/
define workfile wkfl_99 no-undo
   field w99_part  like pt_part
   field w99_qty LIKE ps_qty_per 
    field w99_user  like mfguser .

define workfile wkfl_66 no-undo
   field w66_part  like pt_part
    field w66_qty LIKE ps_qty_per 
   field w66_user  like mfguser .

define workfile wkfl_33 no-undo
   field w33_part  like pt_part
    field w33_qty LIKE ps_qty_per 
   field w33_user  like mfguser .

assign
   glxcst = 0
   curcst = 100000.

FORM /*GUI*/ 
   pt_part format "x(25)"

  with STREAM-IO /*GUI*/  frame b width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

for first icc_ctrl no-lock:
     cuitem = icc_user1 .
end.


ASSIGN  
               cuqty = 0 .

FOR EACH pt_mstr EXCLUSIVE-LOCK:
    ASSIGN pt__dec01 = 0 
                  pt__log01 = NO .
END.

/*! UPDATE THE BOTTOM LEVEL FROM BOM DATA  */
/***从铜层起，倒数第一层The bottom level ，产生临时文件wkfl_99***/
FOR EACH ps_mstr WHERE ps_comp = cuitem 
       AND ( eff_date >= ps_start OR ps_start = ? ) AND ( eff_date <= ps_end OR ps_end = ? ) 
       BREAK BY ps_par :
       cuqty = cuqty + ps_qty_per * ( 1 + ps_scrp_pct / 100 ) .
       IF LAST-OF(ps_par) THEN DO:
           FIND FIRST pt_mstr WHERE pt_part = ps_par EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE pt_mstr  THEN
               ASSIGN pt__dec01 = cuqty 
                             pt__log01 = YES .
           ELSE DO:
                FIND FIRST bom_mstr WHERE bom_parent = ps_par EXCLUSIVE-LOCK NO-ERROR.
                
           END.
           FIND FIRST wkfl_99 WHERE w99_par = ps_par AND w99_user = mfguser NO-ERROR.
           IF NOT AVAILABLE wkfl_99  THEN DO:
               CREATE wkfl_99.
               ASSIGN w99_part = ps_par 
                              w99_qty  = cuqty 
                             w99_user = mfguser .
           END.
           cuqty = 0 .
       END.
END.

/*! 2 LOOP THROUGH ALL ITEMS IN SELECTION RANGE */
find first wkfl_99 where w99_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_99 THEN RUN is-wk99.
ELSE LEAVE .

/***3***/
find first wkfl_66 where w66_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_66 THEN RUN is-wk66.
ELSE LEAVE .

/***4***/
find first wkfl_33 where w33_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_33 THEN RUN is-wk33.
ELSE LEAVE .

/*! 5 LOOP THROUGH ALL ITEMS IN SELECTION RANGE */
find first wkfl_99 where w99_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_99 THEN RUN is-wk99.
ELSE LEAVE .

/***6***/
find first wkfl_66 where w66_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_66 THEN RUN is-wk66.
ELSE LEAVE .

/***7***/
find first wkfl_33 where w33_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_33 THEN RUN is-wk33.
ELSE LEAVE .


/*! 8 LOOP THROUGH ALL ITEMS IN SELECTION RANGE */
find first wkfl_99 where w99_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_99 THEN RUN is-wk99.
ELSE LEAVE .

/***9***/
find first wkfl_66 where w66_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_66 THEN RUN is-wk66.
ELSE LEAVE .

/***10***/
find first wkfl_33 where w33_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_33 THEN RUN is-wk33.
ELSE LEAVE .

/*! 11 LOOP THROUGH ALL ITEMS IN SELECTION RANGE */
find first wkfl_99 where w99_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_99 THEN RUN is-wk99.
ELSE LEAVE .

/***12***/
find first wkfl_66 where w66_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_66 THEN RUN is-wk66.
ELSE LEAVE .

/***13***/
find first wkfl_33 where w33_user  =  mfguser no-lock no-error.
IF AVAILABLE wkfl_33 THEN RUN is-wk33.
ELSE LEAVE .

PROCEDURE is-wk99:

    /***从铜层起，倒数第二层The lastest seconed level， 产生临时文件wkfl_66 ***/
    cuqty = 0 .
    for each  wkfl_99 WHERE w99_user = mfguser , EACH ps_mstr WHERE  ps_comp = w99_part 
           AND ( eff_date >= ps_start OR ps_start = ? ) AND ( eff_date <= ps_end OR ps_end = ? ) 
           BREAK BY ps_par :

             /*! FIND NEXT ITEM MATCHING SELECTION CRITERIA */
             cuqty = cuqty + ps_qty_per * ( 1 + ps_scrp_pct / 100 )  * w99_qty .

             IF LAST-OF(ps_par) THEN DO:
                 FIND FIRST pt_mstr WHERE pt_part = ps_par EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE pt_mstr  THEN
                     ASSIGN pt__dec01 = cuqty 
                                   pt__log01 = YES .
                 ELSE DO:
                      FIND FIRST bom_mstr WHERE bom_parent = ps_par EXCLUSIVE-LOCK NO-ERROR.

                 END.
                 FIND FIRST wkfl_66 WHERE w66_par = ps_par AND w66_user = mfguser NO-ERROR.
                 IF NOT AVAILABLE wkfl_66  THEN DO:
                     CREATE wkfl_66.
                     ASSIGN w66_part = ps_par 
                                    w66_qty  = cuqty 
                                    w66_user = mfguser .
                 END.
                 cuqty = 0 .
             END.

    end. /* for each wkfl_99 */
    /*clear the all records for table wkfl_99**/
    FOR EACH wkfl_99 WHERE w99_user = mfguser :
        DELETE wkfl_99 .
    END.


END PROCEDURE.


PROCEDURE is-wk66:
    /***从铜层起，倒数第三层The lastest thirded level， ，产生临时文件wkfl_33 ***/
    cuqty = 0 .
    for each  wkfl_66 WHERE w66_user = mfguser , EACH ps_mstr WHERE  ps_comp = w66_part 
           AND ( eff_date >= ps_start OR ps_start = ? ) AND ( eff_date <= ps_end OR ps_end = ? ) 
           BREAK BY ps_par :

             /*! FIND NEXT ITEM MATCHING SELECTION CRITERIA */
             cuqty = cuqty + ps_qty_per * ( 1 + ps_scrp_pct / 100 )  * w66_qty .

             IF LAST-OF(ps_par) THEN DO:
                 FIND FIRST pt_mstr WHERE pt_part = ps_par EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE pt_mstr  THEN
                     ASSIGN pt__dec01 = cuqty 
                                   pt__log01 = YES .
                 ELSE DO:
                      FIND FIRST bom_mstr WHERE bom_parent = ps_par EXCLUSIVE-LOCK NO-ERROR.

                 END.
                 FIND FIRST wkfl_33 WHERE w33_par = ps_par AND w33_user = mfguser NO-ERROR.
                 IF NOT AVAILABLE wkfl_33  THEN DO:
                     CREATE wkfl_33.
                     ASSIGN w33_part = ps_par 
                                    w33_qty  = cuqty 
                                    w33_user = mfguser .
                 END.
                 cuqty = 0 .
             END.

    end. /* for each wkfl_66 */

    FOR EACH wkfl_66 WHERE w66_user = mfguser :
        DELETE wkfl_66 .
    END.

END.

PROCEDURE is-wk33:
    /***从铜层起，倒数第四层The lastest fourth level ，产生临时文件wkfl_99 ***/
    cuqty = 0 .
    for each  wkfl_33 WHERE w33_user = mfguser , EACH ps_mstr WHERE  ps_comp = w33_part 
           AND ( eff_date >= ps_start OR ps_start = ? ) AND ( eff_date <= ps_end OR ps_end = ? ) 
           BREAK BY ps_par :

             /*! FIND NEXT ITEM MATCHING SELECTION CRITERIA */
             cuqty = cuqty + ps_qty_per * ( 1 + ps_scrp_pct / 100 )  * w33_qty .

             IF LAST-OF(ps_par) THEN DO:
                 FIND FIRST pt_mstr WHERE pt_part = ps_par EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE pt_mstr  THEN
                     ASSIGN pt__dec01 = cuqty 
                                   pt__log01 = YES .
                 ELSE DO:
                      FIND FIRST bom_mstr WHERE bom_parent = ps_par EXCLUSIVE-LOCK NO-ERROR.

                 END.
                 FIND FIRST wkfl_99 WHERE w99_par = ps_par AND w99_user = mfguser NO-ERROR.
                 IF NOT AVAILABLE wkfl_99  THEN DO:
                     CREATE wkfl_99.
                     ASSIGN w99_part = ps_par 
                                    w99_qty  = cuqty 
                                    w99_user = mfguser .
                 END.
                 cuqty = 0 .
             END.

    end. /* for each wkfl_33 */


    FOR EACH wkfl_33 WHERE w33_user = mfguser :
        DELETE wkfl_33 .
    END.

END.


FOR EACH pt_mstr WHERE pt__dec01 <> 0       
       and pt_part >= part and pt_part <= part1
         and pt_prod_line >= line and pt_prod_line <= line1
         and pt_part_type >= type and pt_part_type <= type1
        and pt_group >= grp and pt_group <= grp1
         no-lock:
        DISPLAY pt_part pt_desc1 pt_desc2 pt_prod_line pt_um
                      pt__dec01  FORMAT "->>,>>>,>>>9.9<<<<<<<" 
                      LABEL "Copper Weight"  WITH WIDTH 132 STREAM-IO .

   END.

