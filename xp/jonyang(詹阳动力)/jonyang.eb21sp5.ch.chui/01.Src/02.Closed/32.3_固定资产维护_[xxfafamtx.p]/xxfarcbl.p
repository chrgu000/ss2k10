/* farcbl.p - RECAST ADJUSTMENT                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.29.1.20 $                                                         */
/*V8:ConvertMode=NoConvert                                              */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00     BY: *N0L0* Jacolyn Neder */
/* REVISION: 9.1     LAST MODIFIED: 11/20/00     BY: *M0VN* Atul Dhatrak  */
/* Revision: 1.29.1.7  BY: Alok Thacker          DATE: 03/13/02  ECO: *M1NB*  */
/* Revision: 1.29.1.8  BY: Ashish Kapadia        DATE: 06/21/02  ECO: *N1LR*  */
/* Revision: 1.29.1.9  BY: Manish Dani           DATE: 12/20/02  ECO: *M1YW*  */
/* Revision: 1.29.1.10  BY: Rajesh Lokre DATE: 04/03/03 ECO: *M1RX* */
/* Revision: 1.29.1.12  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/* Revision: 1.29.1.14  BY: Veena Lad    DATE: 08/01/03 ECO: *N2J4* */
/* Revision: 1.29.1.15  BY: Dorota Hohol      DATE: 09/01/03 ECO: *P0YS* */
/* Revision: 1.29.1.16  BY: Vivek Gogte       DATE: 09/03/03 ECO: *P121* */
/* Revision: 1.29.1.18    BY: Dorota Hohol      DATE: 10/20/03 ECO: *P138* */
/* Revision: 1.29.1.19    BY: Sandy Brown (OID) DATE: 12/06/03 ECO: *Q04L* */
/* $Revision: 1.29.1.20 $ BY: Reena Ambavi  DATE: 03/18/04  ECO: *P1TP* */

/* SS - 100505.1  By: Roger Xiao */ 
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "FARCBL.P"}

define parameter buffer fa_mstr    for  fa_mstr.
define parameter buffer fab_det    for  fab_det.
define parameter buffer faadj_mstr for  faadj_mstr.
define input  parameter l-year-get as   integer format "9999" no-undo.
define input  parameter l-follyrs  like mfc_logical           no-undo.
define output parameter l-err-nbr  as   integer initial 0     no-undo.

define variable l-open-yrper  like fabd_yrper    no-undo.
define variable l-adj-yrper   like fabd_yrper    no-undo.
define variable l-yrper       like fabd_yrper    no-undo.
define variable l-first-yrper like fabd_yrper    no-undo.
define variable l-final-yrper like fabd_yrper    no-undo.
define variable l-per-total   like fabd_peramt   no-undo.
define variable l-adj-total   like fabd_peramt   no-undo.
define variable l-delta       like fabd_peramt   no-undo.
define variable l-seq         like fabd_seq      no-undo.
define variable l-per         as character       no-undo.
define variable l-numper      as integer         no-undo.
define variable l-diff-accamt like fabd_accamt   no-undo.
define variable l-accamt      like fabd_accamt   no-undo.
define variable l-peramt      like fabd_peramt   no-undo.
define variable l-suspend     like fabd_suspend  no-undo.
define variable l-transfer    like fabd_transfer no-undo.

define variable l-per-amt     like fabd_peramt   no-undo.
define variable l-acc-amt     like fabd_accamt   no-undo.

define variable l-perinloop   as   integer       no-undo.
define variable l-short-year  like mfc_logical   no-undo.
define variable l-sratio      as   decimal       no-undo.

define variable l-tot-accamt      as   decimal                no-undo.
define variable l-temp-total      as   decimal                no-undo.
define variable l-original-numper as   integer                no-undo.
define variable l-adj-yr-numper   as   integer                no-undo.
define variable l-yrget-shortyear like mfc_logical initial no no-undo.
{&FARCBL-P-TAG1}
define variable l-cal             like fabk_calendar no-undo.
define variable l_startper        like fabd_yrper    no-undo.
define variable l_accum_per_total like fabd_peramt   no-undo.
define variable l_last_yrper      like fabd_yrper    no-undo.

define new shared temp-table dep no-undo like fabd_det.

define buffer adj for fabd_det.
define buffer b-fabd for fabd_det.

for first fabk_mstr
    where fabk_mstr.fabk_domain = global_domain and  fabk_id = fab_fabk_id
   no-lock:
end. /* FOR FIRST fabk_mstr */

{gprunp.i "fapl" "p" "fa-get-per"
   "(input  fab_date,
     input  fabk_calendar,
     output l-per,
     output l-err-nbr)"}

if l-err-nbr > 0
then
   return.

{gprunp.i "fapl" "p" "fa-get-perinyr"
   "(input  l-per,
     input  fabk_calendar,
     output l-numper)"}

/* ASSIGN l-short-year AS YES IF CALENDAR DEFINED FOR A SHORT YEAR */
/* THE SHORT YEAR RATIO l-sratio IS NOT REQUIRED IN THIS PROGRAM   */

{gprunp.i "fapl" "p" "fa-shortyear"
   "(input  l-per,
     input  fabk_calendar,
     output l-short-year,
     output l-sratio)"}

/* IF THE FIRST YEAR IS NOT SHORT YEAR THEN STORE  */
/* ORIGINAL NUMBER OF PERIODS                      */
if not l-short-year
then
   l-original-numper = l-numper.

