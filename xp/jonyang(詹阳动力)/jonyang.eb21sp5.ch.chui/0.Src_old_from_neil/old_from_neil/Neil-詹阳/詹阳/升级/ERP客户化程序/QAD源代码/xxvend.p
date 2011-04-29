
      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "A "}
          
      define variable vend like ap_vend.
      define variable date like ap_effdate.
      define variable date1 like ap_effdate.
      define variable effdate like ap_effdate.
      define variable ref like ap_ref.
      define variable invoice like vo_invoice.
      define variable rmk like ap_rmk.
      define variable dr like ap_amt.
      define variable cr like ap_amt.
      define variable bal like ap_amt.
      define variable bebal like ap_amt.
      define variable enbal like ap_amt.
      define variable type like ap_type.
      define variable amt_balance  like vd_balance.	
      define variable amt_prepay   like vd_prepay.	
      define variable voamt  like vd_balance.	
      define variable ckamt  like vd_balance.	
      define variable voamt1 like vd_balance.	
      define variable ckamt1 like vd_balance.	

      define variable drsum like ap_amt.
      define variable crsum like ap_amt.
         
      define variable dr1    like ap_amt.
      define variable cr1    like ap_amt.
      define variable drsum1 like ap_amt.
      define variable crsum1 like ap_amt.
      define variable begamt like vd_balance format "->>>,>>>,>>>,>>9.9<<<".	
      define variable endamt like vd_balance format "->>>,>>>,>>>,>>9.9<<<".	

      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
      vend label "供应商"  colon 25
      date label "生效日期"  colon 25   date1  colon 50 label {t001.i} skip (1)
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

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



      /* REPORT BLOCK */
    
/*K0SM*/ {wbrp01.i}


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

            if vend = hi_char then vend = "".
            if date = low_date then date = ?.
            if date1 = hi_date then date1 = ?.

/*F058*/
/*K0SM*/ if c-application-mode <> 'web':u then
           
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0SM*/ {wbrp06.i &command = update &fields = "  vend date date1" &frm = "a"}

