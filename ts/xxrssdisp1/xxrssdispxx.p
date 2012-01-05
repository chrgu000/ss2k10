/* GUI CONVERTED from xxrssdisp1.p (converter v1)  mage 06/07/27 */



/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

/* PREPROCESSOR USED FOR REPORT'S WITH SIMULATION OPTION */
&SCOPED-DEFINE simulation true

define variable supp_schedule as integer initial 4.
define variable shipto_from like po_ship.
define variable shipto_to   like po_ship.
define variable part_from like pod_part.
define variable part_to   like pod_part.
define variable supplier_from like po_vend.
define variable supplier_to   like po_vend.
define variable po_from like po_nbr.
define variable po_to   like po_nbr.
define variable report_yn like mfc_logical label "Report Detail/Summary"
   format "Detail/Summary".
/* DEFAULT VALUE FOR UPDATE_YN IS CHANGED FROM YES TO NO  */
/* SINCE IT IS RECOMMENDED APPROACH IN HELP DOCUMENTATION */
define variable update_yn like mfc_logical label "Update" INITIAL YES no-undo.
define variable asof_date as date label "As-of Date".
define variable work_qty like schd_discr_qty.
define variable prior_end_date as date.
define variable new_end_date as date.
define variable cum_qty like sch_pcr_qty.
define variable ord_chg as decimal.
define variable start_date as date.
define variable orig_cum_qty as decimal.
define variable new_cum_qty as decimal.
define variable work_diff as decimal.
define variable i as integer.
define variable req_cum_req_qty like schd_cum_qty.
define variable monday_date as date.
define variable shipfrom_date as date.
define variable shipfrom_time as character.
define variable ret_status as character.
define variable interval as character.
define variable work_dt as date.
define variable last_dt as date.
define variable past_logic as integer.
define variable warn_ct as integer no-undo.
define variable error_ct as integer no-undo.
define new shared stream audit.
define variable sch_recid as recid.
define variable daylabel as character format "x(10)".
define variable buyer_from like po_buyer.
define variable buyer_to like po_buyer.
define variable past_due as decimal.
define variable amt_to_reduce like schd_det.schd_discr_qty.
define variable sched_type like sch_type.
define variable trans_lt_hrs as decimal format ">9.99" label "Trans LT Hours".
define variable new-schd-recno as recid.
define variable old_db as character no-undo.
define variable sdb_err as integer no-undo.
define buffer posite for si_mstr.
define variable got_db like mfc_logical no-undo.
define variable use_calendardays as logical format "Calendar/Working"
   initial yes no-undo.
define variable firm_upto as date no-undo.
define variable l_tmp_string1 as character no-undo.
define variable l_tmp_string2 as character no-undo.
define variable l_gen_pln like mfc_logical
   label "Generate Planning Schedules" no-undo.
define variable l_gen_shp like mfc_logical
   label "Generate Shipping Schedules" no-undo.
define variable l_adg_module like mfc_logical initial false no-undo.
define variable l_rlse_id like sch_rlse_id no-undo.
define variable curr_rel_id as integer no-undo.
define variable msg-text like msg_desc extent 2 no-undo.
define variable days     as character format "x(80)" no-undo.

define variable l_chk_schmstr like mfc_logical no-undo.
define variable l_chk_schdet  like mfc_logical no-undo.

define variable l_undo  like mfc_logical no-undo.
define variable l_recid as   recid       no-undo.

define new shared variable ship_dlvy_code as character.
define new shared variable interval_code as character.
define new shared variable req_dt as date.
define new shared variable req_qty as decimal.
define new shared variable week_offset as integer.
define new shared variable shipto_calid as character.
define new shared variable resch_ct as integer.
define new shared variable resch_dt as date extent 999 no-undo.
define new shared variable resch_qty as decimal extent 999 no-undo.
define new shared variable working_hours as decimal extent 999 no-undo.
define new shared variable resch_stat as character.
define new shared workfile work_schd like schd_det. /*workfiles last*/
define new shared variable date_based_rel_id like mfc_logical no-undo.
define new shared variable active_rlse_id    like sch_rlse_id no-undo.
define variable export_appid as character
   label "External Application" format "x(12)" no-undo.
define variable firm_yn      like mfc_logical
   label "Export Firm Schedules" initial false no-undo.
define variable plan_yn      like mfc_logical
   label "Export Planned Schedules" initial true no-undo.
define variable continue_exp like mfc_logical initial false.

define buffer current_sch_mstr for sch_mstr.
define buffer new_schd_det for schd_det.
define buffer poddet for pod_det.

define new shared temp-table t_schd_det no-undo like schd_det.

define variable export_enabled like mfc_logical initial false.


