/* xxfaderp01a1.p       ASSETS OWNED REPORT SUBROUTINE                        */
/*V8:ConvertMode=FullGUIReport                                                */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}
{xxfaderp01.i}
/* ********** Begin Translatable Strings Definition ********* */

&SCOPED-DEFINE faaorpa_p_1 "Acc Depr Amt"
/* MaxLen: 16 Comment: Accumulated depreciation for period */

&SCOPED-DEFINE faaorpa_p_2 "Net Book Value"
/* MaxLen: 16 Comment: Net Book Value */

&SCOPED-DEFINE faaorpa_p_3 "Cost"
/* MaxLen: 16 Comment: Asset Cost */

&SCOPED-DEFINE faaorpa_p_4 "Annual Depr Amt"
/* MaxLen: 16 Comment: Annual Depreciation Amount */

&SCOPED-DEFINE faaorpa_p_5 "Total Assets"
/* MaxLen: 15 Comment: Total Assets for break */

&SCOPED-DEFINE faaorpa_p_6 "Total Cost"
/* MaxLen: 13 Comment: Total Cost */

&SCOPED-DEFINE faaorpa_p_7 "Total Depr"
/* MaxLen: 13 Comment: Total Depreciation Amt */

&SCOPED-DEFINE faaorpa_p_8 "Total Net"
/* MaxLen: 13 Comment: Total Net Book Amt */

&SCOPED-DEFINE faaorpa_p_9 "Total Assets for Report"
/* MaxLen: 30 Comment: Total Assets for break */

/* ********** End Translatable Strings Definition ********* */

/* WEB ENABLEMENT INCLUDE */
{wbrp02.i}

/* INPUT PARMAMETERS */
define input parameter fromLoc    like fa_faloc_id no-undo.
define input parameter toLoc      like fa_faloc_id no-undo.
define input parameter fromAsset  like fa_id       no-undo.
define input parameter toAsset    like fa_id       no-undo.
define input parameter FromBook   like fabk_id     no-undo.
define input parameter toBook     like fabk_id     no-undo.
define input parameter fromClass  like fa_facls_id no-undo.
define input parameter toClass    like fa_facls_id no-undo.
define input parameter fromEntity like fa_entity   no-undo.
define input parameter toEntity   like fa_entity   no-undo.
define input parameter fromYrPer  like fabd_yrper  no-undo.
define input parameter toYrPer    like fabd_yrper  no-undo.
define input parameter fromauthNbr like fa_auth_number no-undo.
define input parameter toauthNbr  like fa_auth_number no-undo.
define input parameter fromstartdt like fa_startdt no-undo.
define input parameter tostartdt  like fa_startdt no-undo.
define input parameter fromfasaveas like fa__chr01 no-undo.
define input parameter tofasaveas   like fa__chr01 no-undo.
define input parameter yrPeriod   like fabd_yrper  no-undo.
define input parameter printTot   like mfc_logical no-undo.
define input parameter nonDepr    like mfc_logical no-undo.
define input parameter fullDepr   like mfc_logical no-undo.
define input parameter inclRet    like mfc_logical no-undo.

/* DEFINE VARIABLES */
/* CHARACTER */
define variable oldAsset      like fa_id                  no-undo.
define variable perBeg        as character format "x(6)"  no-undo.
define variable perEnd        as character format "x(6)"  no-undo.
define variable disDate       as character format "x(6)"  no-undo.
define variable fabdYrper     like fabd_yrper             no-undo.
define variable l_fab_fabk_id like fab_fabk_id            no-undo.
define variable l_zeronbv     like mfc_logical            no-undo.
define variable l_finalper    like fabd_yrper             no-undo.

/* INTEGER */
define variable netBook           like fabd_peramt           no-undo.
define variable costAmt           like fabd_peramt           no-undo.
define variable basisAmt          like fabd_peramt           no-undo.
define variable accDepr           like fabd_accamt           no-undo.
define variable assetCnt          as   integer               no-undo.
define variable annDepr           like fabd_accamt           no-undo.
define variable totUnits          like fabd_accup            no-undo.
define variable mc-error-number   as   integer format "9999" no-undo.
define variable l_totcostAmt      as decimal format "->>>>,>>>,>>9.99"
   no-undo.
define variable l_totaccDepr      as decimal format "->>>>,>>>,>>9.99"
   no-undo.
