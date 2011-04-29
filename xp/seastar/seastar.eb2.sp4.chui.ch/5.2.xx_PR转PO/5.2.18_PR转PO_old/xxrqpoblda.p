/* rqpoblda.p - Requisition To Purchase Order Build Sub-Program             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=ReportAndMaintenance                              */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan     */
/* REVISION 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION 8.5       LAST MODIFIED: 09/02/98  BY: *J2YD* Patrick Rowan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                */


/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Display scrolling window of requisition lines to select.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 1) A temp-table is used to hold the requisition lines.  Once a line has been
    selected, the copy_to_po flag will be set.  A seperate process will
    gather the selected lines and create a new purchase order.
 ============================================================================
 !*/
         {mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

         /* VARIABLES */

         /* SHARED VARIABLES*/
         {xxrqpovars.i}

define shared temp-table rq_wrk 
   field rq_nbr                     like rqm_mstr.rqm_nbr label "申请号"
   field rq_line                    like rqd_line label "项次"
   field rq_site                    like rqd_site label "地点"
   field rq_item                    like rqd_part       label "零件号"
   field rq_net_qty                 like rqd_req_qty    label "未结数量"
   field rq_need_date               as date           label "需要日期"
   field rq_supplier                like rqd_vend     label "供应商"
   field rq_ship                    like rqd_ship     label "交运地"
   field rq_buyer_id                like rqm_buyer    label "采购员"
   field rq_copy_to_po              like mfc_logical  label "复制"
   index rq_index1                  is unique primary
   rq_nbr ascending
   rq_line ascending.



         repeat for rq_wrk
		    on endkey undo, leave 
            with frame y width 80 no-attr-space down:
			 {xxswindowd.i rq_wrk "y"
                           rq_nbr
                           rq_line
                           rq_nbr
                           rq_copy_to_po
                           rq_nbr
                           rq_line
                           rq_item
                           rq_net_qty
                           rq_need_date
                           rq_supplier
                           rq_buyer_id
                           rq_copy_to_po}

               /* {1}=file name  {2}=frame name {3}=key1 field
                  {4}=key2 field {5}=scrolling field name
                  {6}=field to update  {7}...{14}=display fields  */

               if keyfunction(lastkey) = "go" then do:

                  {mfmsg01.i 12 1 info_correct}  /* IS ALL INFO CORRECT? */
                  if info_correct then
                     leave.
               end.

               if keyfunction(lastkey) = "return" or
                  keyfunction(lastkey) = "end-error" then
                     leave.
           
         end.  /* repeat */
