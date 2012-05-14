/*zzspechk.p   Specification Check */
/*Last Modify by Leo Zhou   11/08/2011 */

{mfdeclre.i}

def input parameter v_lotno  like zzsellot_lotno.
def input parameter v_rwknum as char.
def input parameter v_part   like pt_part.
def output parameter v_result as logical.
/* def output parameter v_rmks as char no-undo.  */
def var v_rmks as char no-undo.
def var v_wt_max  like zzsellot_insp_diviedweight.
def var v_wt_min  like zzsellot_insp_diviedweight.
def var v_dn_max  like zzsellot_insp_dn.
def var v_dn_min  like zzsellot_insp_dn.
def var v_mfd_max like zzsellot_insp_mfd.
def var v_mfd_min like zzsellot_insp_mfd.
def var v_cut_max like zzsellot_insp_cutoff.
def var v_cut_min like zzsellot_insp_cutoff.
def var v_zdw_max like zzsellot_insp_zdw.
def var v_zdw_min like zzsellot_insp_zdw.
def var v_dia_max like zzsellot_insp_dia.
def var v_dia_min like zzsellot_insp_dia.
def var v_non_max like zzsellot_insp_noncirc.
def var v_non_min like zzsellot_insp_noncirc.
def var v_eln_max like zzsellot_insp_efflength.
def var v_eln_min like zzsellot_insp_efflength.
def var v_len_max like zzsellot_insp_efflength.
def var v_len_min like zzsellot_insp_efflength.
def var v_adj like zzsellot_insp_efflength.
def var v_macno as int.

v_result = no.

find first zzsellot_mstr no-lock where zzsellot_domain = global_domain
      and zzsellot_lotno = v_lotno 
      and (zzsellot_reworknum = v_rwknum or 
           zzsellot_final = "1" and v_rwknum = "" ) no-error.
v_rmks = "find zzsellot_mstr".
if not avail zzsellot_mstr then return.

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00041" no-error.
v_rmks = "00041".
if not avail mpd_det or zzsellot_extralen_tech <> deci(mpd_tol) then return.

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00042" no-error.
v_rmks = "00042".
if not avail mpd_det or zzsellot_extralen_other <> deci(mpd_tol) then return.

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00015" no-error.
if avail mpd_det then v_wt_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00016" no-error.
if avail mpd_det then v_wt_min = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00039" no-error.
if avail mpd_det then do:
   if mpd_tol = "1" then do:
      v_rmks = "zzsellot_insp_diviedweight:" + string(zzsellot_insp_diviedweight)
               + "  Min:" + string(v_wt_min)
	       + "  Max:" + string(v_wt_max).
      if zzsellot_insp_diviedweight < v_wt_min or
         zzsellot_insp_diviedweight > v_wt_max then return.
   end.
   else do:
      v_rmks = "zzsellot_insp_calcweight:" + string(zzsellot_insp_calcweight)
               + "  Min:" + string(v_wt_min)
	       + "  Max:" + string(v_wt_max).
      if zzsellot_insp_calcweight < v_wt_min or
         zzsellot_insp_calcweight > v_wt_max then return.
   end.
end.

v_rmks = "CalcWT:" + string(zzsellot_insp_calcweight)
        + "  DiviedWT:"  + string(zzsellot_insp_diviedweight) /*
	+ string( zzsellot_insp_calcweight > zzsellot_insp_diviedweight) */ .

if zzsellot_insp_calcweight > zzsellot_insp_diviedweight then return.

