/* mfglobe.i - Spinning globe and boilerplate                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                          */
/******************************** Tokens **************************************/
/*V8:ConvertMode=NoConvert                                                    */
/******************************** History *************************************/
/* Revision: 8.3     Last Modified: 03/17/94     By: aed                      */
/* Revision: 8.3     Last Modified: 03/24/95     By: aed                      */
/* Revision: 8.3     Last Modified: 10/16/95     By: jzs      /*J08V*/        */
/* Revision: 8.5     Last Modified: 01/25/96     By: jpm      /*J0CF*/        */
/* Revision: 8.3     Last Modified: 04/03/96     By: jpm      /*G1MP*/        */
/* Revision: 8.5     Last Modified: 07/26/96     By: aed      /*J12D*/        */
/* Revision: 8.6     Last Modified: 03/12/97    BY: *K081* Jean Miller        */
/* Revision: 8.6     Last Modified: 03/20/97    BY: *G2L8* Cynthia Terry      */
/* Revision: 8.6     Last Modified: 09/05/97    By: *J20D* Jean Miller        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 04/08/99    BY: *M0C0* Tom Toboco         */
/* REVISION: 9.1     LAST MODIFIED: 11/24/99    BY: *M0G0* Jean Miller        */
/* REVISION: 9.1     LAST MODIFIED: 12/28/99    BY: *M0H7* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 03/22/00    BY: *N08T* Dennis Taylor      */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 10/24/00    BY: *N0T3* Jean Miller        */
/* Revision: 1.17      BY: Jean Miller        DATE: 07/30/01  ECO: *N10T*     */
/* $Revision: 1.18 $   BY: Jean Miller        DATE: 08/12/02  ECO: *P08G*     */
/*  $Revision: 101122.1 $ BY: zhangyun      DATE: 11/22/10        ECO: *YM*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Local Variable Definitions */
&SCOPED-DEFINE STOP-GLOBE 75
&SCOPED-DEFINE LAST-GLOBE 75

define variable get-globe    as character            no-undo.
define variable rect-image   as widget-handle        no-undo.
define variable spin_ok      as character initial "" no-undo.
define variable mfgpro_world as widget               no-undo.

/* Definitions of the Frame */
define frame {&frm}.

create rectangle rect-image
assign
   frame           = frame {&frm}:handle
   edge-pixels     = 6
   graphic-edge    = yes
   width-pixels    = 294
   height-pixels   = 164
   bgcolor         = 15
   fgcolor         = 15
   row             = {&vBias}
   x               = (frame {&frm}:width-pixels - rect-image:width-pixels) / 2.

/* Add the globe. */
run draw-globe
   (input frame {&frm}:handle,
    input  rect-image:x,
    input  rect-image:y,
    input  rect-image:width-p,
    input  rect-image:height-p,
    output mfgpro_world).

/* Find out if globe should spin */
GET-KEY-VALUE SECTION "Applications" KEY "spin" VALUE spin_ok.

/* Bind a trigger to the world to spin it */
on mouse-select-click of mfgpro_world
do:
   if spin_ok = "yes" then run spin-globe.
end.

