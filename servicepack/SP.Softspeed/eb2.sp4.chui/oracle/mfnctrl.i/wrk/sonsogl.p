/* sonsogl.p - CREATE JOURNAL REF FOR INVOICE POST                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*J2CZ*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0      LAST MODIFIED: 03/20/86   BY: PML        */
/* REVISION: 4.0      LAST MODIFIED: 02/01/88   BY: PML *A169* */
/* REVISION: 7.3      LAST MODIFIED: 07/12/93   BY: dpm *GD33* */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala*/
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 07/20/00   BY: *L0QV* Manish K.    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb          */
/*J2CZ* ADDED EXCLUSIVE-LOCK  FOR PERFORMANCE */

         {mfdeclre.i}                                             /*J34F*/

/*L0QV*/ define input parameter l_effdate like ar_effdate no-undo.
         define shared variable ref like glt_det.glt_ref.
         define shared variable batch like ar_batch.

         find first soc_ctrl
/*J2CZ*/    exclusive-lock no-error.

         if soc_jrnl > 999999 then soc_jrnl = 1.
         soc_jrnl = soc_jrnl + 1.

/*L0QV** BEGIN DELETE***********************************
 *       ref = "SO"
 *       + substring(string(year(today),"9999"),3,2)
 *       + string(month(today),"99")
 *       + string(day(today),"99")
 *       + string(soc_jrnl,"999999").
 *L0QV** END DELETE ***********************************/

/*L0QV*/ ref = "SO"
/*L0QV*/ + substring(string(year(l_effdate),"9999"),3,2)
/*L0QV*/ + string(month(l_effdate),"99")
/*L0QV*/ + string(day(l_effdate),"99")
/*L0QV*/ + string(soc_jrnl,"999999").

         if soc_ar = yes then do:
            /* get next ar batch number */
            {mfnctrl.i arc_ctrl arc_batch ar_mstr ar_batch batch}

/*GD33*/    find ba_mstr where ba_batch = batch and ba_module = "SO"
/*GD33*/       exclusive-lock no-error.
/*GD33*/    if not available ba_mstr then do:
/*GD33*/       create ba_mstr.
/*GD33*/       assign
/*GD33*/          ba_batch = batch
/*GD33*/          ba_module = "SO"
/*GD33*/          ba_doc_type = "I"
/*GD33*/          ba_status = "NU" /*not used*/.
            end.

         end.

         release soc_ctrl.
         release arc_ctrl.
         release ba_mstr.
