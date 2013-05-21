/*Zzictrcfcrp01.p for report the transaction of the items during a period*/
/*Last modified: 02/03/2004, By: Kevin, to cancel the 'loc' criteria*/


/* DISPLAY TITLE */
{mfdtitle.i "e+ "}

def var effdate like tr_effdate.
def var effdate1 like tr_effdate.
def var loc like loc_loc.
def var loc1 like loc_loc.
def var line like pt_prod_line.
def var line1 like pt_prod_line.
def var type like pt_part_type.
def var type1 like pt_part_type.
def var group1 like pt_group.
def var group2 like pt_group.
def var part like pt_part.
def var part1 like pt_part.
def var site like si_site.
def var site1 like si_site.
def var keeper as char label "保管员".
def var keeper1 as char.

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes
     LABEL "Suppress Zero"
/*JJ     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 */ NO-UNDO.

def var edqty like tr_qty_loc.
def var bgqty like tr_qty_loc.
def var inqty like tr_qty_loc.
def var inamt like tr_qty_loc.
def var outqty like tr_qty_loc.
def var outamt like tr_qty_loc.
def var tot_edqty like tr_qty_loc.
def var tot_bgqty like tr_qty_loc.
def var tot_inqty like tr_qty_loc.
def var tot_outqty like tr_qty_loc.

def var rctpo like tr_qty_loc no-undo.
def var rctpo_amt like rctpo no-undo.
def var rcttr like tr_qty_loc no-undo.
def var rcttr_amt like rcttr no-undo.
def var rctunp like tr_qty_loc no-undo.
def var rctunp_amt like rctunp no-undo.
def var rctwo like tr_qty_loc no-undo.
def var rctwo_amt like rctwo no-undo.
def var isspo like tr_qty_loc no-undo.
def var isspo_amt like isspo no-undo.
def var isstr like tr_qty_loc no-undo.
def var isstr_amt like isstr no-undo.
def var issunp like tr_qty_loc no-undo.
def var issunp_amt like issunp no-undo.
def var issso like tr_qty_loc no-undo.
def var issso_amt like issso no-undo.
def var isswo like tr_qty_loc no-undo.
def var isswo_amt like isswo no-undo.
def var invadj like tr_qty_loc no-undo.
def var invadj_amt like invadj no-undo.
def var cstadj_amt like tr_qty_loc no-undo.
def var oth like tr_qty_loc no-undo.
def var oth_amt like oth no-undo.

def var cst like tr_qty_loc.
def var bgqty_amt like tr_qty_loc.
def var edqty_amt like tr_qty_loc.

def var msg-nbr as inte.

DEF VAR I AS INTE.
DEF VAR LINECOUNT AS INTE.

def var lscrap as log initial yes no-undo.
def var lconsign as log initial yes no-undo.
def var curr_tot as decimal format "->>>,>>>,>>9.99<<<<" no-undo.
def var old_tot like curr_tot no-undo.

def var using_cust_consignment as log no-undo.

define variable ENABLE_CUSTOMER_CONSIGNMENT as character no-undo
   initial "enable_customer_consignment".
