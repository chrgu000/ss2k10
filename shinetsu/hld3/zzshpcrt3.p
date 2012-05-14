/*zzshpcrt3.p   Ship Weight Preparation  */
/*Last Modify by Leo Zhou     04/09/2012 */

{mfdeclre.i}

def input parameter v_key as char.
def input parameter v_part as char.
def input parameter v_ship_wt as deci.
def input parameter v_ship_qty as int.
def output parameter v_finish as log.
def output parameter v_act_wt as deci.
def output parameter v_act_qty as int.

def {1} shared temp-table tt
    field tt_line   as int format ">>9"
    field tt_key1   as logical format "Y/N"
    field tt_key2   as logical format "Y/N"
    field tt_key3   as char format "x(1)"
    field tt_lotno  as char format "x(15)"
    field tt_def    as char format "x(1)"
    field tt_star   as char format "x(1)"
    field tt_mfd    as deci format ">9.99"
    field tt_lc     as deci format ">>,>>9"
    field tt_l0     as deci format ">>,>>9.9"
    field tt_dia    as deci format ">>9.9<"
    field tt_efflen as int  format ">>,>>9"
    field tt_totwt  as deci format ">>>,>>9.9"
    field tt_calwt  as deci format ">>>,>>9.9"
    field tt_diavar as deci format ">9.99"
    field tt_dn     as deci format ">9.99"
    field tt_ecc    as deci format ">9.99"
    field tt_bow    as deci format ">9.99"
    field tt_ellip  as deci format ">9.99"
    field tt_bubb   as char format "x(1)" 
    field tt_gdwt   as deci format ">>>,>>9.9"  /*CLZ1*/
    index tt_idx1 tt_key1 descending tt_key2 descending tt_lotno ascending
    index tt_idx2 tt_key2 descending tt_key1 descending tt_lotno ascending
    index tt_line tt_line ascending.

def shared temp-table wf
    field wf_lotno   as char
    field wf_calwt   as deci
    field wf_shiplot as char
    field wf_defect  as char
    field wf_star    as char.

def new shared temp-table tb
    field tb_lotno  as char
    field tb_calwt  as deci.

def new shared temp-table tf
    field tf_lotno as char
    field tf_calwt as deci.


def var v_totwt     as deci init 0.
def var v_defect_wt as deci init 0.
def var v_len       as deci init 0.
def var v_kei       as deci init 0.
def var v_len_limit as deci init 0.  /* 长度规格 */
def var v_dia_limit as deci init 0.  /* 直径规格 */
def var v_len_rate  as deci init 0.
def var v_dia_rate  as deci init 0.
def var v_kei_rate  as deci init 0.
def var v_def_class as int format "9".
def var v_def_rate  as deci format ">>9.99".
def var v_curr_wt   as deci.
def var v_curr_def  as deci.
def var v_len_wt    as deci.   /* */
def var v_dia_wt    as deci.
def var v_open_wt1  as deci.
def var v_open_wt2  as deci.
def var v_comp_qty  as int.
def var v_pknbr     as int.
def var v_debug as log.
def var v_init  as log.
def var i as int.

/*Debug ONLY*/
v_debug = no.

if v_debug = yes then do:
   message "v_key=" v_key.
   pause.
end.

/*Find shipping schedule*/
find first usrw_wkfl where usrw_domain = global_domain
     and usrw_key1 = "PRE_SHIP" and usrw_key2 = v_key no-lock no-error.
if not avail usrw_wkfl then do:
    v_finish = no.
 
    /*No Shipping Schedule found*/
   {pxmsg.i &msgnum=4551 &errorlevel=3}

    return.
end.

v_comp_qty = 0.
v_pknbr = 1.

/*Box*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00107" no-error.
if avail mpd_det then v_pknbr = int(mpd_tol).

/*Defect Rate*/
find first mpd_det no-lock where mpd_domain = global_domain         /*CLZ1*/
     and mpd_nbr = "X7" + v_part and mpd_type = "00122" no-error.   /*CLZ1*/
