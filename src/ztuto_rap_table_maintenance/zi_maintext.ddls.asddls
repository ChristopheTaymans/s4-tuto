@EndUserText.label: 'Main Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_MainText
  as select from ZTUTTABLE_T
  association [1..1] to ZI_Main_S as _MainAll on $projection.SingletonID = _MainAll.SingletonID
  association to parent ZI_Main as _Main on $projection.Id = _Main.Id
  association [0..*] to I_LanguageText as _LanguageText on $projection.Langu = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key LANGU as Langu,
  key ID as Id,
  @Semantics.text: true
  DESCRIPTION as Description,
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _MainAll,
  _Main,
  _LanguageText
  
}
