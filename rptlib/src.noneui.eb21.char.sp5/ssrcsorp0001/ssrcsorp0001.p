/* rcsorp.p - Customer Schedules - Scheduled Order Report                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.12 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 7.3    LAST MODIFIED: 10/06/92           BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 01/13/95           BY: srk *G0C1*          */
/* REVISION: 7.3    LAST MODIFIED: 08/21/95           BY: bcm *G0TB*          */
/* REVISION: 7.3    LAST MODIFIED: 07/31/96           BY: *G29C* Ajit Deodhar */
/* REVISION: 8.6    LAST MODIFIED: 10/03/97           BY: bvm *K0KR*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/22/00   BY: *N08Y* Kaustubh K.        */
/* REVISION: 9.1      LAST MODIFIED: 05/31/00   BY: *N09M* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 07/07/00   BY: *N0FD* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.6   BY: Jean Miller         DATE: 12/14/01  ECO: *P03Q*    */
/* Revision: 1.5.1.8   BY: Patrick Rowan       DATE: 01/08/01  ECO: *P00G*    */
/* Revision: 1.5.1.9  BY: Katie Hilbert DATE: 04/15/02 ECO: *P03J* */
/* Revision: 1.5.1.11  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.5.1.12 $ BY: Rajinder Kamra  DATE: 06/23/03  ECO *Q003*  */
/* $Revision: 1.5.1.12 $ BY: Bill Jiang  DATE: 03/08/08  ECO *SS - 20080308.1*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080308.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{a6mfdtitle.i "2+ "}

define input parameter i_shipfrom_from like scx_shipfrom no-undo.
define input parameter i_shipfrom_to   like scx_shipfrom no-undo.
define input parameter i_cust_from     like so_cust      no-undo.
define input parameter i_cust_to       like so_cust      no-undo.
define input parameter i_shipto_from   like so_ship      no-undo.
define input parameter i_shipto_to     like so_ship      no-undo.
define input parameter i_dock_from     like sod_dock     no-undo.
define input parameter i_dock_to       like sod_dock     no-undo.
define input parameter i_part_from     like sod_part     no-undo.
define input parameter i_part_to       like sod_part     no-undo.
define input parameter i_po_from       like sod_contr_id no-undo.
define input parameter i_po_to         like sod_contr_id no-undo.
define input parameter i_custref_from  like scx_custref  no-undo.
define input parameter i_custref_to    like scx_custref  no-undo.
define input parameter i_modelyr_from  like scx_modelyr  no-undo.
define input parameter i_modelyr_to    like scx_modelyr  no-undo.
define input parameter i_order_from    like scx_order    no-undo.
define input parameter i_order_to      like scx_order    no-undo.

{ssrcsorp0001.i}
/* SS - 20080308.1 - E */
{rcrpvar.i}
/* CONSIGNMENT VARIABLES */
{socnvars.i}

define variable sortoption    as integer label "Sort Option"
                              format "9" initial 1 no-undo.
define variable sortextoption as character extent 2 format "x(66)" no-undo.

define variable l_msgdesc     like msg_desc no-undo.

assign
   sortextoption[1] = "1 - " + getTermLabel("BY",2) + " " +
                               getTermLabel("SHIP_FROM",9)          + "," +
                               getTermLabel("CUSTOMER",4)           + "," +
                               getTermLabel("SHIP-TO",7)            + "," +
                               getTermLabel("ORDER",5)              + "," +
                               getTermLabel("DOCK",4)               + "," +
                               getTermLabel("ITEM",4)               + "," +
                               getTermLabel("PURCHASE_ORDER",2)     + "," +
                               getTermLabel("CUSTOMER_REFERENCE",8) + "," +
                               getTermLabel("MODEL_YEAR",8)
   sortextoption[2] = "2 - " + getTermLabel("BY",2)                 + " " +
                               getTermLabel("ITEM",4)               + "," +
                               getTermLabel("SHIP_FROM",9)          + "," +
                               getTermLabel("CUSTOMER",4)           + "," +
                               getTermLabel("SHIP-TO",7)            + "," +
                               getTermLabel("ORDER",5)              + "," +
                               getTermLabel("DOCK",4)               + "," +
                               getTermLabel("PURCHASE_ORDER",2)     + "," +
                               getTermLabel("CUSTOMER_REFERENCE",8) + "," +
                               getTermLabel("MODEL_YEAR",8).
