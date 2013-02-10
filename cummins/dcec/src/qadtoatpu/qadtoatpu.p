
{mfdeclre.i "new global"}
{mf1.i "new global"}
session:date-format = 'dmy'.
base_curr = "RMB".
global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "qadtoatpu.p".
hi_char = chr(255).
low_date = date(01,01,1900).
hi_date = date(12,31,3999).

DEFINE VARIABLE phantom AS INT.
DEFINE VARIABLE v_start AS CHAR.
DEFINE VARIABLE v_end AS CHAR.
DEFINE VARIABLE v_comp AS INT.
DEFINE VARIABLE v_buyer LIKE ptp_buyer.
DEFINE VARIABLE v_vend LIKE po_vend.
DEFINE VARIABLE v_supply LIKE pod__chr01.
DEFINE VARIABLE v_qty LIKE prh_rcvd.
DEFINE VARIABLE v_percent LIKE qad_decfld[1].
DEFINE VARIABLE v_date AS CHAR.
DEFINE VARIABLE v_run1 LIKE ptp_run_seq1.
DEFINE VARIABLE v_prod_line LIKE pt_prod_line.
DEFINE VARIABLE v_warehouse LIKE CODE_cmmt INITIAL "B01".
DEFINE VARIABLE v_site like si_site.
define variable v_outpath as character.

FUNCTION getWcSite RETURNS character(iwkctr as character) forward.

DEFINE WORKFILE xxwk
   FIELD xx_site LIKE pod_site
   FIELD xx_start AS CHAR
   FIELD xx_part LIKE pod_part
   FIELD xx_nbr LIKE pod_nbr
   FIELD xx_percent LIKE qad_decfld[1]
   FIELD xx_vend LIKE po_vend
   FIELD xx_date AS CHAR
   FIELD xx_buyer LIKE ptp_buyer
   FIELD xx_t AS CHAR
   FIELD xx_f AS CHAR
   FIELD xx_blank AS CHAR
   FIELD xx_supply LIKE pod__chr01
   FIELD xx_sch LIKE pod_sched
   FIELD xx_run_seq1 LIKE ptp_run_seq1
   FIELD xx_prod_line LIKE pt_prod_line.

v_outpath = "".
find first usrw_wkfl no-lock where usrw_domain = global_domain
       and usrw_key1 = "QADTOATPU-CTRL"
       and usrw_key2 = "QADTOATPU-CTRL" no-error.
if available usrw_wkfl then do:
   assign v_outpath = usrw_key3.
end.


OUTPUT TO value(v_outpath + "pt_mstr.txt").
PUT UNFORMATTED "pt_part|".
PUT UNFORMATTED "pt_desc1|".
PUT UNFORMATTED "pt_desc2|".
PUT UNFORMATTED "pt_group|".
PUT UNFORMATTED "pt_part_type|".
PUT UNFORMATTED "pt_status|".
PUT UNFORMATTED "pt_phantom|".
PUT UNFORMATTED "pt_article|".
PUT UNFORMATTED "pt_prod_line|" SKIP.

FOR EACH pt_mstr NO-LOCK where pt_domain = global_domain:
    IF pt_phantom = YES THEN phantom = -1.
    ELSE phantom = 0.

    PUT UNFORMATTED pt_part "|".
    PUT UNFORMATTED pt_desc1 "|".
    PUT UNFORMATTED pt_desc2 "|".
    PUT UNFORMATTED pt_group "|".
    PUT UNFORMATTED pt_part_type "|".
    PUT UNFORMATTED pt_status "|".
    PUT UNFORMATTED phantom "|".
    PUT UNFORMATTED pt_article "|".
    PUT UNFORMATTED pt_prod_line "|"  SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "ps_mstr.txt").
