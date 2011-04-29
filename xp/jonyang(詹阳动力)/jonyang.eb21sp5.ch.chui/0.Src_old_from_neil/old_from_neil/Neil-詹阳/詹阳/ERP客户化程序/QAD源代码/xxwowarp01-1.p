/* GUI CONVERTED from wowarp01.p (converter v1.71) Tue Oct  6 14:58:30 1998 */
/* wowarp01.p - ALLOCATIONS BY ORDER REPORT                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowarp01.p (converter v1.00) Fri Oct 10 13:57:24 1997 */
/* web tag in wowarp01.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K102*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 05/13/86   BY: EMB      */
/* REVISION: 1.0      LAST MODIFIED: 09/02/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94**/
/* REVISION: 4.0    LAST MODIFIED: 02/24/88    BY: WUG *A175**/
/* REVISION: 5.0    LAST MODIFIED: 10/26/89    BY: emb *B357**/
/* REVISION: 5.0    LAST MODIFIED: 11/30/89    BY: emb *B409**/
/* REVISION: 5.0    LAST MODIFIED: 04/13/90    BY: emb *B663**/
/* REVISION: 7.3    LAST MODIFIED: 02/09/93    BY: emb *G656**/
/* REVISION: 7.2    LAST MODIFIED: 02/28/95    BY: ais *F0KM**/
/* REVISION: 8.6    LAST MODIFIED: 10/15/97    BY: ays *K102**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/*By: Neil Gao 09/02/06 ECO: *SS 20090206* */

     /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdtitle.i "e+ "} /*G656*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowarp01_p_1 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowarp01_p_2 "备料量"
/* MaxLen: Comment: */
&SCOPED-DEFINE wowarp01_p_4 "领料量"
&SCOPED-DEFINE wowarp01_p_3 "子零件"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable vend like wo_vend.
     define variable nbr like wod_nbr.
     define variable nbr1 like wod_nbr.
     define variable lot like wod_lot.
     define variable lot1 like wod_lot.
/*F0KM   define variable part like wod_part.  */
/*F0KM*/ define variable part like wod_part   label {&wowarp01_p_3}.
     define variable part1 like wod_part.
     define variable desc1 like pt_desc1.
     define variable desc2 like pt_desc1.
     define variable wodesc1 like pt_desc1.
     define variable wodesc2 like pt_desc1.
     define variable open_ref like wod_qty_req label {&wowarp01_p_1}.
     define variable qty_all like wod_qty_req label {&wowarp01_p_2}.
     define variable qty_pick like wod_qty_req label {&wowarp01_p_4}.
     define variable qty_all1 like wod_qty_req .
     define variable qty_pick1 like wod_qty_req  .
     define variable loc like pt_loc.
     define variable loc1 like pt_loc.
     define variable s_num as character extent 4.
     define variable d_num as decimal decimals 9 extent 4.
     define variable i as integer.
     define variable j as integer.
     define variable getall like mfc_logical initial YES label "只显示已明细备料/领料记录".
     define variable getall1 like mfc_logical initial YES label "只显示库位库存为零记录".
     define variable deliver like wod_deliver.    
     define variable deliver1 like wod_deliver.    
     define variable buyer like pt_buyer.    
     define variable buyer1 like pt_buyer.   
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        nbr            colon 15
        nbr1           label {t001.i} colon 49 skip
        part           colon 15
        part1          label {t001.i} colon 49 skip 
        lot            colon 15 
        lot1          label {t001.i} colon 49 skip 
        deliver       colon 15
        deliver1       label {t001.i} colon 49 skip 
        buyer          colon 15
        buyer1       label {t001.i} colon 49 skip (1) 

        getall colon 35
        getall1 colon 35 
/*K102*  with frame a side-labels. */
/*K102*/  SKIP(.4)  /*GUI*/
with frame a side-labels width 80.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).


/*K102*/ {wbrp01.i}

repeat : 


        if nbr1 = hi_char then nbr1 = "".
        if lot1 = hi_char then lot1 = "".
        if deliver1 = hi_char then deliver1 = "".
        if  buyer1 = hi_char then  buyer1 = "".

/*K102*/ if c-application-mode <> 'web':u then
        

					update nbr nbr1 part part1 lot lot1 deliver deliver1 buyer buyer1 getall getall1 with frame a.

