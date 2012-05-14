/*zzshppre1.p   Ship Weight Preparation */
/*Last Modify by Leo Zhou   11/08/2011  */
/*Last Modify by Leo Zhou   03/12/2012    *CLZ1*/
/*Last Modify by Leo Zhou   03/27/2012    *CLZ2*/

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
def var v_exceed     as char format "x(9)".
def var v_sort       as char.
def var v_defect     as log.
def var v_leave      as log.
def var v_ok         as log.
def var v_msg        as char format "x(28)".   /*CLZ1*/
def var v_recid      as recid.                 /*CLZ1*/
def var v_count1     as int.                   /*CLZ1*/
def var v_count2     as int.                   /*CLZ1*/
def var v_totwt1     as deci.                  /*CLZ1*/
def var v_totwt2     as deci.                  /*CLZ1*/
def var v_date       as date.                  /*CLZ1*/
def var v_lbl44      as char.                  /*CLZ1*/
def var v_printer    as char format "x(18)".   /*CLZ1*/
def var v_tmp        as char.                  /*CLZ1*/
def var v_tmp1       as char.                  /*CLZ1*/
def var v_tmp2       as int.                   /*CLZ1*/
def var v_tmp3       as int.                   /*CLZ1*/
def var v_tmp4       as deci.                  /*CLZ1*/
def var v_tmp5       as char.                  /*CLZ1*/
def var v_tmp6       as char.                  /*CLZ1*/
def var v_year       as int.                   /*CLZ2*/
def var v_last_month as int.                   /*CLZ2*/
def var v_loc        as char.
def var v_progress   as char.
def var v_flag2      as log.
def var v_i          as int.
def var v_c          as int.
def var v_pknbr      as int.
def var v_int        as int.
def var v_rem        as int.
def var v_up         as char.
def var v_down       as char.
def var v_final      as char.
def var v_max_var    as deci.
def var v_testfile   as char.   /*For TEST ONLY*/
def stream s1.                  /*For TEST ONLY*/

/*Define temp-table tt, wf*/
{zzshdef1.i "new"}

def var x1 as char format "x".
def var i  as int.

/*v_new_month = year(today) * 100 + month(today). */
/*v_seldesc =  GetTermLabel("SHP_LBL1",36). */
v_finish = GetTermLabel("SHP_LBL2",36).  /*Complete*/
v_lbl44  = GetTermLabel("SHP_LBL44",6).  /*Count*/

def temp-table wk
    field wk_lotno  like ld_lot
    field wk_flag   as int format "9"
    field wk_qty    like ld_qty_oh
    index wk_indx wk_flag.

def temp-table t1
    field t1_lotno like ld_lot.

def temp-table t2 
    field t2_lotno like ld_lot.

def temp-table th    /*CLZ2*/
    field th_lotno like ld_lot .

def var l-focus as widget-handle no-undo. 


form
    v_part colon 10 v_desc no-label   v_normal_wt colon 58 v_normal_qty no-label
    v_sel  colon 10 v_period no-label space(0) v_count no-label space(0) 
                    v_lbl44 no-label /*v_seq no-label */
                               v_defect_wt colon 58 v_defect_qty no-label
    v_plan_wt colon 18 v_exceed no-label
                               v_star_wt colon 58 v_star_qty no-label
    v_comp_wt colon 18         v_avail_wt colon 58 v_avail_qty no-label
    v_remain_wt colon 18       v_reserve_wt colon 58 v_reserve_qty no-label
    v_ship_wt colon 18 v_ship_qty no-label
                               v_hold_wt colon 58 v_hold_qty no-label
    v_result_wt colon 18 v_result_qty no-label
                               v_notspec_wt colon 58 v_notspec_qty no-label
with frame a side-labels col 1 width 100 overlay.
setframelabels(frame a:handle). 


define button btn-ship    size 14 by 1 label "Preparation".
define button btn-hist    size 14 by 1 label "Histogram".
define button btn-replace size 10 by 1 label "Replace". 
define button btn-exec    size 10 by 1 label "Execute". 
define button btn-cancel  size 16 by 1 label "Cancel".
define button btn-req     size 15 by 1 label "Required".
define button btn-except  size 15 by 1 label "Except".
define button btn-finish  size 8  by 1 label "Finish".
define button btn-return  size 12 by 1 label "Return".   /*CLZ1*/


form
   tt_key1 label "M"   format "Y/N"
   tt_key2 label "Ex"  format "Y/N"
   tt_lotno label "OVDLotNo" format "x(15)"
   tt_def  label "Def" format "x(1)"
   tt_star label "S"   format "x(1)"
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
      btn-cancel space /*btn-req space btn-except space  *CLZ1*/ 
      btn-finish space btn-return   /*CLZ1*/
with frame c side-labels width 152 no-box.
setframelabels(frame c:handle).

l-focus = btn-ship:handle in frame c .

form skip(1)
     "Lot Number Comparision Sheet Print" skip
     v_printer colon 20
     skip(1)
with frame p side-labels row 6 width 55 title " Print " overlay centered. 
setframelabels(frame p:handle).


