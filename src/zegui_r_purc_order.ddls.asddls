@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional CDS'
@Metadata.ignorePropagatedAnnotations: false
define root view entity  ZEGUI_R_PURC_ORDER
as select from  ZEGUI_I_PURC_ORDER
composition [0..*] of ZEGUI_R_PO_ITEM as _Items
association [0..1] to ZEGUI_I_PO_SUM as _Total 
on $projection.PoId = _Total.PoId

association [1..1] to ZEGUI_r_BUYER as _Buyer
on $projection.BuyerId = _Buyer.BuyerId
{
    key PoId,
    DeliveryDate,
    OrderDate,
    Status,
    CurrencyCode,
    BuyerId
    
    /* Associations */
    ,_Items,_Total, _Buyer
}
