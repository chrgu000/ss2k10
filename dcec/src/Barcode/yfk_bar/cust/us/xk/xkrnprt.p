/* xkrnprt.p                     收货单打印子程序                           */

{mfdeclre.i}

define input parameter rnnbr as char.
define variable psnbr as char.
define variable eline as integer.
define variable pageline as integer.
define variable filetmp as char format "x(50)".
define variable vend like po_vend.
define variable shipto like po_ship.
define variable loc like pod_loc.
define variable shipvia like po_shipvia.
DEFINE VARIABLE recDept like ad_name.
DEFINE VARIABLE vendname like ad_name.
DEFINE VARIABLE needKb as logic.
DEFINE SHARED VARIABLE xPrtRn as logic label "打印收货单".
DEFINE SHARED VARIABLE xPrtKb as logic label "打印看板".

define workfile temp
    field temp_line like xkrod_line FORMAT "9999"
    field temp_part like pod_part
    field temp_vend_part like pod_part
    field temp_desc like pt_desc1    
    field temp_um like pod_um
    field temp_uc AS DECIMAL LABEL "单包装"
    field temp_qty_rcvd like pod_qty_rcvd
    FIELD temp_site LIKE pod_site
    FIELD temp_loc LIKE pod_loc
    FIELD temp_time LIKE xkprh_eff_time
    FIELD temp_kblist as CHAR FORMAT "x(120)"  
    field temp_kbsupid like knbsm_supermarket_id .


FORM 
    SKIP(2)
    xkro_nbr COLON 20               xkro_supplier COLON 50
    xkro_user COLON 20              xkro_ord_date COLON 50
    xkro_site COLON 20              xkro_loc      COLON 50
    xkro_dsite COLON 20             xkro_dloc     COLON 50
    xkro_urgent COLON 20            xkro_status   COLON 50
    skip(1)
    temp_kbsupid colon 20
    SKIP(1)
WITH FRAME bb WIDTH 80 SIDE-LABELS ATTR-SPACE .

/********** Data Source Start**************************
     temp_line   <-  prh_line or xkprh_line  
     temp_part   <-  prh_part or xkprh_part
     temp_vend_part <- vp_vend_part
     temp_desc   <-  pt_desc1  
     temp_um     <-  pt_um
     temp_uc     <-  pt_ord_mult
     temp_qty_rcvd <- prh_rcvd or xkprh_qty
************ Data Source End *************************/       

/*** Get data from xkprh_hist ***/
find first xkprh_hist where xkprh_nbr = rnnbr no-lock no-error.
if available xkprh_hist then do:       
   psnbr = xkprh_po_nbr.
   vend = xkprh_vend.
   loc = "".
   find first ad_mstr where ad_addr = vend no-lock no-error.
   if available ad_mstr then do:
      vendname = ad_name.
   end.   

   /*** Get shipto and shipvia ***/
   find first po_mstr where po_nbr = psnbr no-lock no-error.
   if available po_mstr then do:
       shipto = po_ship.
       shipvia = "".
        find first ad_mstr where ad_addr = shipto no-lock no-error.
        if available ad_mstr then do:
           recDept = ad_name.
        end.   
   end.
   else do:
      find xkro_mstr where xkro_nbr = psnbr no-lock no-error.
      if available xkro_mstr then do:
         shipto = xkro_dsite.
         vend = xkro_site.
         find first loc_mstr where loc_site = xkro_dsite and 
         loc_loc = xkro_dloc no-lock no-error.
         if available loc_mstr then recDept = loc_desc.
          
         find first loc_mstr where loc_loc = xkro_loc and 
         loc_site = xkro_site no-lock no-error.
         if available loc_mstr then do:
            vendname = loc_desc.
            find first ad_mstr where ad_addr = vend no-lock no-error.
            if available ad_mstr then do:
               vendname = ad_name.
            end.   
         end.
      end.
   end.
   /*** Create detail line ***/
   for each xkprh_hist where xkprh_nbr = rnnbr no-lock:
      find first xkrod_det where xkrod_nbr = xkprh_po_nbr 
      and xkrod_line = xkprh_line no-lock no-error.
      create temp.
      assign temp_line = IF AVAILABLE xkrod_det THEN xkrod_line ELSE xkprh_line
             temp_part = xkprh_part
             temp_qty_rcvd = xkprh_qty
             temp_site =  xkprh_dsite
             temp_loc = xkprh_dloc
             temp_time = xkprh_eff_time
             temp_uc = if available xkrod_det then xkrod_pack else 0
             temp_kblist = xkprh_kbid.                
      IF xkprh_kbid <> "" then find first knbd_det where knbd_id = INTEGER(substring ( xkprh_kbid,1,index ( xkprh_kbid,"~,") - 1)) 
      no-lock no-error.                
      if available knbd_det then do:
         find first knbl_det where knbl_keyid = knbd_knbl_keyid 
         no-lock no-error.        
         if available knbl_det then do:
            find first knb_mstr where knb_keyid = knbl_knb_keyid 
            no-lock no-error.  
            if available knb_mstr then do:
               find first knbsm_mstr where knbsm_keyid = knb_knbsm_keyid no-lock no-error. 
               if available knbsm_mstr then 
                  temp_kbsupid = knbsm_supermarket_id.
            end.
         end.
      end.
   end.  /* for each xkprh_hist */
