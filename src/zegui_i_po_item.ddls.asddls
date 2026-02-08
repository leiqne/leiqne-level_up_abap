@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface PO Item'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZEGUI_I_PO_ITEM as select from zegui_po_item
association to parent ZEGUI_I_PURC_ORDER as _Header on $projection.PoId = _Header.PoId
{
    key po_item_id as PoItemId,
    po_id as PoId,
    productname as Productname,
    quantity as Quantity,
    currencycode as Currencycode,
    unitprice as Unitprice
   ,_Header
}