PROCEDURE draw-globe:
/* ----------------------------------------------------------------------
   Purpose: Draws an image and copyright text within the bounding box.
   Input Parameters:
      phFrame     - Frame to draw in
      pX, pY      - Upper Left corner of bounding region
      pWP, pHP    - Width and Height of bounding region
   Output:
      phImage     - Handle of world image
   ----------------------------------------------------------------------*/
   define input  parameter phFrame as widget  no-undo.
   define input  parameter pX      as integer no-undo.
   define input  parameter pY      as integer no-undo.
   define input  parameter pWP     as integer no-undo.
   define input  parameter pHP     as integer no-undo.

   define output parameter phImage as widget no-undo.

   define variable h as widget no-undo.
   define variable i as integer no-undo.
   define variable x as integer no-undo.
   define variable y as integer no-undo.
   define variable width-p  as integer no-undo.
   define variable height-p as integer no-undo.
   define variable txt as character no-undo.
   define variable lin as character no-undo.
   define variable temp-result as logical.
   define variable repr-text like msg_desc no-undo.

   /******************************************************************/
   /* Now create an image in the remaining space.  The size of this  */
   /* image is 282 x 188 pixels. Center it vertically between the top*/
   /* of the bounding box, and the last y value from the text.       */
   /******************************************************************/
   assign
      width-p = 282
      height-p = min(y - pY - rect-image:edge-pixels - 1, 188).

   create image phImage
   assign
      frame         = phFrame
      x             = rect-image:x + rect-image:edge-pixels
      y             = rect-image:y + rect-image:edge-pixels
      height-pixels = 188
      width-pixels  = 282
      sensitive     = yes
      bgcolor       = 15
      fgcolor       = 15.

   /* Now load the image */
   temp-result = phImage:load-image ("gl00{&stop-globe}",0,0,282,188).

   /* Add text to bottom of screen.  Use a text line height that */
   /* Includes 2 pixels of margin. G1MP changed "qad.inc" to     */
   /* "QAD" in copyright text.*/
   assign
      height-p = 2 + font-table:get-text-height-p (20)
      y        = pY + pHP - (height-p / 2).

   /* GET EXTERNALIZED LABELS. */
   /* THIS PRODUCT MAY NOT BE REPRODUCED OR DISTRIBUTED */
   {pxmsg.i &MSGNUM=3775 &ERRORLEVEL=1 &MSGBUFFER=repr-text}
   assign
      txt = getTermLabel("QAD_INC._PROPRIETARY",28) +
            ". " +
            repr-text +
            ". " +
            CHR(10) +
            "Copyright 1986-2004 QAD Inc. " +
            getTermLabel("ALL_RIGHTS_RESERVED",28) +
            "." +
            CHR(10).

   do i = 1 to 2:

      lin = entry(i,txt,chr(10)).
      width-p = font-table:get-text-width-p (lin ,20).

      create text h
      assign
         frame         = phFrame
         format        = "x(" + string(length(lin,"RAW")) + ")"
         screen-value  = lin
         width-pixels  = width-p
         height-pixels = height-p
         font          = 20
         fgcolor       = 0
         bgcolor       = 8
         y             = rect-image:y + rect-image:height-pixels +
                         ((i - 1) * font-table:get-text-height-p (20)) + 2
         x             = (phFrame:width-pixels / 2)  - (width-p / 2).

   end.

END PROCEDURE.

PROCEDURE spin-globe:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
   -------------------------------------------------------------*/
   define variable num-rotate  as integer no-undo.
   define variable num-globes  as integer no-undo.
   define variable stop-it     as logical initial false.
   define variable temp-result as logical.

   on mouse-select-dblclick of mfgpro_world
   do:
      stop-it = true.
   end.

   mfgpro_world:sensitive = true.

/*YM loopa:                                                                  */
/*YM repeat:                                                                 */
/*YM                                                                         */
/*YM    repeat num-globes = 1 to {&LAST-GLOBE}:                              */
/*YM                                                                         */
/*YM       if num-globes < ({&LAST-GLOBE} - {&STOP-GLOBE}) then              */
/*YM          get-globe = string(num-globes + {&STOP-GLOBE} - 1).            */
/*YM       else                                                              */
/*YM          get-globe = string(num-globes                                  */
/*YM                    - ({&LAST-GLOBE} - {&STOP-GLOBE})).                  */
/*YM                                                                         */
/*YM       if length(get-globe, "raw") < 2 then                              */
/*YM          get-globe = "0" + get-globe.                                   */
/*YM                                                                         */
/*YM       temp-result = mfgpro_world:load-image("gl00" + get-globe).        */
/*YM                                                                         */
/*YM       process events.                                                   */
/*YM                                                                         */
/*YM       if stop-it then leave loopa.                                      */
/*YM                                                                         */
/*YM    end.                                                                 */
/*YM                                                                         */
/*YM    process events.                                                      */
/*YM                                                                         */
/*YM    if stop-it then leave loopa.                                         */
/*YM    if first-time then leave loopa.                                      */
/*YM                                                                         */
/*YM end.                                                                    */

   temp-result = mfgpro_world:load-image("gl00" + "{&STOP-GLOBE}" + "").

END PROCEDURE.
