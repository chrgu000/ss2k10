/* xslapjp.p 日供件打印条码,并修改收货库位                                    */
/*----rev history-------------------------------------------------------------*/
/* ss - 110321.1  by: roger xiao                                              */
/*-revision end---------------------------------------------------------------*/
/* Barcode 68                                                                 */

define variable sectionid as integer init 0 .
define variable wmessage as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "barcode" and code_value ="wtimeout" no-lock no-error. /*  timeout - all level */
if available(code_mstr) then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "barcode" and code_value ="xslapjpwtimeout" no-lock no-error. /*  timeout - program level */
if available(code_mstr) then wtimeout = 60 * decimal(code_cmmt).

mainloop:
repeat:
     /* cycle counter -section id -- start*/
      sectionid = sectionid + 1 .
     /* section id -- end  */

     /* start  line :1002  地点[site]  */
     v1002l:
     repeat:

        /* --define variable -- start */
        hide all.
        define variable v1002           as char format "x(50)".
        define variable pv1002          as char format "x(50)".
        define variable l10021          as char format "x(40)".
        define variable l10022          as char format "x(40)".
        define variable l10023          as char format "x(40)".
        define variable l10024          as char format "x(40)".
        define variable l10025          as char format "x(40)".
        define variable l10026          as char format "x(40)".
        /* --define variable -- end */


        /* --first time default  value -- start  */
        {xsdfsite.i}
        v1002 = wdefsite.
        v1002 = entry(1,v1002,"@").
        /* --first time default  value -- end  */


        /* --cycle time default  value -- start  */
        v1002 = entry(1,v1002,"@").
        /* --cycle time default  value -- end  */

        /* logical skip start */
        if apass = "y" then
        leave v1002l.
        /* logical skip end */
                display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f1002 no-box.

                /* label 1 - start */ 
                l10021 = "地点设定有误" .
                display l10021          format "x(40)" skip with fram f1002 no-box.
                /* label 1 - end */ 


                /* label 2 - start */ 
                l10022 = "1.没有设定默认地点" .
                display l10022          format "x(40)" skip with fram f1002 no-box.
                /* label 2 - end */ 


                /* label 3 - start */ 
                l10023 = "2.权限设定有误" .
                display l10023          format "x(40)" skip with fram f1002 no-box.
                /* label 3 - end */ 


                /* label 4 - start */ 
                l10024 = "  请查核" .
                display l10024          format "x(40)" skip with fram f1002 no-box.
                /* label 4 - end */ 
                display "输入或按e退出"       format "x(40)" skip
        skip with fram f1002 no-box.
        update v1002
        with  fram f1002 no-label
        editing:
          readkey pause wtimeout.
          if lastkey = -1 then quit.
        if lastkey = 404 then do: /* disable f4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* press e exist cycle */
        if v1002 = "e" then  leave mainloop.
        display  skip wmessage no-label with fram f1002.

         /*  ---- valid check ---- start */

        display "...processing...  " @ wmessage no-label with fram f1002.
        pause 0.
        /* check for number variable start  */
        /* check for number variable  end */
        if not trim(v1002) = "e" then do:
                display skip "error , retry " @ wmessage no-label with fram f1002.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- valid check ---- end */

        display  "" @ wmessage no-label with fram f1002.
        pause 0.
        leave v1002l.
     end.
     pv1002 = v1002.
     /* end    line :1002  地点[site]  */


     /* start  line :1300  图号[item]  */
     v1300l:
     repeat:

        hide all.
        define variable v1300           as char format "x(50)".
        define variable pv1300          as char format "x(50)".
        define variable l13001          as char format "x(40)".
        define variable l13002          as char format "x(40)".
        define variable l13003          as char format "x(40)".
        define variable l13004          as char format "x(40)".
        define variable l13005          as char format "x(40)".
        define variable l13006          as char format "x(40)".


        if sectionid > 1 then 
        v1300 = pv1300 .
        v1300 = entry(1,v1300,"@").

        l13001 = "图号 或 图号+批号?" .
        l13002 = "" . 
        l13003 = "" . 
        l13004 = "" . 

        display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f1300 no-box.
        display l13001          format "x(40)" skip with fram f1300 no-box.
        display l13002          format "x(40)" skip with fram f1300 no-box.
        display l13003          format "x(40)" skip with fram f1300 no-box.
        display l13004          format "x(40)" skip with fram f1300 no-box.
        display "输入或按e退出"       format "x(40)" skip skip with fram f1300 no-box.

        recid(pt_mstr) = ?.
        update v1300
        with  fram f1300 no-label
        editing:
            readkey pause wtimeout.
            if lastkey = -1 then quit.
            if lastkey = 404 then do: /* disable f4 */
               pause 0 before-hide.
               undo, retry.
            end.
            display skip "^" @ wmessage no-label with fram f1300.
            if lastkey = keycode("f10") or keyfunction(lastkey) = "cursor-down"
            then do:
                  if recid(pt_mstr) = ? then find first pt_mstr where 
                              pt_part >=  input v1300
                               no-lock no-error.
                  else do: 
                       if pt_part =  input v1300
                       then find next pt_mstr
                        no-lock no-error.
                        else find first pt_mstr where 
                              pt_part >=  input v1300
                               no-lock no-error.
                  end.
                  if available pt_mstr then display skip 
                        pt_part @ v1300 pt_desc1 @ wmessage no-label with fram f1300.
                  else   display skip "" @ wmessage with fram f1300.
            end.
            if lastkey = keycode("f9") or keyfunction(lastkey) = "cursor-up"
            then do:
                  if recid(pt_mstr) = ? then find last pt_mstr where 
                              pt_part <=  input v1300
                               no-lock no-error.
                  else do: 
                       if pt_part =  input v1300
                       then find prev pt_mstr
                        no-lock no-error.
                        else find first pt_mstr where 
                              pt_part >=  input v1300
                               no-lock no-error.
                  end.
                  if available pt_mstr then display skip 
                        pt_part @ v1300 pt_desc1 @ wmessage no-label with fram f1300.
                  else   display skip "" @ wmessage with fram f1300.
            end.
            apply lastkey.
        end.


        if v1300 = "e" then  leave mainloop.
        display  skip wmessage no-label with fram f1300.

         /*  ---- valid check ---- start */

        display "...processing...  " @ wmessage no-label with fram f1300.
        pause 0.

        find first pt_mstr where pt_part = entry(1, v1300, "@") no-lock no-error.
        if not available pt_mstr then do:
                display skip "error,retry" @ wmessage no-label with fram f1300.
                pause 0 before-hide.
                undo, retry.
        end.
        else do:
            if index(v1300,"@") <= 0  then
                  assign v1300 = pt_part.
        end.

         /*  ---- valid check ---- end */

        display  "" @ wmessage no-label with fram f1300.
        pause 0.
        leave v1300l.
     end.
     if index(v1300,"@" ) = 0 then v1300 = v1300 + "@".
     pv1300 = v1300.
     v1300 = entry(1,v1300,"@").
     /* end    line :1300  图号[item]  */


     /* start  line :1500  批号[lot]  */
     v1500l:
     repeat:

        hide all.
        define variable v1500           as char format "x(50)".
        define variable pv1500          as char format "x(50)".
        define variable l15001          as char format "x(40)".
        define variable l15002          as char format "x(40)".
        define variable l15003          as char format "x(40)".
        define variable l15004          as char format "x(40)".
        define variable l15005          as char format "x(40)".
        define variable l15006          as char format "x(40)".
        
        
        define variable v_case_nbr      as char format "x(10)".
        define variable v_case_old      as char format "x(10)".
        define variable v_recid         as recid .
        define variable v_loc_to        as char format "x(8)" .
        define variable v_qty_rct       like xxship_rcvd_qty .
        define variable v_contract_nbr  as char format "x(18)" .
        define variable v_japan         as logical .
        define variable v_inv_nbr       as char format "x(18)" .

        if index(pv1300,"@") <> 0 then
        v1500 = entry(2, pv1300, "@").
        v1500 = entry(1,v1500,"@").
        
        v_case_nbr = "" .
        v_case_old = "" .
        v_recid    = ? .
        v_loc_to   = "" .
        v_qty_rct  = 0 .
        v_japan    = no.
        v_inv_nbr  = "" .
        v_contract_nbr = "" .

        /*
        find first pt_mstr where pt_part = v1300 and pt_lot_ser = "" no-lock no-error.
        if available pt_mstr then leave v1500l.
        */

        l15001 = "批号?" .
        l15002 = "图号:" + trim( v1300 ) .
        l15003 = "" . 
        l15004 = "" . 

        display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f1500 no-box.
        display l15001          format "x(40)" skip with fram f1500 no-box.
        display l15002          format "x(40)" skip with fram f1500 no-box.
        display l15003          format "x(40)" skip with fram f1500 no-box.
        display l15004          format "x(40)" skip with fram f1500 no-box.
        display "输入或按e退出"       format "x(40)" skip skip with fram f1500 no-box.

        recid(ld_det) = ?.
        update v1500
        with  fram f1500 no-label
        editing:
            readkey pause wtimeout.
            if lastkey = -1 then quit.
            if lastkey = 404 then do: /* disable f4 */
               pause 0 before-hide.
               undo, retry.
            end.
            display skip "^" @ wmessage no-label with fram f1500.
            if lastkey = keycode("f10") or keyfunction(lastkey) = "cursor-down"
            then do:
                  if recid(ld_det) = ? then find first ld_det where 
                              ld_part = v1300 and ld_site = v1002 and  
                              ld_lot >=  input v1500
                               no-lock no-error.
                  else do: 
                       if ld_lot =  input v1500
                       then find next ld_det
                       where ld_part = v1300 and ld_site = v1002
                        no-lock no-error.
                        else find first ld_det where 
                              ld_part = v1300 and ld_site = v1002 and  
                              ld_lot >=  input v1500
                               no-lock no-error.
                  end.
                  if available ld_det then display skip 
                        ld_lot @ v1500 ld_lot + "/" + trim(string(ld_qty_oh)) @ wmessage no-label with fram f1500.
                  else   display skip "" @ wmessage with fram f1500.
            end.
            if lastkey = keycode("f9") or keyfunction(lastkey) = "cursor-up"
            then do:
                  if recid(ld_det) = ? then find last ld_det where 
                              ld_part = v1300 and ld_site = v1002 and  
                              ld_lot <=  input v1500
                               no-lock no-error.
                  else do: 
                       if ld_lot =  input v1500
                       then find prev ld_det
                       where ld_part = v1300 and ld_site = v1002
                        no-lock no-error.
                        else find first ld_det where 
                              ld_part = v1300 and ld_site = v1002 and  
                              ld_lot >=  input v1500
                               no-lock no-error.
                  end.
                  if available ld_det then display skip 
                        ld_lot @ v1500 ld_lot + "/" + trim(string(ld_qty_oh)) @ wmessage no-label with fram f1500.
                  else   display skip "" @ wmessage with fram f1500.
            end.
            apply lastkey.
        end.

        
        if v1500 = "e" then  leave mainloop.
        display  skip wmessage no-label with fram f1500.


        display "...processing...  " @ wmessage no-label with fram f1500.
        pause 0.
        if not ( if index(v1500,"@" ) <> 0 then entry(2,v1500,"@") else v1500 ) <> "" then do:
        end.


        v_case_nbr = trim(substring(v1500,11)).
        v_contract_nbr = trim(substring(v1500,7,4)) .

        if v_case_nbr <> "" then do:
            do i = 1 to length(v_case_nbr).
                if index("0987654321", substring(v_case_nbr,i,1)) = 0 then do:
                    display skip "托号有误,请重新输入." @ wmessage no-label with fram f1500.
                    pause 0 before-hide.
                    undo, retry.
                end.
            end.
        end.

            for each  xxinv_mstr 
                use-index xxinv_con
                where substring(xxinv_con,6) = v_contract_nbr 
            no-lock :
                if v_japan = yes then leave .

                find first xxship_det
                    use-index xxship_case
                    where xxship_nbr    = xxinv_nbr
                    and   xxship_vend   = xxinv_vend
                    and   xxship_case2  = integer(v_case_nbr)
                    and   xxship_part2  = v1300 
                    and   xxship_status = "RCT-PO" 
                no-lock no-error.
                if avail xxship_det then do:
                    v_recid     = recid(xxship_det) .
                    v_loc_to    = xxship_rcvd_loc   .
                    v_qty_rct   = xxship_rcvd_qty   .
                    v_inv_nbr   = xxship_nbr         .
                    v_japan     = yes .
                    v_case_old  = string(xxship_case) .
                end.         
                else leave .

            end.  /* for each  xxinv_mstr */

        if v_japan = yes then do:
            if v_recid = ? then do:
                display skip "日供件,且发票有误,请重新输入." @ wmessage no-label with fram f1500.
                pause 0 before-hide.
                undo, retry.
            end.
        end. /*if v_japan = yes then*/
        else do:
                display skip "仅限日供件,请重新输入." @ wmessage no-label with fram f1500.
                pause 0 before-hide.
                undo, retry.
        end.



        display  "" @ wmessage no-label with fram f1500.
        pause 0.
        leave v1500l.
     end.
     if index(v1500,"@" ) <> 0 then v1500 = entry(2,v1500,"@").
     pv1500 = v1500.
     /* end    line :1500  批号[lot]  */


     /* start  line :1501  库位[loc]  */
     v1501l:
     repeat:

        hide all.
        define variable v1501           as char format "x(50)".
        define variable pv1501          as char format "x(50)".
        define variable l15011          as char format "x(40)".
        define variable l15012          as char format "x(40)".
        define variable l15013          as char format "x(40)".
        define variable l15014          as char format "x(40)".
        define variable l15015          as char format "x(40)".
        define variable l15016          as char format "x(40)".


        if sectionid > 1 then v1501 = pv1501 .

        v1501  = "" .
        l15011 = "库位?" .
        l15012 = "数量+原库位:" +  string(v_qty_rct) + "+" + v_loc_to . 
        l15013 = "图号: "  + v1300 . 
        l15014 = "发票+托号: " + v_inv_nbr + "+" + v_case_old  . 


        display "[日供标签列印]"        + "*" + trim ( v1002 )  format "x(40)" skip with fram f1501 no-box.
        display l15011                format "x(40)" skip with fram f1501 no-box.
        display l15012                format "x(40)" skip with fram f1501 no-box.
        display l15013                format "x(40)" skip with fram f1501 no-box.
        display l15014                format "x(40)" skip with fram f1501 no-box.
        display "输入或按E退出"       format "x(40)" skip skip with fram f1501 no-box.

        update v1501
        with  fram f1501 no-label
        editing:
            readkey pause wtimeout.
            if lastkey = -1 then quit.
            if lastkey = 404 then do: 
                pause 0 before-hide.
                undo, retry.
            end.
           apply lastkey.
        end.

        if v1501 = "e" then  leave mainloop.
        display  skip wmessage no-label with fram f1501.


        display "...processing...  " @ wmessage no-label with fram f1501.
        pause 0.
        find first loc_mstr where loc_site = v1002  and loc_loc = v1501 no-lock no-error.
        if not available loc_mstr then do:
                display skip "error , retry." @ wmessage no-label with fram f1501.
                pause 0 before-hide.
                undo, retry.
        end.


        display  "" @ wmessage no-label with fram f1501.
        pause 0.
        leave v1501l.
     end.
     if index(v1501,"@" ) <> 0 then v1501 = entry(2,v1501,"@").
     pv1501 = v1501.
     /* end    line :1501  库位[loc]  */




     /* start  line :1520  受检章  */
     v1520l:
     repeat:

        hide all.
        define variable v1520           as char format "x(50)".
        define variable pv1520          as char format "x(50)".
        define variable l15201          as char format "x(40)".
        define variable l15202          as char format "x(40)".
        define variable l15203          as char format "x(40)".
        define variable l15204          as char format "x(40)".
        define variable l15205          as char format "x(40)".
        define variable l15206          as char format "x(40)".


        v1520 = "y".
        v1520 = entry(1,v1520,"@").

        if sectionid > 1 then v1520 = pv1520 .
        v1520 = entry(1,v1520,"@").

        l15201 = "受检章-Y" .
        l15202 = "检验ok - N" .
        l15203 = "" . 
        l15204 = "" . 

        display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f1520 no-box.
        display l15201          format "x(40)" skip with fram f1520 no-box.
        display l15202          format "x(40)" skip with fram f1520 no-box.
        display l15203          format "x(40)" skip with fram f1520 no-box.
        display l15204          format "x(40)" skip with fram f1520 no-box.
        display "输入或按e退出"       format "x(40)" skip  skip with fram f1520 no-box.

        update v1520
        with  fram f1520 no-label
        editing:
            readkey pause wtimeout.
            if lastkey = -1 then quit.
            if lastkey = 404 then do: /* disable f4 */
                pause 0 before-hide.
                undo, retry.
            end.
            apply lastkey.
        end.

        if v1520 = "e" then  leave mainloop.
        display  skip wmessage no-label with fram f1520.


        display "...processing...  " @ wmessage no-label with fram f1520.
        pause 0.

        display  "" @ wmessage no-label with fram f1520.
        pause 0.
        leave v1520l.
     end.
     pv1520 = v1520.
     /* end    line :1520  受检章  */









