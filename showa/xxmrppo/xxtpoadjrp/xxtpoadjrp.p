/* xxtpoadjrp.p - T type po order qty adjuestment report                      */
/*V8:ConvertMode=FullGUIReport                                                */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character             */
/* REVISION: 120613.1        LAST MODIFIED: 04/24/12 BY: zy                   */
/* REVISION END                                                               */

/* DISPLAY TITLE */
{mfdtitle.i "120628.1"}
define variable vkey1 like usrw_key1 no-undo
                  initial "XXMRPPORP0.P-ITEM-TTYPEPO-QTYADJ".
define variable part like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable vdsort like vd_sort no-undo.

/* SELECT FORM */
form
   part   colon 15
   part1  label {t001.i} colon 49 skip(2)
with frame a side-labels width 80.

  /* SET EXTERNAL LABELS */
  setFrameLabels(frame a:handle).
{wbrp01.i}

repeat:

   if part1 = hi_char then part1 = "".

   update part part1 with frame a.

   if part1 = "" then part1 = hi_char.

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
         getTermLabel("ADJUSTMENT_QUANTITY",20)
         skip.


for each usrw_wkfl no-lock where usrw_key1 = vkey1 and
         usrw_key2 >= part and usrw_key2 <= part1,
    each pt_mstr no-lock use-index pt_prod_part
        where pt_part = usrw_key2
  break by pt_prod_line by pt_part:
      assign vdsort = "".
      find first vd_mstr no-lock where vd_addr = pt_vend no-error.
      if available vd_mstr then do:
          assign vdsort = vd_sort.
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
         usrw_decfld[1].
   end.

   /* REPORT TRAILER */
   {mfreset.i}

end.

{wbrp04.i &frame-spec = a}
