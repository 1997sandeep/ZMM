@AbapCatalog.sqlViewName: 'ZMM_SESNO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch SES No for display'
define view ZMM_SES_NO
  with parameters
    wo      : ebeln,
    zrcount : zrcount
  as select from    zmmt_scp_rabill1         as a
    left outer join I_ServiceEntrySheetAPI01 as b on a.ra_bill_no = b.ServiceEntrySheetName
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
