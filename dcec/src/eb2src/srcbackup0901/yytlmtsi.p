/*YYtlmtsi.p        --      Transfer Order maintenance                           */
/*Revision: Eb2 + sp7       Last modified: 07/29/2005             By: Judy Liu   */
 
/*display the title*/
{mfdtitle.i "b+"}

DEFINE VARIABLE site LIKE si_site.
DEFINE VARIABLE site1 LIKE si_site .

DEFINE VARIABLE nbr LIKE xxtl_nbr.
DEFINE VARIABLE keeper LIKE emp_addr label "保管员".
DEFINE VARIABLE keeper1 LIKE emp_addr.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE part1 LIKE pt_part.
DEFINE VARIABLE msg-nbr as inte.
DEFINE VARIABLE effdate LIKE xxtl_effdate.
DEFINE VARIABLE qty_tot LIKE xxtl_qty_pick.

DEFINE VARIABLE i as inte.
DEFINE temp-table xxwk
      FIELD line as inte format ">>9" label "序"
      FIELD nbr LIKE xxtl_nbr
      FIELD part LIKE pt_part
      FIELD desc1 LIKE pt_desc1
      FIELD qty_req LIKE xxtl_qty_req
      FIELD qty_pick LIKE xxtl_qty_pick
      FIELD loc_fr LIKE loc_loc label "移出库位"
      FIELD loc_to LIKE loc_loc label "车间库位"
      FIELD action as char
/*judy 05/07/29*/  FIELD stat AS CHAR FORMAT "x(1)"
 /*judy 05/07/29*/ FIELD rmks AS CHAR FORMAT "x(40)"
/*      FIELD ok as logic*/
      index index1 line.

DEFINE VARIABLE frametitle as char initial "移仓单明细维护".
DEFINE VARIABLE sw_reset as logic.
DEFINE VARIABLE del-yn as logic.
DEFINE VARIABLE ok_yn as logic.
DEFINE VARIABLE reopen_yn as logic.
 /*judy 05/07/29*/ DEFINE VARIABLE xxline AS INTE.
      
FORM /*GUI*/ 
 SKIP (.2)          
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.2)  /*GUI*/
 nbr colon 22
 site colon 22
 site1 COLON 22 skip(1)
 keeper colon 22       keeper1 colon 45 label {t001.i}
 part colon 22         part1 colon 45 label {t001.i}
 SKIP(.5)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
setframelabels(frame a:handle) .
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

FORM 
 SKIP(.1)  /*GUI*/
xxwk.line 
xxwk.part 
xxwk.desc1 
xxwk.loc_fr
xxwk.loc_to  COLUMN-LABEL "车间库位"
xxwk.qty_req
xxwk.qty_pick
/*judy 05/07/29*/  xxwk.stat
   skip(.1) 
 with /*down*/ frame c width 90 /*overlay*/ title color normal frametitle THREE-D /*GUI*/. 

setframelabels(frame c:handle)  .

