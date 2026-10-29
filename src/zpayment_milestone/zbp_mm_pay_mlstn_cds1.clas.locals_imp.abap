CLASS lhc_zmm_mlstn DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_mlstn RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zmm_mlstn.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zmm_mlstn.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zmm_mlstn.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmm_mlstn RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmm_mlstn.

ENDCLASS.

CLASS lhc_zmm_mlstn IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_rabill TYPE zmm_pay_mlstn,
           lt_rabill TYPE STANDARD TABLE OF zmm_pay_mlstn,
           msg       TYPE string,
           lv_xml    TYPE string,
           template  TYPE string,
           result12  TYPE string.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      ls_rabill-zcurr = 'INR'.


      MODIFY zmm_pay_mlstn FROM @ls_rabill.

     cLEAr : ls_rabill.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    DATA : ls_rabill TYPE zmm_pay_mlstn,
           msg       TYPE string.



       DATA : WA_milestone TYPE   zmm_pay_mlstn,
            it_milestone TYPE STANDARD TABLE OF zmm_pay_mlstn.

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_mlsn>).
        WA_milestone-ebelp = <ls_mlsn>-Ebelp.
        WA_milestone-ebeln = <ls_mlsn>-Ebeln.
        WA_milestone-split_item_no = <ls_mlsn>-SplitItemNo.
        WA_milestone-split_item = <ls_mlsn>-SplitItem.
        WA_milestone-percentage = <ls_mlsn>-Percentage.

      MODIFY zmm_pay_mlstn FROM  @WA_milestone.
        clear : WA_milestone.
      ENDLOOP.


*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
*      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
*      ls_rabill-zcurr = 'INR'.
*      MODIFY zmm_pay_mlstn FROM @ls_rabill.
*    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

  DATA : WA_milestone TYPE   zmm_pay_mlstn,
            it_milestone TYPE STANDARD TABLE OF zmm_pay_mlstn.

      LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_mlsn>).
        WA_milestone-ebelp = <ls_mlsn>-Ebelp.
        WA_milestone-ebeln = <ls_mlsn>-Ebeln.
        WA_milestone-split_item_no = <ls_mlsn>-SplitItemNo.

      delete zmm_pay_mlstn FROM @WA_milestone.
      clear : WA_milestone.
     ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_PAY_MLSTN_CDS1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_PAY_MLSTN_CDS1 IMPLEMENTATION.

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
