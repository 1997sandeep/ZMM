@AbapCatalog.sqlViewName: 'ZMMAPPROVER'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver Display Screen'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZMM_RABILL_PAY_ABS_APPROVER
  as select from zmmt_scp_pa_aprl           as a
    inner join   ZMM_RABILL_PAYABST_DISPLAY as b on  a.ra_bill_no  = b.Rabillno
                                                 and a.appr_status = 'INPROCESS'
                                                 and a.user_name   = $session.user
{
  key a.ra_bill_no as Rabillno,
      a.app_level  as AppLevel,
      b.Ebeln,
      b.Rabillfrom,
      b.Rabillto,
      b.Supplier,
      b.SupplierName,
      b.Plant,
      b.PlantName,
      b.Region,
      b.State,
      b.Gstin,
      b.PAN,
      b.GlAccNo,
      b.VendorInvoice,
      b.HouseBankId,
      b.AccountId,
      b.BillDate,
      b.PostingDate,
      b.CompanyCode,
      b.CompanyName,
      b.Flag,
      b.BusinessPlace,
      b.SectionCode
}
group by
  a.ra_bill_no,
  a.app_level,
  b.Ebeln,
  b.Rabillfrom,
  b.Rabillto,
  b.Supplier,
  b.SupplierName,
  b.Plant,
  b.PlantName,
  b.Region,
  b.State,
  b.Gstin,
  b.PAN,
  b.GlAccNo,
  b.VendorInvoice,
  b.HouseBankId,
  b.AccountId,
  b.BillDate,
  b.PostingDate,
  b.CompanyCode,
  b.CompanyName,
  b.Flag,
  b.BusinessPlace,
  b.SectionCode
