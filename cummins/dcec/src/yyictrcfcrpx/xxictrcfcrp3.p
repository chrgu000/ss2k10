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
def var keeper as char label "����Ա".
def var keeper1 as char.

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes
     LABEL "Suppress Zero"
/*JJ     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 */ NO-UNDO.

def var edqty like tr_qty_loc.
def var bgqty like tr_qty_loc.
def var inqty like tr_qty_loc.
def var outqty like tr_qty_loc.
def var tot_edqty like tr_qty_loc.
def var tot_bgqty like tr_qty_loc.
def var tot_inqty like tr_qty_loc.
def var tot_outqty like tr_qty_loc.

def var rctpo like tr_qty_loc.
def var rcttr like tr_qty_loc.
def var rctunp like tr_qty_loc.
def var rctwo like tr_qty_loc.
def var isspo like tr_qty_loc.
def var isstr like tr_qty_loc.
def var issunp like tr_qty_loc.
def var issso like tr_qty_loc.
def var isswo like tr_qty_loc.
def var invadj like tr_qty_loc.
def var oth like tr_qty_loc.

def var cst like tr_qty_loc.
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
 effdate colon 22       effdate1 colon 49 label {t001.i}
 line colon 22          line1 colon 49 label {t001.i}
 type colon 22          type1 colon 49 label {t001.i}
 group1 colon 22        group2 colon 49 label {t001.i}
 part colon 22          part1 colon 49 label {t001.i}
/* site colon 22          site1 colon 49 label {t001.i} */
 loc colon 22           loc1 colon 49 label {t001.i}
 keeper colon 22        keeper1 colon 49 label {t001.i} skip(1)
 yn_zero colon 33  label "����Ϊ������"
 lscrap colon 33   label "�������Ͽ�λ"
 lconsign colon 33 label "��������"
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

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if line1 = hi_char then line1 = "".
    if type1 = hi_char then type1 = "".
    if group2 = hi_char then group2 = "".
    if part1 = hi_char then part1 = "".
/*    if site1 = hi_char then site1 = "".*/
    if loc1 = hi_char then loc1 = "".
    if keeper1 = hi_char then keeper1 = "".

    update site effdate effdate1 line line1 type type1 group1 group2 part part1 /*site site1*/
           loc loc1 keeper keeper1 yn_zero lscrap lconsign with frame a.

    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
    if line1 = "" then line1 = hi_char.
    if type1 = "" then type1 = hi_char.
    if group2 = "" then group2 = hi_char.
    if part1 = "" then part1 = hi_char.