define variable CUST_CONSIGN_CTRL_TABLE as character no-undo
   initial "cnc_ctrl".
{pocnvars.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

Form
/*GM65*/
/*JJ
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
*/
 site colon 22
 site1 colon 49 label {t001.i}
 effdate colon 22       effdate1 colon 49 label {t001.i}
 line colon 22          line1 colon 49 label {t001.i}
 type colon 22          type1 colon 49 label {t001.i}
 group1 colon 22        group2 colon 49 label {t001.i}
 part colon 22          part1 colon 49 label {t001.i}
/* site colon 22          site1 colon 49 label {t001.i}  */
 loc colon 22           loc1 colon 49 label {t001.i}
 keeper colon 22        keeper1 colon 49 label {t001.i} skip(1)
 yn_zero colon 33  label "抑制为零数据"
 lscrap colon 33   label "包括工废库位"
 lconsign colon 33 label "包括寄售"
/*JJ
 SKIP(.4)  /*GUI*/
*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

/*JJ
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
*/

setFrameLabels(frame a:handle).

repeat:

    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if line1 = hi_char then line1 = "".
    if type1 = hi_char then type1 = "".
    if group2 = hi_char then group2 = "".
    if part1 = hi_char then part1 = "".
    if site1 = hi_char then site1 = "".
    if loc1 = hi_char then loc1 = "".
    if keeper1 = hi_char then keeper1 = "".

    update site site1 effdate effdate1 line line1 type type1 group1 group2 part part1 /*site site1*/
           loc loc1 keeper keeper1 yn_zero lscrap lconsign with frame a.

    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
    if line1 = "" then line1 = hi_char.
    if type1 = "" then type1 = hi_char.
    if group2 = "" then group2 = hi_char.
    if part1 = "" then part1 = hi_char.
    if site1 = "" then site1 = hi_char.
    if loc1 = "" then loc1 = hi_char.
    if keeper1 = "" then keeper1 = hi_char.

/*
                 find si_mstr no-lock where si_domain = global_domain and si_site = site no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     {mfmsg.i msg-nbr 3}
                     undo, retry.
                 end.

                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*JJ
/*GUI*/ if global-beam-me-up then undo, leave.
*/

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.

*/


    curr_tot = 0.
    old_tot = 0.

    {mfselbpr.i "printer" 132 nopage}

    status input "Waiting for report process...".

    disp effdate column-label "起始日期" format "9999/99/99"
         effdate1 column-label "截止日期" format "9999/99/99" with frame b stream-io.

put skip(1) "地点" format "x(9)" "零件号码" format "x(19)" "描述" format "x(25)" "产线" format 'x(6)' "A" format "x(2)" "保管员" format 'x(9)'
    "缺省库位" format "x(9)" "期初库存" format "x(13)" "成本" format "x(16)" "期初库存金额" format "x(13)" "采购收货" format "x(13)"
    "采购收货金额" format "x(13)" "转移入库" format "x(13)" "转移入库金额" format "x(13)" "计划外入库" format "x(13)"
    "计划外入库金额" format "x(13)" "加工单入库" format "x(13)" "加工单入库金额" format "x(13)" "采购退货" format "x(13)"
    "采购退货金额" format "x(13)" "转移出库" format "x(13)" "转移出库金额" format "x(13)" "计划外出库" format "x(13)"
    "计划外出库金额" format "x(13)" "销售出库" format "x(13)" "销售出库金额" format "x(13)" "加工单出库" format "x(13)"
    "加工单出库金额" format "x(13)" "盘点调整" format "x(13)" "盘点金额" format "x(13)" "其他" format "x(13)"
    "其他金额"  format "x(13)" "成本调整" format "x(13)" "期末库存" format "x(13)" "成本" format "x(16)" "期末库存金额" skip.

put unformatted
    "-------- ------------------ ------------------------ ----- - -------- -------- ------------ --------------- ------------ ------------ ------------ ------------ ------------ ".
put unformatted
    "------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ ".
put unformatted "------------ ------------ ------------ ------------ ------------ ".

put unformatted
    "------------ ------------ ------------ ------------ ------------ ------------ ------------ --------------- -------------" skip.

    for each in_mstr where in_domain = global_domain and (in_site >= site and in_site <= site1) and
                           /* in_site = site and  */
                           (in_part >= part and in_part <= part1) and
                           (in__qadc01 >= keeper and in__qadc01 <= keeper1) no-lock,
        each pt_mstr where pt_domain = global_domain and pt_part = in_part and
                           (pt_prod_line >= line and pt_prod_line <= line1) and
                           (pt_part_type >= type and pt_part_type <= type1) and
                           (pt_group >= group1 and pt_group <= group2) no-lock:

        edqty = 0.
        bgqty = 0.
        inqty = 0.
  inamt = 0.
        outqty =0.
  outamt =0.
       rctpo = 0.  rctpo_amt = 0.
       rcttr = 0.  rcttr_amt = 0.
       rctunp = 0. rctunp_amt = 0.
       rctwo = 0.  rctwo_amt = 0.
       isspo = 0.  isspo_amt = 0.
       isstr = 0.  isstr_amt = 0.
       issunp = 0. issunp_amt = 0.
       issso = 0.  issso_amt = 0.
       isswo = 0.  isswo_amt = 0.
       invadj = 0. invadj_amt = 0.
       oth = 0.    oth_amt = 0.
       cstadj_amt = 0.

        edqty = in_qty_oh + in_qty_nonet.
  for each ld_det no-lock where ld_domain = global_domain and
    ld_part = pt_part and
    ld_site = in_site and
    (ld_loc < loc or ld_loc > loc1):
    edqty = edqty - ld_qty_oh.
  end.

  if lconsign = no then do:
    for each ld_det no-lock where ld_domain = global_domain and
      ld_part = pt_part and
      ld_site = in_site and
      (ld_loc >= loc and ld_loc <= loc1) and
      ld_loc begins "CN" :
      edqty = edqty - ld_qty_oh.
    end.
  end.

  if lscrap = no then do:
    for each ld_det no-lock where ld_domain = global_domain and
      ld_part = pt_part and
      ld_site = in_site and
      (ld_loc >= loc and ld_loc <= loc1) and
      /* ld_loc begins "ZZZ" */
      can-find(first pld_det where pld_domain = global_domain and
        pld_prodline = pt_prod_line and
        pld_site = in_site and
        pld_loc = ld_loc):
      edqty = edqty - ld_qty_oh.
    end.
  end.

        for each tr_hist no-lock where tr_domain = global_domain and tr_part = pt_part
                 and tr_site = in_site and tr_effdate >= effdate
                 and tr_ship_type = ""
                 and (tr_qty_loc <> 0 or tr_type = "cst-adj")
                 and (tr_loc >= loc and tr_loc <= loc1):

    if lconsign = no and tr_loc begins "CN" then do:
    next.
    end.

    if lscrap = no then do:
/*
    if can-find(first  pld_det where pld_domain = global_domain and
      pld_prodline = pt_prod_line and
      pld_site = in_site and
      pld_loc = tr_loc) then next.
*/
    if tr_loc begins "ZZZ" then next.
    end.

          if tr_effdate >= effdate and tr_effdate <= effdate1 then do:
             if tr_type = "rct-po" then do:
      rctpo = rctpo + tr_qty_loc.
      rctpo_amt = rctpo_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "rct-tr" then do:
      rcttr = rcttr + tr_qty_loc.
      rcttr_amt = rcttr_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "rct-unp" then do:
      rctunp = rctunp + tr_qty_loc.
      rctunp_amt = rctunp_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "rct-wo" then do:
      rctwo = rctwo + tr_qty_loc.
      rctwo_amt = rctwo_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "iss-prv" then do:
      isspo = isspo - tr_qty_loc.
      isspo_amt = isspo_amt - tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "iss-tr" then do:
      isstr = isstr - tr_qty_loc.
      isstr_amt = isstr_amt - tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "iss-unp" then do:
      issunp = issunp - tr_qty_loc.
      issunp_amt = issunp_amt - tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "iss-so" then do:
      issso = issso - tr_qty_loc.
      issso_amt = issso_amt - tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if tr_type = "iss-wo" then do:
      isswo = isswo - tr_qty_loc.
      isswo_amt = isswo_amt - tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
             else if (tr_type = "tag-cnt" or tr_type = "cyc-cnt" or tr_type = "cyc-rcnt") then do:
      invadj = invadj + tr_qty_loc.
      invadj_amt = invadj_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
       else if (tr_type = "CST-ADJ") then do:
/*
      find first trgl_ where trgl_domain = tr_domain and trgl_trnbr = tr_trnbr no-lock no-error.
      if avail trgl_ then
*/
      cstadj_amt = cstadj_amt + /* (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std) - tr_price */
          /* trgl_gl_amt */ tr_price * tr_loc_begin.
       end.
             else do:
    oth = oth + tr_qty_loc.
      oth_amt = oth_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
       end.
          end.

            if tr_effdate <= effdate1 then do:
                if tr_type begins "Iss" then  do:
                    outqty = outqty - tr_qty_loc.
        outamt = outamt - tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
    end.
                if tr_type begins "rct" then do:
                    inqty = inqty + tr_qty_loc.
        inamt = inamt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
    end.
            end. /* if tr_effdate */
            else if tr_qty_loc <> 0 then
                edqty = edqty - tr_qty_loc.
        end. /* for each tr_hist */

        /*bgqty = max(0, edqty - inqty + outqty ).*/
       bgqty = edqty - inqty + outqty.

        if (yn_zero and (edqty <> 0 or bgqty <> 0 or
    rctpo <> 0 or rctpo_amt <> 0 or
    rcttr <> 0 or rcttr_amt <> 0 or
    rctunp <> 0 or rctunp_amt <> 0 or
    rctwo <> 0 or rctwo_amt <> 0 or
    isspo <> 0 or isspo_amt <> 0 or
    isstr <> 0 or isstr_amt <> 0 or
    issunp <> 0 or issunp_amt <> 0 or
    issso <> 0 or issso_amt <> 0 or
    isswo <> 0 or isswo_amt <> 0 or
    invadj <> 0 or invadj_amt <> 0 or
    oth <> 0 or oth_amt <> 0 or
    cstadj_amt <> 0))
           or not yn_zero then do:


     define variable as_of_date as date no-undo.
     define variable cst_date as date no-undo.
     define variable trrecno as recid no-undo.
     define variable std_as_of_to like sct_cst_tot format "->>>,>>>,>>9.99<<<" no-undo.
           define variable std_as_of_from like std_as_of_to  format "->>>,>>>,>>9.99<<<" no-undo.
     define variable zero_cost as log no-undo. zero_cost = yes.

     as_of_date = effdate1.
     for first tr_hist
        fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
                tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                tr_price tr_status tr_sub_std tr_trnbr tr_type)
        where tr_domain  = global_domain
        and   tr_part    =  in_part
        and   tr_effdate >= as_of_date + 1
        and   tr_site    =  in_site
        and   tr_type    =  "CST-ADJ"
     no-lock use-index tr_part_eff:
     end. /* FOR FIRST TR_HIST */

     if available tr_hist then do:
       cst_date = tr_effdate.

       for each tr_hist
          fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
            tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
            tr_price tr_status tr_sub_std tr_trnbr tr_type)
          where tr_domain = global_domain
          and   tr_part    = in_part
          and   tr_effdate = cst_date
          and   tr_site    = in_site
          and   tr_type    = "CST-ADJ"
          use-index tr_part_eff
          by tr_trnbr:

          trrecno = recid(tr_hist).
          leave.
       end. /* FOR EACH TR_HIST */

       for first tr_hist
          fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
            tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
            tr_price tr_status tr_sub_std tr_trnbr tr_type)
          where recid(tr_hist) = trrecno no-lock:
       end. /* FOR FIRST TR_HIST */

       std_as_of_to = (tr_mtl_std + tr_lbr_std + tr_ovh_std
        + tr_bdn_std + tr_sub_std).

       if tr_price <> std_as_of_to or zero_cost then
          std_as_of_to = std_as_of_to - tr_price.

     end.
     else do:
       {gpsct03.i &cost=sct_cst_tot}
       std_as_of_to = glxcst.
     end.

     as_of_date = effdate - 1.
     for first tr_hist
        fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
                tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                tr_price tr_status tr_sub_std tr_trnbr tr_type)
        where tr_domain  = global_domain
        and   tr_part    =  in_part
        and   tr_effdate >= as_of_date + 1
        and   tr_site    =  in_site
        and   tr_type    =  "CST-ADJ"
     no-lock use-index tr_part_eff:
     end. /* FOR FIRST TR_HIST */

     if available tr_hist then do:
       cst_date = tr_effdate.

       for each tr_hist
          fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
            tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
            tr_price tr_status tr_sub_std tr_trnbr tr_type)
          where tr_domain = global_domain
          and   tr_part    = in_part
          and   tr_effdate = cst_date
          and   tr_site    = in_site
          and   tr_type    = "CST-ADJ"
          use-index tr_part_eff
          by tr_trnbr:

          trrecno = recid(tr_hist).
          leave.
       end. /* FOR EACH TR_HIST */

       for first tr_hist
          fields (tr_domain tr_part tr_effdate tr_site tr_loc tr_ship_type
            tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
            tr_price tr_status tr_sub_std tr_trnbr tr_type)
          where recid(tr_hist) = trrecno no-lock:
       end. /* FOR FIRST TR_HIST */

       std_as_of_from = (tr_mtl_std + tr_lbr_std + tr_ovh_std
        + tr_bdn_std + tr_sub_std).

       if tr_price <> std_as_of_from or zero_cost then
          std_as_of_from = std_as_of_from - tr_price.

     end.
     else do:
       {gpsct03.i &cost=sct_cst_tot}
       std_as_of_from = glxcst.
     end.

