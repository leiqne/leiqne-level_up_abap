@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption purchase order'
@Metadata.ignorePropagatedAnnotations: false
define root view entity  ZEGUI_C_PURC_ORDER 
provider contract transactional_query
as projection on ZEGUI_R_PURC_ORDER
{

    key PoId,    
    OrderDate,
    DeliveryDate,
    Status,
    CurrencyCode,
    
    _Total.TotalPrice as TotalPrice,
    BuyerId,
    _Buyer.FullName as BuyerFullName
    ,_Items: redirected to composition child ZEGUI_C_PO_ITM
    ,_Buyer
}
