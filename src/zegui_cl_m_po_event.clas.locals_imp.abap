CLASS lcl_event_handler DEFINITION
  INHERITING FROM cl_abap_behavior_event_handler.

  PRIVATE SECTION.
    METHODS on_order_created
        FOR ENTITY EVENT it_purchase_order  FOR orderTP~orderCreated.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_order_created.
    DATA lt_event_order TYPE STANDARD TABLE OF zegui_e_order WITH EMPTY KEY.
    DATA lt_event_item TYPE STANDARD TABLE OF zegui_e_item WITH EMPTY KEY.

    LOOP AT it_purchase_order ASSIGNING FIELD-SYMBOL(<ls_order_payload>).

      APPEND INITIAL LINE TO lt_event_order ASSIGNING FIELD-SYMBOL(<ls_event_order>).
      <ls_Event_order>-Po_Id = <ls_order_payload>-%param-poid2.
      <ls_Event_order>-buyer_id = <ls_order_payload>-%param-buyerid2.
      <ls_event_order>-currencycode = <ls_order_payload>-%param-currencycode2.
      <ls_event_order>-deliverydate = <ls_order_payload>-%param-deliveryDate2.
      <ls_event_order>-orderdate = <ls_order_payload>-%param-orderDate2.
      <ls_event_order>-status = <ls_order_payload>-%param-status2.

      SELECT * FROM zegui_tp_po_item
      WHERE PoId = @<ls_order_payload>-%param-PoId2
      INTO TABLE @DATA(lt_items).

      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item_payload>).

        APPEND INITIAL LINE TO lt_event_item ASSIGNING FIELD-SYMBOL(<ls_E_item>).

        <ls_e_item>-currencycode = <ls_item_payload>-Currencycode.
        <ls_e_item>-po_id = <ls_order_payload>-%param-poid2.
        <ls_E_item>-po_item_id = <ls_item_payload>-PoItemId.
        <ls_E_item>-productname = <ls_item_payload>-Productname.
        <ls_E_item>-quantity = <ls_item_payload>-Quantity.
        <ls_E_item>-unitprice = <ls_item_payload>-Unitprice.


        "no idea why is not working xd
        "loop at <ls_order_payload>-%param-_items_abs  assigniNG field-SYMBOL(<ls_item_payload>).
      ENDLOOP.

    ENDLOOP.

    IF lt_event_order IS NOT INITIAL.
      MODIFY zegui_E_order FROM TABLE @lt_event_order.
    ENDIF.

    IF lt_event_item IS NOT INITIAL.
      MODIFY zegui_e_item FROM TABLE @lt_event_item.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
