/* -----------------------------------------------------------
   Purpose:获取最接近vodlotlist
   Parameters: i_weight 目标重量。
               i_pkg_cnt 捆包本数
               o_vodlot_lst 以","隔开的vodlot列表
   Notes:
 -------------------------------------------------------------*/
{mfdtitle.i "120420.1"}
{zzlot.i}
define input parameter i_weight as decimal.
define input parameter i_pkg_cnt as integer.
define output parameter o_vodlot_lst as character.

define variable v_cnt as integer.
define variable v_weight as decimal.
define variable v_curr_weight as decimal.
define variable v_curr_vodlot_lst as character.
assign v_cnt = 0
       v_weight = 0
       v_curr_weight = 0
       v_curr_vodlot_lst = "".

for each tt_vodlot no-lock:
    assign v_curr_weight = v_curr_weight + tt_weight.
    if v_curr_vodlot_lst = "" then do:
       assign v_curr_vodlot_lst = tt_vodlotno.
    end.
    else do:
       assign v_curr_vodlot_lst = v_curr_vodlot_lst + "," + tt_vodlotno.
    end.
    assign v_cnt = v_cnt + 1.
    if v_cnt = i_pkg_cnt then do:
       if v_weight = 0 then do:
          if o_vodlot_lst = "" then do:
             assign o_vodlot_lst = v_curr_vodlot_lst.
          end.
          if i_weight - v_weight < 0 then leave.
          assign v_weight = v_curr_weight.
       end.
       else if i_weight - v_weight > 0 and i_weight - (v_weight + v_curr_weight) < 0 then do:
          if o_vodlot_lst = "" then do:
             assign o_vodlot_lst = v_curr_vodlot_lst.
          end.
          else do:
             if abs(i_weight - (v_weight + v_curr_weight)) < abs(i_weight - v_weight) then do:
                assign o_vodlot_lst = o_vodlot_lst + "," + v_curr_vodlot_lst.
             end.
          end.
          leave.
       end.
       else do:
            assign o_vodlot_lst = o_vodlot_lst + "," + v_curr_vodlot_lst.
       end.
       assign v_weight = v_weight + v_curr_weight
              v_curr_weight = 0
              v_curr_vodlot_lst = ""
              v_cnt = 0.
    end. /* if v_cnt = i_pkg_cnt then do: */
end. /* for each tt_vodlot no-lock: */
