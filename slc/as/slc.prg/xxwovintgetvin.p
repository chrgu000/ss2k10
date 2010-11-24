/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/*By: Neil Gao 09/03/06 ECO: *SS 20090306* */


/*-
得到17 位 VIN码--BEGIN
					{gprun.i ""xxwovintgetvin.p"" 
					"(input strQianBaWei, 
					input strShiShiYi , 
					output v_number)"}
xxwovint01.p调用
*/
pause 0.
{mfdeclre.i}
{gplabel.i}
def input parameter strQianBaWei as char .
def input parameter strShiShiYi  as char .
def input parameter strnb				 as int.
def output parameter v_number    as char .
define variable lastnumber as int.
DEFINE VARIABLE tmp_char as char .
DEFINE VARIABLE intTOT as integer .
DEFINE VARIABLE i as integer .
DEFINE VARIABLE intI as integer .
v_number = "" .
find first xxslc_mstr where xxslc_domain = global_domain
	and xxslc_QianBaWei = strQianBaWei
	and xxslc_ShiShiYi = strShiShiYi
	no-error.
if not avail xxslc_mstr then do:
	create xxslc_mstr.
	assign 
		xxslc_domain    = global_domain
		xxslc_QianBaWei = strQianBaWei
		xxslc_ShiShiYi  = strShiShiYi  
		xxslc_last_number = 9 .		/*最多6位*/
end.
if strnb = 0 then do:
	assign xxslc_last_number = xxslc_last_number + 1 .
	lastnumber = xxslc_last_number.
end.
else do:
	lastnumber = strnb.
end.
if lastnumber >= 1000000 then do:
		message "顺序号已经超过 1000000 了，请你更改规则后再重新产生." view-as alert-box .
		v_number = "" .
		leave.
	end.
else do:
		assign v_number = strQianBaWei 
						  + "*"
						  + strShiShiYi
						  + substring("000000",1,(6 - length(string(lastnumber))))
							+ string(lastnumber)
					  	.
	
	/*算出 第9位* 验证码--BEGIN*/
	intTOT = 0 .
	do i = 1 to length(v_number) :
		if i <> 9 then do:
			tmp_char = caps(substring(v_number,i,1)) .
			IF tmp_char = "I" OR 
			   tmp_char = "O" OR 
			   tmp_char = "Q" THEN DO:
			   MESSAGE "VIN码号 " + v_number + " 不能包含 O I Q 字母 " view-as alert-box .
			   v_number = "" .
			   leave .
			END.
			run pro_duiyingzhi(input-output tmp_char) .
			run pro_JiaQuanXiShu(input i , output intI) .
			assign intTOT = intTOT + ( integer(tmp_char) * intI ).
		end.
	end.	
	if v_number <> "" then do:
		intTOT = intTOT mod 11 .	/*对11取余 IF = 10 then X */
		assign v_number = substring(v_number,1,8) 
							+ (if intTOT = 10 then "X" else string(intTOT))
							+ substring(v_number,10,8) 
							.
	end.
	/*算出 第9位* 验证码--end*/
end.

procedure pro_JiaQuanXiShu:
def input parameter pro_i as inte .
def output parameter pro_intI as inte .
		 if pro_i = 1 then pro_intI = 8 .
	else if pro_i = 2 then pro_intI = 7 .
	else if pro_i = 3 then pro_intI = 6 .
	else if pro_i = 4 then pro_intI = 5 .
	else if pro_i = 5 then pro_intI = 4 .
	else if pro_i = 6 then pro_intI = 3 .
	else if pro_i = 7 then pro_intI = 2 .
	else if pro_i = 8 then pro_intI = 10 .

	else if pro_i = 10 then pro_intI = 9 .
	else if pro_i = 11 then pro_intI = 8 .
	else if pro_i = 12 then pro_intI = 7 .
	else if pro_i = 13 then pro_intI = 6 .
	else if pro_i = 14 then pro_intI = 5 .
	else if pro_i = 15 then pro_intI = 4 .
	else if pro_i = 16 then pro_intI = 3 .
	else if pro_i = 17 then pro_intI = 2 .
end.

procedure pro_duiyingzhi:
def input-output parameter pro_char as char .
pro_char = caps(pro_char).
		 if pro_char = "0" then assign pro_char = "0" .
	else if pro_char = "1" then assign pro_char = "1" .
	else if pro_char = "2" then assign pro_char = "2" .
	else if pro_char = "3" then assign pro_char = "3" .
	else if pro_char = "4" then assign pro_char = "4" .
	else if pro_char = "5" then assign pro_char = "5" .
	else if pro_char = "6" then assign pro_char = "6" .
	else if pro_char = "7" then assign pro_char = "7" .
	else if pro_char = "8" then assign pro_char = "8" .
	else if pro_char = "9" then assign pro_char = "9" .

	else if pro_char = "A" then assign pro_char = "1" .
	else if pro_char = "B" then assign pro_char = "2" .
	else if pro_char = "C" then assign pro_char = "3" .
	else if pro_char = "D" then assign pro_char = "4" .
	else if pro_char = "E" then assign pro_char = "5" .
	else if pro_char = "F" then assign pro_char = "6" .
	else if pro_char = "G" then assign pro_char = "7" .
	else if pro_char = "H" then assign pro_char = "8" .

	else if pro_char = "J" then assign pro_char = "1" .
	else if pro_char = "K" then assign pro_char = "2" .
	else if pro_char = "L" then assign pro_char = "3" .
	else if pro_char = "M" then assign pro_char = "4" .
	else if pro_char = "N" then assign pro_char = "5" .
	else if pro_char = "P" then assign pro_char = "7" .
	else if pro_char = "R" then assign pro_char = "9" .

	else if pro_char = "S" then assign pro_char = "2" .
	else if pro_char = "T" then assign pro_char = "3" .
	else if pro_char = "U" then assign pro_char = "4" .
	else if pro_char = "V" then assign pro_char = "5" .
	else if pro_char = "W" then assign pro_char = "6" .
	else if pro_char = "X" then assign pro_char = "7" .
	else if pro_char = "Y" then assign pro_char = "8" .
	else if pro_char = "Z" then assign pro_char = "9" .
end.