/* DISPLAY TITLE */
/*GA24*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */
/* MaxLen: Comment: */
/* ********** End Translatable Strings Definitions ********* */

define var unit_st_mtl_cost as decimal format "->>>,>>>,>>>,>>9.99<<<" .
define var unit_st_cost as decimal format "->>>,>>>,>>>,>>9.99<<<" .
define var value_qty_com_std as decimal format "->>>,>>>,>>>,>>9.99<<<" .
define var value_qty_com_mat_std as decimal format "->>>,>>>,>>>,>>9.99<<<".
define var value_rej_std as decimal format "->>>,>>>,>>>,>>9.99<<<" .
define var value_rej_mat_std as decimal format "->>>,>>>,>>>,>>9.99<<<" .
define var open_qty as decimal format "->>>,>>>,>>9.9<<<<<<<<" .

DEFINE VAR site LIKE ptp_site.
DEFINE VAR nbr LIKE wo_nbr.
DEFINE VAR nbr1 LIKE wo_nbr.
DEFINE VAR part LIKE wo_part.
DEFINE VAR part1 LIKE wo_part.
DEFINE VAR lot LIKE wo_lot.
DEFINE VAR lot1 LIKE wo_lot.
DEFINE VAR reldate LIKE wo_rel_date.
DEFINE VAR reldate1 LIKE wo_rel_date.
DEFINE VAR duedate LIKE wo_due_date.
DEFINE VAR duedate1 LIKE wo_due_date.
DEFINE VAR effdate LIKE tr_effdate.
DEFINE VAR effdate1 LIKE tr_effdate.
DEFINE VAR ptgroup LIKE pt_group.
DEFINE VAR ptgroup1 LIKE pt_group.
DEFINE VAR buy LIKE ptp_buyer.
DEFINE VAR buy1 LIKE ptp_buyer.

     form
        nbr         colon 15
        nbr1        label {t001.i} colon 49 skip
        part        colon 15
        part1       label {t001.i} colon 49 skip
        lot         colon 15
        lot1        label {t001.i} colon 49 skip
        reldate     colon 15
        reldate1    label {t001.i} colon 49 skip
        duedate     colon 15
        duedate1    label {t001.i} colon 49 skip
        effdate     colon 15
        effdate1    label {t001.i} colon 49 skip (1)
        ptgroup     colon 15
        ptgroup1    label {t001.i} colon 49 SKIP
        buy         colon 15
        buy1        label {t001.i} colon 49 SKIP

     with frame a side-labels width 80 attr-space.


/*K0WH*/ {wbrp01.i}
repeat on error undo, retry:

    if nbr1 = hi_char then nbr1 = "".
    if part1 = hi_char then part1 = "".
    if lot1 = hi_char then lot1 = "".
    if ptgroup1 = hi_char then  ptgroup1 = "".
    if  buy1 = hi_char then  buy1 = "".
    
    if reldate = low_date then reldate = ?.
    if reldate1 = low_date then reldate1 = ?.

    if duedate = low_date then duedate = ?.
    if duedate1 = low_date then duedate1 = ?.

    if effdate = low_date then effdate = ?.
    if effdate1 = low_date then effdate1 = ?.


/*K0WH*/  if c-application-mode <> 'web':u then update
       nbr       nbr1
       part      part1
      lot       lot1
       reldate   reldate1
       duedate   duedate1
       effdate   effdate1
       ptgroup   ptgroup1
       buy       buy1
    with frame a .


