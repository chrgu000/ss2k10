/* xxpkrtn3.p   Retrun materiel to store	By: Sunny Zhou AtosOrigin 08/19/02 */
/* xxpkrtn3.p copy from iclotr.p	by sunnyzhou				   */
/* GUI CONVERTED from iclotr.p (converter v1.69) Tue Jul 29 20:18:40 1997 */
/* REVISION: 8.5    LAST MODIFIED: 07/11/96 BY: *G1ZM* Julie Milligan   */
/* REVISION: 8.5    LAST MODIFIED: 11/05/96 BY: *J17R* Murli Shastri    */
/* REVISION: 8.5    LAST MODIFIED: 04/18/97 BY: *H0S4* Russ Witt        */
/* REVISION: 8.5    LAST MODIFIED: 07/09/97 BY: *J1W2* Manmohan K.Pardesi */
/* REVISION: 8.5    LAST MODIFIED: 08/20/02 BY: *Sunny* AtosOrigin */

     /* DISPLAY TITLE */
/*sunny /*GH52*/ {mfdtitle.i "e+ "}   /*GH52*/ */
/*sunny*/	  {mfdeclre.i}

/*sunny*/     define shared variable xsite like tr_site no-undo.
/*sunny*/     define shared variable xxnbr like tr_nbr  no-undo.
/*sunny*/     define shared variable xxnbr1 like tr_nbr  no-undo.
/*sunny*/     define shared variable so_job like tr_so_job no-undo.
/*sunny*/     define shared variable rmks like tr_rmks  no-undo.
/*sunny*/     define shared variable eff_date like tr_effdate no-undo.

/*sunny*/     define variable xnbr  like tr_nbr .
     define new shared variable lotserial like sr_lotser no-undo.
     define new shared variable lotserial_qty like sr_qty no-undo.

     define new shared variable transtype as character
        format "x(7)" initial "ISS-TR".
     define new shared variable from_nettable like mfc_logical.
     define new shared variable to_nettable like mfc_logical.
     define new shared variable null_ch as character initial "".
     define new shared variable old_mrpflag like pt_mrp.
     define new shared variable intermediate_acct like trgl_dr_acct.
     define new shared variable intermediate_cc like trgl_dr_cc.
     define new shared variable from_expire like ld_expire.
     define new shared variable from_date like ld_date.
/*F701   def var lotref_from like ld_ref label "From Ref".                   */
/*F701   def var lotref_to like ld_ref label "To Ref".                       */
/*F003*/ define variable glcost like sct_cst_tot.
/*F190*/ define buffer lddet for ld_det.
/*F190   define variable status_to like tr_status label "Status" no-undo.    */
/*F190   define variable status_from like tr_status label "Status" no-undo.  */
/*F190*/ define variable undo-input like mfc_logical.
/*F190*/ define variable yn like mfc_logical.
/*F190*/ define variable assay like tr_assay.
/*F190*/ define variable grade like tr_grade.
/*F190*/ define variable expire like tr_expire.
/*sunny /*F701*/ define shared variable trtype as character. */
/*sunny*/ /*F701*/ define new shared variable trtype as character initial "SITE/LOC" . 
/*F701*/ define new shared variable site_from like pt_site no-undo.
/*F701*/ define new shared variable loc_from like pt_loc no-undo.
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*F701*/ define new shared variable site_to like pt_site no-undo.
/*F701*/ define new shared variable loc_to like pt_loc no-undo.
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F701*/ define variable ld_recid as recid.
/*J1W2*/ define variable ld_recid_from as recid no-undo.
/*J1W2*/ define variable lot_control like clc_lotlevel no-undo.
/*J1W2*/ define variable errmsg as integer no-undo.
/*J1W2*/ define variable lot_found like mfc_logical no-undo.
/*J1W2*/ define buffer lddet1 for ld_det.
/*J1W2*/ define variable mesg_desc as character no-undo.
/*sunny*/ define variable xAction as character format "x(30)" label "处理信息".
/*judy 05/08/09*/  define variable iss_trnbr like tr_trnbr no-undo.
/*judy 05/08/09*/  define variable rct_trnbr like tr_trnbr no-undo.
 /*judy 05/08/09*/    {gldydef.i NEW}
/*judy 05/08/09*/    {gldynrm.i NEW}

/*F0FH*/ {gpglefdf.i}

/*sunny*/ define buffer xxpnrtn for xxpn_rtn.

FORM /*GUI*/    
	xAction
	xxpn_trnbr
	xxpn_site
	xxpn_nbr
	xxpn_part		
	xxpn_tg_loc
	xxpn_trtype
	xxpn_act_loc
	xxpn_qty		
	xxpn_lot		
	xxpn_ref		
	xxpn_serial		
	xxpn_sojob		
 with stream-io frame xd width 300 NO-BOX down /*GUI*/.

