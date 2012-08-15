{mfdeclre.i}
def  shared temp-table xxwk
    field xxwk_part like pt_part
    field xxwk_line like ln_line
    field xxwk_site like pt_site
    field xxwk_plan as character extent 31
    field xxwk_errmsg as character format "x(40)" .
    
    
    def shared temp-table xxwk1
    field xxwk1_part like pt_part
    field xxwk1_line like ln_line
    field xxwk1_site like pt_site
    field xxwk1_plan as decimal extent 31 .
    
 
 define input parameter xxsite as character .
 define input parameter xxline as character .
 define input parameter xxpart as character .
 define input-output parameter ok_yn as logical .
 define output parameter errmsg as character format "x(40)" .
 define variable mc-error-number  like msg_nbr              no-undo.
 define variable unitcost         like pod_pur_cost         no-undo.
 define variable xxrate2 as decimal .
 define variable xxrate as decimal .
 define variable l_gl_set like  si_gl_set .
 define variable xxbomcode as character .
 define variable xxrouting as character .
 
 
 find si_mstr where si_site = xxsite no-lock no-error .
 if not available si_mstr or (si_db <> global_db) 
 then do: 
 ok_yn = no .
 errmsg = "地点不已存在" .
 end.
 else do:
     {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
if return_int = 0 
    then assign ok_yn = no
                errmsg = "该地点无权访问" .
 end.   
 find first pt_mstr where pt_part = xxpart no-lock no-error .
          if not available pt_mstr then
          do:
          ok_yn = no .
          errmsg = "零件号不存在" .
          end.
          else assign xxbomcode = pt_bom_code
                      xxrouting = pt_routing .
find ptp_det where ptp_part = xxpart and ptp_site = xxsite no-lock no-error .
if available ptp_det then 
                    assign xxbomcode = ptp_bom_code
                           xxrouting = ptp_routing .
if xxbomcode = "" then xxbomcode = xxpart .
if xxrouting = "" then xxrouting = xxpart .
 if xxbomcode <> "" then 
        do:
        find first bom_mstr where bom_parent = xxbomcode no-lock no-error .
        find first ps_mstr where ps_par = xxbomcode no-lock no-error .
        if not available bom_mstr and not available ps_mstr then
            assign  ok_yn = no 
                    errmsg = "BOM不存在--" + xxbomcode .
   
        end.
if xxrouting <> "" then 
        do:
        find first ro_det where ro_routing = xxrouting no-lock no-error .
        if not available ro_det then 
          assign  ok_yn = no 
                    errmsg = "ROUTING不存在--" + xxrouting .

        end.
  find first ln_mstr where ln_site = xxsite and ln_line = xxline no-lock no-error .
  if not available ln_mstr then
              assign  ok_yn = no 
                    errmsg = "生产线不存在" .

 find first lnd_det where lnd_site = xxsite and lnd_line = xxline 
            and lnd_part = xxpart 
            and (lnd_start <= today or lnd_start = ? )
            and (lnd_expire >= today or lnd_expire = ?  ) no-lock no-error .
            if not available lnd_det then 
            assign ok_yn = no
                    errmsg = "生产线零件对应关系不存在" .

/*judy*/
find first pt_mstr where pt_part = xxpart no-lock no-error .
IF AVAIL pt_mstr THEN DO:
    FIND FIRST isd_det WHERE trim(substring(isd_status,1,8)) = TRIM(pt_status) 
           AND isd_tr_type = "ADD-RE" NO-LOCK NO-ERROR.
    IF AVAIL isd_det THEN 
        assign ok_yn = no
               errmsg = "零件状态不允许维护生产日程单".
END.
/*judy*/
