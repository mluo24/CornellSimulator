open GameGaugesDict
open KeyValueType
module GameIntDict =
  MakeGameDict (KeyValueType.IntPos) (KeyValueType.CaselessString)
