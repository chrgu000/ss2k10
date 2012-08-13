/*zzasnmt.p to maintain the ASN uploaded from out file transfered by the third logistic*/
/*Revision: 8.5f    Last modified: 11/11/2003   By: Kevin*/

/*display the title*/
{mfdtitle.i "f+"}

def var site like si_site.
def var asn as char format "x(12)" label "ASN#".
def var keeper like emp_addr label "保管员".
def var keeper1 like emp_addr.
def var part like pt_part.
def var part1 like pt_part.
def var msg-nbr as inte.

def var i as inte.
def temp-table xxwk
      field line as inte format ">>9" label "序"
      field part like pt_part
      field desc1 like pt_desc1
      field vend like vd_addr
      field qty_ord like tr_qty_loc label "计划量"
      field qty_asn like tr_qty_loc label "送货量"
      field qty_act like tr_qty_loc label "实收量"
      field id like abs_id
      field action as char
      field ponbr like po_nbr
      field poline like pod_line 
      field loc like loc_loc
      field ok as logic
      field effdate like abs_shp_date
      index index1 line /*vend part id*/.
def buffer abs_work for abs_mstr.

def var frametitle as char initial "ASN明细".
def var sw_reset as logic.
def var del-yn as logic.
def var ok_yn as logic.
def var reopen_yn as logic.

def var vend like vd_addr.
def var ponbr like pod_nbr.
def var poline like pod_line.
def var popart like pt_part.
def var loc like loc_loc.
def var qty_asn like tr_qty_loc label "送货量".
def var qty_act like tr_qty_loc label "实收量".
def var effdate like abs_shp_date.
      
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22
 asn colon 22 skip(1)
 keeper colon 22       keeper1 colon 45 label {t001.i}
 part colon 22         part1 colon 45 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

form
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
effdate colon 16 
vend colon 16 
popart colon 16  loc colon 40
ponbr colon 16  
poline colon 16
 SKIP(.4)  /*GUI*/
with frame b attr-space overlay side-labels
		  centered row 15 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


form
 SKIP(.1)  /*GUI*/
xxwk.line 
xxwk.part 
xxwk.desc1 
xxwk.vend 
xxwk.qty_ord format "->>>>>9"
xxwk.qty_asn format "->>>>>9"
xxwk.qty_act format "->>>>>9"
   skip(.1) 
with /*down*/ frame c width 90 /*overlay*/ title color normal frametitle THREE-D /*GUI*/.
   
