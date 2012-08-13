{mfdtitle.i}
    &SCOPED-DEFINE rsrp01_p_5 "Created"
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR grp AS INT .
DEF VAR mcount AS INT.
DEF VAR totcnt AS INT.
DEF VAR iscr AS LOGICAL.
DEF VAR isfirst AS LOGICAL.
DEF VAR mfile AS CHAR.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR mqty LIKE pod_qty_ord.
DEF VAR mamt LIKE pod_pur_cost.
DEF VAR meffdt as CHAR FORMAT "x(8)".
DEF VAR  pre AS CHAR.
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
DEF VAR mcnt AS INT.
DEF VAR ishave AS LOGICAL.
DEF VAR pre1 AS CHAR.
DEF VAR isend AS LOGICAL.
DEFINE VARIABLE yn AS LOGICAL.
define  variable supplier_from like po_vend.
/*K0MZ*/ define  variable supplier_to like po_vend.
/*K0MZ*/ define  variable shipto_from like po_ship.
/*K0MZ*/ define  variable shipto_to like po_ship.
/*K0MZ*/ define  variable part_from like pod_part.
/*K0MZ*/ define  variable part_to like pod_part.
/*K0MZ*/ DEFINE variable po_from like po_nbr.
/*K0MZ*/ define  variable po_to like po_nbr.
/*K0MZ*/ define  variable buyer_from like po_buyer.
/*K0MZ*/ define  variable buyer_to like po_buyer.
/*K0MZ*/ define  variable date_from as date label  {&rsrp01_p_5}.
/*K0MZ*/ define  variable date_to as date.
DEF VAR purpose AS CHAR FORMAT "x(2)" LABEL "日程目的".
DEF VAR mdesc_p AS CHAR FORMAT "x(8)".
DEF VAR delivery AS CHAR FORMAT "x(2)" LABEL "基于交付/发货".
DEF VAR mdesc_d AS CHAR FORMAT "x(8)".
DEF VAR mfreq AS CHAR FORMAT "x(3)" LABEL "需求周期".
DEF VAR mdesc_f AS CHAR FORMAT "x(8)".
DEF VAR muser AS CHAR FORMAT "x(8)" LABEL '用户'.
DEF VAR buyer LIKE ptp_buyer.
DEF VAR buyer1 LIKE ptp_buyer.
DEF VAR logistic LIKE pod__chr01 FORMAT 'x(8)' LABEL '物流公司'.
DEF FRAME a
    
    SKIP(0.5)
    supplier_from COLON 15
    supplier_to COLON 45
    shipto_from COLON 15
    shipto_to COLON 45
    part_from COLON 15
    part_to COLON 45
   po_from COLON 15
    po_to COLON 45
    DATE_from COLON 15
    DATE_to COLON 45
   muser COLON 15 logistic COLON 45
    purpose COLON 15
    mDESC_p  NO-LABEL COLON 45
    delivery COLON 15
    mdesc_d NO-LABEL COLON 45
    mfreq COLON 15
    mdesc_f NO-LABEL COLON 45
    WITH WIDTH 80 SIDE-LABELS THREE-D.
ON CURSOR-DOWN OF purpose
DO:
   ASSIGN purpose.
   IF purpose = '00' THEN DO:
       purpose = '01'.
       mdesc_p = '结束日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
   IF purpose = '01' THEN DO:
       purpose = '05'.
       mdesc_p = '取代日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
   IF purpose = '05' THEN DO:
       purpose = '00'.
       mdesc_p = '新日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
   IF purpose <> '00' AND purpose <> '01' AND purpose <> '05' THEN DO:
       purpose = '00'.
       mdesc_p = '新日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
END.
ON CURSOR-UP OF purpose
DO:
   ASSIGN purpose.
   IF purpose = '00' THEN DO:
       purpose = '01'.
       mdesc_p = '结束日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
   IF purpose = '01' THEN DO:
       purpose = '05'.
       mdesc_p = '取代日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
   IF purpose = '05' THEN DO:
       purpose = '00'.
       mdesc_p = '新日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
   IF purpose <> '00' AND purpose <> '01' AND purpose <> '05' THEN DO:
       purpose = '00'.
       mdesc_p = '新日程'.
       DISP purpose mdesc_p WITH FRAME a.
       LEAVE.
   END.
