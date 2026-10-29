@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill dedcattion'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZRABILL_DED as select from zmmt_scp_rabill1
{
    key ra_bill_no,
    deduction1,
    deduction2,
    remark1,
    remark2
}
group by ra_bill_no,
    deduction1,
    deduction2,
    remark1,
    remark2
