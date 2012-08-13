/* GUI CONVERTED from fsconst.i (converter v1.69) Tue Apr  9 14:02:19 1996 */
/* fsconst.i   Field Service Constants                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.5      LAST MODIFIED: 07/01/93   BY: sas    *J04C*/
/* REVISION: 7.5      LAST MODIFIED: 04/05/93   BY: gcs    *J04C*/
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: *J04C* Sue Poland   */


	  /***********************************************************/
	  /*                    fsm_type field values                */
	  /***********************************************************/
	  define variable fsmro_c        as character initial "FSM-RO".
	  define variable fsm_c          as character initial "FSM".
	  define variable rma_c          as character initial "RMA".
	  define variable rmarct_c       as character initial "RMA-RCT".
	  define variable rmaiss_c       as character initial "RMA-ISS".
	  define variable scontract_c    as character initial "SC".
	  define variable saddcharge_c   as character initial "SC-ADD".
	  define variable isswo_c        as character initial "ISS-WO".
	  define variable rctup_c        as character initial "RCT-UNP".

	  /***********************************************************/
	  /*                    file field values                    */
	  /***********************************************************/
	  define variable safile_c       as character initial "sa_mstr".
	  define variable svfile_c       as character initial "sv_mstr".
	  define variable isbfile_c      as character initial "isb_mstr".
	  define variable wodfile_c      as character initial "wod_det".
	  define variable itmfile_c      as character initial "itm_det".
	  define variable itmhfile_c     as character initial "itmh_hist".

	  /***********************************************************/
	  /*                    sal_type   values                    */
	  /***********************************************************/
	  define variable saltotrec_c    as character initial "T".
	  define variable saldetrec_c    as character initial "D".

	  /***********************************************************/
	  /*                    sv_svc_types                         */
	  /***********************************************************/
	  define variable warrtype_c     as character initial "W".
	  define variable satype_c       as character initial "S".

	  /***********************************************************/
	  /*                    ca_prefix values                     */
	  /***********************************************************/
	  define variable caprefix_c     as character initial "CA".
	  define variable euprefix_c     as character initial "EU".
	  define variable invmstr_c      as character initial "inv".
	  define variable additems_c     as character initial "ai".

	  /***********************************************************/
	  /*                    fpc_list_type (price list types)     */
	  /***********************************************************/
	  define variable expenselst_c   as integer   initial 3.
	  define variable repairlst_c    as integer   initial 2.
	  define variable contractlst_c  as integer   initial 1.

	  /***********************************************************/
	  /*                op_hist transaction types                */
	  /***********************************************************/
	  define variable labortrans_c   as character initial "LABOR".
	  define variable exptrans_c     as character initial "EXPENSE".


	  /***********************************************************/
	  /*                escalation prefix values                 */
	  /***********************************************************/
	  define variable rces_c         as character initial "R".
	  define variable rcesdet_c      as character initial "RD".

	  /***********************************************************/
	  /*                fcc_type values                          */
	  /***********************************************************/
	  define variable revenuefcc_c   as character initial "R".
	  define variable chargefcc_c    as character initial "C".

	  /***********************************************************/
	  /*                wo_status for repair wo                  */
	  /***********************************************************/
	  /* WOREADY_C INDICATES READY TO INVOICE */
	  define variable woready_c      as character initial "1".
          /* WOCLOSE_C INDICATES INVOICE HAS BEEN POSTED FOR THE REPORT */
/*J04C*	  define variable woclose_c      as character initial "C".     */
/*J04C*/  define variable woclose_c      as character initial "2".

	  /***********************************************************/
	  /*                return site values for rdf_mstr          */
	  /***********************************************************/
	  define variable rdf_return_c   as character initial "R".
/*J04C*/  define variable rdf_repair_c   as character initial "RP".
	  define variable rdf_rts_c      as character initial "T".
	  define variable rdf_rrts_c     as character initial "TR".
	  define variable rdf_spare_c    as character initial "S".
	  define variable rdf_sreturn_c  as character initial "SR".
	  define variable rdf_scrap_c    as character initial "SC".
	  define variable rdf_es_c       as character initial "ES".

	  /***********************************************************/
	  /*              fcg_index values                           */
	  /***********************************************************/
	  define variable warranty_c      as integer  initial  1.
	  define variable contract_c      as integer  initial  2.
	  define variable covered_c       as integer  initial  3.
	  define variable project_c       as integer  initial  4.
	  define variable giveaway_c      as integer  initial  5.
	  define variable fixedbill_c     as integer  initial  6.
	  define variable billable_c      as integer  initial  7.

	  /***********************************************************/
	  /*                miscelaneous                             */
	  /***********************************************************/
	  define variable mfblank        as character initial "".
	  define variable zero           as integer   initial 0.
	  define variable one            as integer   initial 1.
	  define variable fsdate_c       as character initial "findate".