Mainloop:
repeat:
      
      if keeper1 = hi_char then keeper1 = "".
      if part1 = hi_char then part1 = "".
      
      update  nbr keeper keeper1 part part1 with frame a editing:
            if frame-FIELD = "nbr" then do:
                {mfnp.i xxtl_det nbr xxtl_nbr  nbr xxtl_nbr xxtl_index}
                if recno <> ? then do:
                    disp xxtl_nbr @ nbr xxtl_site @ site 
                         xxtl_site1 @ site1 with frame a.    
                end.
            end.
            else do:
                readkey.
              apply lastkey.
            end.
     end.      

      if keeper1 = "" then keeper1 = hi_char.
      if part1 = "" then part1 = hi_char.
      
      if nbr = "" then do:
           message "移仓单号不允许为空,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.
      find first xxtl_det where xxtl_nbr = nbr no-lock no-error.
       if not available xxtl_det then do:
            message "移仓单不存在,请重新输入!" view-as alert-box error.
            next-prompt nbr with frame a.
            undo,retry.
       end.
       site = xxtl_site .
       site1 = xxtl_site1.
       DISP site site1 WITH FRAME a.
       
       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
           IF  not available si_mstr then msg-nbr = 708.
           else msg-nbr = 5421.
           {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3}    
           undo, retry.
       end.
       
       {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if return_int = 0 then do:
                      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
                  undo,retry.
             end.  

       find si_mstr no-lock where si_site = site1 no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3}  
          undo, retry.
       end.
            
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}    /* USER DOES NOT HAVE */
/*J034*/                                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.



     
      effdate = xxtl_effdate.
      
      
      find first xxtl_det where xxtl_site = site and
                                xxtl_nbr = nbr and
                                xxtl_qty_tr >  0
 /*judy 05/07/29   xxtl_status <>  "" */ no-lock no-error.
      IF  available xxtl_det then do:
           message "该移仓单已经确认并移库,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.
 
      for each xxwk:
          delete xxwk.
      end.
 
      i = 0.         
      for each xxtl_det where xxtl_nbr = nbr AND 
                         (xxtl_part >= part and xxtl_part <= part1) 
                         AND xxtl_status = "" no-lock,
          each in_mstr where in_site = site and in_part = xxtl_part 
                            and (in__qadc01 >= keeper and in__qadc01 <= keeper1) 
                            no-lock break /*by in__qadc01*/ by xxtl_part:             /*kevin,according to chenlu*/
         
          find first xxwk where xxwk.nbr = xxtl_nbr 
                            and xxwk.part = xxtl_part
                            and xxwk.loc_fr = xxtl_loc_fr
                            and xxwk.loc_to = xxtl_loc_to no-error.
          if not available xxwk then do:
          
               i = i + 1.
               create xxwk.
               assign xxwk.line = i
                      xxwk.nbr = xxtl_nbr
                      xxwk.part = xxtl_part
                      xxwk.loc_fr = xxtl_loc_fr
                      xxwk.loc_to = xxtl_loc_to
                      xxwk.qty_req = xxtl_qty_req
                      xxwk.qty_pick = xxtl_qty_pick
/*judy 05/07/29*/ xxwk.stat = xxtl_status                     
                      xxwk.action = "update".
             
/*judy 05/07/29*/     GLOBAL_part = xxtl_part.
/*judy 05/07/29*/    GLOBAL_site =   site .
/*judy 05/07/29*/    GLOBAL_loc =  xxtl_loc_fr.

             /*kevin,12/23/03  
               if xxtl_qty_pick > 0 then assign xxwk.qty_pick = xxtl_qty_pick.
               else do:
                     find ld_det where ld_site = xxtl_site and ld_part = xxtl_part 
                                     and ld_loc = xxtl_loc_fr no-lock no-error.
                     if available ld_det then do:
                          if ld_qty_oh >= xxtl_qty_req then
                                 assign xxwk.qty_pick = xxtl_qty_req.
                          else assign xxwk.qty_pick = ld_qty_oh.
                     end.            
               end.      
             */                 
                              
               find pt_mstr where pt_part = xxwk.part no-lock no-error.
               if available pt_mstr then assign xxwk.desc1 = pt_desc2.
          
          end.                                       
                          
                                    
      end. /*for each xxtl_det,each in_mstr*/


   sw_reset = yes.
   mainloop1:   
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.                  /*eyes*/

/*F0PV*/    if not batchrun then do:

               /* {1} = File-name (eg pt_mstr)                    */
               /* {2} = Index to use (eg pt_part)                 */
               /* {3} = FIELD to select records by (eg pt_part)   */
               /* {4} = FIELD(s) to display from primary file     */
               /* {5} = FIELD to highlight (eg pt_part)           */
               /* {6} = Frame name                                */
               /* {7} = Selection Criterion                       */
               /* {8} = Message number for the status line        */
/*G1DT*/       /* {9} = Exclusive lock needed (Y/N)            */

