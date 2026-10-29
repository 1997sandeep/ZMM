CLASS lhc_ZrMmtScpPaUser DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrMmtScpPaUser RESULT result.

ENDCLASS.

CLASS lhc_ZrMmtScpPaUser IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
