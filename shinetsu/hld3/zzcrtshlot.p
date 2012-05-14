/*zzcrtshlot.p   Create ShipLotNo */

{mfdeclre.i}

def input parameter v_part as char.
def output parameter v_shiplot as char format "x(14)".
def var v_lot1  as char format "x(7)".
def var v_lot2  as int format "999999" init 0.
def var v_start as int format "999999" init 0.
def var v_end   as int format "999999" init 0.
def var v_usercode as char.

v_usercode = global_userid.
v_lot2 = 0.
v_start = 1.

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "XF" + v_usercode and mpd_type = "00001" no-error.
if not avail mpd_det or mpd_tol <> "1" then do:
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00058" no-error.
   if avail mpd_det then v_lot1 = mpd_tol.
   
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00114" no-error.
   if avail mpd_det then v_start = int(mpd_tol).
   
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00115" no-error.
   if avail mpd_det then v_end = int(mpd_tol).
   
   /*Get next shiplotno*/
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00116" no-error.
   if avail mpd_det then v_lot2 = int(mpd_tol).
   if v_lot2 < v_start then v_lot2 = v_start.

   v_shiplot = string(v_lot1,"x(7)") + "-" + string(v_lot2,"999999").

   /*Update Next ShipLotNo*/
   if v_lot2 >= v_end then v_lot2 = v_start.
   else v_lot2 = v_lot2 + 1.
   
   find first mpd_det where mpd_domain = global_domain
       and mpd_nbr = "X7" + v_part and mpd_type = "00116" exclusive-lock no-error.
   if avail mpd_det then do:
      assign mpd_tol = string(v_lot2,">>>>>9").
   end.
   release mpd_det.
   
end.
else do:
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "XF" + v_usercode and mpd_type = "00002" no-error.
   if avail mpd_det then v_lot1 = mpd_tol.
   
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "XF" + v_usercode and mpd_type = "00013" no-error.
   if avail mpd_det then v_start = int(mpd_tol).
   
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "XF" + v_usercode and mpd_type = "00014" no-error.
   if avail mpd_det then v_end = int(mpd_tol).
   
   /*Get next shiplotno*/
   find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "XF" + v_usercode and mpd_type = "00015" no-error.
   if avail mpd_det then v_lot2 = int(mpd_tol).
   if v_lot2 < v_start then v_lot2 = v_start.

   v_shiplot = string(v_lot1,"x(7)") + "-" + string(v_lot2,"999999").

   /*Update Next ShipLotNo*/
   if v_lot2 >= v_end then v_lot2 = v_start.
   else v_lot2 = v_lot2 + 1.

   find first mpd_det where mpd_domain = global_domain
        and mpd_nbr = "XF" + v_usercode and mpd_type = "00015" exclusive-lock no-error.
   if avail mpd_det then do:
      assign mpd_tol = string(v_lot2,">>>>>9").
   end.
   release mpd_det.
end.  /*else do*/
