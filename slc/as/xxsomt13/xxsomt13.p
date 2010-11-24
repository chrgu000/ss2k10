/* xxsomt13.p   - SALES ORDER MAINTENANCE                                     */
/* REVISION:101027.1 LAST MODIFIED: 10/27/10 BY: zy              *ar*         */
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1B   QAD:eb21sp5                                  */
{mfdtitle.i "101027.1"}

/* CHANGES MADE TO THIS PROGRAM MAY ALSO NEED TO BE */
/* MADE TO PROGRAM fseomt.p.                        */

{etdcrvar.i "new"}
{etvar.i &new="new"}
{etrpvar.i &new="new"}

/*!

With J04C, Sales Orders and RMAs are maintained in common code.  Sosomt.p
and fsrmamt.p both call sosomt1.p for their processing.  The one input
parameter to sosomt1.p tells it whether RMA's or SO's are being maintained.

*/

pause 0.

/* THE INPUT PARAMETER TO SOSOMT1.P, NO, MEANS, "NO, THIS IS    */
/* NOT AN RMA" TO THAT PROGRAM.                                 */

/*ar*/ /* {gprun.i  ""sosomt1.p""  */
/*ar*/ /*   "(input no)"}          */

/*ar*/{gprun.i  ""xxsomt113.p"" "(input no)"}       