PUT UNFORMATTED "ps_par|".
PUT UNFORMATTED "ps_comp|".
PUT UNFORMATTED "ps_ref|".
PUT UNFORMATTED "ps_qty_per|".
PUT UNFORMATTED "ps_start|".
PUT UNFORMATTED "ps_end|".
PUT UNFORMATTED "ps_op|".
PUT UNFORMATTED "ps_rmks|" SKIP.
FOR EACH ps_mstr NO-LOCK where ps_domain = global_domain:
    IF ps_start = ? THEN v_start = "".
    ELSE v_start = STRING(YEAR(ps_start)) + "/" + STRING(MONTH(ps_start)) + "/" + STRING(DAY(ps_start)).
    IF ps_end = ? THEN v_end = "".
    ELSE v_end = STRING(YEAR(ps_end)) + "/" + STRING(MONTH(ps_end)) + "/" + STRING(DAY(ps_end)).

    PUT UNFORMATTED ps_par "|".
    PUT UNFORMATTED ps_comp "|".
    PUT UNFORMATTED ps_ref "|".
    PUT UNFORMATTED ps_qty_per "|".
    PUT UNFORMATTED v_start "|".
    PUT UNFORMATTED v_end "|".
    PUT UNFORMATTED ps_op "|".
    PUT UNFORMATTED ps_rmks "|" SKIP.
END.
FOR EACH pt_mstr WHERE pt_domain = global_domain AND pt_prod_line >= "7000" AND pt_prod_line <= "82ZZ".
    PUT UNFORMATTED trim(pt__chr09) "|".
    PUT UNFORMATTED pt_part "|".
    PUT UNFORMATTED  "|".
    PUT UNFORMATTED  "1|".
    PUT UNFORMATTED  "|".
    PUT UNFORMATTED  "|".
    PUT UNFORMATTED  "0|".
    PUT UNFORMATTED  "0|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "bom_mstr.txt").
PUT UNFORMATTED "bom_parent|".
PUT UNFORMATTED "bom__chr01|" SKIP.

FOR EACH bom_mstr NO-LOCK where bom_domain = global_domain:
    assign v_site = "".
    if substring(bom_parent,length(bom_parent) - 1,2) = "ZZ" then
       assign v_site = "DCEC-B".
    else
       assign v_site = "DCEC-C".
    PUT UNFORMATTED bom_parent "|".
    PUT UNFORMATTED v_site "|" SKIP.
END.
OUTPUT CLOSE.


OUTPUT TO value(v_outpath + "in_mstr.txt").

PUT UNFORMATTED "in_part|".
PUT UNFORMATTED "in_site|".
PUT UNFORMATTED "in_user1|".
PUT UNFORMATTED "in__qadc01|".
PUT UNFORMATTED "in_abc|".
PUT UNFORMATTED "in_user2|".
PUT UNFORMATTED "in_loc|" SKIP.

FOR EACH in_mstr NO-LOCK where in_domain = global_domain:
    FIND FIRST  CODE_mstr WHERE code_domain = global_domain
            and CODE_fldname = "Keeper-Warehouse"
            AND CODE_value = IN__qadc01 NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN v_warehouse = CODE_cmmt.
    ELSE DO:
        IF in_site = "DCEC-B" THEN v_warehouse = "B01".
        IF in_site = "DCEC-C" THEN v_warehouse = "C01".

    END.
    IF in_site = "DCEC-SV" THEN v_warehouse = "V01".

    PUT UNFORMATTED in_part "|".
    PUT UNFORMATTED in_site "|".
    PUT UNFORMATTED in_user1 "|".
    PUT UNFORMATTED in__qadc01 "|".
    PUT UNFORMATTED in_abc "|".
    PUT UNFORMATTED in_user2 "|".
    PUT UNFORMATTED in_loc "|".
    PUT UNFORMATTED v_warehouse "|"SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "opm_mstr.txt").

PUT UNFORMATTED "opm_desc|".
PUT UNFORMATTED "opm_wkctr|".
PUT UNFORMATTED "opm_std_op|".
PUT UNFORMATTED "opm__chr01|" SKIP.


FOR EACH opm_mstr NO-LOCK where opm_domain = global_domain:
    assign v_site = "".
    v_site = getWcSite(opm_wkctr).
    PUT UNFORMATTED opm_desc "|".
    PUT UNFORMATTED opm_wkctr "|".
    PUT UNFORMATTED opm_std_op "|".
    PUT UNFORMATTED v_site "|" SKIP.
