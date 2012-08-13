/*************************************************
** Program: xgchk01.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-18
** Description: Finish Goods Check Maintenance
*************************************************/

/*Modify by Xiangwh 2005-09-25   xwh050925
add the pallet parameter to backflush subprogram*/
/*Last Modified BY: Li Wei Date:2005-11-29 *lw02* */
/*Last Modified BY: hou    Date:2006-03-12 *H01* */

{mfdtitle.i}

/*lw02*/ define new shared variable ck_type like xwck_type format "x(3)".
define variable ck_lot  like xwck_lot.
define variable ck_part like xwck_part.
define variable ck_qty  like xwck_qty_chk.

define variable del-yn as logical.
define variable cfm-yn as logical.
define variable cfm-chk as logical.
define variable cfm-prt as logical.
define variable cfm-bkfl as logical.

define variable pal_nbr as character.
define variable tot_qty like xwck_qty_chk.
define variable tot_def like xpal_qty_def.
define variable counter as integer.
define variable origin_part like xwck_part.
define variable ErrNum as integer.

/*lw02*/ define variable Lot_num as integer.

define temp-table xxck_det
    field xxck_lnr      like xwck_lnr
    field xxck_part     like xwck_part
    field xxck_lot      like xwck_lot
    field xxck_qty      like xwck_qty_chk
    field xxck_prd_date like xwck_prd_date
    field xxck_prd_time like xwck_prd_time
    field xxck_cust     like xwck_cust
    field xxck_loc      like xwck_loc
    field xxck_stat     like xwck_stat
    field xxck_pallet   like xwck_pallet.


form 
   ck_type colon 10 "  (1 合格)" 
   ck_lot  colon 45
   skip(1)
   ck_part colon 10
   ck_qty  colon 45
with frame a  side-labels width 80 attr-space three-d.

form
    xxck_lnr     
    xxck_part    
    xxck_lot     
    xxck_qty     
    xxck_prd_date
    xxck_prd_time
    xxck_stat    
with frame c width 80 attr-space three-d.

view frame a.
hide frame c.

mainloop:
repeat:
     ErrNum = 0.
     Lot_num = 0.

      update
      ck_type validate(ck_type = "1" /*or ck_type = "2" */ , "ERR:输入正确的类型")
      with frame a.     
      
      for each xxck_det:
          delete xxck_det.
      end.


      tot_qty = 0.
      counter = 0.
      origin_part = "".

     do transaction on error undo,retry:      
          loopa:
          repeat:
                
                ck_lot = "".

                update 
                ck_lot
                with frame a.
                 
                counter = counter + 1.
                ErrNum = 0.

                find first xwo_srt no-lock where xwo_lot = ck_lot no-error.
                if avail xwo_srt then do:
                    if counter = 1 then do:
                        find first xpal_ctrl no-lock where xpal_part = xwo_part no-error.
                        if not avail xpal_ctrl then do:
                            ErrNum = ErrNum + 1.
                            message "ERR:没有零件" xwo_part "对应的托盘控制文件".
                            undo loopa,retry.
                        end.
                        else tot_def = xpal_qty_def.
                    end.

                    
                    if counter > tot_def then do:
                        ErrNum = ErrNum + 1.
                        /*
                        message "ERR:实际数量超出托盘默认最大数量,是否继续" update cfm-yn.
                        if not cfm-yn then undo loopa,retry.
                        else do:
                            cfm-yn = no.
                        end.
                        */
                        message "ERR:实际数量超出托盘默认最大数量".
                        undo loopa,retry.
                    end.

                    /*part difference, error*/
                    if origin_part <> "" and origin_part <> xwo_part then do:
                        ErrNum = ErrNum + 1.
                        message "ERR:当前零件" xwo_part "与上次零件" origin_part "不符,不能放入同一托盘".
                        undo loopa, retry.
                    end.
                    else origin_part = xwo_part.

                    find first xxck_det no-lock where xxck_lot = ck_lot no-error.
                    if not avail xxck_det then do:

                        create xxck_det.

                        find first xwck_mstr where xwck_lot = ck_lot no-error.
                        if avail xwck_mstr then do:
                            if xwck_stat <> "" and 
                               xwck_stat <> "CK" then do:
                               ErrNum = ErrNum + 1.
                                message "ERR:该批号已经被审核过".
                            end.

                            if xwck_type = "1" then do:
                                ErrNum = ErrNum + 1.
                                message "ERR:该批号已经被审核过并且是合格品,不能二次审核".
                                next-prompt ck_lot with frame a.
                                undo loopa,retry.
                            end.

                            if xwck_blkflh and xwck_type = "2" then xwck_tr = yes.
                        end.

                        assign
                        xxck_lnr      = xwo_lnr
                        xxck_part     = xwo_part
                        xxck_lot      = ck_lot
                        xxck_qty      = xwo_qty
                        xxck_prd_date = xwo_due_date
                        xxck_prd_time = xwo_due_time
                        xxck_cust     = xwo_cust
                        xxck_loc      = xwo_loc_des
                        xxck_stat     = "CK".
                        
                        tot_qty = tot_qty + xxck_qty.
                        ck_part = xxck_part.
                        ck_qty  = xxck_qty.
                        display ck_part ck_qty with frame a.
                    end.
                    else do:
                        ErrNum = ErrNum + 1.
                        message "ERR:重复的批号".
                        next-prompt ck_lot with frame a.
                        undo loopa, retry.
                    end.
                end.
                else do:
                    ErrNum = ErrNum + 1.
                    message "ERR:批号不存在".
                    counter = counter - 1.
                    next-prompt ck_lot with frame a.
                    undo loopa,retry.
                end.
