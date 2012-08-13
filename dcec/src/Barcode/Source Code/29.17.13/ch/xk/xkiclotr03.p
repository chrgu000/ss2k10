/* GUI CONVERTED from iclotr02.p (converter v1.76) Mon Aug 26 05:13:04 2002 */
/* iclotr02.p - INVENTORY TRANSFER SINGLE ITEM (RESTRICTED)                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0     LAST MODIFIED: 07/02/92    BY: pma *F701*                */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7     BY: Jean Miller            DATE: 12/10/01  ECO: *P03H*   */
/* $Revision: 1.8 $      BY: Manjusha Inglay        DATE: 08/16/02  ECO: *N1QP*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* LAST MODIFIED BY LB01             06/14/04                                 */
/*CJ modified on Oct. 22 2004 *cj*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
/*lb01*/
define input PARAMETER rdcponbr like po_nbr.
define input PARAMETER rdceffdate as date.

/* lb01
def shared temp-table xkrodet like xkrod_det.
*/

	define shared work-table xkrodet
		field xkrodnbr like xkrod_det.xkrod_nbr
		field xkrodline like xkrod_line
		field xkrodpart like pt_part
		field xkrodqtyord as decimal format "->,>>>,>>9.9<<<<<<<<" label "订量"
		field xkrodqtyopen as decimal format "->,>>>,>>9.9<<<<<<<<" label "待转移量"
 		field xkrodqtyrcvd as decimal format "->,>>>,>>9.9<<<<<<<<" label "已转移量".

DEFINE shared TEMP-TABLE rctkb
/*cj*/ FIELD seq11 AS INTEGER FORMAT "9999"
    FIELD kbid LIKE knbd_id
    FIELD part LIKE pt_part
    FIELD qty AS DECIMAL LABEL "收获数量"
    FIELD rct AS LOGICAL INITIAL YES
    INDEX kbid 
/*cj*/    seq11 part    
    kbid .


define new shared variable trtype as character.

{gldydef.i new}
{gldynrm.i new}
trtype = "SITE/LOC".

for each rctkb:
	delete rctkb.
end.


find first xkro_mstr no-lock where xkro_nbr = rdcponbr no-error.
if not available xkro_mstr then leave.
for each xkrodet where xkrodet.xkrodnbr = rdcponbr and xkrodet.xkrodqtyopen <> 0:  /*lb01*/
	create rctkb.
	assign
		kbid = xkrodet.xkrodline
		part = xkrodet.xkrodpart.

	{gprun.i ""xkiclotr.p"" "(xkrodnbr,xkrodpart, rdceffdate, xkrodqtyopen,
	                          xkro_site,xkro_loc,xkro_dsite,xkro_dloc,
	                          output qty)"}
	                          

end.


/*GUI*/ if global-beam-me-up then undo, leave.

