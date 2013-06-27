/* rcctwbc.p  - CONTAINER WORKBENCH - SUB PROGRAM - ADD ITEM - CONT - BOTH    */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* VERSION 7.5      LAST MODIFIED: 04/14/95           BY: GWM  *J049*         */
/* VERSION 8.5      LAST MODIFIED: 07/25/96           BY: jpm  *J11D*         */
/* REVISION: 8.6      LAST MODIFIED: 08/03/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *J1NG* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2GP* D. Tunstall        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *J32D* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/99   BY: *K22B* Hemali Desai       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0NY* Dave Caveney       */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00   BY: *N0R9* Jean Miller        */
/* Revision: 1.9.1.6    BY: Jean Miller        DATE: 03/22/01 ECO: *P008*     */
/* Revision: 1.9.1.7    BY: Dan Herman         DATE: 07/09/01 ECO: *P007*     */
/* Revision: 1.9.1.9    BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K*     */
/* Revision: 1.9.1.10   BY: Mandar Gawde       DATE: 05/17/04 ECO: *P1YF*     */
/* $Revision: 1.9.1.11 $ BY: Abhijit Gupta    DATE: 10/30/07 ECO: *P6CJ* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcctwbc_p_1 "Container"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcctwbc_p_2 "Add Containers"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcctwbc_p_3 "Item Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcctwbc_p_6 "Quantity"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcctwbc_p_7 "UM"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* INPUT PARAMETERS */
define input parameter ship_from like abs_shipfrom.
define input parameter add_container as logical.
define input parameter add_item as logical.
define input parameter add_parent_container as logical.
define input parameter tmp_prefix as character.
define input parameter ship_wb as logical.
define input parameter shipto_code as character.
define input parameter p_dock_id   as character no-undo.

/* OUTPUT PARAMETERS */
define input-output parameter abs_recid as recid.

/* LOCAL VARIABLES */
define variable cont_level as integer initial 2 no-undo.
define variable parent_number like abs_par_id no-undo.
define variable cont_qty like abs_qty label {&rcctwbc_p_6} no-undo.
define variable high_level as integer no-undo.
define variable mixed_level as logical no-undo.
define variable mixed_item like pt_part no-undo.
define variable first_cont like abs_id no-undo.
define variable last_cont like abs_id no-undo.
define variable cont_display as character format "x(40)" label {&rcctwbc_p_1}
                                                         no-undo.
define variable parent_more like mfc_logical label {&rcctwbc_p_2} no-undo.
define variable temp_parent like abs_par_id no-undo.
define variable abnormal_exit as logical no-undo.
define variable parent_level as integer no-undo.
define variable levels as integer no-undo.
define variable cont_um as character format "XX" label {&rcctwbc_p_7}.
define variable absid like abs_id no-undo.
define variable lit-text as character format "x(18)" no-undo.

lit-text = getTermLabel("MIXED_ITEMS",18).

form
   cont_display format "x(40)"
   abs_mstr.abs_item
   abs_mstr.abs_item label {&rcctwbc_p_3}
   cont_qty format "->,>>>,>>9.9<<<<"
   cont_um
with frame ax width 80 10 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame ax:handle).

/* RESET STATUS */
status input.

find abs_mstr where recid(abs_mstr) = abs_recid no-lock no-error.

