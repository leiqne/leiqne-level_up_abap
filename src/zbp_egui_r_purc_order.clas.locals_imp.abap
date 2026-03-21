CLASS lsc_zegui_r_purc_order DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zegui_r_purc_order IMPLEMENTATION.

  METHOD adjust_numbers.
    SELECT
    MAX( po_id )
    FROM zegui_purc_order
    INTO @DATA(lv_max).

    LOOP AT mapped-zegui_r_purc_order REFERENCE INTO DATA(map).
      map->PoId = lv_max + 1.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

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
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zegui_r_purc_order RESULT result.
    METHODS SetDefaultCurrencyCode FOR DETERMINE ON SAVE
      IMPORTING keys FOR zegui_r_po_item~SetDefaultCurrencyCode.

    METHODS is_update_allowed RETURNING VALUE(update_allowed) TYPE abap_bool.

ENDCLASS.

CLASS lhc_ZEGUI_R_PURC_ORDER IMPLEMENTATION.

  METHOD is_update_allowed.
    "some internal logic, returning this just for demo purposes
    update_allowed = abap_false.
  ENDMETHOD.

  METHOD get_instance_authorizations.

    DATA: update_requested TYPE abap_bool,
          update_granted   TYPE abap_bool.

    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(current_status)
    FAILED failed.

    CHECK current_status IS NOT INITIAL.

    "update operation?
    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
    requested_authorizations-%action-Edit = if_abap_behv=>mk-on THEN
    abap_true ELSE abap_false ).

    LOOP AT current_status ASSIGNING FIELD-SYMBOL(<lfs_currentstatus>).
      IF <lfs_currentstatus>-Status <> 'CANCELLED'.
        IF update_requested = abap_true.
          update_granted = is_update_allowed( ).
          IF update_granted = abap_false.
            APPEND VALUE #( %tky = <lfs_currentstatus>-%tky ) TO failed-zegui_r_purc_order.
            APPEND VALUE #( %tky = keys[ 1 ]-%tky
            %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'No  authotrization to update status :( ' ) ) TO reported-zegui_r_purc_order.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
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
    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    FIELDS ( Status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(orders).

    MODIFY ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    UPDATE FIELDS ( status )
    WITH VALUE #(
      FOR order IN orders
      WHERE ( status IS INITIAL )
      ( %tky   = order-%tky
        status = 'APPROVED' )
    ).
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

    "Change to given status
    MODIFY ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    UPDATE FIELDS ( Status )
    WITH VALUE #( FOR key IN keys ( %key-PoId = key-PoId
    Status = key-%param-Status ) )
    REPORTED reported
    FAILED failed.

    "intermediate variable to return and refresh UI
    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
  ENTITY zegui_r_purc_order
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(updated_orders).

    "Map for result and returns the right values
    result = VALUE #( FOR order IN updated_orders
                      ( %tky = order-%tky
                        %param-PoId = order-PoId ) ).


    " chanage into CANCELLED
*    LOOP AT orders INTO DATA(order).
*      IF order-Status = 'CANCELLED'.
*        APPEND VALUE #(
*        %tky = order-%tky
*        %msg = new_message_with_text(
*               severity = if_abap_behv_message=>severity-error
*                text     = |This PO is already cancelled|
*         ) ) TO reported-zegui_r_purc_order.
*        CONTINUE.
*      ENDIF.
*      MODIFY ENTITIES OF zegui_r_purc_order IN LOCAL MODE
*      ENTITY zegui_r_purc_order
*      UPDATE FIELDS ( Status )
*      WITH VALUE #(
*      ( %tky = order-%tky
*      Status = 'CANCELLED'   )
*      ).
*      " return the results
*      APPEND VALUE #( %tky = order-%tky %param-PoId = order-PoId ) TO result.
*    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
    ENTITY zegui_r_purc_order
    FIELDS ( Status )
    WITH VALUE #( FOR key IN keys
    ( %key-PoId = key-PoId ) )
    RESULT DATA(result_order).

    LOOP AT result_order INTO DATA(ls_result).
      DATA(lv_modify_status) = COND #( WHEN ls_result-Status EQ 'CANCELLED'
          THEN if_abap_behv=>fc-o-disabled
          ELSE if_abap_behv=>fc-o-enabled ).

      result = VALUE #( (
      %tky = ls_result-%tky
      %action-ChangeStatus = lv_modify_status  ) ).

      reported-zegui_r_purc_order = VALUE #( (
       %tky = ls_result-%tky
       %action-ChangeStatus = lv_modify_status
       %msg = new_message_with_text( text = 'Modify status not applicable to this instance(s)' ) ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD SetDefaultCurrencyCode.
    " Se aplica el read pq si se hace on key no tiene currency code por lo cual
    "no se puede filtrar por el currency code
    READ ENTITIES OF zegui_r_purc_order IN LOCAL MODE
      ENTITY zegui_r_po_item
        FIELDS ( currencycode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    MODIFY ENTITIES OF zegui_r_purc_order IN LOCAL MODE
      ENTITY zegui_r_po_item
        UPDATE FIELDS ( currencycode )
        WITH VALUE #( FOR item IN lt_items WHERE ( currencycode IS INITIAL )
                      ( %tky = item-%tky
                        currencycode = 'USD' ) ).
  ENDMETHOD.

ENDCLASS.
