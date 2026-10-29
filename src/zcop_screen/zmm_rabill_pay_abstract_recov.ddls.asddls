@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Recovery posting'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PAY_ABSTRACT_RECOV
  as select distinct from    zmmt_scp_pa_h1           as a
    left outer join zmmt_scp_ra_payi         as b on a.ra_bill_no = b.ra_bill_no
                                                  and(
                                                    b.itm_code    = 'REMB'
                                                    or b.itm_code = 'REMT'
                                                    or b.itm_code = 'REWD'
                                                    or b.itm_code = 'EWMC'
                                                    or b.itm_code = 'RRYL'
                                                    or b.itm_code = 'TDSA'
                                                  )
    left outer join I_PurchaseOrderItemAPI01 as e on  a.ebeln = e.PurchaseOrder
                                                  and e.TaxCode is not null
    left outer join zmmt_scp_pa_mas1 as f on b.itm_code = f.itm_code

{
  key a.ra_bill_no               as Rabillno,
      a.ebeln                    as Ebeln,
      a.lifnr                    as Supplier,
      upper(a.vendor_invoice)    as VendorInvoice,
      a.bill_date                as BillDate,
      a.post_date                as PostingDate,
      a.prctr                    as ProfitCenter,
      a.bupla                    as BusinessPlace,
      e.CompanyCode              as CompanyCode,
      cast('' as abap.numc( 6 )) as Counter,
      b.zcurr,
      b.itm_code,
//      b.gl_code,
      f.gl_code,
      case  b.itm_code
      when 'ADMO'  then 'A'
      when 'ADMT'  then 'A'
      when 'ADMC'  then 'A'
      when 'ADWD'  then 'A'
      when 'RERT'  then 'B'
      when 'EXRR'  then 'O'
      when 'GSTP'  then 'G'
      when 'GSTG'  then 'O'
      when 'GSTR'  then 'O'
      when 'TSDR'  then 'O'
      when 'OTR1'  then 'G'
      when 'REMB'  then 'A'
      when 'REMT'  then 'A'
      when 'REWD'  then 'A'
      when 'EWMC'  then 'A'
      when 'REWO'  then 'B'
      when 'EXRH'  then 'O'
      when 'GSTH'  then 'G'
      when 'GSTS'  then 'O'
      when 'GSTD'  then 'O'
      when 'TSDH'  then 'O'
      when 'OTH1'  then 'O'
      end                        as SpecialGL,
////      case b.itm_code
////      when 'REMB' then 'B'
////      when 'REMT' then 'B'
////      when 'EWMC' then 'B'
////      when 'REWD' then 'B'
////      when 'RRYL' then 'B'
////      end                        as SpecialGL,
      b.description              as Remarks,
      @Semantics.amount.currencyCode : 'zcurr'
      b.thisbill                 as thisbill,
      a.gl_acc                   as HeaderGl,
      a.hbkid                    as HouseBankID,
      a.hktid                    as AccountID,
      e.TaxCode,
      a.sectioncode as SectionCode
}
where
  b.gl_code <> ''
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
 // b.itm_code,
  b.description,
  b.gl_code,
  b.zcurr,
  b.thisbill,
  a.gl_acc,
  a.hbkid,
  a.hktid,
  a.prctr,
  e.TaxCode,
    f.gl_code,
    b.itm_code,
    a.sectioncode
