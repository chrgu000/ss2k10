/*******************************************************
** Program: xxsoisck.p
** Author : Li Wei , AtosOrigin
** Date   : 2005-8-12
** Description: SO shiped control, if finish goods not
**              was checked,shipment will fail
********************************************************/
/*Last Modified BY:Li Wei Date:2005-11-30 ECO *lw02* */


define shared temp-table xtable
    field xtable_recid as recid
    field xtable_pal like xwck_pallet.

define input parameter part like pt_part.
define input parameter dt as date.
define input parameter tm as integer.
define output parameter CanShipped as logical.
/*lw02*/define output parameter o_pallet as character.

define buffer buf_xwck for xwck_mstr.

     /* Check date for shipment by time-seqence*/

    find first buf_xwck no-lock where buf_xwck.xwck_part = part
                                  and buf_xwck.xwck_type = "1"
                                  and buf_xwck.xwck_stat = "CK"
                                  and buf_xwck.xwck_date < dt
                                  and buf_xwck.xwck_shipper = ""
                                  no-error.
    if avail buf_xwck then do:        
        find first xtable no-lock where xtable_pal = buf_xwck.xwck_pallet no-error.
        if not avail xtable then do:
            CanShipped = no.
            o_pallet = buf_xwck.xwck_pallet.
        end.
        else CanShipped = yes.
    end.
    else CanShipped = yes.