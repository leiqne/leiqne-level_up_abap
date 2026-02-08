@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Buyer'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZEGUI_I_BUYER as select from zegui_buyer
{
    key buyer_id as BuyerId,
    full_name as FullName,
    email as Email
}
