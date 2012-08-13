/*zzicmlttr.p for inventory transfer by multiple lines，By Kevin,2003/11*/

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def var site_from like si_site.
def var site_to like si_site.
def var loc_from like loc_loc.
def var loc_to like loc_loc.
def var part like pt_part.
def var part1 like pt_part.
def var lot like ld_lot.
def var lot1 like ld_lot.
def var ref like ld_ref.
def var ref1 like ld_ref.

def var i as inte.
def var msg-nbr as inte.
define variable sw_reset like mfc_logical.
def temp-table tr
     field line as inte format ">>9"
     field part like pt_part
     field um like pt_um
     field qty_tr like tr_qty_loc
/*     field loc_from like tr_loc column-label "发出库位"*/
     field lot_from like ld_lot column-label "批/序号"          /*kevin for lot/ref*/
     field ref_from like ld_ref column-label "参考号"           /*kevin for lot/ref*/
/*     field loc_to like tr_loc column-label "接收库位"*/
     index trindex line.
def var del-yn as logic.
def var ok_yn as logic.
def var frametitle as char init "Transfer Detail MAINTENACE".
def var trtype as char.
def var bmrecno as recid.

form
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
    site_from colon 22 label "调出地点"    site_to   colon 44 label "调入地点"
    loc_from colon 22 label "调出库位"        loc_to colon 44 label "调入库位" skip(1)
    part colon 22                   part1 colon 44 label {t001.i}
    lot colon 22                    lot1 colon 44 label {t001.i}
    ref colon 22                    ref1 colon 44 label {t001.i}     
    SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

view frame a.
form
 SKIP(.1)  /*GUI*/
   tr.line format ">>>9" label "Line"
   tr.part
   tr.um
   tr.lot_from
   tr.ref_from
   tr.qty_tr label "数量"
   skip(.1) 
   with /*down*/ frame c width 90 /*overlay*/ title color normal frametitle THREE-D /*GUI*/.         

repeat:
   
   update site_from loc_from with frame a.   
   find si_mstr no-lock where si_site = site_from no-error.
      if not available si_mstr or
         (si_db <> global_db) then do:
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
  
   find loc_mstr where loc_site = site_from and loc_loc = loc_from no-lock no-error.
   if not available loc_mstr then do:
      {mfmsg.i 229 3}
      undo,retry.
   end.
   
   update site_to loc_to with frame a.   
   find si_mstr no-lock where si_site = site_to no-error.
      if not available si_mstr or
         (si_db <> global_db) then do:
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
   
   find loc_mstr where loc_site = site_to and loc_loc = loc_to no-lock no-error.
   if not available loc_mstr then do:
      {mfmsg.i 229 3}
      next-prompt site_to with frame a.
      undo,retry.
   end.
   
   if part1 = hi_char then part1 = "".
   if lot1 = hi_char then lot1 = "".
   if ref1 = hi_char then ref1 = "".
   
   update part part1 lot lot1 ref ref1 with frame a.
   
   if part1 = "" then part1 = hi_char.
   if lot1 = "" then lot1 = hi_char.
   if ref1 = "" then ref1 = hi_char.
   
   /*create the temp-table tr*/
   for each tr:
       delete tr.
   end.
   
   i = 0.
   for each ld_det where ld_site = site_from
                    and  ld_loc = loc_from
                 and (ld_part >= part and ld_part <= part1)
                 and (ld_lot >= lot and ld_lot <= lot1)
                 and (ld_ref >= ref and ld_ref <= ref1)
                 and ld_qty_oh > 0
          no-lock by ld_part by ld_lot by ld_ref:
         
         i = i + 1.
         find first tr where tr.part = ld_part
                          and tr.lot_from = ld_lot
                          and tr.ref_from = ld_ref no-error.
         if not available tr then do:
               create tr.
               assign tr.line = i
                      tr.part = ld_part
                      tr.lot_from = ld_lot
                      tr.ref_from = ld_ref
                      tr.qty_tr = ld_qty_oh.
               
               find pt_mstr where pt_part = tr.part no-lock no-error.
               if available pt_mstr then tr.um = pt_um.       
         end. /*if not available tr*/
          
          
   end. /*for each ld_det*/
   
      
   sw_reset = yes.   
   mainloop1:   
            repeat:
/*/*GUI*/ if global-beam-me-up then undo, leave.*/                  /*eyes*/

/*FIND LAST BOM USE-INDEX BOMINDEX. ASSIGN BOM.OPTYPE = "DEL".*/
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
                  tr
                  trindex              
                  tr.line
                  "tr.line tr.part um tr.lot_from tr.ref_from tr.qty_tr"
                  tr.line
                  c
                  yes
                  8808
                  yes
               }

/*F0PV*/     end.    /* if not batchrun then do */
             
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               
               for each tr no-lock:
                   disp tr.
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
/*GA32*/                create tr.
                        
/*GA32*/                prompt-for tr.line with frame c.
/*GA32*/                delete tr.
/*GA32*/                find first tr where tr.line = input tr.line no-lock no-error.
/*GA32*/                if available tr then do:
/*GA32*/                   recno = recid(tr).
/*GA32*/                end.
/*GA32*/                else do:                           
                           prompt-for tr.part with frame c.                   /*eyes*/
                           find pt_mstr where pt_part = input tr.part no-lock no-error.        /*eyes*/
                           if not available pt_mstr then do:
                                {mfmsg.i 16 3}
                                undo,retry.
                           end.                           

/*GA32*/                   create tr.
/*GA32*/                   assign tr.line = input tr.line.
                           assign tr.part = input tr.part.                   /*eyes*/
                           assign tr.um = pt_um.
                           
                           find first ld_det where ld_site = site_from and ld_loc = loc_from
                           and ld_lot = tr.lot_from and ld_ref = tr.ref_from                  /*kevin*/
                           and ld_part = tr.part no-lock no-error.
                           if available ld_det then assign tr.qty_tr = ld_qty_oh.
                           
                           disp tr.line tr.part tr.um with frame c.
                           
                           /*prompt-for tr.qty_tr with frame c.
                           if input tr.qty_tr = 0 then do:
                                 message "错误: 转移数量不能为“0”!".
                                 undo,retry.
                           end.*/
                           
                           /*assign tr.qty_tr = input tr.qty_tr.*/
                           recno = recid(tr).
/*GA32*/                end.
/*GA32*/             end.

/*F0PV*/             find tr exclusive-lock where recid(tr) = recno.
/*GA32*/             display tr.line tr.part tr.um tr.lot_from tr.ref_from tr.qty_tr with frame c.
                     
                     
/*GA32*/             set tr.qty_tr with frame c editing:
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
                     
                     if tr.qty_tr = 0 then do:
                                 message "错误: 转移数量不能为“0”!".
                                 undo,retry.
                     end.

                     find first ld_det where ld_site = site_from and ld_loc = loc_from and ld_part = tr.part
                     and ld_lot = tr.lot_from and ld_ref = tr.ref_from and ld_qty_oh >= tr.qty_tr no-lock no-error.
                     if not available ld_det then do:
                           message "错误: 准备转移的库存不足,请重新输入!".
                           undo,retry.
                     end.
                     
                     if not del-yn then do:                                                                     
                        next mainloop1.
                     end.  
                     else do:                       
                        delete tr.                        
                        clear frame c.
                        next mainloop1.
                     end.
               end. /*do transaction*/               

            end. /*if keyfunction(lastkey)*/
          end. /*mailloop1,repeat*/            
          if not ok_yn then undo,retry.        /*Kevin*/   
end. /*repeat*/