Mainloop:
repeat:
      
      if keeper1 = hi_char then keeper1 = "".
      if part1 = hi_char then part1 = "".
      
      update site asn keeper keeper1 part part1 with frame a.

      if keeper1 = "" then keeper1 = hi_char.
      if part1 = "" then part1 = hi_char.
      
       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          {mfmsg.i msg-nbr 3}
          undo, retry.
       end.
            
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.

      if asn = "" then do:
           message "ASN号不允许为空,请重新输入!" view-as alert-box error.
           next-prompt asn with frame a.
           undo,retry.
      end.
      find first abs_mstr where abs_id begins "s" + asn no-lock no-error.
      if not available abs_mstr then do:
           message "ASN不存在,请重新输入!" view-as alert-box error.
           next-prompt asn with frame a.
           undo,retry.
      end.
      if abs_shipto <> site then do:
           message "ASN地点与输入地点不一致,请重新输入!" view-as alert-box error.
           next-prompt asn with frame a.
           undo,retry.
      end.

      /*verify whether the ASN has been received*/
      find first abs_mstr where abs_id = "s" + asn and
                                substr(abs_status,2,1) = "y" no-lock no-error.
      if available abs_mstr then do:
          message "此ASN已经收货,请重新输入" view-as alert-box error.
          next-prompt asn with frame a.
          undo,retry.
      end.               
      
      for each xxwk:
          delete xxwk.
      end.
      
      i = 0.         
      for each abs_mstr where abs_mstr.abs_type = "r" 
                          and abs_mstr.abs_id = "S" + asn 
                          and abs_mstr.abs_shipto = site 
                          and substr(abs_status,2,1) <> "y" no-lock,
          each abs_work where abs_work.abs_par_id = abs_mstr.abs_id
                          and abs_work.abs_shipfrom = abs_mstr.abs_shipfrom 
                          and (abs_work.abs_item >= part and abs_work.abs_item <= part1) no-lock,
        each in_mstr where in_site = site and in_part = abs_work.abs_item 
                        and (in__qadc01 >= keeper and in__qadc01 <= keeper1) no-lock
        break by in__qadc01 by in_part by abs_mstr.abs_shipfrom:
          
          /*
          find in_mstr where in_site = site and in_part = abs_work.abs_item no-lock no-error.
          if not available in_mstr or (in__qadc01 < keeper or in__qadc01 > keeper1) then next.*/
            
          find first xxwk where xxwk.vend = abs_work.abs_shipfrom 
                             and xxwk.id = abs_work.abs_id no-error.
          if not available xxwk then do:
               i = i + 1.
               create xxwk.
               assign xxwk.line = i
                      xxwk.part = abs_work.abs_item
                      xxwk.vend = abs_work.abs_shipfrom
                      xxwk.qty_asn = abs_work.abs__dec01
                      xxwk.qty_act = abs_work.abs_qty
                      xxwk.id = abs_work.abs_id
                      xxwk.action = "update".
               
               if abs_work.abs__chr01 = "y" then assign xxwk.ok = yes.
               
               find pt_mstr where pt_part = xxwk.part no-lock no-error.
               if available pt_mstr then assign xxwk.desc1 = pt_desc1.
          
              find pod_det where pod_nbr = abs_work.abs_order and string(pod_line) = abs_work.abs_line
             no-lock no-error.
             if available pod_det then do:
                   find po_mstr where po_nbr = pod_nbr no-lock no-error.
                   if available po_mstr then do:
                         if not po_sched then assign xxwk.qty_ord = pod_qty_ord.
                         else do:
                            for each schd_det where schd_type = 4 and
                                          schd_nbr = pod_nbr and
                                          schd_line = pod_line and
                                          schd_rlse_id = pod_curr_rlse_id[1] and
                                          schd_date = abs_mstr.abs_shp_date
                                          no-lock:
                               assign xxwk.qty_ord = xxwk.qty_ord + schd_discr_qty.                  
                        end. /*for each schd_det*/
                                          
                         end. /*if po_sched = yes*/
                   end.
             end.             
          end.                                       
                          
                                    
      end. /*for each abs_mstr*/

/*      
      for each xxwk no-lock:
           disp xxwk.line format ">>9" xxwk.part xxwk.desc1 
                xxwk.vend format "x(8)" xxwk.qty_ord format ">>>>9" xxwk.qty_asn format ">>>>9" 
                xxwk.qty_act format ">>>>9".
      end.
*/

   sw_reset = yes.
   mainloop1:   
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.                  /*eyes*/

/*F0PV*/    if not batchrun then do:

               /* {1} = File-name (eg pt_mstr)                    */
               /* {2} = Index to use (eg pt_part)                 */
               /* {3} = Field to select records by (eg pt_part)   */
               /* {4} = Field(s) to display from primary file     */
               /* {5} = Field to highlight (eg pt_part)           */
               /* {6} = Frame name                                */
               /* {7} = Selection Criterion                       */
               /* {8} = Message number for the status line        */
/*G1DT*/       /* {9} = Exclusive lock needed (Y/N)            */

               {zzmpscrad4.i
                  xxwk
                  index1              
                  xxwk.part
                  "xxwk.line xxwk.part xxwk.desc1 xxwk.vend xxwk.qty_ord xxwk.qty_asn xxwk.qty_act"
                  xxwk.part
                  c
                  "xxwk.action <> ""delete"""
                  8808
                  yes
               }