form skip(1)
     v_new_month colon 20
     v_new_count colon 20
     v_new_part  colon 20
     v_new_seq   colon 20
     skip(1)
with frame g side-labels row 6 width 70 title " Replace " overlay centered. 
setframelabels(frame g:handle).

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
    find first tt no-lock no-error.

    if v_ship_wt <= 0 or not avail tt or tt_lotno = "" then do:
       /*Can not use this function when Ship Weight is zero.*/
       {pxmsg.i &MSGNUM=31023 &ERRORLEVEL=3}
       pause.
       return.
    end.

    if v_flag <> "" then do:
       /*Can not perform this action*/
       {pxmsg.i &MSGNUM=31003 &ERRORLEVEL=3}
       pause.
       return.
    end.

    v_final = "".
    if v_ship_wt = v_remain_wt then v_final = "1".

    empty temp-table th.   /*CLZ2*/
    v_totwt = 0.
    v_totqty = 0.
    for each tt no-lock where tt_key1 = yes:
        v_totwt = v_totwt + tt_gdwt.
	v_totqty = v_totqty + 1.
    end.

    
    if /**v_totwt > v_ship_wt or
       v_totwt > v_remain_wt or  **/
       v_totqty > v_ship_qty and v_ship_qty <> 0 then do:
       /*  必选重量大于出库重量或剩余重量/根数  */
       {pxmsg.i &MSGNUM=31002 &ERRORLEVEL=3}
       pause.
       return.
    end.

    /*Debug ONLY*
    output to shtt1.txt.
    for each tt no-lock:
	disp tt with frame zz width 220 no-box down.
	down with frame zz.
    end.
    output close.
    *Debug ONLY*/

    v_result = no.
    find first usrw_wkfl where usrw_domain = global_domain
         and usrw_key1 = "PRE_SHIP" and usrw_key2 = v_key2 no-lock no-error.
    if not avail usrw_wkfl then do:
       /*No Shipping Schedule found*/
       {pxmsg.i &msgnum=4551 &errorlevel=3}
       pause.
       return.
    end.
    
    /*Ship Weight Preparation*/
    if v_final = "1" then do:
       if usrw_charfld[4] = "1" then do:    /*Exceed*/
       {gprun.i ""zzshpcrt1.p"" "(usrw_key2, v_part,
                                  v_ship_wt, v_ship_qty, 
                                  output v_result,
			          output v_result_wt,
			          output v_result_qty)"}
       end.
       else do:   /*Less Than*/
       {gprun.i ""zzshpcrt2.p"" "(usrw_key2, v_part,
                                  v_ship_wt, v_ship_qty, 
                                  output v_result,
			          output v_result_wt,
			          output v_result_qty)"}
       end.
    end.
    else do:
       /* 不校验超/以下区分,但数量要符合捆包倍数 */
       {gprun.i ""zzshpcrt3.p"" "(usrw_key2, v_part,
                                  v_ship_wt, v_ship_qty, 
                                  output v_result,
			          output v_result_wt,
			          output v_result_qty)"}
       v_result = yes.    /*20120418*/
    end.

    /*  最终整合时才校验. */
    if v_result = yes and v_final = "1" then do:
       v_max_var = 0.
       if usrw_charfld[4] = "1" then do:  /*Exceed*/
	  for each code_mstr no-lock where code_domain = global_domain
	       and code_fldname matches "ZZ_weight*_over"
	       and code_value = "":
              if deci(code_cmmt) > v_max_var then v_max_var = deci(code_cmmt).
          end.
       end.
       else do:
	  for each code_mstr no-lock where code_domain = global_domain
	       and code_fldname matches "ZZ_weight*_under"
	       and code_fldname <= "ZZ_weight3_under"
	       and code_value = "":
	      if deci(code_cmmt) > v_max_var then v_max_var = deci(code_cmmt).
          end.

	  find first code_mstr where code_fldname = "ZZ_weight4_under"
	       and code_value = "" no-lock no-error.
	  if avail code_mstr then do:
	      if v_max_var < deci(code_cmmt) * v_ship_wt then 
	         v_max_var = deci(code_cmmt) * v_ship_wt.
          end.
       end.

       if abs(v_ship_wt - v_result_wt) > v_max_var then do:
	   disp v_result_wt v_result_qty with frame a.
	   /*Result check failed.*/
	   {pxmsg.i &MSGNUM=31024 &ERRORLEVEL=3}
	   pause.
	   v_result = no.
       end.
    end.   /*Result check*/

    if v_result = yes and v_result_qty > 0 then do:
        /*Ship weight preparation complete.*/
	{pxmsg.i &MSGNUM=31004 &ERRORLEVEL=1}
	pause 2.
        v_flag = "1".
	disp v_result_wt v_result_qty with frame a.
	
	/*Display the result only*/
	for each tt where tt_key3 <> "1":
	    create th.
	    assign th_lotno = tt_lotno .
	    delete tt.
	end.

        /*Debug ONLY*
        output to shtt1.txt append.
        put skip(2) "Result: " v_result_wt "  " v_result_qty skip.
	for each tt no-lock:
	    disp tt with frame zz2 width 220 no-box down.
	    down with frame zz2.
        end.
        output close.
        *Debug ONLY*/
    end.
    else do:
	/*Ship weight preparation failed.*/
	{pxmsg.i &MSGNUM=31005 &ERRORLEVEL=1}
	pause 3.
	v_flag = "".
	v_result_wt = 0.
	v_result_qty = 0.
	
	/*Undo*/
	for each tt where tt_key3 = "1":
	    assign tt_key3 = "".
	end.
	empty temp-table wf.
    end.
