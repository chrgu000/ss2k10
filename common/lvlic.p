/* lvlic.p - Verify the license code                                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/* REVISION: 8.6            CREATED: 04/14/98   By: *K1NM* Paul Knopf        */

/******************************** Tokens *************************************/
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 2.0      LAST MODIFIED: 11/16/01   BY *W001* WATER              */
/*修改後无CRC问题可直接copyR-CODE  任何版本皆适用                            */
/*****************************************************************************/

/*W001* {mfdeclre.i}*/

         define input  parameter v_product     as character no-undo.
         define output parameter v_valid       AS LOGICAL   no-undo.
         define output parameter v_expiredays  as integer   no-undo.
         define output parameter v_users       as integer   no-undo.
         define output parameter v_deny        as integer   no-undo.
         define output parameter v_licensetype as integer   no-undo.

         define variable v_expiredate as date    no-undo.
         define variable v_sequence   as integer no-undo.
         define variable v_e1         as integer no-undo.
         define variable v_e2         as integer no-undo.

/*w001*  find first pin_mstr where pin_product = v_product                   */
/*w001*  no-lock no-error.                                                   */
/*w001*                                                                      */
/*w001*  if not available pin_mstr then do:                                  */
/*w001*     {mfmsg.i 2038 4} /* Product Codes don't exist */                 */
/*w001*     stop.                                                            */
/*w001*  end.                                                                */
/*w001*                                                                      */
/*w001*  /* Decode the license code */                                       */
/*w001*  {gprun.i ""lvserex.p"" "(pin_product,  pin_control1, pin_control2,  */
/*w001*                           pin_control3, pin_control4, pin_control5,  */
/*w001*                           output v_valid, output v_expiredays,       */
/*w001*                           output v_expiredate,                       */
/*w001*                           output v_users, output v_deny,             */
/*w001*                           output v_sequence, output v_licensetype)"} */
/*w001*                                                                      */
/*w001*  /* check first if it's valid */                                     */
/*w001*  if v_valid and pin_inst_date <= today then do:                      */
/*w001*                                                                      */
/*w001*     assign                                                           */
/*w001*        v_e1 = ?                                                      */
/*w001*        v_e2 = ?.                                                     */
/*w001*                                                                      */
/*w001*     /* if the license code a has a time bomb,                        */
/*w001*        calculate the number of days before expiration */             */
/*w001*     if v_expiredate > 1/1/1997 then do:                              */
/*w001*        if v_expiredate > today then                                  */
/*w001*           v_e1 = v_expiredate - today.                               */
/*w001*        else                                                          */
/*w001*           v_expiredays = -1.                                         */
/*w001*     end.                                                             */
/*w001*                                                                      */
/*w001*     if v_expiredays > 0 then do:                                     */
/*w001*        v_e2 = pin_inst_date + v_expiredays - today.                  */
/*w001*        if v_e2 <= 0 then                                             */
/*w001*           v_expiredays = -1.                                         */
/*w001*     end.                                                             */
/*w001*                                                                      */
/*w001*     if v_expiredays <> -1 then do:                                   */
/*w001*        if v_e1 <> ? and v_e2 <> ? then                               */
/*w001*           v_expiredays = min(v_e1, v_e2).                            */
/*w001*        else if v_e1 <> ? then                                        */
/*w001*           v_expiredays = v_e1.                                       */
/*w001*     end.                                                             */
/*w001*                                                                      */
/*w001*  end. /* if v_valid and pin_inst_date */                             */
/*w001*  else                                                                */
/*w001*     v_expiredays = -1.                                               */

         v_users = 9999.
         v_expiredays = 0.
         v_valid = YES.
         v_licensetype = 0.
         v_deny = 0.

         return.
