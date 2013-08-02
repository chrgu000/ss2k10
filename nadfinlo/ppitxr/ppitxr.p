/* ppitxr.p - ITEM RESPONSIBILITY-OWNING PROGRAM                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                          */
/*                                                                            */
/* This routine provides the procedures which are executed as a result of the */
/* call from the appropriate Data Type Controllers / structured programs      */
/* It contains most of the business logic pertaining to Item Maintenance      */
/*                                                                            */
/* Revision: 1.2      BY: G.Latha           DATE: 03/23/00   ECO: *N03T*      */
/* Revision: 1.3      BY: David Morris      DATE: 05/12/00   ECO: *N0B1*      */
/* Revision: 1.4      BY: G.Latha           DATE: 05/12/00   ECO: *N0BK*      */
/* Revision: 1.5      BY: G.Latha           DATE: 05/16/00   ECO: *N0B9*      */
/* Revision: 1.6      BY: Zheng Huang       DATE: 07/13/00   ECO: *N059*      */
/* Revision: 1.7      BY: Vandna Rohira     DATE: 08/25/00   ECO: *M0R8*      */
/* Revision: 1.8      BY: Larry Leeth       DATE: 12/04/00   ECO: *N0V1*      */
/* Revision: 1.9      BY: Katie Hilbert     DATE: 04/01/01   ECO: *P002*      */
/* Revision: 1.10     BY: Rajesh Kini       DATE: 05/05/01   ECO: *M16M*      */
/* Revision: 1.11     BY: Russ Witt         DATE: 09/21/01   ECO: *P01H*      */
/* $Revision: 1.12 $  BY: Vandna Rohira     DATE: 01/21/03   ECO: *N24S*      */
/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ******************************* DEFINITIONS ****************************** */

/* 130802.1 *******************************************************************                                                                  *
 * 改 pt_plan_ord 默认为NO                                                    *
 * 由于是默认在表结构里子程序多个程序调用因此直接修改标准程序了               *
 ******************************************************************************/

{mfdeclre.i}

&GLOBAL-DEFINE FSM "FSM"
&GLOBAL-DEFINE GL_COST_SET 'GL'
&GLOBAL-DEFINE CURRENT_COST_SET 'CUR'


/* Define Handles for the programs. */
{pxphdef.i aperxr}
{pxphdef.i bmbmxr}
{pxphdef.i bmpsxr}
{pxphdef.i clalxr}
{pxphdef.i fseuxr}
{pxphdef.i fsscxr}
{pxphdef.i fssmxr}
{pxphdef.i gpacxr}
{pxphdef.i gpcodxr}
{pxphdef.i gplngxr}
{pxphdef.i icilxr}
{pxphdef.i icinxr}
{pxphdef.i icsixr}
{pxphdef.i pccgxr}
{pxphdef.i piapxr}
{pxphdef.i ppccxr1}
{pxphdef.i ppcixr}
{pxphdef.i ppcpxr}
{pxphdef.i ppicxr}
{pxphdef.i ppipxr}
{pxphdef.i ppprxr}
{pxphdef.i pxgblmgr}
{pxphdef.i soatpxr}
{pxphdef.i spfhxr}
/* End Define Handles for the programs. */

{pxmaint.i}

define temp-table ttPhyItem like pt_mstr.


/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */


/*============================================================================*/
PROCEDURE assignDefaultsForNewItem:
/*------------------------------------------------------------------------------
Purpose:       TO ASSIGN DEFAULTS FOR NEW ITEM.
Exceptions:    NONE
Conditions:
        Pre:   partMaster(r)
        Post:  pl_mstr(r), partMaster(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer partMaster for pt_mstr.

   define buffer productLine for pl_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='processRead' &PROGRAM  = 'ppprxr.p'
                &HANDLE=ph_ppprxr
         &PARAM="(input  pt_prod_line,
            buffer productLine,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}
      if return-value = {&SUCCESS-RESULT} then
         assign
            partMaster.pt_taxc    = productLine.pl_taxc
            partMaster.pt_taxable = productLine.pl_taxable.

      {pxrun.i &PROC='defaultPOSite'
         &PARAM="(input-output partMaster.pt_po_site,
            input partMaster.pt_site)"}

      {pxrun.i &PROC='defaultItemEMTType'
         &PARAM="(input-output partMaster.pt_btb_type)"}

      {pxrun.i &PROC='defaultAtpEnforcement' &PROGRAM  = 'soatpxr.p'
                &HANDLE=ph_soatpxr
         &PARAM="(input-output partMaster.pt_atp_enforcement)"}

      {pxrun.i &PROC='defaultServiceCategory'
         &PARAM="(input-output partMaster.pt_fsc_code)"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE createInventory:
/*------------------------------------------------------------------------------
Purpose:       TO CREATE INVENTORY RECORD FOR ITEM.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  si_mstr(r), in_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer partMaster for pt_mstr.
   define parameter buffer in_mstr    for in_mstr.

   define buffer   si_mstr      for  si_mstr.
   define variable l_si_gl_set  like si_gl_set  no-undo.
   define variable l_si_cur_set like si_cur_set no-undo.
   define variable l_pt_abc     like pt_abc     no-undo.
   define variable l_recno      as   recid      no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         l_si_gl_set  = """"
         l_si_cur_set = """"
         l_pt_abc     = """"
         pt_mrp       = yes.

      {pxrun.i &PROC ='processRead' &PROGRAM  = 'icsixr.p'
                &HANDLE=ph_icsixr
         &PARAM="(input  pt_site,
            buffer si_mstr,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}
      if return-value = {&SUCCESS-RESULT} then
         assign
            l_si_gl_set  = si_gl_set
            l_si_cur_set = si_cur_set.

      if (pt_abc <> """" and pt_abc <> ?) then
         l_pt_abc = pt_abc.

      /* EIGHTH INPUT PARAMETER FOR CYCLE COUNT INTERVAL CHANGED */
      /* FROM UNKNOWN VALUE ? TO PT_CYC_INT                     */

      {pxrun.i &PROC ='createItem' &PROGRAM='icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(input  no,
                  input  pt_part,
                  input  pt_site,
                  input  l_si_gl_set,
                  input  l_si_cur_set,
                  input  l_pt_abc,
                  input  pt_avg_int,
                  input  pt_cyc_int,
                  input  pt_rctpo_status,
                  input  pt_rctpo_active,
                  input  pt_rctwo_status,
                  input  pt_rctwo_active,
                  output l_recno)"}

      {pxrun.i &PROC ='processRead' &PROGRAM  = 'icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(input  pt_part,
            input  pt_site,
            buffer in_mstr,
            input  {&LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE createItem:
/*------------------------------------------------------------------------------
Purpose:       TO CREATE ITEM.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  inventoryControl(r), partMaster(c)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer partMaster   for  pt_mstr.
   define input parameter pItemId       as character no-undo.
   define input parameter pProductLine  as character no-undo.

   define buffer inventoryControl for icc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first inventoryControl
         fields(icc_site)
         no-lock :
      end. /* for first icc_ctrl */

      create partMaster.
      assign partMaster.pt_part  = pItemId
         partMaster.pt_site      =
            inventoryControl.icc_site when (available inventoryControl)
         partMaster.pt_prod_line = pProductLine.
/*默认为NO*/     partMaster.pt_plan_ord = no.
          if recid(partMaster) = -1 then. /* OCACLE */

   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE createItemCost:
/*------------------------------------------------------------------------------
Purpose:       TO CREATE cOST IF AN ITEM ALREADY EXISTS AND WHEN THE USER
               CHANGES THE DEFAULT SITE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  icc_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.
   define input parameter pSite   as character no-undo.
   define input parameter pType   as character no-undo.
   define parameter buffer in_mstr    for  in_mstr.
   define output parameter pSiteChanged  as logical no-undo.

   /* LOCAL VARIABLES */
   define buffer sct_det  for sct_det.
   define buffer icc_ctrl for icc_ctrl.
   define variable l_in_set  like in_gl_set  no-undo.
   define variable l_icc_set like icc_gl_set no-undo.
   define variable l_si_set  like si_cur_set no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first icc_ctrl
         fields(icc_cur_set icc_gl_set icc_site)
         no-lock:
      end. /* For first icc_ctrl */

      if pType = {&GL_COST_SET} then
         assign
            l_in_set  = in_gl_set
            l_icc_set = icc_ctrl.icc_gl_set.
      else if pType = {&CURRENT_COST_SET} then
         assign l_in_set  = in_cur_set
            l_icc_set = icc_ctrl.icc_cur_set.

      if (l_in_set = ""
         and not can-find(sct_det where sct_sim = l_icc_set
         and sct_part = pItemId and sct_site = pSite))
         or (l_in_set <> ""
         and not can-find(sct_det where sct_sim = l_in_set
         and sct_part = pItemId and sct_site = pSite)) then do:
         {pxrun.i &PROC ='createItemCost' &PROGRAM='ppicxr.p'
                   &HANDLE=ph_ppicxr
            &PARAM="(buffer in_mstr,
               buffer sct_det,
               input pType)"}
         pSiteChanged = yes.
      end.
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE defaultInDataSiteChange:
/*------------------------------------------------------------------------------
Purpose:       Default the om data site charge.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  in_mstr(r), si_mstr(r), icc_ctrl(r), sct_det(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer partMaster   for pt_mstr.
   define parameter buffer prevItem     for ttPhyItem.
   define input  parameter pNewItem     as  logical no-undo.
   define output parameter pSiteChanged as  logical no-undo.

   define buffer   in_mstr  for  in_mstr.
   define buffer   sct_det  for  sct_det.
   define buffer   si_mstr  for  si_mstr.
   define buffer   icc_ctrl for  icc_ctrl.
   define variable csset    like cs_set no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pNewItem then do:
         {pxrun.i &PROC='siteUpdate' &PROGRAM='icinxr.p'
                   &HANDLE=ph_icinxr
            &PARAM="(input partMaster.pt_part,
               input partMaster.pt_site,
               input prevItem.pt_site,
               input partMaster.pt_abc,
               input partMaster.pt_avg_int,
               input partMaster.pt_cyc_int,
               input partMaster.pt_rctpo_status,
               input partMaster.pt_rctpo_active,
               input partMaster.pt_rctwo_status,
               input partMaster.pt_rctwo_active)"}

         {pxrun.i &PROC='itemCostUpdate' &PROGRAM='ppicxr.p'
                   &HANDLE=ph_ppicxr
            &PARAM="(input partMaster.pt_part,
               input prevItem.pt_site,
               input partMaster.pt_site,
               input {&GL_COST_SET})"}

         {pxrun.i &PROC='itemCostUpdate' &PROGRAM='ppicxr.p'
                   &HANDLE=ph_ppicxr
            &PARAM="(input partMaster.pt_part,
               input prevItem.pt_site,
               input partMaster.pt_site,
               input {&CURRENT_COST_SET})"}
      end. /* If pNewItem then do: */

      {pxrun.i &PROC='processRead' &PROGRAM='icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(input  partMaster.pt_part,
            input  partMaster.pt_site,
            buffer in_mstr,
            input  {&LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}

      if return-value = {&RECORD-LOCKED} then
         return error return-value.

      if return-value = {&RECORD-NOT-FOUND} then
         {pxrun.i &PROC='createInventory'
            &PARAM="(buffer partMaster,
               buffer in_mstr)"}
      else
         {pxrun.i &PROC='updateInventory'
            &PARAM="(buffer partMaster,
               buffer in_mstr,
               input pNewItem)"}

      if not pNewItem and prevItem.pt_site <> partMaster.pt_site then do:
         {pxrun.i &PROC='createItemCost'
            &PARAM="(input  partMaster.pt_part,
               input  partMaster.pt_site,
               input  {&GL_COST_SET},
               buffer in_mstr,
               output pSiteChanged)"}

         {pxrun.i &PROC='createItemCost'
            &PARAM="(input  partMaster.pt_part,
               input  partMaster.pt_site,
               input  {&CURRENT_COST_SET},
               buffer in_mstr,
               output pSiteChanged)"}
      end. /* if not pNewItem */

      {pxrun.i &PROC='processRead' &PROGRAM  = 'icsixr.p'
                &HANDLE=ph_icsixr
         &PARAM="(input  partMaster.pt_site,
            buffer si_mstr,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}

      {pxrun.i &PROC='updateCostSets' &PROGRAM='icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(buffer in_mstr,
            buffer si_mstr)"}

      for first icc_ctrl
         fields(icc_gl_set) no-lock:
      end.

      {pxrun.i &PROC='findByKey' &PROGRAM='ppicxr.p'
                &HANDLE=ph_ppicxr
         &PARAM="(input
            (if si_gl_set = '' then
               icc_ctrl.icc_gl_set
            else si_gl_set),
            input partMaster.pt_part,
            input partMaster.pt_site,
            buffer sct_det)"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE defaultItemEMTType:
/*------------------------------------------------------------------------------
Purpose:       TO SET THE DEFAULT EMT TYPE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input-output parameter pPtBtbType as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPtBtbType = "" then
         pPtBtbType = "01".

   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE defaultPOsite:
/*------------------------------------------------------------------------------
Purpose:       TO DEFAULT PURCHASE ORDER SITE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input-output parameter pSiteIdPO      as character no-undo.
   define input        parameter pSiteIdDefault as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pSiteIdPO = "" then
         pSiteIdPO = pSiteIdDefault.
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE defaultServiceCategory:
/*------------------------------------------------------------------------------
Purpose:       TO DEFAULT SERVICE CATEGORY.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input-output parameter pServiceCategory as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* IF SERVICE CATEGORY IS BLANK, DEFAULT IN FROM CONTROL FILE */
      {pxgetph.i fssmxr}
      if pServiceCategory = "" then do:
         pServiceCategory = {pxfunct.i &FUNCTION='getDefaultServiceCategory'
                               &PROGRAM='fssmxr.p'
                               &HANDLE=ph_fssmxr}.
      end. /* if pServiceCategory = "" then do: */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE deleteConfigModel:
/*------------------------------------------------------------------------------
Purpose:       TO DELETE CONFIGURATION MODEL.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId    as character                no-undo.
   define input parameter pNewPmCode as character                no-undo.
   define input parameter pOldPmCode as character                no-undo.
   define variable cfexists          like mfc_logical initial no no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}
      if pOldPmCode = "c" and pNewPmCode <> "c"
         and cfexists then do:
         {pxrun.i &PROC='deleteConfigModel' &PROGRAM='ppcpxr.p'
                   &HANDLE=ph_ppcpxr
            &PARAM="(input pItemId)"
            &FIELD-LIST= pt_pm_code}
      end.
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE generateItemAnalysisCode:
/*------------------------------------------------------------------------------
Purpose:       TO GENERATE ITEM ANALYSIS CODE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define        parameter buffer partMaster for pt_mstr.
   define        parameter buffer prevItem   for ttPhyItem.
   define  input parameter pNewItem          as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pNewItem
         or (prevItem.pt_desc1     <> partMaster.pt_desc1
         or  prevItem.pt_desc2     <> partMaster.pt_desc2
         or  prevItem.pt_break_cat <> partMaster.pt_break_cat
         or  prevItem.pt_group     <> partMaster.pt_group
         or  prevItem.pt_part_type <> partMaster.pt_part_type
         or  prevItem.pt_prod_line <> partMaster.pt_prod_line
         or  prevItem.pt_article   <> partMaster.pt_article
         or  prevItem.pt_buyer     <> partMaster.pt_buyer
         or  prevItem.pt_part      <> partMaster.pt_part
         or  prevItem.pt_site      <> partMaster.pt_site) then do:

         {pxrun.i &PROC='deleteAnalysisCodes' &PROGRAM='gpacxr.p'
                   &HANDLE=ph_gpacxr
            &PARAM="(input partMaster.pt_part,
               input '6')"}

         {pxrun.i &PROC='generateItemAnalysisCode' &PROGRAM='gpacxr.p'
                   &HANDLE=ph_gpacxr
            &PARAM="(input pNewItem,
               input partMaster.pt_part)"}
      end. /* If pNewItem */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.

END PROCEDURE.

/*============================================================================*/
PROCEDURE getBasicItemData:
/*------------------------------------------------------------------------------
Purpose:       Gets Basic Item Data description1 & description2, price, site
               status, um and vend.
Exceptions:    RECORD-NOT-FOUND
Conditions:
        Pre:   None
        Post:  partMaster(r)
Notes:
History:       Extracted from popomth.p
------------------------------------------------------------------------------*/
   define input parameter  pItemId       as character no-undo.
   define output parameter pDescription1 as character no-undo.
   define output parameter pDescription2 as character no-undo.
   define output parameter pItemPrice    as decimal   no-undo.
   define output parameter pItemSite     as character no-undo.
   define output parameter pItemStatus   as character no-undo.
   define output parameter pUM           as character no-undo.
   define output parameter pItemSupplier as character no-undo.

   define buffer partMaster for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first partMaster
         fields (pt_part pt_desc1 pt_desc2 pt_price pt_site
         pt_status pt_um pt_vend)
         where pt_part = pItemId
         no-lock:


         assign
            pDescription1 = pt_desc1
            pDescription2 = pt_desc2
            pItemPrice    = pt_price
            pItemSite     = pt_site
            pItemStatus   = pt_status
            pUM           = pt_um
            pItemSupplier = pt_vend.
      end.

      if not available partMaster then
         return {&RECORD-NOT-FOUND}.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE getConfigType:
/*------------------------------------------------------------------------------
Purpose:       TO GET CONFIGURATION TYPE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
        Post:  NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pPurMfgCode as character no-undo.
   define input  parameter pCfg        as character no-undo.
   define output parameter pCfgType    as character no-undo.

   define variable l_cfgLabel          as character no-undo.
   define variable l_cfgCode           as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if can-find(first lngd_det
         where lngd_lang    = global_user_lang
         and lngd_dataset = "pt_mstr"
         and lngd_field   = "pt_cfg_type") then do:

         {pxrun.i &PROC='convertAlphaToNumeric' &PROGRAM='gplngxr.p'
                   &HANDLE=ph_gplngxr
            &PARAM="(input  'pt_mstr',
               input  'pt_cfg_type',
               input  pCfg,
               output l_cfgCode,
               output l_cfgLabel)"
            &CATCHERROR=true}
         if return-value = {&SUCCESS-RESULT} and
            pPurMfgCode  = "C" then
            pCfgType = l_cfgCode.
         else
            pCfgType = pCfg.
      end. /* If can-find(first lngd_det */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE getConfigTypeDesc:
/*------------------------------------------------------------------------------
Purpose:       TO GET CONFIGURATION TYPE DESCRIPTION.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input  parameter pCfgType      as character no-undo.
   define output parameter pCfg          as character no-undo.
   define output parameter pCfgLabel     as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         pCfg      = pCfgType
         pCfgLabel = "".

      /* GET MNEMONIC pCfg AND pCfgLabel FROM LNGD_DET */
      {pxrun.i &PROC='convertNumericToAlpha' &PROGRAM='gplngxr.p'
                &HANDLE=ph_gplngxr
         &PARAM="(input  'pt_mstr',
            input  'pt_cfg_type',
            input  pCfgType,
            output pCfg,
            output pcfgLabel)"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE processCreate:
/*---------------------------------------------------------------------------
Purpose:       TO CREATE ITEM MASTER RECORD.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
---------------------------------------------------------------------------*/
   define input     parameter pItemId      as  character no-undo.
   define input     parameter pProductLine as  character no-undo.
   define parameter buffer    partMaster   for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='createItem'
         &PARAM="(buffer partMaster,
            input  pItemId,
            input pProductLine)"}

      {pxrun.i &PROC='setReplanRequiredIfDefaultPlanning' &PROGRAM='icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(input pItemId)"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE processDelete:
/*------------------------------------------------------------------------------
Purpose:       TO DELETE AN ITEM MASTER RECORD.
Exceptions:    APP-ERROR-NO-REENTER-RESULT
Conditions:
        Pre:   NONE
       Post:   partMaster(d)
Notes:
History:
------------------------------------------------------------------------------*/
   define  parameter buffer partMaster for pt_mstr.

   define variable  undo_del as logical   no-undo.
   define variable  msg      as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""ppptdla1.p""
               "(input recid(partMaster),
                 input-output undo_del,
                 output msg)"}

      if undo_del then
         return error {&APP-ERROR-NO-REENTER-RESULT}.

      {gprun.i ""ppptdla3.p""
               "(input recid(partMaster),
                 input-output undo_del,
                 output msg)"}

      if undo_del then
         return error {&APP-ERROR-NO-REENTER-RESULT}.

      {gprun.i ""ppptdla2.p""
               "(input recid(partMaster),
                 input-output undo_del,
                 output msg)"}

      if undo_del then
         return error {&APP-ERROR-NO-REENTER-RESULT}.

      {gprun.i ""ppptdlb1.p""
               "(input recid(partMaster),
                 input-output undo_del,
                 output msg)"}

      if undo_del then
         return error {&APP-ERROR-NO-REENTER-RESULT}.

      {gprun.i ""ppptdlc1.p""
               "(input recid(partMaster),
                 input-output undo_del,
                 output msg)"}

      if undo_del then
         return error {&APP-ERROR-NO-REENTER-RESULT}.

      {pxrun.i &PROC ='setReplanRequired' &PROGRAM='icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(input pt_part,
            input pt_site)"}

      {pxrun.i &PROC ='deleteAnalysisCodes' &PROGRAM='gpacxr.p'
                &HANDLE=ph_gpacxr
         &PARAM="(input pt_part,
            input '6')"}

      {pxrun.i &PROC ='deleteItem' &PROGRAM='piapxr.p'
                &HANDLE=ph_piapxr
         &PARAM="(buffer partMaster)"}

      {pxrun.i &PROC ='deleteItem' &PROGRAM='aperxr.p'
                &HANDLE=ph_aperxr
         &PARAM="(input pt_part)"}

      {pxrun.i &PROC='deleteItem' &PROGRAM='ppccxr1.p'
                &HANDLE=ph_ppccxr1
         &PARAM="(input pt_part)"}

      delete partMaster.
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE processRead:
/*------------------------------------------------------------------------------
Purpose:       TO READ AN ITEM MASTER RECORD DEPENDING UPON THE LOCK AND WAIT
               FLAG.
Exceptions:    RECORD-LOCKED, RECORD-NOT-FOUND
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input     parameter pItemId     as  character no-undo.
   define parameter buffer    partMaster  for pt_mstr.
   define input     parameter pLockRecord as  logical   no-undo.
   define input     parameter pWait       as  logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pLockRecord then do:
         if pWait then do:
            find first partMaster exclusive-lock
               where pt_part = pItemId no-error.
         end. /* if pWait */
         else do:
            find first partMaster exclusive-lock
               where pt_part = pItemId no-error no-wait.
            if locked partMaster then
               return {&RECORD-LOCKED}.
         end. /* else */
      end. /* if pLockRecord */
      else do:
         for first partMaster no-lock
            where pt_part = pItemId:
         end. /* for first partMaster no-lock */
      end. /* else */

      if not available partMaster then
         return {&RECORD-NOT-FOUND}.
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setInspectionRequired:
/*------------------------------------------------------------------------------
Purpose:       TO SET INSPECTION REQUIRED FLAG.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define  parameter buffer partMaster for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pt_shelflife <> 0 then
         pt_insp_rqd = yes.

   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setISBRebuild:
/*------------------------------------------------------------------------------
Purpose:       TO SET INSTALLED CONFIG FILE REBUILD FLAG.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   isb_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pCoverage    as character     no-undo.
   define input parameter pOldCoverage as character     no-undo.
   define input parameter pItemId      as character     no-undo.
   define variable l_mesg              like mfc_logical no-undo.

   define buffer isb_mstr for isb_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      l_mesg = no.

      if pCoverage <> pOldCoverage and
         pCoverage = "S" then do:

         for each isb_mstr
            fields(isb_eu_nbr isb_part)
            where   isb_eu_nbr >= ""
              and   isb_part    = pItemId
            no-lock
            use-index isb_part_ser
            break by isb_eu_nbr:

            if first-of(isb_eu_nbr) then do:
               {pxrun.i &PROC='setISBRebuild' &PROGRAM='fseuxr.p'
                         &HANDLE=ph_fseuxr
                  &PARAM="(input  isb_eu_nbr,
                     output l_mesg)"}
            end. /* If first-of(isb_eu_nbr) */
         end. /* For each isb_mstr */

         if l_mesg then do:
            /* 2949 - RUN INSTALLED CONFIG FILE REBUILD */
            {pxmsg.i &MSGNUM=2949
               &ERRORLEVEL={&INFORMATION-RESULT}}
         end. /* if l_mesg */
      end. /* if pCoverage <> pOldCoverage */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setJointType:
/*------------------------------------------------------------------------------
Purpose:       TO SET JOINT TYPE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input-output parameter pJointType        as character no-undo.
   define input        parameter pBomFormulaId     as character no-undo.
   define input        parameter pOldBomFormulaId  as character no-undo.
   define input        parameter pItemId           as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pJointType    <> "5" and
         pBomFormulaId <> pOldBomFormulaId then do:
         if can-find(first ps_mstr where ps_par = pItemId
            and ps_joint_type = "1") then
            pJointType = "1".
         else pJointType = "".
      end. /* If pJointType <> "5" */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setLowerLevelCode:
/*------------------------------------------------------------------------------
Purpose:       TO SET THE LOW LEVEL CODE OF THE ITEM.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   bom_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input        parameter pItemId         as character no-undo.
   define input        parameter pBomFormulaId   as character no-undo.
   define input-output parameter pPtLowLevelCode as integer   no-undo.

   define buffer bom_mstr for bom_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC ='processRead' &PROGRAM  = 'bmbmxr.p'
                &HANDLE=ph_bmbmxr
         &PARAM="(input (if pBomFormulaId > '' then pBomFormulaId
            else pItemId),
            buffer bom_mstr,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}

      {pxgetph.i icinxr}
      if ((available bom_mstr and (pPtLowLevelCode > bom_ll_code
         or {pxfunct.i &FUNCTION = 'isDrpMrpRequired' &PROGRAM = 'icinxr.p'
                        &HANDLE=ph_icinxr
             }))
         or (not available bom_mstr and pPtLowLevelCode > 0))
         then do:
         if available bom_mstr then
            pPtLowLevelCode = bom_ll_code.
         else
            pPtLowLevelCode = 0.
      end. /* If ((available bom_mstr and (pPtLowLevelCode > bom_ll_code */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setModificationInfo:
/*------------------------------------------------------------------------------
Purpose:       TO STORE AUDIT ENTRIES INTO ITEM BUFFER.
Exceptions:    NONE
Conditions:
        Pre:   partMaster(r) or partMaster(c)
       Post:   partMaster(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define  parameter buffer partMaster for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i pxgblmgr}
      assign
         partMaster.pt_mod_date = today
         partMaster.pt_userid   =
            {pxfunct.i &FUNCTION='getCharacterValue' &PROGRAM='pxgblmgr.p'
                        &HANDLE=ph_pxgblmgr
               &PARAM='global_userid'}.

   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setMRPRequired:
/*------------------------------------------------------------------------------
Purpose:       TO SET MRP REQUIRED FLAG FOR INVENTORY RECORDS.
Exceptions:    NONE
Conditions:
        Pre:   partMaster(r)
       Post:   bom_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define parameter buffer partMaster   for pt_mstr.
   define input parameter  pOrderPolicy as  character no-undo.

   define buffer bom_mstr for bom_mstr.
   define buffer in_mstr for in_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pt_ord_pol = ""
         and pOrderPolicy <> pt_ord_pol then do:
         {pxrun.i &PROC='setMRPRequired' &PROGRAM='icinxr.p'
                   &HANDLE=ph_icinxr
            &PARAM="(input partMaster.pt_part,
               input partMaster.pt_site,
               buffer in_mstr)"}
      end. /* If pt_ord_pol = "" */

      {pxrun.i &PROC='processRead' &PROGRAM  = 'bmbmxr.p'
                &HANDLE=ph_bmbmxr
         &PARAM="(input
            (if partMaster.pt_bom_code > '' then partMaster.pt_bom_code
            else partMaster.pt_part),
            buffer bom_mstr,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}

      {pxgetph.i icinxr}
      if ((available bom_mstr and (partMaster.pt_ll_code > bom_ll_code
         or {pxfunct.i &FUNCTION = 'isDrpMrpRequired' &PROGRAM = 'icinxr.p'
                        &HANDLE=ph_icinxr
             }))
         or (not available bom_mstr and partMaster.pt_ll_code > 0)) and
         (partMaster.pt_pm_code <> "D" and
         partMaster.pt_pm_code <> "P") then do:
         {pxrun.i &PROC='setMRPRequiredForBom' &PROGRAM='icinxr.p'
                   &HANDLE=ph_icinxr
            &PARAM="(input partMaster.pt_part,
               input partMaster.pt_ll_code)"}
      end. /* If ((available bom_mstr and ... */

      {pxrun.i &PROC ='setMRPRequiredForAllSites' &PROGRAM='icinxr.p'
                &HANDLE=ph_icinxr
         &PARAM="(input partMaster.pt_part)"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setReplanRequired:
/*------------------------------------------------------------------------------
Purpose:       TO SET INVENTORY LEVEL TO 99999.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId          as character no-undo.
   define input parameter pNewBomFormulaId as character no-undo.
   define input parameter pOldBomFormulaId as character no-undo.
   define input parameter pNewPurMfgCode   as character no-undo.
   define input parameter pOldPurMfgCode   as character no-undo.
   define input parameter pNewNetworkCode  as character no-undo.
   define input parameter pOldNetworkCode  as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pNewBomFormulaId <> pOldBomFormulaId or
         pNewPurMfgCode   <> pOldPurMfgCode  or
         pNewNetworkCode  <> pOldNetworkCode)
         then do:
         {pxrun.i &PROC='setReplanRequiredAllSites' &PROGRAM='icinxr.p'
                   &HANDLE=ph_icinxr
            &PARAM="(input pItemId)"}
      end. /* if (pNewBomFormulaId <> pOldBomFormulaId */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE setSystemDefaultItem:
/*------------------------------------------------------------------------------
Purpose:       TO SET SYSTEM DEFAULT ITEM.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      global_part = pItemId.
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE updateApplicationOwner:
/*------------------------------------------------------------------------------
Purpose:       TO UPDATE APPLICATION OWNER.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pApplnOwner as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {mgqqapp.i "pApplnOwner"}
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE updateInventory:
/*------------------------------------------------------------------------------
Purpose:       TO UPDATE INVENTORY RECORD.
Exceptions:    NONE
Conditions:
        Pre:   partMaster(r)
       Post:   in_mstr(w)
Notes:
History:
------------------------------------------------------------------------------*/
   define       parameter buffer partMaster for pt_mstr.
   define       parameter buffer in_mstr    for in_mstr.
   define input parameter pNewItem          as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if in_avg_int = ? then
         in_avg_int = pt_avg_int.

      if in_cyc_int = ? then
         in_cyc_int = pt_cyc_int.

      if pNewItem then do:
         assign
            in_abc          = pt_abc
            in_avg_int      = pt_avg_int
            in_cyc_int      = pt_cyc_int
            in_rctpo_status = pt_rctpo_status
            in_rctpo_active = pt_rctpo_active
            in_rctwo_status = pt_rctwo_status
            in_rctwo_active = pt_rctwo_active.
      end. /* if pNewItem then do: */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE updateItemPlanning:
/*------------------------------------------------------------------------------
Purpose:       TO UPDATE ITEM PLANNING.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pNewPmCode as character no-undo.
   define input parameter pOldPmCode as character no-undo.
   define input parameter pItemId    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxgetph.i spfhxr}
      if (pOldPmCode =  "F" and
         pNewPmCode <> "F" and
         not {pxfunct.i &FUNCTION='isParentItem' &PROGRAM='spfhxr.p'
                        &HANDLE=ph_spfhxr
            &PARAM="input pItemId"})
         or (pOldPmCode <> "F"
         and pNewPmCode =  "F") then do:
         {pxrun.i &PROC ='setPurMfgCode' &PROGRAM='ppipxr.p'
                   &HANDLE=ph_ppipxr
            &PARAM="(input pItemId,
               input pNewPmCode)"}
      end. /* if (pOldPmCode =  "F" */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE validateAbcCode:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE ABC CODE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pAbcCode as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC  ='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM ="(input 'pt_abc',
                         input '',
                         input pAbcCode,
                         input '')"
      }

   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateAutoLot:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE AUTO LOT FLAG.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pLotSer  as character no-undo.
   define input parameter pAutoLot as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pLotSer = "s" and pAutoLot = yes then do:
         /*2745 - AUTO LOT IS NOT ALLOWED WITH SERIAL CONTROLLED ITEMS. */
         {pxmsg.i &MSGNUM=2745
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* if pLotSer = "s" and pAutoLot = yes then do: */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateAverageInterval:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE AVERAGE INTERVAL.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pAverageInterval as integer   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC  ='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM ="(input 'pt_avg_int',
                         input '',
                         input string(pAverageInterval) ,
                         input '')"}
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateBomCode:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE BILL OF MATERIAL.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pBomCode   as character no-undo.
   define input parameter pJointType as character no-undo.
   define input parameter pItemId    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pJointType  =  "5" and
         pBomCode    <> ""  and
         pBomCode    <> pItemId then do:

         /* 6533 - BOM/FORMULA MUST BE BLANK OR THE SAME AS THE ITEM NUMBER.*/
         {pxmsg.i &MSGNUM     = 6533
            &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* pBomCode <> "" and pBomCode <> pItemId then do: */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateBomFormulaId:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE BOM/FORMULA ID.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId          as character no-undo.
   define input parameter pNewBomFormulaId as character no-undo.
   define input parameter pOldBomFormulaId as character no-undo.
   define input parameter pNewPurMfgCode   as character no-undo.
   define input parameter pOldPurMfgCode   as character no-undo.
   define input parameter pNewNetworkCode  as character no-undo.
   define input parameter pOldNetworkCode  as character no-undo.
   define input parameter pPtJointType     as character no-undo.
   define variable l_psrecno               as integer initial 1  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pNewBomFormulaId <> pOldBomFormulaId or
         pNewPurMfgCode   <> pOldPurMfgCode  or
         pNewNetworkCode  <> pOldNetworkCode)
         then do:
         {gprun.i ""bmpsmta1.p""
                   "(pItemId,
                     """",
                     if pNewBomFormulaId > '' then pNewBomFormulaId
                     else pItemId,
                     input-output l_psrecno)"}

         {pxrun.i &PROC ='validateNoCyclicStructure' &PROGRAM='bmpsxr.p'
                   &HANDLE=ph_bmpsxr
                  &PARAM="(input l_psrecno)"
         }
      end. /* if (pNewBomFormulaId <> pOldBomFormulaId */

      {pxrun.i &PROC      ='validateBomCode'
               &PARAM     ="(input pNewBomFormulaId,
                             input pPtJointType,
                             input pItemId)"
      }

      if pNewBomFormulaId > "" then do:
         {pxrun.i &PROC ='validateParentItem' &PROGRAM='bmpsxr.p'
                   &HANDLE=ph_bmpsxr
                  &PARAM="(input pNewBomFormulaId)"
         }
      end. /* if pNewBomFormulaId > "" then do: */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateBuyerPlanner:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE BUYER PLANNER.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pBuyer as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC       ='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
               &PARAM      ="(input 'pt_buyer',
                              input '',
                              input pBuyer,
                              input '')"
               &FIELD-LIST = pt_buyer
      }

   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateConfigType:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE CONFIGURATION TYPE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pCfg        as character no-undo.
   define input parameter pPurMfgCode as character no-undo.

   define variable valid_mnemonic as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pPurMfgCode =  "C" or
         (pPurMfgCode <> "C" and pCfg <> "")) and
         can-find(first lngd_det
         where lngd_lang    = global_user_lang
         and lngd_dataset = "pt_mstr"
         and lngd_field   = "pt_cfg_type") then do:
         {pxrun.i &PROC='validateLanguageDetail' &PROGRAM='gplngxr.p'
                   &HANDLE=ph_gplngxr
            &PARAM="(input 'pt_mstr',
               input 'pt_cfg_type',
               input pCfg,
               input '3093')"}
      end. /* If (pPurMfgCode =  "C" or */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateCoverage:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE COVERAGE.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GEN-APP-EXCEPT}:
      if not(lookup(pValue,"S,C,N")<> 0) then do:
         /* 1382 - VALUE MUST BE [C]OVERED, [S]UBASSEMBLIES, OR [N]ONE */
         {pxmsg.i &MSGNUM=1382
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If not(lookup(pValue,"S,C,N")<> 0) then do: */
   end. /* Do on error undo, return error {&GEN-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateCreate:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE WHILE CREATING AN ITEM.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   partMaster(r), soc_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.

   define buffer soc_ctrl   for soc_ctrl.
   define buffer partMaster for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* VALIDATE THE ENTERED ITEM CODE */
      {pxrun.i &PROC='validateItemId'
         &PARAM="(input pItemId)"}

      /* CHECK FOR EXISTENCE OF ENTERED ITEM CODE */
      {pxrun.i &PROC ='processRead'
         &PARAM="(input  pItemId,
            buffer partMaster,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}

      if return-value = {&SUCCESS-RESULT} then do:
         /* 7115 - ITEM ALREADY EXISTS IN ITEM MASTER */
         {pxmsg.i &MSGNUM     = 7115
            &ERRORLEVEL = {&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* if return-value = {&SUCCESS-RESULT} */

      /* VALIDATE THE ENTERED ITEM AGAINST EXISTING CUSTOMER ITEMS    */
      /* ONLY IF THE SEARCH FOR CUSTOMER ITEM FIRST FLAG (SOC__QADL02)*/
      /* IS SET TO NO IN THE SALES ORDER CONTROL FILE.                */
      for first soc_ctrl
         fields(soc_apm soc__qadl02)
         no-lock:
      end. /* for first soc_ctrl */
      if not available soc_ctrl or not soc_ctrl.soc__qadl02 then
         {pxrun.i &PROC='validateItemDoesNotExist' &PROGRAM='ppcixr.p'
                   &HANDLE=ph_ppcixr
            &PARAM="(input pItemId)"
            &FIELD-LIST=pt_part}

      {pxrun.i &PROC='validateDefaultSite'
         &FIELD-LIST= pt_part}
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateCycleCountInterval:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE CYCLE COUNT INTERVAL.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pCycleCountInterval as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_cyc_int',
            input '',
            input string(pCycleCountInterval) ,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateDefaultSite:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE THE DEFAULT SITE SETUP IN INVENTORY CONTROL FILE.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   icc_ctrl(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define buffer icc_ctrl for icc_ctrl.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first icc_ctrl
         fields(icc_site)
         no-lock:
      end. /* for first icc_ctrl */

      if (not can-find(si_mstr where si_site = ""))
         and (not available icc_ctrl
         or (available icc_ctrl and icc_ctrl.icc_site = ""))
         then do:
         /* 232 - INVALID DEFAULT SITE.  NEW ITEMS MAY NOT BE ADDED. */
         {pxmsg.i &MSGNUM=232
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* if (not can-find(si_mstr where si_site = "")) */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateDesignGroup:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE DESIGN GROUP.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pDesignGroup    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateDesignGroup' &PROGRAM='pccgxr.p'
                &HANDLE=ph_pccgxr
         &PARAM="(input pDesignGroup)"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateDrawingLocation:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE DRAWING LOCATION.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pDrawingLocation    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_drwg_loc',
            input '',
            input pDrawingLocation,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateDrawingSize:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE DRAWING SIZE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pDrawingSize    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_drwg_size',
            input '',
            input pDrawingSize,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateInspectionLeadTime:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE INSPECTION LEAD TIME.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as integer  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_insp_lead',
            input '',
            input string(pValue) ,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateInstallation:
/*-----------------------------------------------------------------------------
Purpose:       Check if the item requires an installation call, when an
               Installation BOM or routing has been entered.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
-----------------------------------------------------------------------------*/
   define input parameter pInstallationBomId       as character no-undo.
   define input parameter pInstallationRoutingId   as character no-undo.
   define input parameter pInstallationCall        as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pInstallationBomId <> "" or
         pInstallationRoutingId <> "")
         and not pInstallationCall then do:
         /* 771 - ITEM DOES NOT REQUIRE AN INSTALLATION CALL */
         {pxmsg.i &MSGNUM=771
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateItemGroup:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE ITEM GROUP.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemGroup    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_group',
            input '',
            input pItemGroup,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateItemId:
/*---------------------------------------------------------------------------
Purpose:       TO VALIDATE THE ENTERED ITEM CODE FOR BLANK VALUE.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
---------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pItemId = "" then do:
         /* 40 - BLANK NOT ALLOWED. */
         {pxmsg.i &MSGNUM     = 40
            &ERRORLEVEL = {&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If input pt_part = "" then do: */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateItemStatus:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE ITEM STATUS..
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemStatus as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if can-find (first qad_wkfl where qad_key1 = "PT_STATUS") and
         not can-find(qad_wkfl where qad_key1 = "PT_STATUS"
         and   qad_key2 = pItemStatus) then do:
         /* 362 - STATUS DOES NOT EXIST */
         {pxmsg.i &MSGNUM=362
            &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If can-find (first qad_wkfl where qad_key1 = "PT_STATUS") */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateItemType:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE ITEM TYPE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemType as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_part_type',
            input '',
            input pItemType,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateLotGroup:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE LOT GROUP.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPtLotGroup as character no-undo.
   define input parameter pPtSite     as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pPtLotGroup <> "") then do:
         {pxrun.i &PROC='validateLotGroup' &PROGRAM='clalxr.p'
                   &HANDLE=ph_clalxr
            &PARAM="(input pPtLotGroup,
               input pPtSite)"}
      end. /* If (pPtLotGroup <> "") */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateLotSerial:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE LOT SERIAL.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId    as character no-undo.
   define input parameter pNewLotSer as character no-undo.
   define input parameter pOldLotSer as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if not(lookup(pNewLotSer,"L,S") <> 0 or pNewLotSer = "") then do:
         /* 1371 - VALUE MUST BE (L)OT, (S)ERIAL, OR BLANK */
         {pxmsg.i &MSGNUM=1371
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* if not(lookup(pNewLotSer,"L,S") */

      if pOldLotSer = "" and pNewLotSer <> "" then do:
         {pxrun.i &PROC='validateNoLotSer' &PROGRAM='icilxr.p'
                   &HANDLE=ph_icilxr
            &PARAM="(input pItemId)"}
      end. /* If pOldLotSer = "" and pNewLotSer <> "" then do: */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateMfgLeadTime:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE MANUFACTURING LEAD TIME.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM ="(input 'pt_mfg_lead',
            input '',
            input string(pValue) ,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateModel:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE MODEL.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pModel as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_model',
            input '',
            input pModel,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateNetWeightUM:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE NET WEIGHT UNIT OF MEASURE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC ='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_net_wt_um',
            input '',
            input pValue,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateOrderPeriod:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE ORDER PERIOD    .
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pOrderPeriod as integer  no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_ord_per',
            input '',
            input string(pOrderPeriod) ,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validatePhantom:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE PHANTOM ITEM.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPhantom   as logical   no-undo.
   define input parameter pJointType as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pJointType = "1"  or
         pJointType  = "5") and
         pPhantom    = yes then do:

         /* 6512 - A CO/BY-PRODUCT OR BASE PROCESS MAY NOT BE A PHANTOM. */
         {pxmsg.i &MSGNUM=6512
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If (pJointType = "1" or pJointType = "5") */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validatePMAvailable:
/*-----------------------------------------------------------------------------
Purpose:       Check if the item's days between preventive maintenance is not
               Zero, when a PM BOM or routing has been entered
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
-----------------------------------------------------------------------------*/
   define input parameter pPMBomId       as character no-undo.
   define input parameter pPMRoutingId   as character no-undo.
   define input parameter pDaysBetweenPM as integer   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pPMBomId <> "" or
         pPMRoutingId <> "")
         and pDaysBetweenPM = 0 then do:
         /* 770 - DAYS BETWEEN PM IS ZERO */
         {pxmsg.i &MSGNUM=770
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateProductLine:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE PRODUCT LINE.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pProductLine as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if not(can-find(pl_mstr where pl_prod_line = pProductLine)) then do:
         /* 59 - PRODUCT LINE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=59
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If not(can-find(pl_mstr */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validatePromotionGroup:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE PROMOTION GROUP.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPtPromo as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_promo',
            input '',
            input pPtPromo,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validatePurchaseLeadTime:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE PURCHASE LEAD TIME.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_pur_lead',
            input '',
            input string(pValue) ,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validatePurMfgCode:
/*------------------------------------------------------------------------------
Purpose:       VALIDATE PURCHASE MANUFACTURING CODE.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId        as character no-undo.
   define input parameter pPurMfgCode    as character no-undo.
   define input parameter pOldPurMfgCode as character no-undo.
   define input parameter pJointType     as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_pm_code',
            input '',
            input pPurMfgCode,
            input '')"}

      if (pJointType = "1"  or
         pJointType  = "5") and
         pPurMfgCode = "C"  then do:
         /* 225 - CONFIGURED ITEM NOT ALLOWED. */
         {pxmsg.i &MSGNUM=225
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* if pJointType = "1" or pJointType = "5" then do: */

      {pxgetph.i spfhxr}
      if pOldPurMfgCode =  "F" and
         pPurMfgCode    <> "F" and
         {pxfunct.i &FUNCTION='isParentItem' &PROGRAM='spfhxr.p'
                     &HANDLE=ph_spfhxr
            &PARAM="input pItemId"} then do:

         /* FAMILY HIERARCHY EXISTS, CHANGE P/M CODE NOT ALLOWED */
         {pxmsg.i &MSGNUM=4644
             &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If pOldPurMfgCode =  "F" and pPurMfgCode    <> "F" */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateReceiptStatus:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE PO / WO  RECEIPT STATUS.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pActive     as logical   no-undo.
   define input parameter pStatus     as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pActive or pStatus <> "") and
         not can-find (is_mstr where is_status = pStatus) then do:
         /* 361 - INVENTORY STATUS IS NOT DEFINED. */
         {pxmsg.i &MSGNUM=361
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* IF (pActive or pStatus <> "") */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/*============================================================================*/
PROCEDURE validateRepairable:
/*-----------------------------------------------------------------------------
Purpose:       Check if the item is repairable, when a repair BOM or routing
               has been entered.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
-----------------------------------------------------------------------------*/
   define input parameter pRepairBomId       as character no-undo.
   define input parameter pRepairRoutingId   as character no-undo.
   define input parameter pRepairable        as logical   no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pRepairBomId <> "" or
         pRepairRoutingId <> "")
         and not pRepairable then do:
         /* 769 - ITEM IS NOT REPAIRABLE */
         {pxmsg.i &MSGNUM=769
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateRestrictedStatus:
/*------------------------------------------------------------------------------
Purpose:       Validation to restrict transaction for a given Item Status Code.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   partMaster(r)
       Post:   isd_det(r)
Notes:
History:       Extracted from popomtea.p
------------------------------------------------------------------------------*/
   define input parameter pPtStatus        as   character no-undo.
   define input parameter pTransactionType as   character no-undo.
   define input parameter pDisplayMessage  like mfc_logical no-undo.

   define variable ptstatus like pPtStatus no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      assign
         ptstatus = pPtStatus
         substring(ptstatus,9,1) = "#".

      if can-find(isd_det where isd_status = ptstatus
         and isd_tr_type = pTransactionType) then do:
         if pDisplayMessage
         then do:
            /* MESSAGE #358 - RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
            {pxmsg.i
               &MSGNUM=358
               &ERRORLEVEL={&APP-ERROR-RESULT}
               &MSGARG1=pPtStatus}
         end. /* IF pDisplayMessage */
         return error {&APP-ERROR-RESULT}.
      end. /* IF CAN-FIND(isd_det ... */
   end. /* DO ON ERROR UNDO, RETURN ERROR */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateRevision:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE REVISION.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pRevision as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_rev',
            input '',
            input pRevision,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateRunSequence:
/*------------------------------------------------------------------------------
Purpose:       VALIDATE RUN SEQUENCE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPtPmCode  as character no-undo.
   define input parameter pFieldName as character no-undo.
   define input parameter pRunSeq    as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if (pPtPmCode = "L") or
         (pPtPmCode <> "L" and pRunSeq <> "") then do:
         {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                   &HANDLE=ph_gpcodxr
            &PARAM="(input pFieldName,
               input '',
               input pRunSeq,
               input '')"}
      end. /* If (pPtPmCode = "L") */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateServiceCategory:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE SERVICE CATEGORY.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   serviceCategory(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pServiceCategory as character no-undo.

   define buffer serviceCategory for fsc_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if not({fsfsc.v &field=pServiceCategory &blank_ok=yes}) then do:
         /* 425 - SERVICE CATEGORY MUST EXIST */
         {pxmsg.i &MSGNUM=425
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* if not({fsfsc.v &field=pServiceCategory &blank_ok=yes}) */

      {pxrun.i &PROC ='processRead' &PROGRAM  = 'fsscxr.p'
                &HANDLE=ph_fsscxr
         &PARAM="(input  pServiceCategory,
            buffer serviceCategory,
            input  {&NO_LOCK_FLAG},
            input  {&NO_WAIT_FLAG})"}

      /* ENSURE THIS SERVICE CATEGORY APPLIES TO ITEMS */
      if available serviceCategory then
         if fsc_parts or fsc_exg_parts or fsc_con_parts then .
         else do:
            /* 417 - PART SERVICE CATEGORY MUST BE SPECIFIED */
            {pxmsg.i &MSGNUM=417
               &ERRORLEVEL={&APP-ERROR-RESULT}}
            return error {&APP-ERROR-RESULT}.
         end. /* Else do: */
      else do:
         /* 988 - SERVICE CATEGORY  MUST EXIST */
         {pxmsg.i &MSGNUM=988
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* Else do: */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateServiceGroup:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE SERVICE GROUP.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_svc_group',
            input '',
            input pValue,
            input '')"
         &FIELD-LIST = pt_svc_group}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateShipWeightUM:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE SHIP WEIGHT UNIT OF MEASURE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC ='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_ship_wt_um',
            input '',
            input pValue,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateSiteIDDefault:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE SITE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateSite' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
         &PARAM="(input 'pt_mstr.pt_site',
            input pValue,
            input no,
            input '')"}
      {pxrun.i &PROC='validateDatabaseSite' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
         &PARAM="(input pValue)"}
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateSiteIdPO:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE PURCHASE ORDER SITE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC  ='validateSite' &PROGRAM='icsixr.p'
                &HANDLE=ph_icsixr
         &PARAM ="(input 'pt_mstr.pt_po_site',
            input pValue,
            input no,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateSystemType:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE SYSTEM TYPE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_sys_type',
            input '',
            input pValue,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateTaxInfo:
/*------------------------------------------------------------------------------
Purpose:       VALIDATE TAX INFORMATION.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pTaxCode as character no-undo.

   define variable gptxc_valid as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {gprun.i ""gptxcval.p""
         "(input  pTaxCode,
         output gptxc_valid)"}

      if not gptxc_valid then
         return error {&APP-ERROR-RESULT}.
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateUMInTransHist:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE UNIT OF MEASUREMENT.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if can-find(first tr_hist use-index tr_part_trn
            where tr_part = pItemId) then do:
         /* 1451 - TRANSACTION HISTORY EXISTS FOR THIS ITEM */
         {pxmsg.i &MSGNUM=1451
            &ERRORLEVEL={&WARNING-RESULT}}
         return {&WARNING-RESULT}.
      end. /* if can-find(first tr_hist use-index tr_part_trn */
   end. /* do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateUnitOfMeasure:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE UNIT OF MEASUREMENT.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pNewUM  as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_um',
            input '',
            input pNewUM,
            input '')"
         &FIELD-LIST=pt_um}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateUsageCode:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE USAGE CODE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_svc_type',
            input '',
            input pValue,
            input '')"
         &FIELD-LIST=pt_svc_type}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateVolumeUM:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE VOLUME UNIT OF MEASURE.
Exceptions:    NONE
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pValue as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      {pxrun.i &PROC='validateGeneralizedCodes' &PROGRAM='gpcodxr.p'
                &HANDLE=ph_gpcodxr
         &PARAM="(input 'pt_size_um',
            input '',
            input pValue,
            input '')"}
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateWarrantyCode:
/*------------------------------------------------------------------------------
Purpose:       TO VALIDATE AND SELECT VALID WARRANTY CODE.
Exceptions:    WARNING-RESULT
Conditions:
        Pre:   NONE
       Post:   sv_mstr(r)
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pWarrantyCode as character no-undo.

   define buffer sv_mstr for sv_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pWarrantyCode <> " " then do:
         {fssvsel.i pWarrantyCode  ""W"" """"}
         if not available sv_mstr then do:
            /* 7116 - CONTRACT/WARRANTY TYPE IS NOT VALID */
            {pxmsg.i &MSGNUM=7116
               &ERRORLEVEL={&WARNING-RESULT}}
            return {&WARNING-RESULT}.
         end. /* If  not available sv_mstr  then do: */
      end. /* If pWarrantyCode <> " " then do: */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.


/*============================================================================*/
PROCEDURE validateYieldPercent:
/*------------------------------------------------------------------------------
Purpose:       VALIDATE YIELD PERCENT.
Exceptions:    APP-ERROR-RESULT
Conditions:
        Pre:   NONE
       Post:   NONE
Notes:
History:
------------------------------------------------------------------------------*/
   define input parameter pPtYieldPct as decimal no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      if pPtYieldPct = 0 then do:
         /* 3953 - VALUE MUST BE GREATER THAN ZERO */
         {pxmsg.i &MSGNUM=3953
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         return error {&APP-ERROR-RESULT}.
      end. /* If pPtYieldPct = 0 */
   end. /* Do on error undo, return error {&GENERAL-APP-EXCEPT}: */
   return {&SUCCESS-RESULT}.
END PROCEDURE.



/* extract from poporcm.p */
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */



/*
/*============================================================================*/
PROCEDURE processRead :
/*------------------------------------------------------------------------------
<Comment1>
ppitxr.p
processRead (
   input character pPODetailPart,
    Buffer pPt_mstr,
   input logical pLockRecord,
   input logical pWait)

Parameters:
   pPODetailPart -
   pPt_mstr -
   pLockRecord -
   pWait -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pPODetailPart as character no-undo.
   define  parameter buffer pPt_mstr for pt_mstr.
   define input parameter pLockRecord as logical no-undo.
   define input parameter pWait as logical no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first pPt_mstr
         fields(pt_lot_ser pt_part pt_rctpo_active
                pt_rctpo_status    pt_status)
         where pt_part = pPODetailPart no-lock:
      end. /* FOR FIRST pPt_mstr */
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.
*/



/* extract from poporca.p */
/* ========================================================================== */
/* ******************************** FUNCTIONS ******************************* */
/* ========================================================================== */



/*============================================================================*/
FUNCTION isAutoLotControlled RETURNS logical
   (input pPodType as character,
    input pPodPart as character):
/*------------------------------------------------------------------------------
Purpose:       Determines if the item is automatic Lot control.
ppitxr.p
isAutoLotControlled RETURNS logical (
   input character pPodType ,
   input character pPodPart )

Parameters:
   pPodType -
   pPodPart -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define variable returnData as logical no-undo.

   define buffer pt_mstrClean for pt_mstr.

   returnData = no.

   for first pt_mstrClean fields(pt_lot_ser pt_auto_lot pt_lot_grp)
      where pt_part = pPodPart no-lock:
   end.
   if available pt_mstrClean then do:
      if (pt_mstrClean.pt_lot_ser = "L" and pt_mstrClean.pt_auto_lot = yes and
          pt_mstrClean.pt_lot_grp <> "" and pPodType = "")
      then returnData = yes.
   end.

   return (returnData).
END FUNCTION.

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */



/*============================================================================*/
PROCEDURE getUnitOfMeasure :
/*------------------------------------------------------------------------------
Purpose:       Get unit of measure.
ppitxr.p
getUnitOfMeasure (
   input character pItemId,
   output character pUnitOfMeasure)

Parameters:
   pItemId -
   pUnitOfMeasure -

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/
   define input parameter pItemId as character no-undo.
   define output parameter pUnitOfMeasure as character no-undo.

   define buffer pt_mstr for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first pt_mstr
         fields(pt_part pt_um)
         where pt_part = pItemId no-lock:
      end. /*  FOR FIRST PT_MSTR */
      if available pt_mstr then
         pUnitOfMeasure = pt_um.
   end.
   return {&SUCCESS-RESULT}.
END PROCEDURE.
