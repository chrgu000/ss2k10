/* gpmp.p - Recalculate Materials Plan - MRP/DRP - driver program     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*V8:ConvertMode=Maintenance                                            */
/*K1Q4*/ /*V8:WebEnabled=No                                              */
/* REVISION: 7.2       LAST EDIT: 11/03/95   MODIFIED BY: *F0GM* Evan Bishop */
/* REVISION: 8.6       LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan           */
/* REVISION: 9.1       LAST EDIT: 08/13/00   BY: *N0KS* myb                  */
/* By: Neil Gao Date: 07/11/05 ECO: * ss 20071105 * */

/*****************************************************************************
    Parameter definitions:
         module-code = the passed parameter indicating MRP or DRP module
               This is an integer value of either 1 or 2.
    calculation-mode = the passed parameter for net change/regen/selective
               This will have an integer value of 1, 2 or 3.
    These values are determined by the menu level program which the user
    selects and are not parameters over which the user has direct input
    control.
******************************************************************************/

/*V8!    session:system-alert-boxes = no. */

     {mfglobal.i}

     /* Define constants for mrp/drp net-change/regen/selective options */
     {gpmpvar.i}

     define input parameter module-code as integer no-undo.
     define input parameter calculation-mode as integer no-undo.

     if calculation-mode = selective then do:

        /* Execute the selective calculation */
/* ss 20071121 - b */
/*
        {gprun.i ""gpmp02.p"" "(module-code,calculation-mode)" }
*/
        {gprun.i ""xxgpmp02.p"" "(module-code,calculation-mode)" }

/* ss 20071121 - e */
     end.
     else if calculation-mode = net-change
     or calculation-mode = regeneration then do:

        /* Execute the Net-change/Regen calculation */
/* ss 20071105 - b */
/*
        {gprun.i ""gpmp01.p"" "(module-code,calculation-mode)" }
*/
        {gprun.i ""xxgpmp01.p"" "(module-code,calculation-mode)" }
/* ss 20071105 - e */

     end.

/*V8!    session:system-alert-boxes = yes. */
