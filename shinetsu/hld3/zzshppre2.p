/*zzshppre1.p   Ship Weight Preparation */
/*Last Modify by Leo Zhou   11/08/2011 */

{mfdtitle.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

def var v_part       as char format "x(6)".
def var v_desc       as char format "x(24)".
def var v_sel        as char format "x(12)".
def var v_seldesc    as char format "x(36)".
def var v_period     as int  format "999999".
def var v_count      as int  format ">>9".
def var v_seq        as int  format ">>9".
def var v_usr_seq    as int  format ">>9".
def var v_finish     as char format "x(4)".
def var v_normal_wt  as deci format ">>,>>>,>>9.9".
def var v_normal_qty as int  format ">>9".
def var v_defect_wt  as deci format ">>,>>>,>>9.9".
def var v_defect_qty as int  format ">>9".
def var v_star_wt    as deci format ">>,>>>,>>9.9".
def var v_star_qty   as int  format ">>9".
def var v_avail_wt   as deci format ">>,>>>,>>9.9".
def var v_avail_qty  as int  format ">>9".
def var v_comp_wt    as deci format ">>,>>>,>>9.9".
def var v_reserve_wt as deci format ">>,>>>,>>9.9".
def var v_reserve_qty as int format ">>9".
def var v_hold_wt    as deci format ">>,>>>,>>9.9".
def var v_hold_qty   as int  format ">>9".
def var v_notspec_wt as deci format ">>,>>>,>>9.9".
def var v_notspec_qty as int format ">>9".
def var v_plan_wt    as deci format ">>,>>>,>>9.9".
def var v_remain_wt  as deci format ">>,>>>,>>9.9".
def var v_result_wt  as deci format ">>,>>>,>>9.9".
def var v_result_qty as int  format ">>9".
def var v_ship_wt    as deci format ">>,>>>,>>9.9".
def var v_ship_qty   as int  format ">>9".
def var v_new_month  as int  format ">>>>>9".
def var v_new_count  as int  format ">9" init 1.
def var v_new_part   as char format "x(6)".
def var v_new_seq    as int  format ">9" init 1.
def var v_shiplot    as char format "x(14)".
def var v_flag       as char format "x".   /*Action Flag*/
def var v_excel      as char.
def var v_yn         as log.
def var v_result     as log.
def var v_fmdir      as char.
def var v_todir      as char.
def var v_key2       as char.
def var v_totwt      as deci.
def var v_totqty     as int.
def var v_first_lot  as char.
def var v_last_lot   as char.
def var v_charfld4   as char.
def var v_exceed     as char.
def var v_sort       as char.
def var v_defect     as log.
def var v_leave      as log.
def var v_loc        as char.
def var v_progress   as char.

/*Define temp-table tt, wf*/
{zzshdef1.i "new"}

def var x1 as char format "x".
def var i  as int.

v_new_month = year(today) * 100 + month(today).
/*v_seldesc =  GetTermLabel("SHP_LBL1",36). */
v_finish  =  GetTermLabel("SHP_LBL2",36).  /*完成*/

def temp-table wk
    field wk_lotno  like ld_lot
    field wk_flag   as int format "9"
    field wk_qty    like ld_qty_oh
    index wk_indx wk_flag.

def temp-table t1
    field t1_lotno like ld_lot.

def temp-table t2 
    field t2_lotno like ld_lot.

def var l-focus as widget-handle no-undo. 


form
    v_part v_desc no-label v_sel /*v_seldesc no-label*/
    v_period no-label v_count no-label v_seq no-label 
                      v_finish no-label  v_exceed no-label
    v_normal_wt  colon 18  space(2) v_normal_qty  no-label
    v_reserve_wt colon 55  space(2) v_reserve_qty no-label
    v_defect_wt  colon 18  space(2) v_defect_qty  no-label
    v_hold_wt    colon 55  space(2) v_hold_qty    no-label
    v_star_wt    colon 18  space(2) v_star_qty    no-label
    v_notspec_wt colon 55  space(2) v_notspec_qty no-label
    v_avail_wt   colon 18  space(2) v_avail_qty   no-label
    v_plan_wt    colon 55
    v_comp_wt    colon 18
    v_remain_wt  colon 55
    v_ship_wt    colon 18  space(2) v_ship_qty   no-label
    v_result_wt  colon 55  space(2) v_result_qty no-label
with frame a side-labels col 1 width 100 .
setframelabels(frame a:handle). 


define button btn-ship    size 12 by 1 label "Preparation".
define button btn-hist    size 14 by 1 label "Create Histogram".
define button btn-replace size 8  by 1 label "Replace". 
define button btn-exec    size 10 by 1 label "Execute". 
define button btn-cancel  size 8  by 1 label "Cancel".
define button btn-req     size 15 by 1 label "Required".
define button btn-except  size 15 by 1 label "Except".
define button btn-finish  size 8  by 1 label "Finish".


form
   tt_key1 label "M"   format "Y/N"
   tt_key2 label "Ex"  format "Y/N"
   tt_lotno label "OVDLotNo" format "x(15)"
   tt_def  label "Def" format "x(1)"
   tt_star label "☆"  format "x(1)"
   tt_mfd  label "MFD" format ">9.99"
   tt_lc   label "Lc"  format ">,>>9"
   tt_l0   label "L0"  format ">,>>9.9"
   tt_dia  label "Dia" format ">>9.9"
   tt_efflen  label "EffLen" format ">,>>9"
   tt_totwt
   tt_calwt
   tt_diavar  label "DiaChg"
   tt_dn    label "DN" 
   tt_ecc   label "ECC"
   tt_bow   label "BOW"
   tt_ellip label "Ratio"
   tt_bubb label "Bub" format "x(1)"
   with frame b 8 down scroll 1 width 118 no-box .
setframelabels(frame b:handle).


form
      btn-ship space btn-hist space btn-replace space btn-exec space 
      btn-cancel space btn-req space btn-except space btn-finish 
with frame c side-labels width 152 no-box.
setframelabels(frame c:handle).

l-focus = btn-ship:handle in frame c .


form skip(1)
     v_new_month colon 20
     v_new_count colon 20
     v_new_part  colon 20
     v_new_seq   colon 20
     skip(1)
with frame g side-labels row 6 width 70 title " Replace " overlay centered. 

v_loc = "".
v_progress = "".

find first code_mstr no-lock where code_domain = global_domain
     and code_fldname = "ZZ_SHIPWPRE_LOCATION" 
     and code_value = "SHIP" no-error.
if avail code_mstr then v_loc = trim(code_cmmt).

find first code_mstr no-lock where code_domain = global_domain
     and code_fldname = "ZZ_SHIPWPRE_PROGRESS" 
     and code_value = "SHIP" no-error.
if avail code_mstr then v_progress = trim(code_cmmt).

if v_loc = "" or v_progress = "" then do:
   hide message no-pause.
   {pxmsg.i &MSGNUM=31015 &ERRORLEVEL=3}
   pause.
   return.
end.

find first code_mstr no-lock where code_domain = global_domain
     and code_fldname = "ZZ_SHIPWPRE_SEL" 
     and code_cmmt = global_user_lang no-error.
if avail code_mstr then v_sel = code_value.
   

view frame a.


status input off .

v_flag = "".

/*Ship Preparation*/
on 'choose':u of btn-ship
do:
    hide message no-pause.
    if v_flag <> "" then do:
       /*Can not perform this action*/
       {pxmsg.i &MSGNUM=31003 &ERRORLEVEL=3}
       return.
    end.

    v_totwt = 0.
    v_totqty = 0.
    for each tt no-lock where tt_key1 = yes:
        v_totwt = v_totwt + tt_calwt.
	v_totqty = v_totqty + 1.
    end.

    /*****
    if v_totwt > v_ship_wt or
       v_totwt > v_remain_wt or
       v_totqty > v_ship_qty and v_ship_qty <> 0 then do:
       /*  必选重量大于出库重量或剩余重量/根数  */
       {pxmsg.i &MSGNUM=31002 &ERRORLEVEL=3}
       return.
    end.
    ****/

    /*Debug ONLY*/
    output to shtt1.txt.
    for each tt no-lock:
	disp tt with frame zz width 220 no-box down.
	down with frame zz.
    end.
    output close.
    /*Debug ONLY*/

    v_result = no.
    /*Ship Weight Preparation*/
    {gprun.i ""zzshpcrt1.p"" "(v_key2, v_part,
                               v_ship_wt, v_ship_qty, 
                               output v_result,
			       output v_result_wt,
			       output v_result_qty)"}
    
    if v_result = yes then do:
        /*Ship weight preparation complete.*/
	{pxmsg.i &MSGNUM=31004 &ERRORLEVEL=1}
        v_flag = "1".
	disp v_result_wt v_result_qty with frame a.
	
	/*Display the result only*/
	for each tt where tt_key3 <> "1":
	    delete tt.
	end.

        /*Debug ONLY*/
        output to shtt1.txt append.
        put skip(2) "Result: " v_result_wt "  " v_result_qty skip.
	for each tt no-lock:
	    disp tt with frame zz2 width 220 no-box down.
	    down with frame zz2.
        end.
        output close.
        /*Debug ONLY*/
    end.
    else do:
	/*Ship weight preparation failed.*/
	{pxmsg.i &MSGNUM=31005 &ERRORLEVEL=1}
	v_flag = "".
	v_result_wt = 0.
	v_result_qty = 0.
	
	/*Undo*/
	for each tt where tt_key3 = "1":
	    assign tt_key3 = "".
	end.
	empty temp-table wf.
    end.
    /*return . */
end.

on 'choose':u of btn-hist
do:
    hide message no-pause.
    if v_flag <> "1" then do:
       /*Can not create histogram,unless clicked on "ship preparation" button.*/
       {pxmsg.i &MSGNUM=31001 &ERRORLEVEL=3}
       return.
    end.

    /*Copy Excel template to */
    find first code_mstr no-lock where code_domain = global_domain
         and code_fldname = "ZZ_SHIPWPRE_HISTOGRAM_TEMP"
	 and code_value = "" no-error.
    if not avail code_mstr then do:
        /*Can not found directory for histogram template*/
	{pxmsg.i &msgnum=31006 &errorlevel=3}
	return.
    end.

    v_excel = substring(v_part,1,6) + "_G.xlsm".

    if substr(trim(code_cmmt), length(trim(code_cmmt)) - 1,1) <> "/" then
         v_fmdir = code_cmmt + "/" + v_excel.
    else v_fmdir = code_cmmt + v_excel.

    find first code_mstr no-lock where code_domain = global_domain
         and code_fldname = "ZZ_SHIPWPRE_HISTOGRAM_SAVE"
	 and code_value = "" no-error.
    if not avail code_mstr then do:
	/*Can not found directory for histogram saved*/
	{pxmsg.i &msgnum=31007 &errorlevel=3}
	return.
    end.

    v_todir = code_cmmt.

    unix silent cp value(v_fmdir) value(v_todir) .

    /*Open Excel file (How to open Excel file?)*/
    /*{pxmsg.i &msgnum=31000 &errorlevel=1 &MSGARG1=v_excel} */

    v_first_lot = "".
    v_last_lot = "".
    v_totwt = 0.
    /*for each wf by wf_lotno:*/
    for each tt where tt_key3 = "1":
	/*Call shiplot generate program*/
	{gprun.i ""zzcrtshlot.p"" "(v_part, output v_shiplot)"}
	/*wf_shiplot = v_shiplot. */
	v_totwt = v_totwt + tt_calwt.

	if v_first_lot = "" then v_first_lot = v_shiplot.
	v_last_lot = v_shiplot.

	/*Update zzsellot_mstr*/
	find first zzsellot_mstr where zzsellot_domain = global_domain
	     and zzsellot_lotno = tt_lotno and zzsellot_final = "1"
	     exclusive-lock no-error.
	if avail zzsellot_mstr then do:
           assign zzsellot_shiplotno = v_shiplot
	          zzsellot_shipplan_ym = string(v_period,"999999")
		  zzsellot_shipplan_num = v_count
		  zzsellot_shipwtprep_num = v_usr_seq + 1
		  zzsellot_shiplotwt = tt_calwt
		  zzsellot_packsegup = ""
		  zzsellot_packsegdw = "".
	end.

        /*Histogram */
        create usrw_wkfl.
        assign usrw_domain = global_domain
               usrw_key1 = "HIST_DAT"
	       usrw_key2 = tt_lotno
	       usrw_key3 = "2"
	       usrw_key4 = v_part
	       usrw_charfld[1] = global_userid.
    end.

    /*Find last user sequence*/
    for last usrw_wkfl no-lock where usrw_domain = global_domain
         and usrw_key1 = "PRE_SPSB" and usrw_key2 begins v_key2
	 and int(usrw_key3) = v_seq
	 by int(substr(usrw_key2,15,2)):
	v_usr_seq = int(substr(usrw_key2,15,2)).
    end.

    /*Shipment Detail Record*/
    create usrw_wkfl.
    assign usrw_domain = global_domain
           usrw_key1 = "PRE_SPSB"
	   usrw_key2 = v_key2 + string(v_usr_seq + 1,"99")
	   usrw_key3 = string(v_seq,"99")
	   usrw_charfld[1] = v_first_lot
	   usrw_charfld[2] = v_last_lot
	   usrw_charfld[3] = string(year(today),"9999") + "/" +
	                     string(month(today),"99") + "/" +
			     string(day(today),"99")
	   usrw_charfld[4] = v_charfld4
	   usrw_charfld[5] = if v_totwt >= v_remain_wt then "1" else ""
	   usrw_decfld[1] = v_plan_wt .

    if v_defect = yes then do:
       for each tt where tt_key3 = "1" 
            and tt_def = "*" by tt_lotno:
	   create usrw_wkfl.
	   assign usrw_domain = global_domain
		  usrw_key1 = "DEF_MAP"
		  usrw_key2 = tt_lotno
		  usrw_key3 = v_part
		  usrw_charfld[1] = global_userid.
       end.
    end.

    /*Clear temp-table tt*/
    for each tt where tt_key3 = "1":
        delete tt.
    end.

    /*Update remain information*/
    

end.  /*btn-hist*/

on 'choose':u of btn-replace
do:
  hide message no-pause.
  v_flag = "2".

  repeat:
    /**/
    update v_new_month  v_new_count  with frame g.

    if truncate(v_new_month / 100, 0) < 2011 or 
       truncate(v_new_month / 100, 0) > year(today) + 1 or
       v_new_month mod 100 < 1 or v_new_month mod 100 > 12 or
       v_new_count < 0 or v_new_count > 99 then do:
       /*Invalid period*/
       {pxmsg.i &msgnum=495 &errorlevel=3 }
       next.
    end.
    
    repeat:
        update v_new_part  v_new_seq with frame g.
    
        find first pt_mstr where pt_domain = global_domain and pt_part = v_new_part no-lock no-error.
        if not avail pt_mstr then do:
	   /*Invalid Item*/
           {pxmsg.i &msgnum=10533 &errorlevel=3 }
           next.
	end.

	if v_new_seq < 0 then do:
	   /*Invalid sequence*/
           {pxmsg.i &msgnum=2818 &errorlevel=3 }
           next.
	end.
	leave.
    end.

    leave.
  end.  /*repeat*/

  /***Find shipping schedule***/
    v_normal_wt = 0.
    v_normal_qty = 0.
    v_defect_wt = 0.
    v_defect_qty = 0.
    v_star_wt = 0.
    v_star_qty = 0.
    v_avail_wt = 0.
    v_avail_qty = 0.
    v_comp_wt = 0.
    v_reserve_wt = 0.
    v_reserve_qty = 0.
    v_hold_wt = 0.
    v_hold_qty = 0.
    v_notspec_wt = 0.
    v_notspec_qty = 0.
    v_plan_wt = 0.
    v_remain_wt = 0.
    v_result_wt = 0.
    v_result_qty = 0.
    v_desc = "".

    v_period = 0.
    v_key2 = "".
    v_charfld4 = "".
    v_exceed = "".

    /**Find the first Open schedule**/
    for first usrw_wkfl no-lock where usrw_domain = global_domain
          and usrw_key1 = "PRE_SHIP"
	  and substr(usrw_key2,7,6) = v_part
          and usrw_charfld[15] <> "1"
	  by int(substr(usrw_key2,1,6)) 
	  by int(usrw_key3)
	  by int(substr(usrw_key2,13,2)):
	v_finish = "".
        v_period = int(substr(usrw_key2,1,6)).
        v_count  = int(substr(usrw_key2,13,2)).
        v_seq    = int(usrw_key3).
	v_plan_wt = usrw_decfld[1].
	v_comp_wt = usrw_decfld[2].   /* shipped qty */
	v_remain_wt = v_plan_wt - v_comp_wt .
	v_key2 = usrw_key2.
	v_charfld4 = usrw_charfld[4].    /* over weight flag */
    end.

    if v_charfld4 = "1" then v_exceed = GetTermLabel("SHP_LBL41",10).
    if v_charfld4 = "2" then v_exceed = GetTermLabel("SHP_LBL42",10).

    if v_period = 0 then do:
       /*No Shipping Schedule found*/
       {pxmsg.i &msgnum=4551 &errorlevel=3}
       next.
    end.

    disp v_period v_count v_seq v_exceed with frame a.

    /*Get Normal Inventory*/
    for each ld_det where ld_domain = global_domain
        and ld_part = v_part + "-05" and ld_loc = v_loc:
	find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot2" 
	     and lot__chr02 = v_progress no-lock no-error.
	if not avail lot_mstr then next.

	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = ld_lot
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr then next.

	/*Specification Check*/
	v_result = no.
	{gprun.i ""zzspechk.p"" "(ld_lot, '', v_part, output v_result)"} 

        /*v_result = yes. *TEST ONLY*/

	create wk.
	assign wk_lotno = ld_lot
	       wk_flag  = 0
	       wk_qty   = /*ld_qty_oh */ zzsellot_insp_goodweight .

	if v_result = no then do:
	   wk_flag = 7.    /* Out of specification */
	end.
	else do:

	  /*Status Check*/
	  find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot1" 
	     no-lock no-error.
	  if avail lot_mstr then do:
	    if lot__chr02 = "1" then wk_flag = 6.   /*出货禁止品*/
	    else if lot__chr03 <> "1" or lot__chr04 <> "1" or 
	       lot__chr05 <> "1" or lot__chr06 <> "1" 
	       then wk_flag = 5.   /*出库保留品*/
	    else wk_flag = 2. /*通常品*/
          end.
	  
	  if wk_flag = 0 or wk_flag = 2 then do:
	     if zzsellot_insp_defect = "*" then wk_flag = 4.
	     else if zzsellot_insp_star = "*" then  wk_flag = 3.
	  end.

	  if wk_flag = 0 then wk_flag = 2.

	end.  /*v_result = no*/

    end.  /*for each ld_det*/

    /*****
    for each wk:
        if v_sel begins "2" and wk_flag <> 2 then delete wk.
	if v_sel begins "3" and wk_flag <> 3 then delete wk.
	if v_sel begins "4" and wk_flag <> 4 then delete wk.
    end.
    *****/

    for each wk :
	if wk_flag = 2 then 
	   assign v_normal_wt  = v_normal_wt + wk_qty
	          v_normal_qty = v_normal_qty + 1.
	else if wk_flag = 3 then 
	   assign v_star_wt  = v_star_wt + wk_qty
	          v_star_qty = v_star_qty + 1.
	else if wk_flag = 4 then 
	   assign v_defect_wt  = v_defect_wt + wk_qty
	          v_defect_qty = v_defect_qty + 1.
	else if wk_flag = 5 then  /*  保留品  */
	   assign v_reserve_wt  = v_reserve_wt + wk_qty
	          v_reserve_qty = v_reserve_qty + 1.
	else if wk_flag = 6 then  /*  禁止品  */
	   assign v_hold_wt  = v_hold_wt + wk_qty
	          v_hold_qty = v_hold_qty + 1.
	else if wk_flag = 7 then  /*  规格外品  */
	   assign v_notspec_wt  = v_notspec_wt + wk_qty
	          v_notspec_qty = v_notspec_qty + 1.
    end.  /*for each wk*/

    v_avail_wt = v_avail_wt + v_normal_wt + v_defect_wt + v_star_wt.
    v_avail_qty = v_avail_qty + v_normal_qty + v_defect_qty + v_star_qty.

    v_result_wt = 0.
    v_result_qty = 0.

    /*************************************/

    disp v_normal_wt  v_normal_qty
	v_reserve_wt  v_reserve_qty 
	v_defect_wt   v_defect_qty
	v_hold_wt     v_hold_qty
	v_star_wt     v_star_qty
	v_notspec_wt  v_notspec_qty 
	v_avail_wt    v_avail_qty 
	v_plan_wt   
	v_comp_wt  
	v_remain_wt 
	v_ship_wt     v_ship_qty 
	v_result_wt   v_result_qty 
    with frame a.

    empty temp-table t1.
    empty temp-table t2.

    /*Find Original Data*/
    for each usrw_wkfl no-lock where usrw_domain = global_domain
         and usrw_key1 = "HIST_DAT" and usrw_key2 = v_key2
	 and usrw_key3 = "2":
	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = wk_lotno
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr then next.

	create tt.
        assign 
	   tt_key1 = yes
           tt_key2 = no
	   tt_key3 = ""
	   tt_lotno  = wk_lotno
	   tt_def    = zzsellot_insp_defect
	   tt_star   = zzsellot_insp_star
	   tt_mfd    = zzsellot_insp_mfd
	   tt_lc     = zzsellot_insp_cutoff
	   tt_l0     = zzsellot_insp_zdw
	   tt_dia    = zzsellot_insp_dia
	   tt_efflen = zzsellot_insp_efflength
	   tt_totwt  = zzsellot_insp_diviedweight
	   tt_calwt  = zzsellot_insp_calcweight
	   tt_diavar = zzsellot_insp_diavar
	   tt_dn     = zzsellot_insp_dn
	   tt_ecc    = zzsellot_insp_ecc
	   tt_bow    = zzsellot_insp_bow
	   tt_ellip  = zzsellot_insp_noncirc
	   tt_bubb   = zzsellot_insp_bubble.

	if tt_def  = ? then tt_def  = "".
	if tt_star = ? then tt_star = "".
	if tt_mfd  = ? then tt_mfd  = 0.
	if tt_dia  = ? then tt_dia  = 0.
	if tt_bubb = ? then tt_bubb = "".
    end.

    /*Find New Availabel Inventory*/
    for each wk where wk_flag = 2 or wk_flag = 3 or wk_flag = 4 :
	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = wk_lotno
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr then next.

        create tt.
        assign 
	   tt_key1 = no
           tt_key2 = no
	   tt_key3 = ""
	   tt_lotno  = wk_lotno
	   tt_def    = zzsellot_insp_defect
	   tt_star   = zzsellot_insp_star
	   tt_mfd    = zzsellot_insp_mfd
	   tt_lc     = zzsellot_insp_cutoff
	   tt_l0     = zzsellot_insp_zdw
	   tt_dia    = zzsellot_insp_dia
	   tt_efflen = zzsellot_insp_efflength
	   tt_totwt  = zzsellot_insp_diviedweight
	   tt_calwt  = zzsellot_insp_calcweight
	   tt_diavar = zzsellot_insp_diavar
	   tt_dn     = zzsellot_insp_dn
	   tt_ecc    = zzsellot_insp_ecc
	   tt_bow    = zzsellot_insp_bow
	   tt_ellip  = zzsellot_insp_noncirc
	   tt_bubb   = zzsellot_insp_bubble.

        if tt_def  = ? then tt_def  = "".
	if tt_star = ? then tt_star = "".
	if tt_mfd  = ? then tt_mfd  = 0.
	if tt_dia  = ? then tt_dia  = 0.
	if tt_bubb = ? then tt_bubb = "".
    end.  /*for each wk*/

  /***********************/

  /*********
  empty temp-table t1.
  empty temp-table t2.

  for each tt:
      if tt_key1 = yes then do:
         create t1.
         assign t1_lotno = tt_lotno.
      end.
      else do:
         create t2.
         assign t2_lotno = tt_lotno.
      end.
  end.
  *********/

  hide frame g no-pause.
  return.
end.   /*btn-replace*/

on 'choose':u of btn-exec
do:
    hide message no-pause.
    if v_flag <> "2" then do:
       /*Can not use this founction*/
       {pxmsg.i &MSGNUM=7694 &errorlevel=3}
    end.
    else do:
       /*l-focus = self:handle. */
       for each tt:
           if tt_key1 = no then do:
	       find first t1 where t1_lotno = tt_lotno no-error.
	       if avail t1 then do:
	       end.
	   end.
       end.
    end.

    return.
end.

on 'choose':u of btn-cancel
do: 
    hide message no-pause.
    /*Cancel*/
    v_yn = no.
    {pxmsg.i &MSGNUM=6467 &ERRORLEVEL=1 &CONFIRM=v_yn}
    if v_yn then do:
	/*Undo transaction*/
	/*Empty temp-table*/
	empty temp-table tt.
	empty temp-table t1.
	empty temp-table t2.
	empty temp-table wk.
	v_result_wt = 0.
	v_result_qty = 0.
	/*Refresh screen*/
	v_flag = "".
    end.
    return.
end.

on 'choose':u of btn-req
do: 
    if v_flag = "" then do:
	/*Refresh screen*/
       v_sort = "tt_idx1".
    end.
    return.
end.

on 'choose':u of btn-except
do: 
    if v_flag = "" then do:
       /*Refresh screen*/
       v_sort = "tt_idx2".
       /*l-focus = self:handle. */
    end.
    return.
end.

on 'choose':u of btn-finish
do: 
    /*Finish*/
    v_yn = no.
    {pxmsg.i &MSGNUM=175 &ERRORLEVEL=1 &CONFIRM=v_yn}
    
    if v_yn then do:
       /*Update flag*/
       find first usrw_wkfl where usrw_domain = global_domain
          and usrw_key1 = "PRE_SHIP" and usrw_key2 = v_key2
	  and int(usrw_key3) = v_seq no-error.
       if avail usrw_wkfl then do:
          assign usrw_charfld[15] = "1".
          for last usrw_wkfl where usrw_domain = global_domain
              and usrw_key1 = "PRE_SPSB"
	      and usrw_key2 = v_key2 + string(v_usr_seq + 1,"99")
	      and int(usrw_key3) = v_seq :
              assign usrw_charfld[5] = "1".
          end.
       end. /*usrw_wkfl*/
       else do:
	    /*Update failed.*/
            {pxmsg.i &MSGNUM=31009 &ERRORLEVEL=3}
       end.
    end.    /*v_yn*/
    return.
end.  /*btn-finish*/


v_ship_wt = v_remain_wt.

main-loop:
repeat:

    empty temp-table tt.
    empty temp-table wk.
    v_normal_wt  = 0.
    v_normal_qty = 0.
    v_defect_wt  = 0.
    v_defect_qty = 0.
    v_star_wt  = 0.
    v_star_qty = 0.
    v_avail_wt = 0.
    v_avail_qty = 0.
    v_comp_wt = 0.
    v_reserve_wt  = 0.
    v_reserve_qty = 0.
    v_hold_wt  = 0.
    v_hold_qty = 0.
    v_notspec_wt = 0.
    v_notspec_qty = 0.
    v_plan_wt   = 0.
    v_remain_wt = 0.
    v_result_wt = 0.
    v_result_qty = 0.
    v_desc = "".

    v_flag = "".
    hide frame b no-pause.
    hide frame c no-pause.
    hide frame g no-pause.

    update v_part with frame a.
    
    find first pt_mstr where pt_domain = global_domain 
        and pt_part = v_part no-lock no-error.
    if not avail pt_mstr then do:
	/*Item number does not exists.*/
	{pxmsg.i &msgnum=16 &errorlevel=3}
	next.
    end.

    v_desc = pt_desc1.
    disp v_desc with frame a.

    find first mpd_det where mpd_domain = global_domain
         and mpd_nbr = "X7" + v_part and mpd_type = "00109"
	 and mpd_tol = "1" no-lock no-error.
    if not avail mpd_det then do:
	/*Invalid item.*/
	{pxmsg.i &msgnum=10533 &errorlevel=3}
	next.
    end.

    update v_sel with frame a.

    if int(substr(v_sel,1,1)) < 1 or int(substr(v_sel,1,1)) > 4 then do:
	/*Selected type is invalid.*/
	{pxmsg.i &msgnum=5332 &errorlevel=3}
	next.
    end.
    
    v_period = 0.
    v_key2 = "".
    v_charfld4 = "".
    v_exceed = "".

    /**Find the first Open schedule**/
    for first usrw_wkfl no-lock where usrw_domain = global_domain
          and usrw_key1 = "PRE_SHIP"
	  and substr(usrw_key2,7,6) = v_part
          and usrw_charfld[15] <> "1"
	  by int(substr(usrw_key2,1,6)) 
	  by int(usrw_key3)
	  by int(substr(usrw_key2,13,2)):
	v_finish = "".
        v_period = int(substr(usrw_key2,1,6)).
        v_count  = int(substr(usrw_key2,13,2)).
        v_seq    = int(usrw_key3).
	v_plan_wt = usrw_decfld[1].
	v_comp_wt = usrw_decfld[2].   /* shipped qty */
	v_remain_wt = v_plan_wt - v_comp_wt .
	v_key2 = usrw_key2.
	v_charfld4 = usrw_charfld[4].    /* over weight flag */
    end.

    if v_charfld4 = "1" then v_exceed = GetTermLabel("SHP_LBL41",10).
    if v_charfld4 = "2" then v_exceed = GetTermLabel("SHP_LBL42",10).

    if v_period = 0 then do:
       /*No Shipping Schedule found*/
       {pxmsg.i &msgnum=4551 &errorlevel=3}
       next.
    end.

    /***********
    v_period = 0.
    v_seq = 0.
    v_count = 0.
    for each usrw_wkfl no-lock where usrw_domain = global_domain
            and usrw_key1 = "PRE_SPSB"
	    and substr(usrw_key2,7,6) = v_part
	    break by int(substr(usrw_key2,1,6)) 
	    by int(usrw_key3)
	    by int(substr(usrw_key2,13,2)):
        if last-of(int(usrw_key3)) then do:
           if usrw_charfld[5] = "" then do:
	      v_finish = "".
              v_period = int(substr(usrw_key2,1,6)).
              v_seq = int(usrw_key3).
              v_count = int(substr(usrw_key2,13,2)).
	   end.
	end.
    end.

    if v_period = 0 then do:
   
    end.

    ***********/

    disp v_period v_count v_seq v_exceed with frame a.
   
    /********************************/
    /*Get Normal Inventory*/
    for each ld_det where ld_domain = global_domain
        and ld_part = v_part + "-05" and ld_loc = v_loc:
	find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot2" 
	     and lot__chr02 = v_progress no-lock no-error.
	if not avail lot_mstr then next.

	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = ld_lot
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr then next.

	/*Specification Check*/
	v_result = no.
	{gprun.i ""zzspechk.p"" "(ld_lot, '', v_part, output v_result)"} 

        v_result = yes. /*TEST ONLY*/

	create wk.
	assign wk_lotno = ld_lot
	       wk_flag  = 0
	       wk_qty   = /*ld_qty_oh */ zzsellot_insp_goodweight .

	if v_result = no then do:
	   wk_flag = 7.    /* Out of specification */
	end.
	else do:

	  /*Status Check*/
	  find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot1" 
	     no-lock no-error.
	  if avail lot_mstr then do:
	    if lot__chr02 = "1" then wk_flag = 6.   /*出货禁止品*/
	    else if lot__chr03 <> "1" or lot__chr04 <> "1" or 
	       lot__chr05 <> "1" or lot__chr06 <> "1" 
	       then wk_flag = 5.   /*出库保留品*/
	    else wk_flag = 2. /*通常品*/
          end.
	  
	  if wk_flag = 0 or wk_flag = 2 then do:
	     if zzsellot_insp_defect = "*" then wk_flag = 4.
	     else if zzsellot_insp_star = "*" then  wk_flag = 3.
	  end.

	  if wk_flag = 0 then wk_flag = 2.

	end.  /*v_result = no*/
    end.  /*for each ld_det*/

    /*******
    for each wk:
        if v_sel begins "2" and wk_flag <> 2 then delete wk.
	if v_sel begins "3" and wk_flag <> 3 then delete wk.
	if v_sel begins "4" and wk_flag <> 4 then delete wk.
    end.
    *******/

    for each wk :
	if wk_flag = 2 then 
	   assign v_normal_wt  = v_normal_wt + wk_qty
	          v_normal_qty = v_normal_qty + 1.
	else if wk_flag = 3 then 
	   assign v_star_wt  = v_star_wt + wk_qty
	          v_star_qty = v_star_qty + 1.
	else if wk_flag = 4 then 
	   assign v_defect_wt  = v_defect_wt + wk_qty
	          v_defect_qty = v_defect_qty + 1.
	else if wk_flag = 5 then  /*  保留品  */
	   assign v_reserve_wt  = v_reserve_wt + wk_qty
	          v_reserve_qty = v_reserve_qty + 1.
	else if wk_flag = 6 then  /*  禁止品  */
	   assign v_hold_wt  = v_hold_wt + wk_qty
	          v_hold_qty = v_hold_qty + 1.
	else if wk_flag = 7 then  /*  规格外品  */
	   assign v_notspec_wt  = v_notspec_wt + wk_qty
	          v_notspec_qty = v_notspec_qty + 1.
    end.  /*for each wk*/

    v_avail_wt = v_avail_wt + v_normal_wt + v_defect_wt + v_star_wt.
    v_avail_qty = v_avail_qty + v_normal_qty + v_defect_qty + v_star_qty.

    v_result_wt = 0.
    v_result_qty = 0.

    /*************************************/

    disp v_normal_wt  v_normal_qty
	v_reserve_wt  v_reserve_qty 
	v_defect_wt   v_defect_qty
	v_hold_wt     v_hold_qty
	v_star_wt     v_star_qty
	v_notspec_wt  v_notspec_qty 
	v_avail_wt    v_avail_qty 
	v_plan_wt   
	v_comp_wt  
	v_remain_wt 
	v_ship_wt     v_ship_qty 
	v_result_wt   v_result_qty 
    with frame a.

    v_ship_wt = min(v_remain_wt,v_avail_wt).
    
    loop_shipwt:
    repeat:
	
	update v_ship_wt v_ship_qty with frame a.

	if v_ship_wt > v_remain_wt or v_ship_wt > v_avail_wt then do:
	   /*Ship weight can not greater than the remaining weight.*/
	   {pxmsg.i &MSGNUM=31008 &ERRORLEVEL=3}
	   next.
	end.
	else if v_ship_wt <= 0 then do:
	   /*Ship weight must be greater than zero.*/
	   {pxmsg.i &MSGNUM=31016 &ERRORLEVEL=3}
	end.
	else leave.

    end.  /*loop_shipwt*/

    /*Fill temp-tabel tt*/
    /*{zzshppre1.i}*/

    for each wk where wk_flag = 2 or wk_flag = 3 or wk_flag = 4 :
	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = wk_lotno
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr then next.

        create tt.
        assign 
	   tt_key1 = no
           tt_key2 = no
	   tt_key3 = ""
	   tt_lotno  = wk_lotno
	   tt_def    = zzsellot_insp_defect
	   tt_star   = zzsellot_insp_star
	   tt_mfd    = zzsellot_insp_mfd
	   tt_lc     = zzsellot_insp_cutoff
	   tt_l0     = zzsellot_insp_zdw
	   tt_dia    = zzsellot_insp_dia
	   tt_efflen = zzsellot_insp_efflength
	   tt_totwt  = zzsellot_insp_diviedweight
	   tt_calwt  = zzsellot_insp_calcweight
	   tt_diavar = zzsellot_insp_diavar
	   tt_dn     = zzsellot_insp_dn
	   tt_ecc    = zzsellot_insp_ecc
	   tt_bow    = zzsellot_insp_bow
	   tt_ellip  = zzsellot_insp_noncirc
	   tt_bubb   = zzsellot_insp_bubble.

        if tt_def  = ? then tt_def  = "".
	if tt_star = ? then tt_star = "".
	if tt_mfd  = ? then tt_mfd  = 0.
	if tt_dia  = ? then tt_dia  = 0.
	if tt_bubb = ? then tt_bubb = "".
    end.  /*for each wk*/

    find first tt no-lock no-error.
    if not available tt then do:
	/*No record available.*/
	{pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
	undo, retry.
    end.

    v_sort = "tt_idx1".

    pause 0.

    loop1:
    repeat on end-key undo, leave loop1:

        /*Scroll Screen and update tt_key1 and tt_key2*/
	if v_sort = "tt_idx1" then do:
		{zzshscroll.i "tt_idx1"}
	end.
	else if v_sort = "tt_idx2" then do:
		{zzshscroll.i "tt_idx2"}
	end.
	else if v_sort = "tt_idx3" then do:
		{zzshscroll.i "tt_idx3"}
	end.
	else if v_sort = "tt_idx4" then do:
		{zzshscroll.i "tt_idx4"}
	end.

        /*find first tt use-index {1} no-lock no-error. */
        if not avail tt then leave. 
     
        enable btn-ship btn-hist btn-replace btn-exec 
	       btn-cancel btn-req btn-except btn-finish with frame c.
        
	repeat on end-key undo, next main-loop:
	        view frame c.
		v_leave = no.

		/*Refresh detail screen*/
		if v_sort = "tt_idx1" then do:
			{zzshpref.i "tt_idx1"}
		end.
		else if v_sort = "tt_idx2" then do:
			{zzshpref.i "tt_idx2"}
		end.
		else if v_sort = "tt_idx3" then do:
			{zzshpref.i "tt_idx3"}
		end.
		else if v_sort = "tt_idx4" then do:
			{zzshpref.i "tt_idx4"}
		end.

		wait-for GO of frame c or
	             choose of btn-ship, btn-hist, btn-replace,
	                       btn-exec, btn-cancel, btn-req,
			       btn-except, btn-finish /*focus l-focus*/ .
            
	        clear frame g all no-pause .
		find first tt no-lock no-error.
		if not avail tt then v_leave = yes.

		if v_leave then leave.
	end.  /*repeat*/

	if v_leave then leave.
            
    end.  /*repeat*/
    /************/

    hide frame c no-pause.
    hide frame b no-pause.
    hide frame g no-pause.
    pause before-hide.
      
end.   /*main-loop*/
