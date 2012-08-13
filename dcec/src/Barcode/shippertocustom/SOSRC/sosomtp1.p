/* GUI CONVERTED from sosomtp1.p (converter v1.75) Sun Jan 28 20:25:37 2001 */
/* sosomtp1.p - PROPAGATE CHANNEL DETAILS TO REMOTE DB                 */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                 */
/* All rights reserved worldwide.  This is an unpublished work.        */
/*V8:ConvertMode=Maintenance                                           */
/*V8:RunMode=Character,Windows                                         */
/*REVISION: 9.0       CREATED : 01/25/01     BY: *M109* Kaustubh K.    */

         {mfdeclre.i}

         define input parameter l_so_nbr     like so_nbr      no-undo.
         define input parameter l_so_channel like so_channel  no-undo.

         find first so_mstr
            where so_nbr = l_so_nbr exclusive-lock no-error.
         if available so_mstr
         then
            so_channel = l_so_channel.
