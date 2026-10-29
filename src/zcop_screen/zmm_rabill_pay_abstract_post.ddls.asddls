@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for Miro Posting'
define root view entity ZMM_RABILL_PAY_ABSTRACT_POST
  as select from    zmmt_scp_pa_h1               as a
    left outer join zmmt_scp_ra_payi             as b on a.ra_bill_no = b.ra_bill_no
    left outer join I_ServiceEntrySheetAPI01     as c on  a.ra_bill_no = c.ServiceEntrySheetName
                                                      and a.ebeln      = c.PurchaseOrder
                                                      and c.IsDeleted <> 'X'
    left outer join I_ServiceEntrySheetItemAPI01 as d on c.ServiceEntrySheet = d.ServiceEntrySheet
    left outer join I_PurchaseOrderItemAPI01     as e on  d.PurchaseOrder     = e.PurchaseOrder
                                                      and d.PurchaseOrderItem = e.PurchaseOrderItem
    left outer join ZMM_RABILL_PAY_GROSS_AMOUNT2 as f on  c.ServiceEntrySheetName = f.ServiceEntrySheetName
                                                      and c.PurchaseOrder         = f.PurchaseOrder
                                                      and c.MaterialDocument      = f.MaterialDocument
                                                      and d.PurchaseOrderItem     = f.PurchaseOrderItem
                                                      and d.ServiceEntrySheetItem = f.ServiceEntrySheetItem  
//   left outer join zmmt_scp_pa1 as ff on a.ra_bill_no = ff.ra_bill_no
//                                     and ff.itm_code = 'GTAD'                                                                                                    
{
  key a.ra_bill_no               as Rabillno,
      d.PurchaseOrder            as Ebeln,
      d.PurchaseOrderItem        as Ebelp,
      a.lifnr                    as Supplier,
      upper(a.vendor_invoice)    as VendorInvoice,
      a.bill_date                as BillDate,
      a.post_date                as PostingDate,
      c.MaterialDocument         as GRDoc,
      c.MaterialDocumentYear     as GRDocYear,
      c.ServiceEntrySheetName    as SesNo,
      c.ServiceEntrySheet        as Ses,
      d.ServiceEntrySheetItem    as SesItem,
      c.Currency                 as Currency,  
      d.ConfirmedQuantity        as Qty,
      d.QuantityUnit             as Unit,
      @Semantics.amount.currencyCode : 'Currency'
      f.SupplierInvoiceAmount    as SupplierInvoiceAmount,
//      ff.thisbill    as SupplierInvoiceAmount,
      @Semantics.amount.currencyCode : 'Currency'
      f.GrossAmount              as GrossAmount, //calculated with tax
      e.TaxCode                  as TaxCode,
      a.bupla                    as BusinessPlace,
////      a.bupla                    as SectionCode,
      e.CompanyCode              as CompanyCode,
      case e.CompanyCode
      when '1000' then '1829'
      when '1100' then '1823'
      when '1200' then '1829'
      when '1300' then '1829'
      when '1400' then '1829'     
      when '3000' then '1829'     
      end as SectionCode,
      cast('' as abap.numc( 6 )) as Counter,
      a.narration
}
where
  c.MaterialDocument is not initial
group by
  a.ra_bill_no,
  d.PurchaseOrder,
  d.PurchaseOrderItem,
  a.lifnr,
  a.vendor_invoice,
  a.bill_date,
  a.post_date,
  c.MaterialDocument,
  c.MaterialDocumentYear,
  c.ServiceEntrySheetName,
  c.ServiceEntrySheet,
  c.Currency,
  d.QuantityUnit,
  f.SupplierInvoiceAmount,
  f.GrossAmount,
  e.TaxCode,
  a.bupla,
  e.CompanyCode,
  d.ServiceEntrySheetItem,
  d.ConfirmedQuantity,
  a.narration
//    ff.thisbill