mainloop:
do on error undo,leave:

	FOR EACH xxpn_rtn where xxpn_site = xSite
			  and   xxpn_nbr >= xxnbr
			  and   xxpn_nbr <= xxnbr1
			  and   not xxpn_del
			  and   not xxpn_ok
			  and   xxpn_act_loc <> ""
			  and   xxpn_tg_loc  <> ""
			  and   xxpn_act_loc <> xxpn_tg_loc
			  and   xxpn_qty <> 0 
			  and   xxpn_trtype = "RCT-TR" exclusive-lock
			  with frame xd :
		down with frame xd .
		
		IF xxpn_site = "" 
		or xxpn_nbr = "" 
		or xxpn_part = ""
		or xxpn_old_loc = "" 
		or xxpn_tg_loc = "" 
		or xxpn_act_loc = "" 
		or xxpn_qty = 0      
		THEN DO:
			xxpn_del = yes .
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"不符合回调要求" @ xaction
				with frame xd .
		   next.
		END.
		
/***********************tfq deleted begin************************/
		lotserial_qty = abs(xxpn_qty).

		site_from = xxpn_site.
		loc_from = xxpn_tg_loc.
		lotser_from = xxpn_lot.
		lotref_from = xxpn_ref.

		site_to = xxpn_site.
		loc_to  = xxpn_act_loc.
		lotser_to = xxpn_lot.
		lotref_to = xxpn_ref.

		xnbr = xxpn_nbr.
	
		  global_part = xxpn_part.
		  global_site = site_from.
		  global_loc = loc_from.
		  global_lot = lotser_from.

		FIND first pt_mstr where pt_part = xxpn_part no-lock no-error.
		if not available pt_mstr then do:	
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"找不到零件资料" @ xaction
				with frame xd .
		   next.
		end.							
	        old_mrpflag = pt_mrp.						
	        
 /*G1D2*/         find ld_det where ld_det.ld_part = pt_part
 /*G1D2*/           and ld_det.ld_site = site_from
 /*G1D2*/           and ld_det.ld_loc = loc_from
 /*G1D2*/           and ld_det.ld_lot = lotser_from
 /*G1D2*/           and ld_det.ld_ref = lotref_from no-lock no-error.
/*sunny*/		IF available ld_det and ld_qty_oh < abs(xxpn_qty) THEN
			DO:
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"已有库存小于回退数量" @ xaction
				with frame xd .
			   next.
			END.
 /*G1D2*/       if not available ld_det then do:
 /*F0D2*/          find si_mstr where si_site = site_from no-lock no-error.
 /*F0D2*/          find loc_mstr where loc_site = site_from
 /*F0D2*/                          and loc_loc = loc_from no-lock no-error.
 
 /*F0D2*/          if not available si_mstr then do:
 /*F0D2*/             /* site does not exist */
/*SUNNY /*F0D2*/             {mfmsg.i 708 3} */
/*sunny /*G1FP*/             undo from-loop, retry from-loop. */
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"地点不存在" @ xaction
				with frame xd .
/*undo= /*sunny*/	            undo, next. */
 /*F0D2*//*G1FP*            undo xferloop, retry xferloop. */
 /*F0D2*/          end.
 /*F0D2*/          if not available loc_mstr then do:
 /*F0D2*/             if not si_auto_loc then do:
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"找不到库位:" + xxpn_act_loc @ xaction
				with frame xd .
			next.
 /*F0D2*/             end.
 /*F0D2*/             else do:
 /*F0D2*/                find is_mstr where is_status = si_status
 /*F0D2*/                no-lock no-error.
 /*F0D2*/                if available is_mstr and is_overissue then do:
 /*F0D2*/                   create loc_mstr.
 /*F0D2*/                   assign
 /*F0D2*/                      loc_site = si_site
 /*F0D2*/                      loc_loc = loc_from
 /*F0D2*/                      loc_date = today
 /*F0D2*/                      loc_perm = no
 /*F0D2*/                      loc_status = si_status.
 /*F0D2*/                end.
 /*F0D2*/                else do:
 /*F0D2*/                   /* quantity available in site loc for lot serial */
 /*sunny /*F0D2*/                   {mfmsg02.i 208 3 0} */
 /*F0D2*/                end. /* available is_mstr*/
 /*F0D2*/             end. /* si_auto_loc*/
 /*F0D2*/          end. /* not available loc_mstr*/
 /*F0D2*/
 /*G0SQ*/          find is_mstr where is_status = loc_status
 /*F0D2*/          no-lock no-error.
 /*F0D2*/          if available is_mstr and is_overissue
 /*F0NL*/          and  (pt_lot_ser =  "" )
 /*F0D2*/          then do:
 /*F0D2*/             create ld_det.
  /*G1D2*/               assign
 /*G1D2*/                  ld_det.ld_site = site_from
 /*G1D2*/                  ld_det.ld_loc = loc_from
 /*G1D2*/                  ld_det.ld_part = pt_part
 /*G1D2*/                  ld_det.ld_lot = lotser_from
 /*G1D2*/                  ld_det.ld_ref = lotref_from
 /*G1D2*/                  ld_det.ld_status = loc_status
 /*G1ZM*/                  status_from = loc_status.
  /*F0D2*/         end.
 /*F0D2*/          else do:
 /*F0D2*/             /* Location/lot/item/serial does not exist */