end.   /*btn-ship*/

on 'choose':u of btn-hist
do:
    
    hide message no-pause.
    find first tt no-lock no-error.

    if v_ship_wt <= 0 or not avail tt or tt_lotno = "" then do:
       /*Can not use this function when Ship Weight is zero.*/
       {pxmsg.i &MSGNUM=31023 &ERRORLEVEL=3}
       pause.
       return.
    end.

    if v_flag <> "1" then do:
       /*Can not create histogram,unless clicked on "ship preparation" button.*/
       {pxmsg.i &MSGNUM=31001 &ERRORLEVEL=3}
       pause.
       return.
    end.

    /*Copy Excel template to */
    find first code_mstr no-lock where code_domain = global_domain
         and code_fldname = "ZZ_SHIPWPRE_HISTOGRAM_TEMP"
	 and code_value = "" no-error.
    if not avail code_mstr then do:
        /*Can not found directory for histogram template*/
	{pxmsg.i &msgnum=31006 &errorlevel=3}
	pause.
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
	pause.
	return.
    end.

    v_todir = code_cmmt.

    if global_userid <> "qadclz" then do:
       unix silent cp value(v_fmdir) value(v_todir) .
    end.

    /*Create "HIST_DAT"*/
    {zzshphist1.i} /*usrw_key3 = "1" */
    {zzshphist2.i} /*usrw_key3 = "2" */
    {zzshphist3.i} /*usrw_key3 = "3" */

    if global_userid = "qadclz" then v_yn = yes.
    else v_yn = no.
    /*Do you want to create HISTGRAM data?*/
    {pxmsg.i &MSGNUM=31019 &ERRORLEVEL=1 &CONFIRM=v_yn}

  if v_yn = yes then do:

    v_first_lot = "".
    v_last_lot = "".
    v_totwt = 0.
    v_defect = no.

    /*for each wf by wf_lotno:*/
    v_testfile = "/tmp/sh_" + string(year(today),"9999") 
                 + string(month(today),"99") + string(day(today),"99") 
		 + string(time) + ".txt".

    output stream s1 to value(v_testfile) .
    put stream s1 unformatted string(time,"HH:MM:SS") " v_key2:" v_key2  
                              "  v_seq:" v_seq " By:" global_userid skip.

    find first mpd_det no-lock where mpd_domain = global_domain
         and mpd_nbr = "X7" + v_part and mpd_type = "00107" no-error.
    if avail mpd_det then v_pknbr = int(mpd_tol).
    else v_pknbr = 1.

    v_i = 1.
    v_c = 1.
    v_flag2 = no.
    v_int = truncate(v_result_qty / v_pknbr,0).
    v_rem = v_result_qty mod v_pknbr. 
    v_up = "".
    v_down = "".

    /*Find last user sequence*/
    v_usr_seq = 0.
    for last usrw_wkfl no-lock where usrw_domain = global_domain
         and usrw_key1 = "PRE_SPSB" and usrw_key2 begins v_key2
	 and int(usrw_key3) = v_seq
	 by int(substr(usrw_key2,15,2)):
	v_usr_seq = int(substr(usrw_key2,15,2)).
    end.

    for each tt where tt_key3 = "1" by tt_efflen by tt_dia :
	/*Call shiplot generate program*/
	{gprun.i ""zzcrtshlot.p"" "(v_part, output v_shiplot)"}
	/*wf_shiplot = v_shiplot. */
	v_totwt = v_totwt + tt_gdwt.

	if v_first_lot = "" then v_first_lot = v_shiplot.
	v_last_lot = v_shiplot.

	put stream s1 unformatted "  OVDLotNo:" tt_lotno " CurrentSHLot:" v_shiplot
	              "  Weight:" tt_gdwt .

        v_up = "".
	v_down = "".

        if v_pknbr = 1 then do:
           v_up = "1".
	   v_down = "1".
	end.
        else do:
	 if v_pknbr = 2 and v_c <= (v_int - v_pknbr + v_rem + 1) and v_rem <> 0 or 
            v_pknbr = 2 and v_c <= (v_int - v_pknbr + v_rem + 2) and v_rem = 0 or
            v_pknbr = 3 and v_c <= (v_int - v_pknbr + v_rem + 1) and v_rem <> 0 or 
            v_pknbr = 3 and v_c <= (v_int) and v_rem = 0 or 
            v_pknbr = 4 and v_c <= (v_int - v_pknbr + v_rem + 1) and v_rem <> 0 or 
            v_pknbr = 4 and v_c <= (v_int) and v_rem = 0 then do:
           if v_i mod v_pknbr = 1 then assign v_down = "1".
           if v_i mod v_pknbr = 0 then assign v_up = "1"
                                              v_c = v_c + 1.
           if v_pknbr = 2 and v_c <= (v_int - v_pknbr + v_rem + 1) and v_rem <> 0 or 
              v_pknbr = 2 and v_c <= (v_int - v_pknbr + v_rem + 2) and v_rem = 0 or
              v_pknbr = 3 and v_c <= (v_int - v_pknbr + v_rem + 1) and v_rem <> 0 or 
              v_pknbr = 3 and v_c <= (v_int) and v_rem = 0 or 
              v_pknbr = 4 and v_c <= (v_int - v_pknbr + v_rem + 1) and v_rem <> 0 or 
              v_pknbr = 4 and v_c <= (v_int) and v_rem = 0 then v_flag2 = yes.
         end.
         else do:
           if v_flag2 then assign v_i = 1 v_flag2 = no.
           if v_i mod (v_pknbr - 1) = 1 or v_pknbr = 2 then assign v_down = "1".
           if v_i mod (v_pknbr - 1) = 0 then assign v_up = "1".
         end.
         v_i = v_i + 1.
	end.   /*v_pknbr <> 1*/

	/*Update zzsellot_mstr*/
	find first zzsellot_mstr where zzsellot_domain = global_domain
	     and zzsellot_lotno = tt_lotno and zzsellot_final = "1"
	     exclusive-lock no-error.
	if avail zzsellot_mstr then do:
           assign zzsellot_shiplotno = v_shiplot
	          zzsellot_shipplan_ym = string(v_period,"999999")
		  zzsellot_shipplan_num = v_count
		  zzsellot_shipwtprep_num = v_usr_seq + 1
		  zzsellot_shiplotwt = tt_gdwt
		  zzsellot_packsegup = v_up
		  zzsellot_packsegdw = v_down .
	end.
	release zzsellot_mstr.

	/*Update Progress Status (From 210 to 230)*/
	find first lot_mstr where lot_domain = global_domain
	     and lot_serial = tt_lotno and lot_part = "zzlot2" 
	     and lot__chr02 = v_progress exclusive-lock no-error.
	if avail lot_mstr then do:
	   assign lot__chr02 = "230".
	   put stream s1 " NewStatus:" lot__chr02.
	end.
	release lot_mstr.
	put stream s1 skip.
    end.  /*for each tt*/

    /*Shipment Detail Record*/
    create usrw_wkfl.
    assign usrw_domain = global_domain
           usrw_key1 = "PRE_SPSB"
	   usrw_key2 = v_key2 + string(v_usr_seq + 1,"99")
	   usrw_key3 = string(v_seq,"99")
	   usrw_datefld[1] = v_date            /*CLZ1*/
	   usrw_charfld[1] = v_first_lot
	   usrw_charfld[2] = v_last_lot
	   usrw_charfld[3] = string(year(today),"9999") + "/" +
	                     string(month(today),"99") + "/" +
			     string(day(today),"99")
	   usrw_charfld[4] = v_charfld4
	   usrw_charfld[5] = if v_totwt >= v_remain_wt then "1" else ""
	   usrw_decfld[1] = v_plan_wt 
	   usrw_decfld[2] = v_totwt.   /*CLZ1*/

    put stream s1 unformatted "  Create PRE_SPSB.  key2:" usrw_key2 
                  "  FirstLot:" v_first_lot "  LastLot:" v_last_lot
		  "  TotWT:" v_totwt skip.

    /*************
    find first tt where tt_key3 = "1" and tt_def = "*" no-error.
    if avail tt then v_defect = yes.

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
    ************/

    /*Update remain information*/
    for first usrw_wkfl where usrw_domain = global_domain
          and usrw_key1 = "PRE_SHIP" and usrw_key2 = v_key2
	  and int(usrw_key3) = v_seq
          and usrw_charfld[15] <> "1"
	  by int(substr(usrw_key2,1,6)) 
	  by int(usrw_key3)
	  by int(substr(usrw_key2,13,2)):

        assign usrw_decfld[2] = usrw_decfld[2] + v_totwt.

	if usrw_decfld[1] - usrw_decfld[2] <= 0 then do:
	    usrw_charfld[15] = "1".    /*Complete Flag*/
        end.
	put stream s1 unformatted "  usrw_decfld[2]:" usrw_decfld[2]
	              "usrw_charfld[15]:" usrw_charfld[15] skip.
    end.
    release usrw_wkfl.

    put stream s1 "PRE_SHIP updated. " string(time,"HH:MM:SS") skip.
    
    output stream s1 close.   /*TEST ONLY*/

    pt-loop:
    do on error undo, retry:
       update v_printer with frame p.

       if v_printer = "" then do:
	  /* PRINTER CAN NOT BE BLANK.*/
	  {pxmsg.i &MSGNUM=31505 &ERRORLEVEL=3} 
	  pause.
	  undo, retry pt-loop.
       end.
       else do:
	  find first code_mstr where code_domain = global_domain
		and code_fldname = "API_PRINTER"
		and code_value = v_printer no-lock no-error .
	  if not avail code_mstr then do :
		/*the printer is not defined*/
		{pxmsg.i &msgnum=4676 &errorlevel=3}
		pause.
		undo, retry pt-loop.
	  end.
       end.
    end.  /*pt-loop*/

    hide frame p no-pause.

    /*Print Ship Lot Number Comparision Sheet*/
    {gprun.i ""zzshplotpt.p"" "(v_printer, v_part, substr(v_key2,1,6), 
                                int(substr(v_key2,13,2)), v_usr_seq + 1)"}

    /*v_remain_wt = usrw_decfld[1] - usrw_decfld[2] .*/
    v_ship_wt = 0.
    v_ship_qty = 0.
    v_result_wt = 0.
    v_result_qty = 0.

    v_flag = "11".
    
    disp v_ship_wt v_ship_qty /*v_remain_wt v_comp_wt   *CLZ1*/
         v_result_wt  v_result_qty
         with frame a.

    /*Clear temp-table tt*/
    for each tt where tt_key3 = "1":
        delete tt.
    end.

  end.   /*v_yn=yes*/
  else do:
       /**/
  end.

