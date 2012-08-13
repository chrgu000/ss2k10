/*-----------------------------------------------------------------------------
  File: kbdltt.i
  Description: KANBAN DISPATCH LIST TEMP TABLE DEFINITION
  History
      Cai last modified by 06/15/2004
	 
	 2004-6-17, Yang Enping, 0003
	     1.  Add window time, use filed:
	         Window date: ttWindowDate  ==>  usrw_datefld[2]
		 Window time: ttWindowTime  ==>  usrw_intfld[3]
             2.  Below invloved files should be reviewed and modify
	         xkkbdlrp1.p
		 xkkbdlrp.p
		 xkkbdlrd.p
		 xkplpre.p

-------------------------------------------------------------------------------*/
define {1} shared temp-table ttDispList
   field ttPart              like knbi_part
   field ttStep              like knbi_step
   field ttSiteSupermarket   like knbsm_site
   field ttSupermarket_id    like knbsm_supermarket_id
   field ttSourceType        like knbs_source_type
   field ttSourceRef1        like knbs_ref1
   field ttSourceRef2        like knbs_ref2
   field ttSourceRef3        like knbs_ref3
   field ttSourceRef4        like knbs_ref4
   field ttSourceRef5        like knbs_ref5
   field ttID                like knbd_id
   field ttCardType          like knbl_card_type
   field ttAuthDate          like knbd_authorize_date
   field ttAuthTime          like knbd_authorize_time
   field ttKanbanQuantity    like knbd_kanban_quantity
   field ttUM                like pt_um
   field ttSourceEmail       like knbl_source_email
   field ttDestinationEmail  like knbism_dest_email
   field ttSourceFax         like knbl_source_fax
   field ttDestinationFax    like knbism_dest_fax
   field ttSourceFax2        like knbl_source_fax2
   field ttDestinationFax2   like knbism_dest_fax2
   field ttComment           as   character  extent 10 format "x(33)"
   field ttBlanketPO         like kbtr_po_nbr
   field tturgent            as logical
   FIELD ttline              AS INTEGER
   FIELD ttwkctr             AS CHARACTER
/*0003*----*/
   field ttWindowDate        as date
   field ttWindowTime        as int
/*----*0003*/
   index cardID is unique primary
   ttID

   index suppSource is unique
   ttSourceType
   ttSourceRef1
   ttSourceRef2
   ttSourceRef3
   ttSourceRef4
   ttSourceRef5
   ttPart
   ttStep
   ttSiteSupermarket
   ttSupermarket_id
   ttID

   index consSource is unique
   ttSiteSupermarket
   ttSupermarket_id
   ttPart
   ttStep
   ttSourceRef1
   ttSourceRef2
   ttSourceRef3
   ttSourceRef4
   ttSourceRef5
   ttID

   index SourceFax is unique
   ttSourceFax
   ttSourceFax2
   ttSourceRef1
   ttSourceRef2
   ttSourceRef3
   ttSourceRef4
   ttSourceRef5
   ttPart
   ttStep
   ttSiteSupermarket
   ttSupermarket_id
   ttID

   index DestinationFax is unique
   ttDestinationFax
   ttDestinationFax2
   ttSiteSupermarket
   ttSupermarket_id
   ttPart
   ttStep
   ttSourceFax
   ttSourceFax2
   ttSourceRef1
   ttSourceRef2
   ttSourceRef3
   ttSourceRef4
   ttSourceRef5
   ttID

   index SourceEmail is unique
   ttSourceEmail
   ttSourceRef1
   ttSourceRef2
   ttSourceRef3
   ttSourceRef4
   ttSourceRef5
   ttPart
   ttStep
   ttSiteSupermarket
   ttSupermarket_id
   ttID

   index DestinationEmail is unique
   ttDestinationEmail
   ttSiteSupermarket
   ttSupermarket_id
   ttPart
   ttStep
   ttSourceRef1
   ttSourceRef2
   ttSourceRef3
   ttSourceRef4
   ttSourceRef5
   ttID

.
