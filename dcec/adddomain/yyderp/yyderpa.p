/* GUI CONVERTED from yyderpa.p (converter v1.75) Fri May 22 11:20:57 2009 */
/* faderpa.p PRINT DEPRECIATION EXPENSE REPORT SUBROUTINE                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.10.1.17 $                                                             */
/*V8:ConvertMode=Report                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 11/30/99   BY: *N062* P Pigatti        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/13/00   BY: *N0G1* BalbeerS Rajput  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 10/17/00   BY: *M0V2* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *M0YX* Jose Alex        */
/* Revision:              BY: Vinod Nair        DATE: 12/24/01  ECO: *M1N8* */
/* Revision: 1.10.1.14    BY: Ashish Kapadia    DATE: 07/10/02  ECO: *M1ZW* */
/* Revision: 1.10.1.15    BY: Vivek Gogte       DATE: 11/11/02  ECO: *N1YX* */
/* $Revision: 1.10.1.17 $      BY: Rajesh Lokre      DATE: 05/19/03  ECO: *N240* */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/20/12  ECO: *SS-20120821.1*   */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}   /* WEB ENABLEMENT INCLUDE */

/* Input Parmameters */
define input parameter fromEntity   like fa_entity   no-undo.
define input parameter toEntity     like fa_entity   no-undo.
define input parameter fromBook     like fabk_id     no-undo.
define input parameter toBook       like fabk_id     no-undo.
define input parameter fromClass    like fa_facls_id no-undo.
define input parameter toClass      like fa_facls_id no-undo.
define input parameter fromAsset    like fa_id       no-undo.
define input parameter toAsset      like fa_id       no-undo.
define input parameter l-yrper      like fabd_yrper  no-undo.
define input parameter l-yrper1     like fabd_yrper  no-undo.
define input parameter Retire like mfc_logical no-undo.
define input parameter tax_fa like mfc_logical no-undo. 

define input parameter outpath     as char format "x(48)"  no-undo.

/* DEFINE VARIABLES */
/* CHARACTER */
define variable perBeg  as character format "x(6)" no-undo.
define variable perEnd  as character format "x(6)" no-undo.
define variable l_fa_id like fa_id                 no-undo.

/* INTEGER */
define variable curryer like fabd_yrper  no-undo.
define variable fa_life like fab_life no-undo.
define variable cls_desc like facls_desc no-undo.
define variable netBook    like fabd_peramt no-undo.
define variable costAmt    like fabd_peramt no-undo.
define variable desc1 like fa_desc1 no-undo.
define variable fa_class like fa_facls_id no-undo.
define variable fa_loc like fa_faloc_id no-undo.
define variable last_yrper like fabd_yrper format "x(8)" no-undo.
define variable used_yrper as integer initial 0  no-undo.
define variable accDepr    like fabd_accamt no-undo.  
define variable expAmt     like fabd_peramt no-undo.
define variable currexp    like fabd_peramt label "Curr Expense" no-undo .
define variable assetCnt   as   integer     no-undo.
define variable netTot     like fabd_accamt no-undo.
define variable netTot1     like fabd_accamt no-undo.
define variable costTot    like fabd_accamt no-undo.
define variable costTot1    like fabd_accamt no-undo.
define variable currTot    like fabd_accamt no-undo.
define variable currTot1    like fabd_accamt no-undo.
define variable disp_rsn like fa_disp_rsn no-undo.
define var sup_name as char format "x(60)" no-undo.
define var i as integer initial "1" no-undo.
/* define variable accDeprTot like fabd_accamt no-undo.  */
define variable expTot     like fabd_accamt no-undo.
define variable expTot1     like fabd_accamt no-undo.
/* define variable annTot     like fabd_accamt no-undo.  
define variable annDepr    like fabd_accamt no-undo.     */ 
define variable service_date like fab_date no-undo.
define variable ovrdt like fab_ovrdt no-undo.
define var ovramt like fab_ovramt no-undo.
define variable l_expamt like fabd_peramt no-undo.
define variable bk_id like fabd_fabk_id no-undo.
define variable total-assets       as integer                  no-undo.
define variable disp-totals        as character format "x(20)" no-undo.
define variable tot-assets-for-Rep as integer                  no-undo.
define variable loc_desc as character format "x(28)" no-undo.
define variable loc_site as character format "x(28)" no-undo.
define variable l-book-totals    as character format "x(20)" no-undo.
define variable l-entity-totals  as character format "x(20)" no-undo.
define variable l-grand-totals   as character format "x(20)" no-undo.
define variable dte01 as char format "x(10)" no-undo.
define variable disp_dt as char format "x(10)" no-undo.
define variable l_oldentity    like fa_entity  no-undo.
define variable l_oldyrper     like fabd_yrper no-undo.
define variable l_curryrper    like fabd_yrper no-undo.
define variable l_begyrper     like fabd_yrper no-undo.
define variable yrper1  like fabd_yrper no-undo.
define variable l_disp_trf     as   character format "x(17)" no-undo.
define variable l_disp_ent     as   character format "x(13)" no-undo.
define variable l_disp_fromper as   character format "x(15)" no-undo.
define variable l_disp_toper   as   character format "x(15)" no-undo.
/*Define Excel object handle */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
/*Create a New chExcel Application object */
CREATE "Excel.Application" chExcelApplication.

