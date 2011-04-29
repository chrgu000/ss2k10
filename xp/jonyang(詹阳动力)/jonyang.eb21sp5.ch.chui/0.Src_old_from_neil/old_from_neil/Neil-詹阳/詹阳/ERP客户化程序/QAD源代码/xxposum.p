/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "A "}
      define variable line like pl_prod_line.
      define variable line1 like pl_prod_line.
      define variable date like prh_rcp_date.
      define variable date1 like prh_rcp_date.

      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      line label "产品类"   colon 25   line1  colon 50 label {t001.i}
      date label "生效日期"   colon 25   date1  colon 50 label {t001.i} skip (1)
/*FQ80*   with frame a side-labels attr-space. */
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).

      /* REPORT BLOCK */
    
/*K0SM*/ {wbrp01.i}

repeat : 
	
     if line1 = hi_char then line1 = "".
     if date = low_date then date = ?.
     if date1 = hi_date then date1 = ?.

			update line line1 date date1 with frame a.

/*K0SM*/ if (c-application-mode <> 'web':u) or
/*K0SM*/ (c-application-mode = 'web':u and
/*K0SM*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i line   }
         {mfquoter.i line1  }
         {mfquoter.i date   }
         {mfquoter.i date1  }

         if line1 = "" then line1 = hi_char.
         if date = ? then date = low_date.
         if date1 = ? then date1 = hi_date.


/*K0SM*/ end.
         /* SELECT PRINTER */
             
					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




         {mfphead.i}
         
         define variable lin like pl_prod_line.
         define variable ccost like prh_pur_cost.
         define variable cstd like prh_pur_std.
         define variable cost like prh_pur_cost.
         define variable std like prh_pur_std.
         define variable cvar like prh_pur_cost.
         define variable varn like prh_pur_cost.
         define variable crate like prh_pur_cost.
         define variable rate like prh_pur_cost.
         
         for each pl_mstr no-lock where
             ( pl_prod_line >= line ) and
             ( pl_prod_line <= line1 )
             with width 160:
             
             lin = pl_prod_line.
             
             for each prh_hist no-lock where
                 ( prh_rcp_date >= date ) and
                 ( prh_rcp_date <= date1 ):
                 find pt_mstr no-lock where
                      ( pt_prod_line = lin ) and
                      ( pt_part = prh_part ) no-error.
                      if available pt_mstr then do:
                         ccost = ccost + prh_rcvd * prh_pur_cost.
                         cstd = cstd + prh_rcvd * prh_pur_std.
                      end.
             end.
             for each prh_hist no-lock where
                 ( prh_rcp_date <= date1 ):
                 find pt_mstr no-lock where
                      ( pt_prod_line = lin ) and
                      ( pt_part = prh_part ) no-error.
                      if available pt_mstr then do:
                         cost = cost + prh_rcvd * prh_pur_cost.
                         std = std + prh_rcvd * prh_pur_std.
                      end.
             end.
             
             cvar = ccost - cstd.
             varn = cost - std.
             crate = cvar / cstd * 100.
             rate = varn / std * 100.
             
             display
               lin column-label "产品类"
               cstd column-label "本期标准成本"
               ccost column-label "本期订单成本"
               cvar column-label "本期差异"
               crate column-label "本期差异率%"
               std column-label "累计标准成本"
               cost column-label "累计订单成本"
               varn column-label "累计差异"
               rate column-label "累计差异率%"
               WITH STREAM-IO /*GUI*/ .
             
             ccost = 0.
             cstd = 0.
             cost = 0.
             std = 0.

         end.

         /* REPORT TRAILER  */
         
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


      end.

/*K0SM*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end. 