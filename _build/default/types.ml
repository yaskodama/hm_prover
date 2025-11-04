type ty =
  | TVar of int
  | TInt
  | TBool
  | TFun of ty * ty
[@@deriving show]

type scheme = Forall of int list * ty [@@deriving show]

let rec equal_ty a b =
  match a, b with
  | TVar x, TVar y -> x = y
  | TInt, TInt -> true
  | TBool, TBool -> true
  | TFun (a1,b1), TFun (a2,b2) -> equal_ty a1 a2 && equal_ty b1 b2
  | _ -> false
