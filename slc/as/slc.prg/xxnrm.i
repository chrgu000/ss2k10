/* nrm.i - NUMBER RANGE MANAGEMENT ENGINE                                     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 8.6      LAST MODIFIED: 04/30/96   BY: PCD *K002*                */
/*                                   09/27/96   BY: JZW *K00R*                */
/*                                   10/09/96   BY: JZW *K010*                */
/*                                   10/22/96   BY: JZW *K018*                */
/*                                   10/25/96   BY: JZW *K019*                */
/*                                   12/18/96   BY: JZW *K03F*                */
/*                                   12/27/96   BY: VRN *K03V*                */
/*                                   02/13/97   *K064*  Jeff Wootton          */
/*                                   04/11/97   *K0BB*  Jeff Wootton          */
/*                                   04/18/97   *K0C1*  E. Hughart            */
/* REVISION: 8.6      LAST MODIFIED: 01/11/99   BY: *K1YS* G.Latha            */
/* REVISION: 8.6E     LAST MODIFIED: 01/15/00   BY: *L0NT* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00   BY: *N0W9* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *K064*                    */
/* Old ECO marker removed, but no ECO header exists *K0BB*                    */
/* Old ECO marker removed, but no ECO header exists *K0C1*                    */
/* Revision: 1.18        BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.20        BY: Jean Miller          DATE: 02/24/04  ECO: *Q067* */
/* Revision: 1.21        BY: Vinay Soman          DATE: 08/26/04  ECO: *P2HB* */
/* $Revision: 1.22 $          BY: Swati Sharma         DATE: 03/10/05  ECO: *P3C7* */
/*-Revision end---------------------------------------------------------------*/

/* PATCH L0NT IS TO ENHANCE THE PERFORMANCE OF BACK DATING  */
/* OPERATIONS IN THE CASE OF DATE-DRIVEN CONTROL SEGMENTED  */
/* SEQUENCES. IT CREATES/UPDATES NRH_HIST RECORD TO STORE   */
/* THE HIGHEST SEQUENCE NUMBER USED FOR THE PERIOD OF THE   */
/* PREVIOUS TRANSACTION ON PERIODIC RESET BASED ON DATE IN  */
/* THE CASE OF DATE-DRIVEN CONTROL SEGMENTED SEQUENCES.     */
/* EVERY RESET OPERATION WILL NOW SEARCH FOR THE HIGHEST    */
/* SEQUENCE NUMBER USAGE RECORD (NRH_SEQID = NR_SEQID + "," */
/* + NRH_NON_INC) TO GET THE HIGHEST SEQUENCE NUMBER ALREADY*/
/* USED FOR THE PERIOD IN WHICH THE EFFECTIVE DATE OF THE   */
/* CURRENT TRANSACTION FALLS.                               */

{cxcustom.i "NRM.I"}

define variable nr-action-register as character initial "1".
define variable nr-action-void     as character initial "2".
define variable nr-action-print    as character initial "3".

/* SEQUENCE DATA STRUCTURE */
define variable Current_id      like nr_seqid.
define variable description     like nr_desc.
define variable vDataset        like nr_dataset.
define variable Discard_allowed like nr_allow_discard.
define variable Void_allowed    like nr_allow_void.
define variable Internal        like nr_internal.
define variable Effdate         like nr_effdate.
define variable Expdate         like nr_exp_date.
define variable In_use          as logical.
define variable Next_set        as logical.
define variable Segment_count   as integer.
define variable Current_value   as character.
define variable Non_inc_block   as character.
define variable Curr_effdate    as date.
define variable Valuemask       as character.
define variable Archived        as logical.
define variable Error_state     as logical no-undo.
define variable Error_nbr       as integer no-undo.
define variable Error_seg_nbr   as integer no-undo.
define variable Segment_edited  as logical no-undo.

/* FOR THE SEQUENCE  */
define variable l_inuse         like mfc_logical initial no no-undo.

/* SEGMENT DATA STRUCTURE */
define temp-table segment no-undo
   field seg_attached           as logical
   field seg_type               as character
   field seg_exe_generate       as character format "x(20)"
   field seg_exe_validate       as character format "x(20)"
   field seg_exe_reset          as character format "x(20)"
   field seg_exe_edit           as character format "x(20)"
   field seg_exe_display        as character format "x(20)"
   field seg_exe_decrement      as character format "x(20)"
   field seg_nbr                as integer
   field seg_rank               as character
   field seg_ini                as character
   field seg_min                as character
   field seg_max                as character
   field seg_reset              as character
   field seg_value              as character
   field seg_format             as character
   field seg_valuemask          as character
   index seg-nbr seg_nbr.


define stream history.
define variable trans_effdate        as date.

PROCEDURE nr_create:

   assign
      Current_id      = ""
      description     = ""
      vDataset         = ""
      Internal        = no
      Effdate         = today
      Expdate         = hi_date
      Discard_allowed = no
      Void_allowed    = no
      Segment_count   = 0
      In_use          = no
      l_inuse         = no
      Next_set        = no
      Archived        = no
      Error_state     = false
      Error_nbr       = 0
      trans_effdate   = today.

   for each segment where seg_attached exclusive-lock:
      delete segment.
   end.

