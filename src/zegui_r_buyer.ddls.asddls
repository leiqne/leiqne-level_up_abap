
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional buyer'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZEGUI_r_BUYER as select from ZEGUI_I_BUYER
{
    key BuyerId,
    FullName,
    Email
}
