@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional PO ITM'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZEGUI_R_PO_ITEM
as select from ZEGUI_I_PO_ITEM
association to parent ZEGUI_R_PURC_ORDER as _Header 
on $projection.PoId= _Header.PoId
{
    key PoItemId,
    PoId,
    Productname,
    Quantity,
    Currencycode,
    Unitprice
    
    /* Associations */
    ,_Header
}