/*dn*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00025" no-error.
if avail mpd_det then v_dn_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00026" no-error.
if avail mpd_det then v_dn_min = deci(mpd_tol).

v_rmks = "zzsellot_insp_dn:" + string(zzsellot_insp_dn)
               + "  Min:" + string(v_dn_min)
	       + "  Max:" + string(v_dn_max).
if zzsellot_insp_dn < v_dn_min or
   zzsellot_insp_dn > v_dn_max then return.

/*mfd*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00019" no-error.
if avail mpd_det then v_mfd_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00020" no-error.
if avail mpd_det then v_mfd_min = deci(mpd_tol).

v_rmks = "zzsellot_insp_mfd:" + string(zzsellot_insp_mfd)
               + "  Min:" + string(v_mfd_min)
	       + "  Max:" + string(v_mfd_max).

if zzsellot_insp_mfd < v_mfd_min or
   zzsellot_insp_mfd > v_mfd_max then return.

/*cutoff*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00017" no-error.
if avail mpd_det then v_cut_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00018" no-error.
if avail mpd_det then v_cut_min = deci(mpd_tol).

v_rmks = "zzsellot_insp_cutoff:" + string(zzsellot_insp_cutoff)
               + "  Min:" + string(v_cut_min)
	       + "  Max:" + string(v_cut_max).

if zzsellot_insp_cutoff < v_cut_min or
   zzsellot_insp_cutoff > v_cut_max then return.

/*zdw*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00023" no-error.
if avail mpd_det then v_zdw_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00024" no-error.
if avail mpd_det then v_zdw_min = deci(mpd_tol).

v_rmks = "zzsellot_insp_zdw:" + string(zzsellot_insp_zdw)
               + "  Min:" + string(v_zdw_min)
	       + "  Max:" + string(v_zdw_max).

if zzsellot_insp_zdw < v_zdw_min or
   zzsellot_insp_zdw > v_zdw_max then return.

/*Ecc*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00027" no-error.
v_rmks = "00027".
if not avail mpd_det or zzsellot_insp_ecc > deci(mpd_tol) then return.

/*dia*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00013" no-error.
if avail mpd_det then v_dia_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00014" no-error.
if avail mpd_det then v_dia_min = deci(mpd_tol).

v_rmks = "zzsellot_insp_dia:" + string(zzsellot_insp_dia)
               + "  Min:" + string(v_dia_min)
	       + "  Max:" + string(v_dia_max).

if zzsellot_insp_dia < v_dia_min or
   zzsellot_insp_dia > v_dia_max then return.

/*diavar*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00029" no-error.
v_rmks = "00029".
if not avail mpd_det or zzsellot_insp_diavar > deci(mpd_tol) then return.

/*noncirc*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00034" no-error.
if avail mpd_det then v_non_max = deci(mpd_tol).

find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00035" no-error.
if avail mpd_det then v_non_min = deci(mpd_tol).

v_rmks = "zzsellot_insp_noncirc:" + string(zzsellot_insp_noncirc)
               + "  Min:" + string(v_non_min)
	       + "  Max:" + string(v_non_max).

if zzsellot_insp_noncirc < v_non_min or
   zzsellot_insp_noncirc > v_non_max then return.

/*slope*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00032" no-error.
v_rmks = "00032".
if not avail mpd_det or zzsellot_insp_slope > deci(mpd_tol) then return.

/*d1285*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00033" no-error.
v_rmks = "00033".
if not avail mpd_det or zzsellot_insp_d1285 < deci(mpd_tol) then return.

/*bow*/
find first mpd_det no-lock where mpd_domain = global_domain
     and mpd_nbr = "X7" + v_part and mpd_type = "00030" no-error.
v_rmks = "00030".
if not avail mpd_det or zzsellot_insp_bow > zzsellot_insp_efflength * deci(mpd_tol) * 1000
then return.

/*Effective Length*/
if zzsellot_insp_defect <> "*" then do:
	find first mpd_det no-lock where mpd_domain = global_domain
	and mpd_nbr = "X7" + v_part and mpd_type = "00011" no-error.
	if avail mpd_det then v_len_max = deci(mpd_tol).
	
	find first mpd_det no-lock where mpd_domain = global_domain
	and mpd_nbr = "X7" + v_part and mpd_type = "00012" no-error.
	if avail mpd_det then v_len_min = deci(mpd_tol).
	
	/*Diff_Adjusted_Length*/
	find first mpd_det no-lock where mpd_domain = global_domain
	and mpd_nbr = "X7" + v_part and mpd_type = "00040" no-error.
	if avail mpd_det then v_adj = deci(mpd_tol).
	
	v_rmks = "zzsellot_insp_efflength:" + string(zzsellot_insp_efflength)
               + "  Min:" + string(v_len_min)
	       + "  Max:" + string(v_len_max) 
	       + "  Adj" + string(v_adj).

	if zzsellot_insp_efflength + v_adj < v_len_min or
	   zzsellot_insp_efflength + v_adj > v_len_max then return.
end.
else do:
	find first mpd_det no-lock where mpd_domain = global_domain
	and mpd_nbr = "X7" + v_part and mpd_type = "00036" no-error.
	v_rmks = "00036".
	if not avail mpd_det or mpd_tol <> "1" then return.
end.

v_result = yes.
