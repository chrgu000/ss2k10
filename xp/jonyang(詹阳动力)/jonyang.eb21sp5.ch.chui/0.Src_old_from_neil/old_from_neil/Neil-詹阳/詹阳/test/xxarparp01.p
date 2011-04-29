/* GUI CONVERTED from arparp01.p (converter v1.71) Fri Aug 21 18:36:40 1998 */
/* arparp01.p - DETAIL APPLY UNAPPLIED AUDIT REPORT                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert arparp01.p (converter v1.00) Fri Oct 10 13:57:06 1997 */
/* web tag in arparp01.p (converter v1.00) Mon Oct 06 14:17:23 1997 */
/*F0PN*/ /*K1DN*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 10/05/89   BY: MLB *B326*          */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*          */
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D153*          */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*          */
/* REVISION: 6.0      LAST MODIFIED: 03/19/91   BY: MLB *D444*          */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: bjb *D507*          */
/* REVISION: 7.0      LAST MODIFIED: 02/01/92   BY: pml *F128*          */
/*                                   03/04/92   by: jms *F237*          */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   by: jms *G024*          */
/*                                   09/27/92   By: jcd *G247*          */
/*                                   02/25/93   By: skk *G746*          */
/*                                   08/23/94   By: rxm *GL40*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*          */
/* REVISION: 8.5      LAST MODIFIED: 12/14/95   by: taf & mwd *J053*    */
/*                                   04/09/96   by: jzw *G1P6*          */
/*                                   07/29/96   by: taf *J101*          */
/* REVISION: 8.6      LAST MODIFIED: 12/16/97   by: bvm *K1DN*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F8* D. Tunstall */
/* REVISION: 8.6E     LAST MODIFIED: 04/30/98   BY: *J2KJ* Niranjan R.  */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L01K* Jaydeep Parikh */
/* Revision: Version.ui    Modified: 02/25/2009   By: Kaine Zhang     Eco: *ss_20090225* */
/* SS - 090524.1 By: Neil Gao */

&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE



&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}



&SCOPED-DEFINE arparp01_p_1 "基本货币批处理合计:"


&SCOPED-DEFINE arparp01_p_2 "发票"


&SCOPED-DEFINE arparp01_p_3 "打印总帐明细"


&SCOPED-DEFINE arparp01_p_4 "基本货币报表合计:"


&SCOPED-DEFINE arparp01_p_5 "财务费用"


&SCOPED-DEFINE arparp01_p_6 " 报表"


&SCOPED-DEFINE arparp01_p_7 "基本货币报表"


&SCOPED-DEFINE arparp01_p_8 "通知"


&SCOPED-DEFINE arparp01_p_9 " 批处理合计:"


&SCOPED-DEFINE arparp01_p_10 "基本货币批处理"


&SCOPED-DEFINE arparp01_p_11 " 报表合计:"


&SCOPED-DEFINE arparp01_p_12 "指定用途金额"


&SCOPED-DEFINE arparp01_p_13 " 批处理"


&SCOPED-DEFINE arparp01_p_14 "      付款"


&SCOPED-DEFINE arparp01_p_15 "单位"


&SCOPED-DEFINE arparp01_p_16 "S-汇总/D-明细"


&SCOPED-DEFINE arparp01_p_17 "类型"


&SCOPED-DEFINE arparp01_p_18 "  合计:"

&SCOPED-DEFINE arparp01_p_19 "日期!生效日期"


define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable base_amt_fmt as character.
define new shared variable curr_amt_old as character.
define new shared variable curr_amt_fmt as character.
define variable oldcurr like ar_curr.
define variable oldsession as character.
define variable cust like ar_bill.
define variable cust1 like ar_bill.
define variable check_nbr like ar_check.
define variable check1 like ar_check.
define variable batch like ar_batch.
define variable batch1 like ar_batch.
define variable entity like ar_entity.
define variable entity1 like ar_entity.
define variable ardate like ar_date.
define variable ardate1 like ar_date.
define variable effdate like ar_effdate.
define variable effdate1 like ar_effdate.

define variable name like ad_name format "x(24)" no-undo.
define variable type like ar_type format "X(10)".
define variable detlines as integer.
define variable gltrans like mfc_logical initial no
label {&arparp01_p_3}.
define variable gl_sum like mfc_logical initial no.
define variable gldesc like glt_desc.
define variable summary like mfc_logical format {&arparp01_p_16}
initial no label {&arparp01_p_16}.
define new shared variable base_rpt like ar_curr.
define variable base_damt like ard_amt.
define new shared variable base_amt like ar_amt.
define variable disp_curr as character format "x(1)" label "C".
define new shared variable ar_recno as recid.

