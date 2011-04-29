/* mficgl02.i -                                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*J2CZ*/ /*V8:RunMode=Character,Windows                                      */
/*               DOES NOT UPDATE ICC_CTRL                                    */
/* REVISION: 4.0      LAST MODIFIED: 08/10/89   BY: emb *A779*               */
/* REVISION: 5.0      LAST MODIFIED: 04/04/89   BY: WUG *B089*               */
/* REVISION: 5.0      LAST MODIFIED: 04/26/89   BY: MLB *B105*               */
/* REVISION: 5.0      LAST MODIFIED: 02/28/90   BY: WUG *B594*               */
/* REVISION: 5.0      LAST MODIFIED: 04/12/90   BY: emb *B653*               */
/* REVISION: 5.0      LAST MODIFIED: 08/07/90   BY: WUG *B753*               */
/* REVISION: 5.0      LAST MODIFIED: 08/16/90   BY: emb *B766*               */
/* REVISION: 6.0      LAST MODIFIED: 10/24/90   BY: pml *D143*               */
/* REVISION: 6.0      LAST MODIFIED: 03/13/91   BY: WUG *D472*               */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 10/29/91   BY: jjs *F016*               */
/* REVISION: 7.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 01/14/92   by: jms *F058*               */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   by: jms *F350*               */
/* REVISION: 7.0      LAST MODIFIED: 04/14/92   by: pma *F393*               */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   by: pma *F609*               */
/* REVISION: 7.0      LAST MODIFIED: 06/10/92   by: pma *F564*               */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   by: pma *F686*               */
/* REVISION: 7.3      LAST MODIFIED: 10/26/93   by: ais *GG70*               */
/* REVISION: 7.3      LAST MODIFIED: 10/29/94   by: bcm *GN73*               */
/* REVISION: 9.0      LAST MODIFIED: 09/30/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb               */
/*****************************************************************************/
/*!
This file will not update icc_ctrl.
*/
/*!
/*N014* ADDED *-sub REFERENCES BELOW */
{&gl-amount} gl amount
{&tran-type} tran type
{&order-no}  order number
{&dr-acct}   dr acct
{&dr-sub}    dr sub
{&dr-cc}     dr cc
{&drproj}    dr project
{&cr-acct}   cr acct
{&cr-sub}    cr sub
{&cr-cc}     cr cc
{&crproj}    cr project
{&entity}    entity
{&same-ref}  overrides creation of new gl reference
/*F003*/  {&find}  find/release icc_ctrl
*/

/*! *F564*
    Changed this program to call gpicgl.p, a passed parameter
    program.  Moved most of the logic from mficgl02.i to gpicgl.p
    and it's include files (gpgltdet.i)
*/
/**************************************************************/
/*J2CZ* REPLACED FIND, FIND FIRST/LAST STATEMENTS
    WITH     FOR FIRST/LAST STATEMENTS
    FOR      PERFORMANCE */

     if {&gl-amount} <> 0 then do:
        if eff_date = ? then eff_date = today.
/*F003*/    if "{&find}" <> "false" then
/*J2CZ** find first icc_ctrl no-lock. */
/*J2CZ*/ for first icc_ctrl no-lock: end.
        if icc_gl_tran then do:
/*F564*/       msg_temp = {&tran-type}.

/*F686*/       /*added 'input ref' below*/
/*GG70*/       /*changed 'input ref' below to 'input-output ref' */
/*N014*/       /* ADDED &dr-sub AND &cr-sub BELOW */
/*F564*/       {gprun.i ""gpicgl.p"" "(input {&gl-amount},
                       input msg_temp,
                       input {&order-no},
                       input {&dr-acct},
                       input {&dr-sub},
                       input {&dr-cc},
                       input {&drproj},
                       input {&cr-acct},
                       input {&cr-sub},
                       input {&cr-cc},
                       input {&crproj},
                       input {&entity},
                       input eff_date,
/*GN73**                               input icc_gl_sum, **/
/*GN73*/                               input {&same-ref},
                       input icc_mirror,
                       input-output ref,
                       input recid(trgl_det),
                       input recid(tr_hist))"
           }

        end.

/*F003*/    if "{&find}" <> "false" then
        release icc_ctrl.
     end.
