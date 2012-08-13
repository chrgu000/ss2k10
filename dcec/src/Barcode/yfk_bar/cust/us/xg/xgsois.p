/*************************************************
** Program: xgsois.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-18
** Description: Finish Goods Check Maintenance
*************************************************/
/*modified by xwh, xwh050926
 Date: 2005-09-26
 Description: modify the subprogram for printing  transfer shipper*/
/* modified by xwh,xwh050927
 Description: correct the wrong logic for caculating transfer qty*/

/* modified by lw02,lw02
 Description: display pallet counter */

/* Last modified: hou   2006.03.06    *H01*  */

{mfdtitle.i}

define variable pallet like xwck_pallet.
define variable shipper like abs_id label "货运单".
define variable cust_order like abs_id label "客户采购单号".
define variable Qty_ship like xwck_qty_chk.
define variable Can_ship as logical.
define variable filename as character format "x(50)".
define variable cimconfirm as logical.
define variable shipperconfirm as logical.
define variable IS-ICTR as logical.
define variable errors as integer.
define variable print as logical label "打印发运单".
define variable origin_to as character.
define variable origin_loc as character.
define variable site as character.
define variable loc  as character.
/*Lu_2 define variable loc_fm  as character. */ 
define variable loc_to  as character.   /*Lu_3*/
define new global shared variable loc_fm  as character.  /*Lu_2*/
define variable pal_counter as integer.
define variable custname as character format "x(24)".
DEFINE VAR qt AS CHARACTER INIT '"'.
DEFINE VAR spc AS CHARACTER INIT " ".
define variable x_pal like xwck_pallet. /*lw02*/
define buffer buf_xwck for xwck_mstr.
define new shared temp-table xtable
    field xtable_recid as recid
    field xtable_pal like xwck_pallet.

define temp-table xcim
    field xcim_pal     like xwck_pallet
    field xcim_shipper as character
    field xcim_from    like abs_shipfrom
    field xcim_to      like abs_shipto
    field xcim_site    like si_site
    field xcim_loc     like loc_loc
    field xcim_part    like xwck_part
    field xcim_qty     like xwck_qty_chk.
/*xwh051007*/
DEFINE VARIABLE lot_counter AS INTEGER.

/*H01*/
{xglogdef.i "new"}
    
form
    shipper colon 10
    print   colon 55 
    skip(1)
    pallet colon 10 
    pal_counter colon 25 no-label /*lw02*/
    xwck_cust colon 10
    custname no-label
    xwck_part colon 55
    xwck_lot  colon 10
    qty_ship  colon 55
    
with frame a side-labels width 80 attr-space.

filename = string(month(today),"99") + string(day(today),"99") + ".cim".

for first shc_ctrl
   fields (shc_require_inv_mov shc_ship_nr_id)
   no-lock:
end. /* FOR FIRST sch_ctrl */


mainloop:
repeat:

    origin_to = "".
    origin_loc = "".
    qty_ship = 0.
/*xwh051007*/
    lot_counter = 0.
    pal_counter = 0.
    pallet = "".
    IS-ICTR = no.
    
    if search(filename) <> ? then os-delete value(filename).
    
    for each xtable:
        delete xtable.
    end.     
    
    for each xcim:
        delete xcim.
    end.

    print = YES.
    update shipper print with frame a.
    
    if shipper = "" then do:
        run GetShipperNbr(output shipper).
    end.

    display shipper with frame a. 

    find first xgtr_det no-lock where xgtr_shipper = shipper no-error.
    if avail xgtr_det then do:
        message "ERR:发运单已经发运，不能二次发运".
        undo mainloop, retry.
    end.
    release xgtr_det.

    loopa:
    repeat on error undo,retry:
        
        update pallet with frame a.
        
        pal_counter = pal_counter + 1.
        
        site = "".
        qty_ship = 0.