/*----printloop start-----------------------------------------------------------------------------------------------------------------------------*/
   /* internal cycle input :9010    */
   v9010lmainloop:
   repeat:
     /* start  line :9010  条码上的数量[qty on label]  */
     v9010l:
     repeat:

        /* --define variable -- start */
        hide all.
        define variable v9010           as char format "x(50)".
        define variable pv9010          as char format "x(50)".
        define variable l90101          as char format "x(40)".
        define variable l90102          as char format "x(40)".
        define variable l90103          as char format "x(40)".
        define variable l90104          as char format "x(40)".
        define variable l90105          as char format "x(40)".
        define variable l90106          as char format "x(40)".
        /* --define variable -- end */


        /* --first time default  value -- start  */
        v9010 = string(v_qty_rct).
        v9010 = entry(1,v9010,"@").
        /* --first time default  value -- end  */


        /* --cycle time default  value -- start  */
        v9010 = entry(1,v9010,"@").
        /* --cycle time default  value -- end  */

        /* logical skip start */
        /* logical skip end */
                display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f9010 no-box.

                /* label 1 - start */ 
                l90101 = "条码上数量" .
                display l90101          format "x(40)" skip with fram f9010 no-box.
                /* label 1 - end */ 


                /* label 2 - start */ 
                l90102 = "图号:" + trim( v1300 ) .
                display l90102          format "x(40)" skip with fram f9010 no-box.
                /* label 2 - end */ 


                /* label 3 - start */ 
                l90103 = "批号:" + trim(v1500) .
                display l90103          format "x(40)" skip with fram f9010 no-box.
                /* label 3 - end */ 


                /* label 4 - start */ 
                  l90104 = "" . 
                display l90104          format "x(40)" skip with fram f9010 no-box.
                /* label 4 - end */ 
                display "输入或按e退出"       format "x(40)" skip
        skip with fram f9010 no-box.
        update v9010
        with  fram f9010 no-label
        editing:
          readkey pause wtimeout.
          if lastkey = -1 then quit.
        if lastkey = 404 then do: /* disable f4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* press e exist cycle */
        if v9010 = "e" then  leave v9010lmainloop.
        display  skip wmessage no-label with fram f9010.

         /*  ---- valid check ---- start */

        display "...processing...  " @ wmessage no-label with fram f9010.
        pause 0.
        /* check for number variable start  */
        if v9010 = "" or v9010 = "-" or v9010 = "." or v9010 = ".-" or v9010 = "-." then do:
                display skip "can not empty  " @ wmessage no-label with fram f9010.
                pause 0 before-hide.
                undo, retry.
        end.
        do i = 1 to length(v9010).
                if index("0987654321.-", substring(v9010,i,1)) = 0 then do:
                display skip "format  error  " @ wmessage no-label with fram f9010.
                pause 0 before-hide.
                undo, retry.
                end.
        end.

        if v9010 <> string(v_qty_rct) then do:
                display skip "数量不可修改" @ wmessage no-label with fram f9010.
                pause 0 before-hide.
                undo, retry.
        end.
        /* check for number variable  end */
         /*  ---- valid check ---- end */

        display  "" @ wmessage no-label with fram f9010.
        pause 0.
        leave v9010l.
     end.
     pv9010 = v9010.
     /* end    line :9010  条码上的数量[qty on label]  */


     /* start  line :9020  条码个数[no of label]  */
     v9020l:
     repeat:

        /* --define variable -- start */
        hide all.
        define variable v9020           as char format "x(50)".
        define variable pv9020          as char format "x(50)".
        define variable l90201          as char format "x(40)".
        define variable l90202          as char format "x(40)".
        define variable l90203          as char format "x(40)".
        define variable l90204          as char format "x(40)".
        define variable l90205          as char format "x(40)".
        define variable l90206          as char format "x(40)".
        /* --define variable -- end */


        /* --first time default  value -- start  */
        v9020 = "1".
        v9020 = entry(1,v9020,"@").
        /* --first time default  value -- end  */


        /* --cycle time default  value -- start  */
        v9020 = entry(1,v9020,"@").
        /* --cycle time default  value -- end  */

        /* logical skip start */
        /* logical skip end */
                display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f9020 no-box.

                /* label 1 - start */ 
                l90201 = "条码张数?" .
                display l90201          format "x(40)" skip with fram f9020 no-box.
                /* label 1 - end */ 


                /* label 2 - start */ 
                l90202 = "图号:" + trim( v1300 ) .
                display l90202          format "x(40)" skip with fram f9020 no-box.
                /* label 2 - end */ 


                /* label 3 - start */ 
                l90203 = "批号:" + trim(v1500) .
                display l90203          format "x(40)" skip with fram f9020 no-box.
                /* label 3 - end */ 


                /* label 4 - start */ 
                  l90204 = "" . 
                display l90204          format "x(40)" skip with fram f9020 no-box.
                /* label 4 - end */ 
                display "输入或按e退出"       format "x(40)" skip
        skip with fram f9020 no-box.
        update v9020
        with  fram f9020 no-label
        editing:
          readkey pause wtimeout.
          if lastkey = -1 then quit.
        if lastkey = 404 then do: /* disable f4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* press e exist cycle */
        if v9020 = "e" then  leave v9010lmainloop.
        display  skip wmessage no-label with fram f9020.

         /*  ---- valid check ---- start */

        display "...processing...  " @ wmessage no-label with fram f9020.
        pause 0.
        /* check for number variable start  */
        if v9020 = "" or v9020 = "-" or v9020 = "." or v9020 = ".-" or v9020 = "-." then do:
                display skip "can not empty  " @ wmessage no-label with fram f9020.
                pause 0 before-hide.
                undo, retry.
        end.
        do i = 1 to length(v9020).
                if index("0987654321.-", substring(v9020,i,1)) = 0 then do:
                display skip "format  error  " @ wmessage no-label with fram f9020.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* check for number variable  end */
         /*  ---- valid check ---- end */

        display  "" @ wmessage no-label with fram f9020.
        pause 0.
        leave v9020l.
     end.
     pv9020 = v9020.
     /* end    line :9020  条码个数[no of label]  */


   wtm_num = v9020.
     /* start  line :9030  打印机[printer]  */
     v9030l:
     repeat:

        /* --define variable -- start */
        hide all.
        define variable v9030           as char format "x(50)".
        define variable pv9030          as char format "x(50)".
        define variable l90301          as char format "x(40)".
        define variable l90302          as char format "x(40)".
        define variable l90303          as char format "x(40)".
        define variable l90304          as char format "x(40)".
        define variable l90305          as char format "x(40)".
        define variable l90306          as char format "x(40)".
        /* --define variable -- end */


        /* --first time default  value -- start  */
        find first upd_det where upd_nbr = "lapjp" and upd_select = 99 no-lock no-error.
