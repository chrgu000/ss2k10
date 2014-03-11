/* minth根据part 产生barcode值 */

{mfdeclre.i}
define input parameter thpart as char.
define input parameter xbc   as char format  "x(24)" .
/*define input parameter xtype   as char format  "x(8)".*/

define output parameter thbcdata as char.
define output parameter thtype   as  char.
define output parameter thdesc1  as  char  format "x(24)".
define output parameter thdesc2  as  char  format "x(24)".

thbcdata = "".
find first pt_mstr no-lock where pt_domain = global_domain and pt_part = thpart  no-error .
find first xpbc_mstr no-lock where xpbc_domain = global_domain and xpbc_part = thpart  no-error .
find first code_mstr  where code_domain = global_domain and code_fldname = "BarCodeDateSeq" and code_value = "KanBan" no-error .
if avail pt_mstr and avail code_mstr then do:
   thtype =  if avail xpbc_mstr then xpbc_type else "3".
   thdesc1 = pt_desc1.
   thdesc2 = pt_desc2.
   thbcdata = STRING(TODAY, "999999") + "0001".
   if thbcdata <= code_cmmt then do:
     thbcdata  = string(deci(code_cmmt) + 1).
   end.
   code_cmmt = thbcdata.
   thbcdata = (if avail xpbc_mstr then xpbc_box_type else "" ) + thbcdata .

   /*
   define var id as int.
   id = 0 .
   for last xbc1_mstr where xbc1_domain = global_domain and xbc1_bc = thbcdata break by xbc1_id:
         id = xbc1_id + 1 .
   end.
   */
   /*ss - 120109 - b*/
    thbcdata = xbc.
   /*ss - 120109 - b*/

    {xxbccreatex.i
      &domain  = "global_domain"
      &site       = " """" "
      &part      = "thpart"
      &bc         = "thbcdata"
      &id         = "0"
       }
end.