/*xwh051007*/
        lot_counter = 0.

        find first xwck_mstr no-lock where xwck_pallet = pallet
                                     and xwck_type = "1"
                                     and xwck_stat = "CK"
                                     and xwck_shipper = ""
                                     no-error.
        if avail xwck_mstr then do:
            if pal_counter = 1 then do:
/*Lu_4*/            	
            	  find first xpal_ctrl where xpal_part = xwck_part 
                                       and xpal_cust_def = xwck_cust no-lock no-error.
/*Lu_4*/        if available xpal_ctrl then do :                                       
            	     find first loc_mstr where loc_loc = xpal_dloc_def no-lock no-error.
                   if loc_status = "Customer" then IS-ICTR = NO.
                                           else IS-ICTR = YES.
                   assign
                      origin_to = xwck_cust
                      origin_loc = xpal_dloc_def.
                end.
                else do:      
                   message "ERR:此零件的托盘参数未维护".
                    undo loopa,retry.
                end.      
                /*lw01
                if IS-ICTR then do:
                    find first xgtr_det no-lock where xgtr_shipper = shipper no-error.
                    if avail xgtr_det then do:
                        message "ERR:发运单已经发运，不能二次发运".
                        undo mainloop, retry.
                    end.
                    release xgtr_det.
                end.
                */
            end.
        end.
        else do:
            pal_counter = pal_counter - 1.
            message "ERR:无效的托盘号".
            undo loopa,retry.
        end.
        display pal_counter with frame a. /*lw02*/
        /*lw01*/
        find first xtable no-lock where xtable_pal = pallet no-error.
        if avail xtable then do:
            message "ERR:已经扫描过的托盘".
            undo loopa,retry.
        end.

        for each xwck_mstr no-lock  where xwck_pallet = pallet
                                     and xwck_type = "1"
                                     and xwck_stat = "CK"
                                     and xwck_shipper = ""
                                     USE-INDEX xwck_pal
                                     break by xwck_part
                                     by xwck_pallet:
            if first-of(xwck_part) then do:
                qty_ship = 0.

                find first ad_mstr no-lock where ad_addr = xwck_cust no-error.
                if avail ad_mstr then custname = ad_name.
                                 else custname = "".
               
                display 
                xwck_cust 
                custname
                xwck_part 
                xwck_lot 
                with frame a.

                find first pt_mstr no-lock where pt_part = xwck_part no-error.
                if avail pt_mstr then do:
                    if not can-find(first si_mstr where si_site = pt_site) then do:
                        message "ERR:发出地点错误".
                        undo loopa,retry.
                    end.
                    else site = pt_site.
                end.
                else do:
                    message "ERR:零件错误".
                    undo loopa,retry.
                end.

                   assign loc_to = origin_loc.                                         
                

                if IS-ICTR = no then do:
                    find first scx_ref no-lock where scx_shipfrom = pt_site
                                                 and scx_shipto = xwck_cust
                                                 and scx_part = xwck_part
                                                 no-error.
                    if not avail scx_ref or scx_order = "" then do:
                        message "ERR:没有可用的客户日程单" .
                        undo loopa,retry.
                    end.

                    if xwck_cust <> origin_to then do:
                        message "ERR:客户不同于前一客户".
                        undo loopa,retry.
                    end.

                    if not can-find(first cm_mstr where cm_addr = xwck_cust) then do:
                        message "ERR:错误的客户代码".
                        undo loopa,retry.
                    end.

                end.

/*Lu_1*                
                if xwck_loc_des <> origin_loc then do:
                    message "ERR:目的库位不同于前一目的库位".
                    undo loopa,retry.
                end.   */

            end. /*if first-of*/
/*051208 remark FIFO policy required by Tan begin-------
            /*first in , first out*/
            {gprun.i ""xgsoiscka.p""
            "(input xwck_part,
            input xwck_date,
            input xwck_time,
            output can_ship,
            output x_pal)"} /*lw02*/ 

            if not can_ship then do:
               message "ERR:发运必须按先进先出原则 " x_pal.
               undo loopa,retry.
            end.
