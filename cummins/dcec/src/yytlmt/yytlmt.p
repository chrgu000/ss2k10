/*zztlmt.p to maintain the transfer list uploaded from out file created by ATPU*/
/*Revision: 8.5f    Last modified: 12/20/2003   By: Kevin*/
/*Revision: 8.5f    Last modified: 12/23/2003   By: Kevin, to allow the picked qty is zero*/
/*Revision: eb2+sp7   retrofit : 06/22/2005   By: tao fengqin  *tfq*   */
/*display the title*/
{mfdtitle.i "121112.1"}

def var site like si_site.
def var nbr like xxtl_nbr.
def var keeper like emp_addr label "保管员".
def var keeper1 like emp_addr.
def var part like pt_part.
def var part1 like pt_part.
def var msg-nbr as inte.
def var effdate like xxtl_effdate.
def var qty_tot like xxtl_qty_pick.

def var i as inte.
def temp-table xxwk
      field line as inte format ">>9" label "序"
      field nbr like xxtl_nbr
      field part like pt_part   LABEL "零件"
      field desc1 like pt_desc1 LABEL "描述"
      field qty_req like xxtl_qty_req
      field qty_pick like xxtl_qty_pick
      field loc_fr like loc_loc label "移出库位"
      field loc_to like loc_loc label "车间库位"
      field action as char
/*      field ok as logic*/
      index index1 line.

def var frametitle as char initial "移仓单明细维护".
def var sw_reset as logic.
def var del-yn as logic.
def var ok_yn as logic.
def var reopen_yn as logic.


FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22
 nbr colon 22 skip(1)
 keeper colon 22       keeper1 colon 45 label {t001.i}
 part colon 22         part1 colon 45 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
setframelabels(frame a:handle) .
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/


form
 SKIP(.1)  /*GUI*/
xxwk.line  LABEL "序"
xxwk.part
xxwk.desc1
xxwk.loc_fr
xxwk.loc_to
xxwk.qty_req
xxwk.qty_pick
   skip(.1)
with /*down*/ frame c width 90 /*overlay*/ title color normal frametitle THREE-D /*GUI*/.
 /*setframelabels(frame c:handle) .*/

Mainloop:
repeat:

      if keeper1 = hi_char then keeper1 = "".
      if part1 = hi_char then part1 = "".

      update site nbr keeper keeper1 part part1 with frame a editing:
            if frame-field = "site" then do:
                {mfnp.i si_mstr site " si_domain = global_domain and si_site " site si_site si_site}
                if recno <> ? then do:
                    disp si_site @ site with frame a.
                end.
            end.
            else do:
                readkey.
              apply lastkey.
            end.
     end.

      if keeper1 = "" then keeper1 = hi_char.
      if part1 = "" then part1 = hi_char.

       /*verify the input site*/
       find si_mstr no-lock where si_domain = global_domain and si_site = site no-error.
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

      effdate = xxtl_effdate.

      if xxtl_site <> site then do:
           message "移仓单地点与输入地点不一致,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.

      find first xxtl_det where xxtl_site = site and
                                xxtl_nbr = nbr and
                                xxtl_qty_tr > 0 no-lock no-error.
      if available xxtl_det then do:
           message "该移仓单已经确认并移仓,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.

      for each xxwk:
          delete xxwk.
      end.

      i = 0.
      for each xxtl_det where xxtl_nbr = nbr and
                              xxtl_site = site and
                         (xxtl_part >= part and xxtl_part <= part1) no-lock,
          each in_mstr where in_domain = global_domain and in_site = site and in_part = xxtl_part
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
                      xxwk.action = "update".

             /*kevin,12/23/03
               if xxtl_qty_pick > 0 then assign xxwk.qty_pick = xxtl_qty_pick.
               else do:
                     find ld_det where ld_domain = global_domain and ld_site = xxtl_site and ld_part = xxtl_part
                                     and ld_loc = xxtl_loc_fr no-lock no-error.
                     if available ld_det then do:
                          if ld_qty_oh >= xxtl_qty_req then
                                 assign xxwk.qty_pick = xxtl_qty_req.
                          else assign xxwk.qty_pick = ld_qty_oh.
                     end.
               end.
             */

               find pt_mstr where pt_domain = global_domain and
                    pt_part = xxwk.part no-lock no-error.
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
               /* {3} = Field to select records by (eg pt_part)   */
               /* {4} = Field(s) to display from primary file     */
               /* {5} = Field to highlight (eg pt_part)           */
               /* {6} = Frame name                                */
               /* {7} = Selection Criterion                       */
               /* {8} = Message number for the status line        */
