/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* $Revision: 1.3.1.4 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 02/28/07  ECO: *SS - 20070415.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/* SS - 20070415.1 - B */
/*/*
define temp-table t_autocr
   field ac_sixrecid as recid
   field ac_sixselect      as logical label "*" format "*/"
   field ac_sopart         like six_sopart
   field ac_authorization  like six_authorization
   field ac_ship_id        like six_ship_id
   field ac_po             like six_po
   field ac_custref        like six_custref
   field ac_modelyr        like six_modelyr
   field ac_salesorder     like six_order
   index ac_partauth
         ac_sopart
         ac_authorization
   index ac_authpart
         ac_authorization
         ac_sopart
   index ac_shippart
         ac_ship_id
         ac_sopart
   index ac_popart
         ac_po
         ac_sopart
   index ac_sixrecid is unique
         ac_sixrecid.
*/
DEFINE {1} SHARED TEMP-TABLE ttxxapbkrp0001
   field ttxxapbkrp0001_bk_code like bk_code
   field ttxxapbkrp0001_bk_desc like bk_desc
   field ttxxapbkrp0001_ad_sort like ad_sort
   field ttxxapbkrp0001_ad_date like ad_date
   field ttxxapbkrp0001_ad_lang like ad_lang
   field ttxxapbkrp0001_ad_line1 like ad_line1
   field ttxxapbkrp0001_ad_line2 like ad_line2
   field ttxxapbkrp0001_ad_line3 like ad_line3
   field ttxxapbkrp0001_ad_city like ad_city
   field ttxxapbkrp0001_ad_state like ad_state
   field ttxxapbkrp0001_ad_zip like ad_zip
   field ttxxapbkrp0001_ad_format like ad_format
   field ttxxapbkrp0001_ad_country like ad_country
   field ttxxapbkrp0001_ad_ctry like ad_ctry
   field ttxxapbkrp0001_ad_county like ad_county
   field ttxxapbkrp0001_ad_attn like ad_attn
   field ttxxapbkrp0001_ad_attn2 like ad_attn2
   field ttxxapbkrp0001_ad_phone like ad_phone
   field ttxxapbkrp0001_ad_ext like ad_ext
   field ttxxapbkrp0001_ad_phone2 like ad_phone2
   field ttxxapbkrp0001_ad_ext2 like ad_ext2
   field ttxxapbkrp0001_ad_fax like ad_fax
   field ttxxapbkrp0001_ad_fax2 like ad_fax2
   field ttxxapbkrp0001_bk_check like bk_check
   field ttxxapbkrp0001_bk_entity like bk_entity
   field ttxxapbkrp0001_bk_curr like bk_curr
   field ttxxapbkrp0001_bk_bk_acct1 like bk_bk_acct1
   field ttxxapbkrp0001_bk_acct like bk_acct
   field ttxxapbkrp0001_bk_sub like bk_sub
   field ttxxapbkrp0001_bk_cc like bk_cc
   field ttxxapbkrp0001_bk_bk_acct2 like bk_bk_acct2
   field ttxxapbkrp0001_bk_pip_acct like bk_pip_acct
   field ttxxapbkrp0001_bk_pip_sub like bk_pip_sub
   field ttxxapbkrp0001_bk_pip_cc like bk_pip_cc
   field ttxxapbkrp0001_bk_dftar_acct like bk_dftar_acct
   field ttxxapbkrp0001_bk_dftar_sub like bk_dftar_sub
   field ttxxapbkrp0001_bk_dftar_cc like bk_dftar_cc
   field ttxxapbkrp0001_bk_dftap_acct like bk_dftap_acct
   field ttxxapbkrp0001_bk_dftap_sub like bk_dftap_sub
   field ttxxapbkrp0001_bk_dftap_cc like bk_dftap_cc
   field ttxxapbkrp0001_bk_bkchg_acct like bk_bkchg_acct
   field ttxxapbkrp0001_bk_bkchg_sub like bk_bkchg_sub
   field ttxxapbkrp0001_bk_bkchg_cc like bk_bkchg_cc
   field ttxxapbkrp0001_bk_bktx_acct like bk_bktx_acct
   field ttxxapbkrp0001_bk_bktx_sub like bk_bktx_sub
   field ttxxapbkrp0001_bk_bktx_cc like bk_bktx_cc
   field ttxxapbkrp0001_bk_disc_acct like bk_disc_acct
   field ttxxapbkrp0001_bk_disc_sub like bk_disc_sub
   field ttxxapbkrp0001_bk_disc_cc like bk_disc_cc
   field ttxxapbkrp0001_bk_cdft_acct like bk_cdft_acct
   field ttxxapbkrp0001_bk_cdft_sub like bk_cdft_sub
   field ttxxapbkrp0001_bk_cdft_cc like bk_cdft_cc
   field ttxxapbkrp0001_bk_ddft_acct like bk_ddft_acct
   field ttxxapbkrp0001_bk_ddft_sub like bk_ddft_sub
   field ttxxapbkrp0001_bk_ddft_cc like bk_ddft_cc
   field ttxxapbkrp0001_bk_edft_acct like bk_edft_acct
   field ttxxapbkrp0001_bk_edft_sub like bk_edft_sub
   field ttxxapbkrp0001_bk_edft_cc like bk_edft_cc
   field ttxxapbkrp0001_ad_gst_id like ad_gst_id
   field ttxxapbkrp0001_ad_pst_id like ad_pst_id
   field ttxxapbkrp0001_ad_vat_reg like ad_vat_reg
   .
/* SS - 20070415.1 - E */