-------------  remark FIFO end*/  

            /*Record ID, write back the shipper number*/
            create xtable.
            assign
            xtable_recid = recid(xwck_mstr)
            xtable_pal = xwck_pallet.
        
            qty_ship = qty_ship + xwck_qty_chk. /*total QTY by Part*/
/*xwh051007*/
            lot_counter = lot_counter + 1.
            if last-of(xwck_part) then do:
                display qty_ship with frame a.
/*Lu_1          if IS-ICTR  then do:                            */
                    find first xgpl_ctrl no-lock where xgpl_lnr =  xwck_lnr no-error.
                    if not avail xgpl_ctrl then do:
                        message "ERR:没有仓库库位,请先维护生产线控制文件".
                        undo loopa,retry.
                    end.

/*xwh050927                    find first xgtr_det no-lock where xgtr_shipper = shipper no-error.*/
                    find first xgtr_det EXCLUSIVE-LOCK where xgtr_shipper = shipper AND xgtr_part = xwck_part no-error.
                    if not avail xgtr_det then do:
                        create xgtr_det.
                        assign
                        xgtr_shipper = shipper
                        xgtr_part    = xwck_part
                        xgtr_site    = site
                        xgtr_qty     = qty_ship
/*xwh051007 add lot counter and customer code*/
                        xgtr_lot_count = lot_counter
                        xgtr_cust = xwck_cust
                        xgtr_f_loc   = xgpl_loc
/*Lu_3                        xgtr_t_loc   = xwck_loc_des */
/*Lu_3*/                xgtr_t_loc = loc_to.
                    end.
                    ELSE
                    assign
    /*xwh050927         xgtr_qty     = qty_ship.*/
                    xgtr_qty     = xgtr_qty + qty_ship
/*xwh050927 add lot_counter*/                    
                    xgtr_lot_count = xgtr_lot_count + lot_counter.
                    xgtr_effdate = today.
                    
/*Lu_2*/            loc_fm = xgtr_f_loc.                   

                    release xgtr_det.
/*Lu_1          end.   */
                if IS-ICTR = no then do:
                    
                    find first xcim no-lock where xcim_part = xwck_part
                                              no-error.
                    if avail xcim then do:
                        xcim_qty = xcim_qty + qty_ship.
                    end.
                    else do:
                        create xcim.
                        assign
                        xcim_pal     = xwck_pallet
                        xcim_shipper = shipper
                        xcim_from    = site
                        xcim_to      = xwck_cust
                        xcim_site    = site
/*Lu_3                        xcim_loc     = xwck_loc_des  */
/*Lu_3*/                xcim_loc     = loc_to
                        xcim_part    = xwck_part
                        xcim_qty     = qty_ship.

                    end.
                end. /*if IS-ICTR*/
            end.
        end. /*for each*/

        if qty_ship = 0 then do:
            message "ERR:没有符合发运条件的审核记录".
            undo loopa, retry.
        end.

    end. /*loopa*/
    
    find first cm_mstr where cm_addr = origin_to no-lock no-error.
       if cm_region = "yes" then do:
       	   update cust_order.
       end.	   

    cimconfirm = yes.
    message "INF:确认产生发运单或移库" update  cimconfirm .
    
/*  if IS-ICTR then do:  */
        if cimconfirm then do:
            for each xgtr_det no-lock where xgtr_shipper = shipper:
                {gprun.i ""xgictrcm.p""
                "(input filename,
                input xgtr_part,
                input xgtr_qty,
                input xgtr_effdate,
                input xgtr_shipper,
                input xgtr_site,
                input xgtr_f_loc,
                input '',
                input '',
                input xgtr_site,
                input xgtr_t_loc)"}
            end.
        end.