/***二分割增加***begin***************************************************************************************/


   DEFINE VARIABLE effdate   AS DATE.
   DEFINE VARIABLE effdate1   AS DATE.
   DEFINE VARIABLE effdate2   AS DATE.

   DEFINE VARIABLE psrecid  AS RECID EXTENT 150.
   DEFINE VARIABLE qty_per  AS decimal EXTENT 150.
   DEFINE VARIABLE qty_perx  AS  decimal.
   DEFINE VARIABLE vend1    AS CHAR FORMAT "x(8)".
   DEFINE VARIABLE vend2   AS  CHAR FORMAT "x(8)".
   DEFINE VARIABLE  Ix AS INT INITIAL 1.
   DEFINE VARIABLE  Jx AS INT INITIAL 1.
   DEFINE VARIABLE level AS INT INITIAL 1.
   DEFINE VARIABLE mx AS INT INITIAL 1.
   DEFINE VARIABLE par_part AS CHARACTER FORMAT "x(18)".
   DEFINE VARIABLE comp_um AS  CHARACTER FORMAT "x(2)".
   DEFINE VARIABLE sub AS LOGICAL.
   DEFINE VARIABLE ecnnbr AS CHARACTER FORMAT "x(12)".
   define new shared variable line as integer.
   define new shared variable line1 as integer.
 /*1029  DEFINE VARIABLE usedtime AS DECIMAL. */
   DEFINE VARIABLE half AS LOGICAL.
   DEFINE VARIABLE lastdate AS DATE.

   DEFINE VARIABLE usedtime1 AS DECIMAL.
   DEFINE VARIABLE usedtime2 AS DECIMAL.
   DEFINE VARIABLE usedtime3 AS DECIMAL.
   DEFINE VARIABLE usedtime4 AS DECIMAL.
   DEFINE VARIABLE usedtime5 AS DECIMAL.
   DEFINE VARIABLE usedtime6 AS DECIMAL.
   DEFINE VARIABLE usedtime7 AS DECIMAL.
   DEFINE VARIABLE usedtime8 AS DECIMAL.
   DEFINE VARIABLE usedtime9 AS DECIMAL.
    DEFINE VARIABLE usedtime10 AS DECIMAL.
    DEFINE VARIABLE usedtime11 AS DECIMAL.
 
   DEFINE VARIABLE lndrate LIKE lnd_rate.
   DEFINE VARIABLE cum_qty_req  LIKE schd_det.schd_cum_qty.
   DEFINE NEW SHARED VARIABLE NEW_schd_det as logical.
   DEFINE VARIABLE usedqty LIKE seq_qty_req.
   DEFINE VARIABLE change as logical.
   DEFINE NEW SHARED VARIABLE site   AS CHARACTER.
   DEFINE VARIABLE part_first_due as logical.
   DEFINE VARIABLE adjqty  as decimal .
   DEFINE VARIABLE sumqty  as  decimal.
   DEFINE VARIABLE sumqty1 as decimal.
   DEFINE VARIABLE adqty as decimal.

   define temp-table seqt_det no-undo  /*按时间段划分排程*/
    field  seqt_type   like  pt_run_seq2
    field  seqt_site   like  so_site
    field  seqt_line   LIKE  lnd_line
    field  seqt_due_date   as    date
    field  seqt_seq    as    integer
    field  seqt_part   like  pt_part
    field  seqt_qty_ord    like  seq_qty_req 
    index  seqt1 IS PRIMARY IS UNIQUE  seqt_site seqt_line seqt_part seqt_type seqt_due_date seqt_seq .

 define temp-table  podr1_det no-undo /*根据时间段排程,产生时间段物料需求*/
    field   podr1_site   like  so_site
    field   podr1_type   like  pt_run_seq2
    field   podr1_line   LIKE  lnd_line
    field   podr1_due_date   as    date
    field   podr1_schddue as   date
    field   podr1_seq    as    integer
    field   podr1_part   like  pt_part
    field   podr1_qty_ord     like  seq_qty_req
    field   podr1_qty_schd    like  seq_qty_req  
    FIELD   podr1_time        LIKE  schd_det.schd_time
    FIELD   podr1_rlse_id        LIKE  schd_det.schd_rlse_id
    FIELD   podr1_nbr        LIKE  schd_det.schd_nbr
    FIELD   podr1_line       LIKE  schd_det.schd_line
    index  podr11 is primary IS UNIQUE   podr1_site  podr1_line  podr1_type  podr1_part  podr1_due_date  podr1_seq 
    index  podr12 is unique   podr1_site podr1_type  podr1_part   podr1_line   podr1_schddue  podr1_due_date  podr1_seq
    index  podr13 is unique   podr1_site   podr1_part  podr1_type  podr1_line  podr1_schddue  podr1_due_date  podr1_seq.


 define temp-table podr_det no-undo /*根据时间段排程,产生时间段物料需求*/
   field  podr_site   like  so_site
   field  podr_type   like  pt_run_seq2
   field  podr_due_date   as    date
   field  podr_schddue as   date
   field  podr_seq    as    integer
   field  podr_part   like  pt_part
   field  podr_qty_ord     like  seq_qty_req
   field  podr_qty_schd    like  seq_qty_req  
   FIELD  podr_time        LIKE  schd_det.schd_time
   FIELD  podr_rlse_id        LIKE  schd_det.schd_rlse_id
   FIELD  podr_nbr        LIKE  schd_det.schd_nbr
   FIELD  podr_line       LIKE  schd_det.schd_line
   index  podr1 is primary IS UNIQUE  podr_site podr_type podr_part podr_due_date podr_seq 
   index  podr2 is unique  podr_site podr_type podr_part podr_schddue podr_due_date podr_seq
   index  podr3 is unique  podr_site  podr_part podr_type podr_schddue podr_due_date podr_seq.

 /***二分割增加***end***************************************************************************************/


define temp-table bm_ms no-undo
   field  bm_par  like pt_part
   field  bm_comp like pt_part
   FIELD  bm_desc LIKE pt_desc1
   field  bm_type like pt_run_seq2
   field  bm_qty_per like seq_qty_req 
   field  bm_vend like pt_vend
   INDEX  bm1 IS UNIQUE  bm_par bm_type bm_comp.
 /*FUNCTION work1date RETURNS DATE (  date10 AS DATE). */

define variable t2   as decimal extent 2  initial 4 no-undo.
define variable t4   as decimal extent 4  initial 2 no-undo.
define variable t6   as decimal extent 6  initial 2 no-undo.
define variable t12  as decimal extent 12 initial 1.5 no-undo.

define variable time2   as character extent 2  format "99:99" no-undo.
define variable time4   as character extent 4  format "99:99" no-undo.
define variable time6   as character extent 6  format "99:99" no-undo.
define variable time12  as character extent 12 format "99:99" no-undo.


/* Include file holds procedure to check export spec
*   and to check if recovery is needed*/
{rswoex.i}

{pocnvars.i} /* Consignment variables */

days = getTermLabel("SUNDAY",10) + ",".
days = days + getTermLabel("MONDAY",10) + ",".
days = days + getTermLabel("TUESDAY",10) + ",".
days = days + getTermLabel("WEDNESDAY",10) + ",".
days = days + getTermLabel("THURSDAY",10) + ",".
days = days + getTermLabel("FRIDAY",10) + ",".
days = days + getTermLabel("SATURDAY",10).

