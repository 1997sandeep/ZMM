@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Posting for Material and Recovey'
define root view entity ZMM_RABILL_PAY_MAT_DSL_GSTPOST
  as select from    zmmt_scp_pa_h1                 as a
    left outer join zmmt_scp_ra_payi               as b on a.ra_bill_no = b.ra_bill_no
                                                        and(
                                                          b.itm_code    = 'CGMT'
                                                          or b.itm_code = 'IGMT'
                                                          or b.itm_code = 'SGMT'
                                                          //                                                          b.sr_no_n     = '046'
                                                          //                                                          or b.sr_no_n  = '047'
                                                          //                                                          or b.sr_no_n  = '048'
                                                        )
    left outer join I_PurchaseOrderItemAPI01       as e on  a.ebeln   = e.PurchaseOrder
                                                        and e.TaxCode is not initial
    left outer join I_PurOrdAccountAssignmentAPI01 as f on e.PurchaseOrder = f.PurchaseOrder
    left outer join I_EnterpriseProjectElement     as g on f.WBSElementInternalID_2 = g.WBSElementInternalID

{
  key a.ra_bill_no               as Rabillno,
      a.ebeln                    as Ebeln,
      a.lifnr                    as Supplier,
      upper(a.vendor_invoice)    as VendorInvoice,
      a.bill_date                as BillDate,
      a.post_date                as PostingDate,
      a.wekrs                    as ProfitCenter,
      a.bupla                    as BusinessPlace,
//      a.bupla                    as SectionCode,
      case e.CompanyCode
      when '1000' then '1829'
      when '1100' then '1823'
      when '1200' then '1829'
      when '1300' then '1829'
      when '1400' then '1829'
      when '3000' then '1829'
      end as SectionCode,
      e.CompanyCode              as CompanyCode,
      cast('' as abap.numc( 6 )) as Counter,
      b.zcurr,
      b.itm_code,
      b.gl_code,
      b.remarks                  as Remarks,
      @Semantics.amount.currencyCode : 'zcurr'
      b.thisbill                 as thisbill,
      g.ProjectElement           as ProjectElement,
      e.TaxCode                  as TaxCode
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
  e.TaxCode
