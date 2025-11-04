type progress = | Value | Step_exists of Syntax.expr
let progress_of (th:Typing_thm.thm) : progress =
  let (_g,e,_t) = Typing_thm.concl th in
  match e with
  | Syntax.ELam _ | Syntax.EInt _ | Syntax.EBool _ -> Value
  | Syntax.EApp (e1,_) -> Step_exists e1
  | Syntax.ELet (_,e1,_) -> Step_exists e1
  | Syntax.EIf (Syntax.EBool true, e2, _) -> Step_exists e2
  | Syntax.EIf (Syntax.EBool false, _, e3) -> Step_exists e3
  | Syntax.EIf (e1,_,_) -> Step_exists e1