/* Determine if the MRP export fields are to be displayed */
run checkExpEnabled( output export_enabled ).

FORM /*GUI*/ 
   po_nbr
   pod_part
   po_vend
   pod_site label "Ship To"
with STREAM-IO /*GUI*/  frame audit down width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame audit:handle).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   effdate              colon 16 
   effdate1             colon 46 label "To"
   po_from              colon 16
   po_to                colon 46 label "To"
   part_from            colon 16
   part_to              colon 46 label "To"
   shipto_from          colon 16
   shipto_to            colon 46 label "To"
   supplier_from        colon 16
   supplier_to          colon 46 label "To"
   buyer_from           colon 16
   buyer_to             colon 46 label "To"
   update_yn            colon 35
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
firm_yn        colon 35
   plan_yn        colon 35
   export_appid   colon 35
with frame export_popup overlay row 5
   centered side-labels attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-export_popup-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame export_popup = F-export_popup-title.
 RECT-FRAME-LABEL:HIDDEN in frame export_popup = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame export_popup =
  FRAME export_popup:HEIGHT-PIXELS - RECT-FRAME:Y in frame export_popup - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME export_popup = FRAME export_popup:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame export_popup:handle).

asof_date = today.



/* site = "ts" . */


/***二分割增加***begin***************************************************************************************/

      FUNCTION work1date RETURNS DATE (  date10 AS DATE).
     date10 = date10 -  1.
     if not available shop_cal then
     find shop_cal no-lock where shop_domain = global_domain and shop_site = site
     and shop_wkctr = "" and shop_mch = "" no-error.

     if not available shop_cal then
     find shop_cal no-lock where shop_site = ""
     and shop_wkctr = "" and shop_mch = "" no-error.


     if available shop_cal
     and (shop_wday[1] or shop_wday[2] or shop_wday[3]
       or shop_wday[4] or shop_wday[5] or shop_wday[6] or shop_wday[7])
     then do:

/*G468*/    repeat:

/*G468*/       if shop_wdays[weekday(date10)] then do:
         
/*G468*/          if not can-find(hd_mstr where hd_domain = global_domain and  hd_date = date10
             and hd_site = site) then do:
/*G468*/             leave.
          end.
          else do:

          date10 = date10 +  1.
          end.
           end.
           else

         date10 = date10 +  1.

        end. /*repeat*/
     end. /*available shop_cal*/
/*G468*/ else release shop_cal.

    RETURN date10.

 END .

 /*ts******************************
 FUNCTION lastwork1date RETURNS DATE (  date11 AS DATE).
     date11 = date11 -  1.
     if not available shop_cal then
     find shop_cal no-lock where shop_site = site
     and shop_wkctr = "" and shop_mch = "" no-error.

     if not available shop_cal then
     find shop_cal no-lock where shop_site = ""
     and shop_wkctr = "" and shop_mch = "" no-error.


     if available shop_cal
     and (shop_wday[1] or shop_wday[2] or shop_wday[3]
       or shop_wday[4] or shop_wday[5] or shop_wday[6] or shop_wday[7])
     then do:

/*G468*/    repeat:

/*G468*/       if shop_wdays[weekday(date11)] then do:
         
/*G468*/          if not can-find(hd_mstr where hd_date = date11
             and hd_site = site) then do:
/*G468*/             leave.
          end.
          else do:

          date11 = date11 -  1.
          end.
           end.
           else

         date11 = date11 -  1.

        end. /*repeat*/
     end. /*available shop_cal*/
/*G468*/ else release shop_cal.

    RETURN date11.

 END .

 *ts******************************/


  FUNCTION lastwork1date RETURNS DATE (  date11 AS DATE, line11 AS CHARACTER).

     date11 = date11 -  1.
     find last rps_mstr no-lock where rps_domain = global_domain and  rps_site = site 
        and rps_line = line11 and rps_due_date >= date11 - 15 no-error.
	if available rps_mstr then date11 = rps_due_date .
    RETURN date11.

 END .



 FUNCTION nextwork1date RETURNS DATE (  date12 AS DATE).
    date12 = date12 + 1.
    if not available shop_cal then
    find shop_cal no-lock where shop_domain = global_domain and shop_site = site
    and shop_wkctr = "" and shop_mch = "" no-error.

    if not available shop_cal then
    find shop_cal no-lock where shop_domain = global_domain and shop_site = ""
    and shop_wkctr = "" and shop_mch = "" no-error.


    if available shop_cal
    and (shop_wday[1] or shop_wday[2] or shop_wday[3]
      or shop_wday[4] or shop_wday[5] or shop_wday[6] or shop_wday[7])
    then do:

/*G468*/    repeat:

/*G468*/       if shop_wdays[weekday(date12)] then do:

/*G468*/          if not can-find(hd_mstr where hd_domain and global_domain and hd_date = date12
            and hd_site = site) then do:
/*G468*/             leave.
         end.
         else do:

         date12 = date12 +  1.
         end.
          end.
          else

        date12 = date12  +  1.

       end. /*repeat*/
    end. /*available shop_cal*/
/*G468*/ else release shop_cal.

   RETURN date12.

END .


       effdate2 = nextwork1date(effdate1).
/*new  add beging **************/



assign t2[1] = 3.3
       t2[2] = 4.7
       t4[1] = 3.3
       t4[2] = 4.7
       t4[3] = 4.3
       t4[4] = 3.7
       t6[1] = 1.83
       t6[2] = 0.83
       t6[3] = 1.33
       t6[4] = 1
       t6[5] = 0.83
       t6[6] = 2
       t12[1] = 1.83
       t12[2] = 0.83
       t12[3] = 1.33
       t12[4] = 1
       t12[5] = 0.83
       t12[6] = 2
       t12[7] = 2
       t12[8] = 1.33
       t12[9] = 1
       t12[10] = 1.33
       t12[11] = 1
       t12[12] = 1 .

site = "ts".   

