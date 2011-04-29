/*  程序名&说明                                                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/06/20   BY: Softspeed Jack    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "090915.1"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var   v_nbr               like xic_nbr .
define var v_loc_from             like xic_loc_from .
define var v_type                like xxicm_type .
define shared var v_type1        like xxicm_type .
define var v_acc                 like xxicm_acc .
define var v_accd                like xxicm_accd .
define var v_dept                like cc_ctr .
define var v_desc1               like pt_desc1 .
define var v_desc2               like pt_desc2 .
define var v_desc3               like ac_desc .
define var v_desc4               like sb_desc .
define var v_desc5               like cc_desc .
define var v_desc6               like pj_desc .
define var v_project             like pj_project .
define variable del-yn like mfc_logical initial no.
 define new shared var lotserial_qty1 like xic_qty_from .
          define new shared var um1 like xic_um .
          define new shared var site1 like xic_site_from .
          define new shared var conv1 like um_conv .
          define new shared var eff_date1 like glt_effdate .
          define new shared var dr_acct1 like trgl_dr_acct .
          define new shared var dr_sub1 like trgl_dr_sub.
          define new shared var dr_cc1 like trgl_dr_cc.
	  define new shared var dr_proj1 like pj_project .
          define new shared var location1 like sr_loc .
          define new shared var lotserial1 like sr_lotser.
          define new shared var lotref1 like sr_ref format "x(8)" .
          define new shared var mulity_entry1 like mfc_logical .
          define new shared var ordernbr1 like tr_nbr .
          define new shared var orderline1 like tr_line .

	  define variable error-found like mfc_logical.
          define variable undo-input  like mfc_logical.
define new shared variable transtype as character format "x(7)" initial "iss-unp".
define new shared var eff_date2 like glt_effdate initial today .


define  frame a.

{gpglefv.i}
{gprunpdf.i "gpglvpl" "p"}

{gldydef.i new}
{gldynrm.i new}

/* DISPLAY SELECTION FORM */

form
    SKIP(.2)
    
    v_nbr                     colon 12 label "出库单号码" validate ( can-find( first xic_det where xic_det.xic_domain = global_domain and xic_nbr = input v_nbr and xic__log01 = no),"此单号已经确认或非计划外出库资料" ) 
    eff_date2                 colon 32 label "确认日期" validate ( eff_date2 <> ? ,"确认日不能为空")
    v_loc_from                  colon 50 label "库位"
    v_type                  colon 70 label "单据类型" 
    
    v_acc                   colon 5 label "帐户"
    v_desc3                 colon 15 no-label  format "x(20)"
    
    v_accd                  colon 45 label "分账户"
    v_desc4                  colon 57     no-label   format "x(18)"
    
    v_dept                  colon 5 label "成本"
    v_desc5                 colon 15    no-label format "x(20)" 
   
    v_project               colon 45 label "项目"
    v_desc6                  colon 57   no-label  format  "x(18)" 

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).


/* DISPLAY */
view frame a.