/* FOR ADJUSTMENT FROM UTILITY utrgendp.p., DETERMINE WHETHER */
/* THE YEAR FOR WHICH ADJUSTMENT IS BEING ASKED BY USER IS    */
/* SHORT YEAR OR NOT.                                         */
if l-year-get <> 0
then do:

   {gprunp.i "fapl" "p" "fa-get-perinyr"
             "(input  string(l-year-get),
               input  fabk_calendar,
               output l-numper)"}

   {gprunp.i "fapl" "p" "fa-shortyear"
             "(input  string(l-year-get),
               input  fabk_calendar,
               output l-short-year,
               output l-sratio)"}

   assign
      l-adj-yr-numper   = l-numper
      l-yrget-shortyear = l-short-year.

end.  /* IF l-year-get <> 0 */


assign
   l-adj-total  = 0
   l-adj-yrper  = ""
   l-yrper      = ""
   l-open-yrper = "".

/* SET CALENDAR FOR THIS BOOK */

for first fabk_mstr
   fields(fabk_domain fabk_calendar fabk_id fabk_post)
   where fabk_mstr.fabk_domain = global_domain
   and   fabk_id = fab_fabk_id:
end. /* FOR FIRST fabk_mstr */

if available fabk_mstr
then
   l-cal = if fabk_post
           then
              ""
           else
              fabk_calendar.
else
do:
   /* INVALID BOOK CODE */
   l-err-nbr = 4214.
   return.
end. /* ELSE DO */

/* FIND DEPRECIATION METHOD. */

for first famt_mstr
   fields(famt_domain famt_active famt_actualdays famt_conv famt_elife
          famt_id famt_perc famt_switchsl famt_type)
   where famt_mstr.famt_domain = global_domain
   and   famt_id = fab_famt_id
   no-lock:
end. /* FOR FIRST famt_mstr */

if not available famt_mstr or
   (available famt_mstr and not famt_active) then
do:
   /* INVALID DEPRECIATION METHOD */
   l-err-nbr = 4200.
   return.
end. /* IF NOT AVAILABLE famt_mstr */

{gprunp.i "fapl" "p" "fa-get-per"
   "(input  fab_date,
     input  l-cal,
     output l_startper,
     output l-err-nbr)"}
if l-err-nbr <> 0
then
   return.

/* FIND FIRST ELIGIBLE PERIOD FOR ADJUSTMENT */
/* IF CALLED FROM UTILITY THEN FIND FIRST    */
/* ELIGIBLE PERIOD FOR THE YEAR FOR WHICH    */
/* THE UTILITY utrgendp.p IS RUN             */

l-openyr:
for each b-fabd
   fields(fabd_domain fabd_yrper fabd_fa_id fabd_post fabd_suspend
          fabd_fabk_id)
   where b-fabd.fabd_domain = global_domain
   and   fabd_fa_id         = fab_fa_id
   and   fabd_fabk_id       = fab_fabk_id
   and   fabd_post          = no
   and   fabd_suspend       = no
   and   (if l-year-get <> 0
          then
             fabd_yrper begins string(l-year-get)
          else
             true)
   no-lock
   use-index fabd_fa_id:

   /* WHEN CALLED FROM UTILITY, FOR CONVENTION 3 WITH ACUTAL */
   /* DAYS SET TO NO, DO NOT DELETE THE DEPRECIAITON RECORDS */
   /* OF THE ADJUSTMENT YEAR FOR PERIODS NOT IN THE LOGICAL  */
   /* YEAR. ALSO SKIP THE POSTED RECORDS                     */

   if l-year-get <> 0
   and famt_conv = "3"
   and not famt_actualdays
   and (fabd_post or fabd_yrper <=
        string(l-year-get) + substring(l_startper,5,2))
   then
      next.
   else do:
      l-open-yrper = fabd_yrper.
      leave l-openyr.
   end. /* ELSE DO */

end. /* FOR EACH b-fabd */

/* FIND THE FIRST PERIOD IN THE CURRENT SCHEDULE */
/* IF CALLED FROM UTILITY utrgendp.p THEN FIND FIRST */
/* ELIGIBLE PERIOD IN THE CURRENT SCHEDULE FOR       */
/* THE YEAR FOR WHICH THE UTILITY utrgendp.p IS RUN. */
l-firstyr:
for each b-fabd
   fields(fabd_domain fabd_fa_id fabd_fabk_id fabd_post fabd_yrper)
   where b-fabd.fabd_domain = global_domain
   and   fabd_fa_id         = fab_fa_id
   and   fabd_fabk_id       = fab_fabk_id
   and   (if l-year-get <> 0
          then
             fabd_yrper begins string(l-year-get)
          else
             true)
   no-lock
   use-index fabd_fa_id:

      /* WHEN CALLED FROM UTILITY, FOR CONVENTION 3 WITH ACUTAL */
      /* DAYS SET TO NO, DO NOT DELETE THE DEPRECIAITON RECORDS */
      /* OF THE ADJUSTMENT YEAR FOR PERIODS NOT IN THE LOGICAL  */
      /* YEAR                                                   */

      if l-year-get <> 0
      and famt_conv = "3"
      and not famt_actualdays
      and (fabd_yrper <=
          string(l-year-get) + substring(l_startper,5,2))
      then
         next.
      else do:
         assign
            l-first-yrper = b-fabd.fabd_yrper
            l-yrper       = l-first-yrper.
         leave l-firstyr.
      end. /* ELSE DO */

end. /* FOR EACH b-fabd */

