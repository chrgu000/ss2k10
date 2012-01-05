/* GUI CONVERTED from resqwba.p (converter v1.76) Mon Aug 12 22:34:42 2002 */
/* $Revision: 1 $ BY: mage chen    DATE: 07/05/05 ECO: *ts01*     */

{mfdeclre.i} /* SHARED VARIABLE INCLUDE */

/* IF YES THEN WILL SHOW ERROR MESSAGES TO USER */

define input parameter p-show-messages    as logical no-undo.

define new shared variable shopcal_recno  as   recid.
define new shared variable use_detail     like mfc_logical.
define new shared variable done_division  like mfc_logical.
define new shared variable amt_seq        like seq_qty_req.
define new shared variable qtyreq         like seq_qty_req.
define new shared variable temp_rel       like seq_due_date.
define new shared variable line_rate      like lnd_rate.
define new shared variable part           like seq_part.
define new shared variable leftover       like mfc_logical.
define new shared variable undo-input     like mfc_logical.
define new shared variable lnd_recno      as   recid.
define new shared variable sequence       as   decimal initial 0.
define new shared variable used_hours     as   decimal.
define new shared variable shft_amt       as   decimal decimals 2 extent 4.
define new shared variable hours          as   decimal extent 4.
define new shared variable cap            as   decimal extent 4.
define     shared variable undo-input1    like mfc_logical no-undo.
define     shared variable multiple       as   decimal.
define     shared variable site           like seq_site.
define     shared variable prline         like seq_line.
define     shared variable begin_date     like seq_due_date.
define     shared variable lundo-input2   like mfc_logical no-undo.

define            variable gross_qty      like seq_qty_req        no-undo.
define            variable temp_date      like seq_start          no-undo.
define            variable i              as   integer            no-undo.
define            variable j              as   integer            no-undo.
define            variable old_part       like seq_part           no-undo.
define            variable increment      as   integer            no-undo.
define            variable found_date     like mfc_logical        no-undo.
define            variable ii             as   integer            no-undo.
define            variable l_count        as   integer initial 1  no-undo.
define            variable start_priority as   decimal            no-undo.
define            variable new_priority   as   decimal            no-undo.
define            variable changetime     like chg_time           no-undo.
define            variable check_date     as   date               no-undo.
define            variable yn             like mfc_logical        no-undo.
/*ts01*/ define     variable used_cap       as   decimal           no-undo.
/*ts01*/ define     variable free_cap       as   decimal .
/*ts01*/ define     variable move_cap       as   decimal .
/*ts01*/ define     variable next_priority  like  seq_priority.


/*ts*/ define temp-table ts_work no-undo
   field ts_date   like seq_due_date
   field ts_cap    as   decimal 
   field ts_used   as   decimal 
   field ts_free_cap   as   decimal 
   INDEX ts-asc IS PRIMARY ts_date ASCENDING
   INDEX ts-des ts_date DESCENDING.

define workfile work_seq no-undo
   field work_part like seq_part
   field work_qty  like seq_qty_req.


define temp-table tsm_move no-undo
   field tsm_due_date like seq_due_date
   field tsm_line like seq_line
   field tsm_mode like seq_mode
   field tsm_mode_qty like seq_mode_qty
   field tsm_part like seq_part
   field tsm_priority like seq_priority
   field tsm_qty_req like seq_qty_req
   field tsm_release like seq_release
   field tsm_shift1 like seq_shift1
   field tsm_shift2 like seq_shift2
   field tsm_shift3 like seq_shift3
   field tsm_shift4 like seq_shift4
   field tsm_site like seq_site
   field tsm_start like seq_start
   field tsm_type like seq_type
   field tsm_user1 like seq_user1
   field tsm_user2 like seq_user2
   field tsm_chr01 like seq__chr01
   field tsm_chr02 like seq__chr02
   field tsm_chr03 like seq__chr03
   field tsm_chr04 like seq__chr04
   field tsm_chr05 like seq__chr05
   field tsm_dec01 like seq__dec01
   field tsm_dec02 like seq__dec02
   field tsm_dec03 like seq__dec03
   field tsm_log01 like seq__log01
   index tsm_primary
   tsm_due_date
   tsm_priority
   tsm_part.