mainloop:
repeat with frame a:
    clear frame a no-pause .


    ststatus = stline[1].
    status input ststatus. 
    assign eff_date2 = today .

    prompt-for  v_nbr with frame a editing:

         if frame-field = "v_nbr" then do:
            {mfnp.i xic_det v_nbr  "xic_det.xic_domain = global_domain and xic_nbr "  v_nbr xic_nbr xic_nbr }
             if recno <> ? then do:
                
                    find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = xic_type no-lock no-error .
                     v_acc = if available xxicm_mstr then xxicm_acc else "" .
                     v_accd = if available xxicm_mstr then xxicm_accd else "" .
                     
		     find first ac_mstr where ac_domain = global_domain and ac_code = v_acc no-lock no-error .
		     v_desc3 = if available ac_mstr then ac_desc else "" .
		     find first sb_mstr where sb_domain = global_domain and sb_sub = v_accd no-lock no-error .
		     v_desc4 = if available sb_mstr then sb_desc else "" .
		     find first cc_mstr where cc_domain = global_domain and cc_ctr = xic__chr01 no-lock no-error .
		     v_desc5 = if available cc_mstr then cc_desc else "" .
		     find first pj_mstr where pj_domain = global_domain and pj_project = xic__chr02 no-lock no-error .
		      v_desc6 = if available pj_mstr then pj_desc else "" .

                display xic_nbr @ v_nbr  eff_date2 xic_loc_from @ v_loc_from xic_type @ v_type v_acc v_desc3 v_accd v_desc4 xic__chr01 @ v_dept v_desc5 xic__chr02 @ v_project v_desc6 with frame a .
                for each xic_det where xic_domain = global_domain and xic_nbr = input v_nbr :
                  find first pt_mstr where pt_domain = global_domain and pt_part = xic_part no-lock no-error .
                   v_desc1 =  if available pt_mstr then pt_desc1 else "" .
                   v_desc2 = if available pt_mstr then pt_desc2 else "" .
                 display xic_line label "项次" xic_part label "料号" v_desc1 + v_desc2 label "说明" xic_qty_from label "出库数量" xic_lot_from format "x(17)" label "批号" xic_ref_from label "序号" xic_um column-label "UM" with width 100 stream-io .   
                end .
               end.
           end .
          else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end. 
          
    end. /* PROMPT-FOR...EDITING */
   
    assign v_nbr .
    
    update eff_date2 .
    
    find first  xic_det where xic_domain = global_domain and xic_nbr = input v_nbr .
    find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = xic_type no-lock no-error .
                     v_acc = if available xxicm_mstr then xxicm_acc else "" .
                     v_accd = if available xxicm_mstr then xxicm_accd else "" .
                    
		     find first ac_mstr where ac_domain = global_domain and ac_code = v_acc no-lock no-error .
		     v_desc3 = if available ac_mstr then ac_desc else "" .

		     find first sb_mstr where sb_domain = global_domain and sb_sub = v_accd no-lock no-error .
		     v_desc4 = if available sb_mstr then sb_desc else "" .
		     find first cc_mstr where cc_domain = global_domain and cc_ctr = xic__chr01 no-lock no-error .
		     v_desc5 = if available cc_mstr then cc_desc else "" .
		     find first pj_mstr where pj_domain = global_domain and pj_project = xic__chr02 no-lock no-error .
		      v_desc6 = if available pj_mstr then pj_desc else "" .

    display xic_nbr @ v_nbr  xic_loc_from @ v_loc_from xic_type @ v_type v_acc v_desc3 v_accd v_desc4 xic__chr01 @ v_dept v_desc5  xic__chr02 @ v_project v_desc6 with frame a .
     
    for each xic_det where xic_domain = global_domain and xic_nbr = input v_nbr :
        find first pt_mstr where pt_domain = global_domain and pt_part = xic_part no-lock no-error .
           v_desc1 =  if available pt_mstr then pt_desc1 else "" .
           v_desc2 = if available pt_mstr then pt_desc2 else "" .
          display xic_line label "项次" xic_part label "料号" v_desc1 + v_desc2 label "说明" xic_qty_from label "出库数量" xic_lot_from format "x(17)" label "批号" xic_ref_from label "序号" xic_um column-label "UM" with width 100 stream-io .   
    end .
    
    find first  xic_det where xic_domain = global_domain and xic_nbr = input v_nbr .

    if available xic_det  and lookup( xic_type , v_type1 ) > 0 then do :
    find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = xic_type and xxicm_confirm = 2 /* and xic_type = v_type1 */ no-lock no-error .
     if not available xxicm_mstr then do :
        message  "请输入计划外出库资料" view-as alert-box .
        clear frame a .
        undo mainloop,retry mainloop .
      end .
    end .
    else do :
      message "此菜单不能确认此类型或单号不存在" view-as alert-box .
      clear frame a .
      undo mainloop ,retry mainloop .
    end .
/* SS - 090915.1 - B */
if xic__log01 = yes then do :
    message "此单号已经确认，不能做修改" view-as alert-box .
    undo , retry .
