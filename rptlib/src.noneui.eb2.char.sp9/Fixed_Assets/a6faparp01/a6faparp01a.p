/* faparpa.p PRINT PERIODIC ACTIVITY REPORT SUBROUTINE                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.11.1.14.3.1 $                                                             */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 11/30/99   BY: *N062* P Pigatti        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/14/00   BY: *M0PS* Shilpa Athalye   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0NV* BalbeerS Rajput  */
/* Revision: 1.11.1.12   BY: Vinod Nair          DATE: 12/24/01  ECO: *M1N8*  */
/* Revision: 1.11.1.13   BY: Vivek Dsilva        DATE: 01/10/02  ECO: *M1SZ*  */
/* Revision: 1.11.1.14   BY: Rajaneesh S.        DATE: 05/22/02  ECO: *M1Y9*  */
/* $Revision: 1.11.1.14.3.1 $   BY: Dorota Hohol      DATE: 08/04/03 ECO: *P0YS* */
/* $Revision: 1.11.1.14.3.1 $   BY: Bill Jiang      DATE: 05/08/06 ECO: *SS - 20060508.1* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060508.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6faparp01.p
   a6faparp01a.p
*/
/* SS - 20060508.1 - E */

/* SS - 20060508.1 - B */
{a6faparp01.i}
/* SS - 20060508.1 - E */

