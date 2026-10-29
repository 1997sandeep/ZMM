@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for Material and Disel Posting'
define root view entity ZMM_RABILL_PAY_MAT_DSL_POST
  as select from    zmmt_scp_pa_h1                 as a
    left outer join zmmt_scp_ra_payi               as b on a.ra_bill_no = b.ra_bill_no
                                                        and(
                                                          b.itm_code    = 'MTRE'
                                                          or b.itm_code = 'DSEL'
                                                          or b.itm_code = 'OTDD'
                                                          or b.itm_code = 'OTH2'
                                                          or b.itm_code = 'MTDD'
                                                          or b.itm_code = 'EMDD'
                                                          or b.itm_code = 'FLDD'
                                                          
                                                        )
    left outer join I_PurchaseOrderItemAPI01       as e on  a.ebeln   = e.PurchaseOrder
                                                        and e.TaxCode is not initial
    left outer join I_PurOrdAccountAssignmentAPI01 as f on e.PurchaseOrder = f.PurchaseOrder
    left outer join I_EnterpriseProjectElement     as g on f.WBSElementInternalID_2 = g.WBSElementInternalID

  //added on 04/10/2023
    left outer join ZMM_RABILL_PAY_ABSTRACT_TAXSUM as h on e.TaxCode = h.TaxCode

{
  key a.ra_bill_no               as Rabillno,
      a.ebeln                    as Ebeln,
      a.lifnr                    as Supplier,
      upper(a.vendor_invoice)    as VendorInvoice,
      a.bill_date                as BillDate,
      a.post_date                as PostingDate,
      a.prctr                    as ProfitCenter,
      a.bupla                    as BusinessPlace,
//      a.sectioncode                   as SectionCode,
      e.CompanyCode              as CompanyCode,
      case e.CompanyCode
      when '1000' then 'DLS1'
      when '1100' then 'DLS1'
      when '1200' then 'DLS1'
      when '1300' then 'DLS1'
      when '1400' then 'DLS1'
      when '3000' then 'DLS1'
      end as SectionCode,
      cast('' as abap.numc( 6 )) as Counter,
      b.zcurr,
      b.itm_code,
      b.gl_code,
      b.remarks                  as Remarks,
      @Semantics.amount.currencyCode : 'zcurr'
      b.thisbill                 as thisbill,
      g.ProjectElement           as ProjectElement,
      e.TaxCode                  as TaxCode, //added on 29.09.203
      @Semantics.amount.currencyCode : 'zcurr'
      h.Rate                     as Rate
}
where
      b.gl_code    <>   ''
//  and a.ra_bill_no like '0%'
group by
  a.ra_bill_no,
  a.ebeln,
  a.lifnr,
  a.vendor_invoice,
  a.bill_date,
  a.post_date,
  a.wekrs,
  a.bupla,
  e.CompanyCode,
  b.itm_code,
  b.remarks,
  b.gl_code,
  b.zcurr,
  b.thisbill,
  g.ProjectElement,
  e.TaxCode,
  a.prctr ,
  h.Rate,
    a.sectioncode