END.
OUTPUT CLOSE.


OUTPUT TO value(v_outpath + "ptp_det.txt").

PUT UNFORMATTED "ptp_part|".
PUT UNFORMATTED "ptp_site|".
PUT UNFORMATTED "ptp_bom_code|".
PUT UNFORMATTED "ptp_phantom|".
PUT UNFORMATTED "ptp_routing|".
PUT UNFORMATTED "ptp_ord_mutl|".
PUT UNFORMATTED "ptp_run_seq1|" SKIP.


FOR EACH ptp_det NO-LOCK where ptp_domain = global_domain:
    IF ptp_phantom = YES THEN phantom = -1.
    ELSE phantom = 0.

    PUT UNFORMATTED ptp_part "|".
    PUT UNFORMATTED ptp_site "|".
    PUT UNFORMATTED ptp_bom_code "|".
    PUT UNFORMATTED phantom "|".
    PUT UNFORMATTED ptp_routing "|".
    PUT UNFORMATTED ptp_ord_mult "|".
    PUT UNFORMATTED ptp_run_seq1 "|" SKIP.
END.
OUTPUT CLOSE.


OUTPUT TO value(v_outpath + "rps_mstr.txt").

PUT UNFORMATTED "rps_part|".
PUT UNFORMATTED "rps_due_date|".
PUT UNFORMATTED "rps_rel_date|".
PUT UNFORMATTED "rps_qty_req|".
PUT UNFORMATTED "rps_qty_comp|".
PUT UNFORMATTED "rps_site|".
PUT UNFORMATTED "rps_line|" SKIP.


FOR EACH rps_mstr NO-LOCK where rps_domain = global_domain:
    IF rps_due_date = ? THEN v_start = "".
    ELSE v_start = STRING(YEAR(rps_due_date)) + "/" + STRING(MONTH(rps_due_date)) + "/" + STRING(DAY(rps_due_date)).
    IF rps_rel_date = ? THEN v_end = "".
    ELSE v_end = STRING(YEAR(rps_rel_date)) + "/" + STRING(MONTH(rps_rel_date)) + "/" + STRING(DAY(rps_rel_date)).
    IF rps_qty_comp = ? THEN v_comp = 0.
    ELSE v_comp = rps_qty_comp.


    PUT UNFORMATTED rps_part "|".
    PUT UNFORMATTED v_start "|".
    PUT UNFORMATTED v_end "|".
    PUT UNFORMATTED rps_qty_req "|".
    PUT UNFORMATTED v_comp "|".
    PUT UNFORMATTED rps_site "|".
    PUT UNFORMATTED rps_line "|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "wc_mstr.txt").
PUT UNFORMATTED "wc_wkctr|".
PUT UNFORMATTED "wc_desc|".
PUT UNFORMATTED "wc_dept|".
PUT UNFORMATTED "wc__chr01|" SKIP.


FOR EACH wc_mstr NO-LOCK where wc_domain = global_domain:
    assign v_site = "".
    v_site = getWcSite(wc_wkctr).
    PUT UNFORMATTED wc_wkctr "|".
    PUT UNFORMATTED wc_desc "|".
    PUT UNFORMATTED wc_dept "|".
    PUT UNFORMATTED v_site "|" SKIP.

END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "ad_mstr.txt").
PUT UNFORMATTED "ad_addr|".
PUT UNFORMATTED "ad_name|".
PUT UNFORMATTED "ad_line1|".
PUT UNFORMATTED "ad_line2|".
PUT UNFORMATTED "ad_city|".
PUT UNFORMATTED "ad_state|".
PUT UNFORMATTED "ad_zip|".
PUT UNFORMATTED "ad_type|".
PUT UNFORMATTED "ad_attn|".
PUT UNFORMATTED "ad_phone|" SKIP.