end.  /*btn-hist*/

on 'choose':u of btn-replace
do:
  hide message no-pause.
  find first tt no-lock no-error.

  if not avail tt or tt_lotno = "" then do:
       /*Can not use this function when Ship Weight is zero.*/
       {pxmsg.i &MSGNUM=31023 &ERRORLEVEL=3}
       pause.
       return.
  end.

  /*replace1*/
  repeat:

    update v_new_month  v_new_count  with frame g.

    /******
    if truncate(v_new_month / 100, 0) < year(today) - 1 or 
       truncate(v_new_month / 100, 0) > year(today) + 1 or
       v_new_month mod 100 < 1 or v_new_month mod 100 > 12 or
       v_new_count <= 0 or v_new_count > 99 then do:
       /*Invalid period*/
       {pxmsg.i &msgnum=495 &errorlevel=3 }
       pause.
       next.
    end.
    
    /*replace2*/
    repeat:
    *******/
    v_new_part = caps(v_part).
        update v_new_part  v_new_seq with frame g.
    
        find first pt_mstr where pt_domain = global_domain and pt_part = v_new_part no-lock no-error.
	find first mpd_det no-lock where mpd_domain = global_domain
               and mpd_nbr = "X7" + v_new_part no-error.
        if not avail pt_mstr or not avail mpd_det then do:
	   /*Invalid Item*/
           {pxmsg.i &msgnum=10533 &errorlevel=3 }
	   pause.
           next.
	end.

	if v_new_seq <= 0 then do:
	   /*Invalid sequence*/
           {pxmsg.i &msgnum=2818 &errorlevel=3 }
	   pause.
           next.
	end.
	leave.
    /***
    end.  /*replace2*/
    leave.
    ***/
  end.  /*replace1*/

  empty temp-table wk.
  empty temp-table tt.
  empty temp-table t1.
  empty temp-table t2.
  v_flag = "2".

  /*Replace*/
  {zzshprpl.i}

  hide frame g no-pause.
  return.
