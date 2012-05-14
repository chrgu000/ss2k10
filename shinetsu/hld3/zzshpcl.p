/*zzshpcl.p   Ship Weight Preparation Cancel*/
/*Last Modify by Leo Zhou   03/09/2012  */

{mfdeclre.i}

def input parameter v_recid  as recid.
def input parameter v_status as char.
def output parameter v_ok as log.
def var v_key2    as char format "x(16)".
def var v_seq     as char.
def var v_start   as char.
def var v_end     as char.
def var v_shiplot as char.
def var v_part    as char.
def var v_file    as char.
def var i         as int.
def var v_msg     as char format "x(20)".
def var v_totwt   as deci.

v_ok = no.
v_part = "".
v_shiplot = "".

find first usrw_wkfl where recid(usrw_wkfl) = v_recid no-error.
/***
find last usrw_wkfl no-lock where usrw_domain = global_domain
     and usrw_key1 = "PRE_SHIP" and usrw_key2 = v_key2
     and usrw_decfld[2] <> 0  no-error.
***/
if not avail usrw_wkfl then do:
     /*No Ship Weight Schedule found*/
     {pxmsg.i &MSGNUM=4551 &ERRORLEVEL=3 &MSGARG1=v_key2}
     return.
end.

/*For no SPSB but finish schedule  *Mar 14 2012*/
if usrw_decfld[2] = 0 and usrw_charfld[15] = "1" then do:
   usrw_charfld[15] = "".
   v_ok = yes.
   return.
end.

v_key2 = usrw_key2.
v_part = substr(v_key2,7,6).

find last usrw_wkfl no-lock where usrw_domain = global_domain
     and usrw_key1 = "PRE_SPSB" and usrw_key2 begins v_key2 no-error.
if not avail usrw_wkfl then do:
     /*Did not find shippreparation detail data*/
     {pxmsg.i &MSGNUM=31021 &ERRORLEVEL=3}
     return.
end.
else do:
    v_seq   = usrw_key3.
    v_start = usrw_charfld[1].
    v_end   = usrw_charfld[2].
end.

v_file = "/tmp/cl_" + string(year(today),"9999") 
         + string(month(today),"99") + string(day(today),"99") 
	 + string(time) + ".txt".

output to value(v_file).
put unformatted today " " string(time,"HH:MM:SS") "  Key2:" v_key2 "  Seq:" v_seq
    "  StartShipLot:" v_start "  EndShipLot:" v_end "  By:" global_userid skip.

do i = int(entry(2, v_start, "-")) to int(entry(2, v_end, "-")) :
   v_shiplot = entry(1, v_start, "-") + "-" + string(i,"999999").
   put unformatted "   ShipLotNo:" v_shiplot.
   for each zzsellot_mstr where zzsellot_domain = global_domain
        and zzsellot_shiplotno = v_shiplot and zzsellot_final = "1" :
       for each usrw_wkfl where usrw_domain = global_domain
            and usrw_key1 = "HIST_DAT"
            and usrw_key2 = zzsellot_lotno:
	   delete usrw_wkfl.
       end.
       put "  HIST_DAT ".

       /**************
       for each usrw_wkfl where usrw_domain = global_domain
            and usrw_key1 = "DEF_MAP"
            and usrw_key2 = zzsellot_lotno:
	   delete usrw_wkfl.
       end.
       put "  DEF_MAP ".
       **************/

       find first lot_mstr where lot_domain = global_domain
	     and lot_serial = zzsellot_lotno and lot_part = "zzlot2" 
	     and lot__chr02 = "230" exclusive-lock no-error.
       if avail lot_mstr then
          assign lot__chr02 = v_status.

       put "  Status:" v_status.

       assign zzsellot_shiplotno = ""
              zzsellot_shipplan_ym = ""
	      zzsellot_shipplan_num = 0
	      zzsellot_shipwtprep_num = 0
	      zzsellot_shiplotwt = 0
	      zzsellot_packsegup = ""
	      zzsellot_packsegdw = "".
       put " zzsellot_mstr." .
   end.
   put skip.
end.   /*do i=*/

/*Reset PRE_SPSB*/
v_totwt = 0.
for last usrw_wkfl where usrw_domain = global_domain
     and usrw_key1 = "PRE_SPSB" and usrw_key2 begins v_key2:
    v_totwt = usrw_decfld[2].
    delete usrw_wkfl.
    put "  PRE_SPSB ".
end.

/*Reset PRE_SHIP*/
find first usrw_wkfl where recid(usrw_wkfl) = v_recid no-error.
if avail usrw_wkfl then do:
    assign usrw_decfld[2] = max(usrw_decfld[2] - v_totwt, 0).
           usrw_charfld[15] = "".
    put "  PRE_SHIP ".
end.

/*Reset the next shiplotno*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "XF" + global_userid and mpd_type = "00001" no-error.
if not avail mpd_det or mpd_tol <> "1" then do:
   find first mpd_det where mpd_domain = global_domain
       and mpd_nbr = "X7" + v_part and mpd_type = "00116" exclusive-lock no-error.
   if avail mpd_det then do:
      put "  ShipSeqFrom:" mpd_tol " To:" entry(2, v_start, "-").
      assign mpd_tol = entry(2, v_start, "-").
   end.
   release mpd_det.
end.
else do:
   find first mpd_det where mpd_domain = global_domain
        and mpd_nbr = "XF" + global_userid and mpd_type = "00015" exclusive-lock no-error.
   if avail mpd_det then do:
      put "  ShipSeqFrom:" mpd_tol " To:" entry(2, v_start, "-").
      assign mpd_tol = entry(2, v_start, "-").
   end.
   release mpd_det.
end.

put skip.
put "ShipWeightPreparation Cancel Complete. " string(time,"HH:MM:SS") skip.

v_ok = yes.