FOR EACH ad_mstr NO-LOCK where ad_domain = global_domain:
    PUT UNFORMATTED ad_addr "|".
    PUT UNFORMATTED ad_name "|".
    PUT UNFORMATTED ad_line1 "|".
    PUT UNFORMATTED ad_line2 "|".
    PUT UNFORMATTED ad_city "|".
    PUT UNFORMATTED ad_state "|".
    PUT UNFORMATTED ad_zip "|".
    PUT UNFORMATTED ad_type "|".
    PUT UNFORMATTED ad_attn "|".
    PUT UNFORMATTED ad_phone "|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "xxptmp_mstr.txt").

PUT UNFORMATTED "xxptmp_par|".
PUT UNFORMATTED "xxptmp_comp|".
PUT UNFORMATTED "xxptmp_site|".
PUT UNFORMATTED "xxptmp_cust|".
PUT UNFORMATTED "xxptmp_vend|".
PUT UNFORMATTED "xxptmp_qty_per|".
PUT UNFORMATTED "xxptmp_rmks|" SKIP.

FOR EACH xxptmp_mstr NO-LOCK where xxptmp_domain = global_domain:
    for each ptp_det no-lock where ptp_domain = global_domain
           and ptp_part = xxptmp_comp
           and (ptp_site = "DCEC-B" or ptp_site = "DCEC-C"):
        PUT UNFORMATTED xxptmp_par "|".
        PUT UNFORMATTED xxptmp_comp "|".
        PUT UNFORMATTED ptp_site "|".
        PUT UNFORMATTED xxptmp_cust "|".
        PUT UNFORMATTED xxptmp_vend "|".
        PUT UNFORMATTED xxptmp_qty_per "|".
        PUT UNFORMATTED xxptmp_rmks "|" SKIP.
    end.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "xxppiftr_un.txt").

PUT UNFORMATTED "xxppiftr_so|".
PUT UNFORMATTED "xxppiftr_bd|".
PUT UNFORMATTED "xxppiftr_flag|".
PUT UNFORMATTED "xxppiftr_un|" SKIP.


FOR EACH xxppiftr_un NO-LOCK where xxppiftr_domain = global_domain:
    IF xxppiftr_bd = ? THEN v_start = "".
    ELSE v_start = STRING(YEAR(xxppiftr_bd)) + "/" + STRING(MONTH(xxppiftr_bd)) + "/" + STRING(DAY(xxppiftr_bd)).
    IF xxppiftr_flag = Yes THEN phantom = -1.
    ELSE phantom = 0.

    PUT UNFORMATTED xxppiftr_so "|".
    PUT UNFORMATTED v_start "|".
    PUT UNFORMATTED phantom "|".
    PUT UNFORMATTED xxppiftr_un "|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "pi_mstr.txt").


PUT UNFORMATTED "PI_LIST|".
PUT UNFORMATTED "PI_PART_CODE|".
PUT UNFORMATTED "PI_CURR|".
PUT UNFORMATTED "PI_UM|".
PUT UNFORMATTED "PI_START|".
PUT UNFORMATTED "PI_EXPIRE|".
PUT UNFORMATTED "PI_LIST_PRICE|" SKIP.

FOR EACH PI_MSTR WHERE pi_domain = global_domain and
         PI_PART_CODE <> "qadall--+--+--+--+--+" NO-LOCK:
    IF PI_START = ? THEN v_start = "".
    ELSE v_start = STRING(YEAR(PI_START)) + "/" + STRING(MONTH(PI_START)) + "/" + STRING(DAY(PI_START)).
    IF PI_EXPIRE = ? THEN v_end = "".
    ELSE v_end = STRING(YEAR(PI_EXPIRE)) + "/" + STRING(MONTH(PI_EXPIRE)) + "/" + STRING(DAY(PI_EXPIRE)).

    PUT UNFORMATTED PI_LIST "|".
    PUT UNFORMATTED PI_PART_CODE "|".
    PUT UNFORMATTED PI_CURR "|".
    PUT UNFORMATTED PI_UM "|".
    PUT UNFORMATTED v_start "|".
    PUT UNFORMATTED v_end "|".
    PUT UNFORMATTED PI_LIST_PRICE "|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "pc_mstr.txt").


