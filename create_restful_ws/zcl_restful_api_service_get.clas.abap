class ZCL_RESTFUL_API_SERVICE_GET definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_RESTFUL_API_SERVICE_GET IMPLEMENTATION.


method if_http_extension~handle_request.

  "$. Region Data Defination
  data: lv_response         type string,
        lv_json_request     type string,
        lv_json_response    type string,
        lv_json_xresponse   type xstring.

  data: lv_path        type string,
        lv_meth        type string,
        lv_method      type ihttpval.

  types : begin of ty_import,
           veri type string,
          end of ty_import.
  data : ls_import type ty_import.

  types : begin of ty_export,
            mesaj type string,
          end of ty_export.
  data : ls_send_object type ty_export.

*
*  data : ls_send_object   type zhbwm_ws_s084,
*         ls_parsed_object type zhbwm_ws_s084.
  "$. Endregion Data Defination

  lv_meth = server->request->get_header_field( name = '~request_method' ).
  shift lv_path left by 1 places.

  lv_path = server->request->get_header_field( name = '~PATH_INFO' ).

  lv_json_request = lv_path.


  translate lv_meth   to lower case.
  translate lv_method to lower case.


  replace all occurrences of cl_abap_char_utilities=>cr_lf
    in lv_json_request
    with ''.

  replace all occurrences of cl_abap_char_utilities=>horizontal_tab
    in lv_json_request
    with ''.

  replace all occurrences of cl_abap_char_utilities=>vertical_tab
    in lv_json_request
    with ''.

  replace all occurrences of cl_abap_char_utilities=>newline
    in lv_json_request
    with ''.

  replace all occurrences of cl_abap_char_utilities=>form_feed
    in lv_json_request
    with ''.

  replace all occurrences of cl_abap_char_utilities=>backspace
    in lv_json_request
    with ''.


  cl_fdt_json=>json_to_data( exporting iv_json = lv_json_request
                             changing  ca_data = ls_import ).


  "$. Region events
      if ls_import-veri is not initial.
         ls_send_object-mesaj = 'Basarili'.
         else.
         ls_send_object-mesaj = 'Basarisiz'.
      endif.
  "$. Endregion events


    lv_json_response = cl_fdt_json=>data_to_json( ia_data = ls_send_object ).

  "$. Region response data

*  call function 'SCMS_STRING_TO_XSTRING'
*    exporting
*      text   = lv_json_response
*    importing
*      buffer = lv_json_xresponse
*    exceptions
*      failed = 1
*      others = 2.

  server->response->set_header_field( name  = 'Accept-Language' value = 'tr-TR' ).
  server->response->set_content_type( 'application/json' ).

*  server->response->set_status( code = lv_status_code reason = ls_response-message ).
*  server->response->set_data( data = lv_json_xresponse ). "
  server->response->set_cdata( data = lv_json_response ). "

  "$. Endregion response data

endmethod.
ENDCLASS.