end .   
/* SS - 090915.1 - E */   
   message "是否确认" view-as alert-box question buttons yes-no-cancel title "确认" update choice as logical .
    
 if choice = yes then do :
 
   for each xic_det where xic_det.xic_domain = global_domain and  xic_nbr = input v_nbr and xic__log01 = no :
   
     if xic_qty_from = 0 then do :
        message xic_nbr xic_line "此笔资料数量为零!" view-as alert-box .
	clear frame a .
	undo mainloop,retry mainloop .
      end .

 /*  find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = xic_type and xxicm_confirm = 0 no-lock no-error .
     if not available xxicm_mstr then do :
        message "请输入计划外出库资料" view-as alert-box .
        clear frame a .
        undo mainloop,retry mainloop .
      end .  */
    
    find first ac_mstr where ac_domain = global_domain and ac_code =  xxicm_acc  no-lock no-error .
      if not available ac_mstr then do :
        message "帐户不存在!" view-as alert-box .
	clear frame a .
	undo mainloop,retry mainloop .
      end .

      find first sb_mstr where sb_domain = global_domain and sb_sub =  xxicm_accd no-lock no-error .
       if not available sb_mstr then do :
        message "分帐户不存在!" view-as alert-box .
	clear frame a .
	undo mainloop ,retry mainloop .
	end .

    find first cc_mstr where cc_domain = global_domain and cc_ctr =  xic__chr01 no-lock no-error .
      if not available cc_mstr then do :
        message "成本中心不存在" view-as alert-box .
	clear frame a .
	undo mainloop , retry mainloop .
      end .

      find first pj_mstr where pj_domain = global_domain and pj_project =  xic__chr02 no-lock no-error .
      if not available pj_mstr then do :
        message "项目不存在" view-as alert-box .
	clear frame a .
	undo mainloop , retry mainloop .
      end .
    
    find first si_mstr where si_mstr.si_domain = global_domain and si_site = xic_site_from no-lock no-error .
      if not available si_mstr then do :
        message "地点不存在!" view-as alert-box .
	clear frame a .
	undo mainloop , retry mainloop .
      end .

    find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = xic_site_from
        and loc_loc = xic_loc_from no-lock no-error .
      if not available loc_mstr then do :
         message "库位不存在" view-as alert-box .
	 clear frame a .
	 undo mainloop,retry mainloop .
      end . 

   find first pt_mstr where pt_domain = global_domain and pt_part = xic_part no-lock no-error .
      if not available pt_mstr then do :
        message "料号基本资料不存在!" view-as alert-box .
        undo mainloop,retry mainloop .
      end .


     if /* ((transtype = "ISS-UNP"  and lotserial_qty > 0) or
             (transtype = "RCT-UNP"  and lotserial_qty < 0)) and */
            xic_qty_from <> 0
         then do:

            run checkConsignmentInventory
               (input xic_nbr,
                input xic_line,
                input xic_site_from,
                input xic_part,
                input xic_loc_from,
                input xic_lot_from,
                input xic_ref_from,
                input xic_qty_from * 1,
                output error-found).

           if error-found
               then do:
               /* UNABLE TO ISSUE/RECEIVE CONSIGNED INVENTORY*/
               {pxmsg.i &MSGNUM=4937 &ERRORLEVEL=3}
               undo mainloop,retry mainloop .
            end.  
	end .

	{gprun.i ""icedit.p""
               "(transtype,
                 xic_site_from,
                 xic_loc_from,
                 xic_part,
                 xic_lot_from,
                 xic_ref_from,
                 xic_qty_from,
                 xic_um,
                 """",
                 """",
                 output undo-input)"}
         if undo-input then  undo mainloop,retry mainloop .
	  
            
    

       assign  lotserial_qty1 = xic_qty_from
               um1 = xic_um
               site1 = xic_site_from
               conv1 = 1
               eff_date1 = eff_date2   
               dr_acct1 = xxicm_acc
               dr_sub1  = xxicm_accd
               dr_cc1   = xic__chr01
	       dr_proj1 = xic__chr02
               location1 = xic_loc_from
               lotserial1 = xic_lot_from
               lotref1    = xic_ref_from
               mulity_entry1 = no 
               ordernbr1 = xic_nbr
               orderline1 = xic_line .

  find si_mstr where si_domain = global_domain and
                            si_site   = site1 no-lock.
        {gpglef1.i
            &module = ""IC""
            &entity = si_entity
            &date = eff_date1
            &prompt = "v_nbr"
            &frame = "a"
            &loop = "mainloop"} 


         
     {gprun.i ""xxicintr01.p""
                  "(input pt_part, 
                    input pt_um,
                    input lotserial_qty1, 
                    input site1,
		    input um1 ,
                    input conv1 ,
                    input eff_date1,
                    input  dr_acct1,
                    input dr_sub1 ,
                    input dr_cc1 ,
		    input dr_proj1 ,
                    input location1,
                    input lotserial1,
                    input lotref1,
                    input mulity_entry1,
                    input ordernbr1 ,
                    input orderline1 )"} 

  
       
       assign xic__log01 = yes  xic_eff_date = eff_date2.
       
    end .  /* for each xic_det */

    end . /* choice = yes */
    
    