define variable base_det_amt like glt_amt.
define variable gain_amt like glt_amt.
define variable mc-error-number like msg_nbr no-undo.
define variable foreignpayforeign like mfc_logical no-undo.






{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}


define variable basepayforeign like mfc_logical no-undo.
define variable base_glar_amt like glt_amt no-undo.

find first gl_ctrl no-lock.



&SCOPED-DEFINE PP_FRAME_NAME A

FORM
batch          colon 18 batch1         label {t001.i} colon 49
check_nbr      colon 18 check1         label {t001.i} colon 49
cust           colon 18 cust1          label {t001.i} colon 49
entity         colon 18 entity1        label {t001.i} colon 49
ardate         colon 18 ardate1        label {t001.i} colon 49
effdate        colon 18 effdate1       label {t001.i} colon 49
summary        colon 18
gltrans        colon 18
base_rpt       colon 18
SKIP(.4)
with frame a side-labels width 80 .

setFrameLabels(frame a:handle).

&UNDEFINE PP_FRAME_NAME



FORM
space(10)
ard_ref
type column-label {&arparp01_p_17}
ard_entity format "X(4)" label {&arparp01_p_15}
ard_acct
ard_cc no-label
disp_curr
base_damt label {&arparp01_p_12}
with STREAM-IO   frame c width 132 down.
setframelabels(frame c:handle).

FORM
ar_nbr format "x(8)"
ar_bill name column-label "名称!备注"

ar_check column-label "支票! T "
base_amt format "->>,>>>,>>9.99"
ar_date column-label "日期!生效日期"


ar_acct column-label "帐户!单位"
/* SS 090821.1 - B */
ar_sub  column-label "明细帐号"
/* SS 090821.1 - E */
ar_cc no-label

with STREAM-IO   frame d width 132 down no-box.
setframelabels(frame d:handle).
	
base_amt_fmt = base_amt:format.
{gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
input gl_rnd_mthd)"}
curr_amt_old = base_amt:format.
oldsession = SESSION:numeric-format.
oldcurr = "".

{wbrp01.i}

