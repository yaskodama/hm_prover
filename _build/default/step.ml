open Syntax
let is_value = function | EInt _ | EBool _ | ELam _ -> true | _ -> false
exception Stuck
let rec subst x v e =
  match e with
  | EVar y -> if x=y then v else e
  | ELam(y,e1) -> if x=y then e else ELam(y,subst x v e1)
  | EApp(e1,e2) -> EApp(subst x v e1, subst x v e2)
  | ELet(y,e1,e2) -> let e1'=subst x v e1 in
    let e2'=if x=y then e2 else subst x v e2 in ELet(y,e1',e2')
  | EInt _ | EBool _ -> e
  | EIf(e1,e2,e3) -> EIf(subst x v e1, subst x v e2, subst x v e3)
let rec step = function
  | EApp(ELam(x,e),v2) when is_value v2 -> subst x v2 e
  | EApp(v1,e2) when is_value v1 -> EApp(v1,step e2)
  | EApp(e1,e2) -> EApp(step e1,e2)
  | ELet(x,v1,e2) when is_value v1 -> subst x v1 e2
  | ELet(x,e1,e2) -> ELet(x,step e1,e2)
  | EIf(EBool true,e2,_) -> e2
  | EIf(EBool false,_,e3) -> e3
  | EIf(e1,e2,e3) -> EIf(step e1,e2,e3)
  | e when is_value e -> raise Stuck
  | _ -> raise Stuck
let rec eval e = try let e'=step e in eval e' with Stuck -> e