if avail mpd_det then do:                                           /*CLZ1*/
   if mpd_tol <> "" then v_def_rate = deci(mpd_tol) / 100.          /*CLZ1*/
   else v_def_rate = 0.                                             /*CLZ1*/
end.                                                                /*CLZ1*/
else do:                                                            /*CLZ1*/
   find first code_mstr where code_domain = global_domain
     and code_fldname = "ZZ_DEFECT_DISTRIBUT_RATIO"
     and code_value = "" no-lock no-error.
   if avail code_mstr then v_def_rate = deci(code_cmmt) / 100.
   else v_def_rate = 0.
end.                                                                /*CLZ1*/

/*Length limit*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00110" no-error.
if avail mpd_det and mpd_tol <> "" then v_len_limit = deci(mpd_tol).

/*Dia limit*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00111" no-error.
if avail mpd_det and mpd_tol <> "" then v_dia_limit = deci(mpd_tol).

/*Length Ratio:小于指定长度v_len_limit的产品不能超过这个比率(重量比)  */
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00112" no-error.
if avail mpd_det and mpd_tol <> "" then v_len_rate = deci(mpd_tol).

/*Dia Ratio:小于指定直径v_dia_limit的产品不能超过这个比率(重量比)  */
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00113" no-error.
if avail mpd_det and mpd_tol <> "" then v_dia_rate = deci(mpd_tol).

/*Defect Class */
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00036" no-error.
if avail mpd_det and mpd_tol <> "" then v_def_class = int(mpd_tol).

/******
v_totwt = 0.
for each tt where tt_key2 = no and tt_star <> "*"
            or (tt_key1 = yes and tt_star = "*" ) :
    v_totwt = v_totwt + tt_gdwt.
end. 
******/

/*  最大允许Defect品的重量  */
if v_def_class = 1 then do:
   v_defect_wt = v_ship_wt * v_def_rate.
end.
else v_defect_wt = 0.


if v_debug then do:
    hide message no-pause.
    message "Part:" v_part " Target:" v_ship_wt v_ship_qty 
            "  DefClass:" v_def_class " v_defect_wt=" v_defect_wt 
	    " v_len_rate=" v_len_rate.
    pause.
end.

i = 0.
v_curr_wt = 0.    /*Current total weight*/
v_curr_def = 0.   /*Current defect total weight*/
v_len_wt  = 0.
v_dia_wt  = 0.
v_finish  = no.
v_open_wt1 = v_ship_wt.
v_act_wt = 0.
v_act_qty = 0.

empty temp-table wf.

/*   先安排必选项目  */
for each tt where tt_key1 = yes and tt_key2 = no and tt_key3 <> "1" :

    if v_def_class <> 1 and tt_def = "*" then do:
	/*  该产品不允许包含Defect品  */
	{pxmsg.i &MSGNUM=31010 &ERRORLEVEL=3}
	v_finish = no.
	return.
    end.

    if (i > v_ship_qty and v_ship_qty <> 0 )
       or 
       (v_act_wt + tt_gdwt > v_ship_wt and usrw_charfld[4] = "2")
       then do:
	/*  必选项超过指定根数或指定重量  */
	{pxmsg.i &MSGNUM=31011 &ERRORLEVEL=3}
	v_finish = no.
	return.
    end.

    if v_len_rate <> 0 then do:
       /*  长度规格限制外  */
       if tt_efflen < v_len_limit then do:
	   if (v_len_wt + tt_gdwt) / v_ship_wt > v_len_rate then do:
	       /*  必选项重量比例超过长度规格限制  */
	       {pxmsg.i &MSGNUM=31012 &ERRORLEVEL=3}
	       v_finish = no.
	       return.
	   end.
	   else v_len_wt = v_len_wt + tt_gdwt.
       end.

       /*  直径规格限制外  */
       if tt_dia < v_dia_limit then do:
	   if (v_dia_wt + tt_gdwt) / v_ship_wt > v_dia_rate then do:
	       /*  必选项超过直径规格限制  */
	       {pxmsg.i &MSGNUM=31013 &ERRORLEVEL=3}
	       v_finish = no.
	       return.
	   end.
	   else v_dia_wt = v_dia_wt + tt_gdwt.
       end.
    end.  /*v_len_rate <> 0*/

    /*  累积Defect品的重量是否超过上限   */
    if tt_def = "*" then do:
	if v_debug then do:
	message "Check!  TotDF:" v_curr_def " Curr:" tt_gdwt " Max:" v_defect_wt.
	pause.
        end.

	if v_curr_def + tt_gdwt > v_defect_wt then do:
	   /*   必选项的Defect品超出上限   */
	   {pxmsg.i &MSGNUM=31014 &ERRORLEVEL=3}
	   v_finish = no.
	   return.
	end.
	v_curr_def = v_curr_def + tt_gdwt.
    end.
        
    tt_key3 = "1".
    i = i + 1.
    v_act_wt = v_act_wt + tt_gdwt.
    v_act_qty = v_act_qty + 1.

