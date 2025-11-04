module M = Map.Make(Int)

type subst = Types.ty M.t

let empty : subst = M.empty
let singleton a t = M.add a t empty

let rec apply (s:subst) (t:Types.ty) : Types.ty =
  match t with
  | Types.TVar a -> (match M.find_opt a s with Some t' -> apply s t' | None -> t)
  | Types.TInt | Types.TBool -> t
  | Types.TFun (t1,t2) -> Types.TFun (apply s t1, apply s t2)

let compose (s2:subst) (s1:subst) : subst =
  let open M in
  union (fun _ _ t2 -> Some t2) (map (apply s2) s1) s2

exception UnifyFail of string

let rec occurs a (t:Types.ty) =
  match t with
  | Types.TVar b -> a = b
  | Types.TInt | Types.TBool -> false
  | Types.TFun (t1,t2) -> occurs a t1 || occurs a t2

let rec unify (t1:Types.ty) (t2:Types.ty) : subst =
  match t1, t2 with
  | Types.TInt, Types.TInt
  | Types.TBool, Types.TBool -> empty
  | Types.TFun(a1,b1), Types.TFun(a2,b2) ->
      let s1 = unify a1 a2 in
      let s2 = unify (apply s1 b1) (apply s1 b2) in
      compose s2 s1
  | Types.TVar a, t
  | t, Types.TVar a ->
      if t = Types.TVar a then empty
      else if occurs a t then raise (UnifyFail "occurs check")
      else singleton a t
  | _ -> raise (UnifyFail "clash")