assign time2[1] =  "0900"
       time2[2] = "1400"
       time4[1] = "0900"
       time4[2] = "1400"
       time4[3] = "1800"
       time4[4] = "2200"
       time6[1] = "0830"
       time6[2] = "0930"
       time6[3] = "1030"
       time6[4] = "1230"
       time6[5] = "1330"
       time6[6] = "1500"		  
       time12[1] = "0830"  
       time12[2] = "0930"  
       time12[3] = "1030"  
       time12[4] = "1230"  
       time12[5] = "1330"  
       time12[6] = "1500"  
       time12[7] = "1730"  
       time12[8] = "1830"  
       time12[9] =  "1930" 
       time12[10] = "2030"  
       time12[11] = "2130"
       time12[12] = "2230". 
		     
/*new  add end **************/


/***二分割增加***end***************************************************************************************/

assign
   l_gen_pln = false
   l_gen_shp = false.

/* The flag on the control file rsc_ctrl and mfc_ctrl would always
* be maintained in sync. So we test value of mfc_ctrl flag */
l_adg_module = no.
if can-find (first mfc_ctrl where
   mfc_field = "enable_shipping_schedules"
   and mfc_seq = 4
   and mfc_module = "ADG"
   and mfc_logical = yes)
then
   l_adg_module = yes.
else
   l_adg_module = no.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}


repeat with frame a:
   hide frame audit no-pause.
   
/***二分割增加***begin***************************************************************************************/
   
       line = 0.
       
      
 
FOR EACH bm_ms:
        DELETE bm_ms.
  END. 
 
for each lnd_det no-lock where lnd_domain = global_domain AND lnd_site = "ts"   :
find first bm_ms  where bm_par = lnd_part no-lock no-error.
       if not  available bm_ms then   DO:
           level = 1.
           DO i = 1 TO 150:
            qty_per[1] = 1.
           END.
           CREATE bm_ms.
           ASSIGN bm_par = lnd_part
                  bm_comp = ""
                  bm_qty_per = 0.
           par_part = lnd_part .
           RUN  decompose(par_part ,  effdate, GLOBAL_domain ).   
       END.
end.
for each seqt_det :
delete seqt_det.
end.

/****二分割重排*******/
   for each seq_mstr NO-LOCK  WHERE seq_domain = GLOBAL_domain AND seq_site = "ts" AND  seq_due_date >= effdate 
      and seq_due_date <= effdate1    
      use-index seq_sequence  break by seq_line by seq_due_date BY seq_priority  by seq_part:

      
     
            find seqt_det where seqt_type = "011" and  seqt_site = seq_site  
	     and seqt_line = seq_line and seqt_due_date = seq_due_date
	     and seqt_part = seq_part and seqt_seq = 1 no-error.
	     if not available seqt_det then do:
	     create seqt_det .
	     assign seqt_site = seq_site 
	            seqt_line = seq_line 
		    seqt_part = seq_part
		    seqt_due_date = seq_due_date
	            seqt_seq = 1 
		    seqt_type = "011".
	     end. 
	     seqt_qty_ord = seqt_qty_ord + seq_qty_req.
	    
     END. /*for each seq_mstr */
     
     RELEASE seq_mstr.

 /*按时间段划分排程 end */

/*根据时间段排程,产生时间段物料需求*/

for each podr1_det :
delete podr1_det.
end.

/*******
FOR EACH bm_ms NO-LOCK:
    DISPLAY bm_par  bm_comp bm_type bm_qty_per WITH FRAME cc.
END.
**************/

FOR EACH seqt_det NO-LOCK:
   PUT   "Prod time discreate"  seqt_line  seqt_part seqt_due_date seqt_type  seqt_seq seqt_qty_ord SKIP  . 
END.

for each seqt_det no-lock: 


  for each bm_ms where bm_par = seqt_part and bm_type = seqt_type no-lock:

	   find first  podr1_det  where  podr1_site = seqt_site and  podr1_line = sept_line AND  podr1_type = seqt_type
	      AND   podr1_part =  bm_comp and  podr1_seq = seqt_seq and  podr1_due_date = seqt_due_date  no-error.
           
	   if not available  podr1_det then do: 
              create   podr1_det.
              assign   podr1_site =  seqt_site
                       podr1_line =  sept_line
	               podr1_part =  bm_comp
		       podr1_seq  =  seqt_seq
		       podr1_due_date = seqt_due_date
		       podr1_type = seqt_type
		      .
	   end.
             podr1_qty_ord =  podr1_qty_ord + seqt_qty_ord * bm_qty_per.

  END. /*for each bm_ms  */
