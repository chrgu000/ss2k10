/* zzagerp3a.p */
/* last modified by tao               */


/* DEFINE VARIABLES */
define  shared variable cust like ar_bill.
define  shared variable cust1 like ar_bill.
define  shared variable inv_date1 like ih_inv_date.
define  shared variable age_days as integer extent 5
                    label "Column Days".
define  shared variable age_range as character extent 6
           format "X(16)" .
define  shared variable age_amt like ar_amt extent 6.
define  shared variable age_tmp like ar_amt extent 6 .
define shared variable xxa_ar_amt like ar_amt label "AR balance". 
define shared variable be_amt like ar_amt label "Beer Amt.".
define shared variable bc_amt like ar_amt label "B&C Amt.".
define variable cd_all as character  .
define variable xxa_region like cm_type .
define variable xxa_name like ad_name .
define variable xxa_amt like ar_amt .
define variable xxa_ab like ar_amt .
define variable xxa_curr like gl_base_curr .
define variable xxa_applied like ar_amt .
define variable taolog as integer initial 0 .
define variable date1 as date .
define variable date2 as date .
define variable i1 as integer .
define new shared variable agebe_amt like ar_amt extent 6 .
define new shared variable agebc_amt like ar_amt extent 6 .
define new shared variable agetot_amt like ar_amt extent 6 .
define new shared workfile age_file
    field age_cust like cm_addr
     field age_cu_name like ad_name 
     field age_region like cm_type
    field age_bc_amt like ar_amt
    field age_be_amt like ar_amt
    field age_ar_amt like ar_amt 
    field age_agear_amt like ar_amt extent 6 . 
/* DEFINE END */



/* DISPLAY TITLE */
find first gl_ctrl no-lock.
xxa_curr = gl_base_curr.
cd_all =  "" .
for each code_mstr where code_fldname = "c&b" :
cd_all = cd_all + "**" + code_cmmt .
end.
for each age_file :
delete age_file .
end.
for each cm_mstr where cm_addr >= cust and cm_addr <= cust1 and cm_bill = ""
break by cm_type with frame b down width 132:
xxa_region = cm_type .
find ad_mstr where ad_addr = cm_addr no-lock no-error .
if available ad_mstr then xxa_name = ad_name .
else xxa_name = "" .
find bcih_hist where bcih_cust = cm_addr and bcih_date = inv_date1 
no-lock no-error .
if available bcih_hist then do:
    xxa_ar_amt = bcih_ar_amt .
    bc_amt = bcih_bc_amt .
    be_amt = bcih_be_amt .
    taolog = 1.
    do i1 = 1 to 6 :
    agebe_amt[i1] = 0 .
    end.

    FOR EACH ih_hist WHERE (ih_inv_date >= inv_date1 - age_days[5] 
    AND ih_inv_date <= inv_date1) and ih_bill = cm_addr  NO-LOCK,
    each idh_hist WHERE (ih_inv_nbr = idh_inv_nbr) 
   and (ih_nbr = idh_nbr) 
  NO-LOCK break by ih_bill :
    if ih_inv_nbr begins "h" then next .
    else do:
    {zzagerp3a.i} 
    end.
    end. /*for each ih_hist*/
    {zzagerp3b.i}
    {zzagerp3c.i}  
    end. /*available bcih_hist*/
    else taolog = 0 .
if taolog <> 1 then do:    
/* Jim
xxa_ab = cm_balance .
   */

/*************************************************************/
/*********Count the customer's balance begin - By Jim*********/
/*************************************************************/

find first gl_ctrl no-lock no-error.
if cm_curr = gl_base_curr then do:
   xxa_ab = cm_balance.
end.
else do:
   xxa_ab = 0.
   for each ar_mstr where ar_bill = cm_addr and ar_type <> "d" no-lock:
            xxa_ab = xxa_ab + (ar_amt - ar_applied).
   end.
end.

/*************************************************************/
/*********Count the customer's balance end - By Jim***********/
/*************************************************************/

for each ar_mstr where ar_bill = cm_addr
and ar_effdate > inv_date1
and ar_type <> "a"
and ar_type <> "d"
no-lock:


