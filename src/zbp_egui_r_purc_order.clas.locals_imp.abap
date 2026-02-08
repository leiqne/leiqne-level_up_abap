CLASS lhc_ZEGUI_R_PURC_ORDER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zegui_r_purc_order RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zegui_r_purc_order RESULT result.
    METHODS checkdates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zegui_r_purc_order~checkdates.
    METHODS setinitialstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zegui_r_purc_order~setinitialstatus.
    METHODS changestatus FOR MODIFY
      IMPORTING keys FOR ACTION zegui_r_purc_order~changestatus RESULT result.

ENDCLASS.

CLASS lhc_ZEGUI_R_PURC_ORDER IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD checkDates.
    DATA orders TYPE TABLE FOR READ RESULT zegui_r_purc_order.
    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order FIELDS ( DeliveryDate OrderDate )
    WITH CORRESPONDING #( keys )
    RESULT orders.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    IF orders IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT orders INTO DATA(order).
      IF order-DeliveryDate < order-OrderDate.
        APPEND VALUE #(
        %tky = order-%tky
        %msg = new_message(
        id = 'ZEGUI_MSG'
        number = '001'
        severity =  if_abap_behv_message=>severity-error

        v1 = |Delivery date must be >= order date|
        )
         ) TO reported-zegui_r_purc_order.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD SetInitialStatus.
    MODIFY ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    UPDATE FIELDS ( Status )
    WITH VALUE #( FOR key IN  keys
    ( %tky = key-%tky
     Status = 'Aproved' ) ).
  ENDMETHOD.

  METHOD ChangeStatus.
    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(orders).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT orders INTO DATA(order).
      IF order-Status = 'Cancelled'.
        APPEND VALUE #(
        %tky = order-%tky
        %msg = new_message_with_text(
               severity = if_abap_behv_message=>severity-error
                text     = |This PO is already cancelled|
         ) ) TO reported-zegui_r_purc_order.
        CONTINUE.
      ENDIF.
      MODIFY ENTITIES OF zegui_r_purc_order IN LOCAL MODE
      ENTITY zegui_r_purc_order
      UPDATE FIELDS ( Status )
      WITH VALUE #(
      ( %tky = order-%tky
      Status = 'Cancelled'   )
      ).
      " return the results
      APPEND VALUE #( %tky = order-%tky %param-PoId = order-PoId ) TO result.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