/* /*F0D2*/             {mfmsg.i 305 3} */
		    down with frame xd.
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"库位/零件/批序号不存在" @ xaction
				with frame xd .
/*sunny*/             next.
 /*F0D2*/          end. /*available is_mstr*/
 /*F0D2*/       end. /*not available ld_det*/
		else do:

 /*G1D2*/         if ld_det.ld_qty_oh - lotserial_qty -
 /*G1D2*/                 ld_det.ld_qty_all < 0
 /*G1ZM*/                   and ld_det.ld_qty_all > 0
 /*G1ZM*/                   and ld_det.ld_qty_oh > 0
 /*G1ZM*/                   and lotserial_qty > 0
 /*FO32*/       then do:
 /*G1D2*/            status_from = ld_det.ld_status.
 /*FO32*/       end.
/*F190*/       else do:
/*G1D2*/            status_from = ld_det.ld_status.
/*F190*/       end.
	      end.
/*J1W2*/       ld_recid_from = recid(ld_det).

/*FT37*/
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
          {gprun.i ""icedit.p"" "(""ISS-TR"",
                     site_from,
                     loc_from,
                     pt_part,
                     lotser_from,
                     lotref_from,
                     lotserial_qty,
                     pt_um,
                     """",
                     """",
                     output undo-input)"
          }
/**********tfq****************************************
/*GUI*/ if global-beam-me-up then undo, leave.

/*FT37*/       if undo-input then undo, retry.

/*GUI*/ if global-beam-me-up then undo, leave.
 /* from-loop */
**********************************tfq********************/
/*F190*/          find lddet where lddet.ld_part = pt_part
/*F190*/                       and lddet.ld_site = site_to
/*F190*/                       and lddet.ld_loc  = loc_to
/*F190*/                       and lddet.ld_lot  = lotser_to
/*F190*/                       and lddet.ld_ref  = lotref_to
/*F190*/          no-error.

/*F701*/          ld_recid = ?.
/*F701*/          if not available lddet then do:
/*F701*/             create lddet.
/*F701*/             assign
/*F701*/             lddet.ld_site = site_to
/*F701*/             lddet.ld_loc = loc_to
/*F701*/             lddet.ld_part = pt_part
/*F701*/             lddet.ld_lot = lotser_to
/*GH52*/             lddet.ld_ref = lotref_to.
/*GH52*/             find loc_mstr where loc_site = site_to and
/*GH52*/             loc_loc = loc_to no-lock no-error.
/*GH52*/             if available loc_mstr then do:
/*GH52*/               lddet.ld_status = loc_status.
/*GH52*/             end.
/*GH52*/             else do:
/*GK75*/              find si_mstr where si_site = site_to no-lock no-error.
/*GH52*/                if available si_mstr then do:
/*GH52*/                 lddet.ld_status = si_status.
/*GH52*/                end.
/*GH52*/             end.
/*F701*/             ld_recid = recid(lddet).
/*F701*/          end. /*not available lddet*/
/*F701*/          /*ERROR CONDITIONS*/
/*F701*/          if  ld_det.ld_site = lddet.ld_site
/*F701*/          and ld_det.ld_loc  = lddet.ld_loc
/*F701*/          and ld_det.ld_part = lddet.ld_part
/*F701*/          and ld_det.ld_lot  = lddet.ld_lot
/*F701*/          and ld_det.ld_ref  = lddet.ld_ref then do:
/*sunny /*F701*/             {mfmsg.i 1919 3} /*Data results in null transfer*/ */
/*sunny /*F701*/             undo, retry. */
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"退回库位与原库位相同" @ xaction
				with frame xd .
			next.
/*F701*/          end.

