/* mhjit059.p ISS-UNP for JIT KB module                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



{mfdeclre.i}
{cxcustom.i "ICUNIS.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{&ICUNIS-P-TAG1}

define new shared variable transtype as character format "x(7)".

{gldydef.i new}
{gldynrm.i new}

transtype = "ISS-UNP".
{gprun.i ""xxmhjit059.p""}