/*F0PV*/     end.    /* if not batchrun then do */
             
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               
               
               for each xxwk where xxwk.action <> "delete" no-lock:
                   disp xxwk.line xxwk.part xxwk.desc1 xxwk.vend xxwk.qty_ord format ">>>>>9"
                    xxwk.qty_asn format "->>>>>9" xxwk.qty_act format "->>>>>9"
                   with width 90 stream-io.
               end.
               
               ok_yn = no.
               {mfgmsg10.i 12 1 ok_yn}
            
               if not ok_yn then undo mainloop1,leave.
               else if ok_yn then leave.
               if ok_yn = ? then do:
                   sw_reset = yes.
                   undo mainloop1,retry.
               end.
            
           end. /*if keyfunction*/
             
            
               if recno = ?
               and keyfunction(lastkey) <> "insert-mode"
               and keyfunction(lastkey) <> "go"
               and keyfunction(lastkey) <> "return"
               then leave.

               if yes /*keyfunction(lastkey) <> "end-error"*/
               then do on error undo, retry:
/*GUI*/ /*if global-beam-me-up then undo, leave.*/                 /*eyes*/


/*F0PV            repeat*/ do
/*GA32*/          transaction:
/*/*GUI*/ if global-beam-me-up then undo, leave.*/               /*eyes*/

/* 
/*GA32*/             if false then do:                        
/*GA32*/                update tr.line validate (true,"") with frame c.
/*GA32*/             end.
*/

/*GA32*/             if recno = ? then do:
/*GA32*/                create xxwk.
                        
/*GA32*/                prompt-for xxwk.line with frame c.
/*GA32*/                delete xxwk.
/*GA32*/                find first xxwk where xxwk.line = input xxwk.line no-lock no-error.
/*GA32*/                if available xxwk then do:
/*GA32*/                   recno = recid(xxwk).
/*GA32*/                end.
/*GA32*/                else do:                           
                          /* 
                           prompt-for xxwk.part with frame c.                   /*eyes*/
                           find pt_mstr where pt_part = input xxwk.part no-lock no-error.        /*eyes*/
                           if not available pt_mstr then do:
                                {mfmsg.i 16 3}
                                undo,retry.
                           end.                           

/*GA32*/                   create xxwk.
/*GA32*/                   assign xxwk.line = input xxwk.line.
                           assign xxwk.part = input xxwk.part.                   /*eyes*/
                           assign xxwk.desc1 = pt_desc1.
                           assign xxwk.action = "create".
                           
                           disp xxwk.line xxwk.part xxwk.desc1 with frame c.
                           
                           recno = recid(xxwk).
                          */
                      
                      setnew:
                      Do on error undo,retry:
                           set effdate vend popart loc ponbr poline with frame b.                            
                           
                           find vd_mstr where vd_addr = vend no-lock no-error.
                           if not available vd_mstr then do:
                              {mfmsg.i 2 3}
                              next-prompt vend with frame b.
                              undo,retry setnew.
                           end.
                           
                           find pt_mstr where pt_part = popart no-lock no-error.
                       if not available pt_mstr then do:
                         {mfmsg.i 16 3}
                         next-prompt popart with frame b.
                         undo,retry setnew.
                       end.
                       
                       find in_mstr where in_site = site and in_part = popart no-lock no-error.
                       if not available in_mstr then do:
                             message "该零件未维护对应的保管员信息" view-as alert-box error.
                             undo,retry setnew.
                       end.
                       else do:
                           if in__qadc01 < keeper or in__qadc01 > keeper1 then do:
                                     message "该零件的保管员为" + in__qadc01 + ",不属于选择的范围" view-as alert-box error.
                                     undo,retry setnew.
                               end.
                       end.
                                                
                           find first pod_det where pod_nbr = ponbr and pod_line = poline no-lock no-error.
                           if not available pod_det then do:
                             {mfmsg.i 343 3}
                             next-prompt ponbr with frame b.
                             undo,retry setnew.
                           end.                           
                                                
                           if pod_part <> popart then do:
                              message "零件号与采购单中零件号不一致" view-as alert-box error.
                              next-prompt popart with frame b.
                              undo,retry setnew.
                           end.

                           if pod_site <> site then do:
                                message "采购单的地点与输入地点不一致" view-as alert-box error.
                                next-prompt ponbr with frame b.
                                undo,retry setnew.
                           end.
                           
                           find first abs_mstr where abs_mstr.abs_par_id = "S" + asn and
                                                 abs_mstr.abs_shipfrom = vend and
                                                 abs_mstr.abs_order = ponbr and
                                                 abs_mstr.abs_line = string(poline) and
                                                 abs_mstr.abs_item = popart no-lock no-error.
                       if available abs_mstr then do:
                            message "系统中已经存在此ASN明细" view-as alert-box error.
                            undo,retry setnew.
                       end.
                       
                       find loc_mstr where loc_site = site and loc_loc = loc no-lock no-error.
                       if not available loc_mstr then do:
                            {mfmsg.i 229 3}
                            next-prompt loc with frame b.
                            undo,retry setnew.
                       end.                          
                           
