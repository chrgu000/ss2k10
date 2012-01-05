/* xxsois1112.p - cp from SALES ORDER SHIPMENT WITH SERIAL NUMBERS           */

/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* modify for cimload hide message for gui                                    */
{mfdtitle.i "111215.1"}
{cxcustom.i "SOSOIS.P"}
{sosois1.i new}

{gldydef.i new}
{gldynrm.i new}
{&SOSOIS-P-TAG1}

/* PREVIOUSLY, THE USER COULD SHIP SO'S OR RMA'S WITH SOSOIS.P. */
/* NOW, ONLY SO'S MAY BE SHIPPED WITH SOSOIS.P.  RMA'S ARE      */
/* SHIPPED IN FSRMASH.P.                                        */

sorec = fssoship.

{gprun.i ""xxsoism1112.p""}
