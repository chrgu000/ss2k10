/* xxporp003a.p - 预付款账龄报表--子程式,计算指定ref的预付款冲销情况        */
/* REVISION: 100809.1      Created On: 20100809 ,  BY: Roger Xiao           */
/*----rev history-----------------------------------------------------------*/

/*
计算逻辑:
预付款用正数,且指定了PO(vpo_po),ref = 001,
采购发票冲销预付款时,也指定了相同的po, ref = 002,
所以可关联起来,计算冲销金额
*/




{mfdeclre.i}
{gplabel.i}


        
define input  parameter i_vend    as character no-undo.
define input  parameter i_eff     as date      no-undo.
define input  parameter i_ref     as character no-undo.
define output parameter i_amt     as decimal   no-undo.

define var vopo like po_nbr .


i_amt = 0 .
vopo  = "".
find first vpo_det 
    where vpo_domain = global_domain 
    and   vpo_ref    = i_ref
no-lock no-error.
vopo = if available vpo_det then vpo_po else "".

for each ap_mstr 
        fields (ap_domain ap_vend ap_effdate ap_type ap_ref)
        use-index ap_vend
        where ap_mstr.ap_domain = global_domain 
        and ap_vend     =  i_vend
        and ap_effdate >= i_eff
        and ap_type     = "VO"
    no-lock ,
    each vo_mstr 
        where vo_domain = global_domain
        and   vo_ref    = ap_ref 
        and   vo_prepay < 0   /*小于零的,是冲PO发票的*/
    no-lock by ap_effdate :  

    find first vpo_det 
        where vpo_domain = global_domain 
        and   vpo_ref    = vo_ref
    no-lock no-error.
    if avail vpo_det then do:
        if vpo_po = vopo then i_amt = i_amt + vo_prepay .
    end.
end.


i_amt = - i_amt .

