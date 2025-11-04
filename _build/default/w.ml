let rec infer (env:Env.env) (e:Syntax.expr) : (Subst.subst * Types.ty) =
  match e with
  | Syntax.EInt _ -> (Subst.empty, Types.TInt)
  | Syntax.EBool _ -> (Subst.empty, Types.TBool)
  | Syntax.EVar x ->
      (match Env.lookup x env with
       | None -> failwith "unbound var"
       | Some sc -> (Subst.empty, Env.instantiate sc))
  | Syntax.ELam (x, e) ->
      let a = Types.TVar (Env.fresh ()) in
      let env' = Env.extend x (Types.Forall ([], a)) env in
      let (s1, t1) = infer env' e in
      (s1, Types.TFun (Subst.apply s1 a, t1))
  | Syntax.EApp (e1, e2) ->
      let (s1, t1) = infer env e1 in
      let (s2, t2) = infer (Env.apply_env s1 env) e2 in
      let a = Types.TVar (Env.fresh ()) in
      let s3 = Subst.unify (Subst.apply s2 t1) (Types.TFun (t2, a)) in
      (Subst.compose s3 (Subst.compose s2 s1), Subst.apply s3 a)
  | Syntax.ELet (x, e1, e2) ->
      let (s1, t1) = infer env e1 in
      let env1 = Env.apply_env s1 env in
      let sc = Env.generalize env1 t1 in
      let env2 = Env.extend x sc env1 in
      let (s2, t2) = infer env2 e2 in
      (Subst.compose s2 s1, t2)
  | Syntax.EIf (e1,e2,e3) ->
      let (s1,t1) = infer env e1 in
      let s1 = Subst.compose (Subst.unify t1 Types.TBool) s1 in
      let (s2,t2) = infer (Env.apply_env s1 env) e2 in
      let (s3,t3) = infer (Env.apply_env (Subst.compose s2 s1) env) e3 in
      let s4 = Subst.compose (Subst.unify (Subst.apply s3 t2) t3) (Subst.compose s3 s2) in
      (Subst.compose s4 s1, Subst.apply s4 t3)
