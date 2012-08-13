
/* Revision: 1.0    BY: Jeff Wang, Atos Origin          DATE: 04/21/2004  */
/* Revision: 1.1    BY: Jeff Wang, Atos Origin          DATE: 05/12/2004  */
/* Revision: 1.2    BY: Jeff Wang, Atos Origin          DATE: 06/02/2004  */
/*                  06/16/2004,    Yang Enping,  0001 */
/*                  06/17/2004,    Yang Enping,  0003 */
/*                  12/07/2004,    tracyzhang,  0005 */

/* DISPLAY TITLE */

{mfdtitle.i "AO1 "}

define variable kbid like knbd_id.
define variable kbid1 like knbd_id init 99999999.
define variable printed as logical.
define variable filetmp as char format "x(50)".
define variable eline as integer.
define workfile temp
    field temp_id like knbd_id
    field temp_user_site as char
    field temp_site_desc as char
    field temp_cnsm_site as char
    field temp_cnsm_desc as char
    field temp_vend as char
    field temp_vend_desc as char
    field temp_part as char
    field temp_part_desc as char
    field temp_vend_part as char
    field temp_unit_qty as decimal
    field temp_um as char
    field temp_card_qty as decimal
    field temp_eff_date as date
    field temp_print_date as date.

 DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
RECT-FRAME       AT ROW 1 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
SKIP(.1)  /*GUI*/
    space(1)
   kbid           colon 25 label "看板卡号"
   kbid1          label "至"
   printed        colon 25 label "包含已打印的?" 
SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* DISPLAY */
view frame a.
mainloop:
repeat with frame a:
    /*GUI*/ if global-beam-me-up then undo, leave.
       filetmp = search("kanbancard.xls").
       if filetmp = ? then do:
            message "打印模板kanbancard.xls不存在".
            quit.
       end.          
  
      update  kbid kbid1 printed
           with frame a.
      for each temp:
            delete temp.
       end.     
/********** Data Source Start***************
    temp_id          <- knbd_id
    temp_user_site   <- knbsm_site
    temp_site_desc   <- si_desc  
    temp_cnsm_site   <- knbsm_inv_loc.
    temp_cnsm_desc   <- si_desc
    temp_vend        <- knbd_ref1 or knbd_ref2
    temp_vend_desc   <- ad_name 
    temp_part        <- knbi_part
    temp_part_desc   <- pt_desc1 
    temp_vend_part   <- vp_vend_part 
    temp_unit_qty    <- knbd_pack_qty
    temp_um          <- pt_um
    temp_card_qty    <- knbism_kanban_qty / knbd_pack_qty
    temp_eff_date    <- knbd_print_date
    temp_print_date  <- today   .
************ Data Source End ***************/
/***********Print All Cards *****************/
   if printed = yes then do:
       for each knbd_det no-lock
          where knbd_id >= kbid AND knbd_id <= kbid1:
          create temp.
          assign temp_id = knbd_id
                 temp_print_date = today
/*0003*/         temp_eff_date = knbd_active_start_date .
       end.
   end.    
/***********Print New Cards *****************/
   else do:
       for each knbd_det no-lock
          where knbd_id >= kbid AND knbd_id <= kbid1 AND knbd_user2 <> "Printed":
          create temp.
          assign temp_id = knbd_id
                 temp_print_date = today
/*0003*/         temp_eff_date = knbd_active_start_date .
       end.
   end. 
/**************** Get Kanban data ***************/   
    for each temp:
        find first knbd_det where knbd_id = temp_id 
            no-lock no-error.
        if available knbd_det then do:
          assign temp_unit_qty = knbd_kanban_quantity .
/*0003*                 temp_eff_date = knbd_print_date. */
          if knbd_source_type = "1" then DO:
              temp_vend = knbd_ref1.
              find first ad_mstr where ad_addr = temp_vend no-lock no-error.
              if available ad_mstr then temp_vend_desc = ad_name.
          END.    
          else if knbd_source_type = "2" then DO:
              temp_vend = knbd_ref2.  
              FIND  FIRST knbsm_mstr WHERE knbsm_site=knbd_ref1 AND knbsm_supermarket_id=temp_vend
                  NO-LOCK NO-ERROR.
              IF AVAILABLE knbsm_mstr THEN temp_vend_desc = knbsm_desc.
          END.
                  
/*          find first ad_mstr where ad_addr = temp_vend no-lock no-error.
          if available ad_mstr then temp_vend_desc = ad_name.  */
               
          find first knbl_det where knbl_keyid = knbd_knbl_keyid 
             no-lock no-error.
          if available knbl_det then do:
            find first knb_mstr where knb_keyid = knbl_knb_keyid 
                 no-lock no-error.
            if available knb_mstr then do:
                find first knbsm_mstr where knbsm_keyid = knb_knbsm_keyid
                     no-lock no-error.
                if available knbsm_mstr then do:
                    temp_user_site = knbsm_site.
                    find first si_mstr where si_site = temp_user_site no-lock no-error.
                    if available si_mstr then 
                        temp_site_desc = si_desc.
