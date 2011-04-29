/* xsgetnbr.i                                                              */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*run getnbr(input v_nbrtype output v_wrnbr) .*/


procedure getnbr :
do transaction:
    define input  parameter v_nbrtype as char .
    define output parameter nbr       as integer  .


    nbr  = 0 .

    /*取关联号*/
    if v_nbrtype = "bcwrnbr" then do:
        nbr  = next-value(sfc_sq01) .
        if nbr = 0 then nbr = next-value(sfc_sq01) .
    end.
    
    /*取历史记录流水号*/
    if v_nbrtype = "bctrnbr" then do:
        nbr  = next-value(sfc_sq02) .
        if nbr = 0 then nbr = next-value(sfc_sq02) .
    end.


end.
end procedure. /*getnbr*/

/*-----------------------------------------------------------------------------------------------------------------------------------*/