/*
     {ppptrp6a.i}
           {gpsct03.i &cost=sct_cst_tot}
*/

           edqty_amt = edqty * std_as_of_to.
           bgqty_amt = bgqty * std_as_of_from.

/*
           disp pt_part pt_desc2 pt_prod_line pt_abc in__qadc01 label "保管员"
              in_user1 label "缺省库位" bgqty label "期初库存" std_as_of_from format "->>,>>>,>>9.99<<<<" label "成本"
        bgqty_amt label "期初库存金额"
              rctpo label "采购收货"
        rctpo_amt label "采购收货金额"
        rcttr label "转移入库"
        rcttr_amt label "转移入库金额"
        rctunp label "计划外入库"
        rctunp_amt label "计划外入库金额"
              rctwo label "加工单入库"
        rctwo_amt label "加工单入库金额"
        isspo label "采购退货"
        isspo_amt label "采购退货金额"
        isstr label "转移出库"
        isstr_amt label "转移出库金额"
              issunp label "计划外出库"
        issunp_amt label "计划外出库金额"
        issso label "销售出库"
        issso_amt label "销售出库金额"
              isswo label "加工单出库"
        isswo_amt label "加工单出库金额"
        invadj label "盘点调整"
        invadj_amt label "盘点金额"
        oth label "其他"
        oth_amt label "其他金额"
        cstadj_amt label "成本调整"
              edqty label "期末库存" std_as_of_to format "->>,>>>,>>9.99<<<<" label "成本" edqty_amt label "期末库存金额"
        with width 600 stream-io.
*/


put in_site " " pt_part " " pt_desc2 " " pt_prod_line "  " pt_abc " " in__qadc01 " " in_user1 " " bgqty " " std_as_of_from " " bgqty_amt  " "
  rctpo " " rctpo_amt " "
  rcttr " " rcttr_amt " " rctunp " " rctunp_amt " "  rctwo  " " rctwo_amt " "
  isspo " " isspo_amt " " isstr " " isstr_amt " " issunp " " issunp_amt " "
  issso " " issso_amt " " isswo " " isswo_amt " " invadj " " invadj_amt " " oth " " oth_amt " "
  cstadj_amt " " edqty " " std_as_of_to " " edqty_amt skip.

     curr_tot = curr_tot + edqty_amt.
     old_tot = old_tot + bgqty_amt.

        end.

    end. /*for each in_mstr,each pt_mstr*/

    disp old_tot label "期初库存总金额" curr_tot label "期末库存总金额" with side-label.
.

/*    {mfreset.i} */

    {mfrtrail.i}

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

    status input.

end. /*repeat*/