/*xwh051013 if counter = tot_def then leave*/
                if counter = tot_def then LEAVE loopa.
          end. /*loopa*/

/*lw02*/
          if counter = 0 or counter = ? then do:
              message "ERR:没有待审核的批号".
              undo,next.
          end.
/*lw02*/

          if ck_type = "1" then cfm-yn = yes.
/*lw02                           else cfm-yn = no.*/
/*lw02    if ck_type = "1" then message "INF:确认生成托盘" update cfm-yn.*/
          if cfm-yn then do:
              /*get new pallet number*/ 
              {gprun.i ""xgchk01a.p""
              "(input xwo_part,output pal_nbr)"}
              
              if pal_nbr = "" then do:
                  message "ERR:没有生成新托盘号".
                  UNDO,retry.
              end.
          end.
          
/*lw02          else undo,retry.*/
/*lw02*/  if ck_type = "2" then do:
              pal_nbr = "CK" + string(year(today),"9999") 
                             + string(month(today),"99") 
                             + string(day(today),"99")
                             + string(time).
/*lw02*/  end.
         
          for each xxck_det:
              xxck_pallet = pal_nbr.
              display
                xxck_lnr     
                xxck_part    
                xxck_lot     
                xxck_qty 
                xxck_pallet
                xxck_prd_date
                string(xxck_prd_time,"HH:MM:SS") @ xxck_prd_time label "生产时间"
                xxck_stat
                with frame c down.
                down with frame c.
          end.
          
          cfm-chk = yes.  
          message "INF:确认审核" update cfm-chk.

          if cfm-chk then do:
                /*cfm-chk = no.*/
                for each xxck_det:
                    find first xwck_mstr where xwck_lot = xxck_lot no-error.
                    if not avail xwck_mstr then do:
                        /*creat check record*/
                        create xwck_mstr.
                    end.
                        assign
                        xwck_lnr = xxck_lnr
                        xwck_part = xxck_part
                        xwck_lot = xxck_lot
                        xwck_qty_chk = xxck_qty
                        xwck_prd_date = xxck_prd_date
                        xwck_prd_time = xxck_prd_time
                        xwck_stat = xxck_stat
                        xwck_cust = xxck_cust
                        xwck_loc  = xxck_loc
                        xwck_date = today
                        xwck_time = time
                        xwck_type = ck_type
                        xwck_pallet = xxck_pallet.
                end. /*for each*/
          end.
          clear frame c all.
          hide frame c.
    end. /*do transaction*/    
    
    if ErrNum = 0 then do:
        cfm-prt = yes. /*print*/
        if cfm-yn and cfm-chk then message "INF:确认打印托盘标签" update cfm-prt.

        if cfm-yn and cfm-chk and cfm-prt then do:
            /*cfm-prt = no.*/
            /*pallet printed*/
            {gprun.i ""xgpalprt1.p"" "(input pal_nbr)"}
            PAUSE 1.
        end.
             
/*lw02*/ if ck_type = "2" then do:
            cfm-yn = yes.
            message "INF:确认回冲?" update cfm-yn.
/*lw02*/ end.
         
/*H01*        IF cfm-yn AND cfm-chk THEN DO:  */
/*H01*/ IF cfm-yn AND cfm-chk THEN DO transaction:

             /*cfm-bkfl = no.*/
            /*backflush*/ 
/*xwh050925     {gprun.i ""xgcrt04a.p""} */
            {gprun.i ""xgcrt04a.p"" "(input pal_nbr)"}
            
            /*location transfer*/
/*xwh050925            {gprun.i ""xgcrt04c.p""} */

            {gprun.i ""xgcrt04c.p"" "(input pal_nbr)"}
        END.

        /***lw01***
        cfm-bkfl= yes. /*backflush*/
        if cfm-yn and cfm-chk and cfm-prt then message "INF:确认回冲/移库"  update cfm-bkfl.
        if cfm-bkfl then do:
            /*cfm-bkfl = no.*/
            /*backflush*/ 
            {gprun.i ""xgcrt04a.p""}
            
            /*location transfer*/
            {gprun.i ""xgcrt04c.p""}
        end.
        ***lw01***/
    end.
end. /*mainloop*/