form
   shipfrom_from      colon 15 label "Ship-From"
   shipfrom_to        colon 45 label "To"
   cust_from          colon 15
   cust_to            colon 45 label "To"
   shipto_from        colon 15
   shipto_to          colon 45 label "To"
   dock_from          colon 15
   dock_to            colon 45 label "To"
   part_from          colon 15
   part_to            colon 45 label "To"
   po_from            colon 15 format "x(22)"
   po_to              colon 45 label "To" format "x(22)"
   custref_from       colon 15 format "x(22)"
   custref_to         colon 45 label "To" format "x(22)"
   modelyr_from       colon 15 format "x(22)"
   modelyr_to         colon 45 label "To" format "x(22)"
   order_from         colon 15
   order_to           colon 45 label "To"
   skip(1)
   sortoption         colon 15
   skip
   sortextoption[1]   at 10 no-label
   sortextoption[2]   at 10 no-label
   skip(1)
with frame a side-labels width 80 attr-space.

/* SS - 20080308.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
ASSIGN
   shipfrom_from = i_shipfrom_from
   shipfrom_to   = i_shipfrom_to  
   cust_from     = i_cust_from    
   cust_to       = i_cust_to      
   shipto_from   = i_shipto_from  
   shipto_to     = i_shipto_to    
   dock_from     = i_dock_from    
   dock_to       = i_dock_to      
   part_from     = i_part_from    
   part_to       = i_part_to      
   po_from       = i_po_from      
   po_to         = i_po_to        
   custref_from  = i_custref_from 
   custref_to    = i_custref_to   
   modelyr_from  = i_modelyr_from 
   modelyr_to    = i_modelyr_to   
   order_from    = i_order_from   
   order_to      = i_order_to     
   .
/* SS - 20080308.1 - E */

