@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SES no'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_SESNO_VAL  
with parameters
    wo      : ebeln,
    zrcount : zrcount
  as select from    zmmt_scp_rabill1         as a
    left outer join I_ServiceEntrySheetAPI01 as b on a.ra_bill_no = b.ServiceEntrySheetName
                                                  and b.IsDeleted = '' 
{
  key a.ebeln,
  key a.rcount,
      a.ra_bill_no,
      b.ServiceEntrySheet
}
where
      a.ebeln  = $parameters.wo
  and a.rcount = $parameters.zrcount
group by
  a.ebeln,
  a.rcount,
  a.ra_bill_no,
  b.ServiceEntrySheet
