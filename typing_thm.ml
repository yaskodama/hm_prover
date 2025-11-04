type proofnode =
  | PVar of Env.env * string * Types.scheme
  | PAbs of Env.env * string * Syntax.expr * Types.ty * Types.ty * thm
  | PApp of Env.env * Syntax.expr * Syntax.expr * Types.ty * thm * thm
  | PLet of Env.env * string * Syntax.expr * Syntax.expr * Types.scheme * Types.ty * thm * thm
  | PIf  of Env.env * Syntax.expr * Syntax.expr * Syntax.expr * Types.ty * thm * thm * thm
and thm = Thm of Env.env * Syntax.expr * Types.ty * proofnode
let concl (Thm (g,e,t,_)) = (g,e,t)
let inst_ok (_:Types.scheme) (_:Types.ty) = true
let gen_ok (_:Env.env) (_:Types.ty) (_:Types.scheme) = true
let var g x sc =
  match Env.lookup x g with
  | Some sc' when sc'=sc -> Some (Thm (g,Syntax.EVar x,Env.instantiate sc,PVar(g,x,sc)))
  | _ -> None
let abs g x e t_arg t_body th_e =
  Thm (g,Syntax.ELam(x,e),Types.TFun(t_arg,t_body),PAbs(g,x,e,t_arg,t_body,th_e))
let app g e1 e2 t th1 th2 =
  Thm (g,Syntax.EApp(e1,e2),t,PApp(g,e1,e2,t,th1,th2))
let let_ g x e1 e2 sc t th1 th2 =
  Thm (g,Syntax.ELet(x,e1,e2),t,PLet(g,x,e1,e2,sc,t,th1,th2))
let if_ g e1 e2 e3 t th1 th2 th3 =
  Thm (g,Syntax.EIf(e1,e2,e3),t,PIf(g,e1,e2,e3,t,th1,th2,th3))
type rule =
  | RVar of Env.env * string * Types.scheme
  | RAbs of Env.env * string * Syntax.expr * Types.ty * Types.ty * thm
  | RApp of Env.env * Syntax.expr * Syntax.expr * Types.ty * thm * thm
  | RLet of Env.env * string * Syntax.expr * Syntax.expr * Types.scheme * Types.ty * thm * thm
  | RIf  of Env.env * Syntax.expr * Syntax.expr * Syntax.expr * Types.ty * thm * thm * thm
let last_rule (Thm(_,_,_,p)) = match p with
  | PVar(g,x,sc) -> RVar(g,x,sc)
  | PAbs(g,x,e,t1,t2,th) -> RAbs(g,x,e,t1,t2,th)
  | PApp(g,e1,e2,t,th1,th2) -> RApp(g,e1,e2,t,th1,th2)
  | PLet(g,x,e1,e2,sc,t,th1,th2) -> RLet(g,x,e1,e2,sc,t,th1,th2)
  | PIf(g,e1,e2,e3,t,th1,th2,th3) -> RIf(g,e1,e2,e3,t,th1,th2,th3)
