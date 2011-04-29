/* gpxpldps.i - EXPLODE BILL OF MATERIAL (PASS PARAMETERS TO GPXPLD.P)  */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0      LAST MODIFIED: 12/02/92      BY: pma *G382*       */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93      BY: emb *G656*       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00      BY: *N0KS* myb       */
/* REVISION: eB sp5 chui  LAST MODIFIED: 03/27/07  BY: *ss - eas058* Apple Tam */


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

/*G656*/ {gppmchr.i {&op_list}    op_list}     /*operation list to explode   */
/*G656*/ op_list = gpchr.                      /*(may include non mile-stone */
                           /* operations)                */

/*G656*/ /* Added op_list to run statement */
/*ss - eas058****************************************/
 /*    {gprun.i ""gpxpld.p"" "(input xplddate,
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
                 output bombatch)"
     }*/
     {gprun.i ""xxgpxpld.p"" "(input xplddate,
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
                 output bombatch)"
     }
/*ss - eas058****************************************/
