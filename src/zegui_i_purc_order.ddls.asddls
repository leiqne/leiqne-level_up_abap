@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface purchase order'
@Metadata.ignorePropagatedAnnotations: false
define root view entity ZEGUI_I_PURC_ORDER as select from zegui_purc_order
composition [0..*] of ZEGUI_I_PO_ITEM as _Items
association [1..1] to ZEGUI_I_BUYER as _Buyer
on $projection.BuyerId =_Buyer.BuyerId
{
    key po_id as PoId,
    deliverydate as DeliveryDate,
    orderdate as OrderDate,
    status as Status,
    currencycode as CurrencyCode
    ,_Items,

    buyer_id as BuyerId,
    _Buyer
}
