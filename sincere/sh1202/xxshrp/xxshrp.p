/* xxptpolrp.p - Item Order Policy Report                                     */
/*V8:ConvertMode=FullGUIReport                                                */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character             */
/* REVISION: 120613.1        LAST MODIFIED: 04/24/12 BY: zy                   */
/* REVISION END                                                               */

/* DISPLAY TITLE */
{mfdtitle.i "120823.1"}
{xxusrwkey1202.i}
{xxshrp.i "NEW"}
define variable vsptodesc like xxsh_shipto.
define variable vlgvddesc like xxsh_lgvd.
define variable vptdesc like pt_desc1.
define variable vstatdesc as character format "x(30)".
FUNCTION d2c RETURNS character(iDate as Date) forward.
FUNCTION getMsg RETURNS character(inbr as integer) forward.
/* SELECT FORM */
form
   site   colon 18
   site1  label {t001.i} colon 49 skip
   absid   colon 18
   absid1  label {t001.i} colon 49 skip
   shnbr   colon 18
   shnbr1  label {t001.i} colon 49 skip
   stat  colon 18 vstatdesc no-label skip(2)
with frame a side-labels width 80.
  /* SET EXTERNAL LABELS */
  setFrameLabels(frame a:handle).
{wbrp01.i}
assign vstatdesc = getMsg(99805).
display vstatdesc with frame a.
repeat:

   if site1 = hi_char then site1 = "".
   if absid1 = hi_char then absid1 = "".
   if shnbr1 = hi_char then shnbr1 = "".

   update site site1 absid absid1 shnbr shnbr1 stat
   with frame a.

   if site1 = "" then site1 = hi_char.
   if absid1 = "" then absid1 = hi_char.
   if shnbr1 = "" then shnbr1 = hi_char.

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
    {gprun.i ""xxshrp01.p"" }
   /* PRINTER SELECTION */
  export delimiter "~t"
         getTermLabel("SITE",20)
         getTermLabel("NUMBER",20)
         getTermLabel("LOGISTICS_NUMBER",20)
         getTermLabel("LOGISTICS_VENDOR_ID",20)
         getTermLabel("LOGISTICS_VENDOR",20)
         getTermLabel("SHIP-TO_ID",20)
         getTermLabel("SHIP-TO_ADDRESS",20)
         getTermLabel("TOTALS",20)
         getTermLabel("PRICE",20)
         getTermLabel("PICKUP_COST",20)
         getTermLabel("DELIVERY_COST",20)
         getTermLabel("UNLOADING_COSTS",20)
         getTermLabel("LABELING_COST",20)
         getTermLabel("OPEN_DATE",20)
         getTermLabel("OPERATORS",20)
         getTermLabel("REMARKS",20)         
         getTermLabel("ITEM_NUMBER",20)
         getTermLabel("DESCRIPTION",20)
         getTermLabel("SHIP_TO_PO",20)
         getTermLabel("ORDER",20)
         getTermLabel("ORDER_LINE",20)
         getTermLabel("QUANTITY_TO_SHIP",20)
         getTermLabel("UNIT_OF_MEASURE",20)
         getTermLabel("OPEN",20)
         getTermLabel("DUE_DATE",20)
         getTermLabel("SHIP_DATE",20)
         getTermLabel("MODEL_YEAR",20)
         getTermLabel("CUSTOMER_REFERENCE",20)
         skip.
