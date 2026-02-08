
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Buyer Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZEGUI_C_BUYER as select from ZEGUI_r_BUYER
{
    key BuyerId,
    FullName,
    Email
}
