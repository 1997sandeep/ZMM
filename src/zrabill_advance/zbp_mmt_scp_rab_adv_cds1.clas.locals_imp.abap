CLASS lhc_zmmt_scp_rab_adv_cds1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zscp_rab_adv RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zscp_rab_adv.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zscp_rab_adv.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zscp_rab_adv.

    METHODS read FOR READ
      IMPORTING keys FOR READ zscp_rab_adv RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zscp_rab_adv.

ENDCLASS.

CLASS lhc_zmmt_scp_rab_adv_cds1 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_rabill_ad1 TYPE zmmt_scp_rab_ad1,
           msg           TYPE string,
           count type string.

    data(sydatum1) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    data(syuzeit1) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.

    data sydatum type c LENGTH 8.
    data syuzeit type c LENGTH 8.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
    CONCATENATE syuzeit1+0(2) syuzeit1+3(2) syuzeit1+6(2) INTO syuzeit.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill_ad1>).
      ls_rabill_ad1 = CORRESPONDING #( <ls_ra_bill_ad1> MAPPING FROM ENTITY USING CONTROL ).

      CLEAR:ls_rabill_ad1-ra_bill_no.
      count = ls_rabill_ad1-rcount.
      CONDENSE count.
      CONCATENATE count '/' ls_rabill_ad1-ebeln INTO ls_rabill_ad1-ra_bill_no.
CONDENSE ls_rabill_ad1-ra_bill_no.
      ls_rabill_ad1-local_created_by = sy-uname.
      ls_rabill_ad1-local_last_changed_by = sy-uname.
      ls_rabill_ad1-last_changed_at = sydatum.

      if <ls_ra_bill_ad1>-AdvType = 'AGWD'
      or <ls_ra_bill_ad1>-AdvType = 'MACH'
      or <ls_ra_bill_ad1>-AdvType = 'MATR'
      or <ls_ra_bill_ad1>-AdvType = 'MOBI'.
      MODIFY zmmt_scp_rab_ad1 FROM @ls_rabill_ad1.
      ENDIF.
      CLEAR:ls_rabill_ad1.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA : ls_rabill_ad1 TYPE zmmt_scp_rab_ad1,
           msg           TYPE string.

    data(sydatum) = xco_cp=>sy->date( xco_cp_time=>time_zone->user   )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    data(syuzeit) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill_ad1>).

      ls_rabill_ad1-ra_bill_no = <ls_ra_bill_ad1>-RaBillNo.
      ls_rabill_ad1-adv_type   = <ls_ra_bill_ad1>-AdvType.
      ls_rabill_ad1-ebeln      = <ls_ra_bill_ad1>-Ebeln.
      ls_rabill_ad1-rcount     = <ls_ra_bill_ad1>-Rcount.
      ls_rabill_ad1-adv_paid   = <ls_ra_bill_ad1>-AdvPaid.


      ls_rabill_ad1-local_created_by = sy-uname.
      ls_rabill_ad1-local_last_changed_by = sy-uname.
      ls_rabill_ad1-last_changed_at = sydatum.

      MODIFY zmmt_scp_rab_ad1 FROM @ls_rabill_ad1.
      CLEAR:ls_rabill_ad1.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.


  DATA : WA TYPE   zmmt_scp_rab_ad1,
       lt TYPE STANDARD TABLE OF zmmt_scp_rab_ad1.

     loop at keys INTO data(wa_data) .

   DATA: po  TYPE string,
      po1 TYPE string,
      dummy TYPE string.

po = wa_data-RaBillNo.

SPLIT po AT '/' INTO dummy po1.

     SELECT SINGLE FROM I_PurchaseOrderAPI01
     FIELDS
     PurchaseOrder,
     ReleaseIsNotCompleted
     WHERE PurchaseOrder = @po1
     into @data(po_relase).

     if po_relase-ReleaseIsNotCompleted is  INITIAL.
     SELECT SINGLE FROM ZMM_SCP_TNC_H
     FIELDS
     PurchaseOrder
     WHERE PurchaseOrder = @po1
     into @data(tnc_check).

     if tnc_check is NOT INITIAL.
           SELECT SINGLE FROM zmm_rabill_payabst_display
     FIELDS
     Ebeln
     WHERE Rabillno = @wa_data-RaBillNo
     into @data(ABSTRACT_CHECK).

     IF ABSTRACT_CHECK IS INITIAL.
      WA-adv_type = wa_data-AdvType.
      WA-ra_bill_no  = wa_data-RaBillNo.
      delete zmmt_scp_rab_ad1 FROM @WA.
      clear : Wa.
      endif.
      endif.
      endif.
      if ABSTRACT_CHECK IS INITIAL .
      APPEND VALUE #( %tky = keys[ 1 ]-%tky
      %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-success
      text = 'Deleted Successfully '
    ) ) TO reported-zscp_rab_adv.
     elseif tnc_check is  INITIAL  .
     APPEND VALUE #( %tky = keys[ 1 ]-%tky
      %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-error
      text = 'Work order TNC not maintained.'
    ) ) TO reported-zscp_rab_adv.
     elseif ABSTRACT_CHECK is NOT INITIAL  .
     APPEND VALUE #( %tky = keys[ 1 ]-%tky
      %msg = new_message_with_text(
      severity = if_abap_behv_message=>severity-error
      text = ' Payment Abstract already created'
    ) ) TO reported-zscp_rab_adv.
    endif.



     ENDLOOP.


  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmmt_scp_rab_adv_cds1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmmt_scp_rab_adv_cds1 IMPLEMENTATION.

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
