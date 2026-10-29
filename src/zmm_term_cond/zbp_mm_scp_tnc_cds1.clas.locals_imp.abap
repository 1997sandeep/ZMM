CLASS lhc_zmm_tnc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_tnc RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zmm_tnc.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zmm_tnc.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zmm_tnc.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmm_tnc RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmm_tnc.

ENDCLASS.

CLASS lhc_zmm_tnc IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_rabill TYPE zmmt_scp_tnc1,
           msg       TYPE string,
           lv_xml    TYPE string,
           template  TYPE string,
           result12  TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_rabill-ebeln = <ls_ra_bill>-zinwo.
      ls_rabill-zwo_desc = <ls_ra_bill>-ZwoDesc.
      ls_rabill-zcurr = 'INR'.

      MODIFY zmmt_scp_tnc1 FROM @ls_rabill.




    ENDLOOP.

  ENDMETHOD.

  METHOD update.
    DATA : ls_rabill TYPE zmmt_scp_tnc1,
           msg       TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_rabill-zcurr = 'INR'.
      ls_rabill-ebeln = <ls_ra_bill>-zinwo.
      MODIFY zmmt_scp_tnc1 FROM @ls_rabill.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
    DATA : ls_rabill TYPE zmmt_scp_tnc1,
           msg       TYPE string.

    LOOP AT keys INTO DATA(lv_key).
    ENDLOOP.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_scp_tnc_cds1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_scp_tnc_cds1 IMPLEMENTATION.

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