END PROCEDURE.

PROCEDURE nr_load:
   /* Retrieve a saved sequence by its Id into the current
      sequence data structure.
      Retrieve each segment of the saved sequence. */

   define input parameter load_id like current_id.
   define input parameter lock_required as logical.

   run nr_create.

   if lock_required then
      find first nr_mstr where nr_domain = global_domain and
                               nr_seqid = load_id
      exclusive-lock no-error.
   else
      find first nr_mstr  where nr_domain = global_domain and
                                nr_seqid = load_id
      no-lock no-error.

   if not available nr_mstr then do:
      error_state = true.
      error_nbr = 2914. /* Sequence not found */
      return.
   end.

   /* CHECK IF THE SEQUENCE HAS ALREADY BEEN REGISTERED */
   assign
      Current_id      = nr_seqid
      description     = nr_desc
      vDataset         = nr_dataset
      Internal        = nr_internal
      Effdate         = nr_effdate
      Expdate         = (if nr_exp_date = ? then hi_date else nr_exp_date)
      Discard_allowed = nr_allow_discard
      Void_allowed    = nr_allow_void
      Segment_count   = nr_segcount
      In_use          = can-find (first nrh_hist
                                  where nrh_domain = global_domain
                                   and (nrh_seqid = nr_seqid)) or
                        can-find (first nrh_hist
                                  where nrh_domain = global_domain and
                                        nrh_seqid begins nr_seqid + ",")
      l_inuse         = in_use
      Next_set        = nr_next_set
      Valuemask       = nr_valuemask
      Archived        = nr_archived.

   run nr_load_segments (buffer nr_mstr).

END PROCEDURE.

PROCEDURE nr_save:
   /* Save the current sequence data structure under a given sequence Id. */
   define input parameter save_id as character no-undo.

   define variable new-sequence as logical no-undo.
   define variable is-unique as logical initial true no-undo.
   define variable seq-length as integer initial 0 no-undo.

   new-sequence = (Current_id = "").

   if can-find(nr_mstr where nr_domain = global_domain and
                             nr_seqid = save_id) and
      new-sequence
   then do:
      error_state = true.
      error_nbr = 2909. /* Sequence Id already in use */
      return.
   end.

   if (Segment_count > 0  /* There are some segments */
    or not new-sequence)  /* Saving completed record */
                          /* (do not check initial empty record) */
   and not In_use         /* No numbers have been dispensed */
                          /* (do not re-check record once in-use) */
   then do:               /* Check that record is all valid */

      /* This message should occur if there are no segments */
      /* (but not when saving initial empty record), */
      /* or when none of the segments is an incrementing segment */
      if not can-find(segment where seg_rank = "2") then do:
         Error_state = true.
         Error_nbr   = 2926. /* Seq must have one incrementing seg */
         return.
      end.

      if Effdate = ? then do:
         Error_state = true.
         Error_nbr = 2930. /* Effective date must be specified */
         return.
      end.

      if Discard_allowed and not Void_allowed then do:
         Error_state = true.
         /* If discards are allowed, voids must also be allowed. */
         Error_nbr   = 2931.
         return.
      end.

      for each segment where seg_attached:
         seq-length = seq-length + length(seg_value).
      end.
      if seq-length > 40 then do:
         Error_state = true.
         Error_nbr = 2933.  /* Sequence number length must be 40 char */
         return.
      end.

      run nr_check_unique ( output is-unique ).
      if not is-unique then do:
         Error_state = true.
         Error_nbr   = 2919. /* Seq not unique for target dataset*/
         return.
      end.
      {&NRM-I-TAG3}

   end.

   if new-sequence then do:
      create nr_mstr.
      nr_mstr.nr_domain = global_domain.
   end.
   else
      find nr_mstr where nr_domain = global_domain
                     and nr_seqid = save_id
      exclusive-lock no-error.

   assign
      Current_id       = save_id
      nr_seqid         = save_id
      nr_desc          = description
      nr_dataset       = vDataset
      nr_internal      = Internal
      nr_effdate       = Effdate
      nr_exp_date      = (if Expdate = hi_date then ? else Expdate)
      nr_allow_discard = Discard_allowed
      nr_allow_void    = Void_allowed
      nr_segcount      = Segment_count
      nr_next_set      = Next_set.

   run nr_save_segments (buffer nr_mstr).

   /* USE RECID FUNCTION TO MAKE RECORD VISIBLE IN */
   /* AN ORACLE USER'S SUB-PROGRAM.                */
   if recid(nr_mstr) = ? then .

END PROCEDURE.

PROCEDURE nr_delete:
/*
Delete the sequence represented by the current data
structure. Works only if the sequence has been saved.
*/

   if current_id = "" then do:
      error_state = true.
      error_nbr = 2915. /* Sequence not saved */
      return.
   end.

   if in_use then do:
      error_state = true.
      error_nbr = 2911. /* Sequence is in use */
      return.
   end.

   find first nr_mstr where nr_domain = global_domain and
                            nr_seqid = current_id
   exclusive-lock no-error.

   if not available nr_mstr then do:
      error_state = true.
      error_nbr = 2914. /* Sequence not found */
      return.
   end.

   delete nr_mstr.