end.   /*btn-replace*/

on 'choose':u of btn-exec
do:
    hide message no-pause.
    find first tt no-lock no-error.

    if not avail tt or tt_lotno = "" then do:
       /*Can not use this function when Ship Weight is zero.*/
       {pxmsg.i &MSGNUM=31023 &ERRORLEVEL=3}
       pause.
       return.
    end.

    if v_flag <> "2" then do:
       /*Can not use this founction*/
       {pxmsg.i &MSGNUM=7694 &errorlevel=3}
       pause.
       return.
    end.

    v_count1 = 0.
    v_count2 = 0.
    v_totwt1 = 0.
    v_totwt2 = 0.

    v_testfile = "/tmp/rp_" + string(year(today),"9999") 
                 + string(month(today),"99") + string(day(today),"99") 
		 + string(time) + ".txt".

    output stream s1 to value(v_testfile) .

    put stream s1 unformatted today " " string(time,"HH:MM:SS") 
                  " v_key2:" v_key2 " By:" global_userid skip.

    for each t1:
	find first tt where tt_lotno = t1_lotno and tt_key1 = no no-lock no-error.
	if not avail tt then next.
	v_count1 = v_count1 + 1.
	v_totwt1 = v_totwt1 + tt_gdwt.
	put stream s1 unformatted "t1 " at 3 t1_lotno "  " tt_gdwt skip.
    end.
    for each t2:
	find first tt where tt_lotno = t2_lotno and tt_key1 = yes no-lock no-error.
	if not avail tt then do:
	    delete t2.
	    next.
        end.
	v_count2 = v_count2 + 1.
	v_totwt2 = v_totwt2 + tt_gdwt.
	put stream s1 unformatted "t2 " at 3 t2_lotno "  " tt_gdwt skip.
    end.

    put stream s1 unformatted "  v_count1:" v_count1 " WT1:" v_totwt1
                  "  v_count2:" v_count2 " WT2:" v_totwt2 skip.

    if v_count2 > v_count1 then do:
       /*Replace the quantity is greater than the quantity to be replaced*/
       {pxmsg.i &MSGNUM=31022 &errorlevel=3}
       pause.
       return.
    end.

    for each t1:
	find first tt where tt_lotno = t1_lotno and tt_key1 = no no-lock no-error.
	if not avail tt then next.

	/*Remove original shippreparation data*/
	v_tmp  = "".
	v_tmp1 = "".
	v_tmp2 = 0.
	v_tmp3 = 0.
	v_tmp4 = 0.
	v_tmp5 = "".
	v_tmp6 = "".
	find first zzsellot_mstr where zzsellot_domain = global_domain
	     and zzsellot_lotno = t1_lotno and zzsellot_final = "1" exclusive-lock no-error.
	if avail zzsellot_mstr then do transaction:
	    v_tmp  = zzsellot_shiplotno.
	    v_tmp1 = zzsellot_shipplan_ym.
	    v_tmp2 = zzsellot_shipplan_num.
	    v_tmp3 = zzsellot_shipwtprep_num.
	    v_tmp4 = zzsellot_shiplotwt.
	    v_tmp5 = zzsellot_packsegup.
	    v_tmp6 = zzsellot_packsegdw.

	    find first usrw_wkfl where usrw_domain = global_domain
                 and usrw_key1 = "HIST_DAT" and usrw_key2 = zzsellot_lotno no-error.
	    if avail usrw_wkfl then delete usrw_wkfl.
	    
	    zzsellot_shiplotno = "".
	    zzsellot_shipplan_ym = "".
	    zzsellot_shipplan_num = 0.
	    zzsellot_shipwtprep_num = 0.
	    zzsellot_shiplotwt = 0.
	    zzsellot_packsegup = "".
	    zzsellot_packsegdw = "".

	    find first lot_mstr where lot_domain = global_domain
	         and lot_serial = zzsellot_lotno and lot_part = "zzlot2" 
	         and lot__chr02 = "230" exclusive-lock no-error.
            if avail lot_mstr then
               assign lot__chr02 = v_progress.

	    put stream s1 unformatted "  t1_lotno:" t1_lotno 
	                              " ShipLot:" v_tmp "-->".
            release zzsellot_mstr.
	end.   /*avail zzsellot_mstr*/

	put stream s1 " t2_lotno:" .

	find first t2 no-error.
	if not avail t2 then do:
	    put stream s1 " Next! " skip.
	    next.
        end.

	find first tt where tt_lotno = t2_lotno and tt_key1 = yes no-lock no-error.
	if not avail tt then do:
	    put stream s1 unformatted " NoFound tt! (" t2_lotno ")" skip.
	    next.
	end.

	put stream s1 unformatted t2_lotno .

	find first zzsellot_mstr where zzsellot_domain = global_domain
	     and zzsellot_lotno = t2_lotno and zzsellot_final = "1" 
	     exclusive-lock no-error.
	if not avail zzsellot_mstr then do:
	   put stream s1 "  No zzsellot_mstr!!" skip.
	   next.
        end.

	zzsellot_shiplotno   = v_tmp.
	zzsellot_shipplan_ym = v_tmp1.
	zzsellot_shipplan_num = v_tmp2.
	zzsellot_shipwtprep_num = v_tmp3.
	zzsellot_shiplotwt = v_tmp4.
	zzsellot_packsegup = v_tmp5.
	zzsellot_packsegdw = v_tmp6.
	release zzsellot_mstr.

	find first usrw_wkfl where usrw_domain = global_domain
                 and usrw_key1 = "HIST_DAT" and usrw_key2 = t2_lotno no-error.
	if avail usrw_wkfl then delete usrw_wkfl.

        create usrw_wkfl.
        assign usrw_domain = global_domain
               usrw_key1 = "HIST_DAT"
	       usrw_key2 = t2_lotno
	       usrw_key3 = "2"
	       usrw_key4 = v_part
	       usrw_charfld[1] = global_userid
	       usrw_datefld[1] = today.

        find first lot_mstr where lot_domain = global_domain
	         and lot_serial = t2_lotno and lot_part = "zzlot2" 
	         and lot__chr02 = v_progress exclusive-lock no-error.
        if avail lot_mstr then
               assign lot__chr02 = "230".

	put stream s1 " Data refresh." skip.

	delete t2.
    end.  /*for each t1*/

    put stream s1 skip .

    if v_totwt1 <> v_totwt2 then do:
	/*Update "PRE_SPSB" ship weight*/
	find first usrw_wkfl where recid(usrw_wkfl) = v_recid no-error.
	if avail usrw_wkfl then do:
	   assign usrw_decfld[2] = usrw_decfld[2] - v_totwt1 + v_totwt2.
	   v_tmp = usrw_key2.

	   /*Update "PRE_SHIP" ship weight*/
	   find first usrw_wkfl where usrw_domain = global_domain
	        and usrw_key1 = "PRE_SHIP"
		and usrw_key2 = substr(v_tmp,1,14) no-error.
	   if avail usrw_wkfl then do:
	      assign usrw_decfld[2] = usrw_decfld[2] - v_totwt1 + v_totwt2.
	   end.
	end.

	put stream s1 "  Total Weight Refresh. " v_totwt1 "-->" v_totwt2 skip.
    end.

    put stream s1 "Replac Completed. " string(time,"HH:MM:SS") " By:" global_userid skip.

    output stream s1 close.   /*TEST ONLY*/

    v_flag = "88".
    return.