END.
ON CURSOR-DOWN OF delivery
DO:
   ASSIGN delivery.
   IF delivery = 'SH' THEN DO:
       delivery = 'DL'.
       mdesc_d = '交付'.
       DISP delivery mdesc_d WITH FRAME a.
       LEAVE.
   END.
   IF delivery = 'DL' THEN DO:
       delivery = 'SH'.
       mdesc_d = '发货'.
       DISP delivery mdesc_d WITH FRAME a.
       LEAVE.
   END.
   IF delivery <> 'SH' AND delivery <> 'DL' THEN DO:
       delivery = 'DL'.
       mdesc_d = '交付'.
       DISP delivery mdesc_d WITH FRAME a.
       LEAVE.
   END.
   
END.
ON CURSOR-UP OF delivery
DO:
   ASSIGN delivery.
   IF delivery = 'SH' THEN DO:
       delivery = 'DL'.
       mdesc_d = '交付'.
       DISP delivery mdesc_d WITH FRAME a.
       LEAVE.
   END.
   IF delivery = 'DL' THEN DO:
       delivery = 'SH'.
       mdesc_d = '发货'.
       DISP delivery mdesc_d WITH FRAME a.
       LEAVE.
   END.
   IF delivery <> 'SH' AND delivery <> 'DL' THEN DO:
       delivery = 'DL'.
       mdesc_d = '交付'.
       DISP delivery mdesc_d WITH FRAME a.
       LEAVE.
   END.
   
END.

ON CURSOR-UP OF mfreq
DO:
   ASSIGN mfreq.
   IF mfreq = 'D' THEN DO:
       mfreq = 'W'.
       mdesc_f = '周需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'W' THEN DO:
       mfreq = 'F'.
       mdesc_f = '灵活的需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'F' THEN DO:
       mfreq = 'J'.
       mdesc_f = 'JIT需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
    IF mfreq = 'J' THEN DO:
       mfreq = 'M'.
       mdesc_f = '月需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'M' THEN DO:
       mfreq = 'D'.
       mdesc_f = '日需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq <> 'J' AND mfreq <> 'W' AND mfreq <> 'F' AND mfreq <> 'D' AND mfreq <> 'M' THEN DO:
       mfreq = 'D'.
       mdesc_f = '日需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   
END.

ON CURSOR-DOWN OF mfreq
DO:
   ASSIGN mfreq.
   IF mfreq = 'D' THEN DO:
       mfreq = 'W'.
       mdesc_f = '周需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'W' THEN DO:
       mfreq = 'F'.
       mdesc_f = '灵活的需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'F' THEN DO:
       mfreq = 'J'.
       mdesc_f = 'JIT需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'J' THEN DO:
       mfreq = 'M'.
       mdesc_f = '月需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq = 'M' THEN DO:
       mfreq = 'D'.
       mdesc_f = '日需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   IF mfreq <> 'J' AND mfreq <> 'W' AND mfreq <> 'F' AND mfreq <> 'D' AND mfreq <> 'M' THEN DO:
       mfreq = 'D'.
       mdesc_f = '日需求'.
       DISP mfreq mdesc_f WITH FRAME a.
       LEAVE.
   END.
   
   
END.

FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
DEFINE VARIABLE i AS INT.
   setFrameLabels(frame a:handle).
