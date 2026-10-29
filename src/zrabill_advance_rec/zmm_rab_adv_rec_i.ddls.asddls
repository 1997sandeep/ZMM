@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance recovery item table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_RAB_ADV_REC_I   with parameters
    pwo : ebeln
  as select from    zmmt_scp_rab_ad1         as a1
    left outer join ZMM_ADV_SEC_SUM_THISBILL as a2 on  a1.adv_type = a2.AdvType
                                                   and a1.ebeln    = a2.Ebeln
    left outer join ZMM_RAB_ADV_REC_I_WO_AMT as a4 on  a1.ebeln    = a4.ebeln
    left outer join ZMM_RAB_ADV_REC_I_ADV_GST as a5 on a1.adv_type = a5.AdvType
                                                   and a1.ebeln    = a5.Ebeln
    left outer join ZMM_ADV_REC_CHNG_UPTP_PREV as a3 on a1.ebeln = a3.Ebeln
//                                                    and a1.ra_bill_no > a3.RaBillNo
                                                    and a1.adv_type = a3.AdvType


{
  key  a1.ra_bill_no            as RaBillNo,
  key  a1.adv_type      as AdvType,
  key  a1.ebeln         as Ebeln,
       '' as InvNo,
       '' as InvDate, 
       sum(a5.adv_paid) as AdvPaid,
//       a2.PerWorkDone   as RecTill,
@Semantics.amount.currencyCode: 'zcurr'
       a3.rec_this_bill   as RecTill,
//       a2.RecThisBill,
       '0.00' as RecThisBill,
       case a1.adv_type
        when 'AGWD' then a4.zwork_amt
        when 'MACH' then a4.zmach_amt
        when 'MATR' then a4.zmat_amt
        when 'MOBI' then a4.zmob_amt
//        when 'ROYL' then a4.zroylt_amt
        end as TotWoAmt,
       
//       '0.00'               as RecUpDate,
//       '0.00'               as BalTorec,
       a1.rec_up_date as RecUpDate,
       a1.bal_torec as BalTorec,
       a2.Zcurr,
       '' as blank
}
where
  a1.ebeln = $parameters.pwo
   and a1.adv_type <> 'ROYL'
group by
  a1.adv_type,
  a1.ebeln,
  a2.PerWorkDone,
  a2.Zcurr,
  a2.InvNo,
  a2.InvDate,
  a2.RecThisBill,
    a4.zwork_amt,
    a4.zmach_amt,
    a4.zmat_amt,
    a4.zmob_amt,
    a4.zroylt_amt,
    a1.rec_up_date,
    a1.bal_torec,
    a3.rec_this_bill,
    a1.ra_bill_no