if available ( upd_det ) then
        v9030 = upd_dev.
        v9030 = entry(1,v9030,"@").
        /* --first time default  value -- end  */


        /* --cycle time default  value -- start  */
         if sectionid > 1 then 
        v9030 = pv9030 .
        v9030 = entry(1,v9030,"@").
        /* --cycle time default  value -- end  */

        /* logical skip start */
        /* logical skip end */

        /* --cycle time skip -- start  */
         if sectionid > 1 then leave v9030l .
        /* --cycle time skip -- end  */

                display "[日供标签列印]"      + "*" + trim ( v1002 )  format "x(40)" skip with fram f9030 no-box.

                /* label 1 - start */ 
                l90301 = "打印机?" .
                display l90301          format "x(40)" skip with fram f9030 no-box.
                /* label 1 - end */ 


                /* label 2 - start */ 
                  l90302 = "" . 
                display l90302          format "x(40)" skip with fram f9030 no-box.
                /* label 2 - end */ 


                /* label 3 - start */ 
                  l90303 = "" . 
                display l90303          format "x(40)" skip with fram f9030 no-box.
                /* label 3 - end */ 


                /* label 4 - start */ 
                  l90304 = "" . 
                display l90304          format "x(40)" skip with fram f9030 no-box.
                /* label 4 - end */ 
                display "输入或按e退出"       format "x(40)" skip
        skip with fram f9030 no-box.
        recid(prd_det) = ?.
        update v9030
        with  fram f9030 no-label
        /* roll bar start */
        editing:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if lastkey = 404 then do: /* disable f4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ wmessage no-label with fram f9030.
            if lastkey = keycode("f10") or keyfunction(lastkey) = "cursor-down"
            then do:
                  if recid(prd_det) = ? then find first prd_det where 
                              prd_dev >=  input v9030
                               no-lock no-error.
                  else do: 
                       if prd_dev =  input v9030
                       then find next prd_det
                        no-lock no-error.
                        else find first prd_det where 
                              prd_dev >=  input v9030
                               no-lock no-error.
                  end.
                  if available prd_det then display skip 
            prd_dev @ v9030 prd_desc @ wmessage no-label with fram f9030.
                  else   display skip "" @ wmessage with fram f9030.
            end.
            if lastkey = keycode("f9") or keyfunction(lastkey) = "cursor-up"
            then do:
                  if recid(prd_det) = ? then find last prd_det where 
                              prd_dev <=  input v9030
                               no-lock no-error.
                  else do: 
                       if prd_dev =  input v9030
                       then find prev prd_det
                        no-lock no-error.
                        else find first prd_det where 
                              prd_dev >=  input v9030
                               no-lock no-error.
                  end.
                  if available prd_det then display skip 
            prd_dev @ v9030 prd_desc @ wmessage no-label with fram f9030.
                  else   display skip "" @ wmessage with fram f9030.
            end.
            apply lastkey.
        end.
        /* roll bar end */


        /* press e exist cycle */
        if v9030 = "e" then  leave v9010lmainloop.
        display  skip wmessage no-label with fram f9030.

         /*  ---- valid check ---- start */

        display "...processing...  " @ wmessage no-label with fram f9030.
        pause 0.
        /* check for number variable start  */
        /* check for number variable  end */
        find first prd_det where prd_dev = v9030  no-lock no-error.
        if not available prd_det then do:
                display skip "printer error " @ wmessage no-label with fram f9030.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- valid check ---- end */

        display  "" @ wmessage no-label with fram f9030.
        pause 0.
        leave v9030l.
     end.
     pv9030 = v9030.
     /* end    line :9030  打印机[printer]  */


    find first xxship_det
        where recid(xxship_det)  = v_recid
    no-error.
    if avail xxship_det then do:
        xxship_rcvd_loc = v1501.
    end.


     define variable ts9030 as character format "x(100)".
     define variable av9030 as character format "x(100)".
     procedure lapjp9030l.
        /* define labels path  start */
        define variable labelspath as character format "x(100)" init "/app/bc/labels/".
        find first code_mstr where code_fldname = "barcode" and code_value ="labelspath"no-lock no-error.
        if available(code_mstr) then labelspath = trim ( code_cmmt ).
        if substring(labelspath, length(labelspath), 1) <> "/" then 
        labelspath = labelspath + "/".
        /* define labels path  end */
     input from value(labelspath + "lap03").
     wsection = trim ( string(year(today)) + string(month(today)) + string(day(today)))  + trim(string(time)) + trim(string(random(1,100))) .
     output to value( trim(wsection) + ".l") .
     do while true:
              import unformatted ts9030.
        av9030 = v1300.
       if index(ts9030,"$p") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$p") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$p") + length("$p"), length(ts9030) - ( index(ts9030 ,"$p" ) + length("$p") - 1 ) ).
       end.

          /*库位*/
          if index(ts9030, "$C") <> 0 then do:
             av9030 = trim(V1501).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$C") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$C") 
                    + length("$C"), length(ts9030) - ( index(ts9030 , "$C") + length("$C") - 1 ) ).
          end.    /* SS - 110321.1 */
          /*批序号*/
          if index(ts9030, "$L") <> 0 then do:
             av9030 = substring(v1500,1,6) + "/" + v_contract_nbr.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$L") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$L") 
                    + length("$L"), length(ts9030) - ( index(ts9030 , "$L") + length("$L") - 1 ) ).
          end.


        av9030 = v_inv_nbr + " No." + v_case_old.
       if index(ts9030,"$o") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$o") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$o") + length("$o"), length(ts9030) - ( index(ts9030 ,"$o" ) + length("$o") - 1 ) ).
       end.
       find first pt_mstr where pt_part = v1300  no-lock no-error.
        if available ( pt_mstr )  then
        av9030 = trim(pt_desc1).
       if index(ts9030,"$f") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$f") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$f") + length("$f"), length(ts9030) - ( index(ts9030 ,"$f" ) + length("$f") - 1 ) ).
       end.
       find first pt_mstr where pt_part = v1300  no-lock no-error.
        if available ( pt_mstr )  then
        av9030 = pt_um.
       if index(ts9030,"$u") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$u") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$u") + length("$u"), length(ts9030) - ( index(ts9030 ,"$u" ) + length("$u") - 1 ) ).
       end.
       find first pt_mstr where pt_part = v1300  no-lock no-error.
        if available ( pt_mstr )  then
        av9030 = trim(pt_desc2).
       if index(ts9030,"$e") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$e") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$e") + length("$e"), length(ts9030) - ( index(ts9030 ,"$e" ) + length("$e") - 1 ) ).
       end.
        av9030 = string(today).
       if index(ts9030,"$d") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$d") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$d") + length("$d"), length(ts9030) - ( index(ts9030 ,"$d" ) + length("$d") - 1 ) ).
       end.
        av9030 = v9010.
       if index(ts9030,"$q") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$q") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$q") + length("$q"), length(ts9030) - ( index(ts9030 ,"$q" ) + length("$q") - 1 ) ).
       end.
        av9030 = " ".
       if index(ts9030,"$g") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$g") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$g") + length("$g"), length(ts9030) - ( index(ts9030 ,"$g" ) + length("$g") - 1 ) ).
       end.
        av9030 = trim(v1300) + "@" + trim(v1500).
       if index(ts9030,"&b") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "&b") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"&b") + length("&b"), length(ts9030) - ( index(ts9030 ,"&b" ) + length("&b") - 1 ) ).
       end.
        av9030 = v1500.
       if index(ts9030,"$l") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "$l") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"$l") + length("$l"), length(ts9030) - ( index(ts9030 ,"$l" ) + length("$l") - 1 ) ).
       end.
        av9030 = if trim ( v1520 ) = "y" then "受检章" else "检验ok".
       if index(ts9030,"&r") <> 0  then do:
       ts9030 = substring(ts9030, 1, index(ts9030 , "&r") - 1) + av9030 
       + substring( ts9030 , index(ts9030 ,"&r") + length("&r"), length(ts9030) - ( index(ts9030 ,"&r" ) + length("&r") - 1 ) ).
       end.
       put unformatted ts9030 skip.
     end.
     input close.
     output close.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     end procedure.
     run lapjp9030l.
     do i = 1 to integer(wtm_num):
       find first prd_det where prd_dev = v9030 no-lock no-error.
       if available prd_det then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     end.
   /* internal cycle end :9030    */
   end.
   pause 0 before-hide.
end.
