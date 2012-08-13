/* GUI CONVERTED from iclad01.p (converter v1.71) Wed Mar 29 03:04:05 2000 */
/* iclad01.p - PROGRAM TO UPDATE lad_det MULTI LINE ENTRY               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0      LAST MODIFIED: 05/29/90   BY: emb *D025* */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D744* */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: emb *D920**/
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*            */
/* Revision: 7.3        Last edit: 09/27/93             By: jcd *G247* */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*            */
/* REVISION: 7.3      LAST MODIFIED: 04/11/94   BY: ais *FM98*            */
/* REVISION: 7.3      LAST MODIFIED: 06/20/94   BY: pxd *FP02*            */
/* REVISION: 7.3      LAST MODIFIED: 11/15/94   BY: pxd *FT72*            */
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: taf *J038*            */
/* REVISION: 7.3      LAST MODIFIED: 08/24/95   BY: dzs *G0SY*            */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*            */
/* REVISION: 8.5    LAST MODIFIED: 07/01/96 BY: *G1Z1* Julie Milligan        */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/23/00   BY: *M0L8* Jyoti Thatte      */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE iclad01_p_1 " 发放零件明细: "
/* MaxLen: Comment: */

&SCOPED-DEFINE iclad01_p_2 "          待发放数量: "
/* MaxLen: Comment: */

&SCOPED-DEFINE iclad01_p_3 "参考"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define shared variable wod_recno as recid.
/*       define shared variable mfguser as char.                *G247* */
         define shared variable total_lotserial_qty like wod_qty_chg.

         define variable lad_recno as recid.
         define variable qty_entered like lad_qty_chg.
         define variable um like pt_um.

/*F190*/ define variable yn like mfc_logical.
/*M0L8*/ define variable frametitle as character no-undo.

         find wod_det no-lock where recid(wod_det) = wod_recno.
         find wo_mstr no-lock where wo_lot = wod_lot.
         find pt_mstr no-lock where pt_part = wod_part no-error.

/*F190*/ if available pt_mstr then um = pt_um.

         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


            qty_entered = 0.
            for each lad_det no-lock where lad_dataset = "wod_det"
/*G656*     and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/    and lad_nbr = wod_lot and lad_line = string(wod_op)
            and lad_part = wod_part:
               qty_entered = qty_entered + lad_qty_chg.
            end.
            {mfmsg02.i 300 1 qty_entered}

/*G656*     Changed below
*      from:
*           &other-search="and lad_dataset = ""wod_det"" and lad_nbr = wod_nbr
*                          and lad_line = wod_lot"
*           &assign="lad_part = wod_part lad_dataset = ""wod_det""
*                     lad_nbr = wod_nbr lad_line = wod_lot"
*        to:
*           &other-search="and lad_dataset = ""wod_det"" and lad_nbr = wod_lot
*                          and lad_line = string(wod_op)"
*           &assign="lad_part = wod_part lad_dataset = ""wod_det""
*                     lad_nbr = wod_lot lad_line = string(wod_op)"
**G656*/

/*M0L8*/    frametitle = {&iclad01_p_1} + wod_part + {&iclad01_p_2}
/*M0L8*/                 + string(wod_qty_chg).

/*M0L8*/    /* CHANGED THE FORMAT OF THE DISPLAY-FIELD lad_qty_chg   */
/*M0L8*/    /* TO ->>>>>>9.9<<<<<< AND CHANGED TO FRAMETITLE FROM    */
/*M0L8*/    /* {&iclad01_p_1} + wod_part + {&iclad01_p_2}..          */

/*FM98*/    /*CHANGED SCROLL-FIELD FROM lad_loc TO lad_site        */
/*FP02      added global_ref and s3 to s4 */
            {swindowb.i
            &file=lad_det
            &framename="c"
            &frame-attr="overlay col 1 row 10
               title color normal frametitle"
            &record-id=lad_recno
            &search=lad_part
            &equality=wod_part
            &other-search="and lad_dataset = ""wod_det"" and lad_nbr = wod_lot
                           and lad_line = string(wod_op)"
            &scroll-field=lad_site
            &create-rec=yes
            &assign="lad_part = wod_part lad_dataset = ""wod_det""
                      lad_nbr = wod_lot lad_line = string(wod_op)"
            &prompt-for2=lad_loc
            &prompt-for3=lad_lot
            &prompt-for1=lad_site
            &prompt-for4=lad_ref
            &s4="/*"
            &update-leave=yes
            &display2=lad_loc
            &display3=lad_lot
            &display1=lad_site
            &display5=lad_qty_all
            &display6=lad_qty_pick
            &display7="lad_qty_chg format ""->>>>>>9.9<<<<<<"" "
            &display4="lad_ref format ""x(8)"" column-label "{&iclad01_p_3}" "
            &update1=lad_qty_chg
            &global_exp1="global_site = input lad_site"
            &global_exp2="global_loc = input lad_loc"
            &global_exp3="global_lot = input lad_lot"
            &global_exp4="global_ref = input lad_ref"
            }