/*J1W2*           BEGIN ADDED SECTION */
                  if (pt_lot_ser = "S")
                  then do:
             /* LDDET EXACTLY MATCHES THE USER'S 'TO' CRITERIA */
                     if lddet.ld_part = pt_part
                        and lddet.ld_site = site_to
                        and lddet.ld_loc  = loc_to
                        and lddet.ld_lot  = lotser_to
                        and lddet.ld_ref  = lotref_to
                        and lddet.ld_qty_oh > 0
                     then do:
                        mesg_desc = lddet.ld_site + ', ' + lddet.ld_loc.
                        /* SERIAL EXISTS AT SITE, LOCATION */
/*                        {mfmsg02.i 79 2 mesg_desc } */
                     end.
                     else do:
                        find first lddet1 where lddet1.ld_part = pt_part
                             and lddet1.ld_lot  = lotser_to
                             and lddet1.ld_qty_oh > 0
                             and recid(lddet1) <> ld_recid_from
                             no-lock no-error.
                        if available lddet1 then do:
                           mesg_desc = lddet1.ld_site + ', ' + lddet1.ld_loc.
                           /* SERIAL EXISTS AT SITE, LOCATION */
/*                           {mfmsg02.i 79 2 mesg_desc } */
                        end.
                     end.
                  end.
/*J1W2*           END ADDED SECTION */

/*F701*/          if lddet.ld_qty_oh = 0 then do:
/*F701*/             assign
/*G319*/             lddet.ld_date  = ld_det.ld_date
/*F701*/             lddet.ld_assay = ld_det.ld_assay
/*F701*/             lddet.ld_grade = ld_det.ld_grade
/*F701*/             lddet.ld_expire = ld_det.ld_expire.
/*F701*/          end.
/*F701*/          else do:
/*F701*/             /*Assay, grade or expiration conflict. Xfer not allowed*/
/*F701*/             if lddet.ld_grade  <> ld_det.ld_grade
/*F701*/             or lddet.ld_expire <> ld_det.ld_expire
/*F701*/             or lddet.ld_assay  <> ld_det.ld_assay then do:
/*sunny /*F701*/                {mfmsg.i 1918 4} */
			DISPLAY
				xxpn_trnbr 
				xxpn_site
				xxpn_nbr
				xxpn_part
				xxpn_tg_loc
				"---->" @ xxpn_trtype
				xxpn_act_loc
				xxpn_qty		
				xxpn_lot		
				xxpn_ref		
				xxpn_serial		
				xxpn_sojob		
				"类型不符:"  @ xaction
				with frame xd .

/*undo /*F701*/                undo, retry. */
/*F701*/             end.
/*F701*/          end.
/*0903 /*sunny*/       /* Use "from" status*/
* /*sunny*/	lddet.ld_status = ld_det.ld_status.
*/ /* need use the 'to' status*/

/*FT37*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
           {gprun.i ""icedit.p"" "(""RCT-TR"",
                       site_to,
                       loc_to,
                       pt_part,
                       lotser_to,
                       lotref_to,
                       lotserial_qty,
                       pt_um,
                       """",
                       """",
                       output undo-input)"
           }

/*GUI*/ if global-beam-me-up then undo, leave.

/*GH52*/         release lddet.
/*GH52*/         release ld_det.
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE. Done during 1/11/96 merge.*/
/*G0V9*/       {gprun.i ""icedit.p"" "(""ISS-TR"",
                       site_from,
                       loc_from,
                       pt_part,
                       lotser_from,
                       lotref_from,
                       lotserial_qty,
                       pt_um,
                       """",
                       """",
                       output undo-input)"
           }
/************tfq**************************************
/*GUI*/ if global-beam-me-up then undo, leave.

/*sunny*/ /*G0V9*/       if undo-input then undo, next.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* send-loop */
************************tfq*******************************/
/*GK75*/       hide message.

           /*PASS BOTH LOTSER_FROM & LOTSER_TO IN PARAMETER LOTSERIAL*/
/*F701*/       lotserial = lotser_from.
/*F701*/       if lotser_to = "" then substring(lotserial,40,1) = "#".
/*F701*/       else substring(lotserial,19,18) = lotser_to.