/*G1DT*/       /* {9} = Exclusive lock needed (Y/N)            */

               {yympscrad4.i
                  xxwk
                  index1
                  xxwk.part
                  "xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req xxwk.qty_pick"
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
                for each xxwk NO-LOCK  break by site by xxwk.nbr by xxwk.part by xxwk.loc_fr:

                  qty_tot = qty_tot + xxwk.qty_pick.

                  if last-of(xxwk.loc_fr) then do:

                      if qty_tot <> 0 then do:
                            find ld_det where ld_domain = global_domain and
                                 ld_site = site and ld_loc = xxwk.loc_fr
                                             and ld_part = xxwk.part and ld_lot = "" and ld_ref = ""
                            no-lock no-error.
                            if available ld_det then do:
                               if ld_qty_oh < qty_tot then do:
                                   message "零件" xxwk.part + "在" + site + "," + xxwk.loc_fr
                                                  + "的待移仓总量:" + string(qty_tot) + ",大于库存量:" + string(ld_qty_oh)
                                           view-as alert-box error.
                                   sw_reset = yes.
                                   UNDO mainloop1, RETRY mainloop1.
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

               for each xxwk where xxwk.action <> "delete" no-lock by xxwk.part:
                   disp xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req xxwk.qty_pick
                   with width 90 stream-io.
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
                  for each xxwk no-lock   break by site by xxwk.nbr by xxwk.part by xxwk.loc_fr:
                    qty_tot = qty_tot + xxwk.qty_pick.
                    if last-of(xxwk.loc_fr) then do:
                        if qty_tot <> 0 then do:
                              find ld_det where ld_domain = global_domain and
                                   ld_site = site and ld_loc = xxwk.loc_fr
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
/*GA32*/                find first xxwk where xxwk.line = input xxwk.line no-lock no-error.
/*GA32*/                if available xxwk then do:
/*GA32*/                   recno = recid(xxwk).
/*GA32*/                end.
/*GA32*/                else do:
                           prompt-for xxwk.part xxwk.loc_fr xxwk.loc_to with frame c.                   /*eyes*/
                           find pt_mstr where pt_domain = global_domain and
                                pt_part = input xxwk.part no-lock no-error.        /*eyes*/
                           if not available pt_mstr then do:
                                {mfmsg.i 16 3}
                                undo,retry.
                           end.

                           find loc_mstr where loc_domain = global_domain and
                                loc_site = site and loc_loc = input xxwk.loc_fr no-lock no-error.
                           if not available loc_mstr then do:
                               message "库位 " + site + "," + input xxwk.loc_fr + " 不存在请重新输入" view-as alert-box error.
                               undo,retry.
                           end.

                           find loc_mstr where loc_domain = global_domain and
                                loc_site = site and loc_loc = input xxwk.loc_to no-lock no-error.
                           if not available loc_mstr then do:
                               message "库位 " + site + "," + input xxwk.loc_to + " 不存在请重新输入" view-as alert-box error.
                               undo,retry.
                           end.

/*GA32*/                   create xxwk.
/*GA32*/                   assign xxwk.line = input xxwk.line
                                  xxwk.part = input xxwk.part
                                  xxwk.desc1 = pt_desc2
                                  xxwk.loc_fr = input xxwk.loc_fr
                                  xxwk.loc_to = input xxwk.loc_to
                                  xxwk.action = "create".

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

/*GA32*/             display xxwk.line xxwk.part xxwk.desc1 xxwk.loc_fr xxwk.loc_to xxwk.qty_req
                             xxwk.qty_pick with frame c.

/*GA32*/             set /*xxwk.qty_req*/ xxwk.qty_pick with frame c editing:
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

                     /*
                     if xxwk.qty_req = 0 then do:
                                 message "错误: 需求量不能为“0”!" view-as alert-box error.
                                 next-prompt xxwk.qty_req with frame c.
                                 undo,retry.
                     end.
                     */

                     if input xxwk.qty_pick = 0 then do:
                               /*kevin,12/23
                                 message "错误: 待移仓量不能为“0”!" view-as alert-box error.
                                 next-prompt xxwk.qty_pick with frame c.
                                 undo,retry.
                               */

                            message "提示: 待移仓量为“0”!".
                            hide message.
                     end.
                     else do:
                          find ld_det where ld_domain = global_domain and
                               ld_site = site and
                                    ld_loc = xxwk.loc_fr and
                                    ld_part = xxwk.part and
                                    ld_qty_oh >= xxwk.qty_pick no-lock no-error.
                           if not available ld_det then do:
                              message "移出库位无库存或库存不足!" view-as alert-box error.
                               next-prompt xxwk.qty_pick with frame c.
                              undo,retry.
                          end.
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
                        assign xxtl_qty_req = xxwk.qty_req
                               xxtl_qty_pick = xxwk.qty_pick.
                  end.
                end. /*if xxwk.action = "update"*/
                if xxwk.action = "create" then do:
                     find xxtl_det where xxtl_nbr = nbr and
                                     xxtl_part = xxwk.part and
                                     xxtl_loc_fr = xxwk.loc_fr and
                                     xxtl_loc_to = xxwk.loc_to no-error.
                     if not available xxtl_det then do:
                        create xxtl_det.
                        assign xxtl_nbr = nbr
                               xxtl_site = site
                               xxtl_part = xxwk.part
                               xxtl_effdate = effdate
                               xxtl_loc_fr = xxwk.loc_fr
                               xxtl_loc_to = xxwk.loc_to
                               xxtl_qty_req = xxwk.qty_req
                               xxtl_qty_pick = xxwk.qty_pick
                               xxtl_date = today.
                  end.
                end. /*if xxwk.action = "create"*/
          end. /*for each xxwk*/

end. /*repeat*/
