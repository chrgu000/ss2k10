/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "A "}
      define variable vend like prh_vend.
      define variable vend1 like prh_vend.
      define variable date like prh_rcp_date.
      define variable date1 like prh_rcp_date.


      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      vend label "供应商"  colon 25   vend1  colon 50 label {t001.i}
      date label "生效日期"  colon 25   date1  colon 50 label {t001.i} skip (1)
/*FQ80*   with frame a side-labels attr-space. */
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

      /* REPORT BLOCK */
    
/*K0SM*/ {wbrp01.i}

repeat :

     if vend1 = hi_char then vend1 = "".
     if date = low_date then date = ?.
     if date1 = hi_date then date1 = ?.


			update vend vend1 date date1 with frame a.

/*K0SM*/ if (c-application-mode <> 'web':u) or
/*K0SM*/ (c-application-mode = 'web':u and
/*K0SM*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i vend   }
         {mfquoter.i vend1  }
         {mfquoter.i date   }
         {mfquoter.i date1  }

         if vend1 = "" then vend1 = hi_char.
         if date = ? then date = low_date.
         if date1 = ? then date1 = hi_date.


/*K0SM*/ end.
         /* SELECT PRINTER */
         
					{mfselbpr.i "printer" 132}




         {mfphead.i}
      define variable nbr like prh_nbr.
      define variable receiver like prh_receiver.
      define variable vd like prh_vend.
      define variable sort like vd_sort.
      define variable part like prh_part.
      define variable line like pt_prod_line.
      define variable rmk1 like pt_desc1.
      define variable rmk2 like pt_desc2.
      define variable qty like prh_rcvd.
      define variable std like prh_pur_std.
      define variable cost like prh_pur_cost.
         
      for each prh_hist no-lock where
/*SS 20090207 - B*/
					prh_domain = global_domain and 
/*SS 20090207 - E*/
/*SS 20090207 - B*/
/*
          ( prh_last_vo = "" ) and
*/
/*SS 20090207 - E*/
          ( prh_vend >= vend ) and
          ( prh_vend <= vend1 ) and
          ( prh_rcp_date >= date ) and
          ( prh_rcp_date <= date1 )
          with width 180:
          
          nbr = prh_nbr.
          receiver = prh_receiver.
          vd = prh_vend.
          part = prh_part.
/*SS 20090207 - B*/
/*
          qty = ( prh_rcvd - prh_inv_qty ).
*/
/*SS 20090207 - E*/
          std = prh_pur_std.
          cost = prh_pur_cost.
          
          find vd_mstr no-lock where
/*SS 20090207 - B*/
								vd_domain = global_domain and 
/*SS 20090207 - E*/
               ( vd_addr = prh_vend ) no-error.
               if available vd_mstr then
               sort = vd_sort.
               else
               sort = "".
               
          find pt_mstr no-lock where
/*SS 20090207 - B*/
								pt_domain= global_domain and
/*SS 20090207 - E*/
               ( pt_part = prh_part ) no-error.
               if available pt_mstr then do:
                  rmk1 = pt_desc1.
                  rmk2 = pt_desc2.
                  line = pt_prod_line.
               end.   
               else do:
                  rmk1 = "".
                  rmk2 = "".
                  line = "".
               end.
               
          display
               nbr column-label "采购单"
               receiver column-label "收货单"
               vd column-label "供应商"
               sort column-label "供应商名称"
               part column-label "零件号"
               rmk1 column-label "零件名称"
               rmk2 column-label ""
               line column-label "产品类"
               qty column-label "暂估数量"
               std column-label "标准成本"
               cost column-label "采购成本"
               
 WITH STREAM-IO /*GUI*/ .
        
         end.

         /* REPORT TRAILER  */

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


      end.
 