/*Zzictrcfcrp01.p for report the transaction of the items during a period*/
/*Last modified: 02/03/2004, By: Kevin, to cancel the 'loc' criteria*/
/*Last modified: 03/26/2008, By: Philips, to add ptp_vend and ptp_buyer*/
/*Last modified: 08/16/2012, By: Henri                              */

{mfdtitle.i "20120816"}

def var effdate like tr_effdate.
def var effdate1 like tr_effdate.
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
/*Phi for label*/
DEF VAR buyer AS CHAR LABEL "�ƻ�Ա" FORMAT "x(8)".
DEF VAR vend AS CHAR FORMAT "x(8)".
DEF VAR buyer1 AS CHAR FORMAT "x(8)".
DEF VAR buyer2 AS CHAR FORMAT "x(8)".

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes
     LABEL "Suppress Zero"
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 NO-UNDO.

define temp-table tmp_site
       fields ts_site like si_site.

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

Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*Phi --modify label
 site colon 22
 effdate colon 22     effdate1 colon 49 label "��"
 line colon 22          line1 colon 49 label "��"
 type colon 22          type1 colon 49 label "��"
 group1 colon 22        group2 colon 49 label "��"
 part colon 22          part1 colon 49 label "��"
/* site colon 22          site1 colon 49 label "��" */
/* loc colon 22           loc1 colon 49 label "��" */
 keeper colon 22        keeper1 colon 49 label "��" skip(1)*/

 /*Phi*/ site colon 22 LABEL "�ص�"     site1  colon 49 label "��"
 effdate colon 22 LABEL "��Ч����"     effdate1 colon 49 label "��"
 line colon 22 LABEL "������"        line1 colon 49 label "��"
 type colon 22 LABEL "����"         type1 colon 49 label "��"
 group1 colon 22 LABEL "�����"       group2 colon 49 label "��"
 part colon 22 LABEL "��Ŀ��"         part1 colon 49 label "��"

/* site colon 22          site1 colon 49 label "��" */
/* loc colon 22           loc1 colon 49 label "��" */
 keeper colon 22        keeper1 colon 49 label  "��"
 buyer1 COLON 22 LABEL "�ƻ�Ա"       buyer2 COLON 49 LABEL  "��" SKIP(1)
 yn_zero colon 33  label "����Ϊ������"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if line1 = hi_char then line1 = "".
    if type1 = hi_char then type1 = "".
    if group2 = hi_char then group2 = "".
    if part1 = hi_char then part1 = "".

    if site1 = hi_char then site1 = "".
/*    if loc1 = hi_char then loc1 = "".*/
    if keeper1 = hi_char then keeper1 = "".
    if buyer1 = hi_char then buyer1 = "".
    buyer2 = "".
    for each tmp_site exclusive-lock: delete tmp_site. end.
    update site site1 effdate effdate1 line line1 type type1 group1 group2 part part1 /*site site1*/
           /*loc loc1*/ keeper keeper1 buyer1 buyer2 yn_zero with frame a.

    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
    if line1 = "" then line1 = hi_char.
    if type1 = "" then type1 = hi_char.
    if group2 = "" then group2 = hi_char.
    if part1 = "" then part1 = hi_char.
    if site1 = "" then site1 = hi_char.
/*    if loc1 = "" then loc1 = hi_char.*/
    if keeper1 = "" then keeper1 = hi_char.
    if buyer2 = "" then buyer2 = hi_char.
 /****
    for each si_mstr no-lock where si_domain = global_domain and si_site>= site and si_site <= site1:
           {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
           if return_int <> 0 then do:
              create tmp_site.
              assign ts_site = si_site.
           end.
     end.
     ***/