end. /*for each seqt_det*/
/*根据时间段排程,产生时间段物料需求*/

 /*根据时间段物料需求, 产生时间段交货计划*/


   for each  podr1_det :
      if  podr1_type = "011" then do:
         if  podr1_seq = 1 then assign  podr1_schddue = lastwork1date( podr1_due_date,  podr1_line).
      end. /* if  podr1_type = "012" then do: */ 
   END. /*for each  podr1_det : */

   FOR EACH podr1_det NO-LOCK:
       find first  podr_det  where  podr_site = podr1_site AND  podr_type = podr1_type
	      AND   podr_part =   podr1_part and  podr_seq = podr1_seq and  podr_due_date = podr1_due_date  no-error.
           
	   if not available  podr_det then do: 
              create  podr_det.

              assign           podr_site = podr1_site
 	                       podr_part = podr1_part
		               podr_seq  = podr1_seq
		               podr_due_date = podr1_due_date
		               podr_type = podr1_type
		      .
	   end.
             podr_qty_ord =  podr_qty_ord +   podr1_qty_ord .


   END. 



   FOR EACH podr_det NO-LOCK: 
    PUT "comp part require "   podr_part podr_due_date podr_schddue podr_time  podr_qty_ord podr_qty_schd SKIP.
   END. 

 /************************************************/
 /*根据已产生的供应商日程更p交     e 货计划*********************pt_mftmult***************************/
 for each po_mstr no-lock WHERE po_domain = GLOBAL_domain AND po_nbr >= po_from and po_nbr <= po_to 
     and po_vend >= supplier_from and po_vend <= supplier_to 
     and po_buyer >= buyer_from and po_buyer <= buyer_to
     and po_sched  ,
     each pod_det no-lock WHERE pod_domain = GLOBAL_domain AND  pod_nbr = po_nbr 
     and  pod_part >= part_from and  pod_part <= part_to,
     EACH ptp_det NO-LOCK WHERE ptp_domain = GLOBAL_domain  and ptp_site = pod_site and ptp_part = pod_part
      AND (ptp_run_seq2 = "011"   ) :

     IF ptp_ord_mult <= 1 THEN DO: /*truncate by day***/
           for each podr_det  where podr_part = pod_part break by podr_part BY podr_due_date :
	            podr_qty_schd = podr_qty_ord .
               DISPLAY "last  ptp_ord_mult <= 1 "  podr_part podr_due_date podr_schddue  podr_type podr_seq  podr_time  podr_qty_ord podr_qty_schd WITH FRAME x222 WIDTH 160.
           END.
       END.
     ELSE DO:     /*IF ptp_ord_mult <= 1 THEN DO: /*truncate by day***/ ******/
     IF ptp_run_seq1 BEGINS "A"  THEN DO: /*along truncate*********/
         adjqty = 0.
      for each schd_det WHERE schd_domain = GLOBAL_domain AND schd_type = 4
      and schd_nbr = pod_nbr AND schd_line = pod_line  and schd_rlse_id  = pod_curr_rlse_id[1] AND schd_date >= effdate and schd_date <= effdate1  
      break by schd_type by schd_nbr BY schd_line by schd_rlse_id  by schd_date:
      
          if first-of(schd_line) and  first-of(schd_date) then do:
            sumqty = 0.
            part_first_due = yes.
          end.
        
          if part_first_due then sumqty = sumqty + schd_discr_qty.
            else next.
       
      if last-of(schd_date) and part_first_due  then do:  
         sumqty1 = 0.
         adqty =  0.
         adjqty = 0.
         part_first_due = no. 
      
    

         for each podr_det no-lock where podr_part = pod_part and podr_due_date = schd_date:
            sumqty1 = sumqty1 + podr_qty_ord.
	        if podr_seq  = 1 AND schd_date = effdate  then adqty = podr_qty_ord.
         end. /*for each podr_det*/

      IF sumqty1 > sumqty THEN    adjqty = sumqty - sumqty1.  ELSE adjqty = 0.
      LEAVE .
      END. /*if last-of(schd_date) and part_first_due  then do:  */

         end. /*  for each schd_det where schd_type =  4 and schd_rlse_id  */  

         for each podr_det  where podr_part = pod_part break by podr_part :
           if first-of(podr_part) and podr_seq = 1 THEN  DO:
                     adjqty = adjqty + podr_qty_ord. 
                     IF - adjqty > pod_ord_mult  THEN adjqty = - pod_ord_mult .
           END.
           ELSE DO:
                
             IF adjqty + podr_qty_ord  < 0  THEN do:
                 adjqty = adjqty + podr_qty_ord .
                 DELETE podr_det.
             END. 
             ELSE DO:
   /*1029*/	     podr_qty_schd =  truncate((podr_qty_ord + adjqty) / pod_ord_mult + 0.9, 0) * ptp_ord_mult.
	             adjqty =(podr_qty_ord + adjqty) -  podr_qty_schd.   
                 END.   /*else do*****/
	         END.  /*esle do:*/
           end. /*for each podr_det*/

       END. /*IF ptp_run_seq1 BEGINS "A"  THEN DO:*/
       ELSE DO: /*truncate by day***/
           for each podr_det  where podr_part = pod_part break by podr_part BY podr_due_date :
	             if first-of(podr_due_date) THEN  adjqty = 0.
  /*1029*/	  IF adjqty + podr_qty_ord  < 0  THEN do:
                 adjqty = adjqty + podr_qty_ord .
                             DELETE podr_det.
              END.  
              ELSE DO:  podr_qty_schd =  truncate((podr_qty_ord + adjqty) / ptp_ord_mult + 0.9, 0) * ptp_ord_mult.
	                    adjqty =(podr_qty_ord + adjqty) -  podr_qty_schd. 
              END.
                 IF LAST-OF(podr_due_date)   THEN DO:  podr_qty_schd = podr_qty_schd + adjqty.
  /***                  IF podr_qty_schd < 0 THEN DO: 
                         adj2 =  YES  . 
                       END.
                           ELSE adj2 = NO. ****/
                  END. /*IF LAST-OF(podr_due_date)   THEN DO: */

   /*             DISPLAY "last "  podr_part podr_due_date podr_schddue  podr_type podr_seq  podr_time  podr_qty_ord podr_qty_schd WITH FRAME x1111 WIDTH 160. */
           END.

               for each  podr_det where podr_part = pod_part break by podr_part BY podr_due_date DESCENDING  :
                   IF FIRST-OF(podr_due_date)  AND podr_qty_schd < 0  THEN DO:  adjqty = podr_qty_schd  .
                                                                                DELETE podr_det .
                   END.
                   ELSE DO:
                       podr_qty_schd = max(podr_qty_schd + adjqty, 0) .
                       adjqty = 0 .
                   END.
               END.
       END. /*else do: ... IF ptp_run_seq1 BEGINS "A"  THEN DO*/

     END. /*else do  IF ptp_ord_mult <= 1 THEN DO: /*truncate by day***/ ********/
   end. /*for each po_mstr*************************/
 /****************************************************************************************/
  /*根据已产生的供应商日程更计划*************************/
     FOR EACH podr_det :
      /*   podr_qty_schd = podr_qty_ord . */
        PUT "comp part qty after adj"  podr_part podr_due_date podr_schddue  podr_type podr_seq  podr_time  podr_qty_ord podr_qty_schd SKIP .
     END.

 /*根据已产生的供应商日程* *****/
 do transaction:
