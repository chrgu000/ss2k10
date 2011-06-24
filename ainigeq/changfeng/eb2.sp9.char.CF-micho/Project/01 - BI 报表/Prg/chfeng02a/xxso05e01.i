/* so05e01.i - Sales Order Print Include File                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.5 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0    LAST MODIFIED:  07/05/90   BY: WUG *D043*/
/* REVISION: 8.6E   LAST MODIFIED:  04/23/98   BY: *L00L* EvdGevel            */
/* REVISION: 8.6E   LAST MODIFIED:  05/20/98   BY: *K1Q4* Alfred Tan          */
/* REVISION: 8.6E   LAST MODIFIED:  10/04/98   BY: *J314* Alfred Tan          */
/* REVISION: 9.1    LAST MODIFIED:  08/14/99   BY: *N01Q* Michael Amaladhas   */
/* REVISION: 9.1    LAST MODIFIED:  03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED:  08/12/00   BY: *N0KN* Mark Brown          */
/* REVISION: 9.1    LAST MODIFIED:  08/23/00   BY: *N0ML* Dave Caveney        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.1.5 $   BY: Jean Miller        DATE: 04/16/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

et_new_page = true.
if not et_dc_print then do:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

   /* ***********************Kaine B Add********************** *
    *	display
    *	   sod_line
    *	   sod_part
    *	   cont_lbl @ qty_open
    *	with frame c.
    *	
    *	down 1 with frame c.
    * ***********************Kaine E Add********************** */
end.

else do:

   {etdcrd.i so_curr 75 91}

   form with frame ceuro.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame ceuro:handle).

   /* ***********************Kaine B Add********************** *
    *	display
    *	   sod_line
    *	   sod_part
    *	   cont_lbl @ qty_open
    *	with frame ceuro.
    *	
    *	down 1 with frame ceuro.
    * ***********************Kaine E Add********************** */

end.
