@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For payment abstract report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPAYMENT_ABS_REPORT_HEADER as select from zmmt_scp_pa_h1
{
   key ra_bill_no,
   key wekrs,
   key ebeln,
   zplant_name,
   lifnr,
  zsupplier_name,
  case appr5
  when 'A'
  then 'APPROVE'
  when 'R'
  then 'Rejected'
  else 'INPROCESS'
  end as  ApprovalStatus,
  pan,
  gstin,
  post_date,
  bill_date,
  vendor_invoice
}