if   update_yn then do:
 /*修改供应商日程***************************/
    for each scx_ref no-lock
       where scx_ref.scx_domain = global_domain and  scx_type = 2
      and scx_shipfrom >= supplier_from and scx_shipfrom <= supplier_to
      and scx_shipto >= shipto_from and scx_shipto <= shipto_to
      and scx_part >= part_from and scx_part <= part_to
      and scx_po >= po_from and scx_po <= po_to,
      each pod_det no-lock
       where pod_det.pod_domain = global_domain and  pod_nbr = scx_order and
       pod_line = scx_line,
      each po_mstr no-lock
       where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
      and po_buyer >= buyer_from and po_buyer <= buyer_to,
        EACH ptp_det NO-LOCK WHERE ptp_domain = GLOBAL_domain AND ptp_site = pod_site AND  ptp_part = pod_part
      AND (ptp_run_seq2 = "011"  )   :
   
         change = no.
         i = 1.
         for each podr_det  NO-LOCK  WHERE  podr_site = pod_site AND  podr_part = pod_part AND
	      podr_schddue >= effdate  and podr_schddue <= effdate1 
	      use-index podr3 break BY podr_site BY  podr_part :

	     if first-of(podr_part) then do:
             for each schd_det WHERE schd_domain = GLOBAL_domain AND  schd_type =  4
                 AND schd_nbr = pod_nbr AND schd_line = pod_line and schd_rlse_id  = pod_curr_rlse_id[1]
                 and schd_date >= effdate and schd_date <= effdate1  
              break by schd_type by schd_nbr BY schd_line   by schd_rlse_id by schd_date:
                 IF FIRST-OF(schd_date)  THEN cum_qty_req = schd_cum_qty - schd_discr_qty.
                 DISPLAY  schd_nbr schd_line podr_part  schd_date   STRING( TIME / 3600 ) WITH FRAME x1z.
	      delete schd_det.
	      end. /*for each *****************/
	      for each mrp_det WHERE mrp_domain = GLOBAL_domain AND  mrp_site = pod_site AND mrp_part = pod_part /**AND  mrp_dataset BEGINS  "ss sch_mstr"  **/
	           and mrp_due_date >= effdate and mrp_due_date <= effdate1   and mrp_type BEGINS  "suppl"  USE-INDEX mrp_site_due:
 		      
              delete mrp_det.
              end.
	     end. /*if first-of(podr_part)*/
       IF  podr_qty_schd > 0  THEN DO:
	     for first schd_det  where  schd_domain = GLOBAL_domain AND 
                        schd_type = 4
                       and schd_nbr = pod_nbr
                       and schd_line = pod_line
                       and schd_rlse_id = pod_curr_rlse_id[1]
                       and schd_date = podr_schddue
                       and schd_time = podr_time
                       and schd_interval = ""
         exclusive-lock:
         end.
        change = NO.
      if not available schd_det
      then do:

         new_schd_det = yes.


         create schd_det. schd_det.schd_domain = global_domain.
         if c-application-mode <> "API" then
            assign
               schd_type = 4
               schd_nbr = pod_nbr
               schd_line = pod_line
               schd_rlse_id = pod_curr_rlse_id[1]
               schd_date = podr_schddue
               schd_time = podr_time
               schd_interval = ""
               schd_reference = "".
         else
            assign
               schd_type = 4
               schd_nbr = pod_nbr
               schd_line = pod_line
               schd_rlse_id = pod_curr_rlse_id[1]
               schd_date = podr_schddue
               schd_time = podr_time
               schd_interval = ""
               schd_reference = "".

 
         assign
            schd_fc_qual = "F".

      end.
         
        schd_discr_qty = schd_discr_qty + podr_qty_schd .
        schd_cum_qty = cum_qty_req + schd_discr_qty.
        cum_qty_req = cum_qty_req + schd_discr_qty.
	    change = yes. 
        
        podr_rlse_id = schd_rlse_id .
        podr_nbr = schd_nbr.
        podr_line = schd_line.

         {inmrp1.i}
            FIND mrp_det WHERE  mrp_det.mrp_domain = global_domain
                         AND mrp_det.mrp_dataset = "ss sch_mstr"
                         AND mrp_det.mrp_part = pod_part
                         AND  mrp_det.mrp_site = pod_site
                         AND  mrp_det.mrp_nbr  = pod_nbr
                         AND  mrp_det.mrp_line = string(pod_line)
                         AND  mrp_det.mrp_due_date = podr_schddue NO-ERROR.
    IF NOT AVAILABLE mrp_det  THEN DO:
 
      create mrp_det. mrp_det.mrp_domain = global_domain.
      assign
         mrp_det.mrp_dataset = "ss sch_mstr"
         mrp_det.mrp_part = pod_part
         mrp_det.mrp_site = pod_site
         mrp_det.mrp_nbr  = pod_nbr
         mrp_det.mrp_detail = "Supply Schdule REquire" 
          mrp_det.mrp_line = string(pod_line)
         mrp_det.mrp_type = "supply"
         mrp_det.mrp_due_date = podr_schddue
         mrp_det.mrp_rel_date = podr_schddue
         mrp_det.mrp_line2 = string(i).
         {mfmrkey.i}
         mrp_det.mrp_keyid = next_seq.
         i = i + 1.
        END.
           
       mrp_det.mrp_qty  =   mrp_det.mrp_qty + podr_qty_schd * pod_um_conv.

 

       END. /*if podr_qty_schd > 0 ****/

        end. /*for each podr_det*/
 
   

    end. /*for each po_mstr*************************/

 /*修改供应商日程***************************/

/*修改MRP_DET begin*********************************/



