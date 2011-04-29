

define temp-table temp1 field t1_wrnbr like xxwrd_wrnbr .
define var v_ord like xxwrd_qty_ord .
define var v_num as integer .

for each temp1 :  delete temp1 . end.


/*查找问题数据*/
for each xxwrd_det 
    fields (xxwrd_wrnbr xxwrd_wolot xxwrd_op 
            xxwrd_qty_ord  xxwrd_qty_comp xxwrd_qty_rejct)
    no-lock
    break by xxwrd_wrnbr by xxwrd_wolot desc by xxwrd_op :

	if first-of(xxwrd_wrnbr) then do:
	v_num = 0 .
	end.
	v_num = v_num + 1 .

	if v_num = 2 then do:
		v_ord = xxwrd_qty_ord - xxwrd_qty_rejct.
	end.
	if v_num > 2 then do:
		if v_ord <> xxwrd_qty_ord  then do:		
			find first temp1 where t1_Wrnbr = xxwrd_wrnbr no-lock no-error .
			if not avail temp1 then do:
					create temp1 .
					t1_wrnbr = xxwrd_wrnbr .
			end.
		end.
		v_ord = xxwrd_qty_ord - xxwrd_qty_rejct.
	end.
end.


/*修正前*/
output to "sfc1.txt" .
    for each temp1 ,
        each xxwrd_det where xxwrd_wrnbr = t1_wrnbr 
        break by xxwrd_wrnbr by xxwrd_wolot desc by xxwrd_op 
        with frame x1 width 200:

        disp xxwrd_wonbr xxwrd_wolot xxwrd_op xxwrd_wrnbr xxwrd_qty_ord xxwrd_qty_comp xxwrd_qty_rejct  xxwrd_opfinish xxwrd_status xxwrd_close with frame x1 . 
        
        if last-of(xxwrd_wrnbr) then do:
            put skip(5) .
        end.
    end.
output close.

/*修正订购量*/
for each temp1 ,
    each xxwrd_det where xxwrd_wrnbr = t1_wrnbr 
    break by xxwrd_wrnbr by xxwrd_wolot desc by xxwrd_op :
    if first-of(xxwrd_wrnbr) then do:
        v_num = 0 .
    end.
    v_num = v_num + 1 .

    if v_num = 2 then v_ord = xxwrd_qty_ord - xxwrd_qty_rejct.

    if v_num > 2 then do:
        xxwrd_qty_ord = v_ord - xxwrd_qty_rejct.
        v_ord = xxwrd_qty_ord - xxwrd_qty_rejct.
    end.
end.

/*修正后*/
output to "sfc2.txt" .
    for each temp1 ,
        each xxwrd_det where xxwrd_wrnbr = t1_wrnbr 
        break by xxwrd_wrnbr by xxwrd_wolot desc by xxwrd_op 
        with frame x2 width 200:

        disp xxwrd_wonbr xxwrd_wolot xxwrd_op xxwrd_wrnbr xxwrd_qty_ord xxwrd_qty_comp xxwrd_qty_rejct  xxwrd_opfinish xxwrd_status xxwrd_close with frame x2 . 

        if last-of(xxwrd_wrnbr) then do:
            put skip(5) .
        end.
    end.
output close.








/*----------------------------------------------------

define var a as char format "x(1)".
for each xxfb_hist where xxfb_wonbr = "G0902A00247-11" :
find first xcode_mstr where xcode_fldname = "sfc-cell-mch" and xcode_value = xxfb_wc no-lock no-error. 
a = if avail xcode_mstr then "Y" else "" .
disp xxfb_type2 xxfb_wolot xxfb_op xxfb_qty_fb  xxfb_date xxfb_wc a .



for each xxwrd_det where xxwrd_wonbr = "G0902S00188-71" 
break by xxwrd_wonbr by xxwrd_wolot desc by xxwrd_op
:
disp xxwrd_wolot xxwrd_op xxwrd_qty_ord xxwrd_qty_comp xxwrd_qty_rej xxwrd_close  .


----------test---------------------------------------------*/











