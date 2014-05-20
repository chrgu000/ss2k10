/*REVISION: 9.0                  LAST MODIFIED: 09/25/13 BY: ZY *SS-20130925.1*/

{mfdtitle.i "test.1"}

define variable pklnbr like xxpklm_nbr.
define variable stat   as   character format "x(1)".
define variable del-yn as logical initial no.
form
   pklnbr colon 20 skip(1)
   stat   colon 20 skip
   "空白: 可发料" at 20 skip
   "I:    发料,可退料报废出库." at 20 skip
   "R:    退料." at 20 skip
   "C:    已结." at 20 skip
   "X:    取消." at 20 skip
   "D:    删除." at 20 skip
with frame a side-labels width 80 attr-space.
/*日期限制*/
 {xxcmfun.i}
 run verfiydata(input today,input date(3,5,2014),input yes,input "softspeed201403",input vchk5,input 140.31).

mainloop:
repeat with frame a:

  prompt-for  pklnbr editing:
      /* FIND NEXT/PREVIOUS RECORD */
   {mfnp05.i xxpklm_mstr xxpklm_index1 " yes " xxpklm_nbr "input pklnbr"}
    if recno <> ? then do:
        assign pklnbr = xxpklm_nbr
               stat = xxpklm_stat.
         display pklnbr stat.
         display xxpklm_date xxpklm_prod_line xxpklm_wkctr xxpklm_par xxpklm_sch_qty
                 xxpklm_cr_date with frame b with 2 columns width 80.
    end.
  end. /* editing: */
  assign pklnbr.
  find xxpklm_mstr no-lock where xxpklm_nbr = input pklnbr no-error.
  if available xxpklm_mstr then do:
     display  xxpklm_nbr @ pklnbr xxpklm_stat @ stat with frame a.
     display xxpklm_date xxpklm_prod_line xxpklm_wkctr xxpklm_par xxpklm_sch_qty
                 xxpklm_cr_date with frame b with 2 columns width 80.
  end.
  else do:
      message "领料单不存在,请重新输入!" .
      NEXT  mainloop.
  end.
     repeat :
         update stat with frame a.
         if index("IRCXD" , stat) = 0 and stat <> "" then do:
         		message "状态错误!".
         		undo,retry.
         end.
         if stat = "D" then do:
               find first xxpklm_mstr exclusive-lock where xxpklm_nbr = pklnbr
                       no-error.
               if available xxpklm_mstr then do:
                  IF  xxpklm_stat = "" THEN DO:
                      assign del-yn = no.
                      {mfmsg01.i 11 2 del-yn}
                      if del-yn then do:
                          delete xxpklm_mstr.
                          for each xxpkld_det exclusive-lock where xxpkld_nbr = pklnbr:
                             delete xxpkld_det.
                          end.
                       end.
                      clear frame a.
                      leave mainloop.
                  END.
                  ELSE DO:
                     message "领料单状态 " trim(xxpklm_status) ", 不能删除!" .
                     undo,retry.
                  END.
            end. /*   if available xxpklm_mstr then do: */
         end.
         else do:
           find first xxpklm_mstr exclusive-lock where xxpklm_nbr = pklnbr no-error.
           if available xxpklm_mstr then do:
              assign xxpklm_stat = stat.
              for each xxpkld_det exclusive-lock where xxpkld_nbr = pklnbr:
                  if stat = "I" and xxpkld_qty_iss <> 0 then do:
              	      assign xxpkld__chr01 = stat.
              	  end.
              	  if stat = "R" and xxpkld_qty_ret <> 0 then do:
              	     assign xxpkld__chr01 = stat.
              	  end.
              end.
           end.
         end.
         leave.
    end. /* repeat */
end.