define temp-table tsm1_move no-undo
   field tsm1_due_date like seq_due_date
   field tsm1_line like seq_line
   field tsm1_mode like seq_mode
   field tsm1_mode_qty like seq_mode_qty
   field tsm1_part like seq_part
   field tsm1_priority like seq_priority
   field tsm1_qty_req like seq_qty_req
   field tsm1_release like seq_release
   field tsm1_shift1 like seq_shift1
   field tsm1_shift2 like seq_shift2
   field tsm1_shift3 like seq_shift3
   field tsm1_shift4 like seq_shift4
   field tsm1_site like seq_site
   field tsm1_start like seq_start
   field tsm1_type like seq_type
   field tsm1_user1 like seq_user1
   field tsm1_user2 like seq_user2
   field tsm1_chr01 like seq__chr01
   field tsm1_chr02 like seq__chr02
   field tsm1_chr03 like seq__chr03
   field tsm1_chr04 like seq__chr04
   field tsm1_chr05 like seq__chr05
   field tsm1_dec01 like seq__dec01
   field tsm1_dec02 like seq__dec02
   field tsm1_dec03 like seq__dec03
   field tsm1_log01 like seq__log01
   index tsm1_primary
   tsm1_due_date
   tsm1_priority
   tsm1_part.
/*ts01 define buffer seq for  seq_mstr.**/

for each ts_work :
delete ts_work.
end.

for each seq_mstr  EXCLUSIVE-LOCK where seq_domain = global_domain and seq_site = site and
seq_line = prline and seq_due_date >= begin_date and seq_qty_req <= 0 :
delete seq_mstr.
end.

  ii = 0.
  find last seq_mstr
      where  seq_domain = global_domain and  seq_site = site
     and seq_line = prline
     and seq_due_date >= begin_date
     use-index seq_sequence no-lock no-error.
     if available seq_mstr then do:
     temp_rel = begin_date.
   
    do while temp_rel <= seq_due_date :
    {recaldt.i temp_rel shopcal_recno}

    /* GET CAPACITY FOR NEW DAY */
    {recalcap.i &date=temp_rel}
      if   cap[1]  >= 0
         or cap[2] >= 0
         or cap[3] >= 0
         or cap[4] >= 0
         then do:
    create ts_work .
    ts_work.ts_date = temp_rel.
    ts_work.ts_cap  = cap[1] + cap[2] + cap[3] + cap[4].
    end. /*if cap[1] >= 0 */
    temp_rel = temp_rel + 1.
     end. /*while do */
     end. /*if available seq_mstr then do: */
     else leave.
    old_part = "".

  

   for each seq_mstr
   fields(seq_due_date seq_line   seq_part   seq_priority seq_qty_req
          seq_shift1   seq_shift2 seq_shift3 seq_shift4   seq_site 
	  seq__dec01   seq__dec02 seq_domain)
     where   seq_domain = global_domain and seq_site = site
     and seq_line = prline
     and seq_due_date >= begin_date
     and seq_qty_req > 0 use-index seq_sequence 
     break by seq_site by seq_line by seq_due_date:
 
