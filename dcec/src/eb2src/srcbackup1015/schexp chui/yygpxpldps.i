/* GUI CONVERTED from gpxpldps.i (converter v1.76) Wed Dec  5 09:38:36 2001 */
/* gpxpldps.i - EXPLODE BILL OF MATERIAL (PASS PARAMETERS TO GPXPLD.P)        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 12/02/92      BY: pma *G382*             */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93      BY: emb *G656*             */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00      BY: *N0KS* myb             */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5 $    BY: Jean Miller           DATE: 12/03/01  ECO: *P039*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{gppmdte.i {&date}      xplddate}     /*effective date*/
xplddate = gpdte.

{gppmchr.i {&site}      xpldsite}     /*work order site*/
xpldsite = gpchr.

{gppmchr.i {&comp}      xpldcomp}     /*first parent part number*/
xpldcomp = gpchr.

{gppmchr.i {&xtype}    xpldtrans}     /*transaction type*/
xpldtrans = gpchr.

{gppmchr.i {&group}      psgroup}     /*option group*/
psgroup = gpchr.

{gppmchr.i {&process}  psprocess}     /*process*/
psprocess = gpchr.

{gppmdec.i {&op}       operation}     /*routing operation*/
operation = gpdec.

{gppmlog.i {&del}          pkdel}     /*delete old pk_det records?*/
pkdel = gplog.

{gppmlog.i {&nopick}   incl_nopk}     /*create pk_det records if*/
incl_nopk = gplog.                    /*issue policy = no?      */

{gppmlog.i {&phantom}  incl_phtm}     /*create pk_det records if*/
incl_phtm = gplog.                    /*pt_phantom = yes?       */

{gppmchr.i {&op_list}    op_list}     /*operation list to explode   */
op_list = gpchr.                      /*(may include non mile-stone */
                                      /* operations)                */
/*tfq {gprun.i ""gpxpld.p""
   "(input xplddate,
     input xpldsite,
     input xpldcomp,
     input xpldtrans,
     input psgroup,
     input psprocess,
     input operation,
     input pkdel,
     input incl_nopk,
     input incl_phtm,
     input op_list,
     output bombatch)"} */
/*tfq*/ {gprun.i ""yygpxpld.p""
   "(input xplddate,
     input xpldsite,
     input xpldcomp,
     input xpldtrans,
     input psgroup,
     input psprocess,
     input operation,
     input pkdel,
     input incl_nopk,
     input incl_phtm,
     input op_list,
     output bombatch)"}
/*GUI*/ if global-beam-me-up then undo, leave.