END PROCEDURE.


PROCEDURE nr_archive:
   /* Archive and/or delete a sequence. */
   define input parameter p-file as character no-undo.
   define input parameter p-seq-id as character no-undo.
   define input parameter p-archive as logical no-undo.
   define input parameter p-delete as logical no-undo.
   define input parameter p-to-seqnum as character no-undo.

   output stream history to value (p-file) append.

   if p-delete then do:

      find nr_mstr where nr_domain = global_domain
                     and nr_seqid = p-seq-id
      exclusive-lock no-error.

      if available nr_mstr then assign nr_archived = true.

   end.

   for each nrh_hist where
            nrh_domain = global_domain and
            nrh_seqid = p-seq-id and
            nrh_number <= p-to-seqnum
   exclusive-lock:

      if p-archive then do:
         export stream history "nrh_hist".
         export stream history nrh_hist.
      end.
      if p-delete then do:
         delete nrh_hist.
      end.
   end.

   /* Mark the sequence as Archived. */
   find nr_mstr where nr_domain = global_domain
                  and nr_seqid = p-seq-id
   no-lock no-error.

   if available nr_mstr then do:
      if p-archive then do:
         export stream history "nr_mstr".
         export stream history nr_mstr.
      end.
   end.

   output stream history close.

END PROCEDURE.



PROCEDURE nr_verify:
   /* Verify that an external sequence number conforms to the definition
      of a previously defined sequence. */
   define input parameter seq-nbr as character no-undo.
   define output parameter is_valid as logical initial true no-undo.

   for each segment where seg_attached:
      run value (seg_exe_validate)
         (input recid (segment),
          input-output seq-nbr,
          output is_valid).

      if not is_valid then do:
         Error_seg_nbr = seg_nbr.
         return.
      end.
   end.

   if seq-nbr <> "" then do: /* CHARACTERS EXIST PAST LAST SEGMENT */
      is_valid = false.
      Error_seg_nbr = Segment_count.
      /* ASSUME THE CHARACTERS BELONG TO THE LAST SEGMENT */
      return.
   end.

END PROCEDURE.

PROCEDURE nr_set_target:
   /* Set the target dataset for the sequence. */
   define input parameter p-dataset as character no-undo.

   /* If In_use, disallow maintenance */
   {nrinuse.i}

   vDataset = p-dataset.

END PROCEDURE.

PROCEDURE nr_set_description:

   define input parameter p-description as character no-undo.

   /* If In_use, allow maintenance of description */

   description = p-description.

END PROCEDURE.

PROCEDURE nr_set_effdt:
   /* Set the effective and expiration dates for the sequence. Verify that
      the expiration date is not earlier that the effective date. */
   define input parameter p-effdate as date no-undo.
   define input parameter p-expdate as date no-undo.

   /* If In_use, allow maintenance of Effective and Expiration */
   if p-effdate = ? then do:
      Error_state = true.
      Error_nbr = 2930. /* Effective date must be specified */
      return.
   end.

   if p-expdate <> ?
      and p-expdate < p-effdate
   then do:
      Error_state = true.
      Error_nbr = 2902. /* Exp date cannot precede effective date */
      return.
   end.

   Effdate = p-effdate.
   Expdate = p-expdate.

   /* Reset the valuemask for date-driven segment */
   find segment where seg_attached and seg_rank <= "1" no-error.
   if available segment then do:
      /* Date */
      if seg_type = "2" then
      run seg_set_date
         (recid(segment), seg_format, (seg_rank = "0")).
      /* Fiscal */
      if seg_type = "3" then
      run seg_set_fiscal
         (recid(segment), seg_format, (seg_rank = "0")).
      /* xdate */
      if seg_type = "5" then
      run seg_set_xdate
         (recid(segment), seg_format, (seg_rank = "0")).
   end.

END PROCEDURE.


PROCEDURE nr_set_internal:
   /* Set the internal sequence flag for a sequence. */
   define input parameter p-internal as logical.

   /* If In_use, disallow maintenance */
   {nrinuse.i}

   internal = p-internal.

END PROCEDURE.

PROCEDURE nr_set_discards:
   /* Set the discard policy for a sequence.
      Can be set to Allow/Not allow discarding of sequence numbers. */

   define input parameter p-discard-allowed as logical.

   /* If In_use, disallow maintenance */
   {nrinuse.i}

   discard_allowed = p-discard-allowed.

END PROCEDURE.


PROCEDURE nr_set_voids:
/* Set the void policy for a sequence.
  Can be set to Allow/Not allow for voiding sequence numbers. */
   define input parameter p-void-allowed as logical.

   /* If In_use, disallow maintenance */
   {nrinuse.i}

   /* If discards allowed, voids must be allowed */
   if discard_allowed and not p-void-allowed then do:
      Error_state = true.
      Error_nbr   = 2931. /* If discards allowed, voids must be allowed */
      return.
   end.

   void_allowed = p-void-allowed.

END PROCEDURE.


