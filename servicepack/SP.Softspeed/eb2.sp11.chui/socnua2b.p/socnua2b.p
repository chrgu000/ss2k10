/* socnua2b.p - Sales Order Consignment Usage Process Temp-Table Program      */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* This procedure updates shipment, invoice and tax data for the SO line.     */
/*                                                                            */
/* Revision: 1.2.1.1     BY: Robin McCarthy       DATE: 10/01/05  ECO: *P3MZ* */
/* $Revision: 1.2.1.2 $  BY: Robin McCarthy       DATE: 10/14/05  ECO: *P44V* */
/* $Revision: 1.2.1.2 $  BY: Bill Jiang       DATE: 06/28/06  ECO: *SS - 20060628.1* */
/*-Revision end---------------------------------------------------------------*/

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

/*V8:ConvertMode=NoConvert                                                    */

{mfdeclre.i}

{socnutmp.i}   /* COMMON USAGE TEMP-TABLE DEFINITIONS */

/* PARAMETERS */
define input        parameter ip_effdate     as  date                   no-undo.
define input-output parameter table          for tt_so_update.

define variable result-status                as  integer                no-undo.

for each tt_so_update
exclusive-lock:
   for first sod_det
      where sod_nbr  = tt_so_nbr
      and   sod_line = tt_sod_line
   exclusive-lock:
      assign
         sod_cum_qty[4]  = tt_sod_cum_qty
         sod_cum_date[4] = tt_sod_cum_date
         sod_qty_inv     = tt_sod_qty_inv
         sod_list_pr     = tt_sod_list_pr
         sod_price       = tt_sod_price.

         for first so_mstr
            where so_nbr = sod_nbr
         exclusive-lock:
            assign
               so_inv_date = ip_effdate
               /* SS - 20060628.1 - B */
               /*
               so_to_inv   = tt_so_to_inv
               */
               /* SS - 20060628.1 - E */
               .
            /* SS - 20060628.1 - B */
            IF so_to_inv = NO THEN DO:
               ASSIGN 
                  so_to_inv   = tt_so_to_inv
                  .
            END.
            /* SS - 20060628.1 - E */
         end.

         {gprun.i ""txcalc.p""
                  "(input '13',
                    input sod_nbr,
                    input '',
                    input 0,
                    input no,
                    output result-status)"}

   end. /* FOR FIRST sod_det */
end. /* FOR EACH tt_so_update */