/* FIND THE FINAL PERIOD IN THE CURRENT SCHEDULE */
for last b-fabd
   fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper)
    where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id   =
    fab_fa_id
   and   b-fabd.fabd_fabk_id = fab_fabk_id
   no-lock
   use-index fabd_fa_id:
end. /* FOR LAST b-fabd */


/* GET NEW DEPRECIATION SCHEDULE                 */
/* ADDED 1st INPUT PARAMETER AS 'no' THIS WILL   */
/* SKIP THE VALIDATION FOR A COMPLETELY DEFINED  */
/* NEXT CALENDAR YEAR. THIS CHECK IS ONLY FOR AN */
/* ASSET ADDED IN A SHORT YEAR                   */

/* ADDED 5TH AND 6TH PARAMETERS AS THE YEAR FOR ADJUSTMENT   */
/* AND DEPRECIATION CALCULATION FOR FOLLOWING YEARS IS       */
/* NEEDED OR NOT RESPECTIVELY. THESE PARAMETERS WILL BE zero */
/* AND no RESPECTIVELY EXCEPT FOR UTILITY utrgendp.p         */
{&FARCBL-P-TAG10}

{gprun.i ""fadpbla.p""
   "(input  no,
     input  faadj_resrv,
     buffer fa_mstr,
     buffer fab_det,
     input  l-year-get,
     input  l-follyrs,
     output l-err-nbr)"}.

{&FARCBL-P-TAG11}

if l-err-nbr > 0
then
   return.

