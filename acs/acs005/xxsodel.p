/* xxsodel.p   - SALES ORDER delete                                          */
/* REVISION: 1.0      LAST MODIFIED: 09/25/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "100925.1"}

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

{gprun.i  ""xxsodel1.p""
   "(input no)"}