/*Create a new workbook based on the template chExcel file */
chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\qadtemp\mfgguitest\template\fa-temp.xls").
define buffer fabd for fabd_det .
define buffer fabd1 for fabd_det .
/* TEMPORARY TABLE FOR TRANSFER DETAILS OF THE ASSET */
define temp-table tt_fabddetail no-undo
   field tt_fabd_fa_id       like fa_id
   field tt_fabd_entity      like fa_entity
   field tt_fabd_fabk_id     like fabd_fabk_id
   field tt_fabd_from_yrper  like fabd_yrper
   field tt_fabd_to_yrper    like fabd_yrper
   field tt_fabd_expense     like fabd_accamt
   index tt_detail is primary
         tt_fabd_fa_id tt_fabd_fabk_id tt_fabd_from_yrper.

define buffer fabddet for fabd_det.



/* REPORT LOGIC */

empty temp-table tt_fabddetail.
 find first fabk_mstr where  /* *SS-20120821.1*   */ fabk_mstr.fabk_domain = global_domain and fabk_post = yes no-lock no-error.
  if avail fabk_mstr then bk_id = fabk_id.
/* COMBINED for first fa_mstr WITH for each fabd_det TO CORRECT */
/* THE PROBLEM OF TOTALS NOT PRINTED WHEN THE NON-DEPRECIATING  */
/* ASSET IS THE LAST ASSET IN A BREAK GROUP                     */
  find first glc_cal where  /* *SS-20120821.1*   */ glc_cal.glc_domain = global_domain and glc_start <= today and glc_end >= today no-lock no-error.
         if avail glc_cal then do:
           if integer(glc_per) < 10 then   curryer = string(glc_year) + "0" + string(glc_per).
            else curryer = string(glc_year) +  string(glc_per).
        end.