/*    if site1 = "" then site1 = hi_char.*/
    if loc1 = "" then loc1 = hi_char.
    if keeper1 = "" then keeper1 = hi_char.

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


    curr_tot = 0.
    old_tot = 0.

    {mfselbpr.i "printer" 132 nopage}

    status input "Waiting for report process...".

    disp effdate column-label "��ʼ����" format "9999/99/99"
         effdate1 column-label "��ֹ����" format "9999/99/99" with frame b stream-io.

    for each in_mstr where /*(in_site >= site and in_site <= site1) and*/ in_domain = global_domain and
                       in_site = site and
                           (in_part >= part and in_part <= part1) and
                           (in__qadc01 >= keeper and in__qadc01 <= keeper1) no-lock,
        each pt_mstr where pt_domain = global_domain and pt_part = in_part and
                           (pt_prod_line >= line and pt_prod_line <= line1) and
                           (pt_part_type >= type and pt_part_type <= type1) and
                           (pt_group >= group1 and pt_group <= group2) no-lock:

        edqty = 0.
        bgqty = 0.
        inqty = 0.
        outqty =0.
       rctpo = 0.
       rcttr = 0.
       rctunp = 0.
       rctwo = 0.
       isspo = 0.
       isstr = 0.
       issunp = 0.
       issso = 0.
       isswo = 0.
       invadj = 0.
       oth = 0.

        edqty = in_qty_oh + in_qty_nonet.

        for each ld_det no-lock where ld_domain = global_domain and
                ld_part = pt_part and
                ld_site = in_site and
                (ld_loc < loc or ld_loc > loc1 ):
                edqty = edqty - ld_qty_oh.
        end.

        if lconsign = no then do:
                for each ld_det no-lock where ld_domain = global_domain and
                        ld_part = pt_part and
                        ld_site = in_site and
                        ld_loc begins "CN" and
                        ld_loc >= loc and ld_loc <= loc1:
                        edqty = edqty - ld_qty_oh.
                end.
        end.

        if lscrap = no then do:
                for each ld_det no-lock where ld_domain = global_domain and
                        ld_part = pt_part and
                        ld_site = in_site and
                        ld_loc >= loc and ld_loc <= loc1 and
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
                 and (tr_loc >= loc and tr_loc <= loc1) :

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
             if tr_type = "rct-po" then rctpo = rctpo + tr_qty_loc.
             else if tr_type = "rct-tr" then rcttr = rcttr + tr_qty_loc.
             else if tr_type = "rct-unp" then rctunp = rctunp + tr_qty_loc.
             else if tr_type = "rct-wo" then rctwo = rctwo + tr_qty_loc.
             else if tr_type = "iss-prv" then isspo = isspo - tr_qty_loc.
             else if tr_type = "iss-tr" then isstr = isstr - tr_qty_loc.
             else if tr_type = "iss-unp" then issunp = issunp - tr_qty_loc.
             else if tr_type = "iss-so" then issso = issso - tr_qty_loc.
             else if tr_type = "iss-wo" then isswo = isswo - tr_qty_loc.
             else if (tr_type = "tag-cnt" or tr_type = "cyc-cnt" or tr_type = "cyc-rcnt")
                  then invadj = invadj + tr_qty_loc.
             else oth = oth + tr_qty_loc.
          end.

            if tr_effdate <= effdate1 then do:
                if tr_type begins "Iss" then
                    outqty = outqty - tr_qty_loc.
                if tr_type begins "rct" then
                    inqty = inqty + tr_qty_loc.
            end. /* if tr_effdate */
            else if tr_qty_loc <> 0 then
                edqty = edqty - tr_qty_loc.
        end. /* for each tr_hist */

        /*bgqty = max(0, edqty - inqty + outqty ).*/
       bgqty = edqty - inqty + outqty.

        if (yn_zero and (edqty <> 0 or bgqty <> 0 or rctpo <> 0 or rcttr <> 0 or rctunp <> 0 or rctwo <> 0
          or isspo <> 0 or isstr <> 0 or issunp <> 0 or issso <> 0
          or isswo <> 0 or invadj <> 0 or oth <> 0))
           or not yn_zero then do:

           {gpsct03.i &cost=sct_cst_tot}

           edqty_amt = edqty * glxcst.
 
            find first ptp_det no-lock where ptp_domain = global_domain
                   and ptp_part = pt_part and ptp_site = in_site no-error. 
           disp pt_part pt_desc2 pt_prod_line pt_abc in__qadc01 label "����Ա"
              in_user1 label "ȱʡ��λ" 
              ptp_buyer label "�ɹ�Ա" when available ptp_det
              ptp_vend label "��Ӧ��" when available ptp_det
              ptp_run_seq2 label "E&O" when available ptp_det
              bgqty label "�ڳ����"
              rctpo label "�ɹ��ջ�" rcttr label "ת�����" rctunp label "�ƻ������"
              rctwo label "�ӹ������" isspo label "�ɹ��˻�" isstr label "ת�Ƴ���"
              issunp label "�ƻ������" issso label "���۳���"
              isswo label "�ӹ�������" invadj label "�̵����" oth label "����"
              edqty label "��ĩ���" /* glxcst format "->>,>>>,>>9.99<<<<" edqty_amt label "��ĩ�����" */ with width 300 stream-io.

           curr_tot = curr_tot + edqty.
           old_tot = old_tot + bgqty.

        end.

    end. /*for each in_mstr,each pt_mstr*/

    disp old_tot label "�ڳ����������" curr_tot label "��ĩ���������" with side-label.
.

  {mfrtrail.i}

/*    {mfreset.i} */
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

    status input.

end. /*repeat*/

