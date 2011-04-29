/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "A "}
      define variable cust like ar_cust.
      define variable date like ar_effdate.
      define variable date1 like ar_effdate.


          
      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      cust label "客户"  colon 25
      date label "生效日期"  colon 25   date1  colon 50 label {t001.i} skip (1)
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



      /* REPORT BLOCK */
    
/*K0SM*/ {wbrp01.i}

repeat : 

            if cust = hi_char then cust = "".
            if date = low_date then date = ?.
            if date1 = hi_date then date1 = ?.


					update cust date date1 with frame a.

/*K0SM*/ if (c-application-mode <> 'web':u) or
/*K0SM*/ (c-application-mode = 'web':u and
/*K0SM*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i cust   }
         {mfquoter.i date  }
         {mfquoter.i date1   }

               if cust = "" then cust = hi_char.
               if date = ? then date = low_date.
               if date1 = ? then date1 = hi_date.


/*K0SM*/ end.
         /* SELECT PRINTER */
         
					{mfselbpr.i "printer" 132}

         {mfphead.i}
      define variable effdate like ar_effdate.
      define variable nbr like ar_nbr.
      define variable rmk like ar_po.
      define variable dr like ar_amt.
      define variable cr like ar_amt.
      define variable bal like ar_amt.
      define variable bebal like ar_amt.
      define variable enbal like ar_amt.
      define variable type like ar_type.


         for each ar_mstr no-lock where
/*SS 20090207 - B*/
						ar_domain = global_domain and
/*SS 20090207 - E*/
          ( ar_cust = cust ) and
          ( ar_effdate >= date ) and
          ( ar_type <> "a" ) and
          ( ar_type <> "d" ):
             bebal = bebal + ar_base_amt.
         end.
         for each ar_mstr no-lock where
/*SS 20090207 - B*/
					ar_domain = global_domain and
/*SS 20090207 - E*/
          ( ar_cust = cust ) and
          ( ar_effdate >= date1 ) and
          ( ar_type <> "a" ) and
          ( ar_type <> "d" ):
             enbal = enbal + ar_base_amt.
         end.
         find cm_mstr no-lock where cm_addr = cust
/*SS 20090207 - B*/
					and cm_domain = global_domain
/*SS 20090207 - E*/         
         .
             bebal = cm_balance - bebal.
             enbal = cm_balance - enbal.
             bal = bebal.
         display
            cm_addr label "代码"
            cm_sort label "名称"  skip(.4)
            date label "期初日期"
            date1 label "期末日期" skip(.4)
            bebal label "期初余额"
            enbal label "期末余额"
            with side-labels.
            
         for each ar_mstr no-lock where
/*SS 20090207 - B*/
					ar_domain = global_domain and
/*SS 20090207 - E*/
          ( ar_cust = cust ) and
          ( ar_effdate >= date ) and
          ( ar_effdate <= date1 ) and
          ( ar_type <> "a" ) and
          ( ar_type <> "d" )
          with width 132 by ar_effdate:
            if ar_base_amt >= 0 then
               dr = ar_base_amt.
            else
               cr = - ar_base_amt.
            effdate = ar_effdate.
            nbr = ar_nbr.
            type = ar_type.
            rmk = ar_po.
            bal = bal + dr - cr.
            display
     effdate column-label "生效日期"
     nbr column-label "凭证号"
     type column-label "类型"
     rmk column-label "摘要"
     dr column-label "借方"
     cr column-label "贷方"
     bal column-label "余额"
          WITH  STREAM-IO /*GUI*/ .

            dr = 0.
            cr = 0.
        

         end.

         /* REPORT TRAILER  */
         
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .



      end.


 