REPEAT:
   DATE_from = TODAY.
   DATE_to = TODAY.
   purpose = '00'.
   delivery = 'DL'.
   mfreq = 'D'.
    UPDATE supplier_from 
    supplier_to 
    shipto_from
    shipto_to 
    part_from 
    part_to 
   muser
    po_from 
    po_to 
    DATE_from 
    DATE_to 
        purpose
        delivery logistic
        mfreq WITH FRAME a.
    DISP mdesc_f mdesc_d mdesc_p WITH FRAME a.
    IF supplier_to = '' THEN supplier_to = hi_char.
   IF shipto_to = '' THEN shipto_to = hi_char.
   IF part_to = '' THEN part_to = hi_char.
   IF buyer1 = '' THEN buyer1 = hi_char.
   IF po_to = '' THEN po_to = hi_char.
   IF DATE_from = ? THEN DATE_from = low_date.
   IF DATE_to = ? THEN DATE_to = hi_date.

    IF (supplier_from <> '' OR supplier_to <> hi_char) AND muser <> '' THEN DO:
        MESSAGE '供应商与用户不能同时选!' VIEW-AS ALERT-BOX.
        UNDO,RETRY.
    END.
        IF delivery <> 'SH' AND delivery <> 'DL' THEN
             DO: MESSAGE '无效交付/发货代码!' VIEW-AS ALERT-BOX.
         UNDO,RETRY.
        END.
         IF purpose <> '00' AND purpose <> '01' AND purpose <> '05' THEN
              DO: MESSAGE '无效日程目的代码!' VIEW-AS ALERT-BOX.
         UNDO,RETRY.
         END.
        IF mfreq <> 'J' AND mfreq <> 'W' AND mfreq <> 'F' AND mfreq <> 'D' AND mfreq <> 'M' THEN 
         DO: MESSAGE '无效周期需求!' VIEW-AS ALERT-BOX.
         UNDO,RETRY.
     END.
   
   /* FIND FIRST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND code_value =  INPUT ptp_buyer AND SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = GLOBAL_userid  NO-LOCK NO-ERROR.
IF NOT AVAILABLE CODE_mstr THEN DO:
    
   
        MESSAGE '输入的计划员不属于该用户!' VIEW-AS ALERT-BOX.
        UNDO,RETRY.
    END.*/
   /* IF muser <> '' THEN DO:
  
    FIND FIRST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = muser NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN buyer = CODE_value.
 FIND LAST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = muser NO-LOCK NO-ERROR.
       IF AVAILABLE CODE_mstr THEN buyer1 = CODE_value.
    
  END.*/
grp = 0.