/*  end.  */
    if IS-ICTR = no then do:
        if cimconfirm then do:        
            find first xcim no-lock no-error.
            if avail xcim then do:
                run ShipperHeader(input filename,input site,input shipper,input origin_to).
            end.
            for each xcim:
                run ShipperDetail(input filename,
                 input xcim_part,
                 input xcim_qty,
                 input xcim_from,
                 input xcim_loc,
                 input xcim_from,
                 input xcim_to).
            end.
            find last xcim no-lock no-error.
            if avail xcim then do:
                run ShipperTrail(input filename). 
            end.

/*Lu_1      shipperconfirm = yes.
            message "INF:发运单确认" update shipperconfirm.
            
            if shipperconfirm then do:
                run ShipperComfirm(input filename ,input site ,input shipper ).
            end.  */
        end.
    end. /*if is-ictr*/

    if cimconfirm then do:
       cimconfirm = no.
       {xgcmdef.i "new"}
       do transaction on error undo,leave:
          
          {gprun.i ""xgcm001.p""
          "(INPUT filename,
          output errors)"}

           if errors > 0 then do:
               {mfselprt.i "terminal" 132}
               for each cim_mstr break by cim_group:
                   disp cim_desc with width 200 stream-io.
               end.
               {mfreset.i}
               undo , leave.
           end.
           else do:
              if IS-ICTR = no then do:
                  find first abs_mstr no-lock where substr(abs_id,3,7) = shipper no-error.
                  if not avail abs_mstr then do:
                      message "ERR:发运单没生成".
                      undo,leave.
                  end.
              end.

              for each xtable:
                  find first xwck_mstr exclusive-lock where recid(xwck_mstr) = xtable_recid no-error.
                  if avail xwck_mstr then do:
                      xwck_shipper = shipper.
                      xwck_shp_date = TODAY.
                  END.
              end.
              message "INF:数据导入成功!".
              pause 3.
           end.
           release xwck_mstr.
       end. /*do transaction*/

         /*H01*/
         {xgxlogdet.i}
       
    end. /*if cimconfirm*/

    /*shipper printed*/
    if print then do:
    	find first tr_hist where tr_nbr = shipper no-lock no-error.    /*Lu_4*/
    	if available tr_hist then do:                                  /*Lu_4*/
        find first abs_mstr no-lock where abs_shipfrom = site 
                                     and abs_id       = "s" + shipper
                                     no-error.
        if  available abs_mstr then do:
            /*print out-door-document
            {gprun.i ""xxship02p.p"" "(input recid(abs_mstr))"}
            */
            {gprun.i ""xgicshprt2.p"" "(input recid(abs_mstr))"}
        end.
        else do:
            find first xgtr_det no-lock where xgtr_shipper = shipper no-error.
            if avail xgtr_det then do:
/*xwh051007                {gprun.i ""xxicshprt2.p"" "(input recid(xgtr_det))"}*/
                {gprun.i ""xgtrprt2.p"" "(input shipper)"}
            end.
        end.
      end.                     /*Lu_4*/
      else do:                 /*Lu_4*/
      	message "移库失败！".  /*Lu_4*/
      	pause 3.               /*Lu_4*/
      end.	                   /*Lu_4*/
    end.
    
    if search(filename) <> ? then os-delete value(filename).
    
end. /*mainloop*/

Procedure GetShipperNbr:
    define output parameter NextNbr like nr_seg_value.
    define variable Nbr  as integer.
    define variable Len1 as integer.
    define variable Len2 as integer.
    define variable Pos  as integer.

    find first shc_ctrl no-lock no-error.
    if available shc_ctrl then do:
        find first nr_mstr exclusive-lock where nr_seqid =  shc_ship_nr_id no-error.
        if avail nr_mstr then do:
             
            if index(nr_seg_value,",") = 0 then do:
                pos = length(nr_seg_value).
                Len1 = pos. 
            end.
            else do:
                Len1 = index(nr_seg_value,",") - 1.
                pos = index(nr_seg_value,",") - 1.
            end.

            Nbr = int(substr(nr_seg_value, 1 , pos)) + 1.
            Len2 = length(string(Nbr)).
            
            NextNbr = fill( "0", Len1 - Len2 ) + string(Nbr).
            
            if index(nr_seg_value,",") = 0 then 
                nr_seg_value = NextNbr.
            else nr_seg_value = NextNbr + substr(nr_seg_value,pos + 1).
        end.
    end.

    release shc_ctrl.
    release nr_mstr.
