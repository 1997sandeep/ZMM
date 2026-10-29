@AbapCatalog.sqlViewName: 'ZMMCOPREP2'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COP Report2'
@Metadata.allowExtensions: true
define view ZMM_COP_REPORT2
  as select from    ZMM_RABILL_REPORT1        as a
    left outer join ZPAYMENT_ABS_REPORT_HEADER            as b on a.RaBillNo = b.ra_bill_no
    left outer join ZMM_RABILL_PAY_ABS_ACCDOC as c on  a.RaBillNo  = c.RaBillNo
                                                   and b.ebeln     = c.PO
                                                   and b.lifnr     = c.lifnr
                                                   and b.post_date = c.PostedDate
                                                   and b.bill_date = c.DocumentDate
    left outer join  ZPAYMENT_ABS_REPORT_APP_PER1 as D on a.RaBillNo = D.RaBillNo
{
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZMM_RABILL_PAY_ABS_VALD', element: 'RaBillNo'} }]
  key a.RaBillNo,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_COMPANYCODE', element: 'CompanyCode'} }]
   key   b.wekrs             as CompanyCode,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_Plant', element: 'Plant'} }]
  key    b.wekrs                   as Plant,
   key   b.zplant_name             as ProjectName,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_Supplier', element: 'Supplier'} }]
   key   b.lifnr                   as Vendor,
   key   b.zsupplier_name          as VendorName,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zmm_f4_ebeln', element: 'PurchaseOrder'} }]
   key   b.ebeln                   as WoNumber,
    key   D.Status as ApprovalStatus,
   key   D.UserName,
    key  b.pan                     as VendorPan,
   key   b.gstin                   as VendorGstin,
   key   b.post_date               as PostingDate,
   key   b.bill_date               as BillDate,
    key  b.vendor_invoice          as InvocieNumber, 
   key   a.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.GTBQ,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.CGST,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.SGST,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.IGST,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.TOTA,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.ADMO,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.ADMT,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.ADMC,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.ADWD,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.RERT,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.EXRR,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.GSTP,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.GSTG,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.GSTR,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.TSDR,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.OTR1,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.OTR2,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.TOTB,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.REMB,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.REMT,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.REWD,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.EWMC,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.REWO,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.TDSA,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.EXRH,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.GSTH,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.GSTS,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.GSTD,
      @Semantics.amount.currencyCode : 'zcurr'
   key   a.TSDH,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.OTH1,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.OTH2,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.MTRE,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.DSEL,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.OTDD,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.TOTC,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.SDIT,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.TOTD,
      @Semantics.amount.currencyCode : 'zcurr'
    key  a.AMTP,
   key   c.PostedDocument          as InvoiceDocumentNo,
   key   left(c.DocumentDate , 4 ) as InvoiceDocYear
}
group by
  a.RaBillNo,
  c.CompanyCode,
  b.wekrs,
  b.zplant_name,
  b.lifnr,
  b.zsupplier_name,
  b.ebeln,
  b.pan,
  b.gstin,
  b.post_date,
  b.bill_date,
  b.vendor_invoice,
  a.zcurr,
  a.GTBQ,
  a.MTRE,
  a.DSEL,
  a.CGST,
  a.SGST,
  a.IGST,
  a.TOTA,
  a.ADMO,
  a.ADMT,
  a.ADMC,
  a.ADWD,
  a.RERT,
  a.GSTP,
  a.GSTG,
  a.GSTR,
  a.TSDR,
  a.OTR1,
  a.OTR2,
  a.TOTB,
  a.REMB,
  a.REMT,
  a.REWD,
  a.EWMC,
  a.REWO,
  a.TDSA,
  a.GSTH,
  a.GSTS,
  a.GSTD,
  a.TSDH,
  a.OTH1,
  a.OTH2,
  a.TOTC,
  a.SDIT,
  a.TOTD,
  a.AMTP,
  c.PostedDocument,
  c.DocumentDate,
    a.OTDD,
    a.EXRR,
    a.EXRH,
    D.UserName,
    D.Status