end.  /*btn-exec*/

on 'choose':u of btn-cancel
do: 
    hide message no-pause.
    /*Cancel*/
    v_yn = no.
    v_msg = "".
    v_recid = 0.

    find last usrw_wkfl no-lock where usrw_domain = global_domain
         and usrw_key1 = "PRE_SHIP" 
	 and substr(usrw_key2,7,6) = v_part 
	 and (usrw_decfld[2] <> 0 or
	     usrw_decfld[2] = 0 and usrw_charfld[15] = "1") no-error.
    if not avail usrw_wkfl then do:
       /*Did not find the data can be canceled. */
       {pxmsg.i &MSGNUM=31020 &ERRORLEVEL=3 &MSGARG1=v_part}
       pause.
       return.
    end.
    else do:
	v_msg = "" /*" Schedule:" + usrw_key2 */ .
	v_recid = recid(usrw_wkfl).
    end.

    /*Are you sure to cancel? # */
    {pxmsg.i &MSGNUM=31018 &ERRORLEVEL=1 &MSGARG1=v_msg &CONFIRM=v_yn}

    if v_yn then do:
	/*Undo transaction*/
	/*1.Undo progress status*/
	/*2.Undo zzsellot_mstr*/
	/*3.Undo shipment detail*/
	/*4.Undo HIST_DAT*/
	{gprun.i ""zzshpcl.p"" "(v_recid, v_progress, output v_ok)"}
	
	if v_ok = no then return.

	/*Empty temp-table*/
	empty temp-table tt.
	empty temp-table t1.
	empty temp-table t2.
	empty temp-table wk.
	v_result_wt = 0.
	v_result_qty = 0.
	/*Refresh screen*/
	v_flag = "".
    end.  /*v_yn*/
    return.
