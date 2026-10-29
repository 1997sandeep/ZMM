CLASS lhc_ZMB_DATA_DET DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zmb_data_det RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zmb_data_det RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE zmb_data_det.

    METHODS update FOR MODIFY
       entities FOR UPDATE zmb_data_det.

    METHODS delete FOR MODIFY
       keys FOR DELETE zmb_data_det.

    METHODS read FOR READ
       keys FOR READ zmb_data_det RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK zmb_data_det.

ENDCLASS.

CLASS lhc_ZMB_DATA_DET IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

   if 1 = 1.
  endif.
  ENDMETHOD.

  METHOD update.


  DATA : WA TYPE   zmeas_book_h_tbl,
       lt TYPE STANDARD TABLE OF zmeas_book_h_tbl.

     loop at entities INTO data(wa_data) .
      WA-ebeln = wa_data-ebeln.
      WA-mbno  = wa_data-mbno.
      WA-delflag  = 'X'.
      MODIFY zmeas_book_h_tbl FROM @WA.
      clear : Wa.
   ENDLOOP.
  ENDMETHOD.

  METHOD delete.


  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMB_DATA_DET DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMB_DATA_DET IMPLEMENTATION.

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