end.   /*  mainloop: */

status input.



PROCEDURE checkConsignmentInventory:

   define input  parameter ip_ordernbr    as character no-undo.
   define input  parameter ip_orderline   as character no-undo.
   define input  parameter ip_site        like ld_site no-undo.
   define input  parameter ip_part        like ld_part no-undo.
   define input  parameter ip_location    like ld_loc  no-undo.
   define input  parameter ip_lotser      like ld_lot  no-undo.
   define input  parameter ip_ref         like ld_ref  no-undo.
   define input  parameter ip_tran_qty    as decimal   no-undo.
   define output parameter op_error      as logical   no-undo.

   define variable consigned_line        as logical   no-undo.
   define variable unconsigned_qty       as decimal   no-undo.
   define variable consigned_qty_oh      as decimal   no-undo.
   define variable location_qty          as decimal   no-undo.
   define variable procid                as character no-undo.

   /*IF A SALES ORDER WAS ENTERED, CHECK WHETHER IT IS FOR A   */
   /*CONSIGNED ITEM.                                           */

  /* if ip_ordernbr <> "" then do:
      run checkConsignedOrder
         (input ip_ordernbr,
          input ip_orderline,
          input ip_part,
          output consigned_line,
          output op_error).
      if consigned_line then
         op_error = yes.
      else
         op_error = no.
   end. */
    
    op_error = no .  /* jack */

   if not op_error then do: 
      /*IF CONSIGNED, FIND OUT HOW MUCH NON-CONSIGNED INVENTORY   */
      /*IS AT THE LOCATION. IF THERE IS NOT ENOUGH TO COVER THE   */
      /*QTY BEING ISSUED, THEN ERROR.                             */

      /*RETRIEVE THE TOTAL QTY ON-HAND FOR THE LOCATION */
      for first ld_det
          fields( ld_domain ld_qty_oh ld_cust_consign_qty)
           where ld_domain = global_domain and
                 ld_part = ip_part     and
                 ld_site = ip_site     and
                 ld_loc  = ip_location and
                 ld_lot  = ip_lotser   and
                 ld_ref  = ip_ref
      no-lock:
         assign
             location_qty  = ld_qty_oh
             consigned_qty_oh = ld_cust_consign_qty.

      end. /*for first ld_det*/

      unconsigned_qty = location_qty - consigned_qty_oh.

      if (consigned_qty_oh <> 0) and
         ((ip_tran_qty > 0 and unconsigned_qty < ip_tran_qty) or
          (ip_tran_qty < 0 and unconsigned_qty < (ip_tran_qty * -1)))
      then
        op_error = yes.

   end.

END PROCEDURE. /*checkConsignmentInventory*/
