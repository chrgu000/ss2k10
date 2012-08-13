/* xgkbpd01.p    失效或关闭看板卡                         */
/* create by: hou             2006/02/22                  */

{mfdeclre.i}
{kbconst.i}


define input  parameter p_nbr    like xpd_nbr.
define input  parameter p_part   as   char.
define input  parameter p_qty    like xpdsd_qty.
define input-output parameter p_buf    like xpdsd_work_buf.

define variable v_buf   like xpdsd_work_buf.
define variable v_msg   as   char.
define variable v_rid   as   rowid.

v_buf = p_buf.
if p_qty > v_buf then return.

for each xpdkb_det where xpdkb_nbr = p_nbr and xpdkb_part = p_part:
   find first knbd_det where knbd_id = xpdkb_id and knbd_active and
   knbd_status = {&KB-CARDSTATE-EMPTYACC} no-lock no-error.
   if avail knbd_det then do:
      v_rid = rowid(knbd_det).
      find knbd_det where rowid(knbd_det) = v_rid exclusive-lock no-error.
      if avail knbd_det then do:
         
         if knbd_active_code = {&KB-CARD-ACTIVE-CODE-PERIOD} then
            assign knbd_pou_ref = ""
                   knbd_active_start_date = ?.
         
         /* DEACTIVATE SINGLE CARD */
         {gprun.i ""xgkbcdmt02.p"" "(input knbd_id,output v_msg)"}
         if v_msg = "" then do:
            v_buf = v_buf - knbd_kanban_quantity.
            if p_qty > v_buf then do:
               p_buf = v_buf.
               return.
            end.
         end.
      end.
   end.
end.

for each xpdkb_det where xpdkb_nbr = p_nbr and xpdkb_part = p_part:
   find first knbd_det where knbd_id = xpdkb_id and knbd_active and
   knbd_status <> {&KB-CARDSTATE-EMPTYACC} no-lock no-error.
   if avail knbd_det then do:
      v_rid = rowid(knbd_det).
      find first knbd_det where rowid(knbd_det) = v_rid exclusive-lock no-error.
      if avail knbd_det then do:
         
         if knbd_active_code = {&KB-CARD-ACTIVE-CODE-PERIOD} then
            assign knbd_pou_ref = ""
                   knbd_active_start_date = ?.
         
         /* CLOSE SINGLE CARD */   
         {gprun.i ""xgkbcdmt03.p"" "(input knbd_id,output v_msg)"}
         if v_msg = "" then do:
            v_buf = v_buf - knbd_kanban_quantity.
            if p_qty > v_buf then do:
               p_buf = v_buf.
               return.
            end.
         end.
      end.
   end.
end.