end.   /*btn-cancel*/

/**********CLZ1**********
on 'choose':u of btn-req
do: 
    if v_flag = "" then do:
	/*Refresh screen*/
       v_sort = "tt_idx1".
    end.
    return.
end.    /*btn-req*/

on 'choose':u of btn-except
do: 
    if v_flag = "" then do:
       /*Refresh screen*/
       v_sort = "tt_idx2".
       /*l-focus = self:handle. */
    end.
    return.
end.
**********CLZ1**********/

on 'choose':u of btn-finish
do: 
    find first code_mstr no-lock where code_domain = global_domain
           and code_fldname = "ZZ_SHIP_FINISH"
           and code_value = global_userid no-error.
    if not avail code_mstr then do:
       {pxmsg.i &MSGNUM=31017 &ERRORLEVEL=3}
       pause.
       return.
    end.

    /*Finish*/
    if global_userid = "qadclz" then v_yn = yes.
    else v_yn = no.
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
	      and usrw_key2 begins v_key2 
	      and int(usrw_key3) = v_seq :
              assign usrw_charfld[5] = "1".
          end.
       end. /*usrw_wkfl*/
       else do:
	    /*Update failed.*/
            {pxmsg.i &MSGNUM=31009 &ERRORLEVEL=3}
	    pause 3.
       end.
       return.
    end.    /*v_yn*/
end.  /*btn-finish*/

on 'choose':u of btn-return
do:
    v_flag = "99".
    return.
