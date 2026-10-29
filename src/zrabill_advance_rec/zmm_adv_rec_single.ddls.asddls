@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'rabill advance recovery'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_ADV_REC_Single 
   as select from zmmt_scp_rab_rec
{
  key ra_bill_no as RaBillNo,
  key adv_type as AdvType,
  key adv_rec as AdvRec,
  ebeln as Ebeln
}