/* SS - 100505.1 - B */
        /*不追溯调整:直线折旧法,且全期间或下期间算法时,*/
        for first famt_mstr
            where famt_mstr.famt_domain = global_domain 
            and  famt_id = fab_famt_id
        no-lock:
        end.
        if avail famt_mstr 
           and famt_type = "1" 
           and (famt_conv = "1" or famt_conv = "3" )
        then do:
         
            define var perBeg          as character format "x(6)" no-undo. /*开始期间*/
            define var perEnd          as character format "x(6)" no-undo. /*结束期间*/
            define var l_error      as   integer      no-undo.
            define var v_mth_oldyr  as decimal format ">>>>9.99" no-undo .
            define var v_mth_thisyr as decimal format ">>>>9.99" no-undo .         
            define var v_mth_post as decimal .   /*已过账的折旧期间数*/
            define var v_per_post as char    .   /*已过账的最后期间*/
            define var v_mth_life as integer .   /*调整后,新寿命*/

            define var v_amt_post as decimal .   /*已过账的折旧金额*/
            define var v_amt_left as decimal .   /*剩余可折旧金额*/
            define var v_amt_per  as decimal .   /*每月分摊*/
            define var v_amt_acc  as decimal .   /*预期累计折旧*/

            v_mth_post = 0 .
            v_amt_post = 0 .
            v_per_post = "" .
            for each fabd_det
                where fabd_det.fabd_domain = global_domain 
                and  fabd_fa_id   = fab_fa_id
                and  fabd_fabk_id = fab_fabk_id
                and  fabd_post    = yes 
            no-lock 
            break by fabd_fa_id by fabd_yrper :
                /*if first-of(fabd_yrper) then v_mth_post = v_mth_post + 1 . **有的期间不连续,不能这样算*/
                if last-of(fabd_fa_id) then assign v_amt_post = fabd_accamt v_per_post = fabd_yrper .
            end.

                    

            /*服务日期所在期间,可能小于初始折旧期间*/
            {gprunp.i "fapl" "p" "fa-get-per"
                  "(input  fab_date,
                    input  """",
                    output perBeg,
                    output l_error)"}
            if l_error <> 0 then  perBeg = string(year(fab_date), "9999") + string(month(fab_date), "99").

            /*查找最后一个期间*/  /*调整后,新寿命*/
            v_mth_life = 0 .
            perend = "" .
            for each dep no-lock break by dep.fabd_fa_id by dep.fabd_yrper : 
                v_mth_life = v_mth_life + 1 .
                if last-of(dep.fabd_fa_id) then perEnd = dep.fabd_yrper .
            end.


            /*已提折旧月数*/
            v_mth_oldyr  = 0 .
            v_mth_thisyr = 0 .
            {gprunp.i "xxfain01" "p" "get-mth-used"
                  "(input  v_mth_life,
                    input  """" ,
                    input  perBeg,
                    input  perEnd,
                    input  v_per_post,
                    output v_mth_oldyr,
                    output v_mth_thisyr")}  
            v_mth_post   = v_mth_oldyr + v_mth_thisyr .
        
            
            
            
            
            
            
            
            /*调整后,新成本(扣除残值when famt_salv = yes) */
            {gprunp.i "fapl" "p" "fa-get-basis" "(input  fab_fa_id, input  fab_fabk_id, output v_amt_left)"}

            /*每月分摊 = 剩余可折旧金额/ 剩余可折旧期间 */ 
            if v_mth_life - v_mth_post > 0 then v_amt_per = (v_amt_left - v_amt_post) / (v_mth_life - v_mth_post) .

            /*精确到两位小数*/
            v_amt_per = round(v_amt_per,2) .

/*
if global_userid = "mfg" then 
message "每期" v_amt_per "已过账" v_amt_post "净值" (v_amt_left - v_amt_post) skip
        "寿命" v_mth_life "已提月数" v_mth_post " = 之前" v_mth_oldyr "+本年" v_mth_thisyr skip
        "起始" perBeg  "结束" perEnd "最后过账" v_per_post
        view-as alert-box.
*/ 
            /*调整产生的临时表dep,create in fadpbla.p*/
            v_amt_acc = 0.
            for each dep break by dep.fabd_yrper :
                find first fabd_det
                    where fabd_det.fabd_domain = global_domain 
                    and  fabd_det.fabd_fa_id   = fab_fa_id
                    and  fabd_det.fabd_fabk_id = fab_fabk_id
                    and  fabd_det.fabd_yrper   = dep.fabd_yrper 
                    and  fabd_det.fabd_post    = yes 
                no-lock no-error .
                if avail fabd_det then assign dep.fabd_peramt = fabd_det.fabd_peramt .
                else do:
                    if dep.fabd_yrper <= v_per_post then do:
                        dep.fabd_peramt = 0 .
                    end.
                    else dep.fabd_peramt = v_amt_per .                    
                end.

                /*四舍五入的差异记录在最后期间*/
                v_amt_acc = v_amt_acc + dep.fabd_peramt .
                if last(dep.fabd_yrper) and v_amt_acc <> v_amt_left then do:
                    dep.fabd_peramt = dep.fabd_peramt + ( v_amt_left - v_amt_acc) .
                end.

            end. /*for each dep*/

            /*test****
            for each dep no-lock with frame x :
            disp dep.fabd_yrper dep.fabd_peramt  dep.fabd_accamt .
            end.
            pause.
            hide frame x no-pause .
            ******/

        end. /*if avail famt_mstr and*/
/* SS - 100505.1 - E */





/* FIND LAST PERIOD FROM TEMP TABLE DEP */
for last dep
    where dep.fabd_domain = global_domain and  dep.fabd_fa_id   = fab_fa_id
   and   dep.fabd_fabk_id = fab_fabk_id
   no-lock
   use-index fabd_fa_id:
end.  /* FOR LAST dep */

/* COMPARE LAST PERIOD OF TEMP TABLE AND DB TABLE fabd_det */
/* AND ASSIGN GREATER OF THE TWO AS FINAL PERIOD           */
assign
   l-final-yrper = (if available dep
                    then
                       (if dep.fabd_yrper <= b-fabd.fabd_yrper
                        then
                           b-fabd.fabd_yrper
                        else
                           dep.fabd_yrper)
                    else
                       b-fabd.fabd_yrper)
   l_last_yrper  = b-fabd.fabd_yrper
   l-diff-accamt = 0.

/* IF CALLED FROM UTILITY utrgendp.p, THEN FIND FIRST */
/* dep WHERE THE YEAR IS SAME AS THAT ASKED BY USER   */
/* IN THE UTILITY utrgendp.p                          */
for first dep
    where dep.fabd_domain = global_domain and  (if l-year-get <> 0
          then
             dep.fabd_yrper begins string(l-year-get)
          else
             true)
   no-lock
   use-index fabd_fa_id:
end.  /* FOR FIRST dep */


/* IF ORIGINAL SCHEDULE DOESN'T NOT START FROM BEGIN (HAPPENS WITH */
/* MIGRATED ASSETS), CALCULATE THE AMOUNT DIFFERENCE PRIOR TO THE  */
/* START OF THE ORIGINAL SCHEDULE                                  */

if available dep
   and dep.fabd_yrper < l-first-yrper
then do:
   for first dep
      fields( fabd_domain fabd_peramt fabd_yrper fabd_accamt)
       where dep.fabd_domain = global_domain and  dep.fabd_yrper = l-first-yrper
      no-lock:
   end. /* FOR FIRST dep */

   if available dep
   then
      l-diff-accamt = dep.fabd_accamt - dep.fabd_peramt.

   {gprunp.i "fapl" "p" "fa-get-accdep"
      "(input  fab_fa_id,
        input  fab_fabk_id,
        input  l-first-yrper,
        output l-accamt)"}

   {gprunp.i "fapl" "p" "fa-get-perdep"
      "(input  fab_fa_id,
        input  fab_fabk_id,
        input  l-first-yrper,
        output l-peramt)"}

   l-diff-accamt = l-diff-accamt - l-accamt + l-peramt.
end.  /* IF dep.fabd_yrper < l-first-yrper */

/* FOR ASSETS, DEPRECIATION PER PERIOD IS CALCULATED FROM            */
/* ACCUMULATED DEPRECIATION DIVIDED EQUALLY BETWEEN ALL PERIODS FROM */
/* SERVICE DATE TO OVERRIDE DATE, USED TO COMPARE WITH DEP TABLE     */

run ip-cal-peramt
   (input  fab_fa_id,
    input  fab_fabk_id,
    output l-per-amt).

/* CYCLE THROUGH NEW SCHEDULE */
/* CYCLE THROUGH NEW SCHEDULE COMPLETELY ONLY IF USER HAS SELECTED   */
/* FOLLOWING YEARS AS yes OR IF THE ADJUSTMENT YEAR IS A SHORT YEAR. */
/* OTHERWISE CYCLE THROUGH THE ADJUSTMENT YEAR ONLY.                 */

for each dep
    where dep.fabd_domain = global_domain and  dep.fabd_yrper >= l-first-yrper
   and   (if  l-year-get <> 0
          and not l-follyrs
          and not l-yrget-shortyear
          then
             dep.fabd_yrper < string(l-year-get + 1)
          else
             true)
   no-lock
   break by dep.fabd_fa_id:

   NEXT-DEP-PER:
   repeat:

      /* LOGIC BELOW GETS THE CORRECT NUMBER OF PERIODS (l-numper) */
      /* IN THE NEXT YEAR. i.e  AFTER THE SHORT YEAR IS COMPLETE.  */
      /* THE VARIABLE l-perinloop WILL TRACK THE PERIOD IN THE LOOP */
      {&FARCBL-P-TAG2}
      if l-short-year
      then do:
         if l-perinloop = l-numper + 1
         then do:
            {gprunp.i "fapl" "p" "fa-get-perinyr"
               "(input  l-adj-yrper,
                 input  fabk_calendar,
                 output l-numper)"}
            l-short-year = no.
         end. /* if l-perinloop .... */
         l-perinloop = l-perinloop + 1.
      end. /* IF l-short-year .... */

      if l-adj-yrper = ""
      then
         l-adj-yrper = l-first-yrper.
      else do:
         {gprunp.i "fapl" "p" "fa-get-nextper"
            "(input  l-adj-yrper,
              input  l-numper,
              output l-adj-yrper)"}
      end. /* ELSE DO */

      /* FOR ADJUSTMENT YEAR FROM UTILITY utrgendp.p AND FOR    */
      /* FOLLOWING YEARS FROM UTILITY, WE NEED TO ASSIGN NUMBER */
      /* OF PERIODS IN ADJUSTMENT YEAR                          */
      if  l-year-get <> 0
      then do:

         if dep.fabd_yrper begins string(l-year-get)
         or (l-follyrs
             and integer(substring(dep.fabd_yrper,1,4)) > l-year-get)
         then
            l-numper = l-adj-yr-numper.
         else
            l-numper = l-original-numper.

      end.    /* IF l-year-get */

      /* IF DEPRECIATION IS SUSPENDED, ADJUST THE ACCUMULATED */
      /* DEPRECIATION IF NECESSARY                            */
      {gprunp.i "fapl" "p" "fa-get-suspend"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  l-adj-yrper,
           output l-suspend)"}
      if l-suspend
      then do:
         if l-adj-yrper >= l-open-yrper
            and l-adj-total <> 0
         then do:

            {gprunp.i "fapl" "p" "fa-get-transfer"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  l-adj-yrper,
                 output l-transfer)"}

            create fabd_det. fabd_det.fabd_domain = global_domain.
            {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and " fabd_det
            fabd_seq fabd_sq01 l-seq}
            buffer-copy
               dep
                  except oid_fabd_det
                     fabd_yrper
                     fabd_seq
                     fabd_post
                     fabd_suspend
                     fabd_peramt
                     fabd_accamt
                     fabd_resrv
                     fabd_resrv_type
                     fabd_adj_yrper
                     fabd_mod_userid
                     fabd_mod_date
                     fabd_transfer
               to fabd_det.
            fabd_det.fabd_domain = global_domain.

            assign
               fabd_det.fabd_yrper      = l-adj-yrper
               fabd_det.fabd_seq        = l-seq
               fabd_det.fabd_post       = no
               fabd_det.fabd_suspend    = yes
               fabd_det.fabd_transfer   = l-transfer
               fabd_det.fabd_peramt     = 0
               fabd_det.fabd_accamt     = l-adj-total
               fabd_det.fabd_resrv      = faadj_resrv
               fabd_det.fabd_resrv_type = faadj_type
               fabd_det.fabd_adj_yrper  = l-adj-yrper
               fabd_det.fabd_mod_user   = global_userid
               fabd_det.fabd_mod_date   = today.

            if recid (fabd_det) = -1
            then .

         end.  /* IF l-adj-yrper > ... */
      end.  /* IF l-suspend ... */
      else
         leave NEXT-DEP-PER.
   end.  /* NEXT-DEP-PER */

   assign
      l-yrper     = l-adj-yrper
      l-per-total = 0.

   /* IF FINAL PERIOD IS REACHED THEN DO NOT ITERATE ANY MORE */
   if  l-year-get <> 0
   and l-yrper     > l-final-yrper
   and not l-yrget-shortyear
   then
      leave.

   /* FIND OUT LAST FABD_DET RECORD LESS THAN OR EQUAL TO */
   /* CURRENT ADJUSTMENT PERIOD TO GET VALUE OF PERIOD    */
   /* DEPRECIATION AND ACCUMULATED DEPRECIATION           */
   for last b-fabd
      fields( fabd_domain fabd_yrper fabd_fa_id fabd_peramt fabd_accamt
      fabd_fabk_id)
       where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id   =
       fab_fa_id
      and b-fabd.fabd_fabk_id   = fab_fabk_id
      and b-fabd.fabd_yrper     <= l-adj-yrper
      no-lock
      use-index fabd_fa_id:
   end. /* FOR LAST b-fabd */

   if l-adj-yrper < l-open-yrper
   then do:
      /* CATCH UP ADJUSTMENT */
      run ip-adjust
         (l-adj-yrper,
          output l-per-total).
      l-yrper = l-open-yrper.

      /* l-acc-amt IS USED TO ACCUMULATE l-per-amt TO CALCULATE */
      /* CORRECT ADJUSTMENT DEPRECIATION OF OVERRIDING DATE     */
      /* OF NEWLY ENTERED ASSET WITH OVERRIDING AMOUNT          */

      if ((b-fabd.fabd_peramt    =  0
           or  b-fabd.fabd_accamt  =  0)
         and dep.fabd_post       =  yes)
         and b-fabd.fabd_peramt  <>  fab_det.fab_ovramt
         and fab_ovrdt           <>  ?
      then
         assign
            l-acc-amt   = l-acc-amt   + l-per-amt
            l-per-total = l-per-total + l-per-amt.

   end. /* IF l-adj-yrper < l-open-yrper */
   else do:
      {gprunp.i "fapl" "p" "fa-get-cur-perdep"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  l-adj-yrper,
           output l-per-total)"}
   end. /* ELSE DO */

   if l-per-total <> 0
   then
      l_accum_per_total = l_accum_per_total + l-per-total.

   /* IN CASE OF NEWLY CREATED ASSET l-per-total CONTAINS OVERRIDDING */
   /* AMOUNT, RESULTS IN WRONG ADJUSTMENT RECORD FOR OVERRIDDING      */
   /* PERIOD, HENCE SUBTRACTING l-acc-amt FROM l-per-total TO CREATE  */
   /* CORRECT ADJUSTMENT RECORD                                       */

   if (b-fabd.fabd_peramt = fab_det.fab_ovramt)
      and fab_ovrdt <> ?
   then
      l-delta = dep.fabd_peramt - (l-per-total - l-acc-amt).
   else
      l-delta = dep.fabd_peramt - l-per-total.

   if dep.fabd_yrper = l-first-yrper
   then
      l-delta = l-delta + l-diff-accamt.
   {&FARCBL-P-TAG3}

   /* FOR LIFE ADJUSTMENT TO INCREASE THE LIFE THE FIRST NEW PERIODS */
   /* ACCUMULATED DEPRECIATION CALCULATED SHOULD CONSIDER THE        */
   /* ACCUMULATED DEPRECIATION OF THE PRIOR PERIOD                   */
   if l-per-total = 0
      and dep.fabd_yrper > l_last_yrper
   then
      l-adj-total = l-adj-total + l-delta + l_accum_per_total.
   else
      l-adj-total = l-adj-total + l-delta.

   if l-per-total = 0
      and dep.fabd_yrper > l_last_yrper
   then
      l_accum_per_total = 0.

   /* DETERMINE THE CORRECT ACCUMULATED DEPRECIATION */
   /* SO FAR WHEN CALLED FROM UTILITY utrgendp.p     */
   if  l-year-get    <> 0
   and dep.fabd_post  = no
   then do:

      l-tot-accamt = 0.

      for each adj
          where adj.fabd_domain = global_domain and  adj.fabd_fa_id   =
          dep.fabd_fa_id
         and   adj.fabd_fabk_id = dep.fabd_fabk_id
         and   adj.fabd_yrper   = dep.fabd_yrper
         no-lock
         use-index fabd_fa_id:

         l-tot-accamt = l-tot-accamt + adj.fabd_accamt.

      end.  /* FOR EACH adj */

      if  l-adj-total <> l-tot-accamt - dep.fabd_accamt
      then
         l-adj-total = dep.fabd_accamt - l-tot-accamt.

   end.  /* IF l-year-get <> 0... */

   if l-delta <> 0
      or (l-adj-yrper >= l-open-yrper
          and l-adj-total <> 0)
   then do:

      {gprunp.i "fapl" "p" "fa-get-suspend"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  l-yrper,
           output l-suspend)"}

      {gprunp.i "fapl" "p" "fa-get-transfer"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  l-yrper,
           output l-transfer)"}

      create fabd_det. fabd_det.fabd_domain = global_domain.
      {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and " fabd_det
      fabd_seq fabd_sq01 l-seq}
      buffer-copy
         dep
            except oid_fabd_det
               fabd_yrper
               fabd_seq
               fabd_post
               fabd_suspend
               fabd_peramt
               fabd_accamt
               fabd_resrv
               fabd_resrv_type
               fabd_adj_yrper
               fabd_mod_userid
               fabd_mod_date
         to fabd_det.
      fabd_det.fabd_domain = global_domain.
      assign
         fabd_det.fabd_seq        = l-seq
         fabd_det.fabd_yrper      = l-yrper
         fabd_det.fabd_post       = no
         fabd_det.fabd_suspend    = l-suspend
         fabd_det.fabd_transfer   = l-transfer
         {&FARCBL-P-TAG4}
         fabd_det.fabd_peramt     = l-delta
         {&FARCBL-P-TAG5}
         fabd_det.fabd_accamt     = (if l-adj-yrper < l-open-yrper
                                     then 0
                                     else l-adj-total)
         fabd_det.fabd_resrv      = faadj_resrv
         fabd_det.fabd_resrv_type = faadj_type
         fabd_det.fabd_adj_yrper  = l-adj-yrper
         fabd_det.fabd_mod_user   = global_userid
         fabd_det.fabd_mod_date   = today.

      if recid (fabd_det) = -1
      then .
   end.  /* IF l-delta <> 0 .... */

   /* ADJUST THE CURRENT ADJUSTMENT TOTAL FOR NEWLY EXTENDED SCHEDULE */
   if (l-adj-yrper = l-final-yrper
       and not l-yrget-shortyear)
   or (l-year-get <> 0
       and last(dep.fabd_fa_id))
   then do:
      {gprunp.i "fapl" "p" "fa-get-accdep"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  l-adj-yrper,
           output l-adj-total)"}
   end.  /* IF l-adj-yrper = l-final-yrper */
   {&FARCBL-P-fTAG6}
end.  /* FOR EACH dep */

if l-adj-yrper < l-open-yrper
then do:
   /* DEPRECIATION ALREADY POSTED FOR ADJUSTMENT PERIOD */
   l-err-nbr = 3225.
   return.
end. /* IF l-adj-yrper < l-open-yrper */
{&FARCBL-P-TAG7}

/* CURRENT LIFE IS LONGER THAN THE NEW LIFE */
for each b-fabd
    where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id   =
    fab_fa_id
   and   b-fabd.fabd_fabk_id = fab_fabk_id
   and   b-fabd.fabd_yrper   > l-adj-yrper
   no-lock
   break by b-fabd.fabd_yrper:

   if  l-year-get <> 0
   and not l-follyrs
   and not (b-fabd.fabd_yrper begins string(l-year-get))
   then
      leave.


   if first-of(b-fabd.fabd_yrper)
   then do:
      {gprunp.i "fapl" "p" "fa-get-suspend"
         "(input  fab_fa_id,
           input  fab_fabk_id,
           input  b-fabd.fabd_yrper,
           output l-suspend)"}
      if l-suspend
      then
         l-per-total = 0.
      else do:
         {gprunp.i "fapl" "p" "fa-get-perdep"
            "(input  fab_fa_id,
              input  fab_fabk_id,
              input  b-fabd.fabd_yrper,
              output l-per-total)"}

         /* MAINTAIN EXISTING RECAST ADJUSTMENT FUNCTIONALITY */
         if l-year-get = 0
         then
            assign
               l-adj-total = l-adj-total - l-per-total.
         /* ADJUSTMENT WHEN CALLED FROM UTILITY utrgendp.p */
         else do:

            l-temp-total = 0.
            for each adj
               fields( fabd_domain adj.fabd_accamt)
                where adj.fabd_domain = global_domain and  adj.fabd_fa_id   =
                b-fabd.fabd_fa_id
               and   adj.fabd_fabk_id = b-fabd.fabd_fabk_id
               and   adj.fabd_yrper   = b-fabd.fabd_yrper
               use-index fabd_fa_id
               no-lock:

               l-temp-total = l-temp-total + adj.fabd_accamt.

            end.  /* FOR EACH adj */
         end.  /* ELSE DO */

      end. /* ELSE DO */

      create fabd_det. fabd_det.fabd_domain = global_domain.
      {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and " fabd_det
      fabd_seq fabd_sq01 l-seq}
      buffer-copy
         b-fabd
            except oid_fabd_det
               fabd_seq
               fabd_peramt
               fabd_accamt
               fabd_resrv
               fabd_resrv_type
               fabd_adj_yrper
               fabd_mod_userid
               fabd_mod_date
         to fabd_det.
      fabd_det.fabd_domain = global_domain.
      assign
         fabd_det.fabd_seq        = l-seq
         fabd_det.fabd_peramt     = - l-per-total
         fabd_det.fabd_accamt     = l-adj-total - l-temp-total
         fabd_det.fabd_resrv      = faadj_resrv
         fabd_det.fabd_resrv_type = faadj_type
         fabd_det.fabd_adj_yrper  = fabd_det.fabd_yrper
         fabd_det.fabd_mod_user   = global_userid
         fabd_det.fabd_mod_date   = today.

      if recid (fabd_det) = -1
      then .
   end.  /* IF first-of ... */
end.  /* FOR EACH b-fabd */

{&FARCBL-P-TAG9}

/* CREATE REVERSAL ENTRY FOR THOSE PERIODS WHICH ARE  */
/* NOT EXISTING IN CALENDAR ANYMORE                   */
if (l-year-get <> 0
    and (l-follyrs
         or l-yrget-shortyear))
then
   run create-reverse-entry.


PROCEDURE ip-adjust:

   define input  parameter l-cur-yrper as character         no-undo.
   define output parameter l-per-total as decimal initial 0 no-undo.

   /* Total for adjustment made to a later period */
   for each adj
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_adj_yrper fabd_peramt)
       where adj.fabd_domain = global_domain and  fabd_fa_id     =
       fab_det.fab_fa_id
      and   fabd_fabk_id   = fab_det.fab_fabk_id
      and   fabd_adj_yrper = l-cur-yrper
      no-lock:
      accumulate fabd_peramt (total).
   end. /* FOR EACH adj */
   l-per-total = accum total fabd_peramt.