/*G1D2*  /*GH52*/       do transaction: */
/*F003         INPUT PARAMETER ORDER:                                        */
/*F003         TR_LOT, TR_SERIAL, LOTREF_FROM, LOTREF_TO QUANTITY, TR_NBR,   */
/*F003         TR_SO_JOB, TR_RMKS, PROJECT, TR_EFFDATE, SITE_FROM, LOC_FROM, */
/*F003         SITE_TO, LOC_TO, TEMPID                                       */
/*F003         GLCOST                                                        */
/*F190         ASSAY, GRADE, EXPIRE                                          */
/*F0FH         added eff_date                                                */
/*********************tfq changed ********************************************/
{gprun.i ""icxfer.p"" "("""",
                       lotserial,
                       lotref_from,
                       lotref_to,
                       lotserial_qty,
                       xnbr,
                       so_job,
                       rmks,
                       """",
                       eff_date,
                       site_from,
                       loc_from,
                       site_to,
                       loc_to,
                       no,
 /*judy 05/08/09*/    """",
 /*judy 05/08/09*/    """",
    /*judy 05/08/09*/   """",
      /*judy 05/08/09*/   0,
                       output glcost,
 /*judy 05/08/09*/   output iss_trnbr,
   /*judy 05/08/09*/   output rct_trnbr,
                       input-output assay,
                       input-output grade,
                       input-output expire)"
            }      
  /*********************tfq changed end********************************************/ 
  /*********tfq***************deleted***************************                         
/*F003*/       {gprun.i ""icxfer.p"" "("""",
                       lotserial,
                       lotref_from,
                       lotref_to,
                       lotserial_qty,
                       xnbr,
                       so_job,
                       rmks,
                       """",
                       eff_date,
                       site_from,
                       loc_from,
                       site_to,
                       loc_to,
                       no,
                       output glcost,
                       input-output assay,
                       input-output grade,
                       input-output expire)"
           }
*****************************tfq deleted end****************/
/*GUI*/ if global-beam-me-up then undo, leave.
  /*end transaction toloop */

/*sunny /*GH52*/       do transaction: */
/*F701*/       if ld_recid <> ? then
/*F701*/       find ld_det where ld_recid = recid(ld_det) no-error.
/*GE98 /*F701*/ if available ld_det and ld_det.ld_qty_oh = 0 then delete ld_det. */
/*GE98*/       if available ld_det then do:
/*GE98*/          find loc_mstr no-lock
/*GE98*/             where loc_site = ld_det.ld_site
/*GE98*/               and loc_loc  = ld_det.ld_loc.
/*GE98*/          if ld_det.ld_qty_oh = 0
/*GE98*/          and ld_det.ld_qty_all = 0
/*GE98*/          and not loc_perm
/*GE98*/          and not can-find(first tag_mstr
/*GE98*/                            where tag_site   = ld_det.ld_site
/*GE98*/                              and tag_loc    = ld_det.ld_loc
/*GE98*/                              and tag_part   = ld_det.ld_part
/*GE98*/                              and tag_serial = ld_det.ld_lot
/*GE98*/                              and tag_ref    = ld_det.ld_ref)
/*GE98*/          then delete ld_det.
/*GE98*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*repeat transaction*/
	FIND last tr_hist where tr_nbr = xxpn_nbr 
			  and   tr_effdate = eff_date
			  and   (tr_loc = xxpn_act_loc or tr_loc = xxpn_tg_loc)
			  and   tr_qty_chg = abs(xxpn_qty)
			  and   tr_date = today
			  and   (tr_type = "ISS-TR" or tr_type = "RCT-TR")
			  use-index tr_nbr_eff 
			NO-LOCK NO-ERROR.
			IF available tr_hist THEN
			DO:
				xxpn_rtn.xxpn_ok = yes.
				xaction = "退料成功" .
				xxpn_rtn.xxpn_new_trnbr = tr_trnbr.
				FIND last xxpnrtn where xxpnrtn.xxpn_trnbr = xxpn_rtn.xxpn_tg_trnbr 
				     NO-ERROR.
				IF available xxpnrtn THEN 
				DO:
				   xxpnrtn.xxpn_ok = yes.
				   xxpnrtn.xxpn_new_trnbr = tr_trnbr .
				END.
			END.
			ELSE DO:
				xxpn_rtn.xxpn_ok = no .
				xaction = "退料失败".
			END.
			DISPLAY
				xxpn_rtn.xxpn_trnbr 
				xxpn_rtn.xxpn_site
				xxpn_rtn.xxpn_nbr
				xxpn_rtn.xxpn_part
				xxpn_rtn.xxpn_tg_loc
				"---->" @ xxpn_rtn.xxpn_trtype
				xxpn_rtn.xxpn_act_loc
				xxpn_rtn.xxpn_qty		
				xxpn_rtn.xxpn_lot		
				xxpn_rtn.xxpn_ref		
				xxpn_rtn.xxpn_serial		
				xxpn_rtn.xxpn_sojob		
				xAction
				with frame xd .

   END. /* for each xxpn_rtn*/

END. /* DO ON ERROR*/

/************tfq deleted end***************/