end.


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
	v_date    = usrw_datefld[1].     /*CLZ1*/
	v_charfld4 = usrw_charfld[4].    /* over weight flag */
    end.

    if v_charfld4 = "1" then v_exceed = GetTermLabel("SHP_LBL41",10).
    if v_charfld4 = "2" then v_exceed = GetTermLabel("SHP_LBL42",10).

    if v_period = 0 then do:
       /*No Shipping Schedule found*/
       {pxmsg.i &msgnum=4551 &errorlevel=3}
       next.
    end.

    disp v_period v_count v_lbl44 /*v_seq*/ v_exceed with frame a.
   
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

	create wk.
	assign wk_lotno = ld_lot
	       wk_flag  = 0
	       wk_qty   = /*ld_qty_oh */ zzsellot_insp_goodweight .

	/*v_result = yes.  *TEST ONLY*/
	if v_result = no then do:
	   wk_flag = 7.    /* Out of specification */
	end.
	else do:

	  /*Status Check*/
	  find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot1" 
	     no-lock no-error.
	  if avail lot_mstr then do:
	    if lot__chr02 = "1" then wk_flag = 6.   /*Hold*/
	    else if lot__chr03 <> "1" or lot__chr04 <> "1" or 
	       lot__chr05 <> "1" or lot__chr06 <> "1" 
	       then wk_flag = 5.   /*Reserve*/
	    else wk_flag = 2. /*Normal*/
          end.
	  
	  if wk_flag = 0 or wk_flag = 2 then do:
	     if zzsellot_insp_defect = "*" then wk_flag = 4.
	     else if zzsellot_insp_star = "*" then  wk_flag = 3.
	  end.

	  if wk_flag = 0 then wk_flag = 2.
	end.  /*v_result = no*/
    end.  /*for each ld_det*/

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
	else if wk_flag = 5 then  /* Reserve */
	   assign v_reserve_wt  = v_reserve_wt + wk_qty
	          v_reserve_qty = v_reserve_qty + 1.
	else if wk_flag = 6 then  /* HOLD */
	   assign v_hold_wt  = v_hold_wt + wk_qty
	          v_hold_qty = v_hold_qty + 1.
	else if wk_flag = 7 then  /* Out of Spec */
	   assign v_notspec_wt  = v_notspec_wt + wk_qty
	          v_notspec_qty = v_notspec_qty + 1.
    end.  /*for each wk*/

    v_avail_wt = v_avail_wt + v_normal_wt + v_defect_wt + v_star_wt.
    v_avail_qty = v_avail_qty + v_normal_qty + v_defect_qty + v_star_qty.

    v_result_wt = 0.
    v_result_qty = 0.

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

	if v_ship_wt > v_remain_wt or 
	   v_ship_wt > v_avail_wt or 
	   v_ship_qty > 0 and v_ship_qty > v_avail_qty
	then do:
	   /*Ship weight can not greater than the remaining weight.*/
	   {pxmsg.i &MSGNUM=31008 &ERRORLEVEL=3}
	   next.
	end.

	if v_ship_wt < 0 or v_ship_qty < 0 then do:
	   /*Ship weight must be greater than zero.*/
	   {pxmsg.i &MSGNUM=31016 &ERRORLEVEL=3}
	   next.
	end.
	
	if v_ship_wt < v_remain_wt and v_ship_qty <> 0 then do:
	       find first mpd_det no-lock where mpd_domain = global_domain
                   and mpd_nbr = "X7" + v_part and mpd_type = "00107" no-error.
               if avail mpd_det then v_pknbr = int(mpd_tol).
               else v_pknbr = 1.
               
	       if v_ship_qty mod v_pknbr <> 0 then do:
	          /*The number must be multiple of packing number #.*/
	          {pxmsg.i &MSGNUM=31025 &ERRORLEVEL=3 &MSGARG1=v_pknbr}
	          next.
               end.
	end.
	leave.
    end.  /*loop_shipwt*/

    /*Fill temp-tabel tt*/
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
	   tt_gdwt   = zzsellot_insp_goodweight      /*CLZ*/
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
	create tt.  /*Create NULL data*/
	/******
	/*No record available.*/
	{pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
	undo, retry.
	******/
    end.

    v_sort = "tt_idx1".

    pause 0.

    loop1:
    repeat /*on end-key undo, leave loop1 */ :

        /*Scroll Screen and update tt_key1 and tt_key2*/
	if v_sort = "tt_idx1" then do:
		{zzshscroll.i "tt_idx1"}
	end.
	else if v_sort = "tt_idx2" then do:
		{zzshscroll.i "tt_idx2"}
	end.

        /***
        view frame a.
	view frame b.
	view frame c.
	***/
	
        /*find first tt use-index {1} no-lock no-error. */
        if not avail tt then leave. 
     
        enable btn-ship btn-hist btn-replace btn-exec 
	       btn-cancel /*btn-req btn-except *CLZ1*/
	       btn-finish btn-return with frame c.
        
	repeat /*on end-key undo, next main-loop */ :
	        view frame a.
		view frame b.
	        view frame c.
		v_leave = no.

		/*Refresh detail screen*/
		if v_sort = "tt_idx1" then do:
			{zzshpref.i "tt_idx1"}
		end.
		else if v_sort = "tt_idx2" then do:
			{zzshpref.i "tt_idx2"}
		end.

		wait-for GO of frame c or
	             choose of btn-ship, btn-hist, btn-replace,
	                       btn-exec, btn-cancel, 
			       /*btn-req, btn-except,     *CLZ1*/
			       btn-finish, btn-return .  /*CLZ1*/
            
	        clear frame g all no-pause .
		find first tt no-lock no-error.
		if not avail tt then v_leave = yes.

		if v_leave then leave.
		if v_flag = "99" then undo, next main-loop.  /*CLZ1*/
		if v_flag = "88" then next main-loop.        /*CLZ1*/
                
		hide all no-pause.
		/***
		hide frame a no-pause.
		hide frame b no-pause.
		hide frame c no-pause.
		***/
	end.  /*repeat*/

	hide all no-pause.
	if v_leave then leave.
        
    end.  /*repeat*/

    pause before-hide.
    hide all no-pause.
end.   /*main-loop*/