end.  /*if update_yn**************/
/********修改MRP_DET end *********************************/
   end.  /* do TRANSACTION */

 /**根据已产生的供应商日程更改供应商交货计划*************************************************************************************************************/
 FOR EACH podr_det  NO-LOCK WHERE podr_schddue >= effdate AND podr_schddue  <= effdate1 AND podr_qty_schd > 0  BREAK BY podr_site BY podr_part :
      FIND FIRST  mrp_det NO-LOCK WHERE mrp_domain = GLOBAL_domain AND mrp_site = podr_site AND mrp_part = podr_part 
           AND mrp_type BEGINS "suppl"  AND  mrp_due_date = podr_schddue  NO-ERROR .
      FIND first schd_det NO-LOCK WHERE schd_domain = GLOBAL_domain  
                       AND schd_type = 4
                       and schd_nbr = podr_nbr
                       and schd_line = podr_line
                       and schd_rlse_id = podr_rlse_id
                       and schd_date = podr_schddue
                       and schd_time = podr_time NO-ERROR.
      IF NOT AVAILABLE mrp_det  THEN PUT "error mrp_det "  podr_part podr_due_date podr_schddue  podr_type podr_seq  podr_time  podr_qty_ord podr_qty_schd SKIP. 
      IF NOT AVAILABLE schd_det  THEN PUT "error schd_det"  podr_part podr_due_date podr_schddue  podr_type podr_seq  podr_time  podr_qty_ord podr_qty_schd SKIP.
      IF AVAILABLE  mrp_det AND AVAILABLE schd_det   THEN PUT "ok            " podr_part podr_due_date podr_schddue  podr_type podr_seq  podr_time  podr_qty_ord podr_qty_schd SKIP. 
 END.  /*for podr_det ***/

      {mfrtrail.i}
end.

 
PROCEDURE subtract_firmqty:
   define input parameter pod_recid as recid no-undo.
   define input parameter sch_recid as recid no-undo.
   define input parameter scx_recid as recid no-undo.

   for first pod_det where recid(pod_det) = pod_recid:
   end.

   for first sch_mstr where recid(sch_mstr) = sch_recid:
   end.

   for first scx_ref where recid(scx_ref) = scx_recid:
   end.

   if pod_firm_days > 0
      and pod_type = ""
      and update_yn then do:

      if use_calendardays then
         firm_upto = sch_pcs_date + pod_firm_days .
      else do:
         /* Using working days as firm days */
         {gprun1.i ""mfhdate.p""
            "(input sch_pcs_date,
              input pod_firm_days,
              input scx_shipto,
              true,
              output firm_upto)"}
      end. /* else of if use_calendardays */
      {gprun.i ""rssupb.p"" "(input firm_upto)"}
   end.

END PROCEDURE.  /* Procedure subtract_firmqty */

PROCEDURE determine_release_ID:
   define input parameter in_pod_nbr like pod_nbr no-undo.
   define input parameter in_pod_line like pod_line no-undo.
   define output parameter cur_rel_id like sch_rlse_id no-undo.

   curr_rel_id = 0.

   l_rlse_id = string(year(asof_date), "9999") +
      string(month(asof_date), "99")  +
      string(day(asof_date), "99")    + "-".

   find last sch_mstr
      where sch_type = 4
      and   sch_nbr  = in_pod_nbr
      and   sch_line = in_pod_line
      and   sch_rlse_id begins l_rlse_id
   no-lock no-error.

   do while curr_rel_id = 0:

      if not available sch_mstr
      then do:
         l_rlse_id   = l_rlse_id + string(001,"999").
         curr_rel_id = 1.
      end. /* IF NOT available sch_mstr */
      else do:
         curr_rel_id = integer(substring(sch_rlse_id,11,3)) no-error.
         if curr_rel_id = 0
         then
            find prev sch_mstr
               where sch_type = 4
               and   sch_nbr  = in_pod_nbr
               and   sch_line = in_pod_line
               and   sch_rlse_id begins l_rlse_id
            no-lock no-error.
         else do:
            if curr_rel_id + 1 > 999
            then do:
               l_rlse_id = l_rlse_id + string(001,"999").
            end. /* IF curr_rel_id + 1 > 999 */
            else do:
               l_rlse_id = l_rlse_id +
                  string(integer(substring(sch_rlse_id,11,3)) + 1,"999").
            end. /* ELSE DO: */

         end. /* ELSE DO: */

      end. /* ELSE DO: */

   end. /* DO WHILE curr_rel_id = 0: */

END PROCEDURE.

PROCEDURE display_message_mfmsg02:
   define input parameter l_msg_nbr as integer no-undo.
   define input parameter l_msg_level as integer no-undo.
   define input parameter l_parm_1 as integer no-undo.

   {pxmsg.i &MSGNUM=l_msg_nbr &ERRORLEVEL=l_msg_level &MSGARG1=l_parm_1}

END PROCEDURE.

PROCEDURE find_active_rlse_id:

   define input-output parameter act_rlse_id like sch_rlse_id no-undo.

   define input parameter act_sch_type like sch_type  no-undo.
   define input parameter act_pod_nbr  like pod_nbr   no-undo.
   define input parameter act_pod_line like pod_line  no-undo.

   define buffer b_schmstr for sch_mstr.
   define buffer b_poddet  for pod_det.

   for first b_poddet
      fields (pod_cum_date pod_cum_qty   pod_curr_rlse_id
      pod_fab_days pod_firm_days pod_line
      pod_nbr      pod_ord_mult  pod_part
      pod_po_site  pod_raw_days  pod_rlse_nbr
      pod_sched    pod_sd_pat    pod_site
      pod_type     pod_um        pod__qad05)
      where b_poddet.pod_nbr  = act_pod_nbr
      and   b_poddet.pod_line = act_pod_line
   no-lock:

   if b_poddet.pod_curr_rlse_id[act_sch_type - 3] <> ""
   then
      act_rlse_id = b_poddet.pod_curr_rlse_id[act_sch_type - 3].
   else do:
      for first b_schmstr
         fields (sch_cr_date   sch_cr_time  sch_eff_end
         sch_eff_start sch_fab_end  sch_fab_qty
         sch_fab_strt  sch_line     sch_nbr
         sch_pcr_qty   sch_pcs_date sch_raw_end
         sch_raw_qty   sch_raw_strt sch_rlse_id
         sch_sd_pat    sch_type)
         where b_schmstr.sch_type    = act_sch_type
         and   b_schmstr.sch_nbr     = act_pod_nbr
         and   b_schmstr.sch_line    = act_pod_line
         and   b_schmstr.sch_eff_end = ?
      no-lock:

         act_rlse_id = b_schmstr.sch_rlse_id.

      end. /* FOR FIRST b_schmstr */

   end. /* ELSE DO */

