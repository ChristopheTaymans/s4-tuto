@EndUserText.label: 'Main'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_Main
  as select from ztuttable1
  association to parent ZI_Main_S as _MainAll on $projection.SingletonID = _MainAll.SingletonID
  composition [0..*] of ZI_MainText as _MainText
  composition [0..*] of ZI_Child1 as _Child1
{
  key id as Id,
  field1 as Field1,
  field2 as Field2,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  1 as SingletonID,
  _MainAll,
  _MainText,
  _Child1
  }