{mfdeclre.i}
{cxcustom.i "FAPARPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


/* ********** BEGIN TRANSLATABLE STRINGS DEFINITION ********* */

&SCOPED-DEFINE faparpa_p_1 "Cost"
/* MaxLen: 15 Comment: Asset Cost */

&SCOPED-DEFINE faparpa_p_2 "Acquired"
/* MaxLen: 14 Comment: Acquired Amounts */

&SCOPED-DEFINE faparpa_p_3 "Transfers"
/* MaxLen: 14 Comment: Transfer Amounts */

&SCOPED-DEFINE faparpa_p_4 "Retired"
/* MaxLen: 14 Comment: Retired Amounts */

&SCOPED-DEFINE faparpa_p_5 "Adjustments"
/* MaxLen: 14 Comment: Adjustment Amounts */

&SCOPED-DEFINE faparpa_p_6 "End Balance"
/* MaxLen: 14 Comment: Ending Balance Amount */

&SCOPED-DEFINE faparpa_p_7 "Total Assets"
/* MaxLen: 15 Comment: Asset Count */

/* ********** END TRANSLATABLE STRINGS DEFINITION ********* */

{wbrp02.i}   /* WEB ENABLEMENT INCLUDE */

/* INPUT PARMAMETERS */
define input parameter fromEntity like fa_entity   no-undo.
define input parameter toEntity   like fa_entity   no-undo.
define input parameter fromAsset  like fa_id       no-undo.
define input parameter toAsset    like fa_id       no-undo.
define input parameter l-yrper    like fabd_yrper  no-undo.
define input parameter l-yrper1   like fabd_yrper  no-undo.
define input parameter printTot   like mfc_logical no-undo.
define input parameter nonDepr    like mfc_logical no-undo.

/* DEFINE VARIABLES */
/* CHARACTER */
define variable assetID like fa_id no-undo.
define variable serDate  as character    format "x(6)" no-undo.
define variable retDate  as character    format "x(6)" no-undo.
define variable acqDate  as character    format "x(6)" no-undo.
define variable perDate  like fabd_yrper format "x(7)" no-undo.
define variable l_fadesc like fa_desc1                 no-undo.
define variable l_yrper  like fabd_yrper               no-undo.

/* INTEGER */
{&FAPARPA-P-TAG1}
define variable costAmt  as integer format "->>>>>,>>>,>>9"  no-undo.
define variable retAmt   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable trAmt    as integer format "->>>>>,>>>,>>9"  no-undo.
define variable acqAmt   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable adjAmt   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable assetCnt as integer no-undo.
define variable endAmt   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable costTot  as integer format "->>>>>>,>>>,>>9" no-undo.
define variable retTot   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable trTot    as integer format "->>>>>,>>>,>>9"  no-undo.
define variable acqTot   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable adjTot   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable endTot   as integer format "->>>>>,>>>,>>9"  no-undo.
define variable total-assets as integer format "->>>>>,>>>,>>9" no-undo.
define variable l_costamt as integer format "->>>>>,>>>,>>9" no-undo.
{&FAPARPA-P-TAG2}
define variable l_dep        like mfc_logical                no-undo.
define variable l_famstr_err like mfc_logical                no-undo.
define variable l-err-nbr    as   integer initial 0          no-undo.
/* DEFINE PERIODIC TEMPTABLE */
define temp-table T_perActy no-undo
   field enty      like fa_entity
   field asst      like fa_id
   field tt_yrper  like fabd_yrper
   field assetDesc like fa_desc1
   field cost      like costTot
   field acqr      like acqTot
   field trsfrs    like trTot
   field retmnt    like retTot
   field adjmnt    like adjTot
   field endBal    like endTot.

/* REPORT LOGIC */
for first fabk_mstr
   fields(fabk_id fabk_post)
   where fabk_post = yes
   no-lock:
end. /* FOR FIRST fabk_mstr */

if not available fabk_mstr then return.

/* GET EACH ASSET ID WITHIN USER SELECTED RANGES */
for each fabd_det
   fields(fabd_fa_id fabd_fabk_id fabd_entity
          fabd_yrper fabd_transfer fabd_trn_entity)
   where fabd_entity >= fromEntity
   and   fabd_entity <= toEntity
   and   fabd_fa_id  >= fromAsset
   and   fabd_fa_id  <= toAsset
   and   fabd_yrper  >= l-yrper
   and   fabd_yrper  <= l-yrper1
   no-lock
   break
      by fabd_fa_id
      by fabd_transfer
      by fabd_yrper:

   l_yrper = fabd_yrper.

   if first-of(fabd_fa_id)
   then do:

      /* READ ASSET MSTR TO PULL DESCRIPTION */
      for first fa_mstr
         fields(fa_id fa_desc1 fa_startdt
                fa_dep fa_disp_dt fa_puramt)
         where fa_id = fabd_fa_id
         no-lock:
      end. /* FOR FIRST fa_mstr */

      if not available (fa_mstr)
      then
         assign
            l_fadesc     = ""
            l_famstr_err = yes.
      else do:

         assign
            l_fadesc     = fa_desc1
            l_dep        = fa_dep
            l_famstr_err = no.

          {gprunp.i "fapl" "p" "fa-get-per"
             "(input  fa_startdt,
               input  """",
               output serDate,
               output l-err-nbr)"}

          {gprunp.i "fapl" "p" "fa-get-per"
             "(input  fa_disp_dt,
               input  """",
               output retDate,
               output l-err-nbr)"}

         if (l_yrper >= serDate)
             and (l_yrper <= retDate
             or   retDate  = ?
             or   retDate  = "")
             and (nonDepr = yes
                  or l_dep)
         then do:

            /* SET COST AMOUNT */
            if fa_dep
            then do:
               {gprunp.i "fapl" "p" "fa-get-cost"
                  "(input  fa_id,
                    input  fabk_id,
                    output costAmt)"}
            end. /* IF FA_DEP */
            else
               costAmt = fa_puramt.

            l_costamt = costAmt.

            {gprunp.i "fapl" "p" "fa-get-per"
               "(input  fa_startdt,
                 input  """",
                 output acqDate,
                 output l-err-nbr)"}

         end. /* IF (l_yrper >= */
      end. /* ELSE DO */

   end. /* IF FIRST-OF(fabd_fa_id ) */

   if l_famstr_err = no
   then do:

      /* IF YR/PERIOD < SERVICE DATE OR > RETIREMENT DATE OR THE nonDepr
      IS NO AND ASSET IS NOT DEPRECIATABLE THEN DON'T REPORT*/

      if (l_yrper >= serDate )
         and (l_yrper <= retDate
         or   retDate  = ?
         or   retDate  = "")
         and (nonDepr = yes or
              l_dep   = yes)
      then do:

         /* SET COST AMOUNT */
         /* CHECK IF ASSET WAS RETIRED IN PERIOD  */
         /* CHECK IF ASSET WAS ACQUIRED IN PERIOD */

         assign
            costAmt = l_costamt
            perDate = substring(l_yrper,1,4)
                      + "/"
                      + substring(l_yrper,5,2)
            adjAmt  = 0.

            /* CALCULATE THE COST OF THE ASSET */
         if l_dep
         then do:
            {gprunp.i "fapl" "p" "fa-get-cost-asof-date"
                                 "(input fabd_fa_id,
                                   input fabk_id,
                                   input l_yrper,
                                   input yes,
                                   output costAmt)"}
         end. /* IF l_dep */

         assign
            retAmt  = if retDate = l_yrper
                      then
                         costAmt
                      else
                         0
            acqAmt  = if acqDate = l_yrper
                      then
                         costAmt
                      else
                         0.

         /* CHECK WHETHER THE ASSET WAS TRANSFERRED */
         /* SET COST IF ASSET WASN'T TRASFERRED OR ACQUIRED */
         /* COMPUTE THE ENDING BALANCE */
         /* SAVE ASSET FOR SETTING COST LATER */

         assign
            trAmt   = if fabd_transfer = yes
                         and last-of(fabd_yrper)
                      then
                         costAmt
                      else
                         0
            costAmt = if last-of(fabd_yrper)
                         and trAmt  = 0
                         and acqAmt = 0
                      then
                         costAmt
                      else
                         0.
          {&FAPARPA-P-TAG5}
          if can-find(first fab_det
                      where fab_fa_id       = fabd_fa_id
                        and fab_fabk_id     = fabk_id
                        and fab_cst_adjper  = l_yrper)
          then do:
             /* FIND BASIS ADJUSTMENTS FOR A GIVEN YEAR/PERIOD */
             for each fab_det
                fields(fab_amt fab_cst_adjper fab_fabk_id fab_fa_id)
                where fab_fa_id      = fabd_fa_id
                  and fab_fabk_id    = fabk_id
                  and fab_cst_adjper = l_yrper
                no-lock:

                assign
                   adjAmt  = fab_amt
                   {&FAPARPA-P-TAG6}
                   endAmt  = costAmt + acqAmt + trAmt - retAmt + adjAmt.

                /* CREATE TEMP TABLE FOR PERIODIC ACTIVITY RPT */
                if trAmt > 0
                   and fabd_entity <> fabd_trn_entity
                then
                   /* CREATE ENTITY TRANSFER RECORDS */
                   run p_tt_create.


                /* CREATE NON TRANSFER RECORDS */
                else do:

                   if last-of(fabd_yrper)
                      and trAmt = 0
                   then do:

                      for first t_peracty
                         where enty     = fabd_entity
                           and asst     = fabd_fa_id
                           and tt_yrper = fabd_yrper
                         exclusive-lock:

                         /* ACCUMULATE THE AMOUNTS */
                         assign
                            acqr    = acqAmt
                            trsfrs  = 0
                            retmnt  = retAmt
                            adjmnt  = adjmnt + adjAmt
                            endBal  = costAmt + acqr +
                                      trsfrs - retmnt + adjmnt.
                      end. /* FOR FIRST t_peracty */

                      if not available t_peracty
                      then do:

                         create T_perActy.
                         assign
                            enty      = fabd_entity
                            asst      = fabd_fa_id
                            tt_yrper  = fabd_yrper
                            assetDesc = l_fadesc
                            cost      = costAmt
                            acqr      = acqAmt
                            trsfrs    = 0
                            retmnt    = retAmt
                            adjmnt    = adjAmt
                            endBal    = endAmt.

                      end. /* IF NOT AVAILABLE t_peracty */
                   end. /* LAST-OF(fabd_fa_id) ... */
                end. /* ELSE DO: */

             end. /* FOR EACH fab_det */
          end. /* IF CAN-FIND(FIRST fab_det) */

         /* FOR ASSETS WITHOUT ANY ADJUSTMENTS */
         /* BEGIN ADD */
         else do:
            assign
               adjAmt = 0
               endAmt = costAmt + acqAmt + trAmt - retAmt + adjAmt.

            /* CREATE TEMP TABLE FOR PERIODIC ACTIVITY RPT */
            if trAmt > 0 and
               fabd_entity <> fabd_trn_entity
            then
               /* CREATE ENTITY TRANSFER RECORDS */
               run p_tt_create.

            /* CREATE NON TRANSFER RECORDS */
            else do:
               if last-of(fabd_yrper)
                  and trAmt = 0
               then do:
                  /* CREATE RECORD FOR TRANSFER = 0 TRANSACTION */
                  create T_perActy.
                  assign
                     enty      = fabd_entity
                     asst      = fabd_fa_id
                     tt_yrper  = fabd_yrper
                     assetDesc = l_fadesc
                     cost      = costAmt
                     acqr      = acqAmt
                     trsfrs    = 0
                     retmnt    = retAmt
                     adjmnt    = adjAmt
                     endBal    = endAmt.
               end. /* IF LAST-OF(fabd_fa_id) */
            end. /* ELSE DO - NON TRANSFER RECORDS */
         end. /* ELSE DO */

      end. /* IF l_yrper  */

   end. /* IF l_famstr_err = NO */

end. /* FOR EACH fabd_det */

/* SS - 20060508.1 - B */
/*
/* PROCESS EACH PERIODIC ACTIVITY RECORD */
for each T_perActy
   no-lock
   break by enty
         by tt_yrper
         by asst:

    /* ACCUMULATE TOTALS BY ENTITY */
    accumulate trsfrs (total by tt_yrper).
    accumulate cost   (total by tt_yrper).
    accumulate acqr   (total by tt_yrper).
    accumulate retmnt (total by tt_yrper).
    accumulate adjmnt (total by tt_yrper).
    accumulate endBal (total by tt_yrper).

   /* PRINT HEADERS OF REPORT */
   if first-of(tt_yrper)
      or line-counter = 1
   then do with frame f-1:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-1:handle).
      display
         skip(1)
         enty
         skip
         fabk_id
         skip
         tt_yrper
         skip(1)
      with frame f-1 down
      side-labels no-box no-attr-space width 132.

   end. /* IF FIRST-OF(tt_yrper) */

   if printTot = no
   then do with frame f-2:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-2:handle).

      /* DISPLAY DETAIL REPORT */
      display
         asst
         assetDesc format "x(20)"
         cost   column-label {&faparpa_p_1}
         acqr   column-label {&faparpa_p_2}
         trsfrs column-label {&faparpa_p_3}
         retmnt column-label {&faparpa_p_4}
         adjmnt column-label {&faparpa_p_5}
         endBal column-label {&faparpa_p_6}
      with frame f-2 down no-box no-attr-space width 132.

   end. /* IF printTot = no */

   if last-of(tt_yrper)
   then do:

      /* DISPLAY TOTALS */
      if printTot = no
      then do:

         display
            skip(1)
            getTermLabel("TOTALS",20) format "x(20)"
            {&FAPARPA-P-TAG3}
            accum total by tt_yrper cost   at 40
            accum total by tt_yrper acqr   at 55
            accum total by tt_yrper trsfrs at 70
            accum total by tt_yrper retmnt at 85
            accum total by tt_yrper adjmnt at 100
            accum total by tt_yrper endBal at 115
            {&FAPARPA-P-TAG4}
         with frame f-3 no-labels no-box no-attr-space width 132.

      end. /* IF printTot = NO */

      else do with frame f-4:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-4:handle).
         display
            skip(1)
            getTermLabel("TOTALS",20) format "x(20)"
            accum total by tt_yrper cost
             @ cost   column-label {&faparpa_p_1} at 40
            accum total by tt_yrper acqr
             @ acqr   column-label {&faparpa_p_2} at 55
            accum total by tt_yrper trsfrs
             @ trsfrs column-label {&faparpa_p_3} at 70
            accum total by tt_yrper retmnt
             @ retmnt column-label {&faparpa_p_4} at 85
            accum total by tt_yrper adjmnt
             @ adjmnt column-label {&faparpa_p_5} at 100
            accum total by tt_yrper endBal
             @ endBal column-label {&faparpa_p_6} at 115
         with frame f-4 no-box no-attr-space width 132.
      end. /* ELSE DO WITH FRAME f-4 */

      page.

  end. /* IF LAST-OF tt_yrper */

   /* PAGE BREAKING */
   if page-size - line-counter < 3
   then
      page.

   {mfrpchk.i}

end. /* FOR EACH t-perActy */
*/
/* PROCESS EACH PERIODIC ACTIVITY RECORD */
for each T_perActy
   no-lock
   :

   CREATE tta6faparp01.
   ASSIGN
      tta6faparp01_enty = enty
      tta6faparp01_fabk_id = fabk_id
      tta6faparp01_yrper = tt_yrper
      tta6faparp01_asst = asst
      tta6faparp01_assetDesc = assetDesc
      tta6faparp01_cost = cost
      tta6faparp01_acqr = acqr
      tta6faparp01_trsfrs = trsfrs
      tta6faparp01_retmnt = retmnt
      tta6faparp01_adjmnt = adjmnt
      tta6faparp01_endBal = endBal
      .

end. /* FOR EACH t-perActy */
/* SS - 20060508.1 - E */

/* Web Enablement include */
{wbrp04.i}


/* CREATE ENTITY TRANSFER RECORDS */
PROCEDURE p_tt_create:

   /* CREATE RECORD FOR TO ENTITY TRANSFER TXN */
   create T_perActy.
   assign
      enty      = fabd_det.fabd_entity
      asst      = fabd_det.fabd_fa_id
      tt_yrper  = fabd_det.fabd_yrper
      assetDesc = l_fadesc
      cost      = costAmt
      acqr      = acqAmt
      trsfrs    = trAmt
      retmnt    = retAmt
      adjmnt    = adjAmt
      endBal    = endAmt.

   if fabd_det.fabd_trn_entity <= toEntity and
      fabd_det.fabd_trn_entity >= fromEntity
   then do:
      /* CREATE RECORD FOR FROM ENTITY TRANSFER TXN */
      create T_perActy.
      assign
         enty      = fabd_det.fabd_trn_entity
         asst      = fabd_det.fabd_fa_id
         tt_yrper  = fabd_det.fabd_yrper
         assetDesc = l_fadesc
         cost      = trAmt
         acqr      = 0
         trsfrs    = 0 - trAmt
         retmnt    = 0
         adjmnt    = 0
         endBal    = cost + trsfrs.

   end. /* IF fabd_trn_entity */

END PROCEDURE.