PROCEDURE nr_add_segment:
   /* Attach a segment to the current sequence.
      Segment is attached as the last segment. */
   define input parameter p-seg-recid as recid.

   /* If In_use, disallow maintenance */
   {nrinuse.i}

   Segment_count = Segment_count + 1.

   find segment where recid (segment) = p-seg-recid.

   assign
      seg_attached   = true
      seg_nbr        = Segment_count.

END PROCEDURE.


PROCEDURE nr_drop_segment:
   /* Drop active segment from the current sequence. Does not save the sequence. */
   define input parameter p-seg-recid as recid.

   define variable k as integer initial 1.

   find segment where recid (segment) = p-seg-recid.

   delete segment.

   /* Re-number segments for display */
   for each segment where seg_attached by seg_nbr:
      seg_nbr = k.
      k = k + 1.
   end.

   Segment_count = Segment_count - 1.

END PROCEDURE.

PROCEDURE nr_set_seg_nbr:
   /* Set the segment number of segment, with respect to other segments. */

   define input parameter p-old-nbr as integer no-undo.
   define input parameter p-new-nbr as integer no-undo.

   define variable target as recid no-undo.

   /* If In_use, disallow maintenance */
   {nrinuse.i}

   find first segment where seg_attached and seg_nbr = p-old-nbr.
   target = recid (segment).

   if p-new-nbr > Segment_count then p-new-nbr = Segment_count.

   for each segment where seg_attached by seg_type:

      if recid (segment) = target then do:
         seg_nbr = p-new-nbr.
         next.
      end.

      if p-new-nbr <= p-old-nbr and
         ( seg_nbr >= p-new-nbr and seg_nbr < p-old-nbr )
         then seg_nbr = seg_nbr + 1.
      else if p-new-nbr > p-old-nbr and
         ( seg_nbr <= p-new-nbr and seg_nbr > p-old-nbr )
         then seg_nbr = seg_nbr - 1.

   end.

END PROCEDURE.

PROCEDURE nr_load_segments:
/* Retrieve segment information into the current sequence data structure.
   This is an internal service; it is not meant to be used by client programs. */

   define parameter buffer p-nrmstr for nr_mstr.

   define variable load-value as character no-undo initial "".

   define variable k       as integer no-undo.
   define variable type    as character no-undo.
   define variable rank    as character no-undo.
   define variable ini     as character no-undo.
   define variable min     as character no-undo.
   define variable max     as character no-undo.
   define variable rst     as character no-undo.
   define variable val     as character no-undo.
   define variable fmt     as character no-undo.
   define variable segtype as character no-undo.
   define variable seg        as recid no-undo.

   assign
      type  = nr_seg_type
      rank  = nr_seg_rank
      ini   = nr_seg_ini
      min   = nr_seg_min
      max   = nr_seg_max
      rst   = nr_seg_reset
      val   = nr_seg_value
      fmt   = nr_seg_format.

   do k = 1 to Segment_count:

      run nr_unpack (input-output type, output segtype).
      run nr_seg_make (input segtype, output seg).

      find segment where recid(segment) = seg no-error.

      run nr_unpack (input-output rank, output seg_rank).
      run nr_unpack (input-output ini, output seg_ini).
      run nr_unpack (input-output min, output seg_min).
      run nr_unpack (input-output max, output seg_max).
      run nr_unpack (input-output rst, output seg_reset).
      run nr_unpack (input-output val, output seg_value).
      run nr_unpack (input-output fmt, output seg_format).

      seg_valuemask = substring(Valuemask,1,2 * length(seg_value)).
      Valuemask = substring(Valuemask, 2 * length(seg_value) + 1).

      assign
         seg_attached = true
         seg_nbr      = k
         load-value   = load-value + seg_value.

   end.

   Current_value = load-value.

END PROCEDURE.

PROCEDURE nr_save_segments:
   /* Save segment information from the current sequence data
      structure to database storage.
      This is an internal service; it is not meant to be used
      by a client program. */
   define parameter buffer p-nrmstr for nr_mstr.

   define variable delim as character initial ",".

   /* Clear segment fields. */
   assign
      nr_seg_ini        = ""
      nr_seg_min        = ""
      nr_seg_max        = ""
      nr_seg_reset      = ""
      nr_seg_type       = ""
      nr_seg_nbr        = ""
      nr_seg_rank       = ""
      nr_seg_value      = ""
      nr_seg_format     = ""
      nr_valuemask      = "".


   /* Pack fields */
   for each segment:
      assign
         nr_seg_type   = nr_seg_type + seg_type + delim
         nr_seg_rank   = nr_seg_rank + seg_rank + delim
         nr_seg_ini    = nr_seg_ini + seg_ini + delim
         nr_seg_min    = nr_seg_min + seg_min + delim
         nr_seg_max    = nr_seg_max + seg_max + delim
         nr_seg_reset  = nr_seg_reset + seg_reset + delim
         nr_seg_value  = nr_seg_value + seg_value + delim
         nr_seg_format = nr_seg_format + seg_format + delim
         nr_valuemask  = nr_valuemask + seg_valuemask.

   end.

END PROCEDURE.

