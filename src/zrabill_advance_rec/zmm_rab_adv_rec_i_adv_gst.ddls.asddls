@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Adv paid + GST for  advance recovery'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RAB_ADV_REC_I_ADV_GST 
  as select from zmmt_scp_rab_ad1         as a1
{
  key  a1.adv_type      as AdvType,
  key  a1.ebeln         as Ebeln,
  a1.adv_paid + a1.gst as adv_paid
}
