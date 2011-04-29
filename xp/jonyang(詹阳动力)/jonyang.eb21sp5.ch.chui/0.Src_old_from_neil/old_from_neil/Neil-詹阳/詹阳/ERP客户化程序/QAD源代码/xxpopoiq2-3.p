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
/* Revision: Version.ui    Modified: 02/24/2009   By: Kaine Zhang     Eco: *ss_20090224* */
/* ********** Begin Translatable Strings Definitions ********* */



&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE



&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}
&SCOPED-DEFINE popoIQ_p_1 "��ȱ��"


&SCOPED-DEFINE popoIQ_p_2 "ֻ��ӡδ��ɹ���"


&SCOPED-DEFINE popoIQ_p_3 "���ܽ��"






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
define variable part3 as CHARACTER FORMAT "x(10)".
define variable DESC1 like pt_DESC1.
define variable DESC2 like pt_DESC2.
define variable work_ord like pod_wo_lot.
define variable getall like mfc_logical initial YES label {&popoiq_p_2}.
define variable ext_cost like pod_pur_cost label {&popoIQ_p_3}  format "->,>>>,>>>,>>9.99".
define variable ext_cost1 like pod_pur_cost label {&popoIQ_p_3} format "->,>>>,>>>,>>9.99".
define variable pur_cost like pod_pur_cost format "->,>>>,>>>,>>9.99<<".
define variable price_1 like sct_mtl_tl format "->>>>>>9.99".
define variable name1 like ad_name.
define variable line1 like ad_line1.
define variable ex_rate2 like po_nbr.
define variable bz as CHARACTER FORMAT "x(78)".
define variable bz1 as CHARACTER FORMAT "x(78)".
define variable bz2 as CHARACTER FORMAT "x(78)".
define variable bz3 as CHARACTER FORMAT "x(50)".


{gprunpdf.i "mcpl" "p"}



&SCOPED-DEFINE PP_FRAME_NAME A

FORM
PART        colon 20
PART1      label {t001.i} colon 49 skip

vend           colon 20

vend1          label {t001.i} colon 49 skip
nbr            colon 20
nbr1           label {t001.i} colon 49 skip

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
GETALL            colon 20 skip
"---------------------------------------------- �ı�¼���� ---------------------------------------------" colon 2
bz3            label "��ͬ�����ܽ��(��˰)�������(��д)" colon 30
bz             label "��������" colon 20
bz1            label "���䷽ʽ/֧����ʽ:"  colon 20
bz2            label "���������׼��Ҫ��:"  colon 20

with frame a side-labels width 210 attr-space.

setFrameLabels(frame a:handle).

&UNDEFINE PP_FRAME_NAME


{wbrp01.i}

