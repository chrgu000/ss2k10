/* faaqrpa.p PRINT ACQUISITIONS REPORT SUBROUTINE                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.13.1.13 $                                                       */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/14/00   BY: *M0PS* Shilpa Athalye   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 08/25/00   BY: *N0NT* Rajinder Kamra   */
/* Revision: 1.13.1.10    BY: Vinod Nair         DATE: 12/24/01  ECO: *M1N8*  */
/* Revision: 1.13.1.11    BY: Vivek Dsilva       DATE: 01/10/02  ECO: *M1SZ*  */
/* Revision: 1.13.1.12    BY: K Paneesh          DATE: 04/19/02  ECO: *N1GS*  */
/* $Revision: 1.13.1.13 $    BY: Shoma Salgaonkar    DATE: 02/19/03  ECO: *N27T*  */
/* $Revision: 1.13.1.13 $    BY: Bill Jiang    DATE: 05/05/06  ECO: *SS - 20060505.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060505.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6faaqrp01.p
   a6faaqrp01a.p
*/
/* SS - 20060505.1 - E */

/* SS - 20060505.1 - B */
{a6faaqrp01.i}
/* SS - 20060505.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITION ********* */

&SCOPED-DEFINE faaqrpa_p_1 "Cost"
/* MaxLen: 18 Comment:  Asset Cost */

&SCOPED-DEFINE faaqrpa_p_2 "Total Assets"
/* MaxLen: 15 Comment:  Asset Count */

&SCOPED-DEFINE faaqrpa_p_4 "Total Assets for Report"
/* MaxLen: 35 Comment:  Asset Count for report */

/* ********** END TRANSLATABLE STRINGS DEFINITION ********* */

{wbrp02.i}   /* WEB ENABLEMENT INCLUDE */

/* DEFINE VARIABLES */

/* INPUT PARAMTERS */
define input parameter fromClass  like fa_facls_id    no-undo.
define input parameter toClass    like fa_facls_id    no-undo.
define input parameter fromLoc    like fa_faloc_id    no-undo.
define input parameter toLoc      like fa_faloc_id    no-undo.
define input parameter fromEntity like fa_entity      no-undo.
define input parameter toEntity   like fa_entity      no-undo.
define input parameter l-yrper    like fab_cst_adjper no-undo.
define input parameter l-yrper1   like fab_cst_adjper no-undo.
define input parameter nonDepr    like mfc_logical    no-undo.

/* CHARACTER */
define variable serDate like fab_cst_adjper no-undo.

/* INTEGER */
define variable costAmt      like fabd_peramt           no-undo.
define variable costTot      like fabd_accamt           no-undo.
define variable assetCnt  as integer                    no-undo.
define variable assetCnt2 as integer                    no-undo.
define variable l-err-nbr as integer          initial 0 no-undo.
define variable l-cost-grtot like fabd_accamt initial 0 no-undo.

/* LOGICAL */
define variable l_first_class like mfc_logical no-undo.

/* REPORT LOGIC */

for first fabk_mstr
   fields(fabk_id fabk_post)
   where fabk_post = yes
   no-lock:
end. /* FOR FIRST fabk_mstr */
if not available fabk_mstr then return.

