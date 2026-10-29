@AbapCatalog.sqlViewName: 'ZMMPAYABSTRACT'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final Projection View Pay Abs Service'
define view ZMM_RABILL_PAY_ABSTRACT_FINAL
//  as select from ZMM_RABILL_PAY_PROJECION as a
//  as select from ZMM_RABILL_PAY_PROJECION2 as a
  as select from ZMM_RABILL_PAY_ABSTRACT_FINAL1 as a
    inner join   zmmt_scp_pa_mas1         as b on a.SrNo = b.sr_no_n
    left outer join ZCOP_WITHH1 as  c on a.Ebeln  = c.PurchaseOrder
                                        and a.PaMasterDescription = c.RetentionMoneyHOLD
    left outer join ZCOP_GST as  d on a.Ebeln  = d.PurchaseOrder
                                        and a.PaMasterDescription = d.gstname
                                        
////    left outer join I_ServiceEntrySheetAPI01 as c on a.RaBillNo = c.ServiceEntrySheetName

{
  key    a.RaBillNo,
         a.Ebeln,
         @ObjectModel.sort.enabled: true
         a.SrNo,
         a.SrNumber,
         a.ItemCode,   
         //         b.itm_code as ItemCode,
         a.PaMasterDescription,
         a.GlAcc,
//         a. Tax,
         case 
        when c.RetentionMoneyHOLD =  'Income Tax (TDS) for Work Done' then c.YY1_Retention_PDH
        when c.RetentionMoneyHOLD = 'Retention Money (HOLD)' then c.WithholdingTaxPercent
        when d.gstname = 'SGST @ %' then d.ConditionRateRatio
        when d.gstname = 'CGST @ %' then d.ConditionRateRatio
        when d.gstname = 'IGST @ %' then d.ConditionRateRatio
         end as  Tax,
         a.zcurr,
         @Semantics.amount.currencyCode : 'zcurr'
//         a.UpToDate,
         sum(a.UpToDate) as UpToDate,
         @Semantics.amount.currencyCode : 'zcurr'
//         a.UpToPreviousBill,
//         a.UpToDate as UpToPreviousBill,
         sum(a.UpToDate) as UpToPreviousBill,
         @Semantics.amount.currencyCode : 'zcurr'
//         a.ThisBill,
         sum(a.ThisBill) as ThisBill,
         a.Remarks,
         b.umskz      as Calc,
////         c.ServiceEntrySheet as SesNo,
         case b.manual
         when 'M'
         then 'true'
         when ''
         then case a.ItemCode //b.itm_code
         when 'MTRE'
         then 'true'
         when 'REWO'
         then 'true'
         else 'false' end
         else
         'false'  end as Edit
}
//where
//  a.RaBillNo <> ''
group by
  a.RaBillNo,
  a.SrNo,
  a.SrNumber,
  a.ItemCode,
  //  b.itm_code,
  a.PaMasterDescription,
  a.Tax,
  a.GlAcc,
  a.Ebeln,
  a.Remarks,
  a.zcurr,
//  a.UpToDate,
////  a.UpToPreviousBill,
//  a.ThisBill,
  b.manual,
  b.umskz,
    c.WithholdingTaxPercent,
    c.RetentionMoneyHOLD,
    c.YY1_Retention_PDH,
    d.gstname,
    d.ConditionRateRatio
////    c.ServiceEntrySheet