end. /* if available xkprh_hist */
else do: /* not available xkprh_hist  */
   find first prh_hist where prh_receiver = rnnbr no-lock no-error.
   if available prh_hist then do:       
      psnbr = prh_nbr.
      vend = prh_vend.
      shipto = prh_ship.
      find first ad_mstr where ad_addr = vend no-lock no-error.
      if available ad_mstr then do:
         vendname = ad_name.
      end.
      find first ad_mstr where ad_addr = shipto no-lock no-error.
      if available ad_mstr then do:
         recDept = ad_name.
      end.
      FOR EACH prh_hist where prh_receiver = rnnbr no-lock :
         create temp.
         assign temp_line = prh_line
                temp_part = prh_part
                temp_qty_rcvd = prh_rcvd
                temp_site = prh_site
                temp_kblist = ""
                temp_uc = 0.                                                                   
      END.
   end. /*available prh_hist*/
end. /* not available xkprh_hist  */

/* Update detail line */
for each temp:
          
   if temp_uc = 0 then do:
      /* find the kanban package quantity added by xwh*/
      FIND FIRST knbi_mstr WHERE knbi_part=temp_part NO-LOCK NO-ERROR.
      FIND FIRST knbsm_mstr WHERE knbsm_site = temp_site AND knbsm_inv_loc = temp_loc NO-LOCK NO-ERROR.
      IF AVAILABLE knbi_mstr THEN 
         IF AVAILABLE knbsm_mstr THEN
         FIND FIRST knbism_det WHERE knbism_knbi_keyid = knbi_keyid AND knbism_knbsm_keyid = knbsm_keyid NO-LOCK NO-ERROR.
         IF AVAILABLE knbism_det THEN
            temp_uc =knbism_pack_qty.
   end. 

      find first pt_mstr where pt_part = temp_part no-lock no-error.
      if available pt_mstr then do:
         temp_desc = pt_desc1.
         temp_um = pt_um.
         if temp_uc = 0 then temp_uc = pt_ord_mult.
      end.

      find first vp_mstr where vp_part = temp_part no-lock no-error.
      if available vp_mstr then 
         temp_vend_part = vp_vend_part.
end. /* for each temp*/

run xPrtHeader.         
needKb = no.
run xPrtDetail.

/*if xPrtKb and can-find(first xkprh_hist where xkprh_nbr = rnnbr and xkprh_kbid <> "" no-lock )                        
then do :                
   for each temp break by temp_kbsupid by temp_line :
      if first-of ( temp_kbsupid )  then do:
         page.
         IF LINE-COUNTER = 1 THEN DISPLAY "." SKIP(18) .                                
         FIND first xkro_mstr WHERE xkro_nbr = psnbr no-lock no-error .
         if available xkro_mstr then 
            PUT UNFORMATTED "    要货单号： " xkro_nbr "    收货单号： " rnnbr "    目的超市： " temp_kbsupid SKIP .
      end.                                 

      needKb = yes.
      put temp_line at 5.
      put temp_part format "x(12)" at 10.
      put temp_vend_part format "x(15)" at 22.
      put temp_desc  format "x(24)".
      put temp_um format "x(4)"at 65.
      put temp_uc format "->>>>>9.99" .
      put temp_qty_rcvd / temp_uc format "->>>9.99" .
      put temp_qty_rcvd  skip.
      IF temp_kblist <> "" and needKb THEN put "      看板号："   temp_kblist format "x(120)" skip.
      if temp_kblist <> "" and needKb and length(temp_kblist) > 120 then do:
         put "             " substring(temp_kblist,120) format "x(120)" skip.
      end.
   end. /*for each temp*/ 
end. /*xPrtRn*/  */

PROCEDURE xPrtHeader:
   put skip(3).
   put "收货单号： " AT 70.
   PUT rnnbr at 82 skip(1).
   put "要货单号： " AT 70.
   PUT psnbr at 82 skip.
   put skip(2).
   put "供应商： " vend at 20 .      
   put "打印日期：" AT 70.
   PUT today at 82 SPACE(2) string(time,"HH:MM:SS") skip.
   put "供应商名称："vendname at 20 .
   put RecDept at 82.
   put skip(3).
END PROCEDURE.

PROCEDURE xPrtDetail:
   for each temp by temp_line:
      DISP temp_line temp_part format "x(12)" LABEL "零件号"
       /*temp_vend_part format "x(15)" at 22.*/
      temp_desc  format "x(24)" LABEL "零件名称"
      temp_um format "x(4)"
      temp_uc format "->>>>>9.99"  LABEL "单包装"
      temp_qty_rcvd / temp_uc format "->>>9.99" LABEL "包装数" 
      temp_qty_rcvd LABEL "收货数" "  " string(temp_time,"hh:mm") LABEL "收货时间" WITH FRAME d DOWN WIDTH 132 STREAM-IO. 
      IF xprtkb THEN DISP temp_kblist LABEL "看板卡" WITH FRAME d.
      /*IF temp_kblist <> "" and needKb THEN put "      看板号："   temp_kblist format "x(120)" skip.
      if temp_kblist <> "" and needKb and length(temp_kblist) > 120 then do:
         put "             " substring(temp_kblist,120) format "x(120)" skip.
      end.                                                                   */
   end.
END PROCEDURE.

