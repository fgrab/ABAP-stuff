    DATA: lr_send_request       TYPE REF TO cl_bcs.
    DATA: text                  TYPE bcsy_text.
    DATA: lr_document           TYPE REF TO cl_document_bcs.
    DATA: lr_sender             TYPE REF TO cl_sapuser_bcs.
    DATA: lr_recipient          TYPE REF TO if_recipient_bcs.
    DATA: lx_bcs_exception      TYPE REF TO cx_bcs.
    DATA: lf_sent_to_all        TYPE os_boolean.
    DATA: lf_length             TYPE so_obj_len.

    TRY.
"# create send request
        lr_send_request = cl_bcs=>create_persistent( ).

"# create document 
*     create lr_document from internal table with text
        lf_length = lines( it_text ) * 255.
        lr_document = cl_document_bcs=>create_document(
                        i_type    = 'RAW'
                        i_text    = it_text
                        i_length  = lf_length
                        i_subject = if_subject ).

"# add document to request
        CALL METHOD lr_send_request->set_document( lr_document ).
"# set sender
        lr_sender = cl_sapuser_bcs=>create( sy-uname ).
        CALL METHOD lr_send_request->set_sender
          EXPORTING
            i_sender = lr_sender.

"# add recipient (email address)
        lr_recipient = cl_cam_address_bcs=>create_internet_address(
                                          if_email ).

"# add recipient to send request
        CALL METHOD lr_send_request->add_recipient
          EXPORTING
            i_recipient = lr_recipient
            i_express   = 'X'.

"# send document
        CALL METHOD lr_send_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = rf_result ).

        COMMIT WORK.


"# exception handling
      CATCH cx_bcs INTO lx_bcs_exception.
        WRITE: TEXT-001.
        WRITE: TEXT-002, lx_bcs_exception->error_type.
        EXIT.

    ENDTRY.
