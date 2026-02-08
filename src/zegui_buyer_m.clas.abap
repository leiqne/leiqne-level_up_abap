CLASS zegui_buyer_m DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zegui_buyer_m IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA t_buyer TYPE zegui_buyer.
    TRY.
        t_buyer-buyer_id = cl_system_uuid=>create_uuid_x16_static( ).
        t_buyer-client = sy-mandt.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.
    t_buyer-full_name = 'WOLKSWAGEN'.
    t_buyer-email = 'WOLKSWAGEN@WOLKSWAGEN.com'.
    SELECT SINGLE full_name
    FROM zegui_buyer
    WHERE full_name = @t_buyer-full_name
    INTO @DATA(exist).

    IF sy-subrc = 0.
        out->write( 'Element already in db' ).
    ELSE.
        insert into zegui_buyer VALUES @t_buyer.
        commit work.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