/* GET EACH ASSET ID TO REPORT ON WITHIN RANGES */
for each fa_mstr
   fields(fa_facls_id fa_id fa_faloc_id fa_entity
          fa_startdt fa_dep fa_desc1 fa_puramt)
   where fa_facls_id >= fromClass
   and   fa_facls_id <= toClass
   and   fa_faloc_id >= fromLoc
   and   fa_faloc_id <= toLoc
   and   fa_entity   >= fromEntity
   and   fa_entity   <= toEntity
   no-lock
   break by fa_facls_id
         by fa_id:

   /* ONLY KEEP ASSETS WHOSE SERVICE DATE = YEAR PERIOD */
   /* CHECK FOR NON DEPRECIATION ASSETS AS WELL */
   {gprunp.i "fapl" "p" "fa-get-per"
      "(input  fa_startdt,
        input  """",
        output serDate,
        output l-err-nbr)"}

   if first-of(fa_facls_id)
   then
      l_first_class = yes.

   if (nonDepr = yes or fa_dep = yes)
      and (serDate     >= l-yrper
           and serDate <= l-yrper1)
   then do:

      /* COUNT ALL THE ASSETS TO BE DISPLAYED AT BOTTOM */
      assetCnt = assetCnt + 1.

      if l_first_class
         and assetCnt = 1
      then
         l_first_class = no.

      /* WRITE OUT COST TOTAL AND ASSET CNT BY CLASS */

      if l_first_class
         and assetCnt <> 1
      then do with frame f-3:

         /* SS - 20060505.1 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-3:handle).
         display
            getTermLabel("TOTAL_COST",15) format "x(15)"
            costTot at 79
         with frame f-3 down no-labels no-attr-space width 132.

         do with frame f-4:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame f-4:handle).
            display
               skip(1)
               assetCnt2 label {&faaqrpa_p_2}
            with frame f-4 down side-labels
            no-box no-attr-space width 132.
         end. /* DO WITH */

         page.
         */
         /* SS - 20060505.1 - E */

         assign
            costTot       = 0
            l_first_class = no
            assetCnt2     = 0.

      end. /* IF l_firstclass */

      /* ASSIGN COST AMOUNT, ASSETCNT AND COSTTOT */
      if fa_dep
      then do:
         {gprunp.i "fapl" "p" "fa-get-cost"
            "(input  fa_id,
              input  fabk_id,
              output costAmt)"}
      end. /* IF FA_DEP */
      else
         costAmt = fa_puramt.

      assign
         assetCnt2    = assetCnt2    + 1
         l-cost-grtot = l-cost-grtot + costAmt
         costTot      = costTot      + costAmt.

      /* SS - 20060505.1 - B */
      /*
      /* DISPLAY A BLANK LINE */
      if line-counter = 1
      then do with frame f-1:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-1:handle).
         display
            skip(1)
            fa_facls_id
            skip(1)
         with frame f-1 down
         side-labels no-box no-attr-space width 132.

      end. /* IF line-counter = 1 */

      /* DISPLAY DETAIL REPORT */
      do with frame f-2:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-2:handle).
         display
            fa_mstr.fa_id
            fa_mstr.fa_desc1
            fa_mstr.fa_faloc_id
            fa_mstr.fa_entity
            costAmt column-label {&faaqrpa_p_1}
            fa_mstr.fa_startdt
         with frame f-2 down no-box no-attr-space width 132.

      end. /* DO WITH */

      /* PAGE BREAKING */
      if page-size - line-counter < 3
      then
         page.
      */
      CREATE tta6faaqrp01.
      ASSIGN
         tta6faaqrp01_fa_facls_id = fa_facls_id
         tta6faaqrp01_fa_id = fa_mstr.fa_id
         tta6faaqrp01_fa_desc1 = fa_mstr.fa_desc1
         tta6faaqrp01_fa_faloc_id = fa_mstr.fa_faloc_id
         tta6faaqrp01_fa_entity = fa_mstr.fa_entity
         tta6faaqrp01_costAmt = costAmt
         tta6faaqrp01_fa_startdt = fa_mstr.fa_startdt
         .
      /* SS - 20060505.1 - E */
      {mfrpchk.i}

   end. /* IF nonDepr = .... */
end. /* DO FOR EACH fa_mstr */

/* SS - 20060505.1 - B */
/*
/* DISPLAY LAST COST TOTAL FOR THE CLASS */
display
   getTermLabel("TOTAL_COST",15) format "x(15)"
   costTot at 79
with frame f-6 down no-labels no-attr-space width 132.

/* DISPLAY LAST ASSET COUNT FOR THE CLASS */
do with frame f-7:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f-7:handle).
   display
      skip(1)
      assetCnt2 label {&faaqrpa_p_2}
   with frame f-7 down side-labels
   no-box no-attr-space width 132.

end. /* DO WITH */

/* DISPLAY GRAND TOTAL COST FOR THE REPORT */
display
   getTermLabel("GRAND_TOTAL",15) format "x(15)"
   l-cost-grtot at 79
with frame f-8 down no-labels
no-attr-space width 132.

/* DISPLAY ASSET COUNT */
do with frame f-5:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f-5:handle).
   display
      skip(1)
      assetCnt label {&faaqrpa_p_4}
   with frame f-5 down side-labels
   no-box no-attr-space width 132.

end. /* DO WITH */
*/
/* SS - 20060505.1 - E */

/* WEB ENABLEMENT INCLUDE */
{wbrp04.i}