/*K102*/ if (c-application-mode <> 'web':u) or
/*K102*/ (c-application-mode = 'web':u and
/*K102*/ (c-web-request begins 'data':u)) then do:

        bcdparm = "".
        {mfquoter.i nbr      }
        {mfquoter.i nbr1     }
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i lot      }
        {mfquoter.i lot1     }
        {mfquoter.i deliver  }
        {mfquoter.i deliver1 }
        {mfquoter.i buyer    }
        {mfquoter.i buyer1   }

        if nbr1 = "" then nbr1 = hi_char.
        if lot1 = "" then lot1 = hi_char.
        if deliver1 = "" then deliver1 = hi_char.
        if buyer1 = "" then buyer1 = hi_char.

					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



        {mfphead.i}

        /* FIND AND DISPLAY */
        for each wo_mstr no-lock where (wo_nbr >= nbr and wo_nbr <= nbr1)
/*SS 20090206 - B*/
				and wo_domain = global_domain 
/*SS 20090206 - E*/
        and (wo_lot >= lot and wo_lot <= lot1),
        each wod_det where wod_lot = wo_lot
/*SS 20090206 - B*/
				and wod_domain = global_domain
/*SS 20090206 - E*/
        and (wod_part >= part) and (wod_part <= part1 or part1 = "")
        and (wod_deliver >= deliver and wod_deliver <= deliver1)
        no-lock break by wo_nbr by wod_lot by wod_part
        with frame b width 400 no-attr-space:
				
				setFrameLabels(frame b:handle).
   
       
          desc1 = "".
          desc2 = "".
          find pt_mstr where pt_part = wo_part 
/*SS 20090206 - B*/
					and pt_domain = global_domain
/*SS 20090206 - E*/          
          no-lock no-error.
          if available pt_mstr then desc1 = pt_desc1.
          if available pt_mstr then desc2 = pt_desc2.
          if page-size - line-counter < 9 then page.
/*B357*/       if wod_qty_req >= 0
/*B357*/       then open_ref = max(wod_qty_req - wod_qty_iss,0).
/*B357*/       else open_ref = min(wod_qty_req - wod_qty_iss,0).

        /*        all_pick = wod_qty_all + wod_qty_pick.*/

/*B357*/       if wo_status = "C" then do:
/*B357*/          open_ref = 0.
/*B357*/          /*all_pick = 0.*/
/*B357*/       end.

        
           find pt_mstr where pt_part = wod_part and (pt_buyer >= buyer and pt_buyer <= buyer1) 
/*SS 20090206 - B*/
						and pt_domain = global_domain
/*SS 20090206 - E*/           
           no-lock no-error.
/*           if page-size - line-counter < 2 and available pt_mstr
           and pt_desc2 <> "" then page.*/
           if available pt_mstr then do:
           loc = "".
           qty_all = 0.
           qty_pick = 0.
            loc1 = "".
           qty_all1 = 0.
           qty_pick1 = 0.

         for each lad_det where lad_dataset = "wod_det" and lad_nbr = wod_lot 
/*SS 20090206 - B*/
						and lad_domain = global_domain
/*SS 20090206 - E*/
             and lad_part = wod_part break by lad_loc
              with frame b width 400 no-attr-space :
              if first(lad_loc) then do:
              qty_all = lad_qty_all.
              qty_pick = lad_qty_pick.
              loc = lad_loc.
              end.
              if last(lad_loc) and lad_loc <> loc then do:
              qty_all1 = lad_qty_all.
              qty_pick1 = lad_qty_pick.
              loc1 = lad_loc.
             end.
  
              end.
     find ld_det where ld_part = wod_part and ld_loc = loc 
/*SS 20090206 - B*/
			and ld_domain = global_domain
/*SS 20090206 - E*/     
     no-lock no-error.
      if open_ref <> 0 
         and (( getall = yes and available  lad_det and (qty_all <> 0 or qty_pick <> 0)) or getall = no)
         and ((getall1 = yes and (not available ld_det or ld_qty_oh = 0)) or getall1 = no) then do:
             display 
              wo_nbr 
              wo_lot 
              wo_status 
              wo_part label "父零件"  
              desc1  
              wod_part label "子零件"
              pt_desc1 
              pt_um
              pt_buyer
/*G656*/      wod_deliver
           wod_qty_req
           open_ref label "待发放量"
           loc
           qty_all
           qty_pick
           ld_qty_oh when available ld_det LABEL "库位库存"
           space(2) wod_iss_date WITH STREAM-IO /*GUI*/ .
/*G656*        space(2) wod_deliver. */

          if desc2 <> "" or pt_desc2 <> "" or qty_all1 <> 0 or qty_pick1 <> 0 or loc1 <> "" then do with frame b:
          down 1.
          display 
          desc2 @ desc1
          pt_desc2 @ pt_desc1
          loc1 @ loc
          qty_all1 @ qty_all
          qty_pick1 @ qty_pick WITH STREAM-IO /*GUI*/ .
         
       end.
        end.   

        end.
end.
        /* REPORT TRAILER  */
        
end.

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


/*K102*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end. /*p-report*/

end.