CLASS lhc_zmm_mbsheet DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_mbsheet RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zmm_mbsheet.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zmm_mbsheet.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zmm_mbsheet.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmm_mbsheet RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmm_mbsheet.

ENDCLASS.

CLASS lhc_zmm_mbsheet IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_rabill TYPE zmmt_rab_mbsheet,
           lt_rabill TYPE STANDARD TABLE OF zmmt_rab_mbsheet,
           msg       TYPE string,
           lv_xml    TYPE string,
           template  TYPE string,
           result12  TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_rabill-zcurr = 'INR'.


      MODIFY zmmt_rab_mbsheet FROM @ls_rabill.

     cLEAr : ls_rabill.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA : ls_rabill TYPE zmmt_rab_mbsheet,
           msg       TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_rabill-zcurr = 'INR'.
      MODIFY zmmt_rab_mbsheet FROM @ls_rabill.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_RA_BILL_MBSHEET_CDS1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_RA_BILL_MBSHEET_CDS1 IMPLEMENTATION.

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
