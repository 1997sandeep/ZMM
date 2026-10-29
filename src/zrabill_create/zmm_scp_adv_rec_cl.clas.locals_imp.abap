CLASS lhc_rabill_rec DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR rabill_rec RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE rabill_rec.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE rabill_rec.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE rabill_rec.

    METHODS read FOR READ
      IMPORTING keys FOR READ rabill_rec RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK rabill_rec.

ENDCLASS.

CLASS lhc_rabill_rec IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_adv_rec TYPE zmmt_scp_rab_rec,
           msg        TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_adv_rec = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_adv_rec-zcurr = 'INR'.
      MODIFY zmmt_scp_rab_rec FROM @ls_adv_rec.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA : ls_adv_rec TYPE zmmt_scp_rab_rec,
           msg        TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_adv_rec = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_adv_rec-adv_type = <ls_ra_bill>-AdvType.
      ls_adv_rec-ra_bill_no = <ls_ra_bill>-RaBillNo.
      ls_adv_rec-adv_rec = <ls_ra_bill>-AdvRec.
      ls_adv_rec-rec_this_bill = <ls_ra_bill>-RecThisBill.
      MODIFY zmmt_scp_rab_rec FROM @ls_adv_rec.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.

   DATA : WA TYPE   zmmt_scp_rab_rec,
       lt TYPE STANDARD TABLE OF zmmt_scp_rab_rec.

     loop at keys INTO data(wa_data) .
*     SELECT from ZMM_RABILL_PAYABST_DISPLAYITEM
*     FIELDS sum( thisbill ) as rec_pay
*     where Rabillno = @wa_data-RaBillNo and ItemCode in ( 'REWD','REMB','REMT' ,'EWMC' )
*     into @data(pay).
*     if pay =  0.
      WA-adv_type = wa_data-AdvType.
      WA-adv_rec  = wa_data-AdvRec.
      WA-ra_bill_no  = wa_data-RaBillNo.
      delete zmmt_scp_rab_rec FROM @WA.
      clear : Wa.
*      endif.
*      if pay =  0 .
      APPEND VALUE #( %tky = keys[ 1 ]-%tky
      %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-success
      text = 'Deleted Successfully'
    ) ) TO reported-rabill_rec.
*else.
APPEND VALUE #( %tky = keys[ 1 ]-%tky
      %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-error
      text = 'Payment Abstract already Created for this'
    ) ) TO reported-rabill_rec.
*    endif.
     ENDLOOP.



  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_scp_adv_rec DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_scp_adv_rec IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
