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
/*K0MZ*/ define  variable date_from as date label {&rsrp01_p_5}.
/*K0MZ*/ define  variable date_to as date.
DEF VAR muser AS CHAR FORMAT "x(8)" LABEL '用户'.
DEF VAR buyer LIKE ptp_buyer.
DEF VAR buyer1 LIKE ptp_buyer.
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
  muser COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.


FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
DEFINE VARIABLE i AS INT.
   setFrameLabels(frame a:handle).
REPEAT:
   DATE_from = TODAY.
   DATE_to = TODAY + 90.
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
        WITH FRAME a.
    IF supplier_to = '' THEN supplier_to = hi_char.
    IF shipto_to = '' THEN shipto_to = hi_char.
    IF part_to = '' THEN part_to = hi_char.
    IF buyer_to = '' THEN buyer_to = hi_char.
    IF po_to = '' THEN po_to = hi_char.
    IF DATE_from = ? THEN DATE_from = low_date.
    IF DATE_to = ? THEN DATE_to = hi_date.
grp = 0.
IF (supplier_from <> '' OR supplier_to <> hi_char) AND muser <> '' THEN DO:
        MESSAGE '供应商与用户不能同时选!' VIEW-AS ALERT-BOX.
        UNDO,RETRY.
    END.
  /*  IF muser <> '' THEN DO:
  
 FIND FIRST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = muser NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN buyer = CODE_value.
FIND LAST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = muser NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN buyer1 = CODE_value.
 
    END.*/
isfirst = YES.
totcnt = 0.
mcnt = 0.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
mfile = string(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + 'ppod.xml'.
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
      where pod_nbr = scx_order and pod_line = scx_line AND pod_stat = "" ,
     /* each po_mstr no-lock
      where po_nbr = pod_nbr 
        /*and po_buyer >= buyer_from and po_buyer <= buyer_to*/ AND po_stat = "" */
         EACH  ptp_det NO-LOCK WHERE ptp_part = scx_part AND ptp_site = scx_shipto AND  (IF muser <> '' THEN 
            CAN-FIND(FIRST CODE_mstr WHERE CODE_fldname = 'ptp_buyer' AND  CODE_value = ptp_buyer AND SUBSTR(CODE_cmmt,1,INDEX(CODE_cmmt,',') - 1) = muser NO-LOCK) ELSE YES)  :
     FOR EACH sch_mstr no-lock
   where sch_type = 4   
   and sch_nbr = pod_nbr and sch_line = pod_line
        /*  and sch_cr_date >= date_from and sch_cr_date <= date_to*/
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
          PUT '<purpose_code value="00"/>' SKIP.
          FIND FIRST pt_mstr WHERE pt_part = scx_part NO-LOCK NO-ERROR.
          PUT unformat '<facility_id value="' /*IF AVAILABLE pt_mstr THEN upper(pt_site) ELSE*/ upper(scx_shipto) '"/>' SKIP.
             FIND IN_mstr WHERE IN_part = scx_part AND IN_site = (/*IF AVAILABLE pt_mstr THEN pt_site ELSE*/ scx_shipto)   NO-LOCK NO-ERROR.

                 PUT UNFORMAT '<ship_to_id value="' IF AVAILABLE IN_mstr AND SUBSTR(IN__qadc01,1,2) <> '' THEN upper(SUBSTR(IN__qadc01,1,2)) ELSE '' '"/>' SKIP.
          PUT UNFORMAT '<supplier_id value="' upper(scx_shipfrom) '"/>' SKIP.
          PUT UNFORMAT '<ship_delivery_code value="DL"/>' SKIP.
          PUT '<test_yn value="N"/>' SKIP.
          PUT UNFORMAT '<po_number value="' upper(SCH_NBR) '"/>' SKIP.
          PUT '</MaterialRelease_Header>' SKIP.
  
    
      PUT '<Part_Detail>' SKIP.
      PUT UNFORMAT '<buyer_part_no value="' upper(POD_PART) '"/>' SKIP.
      FIND FIRST pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR.
      PUT UNFORMAT '<buyer_part_desc value="' IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE ' ' '"/>' SKIP.
      PUT UNFORMAT '<po_number value="' upper(SCH_NBR) '"/>' SKIP.
     PUT UNFORMAT '<po_line_num value="' string(pod_line) '"/>' SKIP.
     PUT UNFORMAT '<unit_of_measure value="' upper(pod_um) '"/>' SKIP.
     PUT UNFORMAT '<cum_received_prior_qty value="0"/>' SKIP.
     /*FIND FIRST ad_mstr WHERE ad_addr = po_vend AND ad_type = "supplier"  NO-LOCK NO-ERROR.
     /*IF ad_name <> '' THEN*/
     
     PUT UNFORMAT '<flex name="' po_vend '" value="' ad_name '"/>' SKIP.
 */
            yn = NO.
            isend = YES.
         END.







    PUT  '<Requirement_Detail>' SKIP.
    PUT  UNFORMAT '<requirement_date value="' string(year(schd_date),'9999') '-' string(MONTH(schd_date),'99') '-' STRING(DAY(schd_date),'99') '"/>' SKIP.
    PUT UNFORMAT '<requirement_time value="' string(schd_time) '"/>' SKIP.
    PUT UNFORMAT '<requirement_qty value="' STRING(schd_discr_qty) '"/>' SKIP.
    PUT '<requirement_type value="D"/>' SKIP.
    PUT '<requirement_freq value="M"/>' SKIP.
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
