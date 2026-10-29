@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for RA Bill advance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMMT_SCP_RAB_ADV_CDS1 
 as select from zmmt_scp_rab_ad1 as a1
     left outer join ZMMT_SCP_RAB_ADV_CDS2 as a2 on a1.ebeln = a2.ebeln
     left outer join zmm_scp_rab_adv_amt4  as a3 on a1.ebeln = a3.Ebeln
                                                       
     
  // composition of target_data_source_name as _association_name
{
        //  _association_name // Make association public
        @EndUserText.label: 'RABILL No'   
  key   a1.adv_type              as AdvType,
  key   a1.ra_bill_no            as RaBillNo,
        a1.ebeln                 as Ebeln,

        a1.prinvoice             as Prinvoice,
        a1.prinvoice_date        as PrinvoiceDate,
        a1.work_from             as WorkFrom,
        a1.work_to               as WorkTo,
        
        @EndUserText.label: 'Advance Type'
        a1.rcount                as Rcount,
        a1.rec_strt              as RecStrt,
        a1.rec_end               as RecEnd,
        a1.cum_wd_amt            as CumWdAmt,
        a1.tis_wd_amt            as TisWdAmt,
        a1.per_work_done         as PerWorkDone,
        @EndUserText.label: 'Advance Paid'
        a1.adv_paid              as AdvPaid,
        a1.amount                as Amount,
        a1.gst                   as Gst,
        a1.tot_adv               as TotAdv,
        case a1.adv_type
        when 'AGWD' then a2.zwork_done
        when 'MACH' then a2.zmach_adv
        when 'MATR' then a2.zmat_adv
        when 'MOBI' then a2.zmob_adv
//        when 'ROYL' then a2.zroylt
        end as WoPer ,
        
        case a1.adv_type
        when 'AGWD' then a3.zwork_done
        when 'MACH' then a3.zmach_adv
        when 'MATR' then a3.zmat_adv
        when 'MOBI' then a3.zmob_adv
//        when 'ROYL' then a3.zroylt
        end as WoPerMax ,
        a3.amt as RelTotAmt,
        a1.rec_th_bill_c         as RecThBillC,
        a1.rec_th_bill_m         as RecThBillM,
        a1.rec_till              as RecTill,
        a1.rec_up_date           as RecUpDate,
        a1.bal_torec             as BalTorec,
        @EndUserText.label: 'Final Process'
        a1.final_proces          as FinalProces,
        @Semantics.user.createdBy: true
        a1.local_created_by      as LocalCreatedBy,
        @Semantics.systemDateTime.createdAt: true
        a1.local_created_at      as LocalCreatedAt,
        @Semantics.user.localInstanceLastChangedBy: true
        a1.local_last_changed_by as LocalLastChangedBy,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        a1.local_last_changed_at as LocalLastChangedAt
////        @Semantics.systemDateTime.lastChangedAt: true
////        a1.last_changed_at       as LastChangedAt

}where a1.adv_type is not initial
 and a1.adv_type <> 'ROYL'
