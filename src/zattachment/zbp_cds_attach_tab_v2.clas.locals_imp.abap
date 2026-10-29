CLASS lhc_zattach_tab DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zattach_tab RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zattach_tab.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zattach_tab.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zattach_tab.

    METHODS read FOR READ
      IMPORTING keys FOR READ zattach_tab RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zattach_tab.

ENDCLASS.

CLASS lhc_zattach_tab IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_data TYPE zattach_tabb.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_attach>).

      ls_data = CORRESPONDING #( <ls_attach> MAPPING FROM ENTITY USING CONTROL ).

      ls_data-localcreatedat = sy-datum.
      ls_data-localcreatedby = sy-uname.

      ls_data-doc_no = <ls_attach>-docno.
      ls_data-doc_type = <ls_attach>-doctype.
      ls_data-delflag = <ls_attach>-delflag.
      ls_data-file_name = <ls_attach>-filename.
      ls_data-file_size = <ls_attach>-filesize.
      ls_data-file_contents = <ls_attach>-filecontents.
      ls_data-file_type = <ls_attach>-filetype.

      IF ls_data-delflag = 'X'.
        DELETE zattach_tabb FROM @ls_data.
      else.
        MODIFY zattach_tabb FROM @ls_data.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.

  METHOD update.
    DATA : ls_data TYPE zattach_tabb.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_attach>).
      ls_data = CORRESPONDING #( <ls_attach> MAPPING FROM ENTITY USING CONTROL ).
      ls_data-doc_no = <ls_attach>-docno.
      ls_data-doc_type = <ls_attach>-doctype.
      ls_data-delflag = <ls_attach>-delflag.
      ls_data-file_name = <ls_attach>-filename.
      ls_data-file_size = <ls_attach>-filesize.
      ls_data-file_contents = <ls_attach>-filecontents.
      ls_data-file_type = <ls_attach>-filetype.
      IF ls_data-delflag = 'X'.

        DELETE zattach_tabb FROM @ls_data.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcds_attach_tab_v2 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_attach_tab_v2 IMPLEMENTATION.

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