if first-of(seq_due_date) then do:
used_cap = 0.
end. /*if first-of(seq_due_date) **********/

   if seq_qty_req >= 0
      and seq_part <> old_part
      then do:
         for first chg_mstr
            fields(chg_from chg_line chg_site chg_time chg_to chg_domain)
            where  seq_domain = global_domain and  chg_site = site
              and chg_line = prline
              and chg_from = old_part
              and chg_to   = seq_part
            no-lock:
         end. /* FOR FIRST chg_mstr */
 
         if not available chg_mstr
         then
            for first chg_mstr
               fields(chg_from chg_line chg_site chg_time chg_to chg_domain)
               where  chg_domain = global_domain and  chg_site = site
                 and chg_line = prline
                 and chg_from = ""
                 and chg_to   = seq_part
               no-lock:
         end. /* FOR FIRST chg_mstr */
 
         if available chg_mstr
         then do:
            changetime = chg_time.
	    used_cap = used_cap + changetime.
	    seq__dec01 = chg_time.
         end.
        end. /*if seq_qty_req >= 0 and seq_part <> old_part */

        find last lnd_det where  lnd_domain = global_domain and  lnd_site = site and
	 lnd_line = prline and lnd_part = seq_part no-error.
	 if available lnd_det then  do: 
	 if lnd_rate > 0 then
	assign  used_cap = used_cap + seq_qty_req / lnd_rate
	  seq__dec02 = seq_qty_req / lnd_rate.
	  else assign  used_cap = used_cap + seq_qty_req  
	  seq__dec02 = seq_qty_req .
           end.
	
	  if last-of(seq_due_date) then do:
	  find ts_work WHERE  ts_date = seq_due_date no-error.
	  if available ts_work then ts_used = used_cap.
	  else do:
	  create ts_work.
	  assign   ts_date = seq_due_date
	           ts_cap = 0
		   ts_used = used_cap.
		   end.
           end. /*if last-of(seq_due_date) then do:*/

end. /* FOR EACH seq_mstr */
 
 used_cap = 0.

 
 
for each ts_work:
ts_free_cap = used_cap.
used_cap = max(used_cap + ts_cap - ts_used , 0).
 

end.

 
 move_cap = 0.

 for each tsm_move:
 delete tsm_move.
 end.

 move_cap = 0.

 for each ts_work where ts_date >= begin_date use-index ts-des:
 

 for each tsm_move no-lock :
 next_priority = 0.
 find last seq_mstr where  seq_domain = global_domain and  seq_site = site and
 seq_line = prline and seq_due_date = ts_date no-error.
 if available seq_mstr then do:
 if seq_part = tsm_part then assign
 seq_qty_req = seq_qty_req + tsm_qty_req
 seq__dec02 = seq__dec02 + tsm_dec02.
 else do:
 next_priority  = seq_priority.
 create seq_mstr.
 assign
         seq_domain = global_domain  
         seq_due_date = ts_date
         seq_line = tsm_line
         seq_mode = tsm_mode
         seq_mode_qty = tsm_mode_qty
         seq_part = tsm_part
         seq_priority = next_priority + 1
         seq_qty_req = tsm_qty_req
         seq_release = tsm_release
         seq_shift1 = tsm_shift1
         seq_shift2 = tsm_shift2
         seq_shift3 = tsm_shift3
         seq_shift4 = tsm_shift4
         seq_site = tsm_site
         seq_start = tsm_start
         seq_type = tsm_type
         seq_user1 = tsm_user1
         seq_user2 = tsm_user2
         seq__chr01 = tsm_chr01
         seq__chr02 = tsm_chr02
         seq__chr03 = tsm_chr03
         seq__chr04 = tsm_chr04
         seq__chr05 = tsm_chr05
         seq__dec01 = tsm_dec01
         seq__dec02 = tsm_dec02
         seq__dec03 = tsm_dec03
         seq__log01 = tsm_log01
         .
 
 end. /*else do:*/
 end. /*if available seq_mstr */
 else do:
 create seq_mstr.
 assign
          seq_domain = global_domain 
	  seq_due_date = ts_date
         seq_line = tsm_line
         seq_mode = tsm_mode
         seq_mode_qty = tsm_mode_qty
         seq_part = tsm_part
         seq_priority = next_priority + 1
         seq_qty_req = tsm_qty_req
         seq_release = tsm_release
         seq_shift1 = tsm_shift1
         seq_shift2 = tsm_shift2
         seq_shift3 = tsm_shift3
         seq_shift4 = tsm_shift4
         seq_site = tsm_site
         seq_start = tsm_start
         seq_type = tsm_type
         seq_user1 = tsm_user1
         seq_user2 = tsm_user2
         seq__chr01 = tsm_chr01
         seq__chr02 = tsm_chr02
         seq__chr03 = tsm_chr03
         seq__chr04 = tsm_chr04
         seq__chr05 = tsm_chr05
         seq__dec01 = tsm_dec01
         seq__dec02 = tsm_dec02
         seq__dec03 = tsm_dec03
         seq__log01 = tsm_log01
         .
 
 end. /*else do*/
 next_priority = next_priority + 1.
 
 end. /*for each tsm_move */

