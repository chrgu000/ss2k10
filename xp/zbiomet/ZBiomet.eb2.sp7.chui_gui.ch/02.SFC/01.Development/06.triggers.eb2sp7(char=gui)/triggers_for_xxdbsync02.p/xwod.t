/* wod.t   WORK ORDER DELETE TRIGGER                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.1.1.1 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/* Revision: 1.1       BY: Julie Milligan       DATE: 05/13/02   ECO: *P06V*  */
/* $Revision: 1.1.1.1 $      BY: Inna Fox             DATE: 06/13/02   ECO: *P04Z*  */
/******************************************************************************/

TRIGGER PROCEDURE FOR DELETE OF wo_mstr.

/*ss - 20090401.1 - B*/
do:
    find first xwo_mstr 
	where xwo_lot = wo_lot
    no-error .
    if avail xwo_mstr then do:
	delete xwo_mstr .
    end. 

end.
/*ss - 20090401.1 - E*/


/* Remove any flow schedule details associated with current work order */
for first flsd_det exclusive-lock where
   flsd_flow_wo_nbr = wo_nbr and
   flsd_flow_wo_lot = wo_lot: end.
if available flsd_det then delete flsd_det.
