@AbapCatalog.sqlViewName: 'ZMMRABILLREP1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill Report1'
define view ZMM_RABILL_REPORT1
  as select from ZMM_RABILL_REPORT
{
  key RaBillNo,
      zcurr,
      sum(GrandTotalBOQ)           as GTBQ,
      sum(CgstAmt)                 as CGST,
      sum(SgstAmt)                 as SGST,
      sum(IgstAmt)                 as IGST,
      sum(TotalAmountA)            as TOTA,
      sum(MobilisationAdvance)     as ADMO,
      sum(MaterialAdvance)         as ADMT,
      sum(MachineryAdvance)        as ADMC,
      sum(AdvanceAgainstWorkDone)  as ADWD,
      sum(Royalty)                 as ROYL,
      sum(Retention)               as RERT,
      sum(ExtRetRel)               as EXRR,
      sum(GstPartVHoldDept)        as GSTP,
      sum(GSTSubConHold)           as GSTG,
      sum(GSTTDSHold)              as GSTR,
      sum(TestingDepositHold)      as TSDR,
      sum(MiscDeposit1)            as OTR1,
      sum(MiscDeposit2)            as OTR2,
      sum(TotalAmountB)            as TOTB,
      sum(DMobilisationAdvance)    as REMB,
      sum(DMaterialAdvance)        as REMT,
      sum(DAdvanceAgainstWorkDone) as REWD,
      sum(DMachineryAdvance)       as EWMC,
      sum(DRoyalty)                as RRYL,
      sum(DRetentionMoney)         as REWO,
      sum(TDSAdjustment)           as TDSA,
      sum(SafetyHold)              as EXRH,
      sum(DGstPartVHoldDept)       as GSTH,
      sum(DGstSubConHold)          as GSTS,
      sum(DGSTTDSHold)             as GSTD,
      sum(DTestingDepositHold)     as TSDH,
      sum(DMiscDeposit1)           as OTH1,
      sum(DMiscDeposit2)           as OTH2,
      sum(MaterialRecovery)        as MTRE,
      sum(DieselConsumption)       as DSEL,
      sum(OtherDeduction)          as OTDD,
      sum(MatDslCGST)              as CGMT,
      sum(MatDslSGST)              as SGMT,
      sum(MatDslIGST)              as IGMT,
      sum(TotalDeductionC)         as TOTC,
      sum(IncomeTaxTDS)            as SDIT,
      sum(TotalDeductionD)         as TOTD,
      sum(AmountPayable)           as AMTP
}
group by
  RaBillNo,
  zcurr