for each tsm_move:
delete tsm_move.
end.

 

 if ts_cap < ts_used + move_cap and ts_free_cap > 0  then  do:
 free_cap = min(ts_free_cap, ts_used + move_cap - ts_cap) .
 move_cap = free_cap.
 find first seq_mstr EXCLUSIVE-LOCK where  seq_domain = global_domain and  seq_site = site 
    and seq_line = prline and seq_due_date = ts_date no-error.
   if available seq_mstr then do:
    create tsm_move.
    assign
         tsm_due_date = seq_due_date
         tsm_line = seq_line
         tsm_mode = seq_mode
         tsm_mode_qty = seq_mode_qty
         tsm_part = seq_part
         tsm_priority = seq_priority
         tsm_qty_req = seq_qty_req
         tsm_release = seq_release
         tsm_shift1 = seq_shift1
         tsm_shift2 = seq_shift2
         tsm_shift3 = seq_shift3
         tsm_shift4 = seq_shift4
         tsm_site = seq_site
         tsm_start = seq_start
         tsm_type = seq_type
         tsm_user1 = seq_user1
         tsm_user2 = seq_user2
         tsm_chr01 = seq__chr01
         tsm_chr02 = seq__chr02
         tsm_chr03 = seq__chr03
         tsm_chr04 = seq__chr04
         tsm_chr05 = seq__chr05
         tsm_dec01 = seq__dec01
         tsm_dec02 = seq__dec02
         tsm_dec03 = seq__dec03
         tsm_log01 = seq__log01.
	
	tsm_qty_req = min(round((((free_cap - seq__dec01) / seq__dec02 ) * seq_qty_req + 0.9999999), 0) , seq_qty_req ).
	free_cap = free_cap - seq__dec01 - tsm_qty_req * seq__dec02 / seq_qty_req.
	tsm_dec02 = seq__dec02 * tsm_qty_req / seq_qty_req.
	if tsm_qty_req >= seq_qty_req then seq_qty_req = 0 .
	else assign seq_qty_req = seq_qty_req - tsm_qty_req
	            seq__dec01 = 0
		    seq__dec02 = seq__dec02 - tsm_dec02.
	end.
	else free_cap = 0.
   
  

