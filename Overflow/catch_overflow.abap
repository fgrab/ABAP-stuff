DATA: lr_ref   TYPE REF TO data,
      lx_error TYPE REF TO cx_sy_arithmetic_overflow,
      lf_text  TYPE string.

TRY.
  <ziel> = <quelle> * lf_umren / lf_umrez.
  CATCH cx_sy_arithmetic_overflow INTO lx_error.
    lr_ref = cl_abap_exceptional_values=>get_max_value( <ziel> ).
    IF lr_ref IS BOUND.
      ASSIGN lr_ref->* TO <ziel>.
    ENDIF.
    lf_text = lx_error->if_message~get_text( ).
    MESSAGE s000(0k) WITH lf_text.
ENDTRY.