/******************************
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
  *****************************/

    {mfselbpr.i "printer" 132}

    status input "Waiting for report process...".

    disp effdate column-label "��ʼ����" format "9999/99/99"
         effdate1 column-label "��ֹ����" format "9999/99/99" with frame b stream-io.
    for
       /* each tmp_site no-lock, */
        each in_mstr fields(in_domain in_site in_gl_set in_part in_qty_oh in__qadc01 in_qty_nonet in_user1 in_gl_cost_site in_cur_set) USE-INDEX in_site 
                      where /*(in_site >= site and in_site <= site1) and*/
                           in_domain = global_domain and in_site >= site and in_site <= site1 and
                           (in_part >= part and in_part <= part1) and
                           (in__qadc01 >= keeper and in__qadc01 <= keeper1) no-lock,
        each pt_mstr fields(pt_part pt_part pt_prod_line pt_abc pt_part_type pt_group pt_desc1 pt_desc2) USE-INDEX pt_part 
                     where pt_domain = global_domain and pt_part = in_part and
                           (pt_prod_line >= line and pt_prod_line <= line1) and
                           (pt_part_type >= type and pt_part_type <= type1) and
                           (pt_group >= group1 and pt_group <= group2) NO-LOCK:

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

        for each tr_hist FIELDS (tr_domain tr_part tr_effdate tr_type tr_qty_loc tr_site tr_ship_type) USE-INDEX tr_part_eff no-lock
           where tr_domain = global_domain
                 and tr_site = in_site and tr_effdate >= effdate and tr_part = pt_part
                 and tr_ship_type = ""
                 and (tr_qty_loc <> 0 or tr_type = "cst-adj")
                 /*and (tr_loc >= loc and tr_loc <= loc1)*/:

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
/*Phi --get record*/
           FIND FIRST ptp_det  NO-LOCK
               WHERE ptp_domain = global_domain
               and ptp_part = pt_part
               AND ptp_site = site
               NO-ERROR NO-WAIT.
           IF AVAIL ptp_det THEN DO:

               FIND FIRST ptp_det  NO-LOCK
                   WHERE ptp_domain = global_domain
                   and ptp_part = pt_part
                   AND ptp_site = site
                   AND ptp_buyer >= buyer1
                   AND ptp_buyer <= buyer2
                   NO-ERROR NO-WAIT.
               IF AVAIL ptp_det THEN DO:
/*Phi --for label  */
                   buyer = ptp_buyer.
                   vend = ptp_vend.

              disp pt_part pt_desc2 pt_prod_line pt_abc in__qadc01 label "����Ա"
                 in_user1 label "ȱʡ��λ"
/*Phi -- add pt_buyer and pt_vend*/ buyer LABEL "�ƻ�Ա" vend LABEL "��Ӧ��"
               bgqty label "�ڳ����"
               rctpo label "�ɹ��ջ�" rcttr label "ת�����" rctunp label "�ƻ������"
               rctwo label "�ӹ������" isspo label "�ɹ��˻�" isstr label "ת�Ƴ���"
               issunp label "�ƻ������" issso label "���۳���"
               isswo label "�ӹ�������" invadj label "�̵����" oth label "����"
               edqty label "��ĩ���" glxcst edqty_amt label "��ĩ�����" with width 300 stream-io.
               END.
            ELSE DO:

            END.
           END. /*if avail ptp_det*/
           ELSE DO:
               IF buyer1 = "" THEN DO:
                 buyer = "".
                 vend = "".
                 disp pt_part pt_desc2 pt_prod_line pt_abc in__qadc01 label "����Ա"
                 in_user1 label "ȱʡ��λ"
/*Phi -- add pt_buyer and pt_vend*/ buyer LABEL "�ƻ�Ա" vend LABEL "��Ӧ��"
                 bgqty label "�ڳ����"
                 rctpo label "�ɹ��ջ�" rcttr label "ת�����" rctunp label "�ƻ������"
                 rctwo label "�ӹ������" isspo label "�ɹ��˻�" isstr label "ת�Ƴ���"
                 issunp label "�ƻ������" issso label "���۳���"
                 isswo label "�ӹ�������" invadj label "�̵����" oth label "����"
                 edqty label "��ĩ���" glxcst edqty_amt label "��ĩ�����" with width 300 stream-io.
               END.
           END.
        end.
    end. /*for each in_mstr,each pt_mstr*/
.

    {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

    status input.

end. /*repeat*/