/*K0WH*/ {wbrp06.i &command = update &fields = "  nbr nbr1  part part1  lot lot1  reldate reldate1  
duedate   duedate1 effdate  effdate1  ptgroup   ptgroup1 buy buy1 " &frm = "a"}

/*K0WH*/ if (c-application-mode <> 'web':u) or
/*K0WH*/ (c-application-mode = 'web':u and
/*K0WH*/ (c-web-request begins 'data':u)) then do:


    bcdparm = "".
     {mfquoter.i nbr     }
     {mfquoter.i nbr1    }
     {mfquoter.i part    }
     {mfquoter.i part1   }
    {mfquoter.i lot     }
    {mfquoter.i lot1    }
    {mfquoter.i reldate     }
    {mfquoter.i reldate1    }
    {mfquoter.i duedate     }
    {mfquoter.i duedate1    }
    {mfquoter.i effdate  }
    {mfquoter.i effdate1 }
    {mfquoter.i ptgroup     }
    {mfquoter.i ptgroup1    }
    {mfquoter.i buy    }
    {mfquoter.i buy1    }


            if nbr1 = "" then nbr1 = hi_char.
            if part1 = "" then part1 = hi_char.
/*J035*/    if lot1 = "" then lot1 = hi_char.
/*J035*/    if reldate = ? then  reldate = low_date.
/*J035*/    if reldate1 = ? then  reldate1 = hi_date.
/*J035*/    if duedate = ? then  duedate = low_date.
/*J035*/    if duedate1 = ? then  duedate1 =  hi_date.
/*J035*/    if effdate = ? then effdate = low_date.
/*J035*/    if effdate1 = ? then effdate1 =  hi_date.
            if ptgroup1 = "" then ptgroup1 = hi_char.
            if buy1 = "" then buy1 = hi_char.


/*K0WH*/ end.

    /* SELECT PRINTER */
        {mfselbpr.i "printer" 132}
    {mfphead.i}

for each ptp_det where (ptp_buyer>=buy OR ptp_buyer="") AND (ptp_buyer<=buy1 OR ptp_buyer="" ) AND (ptp_part>=part OR ptp_part="") AND (ptp_part <=part1 OR ptp_part="") NO-LOCK:
for each pt_mstr where pt_part = ptp_part and ptp_site='SM'  AND (pt_group>=ptgroup OR ptgroup="") AND (pt_group<=ptgroup1 OR ptgroup="") NO-LOCK: 

for each sct_det where sct_part =pt_part and sct_site='SM' and sct_sim='Standard' NO-LOCK:
   FOR EACH wo_mstr where wo_part=sct_part and wo_site='SM'AND (wo_nbr>=nbr OR wo_nbr="") AND (wo_nbr<=nbr1 OR wo_nbr="") 
       AND (wo_rel_date>= reldate OR reldate = ?) 
       AND (wo_rel_date<= reldate1 OR reldate = ?) AND (wo_rel_date>= reldate AND wo_rel_date<= reldate1) AND (wo_due_date>= duedate OR duedate= ? ) 
       AND (wo_due_date<= duedate1 OR duedate1 = ?) AND (wo_due_date>= duedate AND wo_due_date<= duedate1)
       AND (wo_lot>=lot OR wo_lot="") AND (wo_lot<=lot1 OR wo_lot="")

       no-lock:

    For each tr_hist where tr_nbr = wo_nbr and tr_part = wo_part and tr_site = 'sm' and 	
       tr_type= 'rct-wo'
       AND (tr_effdate>= effdate OR effdate= ? ) 
       AND (tr_effdate<= effdate1 OR effdate1= ? ) AND (tr_effdate>= effdate AND tr_effdate<= effdate1 ) 
        no-lock  with no-box stream-io width 320:
     {mfrpchk.i}

    assign unit_st_mtl_cost= sct_mtl_ll + sct_mtl_tl.
    assign unit_st_cost= (sct_bdn_ll + sct_bdn_tl + 	 				
        sct_lbr_ll + sct_lbr_tl + sct_mtl_ll + sct_mtl_tl + sct_ovh_ll
    + sct_ovh_tl + sct_sub_ll + sct_sub_tl).
    assign value_qty_com_std= (unit_st_cost * wo_qty_comp ).
    assign value_qty_com_mat_std=(unit_st_mtl_cost) * wo_qty_comp.
    assign value_rej_std = (wo_qty_rjct * unit_st_cost).
    assign value_rej_mat_std=(unit_st_mtl_cost) * wo_qty_rjct.
    assign open_qty=(wo_qty_ord - wo_qty_comp - wo_qty_rjct ).
   
    Display ptp_buyer pt_group wo_part pt_desc1 wo_nbr wo_lot  wo_due_date 	
        wo_site unit_st_cost unit_st_mtl_cost 
    wo_qty_ord wo_qty_comp value_qty_com_std value_qty_com_mat_std
    wo_qty_rjct value_rej_std value_rej_mat_std open_qty tr_type tr_effdate  tr_qty_chg.
    end.
    end.
end.
end.
end.

  if page-size - line-counter < 3 then page.


/*GA24*/       

    {mfrtrail.i}

 end.

/*K0WH*/ {wbrp04.i &frame-spec = a}


