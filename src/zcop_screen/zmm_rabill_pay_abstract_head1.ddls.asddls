@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consume Root View Rabill Pay Abstract'
@Metadata.allowExtensions: true
define root view entity ZMM_RABILL_PAY_ABSTRACT_HEAD1
  as select distinct from ZMM_RABILL_PAY_ABSTRACT_HEADER as a
    left outer join       zmmt_scp_tnc1                  as b on a.Ebeln = b.ebeln
    left outer join       zmmt_scp_rab_rec               as c on a.Rabillno = c.ra_bill_no
    left outer join       ZMM_RABILL_PAY_ABSTRACT_ADVDT  as d on a.Rabillno = d.ra_bill_no
    left outer join       I_PurchaseOrderAPI01 as e on a.Ebeln = e.PurchaseOrder
    left outer join      I_ServiceEntrySheetAPI01 as f on a.Ebeln = f.PurchaseOrder  and a.Rabillno = f.ServiceEntrySheetName and f.ApprovalStatus = '30'

{
  key a.Rabillno,
  key a.Ebeln,

      case
      when d.work_from is not null
      then d.work_from
      else a.Rabillfrom
      end        as Rabillfrom,

      case
      when d.work_to is not null
      then d.work_to
      else a.Rabillto
      end        as Rabillto,

      a.Supplier,
      a.SupplierName,
      a.Plant,
      a.PlantName,
      a.Country,
      a.Region,
      a.State1   as State,
      a.Gstin,
      a.PAN,
      a.GlAccNo,
      a.VendorInvoice,
      a.HouseBankId,
      a.AccountId,
      a.BillDate,
      a.PostingDate,
      a.ItemCode,
      a.zcurr,
      a.thisbill,
      a.uptodate,
      a.uptolast,
      a.remarks,
      a.SrNo,
      a.SrNumber,
      a.PaMasterDescription,
      a.GlAcc,
      a.Tax,
      a.BusinessPlace,
      a.Sectioncode,
      a.InvDate,
      a.InvNum,
      b.zwo_desc as WoDesc,
      c.inv_date,
      c.inv_no,
      a.ProfitCenter,
      ''         as Flag,
      b.znarration    as narration,
       cast( e.PurgReleaseTimeTotalAmount as abap.dec( 14, 2 )) as woamt,
       f.ServiceEntrySheet
      
}
group by
  a.Rabillno,
  a.Ebeln,
  a.Rabillfrom,
  a.Rabillto,
  a.Supplier,
  a.SupplierName,
  a.Plant,
  a.PlantName,
  a.Country,
  a.Region,
  a.State1,
  a.Gstin,
  a.PAN,
  a.GlAccNo,
  a.VendorInvoice,
  a.HouseBankId,
  a.AccountId,
  a.BillDate,
  a.PostingDate,
  a.ItemCode,
  a.zcurr,
  a.thisbill,
  a.uptodate,
  a.uptolast,
  a.remarks,
  a.SrNo,
  a.SrNumber,
  a.PaMasterDescription,
  a.GlAcc,
  a.Tax,
  a.BusinessPlace,
  a.Sectioncode,
  a.InvDate,
  a.InvNum,
  b.zwo_desc,
  c.inv_date,
  c.inv_no,
  d.work_from,
  d.work_to,
  a.ProfitCenter,
  b.znarration,
  e.PurgReleaseTimeTotalAmount,
  f.ServiceEntrySheet