PROCEDURE nr_generate:
   /* Generate the next current value for the sequence.  The value of
      the sequence is generated by applying the seg_exe_generate
      operation to one or more segments in the sequence; which segments
      are thus updated, and in which order, is governed by the
      following rules:

      A Date driven segment can be set up as a control segment; a
      control segment is used to periodically reset the value of the
      incrementing segment.

      If present, the control segment is updated first.  Since a
      control segment is date driven, the display value may or may not
      change.  If the value does change, then the incrementing segment
      is reset to its reset values; if the value does not change, then
      the incrementing segment is incremented.
         seg_rank = "0" ==> Date-driven control segment.
         seg_rank = "1" ==> Date-driven segment, not control.
         seg_rank = "2" ==> Incrementing segment.
         seg_rank = "3" ==> Fixed segment.

      When the sequence is new, or when the next sequence number
      has been set explicitly, seg_value holds the next value. In
      this case nr_generate does not increment the incrementing
      segment, but sets the 'in_use' flag and clears the 'next_set' flag. */

   define input-output parameter l_reset       like mfc_logical no-undo.
   define input-output parameter l_old_seq_nbr like nrh_number  no-undo.
   define input-output parameter l_old_non_inc like nrh_non_inc no-undo.
   define input-output parameter l_old_inc     like nrh_inc     no-undo.

   define variable new-value as character no-undo initial "".
   define variable non-increment as character no-undo initial "".

   define variable dummy    as logical no-undo.
   define variable reset    as logical init false no-undo.
   define variable wrapped  as logical no-undo.

   /* STORE SEQUENCE DETAILS OF THE PREVIOUS TRANSACTION TO UPDATE */
   /* THE HIGHEST SEQUENCE NUMBER USAGE RECORD.                    */
   for each segment where seg_attached
   by seg_nbr:
      assign
         l_old_seq_nbr = l_old_seq_nbr + seg_value
         l_old_non_inc = l_old_non_inc + seg_value when (seg_rank <> "2")
         l_old_inc     = l_old_inc     + seg_value when (seg_rank  = "2").
   end. /* FOR EACH SEGMENT */

   for each segment where seg_attached by seg_rank:

      if seg_rank = "0" then do:
         run value (seg_exe_generate) (recid(segment), output reset).
      end.

      else if seg_rank = "1" then do:
         run value (seg_exe_generate) (recid(segment), output dummy).
      end.

      else if seg_rank = "2"
         and not reset
         and In_use
         and not Next_set
      then do:
         run value (seg_exe_generate) (recid(segment), output wrapped).
      end.

      else if seg_rank = "2" and reset then do:
         run value (seg_exe_reset) (recid(segment)).
      end.

      new-value = new-value + seg_value.

   end. /* for each segment */

   if wrapped then do:
      Error_state = true.
      Error_nbr = 2910. /* Sequence exceeded maximum */
      return.
   end.

   assign
      l_reset = reset.

   if reset then do:

      /* BUILD NON-INCREMENTAL STRING IN SEGMENT NUMBER ORDER */
      for each segment where seg_attached by seg_nbr:
         if seg_type = "2" /* DATE */
         or seg_type = "3" /* FISCAL */
         or seg_type = "4" /* FIXED */
         then
            non-increment = non-increment + seg_value.
      end.

      run nr_backdate (non-increment, output new-value).

      if Error_state then return.

   end.

   else do:
      Curr_effdate = Trans_effdate.
   end.


   assign
      Current_value = new-value
      In_use = true
      Next_set = false.

END PROCEDURE.

PROCEDURE nr_backdate:
   /* Generate a number drawn from an earlier period. */
   define input parameter p-non-inc as character no-undo.
   define output parameter new-value as character no-undo initial "".

   define variable alt-increment as character no-undo.
   define variable wrapped  as logical no-undo.

   /* FIND THE HIGHEST SEQUENCE NUMBER USAGE RECORD */
   for first nrh_hist
      fields(nrh_domain nrh_seqid nrh_inc)
       where nrh_domain = global_domain
         and nrh_seqid = current_id + "," + p-non-inc
   no-lock: end.

   if available nrh_hist then do:
      alt-increment = nrh_inc.
   end.

   for each segment where seg_attached:

      if seg_rank = "2" then do:
         if alt-increment = "" then
            /* SET TO THE RESET VALUE */
            seg_value = seg_reset.
         else
         do: /* SET TO ONE ABOVE THE LAST NUMBER USED */
            seg_value = alt-increment.
            run value (seg_exe_generate) (recid(segment), output wrapped).
         end.
      end. /* if seg_rank = "2" */

      new-value = new-value + seg_value.

   end. /* for each segment */

   if wrapped then do:
      Error_state = true.
      Error_nbr = 2910. /* Sequence exceeded maximum */
   end.


END PROCEDURE.

PROCEDURE nr_value:
   /* Pass back the formatted current value of the sequence.
   It does not affect the current value of the sequence.
   The result is the value recorded by the latest REGISTER operation,
   or the initial value if no numbers have yet been REGISTERed,
   or the Next value if it has been set by Sequence Number Maintenance.
   This applies to both Internal and External sequences. */
   define output parameter p-return as character no-undo initial "".

   for each segment where seg_attached by seg_nbr:
      p-return = p-return + seg_value.
   end.

END PROCEDURE.