/*GA32*/                   create xxwk.
                           assign xxwk.effdate = effdate
/*GA32*/                          xxwk.line = input xxwk.line
                                   xxwk.part = popart                   /*eyes*/
                                   xxwk.desc1 = pt_desc1
                                  xxwk.action = "create"
                                   xxwk.vend = vend
                                   xxwk.ponbr = ponbr
                                   xxwk.poline = poline
                                   xxwk.loc = loc.
                           
                       clear frame b no-pause.
                           
                           disp xxwk.line xxwk.part xxwk.desc1 xxwk.vend with frame c.
                           
                           recno = recid(xxwk).
                      end. /*do...*/     
/*GA32*/                end.
/*GA32*/             end.
                    
                     
/*F0PV*/             find xxwk exclusive-lock where recid(xxwk) = recno.
                     if xxwk.action = "delete" then do:
                       /* 
                        reopen_yn = no.
                        message "第" + string(xxwk.line) + "行已经被删除,是否重新维护" 
                                view-as alert-box error buttons yes-no update reopen_yn.                        
                        if not reopen_yn then undo,retry.
                        else assign xxwk.action = update. 
                       */
                        message "第" + string(xxwk.line) + "行已经被删除" view-as alert-box error.
                        undo,retry.                         
                     end.
                  
