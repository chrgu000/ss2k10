/* pjclacba.p - GET BATCH NUMBER FOR GL TRANSACTION FOR PROJ ACTIVITY CLOSE  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=Maintenance                                                */
/*V8:RunMode=Character,Windows                                              */
/* REVISION: 9.1    CREATED      : 06/30/00  BY: Luke Pokic *N009*          */
/* REVISION: 9.1   MODIFIED      : 08/13/00  BY: *N0KQ* myb                  */


          {mfdeclre.i}


          define shared variable batch    like ar_batch no-undo.
          define shared variable ref      like glt_det.glt_ref no-undo.
          define shared variable eff_date like ar_effdate no-undo.

          /* GET BATCH NUMBER */
          for first soc_ctrl
          exclusive-lock:
          end.

          assign
             soc_jrnl = (if soc_jrnl > 999999 then 1 else soc_jrnl) + 1
             ref = "SO"
                   + substring(string(year(eff_date),"9999"),3,2)
                   + string(month(eff_date),"99")
                   + string(day(today),"99")
                   + string(soc_jrnl,"999999").

          /* GET NEXT BATCH NUMBER */
          {mfnctrl.i arc_ctrl
                     arc_batch
                     ar_mstr
                     ar_batch
                     batch}

          for first ba_mstr
          where ba_batch = batch and ba_module = "SO"
          exclusive-lock:
          end.

          if not available ba_mstr then do:
             create ba_mstr.
             assign ba_batch = batch
                    ba_module = "SO"
                    ba_doc_type = "I"
                    ba_status = "NU".    /* NOT USED */
             if recid(ba_mstr) = -1 then .
          end.

          release soc_ctrl.
          release arc_ctrl.
          release ba_mstr.
