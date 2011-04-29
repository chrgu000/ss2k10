/* GUI CONVERTED from poporp.p (converter v1.71) Thu Jul 16 13:58:34 1998 */
/* poporp.p - PURCHASE ORDER REPORT BY ORDER                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert poporp.p (converter v1.00) Fri Oct 10 13:57:14 1997 */
/* web tag in poporp.p (converter v1.00) Mon Oct 06 14:17:37 1997 */
/*F0PN*/ /*K0M3*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0     LAST MODIFIED: 04/18/90    BY: PML *D001**/
/* REVISION: 6.0     LAST MODIFIED: 10/22/90    BY: RAM *D125**/
/* REVISION: 6.0     LAST MODIFIED: 10/31/90    BY: pml *D157**/
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: RAM *D282**/
/* REVISION: 6.0     LAST MODIFIED: 03/19/91    BY: bjb *D461**/
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261** (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: tjs *G704** (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: ame *GN82**/
/* REVISION: 8.5     LAST MODIFIED: 09/27/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD**/
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi   */
/* REVISION: 8.6     LAST MODIFIED: 04/03/97    BY: *K09K* Arul Victoria */
/* REVISION: 8.6     LAST MODIFIED: 10/11/97    BY: mur *K0M3**/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen   */
/* Revision: Version.ui    Modified: 02/06/2009   By: Kaine Zhang     Eco: *ss_20090206* */

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "} /*GUI moved to top.*/
&SCOPED-DEFINE popoIQ_p_1 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE popoIQ_p_2 "全部（包括已结采购单）"
/* MaxLen: Comment: */

&SCOPED-DEFINE popoIQ_p_3 "成本合计"
/* MaxLen: Comment: */
/* ********** End Translatable Strings Definitions ********* */

/* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

{gppopp.i}

define variable vend like po_vend.
define variable vend1 like po_vend.
define variable nbr like po_nbr.
define variable nbr1 like po_nbr.
define variable nbr2 like Wo_nbr.
define variable nbr3 like Wo_nbr.
define variable nbr4 like Wo_nbr.
define variable LOT like WO_LOT.
define variable LOT1 like WO_LOT.


define variable due like po_due_date.
define variable due1 like po_due_date.
define variable ord   like po_ord_date.
define variable ord1   like po_ord_date.
define variable buyer like po_buyer.
define variable buyer1 like po_buyer.
define variable req   like pod_req_nbr.
define variable req1   like pod_req_nbr.
define variable sord like pod_so_job.
define variable open_ref like pod_qty_ord label {&popoiq_p_1}.
define variable part like pt_part.
define variable part1 like pt_part.
define variable DESC1 like pt_DESC1.
define variable DESC2 like pt_DESC2.
define variable stat like poD_stat.

define variable work_ord like pod_wo_lot.
define variable getall like mfc_logical initial no label {&popoiq_p_2}.
define variable ext_cost like pod_pur_cost label {&popoIQ_p_3}
format "->,>>>,>>>,>>9.99".
define variable price_1 like sct_mtl_tl format "->>>>>>9.99".
define variable receiver like prh_receiver.
define variable summary like mfc_logical label "S-汇总/D-明细" format "S-汇总/D-明细".
define variable summary1 like mfc_logical label "按(1-供应商/2-采购员)汇总：" format "1-供应商/2-采购员".
/*L020*/ {gprunpdf.i "mcpl" "p"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

PART        colon 20
PART1      label {t001.i} colon 49 skip

vend           colon 20

vend1          label {t001.i} colon 49 skip
nbr            colon 20
nbr1           label {t001.i} colon 49 skip
/*  nbr3            colon 20
nbr4           label {t001.i} colon 49 skip*/
LOT            colon 20
LOT1           label {t001.i} colon 49 skip
due            colon 20
due1           label {t001.i} colon 49 skip
ord            colon 20
ord1           label {t001.i} colon 49 skip

buyer          colon 20
buyer1         label {t001.i} colon 49 skip
req            colon 20
req1           label {t001.i} colon 49 skip
stat            colon 20


summary colon 20
summary1 colon 50
GETALL            colon 20

with frame a side-labels width 210 attr-space.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{wbrp01.i}

repeat: 

    /*  Remove remnants from last iteration.    */
    /* *ss_20090206* po_wkfl是之前客户化design的表????, 关于po_wkfl的段落的作用是????,能否删除???? */
    find first po_wkfl no-error.
    if available po_wkfl then
    for each po_wkfl exclusive-lock:
        delete po_wkfl.
    end.

    if nbr1 = hi_char then nbr1 = "".
    if nbr4 = hi_char then nbr4 = "".
    if LOT1 = hi_char then LOT1 = "".

    if vend1 = hi_char then vend1 = "".
    if part1 = hi_char then PART1 = "".
    /*IFP*/     if due1 = hi_date then due1 = ?.
    /*IFP*/     if ord1 = hi_date then ord1 = ?.
    /*IFP*/     if due = low_date then due = ?.
    /*IFP*/     if ord = low_date then ord = ?.
    if buyer1 = hi_char then buyer1 = "".
    if req1   = hi_char then req1   = "".

    /*L020*/ /* CURRENCY CODE VALIDATION */

    update part part1  vend vend1 nbr nbr1  LOT LOT1 due due1
    buyer buyer1 req req1  stat  getall with frame a.

    if (c-application-mode <> "WEB":U) or
    (c-application-mode = "WEB":U and
    (c-web-request begins "DATA":U)) then do:

        bcdparm = "".
        {mfquoter.i vend       }
        {mfquoter.i vend1      }
        {mfquoter.i nbr        }
        {mfquoter.i nbr1       }
        {mfquoter.i LOT        }
        {mfquoter.i LOT1       }


        {mfquoter.i due        }
        {mfquoter.i due1       }
        {mfquoter.i ord        }
        {mfquoter.i ord1       }
        {mfquoter.i summary    }
        {mfquoter.i summary1    }

        {mfquoter.i part}
        {mfquoter.i part1  }
        {mfquoter.i buyer      }
        {mfquoter.i buyer1     }
        {mfquoter.i req        }
        {mfquoter.i req1       }
        {mfquoter.i stat        }


		end.
		
        if nbr1 = "" then nbr1 = hi_char.
        if nbr4 = "" then nbr4 = hi_char.
        if LOT1 = "" then LOT1 = hi_char.
        if vend1 = "" then vend1 = hi_char.
        if part1 = "" then PART1 = hi_char.
        if ord1 = ? then due1 = hi_date.
        if  due1 = ? then due1 = hi_date.
        /*IFP*/     if  ord1 = ? then ord1 = hi_date.
        /*IFP*/     if  due = ? then due = low_date.
        /*IFP*/     if  ord = ? then ord = low_date.
        if buyer1 = "" then buyer1 = hi_char.
        if req1   = "" then req1   = hi_char.


					{mfselbpr.i "printer" 132}
    mainloop: do on error undo, return error on endkey undo, return error:
        find first po_wkfl no-error.

        {mfphead.i}

        /*         12345678 12345678  123 123456789012345678 123456789012345678901234 123456789012345678901234  12  1234567.123 1234567.123 1234567.12 12345678.12 1234567890 1234567890123456789012345678 12345678 12345678
        234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
        1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19   */
        /*        FORM PO_BUYER pod_nbr pod_line POD_PART DESC1 DESC2 pod_um POD_QTY_ORD format "->,>>>,>>>,>>9.99" open_ref format "->,>>>,>>>,>>9.99" " " pod_pur_cost pod_disc_pct EXT_COST " " po_vend ad_mstr.ad_name pod_due_date
        with frame  phead1 width 210.
        view frame phead1.*/
        /*            FORM /*GUI*/  header
        skip(1)
        with STREAM-IO /*GUI*/ frame phead1 width 210.
        view frame phead1.*/


        if not summary then do:
            put skip(1).
            put " 采购员      加工单号        标志号   采购单   序号       零件号                描述1                   描述2            单位  订 货 量     短缺量     采购单价  短缺量金额  供应商代码     供应商名称                到期日    订货日                    备注                状态" at 2 skip .
            put "-------- ------------------ -------- --------- ---- ------------------ ------------------------ ------------------------ ---- ----------- ----------- ---------- ----------- ---------- ---------------------------- --------   -------- ---------------------------------------- --------" at 2 skip.
            for each po_mstr 
                where 
                    /* *ss_20090206* */  po_domain = global_domain and 
                    (po_nbr >= nbr) and (po_nbr <= nbr1)
                    and (po_vend >= vend) and (po_vend <= vend1)
                    and (po_buyer >= buyer and po_buyer <= buyer1)
                    and (po_due_date >= due and po_due_date <= due1)
                    and (po_ord_date >= ord and po_ord_date <= ord1)
                    and  po_type <> "B" 
                no-lock ,
            each pod_det 
                where 
                    /* *ss_20090206* */  pod_domain = po_domain and 
                    pod_nbr = po_nbr
                    and (pod_wo_lot >= LOT AND POD_WO_LOT <= LOT1)
                    and (pod_part >= part and pod_part <= part1)
                    and (pod_req_nbr  >= req and pod_req_nbr <= req1)
                    and ((poD_stat = stat and stat <> "") or stat = "")
                    and not pod_sched
                    and ((pod_status <> "c" and pod_status <> "x") or getall = yes )
                no-lock 
                by pod_part by po_nbr by pod_line  by po_buyer :
                if page-size - line-counter < 2 then do:
                    page.
                    put skip(1).
                    put " 采购员      加工单号        标志号   采购单   序号       零件号                描述1                   描述2            单位  订 货 量     短缺量     采购单价  短缺量金额  供应商代码     供应商名称                到期日     订货日                 备注                        状态" at 2 skip .
                    put "-------- ------------------ -------- --------- ---- ------------------ ------------------------ ------------------------ ---- ----------- ----------- ---------- ----------- ---------- ---------------------------- --------   -------- ----------------------------------------- --------" at 2 skip.
                end.

                /*  NBR2 = WO_NBR.*/
                find PT_MSTR WHERE 
                    /* *ss_20090206* */  pt_domain = pod_domain and 
                    PT_PART = POD_PART no-lock no-error.
                if  available pt_mstr then do :
                    desc1 = pt_desc1.
                    desc2 = pt_desc2.
                end.
                else do:
                    desc1 = "主文件无此零件".
                    desc2 = "".
                end.

                {mfguichk.i } /*Replace mfrpchk*/

                open_ref = pod_qty_ord - pod_qty_rcvd.
                ext_cost = open_REF * pod_pur_cost.
                
                find ad_mstr 
                    where 
                    /* *ss_20090206* */  ad_mstr.ad_domain = po_domain and 
                    ad_mstr.ad_addr = po_vend no-lock no-error.
                FIND WO_MSTR WHERE 
                    /* *ss_20090206* */  wo_domain = pod_domain and
                    WO_LOT = POD_WO_LOT NO-LOCK NO-ERROR.
                IF AVAILABLE WO_MSTR THEN NBR2 = WO_NBR.
                ELSE  NBR2 = "".
                /*  receiver = "".
                if getall = yes then find prh_hist where prh_part = pod_part and prh_nbr = pod_nbr no-lock no-error.
                if available prh_hist then receiver = prh_receiver.*/
                put
                PO_BUYER at 2
                nbr2 at 11
                pod_wo_lot at 30
                pod_nbr at 39
                pod_line at 50
                POD_PART at 54
                DESC1 at 73
                DESC2 at 98
                pod_um at 124
                POD_QTY_ORD format ">>>>>>9.9<<" at 128
                open_ref format ">>>>>>9.9<<" at 140
                pod_pur_cost format ">>>>>>9.9<<<" at 152
                EXT_COST format ">>>>>>>9.9<<<" at 163
                po_vend at 175
                ad_mstr.ad_name at 186
                po_due_date at 215
                po_ord_date at 226
                po_rmks at 237
                poD_stat at 280
                skip.
                put "" skip.

                /*with fram b width 215  no-label .*/


            end.

        end.

        /* end.end for if not summary */
        else do:
            if not summary1 then do:
                for each po_mstr where 
                    /* *ss_20090206* */  po_domain = global_domain and
                    (po_nbr >= nbr) and (po_nbr <= nbr1)
                    and (po_vend >= vend) and (po_vend <= vend1)
                    and (po_buyer >= buyer and po_buyer <= buyer1)
                    and (po_due_date >= due and po_due_date <= due1)
                    and (po_ord_date >= ord and po_ord_date <= ord1)
                    and ((po_stat = stat and stat <> "") or stat = "")
                    and  po_type <> "B" no-lock ,
                    each pod_det where 
                    /* *ss_20090206* */  pod_domain = po_domain and
                    pod_nbr = po_nbr
                    and (pod_wo_lot >= LOT AND POD_WO_LOT <= LOT1)
                    and (pod_part >= part and pod_part <= part1)
                    and (pod_req_nbr  >= req and pod_req_nbr <= req1)
                    and not pod_sched
                    and ((pod_status <> "c" and pod_status <> "x") or getall = yes )
                    no-lock break by po_buyer by po_nbr by pod_line by pod_part:

                    open_ref = pod_qty_ord - pod_qty_rcvd.
                    ext_cost = open_REF * pod_pur_cost.
                    find ad_mstr where 
                        /* *ss_20090206* */  ad_domain = po_domain and
                        ad_mstr.ad_addr = po_vend no-lock no-error.

                    accumulate ext_cost (total by PO_NBR).
                    accumulate ext_cost (total by PO_buyer).
                    if FIRST-OF (PO_BUYER) or page-size - line-counter < 2 then do:
                        page.
                        put skip(1).

                        put "采购员:" AT 2 PO_BUYER.
                        put "" at 2.
                        put " 采购单号   供应商代码            供应商名称                金额合计    到期日    订货日期" at 2 skip .
                        put " ---------  ---------- ----------------------------------- ----------- ---------- --------" at 2 skip.
                        /*123456789 12346579 123456789 123546789 132456789 123456789 132456789 123465789 1234679*/
                    end.
                    if last-of (po_nbr) then do:

                        /*              123456789 123456789 123456789 123456789 123456789 123456789 12346789 123456789*/
                        put po_nbr at 3 po_vend at 14 ad_name at 25 (accum total by PO_NBR (ext_cost)) format "->,>>>,>>>,>>9.99" at 55 po_due_date at 75 po_ord_date .
                    end.
                    if last-of (po_buyer) then do:
                        put "--------------"at 55 skip.
                        put " 合计:" at 30 (accum total by PO_buyer (ext_cost)) format "->,>>>,>>>,>>9.99" at 55.
                    end.
                end.


            end. /*end for eaach po_mstr*/
            else do:
                for each po_mstr where 
                    /* *ss_20090206* */  po_domain = global_domain and
                    (po_nbr >= nbr) and (po_nbr <= nbr1)
                    and (po_vend >= vend) and (po_vend <= vend1)
                    and (po_buyer >= buyer and po_buyer <= buyer1)
                    and (po_due_date >= due and po_due_date <= due1)
                    and (po_ord_date >= ord and po_ord_date <= ord1)
                    and  po_type <> "B" no-lock ,
                    each pod_det where 
                    /* *ss_20090206* */  pod_domain = po_domain and
                    pod_nbr = po_nbr
                    and (pod_wo_lot >= LOT AND POD_WO_LOT <= LOT1)
                    and (pod_part >= part and pod_part <= part1)
                    and (pod_req_nbr  >= req and pod_req_nbr <= req1)
                    and not pod_sched
                    and ((pod_status <> "c" and pod_status <> "x") or getall = yes )
                    no-lock break by po_vend by po_nbr by pod_line by pod_part:

                    open_ref = pod_qty_ord - pod_qty_rcvd.
                    ext_cost = open_REF * pod_pur_cost.
                    find ad_mstr where 
                        /* *ss_20090206* */  ad_mstr.ad_domain = po_domain and
                        ad_mstr.ad_addr = po_vend no-lock no-error.

                    accumulate ext_cost (total by PO_NBR).
                    accumulate ext_cost (total by PO_vend).
                    if FIRST-OF (PO_vend) or page-size - line-counter < 2 then do:
                        page.
                        put skip(1).

                        put "供应商代码:" AT 2 PO_vend  "供应商名称:" at 28 ad_name.
                        put "" at 2.
                        put " 采购单号   采 购 员       金额合计    到期日   订货日期" at 2 skip .
                        put " ---------  ----------  ------------- --------- --------" at 2 skip.
                        /*    123456789 123456789 123456789 123456789 123456789 */
                    end.
                    if last-of (po_nbr) then do:


                        put po_nbr at 3 po_buyer at 14 (accum total by PO_NBR (ext_cost)) format "->,>>>,>>>,>>9.99" at 22 po_due_date at 40 po_ord_date at 50.
                    end.
                    if last-of (po_vend) then do:
                        put "--------------"at 26 skip.
                        put " 合计:" at 12 (accum total by PO_vend (ext_cost)) format "->,>>>,>>>,>>9.99" at 22.
                    end.
                end.


            end. /*end for eaach po_mstr*/



        end. /* end for if  not summary1 */
    end. /* end else do summary1 */


            /* REPORT TRAILER  */

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

        end.

        {wbrp04.i &frame-spec = a}
        
