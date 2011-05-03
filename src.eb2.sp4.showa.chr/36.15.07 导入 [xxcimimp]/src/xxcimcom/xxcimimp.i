/* kbsmwb.i - COMMON DEFINITIONS FOR SUPERMARKET WORKBENCH IMPORT/EXPORT    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */

/* $Revision: 1.15 $   BY: Patrick Rowan   DATE: 10/29/02  ECO: *P0M4*  */

/*V8:ConvertMode=NoConvert                                        */

/* TEMP TABLE TO STORE KANBAN LOOP DATA */

/* SS - 081222.1 By: Bill Jiang */

/* SS - 081222.1 - B */
define {1} SHARED variable remote_options as character format "x(1)" no-undo.
define {1} SHARED variable temporary_directory as character format "x(45)" no-undo.
define {1} SHARED variable file_prefix as character format "x(8)" no-undo.
define {1} SHARED variable audit_trail as character format "x(1)" no-undo.
define {1} SHARED variable log_directory as character format "x(45)" no-undo.
define {1} SHARED variable current_directory as character format "x(45)" no-undo.
define {1} SHARED variable delete_options as character format "x(1)" no-undo.
define {1} SHARED variable include_header as character format "x(1)" no-undo.
define {1} SHARED variable FIELD_delimiter as character format "x(1)" no-undo.
define {1} SHARED variable allow_errors as character format "x(1)" no-undo.

define {1} SHARED variable log_filename as character format "x(20)" no-undo.
define {1} SHARED variable cim_filename as character format "x(20)" no-undo.
define {1} SHARED variable ftp_filename as character format "x(20)" no-undo.

define {1} SHARED variable filename as character format "x(20)" no-undo.

DEFINE {1} SHARED TEMP-TABLE tt0 NO-UNDO
   FIELD tt0_c1 AS CHARACTER INITIAL "-"
   FIELD tt0_error LIKE glt_error FORMAT "X(60)"
   FIELD tt0_line AS INTEGER
   /*
   INDEX tt1_cust IS UNIQUE tt1_cust tt1_cust_part tt1_part
   */
   .

DEFINE {1} SHARED TEMP-TABLE tt1 NO-UNDO
   FIELD tt1_c1 AS CHARACTER INITIAL "-" EXTENT 99 
   FIELD tt1_error LIKE glt_error FORMAT "X(60)"
   FIELD tt1_line AS INTEGER
   /*
   INDEX tt1_cust IS UNIQUE tt1_cust tt1_cust_part tt1_part
   */
   .
/*
define temp-table tt_smwbfile no-undo
   field knb_primary_key          like knb_keyid
   field part                     like pt_part
   field step                     like knbi_step
   field description              as character
   field source_site              like knbs_ref1
   field source                   like knbs_ref2
   field source_type              as character
   field source_type_literal      as character
   field supermarket_site         like knbsm_site
   field supermarket              like knbsm_supermarket_id
   field pacemaker                as logical
   field pitch_interval           like knp_pitch_interval
   field pitch_quantity           like knp_pitch_quantity
   field pitch_um                 like knp_pitch_um
   field available_time           like knp_time_avail
   field takt_time                like knp_takt_time
   field epei_display             as character
   field epe_interval             like knpd_epe_interval
   field epei_in_secs             like knpd_epe_interval
   field cycle_time               like knpd_cycle_time
   field replenish_lead_time      like knbl_rep_time
   field demand_pct               like knbism_demand_pct
   field safety_stock             like knbism_safety_stock
   field safety_time              like knbism_safety_time
   field safety_method            like knbism_ss_method
   field total_safety_stock       like knbism_safety_stock
   field service_level            like knbism_service_level
   field template_used            like knbism_template_used
   field var_factor               like knbism_var_factor
   field planner                  as character
   field start_date               as date
   field horizon                  as integer
   field order_qty                like knbl_order_qty
   field order_point              like knbism_order_point
   field pack_qty                 like knbism_pack_qty
   field kanban_qty               like knbl_kanban_quantity
   field number_of_cards          like knbl_number_of_cards
   field active_card_count        as integer
   field current_inventory        as decimal
   field warning_limit            like knbism_warning_limit
   field critical_limit           like knbism_critical_limit
   field report_buffer_limits     as logical
   field buffer_maximum           like knbism_max_buf
   field buf_limit_disp           as character
   field first_scheduled_date     as date

   /* REVISED VALUES */
   field buffer_maximum_revised   like knbism_max_buf
   field var_factor_revised       like knbism_var_factor
   field safety_stock_revised     like knbism_safety_stock
   field safety_time_revised      like knbism_safety_stock
   field service_level_revised    like knbism_service_level
   field replenish_lead_time_revised
                                  like knbl_rep_time
   field kanban_qty_revised       like knbl_kanban_quantity
   field number_of_cards_revised  like knbl_number_of_cards
   field warning_limit_revised    like knbism_warning_limit
   field critical_limit_revised   like knbism_critical_limit

   /* KANBAN CARD VALUES */
   field cardsNeeded              as decimal
   field cardsNotNeeded           as decimal
   field newCardsNeeded           as logical
   field activeCardCount          as decimal format ">>>9"
   field inactiveCardCount        as decimal format ">>>9"
   field new_activeCardCount      as decimal format ">>>9"
   field new_inactiveCardCount    as decimal format ">>>9"
   field cardsToAdd               as decimal format ">>>9"
   field cardsToInactivate        as decimal format ">>>9"
   field cardsToReactivate        as decimal format ">>>9"

   index tt_sort_order
         source_type
         source
         part
   index tt_kbwbfile_key is unique
         knb_primary_key.


/* TEMP TABLE TO STORE FUTURE DEMAND DATA */
define temp-table tt_smddfile no-undo
   field knb_primary_key          like knb_keyid
   field part                     as character
   field supermarket_site         as character
   field calculated_date          as date
   field available_time           as integer
   field independent_demand       as decimal
   field dependent_demand         as decimal
   field level_schedule           as decimal
   field prelim_level_schedule    as decimal
   index tt_kbwbfile_key is unique
         knb_primary_key
         calculated_date.


/* TEMP TABLE TO STORE ANY KANBANS THAT SHOULD BE REACTIVATED */
define temp-table tt_reactivate    no-undo
   field knb_primary_key          like knb_keyid
   field card_ID                  like knbd_id
   index tt_reactivateIndex is unique primary
         knb_primary_key
         card_ID.



define buffer bSupermarketWB for tt_smwbfile.
define buffer bSMDemand      for tt_smddfile.
define buffer bReactivate    for tt_reactivate.
*/
/* SS - 081222.1 - E */