repeat:

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
    if due1 = hi_date then due1 = ?.
    if ord1 = hi_date then ord1 = ?.
    if due = low_date then due = ?.
    if ord = low_date then ord = ?.
    if buyer1 = hi_char then buyer1 = "".
    if req1   = hi_char then req1   = "".
    if c-application-mode <> "WEB":U then




		update part part1  vend vend1 nbr nbr1  LOT LOT1 due due1
        buyer buyer1 req req1 getall bz bz1 BZ2 with frame a.

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


            {mfquoter.i part}
            {mfquoter.i part1  }
            {mfquoter.i buyer      }
            {mfquoter.i buyer1     }
            {mfquoter.i req        }
            {mfquoter.i req1       }
            if nbr1 = "" then nbr1 = hi_char.
            if nbr4 = "" then nbr4 = hi_char.
            if LOT1 = "" then LOT1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if part1 = "" then PART1 = hi_char.
            if ord1 = ? then due1 = hi_date.
            if  due1 = ? then due1 = hi_date.
            if  ord1 = ? then ord1 = hi_date.
            if  due = ? then due = low_date.
            if  ord = ? then ord = low_date.
            if buyer1 = "" then buyer1 = hi_char.
            if req1   = "" then req1   = hi_char.


        end.

							{mfselbpr.i "printer" 132}
		
    mainloop: 
    do on error undo, return error on endkey undo, return error:
        find first po_wkfl no-error.







        for each po_mstr where 
            /* *ss_20090224* */  po_domain = global_domain and
            (po_nbr >= nbr) and (po_nbr <= nbr1)
            and (po_vend >= vend) and (po_vend <= vend1)
            and (po_buyer >= buyer and po_buyer <= buyer1)
            and (po_due_date >= due and po_due_date <= due1)
            and (po_ord_date >= ord and po_ord_date <= ord1)
            and  po_type <> "B" no-lock ,
        each pod_det where 
            /* *ss_20090224* */  pod_domain = global_domain and
            pod_nbr = po_nbr
            and (pod_wo_lot >= LOT AND POD_WO_LOT <= LOT1)
            and (pod_part >= part and pod_part <= part1)
            and (pod_req_nbr  >= req and pod_req_nbr <= req1)
            and not pod_sched
            and ((pod_status <> "c" and pod_status <> "x" and getall = yes) or getall = no )
            no-lock break by po_vend by po_nbr by pod_line by pod_part  by po_buyer :

            find ad_mstr where 
                /* *ss_20090224* */  ad_domain = global_domain and
                ad_addr = po_ship no-lock no-error.
            if available ad_mstr then do:
                name1 = ad_name.
                line1 = ad_line1.
            end.

            find ad_mstr where 
                /* *ss_20090224* */  ad_mstr.ad_domain = global_domain and
                ad_mstr.ad_addr = po_vend no-lock no-error.
            find PT_MSTR WHERE 
                /* *ss_20090224* */  pt_domain = global_domain and
                PT_PART = POD_PART no-lock no-error.
            if available pt_mstr then do:
                if first-of (po_nbr) or page-size - line-counter < 2 then do:
                    if substring(string(po_ex_rate2),1,1) = "." then ex_rate2 = "0" + string(po_ex_rate2).
                    if substring(string(po_ex_rate2),1,1) <> "." then ex_rate2 = string(po_ex_rate2).


                    page.
                    put "��ӡ����:" at 70 today.
                    put skip(1).
                    put "                             ����ղ�������ع����޹�˾"at 2  "ҳ��:" at 70
                    string(page-number)  skip .
                    put "                                   �ɹ���ͬ" at 2.

                    find PT_MSTR WHERE 
                        /* *ss_20090224* */  pt_domain = global_domain and
                        PT_PART = POD_PART no-lock no-error.
                    put " " at 2 skip.
                    put "�� �� ��:" at 2 po_nbr    "��������:" at 24  po_ord_date .
                    if available pt_mstr and pt_prod_line <> "400" then put  "�� �� ��:" at 64 po_due_dat.
                    put "�� Ӧ ��:" at 2 po_vend   "��    ��:" at 24 ad_name           "�� ϵ ��:" at 64 po_contact.
                    put "���﷢��:" at 2 po_ship   "��    ��:" at 24  name1            "��    ַ:" at 64 line1.
                    put "��������:��ͨ���й�������С��֧��" at 24   "˰    ��: 52011478016884X" at 64 .
                    put "��    ��:521146000018150008733" at 24      "��    ��:3898827" at 64.
                    put "�� �� Ա:"at 2 po_buyer   "�� ͬ ��:" at 24 po_contract.
                    put "�� �� ��" at 2           "֧����ʽ:" at 24 po_cr_terms    "Ӧ���ʻ�:" at 64 po_ap_acct " " po_ap_cc.
                    put "��    ��:" at 2 po_curr   "�� �� ��:"at 24 " " string(po_ex_rate) + " : "  ex_rate2 .

                    put skip(1).
                    put "��  �����              ����            ��  ������     �ɹ�����     ���ϼ�     �ɹ��ʻ�  " at 2 skip .
                    put "��                                      λ             (����˰)     (����˰)      ������   " at 2 skip.
                    put "-- ----------- ------------------------ -- ---------- ----------- --------------- --------" at 2 skip.




                end.


                find PT_MSTR WHERE 
                    /* *ss_20090224* */  pt_domain = global_domain and
                    PT_PART = POD_PART no-lock no-error.
                if  available pt_mstr and pod_desc = "" then do :
                    desc1 = pt_desc1.
                    desc2 = pt_desc2.
                end.
                else do:
                    desc1 = substring(pod_desc,1,24).

                    desc2 = "".
                end.


                {mfguichk.i }

                open_ref = pod_qty_ord - pod_qty_rcvd.
                ext_cost = open_REF * pod_pur_cost.
                pur_cost = pod_pur_cost * 1.17.
                if (integer(pur_cost) - pur_cost <= 0.01 and  integer(pur_cost) - pur_cost >= -0.01) then pur_cost = integer(pur_cost).
                ext_cost1 = open_REF * pur_cost.

                FIND WO_MSTR WHERE 
                    /* *ss_20090224* */  wo_domain = global_domain and
                    WO_LOT = POD_WO_LOT NO-LOCK NO-ERROR.
                IF AVAILABLE WO_MSTR THEN NBR2 = WO_NBR.
                ELSE  NBR2 = "".
                accumulate ext_cost (total by PO_NBR).
                accumulate ext_cost1 (total by PO_NBR).


                part3 = pod_part.

                put
                POd_line at 1
                part3 at 5
                desc1 at 18

                pod_um at 42
                open_ref format "->>>>>>9.9<" at 44

                pod_pur_cost format "->>>>>9.99<<"  at 56
                EXT_COST  format "->,>>>,>>9.9<" at 68

                (pod_acct + pod_cc) at 84.
                if substring(pod_part,11,8) <> "" or desc2 <> "" then
                put substring(pod_part,11,8) at 5.
                put desc2 at 18 .
                if pt_prod_line = "400" then
                put pod_DUE_DATE at 84.






                IF LAST-OF(PO_NBR) THEN DO:

                    PUT "-------------" AT 68 .



                    PUT "���ܽ��" AT 58 (accum total by PO_NBR (ext_cost)) format "->>>,>>>,>>9.9<" AT 66 .

                    put " " at 2.
                    if bz3 = "" then  PUT "��ͬ�����ܽ��(��˰)�������(��д)________________________________________________________________" at 2.
                    if bz3 <> "" then  PUT "��ͬ�����ܽ��(��˰)�������(��д)" at 2 bz3.
                    put "" at 2.
                    if bz = "" then    PUT "��    ��   ��   �� : ______________________________________________________________________________" at 2.
                    if bz <> ""  then
                    PUT "��    ��   ��   �� :" AT 2 BZ.

                    put "" at 2.
                    if bz1 = "" then put "���䷽ʽ / ֧����ʽ: ______________________________________________________________________________" at 2.
                    if bz1 <> "" then
                    put "���䷽ʽ / ֧����ʽ:" AT 2 BZ1.

                    put "" at 2.
                    if bz2 = "" then put "���������׼��Ҫ�� :______________________________________________________________________________" at 2 .
                    if bz2 <> "" then
                    put "���������׼��Ҫ�� :" AT 2 BZ2 .

                    put "" at 2 .
                    put "��ע��: " at 2 .
                    put "       �ͻ�ʱ�����ͻ��嵥���嵥�����ɹ����š�����š���������λ;��ƱҲ���г��ɹ����š�" at 2.
                    put "      --------------------------------------------------------------------------------------------" at 2.
                    put "      " at 2  .
                    put "      --------------------------------------------------------------------------------------------" at 2.
                    put "      " at 2  .
                    put "      --------------------------------------------------------------------------------------------" at 2.
                    put skip(1).
                    put "��׼��ǩ�� :___________________" at 70.
                    put skip(1).
                end.




            END.

        end.

    end.


 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .

end.

        {wbrp04.i &frame-spec = a}

