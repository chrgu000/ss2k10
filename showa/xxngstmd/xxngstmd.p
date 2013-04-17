/* xxngstmd.p - 将NG库位非N-N-N状态的物料改为N-N-N状态                  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.3 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/12/86   BY: EMB */
/* REVISION: 4.0      LAST MODIFIED: 07/18/88   BY: flm *A330* */
/* REVISION: 5.0      LAST MODIFIED: 09/26/89   BY: MLB *B316* */
/* REVISION: 5.0      LAST MODIFIED: 09/19/94   BY: ljm *FR42* */
/* REVISION: 7.3      LAST MODIFIED: 02/13/96   BY: qzl *G1N2* */
/* REVISION: 7.3      LAST MODIFIED: 05/14/97   BY: *G2N1* Cynthia Terry */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.3 $   BY: Katie Hilbert         DATE: 01/31/03  ECO: *P0MJ*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* DISPLAY TITLE */
{mfdtitle.i "3"}

define variable fname as character format "x(40)"
                        label " Backup file".
define variable cimfile as character.
define variable yn like mfc_logical.
define variable offset  as integer.
define stream b1.
define stream b2.
define buffer lddet for ld_det.
{gpcdget.i "UT"}
form
   space(1)
   fname
with frame a width 80 attr-space side-labels no-underline.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*V8-*/

repeat:

   update fname with frame a.
   output to value(fname).
       for each ld_det no-lock where ld_site = "GSA01" and ld_loc = "NG"
         and ld_status <> "N-N-N" with frame b width 320:
         setFrameLabels(frame b:handle).
          display ld_site ld_loc ld_part ld_lot ld_ref ld_qty_oh ld_status.
     end.
   output close.
   {mfmsg01.i 12 2 yn to update}
   if not yn then do:
      undo,retry.
   end.
      offset = 1.
     for each lddet no-lock where lddet.ld_site = "GSA01" and lddet.ld_loc = "NG"
          and lddet.ld_status <> "N-N-N":
        assign cimfile = execname + "." + string(offset,"9999999999").
        output stream b1 to value(cimfile + ".bpi").
        put stream b1 unformat '"' lddet.ld_site '" "' lddet.ld_loc '" "' lddet.ld_part '" "'  lddet.ld_lot '" "' lddet.ld_ref '"' skip.
        put stream b1 unformat '- - - "N-N-N"' skip. 
        output stream b1 close.

           batchrun = yes.
       input from value(cimfile + ".bpi").
       output to value(cimfile +  ".bpo") keep-messages.
       hide message no-pause.
       cimrunprogramloop:
       do transaction on stop undo cimrunprogramloop,leave cimrunprogramloop:
        {gprun.i ""icldmt.p""} 
       end.
       hide message no-pause.
       output close.
       input close.
       batchrun = no.
        offset = offset + 1.
       os-delete value(cimfile + ".bpi"). 
       os-delete value(cimfile + ".bpo"). 
    end.
   

    for each ld_det no-lock where ld_site = "GSA01" and ld_loc = "NG"
         and ld_status <> "N-N-N" with frame c:
         setFrameLabels(frame c:handle).
          display ld_site ld_loc ld_part ld_lot ld_ref ld_qty_oh ld_status.
     end.
end.
 