/*以下程序有时出错  */

  do while free_cap > 0:
  find next  seq_mstr  EXCLUSIVE-LOCK where  seq_domain = global_domain and  seq_site = site 
    and seq_line = prline and seq_due_date = ts_date no-error.
   if available seq_mstr then do:
    create tsm_move.
    assign
         tsm_due_date = seq_due_date
         tsm_line = seq_line
         tsm_mode = seq_mode
         tsm_mode_qty = seq_mode_qty
         tsm_part = seq_part
         tsm_priority = seq_priority
         tsm_qty_req = seq_qty_req
         tsm_release = seq_release
         tsm_shift1 = seq_shift1
         tsm_shift2 = seq_shift2
         tsm_shift3 = seq_shift3
         tsm_shift4 = seq_shift4
         tsm_site = seq_site
         tsm_start = seq_start
         tsm_type = seq_type
         tsm_user1 = seq_user1
         tsm_user2 = seq_user2
         tsm_chr01 = seq__chr01
         tsm_chr02 = seq__chr02
         tsm_chr03 = seq__chr03
         tsm_chr04 = seq__chr04
         tsm_chr05 = seq__chr05
         tsm_dec01 = seq__dec01
         tsm_dec02 = seq__dec02
         tsm_dec03 = seq__dec03
         tsm_log01 = seq__log01.
	tsm_qty_req = min(round((((free_cap - seq__dec01) / seq__dec02 ) * seq_qty_req + 0.9999999), 0) , seq_qty_req ).
	free_cap = free_cap - seq__dec01 - tsm_qty_req * seq__dec02 / seq_qty_req.
	tsm_dec02 = seq__dec02 * tsm_qty_req / seq_qty_req.
	if tsm_qty_req >= seq_qty_req then seq_qty_req = 0 .
	else assign seq_qty_req = seq_qty_req - tsm_qty_req
	            seq__dec01 = 0
		    seq__dec02 = seq__dec02 - tsm_dec02.
	end.
	else free_cap = 0.
   
	end.  /*do while ***********/

   end. /*if ts_cap < ts_used + move_cap and ts_free_cap > 0 then */
     else  move_cap = 0.

/*  end. */
  
 
 
release seq_mstr. 

  for each tsm1_move:
 delete tsm1_move.
 end.

ii = 1.

  for each  seq_mstr where  seq_domain = global_domain and  seq_site = site 
 and seq_line = prline and seq_due_date = ts_date no-lock :
 
 /***********************************************************
 if  seq_priority >= 500  then do:
 find pt_mstr where pt_part = seq_part no-lock.
 
 if pt_run_seq1 = "000"   and seq_priority >= 500  and seq_qty_req > 0  then do:
  find last tsm1_move where tsm1_site = seq_site and
  tsm1_line = seq_line  and tsm1_part = seq_part 
  and tsm1_due_date = seq_due_date no-error.
  if available tsm1_move then tsm1_qty_req = tsm1_qty_req + seq_qty_req .
 
  else do :
  create tsm1_move.
 assign 
         tsm1_due_date = seq_due_date
         tsm1_line = seq_line
         tsm1_mode = seq_mode
         tsm1_mode_qty = seq_mode_qty
         tsm1_part = seq_part
         tsm1_priority = seq_priority
         tsm1_qty_req = seq_qty_req
         tsm1_release = seq_release
         tsm1_shift1 = seq_shift1
         tsm1_shift2 = seq_shift2
         tsm1_shift3 = seq_shift3
         tsm1_shift4 = seq_shift4
         tsm1_site = seq_site
         tsm1_start = seq_start
         tsm1_type = seq_type
         tsm1_user1 = seq_user1
         tsm1_user2 = seq_user2
         tsm1_chr01 = seq__chr01
         tsm1_chr02 = seq__chr02
         tsm1_chr03 = seq__chr03
         tsm1_chr04 = seq__chr04
         tsm1_chr05 = seq__chr05
         tsm1_dec01 = seq__dec01
         tsm1_dec02 = seq__dec02
         tsm1_dec03 = seq__dec03
         tsm1_log01 = seq__log01.
  
 tsm1_priority =  ii.
 ii = ii + 1.
 end.  /*else do*/
 
 end.  /*if pt_run_seq1 = "000"   and seq_priority >= 80  and seq_qty_req > 0 */
 
 else do:
 
  if seq_qty_req > 0 then do:
  
  create tsm1_move.
 assign 
         tsm1_due_date = seq_due_date
         tsm1_line = seq_line
         tsm1_mode = seq_mode
         tsm1_mode_qty = seq_mode_qty
         tsm1_part = seq_part
         tsm1_priority = seq_priority
         tsm1_qty_req = seq_qty_req
         tsm1_release = seq_release
         tsm1_shift1 = seq_shift1
         tsm1_shift2 = seq_shift2
         tsm1_shift3 = seq_shift3
         tsm1_shift4 = seq_shift4
         tsm1_site = seq_site
         tsm1_start = seq_start
         tsm1_type = seq_type
         tsm1_user1 = seq_user1
         tsm1_user2 = seq_user2
         tsm1_chr01 = seq__chr01
         tsm1_chr02 = seq__chr02
         tsm1_chr03 = seq__chr03
         tsm1_chr04 = seq__chr04
         tsm1_chr05 = seq__chr05
         tsm1_dec01 = seq__dec01
         tsm1_dec02 = seq__dec02
         tsm1_dec03 = seq__dec03
         tsm1_log01 = seq__log01.
  
 tsm1_priority =  ii.
 ii = ii + 1.
 end. /*if seq_qty_req > 0 then do:*/
  
 end. /*els do:*/
 
 end. /*if seq_priority >= 80  then do: */
 else do:
 ******************************************************/
 if seq_qty_req > 0 then do:
  
  create tsm1_move.
 assign 
         tsm1_due_date = seq_due_date
         tsm1_line = seq_line
         tsm1_mode = seq_mode
         tsm1_mode_qty = seq_mode_qty
         tsm1_part = seq_part
         tsm1_priority = seq_priority
         tsm1_qty_req = seq_qty_req
         tsm1_release = seq_release
         tsm1_shift1 = seq_shift1
         tsm1_shift2 = seq_shift2
         tsm1_shift3 = seq_shift3
         tsm1_shift4 = seq_shift4
         tsm1_site = seq_site
         tsm1_start = seq_start
         tsm1_type = seq_type
         tsm1_user1 = seq_user1
         tsm1_user2 = seq_user2
         tsm1_chr01 = seq__chr01
         tsm1_chr02 = seq__chr02
         tsm1_chr03 = seq__chr03
         tsm1_chr04 = seq__chr04
         tsm1_chr05 = seq__chr05
         tsm1_dec01 = seq__dec01
         tsm1_dec02 = seq__dec02
         tsm1_dec03 = seq__dec03
         tsm1_log01 = seq__log01.
  
 tsm1_priority =  ii.
 ii = ii + 1.
 end. /*if seq_qty_req > 0 then do:*/
 
  end.

