@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for Advance Posting'
define root view entity ZMM_RABILL_PAY_ABSTRACT_ADPOST
  as select from    zmmt_scp_pa_h1           as a
    left outer join zmmt_scp_ra_payi         as b on a.ra_bill_no = b.ra_bill_no
                                                  and(
                                                    b.itm_code    = 'ADMO'
                                                    or b.itm_code = 'ADMT'
                                                    or b.itm_code = 'ADMC'
                                                    or b.itm_code = 'ADWD'
                                                    or b.itm_code = 'ROYL'
                                                    /////////////////////////////////     Newly added item code
                                                    or b.itm_code = 'RERT'
                                                    or b.itm_code = 'EXRR'
                                                    or b.itm_code = 'GSTP'
                                                    or b.itm_code = 'GSTG'
                                                    or b.itm_code = 'GSTR'
                                                    or b.itm_code = 'TSDR'
                                                    or b.itm_code = 'OTR1'
                                                    or b.itm_code = 'REMB'
                                                    or b.itm_code = 'REMT'
                                                    or b.itm_code = 'REWD'
                                                    or b.itm_code = 'EWMC'
                                                    or b.itm_code = 'REWO'
                                                    or b.itm_code = 'EXRH'
                                                    or b.itm_code = 'GSTH'
                                                    or b.itm_code = 'GSTS'
                                                    or b.itm_code = 'GSTD'
                                                    or b.itm_code = 'TSDH'
                                                    or b.itm_code = 'OTH1'
                                                    ////////////////////////////////// Newly added item code
                                                  )
    left outer join I_PurchaseOrderItemAPI01 as e on a.ebeln = e.PurchaseOrder
    left outer join zmmt_scp_tnc1            as f on  a.ebeln = f.ebeln
                                                  and a.lifnr = f.zvend_code //added for TDS Posting

{
  key a.ra_bill_no               as Rabillno,
      a.ebeln                    as Ebeln,
      a.lifnr                    as Supplier,
      upper(a.vendor_invoice)    as VendorInvoice,
      a.bill_date                as BillDate,
      a.post_date                as PostingDate,
      a.wekrs                    as Plant,
      a.bupla                    as BusinessPlace,
      e.CompanyCode              as CompanyCode,
      cast('' as abap.numc( 6 )) as Counter,
      b.zcurr,
      b.itm_code,
      b.gl_code,
      case b.itm_code
      when 'ADMO' then 'A'
      when 'ADMT' then 'A'
      when 'ADMC' then 'A'
      when 'ADWD' then 'A'
      when 'RERT' then 'B'
      when 'EXRR' then 'O'
      when 'GSTP' then 'G'
      when 'GSTG' then 'O'
      when 'GSTR' then 'O'
      when 'TSDR' then 'O'
      when 'OTR1' then 'G'
      when 'REMB' then 'A'
      when 'REMT' then 'A'
      when 'REWD' then 'A'
      when 'EWMC' then 'A'
      when 'REWO' then 'B'
      when 'EXRH' then 'O'
      when 'GSTH' then 'G'
      when 'GSTS' then 'O'
      when 'GSTD' then 'O'
      when 'TSDH' then 'O'
      when 'OTH1' then 'O'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      when 'ROYL' then 'A'
      end                        as SpecialGL,
      b.description              as Remarks,
      @Semantics.amount.currencyCode : 'zcurr'
      b.thisbill                 as thisbill,
      a.gl_acc                   as HeaderGl,
      a.hbkid                    as HouseBankID,
      a.hktid                    as AccountID,
      f.zadc_with                as WithHoldingTaxType,
      f.zadc_withcd              as WithHoldingCode,
      a.prctr                    as ProfitCenter,
      a.sectioncode              as SectionCode
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
  b.itm_code,
  b.description,
  b.gl_code,
  b.zcurr,
  b.thisbill,
  a.gl_acc,
  a.hbkid,
  a.hktid,
  f.zadc_with,
  f.zadc_withcd,
  a.prctr,
  a.sectioncode