END PROCEDURE.

PROCEDURE ip-cal-peramt:

   define input  parameter l-asset like dep.fabd_fa_id             no-undo.
   define input  parameter l-book  like dep.fabd_fabk_id           no-undo.
   define output parameter l-amt   like dep.fabd_peramt initial 0  no-undo.

   define variable l-yrper         like dep.fabd_yrper             no-undo.
   define variable l-err           as   integer         initial 0  no-undo.

   define buffer b_fab_det for fab_det.

   /* FIND OUT IF ANY OVERRIDE AMOUNT IS ENTERED OR NOT */
   for first b_fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_ovramt fab_ovrdt)
       where b_fab_det.fab_domain = global_domain and  b_fab_det.fab_fa_id   =
       l-asset
      and   b_fab_det.fab_fabk_id =  l-book
      and   b_fab_det.fab_ovramt  <> 0
      and   b_fab_det.fab_ovrdt   <> ?
      no-lock
      use-index fab_fa_id:
   end. /* FOR FIRST b-fab-det */

   if available b_fab_det
   then do:
      /* FIND OUT YEAR AND PERIOD OF ASSET FROM IT'S OVERRIDING DATE    */
      /* CHECK WHETHER FIXED ASSET CALENDAR OR MFG/PRO CALENDAR IS USED */
      for first fabk_mstr
          where fabk_mstr.fabk_domain = global_domain and  fabk_id = l-book
      no-lock:
      end. /* FOR FIRST fabk_mstr */

      /* l-per-amt RETURNS ZERO IN CASE OF ERROR */
      {gprunp.i "fapl" "p" "fa-get-per"
         "(input  fab_ovrdt,
           input  fabk_calendar,
           output l-yrper,
           output l-err)"}

      if l-err <> 0
      then
         return.

      /* CHECK WHETHER ASSET IS NEWLY ENTERED OR NOT */
      for first b-fabd
         fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_peramt
         fabd_accamt)
          where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id   =
          b_fab_det.fab_fa_id
         and   b-fabd.fabd_fabk_id = b_fab_det.fab_fabk_id
         and   b-fabd.fabd_yrper   = l-yrper
         and   b-fabd.fabd_peramt  = b-fabd.fabd_accamt
         no-lock
         use-index fabd_fa_id:
      end. /* FOR FIRST b-fabd */

      if not available b-fabd
      then do:
         /* ASSET IS MIGRATED ONE */
         for last b-fabd
            fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_peramt
            fabd_accamt)
             where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id
             =  b_fab_det.fab_fa_id
            and   b-fabd.fabd_fabk_id =  b_fab_det.fab_fabk_id
            and   b-fabd.fabd_peramt  =  0
            and   b-fabd.fabd_accamt  <> 0
            no-lock
            use-index fabd_fa_id:
         end. /* FOR LAST FABD_DET */
         if not available b-fabd
         then
            leave.
      end. /* IF NOT AVAILABLE b-fabd */

      /* l-per-amt RETURNS ZERO IN CASE OF ERROR */
      {gprunp.i "fapl" "p" "fa-get-per"
         "(input  fa_mstr.fa_startdt,
           input  fabk_calendar,
           output l-yrper,
           output l-err)"}

      if l-err <> 0
      then
         return.
      l-amt   = fabd_accamt
                / ((integer(substring(fabd_yrper,1,4))
                    - integer(substring(l-yrper,1,4)))
                   * l-numper
                   + (integer(substring(fabd_yrper,5,6))
                      - integer(substring(l-yrper,5,6)))
                   + 1).
   end. /* IF AVAILABLE fab_det */
   else
      leave.