for each  seq_mstr where  seq_domain = global_domain and  seq_site = site 
 and seq_line = prline and seq_due_date = ts_date     :
  delete seq_mstr.
end.
 
 release seq_mstr.

  for each tsm1_move  :
   create seq_mstr.
  assign 
         seq_domain = global_domain  
         seq_due_date = tsm1_due_date
         seq_line = tsm1_line
         seq_mode = tsm1_mode
         seq_mode_qty = tsm1_mode_qty
         seq_part = tsm1_part
         seq_priority = tsm1_priority 
         seq_qty_req = tsm1_qty_req
         seq_release = tsm1_release
         seq_shift1 = tsm1_shift1
         seq_shift2 = tsm1_shift2
         seq_shift3 = tsm1_shift3
         seq_shift4 = tsm1_shift4
         seq_site = tsm1_site
         seq_start = tsm1_start
         seq_type = tsm1_type
         seq_user1 = tsm1_user1
         seq_user2 = tsm1_user2
         seq__chr01 = tsm1_chr01
         seq__chr02 = tsm1_chr02
         seq__chr03 = tsm1_chr03
         seq__chr04 = tsm1_chr04
         seq__chr05 = tsm1_chr05
         seq__dec01 = tsm1_dec01
         seq__dec02 = tsm1_dec02
         seq__dec03 = tsm1_dec03
         seq__log01 = tsm1_log01
         .
 
 
  end. 
 
 end. /*for each ts_work */
 
lundo-input2 = no.
undo-input1 = no.

 
