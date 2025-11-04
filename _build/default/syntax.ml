type var = string [@@deriving show]

type expr =
  | EVar of var
  | ELam of var * expr
  | EApp of expr * expr
  | ELet of var * expr * expr
  | EInt of int
  | EBool of bool
  | EIf of expr * expr * expr
[@@deriving show]