PUT UNFORMATTED "PC_LIST|".
PUT UNFORMATTED "PI_PART|" SKIP.

FOR EACH PC_MSTR NO-LOCK where pc_domain = global_domain:
    PUT UNFORMATTED PC_LIST "|".
    PUT UNFORMATTED PC_PART "|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "ih_hist.txt").


PUT UNFORMATTED "IH_INV_NBR|".
PUT UNFORMATTED "IH_NBR|".
PUT UNFORMATTED "IH_INV_DATE|".
PUT UNFORMATTED "IH_CUST|".
PUT UNFORMATTED "IH_PR_LIST|" SKIP.

FOR EACH IH_HIST NO-LOCK where ih_domain = global_domain:
    IF IH_INV_DATE = ? THEN v_start = "".
    ELSE v_start = STRING(YEAR(IH_INV_DATE)) + "/" + STRING(MONTH(IH_INV_DATE)) + "/" + STRING(DAY(IH_INV_DATE)).

    PUT UNFORMATTED IH_INV_NBR "|".
    PUT UNFORMATTED IH_NBR "|".
    PUT UNFORMATTED v_start "|".
    PUT UNFORMATTED IH_CUST "|".
    PUT UNFORMATTED IH_PR_LIST "|" SKIP.
END.
OUTPUT CLOSE.


OUTPUT TO value(v_outpath + "idh_hist.txt").


PUT UNFORMATTED "IDH_INV_NBR|".
PUT UNFORMATTED "IDH_NBR|".
PUT UNFORMATTED "IDH_PART|".
PUT UNFORMATTED "IDH_QTY_INV|".
PUT UNFORMATTED "IDH_PRICE|" SKIP.

FOR EACH IDH_HIST NO-LOCK where idh_domain = global_domain:
    PUT UNFORMATTED IDH_INV_NBR "|".
    PUT UNFORMATTED IDH_NBR "|".
    PUT UNFORMATTED IDH_PART "|".
    PUT UNFORMATTED IDH_QTY_INV "|".
    PUT UNFORMATTED IDH_PRICE "|" SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO value(v_outpath + "rct_po.txt").


PUT UNFORMATTED "PO_NBER|".
PUT UNFORMATTED "PO_VEND|".
PUT UNFORMATTED "PART_NBR|".
PUT UNFORMATTED "RCT_AMOUNT|".
PUT UNFORMATTED "IMP_DATETIME|" SKIP.

FOR EACH PRH_HIST NO-LOCK WHERE prh_domain = global_domain and
         PRH_RCP_DATE >= DATE("01/" + STRING(MONTH(TODAY - 1)) + "/" + STRING(YEAR(TODAY - 1)))
    AND PRH_RCP_DATE <= TODAY - 1 BREAK BY PRH_NBR BY PRH_PART.
    IF FIRST-OF(PRH_NBR) THEN v_qty = 0.
    IF FIRST-OF(PRH_PART) THEN v_qty = 0.

    v_qty = v_qty + PRH_RCVD.

    IF LAST-OF(PRH_NBR) OR LAST-OF(PRH_PART) THEN DO:
        IF PRH_RCP_DATE = ? THEN v_start = "".
        ELSE v_start = STRING(YEAR(PRH_RCP_DATE)) + "/" + STRING(MONTH(PRH_RCP_DATE)) + "/" + STRING(DAY(PRH_RCP_DATE)).

        PUT UNFORMATTED UPPER(PRH_NBR) "|".
        PUT UNFORMATTED UPPER(PRH_VEND) "|".
        PUT UNFORMATTED UPPER(PRH_PART) "|".
        PUT UNFORMATTED v_qty "|".
        PUT UNFORMATTED v_start "|" SKIP.
    END.
END.
OUTPUT CLOSE.



OUTPUT TO value(v_outpath + "qad_wkfl.txt").

