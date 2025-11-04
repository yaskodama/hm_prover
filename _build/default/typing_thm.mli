type thm
val concl : thm -> Env.env * Syntax.expr * Types.ty
val var  : Env.env -> string -> Types.scheme -> thm option
val abs  : Env.env -> string -> Syntax.expr -> Types.ty -> Types.ty -> thm -> thm
val app  : Env.env -> Syntax.expr -> Syntax.expr -> Types.ty -> thm -> thm -> thm
val let_ : Env.env -> string -> Syntax.expr -> Syntax.expr -> Types.scheme -> Types.ty -> thm -> thm -> thm
val if_  : Env.env -> Syntax.expr -> Syntax.expr -> Syntax.expr -> Types.ty -> thm -> thm -> thm -> thm
type rule =
  | RVar of Env.env * string * Types.scheme
  | RAbs of Env.env * string * Syntax.expr * Types.ty * Types.ty * thm
  | RApp of Env.env * Syntax.expr * Syntax.expr * Types.ty * thm * thm
  | RLet of Env.env * string * Syntax.expr * Syntax.expr * Types.scheme * Types.ty * thm * thm
  | RIf  of Env.env * Syntax.expr * Syntax.expr * Syntax.expr * Types.ty * thm * thm * thm
val last_rule : thm -> rule
val inst_ok : Types.scheme -> Types.ty -> bool
val gen_ok  : Env.env -> Types.ty -> Types.scheme -> bool