/*K0SM*/ if (c-application-mode <> 'web':u) or
/*K0SM*/ (c-application-mode = 'web':u and
/*K0SM*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i vend   }
         {mfquoter.i date   }
         {mfquoter.i date1  }

         if vend = "" then vend = hi_char.
         if date = ?  then date  = low_date .
         if date1 = ? then date1 = hi_date.

         amt_balance = 0.
         amt_prepay  = 0.


/*K0SM*/ end.
         /* SELECT PRINTER */
             
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


         {mfphead.i}

         bebal = 0.
         voamt = 0.
         ckamt = 0.
         voamt1 = 0.
         ckamt1 = 0.
         drsum = 0.
         crsum = 0.
         
/*** Frank.xu 
         for each ap_mstr no-lock where ( ap_vend = vend ) and ( ap_effdate >= date ):
             bebal = bebal + ap_base_amt.
         end.
         for each ap_mstr no-lock where ( ap_vend = vend ) and ( ap_effdate >= date1 ):
             enbal = enbal + ap_base_amt.
         end.
***frank.xu**/

         for each ap_mstr no-lock where ( ap_vend = vend ) and ( ap_effdate >= date ):
             if ap_type = "vo" then voamt = voamt + ap_base_amt .
             if ap_type = "ck" then ckamt = ckamt + ap_base_amt .
         end.
         
         for each ap_mstr no-lock where ( ap_vend = vend ) and ( ap_effdate >= date1 ):
             if ap_type = "vo" then voamt1 = voamt1 + ap_base_amt .
             if ap_type = "ck" then ckamt1 = ckamt1 + ap_base_amt .
/**             enbal = enbal + ap_base_amt.  **/
         end.
         
         find first vd_mstr where vd_addr = vend no-lock no-error.
         if available vd_mstr then do : 
            bebal = vd_balance - voamt + ckamt.
            enbal = vd_balance - voamt1 + ckamt1.
/*            bebal = vd_balance - bebal. */
/*            enbal = vd_balance - enbal. */
            amt_prepay = vd_prepay.
            bal = bebal.
         end.

         display
            vd_addr label "代码"   colon 10  
            vd_sort label "名称"   colon 36  skip(.4)
            date  label "期初日期" format 99/99/9999 colon 10
            date1 label "期末日期" format 99/99/9999 colon 36 
/*frank.xu.xom ****
            bebal label "期初余额" colon 10
            enbal label "期末余额" colon 36 space(6) amt_prepay label "预付余额"
*********/            
            with side-labels width 99.
            


         for each ap_mstr no-lock where ( ap_vend = vend ) 
         and ( ap_effdate > date1 ) with width 132 by ap_effdate:
     
            if ap_base_amt >= 0 then cr1 = ap_base_amt.
            else
               dr1 = - ap_base_amt.
            effdate = ap_effdate.
            ref = ap_ref.
            type = ap_type.
            rmk = ap_rmk.
            if ap_type = "vo" or ap_type = "rv" then do: 
               find vo_mstr no-lock where vo_ref = ap_ref.
               invoice = vo_invoice.
                 if vo_prepay >= 0 then
                    dr1 = vo_prepay.
                 else
                    cr1 = ap_base_amt - vo_prepay.
            end.
            
            drsum1 = drsum1 + dr1.
            crsum1 = crsum1 + cr1.
            dr1 = 0.
            cr1 = 0.
        
         end.

         bal = 0.

         for each ap_mstr no-lock where ( ap_vend = vend ) and ( ap_effdate >= date ) 
         and ( ap_effdate <= date1 ) with width 132 by ap_effdate:
     
            if ap_base_amt >= 0 then
               cr = ap_base_amt.
            else
               dr = - ap_base_amt.
            effdate = ap_effdate.
            ref = ap_ref.
            type = ap_type.
            rmk = ap_rmk.
            if ap_type = "vo" or ap_type = "rv" then do: 
               find vo_mstr no-lock where vo_ref=ap_ref.
               invoice = vo_invoice.
                 if vo_prepay >= 0 then
                    dr = vo_prepay.
                 else
                    cr = ap_base_amt - vo_prepay.
            end.
            else do:
              invoice="".
              end.
              bal = bal + cr - dr.
              display
                effdate column-label "生效日期"
                ref column-label "凭证号"
                type column-label "类型"
                invoice column-label "发票"
                rmk column-label "摘要"
                dr column-label "借方"
                cr column-label "贷方"
/**                bal column-label "余额"   ***/
                ap_acct column-label "帐户"
              WITH STREAM-IO /*GUI*/ .
              
              drsum = drsum + dr.
              crsum = crsum + cr.
              dr = 0.
              cr = 0.
        
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

         end.
         
         begamt = vd_balance - vd_prepay + drsum - crsum + drsum1 - crsum1 .
         if begamt < 0 then endamt = begamt - drsum + crsum .
         else endamt = begamt - drsum + crsum .
/***         
         display space(3) drsum label "借方发生额" space(3) crsum label "贷方发生额" space(3)
                          begamt format "->>>,>>>,>>>,>>9.999" label "期初余额" space(3)
                          endamt format "->>>,>>>,>>>,>>9.999" label "期末余额" space(3)
                          vd_balance space(3) 
                          vd_prepay with frame cc width 132.
***/
         display space(45) "发生额总计:" space(1) drsum crsum with frame c1 width 132 no-labels STREAM-IO.
         display space(12) begamt format "->>>,>>>,>>>,>>9.999" label "期初余额" space(3)
                          endamt format "->>>,>>>,>>>,>>9.999" label "期末余额" space(3)
                          vd_balance space(3) 
                          vd_prepay with frame c2 width 132.
         
         
         drsum = 0.
         crsum = 0.
         drsum1 = 0.
         crsum1 = 0.
         begamt = 0.
         endamt = 0.
         

         /* REPORT TRAILER  */
         
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


      end.

/*K0SM*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" vend date date1 /*fpos fpos1*/ "} /*Drive the Report*/

 

