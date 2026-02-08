@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption PO ITM'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZEGUI_C_PO_ITM
as projection on ZEGUI_R_PO_ITEM
{
    @UI.hidden: true
    key PoItemId,
    
    @UI.hidden: true
    PoId,
    @UI.lineItem: [{ position: 10 }]
    @UI.identification: [{ position: 10 }]
    
    Productname,
    @UI.lineItem: [{ position:20 }]
     @UI.identification: [{ position: 20 }]
    Quantity,
    @UI.lineItem: [{ position:40 }]
     @UI.identification: [{ position: 40 }]
     @UI.hidden: true
    Currencycode,
    @UI.lineItem: [{ position:30 }]
     @UI.identification: [{ position: 30 }]
    Unitprice
    /* Associations */
    ,_Header: redirected to parent ZEGUI_C_PURC_ORDER
}
