@EndUserText.label: 'child1'
@AccessControl.authorizationCheck: #CHECK
define  view entity ZI_Child1
  as select from ztuttable2
    association [1..1] to ZI_Main_S as _MainAll on $projection.SingletonID = _MainAll.SingletonID
    association to parent ZI_Main as _Main on $projection.Id = _Main.Id

{
  key id2 as Id2,
  key id as Id,
  description as Description,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  1 as SingletonID,
  _MainAll,
  _Main
  
}
