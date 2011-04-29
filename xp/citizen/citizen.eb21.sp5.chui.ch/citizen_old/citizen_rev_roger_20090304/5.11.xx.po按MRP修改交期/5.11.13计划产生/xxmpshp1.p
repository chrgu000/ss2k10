/* xxmpshp1.p 根据采购件的mrp需求日,和料件交货周次设定,自动分配交货日 */
/* Rev: 01 , create by sofspeed Roger Xiao  ,  ECO:/*xp001*/      */

/* ************************************************
v_type 每x周	交货y次	订在周z交货
(空)		1		1		1
A		1		1		3
B		1		2		1,3
C		1		2		2,4
D		1		3		1,3,5
E		2		1		1

注:如交货日非工作日(hd_mstr),则提前到前一交货期			
************************************************ */


{mfdeclre.i}

  
 
define input  parameter site like mrp_site .
define input  parameter v_part like pt_part .
define input  parameter v_need as date .
define input  parameter v_effdate as date .
define output parameter v_need1 as date .

/*
define var v_need as date .
define var v_effdate as date .
define var site like mrp_site .
define var v_need1 as date .*/


define var v_type as char .
define var v_week1 as integer .
define var v_week2 as integer .
define var v_week3 as integer .
define var v_wks   as integer .
define var v_need2 as integer .


v_type = "" .
v_need2 = 0 .
find first pt_mstr where pt_domain = global_domain and  pt_part = v_part no-lock no-error .
if avail pt_mstr then do:
	v_need2 =  pt_sfty_time + pt_insp_lead .
	v_type = pt__chr02 .
end.

v_need  = v_need  - v_need2 .
if v_need < v_effdate then  v_need =  v_effdate .


/*
repeat while v_need2 > 0 :
	if v_need <= v_effdate then leave .
	find first hd_mstr where hd_domain = global_domain and hd_site = site and hd_date = v_need no-lock no-error .
	if avail hd_mstr then do:
		v_need = v_need - 1 .
	end.
	else do:
		v_need = v_need - 1 .
		v_need2 = v_need2 - 1 .	
		
		repeat :
			if (weekday(v_need) = 1 or weekday(v_need) = 7) then v_need = v_need - 1 .
			else leave .
		end .
	end.
end.
if v_need < v_effdate then  v_need =  v_effdate .

*/


case v_type :
	when ""   then assign v_week1 = 2  v_week2 = 0  v_week3 = 0 .
	when "C"  then assign v_week1 = 3  v_week2 = 0  v_week3 = 0 .
	when "A"  then assign v_week1 = 4  v_week2 = 0  v_week3 = 0 .
	when "B"  then assign v_week1 = 4  v_week2 = 2  v_week3 = 0 .
	
	when "D"  then assign v_week1 = 6  v_week2 = 4  v_week3 = 2 .
	when "E"  then assign v_week1 = 2  v_week2 = 0  v_week3 = 0 .
	when "F"  then assign v_week1 = 2  v_week2 = 0  v_week3 = 0 .
end case .

v_need1 = v_need .
v_wks = 0 .
repeat while v_need1 >= v_effdate :
	find first hd_mstr where hd_domain = global_domain and hd_site = site and hd_date = v_need1 no-lock no-error .
	if avail hd_mstr then do:
		v_need1 = v_need1 - 1 .
	end.
	else do:
		if weekday(v_need1) = v_week1 or weekday(v_need1) = v_week2 or weekday(v_need1) = v_week3 then do :
			v_wks = v_wks + 1  .
			if v_type = "F" then do:
				if v_wks = 4 then leave .
				v_need1 = v_need1 - 1 .
			end.
			else if v_type = "E" then do :
				if v_wks = 2 then leave .
				v_need1 = v_need1 - 1 .
			end.
			else leave .
		end.
		else do:
			v_need1 = v_need1 - 1 .
		end.
	end.
end.

if v_wks <= 0 then do: /*提前期不足*/
	v_need1 = today .
end.

/*message v_need v_need1 v_wks skip v_type v_week1 v_week2 v_week3 view-as alert-box .*/