/*FT72*/    pause 0.
            if keyfunction(lastkey) = "end-error" then leave.

/*G1Z1* /*G0SY*/    if lad_qty_chg <> 0 then do: */
/*G1Z1*/    if (available lad_det and lad_qty_chg <> 0) then do:

/*J038*************** REPLACE ICEDIT.I WITH ICEDIT.P ************************/
/*J038*     {icedit.i                                                       */
/*J038*     &transtype=""ISS-WO""                                           */
/*J038*     &site=lad_site                                                  */
/*J038*     &location=lad_loc                                               */
/*J038*     &part=wod_part                                                  */
/*J038*     &lotserial=lad_lot                                              */
/*J038*     &lotref=lad_ref                                                 */
/*J038*     &quantity=lad_qty_chg                                           */
/*J038*     &um="(if available pt_mstr then pt_um else um) "                */
/*J038*     }                                                               */
/*J038************************ END OF ICEDIT.I BLOCK ************************/

/*J038**************** CALL ICEDIT.P ****************************************/
/*J038*/    {gprun.i ""icedit.p"" "(""ISS-WO"",
                                    lad_site,
                                    lad_loc,
                                    wod_part,
                                    lad_lot,
                                    lad_ref,
                                    lad_qty_chg,
                                    (if available pt_mstr then pt_um else um),
                                    """",
                                    """",
                                    output yn)"
            }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/    if yn then undo, retry.

/*F190*/    if lad_site <> wo_site then do:

/*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
/*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
/*F0TC*/ /*************************** Delete: Begin ***********************
/*J038* ADDED BLANKS FOR INPUTS TRNBR AND TRLINE IN CALL TO ICEDIT3.P      */
/*F190*/       {gprun.i ""icedit3.p"" "(input ""ISS-WO"",
 *                                      input wo_site,
 *                                      input lad_loc,
 *                                      input wod_part,
 *                                      input lad_lot,
 *                                      input lad_ref,
 *                                      input lad_qty_chg,
 *                                      input um,
 *                                        input """",
 *                                        input """",
 *                                      output yn)"
 *             }
/*F190*/       if yn then undo, retry.
 *
/*F190*/       {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
 *                                      input lad_site,
 *                                      input lad_loc,
 *                                      input wod_part,
 *                                      input lad_lot,
 *                                      input lad_ref,
 *                                      input lad_qty_chg,
 *                                      input um,
 *                                        input """",
 *                                        input """",
 *                                      output yn)"
 *             }
/*F190*/       if yn then undo, retry.
 *
/*J038* ADDED INPUTS WO_NBR AND WO_LOT TO CALL TO ICEDIT3.P               */
/*F190*/       {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
 *                                      input wo_site,
 *                                      input lad_loc,
 *                                      input wod_part,
 *                                      input lad_lot,
 *                                      input lad_ref,
 *                                      input lad_qty_chg,
 *                                      input um,
 *                                        input wo_nbr,
 *                                        input wo_lot,
 *                                      output yn)"
 *             }
/*F0TC*/ **************************** Delete: End *************************/
/*J038* ADDED INPUTS WO_NBR AND WO_LOT TO CALL TO ICEDIT4.P               */
/*F0TC*/      {gprun.i ""icedit4.p"" "(input ""ISS-WO"",
                                       input wo_site,
                                       input lad_site,
                                       input pt_loc,
                                       input lad_loc,
                                       input wod_part,
                                       input lad_lot,
                                       input lad_ref,
                                       input lad_qty_chg,
                                       input um,
                                       input wo_nbr,
                                       input wo_lot,
                                       output yn)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F190*/       if yn then undo, retry.
/*F190*/    end.
/*G0SY*/    end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         total_lotserial_qty = qty_entered.
