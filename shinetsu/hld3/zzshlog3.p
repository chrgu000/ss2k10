/*zzshlog3.p   Ship Weight Preparation Logic 3 (For DEFECT ONLY)*/
/*Defect Item*/

def input parameter v_ship_wt as deci.
def input parameter v_ship_qty as int.
def var v_debug as log.

def shared temp-table tb
    field tb_lotno  as char
    field tb_calwt  as deci.

def shared temp-table tf
    field tf_lotno as char
    field tf_calwt as deci.

def var v_init    as log.
def var v_curr_wt as deci.
def var v_curr_qty as int.
def var v_gap     as deci.
def var v_max     as deci.
def var v_min     as deci.
def var v_tmp_lotno as char.
def var v_max_lotno as char.

v_debug = no.
v_curr_wt = 0.
v_curr_qty = 0.
v_init = yes.
v_gap = 0.
v_max = 0.
v_min = 0.
if v_ship_qty < 0 then v_ship_qty = 0.

for each tb no-lock :
    if v_min = 0 then v_min = tb_calwt.
    if v_min > tb_calwt then v_min = tb_calwt.
end.

if v_debug then do:
    hide message no-pause.
    message "zzshlog3.p  Target:" v_ship_wt v_ship_qty " v_min:" v_min.
    pause.
end.

/*  如果最轻的缺陷品重量超过目标重量,就直接返回.  */
if v_min > v_ship_wt then return.

empty temp-table tf.

for each tb by tb_calwt:
    
    if v_init = yes then do:
	if tb_calwt > v_ship_wt then next.
	
	if v_curr_wt + tb_calwt > v_ship_wt 
	  or (v_curr_qty = v_ship_qty and v_ship_qty > 0) then do:
	   v_init = no.
	   next.
        end.

	v_gap = abs(v_curr_wt + tb_calwt - v_ship_wt).

	v_curr_wt = v_curr_wt + tb_calwt.
	create tf.
	assign tf_lotno = tb_lotno
	       tf_calwt = tb_calwt.

        v_curr_qty = v_curr_qty + 1.

	if v_debug then do:
           hide message no-pause.
           message "DFLotNo:" tb_lotno "  WT:" tb_calwt " v_curr_wt=" v_curr_wt
	           "  curr_qty=" v_curr_qty "  Gap=" v_gap.
           pause.
        end.

    end.
    else do:   /*v_init=no*/
	
	/*Pickup next Lot*/
	v_tmp_lotno = tb_lotno.  /*LotNo temporary*/
	v_max_lotno = "".        /* 准备移除的LotNo */
	create tf.
	assign tf_lotno = tb_lotno
	       tf_calwt = tb_calwt.

	/* 找出基准值(当前差异+临时Lot重量)以上最轻的Lot */
	for each tf where tf_calwt >= (v_gap + tb_calwt) by tf_calwt descending:
	    v_max = tf_calwt.
	    v_max_lotno = tf_lotno.
	end.

	if v_max_lotno = "" then do:
           /* 找出基准值以下最重的Lot */
	   for each tf where tf_calwt <= (v_gap + tb_calwt) by tf_calwt:
               v_max = tf_calwt.
	       v_max_lotno = tf_lotno.
	   end.
	end.

	if v_debug then do:
           hide message no-pause.
           message "Loop:" tb_lotno " CurrWT:" tb_calwt " v_curr_wt=" v_curr_wt 
	           " Gap=" v_gap " NewGap=" abs(v_curr_wt + tb_calwt - v_max - v_ship_wt).
           pause.
        end.

	if abs(v_curr_wt + tb_calwt - v_max - v_ship_wt) < v_gap then do:
	    /*本轮筛选有效，除去v_max_lotno*/
            find first tf where tf_lotno = v_max_lotno no-error.
	    if avail tf then delete tf.
	    
	    /*Update the total weight*/
	    v_curr_wt = v_curr_wt + tb_calwt - v_max.
	    
	    /*Update the gap*/
	    v_gap = v_curr_wt - v_ship_wt.
	    
	end.
	else do:
	     /*Give up!  Remove the temporary Lot*/
             find first tf where tf_lotno = v_tmp_lotno no-error.
	     if avail tf then delete tf.
        end.
   end.   /*v_init=no*/
end.  /*tb*/

/****TEST ONLY***
for each tf by tf_lotno:
    disp tf.
end.
message "Total:" v_curr_wt.
pause.
********/
