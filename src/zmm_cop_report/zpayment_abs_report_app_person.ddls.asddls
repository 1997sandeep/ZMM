@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For approval persion name'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPAYMENT_ABS_REPORT_APP_PERSON as select from ZMM_RABILL_PAY_APPROVAL_DSP
{
    key  RaBillNo ,
        max( Levell ) as levell
} where Status <> ''
group by  RaBillNo
