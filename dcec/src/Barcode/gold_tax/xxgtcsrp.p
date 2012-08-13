/* xxgtcsrp.p - Customer Information Report for Golden Tax                */
/* COPYRIGHT Infopower.Ltd. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.6      LAST MODIFIED: 01/13/2001   BY: IFP010 */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

 {mfdtitle.i "f "}  /*GUI moved to top.*/

 define variable addr like cm_addr.
 define variable addr1 like cm_addr.
 define variable name like emp_lname.
 define variable name1 like emp_lname.
 define variable adline like ad_line1 format "x(50)".
 define variable vatreg like ad_pst_id format "x(16)".

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
          addr           colon 15
	    addr1          label {t001.i} colon 49 skip(1)

	  SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80 /*GUI*/ NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

 
/*GUI*/ {mfguirpa.i true  "printer" 355 }

/*GUI*/ procedure p-enable-ui:

	    if addr1 = hi_char then addr1 = "".
	    if name1 = hi_char then name1 = "".
	    
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	    bcdparm = "".
	    {mfquoter.i addr   }
	    {mfquoter.i addr1  }
	    {mfquoter.i name   }
	    {mfquoter.i name1  }

	    if  addr1 = "" then addr1 = hi_char.
	    if  name1 = "" then name1 = hi_char.

	    /* SELECT PRINTER  */
	    
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 355}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

          for each  ad_mstr  where ad_addr >= addr and ad_addr <= addr1
          and ad_type = "customer" no-lock,
          each cm_mstr no-lock where cm_mstr.cm_addr = ad_mstr.ad_addr 
          with frame b width 355 STREAM-IO:
    
            adline = string(ad_line1 + ad_line2 ,"x(50)").
            if ad_vat_reg = ""  then 
               vatreg = substring(ad_pst_id,3,18) .
            else 
               vatreg = ad_vat_reg .
            
            display ad_addr label "代码"
               ad_name label "名称"  FORMAT "x(60)"
               adline  label "注册地址"
               vatreg label "增值税号"
               ad__chr01 format "x(50)" label "开户银行及帐号"
               string(ad_mstr.ad_line3,"x(4)") label "简称"  space(2)
               ad_format label "国内/外"  space(2)
               string(ad_mstr.ad_zip,"x(6)") label "邮编" 
               string(ad_mstr.ad_attn,"x(8)") label "联系人"  .

          end.   
               

	    {mfphead.i}
	          
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

 	    /* REPORT TRAILER */

	    
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	 end.

/*GUI*/ end procedure. /*p-report*/

/*GUI*/ {mfguirpb.i &flds=" addr addr1 "} /*Drive the Report*/