/* GET EACH ASSET ID WITHIN USER SELECTED RANGES */
     for each fa_mstr where  /* *SS-20120821.1*   */ fa_mstr.fa_domain = global_domain and fa_id >= fromAsset and fa_id <= toAsset 
         and fa_entity >= fromEntity and fa_entity  <= toEntity
         and fa_facls_id >= fromClass and fa_facls_id <= toClass 
         and ( (not fa_id begins "T"  and not tax_fa) or (fa_id begins "T"  and  tax_fa) ) 
         and  fa_dep
         and (Retire  or ((not Retire) and fa_disp_rsn = "") )
         break by fa_id:
         
   /* ONLY FIND COST AMOUNT IF NEW ASSETid OR BOOK */
   /* ACCUMULATE DEPR AND NET BOOK AMOUNTS */

   /* FIRST-OF(fabd_fa_id) HERE GIVES UNIQUE RECORD FOR */
   /* ASSET, BOOK AND ENTITY COMBINATION                */
   if first-of(fa_id)
   then do:

      /* GET CORRECT STARTING YEAR PERIOD FOR USE IN OBTAINING */
      /* TRANSFER DETAILS IN CASE ASSET HAS BEEN TRANSFERRED   */
      if l-yrper <> ""
      then
         l_begyrper = l-yrper.
      else do:
         for first fabddet
            fields (fabd_fa_id fabd_fabk_id fabd_yrper)
            where  /* *SS-20120821.1*   */ fabddet.fabd_domain = global_domain 
	    and fabddet.fabd_fa_id   = fa_id  /* fabd_det.fabd_fa_id  */
        /*    and   fabddet.fabd_fabk_id = fabd_det.fabd_fabk_id  */
            no-lock:
            l_begyrper = fabddet.fabd_yrper.
          end. /*  FOR FIRST fabddet */
      end.  /* ELSE */      
       
      /* GET THE ASSET COST AS OF TO YEAR/PERIOD */
      {gprunp.i "fapl" "p" "fa-get-cost-asof-date"
         "(input  fa_id,
           input  bk_id,
           input  l-yrper1,
           input  no,
           output costAmt)"}

      /* GET THE TOTAL PERIOD DEPRECIATION FOR    */
      /* GIVEN YEAR/PERIOD RANGE.                 */

      {gprunp.i "fapl" "p" "fa-get-perdep-range"
         "(input fa_id,
          input  bk_id,
          input  l_begyrper,
          input  l-yrper1,
          output expAmt)"}

     {gprunp.i "fapl" "p" "fa-get-perdep-range"
         "(input fa_id,
          input  bk_id,
          input  l-yrper1,
          input  l-yrper1,
          output currexp)"}
         
      {gprunp.i "fapl" "p" "fa-get-perdep"
         "(input  fa_id,
           input  bk_id,
           input  l_begyrper,
           output l_expamt)"}
   
      {gprunp.i "fapl" "p" "fa-get-accdep"
         "(input  fa_id,
           input  bk_id,
           input  l_begyrper,
           output accDepr)"}
  
      /* GET COST FROM fa_mstr FOR NON-DEPRECIATING ASSETS */
      if not fa_dep
      then
         costAmt = fa_puramt.
      assign
         accDepr = accDepr  - l_expamt  
         netBook = (costAmt - accDepr) - expAmt
         perBeg  = string(integer(substring(l_begyrper,1,4))
                   - 1) + "12"
         perEnd  = string(substring(l_begyrper,1,4)) + "12".

   end. /* ASSET AND BOOK COMPARISON */
      


   /* PROCESS FOR EACH ASSET */
   if last-of(fa_id) 
   then do:
     
     
      ovramt = 0.
     find first facls_mstr where  /* *SS-20120821.1*   */ facls_mstr.facls_domain = global_domain and  facls_mstr.facls_id = fa_mstr.fa_facls_id no-lock no-error.
       if avail facls_mstr then cls_desc = facls_mstr.facls_desc.
    
     find last fab_det where  /* *SS-20120821.1*   */ fab_det.fab_domain = global_domain and fab_fa_id = fa_id and fab_fabk_id = bk_id
             no-lock no-error.
      if avail fab_det then do:
        fa_life = fab_life.
        ovrdt = fab_det.fab_ovrdt .
        ovramt = fab_ovramt.
        service_date = fab_date.
         end.    
      find last fabd1 where  /* *SS-20120821.1*   */ fabd1.fabd_domain = global_domain and fabd1.fabd_fa_id =  fa_id  and fabd1.fabd_fabk_id =  bk_id
          no-lock no-error.
        if avail fabd1 then last_yrper = fabd1.fabd_yrper.  
        if l-yrper1 <= last_yrper then last_yrper =  l-yrper1 . 
      if ovramt > 0 then do:
           used_yrper = integer(fa__int01). 
        for each glc_cal where /* *SS-20120821.1*   */ glc_cal.glc_domain = global_domain and glc_start > ovrdt and 
              ( glc_year < integer(substring(last_yrper,1,4))
                or  (glc_year = integer(substring(last_yrper,1,4)) and  glc_per <= integer(substring(last_yrper,5,6))) )
                 no-lock:
              used_yrper = used_yrper + 1.
            end.  
      end. 
       
       if ovramt = 0 then do:
             used_yrper = 0.
        for each glc_cal where /* *SS-20120821.1*   */ glc_cal.glc_domain = global_domain and  glc_start > service_date and 
       ( glc_year < integer(substring(last_yrper,1,4))
                or  (glc_year = integer(substring(last_yrper,1,4)) and  glc_per <= integer(substring(last_yrper,5,6))) )
            no-lock:
              used_yrper = used_yrper + 1.
         end.      
   end.
               
     find first  faloc_mstr where /* *SS-20120821.1*   */ faloc_mstr.faloc_domain = global_domain and  faloc_mstr.faloc_id =  fa_mstr.fa_faloc_id no-lock no-error.
        if avail faloc_mstr then loc_desc = trim(faloc_mstr.faloc_desc).
        
     find first ad_mstr where /* *SS-20120821.1*   */ ad_mstr.ad_domain = global_domain and ad_addr = string(trim(fa_mstr.fa_faloc_id)) no-lock no-error.
        if avail ad_mstr then loc_site = trim(ad_line1).    
     if fa_mstr.fa__dte01 = ? then assign dte01 = "" .
        else  dte01 = string(fa_mstr.fa__dte01,"9999/99/99").
     if fa_mstr.fa_disp_dt = ? then assign disp_dt = "" .
        else  disp_dt = string(fa_mstr.fa_disp_dt,"9999/99/99").   
     find first code_mstr where /* *SS-20120821.1*   */ code_mstr.code_domain = global_domain and code_fldname = "fa_chr04" and trim(string(code_value))= 
          trim(string(fa__chr04)) no-lock no-error.
     if avail code_mstr then sup_name = trim(code_cmmt).
        else sup_name = "".
         i = i + 1.