end.  /*tt*/

if v_debug then do:
    hide message no-pause.
    message "After Must Item.  1. v_act_wt=" v_act_wt "   i=" i
            "  v_len_rate=" v_len_rate .
    pause.
end.

/*Debug ONLY*
output to shtt2.txt.
   put unformatted " v_ship_wt=" v_ship_wt  "  v_def_rate=" v_def_rate
       " v_len_limit(110)=" v_len_limit "  v_dia_limit(111)=" v_dia_limit skip
       " v_len_rate(112)="  v_len_rate  "  v_dia_rate(113)=" v_dia_rate
       " v_def_class(036)=" v_def_class "  v_defect_wt=" v_defect_wt skip.
output close.
*Debug ONLY*/

empty temp-table tb.
empty temp-table tf.
v_open_wt1 = v_ship_wt - v_act_wt.   /*Open Weight*/
v_open_wt2 = v_defect_wt - v_curr_def.

if v_len_rate = 0 then do:
   if v_def_class = 1 then do:
        /* 无规格限制，Defect品 */
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def = "*" and tt_star <> "*":
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.

	if can-find(first tb) then do:
        /*Ship weight pick logical 1*/
        {gprun.i ""zzshlog3.p"" "(v_open_wt2, v_ship_qty - i)"}
	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt2 = v_open_wt2 - tf_calwt.
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tf_calwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After No_Limit_Defect.  2. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or 
	   (v_act_qty = v_ship_qty and v_ship_qty <> 0)then do:
           v_finish = yes.
	   return.
	end.
	end.  /*can-find(first tb)*/

	/* 无规格限制，通常品 */
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def <> "*" and tt_star <> "*":
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.
        
	v_comp_qty = i.
	/*Ship weight pick logical*/
        {gprun.i ""zzshlog4.p"" "(v_open_wt1, v_ship_qty - i, v_comp_qty, v_pknbr)"}

	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tf_calwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After No_Limit_Normal.  3. v_act_wt=" v_act_wt " i=" i " v_ship_qty=" v_ship_qty.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.

   end.
   else if v_def_class < 1 then do:
	/* 无规格限制，通常品 */
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def <> "*" and tt_star <> "*":
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.

	v_comp_qty = i.
	/*Ship weight pick logical*/
        {gprun.i ""zzshlog4.p"" "(v_open_wt1, v_ship_qty - i, v_comp_qty, v_pknbr)"}

	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After No_Limit_Normal.  4. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.
   end.