/*0005* /*Jeff/*xiang*/*/ */           temp_cnsm_site=  knbsm_supermarket_id.
                    temp_cnsm_desc = knbsm_desc. 
/*0005* *Jeff*/
/*0005* /*Jeff*/            find first loc_mstr where loc_loc = knbsm_inv_loc no-lock no-error.
                    if available loc_mstr then do:
                        temp_cnsm_site = loc_user1.
                        find first ad_mstr where ad_addr = loc_user1 no-lock no-error.
                        if available ad_mstr then temp_cnsm_desc = ad_name.
/*Jeff*/            end. 		*0005*/
/*remarked by xiang            temp_cnsm_site = knbsm_inv_loc.
                    find first si_mstr where si_site = temp_cnsm_site no-lock no-error.
                    if available si_mstr then 
                        temp_cnsm_desc = si_desc. */
                    find first knbism_det where knbism_knbsm_keyid = knbsm_keyid
/*0001*/            and knbism_knbi_keyid = knb_knbi_keyid
                         no-lock no-error.
                    if available knbism_det then do:
                        temp_unit_qty = knbism_pack_qty.
                        temp_card_qty = knbd_kanban_quantity / knbism_pack_qty.
                    end.     
                 end.     

                find first knbs_det where knbs_keyid = knb_keyid
                     no-lock no-error.
                if available knbs_det then do: 
                    temp_cnsm_site = knbsm_inv_loc.
                END.

                find first knbi_mstr where knbi_keyid = knb_knbi_keyid
                     no-lock no-error.
                if available knbi_mstr then do:
                    temp_part = knbi_part.
                    find first pt_mstr where pt_part = knbi_part 
                         no-lock no-error.
                    if available pt_mstr then do:
                        assign temp_part_desc = pt_desc1
                               temp_um = pt_um.                        
                    end.      
                    find first vp_mstr where vp_part = temp_part
                    and vp_vend = temp_vend no-lock no-error.
                    if available vp_mstr then
		       temp_vend_part = vp_vend_part.                        
                    else do:
		       find first vp_mstr no-lock
		       where vp_part = temp_part
/*		       and vp_vend = "10000002"  */
		       no-error .

		       if available(vp_mstr) then
		          temp_vend_part = vp_vend_part .
		   end .
		      
                end.                                     
            end.
        end.
      end.      
    end. /* end of temp */   

           /* Create a New chExcel Application object */
             CREATE "Excel.Application" chExcelApplication.          
             chExcelWorkbook = chExcelApplication:Workbooks:Open(filetmp).                         
             chExcelWorksheet = chExcelWorkbook:ActiveSheet(). 

             /* Display detail */
             eline = 1.
             chExcelWorkSheet:Rows("1:10"):Copy.  
             for each temp :             
                if eline > 1 then do:
                    chExcelWorkSheet:Cells(eline , 1):Select.
                    chExcelWorkSheet:Paste.
                end.    
/*                eline = eline + 1.*/
                chExcelWorksheet:Cells(eline , 2) =  temp_cnsm_site.
                chExcelWorksheet:Cells(eline , 4) =  
                            "*" + string(temp_id, "9999999") + "*".
                chExcelWorksheet:Cells(eline + 1, 2) =  temp_cnsm_desc.
                chExcelWorksheet:Cells(eline + 2, 2) =  temp_vend.
                chExcelWorksheet:Cells(eline + 2, 4) =  
                            "*" + string(temp_id, "9999999") + "*".
                chExcelWorksheet:Cells(eline + 3, 2) =  temp_vend_desc.
                chExcelWorksheet:Cells(eline + 5, 2) =  temp_part.
                chExcelWorksheet:Cells(eline + 5, 5) =  temp_unit_qty.
                chExcelWorksheet:Cells(eline + 6, 2) =  temp_part_desc.
                chExcelWorksheet:Cells(eline + 6, 5) =  temp_um.
                chExcelWorksheet:Cells(eline + 7, 2) =  temp_vend_part.
                chExcelWorksheet:Cells(eline + 7, 5) =  temp_card_qty.
                chExcelWorksheet:Cells(eline + 8, 2) =  string(temp_eff_date,"99-99-9999").
                chExcelWorksheet:Cells(eline + 8, 5) =  string(temp_print_date,"99-99-9999").                                                                                                                                                                                                
                 eline = eline + 10.                                
             end.             
             
             /*Print */
/*xiang*/    IF eline >1  THEN DO:
                 chExcelApplication:Visible = True.
                 chExcelWorkSheet:PrintPreview().
             END.


              /* Release com - handles */
             RELEASE OBJECT chExcelWorksheet. 
             RELEASE OBJECT chExcelWorkbook.
             RELEASE OBJECT chExcelApplication.
       for each knbd_det where knbd_id >= kbid AND knbd_id <= kbid1 exclusive-lock:
           knbd_user2 = "Printed".
       end.
end.

