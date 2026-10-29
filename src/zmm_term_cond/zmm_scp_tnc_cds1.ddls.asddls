@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for work order T&C'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_SCP_TNC_CDS1 
  as select from zmmt_scp_tnc1 as a
     left outer join I_PurchaseOrderAPI01 as b on a.ebeln       = b.PurchaseOrder 
     left outer join I_CompanyCode        as c on b.CompanyCode = c.CompanyCode 
     left outer join I_Supplier           as d on a.zvend_code  = d.Supplier
     left outer join I_PlantStdVH         as e on a.zproject    = e.Plant 
     left outer join I_TaxCodeText        as f on a.wt_withcd   = f.TaxCode 
                                               and f.Language   = 'E'   

{
  key a.ebeln                 as Ebeln,
      a.zin_wo                as ZinWo,
      b.CompanyCode,
      c.CompanyCodeName,
      d.SupplierFullName,
      e.PlantName,
      f.TaxCodeName,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zret                  as Zret,
      a.zwith                 as Zwith,
      @Semantics.amount.currencyCode: 'zcurr'
      a.ztds                  as Ztds,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zlbc                  as Zlbc,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zwct                  as Zwct,
      a.zroy_appl             as ZroyAppl,
      a.zins                  as Zins,
      a.zmat                  as Zmat,
      a.zfud                  as Zfud,
      a.zacc                  as Zacc,
      a.zele                  as Zele,
      a.zpen                  as Zpen,
      a.zbonus                as Zbonus,
      a.final_appr1           as FinalAppr1,
      a.final_appr2           as FinalAppr2,
      a.final_appr3           as FinalAppr3,
      a.wt_withcd             as WtWithcd,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zgst                  as Zgst,
      a.dpr_mandt             as DprMandt,
      a.zadc_with             as ZadcWith,
      a.zadc_withcd           as ZadcWithcd,
      a.zbg_req               as ZbgReq,
      a.zbg_number            as ZbgNumber,
      a.zbg_date              as ZbgDate,
      a.zbg_bank              as ZbgBank,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zbg_amt               as ZbgAmt,
      a.zbg_edate             as ZbgEdate,
      a.zcurr                 as zcurr,
      a.zvend_code            as ZvendCode,
      a.zproject              as Zproject,
      a.zdoctype              as Zdoctype,
      a.zgst_no               as ZgstNo,
      a.zpan_no               as ZpanNo, 
      a.zwo_desc              as ZwoDesc,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zret_ext              as ZretExt,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zmob_adv              as ZmobAdv,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zmach_adv             as ZmachAdv,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zwork_done            as ZworkDone,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zmat_adv              as ZmatAdv,
      @Semantics.amount.currencyCode: 'zcurr'
      a.zroylt                as Zroylt,
      
      @Semantics.user.createdBy: true
      a.local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      a.local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      a.local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      a.local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      a.last_changed_at       as LastChangedAt,
      a.base_chk as base_chk,
      a.pay_chk  as pay_chk
      //    _association_name // Make association public
}