PROCEDURE nr_register_value:
   /* Record a sequence value in the sequence history to indicate that it
      has been used. This service can be used in connection with both internal
      and external sequences. It Operates on the current sequence.
      The non-incrementing portion of the sequence number is stored separately
      in order to support back-dated and post-dated dispensing. */

   define input parameter p-seq-nbr as character no-undo.

   define variable increment as character no-undo.
   define variable non-increment as character no-undo initial "".

   if Current_id = "" then do:
      Error_state = true.
      Error_nbr = 2915. /* Sequence not saved. */
      return.
   end.

   /* Store incrementing and non-incrementing portions. */
   for each segment where seg_attached by seg_nbr:
      if seg_rank = "2" then
         increment = seg_value.
      else
         non-increment = non-increment + seg_value.
   end.

   {&NRM-I-TAG1}
   create nrh_hist.
   assign
      nrh_domain = global_domain
      nrh_seqid = Current_id
      nrh_number = p-seq-nbr
      nrh_inc = increment
      nrh_non_inc = non-increment
      nrh_action = nr-action-register
      nrh_desc = ""
      nrh_userid = global_userid
      nrh_date = today
      nrh_time = string (time,"HH:MM:SS").

   if recid(nrh_hist) = ? then .

   {&NRM-I-TAG2}
   release nrh_hist.

END PROCEDURE.

PROCEDURE nr_exists:
   /* Report whether sequence with the given sequence id exists. */
   define input parameter p-seq-id as character no-undo.
   define output parameter does-exist as logical initial false no-undo.

   does-exist = can-find (first nr_mstr where
                                nr_domain = global_domain
                            and nr_seqid = p-seq-id).

END PROCEDURE.

PROCEDURE nr_is_current:
   /* Report whether sequence is current as of the transaction date.  */
   /* (run nr-load before this)                                       */

   define input parameter p-trans-date as date no-undo.
   define output parameter is-current as logical initial false no-undo.

   is-current = (Effdate <= p-trans-date and
                (Expdate >= p-trans-date)).

END PROCEDURE.

PROCEDURE nr_description:
/* Report the description for the sequence. */
   define input parameter p-seq-id as character no-undo.
   define output parameter p-seq-desc as character no-undo.

   run nr_load
      (input p-seq-id,
       input false). /* NOT EXCLUSIVE-LOCK */

   if Error_state then return.

   p-seq-desc = Description.

END PROCEDURE.

PROCEDURE nr_get_length:
   /* Report the length of the number that is generated (internal seq)
      or is validated (external seq) by the sequence. */
   define input parameter p-seq-id as character no-undo.
   define output parameter p-length as integer no-undo.

   define variable current_value as character no-undo.

   p-length = 0.

   run nr_load
      (input p-seq-id,
       input false). /* NOT EXCLUSIVE-LOCK */

   if Error_state then return.

   run nr_value
      (output current_value).

   p-length = length(current_value).

END PROCEDURE.

PROCEDURE nr_dataset:
   /* Report the target dataset for the sequence. */
   define input parameter p-seq-id as character no-undo.
   define output parameter p-dataset as character no-undo.

   run nr_load
      (input p-seq-id,
       input false). /* NOT EXCLUSIVE-LOCK */

   if Error_state then return.

   p-dataset = vDataset.

END PROCEDURE.

PROCEDURE nr_is_internal:
   /* Report whether the sequence is internal. */
   define input parameter p-seq-id as character no-undo.
   define output parameter is-internal as logical no-undo.

   run nr_load
      (input p-seq-id,
       input false). /* NOT EXCLUSIVE-LOCK */

   if Error_state then return.

   is-internal = Internal.

END PROCEDURE.

PROCEDURE nr_can_discard:
   /* Report whether discard is allowed. */
   define input parameter p-seq-id as character no-undo.
   define output parameter can-discard as logical no-undo.

   run nr_load
      (input p-seq-id,
       input false). /* NOT EXCLUSIVE-LOCK */

   if Error_state then return.

   can-discard = Discard_allowed.

END PROCEDURE.

PROCEDURE nr_can_void:
   /* Report whether void is allowed. */
   define input parameter p-seq-id as character no-undo.
   define output parameter can-void as logical no-undo.

   run nr_load
      (input p-seq-id,
       input false). /* NOT EXCLUSIVE-LOCK */

   if Error_state then return.

   can-void = Void_allowed.

END PROCEDURE.


PROCEDURE nr_check_error:
   /* Query the error state of NRM. */
   define output parameter state as logical.
   define output parameter errnum as integer.

   state = error_state.
   errnum = error_nbr.

END PROCEDURE.

PROCEDURE nr_clear_error:
   /* Clear the error state of the sequence. */
   error_state = false.
   error_nbr = 0.
END PROCEDURE.



PROCEDURE nr_unpack:
   /* Parse a value out of a comma-delimitted string.
      Modifies the source string: the modified string contains the
      remainder of the original source string, minus the parsed value. */
   define input-output parameter src as character no-undo.
   define output parameter val as character no-undo.

   define variable pos as integer no-undo.
   define variable delim as character initial "," no-undo.


   pos = index (src, delim).
   val = substring (src, 1, pos - 1).
   src = substring (src, pos + 1).