define variable l_totnetBook      as decimal format "->>>>,>>>,>>9.99"
   no-undo.
define variable l_totannDepr      as decimal format "->>>>,>>>,>>9.99"
   no-undo.
define variable tot-assets-for-rep as integer             no-undo.
define variable total_amt          as decimal             no-undo.
define variable total_depr         as decimal             no-undo.
define variable total_net          as decimal             no-undo.
define variable l-err-nbr          as integer initial 0   no-undo.

define variable l_retnetbook       like mfc_logical       no-undo.
define variable servDate           as character format "x(6)" no-undo.
define variable l_fa_location      like mfc_logical       no-undo.
define variable l_fa_show          like mfc_logical       no-undo.

/* DEFINE TEMPTABLE FOR ACCUMULATED BY BOOK */
define temp-table t-bookAccum no-undo
   field bookAsset like fa_id
   field bookId    like fabk_id
   field bookcost  like fab_amt
   field bookAccdp like fabd_accamt
   field bookNet   like fab_amt.

/* SET CURRENCY DEPENDENT ROUNDING FORMATS */
for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
   where gl_ctrl.gl_domain = global_domain
no-lock:
end. /* FOR FIRST gl_ctrl */

/* REPORT LOGIC */
/* GET EACH ASSET ID WITHIN USER SELECTED RANGES */
/* INSERT THE FILED fa_replamt IN THE FIELD LIST  */

