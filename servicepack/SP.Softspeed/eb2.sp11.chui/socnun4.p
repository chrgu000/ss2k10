/* socnun4.p - Sales Order Consignment Usage AutoCreate Undo                  */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.1.1.1 $      BY: Robin McCarthy       DATE: 10/01/05  ECO: *P3MZ* */
/* $Revision: 1.1.1.1 $      BY: Bill Jiang       DATE: 06/28/06  ECO: *SS - 20060628.1* */
/* $Revision: 1.1.1.1 $      BY: Bill Jiang       DATE: 06/29/06  ECO: *SS - 20060629.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20060629.1 - B */
/*
1.	修正了部分撤消的BUG
*/
/* SS - 20060629.1 - E */

/* SS - 20060628.1 - B */
/*
1.	修正了"准备打印发票"的BUG
*/
/* SS - 20060628.1 - E */

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}

{socnutmp.i}   /* COMMON USAGE TEMP-TABLE DEFINITIONS */

/* PARAMETERS */
define input-output parameter table             for  tt_so_update.

define variable tr-type       like tx2d_tr_type initial "13" no-undo.
define variable line          like tx2d_line    initial 0    no-undo.
define variable nbr           like tx2d_nbr     initial ""   no-undo.
define variable result-status as   integer                   no-undo.

/* SS - 20060629.1 - B */
DEFINE BUFFER bsod FOR sod_det.
/* SS - 20060629.1 - E */

for each tt_so_update
exclusive-lock:
   for first sod_det
      where sod_nbr  = tt_so_nbr
      and   sod_line = tt_sod_line
   exclusive-lock:

      assign
         sod_cum_qty[4]  = tt_sod_cum_qty
         sod_cum_date[4] = tt_sod_cum_date
         sod_qty_inv     = tt_sod_qty_inv.

      for first so_mstr
         where so_mstr.so_nbr = sod_nbr
      exclusive-lock:
         /* SS - 20060628.1 - B */
         /*
         so_to_inv = tt_so_to_inv.
         */
         so_to_inv = NO.
         /* SS - 20060629.1 - B */
         IF so_inv_nbr = "" THEN DO:
            FOR EACH bsod NO-LOCK
               WHERE bsod.sod_nbr = tt_so_nbr
               :
               IF bsod.sod_qty_inv <> 0 THEN DO:
                  so_to_inv = YES.
                  LEAVE.
               END.
            END.
         END.
         /* SS - 20060629.1 - E */
         /* SS - 20060628.1 - E */

         if tt_so_bol <> "" then
            so_bol = tt_so_bol.

      end. /* FOR FIRST so_mstr */
      release so_mstr.

      {gprun.i ""txcalc.p""
               "(input tr-type,
                 input sod_nbr,
                 input nbr,
                 input line,
                 input no,
                 output result-status)"}
   end. /* FOR FIRST sod_det */
end. /* FOR EACH tt_so_update */
