@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For approval persion name'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPAYMENT_ABS_REPORT_APP_PER1 as select from ZPAYMENT_ABS_REPORT_APP_PERSON as a
                             left outer join ZMM_RABILL_PAY_APPROVAL_DSP as b on a.RaBillNo = b.RaBillNo and a.levell = b.Levell
{
    key a.RaBillNo,
    a.levell,
    b.UserName,
    b.Status
}