empty temp-table tmp_xfa no-error.
for each fa_mstr
    where fa_mstr.fa_domain = global_domain
   and   fa_facls_id >= fromClass
   and   fa_facls_id <= toClass
   and   fa_faloc_id >= fromLoc
   and   fa_faloc_id <= toLoc
   and   fa_id       >= fromAsset
   and   fa_id       <= toAsset
   and   fa_entity   >= fromEntity
   and   fa_entity   <= toEntity
   and   fa_auth_number >= fromauthNbr
   and   fa_auth_number <= toauthNbr
   and   fa_startdt >= fromstartdt
   and   fa_startdt <= tostartdt
   and   fa__chr01 >= fromfasaveas
   and   fa__chr01 <= tofasaveas
   no-lock
   break by fa_faloc_id
         by fa_id:
   assign
      oldasset      = ""
      perbeg        = ""
      perend        = ""
      servDate      = ""
      disDate       = ""
      fabdYrper     = ""
      l_fab_fabk_id = ""
      netbook       = 0
      costamt       = 0
      basisAmt      = 0
      annDepr       = 0
      l_zeronbv     = no
      l_retnetbook  = no
      accdepr       = 0
      l_fa_show     = yes.

   {gprunp.i "xxfapl01" "p" "fa-get-per"
                        "(input fa_startdt,
                          input """",
                          output servDate,
                          output l-err-nbr)"}

   if fa_disp_dt <> ?
   then
      {gprunp.i "xxfapl01" "p" "fa-get-per"
                           "(input fa_disp_dt,
                             input """",
                             output disDate,
                             output l-err-nbr)"}

   /* ALL CHECKS REGARDING IF ASSET SHOULD BE DISPLAYED OR NOT */
   /* ARE MADE HERE, EXCEPT FULL DEPRECIATION CHECK            */

   /* AN ASSET SHOULD NOT BE DISPLAYED IF ASSET */
   /* IS NOT IN SERVICE ON THE AS OF DATE       */

   if servdate > yrPeriod
   then
      l_fa_show = no.

   /* AN ASSET SHOULD NOT BE DISPLAYED IF ASSET IS NON-DEPRECIATING */
   /* ASSET AND 'Include Non-Depreciating Asset' IS SET TO NO        */
   else
   if fa_dep   = no
   and nonDepr = no
   then
      l_fa_show = no.

   /* AN ASSET SHOULD NOT BE DISPLAYED, IF ASSET IS RETIRED AND   */
   /* INCLUDE RETIRED IS SET TO NO AND DISPOSITION DATE IS LESS   */
   /* THAN EQUAL TO TOPERIOD                                      */
   else
   if fa_disp_dt <> ?
   and (inclRet = no
        and (   toYrPer  = hi_char
             or disDate <= toYrPer))
   then
      l_fa_show = no.

   if l_fa_show
   then do:
      if yrPeriod >= disDate
      and disDate <> ""
      then
         l_retnetbook = yes.

      /* CHECK EACH BOOK FOR A GIVEN ASSET */
      for each fab_det
         where fab_det.fab_domain = global_domain
         and   fab_fa_id    = fa_id
         and   fab_fabk_id >= fromBook
         and   fab_fabk_id <= toBook
         no-lock
         break by fab_fabk_id:

         for first fabk_mstr
            fields( fabk_domain fabk_id)
            where fabk_mstr.fabk_domain = global_domain
            and   fabk_id               = fab_fabk_id
         no-lock:
         end. /* FOR FIRST fabk_mstr */

         if available fabk_mstr
         then do:
            /* FOR THE RETIRED ASSET WHEN DISPOSITION DATE IS PRIOR */
            /* OR EQUAL TO 'AS OF DATE', SET l_zeronbv TO YES TO    */
            /* DISPLAY ZERO NET BOOK VALUE.                         */
            if yrPeriod >= disDate
            and disDate <> ""
            then
               l_zeronbv = yes.

         end.  /* IF AVAILABLE fabk_mstr */

     /* ONLY PROCESS AGAINST THE ORIGINAL RESERVE FOR THE BOOK */
     if first-of(fab_fabk_id)
     then do:

        /* FOR EACH BOOK CHECK TO SEE IF A FABD_DET RECORD EXISTS */
        if can-find(first fabd_det
                       where fabd_det.fabd_domain = global_domain
                       and   fabd_fa_id   = fa_id
                       and   fabd_fabk_id = fab_fabk_id
                       and   fabd_yrper  >= fromYrPer
                       and   fabd_yrper  <= toYrPer
                       no-lock)
           or (fab_amt - fab_salvamt = 0)
        then do:

           /* GET BASIS AMT TO CHECK IF ACCDEPR IS GREATER */
           {gprunp.i "xxfapl01" "p" "fa-get-cost"
              "(input  fa_id,
                input  fab_det.fab_fabk_id,
                output costAmt)"}

           {gprunp.i "xxfapl01" "p" "fa-get-basis"
              "(input  fa_id,
                input  fab_det.fab_fabk_id,
                output basisAmt)"}

           /* USE FABD_BUFFER TO CALCULATE DEPRECIATION UNTIL
           THE AS OF DATE IS GREATER THAN THE FABD YR/PERIOD*/
           for last fabd_det
              fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accup
                     fabd_accamt)
              where fabd_det.fabd_domain = global_domain
              and   fabd_fa_id   = fa_id
              and   fabd_fabk_id = fab_fabk_id
              and   fabd_yrper  <= yrPeriod
              no-lock:
           end. /* FOR LAST fabd_det */

           if available fabd_det
           then do:
              /* SAVE YR/PER, TOTAL UNITS, ACCUM DEPR USED TO
              ADD TO THE UOP DATA*/
              assign
                 fabdYrper = fabd_yrper
                 totUnits  = fabd_accup.

              {gprunp.i "xxfapl01" "p" "fa-get-accdep"
                 "(input  fa_id,
                   input  fab_fabk_id,
                   input  fabd_yrper,
                   output accDepr)"}
           end. /* IF AVAILABLE fabd_det */

           /* CHECK TO SEE IF THE ASSET IS UOP */
           if can-find(first famt_mstr
                          where famt_mstr.famt_domain = global_domain
                          and   famt_id               = fab_famt_id
                          and   famt_type             = "2"
                          no-lock)
           then do:
              /* USE THE FORECASTED AMOUNT WHEN THE REQUESTED DATE
              IS GREATER THAN THE YEAR/PERIOD IN FABD_BUFFER */
              for each fauop_det
                 fields( fauop_domain fauop_fa_id fauop_fabk_id
                        fauop_yrper fauop_upper)
                 where fauop_det.fauop_domain = global_domain
                 and   fauop_fa_id   = fa_id
                 and   fauop_fabk_id = fab_fabk_id
                 and   fauop_yrper  <= yrPeriod
                 and   fauop_yrper  >  fabdYrper
                 no-lock:

                 totUnits =  totUnits
                           + fauop_upper.

                 /* ONLY ACCUMULATE FORECAST IF THE ADDITION DOES NOT
                 GO OVER BASIS AMT AND THE TOTAL UNITS ADDITION
                 DOESN'T GO OVER THE PRODUCTION UNITS */
                 if (accDepr
                   + (fab_det.fab_upcost * fauop_det.fauop_upper))> basisAmt
                 or  totUnits > fab_uplife
                 then do:
                    accDepr = basisAmt.
                    leave.
                 end. /* IF (accDepr + ... */
                 else
                    accDepr =  accDepr
                             + (fab_det.fab_upcost * fauop_det.fauop_upper).

                 {gprunp.i "mcpl" "p" "mc-curr-rnd"
                    "(input-output accDepr,
                      input gl_rnd_mthd,
                      output mc-error-number)"}

                 if mc-error-number <> 0
                 then do:
                    {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                 end. /* IF mc-error-number */
              end. /* FOR EACH fauop_det */
           end. /* IF NOT CAN-FIND famt_mstr */

           /* ASSIGN beg AND END DATES TO DETERMINE annDepr, COMPUTE */
           /* NET BOOK VALUE RESET THE SELECT YEAR PERIOD            */
           assign
              perBeg =  string(integer(substring(yrPeriod,1,4))
                      - 1)
                      + "12"
              perEnd =  string(substring(yrPeriod,1,4))
                      + "12".

           {gprunp.i "xxfapl01" "p" "fa-get-anndep"
              "(input fa_id,
                input fab_det.fab_fabk_id,
                input perBeg,
                input perEnd,
                output annDepr)"}

           netBook = if l_zeronbv
                     or (basisAmt - accDepr = 0
                         and not fullDepr)
                     then
                        0
                     else
                        costAmt - accDepr.

           /* FULL DEPRECIATION CHECK  */
           /* AND RETIRED ASSETS CHECK */

           if netBook     > 0
           or fullDepr    = yes
           or (inclRet    = yes
           and fa_disp_dt <> ?)
           then do:

              /* Create temp table for each book and totals */
              create t-bookAccum.
              assign
                 bookAsset = fa_id
                 bookId    = fab_det.fab_fabk_id
                 bookcost  = costAmt
                 bookAccdp = accDepr
                 bookNet   = netbook.

              if printTot = no
              then do:
                 /* IF ASSET IS DIFFERENT PRINT A BLANK LINE */
                 /* AND CALCULATE ASSET COUNT                */

                 if oldAsset <> fa_id
                 then do:
 /*                 put skip(1).  */
                    assetCnt =  assetCnt
                              + 1.
                 end. /* IF oldAsset <> fa_id */

                 /* SAVE OFF ASSET ID TO BE USED ABOVE */
                 oldAsset = fa_id.

              /* DISPLAY DETAIL REPORT - NEED TO CHECK LINE
                 COUNTER SINCE UOP ONLY ASSETS COULD CAUSE
                 COLUMN HEADING TO APPEAR IN THE MIDDLE OF RPT */
    
               create tmp_xfa.
               assign tx_faid      = fa_id
                      tx_fa_loc    = fa_faloc_id
                      tx_facls_id  = fa_facls_id
                      tx_auth_nbr  = fa_auth_number
                      tx_saveas    = fa__chr01 + fa__chr02
                      tx_cstcent   = substring(fa_faloc_id,1,4)
                      tx_puramt    = fa_replamt
                      tx_startdt   = fa_startdt
                      tx_salvamt   = fa_salvamt
                      tx_fabk_id   = fab_fabk_id
                      tx_life      = fab_life
                      tx_costAmt   = costAmt
                      tx_accDepr   = accDepr
                      tx_netBook   = netBook
                      tx_annDepr   = annDepr.
                
              end. /* IF printTot */

              /* CALCULATE TOTALS FOR EACH LOCATION */
              assign
                 l_totcostAmt =  l_totcostamt
                               + costAmt
                 l_totaccDepr =  l_totaccDepr
                               + accDepr
                 l_totnetBook =  l_totnetBook
                               + netBook
                 l_totannDepr =  l_totannDepr
                               + annDepr.

           end. /* IF netBook ... */

           /* PAGE BREAKING */
/*          if page-size - line-counter < 3                                  */
/*           then                                                            */
/*              page.                                                        */
/*           {mfrpchk.i}                                                     */

           /* RESET VARIABLES */
           assign
              fabdYrper = ""
              totUnits  = 0
              accDepr   = 0.
        end.  /* IF CAN-FIND fabd_det ... */
        else do:
           /* CHECK TO SEE IF THE ASSET IS UOP */
           if can-find(first famt_mstr
                          where famt_mstr.famt_domain = global_domain
                          and   famt_id               = fab_famt_id
                          and   famt_type             = "2"
                          no-lock)
           then do:

              /* IF THERE ARE NO FABD_DET RECORDS AVAILABLE FOR
              GIVEN ASSET BOOK UOP FORECASTS ARE USED TO RPT
              THE ASSET'S COSTS. */
              if can-find (first fauop_det
                              where fauop_det.fauop_domain  = global_domain
                              and   fauop_det.fauop_fa_id   = fa_id
                              and   fauop_det.fauop_fabk_id = fab_fabk_id
                              and   fauop_det.fauop_yrper  >= fromYrPer
                              and   fauop_det.fauop_yrper  <= toYrPer
                           no-lock)
              then do:

                 /* IF THE AS OF DATE SELECTED IS GREATER THAN
                 LAST YR/PER FOR THE LAST DETAIL RECORD, SET
                 YRPERIOD TO THAT YEAR PERIOD TO DISPLAY THAT
                 YEAR PERIOD'S ACCUMULATED DEPRECIATION */
                 for last fauop_det
                    fields( fauop_domain fauop_fa_id fauop_fabk_id fauop_accup
                           fauop_yrper)
                    where fauop_det.fauop_domain = global_domain
                    and   fauop_fa_id   = fa_id
                    and   fauop_fabk_id = fab_fabk_id
                    and   fauop_yrper  <= yrPeriod
                    no-lock:

                    accDepr =  fab_det.fab_upcost
                             * fauop_det.fauop_accup.

                    {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output accDepr,
                          input gl_rnd_mthd,
                          output mc-error-number)"}

                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */
                 end. /* FOT LAST fauop_set */

                 /* ACCUMULATE COST AND DEPR AMOUNTS */
                 {gprunp.i "xxfapl01" "p" "fa-get-cost"
                    "(input  fa_id,
                      input  fab_fabk_id,
                      output costAmt)"}
                 /* ASSIGN BEG/END DATES TO DETERMINE ANNDEPR */
                 assign
                    perBeg =  string(integer(substring(yrPeriod,1,4))
                            - 1)
                            + "12"
                    perEnd =  string(substring(yrPeriod,1,4))
                            + "12".

                 {gprunp.i "xxfapl01" "p" "fa-get-forecast-anndep"
                    "(input fa_id,
                      input fab_fabk_id,
                      input perBeg,
                      input perEnd,
                      output annDepr)"}

                 {gprunp.i "xxfapl01" "p" "fa-get-basis"
                    "(input  fa_id,
                      input  fab_det.fab_fabk_id,
                      output basisAmt)"}

                 netBook = basisAmt - accDepr.

                 /* FULL DEPRECIATION CHECK */
                 /* AND RETIRED ASSETS CHECK */

                 if netBook     > 0
                 or fullDepr    = yes
                 or (inclRet    = yes
                 and fa_disp_dt <> ?)
                 then do:

                    /* CREATE TEMP TABLE FOR EACH BOOKS TOTALS */
                    create t-bookAccum.
                    assign
                       bookAsset = fa_id
                       bookId    = fab_fabk_id
                       bookcost  = costAmt
                       bookAccdp = accDepr
                       bookNet   = netbook.

                    if printTot = no
                    then do:
                       /* IF ASSET IS DIFFERENT PRINT A BLANK LINE */
                       /* AND CALCULATE ASSET COUNT */
                       if oldAsset <> fa_id
                       then do:
/*                        put skip(1).                                     */
                          assetCnt = assetCnt + 1.
                       end. /* IF oldAsset */

                       /* SAVE OFF ASSET ID TO BE USED ABOVE */
                       oldAsset = fa_id.

                       /* DISPLAY DETAIL REPORT - CHECK LINE CTR    */
                       /* SINCE UOP ONLY ASSETS COULD CAUSE COLUMN  */
                       /* HEADING TO APPEAR IN MIDDLE OF RPT        */

                         create tmp_xfa.
                         assign tx_faid      = fa_id
                                tx_fa_loc    = fa_faloc_id
                                tx_facls_id  = fa_facls_id
                                tx_auth_nbr  = fa_auth_number
                                tx_saveas    = fa__chr01 + fa__chr02
                                tx_cstcent   = substring(fa_faloc_id,1,4)
                                tx_puramt    = fa_replamt
                                tx_startdt   = fa_startdt
                                tx_salvamt   = fa_salvamt
                                tx_fabk_id   = fauop_det.fauop_fabk_id
                                tx_costAmt   = costAmt
                                tx_accDepr   = accDepr
                                tx_netBook   = netBook
                                tx_annDepr   = annDepr.
          
                    end. /* IF printTot  = no */
                    /* CALCULATE TOTALS FOR EACH LOCATION */
                    assign
                       l_totcostAmt =  l_totcostamt
                                     + costAmt
                       l_totaccDepr =  l_totaccDepr
                                     + accDepr
                       l_totnetBook =  l_totnetBook
                                     + netBook
                       l_totannDepr =  l_totannDepr
                                     + annDepr.

                 end. /* IF netBook */

                 /* PAGE BREAKING */
 /*              if page-size - line-counter < 3                           */
 /*              then                                                      */
 /*                 page.                                                  */
 /*              {mfrpchk.i}                                               */
              end. /* FOR EACH fauop_det  */
           end.    /* FOR FIRST famt_mstr */
        end. /* ELSE FOR IF CAN-FIND fabd_det */
     end. /* IF FIRST-OF fab_det */
      end.    /* FOR EACH fab_det    */

      if fa_dep   = no
      and nonDepr = yes
      then do:

         /* NETBOOK VALUE IS CALCULATED AS (COSTAMT - ACCDEPR) */
         /* SINCE NON-DEPRECIATING ASSETS HAVE ACCDEPR = 0,    */
         /* NETBOOK IS EQUAL TO COSTAMT.                       */
         assign
            costAmt       = fa_replamt
            accDepr       = 0
            netBook       = if l_retnetbook
                            then
                               0
                            else
                               costAmt
            annDepr       = 0
            l_fab_fabk_id = getTermLabel("NONE",4).

         /* CREATE TEMP TABLE FOR EACH BOOK AND TOTALS */
         create t-bookAccum.
         assign
            bookAsset = fa_id
            bookId    = l_fab_fabk_id
            bookcost  = costAmt
            bookAccdp = accDepr
            bookNet   = netBook.

         if printTot = no
         then do:
            /* IF ASSET IS DIFFERENT PRINT A BLANK LINE */
            /* AND CALCULATE ASSET COUNT.               */
            if oldAsset <> fa_id
            then do:
/*                put skip(1).                                     */
                  assetCnt = assetCnt + 1.
            end. /* IF OLDASSET <> FA_ID */

            /* SAVE OFF ASSET ID TO BE USED ABOVE */
               oldAsset = fa_id.

            /* DISPLAY DETAIL REPORT - NEED TO CHECK LINE    */
            /* COUNTER SINCE UOP ONLY ASSETS COULD CAUSE     */
            /* COLUMN HEADING TO APPEAR IN THE MIDDLE OF RPT */
         
               create tmp_xfa.
               assign tx_faid      = fa_id
                      tx_fa_loc    = fa_faloc_id
                      tx_facls_id  = fa_facls_id
                      tx_auth_nbr  = fa_auth_number
                      tx_saveas    = fa__chr01 + fa__chr02
                      tx_cstcent   = substring(fa_faloc_id,1,4)
                      tx_puramt    = fa_replamt
                      tx_startdt   = fa_startdt
                      tx_salvamt   = fa_salvamt
                      tx_fabk_id   = l_fab_fabk_id
                      tx_costAmt   = costAmt
                      tx_accDepr   = accDepr
                      tx_netBook   = netBook
                      tx_annDepr   = annDepr.
         end. /* IF printTot = no */

         /* CALCULATE TOTALS FOR EACH LOCATION */
         assign
            l_totcostAmt =  l_totcostamt
                          + costAmt
            l_totaccDepr =  l_totaccDepr
                          + accDepr
            l_totnetBook =  l_totnetBook
                          + netBook
            l_totannDepr =  l_totannDepr
                          + annDepr.

         /* PAGE BREAKING */
/*         if page-size - line-counter < 3                                  */
/*         then                                                             */
/*            page.                                                         */
/*         {mfrpchk.i}                                                      */

      end. /* IF fa_dep = no AND  */
   end.    /* IF l_fa_show */

end. /* FOR EACH fa_mstr */

/* WEB ENABLEMENT */
{wbrp04.i}