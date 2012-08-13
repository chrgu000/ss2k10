{mfdtitle.i}
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
DEF FRAME a
    
    SKIP(0.5)
    "The PO is exporting......" COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.


VIEW FRAME a.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.

grp = 0.

isfirst = YES.
totcnt = 0.
mcnt = 0.
    /*FOR EACH sch_mstr USE-INDEX sch_cr_date WHERE sch_type = 4  AND sch_cr_date = 02/09/04 AND substr(sch__chr01,8,1) = '' NO-LOCK:
     
        totcnt = totcnt + 1.
    END.*/
    OUTPUT TO VALUE(CODE_CMMT + '\XML\PPO.XML').
  PUT '<?xml version="1.0" encoding="UTF-8" ?>' SKIP.
  PUT '<SupplyWeb_Data>' SKIP.
 

pre = ''.
   isend = NO.
    FOR EACH schd_det  USE-INDEX schd_dtr WHERE   schd_type = 4  AND substr(schd_rlse_id,1,8) = '20070413' /*AND schd_nbr = '0000401c'*/  NO-LOCK :
     
        
    IF pre <> schd_rlse_id + schd_nbr + string(schd_line) THEN DO:
       
           FIND FIRST scx_ref WHERE scx_po = schd_nbr AND scx_line = schd_line AND scx_type = 2 NO-LOCK NO-ERROR.
        FIND FIRST sch_mstr WHERE sch_rlse_id = schd_rlse_id NO-LOCK NO-ERROR.
          IF ISEND THEN DO:
              PUT '</Part_Detail>' SKIP.
              PUT '</MaterialRelease>' SKIP.
          ISEND = NO.
          END.
          PUT '<MaterialRelease>' SKIP.
          PUT '<MaterialRelease_Header>' SKIP.
          PUT UNFORMAT '<release_no value="' SCHD_RLSE_ID '"/>' SKIP.
          PUT UNFORMAT '<release_date value="' string(year(sch_cr_date),'9999') '-' STRING(MONTH(sch_cr_date ),'99') '-' STRING(DAY(sch_cr_date),'99') '"/>' SKIP.
          PUT '<purpose_code value="00"/>' SKIP.
          PUT '<facility_id value="DCEC-B"/>' SKIP.
          PUT '<ship_to_id value="DCEC-B"/>' SKIP.
          PUT UNFORMAT '<supplier_id value="' SCX_SHIPFROM '"/>' SKIP.
          PUT UNFORMAT '<ship_delivery_code value="' substr(scx_shipfrom,LENGTH(scx_shipfrom) - 2,3) '"/>' SKIP.
          PUT '<test_yn value="N"/>' SKIP.
          PUT UNFORMAT '<po_number value="' SCH_NBR '"/>' SKIP.
          PUT '</MaterialRelease_Header>' SKIP.
  
    FIND FIRST pod_det WHERE pod_nbr = sch_nbr AND pod_line = sch_line NO-LOCK NO-ERROR.
      PUT '<Part_Detail>' SKIP.
      PUT UNFORMAT '<buyer_part_no value="' POD_PART '"/>' SKIP.
      PUT UNFORMAT '<po_number value="' SCH_NBR '"/>' SKIP.
     PUT UNFORMAT '<po_line_num value="' string(pod_line) '"/>' SKIP.
     PUT UNFORMAT '<unit_of_measure value="' pod_um '"/>' SKIP.
     PUT UNFORMAT '<cum_received_prior_qty value="0"/>' SKIP.
     
    END.
    PUT  '<Requirement_Detail>' SKIP.
    PUT  UNFORMAT '<requirement_date value="' string(year(schd_date),'9999') '-' string(MONTH(schd_date),'99') '-' STRING(DAY(schd_date),'99') '"/>' SKIP.
    PUT UNFORMAT '<requirement_time value="' string(schd_time) '"/>' SKIP.
    PUT UNFORMAT '<requirement_qty value="' STRING(schd_discr_qty) '"/>' SKIP.
    PUT '<requirement_type value="D"/>' SKIP.
    PUT '<requirement_freq value="D"/>' SKIP.
    PUT UNFORMAT '<requirement_end_date value="' string(year(schd_date + 30),'9999') '-' STRING(MONTH(schd_date + 30),'99') '-' STRING(DAY(schd_date + 30),'99') '"/>' SKIP.
    PUT '</Requirement_Detail>' SKIP.

isend = YES.
pre = schd_rlse_id + schd_nbr + string(schd_line).

/* sch_mstr*/
    END.
    PUT '</Part_Detail>' SKIP.
              PUT '</MaterialRelease>' SKIP.
PUT '</SupplyWeb_Data>'.
OUTPUT CLOSE.
   
MESSAGE "The PO XML file has been created!" VIEW-AS ALERT-BOX.

