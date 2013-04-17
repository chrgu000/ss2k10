/* xxptpolrp.p - Item Order Policy Report                                     */
/*V8:ConvertMode=FullGUIReport                                                */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character             */
/* REVISION: 120613.1        LAST MODIFIED: 04/24/12 BY: zy                   */
/* REVISION END                                                               */

/* DISPLAY TITLE */
{mfdtitle.i "120613.1"}
define variable vkey1 like usrw_key1 no-undo
                  initial "XXMRPPORP0.P-ITEM-ORDER-POLICY".
 define variable line like pt_prod_line no-undo.
 define variable line1 like pt_prod_line no-undo.
 define variable part like pt_part no-undo.
 define variable part1 like pt_part no-undo.
 define variable type like pt_part_type no-undo.
 define variable type1 like pt_part_type no-undo.
 define variable buyer like pt_buyer no-undo.
 define variable buyer1 like pt_buyer no-undo.
 define variable vend like pt_vend no-undo.
 define variable vend1 like pt_vend no-undo.
 define variable pldesc like pl_desc no-undo.
 define variable vdsort like vd_sort no-undo.
 define variable vpoldesc as character no-undo.
 
/* SELECT FORM */
form
   line   colon 15
   line1  label {t001.i} colon 49 skip
   part   colon 15
   part1  label {t001.i} colon 49 skip
   type   colon 15
   type1  label {t001.i} colon 49 skip
   buyer  colon 15
   buyer1 label {t001.i} colon 49 skip
   vend   colon 15
   vend1  label {t001.i} colon 49 skip
with frame a side-labels width 80.

  /* SET EXTERNAL LABELS */
  setFrameLabels(frame a:handle).
{wbrp01.i}

repeat:

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".
   if buyer1 = hi_char then buyer1 = "".
   if vend1 = hi_char then vend1 = "".

   update line line1 part part1 type type1 buyer buyer1 vend vend1
   with frame a.

   if part1 = "" then part1 = hi_char.
   if line1 = "" then line1 = hi_char.
   if type1 = "" then type1 = hi_char.
   if buyer1 = "" then buyer1 = hi_char.
   if vend1 = "" then vend1 = hi_char.

 {gpselout.i &printtype = "printer"
            &printwidth = 132
            &pagedflag = "nopage"
            &stream = " "
            &appendtofile = " "
            &streamedoutputtoterminal = " "
            &withbatchoption = "yes"
            &displaystatementtype = 1
            &withcancelmessage = "yes"
            &pagebottommargin = 6
            &withemail = "yes"
            &withwinprint = "yes"
            &definevariables = "yes"}

   /* PRINTER SELECTION */
  export delimiter "~t"
         getTermLabel("ITEM_NUMBER",20)
         getTermLabel("DESCRIPTION",20)
         getTermLabel("SUPPLIER",20)
         getTermLabel("SORT_NAME",20)
         getTermLabel("UNIT_OF_MEASURE",20)
         getTermLabel("PUR/MFG",20)
         getTermLabel("MANUFACTURING_LEAD_TIME",20)
         getTermLabel("PURCHASE_LEAD_TIME",20)
         getTermLabel("Order_Multiple",20)
         getTermLabel("SHIP_TERMS",20)
         getTermLabel("DESCRIPTION",20)
         skip.

   for each pt_mstr no-lock use-index pt_prod_part
     where (pt_part >= part and pt_part <= part1)
   and (pt_prod_line >= line and pt_prod_line <= line1)
   and (pt_part_type >= type and pt_part_type <= type1)
   and (pt_buyer >= buyer and pt_buyer <= buyer1)
   and (pt_vend >= vend and pt_vend <= vend1),
   each usrw_wkfl no-lock where usrw_key1 = vkey1 and usrw_key2 = pt_part
  break by pt_prod_line by pt_part:
      assign vdsort = ""
      			 vpoldesc = "".
      find first vd_mstr no-lock where vd_addr = pt_vend no-error.
      if available vd_mstr then do:
          assign vdsort = vd_sort.
      end.
      find first code_mstr no-lock where code_fldname = "vd__chr03" and
      					 code_value = usrw_key3 no-error.
      if available usrw_wkfl then do:
      	 assign vpoldesc = code_cmmt.
      end.
      export delimiter "~t"
         pt_part
         pt_desc1
         pt_vend
         vdsort
         pt_um
         pt_pm_code
         pt_mfg_lead
         pt_pur_lead
         pt_ord_mult
         usrw_key3
         vpoldesc.
   end.

   /* REPORT TRAILER */
   {mfreset.i}

end.

{wbrp04.i &frame-spec = a}