/*Fill*/
  chExcelWorkbook:Worksheets(1):Cells(i,1) = fa_id.
  chExcelWorkbook:Worksheets(1):Cells(i,2) =  trim(string(fa_mstr.fa_desc1)).  
  chExcelWorkbook:Worksheets(1):Cells(i,3) = string(fa_mstr.fa_startdt).   
  chExcelWorkbook:Worksheets(1):Cells(i,4) = costAmt.     
  chExcelWorkbook:Worksheets(1):Cells(i,5) = expAmt.  
  chExcelWorkbook:Worksheets(1):Cells(i,6) = netBook.  
  chExcelWorkbook:Worksheets(1):Cells(i,7) = currexp. 
  chExcelWorkbook:Worksheets(1):Cells(i,8) = fa_mstr.fa_salvamt. 
  chExcelWorkbook:Worksheets(1):Cells(i,9) = fa_mstr.fa_facls_id.
  chExcelWorkbook:Worksheets(1):Cells(i,10) = cls_desc.  
  chExcelWorkbook:Worksheets(1):Cells(i,11) = fa_mstr.fa_faloc_id.
  chExcelWorkbook:Worksheets(1):Cells(i,12) = loc_desc.  
  chExcelWorkbook:Worksheets(1):Cells(i,13) = loc_site.  
  chExcelWorkbook:Worksheets(1):Cells(i,14) = fa_life.  
  chExcelWorkbook:Worksheets(1):Cells(i,15) = used_yrper.           
  chExcelWorkbook:Worksheets(1):Cells(i,16) = trim(string(fa_mstr.fa_auth_number)) .  
  chExcelWorkbook:Worksheets(1):Cells(i,17) = trim(string(fa_mstr.fa_custodian)) .  
  chExcelWorkbook:Worksheets(1):Cells(i,18) = trim(string(fa_mstr.fa__chr01)).  
  chExcelWorkbook:Worksheets(1):Cells(i,19) = trim(string(fa_mstr.fa__chr02)).  
  chExcelWorkbook:Worksheets(1):Cells(i,20) = trim(string(fa__chr04)).  
  chExcelWorkbook:Worksheets(1):Cells(i,21) = sup_name.
  chExcelWorkbook:Worksheets(1):Cells(i,22) = string(fa_mstr.fa__dte01).  
  chExcelWorkbook:Worksheets(1):Cells(i,23) = fa_mstr.fa_disp_rsn .  
  chExcelWorkbook:Worksheets(1):Cells(i,24) = string(fa_mstr.fa_disp_dt).                               
                      
 end.

       
end. /* FOR EACH fabd_det */

   /*Save the new chExcel data workbook file */ 
   chExcelWorkbook:SaveAs(outpath + "\" + "FA" + ".xls",,,,,,1).

 chExcelWorkbook:CLOSE.
 chExcelApplication:QUIT.
 /* release com - handles */
 RELEASE OBJECT chExcelWorkbook.
 RELEASE OBJECT chExcelApplication.


/*GUI*/ {mfguichk.i } 