isfirst = YES.
totcnt = 0.
mcnt = 0.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
mfile = string(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + 'ppoc.xml'.
    OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET 'utf-8' SOURCE 'gb2312'.
    
    PUT '<?xml version="1.0" encoding="UTF-8" ?>' SKIP.
  PUT '<SupplyWeb_Data>' SKIP.
 

pre = ''.
   isend = NO.
  
    for each scx_ref no-lock
      where scx_type = 2 
       and scx_shipfrom >= supplier_from and scx_shipfrom <= supplier_to
      and scx_shipto >= shipto_from and scx_shipto <= shipto_to
      and scx_part >= part_from AND scx_part <= part_to
      and scx_po >= po_from and scx_po <= po_to,
      each pod_det no-lock
      where pod_nbr = scx_order and pod_line = scx_line AND pod_stat = ""  AND (IF logistic <> '' THEN pod__chr01 = logistic ELSE YES),
     /* each po_mstr no-lock
      where po_nbr = pod_nbr 
        /*and po_buyer >= buyer_from and po_buyer <= buyer_to*/ AND po_stat = "" */
        EACH  ptp_det NO-LOCK WHERE  ptp_part = scx_part AND ptp_site = scx_shipto AND (IF muser <> '' THEN 
            CAN-FIND(FIRST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  CODE_value = ptp_buyer AND SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = muser NO-LOCK) ELSE YES)  :

        FOR EACH sch_mstr no-lock
   where sch_type = 4   
   and sch_nbr = pod_nbr and sch_line = pod_line
          /*and sch_cr_date >= date_from and sch_cr_date <= date_to*/
         AND sch_rlse_id = pod_curr_rlse_id[1]:
             
        yn = YES.
         for each schd_det no-lock
    where schd_type = sch_type AND schd_date >= DATE_from AND schd_date <= DATE_to
    and schd_nbr = sch_nbr
    and schd_line = sch_line
    and schd_rlse_id = sch_rlse_id:


       IF yn THEN DO:
       
        IF  ISEND THEN DO:
              PUT '</Part_Detail>' SKIP.
              PUT '</MaterialRelease>' SKIP.
          ISEND = NO.
          END.
          PUT '<MaterialRelease>' SKIP.
          PUT '<MaterialRelease_Header>' SKIP.
          PUT UNFORMAT '<release_no value="' upper(SCH_RLSE_ID) '"/>' SKIP.
          PUT UNFORMAT '<release_date value="' string(year(sch_cr_date),'9999') '-' STRING(MONTH(sch_cr_date ),'99') '-' STRING(DAY(sch_cr_date),'99') '"/>' SKIP.
          PUT UNFORMAT '<purpose_code value="' upper(purpose) '"/>' SKIP.
          FIND FIRST pt_mstr WHERE pt_part = scx_part NO-LOCK NO-ERROR.
          PUT unformat '<facility_id value="' /*IF AVAILABLE pt_mstr THEN upper(pt_site) ELSE*/ upper(scx_shipto) '"/>' SKIP.
          FIND IN_mstr WHERE IN_part = scx_part AND IN_site = (/*IF AVAILABLE pt_mstr THEN pt_site ELSE*/ scx_shipto)   NO-LOCK NO-ERROR.

                 PUT UNFORMAT '<ship_to_id value="' IF AVAILABLE IN_mstr AND SUBSTR(IN__qadc01,1,2) <> '' THEN upper(SUBSTR(IN__qadc01,1,2)) ELSE SUBSTR(pod_nbr,LENGTH(pod_nbr),1) + '0' '"/>' SKIP.
          PUT UNFORMAT '<supplier_id value="' IF pod__chr01 <> '' AND pod__chr01 <> 'LS' THEN upper(pod__chr01) ELSE upper(scx_shipfrom) '"/>' SKIP.
          PUT UNFORMAT '<ship_delivery_code value="' upper(delivery) '"/>' SKIP.
          PUT '<test_yn value="N"/>' SKIP.
          PUT UNFORMAT '<po_number value="' upper(SCH_NBR) '"/>' SKIP.
          PUT '</MaterialRelease_Header>' SKIP.
  
    
      PUT '<Part_Detail>' SKIP.
    FIND  FIRST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  CODE_value = ptp_buyer NO-LOCK NO-ERROR. 
      PUT UNFORMAT '<contact_name value="' IF AVAILABLE code_mstr THEN SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) ELSE '' '"/>' SKIP.
      PUT UNFORMAT '<buyer_part_no value="'  (IF pod__chr01 <> '' AND pod__chr01 <> 'LS' THEN upper(scx_shipfrom) + '#'  ELSE '')  upper(POD_PART) '"/>' SKIP.
        PUT UNFORMAT '<buyer_part_desc value="' IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE ' ' '"/>' SKIP.                                                                                      
    PUT UNFORMAT '<po_number value="' upper(SCH_NBR) '"/>' SKIP.
     PUT UNFORMAT '<po_line_num value="' string(pod_line) '"/>' SKIP.
     PUT UNFORMAT '<unit_of_measure value="' upper(pod_um) '"/>' SKIP.
     PUT UNFORMAT '<cum_received_prior_qty value="0"/>' SKIP.
     FIND FIRST ad_mstr WHERE ad_addr = scx_shipfrom AND ad_type = "supplier"  NO-LOCK NO-ERROR.
     /*IF ad_name <> '' THEN*/
     IF AVAILABLE ad_mstr THEN
     PUT UNFORMAT '<flex name="' scx_shipfrom '" value="' upper(ad_name) '"/>' SKIP.
        ELSE PUT UNFORMAT '<flex name="' scx_shipfrom '" value=""/>' SKIP.
            yn = NO.
            isend = YES.
         END.







    PUT  '<Requirement_Detail>' SKIP.
    PUT  UNFORMAT '<requirement_date value="' string(year(schd_date),'9999') '-' string(MONTH(schd_date),'99') '-' STRING(DAY(schd_date),'99') '"/>' SKIP.
    PUT UNFORMAT '<requirement_time value="' string(schd_time) '"/>' SKIP.
    PUT UNFORMAT '<requirement_qty value="' STRING(schd_discr_qty) '"/>' SKIP.
    PUT '<requirement_type value="C"/>' SKIP.
    PUT UNFORMAT '<requirement_freq value="' upper(mfreq) '"/>' SKIP.
    PUT UNFORMAT '<requirement_end_date value="' string(year(schd_date + 30),'9999') '-' STRING(MONTH(schd_date + 30),'99') '-' STRING(DAY(schd_date + 30),'99') '"/>' SKIP.
    PUT '</Requirement_Detail>' SKIP.
     END.
    
