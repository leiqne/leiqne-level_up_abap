@EndUserText.label: 'Status Value Help'
@ObjectModel.dataCategory: #VALUE_HELP
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZEGUI_I_STATUS_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(
       p_domain_name: 'ZEGUI_STATUS'
  )
{
  key value_low as Status,
      text      as StatusText
}
where language = $session.system_language;