end. /* FOR FIRST b_poddet */

END PROCEDURE. /* PROCEDURE find_active_rlse_id */

/* CREATED INTERNAL PROCEDURE p-schd-det TO AVOID DUPLICATE CODE */

PROCEDURE p-schd-det:

   define parameter buffer bf-sch-mstr for sch_mstr.
   define           buffer bf-schd-det for schd_det.

   for each bf-schd-det
         where bf-schd-det.schd_type    = bf-sch-mstr.sch_type
         and   bf-schd-det.schd_nbr     = bf-sch-mstr.sch_nbr
         and   bf-schd-det.schd_line    = bf-sch-mstr.sch_line
         and   bf-schd-det.schd_rlse_id = bf-sch-mstr.sch_rlse_id
      exclusive-lock:

      assign
         new_cum_qty              = new_cum_qty + bf-schd-det.schd_discr_qty
         bf-schd-det.schd_cum_qty = new_cum_qty.
   end. /* FOR EACH bf-schd-det .. */

END PROCEDURE. /* p-schd-det */

/***二分割增加***begin***************************************************************************************/
 PROCEDURE Decompose:   /* BOM*/
                 DEFINE INPUT PARAMETER  ParentItem AS CHARACTER.
                 DEFINE INPUT PARAMETER  effdatex AS DATE.
                 DEFINE INPUT PARAMETER  domain1 LIKE pt_domain.
                 DEFINE VARIABLE par_desc1 AS CHARACTER FORMAT "x(24)" INITIAL "".
                 DEFINE VARIABLE par_desc2 AS CHARACTER FORMAT "x(24)" INITIAL "".
                 DEFINE VARIABLE par_prod_line AS CHARACTER FORMAT "x(8)" INITIAL "".
                 DEFINE VARIABLE comp_part AS CHARACTER FORMAT "x(18)".
                 DEFINE VARIABLE comp_desc1 AS CHARACTER FORMAT "x(24)" INITIAL "".
                 DEFINE VARIABLE comp_desc2 AS CHARACTER FORMAT "x(24)" INITIAL "".
                 DEFINE VARIABLE comp_prod_line AS CHARACTER FORMAT "x(8)" INITIAL "".

                 DEFINE VARIABLE j AS INTEGER  INITIAL 0.
                 FIND bom_mstr WHERE bom_domain = domain1 AND bom_parent = par_part NO-LOCK NO-ERROR.
                 FIND pt_mstr  WHERE  pt_domain = domain1 AND  pt_part = par_part NO-LOCK NO-ERROR.
                
                 FIND FIRST ps_mstr WHERE  ps_domain = domain1 AND   ps_par = parentitem AND (ps_end > effdatex OR ps_end = ?)
                      AND (ps_start <= effdatex OR ps_start = ? )    NO-LOCK NO-ERROR.
                 DO WHILE AVAIL ps_mstr :
                    FIND pt_mstr WHERE  pt_domain = domain1 AND  pt_part = ps_comp NO-LOCK NO-ERROR.
                    IF AVAILABLE pt_mstr  THEN DO:

           /*mage          IF pt_desc1 <> "" THEN comp_desc1 = pt_desc1. ELSE comp_desc1 = " ".
                    IF pt_desc2 <> "" THEN comp_desc2 = pt_desc2. ELSE comp_desc2 = " ".
		         
	       if pt_vend <> ""  and pt_run_seq2 = "xxxx" then do: */

	            FIND FIRST ptp_det NO-LOCK WHERE ptp_domain = GLOBAL_domain AND ptp_part = pt_part NO-ERROR.

	        IF AVAILABLE ptp_det AND  ptp_vend <> "" AND ptp_vend >= supplier_from  AND ptp_vend <= supplier_to 
 /*mage*/           and (ptp_run_seq2 = "011" )
                   then do: 

		    qty_perx = 1.
		    
            DO   j = 1 to level :
		    qty_perx = qty_perx  *  qty_per[j].
	            end.

                    find first bm_ms where bm_par = par_part  and bm_comp = pt_part  no-error.
		    if available bm_ms then bm_qty_per = bm_qty_per + ps_qty_per * qty_perx.
		    else do:
		    create bm_ms.
		     assign bm_par = par_part
		            bm_comp = pt_part
			    bm_vend = ptp_vend
			    bm_desc = comp_desc1
                            bm_type  = ptp_run_seq2 
			    bm_qty_per = ps_qty_per * qty_perx.
                    end.

                    end.  /*pt_vend ....*/

		     if pt_phantom or ps_ps_code = "x" then do:
                     IF available ptp_det  then do:
		        if  ptp_bom_code <> ""  THEN comp_part = ptp_bom_code . ELSE comp_part = ps_comp.
                     end.
		     else do:
		        if  pt_bom_code <> ""  THEN comp_part = pt_bom_code . ELSE comp_part = ps_comp.
		     end. 
		     FIND bom_mstr WHERE bom_domain = domain1 and bom_parent = comp_part NO-LOCK no-error.
                        IF AVAILABLE bom_mstr THEN do:
                           level = level + 1.
                           psrecid[level] = RECID(ps_mstr). 
			               qty_per[level] = ps_qty_per.
                           RUN decompose( bom_parent,effdate1, domain1).
                           FIND  ps_mstr WHERE RECID(ps_mstr) = psrecid[level]   NO-LOCK NO-ERROR.
			               qty_per[level] = 1.
                           level = level - 1.
                        END.
                     end. /*if pt_phantom ********/
                    END. /*if available pt_mstr**********/
                        FIND NEXT  ps_mstr WHERE ps_domain = domain1 AND  ps_par = parentitem AND (ps_end > effdatex OR ps_end = ?)
                             AND (ps_start <= effdatex OR ps_start = ? ) NO-LOCK NO-ERROR.
                        END.  /* do while avail ps_mstr*/
       END. /*procedure decompose */

   OUTPUT CLOSE.









/***二分割增加***end***************************************************************************************/
