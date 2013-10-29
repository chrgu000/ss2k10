/* rcctwbc.p  - CONTAINER WORKBENCH - SUB PROGRAM - ADD ITEM - CONT - BOTH   */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*J11D*/ /*V8:ConvertMode=Maintenance                                        */
/* VERSION 7.5      LAST MODIFIED: 04/14/95           BY: GWM  *J049*        */
/* VERSION 8.5      LAST MODIFIED: 07/25/96           BY: jpm  *J11D*        */
/* REVISION: 8.6    LAST MODIFIED: 08/03/96   BY: *K003* Vinay Nayak-Sujir   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98         BY: *L007* A. Rahane   */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *J1NG* Ajit Deodhar      */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2GP* D. Tunstall       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *J32D* Poonam Bahl       */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/99   BY: *K22B* Hemali Desai      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0NY* Dave Caveney      */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00   BY: *N0R9* Jean Miller       */

         {mfdeclre.i}

         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcctwbc_p_1 "Container"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcctwbc_p_2 "Add Containers"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcctwbc_p_3 "Item Number"
/* MaxLen: Comment: */

/*N0R9* &SCOPED-DEFINE rcctwbc_p_4 "Item" */
/* MaxLen: Comment: */

/*N0R9* &SCOPED-DEFINE rcctwbc_p_5 "MIXED ITEMS" */
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
         define variable cont_display as character format "x(40)"
                                      label {&rcctwbc_p_1} no-undo.
         define variable parent_more like mfc_logical
                                     label {&rcctwbc_p_2} no-undo.
         define variable temp_parent like abs_par_id no-undo.
         define variable abnormal_exit as logical no-undo.
         define variable parent_level as integer no-undo.
         define variable levels as integer no-undo.
         define variable cont_um as character format "XX" label {&rcctwbc_p_7}.
/*K003*/ define variable absid like abs_id no-undo.
/*N0R9*/ define variable lit-text as character format "x(18)" no-undo.

/*N0R9*/ lit-text = getTermLabel("MIXED_ITEMS",18).

/*J11D*/ form
/*J11D*/    cont_display format "x(40)"
/*J11D*/    abs_mstr.abs_item
/*J11D*/    abs_mstr.abs_item label {&rcctwbc_p_3}
/*K22B*  /*J11D*/   cont_qty */
/*K22B*/    cont_qty format "->,>>>,>>9.9<<<<"
/*J11D*/    cont_um
/*J11D*/ with frame ax width 80 10 down.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame ax:handle).

         /* RESET STATUS */
         status input.

/*K003*/ find abs_mstr where recid(abs_mstr) = abs_recid no-lock no-error.

         CREATE_RECORDS:
         do:

            /* CREATE TEMP PARENT FOR RECORD MANIPULATION */
            temp_parent = tmp_prefix.

            /* SAVE PARENT FOR THE NEWLY CREATED RECORDS */
            find abs_mstr where recid(abs_mstr) = abs_recid no-lock no-error.
            if available abs_mstr then do:

            parent_number = abs_mstr.abs_id.
            temp_parent = temp_parent + string(recid(abs_mstr)).

            parent_level = integer(abs_mstr.abs__qad06) + 1.

            if parent_level > 9 then do:
               {mfmsg.i 758 4} /* MAX LEVELS EXCEEDED */
               leave CREATE_RECORDS.
            end.

            if parent_level > 8 and add_item and add_container then do:
               {mfmsg.i 758 4} /* MAX LEVELS EXCEEDED */
               leave CREATE_RECORDS.
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
                 output abnormal_exit)"}.

            if abnormal_exit then leave CREATE_RECORDS.

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
               abs_mstr.abs_shipto = temp_parent.
               abs_mstr.abs__qad06 = "02".

/*J2GP*/       /* NEED TO EXPLICITLY COMMIT TRANSACTION FOR ORACLE SO THAT */
/*J2GP*/       /* IT CAN BE USED BY ANY PROGRAM CALLED AFTER IT */
/*J2GP*/       release abs_mstr.

            end.

            /* ADD ITEM FOR SHIPPER WORKBENCH */
            if ship_wb then do:

/*K003*/       absid = if available abs_mstr then abs_mstr.abs_id else ?.

/*K003*        Added absid as a input parameter */
               {gprun.i ""xxrcshwbc2.p""
                 "(input absid,
                   input ship_from,
                   input temp_parent,
                   input shipto_code,
                   output abnormal_exit)"}.
            end.

            /* ADD ITEM FOR CONTAINER WORKBENCH */
            else do:

/*K003*         Added absid as a input parameter */
                {gprun.i ""rcctwbc2.p""
                  "(input ship_from,
                    input temp_parent,
                    output abnormal_exit)"}.
            end.

            if abnormal_exit then leave CREATE_RECORDS.

         end.  /* IF ADD_ITEM */

         /* ADD PARENT CONTAINERS */
         if add_parent_container then do:

            ADD_PARENT:
            repeat:

                /* DISPLAY CONTAINERS BUILT SO FAR */
/*J32D*/        /* AVOIDING FULL TABLE SCAN OF ABS_MSTR */
                for each abs_mstr
/*J32D*         where abs_mstr.abs_shipto = temp_parent no-lock */
/*J32D*/        where abs_mstr.abs_shipfrom = ship_from and
/*J32D*/         abs_mstr.abs_shipto = temp_parent no-lock
                break by abs_mstr.abs__qad06 descending by abs_mstr.abs_id:

                   cont_qty = cont_qty + abs_mstr.abs_qty.

                   /* SET VARIABLES FOR THIS LEVEL */
                   if first-of(abs_mstr.abs__qad06) then
                   do:
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

/*J1NG*/              cont_um = abs_mstr.abs__qad02.

                      /* DISPLAY ITEM LEVEL */
                      if integer(abs_mstr.abs__qad06) = 1 then do:
/*N0R9*              cont_display = fill(".",high_level - 1) + {&rcctwbc_p_4}. */
/*N0R9*/                 cont_display = fill(".",high_level - 1) +
/*N0R9*/                                getTermLabel("ITEM",10).
                         levels = levels + 1.
/*J1NG*                  cont_um = abs_mstr.abs__qad02.   */
                      end.

                      /* DISPLAY A CONTAINER LEVEL */
                      if integer(abs_mstr.abs__qad06) >= 2 then do:
                         /* CREATE INDENTED CONTANINER RANGE */
                         cont_display =
                            fill(".",high_level - integer(abs__qad06)) +
                            substring(first_cont,2) + " - " +
                            substring(last_cont,2).
/*J1NG*                  cont_um = "EA". */
                      end.

/*J11D*/              display
                         cont_display /*format "x(40)" */
                         abs_mstr.abs_item when (mixed_level = false)
/*N0R9*                  {&rcctwbc_p_5} when (mixed_level = true) */
/*N0R9*/                 lit-text when (mixed_level = true)
/*J11D*/                 @ abs_mstr.abs_item /*label "Item Number" */
                         cont_qty
                         cont_um
/*J11D*               with frame a width 80 10 down.  */
/*J11D*/              with frame ax width 80 10 down.

                      cont_qty = 0.

                   end.

                end. /* FOR EACH ABS_MSTR */

                /* IF LESS THAN MAX LEVELS THEN PROMPT TO ADD MORE */
                if parent_level + levels < 10 then do:

                   /* ADD MORE PARENT CONTAINERS ? */
                   parent_more = false.

/*N0NY*/           form with frame b.
/*N0NY*/           setFrameLabels(frame b:handle).

                   update
                      parent_more colon 35
                   with frame b width 80 side-labels attr-space.

                   hide frame b no-pause.
                   if not parent_more then leave ADD_PARENT.

                   cont_level = high_level + 1.

                   /* ADD NEW CONTAINER LEVEL */
                   {gprun.i ""rcctwbc1.p""
                        "(input ship_from,
                          input temp_parent,
                          input cont_level,
                          input parent_number,
                          input add_item,
                          input tmp_prefix,
                          output abnormal_exit)"}.

                   if abnormal_exit then leave CREATE_RECORDS.

                end. /* ADD_PARENT */

                else leave CREATE_RECORDS.

             end. /* IF CONT_LEVEL < 10 */

            end. /* IF ADD_PARENT_CONTAINER */

         end. /* CREATE_RECORDS */

         /* SET ABS_RECID */
         if abs_recid = -1 then do:
            find first abs_mstr where abs_shipfrom = ship_from
            and abs_mstr.abs_shipto begins tmp_prefix no-lock no-error.
            if available abs_mstr then abs_recid = recid(abs_mstr).
         end.

/*J11D*  hide frame a no-pause. */
/*J11D*/ hide frame ax no-pause.
         hide frame b no-pause.