PUT UNFORMATTED "FACILITY|".
PUT UNFORMATTED "IMP_DATETIME|".
PUT UNFORMATTED "PART_NBR|".
PUT UNFORMATTED "PO_NBR|".
PUT UNFORMATTED "QAD_RATE|".
PUT UNFORMATTED "PO_VEND|".
PUT UNFORMATTED "EFF_DATE|".
PUT UNFORMATTED "PART_CHARGER|".
PUT UNFORMATTED "QAD_FLAG|".
PUT UNFORMATTED "SUP_CURRENT|".
PUT UNFORMATTED "RATE_ID|".
PUT UNFORMATTED "VEND_PL|" SKIP.


FOR EACH pod_det WHERE pod_domain = global_domain and
         pod_status <> "C" /*AND (pod_end_eff[1] = ? OR pod_end_eff[1] >= TODAY - 2)*/  NO-LOCK:
    FIND FIRST po_mstr WHERE po_domain = global_domain and
               po_nbr = pod_nbr NO-LOCK NO-ERROR.
    IF AVAIL po_mstr THEN DO:
        v_vend = po_vend.
    END.
    IF pod__chr01 = "XG" OR pod__chr01 = "KD" OR pod__chr01 = "FSL" THEN v_supply = pod__chr01 . /*add FSL by QI 20120117*/
    ELSE v_supply = po_vend.

    v_percent = 0.
    FOR EACH QAD_WKFL WHERE qad_domain = global_domain and qad_key1 = "poa_det"  AND qad_charfld[3] = pod_site AND qad_charfld[2] = pod_part AND qad_datefld[1] <= TODAY - 1
        AND qad_charfld[1] = pod_nbr NO-LOCK:
        v_percent = qad_decfld[1].
        v_date = STRING(YEAR(qad_datefld[1])) + "/" + STRING(MONTH(qad_datefld[1])) + "/" + STRING(DAY(qad_datefld[1])).
    END.
    IF v_percent = 0 THEN DO:
        IF pod_sched = YES THEN DO:
            v_percent = 0.
            v_date = "01" + "/" + "01" + "/" + "01".
        END.
        ELSE DO:
            v_percent = 100.
            v_date = STRING(YEAR(TODAY)) + "/" + STRING(MONTH(TODAY)) + "/" + STRING(DAY(TODAY)).
        END.
    END.


    FIND FIRST ptp_det WHERE ptp_domain = global_domain and
               ptp_part = pod_part  AND ptp_site = pod_site NO-LOCK NO-ERROR.
    IF AVAIL ptp_det THEN DO:
        FIND FIRST CODE_mstr WHERE code_domain = global_domain and
                   CODE_fldname = "ptp_buyer" AND CODE_value = ptp_buyer NO-LOCK NO-ERROR.
        IF AVAIL CODE_mstr THEN v_buyer = SUBSTRING(CODE_cmmt,1,5).
        ELSE v_buyer = "".

        v_run1 = ptp_run_seq1.
    END.
    ELSE DO:
        v_buyer = "".
        v_run1 = "".
    END.

    FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = pod_part NO-LOCK NO-ERROR.
    IF AVAIL pt_mstr THEN v_prod_line = pt_prod_line.
    ELSE v_prod_line = "".

    v_start = STRING(YEAR(TODAY)) + "/" + STRING(MONTH(TODAY)) + "/" + STRING(DAY(TODAY)).


    CREATE xxwk.
    ASSIGN xxwk.xx_site = pod_site
           xxwk.xx_start = v_start
           xxwk.xx_part = pod_part
           xxwk.xx_nbr = pod_nbr
           xxwk.xx_percent = v_percent
           xxwk.xx_vend = v_vend
           xxwk.xx_date = v_date
           xxwk.xx_buyer = v_buyer
           xxwk.xx_t = "T"
           xxwk.xx_f = "F"
           xxwk.xx_blank = "      |"
           xxwk.xx_supply = v_supply
           xxwk.xx_sch = pod_sched
           xxwk.xx_run_seq1 = v_run1
           xxwk.xx_prod_line = v_prod_line.
END.


