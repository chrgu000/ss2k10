{mfdeclre.i}
DEFINE VAR v_3pl LIKE pod__chr01.
DEFINE VAR v_wh LIKE IN__qadc01.
DEFINE VAR v_pur_price LIKE prh_pur_cost.
DEFINE VAR v_pur_time AS CHAR.

DEFINE VAR mfile  AS CHAR.
DEFINE VAR mfile1 AS CHAR.

DEFINE VAR v_date_string AS CHAR.


FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
mfile  = "SQ05\SQ05_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".


OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.

FOR EACH prh_hist WHERE prh_domain = global_domain and prh_rcp_date >= TODAY - 1  AND prh_rcp_date  <= TODAY - 1 NO-LOCK.
    FIND FIRST pod_det WHERE pod_domain = global_domain and pod_nbr = prh_nbr AND pod_line = prh_line AND pod__chr01 <> "LS" AND pod__chr01 <> "" AND pod__chr01 <> "MH" NO-LOCK NO-ERROR.
    IF AVAIL pod_det THEN v_3pl = pod__chr01.
    ELSE v_3pl = "".
    FIND FIRST IN_mstr WHERE in_domain = global_domain and IN_part = prh_part AND IN_site = prh_site NO-LOCK NO-ERROR.
    IF AVAIL IN_mstr THEN DO:    
       FIND FIRST  CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "Keeper-Warehouse" AND CODE_value = IN__qadc01 NO-LOCK NO-ERROR.
       IF AVAIL CODE_mstr THEN v_wh = CODE_cmmt.
       ELSE DO:
        IF in_site = "DCEC-B" THEN v_wh = "B01".
        IF in_site = "DCEC-C" THEN v_wh = "C01".
        IF in_site = "DCEC-SV" THEN v_wh = "V01".
       END.
    END.
    ELSE DO:
      IF prh_site = "DCEC-B" THEN v_wh = "B01".
      IF prh_site = "DCEC-C" THEN v_wh = "C01".
      IF prh_site = "DCEC-SV" THEN v_wh = "V01".       
    END.
  
        

    FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = prh_part NO-LOCK NO-ERROR.

    FIND LAST pc_mstr WHERE pc_domain = global_domain and pc_part = prh_part AND pc_list = prh_vend AND (pc_start <> 01/01/01 and pc_start <= prh_rcp_date) AND (pc_expire >= prh_rcp_date  OR pc_expire = ?) NO-LOCK NO-ERROR.
    IF AVAIL pc_mstr  THEN v_pur_price = pc_amt[1].  /*prh_pur_cost*/
    ELSE v_pur_price = 0.
    
    v_date_string = STRING(YEAR(prh_rcp_date),"9999") + "-" + STRING(MONTH(prh_rcp_date),"99") + "-" +  STRING(DAY(prh_rcp_date),"99").
    v_pur_time  = "23:00:00".

    PUT UNFORMATTED "|".
    PUT UNFORMATTED UPPER(prh_receiver) "|".
    PUT UNFORMATTED prh_line "|".
    PUT UNFORMATTED UPPER(prh_nbr) "|".
    PUT UNFORMATTED UPPER(prh_site) "|".
    PUT UNFORMATTED UPPER(v_wh) "|".
    PUT UNFORMATTED UPPER(v_3pl) "|".
    PUT UNFORMATTED UPPER(prh_vend) "|".
    PUT UNFORMATTED v_date_string "|".
    PUT UNFORMATTED v_pur_time "|".
    PUT UNFORMATTED UPPER(prh_part) "|".
    PUT UNFORMATTED UPPER(pt_desc2) "|".
    PUT UNFORMATTED UPPER(pt_desc1) "|".
    PUT UNFORMATTED prh_rcvd "|".
    PUT UNFORMATTED prh_rcvd "|".
    PUT UNFORMATTED v_pur_price "|".
    PUT UNFORMATTED prh_rcvd * v_pur_price "|".
    PUT UNFORMATTED UPPER(prh_curr) SKIP.
END.

QUIT.
