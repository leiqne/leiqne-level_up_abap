@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calc view for price'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZEGUI_I_PO_SUM as select from zegui_po_item
{
    
    key po_id as PoId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    cast ( sum( cast ( unitprice as abap.fltp ) * cast( quantity as abap.fltp ) ) as zegui_total_amount ) as TotalPrice,
    currencycode as CurrencyCode
}
group by 

po_id,
currencycode
