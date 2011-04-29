/* gpmp.p - Recalculate Materials Plan - MRP/DRP - driver program     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*V8:ConvertMode=Maintenance                                            */
/*K1Q4*/ /*V8:WebEnabled=No                                              */
/* REVISION: 7.2       LAST EDIT: 11/03/95   MODIFIED BY: *F0GM* Evan Bishop */
/* REVISION: 8.6       LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan           */
/* REVISION: 9.1       LAST EDIT: 08/13/00   BY: *N0KS* myb                  */


/* $Revision: ss - 090616.1  $    BY: mage chen : 05/14/09 ECO: *090616.1*    */


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
        {gprun.i ""gpmp02.p"" "(module-code,calculation-mode)" }

     end.
     else if calculation-mode = net-change
     or calculation-mode = regeneration then do:
/* ss - 090616.1 - b*

        /* Execute the Net-change/Regen calculation */
        {gprun.i ""gpmp01.p"" "(module-code,calculation-mode)" }
* ss - 090616.1 - e*/

/* ss - 090616.1 - b*/

        /* Execute the Net-change/Regen calculation */
        {gprun.i ""xxgpmp01.p"" "(module-code,calculation-mode)" }
/* ss - 090616.1 - e*/

     end.

/*V8!    session:system-alert-boxes = yes. */