FOR EACH xxwk WHERE xxwk.xx_run_seq1 <> "PO-MH" AND
    ((xxwk.xx_prod_line >= "1200" AND xxwk.xx_prod_line <= "15ZZ") OR (xxwk.xx_prod_line >= "1700" AND xxwk.xx_prod_line <= "4ZZZ"))
    BREAK BY xx_part BY xx_site BY xxwk.xx_vend BY xx_sch DESC BY xxwk.xx_date.

    IF LAST-OF(xx_part) OR LAST-OF(xx_site) OR LAST-OF(xxwk.xx_vend) THEN DO:
        PUT UNFORMATTED UPPER(xxwk.xx_site)"|".
        PUT UNFORMATTED xxwk.xx_start "|".
        PUT UNFORMATTED UPPER(xxwk.xx_part) "|".
        PUT UNFORMATTED UPPER(xxwk.xx_nbr) "|".
        PUT UNFORMATTED xxwk.xx_percent "|".
        PUT UNFORMATTED UPPER(xxwk.xx_vend) "|".
        PUT UNFORMATTED xxwk.xx_date "|".
        PUT UNFORMATTED  UPPER(xxwk.xx_buyer) "|".
        PUT UNFORMATTED "T|".
        PUT UNFORMATTED "F|".
        PUT UNFORMATTED xxwk.xx_blank.
        IF xxwk.xx_sch = NO AND (xxwk.xx_run_seq1 = "PO-XG" OR xxwk.xx_run_seq1 = "PO-KD") THEN
            PUT UNFORMATTED UPPER(SUBSTRING(xxwk.xx_run_seq1,4,2)) "|" SKIP.
        ELSE PUT UNFORMATTED UPPER(xxwk.xx_supply) "|" SKIP.
    END.

END.

FUNCTION getWcSite RETURNS character(iwkctr as character):
 /* -----------------------------------------------------------
    Purpose:
    Parameters: iwkctr  workcenter
    Notes:
 东区（DCEC-B）：装配  Z+数字或字母或-，附装 ZF+数字或字母或-，分装   ZS+数字或字母或-；
 西区（DCEC-C）：装配  XA+数字或字母或-、试验  XT+数字或字母或-、喷漆  XP+数字或字母或-、附装  XU+数字或字母或-、分装  XF+数字或字母或-；
 西区（DCEC-C）：F+数字或字母或- ；A+数字或字母或-；T+数字或字母或-；P+数字或字母或-；U+数字或字母或-；
 再造（DCEC-C）：装配  R+数字或字母或-。
 其他地点为空

  -------------------------------------------------------------*/
  define variable i as integer.
  define variable yn as logical.
  define variable ret as character.
  define variable ctrltxt as character
         initial "1234567890abcdefghijklmnopqrstuvwxyz-".
  ret = "".
  yn = no.
  if index("X,F,A,T,P,U,R",substring(iwkctr,1,1)) > 0 then do:
     yn = yes.
     if substring(iwkctr,1,1) = "X" then do:
        if index("A,T,P,U,F",substring(iwkctr,2,1)) > 0 then do:
           do i = 3 to length(iwkctr):
              if index(ctrltxt,lower(substring(iwkctr,i,1))) = 0 then do:
                 assign yn = no.
                 leave.
              end.
           end.
        end.
        else do:
             assign yn = no.
        end.
     end.
     else do:
       do i = 2 to length(iwkctr):
          if index(ctrltxt,lower(substring(iwkctr,i,1))) = 0 then do:
             assign yn = no.
             leave.
          end.
       end.
     end.
     if yn then do:
        ret = "DCEC-C".
     end.
  end.
  else if index("Z",substring(iwkctr,1,2)) > 0 then do:
     yn = yes.
     do i = 2 to length(iwkctr):
        if index(ctrltxt,lower(substring(iwkctr,i,1))) = 0 then do:
           assign yn = no.
           leave.
        end.
     end.
     if yn then do:
        ret =  "DCEC-B".
     end.
  end.
  return ret.

END FUNCTION. /*FUNCTION getWcSite*/