END PROCEDURE.


PROCEDURE nr_seg_make:

   define input parameter seg-type as character.
   define output parameter p-seg as recid.


   if seg-type = "1" then do:
      run seg_make_int (output p-seg).
   end.
   else if seg-type = "2" then do:
      run seg_make_date (output p-seg).
   end.
   else if seg-type = "3" then do:
      run seg_make_fiscal (output p-seg).
   end.
   else if seg-type = "4" then do:
      run seg_make_fixed (output p-seg).
   end.
/*SS 20080713 - B*/
	 else if seg-type = "5" then do:
      run seg_make_xdate (output p-seg).
   end.
/*SS 20080713 - E*/   
   else do:
      /* Invalid segment type. */
      Error_state = true.
      Error_nbr = 2921. /* Invalid segment type */
   end.

END PROCEDURE.


PROCEDURE nr_check_unique:
   /* Test that the sequence is unique for the target dataset.*/
   define output parameter is-unique as logical initial true no-undo.

   define variable o-min as character no-undo.
   define variable o-max as character no-undo.
   define variable n-min as character no-undo.
   define variable n-max as character no-undo.
   define variable new-valmask as character no-undo.
   define variable old-valmask as character no-undo.
   define variable def-match   as logical initial true no-undo.
   define variable type        as character no-undo.
   define variable rank        as character no-undo.
   define variable min         as character no-undo.
   define variable max         as character no-undo.
   define variable val         as character no-undo.
   define variable fmt         as character no-undo.
   define variable segtype     as character no-undo.
   define variable segrank     as character no-undo.
   define variable segmin      as character no-undo.
   define variable segmax      as character no-undo.
   define variable segval      as character no-undo.
   define variable segfmt      as character no-undo.
   define variable old-seg-fmt as character no-undo.
   define variable old-t-date  as date no-undo.

   Valuemask = "".

   for each segment where seg_attached by seg_nbr:
      Valuemask = Valuemask + seg_valuemask.
   end.

   nrmstr-loop:
   for each nr_mstr where nr_domain = global_domain and
                          nr_dataset = vDataset
   no-lock:

      if nr_seqid = Current_id
         then next.

      new-valmask = Valuemask.
      old-valmask = nr_valuemask.

      is-unique = false.

      /* Sequence definition match check */
      if nr_segcount = Segment_count then do:

         assign
            type  = nr_seg_type
            rank  = nr_seg_rank
            min   = nr_seg_min
            max   = nr_seg_max
            fmt   = nr_seg_format
            val   = nr_seg_value.

         for each segment where seg_attached by seg_nbr:

            run nr_unpack ( input-output type, output segtype ).
            run nr_unpack ( input-output rank, output segrank ).
            run nr_unpack ( input-output fmt, output segfmt ).
            run nr_unpack ( input-output val, output segval ).

            if seg_type <> segtype
            or (seg_rank <> "2"           /* 2 = INCREMENTING */
                and seg_format <> segfmt) /* FORMAT IS DIFFERENT */
            or (seg_rank = "3"            /* FIXED */
                and segval <> seg_value)  /* FIXED VALUE IS DIFFERENT */
            then
               def-match = false.

         end.

         if def-match then do:

            new-valmask = "".
            assign
               min = nr_seg_min
               max = nr_seg_max.

            for each segment where seg_attached by seg_nbr:

               run nr_unpack ( input-output min, output segmin ).
               run nr_unpack ( input-output max, output segmax ).

               if seg_rank = "0" or seg_rank = "1" then do:

                  /* Date-driven */
                  if seg_type = "2" then do:

                     old-seg-fmt = seg_format.
                     old-t-date = Trans_effdate.

                     if index(old-seg-fmt,"Y") > 0 then
                        seg_format = "Y4".
                     if index(old-seg-fmt,"M") > 0 then
                        seg_format = seg_format + "M".
                     if index(old-seg-fmt,"D") > 0 then
                        seg_format = seg_format + "D".
                     if index(old-seg-fmt,"W") > 0 then
                        seg_format = seg_format + "W".

                     Trans_effdate = Effdate.
                     run seg_format_date (recid(segment),output n-min).
                     Trans_effdate = Expdate.
                     run seg_format_date (recid(segment),output n-max).
                     Trans_effdate = nr_effdate.
                     run seg_format_date (recid(segment),output o-min).
                     Trans_effdate = (if nr_exp_date = ?
                                      then hi_date else nr_exp_date).
                     run seg_format_date (recid(segment),output o-max).
                     seg_format = old-seg-fmt.
                     Trans_effdate = old-t-date.

                  end.

                  /* Fiscal date */
                  else if seg_type = "3" then do:

                     old-seg-fmt = seg_format.

                     if index(old-seg-fmt,"Y") > 0 then seg_format = "Y".
                     if index(old-seg-fmt,"P3") > 0
                        then seg_format = seg_format + "P3".
                     else if index(old-seg-fmt,"P") > 0
                        then seg_format = seg_format + "P".

                     old-t-date  = Trans_effdate.
                     Trans_effdate = Effdate.
                     run seg_format_fiscal (recid(segment),output n-min).
                     Trans_effdate = Expdate.
                     run seg_format_fiscal (recid(segment),output n-max).
                     Trans_effdate = nr_effdate.
                     run seg_format_fiscal (recid(segment),output o-min).
                     Trans_effdate = (if nr_exp_date = ?
                                      then hi_date else nr_exp_date).
                     run seg_format_fiscal (recid(segment),output o-max).
                     seg_format = old-seg-fmt.
                     Trans_effdate = old-t-date.

                  end.