end.
else if v_len_rate <> 0 then do:
    if v_def_class = 1 then do:
        /* 有规格限制，规格内Defect品 */
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def = "*" and tt_efflen >= v_len_limit
	    and tt_dia >= v_dia_limit and tt_star <> "*" :
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.

	if can-find(first tb) then do:

        /*Ship weight pick logical 2*/
        {gprun.i ""zzshlog3.p"" "(v_open_wt2, v_ship_qty - i)"}
	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt2 = v_open_wt2 - tf_calwt.
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After Limit_In_Defect.  5. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.
	end.  /*can-find(first tb)*/

        /* 有规格限制，规格外Defect品 */
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def = "*" and tt_star <> "*"
	    and (tt_efflen < v_len_limit or tt_dia < v_dia_limit) :
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.

	if can-find(first tb) then do:

        /*Ship weight pick logical 2*/
        {gprun.i ""zzshlog3.p"" "(v_open_wt2, v_ship_qty - i)"}
	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt2 = v_open_wt2 - tf_calwt.
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After Limit_Out_Defect.  6. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.
	end.  /*can-find(first tb)*/

        /*有规格限制，规格外通常品*/
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def <> "*" and tt_star <> "*" 
	    and (tt_efflen < v_len_limit or tt_dia < v_dia_limit) :
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.

        /*Ship weight pick logical 2*/
        {gprun.i ""zzshlog2.p"" "(v_open_wt1, v_ship_qty - i)"}
	
	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After Limit_Out_Normal.  7. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.

        /*有规格限制，规格内通常品*/
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def <> "*" and tt_star <> "*" 
	    and tt_efflen >= v_len_limit
	    and tt_dia >= v_dia_limit :
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.
        
	v_comp_qty = i.
	/*Ship weight pick logical*/
	{gprun.i ""zzshlog4.p"" "(v_open_wt1, v_ship_qty - i, v_comp_qty, v_pknbr)"}

	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After Limit_In_Normal.  8. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.

    end.  /*v_def_class=1*/
    else if v_def_class < 1 then do:
	/*有规格限制，规格外通常品*/
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def <> "*" and tt_star <> "*" 
	    and (tt_efflen < v_len_limit or tt_dia < v_dia_limit) :
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.
        
	/*Ship weight pick logical 2*/
        {gprun.i ""zzshlog2.p"" "(v_open_wt1, v_ship_qty - i)"}
	
	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After Limit_Out_Normal.  9. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.

	/*有规格限制，规格内通常品*/
        empty temp-table tb.
	for each tt where tt_key1 = no and tt_key2 = no and tt_key3 <> "1"
	    and tt_def <> "*" and tt_star <> "*" 
	    and tt_efflen >= v_len_limit 
	    and tt_dia >= v_dia_limit :
            create tb.
	    assign tb_lotno = tt_lotno
	           tb_calwt = tt_gdwt.
	end.

        v_comp_qty = i.
	/*Ship weight pick logical*/
	{gprun.i ""zzshlog4.p"" "(v_open_wt1, v_ship_qty - i, v_comp_qty, v_pknbr)"}

	for each tf:
	    find first tt where tt_lotno = tf_lotno no-error.
	    if avail tt then tt_key3 = "1".
	    v_open_wt1 = v_open_wt1 - tf_calwt.
	    i = i + 1.
	    v_act_wt = v_act_wt + tt_gdwt.
	    v_act_qty = v_act_qty + 1.
	end.

        if v_debug then do:
           hide message no-pause.
           message "After Limit_In_Normal.  10. v_act_wt=" v_act_wt " i=" i.
           pause.
        end.

        if (v_act_wt >= v_ship_wt and v_ship_qty = 0)
	   or
	  (v_act_wt >= v_ship_wt and v_act_qty = v_ship_qty and v_ship_qty <> 0) then do:
           v_finish = yes.
	   return.
	end.

    end.   /*v_def_class<1*/
end.  /*v_len_rate<>0*/


if v_debug then do:
    hide message no-pause.
    message "4. v_curr_wt=" v_act_wt "   i=" i " Finish:" v_finish.
    pause.
end.