/*GA32*/             display xxwk.line xxwk.part xxwk.desc1 xxwk.vend xxwk.qty_ord xxwk.qty_asn xxwk.qty_act with frame c.
                     
                     
/*GA32*/             set xxwk.qty_asn when xxwk.action = "create" xxwk.qty_act with frame c editing:
                        ststatus = stline[2].
                        status input ststatus.
                        readkey.
                        /* DELETE */
                        del-yn = no.
                        if lastkey = keycode("F5")
                        or lastkey = keycode("CTRL-D")
                        then do:
                           del-yn = yes.
                           {mfmsg01.i 11 1 del-yn}
                           if del-yn then do:
                              /*delete tr.*/
                              leave.                              
                           end.
                        end.
                        else do:
                           apply lastkey.
                        end.                
                        
                     end. /* editing */
                     
                     if xxwk.qty_asn = 0 then do:
                                 message "错误: 送货数量不能为“0”!" view-as alert-box error.
                                 next-prompt xxwk.qty_asn with frame c.
                                 undo,retry.
                     end.
                     if xxwk.qty_act = 0 then do:
                                 message "错误: 实收数量不能为“0”!" view-as alert-box error.
                                 next-prompt xxwk.qty_act with frame c.
                                 undo,retry.
                     end.
                                          
                     if not del-yn then do:                                                                     
                        next mainloop1.
                     end.  
                     else do:                       
                        /*delete xxwk.*/
                     assign xxwk.action = "delete".                        
                        clear frame c.
                        next mainloop1.
                     end.
               end. /*do transaction*/               

            end. /*if keyfunction(lastkey)*/
          end. /*mailloop1,repeat*/            
          if not ok_yn then undo,retry.        /*Kevin*/   
      
          /*update ABS_MSTR records for ASN*/ 
          for each xxwk no-lock:
                if xxwk.action = "delete" then do:
                       if xxwk.id = "" then next.
                       else do:
                             find abs_mstr where abs_mstr.abs_id = xxwk.id and abs_mstr.abs_shipfrom = xxwk.vend
                             exclusive-lock no-error.
                             if available abs_mstr then do:
                             delete abs_mstr.
                             end.
                       end.  
                end. /*if xxwk.action = "delete"*/
                if xxwk.action = "update" then do:
                       find abs_mstr where abs_mstr.abs_id = xxwk.id and abs_mstr.abs_shipfrom = xxwk.vend
                       exclusive-lock no-error.                       
                       if available abs_mstr then do:
                           assign abs_qty = xxwk.qty_act
                                  abs__dec01 = xxwk.qty_asn
                                  abs__chr01 = "Y".
                       end.
                end. /*if xxwk.action = "update"*/
                if xxwk.action = "create" then do:
                       /*create master shipper record*/
                       find abs_mstr where abs_mstr.abs_id = "s" + asn and abs_mstr.abs_shipfrom = xxwk.vend no-error.
                       if not available abs_mstr then do:
                             create abs_mstr.
                             assign abs_shipfrom = xxwk.vend
                                    abs_shipto = site
                                    abs_id = "s" + asn
                                    abs_qty = 1
                                    /*abs_shp_date = effdate*/
                                    abs_type = "r"
                                    abs_dataset = "pod_det".
                             
                             if xxwk.effdate <> ? then assign abs_shp_date = xxwk.effdate.
                         else assign abs_shp_date = today.       
                       end. /*if not available abs_mstr, for create master record*/       
                      
                       
                      /*create detail shipper record*/
                      find first abs_work where abs_work.abs_par_id = "S" + asn and
                                                abs_work.abs_shipfrom = xxwk.vend and
                                                abs_work.abs_order = xxwk.ponbr and
                                                abs_work.abs_line = string(xxwk.poline) and
                                                abs_work.abs_item = xxwk.part no-error.                              
                      if not available abs_work then do:
                      
		           create abs_work.

		           assign
		               abs_work.abs_shipfrom = abs_mstr.abs_shipfrom
		               abs_work.abs_id = "i" + abs_mstr.abs_id +
		                        string(pod_nbr,"x(8)") + string(pod_line,"9999") + string(1,"9999")    /*kevin*/
		               abs_work.abs_par_id = abs_mstr.abs_id
		               abs_work.abs_item = xxwk.part
		               abs_work.abs_site = site
		               abs_work.abs_loc = xxwk.loc
		               abs_work.abs_lotser = ""
		               abs_work.abs_ref = ""
		               abs_work.abs_qty = xxwk.qty_act
		               abs_work.abs_dataset = "pod_det"
		               abs_work.abs_order = xxwk.ponbr
		               abs_work.abs_line = string(xxwk.poline)
		               abs_work.abs_type = "r"		              
		               abs_work.abs__dec01 = xxwk.qty_asn
		               abs_work.abs__chr01 = "Y"
		               abs_work.abs__qad03 = "1".                 /*um conv rate*/
		                                            
		           find pt_mstr where pt_part = xxwk.part no-lock no-error.
		           if available pt_mstr then do:
		                assign abs_work.abs__qad02 = pt_um.
		           end.
		           else assign abs_work.abs__qad02 = "EA".
		               
                      end. /*if not available abs_mstr, for create detail record*/
                                                
                end. /*if xxwk.action = "create"*/       
          end. /*for each xxwk*/
          
end. /*repeat*/