/*SS 20080713 - B*/
									/* xDate-driven */
                  if seg_type = "5" then do:

                     old-seg-fmt = seg_format.
                     old-t-date = Trans_effdate.

                     if index(old-seg-fmt,"Y") > 0 then
                        seg_format = "Y4".
                     if index(old-seg-fmt,"M") > 0 then
                        seg_format = seg_format + "M".
                     if index(old-seg-fmt,"D") > 0 then
                        seg_format = seg_format + "D".
                     if index(old-seg-fmt,"W") > 0 then
                        seg_format = seg_format + "W".

                     Trans_effdate = Effdate.
                     run seg_format_xdate (recid(segment),output n-min).
                     Trans_effdate = Expdate.
                     run seg_format_xdate (recid(segment),output n-max).
                     Trans_effdate = nr_effdate.
                     run seg_format_xdate (recid(segment),output o-min).
                     Trans_effdate = (if nr_exp_date = ?
                                      then hi_date else nr_exp_date).
                     run seg_format_xdate (recid(segment),output o-max).
                     seg_format = old-seg-fmt.
                     Trans_effdate = old-t-date.

                  end.
/*SS 20080713 - E*/

               end.

               else if seg_rank = "2" then do:
                  /* RIGHT-JUSTIFY, ZERO-FILL, INTEGER VALUES */
                  n-min = fill("0",9 - length(seg_min)) + seg_min.
                  n-max = fill("0",9 - length(seg_max)) + seg_max.
                  o-min = fill("0",9 - length(segmin)) + segmin.
                  o-max = fill("0",9 - length(segmax)) + segmax.
               end.

               if not (((n-min <= o-max and n-min >= o-min) or
                        (n-max <= o-max and n-max >= o-min)) or
                       ((o-min <= n-max and o-min >= n-min) or
                        (o-max <= n-max and o-max >= n-min)))
               then is-unique = true.

            end. /* For each segment */

         end.    /* If sequence definition matches */

      end.       /* If same segment count */

      /* Character by Character Uniqueness check */
      do while not is-unique and new-valmask > "":

         n-min = substring(new-valmask,1, 1).
         n-max = substring(new-valmask,2, 1).
         o-min = substring(old-valmask,1, 1).
         o-max = substring(old-valmask,2, 1).

         if not ((( n-min >= o-min and n-min <= o-max ) or
                  ( n-max >= o-min and n-max <= o-max )) or
                 (( o-min >= n-min and o-min <= n-max ) or
                  ( o-max >= n-min and o-max <= n-max )))
         then is-unique = true.

         new-valmask = substring(new-valmask,3).
         old-valmask = substring(old-valmask,3).

      end.

      if is-unique = false
      then
         leave nrmstr-loop.

   end.  /* For each nr_mstr with matching dataset */

END PROCEDURE.

PROCEDURE nr_register_max_value:
   /* INTERNAL PROCEDURE TO RECORD THE HIGHEST SEQUENCE NUMBER USED */
   /* FOR THE PERIOD OF THE PREVIOUS TRANSACTION IN THE CASE OF A   */
   /* DATE-DRIVEN CONTROL SEGMENTED SEQUENCE.                       */

   define input parameter l_old_seq_nbr like nrh_number  no-undo.
   define input parameter l_old_non_inc like nrh_non_inc no-undo.
   define input parameter l_old_inc     like nrh_inc     no-undo.

   find first nrh_hist
        where nrh_domain = global_domain
          and nrh_seqid = current_id + "," + l_old_non_inc
   exclusive-lock no-error.

   if available nrh_hist then
      assign
         nrh_number = l_old_seq_nbr
         nrh_inc    = l_old_inc
         nrh_date   = today.

   else do:

      create nrh_hist.
      assign
         nrh_domain  = global_domain
         nrh_seqid   = current_id + "," + l_old_non_inc
         nrh_number  = l_old_seq_nbr
         nrh_non_inc = l_old_non_inc
         nrh_inc     = l_old_inc
         nrh_date    = today.

   end. /* IF NOT AVAILABLE NRH_HIST */

   if recid(nrh_hist) = ? then .

   release nrh_hist.

END PROCEDURE. /* NR_REGISTER_MAX_VALUE */

/* Dispense, Validate, Discard, Void, Set_Next, Mark_printed             */
{nrmsu.i}


/*  SEGMENT TYPES */
{nrint.i}        /* Integer */
/* ss 20071203 - b */
/*
{nrdate.i}       /* Date */
*/
{xxnrdate.i}
/* ss 20071203 - e */
{nrfiscal.i}     /* GL Fiscal Period */
{nrfixed.i}      /* Fixed Value */
/*SS 20080713 - B*/
{xxnrxdate.i}
/*SS 20080713 - E*/