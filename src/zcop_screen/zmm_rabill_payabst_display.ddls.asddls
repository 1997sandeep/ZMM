@AbapCatalog.sqlViewName: 'ZMMRABILLPAYDSP'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Display Rabill PayMent Abstract'
define view ZMM_RABILL_PAYABST_DISPLAY
  as select distinct from zmmt_scp_pa_h1       as h
    inner join            I_PurchaseOrderAPI01 as a on h.ebeln = a.PurchaseOrder
    left outer join       zmmt_scp_tnc1        as b on h.ebeln = b.ebeln
    left outer join       zmmt_scp_rab_rec     as c on h.ra_bill_no = c.ra_bill_no
{
  key h.ra_bill_no     as Rabillno,
      h.ebeln          as Ebeln,
      h.ra_bill_from   as Rabillfrom,
      h.ra_bill_to     as Rabillto,
      h.lifnr          as Supplier,
      h.zsupplier_name as SupplierName,
      h.wekrs          as Plant,
      h.zplant_name    as PlantName,
      h.region         as Region,
      h.state_name     as State,
      h.gstin          as Gstin,
      h.pan            as PAN,
      h.gl_acc         as GlAccNo,
      h.vendor_invoice as VendorInvoice,
      h.hbkid          as HouseBankId,
      h.hktid          as AccountId,
      h.bill_date      as BillDate,
      h.post_date      as PostingDate,
      a.CompanyCode    as CompanyCode,
      'TRIDASA'        as CompanyName,
      ''               as Flag,
      h.bupla          as BusinessPlace,
      h.sectioncode   as SectionCode,
      b.zwo_desc       as WoDesc,
      //      c.inv_date       as InvDate,
      //      c.inv_no         as InvNo
      h.vendor_invoice as InvNo,
      h.bill_date      as InvDate,
      h.prctr          as ProfitCenter,
      h.narration,
//      a.PurgReleaseTimeTotalAmount as woamt
      cast( a.PurgReleaseTimeTotalAmount as abap.dec( 14, 2 )) as woamt
}
group by
  h.ra_bill_no,
  h.ebeln,
  h.ra_bill_from,
  h.ra_bill_to,
  h.lifnr,
  h.zsupplier_name,
  h.wekrs,
  h.zplant_name,
  h.region,
  h.state_name,
  h.gstin,
  h.pan,
  h.gl_acc,
  h.vendor_invoice,
  h.hbkid,
  h.hktid,
  h.bill_date,
  h.post_date,
  a.CompanyCode,
  h.bupla,
  b.zwo_desc,
  //  c.inv_date,
  //  c.inv_no
  h.vendor_invoice,
  h.bill_date,
  h.prctr,
  h.narration,
  h.sectioncode,
  a.PurgReleaseTimeTotalAmount
