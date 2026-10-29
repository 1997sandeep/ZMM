CLASS lhc_ZrMmtScpBuscode DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrMmtScpBuscode RESULT result.

ENDCLASS.

CLASS lhc_ZrMmtScpBuscode IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
