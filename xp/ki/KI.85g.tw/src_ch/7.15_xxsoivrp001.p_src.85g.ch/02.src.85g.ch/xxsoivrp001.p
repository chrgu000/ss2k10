/* xxsoivrp001.p  INVOICES PRINT (BI) -- 限已过账的发票                                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 create By: Roger Xiao */


/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090707.1 - RNB
SS - 090707.1 - RNE */

/* SS - 090810.1 - RNB
加限制,不打印数量为零的项次
SS - 090810.1 - RNE */


{mfdtitle.i "090810.1"}
define new shared variable dev as character format "x(8)" label "输出".

define var inv              like so_inv_nbr label "发票".
define var inv1             like so_inv_nbr label {t001.i}.
define var cust             like so_cust.
define var cust1            like so_cust.
define var bill             like so_bill.
define var bill1            like so_bill.
define var v_inv_date       as date  label "发票日期".
define var v_inv_date1      as date  label "至".
define var v_group          like pt_group label "组别".
define var v_group1         like pt_group label "至".
define new shared var v_sign           as logical format "Yes/No" initial yes.

define temp-table temp9 
    field t9_inv_nbr like ih_inv_nbr .

form
    inv                  colon 15
    inv1                 label {t001.i} colon 49 skip
    v_inv_date           colon 15
    v_inv_date1          label {t001.i} colon 49 skip
    cust                 colon 15
    cust1                label {t001.i} colon 49 skip
    bill                 colon 15
    bill1                label {t001.i} colon 49 skip
    v_group              colon 15
    v_group1             label {t001.i} colon 49 skip(1)

    v_sign             colon 15 label "是否签名"
with frame a width 80 side-labels.




repeat:
    for each temp9 : delete temp9 . end.

    if inv1 = hi_char         then inv1 = "".
    if cust1 = hi_char        then cust1 = "".
    if bill1 = hi_char        then bill1 = "".
    if v_inv_date  = low_date then v_inv_date  = ? . 
    if v_inv_date1 = hi_date  then v_inv_date1 = ? . 
    if v_group1   = hi_char   then v_group1    = "". 

    update
            inv              
            inv1             
            v_inv_date       
            v_inv_date1      
            cust             
            cust1            
            bill             
            bill1            
            v_group          
            v_group1         
                         
            v_sign         
    with frame a.

    bcdparm = "".
    {mfquoter.i  inv      }
    {mfquoter.i  inv1     }
    {mfquoter.i  v_inv_date    }
    {mfquoter.i  v_inv_date1   }
    {mfquoter.i  cust     }
    {mfquoter.i  cust1    }
    {mfquoter.i  bill     }
    {mfquoter.i  bill1    }
    {mfquoter.i  v_group       }
    {mfquoter.i  v_group1      }
    {mfquoter.i  v_sign      }

    if inv1    = ""     then inv1 = hi_char.
    if cust1   = ""     then cust1 = hi_char.
    if bill1   = ""     then bill1 = hi_char.
    if v_inv_date  = ?  then v_inv_date  = low_date. 
    if v_inv_date1 = ?  then v_inv_date1 = hi_date . 
    if v_group1    = "" then v_group1    = hi_char .

    printerloop:
    do on error undo , retry:
        if dev = "" then do:
            if can-find(prd_det where prd_dev = "printer") then   dev = "printer".
            else do:
                find last prd_det where prd_path <> "terminal" and prd_dev <> "terminal" no-lock no-error.
                if available prd_det then dev = prd_dev.
                else dev = "printer".
            end.
        end.
        display dev to 77  with frame a.
        set dev with frame a editing:
            if frame-field = "dev" then do:
                {mfnp05.i prd_det prd_dev "yes" prd_dev "input dev"}
                if recno <> ? then do:
                    dev = prd_dev.
                    display dev with frame a.
                end.
            end.
        end.
        if not can-find(first prd_det where prd_dev = dev) then do:
            {mfmsg.i 34 3}
            undo,retry.
        end.        
    end. /*printerloop:*/


	mainloop: 
	do on error undo, return error on endkey undo, return error:   
    
            for each ih_hist 
                    where ih_inv_nbr >= inv and ih_inv_nbr <= inv1
                    and ih_inv_date >= v_inv_date and ih_inv_date <= v_inv_date1
                    and ih_cust >= cust  and ih_cust <= cust1
                    and ih_bill >= bill   and ih_bill <= bill1
                    no-lock ,
                each idh_hist 
                    where idh_inv_nbr = ih_inv_nbr 
                    and idh_nbr = ih_nbr 
                    and idh_qty_inv <> 0 
                    no-lock,
                each pt_mstr 
                    where pt_part = idh_part 
                    and pt_group >= v_group and pt_group <= v_group1  
                no-lock
                break by idh_inv_nbr by idh_nbr by idh_line :
                if first-of(idh_inv_nbr) then do:
                    find first temp9 where t9_inv_nbr = idh_inv_nbr no-lock no-error.
                    if not avail temp9 then do:
                        create temp9 .
                        assign t9_inv_nbr = idh_inv_nbr .
                    end.
                end.
            end. /*for each ih_hist*/
            
            define var v_pause as integer .
            v_pause = 0 .
            for each temp9 break by t9_inv_nbr :
                v_pause = v_pause + 1 .
                if v_pause > 1 then pause 8 .   /*一定要预留足够的时间给每笔记录刷新数据*/
                {gprun.i ""xxsoivrp001a.p"" "(input t9_inv_nbr)"}
            end. /*for each temp9*/
    end. /*mainloop*/ 


    for each temp9 : delete temp9 . end.    
    hide all no-pause .
    view frame dtitle .
    view frame a .
end. /*repeat*/