END PROCEDURE. /* END OF ip-cal-peramt */

PROCEDURE create-reverse-entry:

   for each b-fabd
       where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id   =
       fab_det.fab_fa_id
      and   b-fabd.fabd_fabk_id = fab_det.fab_fabk_id
      use-index fabd_fa_id
      no-lock:

      if not can-find(first dep
                       where dep.fabd_domain = global_domain and
                       dep.fabd_fa_id   = b-fabd.fabd_fa_id
                      and   dep.fabd_fabk_id = b-fabd.fabd_fabk_id
                      and   dep.fabd_yrper   = b-fabd.fabd_yrper
                      and   dep.fabd_resrv   = faadj_mstr.faadj_resrv
                      no-lock)
      then do:

         /* IF fabd_det IS CREATED BY ONE OF THE OTHER CONDITIONS */
         /* IN THE PROGRAM THEN WE NEED NOT CREATE IT AGAIN.      */
         if can-find(first adj
                      where adj.fabd_domain = global_domain and (
                      adj.fabd_fa_id   = b-fabd.fabd_fa_id
                     and   adj.fabd_fabk_id = b-fabd.fabd_fabk_id
                     and   adj.fabd_yrper   = b-fabd.fabd_yrper
                     and   adj.fabd_resrv   = faadj_mstr.faadj_resrv
                     ) no-lock)
         or b-fabd.fabd_resrv = faadj_mstr.faadj_resrv
         then
            next.

         {gprunp.i "fapl" "p" "fa-get-perdep"
                   "(input  fab_fa_id,
                     input  fab_fabk_id,
                     input  b-fabd.fabd_yrper,
                     output l-per-total)"}

         if l-per-total = 0
         then
            next.

         create fabd_det. fabd_det.fabd_domain = global_domain.
         {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and " fabd_det
         fabd_seq fabd_sq01 l-seq}
         buffer-copy
            b-fabd
               except oid_fabd_det
                  fabd_seq
                  fabd_peramt
                  fabd_accamt
                  fabd_resrv
                  fabd_resrv_type
                  fabd_adj_yrper
                  fabd_mod_userid
                  fabd_mod_date
            to fabd_det.
         fabd_det.fabd_domain = global_domain.
         assign
            fabd_det.fabd_seq        = l-seq
            fabd_det.fabd_peramt     = - l-per-total
            fabd_det.fabd_accamt     = l-adj-total - l-per-total
            fabd_det.fabd_resrv      = faadj_mstr.faadj_resrv
            fabd_det.fabd_resrv_type = faadj_mstr.faadj_type
            fabd_det.fabd_adj_yrper  = fabd_det.fabd_yrper
            fabd_det.fabd_mod_user   = global_userid
            fabd_det.fabd_mod_date   = today
            l-per-total              = 0.

         if recid (fabd_det) = -1
         then.

      end.  /* IF NOT CAN-FIND(FIRST dep... */

      /* KEEP l-adj-total UPDATED WITH ACCUMULATED DEPRECIATION */
      /* SO FAR FOR THE CURRENT RESERVE CODE                    */
      l-adj-total  = if b-fabd.fabd_resrv = faadj_mstr.faadj_resrv
                     then
                        b-fabd.fabd_accamt
                     else
                        (if available fabd_det
                         then
                            fabd_det.fabd_accamt
                         else
                            l-adj-total).

   end.  /* FOR EACH b-fabd */

END PROCEDURE.  /* create-reverse-entry */
/* EOF - farcbl.p */
