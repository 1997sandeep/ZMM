CLASS lhc_ZrMmtScpPaAppr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrMmtScpPaAppr RESULT result.

ENDCLASS.

CLASS lhc_ZrMmtScpPaAppr IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