if xxa_curr <> ar_curr then do:
xxa_amt = ar_amt * (ar_ex_rate2 / ar_ex_rate).
xxa_amt = round(xxa_amt,gl_ex_round).
xxa_applied = ar_applied * (ar_ex_rate2 / ar_ex_rate).
xxa_applied = round(ar_applied,gl_ex_round).
end.
else do:

   
xxa_amt = ar_amt.
xxa_applied = ar_applied.


end.

   
xxa_ab = xxa_ab - xxa_amt /*- xxa_applied.*/.
end.     /*for each ar_mstr*/

xxa_ar_amt = xxa_ab .  /*get ar balance*/
  do i1 = 1 to 6:
  agebe_amt[i1] = 0 .
  end.
 find last bcih_hist where bcih_cust = cm_addr and bcih_date < inv_date1  no-lock no-error .
     if available bcih_hist then do:
     bc_amt = bcih_bc_amt .
     date1 = bcih_date .
     end.
          else do:
          bc_amt = 0 .
          date1 = 01/01/95 .
          end . 
if date1 > inv_date1 - age_days[5] then do:
    date2 = date1 .
    date1 = inv_date1 - age_days[5] .
    end .

    else date2 = date1.

    for each ar_mstr where (ar_bill = cm_addr) and 
    (ar_effdate >= date1 and ar_effdate <= inv_date1 ) and ar_type = "i",
    each ih_hist where ih_bill = ar_bill and ih_inv_nbr = ar_nbr,
    each idh_hist where idh_inv_nbr = ih_inv_nbr and ih_nbr = idh_nbr
    break by ar_bill :
    find pt_mstr where pt_part = idh_part no-lock no-error .
    if available pt_mstr then do:   
    if index(cd_all,"**" + idh_part) <> 0 and ar_effdate > date2 
    then do:
    bc_amt = bc_amt + (idh_qty_inv / idh_um_conv * idh_price) / ih_ex_rate .
    end. /*index matches*/
/*    else do:  */
if ih_inv_nbr begins "h" then next .
else do:
      {zzagerp3a.i}      
   end.    
   end.  /*available pt_mstr*/                   
end.    /*for each idh_hist*/
be_amt = xxa_ar_amt - bc_amt .
{zzagerp3b.i} 
{zzagerp3c.i}  
bc_amt = 0.
be_amt = 0.
end. /*if tao_log <> 1*/
end.  /*for each cm_mstr*/
/*display "123456789a123456789b123456789c123456789d123456789e123456789g123456789h123456789i123456789j123456789k123456789l123456789m123456789n123456789o123456789p123456789q123456789r123456789s123456789t" format "x(210)" with  width 256  .
down 1 . */
display space(60) "Total AR aging report" skip.
display "Customer" format "x(8)" "Reg." format "x(4)" "Name" format "x(28)"
"          AR" format "x(16)" "        Beer" format "x(16)" "         C&B" format "x(16)" 
"          0-" + string(age_days[1]) format "x(16)" 
"          " + string(age_days[1]) + "-" + string(age_days[2]) format "x(16)"
"          " + string(age_days[2]) + "-" + string(age_days[3]) format "x(16)"
"          " + string(age_days[3]) + "-" + string(age_days[4]) format "x(16)"
"          " + string(age_days[4]) + "-" + string(age_days[5]) format "x(16)"
"       " + "Over" + string(age_days[5]) format "x(16)" with width 256 .
down 1 .
for each age_file :
if length(age_cust) > 6 and
age_ar_amt = 0 and age_be_amt = 0 and age_bc_amt = 0
and age_agear_amt[1] = 0 and age_agear_amt[2] = 0 and age_agear_amt[3] = 0
and age_agear_amt[4] = 0 and age_agear_amt[5] = 0 then next .
else
display age_cust age_region age_cu_name age_ar_amt age_be_amt age_bc_amt 
age_agear_amt[1] age_agear_amt[2] age_agear_amt[3] age_agear_amt[4]
age_agear_amt[5] age_agear_amt[6] with width 256 no-label .
end.
