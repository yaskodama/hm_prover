module S = Set.Make(Int)
module M = Map.Make(String)

type env = Types.scheme M.t

let empty : env = M.empty
let extend (x:string) (sc:Types.scheme) (e:env) = M.add x sc e
let lookup (x:string) (e:env) = M.find_opt x e

let rec ftv_ty = function
  | Types.TVar a -> S.singleton a
  | Types.TInt | Types.TBool -> S.empty
  | Types.TFun(t1,t2) -> S.union (ftv_ty t1) (ftv_ty t2)

let ftv_scheme (Types.Forall (as_, t)) =
  S.diff (ftv_ty t) (S.of_list as_)

let ftv_env (e:env) =
  M.fold (fun _ sc acc -> S.union (ftv_scheme sc) acc) e S.empty

let generalize (env:env) (t:Types.ty) =
  let as_ = S.elements (S.diff (ftv_ty t) (ftv_env env)) in
  Types.Forall (as_, t)

let counter = ref 0
let fresh () = incr counter; !counter

let instantiate (Types.Forall (as_, t)) =
  let s =
    List.fold_left
      (fun acc a ->
         Subst.compose acc (Subst.singleton a (Types.TVar (fresh ()))))
      Subst.empty as_
  in
  Subst.apply s t

let apply_env (s:Subst.subst) (env:env) : env =
  M.map (fun (Types.Forall (as_, t)) ->
    let s' = List.fold_left (fun acc a -> Subst.M.remove a acc) s as_ in
    Types.Forall (as_, Subst.apply s' t)
  ) env
