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
DEFINE VARIABLE yn AS LOGICAL.
DEF FRAME a
    
    SKIP(0.5)
    "The Release is exporting......" COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.


VIEW FRAME a.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
DEFINE VARIABLE i AS INT.
grp = 0.

isfirst = YES.
totcnt = 0.
mcnt = 0.
    OUTPUT TO VALUE(CODE_CMMT + '\XML\PPOD.XML') CONVERT TARGET 'utf-8' SOURCE 'gb2312'.
    
    PUT '<?xml version="1.0" encoding="UTF-8" ?>' SKIP.
  PUT '<SupplyWeb_Data>' SKIP.
 

pre = ''.
   isend = NO.
   for each scx_ref no-lock
      where scx_type = 2 AND scx_shipfrom = '11BZ033',
      each pod_det no-lock
      where pod_nbr = scx_order and pod_line = scx_line AND pod_stat = "" ,
      each po_mstr no-lock
      where po_nbr = pod_nbr AND po_stat = "" :
        
     FOR EACH sch_mstr no-lock
   where sch_type = 4   AND sch_rlse_id = pod_curr_rlse_id[1]
   and sch_nbr = pod_nbr and sch_line = pod_line:
             
        yn = YES.
         for each schd_det no-lock
    where schd_type = sch_type AND schd_date >= TODAY AND schd_date <= TODAY + 90  
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
          PUT UNFORMAT '<release_no value="' SCH_RLSE_ID '"/>' SKIP.
          PUT UNFORMAT '<release_date value="' string(year(sch_cr_date),'9999') '-' STRING(MONTH(sch_cr_date ),'99') '-' STRING(DAY(sch_cr_date),'99') '"/>' SKIP.
          PUT '<purpose_code value="00"/>' SKIP.
          PUT '<facility_id value="DCEC-B"/>' SKIP.
          PUT '<ship_to_id value="DCEC-B"/>' SKIP.
          PUT UNFORMAT '<supplier_id value="' po_vend '"/>' SKIP.
          PUT UNFORMAT '<ship_delivery_code value="' substr(po_vend,LENGTH(po_vend) - 2,3) '"/>' SKIP.
          PUT '<test_yn value="N"/>' SKIP.
          PUT UNFORMAT '<po_number value="' SCH_NBR '"/>' SKIP.
          PUT '</MaterialRelease_Header>' SKIP.
  
    
      PUT '<Part_Detail>' SKIP.
      PUT UNFORMAT '<buyer_part_no value="' POD_PART '"/>' SKIP.
      PUT UNFORMAT '<po_number value="' SCH_NBR '"/>' SKIP.
     PUT UNFORMAT '<po_line_num value="' string(pod_line) '"/>' SKIP.
     PUT UNFORMAT '<unit_of_measure value="' pod_um '"/>' SKIP.
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
    PUT '<requirement_freq value="D"/>' SKIP.
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