for each xxsh_mst no-lock where xxsh_domain = global_domain
		 and xxsh_site >= site and (xxsh_site <= site1 or site1 = "") 
		 and xxsh_abs_id >= absid and (xxsh_abs_id <= absid1 or absid1 = ?)
		 and xxsh_nbr >= shnbr and (xxsh_nbr <= shnbr1 or shnbr1 = ?)
		 and (xxsh_stat = stat or stat = "*"):
     assign vsptodesc = ""
            vlgvddesc = "".
     find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
               usrw_key1 = vsptokey and usrw_key2 = xxsh_shipto
            no-error.
     if available usrw_wkfl then do:
        assign vsptodesc = usrw_key3.
     end.
     find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                usrw_key1 = vlgvdkey and usrw_key2 = xxsh_lgvd
            no-error.
     if available usrw_wkfl then do:
        assign vlgvddesc = usrw_key3.
     end.		 
		 put unformat "'" xxsh_site "~t"
		 						  "'" trim(substring(xxsh_abs_id,2,50)) "~t"
		 						  "'" xxsh_nbr "~t"
		 							"'" xxsh_lgvd "~t"
                  vlgvddesc "~t"
                  xxsh_shipto "~t"
                  vsptodesc  "~t"
                  xxsh_price + xxsh_pc + xxsh_dc + xxsh_uc + xxsh_lc "~t"
                  xxsh_price "~t"
                  xxsh_pc "~t"
                  xxsh_dc "~t"
                  xxsh_uc "~t"
                  xxsh_lc "~t"
                  d2c(xxsh_gen_date) "~t"
                  xxsh_userid "~t"
                  xxsh_rmks "~t".
      for each xsh_det no-lock where xsh_site = xxsh_site 
      		 and xsh_abs_id = xxsh_abs_id
      		 and xsh_nbr = xxsh_nbr
      		 break by xsh_nbr by xsh_abs_id by xsh_abs_order by xsh_abs_line:
      		 assign vptdesc = "".
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = xsh_abs_item no-error.
           if available pt_mstr then do:
              assign vptdesc = pt_desc1.
           end.
      		 if not first-of(xsh_nbr) then do:
      		   put unformat  "~t~t~t~t~t~t~t~t~t~t~t~t~t~t~t~t".
      		 end.
      		 put unformat
      		 						 "'" xsh_abs_item "~t"
                       vptdesc "~t"
                       "'" xsh_shipper_po "~t"
                       "'" xsh_abs_order "~t"
                        xsh_abs_line "~t"
                        xsh_abs_qty "~t"
                        xsh_um "~t"
                        xsh_open_qty "~t"
                        d2c(xsh_due_date) "~t"
                        d2c(xsh_abs_shp_date) "~t"
                        xsh_sod_modelyr "~t"
                        xsh_sod_custref.	
      	 	if not last-of(xsh_nbr) then put skip.
      end.  /* for each xsh_det no-lock */
      put skip.
end.
         
 
/*   for each xxsh_mst no-lock use-index xxsh_abs_nbr where                  */
/*        xxsh_domain = global_domain and                                    */
/*       (xxsh_site >= site and xxsh_site <= site1) and                      */
/*       (xxsh_abs_id >= "P" + absid and xxsh_abs_id <= "P" + absid1) and    */
/*       (xxsh_nbr >= shnbr and xxsh_nbr <= shnbr1) and                      */
/*       (stat = "*" or xxsh_stat = stat),                                   */
/*       each abs_mstr no-lock where abs_domain = global_domain and          */
/*             abs_site = xxsh_site and abs_id = xxsh_abs_id:                */
/*      assign vlgvddesc = ""                                                */
/*             vsptodesc = "".                                               */
/*      find first usrw_wkfl no-lock where usrw_domain = global_domain       */
/*             and usrw_key1 = vlgvdkey no-error.                            */
/*      if available usrw_wkfl then do:                                      */
/*          assign vlgvddesc = usrw_key2.                                    */
/*      end.                                                                 */
/*       find first usrw_wkfl no-lock where usrw_domain = global_domain      */
/*             and usrw_key1 = vsptokey no-error.                            */
/*      if available usrw_wkfl then do:                                      */
/*         assign vsptodesc = usrw_key2.                                     */
/*      end.                                                                 */
/*      export delimiter "~t" xxsh_site xxsh_abs_id xxsh_nbr.                */
/*   end.                                                                    */

   /* REPORT TRAILER */
   {mfreset.i}

end.

{wbrp04.i &frame-spec = a}

FUNCTION d2c RETURNS character(iDate as Date):
 /* -----------------------------------------------------------
    Purpose: convert date to YYYY-MM-DD
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  return string(year(idate),"9999") + "-" +
         string(month(idate),"99") + "-" +
         string(day(idate),"99").
END FUNCTION. /*FUNCTION putDate*/

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = global_user_lang 
  			 and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return string(inbr).
  end.
END FUNCTION. /*FUNCTION getMsg*/