/*pre = schd_rlse_id + schd_nbr + string(schd_line).*/
        /* END.*/
        /* ELSE DO:
              FIND FIRST scx_ref WHERE scx_po = pod_nbr AND scx_line = pod_line AND scx_type = 2 NO-LOCK NO-ERROR.
        FIND FIRST sch_mstr WHERE sch_rlse_id = pod_curr_rlse_id[1] AND sch_nbr = pod_nbr AND sch_line = pod_line NO-LOCK NO-ERROR.
            IF AVAILABLE sch_mstr THEN DO:
         
                 IF ISEND THEN DO:
              PUT '</Part_Detail>' SKIP.
              PUT '</MaterialRelease>' SKIP.
          ISEND = NO.
          END.
          PUT '<MaterialRelease>' SKIP.
          PUT '<MaterialRelease_Header>' SKIP.
          PUT UNFORMAT '<release_no value="' pod_curr_rlse_id[1] '"/>' SKIP.
          PUT UNFORMAT '<release_date value="' string(year(sch_cr_date),'9999') '-' STRING(MONTH(sch_cr_date ),'99') '-' STRING(DAY(sch_cr_date),'99') '"/>' SKIP.
          PUT '<purpose_code value="00"/>' SKIP.
          PUT '<facility_id value="DCEC-B"/>' SKIP.
          PUT '<ship_to_id value="DCEC-B"/>' SKIP.
          PUT UNFORMAT '<supplier_id value="' SCX_SHIPFROM '"/>' SKIP.
          PUT UNFORMAT '<ship_delivery_code value="' substr(scx_shipfrom,LENGTH(scx_shipfrom) - 2,3) '"/>' SKIP.
          PUT '<test_yn value="N"/>' SKIP.
          PUT UNFORMAT '<po_number value="' SCH_NBR '"/>' SKIP.
          PUT '</MaterialRelease_Header>' SKIP.
  
    
      PUT '<Part_Detail>' SKIP.
      PUT UNFORMAT '<buyer_part_no value="' POD_PART '"/>' SKIP.
      PUT UNFORMAT '<po_number value="' SCH_NBR '"/>' SKIP.
     PUT UNFORMAT '<po_line_num value="' string(pod_line) '"/>' SKIP.
     PUT UNFORMAT '<unit_of_measure value="' pod_um '"/>' SKIP.
     PUT UNFORMAT '<cum_received_prior_qty value="0"/>' SKIP.
     FIND FIRST ad_mstr WHERE ad_addr = scx_shipfrom NO-LOCK NO-ERROR.
     IF ad_name <> '' THEN
     PUT UNFORMAT '<flex name="' scx_shipfrom '" value="' ad_name '"/>' SKIP.
     ELSE PUT UNFORMAT '<flex name="' scx_shipfrom '" value="' ad_sort '"/>' SKIP.
     
 
    PUT  '<Requirement_Detail>' SKIP.
    PUT  UNFORMAT '<requirement_date value="' string(year(TODAY),'9999') '-' string(MONTH(TODAY),'99') '-' STRING(DAY(TODAY),'99') '"/>' SKIP.
    PUT UNFORMAT '<requirement_time value="0"/>' SKIP.
    PUT UNFORMAT '<requirement_qty value="0"/>' SKIP.
    PUT '<requirement_type value="C"/>' SKIP.
    PUT '<requirement_freq value="D"/>' SKIP.
    PUT UNFORMAT '<requirement_end_date value="' string(year(TODAY + 30),'9999') '-' STRING(MONTH(TODAY + 30),'99') '-' STRING(DAY(TODAY + 30),'99') '"/>' SKIP.
    PUT '</Requirement_Detail>' SKIP.

isend = YES.
            END.
             END.
     */

     
         END.
/* sch_mstr*/   
    END.
   PUT '</Part_Detail>' SKIP.
              PUT '</MaterialRelease>' SKIP.
PUT '</SupplyWeb_Data>'.
OUTPUT CLOSE.    
  /* OS-COMMAND SILENT value ("notepad c:\xml\PPOC.XML').*/
MESSAGE "The Release XML file has been created!" VIEW-AS ALERT-BOX.

END.