repeat:

    if batch1 = hi_char then batch1 = "".
    if check1 = hi_char then check1 = "".
    if cust1 = hi_char then cust1 = "".
    if entity1 = hi_char then entity1 = "".
    if ardate = low_date then ardate = ?.
    if ardate1 = hi_date then ardate1 = ?.
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.


     update batch batch1 check_nbr check1
        cust cust1 entity entity1 ardate ardate1 effdate effdate1 summary
        gltrans base_rpt with frame a.

        if (c-application-mode <> 'web':u) or
        (c-application-mode = 'web':u and
        (c-web-request begins 'data':u)) then do:

            bcdparm = "".
            {mfquoter.i batch    }
            {mfquoter.i batch1   }
            {mfquoter.i check_nbr}
            {mfquoter.i check1   }
            {mfquoter.i cust     }
            {mfquoter.i cust1    }
            {mfquoter.i entity   }
            {mfquoter.i entity1  }
            {mfquoter.i ardate   }
            {mfquoter.i ardate1  }
            {mfquoter.i effdate  }
            {mfquoter.i effdate1 }
            {mfquoter.i summary  }
            {mfquoter.i gltrans  }
            {mfquoter.i base_rpt}

            if batch1 = "" then batch1 = hi_char.
            if check1 = "" then check1 = hi_char.
            if cust1 = "" then cust1 = hi_char.
            if entity1 = "" then entity1 = hi_char.
            if ardate = ? then ardate = low_date.
            if ardate1 = ? then ardate1 = hi_date.
            if effdate = ? then effdate = low_date.
            if effdate1 = ? then effdate1 = hi_date.

        end.


					{mfselbpr.i "printer" 132}
					
                find first gl_ctrl 
                /* *ss_20090225* */  where gl_domain = global_domain
                no-lock.

                define buffer armstr for ar_mstr.


                    {mfphead2.i}


                    if gltrans = yes then do:
                        for each gltw_wkfl where 
                            /* *ss_20090225* */  gltw_domain = global_domain and
                            gltw_userid = mfguser exclusive-lock:
                            delete gltw_wkfl.
                        end.
                    end.

                    do with frame d down:

                        for each ar_mstr where 
                            /* *ss_20090225* */  ar_domain = global_domain and
                            ar_batch >= batch and
                            ar_batch <= batch1 and
                            ar_check >= check_nbr and
                            ar_check <= check1 and
                            ar_bill  >= cust and
                            ar_bill  <= cust1 and
                            ar_entity >= entity and
                            ar_entity <= entity1 and
                            ar_date >= ardate and
                            ar_date <= ardate1 and
                            ar_effdate >= effdate and
                            ar_effdate <= effdate1 and
                            ar_type = "A" and
                            ((ar_curr = base_rpt) or
                            (base_rpt = ""))
                            no-lock break by ar_batch by ar_nbr
                            with frame c width 132 down:

                            if (oldcurr <> ar_curr) or (oldcurr = "") then do:


                                {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                                "(input ar_curr,
                                output rndmthd,
                                output mc-error-number)"}
                                if mc-error-number <> 0 then do:
                                    {mfmsg.i mc-error-number 4}
                                    if c-application-mode <> "WEB":U then
                                    pause.
                                    leave.
                                end.


                                find rnd_mstr where 
                                /* *ss_20090225* */  rnd_domain = global_domain and
                                rnd_rnd_mthd = rndmthd
                                no-lock no-error.
                                if not available rnd_mstr then do:
                                    {mfmsg.i 863 4}
                                    leave.
                                end.


                                if (base_rpt <> "")
                                then do:


                                    if (rnd_dec_pt = "," )
                                    then SESSION:numeric-format = "European".
                                    else SESSION:numeric-format = "American".
                                end.

                                curr_amt_fmt = curr_amt_old.
                                {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                input rndmthd)"}
                                oldcurr = ar_curr.
                            end.

                            base_amt = ar_amt.
                            base_amt:format = curr_amt_fmt.
                            if base_rpt = ""
                            and ar_curr <> base_curr then do:
                                base_amt:format = base_amt_fmt.

                                base_amt = ar_base_amt.
                            end.

                            if first-of(ar_batch) then display ar_batch with frame b
                            side-labels STREAM-IO  .
                            setframelabels(frame b:handle).

                            find ad_mstr where 
                            /* *ss_20090225* */  ad_domain = global_domain and
                            ad_addr = ar_bill no-lock no-wait
                            no-error.
                            if available ad_mstr then name = ad_name.
                            else name = "".
                            display ar_nbr
                            ar_bill
                            name

                            ar_check
                            base_amt format "->>,>>>,>>9.99"
                            ar_date


                            ar_acct
/* SS 090821.1 - B */
														ar_sub