end.

Procedure ShipperHeader:

    DEFINE INPUT PARAMETER flname AS CHARACTER format "x(80)".
    DEFINE INPUT PARAMETER shipfrom AS CHARACTER .
    DEFINE INPUT PARAMETER ship AS CHARACTER .
    DEFINE INPUT PARAMETER shipto AS CHARACTER .

    output to value(flname) append.
    PUT UNFORMATTED "@@batchload rcshmt.p" SKIP.
    PUT UNFORMATTED qt shipfrom qt spc
                    qt ship qt spc
                    qt shipto qt spc
                    /*"- " spc*/ skip
                    "-" spc "no" spc "-" spc "-" spc
/*Lu_1*/            qt cust_order qt spc  
/*Lu_1                    "- No - - - - - - - - No"  */
                    skip
                    "." 
                    skip.
    output close.
end.

procedure ShipperDetail:

    DEFINE INPUT PARAMETER flname AS CHARACTER format "x(80)".
    DEFINE INPUT PARAMETER part AS CHARACTER .
    DEFINE INPUT PARAMETER qty AS DECIMAL.
    DEFINE INPUT PARAMETER site AS CHARACTER .
    DEFINE INPUT PARAMETER loc AS CHARACTER.
    DEFINE INPUT PARAMETER shipfrom AS CHARACTER .
    DEFINE INPUT PARAMETER shipto AS CHARACTER .


    find first scx_ref where scx_shipfrom = shipfrom
                         and scx_shipto = shipto
                         and scx_part = part
                         no-lock no-error.
    if not avail scx_ref then do:
        message "ERR:没有客户日程记录".
        undo,retry.
    end.
/*Lu_1
    FIND FIRST xshloc_mstr WHERE xshloc_cust = scx_order AND xshloc_part = scx_part NO-LOCK NO-ERROR.
    if not avail xshloc_mstr then do:
        message "ERR:此零件发运库位未维护".
        undo,retry.
    end.
    ELSE do:
    	 loc_fm = xshloc_cust_loc.
    END.
Lu_1*/
    output to value(flname) append.
    PUT UNFORMATTED
                qt part qt spc
                qt scx_po qt spc
                qt scx_custref qt spc
                qt scx_modelyr qt spc
                '""'
                ' ""'
                skip
                qt qty qt spc
                "- - "
                qt site qt spc
                "-" spc
/*add loc_fm to cimfile as below*/                
/*Lu_1                qt loc_fm qt spc  */
                "- - No No" 
                skip.
    output close.
end.

procedure ShipperTrail:

    DEFINE INPUT PARAMETER flname AS CHARACTER format "x(80)".
    output to value(flname) append.
    PUT UNFORMATTED "."
                    skip
                    "." 
                    skip .
    PUT UNFORMATTED "." SKIP /*"." SKIP*/ .
    PUT UNFORMATTED "@@END" SKIP .
    output close.
end.

procedure ShipperComfirm:

    DEFINE INPUT PARAMETER flname AS CHARACTER format "x(80)".
    define input parameter site as character.
    define input parameter shipper as character.

    output to value(flname) append.
    PUT UNFORMATTED "@@batchload rcsois.p" SKIP.
    PUT UNFORMATTED qt site qt spc
                    "S" spc
                    qt Shipper qt spc 
                    skip
                    "-" skip
                    "-" skip
                    "-" skip
                    "Yes" SKIP 
                    "." SKIP.
    PUT UNFORMATTED "@@END" SKIP .
    output close.
end.