/*****20130118****************************************************************
FUNCTION getWcSite RETURNS character(iwkctr as character):
 /* -----------------------------------------------------------
    Purpose:
    Parameters: iwkctr  workcenter
    Notes:
    东区（DCEC-B）：装配  Z+数字，附装 ZF+数字，分装   ZS+数字；
    西区（DCEC-C）：装配  A+数字，试验  TA+数字，喷漆  PA+数字，附装  UA+数字，分装  FA+数字；
    西区（DCEC-C）：装配  XA+数字、试验  XT+数字、喷漆  XP+数字、附装  XU+数字、分装  XF+数字；
    再造（DCEC-R）：装配  RA+数字、试验  RT+数字、喷漆  RP+数字、附装  RU+数字。
    其他地点为空
  -------------------------------------------------------------*/
  define variable i as integer.
  define variable yn as logical.
  define variable ret as character.
  ret = "".
  if index("TA,PA,UA,FA,XA,XT,XP,XU,XF",substring(iwkctr,1,2)) > 0 then do:
     yn = yes.
     do i = 3 to length(iwkctr):
        if index("1234567890",substring(iwkctr,i,1)) = 0 then do:
           assign yn = no.
           leave.
        end.
     end.
     if yn then do:
        ret =  "DCEC-C".
     end.
  end.
  else if substring(iwkctr,1,1) = "A" then do:
     yn = yes.
     do i = 2 to length(iwkctr):
        if index("1234567890",substring(iwkctr,i,1)) = 0 then do:
           assign yn = no.
           leave.
        end.
     end.
     if yn then do:
        ret = "DCEC-C".
     end.
  end.
  else if index("ZF,ZS",substring(iwkctr,1,2)) > 0 then do:
     yn = yes.
     do i = 3 to length(iwkctr):
        if index("1234567890",substring(iwkctr,i,1)) = 0 then do:
           assign yn = no.
           leave.
        end.
     end.
     if yn then do:
        ret =  "DCEC-B".
     end.
  end.
  else if substring(iwkctr,1,1) = "Z" then do:
     yn = yes.
     do i = 2 to length(iwkctr):
        if index("1234567890",substring(iwkctr,i,1)) = 0 then do:
           assign yn = no.
           leave.
        end.
     end.
     if yn then do:
        ret = "DCEC-B".
     end.
  end.
  else if index("RA,RT,RP,RU",substring(iwkctr,1,2)) > 0 then do:
     yn = yes.
     do i = 3 to length(iwkctr):
        if index("1234567890",substring(iwkctr,i,1)) = 0 then do:
           assign yn = no.
           leave.
        end.
     end.
     if yn then do:
        ret =  "DCEC-R".
     end.
  end.
  return ret.
END FUNCTION. /*FUNCTION getWcSite*/
***************************************************************************/

/*
v_qty = 0.
FOR EACH ld_det WHERE ld_domain = global_domain and ld_qty_oh <> 0 AND
    ((ld_loc >= "XG" AND  ld_loc <= "XGZZZZZZ") OR (ld_loc >= "KD" AND  ld_loc <= "KDZZZZZZ") OR (ld_loc >= "FS" AND  ld_loc <= "FSZZZZZZ"))
    BREAK BY ld_site BY ld_part.
    IF FIRST-OF(ld_site) OR FIRST-OF(ld_part) THEN DO:
        v_start = STRING(YEAR(TODAY)) + "/" + STRING(MONTH(TODAY)) + "/" + STRING(DAY(TODAY)).

        PUT UNFORMATTED UPPER(ld_site)"|".
        PUT UNFORMATTED v_start "|".
        PUT UNFORMATTED UPPER(ld_part) "|".
        PUT UNFORMATTED  "           |".
        PUT UNFORMATTED  "0|".
        PUT UNFORMATTED UPPER(ld_loc) "|".
        PUT UNFORMATTED v_start "|".
        PUT UNFORMATTED   "    |".
        PUT UNFORMATTED "T|".
        PUT UNFORMATTED "F|".
        PUT UNFORMATTED "      |".
        PUT UNFORMATTED  UPPER(ld_loc) "|" SKIP.
    END.

END.
*/