{wbrp01.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* SS - 20080308.1 - B */
/*
/* ORDER NOT SELECTED, NOT IN ORDER DOMAIN: */
{pxmsg.i &MSGNUM=6264 &ERRORLEVEL=1 &MSGBUFFER=l_msgdesc}
*/
/* SS - 20080308.1 - E */

   /* SS - 20080308.1 - B */
   /*
repeat:

   display
      sortextoption
   with frame a.
   */
   /* SS - 20080308.1 - E */

   if shipfrom_to = hi_char then shipfrom_to = "".
   if cust_to     = hi_char then cust_to     = "".
   if shipto_to   = hi_char then shipto_to   = "".
   if dock_to     = hi_char then dock_to     = "".
   if part_to     = hi_char then part_to     = "".
   if po_to       = hi_char then po_to       = "".
   if custref_to  = hi_char then custref_to  = "".
   if modelyr_to  = hi_char then modelyr_to  = "".
   if order_to    = hi_char then order_to    = "".

   /* SS - 20080308.1 - B */
   /*
   if c-application-mode <> 'web' then
   update
      shipfrom_from
      shipfrom_to
      cust_from
      cust_to
      shipto_from
      shipto_to
      dock_from
      dock_to
      part_from
      part_to
      po_from
      po_to
      custref_from
      custref_to
      modelyr_from
      modelyr_to
      order_from
      order_to
      sortoption
   with frame a.

   {wbrp06.i &command = update &fields = "  shipfrom_from shipfrom_to
        cust_from cust_to shipto_from shipto_to dock_from dock_to
        part_from part_to po_from po_to custref_from custref_to
        modelyr_from modelyr_to order_from  order_to sortoption "
        &frm = "a"}
   */
   /* SS - 20080308.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i shipfrom_from}
      {mfquoter.i shipfrom_to }
      {mfquoter.i cust_from   }
      {mfquoter.i cust_to     }
      {mfquoter.i shipto_from }
      {mfquoter.i shipto_to   }
      {mfquoter.i dock_from   }
      {mfquoter.i dock_to     }
      {mfquoter.i part_from   }
      {mfquoter.i part_to     }
      {mfquoter.i po_from     }
      {mfquoter.i po_to       }
      {mfquoter.i custref_from}
      {mfquoter.i custref_to  }
      {mfquoter.i modelyr_from}
      {mfquoter.i modelyr_to }
      {mfquoter.i order_from  }
      {mfquoter.i order_to    }
      {mfquoter.i sortoption  }

      if shipfrom_to = "" then shipfrom_to = hi_char.
      if cust_to     = "" then cust_to     = hi_char.
      if shipto_to   = "" then shipto_to   = hi_char.
      if dock_to     = "" then dock_to     = hi_char.
      if part_to     = "" then part_to     = hi_char.
      if po_to       = "" then po_to       = hi_char.
      if custref_to  = "" then custref_to  = hi_char.
      if modelyr_to  = "" then modelyr_to  = hi_char.
      if order_to    = "" then order_to    = hi_char.

   end.

   /* SS - 20080308.1 - B */
   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead2.i}

   if sortoption = 1 then do:
   */
   /* SS - 20080308.1 - E */

      for each scx_ref no-lock
          where scx_ref.scx_domain = global_domain and  scx_type = 1
           and scx_shipfrom >= shipfrom_from
           and scx_shipfrom <= shipfrom_to
           and scx_shipto >= shipto_from
           and scx_shipto <= shipto_to
           and scx_part >= part_from
           and scx_part <= part_to
           and scx_po >= po_from
           and scx_po <= po_to
           and scx_custref >= custref_from
           and scx_custref <= custref_to
           and scx_modelyr >= modelyr_from
           and scx_modelyr <= modelyr_to
           and scx_order >= order_from
           and scx_order <= order_to,
          each sod_det no-lock
          where sod_det.sod_domain = global_domain and  sod_nbr = scx_order
           and sod_line = scx_line,
          each so_mstr no-lock
          where so_mstr.so_domain = global_domain and  so_nbr = sod_nbr
           and so_cust >= cust_from
           and so_cust <= cust_to
           and sod_dock >= dock_from
           and sod_dock <= dock_to
      break by scx_shipfrom by so_cust by scx_shipto
            by scx_order by sod_dock by sod_part
            by sod_contr_id by scx_custref by scx_modelyr:

         /* IF WE'RE NOT IN THE CENTRAL DATABASE THEN
            LET'S PRINT AN ERROR MESSAGE TO RUN THE REPORT
            FROM THE CENTRAL DATABASE THEN EXIT THE REPORT*/
         if trim(substring(so_conrep,15,20)) <> global_db
         then do:
            /* SS - 20080308.1 - B */
            /*
            put unformatted skip(2)
               l_msgdesc " "
               trim(substring(so_conrep,15,20)) skip
               {gplblfmt.i &FUNC=getTermLabel(""ORDER"",10) &CONCAT="': '"} +
               so_nbr
               skip(1).
            */
            /* SS - 20080308.1 - E */
            next.
         end.

         /* SS - 20080308.1 - B */
         /*
         {gprun.i ""rcsorpa.p"" "(input recid(scx_ref),
                                  input using_cust_consignment,
                                  input dev)"}
         */
         {gprun.i ""ssrcsorp0001a.p"" "(input recid(scx_ref),
                                  input using_cust_consignment,
                                  input execname)"}
         /* SS - 20080308.1 - E */

         {mfrpchk.i}

      end.

   /* SS - 20080308.1 - B */
   /*
   end.

   else
   if sortoption = 2 then do:

      for each scx_ref no-lock
          where scx_ref.scx_domain = global_domain and  scx_type = 1
           and scx_shipfrom >= shipfrom_from
           and scx_shipfrom <= shipfrom_to
           and scx_shipto >= shipto_from
           and scx_shipto <= shipto_to
           and scx_part >= part_from
           and scx_part <= part_to
           and scx_po >= po_from
           and scx_po <= po_to
           and scx_custref >= custref_from
           and scx_custref <= custref_to
           and scx_modelyr >= modelyr_from
           and scx_modelyr <= modelyr_to
           and scx_order >= order_from
           and scx_order <= order_to,
          each sod_det no-lock
          where sod_det.sod_domain = global_domain and  sod_nbr = scx_order
           and sod_line = scx_line,
          each so_mstr no-lock
          where so_mstr.so_domain = global_domain and  so_nbr = sod_nbr
           and so_cust >= cust_from
           and so_cust <= cust_to
           and sod_dock >= dock_from
           and sod_dock <= dock_to
      break by sod_part by scx_shipfrom by so_cust
            by scx_shipto by scx_order by sod_dock
            by sod_contr_id by scx_custref by scx_modelyr:

         /* IF WE'RE NOT IN THE CENTRAL DATABASE THEN
            LET'S PRINT AN ERROR MESSAGE TO RUN THE REPORT
            FROM THE CENTRAL DATABASE THEN EXIT THE REPORT*/
         if trim(substring(so_conrep,15,20)) <> global_db
         then do:
            put unformatted skip(2)
               l_msgdesc " "
               trim(substring(so_conrep,15,20)) skip
               {gplblfmt.i &FUNC=getTermLabel(""ORDER"",10) &CONCAT="': '"} +
               so_nbr
               skip(1).
            next.
         end.

         {gprun.i ""rcsorpa.p"" "(input recid(scx_ref),
                                  input using_cust_consignment,
                                  input dev)"}

         {mfrpchk.i}

      end.

   end.

   /* REPORT TRAILER */
   {mfrtrail.i}

end.
   */
   /* SS - 20080308.1 - E */

{wbrp04.i &frame-spec = a}