/*judy 05/07/29*/  /*{zzmpscrad4.i*/
/*judy 05/07/29*/  {yympscrad4.i
       xxwk
       index1              
       xxwk.part
      "xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req xxwk.qty_pick xxwk.stat"
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
               
/*judy  05/08/18*/              
              qty_tot = 0.
                for each xxwk no-lock  WHERE xxwk.stat = "" break by site by xxwk.nbr by xxwk.part by xxwk.loc_fr:
                    
                  qty_tot = qty_tot + xxwk.qty_pick.
                   
                  if last-of(xxwk.loc_fr) then do:
                       
                      if qty_tot <> 0 then do:
                            find ld_det where ld_site = site and ld_loc = xxwk.loc_fr
                                             and ld_part = xxwk.part and ld_lot = "" and ld_ref = ""
                            no-lock no-error.
                            if available ld_det then do:
                               if ld_qty_oh < qty_tot then do:       
                                   message "零件" xxwk.part + "在" + site + "," + xxwk.loc_fr
                                                  + "的待移仓总量:" + string(qty_tot) + ",大于库存量:" + string(ld_qty_oh) 
                                           view-as alert-box error.
                                   sw_reset = yes.
                                   undo mainloop1,RETRY mainloop1.       
                               end.
                            END.
                            ELSE  IF NOT AVAIL ld_det THEN DO:

                                message "零件" xxwk.part + "在" + site + "," + xxwk.loc_fr
                                               + "的待移仓总量:" + string(qty_tot) + ",大于库存量:0" 
                                        view-as alert-box error.
                                sw_reset = yes.
                                UNDO mainloop1 ,RETRY mainloop1.       
                            END.
                      end.

                      qty_tot = 0.
                  end.
              end. 
  /*judy 05/08/18*/ 

               for each xxwk where xxwk.action <> "delete" AND xxwk.qty_pick <> 0 no-lock by xxwk.part:
/*judy 05/07/29*/    /*  disp xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req xxwk.qty_pick  
/*judy 05/07/29*/                   with width 90 stream-io.*/
/*judy 05/07/29*/     disp xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req xxwk.qty_pick xxwk.stat xxwk.rmks FORMAT "x(30)"
/*judy 05/07/29*/             with width 90 FRAME o STREAM-IO DOWN. 
/*judy 05/07/29*/          setframelabels(frame o:handle)  .
               end.
               
               ok_yn = no.
               {mfgmsg10.i 12 1 ok_yn}
            
               if not ok_yn then undo mainloop1,leave.
               else if ok_yn then do:
            /*   
               find first xxwk where xxwk.qty_pick = 0 no-lock no-error.
               if available xxwk then do:
                    message "存在未维护待移仓量的零件,请重新维护!" view-as alert-box error.
                    sw_reset = yes.
                    undo mainloop1,retry.
               end.      
               
               find first xxwk where xxwk.qty_pick < xxwk.qty_req no-lock no-error.
               if available xxwk then do:
                    message "存在待移仓量小于需求量的零件,请重新维护!" view-as alert-box error.
                       sw_reset = yes.
                       undo mainloop1,retry.                       
               end.
            */
                
                /*added by kevin,01/18/2003*/  
                qty_tot = 0.
                  for each xxwk  WHERE  xxwk.stat = "" no-lock break by site by xxwk.nbr by xxwk.part by xxwk.loc_fr:
                      
                    qty_tot = qty_tot + xxwk.qty_pick.
                    if last-of(xxwk.loc_fr) then do:
                        if qty_tot <> 0 then do:
                              find ld_det where ld_site = site and ld_loc = xxwk.loc_fr
                                               and ld_part = xxwk.part and ld_lot = "" and ld_ref = ""
                              no-lock no-error.
                              if available ld_det then do:
                                 if ld_qty_oh < qty_tot then do:       
                                     message "零件" xxwk.part + "在" + site + "," + xxwk.loc_fr
                                                    + "的待移仓总量:" + string(qty_tot) + ",大于库存量:" + string(ld_qty_oh) 
                                             view-as alert-box error.
                                     sw_reset = yes.
                                     undo mainloop1,retry.       
                                 end.
                              end.  
/*judy 05/08/18*/
                              ELSE  IF NOT AVAIL ld_det THEN DO:

                                  message "零件" xxwk.part + "在" + site + "," + xxwk.loc_fr
                                                 + "的待移仓总量:" + string(qty_tot) + ",大于库存量:0" 
                                          view-as alert-box error.
                                  sw_reset = yes.
                                  UNDO mainloop1 ,RETRY mainloop1.       
                              END.
/*judy 05/08/18*/
                        end.
                        
                        qty_tot = 0.
                    end.
                end. 
                   
                                
                   leave.
               end.
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
 
/*GA32*/             if recno = ? then do:
/*GA32*/                create xxwk.
                        
/*GA32*/                prompt-for xxwk.line with frame c.
/*GA32*/                delete xxwk.
/*judy 05/07/29*/  IF INPUT xxwk.LINE = 0 THEN DO:
/*judy 05/07/29*/     xxline = i + 1.
/*judy 05/07/29*/     FIND FIRST xxwk WHERE xxwk.LINE= xxline   NO-LOCK NO-ERROR.
/*judy 05/07/29*/   DO WHILE AVAILABLE xxwk :
/*judy 05/07/29*/     xxline = xxline + 1. 
/*judy 05/07/29*/     FIND FIRST xxwk WHERE xxwk.LINE = xxline NO-LOCK NO-ERROR.
 /*judy 05/07/29*/  END.
/*judy 05/07/29*/ END.
/*judy 05/07/29*/  ELSE IF INPUT xxwk.LINE <> 0 THEN xxline = INPUT xxwk.LINE.
 /*judy 05/07/29*/  DISP xxline @ xxwk.LINE WITH FRAME c.
/*judy 05/07/29*/  /*/*GA32*/                find first xxwk where xxwk.line = input xxwk.line no-lock no-error.*/
/*judy 05/07/29*/   find first xxwk where xxwk.line =xxline no-lock no-error.
/*GA32*/                if available xxwk then do:
/*GA32*/                   recno = recid(xxwk).
/*GA32*/                end.
/*GA32*/                else do:                           
                           prompt-for xxwk.part xxwk.loc_fr xxwk.loc_to with frame c.                   /*eyes*/
                           find pt_mstr where pt_part = input xxwk.part no-lock no-error.        /*eyes*/
                           if not available pt_mstr then do:
                                {mfmsg.i 16 3}
                                undo,retry.
                           end.                           
                           
                           find loc_mstr where loc_site = site and loc_loc = input xxwk.loc_fr no-lock no-error.
                           if not available loc_mstr then do:
                               message "库位 " + site + "," + input xxwk.loc_fr + " 不存在请重新输入" view-as alert-box error.
                               undo,retry.
                           end.

                           find loc_mstr where loc_site = site and loc_loc = input xxwk.loc_to no-lock no-error.
                           if not available loc_mstr then do:
                               message "库位 " + site + "," + input xxwk.loc_to + " 不存在请重新输入" view-as alert-box error.
                               undo,retry.
                           end.
                                                      
/*GA32*/                   create xxwk.
/*judy 05/07/29*/ /*GA32                  assign xxwk.line = input xxwk.line*/ 
/*judy 05/07/29*/    assign xxwk.line = xxline 
                                  xxwk.part = input xxwk.part                   
                                  xxwk.desc1 = pt_desc2
                                  xxwk.loc_fr = input xxwk.loc_fr
                                  xxwk.loc_to = input xxwk.loc_to
                                  xxwk.action = "create".

/*judy 05/07/29*/     GLOBAL_part = INPUT xxwk.part.
/*judy 05/07/29*/    GLOBAL_site =   site .
/*judy 05/07/29*/    GLOBAL_loc =  INPUT xxwk.loc_fr.
                               
                         disp xxwk.line xxwk.part xxwk.desc1 with frame c.
                           
                           recno = recid(xxwk).
                          
                      
/*GA32*/                end.
/*GA32*/             end.
                    
                     
/*F0PV*/             find xxwk exclusive-lock where recid(xxwk) = recno.
                     if xxwk.action = "delete" then do:
                        message "第" + string(xxwk.line) + "行已经被删除" view-as alert-box error.
                        undo,retry.                         
                     end.
                  
                  /*kevin,12/23/2003
/*GA32*/             display xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req 
                             xxwk.qty_pick when xxwk.qty_pick <> 0 
                             xxwk.qty_req when xxwk.qty_pick = 0 @ xxwk.qty_pick with frame c.
                  end*/
                  
     /*judy 05/07/29*/ /*  /*GA32*/         display xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req 
                             xxwk.qty_pick with frame c.   */                  
       /*judy 05/07/29*/   /*GA32*/         display xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req 
                             xxwk.qty_pick xxwk.stat  with frame c.                          
/*judy 05/07/29*/  IF xxwk.stat = "" THEN DO:
/*judy 05/07/29*/ /*/*GA32*/             set /*xxwk.qty_req*/ xxwk.qty_pick  with frame c editing:*/
/*judy 05/07/29*/         set /*xxwk.qty_req*/ xxwk.qty_pick xxwk.stat  VALIDATE (lookup(xxwk.stat, " ,x,") > 0,"状态只能为X(取消)或空(正常)")  with frame c editing:
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
                                                  leave.                              
                                               end.
                                            end.
                                            else do:
                                               apply lastkey.
                                            end.                
                                    
                                 end. /* editing */
 /*judy 05/07/29*/ IF xxwk.qty_pick = 0 AND xxwk.qty_req = 0 AND xxwk.action = "create" THEN  xxwk.rmks = "需求量,待移仓量都为0,未生成新记录".                                 
                     /*
                     if xxwk.qty_req = 0 then do:
                                 message "错误: 需求量不能为“0”!" view-as alert-box error.
                                 next-prompt xxwk.qty_req with frame c.
                                 undo,retry.
                     end.
                     */
                     
   /*judy 05/07/29*/ /* if input xxwk.qty_pick = 0 then do:*/
   /*judy 05/07/29*/   if input xxwk.qty_pick = 0 AND xxwk.stat = "" then do:
                               /*kevin,12/23  
                                 message "错误: 待移仓量不能为“0”!" view-as alert-box error.                                 
                                 next-prompt xxwk.qty_pick with frame c.
                                 undo,retry.
                               */  
                                 
                            message "提示: 待移仓量为“0”!".      
                            hide message.
                     end.
    /*judy 05/07/29*/  /*   else do:*/
   /*judy 05/07/29*/  ELSE IF INPUT xxwk.qty_pick <> 0 AND xxwk.stat = "" THEN DO:
                                     find ld_det where ld_site = site and
                                            ld_loc = xxwk.loc_fr and
                                            ld_part = xxwk.part and
                                            ld_qty_oh >= xxwk.qty_pick no-lock no-error.
                                   /* MESSAGE xxwk.loc_fr site xxwk.part xxwk.qty_pick.
                                    PAUSE.*/
                                       if not available ld_det then do:
                                     
                                          message "移出库位无库存或库存不足!" /*view-as alert-box error*/.
                                           next-prompt xxwk.qty_pick with frame c.
                                          undo,retry.
                                      end. 
                              end. /*else do*/
  /*judy 05/07/29*/   END.     /*end of  if xxwk.stat = ""*/
  /*judy 05/07/29*/  ELSE IF xxwk.stat <> "" THEN DO:
   /*judy 05/07/29*/      MESSAGE "此行已关闭,不能进行修改".
  /*judy 05/07/29*/       UNDO, RETRY.
  /*judy 05/07/29*/  END.



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
      
          /*update transfer list records*/ 
          for each xxwk no-lock:
                if xxwk.action = "delete" then do:
                     find xxtl_det where xxtl_nbr = nbr and
                                     xxtl_part = xxwk.part and
                                     xxtl_loc_fr = xxwk.loc_fr and
                                     xxtl_loc_to = xxwk.loc_to no-error.
                  if available xxtl_det then 
                        delete xxtl_det.
                end. /*if xxwk.action = "delete"*/
                if xxwk.action = "update" then do:
                     find xxtl_det where xxtl_nbr = nbr and
                                     xxtl_part = xxwk.part and
                                     xxtl_loc_fr = xxwk.loc_fr and
                                     xxtl_loc_to = xxwk.loc_to no-error.
                     if available xxtl_det then do:
 /*judy 05/07/29*/  /*  assign xxtl_qty_req = xxwk.qty_req
 /*judy 05/07/29*/      xxtl_qty_pick = xxwk.qty_pick.*/
 /*judy 05/07/29*/    assign   xxtl_qty_pick = xxwk.qty_pick
 /*judy 05/07/29*/                 xxtl_status = xxwk.stat.
                  end.
                end. /*if xxwk.action = "update"*/
 /*judy 05/07/29*/  /*   if xxwk.action = "create" then do:*/
 /*judy 05/07/29*/   if xxwk.action = "create" AND xxwk.qty_pick <> 0  then do:
                     find xxtl_det where xxtl_nbr = nbr and
                                     xxtl_part = xxwk.part and
                                     xxtl_loc_fr = xxwk.loc_fr and
                                     xxtl_loc_to = xxwk.loc_to no-error.
                    if not available xxtl_det  then do: 
                        create xxtl_det.
                        assign xxtl_nbr = nbr
                               xxtl_site = site
 /*judy 05/07/29*/ xxtl_site1 = site1
                               xxtl_part = xxwk.part
                               xxtl_effdate = effdate
                               xxtl_loc_fr = xxwk.loc_fr
                               xxtl_loc_to = xxwk.loc_to
                               xxtl_qty_req = xxwk.qty_req
                               xxtl_qty_pick = xxwk.qty_pick
 /*judy 05/07/29*/ xxtl_status = xxwk.stat
                               xxtl_date = today.  
                  end.
                end. /*if xxwk.action = "create"*/       
          end. /*for each xxwk*/
          
end. /*repeat*/