create_records:
do:

   /* CREATE TEMP PARENT FOR RECORD MANIPULATION */
   temp_parent = tmp_prefix.

   /* SAVE PARENT FOR THE NEWLY CREATED RECORDS */
   find abs_mstr where recid(abs_mstr) = abs_recid no-lock no-error.
   if available abs_mstr then do:

      assign
         parent_number = abs_mstr.abs_id
         temp_parent = temp_parent + string(recid(abs_mstr))
         parent_level = integer(abs_mstr.abs__qad06) + 1.

      if parent_level > 9 then do:
         {pxmsg.i &MSGNUM=758 &ERRORLEVEL=4} /* MAX LEVELS EXCEEDED */
         leave create_records.
      end.

      if parent_level > 8 and add_item and add_container then do:
         {pxmsg.i &MSGNUM=758 &ERRORLEVEL=4} /* MAX LEVELS EXCEEDED */
         leave create_records.
      end.

   end.

   /* ADD OR CREATE CONTAINERS */
   if add_container then do:

      {gprun.i ""rcctwbc1.p""
         "(input ship_from,
           input temp_parent,
           input cont_level,
           input parent_number,
           input add_item,
           input tmp_prefix,
           input shipto_code,
           output abnormal_exit)"}.

      if abnormal_exit then
         leave create_records.

   end. /* IF ADD_CONTAINER */

   if add_item then do transaction:

      /* SPECIAL CASE FOR ADDING ADDITIONAL ITEMS ONLY               */
      /* THIS WILL ONLY HAPPEN IF A CONTAINER ALREADY EXISTS AND WISH*/
      /* TO ADD ADDITIONAL ITEMS TO THE CONTAINER                    */
      if not add_container then do:

         /* SINCE NO CONTAINERS WILL BE CREATED   */
         /* SAVE PARENT ID AND SET TO TEMP_PARENT */
         find abs_mstr where recid(abs_mstr) = abs_recid
         exclusive-lock.

         /* ASSIGN TEMP GROUP */
         assign
            abs_mstr.abs_shipto = temp_parent
            abs_mstr.abs__qad06 = "02".

      end.

      /* ADD ITEM FOR SHIPPER WORKBENCH */
      if ship_wb then do:

         absid = if available abs_mstr then abs_mstr.abs_id else ?.

         {gprun.i ""xxrcshwbc2.p""
            "(input absid,
              input ship_from,
              input temp_parent,
              input shipto_code,
              input p_dock_id,
              output abnormal_exit)"}.
      end.

      /* ADD ITEM FOR CONTAINER WORKBENCH */
      else do:

         {gprun.i ""rcctwbc2.p""
            "(input ship_from,
              input temp_parent,
              output abnormal_exit)"}.
      end.

      /* NEED TO EXPLICITLY COMMIT TRANSACTION FOR ORACLE SO THAT */
      /* IT CAN BE USED BY ANY PROGRAM CALLED AFTER IT */
      release abs_mstr.

      if abnormal_exit then leave create_records.

   end.  /* IF ADD_ITEM */

   /* ADD PARENT CONTAINERS */
   if add_parent_container then do:

      add_parent:
      repeat:

         /* DISPLAY CONTAINERS BUILT SO FAR */
         /* AVOIDING FULL TABLE SCAN OF ABS_MSTR */
         for each abs_mstr
             where abs_mstr.abs_domain = global_domain and
             abs_mstr.abs_shipfrom = ship_from and
                  abs_mstr.abs_shipto = temp_parent
         no-lock
         break by abs_mstr.abs__qad06 descending by abs_mstr.abs_id:

            cont_qty = cont_qty + abs_mstr.abs_qty.

            /* SET VARIABLES FOR THIS LEVEL */
            if first-of(abs_mstr.abs__qad06)
            then do:
               /* SET FIRST CONTAINER ID IN RANGE */
               first_cont = abs_mstr.abs_id.
               assign
                  mixed_level = false
                  mixed_item = abs_mstr.abs_item.
            end.

            if first(abs__qad06) then do:
               high_level = integer(abs_mstr.abs__qad06).
               levels = high_level - 1.
            end.

            /* MIXED CONTAINER */
            if abs_mstr.abs_item <> mixed_item then mixed_level = true.

            /* IF LAST OF THIS LEVEL THEN DISPLAY INFO */
            if last-of(abs_mstr.abs__qad06) then do:

               /* SET LAST CONTAINER ID IN RANGE */
               last_cont = abs_mstr.abs_id.

               cont_um = abs_mstr.abs__qad02.

               /* DISPLAY ITEM LEVEL */
               if integer(abs_mstr.abs__qad06) = 1 then do:

                  cont_display = fill(".",high_level - 1) +
                                 getTermLabel("ITEM",10).
                  levels = levels + 1.

               end.

               /* DISPLAY A CONTAINER LEVEL */
               if integer(abs_mstr.abs__qad06) >= 2 then do:
                  /* CREATE INDENTED CONTANINER RANGE */
                  cont_display = fill(".",high_level - integer(abs__qad06)) +
                                 substring(first_cont,2) + " - " +
                                 substring(last_cont,2).
               end.

               display
                  cont_display
                  abs_mstr.abs_item
                     when (mixed_level = false)
                  lit-text
                     when (mixed_level = true)
                     @ abs_mstr.abs_item
                  cont_qty
                  cont_um
               with frame ax width 80 10 down.

               cont_qty = 0.

            end.

         end. /* FOR EACH ABS_MSTR */

         /* IF LESS THAN MAX LEVELS THEN PROMPT TO ADD MORE */
         if parent_level + levels < 10 then do:

            /* ADD MORE PARENT CONTAINERS ? */
            parent_more = false.

            form with frame b.
            setFrameLabels(frame b:handle).

            update
               parent_more colon 35
            with frame b width 80 side-labels attr-space.

            hide frame b no-pause.

            if not parent_more then
               leave add_parent.

            cont_level = high_level + 1.

            /* ADD NEW CONTAINER LEVEL */
            {gprun.i ""rcctwbc1.p""
               "(input ship_from,
                 input temp_parent,
                 input cont_level,
                 input parent_number,
                 input add_item,
                 input tmp_prefix,
                 input shipto_code,
                 output abnormal_exit)"}.

            if abnormal_exit then
               leave create_records.

         end. /* add_parent */

         else
            leave create_records.

      end. /* IF CONT_LEVEL < 10 */

   end. /* IF add_parent_CONTAINER */

end. /* create_records */

/* SET ABS_RECID */
if abs_recid = -1 then do:
   find first abs_mstr  where abs_mstr.abs_domain = global_domain and
              abs_shipfrom = ship_from
          and abs_mstr.abs_shipto begins tmp_prefix
   no-lock no-error.
   if available abs_mstr then abs_recid = recid(abs_mstr).
end.

hide frame ax no-pause.
hide frame b no-pause.
