@EndUserText.label: 'Change Status Parameter'
define abstract entity ZEGUI_A_CHANGESTATUS
{
    @Consumption.valueHelpDefinition: [{
        entity:{
            name: 'ZEGUI_I_STATUS_VH',
            element: 'Status'
        }
    }]
    @EndUserText.label: 'Status'
    Status: zegui_status;
}
