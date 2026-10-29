@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RaBill Document Posting Genrerated'
define root view entity ZMM_RABILL_PAY_ABS_ACCDOC
  as select from zmmt_scp_pa_h1               as a
    inner join   I_OperationalAcctgDocItem    as b on  a.ebeln              = b.PurchasingDocument
                                                   and b.PurchasingDocument is not initial
                                                   and a.bill_date = b.DocumentDate
                                                   and a.post_date = b.PostingDate
    inner join   I_ServiceEntrySheetAPI01     as c on  b.PurchasingDocument    = c.PurchaseOrder
                                                   and c.ServiceEntrySheetName = a.ra_bill_no
                                                   and c.ServiceEntrySheet     is not initial
                                                   and c.MaterialDocument      is not initial
    inner join   I_ServiceEntrySheetItemAPI01 as d on c.ServiceEntrySheet = d.ServiceEntrySheet
{
  key b.CompanyCode           as CompanyCode,
  key b.AccountingDocument    as PostedDocument,
  key b.PurchasingDocument    as PO,
  key c.ServiceEntrySheetName as RaBillNo,
  key c.Supplier              as lifnr,
      b.PostingDate           as PostedDate,
      b.DocumentDate          as DocumentDate,
      d.ServiceEntrySheet     as Ses
}
where
  b.AccountingDocument like '50%'
group by
  b.CompanyCode,
  b.AccountingDocument,
  b.PurchasingDocument,
  c.ServiceEntrySheetName,
  c.Supplier,
  b.PostingDate,
  b.DocumentDate,
  d.ServiceEntrySheet
