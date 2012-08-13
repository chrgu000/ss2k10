/* trw.t  tr_hist Inventory Transaction Write Trigger                         */
/*Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.3.3.2 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/* Revision: 1.1        BY: Jean Miller          DATE: 06/06/02  ECO: *P07T*  */
/* Revision: 1.2        BY: Jean Miller          DATE: 06/13/02  ECO: *P082*  */
/* Revision: 1.3        BY: Jean Miller          DATE: 08/01/02  ECO: *P0CL*  */
/* $Revision: 1.3.3.2 $     BY: Jean Miller          DATE: 09/09/03  ECO: *P10C*  */
/******************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF tr_hist OLD BUFFER old_tr_hist.

/* Removed logic, data now captured differently */


/*james*/
if (tr_hist.tr_type = "ISS-WO" or tr_hist.tr_type = "RCT-WO") and (tr_hist.tr_lot <> "") and (tr_hist.tr_nbr = "") then do:
    find first xxtr_hist where xxtr_trnbr = tr_hist.tr_trnbr use-index xxtr_idx0 no-lock no-error.
    if not available xxtr_hist then do:
        create xxtr_hist.
        assign xxtr_trnbr = tr_hist.tr_trnbr.
    end.
    assign xxtr_part = tr_hist.tr_part
           xxtr_site = tr_hist.tr_site
           xxtr_type = tr_hist.tr_type
           xxtr_key1 = tr_hist.tr_lot.
    release xxtr_hist.           
end.            