/* SS 090821.1 - E */                            
                            ar_cc

                            with frame d STREAM-IO  .
                            down 1 with frame d.
                            display ar_po @ name ar_type @ ar_check ar_effdate @ ar_date ar_entity @ ar_acct with frame d stream-io.
                            down 1 with frame d.

                            if gltrans then do:
                                if gl_vat then do:
                                    ar_recno = recid(ar_mstr).
                                    {gprun.i ""arparpv1.p""}
                                end.
                                {gpnextln.i &ref=ar_bill &line=return_int}
                                create gltw_wkfl.
                                assign gltw_entity = ar_entity
                                gltw_acct = ar_acct
                                gltw_cc = ar_cc
                                gltw_ref = ar_bill
                                gltw_line = return_int
                                gltw_date = ar_date
                                gltw_effdate = ar_effdate
                                gltw_userid = mfguser
                                gltw_desc =
                                ar_batch + " " + ar_type + " " + ar_nbr.
                                gltw_amt = base_amt.
                                recno = recid(gltw_wkfl).
                            end.


                            detlines = 0.
                            for each ard_det where 
                                /* *ss_20090225* */  ard_domain = global_domain and
                                ard_nbr = ar_nbr no-lock
                                by ard_acct with frame e width 132:

                                basepayforeign = no.

                                if ard_ref <> " " then do:
                                    find armstr where 
                                    /* *ss_20090225* */  armstr.ar_domain = global_domain and
                                    armstr.ar_nbr = ard_ref no-lock
                                    no-error.
                                    if available armstr and armstr.ar_curr <> base_curr
                                    and (ar_mstr.ar_curr = base_curr or
                                    base_rpt <> armstr.ar_curr ) then

                                    basepayforeign = yes.
                                end.




                                assign foreignpayforeign = no.
                                if available armstr then
                                if armstr.ar_curr <> base_curr and
                                ar_mstr.ar_curr <> base_curr and
                                armstr.ar_curr <> ar_mstr.ar_curr and
                                base_rpt = "" then foreignpayforeign = yes.


                                if ar_mstr.ar_curr = base_curr or
                                base_rpt = ar_mstr.ar_curr then do:
                                    assign
                                    base_damt = ard_amt
                                    base_det_amt = ard_amt
                                    disp_curr = " ".


                                    if basepayforeign or foreignpayforeign then do:
                                        if ar_mstr.ar_curr = armstr.ar_curr then
                                        do:


                                            {gprunp.i "mcpl" "p" "mc-curr-conv"
                                            "(input armstr.ar_curr,
                                            input base_curr,
                                            input armstr.ar_ex_rate,
                                            input armstr.ar_ex_rate2,
                                            input ard_amt,
                                            input true,
                                            output base_glar_amt,
                                            output mc-error-number)"}.
                                            if mc-error-number <> 0 then do:
                                                {mfmsg.i mc-error-number 2}.
                                            end.
                                        end.
                                        else
                                        do:



                                            {gprunp.i "mcpl" "p" "mc-curr-conv"
                                            "(input armstr.ar_curr,
                                            input base_curr,
                                            input armstr.ar_ex_rate,
                                            input armstr.ar_ex_rate2,
                                            input ard_cur_amt,
                                            input true,
                                            output base_glar_amt,
                                            output mc-error-number)"}.
                                            if mc-error-number <> 0 then do:
                                                {mfmsg.i mc-error-number 2}.
                                            end.
                                        end.
                                    end.
                                    else
                                    base_glar_amt = ard_amt.


                                end.
                                else do:
                                    assign
                                    base_damt:format = base_amt_fmt.


                                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                                    "(input ar_mstr.ar_curr,
                                    input base_curr,
                                    input ar_mstr.ar_ex_rate,
                                    input ar_mstr.ar_ex_rate2,
                                    input ard_amt,
                                    input true,
                                    output base_damt,
                                    output mc-error-number)"}.
                                    if mc-error-number <> 0 then do:
                                        {mfmsg.i mc-error-number 2}.
                                    end.


                                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                                    "(input ar_mstr.ar_curr,
                                    input base_curr,
                                    input ar_mstr.ar_ex_rate,
                                    input ar_mstr.ar_ex_rate2,
                                    input ard_amt,
                                    input true,
                                    output base_det_amt,
                                    output mc-error-number)"}.
                                    if mc-error-number <> 0 then do:
                                        {mfmsg.i mc-error-number 2}.
                                    end.


                                    if basepayforeign or foreignpayforeign then do:
                                        if ar_mstr.ar_curr = armstr.ar_curr then
                                        do:


                                            {gprunp.i "mcpl" "p" "mc-curr-conv"
                                            "(input armstr.ar_curr,
                                            input base_curr,
                                            input armstr.ar_ex_rate,
                                            input armstr.ar_ex_rate2,
                                            input ard_amt,
                                            input true,
                                            output base_glar_amt,
                                            output mc-error-number)"}.
                                            if mc-error-number <> 0 then do:
                                                {mfmsg.i mc-error-number 2}.
                                            end.
                                        end.
                                        else
                                        do:



                                            {gprunp.i "mcpl" "p" "mc-curr-conv"
                                            "(input armstr.ar_curr,
                                            input base_curr,
                                            input armstr.ar_ex_rate,
                                            input armstr.ar_ex_rate2,
                                            input ard_cur_amt,
                                            input true,
                                            output base_glar_amt,
                                            output mc-error-number)"}.
                                            if mc-error-number <> 0 then do:
                                                {mfmsg.i mc-error-number 2}.
                                            end.
                                        end.
                                    end.
                                    else
                                    do:


                                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input ar_mstr.ar_curr,
                                        input base_curr,
                                        input ar_mstr.ar_ex_rate,
                                        input ar_mstr.ar_ex_rate2,
                                        input ard_amt,
                                        input true,
                                        output base_glar_amt,
                                        output mc-error-number)"}.
                                        if mc-error-number <> 0 then do:
                                            {mfmsg.i mc-error-number 2}.
                                        end.
                                    end.


                                    disp_curr = "Y".
                                end.

                                type = "".
                                if ard_type = "M" then type = {&arparp01_p_8}.
                                else if ard_type = "F" then type = {&arparp01_p_5}.
                                else if ard_type = "I" then type = {&arparp01_p_2}.

                                detlines = detlines + 1.
                                accumulate base_damt (total).

                                if not summary then do with frame c:
                                    display
                                    ard_ref
                                    type
                                    ard_entity
                                    ard_acct
                                    ard_cc
                                    disp_curr
                                    base_damt WITH STREAM-IO  .
                                    down 1.
                                end.

                                if gltrans then do:
                                    {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                                    create gltw_wkfl.
                                    assign gltw_entity = ard_entity
                                    gltw_acct = ard_acct
                                    gltw_cc = ard_cc
                                    gltw_ref = ar_mstr.ar_bill
                                    gltw_line = return_int
                                    gltw_date = ar_mstr.ar_date
                                    gltw_effdate = ar_mstr.ar_effdate
                                    gltw_userid = mfguser
                                    gltw_desc = ar_mstr.ar_batch + " " +
                                    ar_mstr.ar_type + " " + ar_mstr.ar_nbr

                                    gltw_amt = - base_glar_amt.
                                    recno = recid(gltw_wkfl).



                                    if base_curr <> ar_mstr.ar_curr or

                                    basepayforeign or foreignpayforeign then do:
                                        if base_rpt = " " or base_rpt = base_curr then
                                        gain_amt = base_glar_amt - base_damt.
                                        if basepayforeign = no and
                                        foreignpayforeign = no and
                                        base_rpt = ar_mstr.ar_curr then
                                        gain_amt = 0.

                                        if gain_amt <> 0 then do:
                                            {gpnextln.i &ref=ar_mstr.ar_bill
                                            &line=return_int}
                                            create gltw_wkfl.
                                            assign gltw_entity = glentity
                                            gltw_acct = ar_mstr.ar_var_acct
                                            gltw_cc = ar_mstr.ar_var_cc
                                            gltw_ref = ar_mstr.ar_bill
                                            gltw_line = return_int
                                            gltw_date = ar_mstr.ar_date
                                            gltw_effdate = ar_mstr.ar_effdate
                                            gltw_userid = mfguser
                                            gltw_desc = ar_mstr.ar_batch + " " +
                                            ar_mstr.ar_type + " " + ar_mstr.ar_nbr
                                            gltw_amt = gain_amt.
                                            recno = recid(gltw_wkfl).
                                        end.
                                    end.
                                end.

                            end.
                            accumulate (accum total  (base_damt))
                            (total by ar_mstr.ar_batch).

                            if detlines > 1 and not summary then do with frame c:
                                if page-size - line-counter < 3 then page.
                                underline base_damt.
                                display {&arparp01_p_14} @ type {&arparp01_p_18} @ ard_entity
                                accum total (base_damt) @ base_damt WITH STREAM-IO  .
                                down 2.
                            end.

                            if last-of(ar_mstr.ar_batch) then do:
                                if page-size - line-counter < 4 then page.
                                if summary then do with frame d:
                                    underline base_amt.
                                    display
                                    (if base_rpt = ""
                                    then {&arparp01_p_1}
                                    else base_rpt + {&arparp01_p_9})
                                    @ name
                                    accum total by ar_mstr.ar_batch
                                    (accum total base_damt) @ base_amt WITH STREAM-IO  .
                                    down 3.
                                end.
                                else do with frame c:
                                    underline base_damt.
                                    display
                                    (if base_rpt = ""
                                    then {&arparp01_p_10}
                                    else base_rpt + {&arparp01_p_13})
                                    @ type
                                    {&arparp01_p_18} @ ard_entity
                                    accum total by ar_mstr.ar_batch
                                    (accum total base_damt) @ base_damt WITH STREAM-IO  .
                                    down 3.

                                    put ""  at 2 .
                                    put  "制表：__________________ 审批：__________________日期：_________________ " at  8.
/* SS 090821.1 - b */
/*
                                    page.
*/
																		if not last(ar_mstr.ar_batch) then page.
/* SS 090821.1 - E */
                                end.
                            end.



/* SS 090524.1 - B */
/*
                            {mfguirex.i }
*/
/* SS 090524.1 - E */
                        end.

                    end.


                    if gltrans then do:
                        page.
                        SESSION:numeric-format = oldsession.
                        {gprun.i ""gpglrp.p""}
                    end.

/* SS 090524.1 - B */
/*
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
 {mfreset.i}
 {mfgrptrm.i} .
/* SS 090524.1 - E */


                end.

                {wbrp04.i &frame-spec = a}

          