/* mf1.i - Include file for mf1.p                                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 7.0 Last modified: 06/23/92            By: jcd *F679*            */
/* Revision: 7.3 Last modified: 09/16/92            By: jcd *G058*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/*           7.3                09/10/94            By: bcm *GM84*            */
/*           8.5                07/24/96            By: jpm *J0WN*            */
/*           8.6E               10/04/98            By: *J314* Alfred Tan     */
/*           9.1                08/13/00            By: *N0KR* Mark Brown     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *N08T*                    */
/* Revision: 1.9        BY: Katie Hilbert         DATE: 03/23/01  ECO: *P008* */
/* $Revision: 1.10 $    BY: Jean Miller           DATE: 06/22/02  ECO: *P09H* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

define {1} shared variable save_term as character.
define {1} shared variable help_exec like mnd_exec.
define {1} shared variable printdefault like prd_dev.
define {1} shared variable printdefaultlevel  as integer.
define {1} shared variable name like ad_name.
define {1} shared variable window_recid       as recid.
define {1} shared variable global_recid       as recid.
define {1} shared variable global_sec_opt     as character.
define {1} shared variable global_timeout_min as integer.
define {1} shared variable global_user_groups as character format "x(60)"
   label "Groups".
define {1} shared variable global_user_name   as character format "x(35)"
   label "User Name".
define {1} shared variable global_passwd      as character.
define {1} shared variable swindow_recid      as recid no-undo initial ?.
