(* The Intel P to C/Pillar Compiler *)
(* COPYRIGHT_NOTICE_1 *)

(* Mil utilities *)

signature MACHINE_INT =
sig
  val intArbTyp : Config.t -> IntArb.typ
  val numericTyp : Config.t -> Mil.Prims.numericTyp
  val t : Config.t -> Mil.typ
  val fieldKind : Config.t -> Mil.fieldKind
  val int : Config.t * int -> Mil.constant
  val intInf : Config.t * IntInf.t -> Mil.constant
  val zero : Config.t -> Mil.constant
  val one : Config.t -> Mil.constant
  val maxValue : Config.t -> Mil.constant
  val add : Config.t * Mil.operand * Mil.operand -> Mil.rhs
  val lt : Config.t * Mil.operand * Mil.operand -> Mil.rhs
end;

signature MIL_UTILS =
sig

  structure Compare :
  sig
    type 'a t = 'a Compare.t
    val variable           : Mil.variable t
    val name               : Mil.name t
    val label              : Mil.label t
    val effects            : Mil.effects t
    val callConv           : 'a t -> 'a Mil.callConv t
    val typKind            : Mil.typKind t
    val pObjKind           : Mil.pObjKind t
    val valueSize          : Mil.valueSize t
    val fieldVariance      : Mil.fieldVariance t
    val fieldSize          : Mil.fieldSize t
    val typ                : Mil.typ t
    val typs               : Mil.typ Vector.t t
    val fieldKind          : Mil.fieldKind t
    val fieldDescriptor    : Mil.fieldDescriptor t
    val tupleDescriptor    : Mil.tupleDescriptor t
    val metaDataDescriptor : Mil.metaDataDescriptor t
    val constant           : Mil.constant t
    val simple             : Mil.simple t
    val operand            : Mil.operand t
    val tupleBase          : Mil.tupleBase t
    val vectorIndexKind    : Mil.vectorIndexKind t
    val fieldIdentifier    : Mil.fieldIdentifier t
    val tupleField         : Mil.tupleField t
    val rhs                : Mil.rhs t
    val instruction        : Mil.instruction t
    val target             : Mil.target t
    val switch             : 'a t -> 'a Mil.switch t
    val codes              : Mil.codes t
    val call               : Mil.call t
    val eval               : Mil.eval t
    val interProc          : Mil.interProc t
    val cuts               : Mil.cuts t
    val return             : Mil.return t
    val transfer           : Mil.transfer t
    val block              : Mil.block t
    val codeBody           : Mil.codeBody t
    val code               : Mil.code t
    val global             : Mil.global t
  end

  structure Eq :
  sig
    type 'a t = 'a * 'a -> bool
    val variable           : Mil.variable t
    val name               : Mil.name t
    val label              : Mil.label t
    val effects            : Mil.effects t
    val callConv           : 'a t -> 'a Mil.callConv t
    val typKind            : Mil.typKind t
    val pObjKind           : Mil.pObjKind t
    val valueSize          : Mil.valueSize t
    val fieldVariance      : Mil.fieldVariance t
    val fieldSize          : Mil.fieldSize t
    val typ                : Mil.typ t
    val typs               : Mil.typ Vector.t t
    val fieldKind          : Mil.fieldKind t
    val fieldDescriptor    : Mil.fieldDescriptor t
    val tupleDescriptor    : Mil.tupleDescriptor t
    val metaDataDescriptor : Mil.metaDataDescriptor t
    val constant           : Mil.constant t
    val simple             : Mil.simple t
    val operand            : Mil.operand t
    val tupleBase          : Mil.tupleBase t
    val vectorIndexKind    : Mil.vectorIndexKind t
    val fieldIdentifier    : Mil.fieldIdentifier t
    val tupleField         : Mil.tupleField t
    val rhs                : Mil.rhs t
    val instruction        : Mil.instruction t
    val target             : Mil.target t
    val switch             : 'a t -> 'a Mil.switch t
    val codes              : Mil.codes t
    val call               : Mil.call t
    val eval               : Mil.eval t
    val interProc          : Mil.interProc t
    val cuts               : Mil.cuts t
    val return             : Mil.return t
    val transfer           : Mil.transfer t
    val block              : Mil.block t
    val codeBody           : Mil.codeBody t
    val code               : Mil.code t
    val global             : Mil.global t
  end

  structure CallConv :
  sig
    type 'a t = 'a Mil.callConv
    val compare : 'a Compare.t -> 'a t Compare.t
    val eq : ('a * 'a -> bool) -> ('a t * 'a t -> bool)
    val map : 'a t * ('a -> 'b) -> 'b t
    val foreach : 'a t * ('a -> unit) -> unit
    structure Dec :
    sig
      val ccCode    : 'a t -> unit option
      val ccClosure : 'a t -> {cls : 'a, fvs : 'a Vector.t} option
      val ccThunk   : 'a t -> {thunk : 'a, fvs : 'a Vector.t} option
    end (* structure Dec *)
  end

  structure TypKind :
  sig
    type t = Mil.typKind
    val fromChar : char -> t option
    val toChar : t -> char
    val toString : t -> string
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure PObjKind :
  sig
    type t = Mil.pObjKind
    val fromChar : char -> t option
    val fromTyp : Mil.typ -> t option
    val toChar : t -> char
    val toString : t -> string
    val isP : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure ValueSize :
  sig
    type t = Mil.valueSize
    val numBits : t -> int
    val numBytes : t -> int
    val toString : t -> string
    val fromString : string -> t option
    val intArb : IntArb.typ -> t
    val wordSize : Config.t -> t
    val ptrSize : Config.t -> t
    val vectorSize : Config.t -> t
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure FieldVariance :
  sig
    type t = Mil.fieldVariance
    val mutable : t -> bool
    val immutable : t -> bool
    val fromChar : char -> t option
    val toString : t -> string
    val toChar : t -> char
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure TraceabilitySize :
  sig
    datatype traceability = TRef | TBits
    datatype t =
        TsAny                                  (* top *)
      | TsAnyS of ValueSize.t                  (* traceability unknown, size fixed *)
      | TsBits of ValueSize.t                  (* not GC, not float, not double, not mask, size fixed *)
      | TsFloat
      | TsDouble
      | TsRef                                  (* GC pointers to object starts *)
      | TsNone                                 (* bottom *)
      | TsMask of Mil.Prims.vectorDescriptor   (* masks for given vector type *)
    val toString : Config.t * t -> string
    val traceabilityIsRef : traceability -> bool
    val traceability : t -> traceability option
    val valueSize : Config.t * t -> ValueSize.t option
    val subTS : Config.t * t * t -> bool
  end

  structure Prims : 
  sig
    structure Utils : PRIMS_UTILS

    structure NumericTyp : 
    sig 
      val tFloat  : Mil.typ
      val tDouble : Mil.typ
      val tIntegerArbitrary : Mil.typ
      val tIntegerFixed : IntArb.typ -> Mil.typ
      val tRat : Mil.typ
      val traceabilitySize : Config.t * Mil.Prims.numericTyp -> TraceabilitySize.t
    end

  end

  structure Typ :
  sig

    type t = Mil.typ
    val valueSize : Config.t * t -> ValueSize.t option
    val fieldSize : Config.t * t -> Mil.fieldSize (* PRE: valid conversion *)
    val numBits : Config.t * t -> int option
    val numBytes : Config.t * t -> int option
    val traceabilitySize : Config.t * t -> TraceabilitySize.t
    val fromTraceabilitySize : TraceabilitySize.t -> t
    val traceability : Config.t * t -> TraceabilitySize.traceability option
    val isNonRefPtr : t -> bool
    val isRef : t -> bool
    val isP : t -> bool
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool

    val fixedArray : PObjKind.t * (t * FieldVariance.t) Vector.t -> t

    structure Dec :
    sig
      val tAny : t -> unit option
      val tAnyS : t -> Mil.valueSize  option
      val tNonRefPtr : t -> unit option
      val tRef : t -> unit option
      val tBits : t -> Mil.valueSize  option
      val tNone : t -> unit option
      val tName : t -> unit option
      val tNumeric : t -> Mil.Prims.numericTyp option
      val tBoolean : t -> unit option
      val tViVector : t -> {vectorSize : Mil.Prims.vectorSize, 
                            elementTyp : Mil.typ} option
      val tViMask : t -> Mil.Prims.vectorDescriptor option
      val tCode : t -> {cc : t Mil.callConv, args : t Vector.t, ress : t Vector.t} option
      val tTuple :
          t -> {pok   : Mil.pObjKind, fixed : (t * Mil.fieldVariance) Vector.t, array : t * Mil.fieldVariance} option
      val tCString : t -> unit option
      val tIdx : t -> unit option
      val tContinuation : t -> t Vector.t option
      val tThunk : t -> t option
      val tPAny : t -> unit option
      val tClosure : t -> {args : t Vector.t, ress : t Vector.t} option
      val tPSum : t -> t Mil.ND.t option
      val tPType : t -> {kind : Mil.typKind, over : t} option
      val tPRef : t -> t option
    end (* structure Dec *)

  end

  structure FieldSize :
  sig
    type t = Mil.fieldSize
    val numBits : t -> int
    val numBytes : t -> int
    val toValueSize : t -> ValueSize.t
    val toString : t -> string
    val fromString : string -> t option
    val intArbSz : IntArb.size -> t
    val toIntArbSz : t -> IntArb.size
    val intArb : IntArb.typ -> t
    val wordSize : Config.t -> t
    val ptrSize : Config.t -> t
    val compare : t Compare.t
    val eq : t * t -> bool
    val fromValueSize : ValueSize.t -> t (* pre: valid conversion *)
    structure Dec :
    sig
      val fs8  : t -> unit option
      val fs16 : t -> unit option
      val fs32 : t -> unit option
      val fs64 : t -> unit option
    end (* structure Dec *)
  end

  structure FieldKind :
  sig
    type t = Mil.fieldKind
    val fieldSize : Config.t * t -> FieldSize.t
    val valueSize : Config.t * t -> ValueSize.t
    val numBits : Config.t * t -> int
    val numBytes : Config.t * t -> int
    val traceability : t -> TraceabilitySize.traceability
    val isRef : t -> bool
    val toString : t -> string
    val compare : t Compare.t
    val eq : t * t -> bool
    val fromString : string -> t option
    val nonRefPtr : Config.t -> t
    val fromTraceSize : Config.t * TraceabilitySize.t -> t
    val toTraceSize : Config.t * t -> TraceabilitySize.t (* pre: result determined *)
    val fromTyp : Config.t * Typ.t -> t (* pre: result determined *)
    val fromTyp' : Config.t * Typ.t -> t option
    val toTyp : t -> Typ.t 
  end

  structure FieldDescriptor :
  sig
    type t = Mil.fieldDescriptor
    val fieldSize : Config.t * t -> FieldSize.t
    val valueSize : Config.t * t -> ValueSize.t
    val numBits : Config.t * t -> int
    val numBytes : Config.t * t -> int
    val traceability : t -> TraceabilitySize.traceability
    val isRef : t -> bool
    val kind : t -> FieldKind.t
    val var : t -> FieldVariance.t
    val mutable : t -> bool
    val immutable : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure TupleDescriptor :
  sig
    type t = Mil.tupleDescriptor
    val fixedFields : t -> FieldDescriptor.t Vector.t
    val numFixed : t -> int
    val fixedField : t * int -> FieldDescriptor.t
    val array : t -> FieldDescriptor.t option
    val hasArray : t -> bool
    val immutable : t -> bool
    val getField : t * int -> FieldDescriptor.t option
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure MetaDataDescriptor :
  sig
    type t = Mil.metaDataDescriptor
    val pok : t -> PObjKind.t
    val fixedFields : t -> FieldDescriptor.t Vector.t
    val numFixed : t -> int
    val fixedField : t * int -> FieldDescriptor.t
    val array : t -> (int * FieldDescriptor.t) option
    val lengthField : t -> int option
    val arrayDescriptor : t -> FieldDescriptor.t option
    val hasArray : t -> bool
    val immutable : t -> bool
    val toTupleDescriptor : t -> TupleDescriptor.t
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure Constant :
  sig
    type t = Mil.constant
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    val pObjKind : t -> Mil.pObjKind option
    structure Dec :
    sig
      val cBoolean : t -> bool option
      val cRat : t -> IntInf.t option
      val cInteger : t -> IntInf.t option
      val cName : t -> Mil.name option
      val cIntegral : t -> IntArb.t option
      val cFloat : t -> Real32.t option
      val cDouble : t -> Real64.t option
      val cViMask : t -> {descriptor : Mil.Prims.vectorDescriptor, elts : bool Vector.t} option
      val cPok : t -> Mil.pObjKind option
      val cOptionSetEmpty : t -> unit option
      val cTypePH : t -> unit option
    end (* structure Dec *)
  end

  structure Simple :
  sig
    type t = Mil.simple
    val compare : t Compare.t
    val eq : t * t -> bool
    val pObjKind : t -> Mil.pObjKind option
    structure Dec :
    sig
      val sVariable : t -> Mil.variable option
      val sConstant : t -> Mil.constant option
    end (* structure Dec *)
  end

  structure Operand :
  sig
    type t = Mil.operand
    val compare : t Compare.t
    val eq : t * t -> bool
    structure Dec :
    sig
      val sVariable : t -> Mil.variable option
      val sConstant : t -> Mil.constant option
    end (* structure Dec *)
  end

  structure TupleBase : 
  sig
    type t = Mil.tupleBase
    val compare : t Compare.t
    val eq      : t Eq.t
    structure Dec : 
    sig
      val tbScalar : t -> unit option
      val tbVector : t -> unit option
    end (* structure Dec *)
  end (* structure TupleBase *)

  structure VectorIndexKind : 
  sig
    type t = Mil.vectorIndexKind
    val compare : t Compare.t
    val eq      : t Eq.t
    structure Dec : 
    sig
      val vikStrided : t -> int option
      val vikVector  : t -> unit option
    end (* structure Dec *)
  end (* structure VectorIndexKind *)

  structure FieldIdentifier :
  sig
    type t = Mil.fieldIdentifier
    val compare : t Compare.t
    val eq      : t Eq.t
    val isFixed : t -> bool
    val isVariable : t -> bool
    val isScalar : t -> bool
    val isVector : t -> bool
    val isVectorIndex : t -> bool
    val fixed : t -> int option
    val variable : t -> Operand.t option
    val fieldDescriptor : TupleDescriptor.t * t -> FieldDescriptor.t
    structure Dec : 
    sig
      val fiFixed          : t -> int option
      val fiVariable       : t -> Mil.operand option
      val fiVectorFixed    : t -> 
                             {descriptor : Mil.Prims.vectorDescriptor,
                              mask : Mil.operand option,
                              index : int} option
      val fiVectorVariable : t ->
                             {descriptor : Mil.Prims.vectorDescriptor,
                              base : Mil.tupleBase,
                              mask : Mil.operand option,
                              index : Mil.operand,
                              kind: Mil.vectorIndexKind} option
    end (* structure Dec *)
  end

  structure TupleField :
  sig
    type t = Mil.tupleField
    val tupDesc : t -> TupleDescriptor.t
    val tup : t -> Mil.variable
    val field : t -> FieldIdentifier.t
    val fieldDescriptor : t -> FieldDescriptor.t
    val isFixed : t -> bool
    val isVariable : t -> bool
    val isScalar : t -> bool
    val isVector : t -> bool
    val isVectorIndex : t -> bool
    val fixed : t -> int option
    val variable : t -> Operand.t option
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure Rhs :
  sig
    type t = Mil.rhs
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    structure Dict : DICT where type key = t
    val fx : Config.t * t -> Effect.set
    val isInit : t -> bool
    val isInitOf : t * Mil.variable -> bool
    val pObjKind : t -> Mil.pObjKind option
    val arity : Config.t * t -> int
    structure Dec :
    sig
      val rhsSimple : t -> Mil.simple option
      val rhsPrim : t -> {prim : Mil.Prims.t, 
                          createThunks : bool, 
                          typs : Mil.typ Vector.t, 
                          args : Mil.operand Vector.t} option
      val rhsTuple : t -> {mdDesc : Mil.metaDataDescriptor,  
                           inits  : Mil.operand Vector.t} option
      val rhsTupleSub : t -> Mil.tupleField option
      val rhsTupleSet : t -> {tupField : Mil.tupleField, ofVal: Mil.operand} option
      val rhsTupleInited : t -> {mdDesc : Mil.metaDataDescriptor, tup : Mil.variable} option
      val rhsIdxGet : t -> {idx : Mil.variable, ofVal : Mil.operand} option
      val rhsCont : t -> Mil.label option
      val rhsObjectGetKind : t -> Mil.variable option
      val rhsThunkMk : t -> {typ : Mil.fieldKind, fvs : Mil.fieldKind Vector.t} option
      val rhsThunkInit : t -> {
        typ   : Mil.fieldKind,
        thunk : Mil.variable option, 
        fx    : Mil.effects,
        code  : Mil.variable option, 
        fvs   : (Mil.fieldKind * Mil.operand) Vector.t
      } option
      val rhsThunkGetFv : t -> {
        typ   : Mil.fieldKind,
        fvs   : Mil.fieldKind Vector.t,
        thunk : Mil.variable,
        idx   : int
      } option
      val rhsThunkValue : t -> {
        typ    : Mil.fieldKind,
        thunk  : Mil.variable option, 
        ofVal : Mil.operand
      } option
      val rhsThunkGetValue : t -> {typ : Mil.fieldKind, thunk : Mil.variable} option
      val rhsThunkSpawn : t -> {typ : Mil.fieldKind, thunk : Mil.variable, fx : Mil.effects} option
      val rhsClosureMk : t -> {fvs : Mil.fieldKind Vector.t} option
      val rhsClosureInit : t -> {
        cls  : Mil.variable option, 
        code : Mil.variable option, 
        fvs  : (Mil.fieldKind * Mil.operand) Vector.t
      } option
      val rhsClosureGetFv : t -> {fvs : Mil.fieldKind Vector.t, cls : Mil.variable, idx : int} option
      val rhsPSetNew : t -> Mil.operand option
      val rhsPSetGet : t -> Mil.variable option
      val rhsPSetCond : t -> {bool : Mil.operand, ofVal: Mil.operand} option
      val rhsPSetQuery : t -> Mil.operand option
      val rhsPSum : t -> {tag : Mil.name, typ : Mil.fieldKind, ofVal : Mil.operand} option
      val rhsPSumProj : t -> {typ : Mil.fieldKind, sum : Mil.variable, tag : Mil.name} option
    end (* structure Dec *)
  end

  structure Instruction :
  sig
    type t = Mil.instruction
    val new : Mil.variable * Mil.rhs -> Mil.instruction
    val new' : Mil.variable vector * Mil.rhs -> Mil.instruction
    val dests : t -> Mil.variable vector
    val dest : t -> Mil.variable option (* Requires zero/one dest *)
    val n : t -> int
    val rhs : t -> Rhs.t
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    val fx : Config.t * t -> Effect.set
    val isInit : t -> bool
    val isInitOf : t * Mil.variable -> bool
    val pObjKind : t -> Mil.pObjKind option
  end

  structure Target :
  sig
    type t = Mil.target
    val block : t -> Mil.label
    val arguments : t -> Operand.t Vector.t
    val argument : t * int -> Operand.t
    val compare : t Compare.t
    val eq : t * t -> bool
    val fromVars : Mil.label * Mil.variable Vector.t -> t
    structure Dec :
    sig
      val t : t -> {block : Mil.label, arguments : Operand.t Vector.t}
    end
  end

  structure Switch :
  sig
    type 'a t = 'a Mil.switch
    val on : 'a t -> Operand.t
    val cases : 'a t -> ('a * Target.t) Vector.t
    val getCase : 'a t * int -> 'a * Target.t
    val caseValue : 'a t * int -> 'a
    val caseTarget : 'a t * int -> Target.t
    val default : 'a t -> Target.t option
    val hasDefault : 'a t -> bool
    val compare : 'a Compare.t -> 'a t Compare.t
    val eq : ('a * 'a -> bool) -> ('a t * 'a t -> bool)
    val noDefault : Operand.t * ('a * Target.t) Vector.t -> 'a t
    val noArgs : Operand.t * ('a * Mil.label) Vector.t * Mil.label option -> 'a t
    val noArgsNoDefault : Operand.t * ('a * Mil.label) Vector.t -> 'a t
  end

  structure Codes :
  sig
    type t = Mil.codes
    val possible : t -> Mil.VS.t
    val exhaustive : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    val all : t
    val none : t
  end

  structure Call :
  sig
    type t = Mil.call
    val compare : t Compare.t
    val eq : t * t -> bool
    val cls : t -> Mil.variable option
    val code : t -> Mil.variable option
    val codes : t -> Mil.codes
    structure Dec : 
    sig
      val cCode : t -> {ptr : Mil.variable, code : Mil.codes} option
      val cClosure : t -> {cls : Mil.variable, code : Mil.codes} option
      val cDirectClosure : t -> {cls : Mil.variable, code : Mil.variable} option
    end (* structure Dec *)
  end

  structure Eval :
  sig
    type t = Mil.eval
    val compare : t Compare.t
    val eq : t * t -> bool
    val thunk : t -> Mil.variable 
    val codes : t -> Mil.codes
    structure Dict : DICT where type key = t
    structure Dec : 
    sig
      val eThunk : t -> {thunk : Mil.variable, code : Mil.codes} option
      val eDirectThunk : t -> {thunk : Mil.variable, code : Mil.variable} option
    end (* structure Dec *)
  end

  structure InterProc :
  sig
    type t = Mil.interProc
    val compare : t Compare.t
    val eq : t * t -> bool
    val codes : t -> Mil.codes
    structure Dec : 
    sig
      val ipCall : t -> {call : Mil.call, args : Mil.operand Vector.t} option
      val ipEval : t -> {typ : Mil.fieldKind, eval : Mil.eval} option
    end (* structure Dec *)
  end

  structure Cuts :
  sig
    type t = Mil.cuts
    val exits : t -> bool
    val targets : t -> Mil.LS.t
    val hasCuts : t -> bool
    val includes : t * Mil.label -> bool
    val union : t * t -> t
    val intersection : t * t -> t
    (* inlineCall (cs1, cs2):
     *   A calls B with cuts cs2, B calls C with cuts cs1, compute the cuts for the call to C when B is inlined into
     *   A, note that this assumes B's code is placed into A, not copied with label duplication.  If B's code is
     *   copied with label duplication into A, then cs1 should be adjusted to the new labels first.
     *)
    val inlineCall : t * t -> t
    val compare : t Compare.t
    val eq : t * t -> bool
    val none : t
    val justExits : t
  end

  structure Return :
  sig
    type t = Mil.return
    val compare : t Compare.t
    val eq : t * t -> bool
    val cuts : t -> Cuts.t
    val binds : t -> Mil.variable Vector.t
    structure Dec : 
    sig
      val rNormal : t -> {rets : Mil.variable Vector.t, block : Mil.label, cuts : Mil.cuts} option
      val rTail : t -> {exits : bool} option
    end (* structure Dec *)
  end

  structure OutEdge :
  sig
    datatype kind =
        OekGoto of {args : Operand.t Vector.t}
      | OekCase of {on : Operand.t, eq : Constant.t, args : Operand.t Vector.t}
      | OekCaseDefault of {on    : Operand.t, cases : Constant.t Vector.t, args  : Operand.t Vector.t}
      | OekInterProcRet of {callee : InterProc.t, rets : Mil.variable Vector.t, fx : Mil.effects}
      | OekInterProcTail of {callee : InterProc.t, fx : Mil.effects}
      | OekReturn of Operand.t Vector.t
      | OekCut
      | OekHalt of Operand.t
      | OekPSumCase of {on : Operand.t, eq : Mil.name, args : Operand.t Vector.t}
      | OekPSumCaseDefault of {on : Operand.t, cases : Mil.name Vector.t, args : Operand.t Vector.t}
    datatype dest = OedBlock of Mil.label | OedExit
    datatype t = OE of {kind : kind, dest : dest}
    val target : t -> Mil.label option
    val exits  : t -> bool
  end

  structure Transfer :
  sig
    type t = Mil.transfer
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    val outEdges : t -> OutEdge.t Vector.t
    val targets : t -> {blocks : Mil.label Vector.t, exits : bool}
    val successors : t -> {blocks : Identifier.LabelSet.t, exits : bool}
    val cuts : t -> Cuts.t
    val isBoolIf : t -> {on : Operand.t, trueBranch : Target.t, falseBranch : Target.t} option
    val isIntraProcedural : t -> Target.t Vector.t option
    val mapOverTargets : t * (Mil.target -> Mil.target) -> t
    val fx : Config.t * t -> Effect.set
    val binds : t -> Mil.variable Vector.t
    structure Dec : 
    sig
      val tGoto : t -> Mil.target option
      val tCase : t -> Mil.constant Mil.switch option
      val tInterProc : t -> {callee : Mil.interProc, ret : Mil.return, fx : Mil.effects} option
      val tReturn : t -> Mil.operand Vector.t option
      val tCut : t -> {cont : Mil.variable, args : Mil.operand Vector.t, cuts : Mil.cuts} option
      val tHalt : t -> Mil.operand option
      val tPSumCase : t -> Mil.name Mil.switch option
    end (* structure Dec *)
  end

  structure Block :
  sig
    type t = Mil.block
    val parameters : t -> Mil.variable Vector.t
    val numParameters : t -> int
    val parameter : t * int -> Mil.variable
    val instructions : t -> Instruction.t Vector.t
    val numInstructions : t -> int
    val instruction : t * int -> Instruction.t
    val transfer : t -> Transfer.t
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    val outEdges : t -> OutEdge.t Vector.t
    val targets : t -> {blocks : Mil.label Vector.t, exits : bool}
    val successors : t -> {blocks : Identifier.LabelSet.t, exits : bool}
    val cuts : t -> Cuts.t
    val getBoolSuccessors : Mil.block -> (Mil.label * Mil.label) option
  end

  structure CodeBody :
  sig
    type t = Mil.codeBody
    val entry : t -> Mil.label
    val blocks : t -> Block.t Mil.LD.t
    val numBlocks : t -> int
    val labels : t -> Mil.LS.t
    val block : t * Mil.label -> Block.t
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
    val listAny : t -> (Mil.label * Block.t) list
    val listRPO : Config.t * t -> (Mil.label * Block.t) list
    val dfsTrees : t -> (Mil.label * Block.t) Tree.t Vector.t
  end

  structure Code :
  sig
    type t = Mil.code

    val fx : t -> Mil.effects
    val escapes : t -> bool
    val recursive : t -> bool
    val cc : t -> Mil.variable CallConv.t
    val args : t -> Mil.variable Vector.t
    val rtyps : t -> Typ.t Vector.t
    val body : t -> CodeBody.t

    val setFx : t * Mil.effects -> t
    val setEscapes : t * bool -> t
    val setRecursive : t * bool -> t
    val setCc : t * Mil.variable CallConv.t -> t
    val setArgs : t * Mil.variable Vector.t -> t
    val setRtyps : t * Typ.t Vector.t -> t
    val setBody : t * CodeBody.t -> t

    val numArgs : t -> int
    val arg : t * int -> Mil.variable
    val numRtyps : t -> int
    val rtyp : t * int -> Typ.t
    val thunkTyp : t -> Typ.t (* For CcThunk, extra single return type *)
    val entry : t -> Mil.label
    val blocks : t -> Block.t Mil.LD.t
    val numBlocks : t -> int
    val labels : t -> Mil.LS.t
    val block : t * Mil.label -> Block.t
    val isCore : t -> bool
    val compare : t Compare.t
    val eq : t * t -> bool
  end

  structure Global :
  sig
    type t = Mil.global
    val isCore : t -> bool
    structure Dict : DICT where type key = t
    val compare : t Compare.t
    val eq : t * t -> bool
    val pObjKind : t -> Mil.pObjKind option
    val immutable : t -> bool
    structure Dec : 
    sig
      val gCode : t -> Mil.code option
      val gErrorVal : t -> Mil.typ option
      val gIdx : t -> int Mil.ND.t option
      val gTuple : t -> {mdDesc : Mil.metaDataDescriptor, inits  : Mil.simple Vector.t} option
      val gRat : t -> Rat.t option
      val gInteger : t -> IntInf.t option
      val gCString : t -> string option
      val gThunkValue : t -> {typ : Mil.fieldKind, ofVal : Mil.simple} option
      val gSimple : t -> Mil.simple option
      val gClosure : t -> {code : Mil.variable option, fvs  : (Mil.fieldKind * Mil.operand) Vector.t} option
      val gPSum : t -> {tag : Mil.name, typ : Mil.fieldKind, ofVal : Mil.simple} option
      val gPSet : t -> Mil.simple option
    end (* structure Dec *)

  end

  structure Globals :
  sig
    type t = Mil.globals
    val num : t -> int
    val vars : t -> Mil.VS.t
    val get : t * Mil.variable -> Global.t
  end

  structure VariableKind :
  sig
    type t = Mil.variableKind
    val toChar : t -> char
    val toString : t -> string
  end

  structure VariableInfo :
  sig
    type t = Mil.variableInfo
    val typ : t -> Typ.t
    val kind : t -> VariableKind.t
  end

  structure IncludeKind :
  sig
    type t = Mil.includeKind
    val fromString : string -> t option
    val toString : t -> string
  end

  structure IncludeFile :
  sig
    type t = Mil.includeFile
    val name : t -> string
    val kind : t -> IncludeKind.t
    val externs : t -> Identifier.VariableSet.t
  end

  structure SymbolTable :
  sig
    type t = Mil.symbolTable
    val variableInfo : t * Mil.variable -> VariableInfo.t
    val variableTyp : t * Mil.variable -> Typ.t
    val variableKind : t * Mil.variable -> VariableKind.t
  end

  structure SymbolTableManager :
  sig
    type t = Mil.symbolTableManager
    val variableInfo : t * Mil.variable -> VariableInfo.t
    val variableTyp : t * Mil.variable -> Typ.t
    val variableKind : t * Mil.variable -> VariableKind.t
    val variableFresh : t * string * Typ.t * VariableKind.t -> Mil.variable
    val variableFreshNoInfo : t * string -> Mil.variable
    val variableClone : t * Mil.variable -> Mil.variable
    val variableRelated : t * Mil.variable * string * Typ.t * VariableKind.t -> Mil.variable
    val variableRelatedNoInfo : t * Mil.variable * string -> Mil.variable
    val variableHasInfo : t * Mil.variable -> bool
    val variableSetInfo : t * Mil.variable * VariableInfo.t -> unit
    val nameMake : t * string -> Mil.name
    val labelFresh : t -> Mil.label
    val finish : t -> SymbolTable.t
  end

  structure SymbolInfo :
  sig
    type t = Mil.symbolInfo
    val variableExists : t * Mil.variable -> bool
    val variableInfo : t * Mil.variable -> VariableInfo.t
    val variableTyp : t * Mil.variable -> Typ.t
    val variableKind : t * Mil.variable -> VariableKind.t
    val variableName : t * Mil.variable -> string
    val variableNameEscaped : t * Mil.variable -> string
    val variableString : t * Mil.variable -> string
    val variableStringEscaped : t * Mil.variable -> string
    val nameString : t * Mil.name -> string
    val nameStringEscaped : t * Mil.name -> string
    val layoutVariable : t * Mil.variable -> Layout.t
    val layoutVariableEscaped : t * Mil.variable -> Layout.t
    val layoutName : t * Mil.name -> Layout.t
    val layoutNameEscaped : t * Mil.name -> Layout.t
    val layoutLabel : t * Mil.label -> Layout.t
  end

  structure Program :
  sig
    type t = Mil.t
    val includes : t -> IncludeFile.t Vector.t
    val incl : t * int -> IncludeFile.t
    val externs : t -> Identifier.VariableSet.t     (* Just the externs not in include files *)
    val externVars : t -> Identifier.VariableSet.t  (* All external variables *)
    val globals : t -> Globals.t
    val numGlobals : t -> int
    val globalVars : t -> Mil.VS.t
    val global : t * Mil.variable -> Global.t
    val symbolTable : t -> SymbolTable.t
    val entry : t -> Mil.variable
  end

  structure Uintp : MACHINE_INT

  structure Sintp : MACHINE_INT

  structure Bool :
  sig
    val t : Config.t -> Typ.t
    val T : Config.t -> Constant.t
    val F : Config.t -> Constant.t
    val fromBool : Config.t * bool -> Constant.t
    val toBool : Config.t * Constant.t -> bool option
    (* XXX NG: mark which one is true and which false *)
    val ifS : Config.t * Operand.t * {trueT : Target.t, falseT : Target.t} -> Constant.t Switch.t
    val ifT : Config.t * Operand.t * {trueT : Target.t, falseT : Target.t} -> Transfer.t
  end

  structure Boxed :
  sig
    val td : FieldKind.t -> TupleDescriptor.t
    val t : PObjKind.t * Typ.t -> Typ.t
    val box : Config.t * PObjKind.t * FieldKind.t * Operand.t -> Rhs.t
    val boxGlobal : Config.t * PObjKind.t * FieldKind.t * Simple.t -> Global.t
    val ofValIndex : int
    val unbox : Config.t * FieldKind.t * Mil.variable -> Rhs.t
  end

  (* This defines constructors for fixed length Mil tuples. *)
  structure Tuple :
  sig
    val typ : Mil.pObjKind * (Mil.typ * Mil.fieldVariance) Vector.t -> Mil.typ

    val td : Mil.fieldDescriptor Vector.t -> Mil.tupleDescriptor
    val mdd : Mil.pObjKind * (Mil.fieldDescriptor Vector.t) -> Mil.metaDataDescriptor

    (* These assume PokNone *)
    val mddImmutable     : Mil.fieldKind Vector.t -> Mil.metaDataDescriptor
    val mddImmutableTyps : Config.t * Mil.typ Vector.t -> Mil.metaDataDescriptor
    val mddImmutableRefs : int -> Mil.metaDataDescriptor
    val mddImmutableBits : int * Mil.fieldSize -> Mil.metaDataDescriptor

    val tdImmutable     : Mil.fieldKind Vector.t -> Mil.tupleDescriptor
    val tdImmutableRefs : int -> Mil.tupleDescriptor
    val tdImmutableBits : int * Mil.fieldSize -> Mil.tupleDescriptor

    val new : Mil.metaDataDescriptor * Mil.operand Vector.t -> Mil.rhs
    val proj : Mil.tupleDescriptor * Mil.variable * int -> Mil.rhs
    val init : Mil.tupleDescriptor * Mil.variable * int * Mil.operand -> Mil.rhs 
    val inited : Mil.metaDataDescriptor * Mil.variable -> Mil.rhs
  end (* structure Tuple *)

  (* This defines an abstraction of variable length arrays in MIL.  
   * These arrays always have length fields (even if created via
   * the newFixed constructor *)
  structure OrdinalArray :
  sig
    val tdVar : Config.t * Mil.fieldKind -> Mil.tupleDescriptor
    val fixedTyp : Config.t * PObjKind.t * Typ.t Vector.t -> Typ.t
    val varTyp : Config.t * PObjKind.t * Typ.t -> Typ.t
    datatype typ = TNot | TFixed of Typ.t Vector.t | TVar of Typ.t
    val isTyp : Config.t * Typ.t -> typ
    val newFixed : Config.t * PObjKind.t * FieldKind.t Vector.t
                   * Mil.operand Vector.t
                   -> Rhs.t
    val newVar : Config.t * PObjKind.t * FieldKind.t * Mil.operand -> Rhs.t
    val lenIndex : int
    val length : Config.t * Mil.variable -> Rhs.t
    val sub : Config.t * FieldKind.t * Mil.variable * Operand.t
              -> Rhs.t
    val update : Config.t * FieldKind.t * Mil.variable * Operand.t
                 * Operand.t
                 -> Rhs.t
    val inited : Config.t * PObjKind.t * FieldKind.t * Mil.variable -> Rhs.t
  end

  structure IndexedArray :
  sig
    val tdVar : Config.t * Mil.fieldKind -> Mil.tupleDescriptor
    val fixedTyp :
        Config.t * PObjKind.t * int Identifier.NameDict.t * Typ.t Vector.t
        -> Typ.t
    val varTyp : Config.t * PObjKind.t * Typ.t -> Typ.t
    val newFixed : Config.t * PObjKind.t * int Identifier.NameDict.t
                   * FieldKind.t Vector.t * Mil.variable * Mil.operand Vector.t
                   -> Rhs.t
    val lenIndex : int
    val idxIndex : int
    val length : Config.t * Mil.variable -> Rhs.t
    val index : Config.t * FieldKind.t * Mil.variable -> Rhs.t
    val idxSub : Config.t * FieldKind.t * Mil.variable * Operand.t
                 -> Rhs.t
  end

  structure Rational :
  sig
    val t : Mil.typ
    val from : Mil.Prims.numericTyp * Mil.operand -> Mil.rhs
    val fromIntegral : IntArb.typ * Mil.operand -> Mil.rhs
    val fromUintp : Config.t * Mil.operand -> Mil.rhs
    val fromSintp : Config.t * Mil.operand -> Mil.rhs
    structure Opt :
    sig
      val max : IntInf.t
      val min : IntInf.t
      val integerFits  : IntInf.t -> bool
      val rationalFits : Rat.t -> bool
      val fromInteger : IntInf.t -> Mil.constant option
      val fromRational : Rat.t -> Mil.constant option
    end (* structure Opt *)

  end (* structure Rational *)

  structure Integer :
  sig
    val t : Mil.typ
    val from : Mil.Prims.numericTyp * Mil.operand -> Mil.rhs
    val fromIntegral : IntArb.typ * Mil.operand -> Mil.rhs
    val fromUintp : Config.t * Mil.operand -> Mil.rhs
    val fromSintp : Config.t * Mil.operand -> Mil.rhs
    structure Opt :
    sig
      val max : IntInf.t
      val min : IntInf.t
      val integerFits  : IntInf.t -> bool
      val rationalFits : Rat.t -> bool
      val fromInteger : IntInf.t -> Mil.constant option
      val fromRational : Rat.t -> Mil.constant option
    end (* structure Opt *)
  end (* structure Integer *)

  structure Def :
  sig
    datatype t = 
             DefGlobal of Mil.global
           | DefRhs of Mil.rhs

    structure Out : 
    sig
      val tuple : t -> {mdDesc : Mil.metaDataDescriptor, inits  : Mil.simple Vector.t} option
      val thunkValue : t -> {typ : Mil.fieldKind, ofVal : Mil.simple} option
      val simple : t -> Mil.simple option
      val pFunction : t -> {code : Mil.variable option, fvs : (Mil.fieldKind * Mil.operand) Vector.t} option
      val pSum : t -> {tag : Mil.name, typ : Mil.fieldKind, ofVal : Mil.simple} option
      val pSet : t -> Mil.simple option
    end (* structure Out *)
  end (* structure Def *)

  structure Id : 
  sig
    datatype t = 
        L of Mil.label    (* block label *)
      | I of int          (* numbered instruction *)
      | T of Mil.label    (* block transfer *)
      | G of Mil.variable (* global *)

    val compare : t Compare.t
    val eq : t * t -> bool
    val layout : Mil.symbolInfo * t -> Layout.t 

    structure Set : SET where type element = t
    structure Dict : DICT where type key = t
    structure ImpDict : DICT_IMP where type key = t
  end (* structure Id *)

  structure FlatTyp :
  sig
    (* Flat typs are the nullary super-types of the general types *)
    val fromTyp : Config.t * Mil.typ -> Mil.typ
  end (* structure FlatTyp *)

  (* Compiler assumptions about pointers into the heap *)
  structure HeapModel : 
  sig
    val null : Config.t -> IntInf.t
    val validRefConstant : Config.t * IntInf.t -> bool
  end (* structure HeapModel *)
end;

functor Intp(val sgn : IntArb.signed
             val ptrSize : Config.t -> Mil.fieldSize) :> MACHINE_INT =
struct

  structure IA = IntArb
  structure M = Mil
  structure MP = Mil.Prims

  fun intArbTyp config = IA.T (Config.targetWordSize' config, sgn)

  fun numericTyp config = MP.NtInteger (MP.IpFixed (intArbTyp config))

  fun t config = M.TNumeric (numericTyp config)

  fun fieldKind config = M.FkBits (ptrSize config)

  fun int (config, i) = 
      let
        val iat = intArbTyp config
      in
        if IA.fits (iat, IntInf.fromInt i) then 
          M.CIntegral (IA.fromInt (iat, i))
        else
          Fail.fail ("MilUtils.Intp", "int", "Doesn't fit")
      end

  fun intInf (config, i) = 
      let
        val iat = intArbTyp config
      in
        if IA.fits (iat, i) then 
          M.CIntegral (IA.fromIntInf (iat, i))
        else
          Fail.fail ("MilUtils.Intp", "intInf", "Doesn't fit")
      end

  fun zero config = int (config, 0)

  fun one config = int (config, 1)

  fun maxValue config = intInf (config, IA.maxValue (intArbTyp config))

  fun binArith (config, a, o1, o2) =
      M.RhsPrim {prim = MP.Prim (MP.PNumArith {typ = numericTyp config, operator = a}),
                 createThunks = false,
                 typs = Vector.new0 (),
                 args = Vector.new2 (o1, o2)}

  fun cmp (config, c, o1, o2) =
      M.RhsPrim {prim = MP.Prim (MP.PNumCompare {typ = numericTyp config, operator = c}),
                 createThunks = false,
                 typs = Vector.new0 (),
                 args = Vector.new2 (o1, o2)}

  fun add (config, o1, o2) = binArith (config, MP.APlus, o1, o2)

  fun lt (config, o1, o2) = cmp (config, MP.CLt, o1, o2)

end

structure MilUtils :> MIL_UTILS =
struct

  structure VI = VectorInstructions
  structure I = Identifier
  structure IM = I.Manager
  structure SI = I.SymbolInfo
  structure VS = I.VariableSet
  structure VD = I.VariableDict
  structure ND = I.NameDict
  structure LS = I.LabelSet
  structure LD = I.LabelDict

  structure IA = IntArb 
  structure M = Mil
  structure MP = Mil.Prims

  structure Chat = ChatF(type env = Config.t
                         fun extract c = c
                         val name = "MilUtils"
                         val indent = 0)


  structure FieldSize =
  struct

    type t = Mil.fieldSize

    val ord = 
     fn fs =>
        (case fs of M.Fs8 => 0 | M.Fs16 => 1 | M.Fs32 => 2 | M.Fs64 => 3)

    val toValueSize =
     fn fs =>
        (case fs
          of M.Fs8  => M.Vs8
           | M.Fs16 => M.Vs16
           | M.Fs32 => M.Vs32
           | M.Fs64 => M.Vs64)
                       
    val numBytes = 
     fn fs =>
        (case fs
          of M.Fs8  => 1
           | M.Fs16 => 2
           | M.Fs32 => 4
           | M.Fs64 => 8)
        
    val numBits = 
     fn fs => numBytes fs * 8

    val toString = 
     fn fs => "S" ^ (Int.toString (numBits fs))

    val fromString = 
     fn s =>
        (case s
          of "S8"  => SOME M.Fs8
           | "S16" => SOME M.Fs16
           | "S32" => SOME M.Fs32
           | "S64" => SOME M.Fs64
           | _     => NONE)

    fun intArbSz (sz : IntArb.size) : t =
        case sz
         of IntArb.S8   => M.Fs8
          | IntArb.S16  => M.Fs16
          | IntArb.S32  => M.Fs32
          | IntArb.S64  => M.Fs64

    val toIntArbSz : t -> IntArb.size = 
     fn fk => 
        (case fk
         of M.Fs8  => IntArb.S8
          | M.Fs16 => IntArb.S16
          | M.Fs32 => IntArb.S32
          | M.Fs64 => IntArb.S64)

    val intArb = 
     fn (IA.T (sz, _)) =>
        intArbSz sz

    val ptrSize =
     fn config =>
        (case Config.targetWordSize config
          of Config.Ws32 => M.Fs32
           | Config.Ws64 => M.Fs64)

    val wordSize = ptrSize

    val compare = fn (fs1, fs2) => Compare.fromOrd ord (fs1, fs2)

    val eq = Equality.fromCompare compare

    val fromValueSize =
     fn vs =>
        let
          fun err s = Fail.fail ("MilUtils.FieldSize", "fromValueSize",
                                 "bad value size " ^ s)
        in
          case vs
           of M.Vs8   => M.Fs8
            | M.Vs16  => M.Fs16
            | M.Vs32  => M.Fs32
            | M.Vs64  => M.Fs64
            | M.Vs128 => err "Vs128"
            | M.Vs256 => err "Vs256"
            | M.Vs512 => err "Vs512"
            | M.Vs1024 => err "Vs1024"
        end

    structure Dec =
    struct
      val fs8  : t -> unit option = 
       fn a => case a of M.Fs8 => SOME () | _ => NONE
      val fs16 : t -> unit option = 
       fn a => case a of M.Fs16 => SOME () | _ => NONE
      val fs32 : t -> unit option = 
       fn a => case a of M.Fs32 => SOME () | _ => NONE
      val fs64 : t -> unit option = 
       fn a => case a of M.Fs64 => SOME () | _ => NONE
    end (* structure Dec *)

  end (* structure FieldSize *)

  structure PrimsUtils = PrimsUtilsF(structure FieldSize = FieldSize)

  structure Compare =
  struct

    structure C = Compare
    type 'a t = 'a C.t

    val variable = I.variableCompare
    val name     = I.nameCompare
    val label    = I.labelCompare

    val effects = Effect.compare

    fun callConv cmp (c1, c2) =
        let
          val ccClosure = C.rec2 (#cls, cmp, #fvs, C.vector cmp)
          val ccThunk   = C.rec2 (#thunk, cmp, #fvs, C.vector cmp)
        in
          case (c1, c2)
           of (M.CcCode,       M.CcCode      ) => EQUAL
            | (M.CcCode,       _             ) => LESS
            | (_,              M.CcCode      ) => GREATER
            | (M.CcClosure x1, M.CcClosure x2) => ccClosure (x1, x2)
            | (M.CcClosure _,  _             ) => LESS
            | (_,              M.CcClosure _ ) => GREATER
            | (M.CcThunk x1,   M.CcThunk x2  ) => ccThunk (x1, x2)
        end

    fun typKind (tk1, tk2) =
        C.fromOrd (fn tk => case tk of M.TkI => 0 | M.TkE => 1) (tk1, tk2)

    fun pObjKind (pok1, pok2) =
        let
          fun ord pok =
              case pok
               of M.PokNone      => 0
                | M.PokRat       => 1
                | M.PokFloat     => 2
                | M.PokDouble    => 3
                | M.PokName      => 4
                | M.PokFunction  => 5
                | M.PokArray     => 6
                | M.PokDict      => 7
                | M.PokTagged    => 8
                | M.PokOptionSet => 9
                | M.PokType      => 10
                | M.PokCell      => 11
                | M.PokPtr       => 12
        in C.fromOrd ord (pok1, pok2)
        end

    fun valueSize (vs1, vs2) =
        let
          fun ord vs =
              case vs
               of M.Vs8    => 0
                | M.Vs16   => 1
                | M.Vs32   => 2
                | M.Vs64   => 3
                | M.Vs128  => 4
                | M.Vs256  => 5
                | M.Vs512  => 6
                | M.Vs1024 => 7


        in C.fromOrd ord (vs1, vs2)
        end

    fun fieldVariance (fv1, fv2) =
        let
          fun ord fv =
              case fv
               of M.FvReadOnly  => 0
                | M.FvReadWrite => 1
        in C.fromOrd ord (fv1, fv2)
        end

    val fieldSize = FieldSize.compare

    fun typ (t1, t2) =
        let
          val intArb = IntArb.compareTyps
          val viVector = C.rec2 (#vectorSize, PrimsUtils.VectorSize.compare, #elementTyp, typ)
          val code = C.rec3 (#cc, callConv typ, #args, C.vector typ, #ress, C.vector typ)
          val typVar = C.pair (typ, fieldVariance)
          val tuple = C.rec3 (#pok, pObjKind, #fixed, C.vector typVar, #array, typVar)
          val pclosure = C.rec2 (#args, C.vector typ, #ress, C.vector typ)
          fun psum (x1, x2) = ND.compare (x1, x2, typ)
          val ptype = C.rec2 (#kind, typKind, #over, typ)
        in
          case (t1, t2)
           of (M.TAny,             M.TAny            ) => EQUAL
            | (M.TAny,             _                 ) => LESS
            | (_,                  M.TAny            ) => GREATER
            | (M.TAnyS x1,         M.TAnyS x2        ) => valueSize (x1, x2)
            | (M.TAnyS _,          _                 ) => LESS
            | (_,                  M.TAnyS _         ) => GREATER
            | (M.TNonRefPtr,       M.TNonRefPtr      ) => EQUAL
            | (M.TNonRefPtr,       _                 ) => LESS
            | (_,                  M.TNonRefPtr      ) => GREATER
            | (M.TRef,             M.TRef            ) => EQUAL
            | (M.TRef,             _                 ) => LESS
            | (_,                  M.TRef            ) => GREATER
            | (M.TBits x1,         M.TBits x2        ) => valueSize (x1, x2)
            | (M.TBits _,          _                 ) => LESS
            | (_,                  M.TBits _         ) => GREATER
            | (M.TNone,            M.TNone           ) => EQUAL
            | (M.TNone,            _                 ) => LESS
            | (_,                  M.TNone           ) => GREATER
            | (M.TNumeric nt1,     M.TNumeric nt2    ) => PrimsUtils.NumericTyp.compare (nt1, nt2)
            | (M.TNumeric _,       _                 ) => LESS
            | (_,                  M.TNumeric _      ) => GREATER
            | (M.TBoolean,         M.TBoolean        ) => EQUAL
            | (M.TBoolean,         _                 ) => LESS
            | (_,                  M.TBoolean        ) => GREATER
            | (M.TName,            M.TName           ) => EQUAL
            | (M.TName,            _                 ) => LESS
            | (_,                  M.TName           ) => GREATER
            | (M.TViVector x1,     M.TViVector x2    ) => viVector (x1, x2)
            | (M.TViVector _,      _                 ) => LESS
            | (_,                  M.TViVector _     ) => GREATER
            | (M.TViMask x1,       M.TViMask x2      ) => PrimsUtils.VectorDescriptor.compare (x1, x2)
            | (M.TViMask _,        _                 ) => LESS
            | (_,                  M.TViMask _       ) => GREATER
            | (M.TCode x1,         M.TCode x2        ) => code (x1, x2)
            | (M.TCode _,          _                 ) => LESS
            | (_,                  M.TCode _         ) => GREATER
            | (M.TTuple x1,        M.TTuple x2       ) => tuple (x1, x2)
            | (M.TTuple _,         _                 ) => LESS
            | (_,                  M.TTuple _        ) => GREATER
            | (M.TCString,         M.TCString        ) => EQUAL
            | (M.TCString,         _                 ) => LESS
            | (_,                  M.TCString        ) => GREATER
            | (M.TIdx,             M.TIdx            ) => EQUAL
            | (M.TIdx,             _                 ) => LESS
            | (_,                  M.TIdx            ) => GREATER
            | (M.TContinuation x1, M.TContinuation x2) => typs (x1, x2)
            | (M.TContinuation _,  _                 ) => LESS
            | (_,                  M.TContinuation _ ) => GREATER
            | (M.TThunk x1,        M.TThunk x2       ) => typ (x1, x2)
            | (M.TThunk _,         _                 ) => LESS
            | (_,                  M.TThunk _        ) => GREATER
            | (M.TPAny,            M.TPAny           ) => EQUAL
            | (M.TPAny,            _                 ) => LESS
            | (_,                  M.TPAny           ) => GREATER
            | (M.TClosure x1,      M.TClosure x2     ) => pclosure (x1, x2)
            | (M.TClosure _,       _                 ) => LESS
            | (_,                  M.TClosure _      ) => GREATER
            | (M.TPSum x1,         M.TPSum x2        ) => psum (x1, x2)
            | (M.TPSum _,          _                 ) => LESS
            | (_,                  M.TPSum _         ) => GREATER
            | (M.TPType x1,        M.TPType x2       ) => ptype (x1, x2)
            | (M.TPType _,         _                 ) => LESS
            | (_,                  M.TPType _        ) => GREATER
            | (M.TPRef x1,         M.TPRef x2        ) => typ (x1, x2)
        end
    and typs (ts1, ts2) = C.vector typ (ts1, ts2)

    fun fieldKind (fk1, fk2) =
        case (fk1, fk2)
         of (M.FkRef,      M.FkRef     ) => EQUAL
          | (M.FkRef,      _           ) => LESS
          | (_,            M.FkRef     ) => GREATER
          | (M.FkFloat,    M.FkFloat   ) => EQUAL
          | (M.FkFloat,    _           ) => LESS
          | (_,            M.FkFloat   ) => GREATER
          | (M.FkDouble,   M.FkDouble  ) => EQUAL
          | (M.FkDouble,      _        ) => LESS
          | (_,            M.FkDouble  ) => GREATER
          | (M.FkBits fs1, M.FkBits fs2) => fieldSize (fs1, fs2)

    fun fieldDescriptor (M.FD fd1, M.FD fd2) =
        C.rec2 (#kind, fieldKind, #var, fieldVariance) (fd1, fd2)

    fun tupleDescriptor (M.TD td1, M.TD td2) =
        C.rec2 (#fixed, C.vector fieldDescriptor,
                #array, C.option fieldDescriptor)
          (td1, td2)

    fun metaDataDescriptor (M.MDD mdd1, M.MDD mdd2) =
        C.rec3 (#pok, pObjKind,
                #fixed, C.vector fieldDescriptor,
                #array, C.option (C.pair (Int.compare, fieldDescriptor)))
          (mdd1, mdd2)

    fun constant (c1, c2) = 
        let
          val viMask = C.rec2 (#descriptor, PrimsUtils.VectorDescriptor.compare,
                               #elts, C.vector Bool.compare)
        in
          case (c1, c2)
           of (M.CBoolean b1,     M.CBoolean b2    ) => Bool.compare (b1, b2)
            | (M.CBoolean _,      _                ) => LESS 
            | (_,                 M.CBoolean _     ) => GREATER
            | (M.CRat r1,         M.CRat r2        ) => IntInf.compare (r1, r2)
            | (M.CRat _,          _                ) => LESS
            | (_,                 M.CRat _         ) => GREATER
            | (M.CInteger i1,     M.CInteger i2    ) => IntInf.compare (i1, i2)
            | (M.CInteger _,      _                ) => LESS
            | (_,                 M.CInteger _     ) => GREATER
            | (M.CName n1,        M.CName n2       ) => name (n1, n2)
            | (M.CName _,         _                ) => LESS
            | (_,                 M.CName _        ) => GREATER
            | (M.CIntegral i1,    M.CIntegral i2   ) => IntArb.compareSyntactic (i1, i2)
            | (M.CIntegral _,     _                ) => LESS
            | (_,                 M.CIntegral _    ) => GREATER
            | (M.CFloat f1,       M.CFloat f2      ) => Real32.compare (f1, f2)
            | (M.CFloat _,        _                ) => LESS
            | (_,                 M.CFloat _       ) => GREATER
            | (M.CDouble d1,      M.CDouble d2     ) => Real64.compare (d1, d2)
            | (M.CDouble _,       _                ) => LESS
            | (_,                 M.CDouble _      ) => GREATER
            | (M.CViMask x1,      M.CViMask x2     ) => viMask (x1, x2)
            | (M.CViMask _,       _                ) => LESS
            | (_,                 M.CViMask _      ) => GREATER
            | (M.CPok pok1,       M.CPok pok2      ) => pObjKind (pok1, pok2)
            | (M.CPok _,          _                ) => LESS
            | (_,                 M.CPok _         ) => GREATER
            | (M.CRef i1,         M.CRef i2        ) => IntInf.compare (i1, i2)
            | (M.CRef _,          _                ) => LESS
            | (_,                 M.CRef _         ) => GREATER
            | (M.COptionSetEmpty, M.COptionSetEmpty) => EQUAL
            | (M.COptionSetEmpty, _                ) => LESS
            | (_,                 M.COptionSetEmpty) => GREATER
            | (M.CTypePH,         M.CTypePH        ) => EQUAL
        end

    fun simple (s1, s2) = 
        case (s1, s2) 
         of (M.SVariable v1, M.SVariable v2) => variable (v1, v2)
          | (M.SVariable _,  _             ) => LESS
          | (_,              M.SVariable _ ) => GREATER
          | (M.SConstant c1, M.SConstant c2) => constant (c1, c2)

    val operand = simple
    val operands = C.vector operand
    val operandO = C.option operand

    val tupleBase = 
     fn p => 
        let
          val res = case p
		     of (Mil.TbScalar   , Mil.TbScalar   ) => EQUAL
		      | (Mil.TbScalar   , _              ) => LESS
		      | (_              , Mil.TbScalar   ) => GREATER
		      | (Mil.TbVector   , Mil.TbVector   ) => EQUAL
        in
          res
        end
        
    val vectorIndexKind = 
     fn p => 
        let
          val kStrided = Int.compare
          val res = case p
		     of (Mil.VikStrided x1, Mil.VikStrided x2) => kStrided (x1, x2)
		      | (Mil.VikStrided _ , _                ) => LESS
		      | (_                , Mil.VikStrided _ ) => GREATER
		      | (Mil.VikVector    , Mil.VikVector    ) => EQUAL
        in
          res
        end
        
    val fieldIdentifier = 
     fn p => 
        let
          val fixed = Int.compare
          val variable = operand
          val vectorFixed = C.rec3 (#descriptor, PrimsUtils.Compare.vectorDescriptor,
                                    #mask, C.option operand,
                                    #index, Int.compare)
          val vectorVariable = C.rec5 (#descriptor, PrimsUtils.Compare.vectorDescriptor,
                                       #base, tupleBase,  
                                       #mask, C.option operand ,
                                       #index, operand,
                                       #kind, vectorIndexKind)
          val res = 
              case p
	       of (Mil.FiFixed x1         , Mil.FiFixed x2         ) => fixed (x1, x2)
		| (Mil.FiFixed _          , _                      ) => LESS
		| (_                      , Mil.FiFixed _          ) => GREATER
		| (Mil.FiVariable x1      , Mil.FiVariable x2      ) => variable (x1, x2)
		| (Mil.FiVariable _       , _                      ) => LESS
		| (_                      , Mil.FiVariable _       ) => GREATER
		| (Mil.FiVectorFixed x1   , Mil.FiVectorFixed x2   ) => vectorFixed (x1, x2)
		| (Mil.FiVectorFixed _    , _                      ) => LESS
		| (_                      , Mil.FiVectorFixed _    ) => GREATER
		| (Mil.FiVectorVariable x1, Mil.FiVectorVariable x2) => vectorVariable (x1, x2)
        in
          res
        end

    fun tupleField (M.TF tf1, M.TF tf2) =
        C.rec3 (#tupDesc, tupleDescriptor, #tup, variable,
                #field, fieldIdentifier)
          (tf1, tf2)

    fun rhs (rhs1, rhs2) =
        let
          val l    = label
          val s    = simple
          val opnd = operand
          val var  = variable
          val prim = C.rec3 (#prim, PrimsUtils.Compare.t,
                             #createThunks, Bool.compare,
                             #args, C.vector operand)
          val t    = C.rec2 (#mdDesc, metaDataDescriptor,
                             #inits, operands)
          val tf   = tupleField
          val ts   = C.rec2 (#tupField, tupleField, #ofVal, operand)
          val ti   = C.rec2 (#mdDesc, metaDataDescriptor,
                             #tup, variable)
          val ig   = C.rec2 (#idx, variable, #ofVal, operand)
          val thkm = C.rec2 (#typ, fieldKind, #fvs, C.vector fieldKind)
          val thki = C.rec5 (#typ, fieldKind,
                             #thunk, C.option variable,
                             #fx, effects,
                             #code, C.option variable,
                             #fvs, C.vector (C.pair (fieldKind, operand)))
          val thkf = C.rec4 (#typ, fieldKind,
                             #fvs, C.vector fieldKind,
                             #thunk, variable,
                             #idx, Int.compare)
          val thkv = C.rec3 (#typ, fieldKind,
                             #thunk, C.option variable,
                             #ofVal, operand)
          val thkg = C.rec2 (#typ, fieldKind, #thunk, variable)
          val thks = C.rec2 (#typ, fieldKind, #thunk, variable)
          val pfmk = C.rec1 (#fvs, C.vector fieldKind)
          val pfi  = C.rec3 (#cls, C.option variable,
                             #code, C.option variable,
                             #fvs, C.vector (C.pair (fieldKind, operand)))
          val pffv = C.rec3 (#fvs, C.vector fieldKind,
                             #cls, variable,
                             #idx, Int.compare)
          val psc  = C.rec2 (#bool, operand, #ofVal, operand)
          val ps   = C.rec3 (#tag, name, #typ, fieldKind, #ofVal, operand)
          val psp  = C.rec3 (#typ, fieldKind, #sum, variable, #tag, name)
        in
          case (rhs1, rhs2)
           of (M.RhsSimple         x1, M.RhsSimple         x2) => s (x1, x2)
            | (M.RhsSimple         _ , _                     ) => LESS
            | (_                     , M.RhsSimple         _ ) => GREATER
            | (M.RhsPrim           x1, M.RhsPrim           x2) => prim (x1, x2)
            | (M.RhsPrim           _ , _                     ) => LESS
            | (_                     , M.RhsPrim           _ ) => GREATER
            | (M.RhsTuple          x1, M.RhsTuple          x2) => t (x1, x2)
            | (M.RhsTuple          _ , _                     ) => LESS
            | (_                     , M.RhsTuple          _ ) => GREATER
            | (M.RhsTupleSub       x1, M.RhsTupleSub       x2) => tf (x1, x2)
            | (M.RhsTupleSub       _ , _                     ) => LESS
            | (_                     , M.RhsTupleSub       _ ) => GREATER
            | (M.RhsTupleSet       x1, M.RhsTupleSet       x2) => ts (x1, x2)
            | (M.RhsTupleSet       _ , _                     ) => LESS
            | (_                     , M.RhsTupleSet       _ ) => GREATER
            | (M.RhsTupleInited    x1, M.RhsTupleInited    x2) => ti (x1, x2)
            | (M.RhsTupleInited    _ , _                     ) => LESS
            | (_                     , M.RhsTupleInited    _ ) => GREATER
            | (M.RhsIdxGet         x1, M.RhsIdxGet         x2) => ig (x1, x2)
            | (M.RhsIdxGet         _ , _                     ) => LESS
            | (_                     , M.RhsIdxGet         _ ) => GREATER
            | (M.RhsCont           x1, M.RhsCont           x2) => l (x1, x2)
            | (M.RhsCont           _ , _                     ) => LESS
            | (_                     , M.RhsCont           _ ) => GREATER
            | (M.RhsObjectGetKind  x1, M.RhsObjectGetKind  x2) => var (x1, x2)
            | (M.RhsObjectGetKind  _ , _                     ) => LESS
            | (_                     , M.RhsObjectGetKind  _ ) => GREATER
            | (M.RhsThunkMk        x1, M.RhsThunkMk        x2) => thkm (x1, x2)
            | (M.RhsThunkMk        _ , _                     ) => LESS
            | (_                     , M.RhsThunkMk        _ ) => GREATER
            | (M.RhsThunkInit      x1, M.RhsThunkInit      x2) => thki (x1, x2)
            | (M.RhsThunkInit      _ , _                     ) => LESS
            | (_                     , M.RhsThunkInit      _ ) => GREATER
            | (M.RhsThunkGetFv     x1, M.RhsThunkGetFv     x2) => thkf (x1, x2)
            | (M.RhsThunkGetFv     _ , _                     ) => LESS
            | (_                     , M.RhsThunkGetFv     _ ) => GREATER
            | (M.RhsThunkValue     x1, M.RhsThunkValue     x2) => thkv (x1, x2)
            | (M.RhsThunkValue     _ , _                     ) => LESS
            | (_                     , M.RhsThunkValue     _ ) => GREATER
            | (M.RhsThunkGetValue  x1, M.RhsThunkGetValue  x2) => thkg (x1, x2)
            | (M.RhsThunkGetValue  _ , _                     ) => LESS
            | (_                     , M.RhsThunkGetValue  _ ) => GREATER
            | (M.RhsThunkSpawn     x1, M.RhsThunkSpawn     x2) => thks (x1, x2)
            | (M.RhsThunkSpawn     _ , _                     ) => LESS
            | (_                     , M.RhsThunkSpawn     _ ) => GREATER
            | (M.RhsClosureMk      x1, M.RhsClosureMk    x2  ) => pfmk (x1, x2)
            | (M.RhsClosureMk      _ , _                     ) => LESS
            | (_                     , M.RhsClosureMk    _   ) => GREATER
            | (M.RhsClosureInit    x1, M.RhsClosureInit  x2  ) => pfi (x1, x2)
            | (M.RhsClosureInit    _ , _                     ) => LESS
            | (_                     , M.RhsClosureInit  _   ) => GREATER
            | (M.RhsClosureGetFv   x1, M.RhsClosureGetFv x2  ) => pffv (x1, x2)
            | (M.RhsClosureGetFv   _ , _                     ) => LESS
            | (_                     , M.RhsClosureGetFv _   ) => GREATER
            | (M.RhsPSetNew        x1, M.RhsPSetNew        x2) => opnd (x1, x2)
            | (M.RhsPSetNew        _ , _                     ) => LESS
            | (_                     , M.RhsPSetNew        _ ) => GREATER
            | (M.RhsPSetGet        x1, M.RhsPSetGet        x2) => var (x1, x2)
            | (M.RhsPSetGet        _ , _                     ) => LESS
            | (_                     , M.RhsPSetGet        _ ) => GREATER
            | (M.RhsPSetCond       x1, M.RhsPSetCond       x2) => psc (x1, x2)
            | (M.RhsPSetCond       _ , _                     ) => LESS
            | (_                     , M.RhsPSetCond       _ ) => GREATER
            | (M.RhsPSetQuery      x1, M.RhsPSetQuery      x2) => s (x1, x2)
            | (M.RhsPSetQuery      _ , _                     ) => LESS
            | (_                     , M.RhsPSetQuery      _ ) => GREATER
            | (M.RhsPSum           x1, M.RhsPSum           x2) => ps (x1, x2)
            | (M.RhsPSum           _ , _                     ) => LESS
            | (_                     , M.RhsPSum           _ ) => GREATER
            | (M.RhsPSumProj       x1, M.RhsPSumProj       x2) => psp (x1, x2)
        end

    fun instruction (M.I x1, M.I x2) =
        C.rec2 (#dests, C.vector variable, #rhs, rhs) (x1, x2)

    fun target (M.T x1, M.T x2) =
        C.rec2 (#block, label, #arguments, C.vector operand) (x1, x2)

    fun switch cmp (x1 : 'a M.switch, x2 : 'a M.switch) =
        C.rec3 (#on, operand, #cases, C.vector (C.pair (cmp, target)),
                #default, C.option target)
          (x1, x2)

    fun codes (x1 : M.codes, x2 : M.codes) =
        C.rec2 (#possible, VS.compare, #exhaustive, Bool.compare) (x1, x2)

    local
      val code = C.rec2 (#ptr, variable, #code, codes)
      val closure = C.rec2 (#cls, variable, #code, codes)
      val dclosure = C.rec2 (#cls, variable, #code, variable)
    in
    fun call (arg1, arg2) = 
        case (arg1, arg2)
         of (M.CCode          x1, M.CCode          x2) => code (x1, x2) 
          | (M.CCode          _ , _                  ) => LESS
          | (_                  , M.CCode          _ ) => GREATER
          | (M.CClosure       x1, M.CClosure       x2) => closure (x1, x2)
          | (M.CClosure       _ , _                  ) => LESS
          | (_                  , M.CClosure       _ ) => GREATER
          | (M.CDirectClosure x1, M.CDirectClosure x2) => dclosure (x1, x2)
    end

    local
      val thunk = C.rec2 (#thunk, variable, #code, codes)
      val dthunk = C.rec2 (#thunk, variable, #code, variable)
    in
    fun eval (arg1, arg2) = 
        case (arg1, arg2)
         of (M.EThunk       x1, M.EThunk       x2) => thunk (x1, x2) 
          | (M.EThunk       _ , _                ) => LESS
          | (_                , M.EThunk       _ ) => GREATER
          | (M.EDirectThunk x1, M.EDirectThunk x2) => dthunk (x1, x2)
    end

    local
      val c = C.rec2 (#call, call, #args, C.vector operand)
      val e = C.rec2 (#typ, fieldKind, #eval, eval)
    in
    fun interProc (x1, x2) =
        case (x1, x2)
         of (M.IpCall x1, M.IpCall x2) => c (x1, x2)
          | (M.IpCall _ , _          ) => LESS
          | (_          , M.IpCall _ ) => GREATER
          | (M.IpEval x1, M.IpEval x2) => e (x1, x2)
    end

    fun cuts (M.C cs1, M.C cs2) =
        C.rec2 (#exits, Bool.compare, #targets, LS.compare) (cs1, cs2)

    local
      val n = C.rec3 (#rets, C.vector variable, #block, label, #cuts, cuts)
    in
    fun return (r1, r2) =
        case (r1, r2)
         of (M.RNormal x1, M.RNormal x2) => n (x1, x2)
          | (M.RNormal _ , _           ) => LESS
          | (_           , M.RNormal _ ) => GREATER
          | (M.RTail   x1, M.RTail   x2) => C.rec1 (#exits, Bool.compare) (x1, x2)
    end

    local
      val interProc = C.rec3 (#callee, interProc, #ret, return, #fx, effects)
      val cut = C.rec3 (#cont, variable, #args, C.vector operand, #cuts, cuts)
    in
    fun transfer (t1, t2) =
        case (t1, t2)
         of (M.TGoto      x1, M.TGoto      x2) => target (x1, x2)
          | (M.TGoto      _ , _              ) => LESS
          | (_              , M.TGoto      _ ) => GREATER
          | (M.TCase      x1, M.TCase      x2) => switch constant (x1, x2)
          | (M.TCase      _ , _              ) => LESS
          | (_              , M.TCase      _ ) => GREATER
          | (M.TInterProc x1, M.TInterProc x2) => interProc (x1, x2)
          | (M.TInterProc _ , _              ) => LESS
          | (_              , M.TInterProc _ ) => GREATER
          | (M.TReturn    x1, M.TReturn    x2) => C.vector operand (x1, x2)
          | (M.TReturn    _ , _              ) => LESS
          | (_              , M.TReturn    _ ) => GREATER
          | (M.TCut       x1, M.TCut       x2) => cut (x1, x2)
          | (M.TCut       _ , _              ) => LESS
          | (_              , M.TCut       _ ) => GREATER
          | (M.THalt      x1, M.THalt      x2) => operand (x1, x2)
          | (M.THalt      _ , _              ) => LESS
          | (_              , M.THalt      _ ) => GREATER
          | (M.TPSumCase  x1, M.TPSumCase  x2) => switch name (x1, x2)
    end

    fun block (M.B x1, M.B x2) =
        C.rec3 (#parameters, C.vector variable,
                #instructions, C.vector instruction,
                #transfer, transfer)
          (x1, x2)

    fun codeBody (M.CB x1, M.CB x2) =
        let
          fun blks (x1, x2) = LD.compare (x1, x2, block)
        in
          C.rec2 (#entry, label, #blocks, blks) (x1, x2)
        end

    fun code (M.F x1, M.F x2) =
        C.rec7 (#fx, effects,
                #escapes, Bool.compare,
                #recursive, Bool.compare,
                #cc, callConv variable,
                #args, C.vector variable,
                #rtyps, C.vector typ,
                #body, codeBody)
          (x1, x2)

    local
      fun idx (x1, x2) = ND.compare (x1, x2, Int.compare)
      val tuple = C.rec2 (#mdDesc, metaDataDescriptor,
                          #inits, C.vector simple)
      val thunkValue = C.rec2 (#typ, fieldKind, #ofVal, simple)
      val psum = C.rec3 (#tag, name, #typ, fieldKind, #ofVal, simple)
      val pfunction = C.rec2 (#code, C.option variable,
                              #fvs, C.vector (C.pair (fieldKind, operand)))
    in
    fun global (g1, g2) =
        case (g1, g2)
         of (M.GCode       x1, M.GCode       x2) => code (x1, x2)
          | (M.GCode       _ , _               ) => LESS
          | (_               , M.GCode       _ ) => GREATER
          | (M.GErrorVal   x1, M.GErrorVal   x2) => typ (x1, x2)
          | (M.GErrorVal _   , _               ) => LESS
          | (_               , M.GErrorVal   _ ) => GREATER
          | (M.GIdx        x1, M.GIdx        x2) => idx (x1, x2)
          | (M.GIdx        _ , _               ) => LESS
          | (_               , M.GIdx        _ ) => GREATER
          | (M.GTuple      x1, M.GTuple      x2) => tuple (x1, x2)
          | (M.GTuple      _ , _               ) => LESS
          | (_               , M.GTuple      _ ) => GREATER
          | (M.GRat        x1, M.GRat        x2) => Rat.compare (x1, x2)
          | (M.GRat        _ , _               ) => LESS
          | (_               , M.GRat        _ ) => GREATER
          | (M.GInteger    x1, M.GInteger    x2) => IntInf.compare (x1, x2)
          | (M.GInteger    _ , _               ) => LESS
          | (_               , M.GInteger    _ ) => GREATER
          | (M.GCString    x1, M.GCString    x2) => String.compare (x1, x2)
          | (M.GCString    _ , _               ) => LESS
          | (_               , M.GCString    _ ) => GREATER
          | (M.GThunkValue x1, M.GThunkValue x2) => thunkValue (x1, x2)
          | (M.GThunkValue _ , _               ) => LESS
          | (_               , M.GThunkValue _ ) => GREATER
          | (M.GSimple     x1, M.GSimple     x2) => simple (x1, x2)
          | (M.GSimple     _ , _               ) => LESS
          | (_               , M.GSimple     _ ) => GREATER
          | (M.GClosure    x1, M.GClosure    x2) => pfunction (x1, x2)
          | (M.GClosure    _ , _               ) => LESS
          | (_               , M.GClosure    _ ) => GREATER
          | (M.GPSum       x1, M.GPSum       x2) => psum (x1, x2)
          | (M.GPSum       _ , _               ) => LESS
          | (_               , M.GPSum       _ ) => GREATER
          | (M.GPSet       x1, M.GPSet       x2) => simple (x1, x2)
    end

  end

  structure Eq =
  struct
    type 'a t = 'a * 'a -> bool
    val variable           : Mil.variable t = Equality.fromCompare Compare.variable
    val name               : Mil.name t = Equality.fromCompare Compare.name
    val label              : Mil.label t = Equality.fromCompare Compare.label
    val effects            : Mil.effects t = Equality.fromCompare Compare.effects
    val callConv           : 'a t -> 'a Mil.callConv t = 
     fn eqA => Equality.fromCompare (Compare.callConv (fn (a, b) => if eqA (a, b) then EQUAL else LESS))
    val typKind            : Mil.typKind t = Equality.fromCompare Compare.typKind
    val pObjKind           : Mil.pObjKind t = Equality.fromCompare Compare.pObjKind
    val valueSize          : Mil.valueSize t = Equality.fromCompare Compare.valueSize
    val fieldVariance      : Mil.fieldVariance t = Equality.fromCompare Compare.fieldVariance
    val fieldSize          : Mil.fieldSize t = FieldSize.eq
    val typ                : Mil.typ t = Equality.fromCompare Compare.typ
    val typs               : Mil.typ Vector.t t = Equality.fromCompare Compare.typs
    val fieldKind          : Mil.fieldKind t = Equality.fromCompare Compare.fieldKind
    val fieldDescriptor    : Mil.fieldDescriptor t = Equality.fromCompare Compare.fieldDescriptor
    val tupleDescriptor    : Mil.tupleDescriptor t = Equality.fromCompare Compare.tupleDescriptor
    val metaDataDescriptor : Mil.metaDataDescriptor t = Equality.fromCompare Compare.metaDataDescriptor
    val constant           : Mil.constant t = Equality.fromCompare Compare.constant
    val simple             : Mil.simple t = Equality.fromCompare Compare.simple
    val operand            : Mil.operand t = Equality.fromCompare Compare.operand
    val tupleBase          : Mil.tupleBase t = Equality.fromCompare Compare.tupleBase
    val vectorIndexKind    : Mil.vectorIndexKind t = Equality.fromCompare Compare.vectorIndexKind
    val fieldIdentifier    : Mil.fieldIdentifier t = Equality.fromCompare Compare.fieldIdentifier
    val tupleField         : Mil.tupleField t = Equality.fromCompare Compare.tupleField
    val rhs                : Mil.rhs t = Equality.fromCompare Compare.rhs
    val instruction        : Mil.instruction t = Equality.fromCompare Compare.instruction
    val target             : Mil.target t = Equality.fromCompare Compare.target
    val switch             : 'a t -> 'a Mil.switch t = 
     fn eqA => Equality.fromCompare (Compare.switch (fn (a, b) => if eqA (a, b) then EQUAL else LESS))
    val codes              : Mil.codes t = Equality.fromCompare Compare.codes
    val call               : Mil.call t = Equality.fromCompare Compare.call
    val eval               : Mil.eval t = Equality.fromCompare Compare.eval
    val interProc          : Mil.interProc t = Equality.fromCompare Compare.interProc
    val cuts               : Mil.cuts t = Equality.fromCompare Compare.cuts
    val return             : Mil.return t = Equality.fromCompare Compare.return
    val transfer           : Mil.transfer t = Equality.fromCompare Compare.transfer
    val block              : Mil.block t = Equality.fromCompare Compare.block
    val codeBody           : Mil.codeBody t = Equality.fromCompare Compare.codeBody
    val code               : Mil.code t = Equality.fromCompare Compare.code
    val global             : Mil.global t = Equality.fromCompare Compare.global
  end

  structure CallConv =
  struct

    type 'a t = 'a Mil.callConv

    val compare = Compare.callConv
    val eq = Eq.callConv

    fun map (cc, f) =
        case cc
         of M.CcCode => M.CcCode
          | M.CcClosure {cls, fvs} =>
            M.CcClosure {cls = f cls, fvs = Vector.map (fvs, f)}
          | M.CcThunk {thunk, fvs} =>
            M.CcThunk {thunk = f thunk, fvs = Vector.map (fvs, f)}

    fun foreach (cc, f) =
        case cc
         of M.CcCode => ()
          | M.CcClosure {cls, fvs} =>
            let
              val () = f cls
              val () = Vector.foreach (fvs, f)
            in ()
            end
          | M.CcThunk {thunk, fvs} =>
            let
              val () = f thunk
              val () = Vector.foreach (fvs, f)
            in ()
            end

    structure Dec =
    struct
      val ccCode = 
       fn c => 
          (case c 
            of M.CcCode => SOME ()
             | _ => NONE)
      val ccClosure = 
       fn c => 
          (case c 
            of M.CcClosure r => SOME r
             | _ => NONE)
      val ccThunk = 
       fn c => 
          (case c 
            of M.CcThunk r => SOME r
             | _ => NONE)
    end (* structure Dec *)

  end

  structure TypKind =
  struct

    type t = Mil.typKind

    fun fromChar c = case c of #"I" => SOME M.TkI | #"E" => SOME M.TkE | _ => NONE

    fun toChar tk = case tk of M.TkI => #"I" | M.TkE => #"E"

    fun toString tk = String.fromChar (toChar tk)

    val compare = Compare.typKind
    val eq = Eq.typKind

  end

  structure PObjKind =
  struct

    type t = Mil.pObjKind

    fun fromChar c =
        case c
         of #"-" => SOME M.PokNone     
          | #"R" => SOME M.PokRat      
          | #"F" => SOME M.PokFloat    
          | #"D" => SOME M.PokDouble   
          | #"N" => SOME M.PokName     
          | #"L" => SOME M.PokFunction 
          | #"A" => SOME M.PokArray    
          | #"B" => SOME M.PokDict     
          | #"S" => SOME M.PokTagged   
          | #"O" => SOME M.PokOptionSet
          | #"P" => SOME M.PokPtr      
          | #"T" => SOME M.PokType     
          | #"C" => SOME M.PokCell     
          | _    => NONE

    fun toChar pok =
        case pok
         of M.PokNone      => #"-"
          | M.PokRat       => #"R"
          | M.PokFloat     => #"F"
          | M.PokDouble    => #"D"
          | M.PokName      => #"N"
          | M.PokFunction  => #"L"
          | M.PokArray     => #"A"
          | M.PokDict      => #"B"
          | M.PokTagged    => #"S"
          | M.PokOptionSet => #"O"
          | M.PokPtr       => #"P"
          | M.PokType      => #"T"
          | M.PokCell      => #"C"

    fun toString pok =
        case pok
         of M.PokNone      => "None"
          | M.PokRat       => "Rat"
          | M.PokFloat     => "Float"
          | M.PokDouble    => "Double"
          | M.PokName      => "Name"
          | M.PokFunction  => "Fun"
          | M.PokArray     => "Array"
          | M.PokDict      => "Dict"
          | M.PokTagged    => "Tag"
          | M.PokOptionSet => "Set"
          | M.PokPtr       => "Ptr"
          | M.PokType      => "Type"
          | M.PokCell      => "Cell"

    val compare = Compare.pObjKind
    val eq = Eq.pObjKind

    val fromTyp = 
     fn t =>
        (case t
          of M.TAny                       => NONE
           | M.TAnyS vs                   => NONE
           | M.TNonRefPtr                 => NONE
           | M.TRef                       => NONE
           | M.TBits vs                   => NONE
           | M.TNone                      => NONE
           | M.TNumeric _                 => NONE
           | M.TBoolean                   => NONE
           | M.TName                      => SOME M.PokName
           | M.TViVector et               => NONE
           | M.TViMask et                 => NONE
           | M.TCode {cc, args, ress}     => NONE
           | M.TTuple {pok, fixed, array} => SOME pok
           | M.TCString                   => NONE
           | M.TIdx                       => NONE
           | M.TContinuation ts           => NONE
           | M.TThunk t                   => SOME M.PokCell 
           | M.TPAny                      => NONE
           | M.TClosure {args, ress}      => SOME M.PokFunction
           | M.TPSum nts                  => SOME M.PokTagged
           | M.TPType {kind, over}        => SOME M.PokType
           | M.TPRef t                    => SOME M.PokPtr)

     fun isP pok =
         case pok
          of M.PokNone      => false
           | M.PokRat       => true
           | M.PokFloat     => true
           | M.PokDouble    => true
           | M.PokName      => true
           | M.PokFunction  => true
           | M.PokArray     => true
           | M.PokDict      => true
           | M.PokTagged    => true
           | M.PokOptionSet => true
           | M.PokType      => true
           | M.PokPtr       => true
           | M.PokCell      => false

  end

  structure ValueSize =
  struct

    type t = Mil.valueSize

    fun numBytes vs =
        case vs
         of M.Vs8    => 1
          | M.Vs16   => 2
          | M.Vs32   => 4
          | M.Vs64   => 8
          | M.Vs128  => 16
          | M.Vs256  => 32
          | M.Vs512  => 64
          | M.Vs1024 => 1024

    fun numBits vs = 8 * numBytes vs

    fun toString vs = "S" ^ (Int.toString (numBits vs))

    fun fromString s =
        case s
         of "S8"    => SOME M.Vs8
          | "S16"   => SOME M.Vs16
          | "S32"   => SOME M.Vs32
          | "S64"   => SOME M.Vs64
          | "S128"  => SOME M.Vs128
          | "S256"  => SOME M.Vs256
          | "S512"  => SOME M.Vs512
          | "S1024" => SOME M.Vs1024
          | _       => NONE

    fun intArb (IA.T (sz, _)) =
        case sz
         of IntArb.S8   => M.Vs8
          | IntArb.S16  => M.Vs16
          | IntArb.S32  => M.Vs32
          | IntArb.S64  => M.Vs64

    fun ptrSize config = 
        (case Config.targetWordSize config
          of Config.Ws32 => M.Vs32
           | Config.Ws64 => M.Vs64)

    val wordSize = ptrSize

    fun vectorSize config =
        case Config.va config
         of Config.ViREF => M.Vs128
          | Config.ViSSE => M.Vs128
          | Config.ViAVX => M.Vs256
          | Config.ViLRB => M.Vs512

    val compare = Compare.valueSize
    val eq = Eq.valueSize

  end

  structure FieldVariance =
  struct

    type t = Mil.fieldVariance

    fun mutable fv =
        case fv
         of M.FvReadOnly  => false
          | M.FvReadWrite => true

    fun immutable fv = not (mutable fv)

    fun fromChar c =
        case c
         of #"+" => SOME M.FvReadOnly
          | #"=" => SOME M.FvReadWrite
          | _    => NONE

    fun toString fv =
        case fv
         of M.FvReadOnly  => "ReadOnly"
          | M.FvReadWrite => "ReadWrite"

    fun toChar fv =
        case fv
         of M.FvReadOnly  => #"+"
          | M.FvReadWrite => #"="

    val compare = Compare.fieldVariance
    val eq = Eq.fieldVariance

  end

  structure TraceabilitySize =
  struct

    datatype traceability = TRef | TBits

    datatype t =
        TsAny
      | TsAnyS of ValueSize.t
      | TsBits of ValueSize.t
      | TsFloat
      | TsDouble
      | TsRef
      | TsNone
      | TsMask of MP.vectorDescriptor
                  
    fun toString (config, ts) =
        case ts
         of TsAny       => "Any"
          | TsAnyS vs   => "Any" ^ ValueSize.toString vs
          | TsBits vs   => "Bits" ^ Int.toString (ValueSize.numBits vs)
          | TsFloat     => "Float"
          | TsDouble    => "Double"
          | TsRef       => "Ref"
          | TsNone      => "None"
          | TsMask vet  => "Mask(" ^ PrimsUtils.VectorDescriptor.toString (config, vet) ^ ")"

    fun traceabilityIsRef t =
        case t
         of TRef  => true
          | TBits => false

    fun traceability ts =
        case ts
         of TsAny       => NONE
          | TsAnyS vs   => NONE
          | TsBits vs   => SOME TBits
          | TsFloat     => SOME TBits
          | TsDouble    => SOME TBits
          | TsRef       => SOME TRef
          | TsNone      => NONE
          | TsMask vet  => SOME TBits

    fun valueSize (config, ts) =
        case ts
         of TsAny       => NONE
          | TsAnyS vs   => SOME vs
          | TsBits vs   => SOME vs
          | TsFloat     => SOME M.Vs32
          | TsDouble    => SOME M.Vs64
          | TsRef       => SOME (ValueSize.ptrSize config)
          | TsNone      => NONE
          | TsMask vet  => NONE

    fun subTS (config, ts1, ts2) = 
        case (ts1, ts2)
         of (TsNone, _) => true
          | (_, TsNone) => false
          | (_, TsAny) => true
          | (TsAny, _) => false
          | (_, TsAnyS vs) => 
            (case valueSize (config, ts1)
              of SOME vs' => vs' = vs
               | NONE => false)
          | (TsAnyS _, _) => false
          | (TsBits vs1, TsBits vs2) => vs1 = vs2
          | (_, TsBits _) => false
          | (TsBits _, _) => false
          | (TsFloat, TsFloat) => true
          | (TsFloat, _) => false
          | (_, TsFloat) => false
          | (TsDouble, TsDouble) => true
          | (TsDouble, _) => false
          | (_, TsDouble) => false
          | (TsMask vit1, TsMask vit2) => PrimsUtils.VectorDescriptor.eq (vit1, vit2)
          | (_, TsMask _) => false
          | (TsMask _, _) => false
          | (TsRef, TsRef) => true

  end

  structure Prims = 
  struct

    structure Utils = PrimsUtils

    structure NumericTyp = 
    struct

      val tFloat  : Mil.typ = M.TNumeric (MP.NtFloat (MP.FpSingle))
      val tDouble : Mil.typ = M.TNumeric (MP.NtFloat (MP.FpDouble))
      val tIntegerArbitrary = M.TNumeric (MP.NtInteger (MP.IpArbitrary))
      val tIntegerFixed     = fn ia => M.TNumeric (MP.NtInteger (MP.IpFixed ia))
      val tRat              = M.TNumeric MP.NtRat

      structure TS = TraceabilitySize

      val traceabilitySize = 
       fn (c, nt) => 
          (case nt
            of MP.NtRat                     => TS.TsRef
             | MP.NtInteger MP.IpArbitrary  => TS.TsRef
             | MP.NtInteger (MP.IpFixed sz) => TS.TsBits (ValueSize.intArb sz)
             | MP.NtFloat MP.FpSingle       => TS.TsFloat
             | MP.NtFloat MP.FpDouble       => TS.TsDouble)

    end (* structure NumericTyp *)

  end (* structure Prims *)

  structure Typ =
  struct

    structure TS = TraceabilitySize

    type t = Mil.typ

    (*  case t
         of M.TAny                       => 
          | M.TAnyS vs                   => 
          | M.TPtr                       => 
          | M.TRef                       => 
          | M.TBits vs                   => 
          | M.TNone                      => 
          | M.TRat                       => 
          | M.TInteger                   => 
          | M.TName                      => 
          | M.TIntegral sz               => 
          | M.TFloat                     => 
          | M.TDouble                    => 
          | M.TViVector et               => 
          | M.TViMask et                 => 
          | M.TCode {cc, args, ress}     => 
          | M.TTuple {pok, fixed, array} => 
          | M.TCString                   =>
          | M.TIdx                       => 
          | M.TContinuation ts           => 
          | M.TThunk t                   => 
          | M.TPAny                      => 
          | M.TClosure {args, ress}      => 
          | M.TPSum nts                  => 
          | M.TPType {kind, over}        => 
          | M.TPRef t                    => 
     *)

    fun traceabilitySize (c, t) =
        case t
         of M.TAny                       => TS.TsAny
          | M.TAnyS vs                   => TS.TsAnyS vs
          | M.TNonRefPtr                 => TS.TsBits (ValueSize.ptrSize c)
          | M.TRef                       => TS.TsRef
          | M.TBits vs                   => TS.TsBits vs
          | M.TNone                      => TS.TsNone
          | M.TNumeric nt                => Prims.NumericTyp.traceabilitySize (c, nt)
          | M.TBoolean                   => TS.TsBits (ValueSize.wordSize c)
          | M.TName                      => TS.TsRef
          | M.TViVector et               => TS.TsBits (ValueSize.vectorSize c)
          | M.TViMask et                 => TS.TsMask et
          | M.TCode {cc, args, ress}     => TS.TsBits (ValueSize.ptrSize c)
          | M.TTuple {pok, fixed, array} => TS.TsRef
          | M.TCString                   => TS.TsBits (ValueSize.ptrSize c)
          | M.TIdx                       => TS.TsRef
          | M.TContinuation ts           => TS.TsBits (ValueSize.ptrSize c)
          | M.TThunk t                   => TS.TsRef
          | M.TPAny                      => TS.TsRef
          | M.TClosure {args, ress}      => TS.TsRef
          | M.TPSum nts                  => TS.TsRef
          | M.TPType {kind, over}        => TS.TsRef
          | M.TPRef t                    => TS.TsRef

    fun fromTraceabilitySize ts =
        (case ts
          of TS.TsAny       => M.TAny
           | TS.TsAnyS vs   => M.TAnyS vs
           | TS.TsBits vs   => M.TBits vs
           | TS.TsFloat     => Prims.NumericTyp.tFloat
           | TS.TsDouble    => Prims.NumericTyp.tDouble
           | TS.TsRef       => M.TRef
           | TS.TsNone      => M.TNone
           | TS.TsMask et   => M.TViMask et)

    fun valueSize (config, t) =  TS.valueSize (config, traceabilitySize (config, t))

    fun fieldSize (config, t) = 
        (case valueSize (config, t)
          of SOME vs => FieldSize.fromValueSize vs
           | NONE => Fail.fail ("MilUtils.Typ", "fieldSize", "Typ has no size"))

    fun numBytes (config, t) = Option.map (valueSize (config, t), ValueSize.numBytes)

    fun numBits (config, t) = Option.map (valueSize (config, t), ValueSize.numBits)

    fun traceability (c, t) = TS.traceability (traceabilitySize (c, t))

    fun isNonRefPtr t =
        case t
         of M.TNonRefPtr      => true
          | M.TCode _         => true
          | M.TCString        => true
          | M.TContinuation _ => true
          | _                 => false

    fun isRef t =
        case t
         of M.TRef                                             => true
          | M.TName                                            => true
          | M.TNumeric M.Prims.NtRat                           => true
          | M.TNumeric (M.Prims.NtInteger M.Prims.IpArbitrary) => true
          | M.TTuple _                                         => true
          | M.TIdx                                             => true
          | M.TThunk _                                         => true
          | M.TPAny                                            => true
          | M.TClosure _                                       => true
          | M.TPSum _                                          => true
          | M.TPType _                                         => true
          | M.TPRef _                                          => true
          | _                                                  => false

     fun isP t =
         case t
          of M.TName             => true
           | M.TTuple {pok, ...} => PObjKind.isP pok
           | M.TPAny             => true
           | M.TClosure _        => true
           | M.TPSum _           => true
           | M.TPType _          => true
           | M.TPRef _           => true
           | _                   => false

    fun isCore t =
        case t
         of M.TAny                       => true
          | M.TAnyS vs                   => true
          | M.TNonRefPtr                 => true
          | M.TRef                       => true
          | M.TBits vs                   => true
          | M.TNone                      => true
          | M.TNumeric _                 => true
          | M.TBoolean                   => true
          | M.TName                      => true
          | M.TViVector et               => true
          | M.TViMask et                 => true
          | M.TCode {cc, args, ress}     => true
          | M.TTuple {pok, fixed, array} => true
          | M.TCString                   => true
          | M.TIdx                       => true
          | M.TContinuation ts           => true
          | M.TThunk t                   => true
          | M.TPAny                      => false
          | M.TClosure {args, ress}      => false
          | M.TPSum nts                  => false
          | M.TPType {kind, over}        => false
          | M.TPRef t                    => false

    val compare = Compare.typ
    val eq = Eq.typ

    fun fixedArray (pok, tvs) = M.TTuple {pok = pok, fixed = tvs, array = (M.TNone, M.FvReadWrite)}

    structure Dec =
    struct
      val tAny = 
       fn t => (case t of M.TAny => SOME () | _ => NONE)
      val tAnyS = 
       fn t => (case t of M.TAnyS r => SOME r | _ => NONE)
      val tNonRefPtr = 
       fn t => (case t of M.TNonRefPtr => SOME () | _ => NONE)
      val tRef = 
       fn t => (case t of M.TRef => SOME () | _ => NONE)
      val tBits = 
       fn t => (case t of M.TBits r => SOME r | _ => NONE)
      val tNone = 
       fn t => (case t of M.TNone => SOME () | _ => NONE)
      val tNumeric = 
       fn t => (case t of M.TNumeric r => SOME r | _ => NONE)
      val tBoolean = 
       fn t => (case t of M.TBoolean => SOME () | _ => NONE)
      val tName = 
       fn t =>(case t of M.TName => SOME () | _ => NONE)
      val tViVector = 
       fn t => (case t of M.TViVector r => SOME r | _ => NONE)
      val tViMask = 
       fn t => (case t of M.TViMask r => SOME r | _ => NONE)
      val tCode = 
       fn t => (case t of M.TCode r => SOME r | _ => NONE)
      val tTuple = 
       fn t => (case t of M.TTuple r => SOME r | _ => NONE)
      val tCString =
       fn t => (case t of M.TCString => SOME () | _ => NONE)
      val tIdx = 
       fn t => (case t of M.TIdx => SOME () | _ => NONE)
      val tContinuation = 
       fn t => (case t of M.TContinuation r => SOME r | _ => NONE)
      val tThunk = 
       fn t => (case t of M.TThunk r => SOME r | _ => NONE)
      val tPAny = 
       fn t => (case t of M.TPAny => SOME () | _ => NONE)
      val tClosure = 
       fn t => (case t of M.TClosure r => SOME r | _ => NONE)
      val tPSum = 
       fn t => (case t of M.TPSum r => SOME r | _ => NONE)
      val tPType = 
       fn t => (case t of M.TPType r => SOME r | _ => NONE)
      val tPRef = 
       fn t => (case t of M.TPRef t => SOME t | _ => NONE)
    end (* structure Dec *)


  end

  structure FieldKind =
  struct

    structure TS = TraceabilitySize

    type t = Mil.fieldKind

    fun fieldSize (config, fk) =
        case fk
         of M.FkRef => FieldSize.ptrSize config
          | M.FkBits fs => fs
          | M.FkFloat => M.Fs32
          | M.FkDouble => M.Fs64

    fun valueSize (config, fk) = FieldSize.toValueSize (fieldSize (config, fk))
    fun numBits   (config, fk) = FieldSize.numBits     (fieldSize (config, fk))
    fun numBytes  (config, fk) = FieldSize.numBytes    (fieldSize (config, fk))

    fun traceability fk =
        case fk
         of M.FkRef    => TS.TRef
          | M.FkBits _ => TS.TBits
          | M.FkFloat  => TS.TBits
          | M.FkDouble => TS.TBits

    fun isRef fk = TS.traceabilityIsRef (traceability fk)

    fun toString fk =
        case fk
         of M.FkRef     => "Ref"
          | M.FkBits fs => "Bits" ^ (Int.toString (FieldSize.numBits fs))
          | M.FkFloat   => "Float"
          | M.FkDouble  => "Double"

    val compare = Compare.fieldKind
    val eq = Eq.fieldKind

    fun fromString s =
        case s
         of "Bits8"  => SOME (M.FkBits M.Fs8)
          | "Bits16" => SOME (M.FkBits M.Fs16)
          | "Bits32" => SOME (M.FkBits M.Fs32)
          | "Bits64" => SOME (M.FkBits M.Fs64)
          | "Double" => SOME M.FkDouble
          | "Float"  => SOME M.FkFloat
          | "Ref"    => SOME M.FkRef
          | _        => NONE

    fun nonRefPtr c = M.FkBits (FieldSize.ptrSize c)

    fun fromTraceSize (c, ts) =
        let
          fun err () = Fail.fail ("MilUtils.FieldKind", "fromTraceSize", "bad trace size " ^ (TS.toString (c, ts)))
        in
          case ts
           of TS.TsAny       => err ()
            | TS.TsAnyS vs   => err ()
            | TS.TsBits vs   => M.FkBits (FieldSize.fromValueSize vs)
            | TS.TsFloat     => M.FkFloat
            | TS.TsDouble    => M.FkDouble
            | TS.TsRef       => M.FkRef
            | TS.TsNone      => err ()
            | TS.TsMask vs   => err ()
        end

    fun toTraceSize (c, fk) =
        (case fk
          of M.FkRef     => TS.TsRef
           | M.FkBits fs => TS.TsBits (FieldSize.toValueSize fs)
           | M.FkFloat   => TS.TsBits (FieldSize.toValueSize M.Fs32)
           | M.FkDouble  => TS.TsBits (FieldSize.toValueSize M.Fs64))

    val vsToFs = FieldSize.fromValueSize

    val fromNumericTyp = 
     fn (c, nt) => 
        (case nt
          of MP.NtRat                      => M.FkRef
           | MP.NtInteger MP.IpArbitrary   => M.FkRef
           | MP.NtInteger (MP.IpFixed sz)  => M.FkBits (FieldSize.intArb sz)
           | MP.NtFloat MP.FpSingle        => M.FkFloat
           | MP.NtFloat MP.FpDouble        => M.FkDouble)

    fun fromTyp' (c, t) =
        (case t
          of M.TAny                       => NONE
           | M.TAnyS vs                   => SOME (M.FkBits (vsToFs vs))
           | M.TNonRefPtr                 => SOME (M.FkBits (FieldSize.ptrSize c))
           | M.TRef                       => SOME M.FkRef
           | M.TBits vs                   => SOME (M.FkBits (vsToFs vs))
           | M.TNone                      => NONE
           | M.TNumeric nt                => SOME (fromNumericTyp (c, nt))
           | M.TBoolean                   => SOME (M.FkBits (FieldSize.wordSize c))
           | M.TName                      => SOME M.FkRef
           | M.TViVector et               => NONE
           | M.TViMask et                 => NONE
           | M.TCode {cc, args, ress}     => SOME (M.FkBits (FieldSize.ptrSize c))
           | M.TTuple {pok, fixed, array} => SOME M.FkRef
           | M.TCString                   => SOME (M.FkBits (FieldSize.ptrSize c))
           | M.TIdx                       => SOME M.FkRef
           | M.TContinuation ts           => SOME (M.FkBits (FieldSize.ptrSize c))
           | M.TThunk t                   => SOME M.FkRef
           | M.TPAny                      => SOME M.FkRef
           | M.TClosure {args, ress}      => SOME M.FkRef
           | M.TPSum nts                  => SOME M.FkRef
           | M.TPType {kind, over}        => SOME M.FkRef
           | M.TPRef t                    => SOME M.FkRef)

    fun fromTyp (c, t) =
        (case fromTyp' (c, t)
          of SOME fk => fk
           | NONE => Fail.fail ("MilUtils.FieldKind", "fromTyp", "No field kind for typ"))

    fun toTyp fk = 
        (case fk
          of M.FkRef     => M.TRef
           | M.FkBits fs => M.TBits (FieldSize.toValueSize fs)
           | M.FkFloat   => Prims.NumericTyp.tFloat
           | M.FkDouble  => Prims.NumericTyp.tDouble)

  end (* structure FieldKind *)

  structure FieldDescriptor =
  struct

    type t = Mil.fieldDescriptor

    fun kind (M.FD {kind = k, ...}) = k
    fun var (M.FD {var = v, ...}) = v

    fun fieldSize (config, fd) = FieldKind.fieldSize (config, kind fd)
    fun valueSize (config, fd) = FieldKind.valueSize (config, kind fd)
    fun numBits   (config, fd) = FieldKind.numBits   (config, kind fd)
    fun numBytes  (config, fd) = FieldKind.numBytes  (config, kind fd)

    fun traceability fd = FieldKind.traceability (kind fd)
    fun isRef fd = TraceabilitySize.traceabilityIsRef (traceability fd)

    fun mutable   fd = FieldVariance.mutable   (var fd)
    fun immutable fd = FieldVariance.immutable (var fd)

    val compare = Compare.fieldDescriptor
    val eq = Eq.fieldDescriptor

  end

  structure TupleDescriptor =
  struct

    type t = Mil.tupleDescriptor

    fun fixedFields (M.TD {fixed, ...}) = fixed
    fun array (M.TD {array = a, ...}) = a

    fun numFixed td = Vector.length (fixedFields td)
    fun fixedField (td, i) = Vector.sub (fixedFields td, i)

    fun hasArray td = Option.isSome (array td)

    fun immutable td =
        Vector.forall (fixedFields td, FieldDescriptor.immutable) andalso
        Option.forall (array td, FieldDescriptor.immutable)

    fun getField (td, i) =
        let
          val fds = fixedFields td
        in
          if i < Vector.length fds then
            SOME (Vector.sub (fds, i))
          else
            array td
        end

    val compare = Compare.tupleDescriptor
    val eq = Eq.tupleDescriptor

  end

  structure MetaDataDescriptor =
  struct

    type t = Mil.metaDataDescriptor

    fun pok (M.MDD {pok = p, ...}) = p
    fun fixedFields (M.MDD {fixed, ...}) = fixed
    fun array (M.MDD {array = a, ...}) = a

    fun numFixed mdd = Vector.length (fixedFields mdd)
    fun fixedField (mdd, i) = Vector.sub (fixedFields mdd, i)

    fun hasArray mdd = Option.isSome (array mdd)
    fun lengthField mdd = Option.map (array mdd, #1)
    fun arrayDescriptor mdd = Option.map (array mdd, #2)

    fun immutable mdd =
        Vector.forall (fixedFields mdd, FieldDescriptor.immutable) andalso
        Option.forall (array mdd, FieldDescriptor.immutable o #2)

    fun toTupleDescriptor (M.MDD {fixed, array, ...}) =
        M.TD {fixed = fixed, array = Option.map (array, #2)}

    val compare = Compare.metaDataDescriptor
    val eq = Eq.metaDataDescriptor

  end

  structure Constant =
  struct

    type t = Mil.constant

    fun isCore c =
        case c
         of M.CBoolean _      => true
          | M.CRat _          => true
          | M.CInteger _      => true
          | M.CName _         => true
          | M.CIntegral _     => true
          | M.CFloat _        => true
          | M.CDouble _       => true
          | M.CViMask _       => true
          | M.CPok _          => true
          | M.CRef _          => true
          | M.COptionSetEmpty => false
          | M.CTypePH         => false

    val compare = Compare.constant

    val eq = Eq.constant

    val pObjKind = 
     fn c => 
        (case c
          of M.CBoolean _      => NONE
           | M.CRat _          => NONE
           | M.CInteger _      => NONE
           | M.CName _         => SOME M.PokName
           | M.CIntegral _     => NONE
           | M.CFloat _        => NONE
           | M.CDouble _       => NONE
           | M.CViMask _       => NONE
           | M.CPok _          => NONE
           | M.CRef _          => NONE
           | M.COptionSetEmpty => SOME M.PokOptionSet
           | M.CTypePH         => SOME M.PokType)

    structure Dec =
    struct
      val cBoolean  = 
       fn c => (case c of M.CBoolean b => SOME b | _ => NONE)
      val cRat = 
       fn c => (case c of M.CRat r => SOME r | _ => NONE)
      val cInteger = 
       fn c => (case c of M.CInteger r => SOME r | _ => NONE)
      val cName = 
       fn c => (case c of M.CName r => SOME r | _ => NONE)
      val cIntegral = 
       fn c => (case c of M.CIntegral r => SOME r | _ => NONE)
      val cFloat = 
       fn c => (case c of M.CFloat r => SOME r | _ => NONE)
      val cDouble = 
       fn c => (case c of M.CDouble r => SOME r | _ => NONE)
      val cViMask = 
       fn c => (case c of M.CViMask r => SOME r | _ => NONE)
      val cPok = 
       fn c => (case c of M.CPok r => SOME r | _ => NONE)
      val cRef = 
       fn c => (case c of M.CRef i => SOME i | _ => NONE)
      val cOptionSetEmpty = 
       fn c => (case c of M.COptionSetEmpty => SOME () | _ => NONE)
      val cTypePH = 
       fn c => (case c of M.CTypePH => SOME () | _ => NONE)
    end (* structure Dec *)

  end

  structure Simple =
  struct

    type t = Mil.simple

    val compare = Compare.simple
    val eq = Eq.simple

    val pObjKind = 
     fn s => 
        (case s
          of M.SConstant c => Constant.pObjKind c
           | M.SVariable v => NONE)

    structure Dec =
    struct
      val sVariable =
       fn s => (case s of M.SVariable r => SOME r | _ => NONE)
      val sConstant =
       fn s => (case s of M.SConstant r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure Operand =
  struct

    type t = Mil.operand

    val compare = Compare.operand
    val eq = Eq.operand

    structure Dec = Simple.Dec

  end

  structure TupleBase = 
  struct
    type t = Mil.tupleBase
    val compare = Compare.tupleBase
    val eq      = Eq.tupleBase
    structure Dec = 
    struct
      val tbScalar = fn tu => (case tu of Mil.TbScalar => SOME () | _ => NONE)
      val tbVector = fn tu => (case tu of Mil.TbVector => SOME () | _ => NONE)
    end (* structure Dec *)
  end (* structure TupleBase *)

  structure VectorIndexKind = 
  struct
    type t = Mil.vectorIndexKind
    val compare = Compare.vectorIndexKind
    val eq      = Eq.vectorIndexKind
    structure Dec = 
    struct
      val vikStrided = fn ve => (case ve of Mil.VikStrided r => SOME r | _ => NONE)
      val vikVector  = fn ve => (case ve of Mil.VikVector => SOME () | _ => NONE)
    end (* structure Dec *)
  end (* structure VectorIndexKind *)

  structure FieldIdentifier =
  struct

    type t = Mil.fieldIdentifier

    val compare = Compare.fieldIdentifier

    val eq      = Eq.fieldIdentifier

    fun fixed fi =
        case fi
         of M.FiFixed idx                 => SOME idx
          | M.FiVariable idx              => NONE
          | M.FiVectorFixed {index, ...}  => SOME index
          | M.FiVectorVariable _          => NONE

    fun variable fi =
        case fi
         of M.FiFixed idx                   => NONE
          | M.FiVariable idx                => SOME idx
          | M.FiVectorFixed _               => NONE
          | M.FiVectorVariable {index, ...} => SOME index

    fun vectorDescriptor fi =
        case fi
         of M.FiFixed idx             => NONE
          | M.FiVariable idx          => NONE
          | M.FiVectorFixed r    => SOME (#descriptor r)
          | M.FiVectorVariable r => SOME (#descriptor r)

    fun isFixed    fi = Option.isSome (fixed fi)
    fun isVariable fi = Option.isSome (variable fi)
    fun isScalar   fi = Option.isNone (vectorDescriptor fi)
    fun isVector   fi = Option.isSome (vectorDescriptor fi)

    fun isVectorIndex fi =
        case fi
         of M.FiFixed idx        => false
          | M.FiVariable idx     => false
          | M.FiVectorFixed _    => false
          | M.FiVectorVariable r => (case #kind r
                                      of M.VikStrided _ => false
                                       | M.VikVector    => true)


    fun fieldDescriptor (td, fi) =
        let
          fun array () =
              case TupleDescriptor.array td
               of NONE => Fail.fail ("MilUtils.FieldIdentifier",
                                     "fieldDescriptor",
                                     "array portion expected")
                | SOME fd => fd
          fun fixed idx =
              if idx < TupleDescriptor.numFixed td then
                TupleDescriptor.fixedField (td, idx)
              else
                array ()
        in
          case fi
           of M.FiFixed idx        => fixed idx
            | M.FiVariable idx     => array ()
            | M.FiVectorFixed r    => fixed (#index r)
            | M.FiVectorVariable r => array ()
        end

    structure Dec = 
    struct
      val fiFixed          = fn fi => (case fi of Mil.FiFixed r => SOME r | _ => NONE)
      val fiVariable       = fn fi => (case fi of Mil.FiVariable r => SOME r | _ => NONE)
      val fiVectorFixed    = fn fi => (case fi of Mil.FiVectorFixed r => SOME r | _ => NONE)
      val fiVectorVariable = fn fi => (case fi of Mil.FiVectorVariable r => SOME r | _ => NONE)
    end (* structure Dec *)

  end (* structure FieldIdentifier *)

  structure TupleField =
  struct

    type t = Mil.tupleField

    fun tupDesc (M.TF {tupDesc = td, ...}) = td
    fun tup (M.TF {tup = t, ...}) = t
    fun field (M.TF {field = fi, ...}) = fi

    fun isFixed          tf = FieldIdentifier.isFixed          (field tf)
    fun isVariable       tf = FieldIdentifier.isVariable       (field tf)
    fun isScalar         tf = FieldIdentifier.isScalar         (field tf)
    fun isVector         tf = FieldIdentifier.isVector         (field tf)
    fun isVectorIndex    tf = FieldIdentifier.isVectorIndex    (field tf)
    fun fixed            tf = FieldIdentifier.fixed            (field tf)
    fun variable         tf = FieldIdentifier.variable         (field tf)
    fun vectorDescriptor tf = FieldIdentifier.vectorDescriptor (field tf)

    fun fieldDescriptor tf =
        FieldIdentifier.fieldDescriptor (tupDesc tf, field tf)

    val compare = Compare.tupleField
    val eq = Eq.tupleField

  end

  structure Rhs =
  struct

    type t = Mil.rhs

    fun isCore rhs =
        case rhs
         of M.RhsSimple _         => true
          | M.RhsPrim _           => true
          | M.RhsTuple _          => true
          | M.RhsTupleSub _       => true
          | M.RhsTupleSet _       => true
          | M.RhsTupleInited _    => true
          | M.RhsIdxGet _         => true
          | M.RhsCont _           => true
          | M.RhsObjectGetKind _  => true
          | M.RhsThunkMk _        => true
          | M.RhsThunkInit _      => true
          | M.RhsThunkGetFv _     => true
          | M.RhsThunkValue _     => true
          | M.RhsThunkGetValue _  => true
          | M.RhsThunkSpawn _     => true
          | M.RhsClosureMk _      => false
          | M.RhsClosureInit _    => false
          | M.RhsClosureGetFv _   => false
          | M.RhsPSetNew _        => false
          | M.RhsPSetGet _        => false
          | M.RhsPSetCond _       => false
          | M.RhsPSetQuery _      => false
          | M.RhsPSum _           => false
          | M.RhsPSumProj _       => false

    val compare = Compare.rhs
    val eq = Eq.rhs

    structure O = struct type t = t val compare = compare end
    structure Dict = DictF(O)

    local
      open Effect
      val T = Total
      val A = PAny
      val R = ReadOnly
      val writeS = fromList [HeapWrite, InitWrite]
      val readS  = fromList [HeapRead, InitRead]
      val genS   = fromList [HeapGen, InitGen]
      fun tuple {mdDesc, inits} =
          let
            val fx = T
            val fx = 
                if MetaDataDescriptor.hasArray mdDesc orelse
                   MetaDataDescriptor.numFixed mdDesc <> Vector.length inits then
                  union (fx, InitGenS)
                else 
                  fx
            val fx = 
                if MetaDataDescriptor.immutable mdDesc then
                  fx
                else 
                  union (fx, HeapGenS)
          in fx
          end

      fun tupleSub tf =
          if FieldDescriptor.immutable (TupleField.fieldDescriptor tf) then
            InitReadS 
          else 
            readS

      fun tupleSet {tupField, ofVal} =
          if FieldDescriptor.immutable (TupleField.fieldDescriptor tupField) then
            InitWriteS
          else 
            writeS

      (* Note that evals cannot be re-ordered with getVals, and hence
       * they need to be assigned effects that prevent re-ordering 
       *)
      fun thunkInit {thunk, ...} =
          if Option.isSome thunk then InitWriteS else InitGenS
      fun thunkValue {thunk, ...} =
          if Option.isSome thunk then InitWriteS else T
      fun pFunctionInit {cls, ...} =
          if Option.isSome cls then InitWriteS else T
    in
    fun fx (config, rhs) =
        case rhs
         of M.RhsSimple _             => T
          | M.RhsPrim {prim, ...}     => PrimsUtils.Effects.t prim
          | M.RhsTuple x              => tuple x
          | M.RhsTupleSub x           => tupleSub x
          | M.RhsTupleSet x           => tupleSet x
          | M.RhsTupleInited _        => InitWriteS
          | M.RhsIdxGet _             => InitReadS
          | M.RhsCont _               => T
          | M.RhsObjectGetKind _      => T
          | M.RhsThunkMk _            => genS
          | M.RhsThunkInit x          => thunkInit x
          | M.RhsThunkGetFv _         => InitReadS
          | M.RhsThunkValue x         => thunkValue x
          | M.RhsThunkGetValue _      => InitReadS
          | M.RhsThunkSpawn {fx, ...} => fx
          | M.RhsClosureMk _          => InitGenS
          | M.RhsClosureInit x        => pFunctionInit x
          | M.RhsClosureGetFv _       => InitReadS
          | M.RhsPSetNew _            => T
          | M.RhsPSetGet _            => T
          | M.RhsPSetCond _           => T
          | M.RhsPSetQuery _          => T
          | M.RhsPSum _               => T
          | M.RhsPSumProj _           => T
    end

    val getInit = 
     fn rhs => 
        (case rhs 
          of M.RhsTupleSet {tupField = M.TF {tup, tupDesc, ...}, ...} => 
             if TupleDescriptor.immutable tupDesc then SOME tup else NONE
           | M.RhsTupleInited {tup, mdDesc} => 
             if MetaDataDescriptor.immutable mdDesc then SOME tup else NONE
           | M.RhsThunkInit {thunk, ...} => thunk
           | M.RhsThunkValue {thunk, ...} => thunk
           | M.RhsClosureInit {cls, ...} => cls
           | _ => NONE)

    val isInit = isSome o getInit
    val isInitOf =
     fn (rhs, v) => 
        (case getInit rhs
          of SOME v' => v = v'
           | NONE => false)

    val pObjKind =
     fn rhs => 
        (case rhs 
          of M.RhsSimple s             => Simple.pObjKind s
           | M.RhsPrim _               => NONE (* XXX anything else here?  -leaf *)
           | M.RhsTuple {mdDesc, ...}  => SOME (MetaDataDescriptor.pok mdDesc)
           | M.RhsTupleSub _           => NONE
           | M.RhsTupleSet _           => NONE
           | M.RhsTupleInited _        => NONE
           | M.RhsIdxGet _             => NONE
           | M.RhsCont _               => NONE
           | M.RhsObjectGetKind _      => NONE
           | M.RhsThunkMk _            => SOME M.PokCell 
           | M.RhsThunkInit _          => SOME M.PokCell 
           | M.RhsThunkGetFv _         => NONE
           | M.RhsThunkValue _         => SOME M.PokCell 
           | M.RhsThunkGetValue _      => NONE
           | M.RhsThunkSpawn _         => NONE
           | M.RhsClosureMk _          => SOME M.PokFunction
           | M.RhsClosureInit x        => SOME M.PokFunction
           | M.RhsClosureGetFv _       => NONE
           | M.RhsPSetNew _            => SOME M.PokOptionSet
           | M.RhsPSetGet _            => NONE
           | M.RhsPSetCond _           => SOME M.PokOptionSet
           | M.RhsPSetQuery _          => NONE
           | M.RhsPSum _               => SOME M.PokTagged
           | M.RhsPSumProj _           => NONE)

    fun arity (config, rhs) =
        case rhs
         of M.RhsSimple _                          => 1
          | M.RhsPrim {prim, ...}                  => #1 (PrimsUtils.Arity.count (PrimsUtils.Arity.t prim))
          | M.RhsTuple x                           => 1
          | M.RhsTupleSub _                        => 1
          | M.RhsTupleSet _                        => 0
          | M.RhsTupleInited _                     => 0
          | M.RhsIdxGet _                          => 1
          | M.RhsCont _                            => 1
          | M.RhsObjectGetKind _                   => 1
          | M.RhsThunkMk _                         => 1
          | M.RhsThunkInit {thunk = NONE, ...}     => 1
          | M.RhsThunkInit {thunk = SOME _, ...}   => 0
          | M.RhsThunkGetFv _                      => 1
          | M.RhsThunkValue {thunk = NONE, ...}    => 1
          | M.RhsThunkValue {thunk = SOME _, ...}  => 0
          | M.RhsThunkGetValue _                   => 1
          | M.RhsThunkSpawn _                      => 0
          | M.RhsClosureMk _                       => 1
          | M.RhsClosureInit {cls = NONE, ...}     => 1
          | M.RhsClosureInit {cls = SOME _, ...}   => 0
          | M.RhsClosureGetFv _                    => 1
          | M.RhsPSetNew _                         => 1
          | M.RhsPSetGet _                         => 1
          | M.RhsPSetCond _                        => 1
          | M.RhsPSetQuery _                       => 1
          | M.RhsPSum _                            => 1
          | M.RhsPSumProj _                        => 1

    structure Dec =
    struct
      val rhsSimple = 
       fn rhs => (case rhs of M.RhsSimple r => SOME r | _ => NONE)
      val rhsPrim = 
       fn rhs => (case rhs of M.RhsPrim r => SOME r | _ => NONE)
      val rhsTuple = 
       fn rhs => (case rhs of M.RhsTuple r => SOME r | _ => NONE)
      val rhsTupleSub = 
       fn rhs => (case rhs of M.RhsTupleSub r => SOME r | _ => NONE)
      val rhsTupleSet = 
       fn rhs => (case rhs of M.RhsTupleSet r => SOME r | _ => NONE)
      val rhsTupleInited = 
       fn rhs => (case rhs of M.RhsTupleInited r => SOME r | _ => NONE)
      val rhsIdxGet = 
       fn rhs => (case rhs of M.RhsIdxGet r => SOME r | _ => NONE)
      val rhsCont = 
       fn rhs => (case rhs of M.RhsCont r => SOME r | _ => NONE)
      val rhsObjectGetKind = 
       fn rhs => (case rhs of M.RhsObjectGetKind r => SOME r | _ => NONE)
      val rhsThunkMk = 
       fn rhs => (case rhs of M.RhsThunkMk r => SOME r | _ => NONE)
      val rhsThunkInit = 
       fn rhs => (case rhs of M.RhsThunkInit r => SOME r | _ => NONE)
      val rhsThunkGetFv = 
       fn rhs => (case rhs of M.RhsThunkGetFv r => SOME r | _ => NONE)
      val rhsThunkValue = 
       fn rhs => (case rhs of M.RhsThunkValue r => SOME r | _ => NONE)
      val rhsThunkGetValue = 
       fn rhs => (case rhs of M.RhsThunkGetValue r => SOME r | _ => NONE)
      val rhsThunkSpawn = 
       fn rhs => (case rhs of M.RhsThunkSpawn r => SOME r | _ => NONE)
      val rhsClosureMk = 
       fn rhs => (case rhs of M.RhsClosureMk r => SOME r | _ => NONE)
      val rhsClosureInit = 
       fn rhs => (case rhs of M.RhsClosureInit r => SOME r | _ => NONE)
      val rhsClosureGetFv = 
       fn rhs => (case rhs of M.RhsClosureGetFv r => SOME r | _ => NONE)
      val rhsPSetNew = 
       fn rhs => (case rhs of M.RhsPSetNew r => SOME r | _ => NONE)
      val rhsPSetGet = 
       fn rhs => (case rhs of M.RhsPSetGet r => SOME r | _ => NONE)
      val rhsPSetCond = 
       fn rhs => (case rhs of M.RhsPSetCond r => SOME r | _ => NONE)
      val rhsPSetQuery = 
       fn rhs => (case rhs of M.RhsPSetQuery r => SOME r | _ => NONE)
      val rhsPSum = 
       fn rhs => (case rhs of M.RhsPSum r => SOME r | _ => NONE)
      val rhsPSumProj = 
       fn rhs => (case rhs of M.RhsPSumProj r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure Instruction =
  struct

    type t = Mil.instruction

    fun new' (vv, rhs) = M.I {dests = vv, n = 0, rhs = rhs}

    fun new (v, rhs) = new' (Vector.new1 v, rhs)

    fun dests (M.I {dests, ...}) = dests

    fun dest (M.I {dests, ...}) = 
        (case Utils.Option.fromVector dests
          of SOME opt => opt
           | NONE => Fail.fail ("MilUtils.Instruction", "dest", "More than one destination"))

    fun n (M.I {n, ...}) = n

    fun rhs  (M.I {rhs,  ...}) = rhs

    fun isCore i = Rhs.isCore (rhs i)

    val compare = Compare.instruction

    val eq = Eq.instruction

    fun fx (config, i) = Rhs.fx (config, rhs i)

    val isInit = Rhs.isInit o rhs

    val isInitOf = 
     fn (i, v) => Rhs.isInitOf (rhs i, v)

    val pObjKind = Rhs.pObjKind o rhs

  end

  structure Target =
  struct

    type t = Mil.target

    fun block (M.T {block, ...}) = block

    fun arguments (M.T {arguments, ...}) = arguments

    fun argument (t, idx) = Vector.sub (arguments t, idx)

    val compare = Compare.target
    val eq = Eq.target

    fun fromVars (b, vs) =
        M.T {block = b, arguments = Vector.map (vs, M.SVariable)}

    structure Dec = 
    struct
      val t = fn (M.T args) => args
    end
  end

  structure Switch =
  struct

    type 'a t = 'a Mil.switch

    fun on      ({on,      ...} : 'a t) = on
    fun cases   ({cases,   ...} : 'a t) = cases
    fun default ({default, ...} : 'a t) = default

    fun getCase    (s, idx) = Vector.sub (cases s, idx)
    fun caseValue  (s, idx) = #1 (getCase (s, idx))
    fun caseTarget (s, idx) = #2 (getCase (s, idx))

    fun hasDefault s = Option.isSome (default s)

    val compare = Compare.switch
    val eq = Eq.switch

    fun noDefault (opnd, cases) =
        {on = opnd, cases = cases, default = NONE}

    fun noArgs (opnd, cases, default) =
        let
          fun doOne l = M.T {block = l, arguments = Vector.new0 ()}
          fun doCase (k, l) = (k, doOne l)
        in
          {on = opnd, cases = Vector.map (cases, doCase),
           default = Option.map (default, doOne)}
        end

    fun noArgsNoDefault (opnd, cases) = noArgs (opnd, cases, NONE)

  end

  structure Codes =
  struct

    type t = Mil.codes

    fun possible   ({possible,    ...} : t) = possible
    fun exhaustive ({exhaustive, ...} : t) = exhaustive

    val compare = Compare.codes
    val eq = Eq.codes

    val all = {possible = VS.empty, exhaustive = false}
    val none = {possible = VS.empty, exhaustive = true}

  end

  structure Call =
  struct

    type t = Mil.call

    val compare = Compare.call
    val eq = Eq.call

    val cls = 
     fn call =>
        (case call
          of M.CCode _ => NONE
           | M.CClosure {cls, ...} => SOME cls
           | M.CDirectClosure {cls, ...} => SOME cls)

    val code =
     fn call => 
        (case call
          of M.CCode {ptr, ...} => SOME ptr
           | M.CClosure _ => NONE
           | M.CDirectClosure {code, ...} => SOME code)

    val codes = 
     fn call => 
        (case call
          of M.CCode {code, ...} => code
           | M.CClosure {code, ...} => code
           | M.CDirectClosure {cls, code} => {possible = VS.singleton code, exhaustive = true})

    structure Dec = 
    struct
      val cCode = 
       fn c => (case c of M.CCode r => SOME r | _ => NONE)
      val cClosure = 
       fn c => (case c of M.CClosure r => SOME r | _ => NONE)
      val cDirectClosure = 
       fn c => (case c of M.CDirectClosure r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure Eval =
  struct

    type t = Mil.eval

    val compare = Compare.eval
    val eq = Eq.eval

    val thunk = 
     fn eval => 
        (case eval
          of M.EThunk {thunk, ...} => thunk
           | M.EDirectThunk {thunk, ...} => thunk)

    val codes = 
     fn eval => 
        (case eval
          of M.EThunk {thunk, code} => code
           | M.EDirectThunk {thunk, code} => {possible = VS.singleton code, exhaustive = true})

    structure O = struct type t = t val compare = compare end
    structure Dict = DictF(O)

    structure Dec =
    struct
      val eThunk =
       fn t => (case t of M.EThunk r => SOME r | _ => NONE)
      val eDirectThunk =
       fn t => (case t of M.EDirectThunk r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure InterProc =
  struct

    type t = Mil.interProc

    val compare = Compare.interProc
    val eq = Eq.interProc 

    val codes =
     fn i => 
        (case i
          of M.IpCall {call, ...} => Call.codes call
           | M.IpEval {eval, ...} => Eval.codes eval)

    structure Dec =
    struct
      val ipCall =
       fn i => (case i of M.IpCall r => SOME r | _ => NONE)
      val ipEval =
       fn i => (case i of M.IpEval r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure Cuts =
  struct

    type t = Mil.cuts

    fun exits   (M.C {exits,   ...}) = exits
    fun targets (M.C {targets, ...}) = targets

    fun hasCuts (M.C {exits, targets}) = exits orelse (not (LS.isEmpty targets))

    fun includes (cuts, l) = LS.member (targets cuts, l)

    fun union (M.C {exits = e1, targets = ts1}, M.C {exits = e2, targets = ts2}) =
        M.C {exits = e1 orelse e2, targets = LS.union (ts1, ts2)}

    fun intersection (M.C {exits = e1, targets = ts1}, M.C {exits = e2, targets = ts2}) =
        M.C {exits = e1 andalso e2, targets = LS.intersection (ts1, ts2)}

    fun inlineCall (cuts1 as M.C {exits = e1, targets = ts1}, M.C {exits = e2, targets = ts2}) =
        if not e1 then cuts1 else M.C {exits = e2, targets = LS.union (ts1, ts2)}

    val compare = Compare.cuts
    val eq = Eq.cuts

    val none = M.C {exits = false, targets = LS.empty}

    val justExits = M.C {exits = true, targets = LS.empty}

  end

  structure Return =
  struct

    type t = Mil.return

    val compare = Compare.return
    val eq = Eq.return
    fun cuts r =
        case r
         of M.RNormal {cuts, ...} => cuts
          | M.RTail {exits, ...}  => M.C {exits = exits, targets = LS.empty}

    fun binds r =
        case r
         of M.RNormal {rets, ...} => rets
          | M.RTail _             => Vector.new0 ()

    structure Dec =
    struct
      val rNormal =
       fn r => (case r of M.RNormal r => SOME r | _ => NONE)
      val rTail =
       fn r => (case r of M.RTail r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure OutEdge =
  struct

    datatype kind =
        OekGoto of {args : Operand.t Vector.t}
      | OekCase of {on : Operand.t, eq : Constant.t, args : Operand.t Vector.t}
      | OekCaseDefault of {
          on    : Operand.t,
          cases : Constant.t Vector.t,
          args  : Operand.t Vector.t
        }
      | OekInterProcRet of
        {callee : InterProc.t, rets : Mil.variable Vector.t, fx : Mil.effects}
      | OekInterProcTail of {callee : InterProc.t, fx : Mil.effects}
      | OekReturn of Operand.t Vector.t
      | OekCut
      | OekHalt of Operand.t
      | OekPSumCase of
        {on : Operand.t, eq : Mil.name, args : Operand.t Vector.t}
      | OekPSumCaseDefault of
        {on : Operand.t, cases : Mil.name Vector.t, args : Operand.t Vector.t}

    datatype dest = OedBlock of Mil.label | OedExit

    datatype t = OE of {kind : kind, dest : dest}

    val target = 
        fn (OE {kind, dest}) => 
           (case dest 
             of OedBlock l => SOME l
              | OedExit => NONE)

    val exits = not o Option.isSome o target

  end

  structure Transfer =
  struct

    type t = Mil.transfer

(*        case t
         of M.TGoto t                      =>
          | M.TCase s                      =>
          | M.TInterProc {callee, ret, fx} =>
          | M.TReturn os                   =>
          | M.TCut {cont, args, cuts}      =>
          | M.THalt opnd                   =>
          | M.TPSumCase s                  =>
*)

    fun isCore t =
        case t
         of M.TGoto t                      => true
          | M.TCase s                      => true
          | M.TInterProc {callee, ret, fx} => true
          | M.TReturn os                   => true
          | M.TCut {cont, args, cuts}      => true
          | M.THalt _                      => true
          | M.TPSumCase s                  => false

    val compare = Compare.transfer
    val eq = Eq.transfer

    local 

      open OutEdge

      fun doSwitch (ce, de, {on, cases, default}) =
          let
            val n = Vector.length cases
            val m = n + (if Option.isSome default then 1 else 0)
            fun genCase (c, M.T {block, arguments}) =
                OE {kind = ce {on = on, eq = c, args = arguments},
                    dest = OedBlock block}
            fun genOne i =
                if i < n then
                  genCase (Vector.sub (cases, i))
                else
                  let
                    val M.T {block, arguments = args} = Option.valOf default
                    val cs = Vector.map (cases, #1)
                    val k = de {on = on, cases = cs, args = args}
                    val oe = OE {kind = k, dest = OedBlock block}
                  in oe
                  end
            val es = Vector.tabulate (m, genOne)
          in es
          end

      fun genCutsEdges (M.C {exits, targets, ...}) =
          let
            val ls = LS.toVector targets
            val n = Vector.length ls
            val m = n + (if exits then 1 else 0)
            fun genOne i =
                if i < n
                then OE {kind = OekCut, dest = OedBlock (Vector.sub (ls, i))}
                else OE {kind = OekCut, dest = OedExit}
            val es = Vector.tabulate (m, genOne)
          in es
          end
    in

    fun outEdges t =
        case t
         of M.TGoto (M.T {block, arguments}) =>
            Vector.new1 (OE {kind = OekGoto {args = arguments},
                             dest = OedBlock block})
          | M.TCase s => doSwitch (OekCase, OekCaseDefault, s)
          | M.TInterProc {callee, ret, fx} =>
            (case ret
              of M.RNormal {rets, block, cuts} =>
                 let
                   val k =
                       OekInterProcRet {callee = callee, rets = rets, fx = fx}
                   val e1 = OE {kind = k, dest = OedBlock block}
                   val es = genCutsEdges cuts
                   val es = Utils.Vector.cons (e1, es)
                 in es
                 end
               | M.RTail {exits} =>
                 Vector.new1 (OE {kind = OekInterProcTail {callee = callee, fx = fx}, dest = OedExit}))
          | M.TReturn os => Vector.new1 (OE {kind = OekReturn os, dest = OedExit})
          | M.TCut {cuts, ...} => genCutsEdges cuts
          | M.THalt opnd => Vector.new1 (OE {kind = OekHalt opnd, dest = OedExit})
          | M.TPSumCase s => doSwitch (OekPSumCase, OekPSumCaseDefault, s)

    fun targets t =
        let
          val es = outEdges t
          val ts = Vector.keepAllMap (es, OutEdge.target)
          val exits = Vector.exists (es, OutEdge.exits)
        in {blocks = ts, exits = exits}
        end

    fun successors t =
        let
          val {blocks, exits} = targets t
          val blocks = LS.fromVector blocks
        in {blocks = blocks, exits = exits}
        end

    end

    fun cuts t =
        case t
         of M.TGoto _               => Cuts.none
          | M.TCase _               => Cuts.none
          | M.TInterProc {ret, ...} => Return.cuts ret
          | M.TReturn _             => Cuts.none
          | M.TCut {cuts, ...}      => cuts
          | M.THalt _               => Cuts.none
          | M.TPSumCase _           => Cuts.none

    fun isBoolIf t =
        Try.try
        (fn () =>
            let
              val (on, cases) = 
                  case t
                   of M.TCase {on, cases, default = NONE} => (on, cases)
                    | _ => Try.fail ()
              val () = Try.V.lenEq (cases, 2)
              val (c1, t1) =
                  case Vector.sub (cases, 0)
                   of (M.CIntegral c, t1) => (c, t1)
                    | _ => Try.fail ()
              val (c2, t2) =
                  case Vector.sub (cases, 1)
                   of (M.CIntegral c, t2) => (c, t2)
                    | _ => Try.fail ()
              val c1 = IntArb.toIntInf c1
              val c2 = IntArb.toIntInf c2
              val (tt, tf) =
                  if c1 = IntInf.zero andalso c2 = IntInf.one
                  then (t2, t1)
                  else if c1 = IntInf.one andalso c2 = IntInf.zero
                  then (t1, t2)
                  else Try.fail ()
            in {on = on, trueBranch = tt, falseBranch = tf}
            end)

    val mapOverTargets = 
     fn (t, f) => 
        let
          val doCase = 
           fn {on, cases, default} => 
              let
                val cases = Vector.map (cases, (fn (a, tg) => (a, f tg)))
                val default = Option.map (default, f)
              in {on = on, cases = cases, default = default}
              end
        in
          case t
           of M.TGoto tg     => M.TGoto (f tg)
            | M.TCase r      => M.TCase (doCase r)
            | M.TInterProc _ => t
            | M.TReturn _    => t
            | M.TCut _       => t
            | M.THalt _      => t
            | M.TPSumCase r  => M.TPSumCase (doCase r)
        end

    val isIntraProcedural = 
     fn t => 
        let
          val doCase = 
           fn {on, cases, default} => 
              let
                val tgs = Vector.map (cases, #2)
              in
                SOME (case default
                       of NONE => tgs
                        | SOME tg => Utils.Vector.cons (tg, tgs))
              end
        in
          case t
           of M.TGoto tg     => SOME (Vector.new1 tg)
            | M.TCase r      => doCase r
            | M.TInterProc _ => NONE
            | M.TReturn _    => NONE
            | M.TCut _       => NONE
            | M.THalt _      => NONE
            | M.TPSumCase r  => doCase r
        end

    (* Note that evals cannot be re-ordered with getVals, and hence
     * these two need to be assigned effects that prevent re-ordering 
     *)
    val fx  = 
     fn (c, t) => 
        let
          val T = Effect.Total
          val fx = 
              case t
               of M.TGoto _                      => T
                | M.TReturn _                    => T
                | M.TInterProc {callee, fx, ...} => 
                  (case callee
                    of M.IpEval _ => Effect.union (fx, Effect.fromList [Effect.InitRead, Effect.InitWrite])
                     | M.IpCall _ => fx)
                | M.TCase _                      => T
                | M.TCut _                       => Effect.FailsS
                | M.THalt _                      => T
                | M.TPSumCase  _                 => T
        in fx
        end

    fun binds t =
        case t
         of M.TGoto t                      => Vector.new0 ()
          | M.TCase s                      => Vector.new0 ()
          | M.TInterProc {callee, ret, fx} => Return.binds ret
          | M.TReturn os                   => Vector.new0 ()
          | M.TCut {cont, args, cuts}      => Vector.new0 ()
          | M.THalt opnd                   => Vector.new0 ()
          | M.TPSumCase s                  => Vector.new0 ()

    structure Dec =
    struct
      val tGoto = 
       fn t => (case t of M.TGoto r => SOME r | _ => NONE)
      val tCase =
         fn t => (case t of M.TCase r => SOME r | _ => NONE)
      val tInterProc =
       fn t => (case t of M.TInterProc r => SOME r | _ => NONE)
      val tReturn =
       fn t => (case t of M.TReturn r => SOME r | _ => NONE)
      val tCut =
       fn t => (case t of M.TCut r => SOME r | _ => NONE)
      val tHalt =
       fn t => (case t of M.THalt r => SOME r | _ => NONE)
      val tPSumCase =
       fn t => (case t of M.TPSumCase r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure Block =
  struct

    type t = Mil.block

    fun parameters   (M.B {parameters,   ...}) = parameters
    fun instructions (M.B {instructions, ...}) = instructions
    fun transfer     (M.B {transfer,     ...}) = transfer

    fun numParameters b = Vector.length (parameters b)
    fun parameter (b, idx) = Vector.sub (parameters b, idx)

    fun numInstructions b = Vector.length (instructions b)
    fun instruction (b, idx) = Vector.sub (instructions b, idx)

    fun isCore b = 
        Vector.forall (instructions b, Instruction.isCore) andalso
        Transfer.isCore (transfer b)

    val compare = Compare.block
    val eq = Eq.block

    fun outEdges b = Transfer.outEdges (transfer b)
    fun targets b = Transfer.targets (transfer b)
    fun successors b = Transfer.successors (transfer b)

    fun cuts b = Transfer.cuts (transfer b)

    fun getBoolTargets (targets : (Mil.constant * Mil.target) Vector.t) =
        if Vector.length (targets) = 2 then
          let 
            fun isTrue (c) = Compare.constant (c, Mil.CInteger (IntInf.fromInt 1)) = EQUAL
            fun isFalse (c) = Compare.constant (c, Mil.CInteger (IntInf.fromInt 0)) = EQUAL
            val (c1, Mil.T t1) = Vector.sub (targets, 0)
            val (c2, Mil.T t2) = Vector.sub (targets, 1)
          in
            if (isTrue c1 andalso isFalse c2) then 
              SOME (#block t1, #block t2)
            else if (isFalse c1 andalso isTrue c2) then 
              SOME (#block t2, #block t1)
            else
              NONE
          end
        else
          NONE

    val getBoolSuccessors : Mil.block -> (Mil.label * Mil.label) option = 
     fn (M.B {transfer, ...}) => case transfer
                                  of Mil.TCase {on, cases, default} => getBoolTargets cases
                                   | _ => NONE


  end

  structure CodeBody =
  struct

    type t = Mil.codeBody

    fun entry  (M.CB {entry,  ...}) = entry
    fun blocks (M.CB {blocks, ...}) = blocks

    fun numBlocks cb = LD.size (blocks cb)
    fun labels cb = LS.fromList (LD.domain (blocks cb))

    fun block (cb, l) =
        case LD.lookup (blocks cb, l)
         of NONE => Fail.fail ("MilUtils.CodeBody", "block", "label " ^ (I.labelString l) ^ " not in code body")
          | SOME b => b

    fun isCore cb = LD.forall (blocks cb, fn (_, b) => Block.isCore b)

    val compare = Compare.codeBody
    val eq = Eq.codeBody

    fun listAny cb = LD.toList (blocks cb)

    fun listRPO (config, cb) =
        let
          val seen = ref LS.empty
          fun visited i = LS.member (!seen, i)
          fun see i = seen := LS.insert (!seen, i)
          fun finish i = 
              let
                val () = Fail.assert ("MilUtils.CodeBody", "listRPO", "Double visited a block",
                                      (fn () => not (visited i)))
              in see i
              end
          fun checkFinished (i, _, acc) = 
              if visited i then
                acc
              else 
                let
                  val msg = "Unreachable node " ^ I.labelString i ^ " in listRPO: appending"
                  val () = Chat.warn1 (config, msg)
                  val acc = (i, block (cb, i))::acc
                in acc
                end
          fun list (i, acc) = 
              if (visited i) then
                acc
              else
                let
                  val () = finish i
                in
                  case LD.lookup (blocks cb, i)
                   of NONE =>
                      let
                        val msg = "Reference to non-existent block " ^ I.labelString i ^ " in listRPO: ignoring"
                        val () = Chat.warn1 (config, msg)
                      in acc
                      end
                    | SOME b =>
                      let
                        val {blocks = ls, ...} = Block.successors b
                        val res = LS.fold (ls, (i, b)::acc, list)
                      in res
                      end
                end
          val rbids = list (entry cb, [])
          val rbids = LD.fold (blocks cb, rbids, checkFinished)
          val lbs = List.rev rbids
        in lbs
        end

    fun dfsTrees cb =
        let
          val seen = ref LS.empty
          fun visited i = LS.member (!seen, i)
          fun see i = seen := LS.insert (!seen, i)
          fun build i = 
              if visited i then
                NONE
              else
                let
                  val b = block (cb, i)
                  val () = see i
                  val {blocks = ls, ...} = Block.successors b
                  val children = Vector.keepAllMap (LS.toVector ls, build)
                  val t = Tree.T ((i, b), children)
                in SOME t
                end
          val t = build (entry cb)
          fun extras (i, _, acc) = if visited i then acc else (build i)::acc
          val ts = LD.fold (blocks cb, [], extras)
          val ts = List.keepAllMap (t::ts, fn a => a)
          val ts = Vector.fromList ts
        in ts
        end

  end

  structure Code =
  struct

    type t = Mil.code

    val ((setFx, fx),
         (setEscapes, escapes),
         (setRecursive, recursive),
         (setCc, cc),
         (setArgs, args),
         (setRtyps, rtyps),
         (setBody, body)) = 
        let
          val pFr = fn (M.F {fx, escapes, recursive, cc, args, rtyps, body}) =>
                       (fx, escapes, recursive, cc, args, rtyps, body)
          val rFp = fn (fx, escapes, recursive, cc, args, rtyps, body) =>
                       M.F {fx = fx, escapes = escapes, recursive = recursive, 
                            cc = cc, args = args, rtyps = rtyps, body = body}
        in FunctionalUpdate.mk7 (pFr, rFp)
        end

    fun numArgs f = Vector.length (args f)
    fun arg (f, idx) = Vector.sub (args f, idx)

    fun numRtyps f = Vector.length (rtyps f)
    fun rtyp (f, idx) = Vector.sub (rtyps f, idx)

    fun thunkTyp f =
        let
          val rtyps = rtyps f
        in
          case Vector.length rtyps
           of 1 => Vector.sub (rtyps, 0)
            | _ => Fail.fail ("MilUtils.Code", "thunkTyp",
                              "CcThunk code should have 1 return")
        end

    fun entry      f       = CodeBody.entry     (body f     )
    fun blocks     f       = CodeBody.blocks    (body f     )
    fun numBlocks  f       = CodeBody.numBlocks (body f     )
    fun labels     f       = CodeBody.labels    (body f     )
    fun block     (f, idx) = CodeBody.block     (body f, idx)

    fun isCore f = CodeBody.isCore (body f)

    val compare = Compare.code
    val eq = Eq.code

  end

  structure Global =
  struct

    type t = Mil.global

    fun isCore g =
        case g
         of M.GCode f       => Code.isCore f
          | M.GErrorVal _   => true
          | M.GIdx _        => true
          | M.GTuple _      => true
          | M.GRat _        => true
          | M.GInteger _    => true
          | M.GCString _    => true
          | M.GThunkValue _ => true
          | M.GSimple _     => false
          | M.GClosure _    => false
          | M.GPSum _       => false
          | M.GPSet _       => false

    val compare = Compare.global
  
    val eq = Eq.global
             
    val pObjKind =
     fn g => 
        (case g
          of M.GCode f              => NONE
           | M.GErrorVal _          => NONE
           | M.GIdx _               => NONE
           | M.GTuple {mdDesc, ...} => SOME (MetaDataDescriptor.pok mdDesc)
           | M.GRat _               => NONE
           | M.GInteger _           => NONE
           | M.GCString _           => NONE
           | M.GThunkValue _        => SOME M.PokCell 
           | M.GSimple s            => Simple.pObjKind s
           | M.GClosure _           => SOME M.PokFunction
           | M.GPSum _              => SOME M.PokTagged
           | M.GPSet _              => SOME M.PokOptionSet)


    val immutable =
     fn g =>
        (case g
          of M.GCode f              => true
           | M.GErrorVal _          => true
           | M.GIdx _               => true
           | M.GTuple {mdDesc, ...} => MetaDataDescriptor.immutable mdDesc
           | M.GRat _               => true
           | M.GInteger _           => true
           | M.GCString _           => false
           | M.GThunkValue _        => true
           | M.GSimple s            => true
           | M.GClosure _           => true
           | M.GPSum _              => true
           | M.GPSet _              => true)

    structure O = struct type t = t val compare = compare end
    structure Dict = DictF(O)

    structure Dec =
    struct
      val gCode =
       fn g => (case g of M.GCode r => SOME r | _ => NONE)
      val gErrorVal = 
       fn g => (case g of M.GErrorVal r => SOME r | _ => NONE)
      val gIdx =
       fn g => (case g of M.GIdx r => SOME r | _ => NONE)
      val gTuple =
       fn g => (case g of M.GTuple r => SOME r | _ => NONE)
      val gRat =
       fn g => (case g of M.GRat r => SOME r | _ => NONE)
      val gInteger =
       fn g => (case g of M.GInteger r => SOME r | _ => NONE)
      val gCString =
       fn g => (case g of M.GCString r => SOME r | _ => NONE)
      val gThunkValue =
       fn g => (case g of M.GThunkValue r => SOME r | _ => NONE)
      val gSimple =
       fn g => (case g of M.GSimple r => SOME r | _ => NONE)
      val gClosure =
       fn g => (case g of M.GClosure r => SOME r | _ => NONE)
      val gPSum =
       fn g => (case g of M.GPSum r => SOME r | _ => NONE)
      val gPSet =
       fn g => (case g of M.GPSet r => SOME r | _ => NONE)
    end (* structure Dec *)

  end

  structure Globals =
  struct

    type t = Mil.globals

    fun num gs  = VD.size gs
    fun vars gs = VS.fromList (VD.domain gs)
    fun get (gs, v) =
        case VD.lookup (gs, v)
         of NONE => Fail.fail ("MilUtils.Globals", "get",
                               "variable " ^ (I.variableString' v) ^
                               " not in globals")
          | SOME g => g

  end

  structure IncludeKind =
  struct

    type t = Mil.includeKind

    fun fromString s = case s of "C" => SOME M.IkC | "Target" => SOME M.IkTarget | _ => NONE

    fun toString ik = case ik of M.IkC => "C" | M.IkTarget => "Target"

  end

  structure IncludeFile =
  struct

    type t = Mil.includeFile

    fun name    (M.IF {name,    ...}) = name
    fun kind    (M.IF {kind,    ...}) = kind
    fun externs (M.IF {externs, ...}) = externs

  end

  structure VariableKind =
  struct

    type t = Mil.variableKind

    fun toChar vk = case vk of M.VkExtern => #"e" | M.VkGlobal => #"g" | M.VkLocal => #"l"

    fun toString vk = case vk of M.VkExtern => "Extern" | M.VkGlobal => "Global" | M.VkLocal => "Local"

  end

  structure VariableInfo =
  struct

    type t = Mil.variableInfo

    fun typ  (M.VI {typ,  ...}) = typ
    fun kind (M.VI {kind, ...}) = kind

  end

  structure SymbolTable =
  struct

    type t = Mil.symbolTable

    fun variableInfo (symtab, v) = I.variableInfo (symtab, v)

    fun variableTyp (symtab, v) = VariableInfo.typ (variableInfo (symtab, v))

    fun variableKind (symtab, v) = VariableInfo.kind (variableInfo (symtab, v))

  end

  structure SymbolTableManager =
  struct

    type t = Mil.symbolTableManager

    fun variableInfo (stm, v) = IM.variableInfo (stm, v)

    fun variableTyp  (stm, v) = VariableInfo.typ  (variableInfo (stm, v))
    fun variableKind (stm, v) = VariableInfo.kind (variableInfo (stm, v))

    fun variableFresh (stm, hint, t, k) =
        IM.variableFresh (stm, hint, M.VI {typ = t, kind = k})

    fun variableFreshNoInfo (stm, hint) =
        IM.variableFreshNoInfo (stm, hint)

    fun variableClone (stm, v) = IM.variableClone (stm, v)

    fun variableRelated (stm, v, hint, t, k) =
        IM.variableRelated (stm, v, hint, M.VI {typ = t, kind = k})

    fun variableRelatedNoInfo (stm, v, hint) =
        IM.variableRelatedNoInfo (stm, v, hint)

    fun variableHasInfo (stm, v) =
        IM.variableHasInfo (stm, v)

    fun variableSetInfo (stm, v, info) =
        IM.variableSetInfo (stm, v, info)

    fun nameMake (stm, s) = IM.nameMake (stm, s)

    fun labelFresh stm = IM.labelFresh stm

    fun finish stm = IM.finish stm

  end

  structure SymbolInfo =
  struct

    type t = Mil.symbolInfo

    val variableExists = SI.variableExists

    fun variableInfo          (si, v) = SI.variableInfo          (si, v)
    fun variableName          (si, v) = SI.variableName          (si, v)
    fun variableNameEscaped   (si, v) = SI.variableNameEscaped   (si, v)
    fun variableString        (si, v) = SI.variableString        (si, v)
    fun variableStringEscaped (si, v) = SI.variableStringEscaped (si, v)

    fun variableTyp  (si, v) = VariableInfo.typ  (variableInfo (si, v))
    fun variableKind (si, v) = VariableInfo.kind (variableInfo (si, v))

    fun nameString        (si, n) = SI.nameString        (si, n)
    fun nameStringEscaped (si, n) = SI.nameStringEscaped (si, n)

    fun layoutVariable        (si, v) = SI.layoutVariable        (v, si)
    fun layoutVariableEscaped (si, v) = SI.layoutVariableEscaped (v, si)
    fun layoutName            (si, n) = SI.layoutName            (n, si)
    fun layoutNameEscaped     (si, n) = SI.layoutNameEscaped     (n, si)
    fun layoutLabel           (si, l) = SI.layoutLabel           (l, si)

  end

  structure Program =
  struct

    type t = Mil.t

    fun includes    (M.P {includes,    ...}) = includes
    fun externs     (M.P {externs,     ...}) = externs
    fun globals     (M.P {globals,     ...}) = globals
    fun symbolTable (M.P {symbolTable, ...}) = symbolTable
    fun entry       (M.P {entry,       ...}) = entry

    fun incl (p, i) = Vector.sub (includes p, i)

    fun externVars p = Vector.fold (includes p, externs p, fn (i, evs) => VS.union (IncludeFile.externs i, evs))

    fun numGlobals  p     = Globals.num  (globals p   )
    fun globalVars  p     = Globals.vars (globals p   )
    fun global     (p, v) = Globals.get  (globals p, v)

  end

  structure Uintp = Intp(val sgn = IntArb.Unsigned
                         val ptrSize = FieldSize.ptrSize)
  structure Sintp = Intp(val sgn = IntArb.Signed
                         val ptrSize = FieldSize.ptrSize)

  structure Bool =
  struct

    fun t config = Uintp.t config

    fun T config = Uintp.one config

    fun F config = Uintp.zero config

    fun fromBool (config, b) = if b then T config else F config

    fun toBool (config, c) = 
        if Constant.eq (c, T config) then 
          SOME true
        else if Constant.eq (c, F config) then
          SOME false
        else
          NONE

    fun ifS (c, opnd, {trueT, falseT}) =
        Switch.noDefault (opnd, Vector.new2 ((T c, trueT), (F c, falseT)))

    fun ifT (c, opnd, x) = M.TCase (ifS (c, opnd, x))

  end

  structure Boxed =
  struct

    fun t (pok, ofTyp) = Typ.fixedArray (pok, Vector.new1 (ofTyp, M.FvReadOnly))

    fun td fk =
        let
          val fd = M.FD {kind = fk, var = M.FvReadOnly}
        in
          M.TD {fixed = Vector.new1 fd, array = NONE}
        end

    fun mdd (c, pok, fk) =
        let
          val fd = M.FD {kind = fk, var = M.FvReadOnly}
        in
          M.MDD {pok = pok, fixed = Vector.new1 fd, array = NONE}
        end

    fun box (c, pok, fk, opnd) =
        M.RhsTuple {mdDesc = mdd (c, pok, fk), inits = Vector.new1 opnd}

    fun boxGlobal (c, pok, fk, s) =
        M.GTuple {mdDesc = mdd (c, pok, fk), inits = Vector.new1 s}

    val ofValIndex = 0

    fun unbox (c, fk, v) =
        M.RhsTupleSub (M.TF {tupDesc = td fk,
                             tup = v,
                             field = M.FiFixed ofValIndex})

  end

  structure Tuple =
  struct

    fun typ (pok, tvs) = Typ.fixedArray (pok, tvs)

    val td =
     fn fds => M.TD {fixed = fds, array = NONE}

    val mdd = 
     fn (pok, fds) => M.MDD {pok = pok, fixed = fds, array = NONE}

    val mddImmutable = 
     fn fks => mdd (M.PokNone, Vector.map (fks, fn fk => M.FD {kind = fk, var = M.FvReadOnly}))
    val mddImmutableTyps = 
     fn (config, typs) => mddImmutable (Vector.map (typs, fn t => FieldKind.fromTyp (config, t)))
    val mddImmutableRefs = 
     fn i => mddImmutable (Vector.new (i, M.FkRef))
    val mddImmutableBits = 
     fn (i, fs) => mddImmutable (Vector.new (i, M.FkBits fs))

    val tdImmutable = MetaDataDescriptor.toTupleDescriptor o mddImmutable
    val tdImmutableRefs = MetaDataDescriptor.toTupleDescriptor o mddImmutableRefs
    val tdImmutableBits = MetaDataDescriptor.toTupleDescriptor o mddImmutableBits

    val new = 
     fn (vt, inits) => M.RhsTuple {mdDesc = vt, inits = inits}

    val proj = 
     fn (td, arr, idx) =>
        M.RhsTupleSub (M.TF {tupDesc = td,
                             tup = arr,
                             field = M.FiFixed idx})

    val init = 
     fn (td, arr, idx, ofVal) =>
        M.RhsTupleSet {tupField = M.TF {tupDesc = td,
                                        tup = arr,
                                        field = M.FiFixed idx},
                       ofVal = ofVal}
        
    val inited = 
     fn (vt, arr) =>
        M.RhsTupleInited {mdDesc = vt, tup = arr}

  end (* structure Tuple *)

  (* This defines an abstraction of variable length arrays in MIL.  
   * These arrays always have length fields (even if created via
   * the newFixed constructor *)
  structure OrdinalArray =
  struct

    fun fixedTyp (c, pok, ts) =
        let
          fun addVar t = (t, M.FvReadOnly)
          val tvs = Vector.map (Utils.Vector.cons (Uintp.t c, ts), addVar)
        in
          Typ.fixedArray (pok, tvs)
        end

    fun varTyp (c, pok, t) =
        M.TTuple {pok = pok, fixed = Vector.new1 (Uintp.t c, M.FvReadOnly), array = (t, M.FvReadOnly)}

    datatype typ = TNot | TFixed of Typ.t Vector.t | TVar of Typ.t

    fun isTyp (c, t) =
        let
          fun checkLen tvs =
              Vector.length tvs >= 1 andalso
              (case Vector.sub (tvs, 0)
                of (t, M.FvReadOnly) => Compare.typ (t, Uintp.t c) = EQUAL
                 | _ => false)
          fun checkRO tvs = Vector.forall (tvs, FieldVariance.immutable o #2)
          fun stripLen tvs = Vector.map (Vector.dropPrefix (tvs, 1), #1)
        in
          case t
           of M.TTuple {pok, fixed, array = (M.TNone, _)} =>
              if checkLen fixed andalso checkRO fixed
              then TFixed (stripLen fixed)
              else TNot
            | M.TTuple {pok, fixed, array = (t, M.FvReadOnly)} =>
              if checkLen fixed andalso Vector.length fixed = 1
              then TVar t
              else TNot
            | _ => TNot
        end
            
    fun tdFixed (c, fks) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          fun doOne fk = M.FD {kind = fk, var = M.FvReadOnly}
          val fks = Utils.Vector.cons (lenFd, Vector.map (fks, doOne))
        in
          M.TD {fixed = fks, array = NONE}
        end

    fun tdVar (c, fk) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          val eltFd = M.FD {kind = fk, var = M.FvReadOnly}
        in
          M.TD {fixed = Vector.new1 lenFd, array = SOME eltFd}
        end

    fun mddFixed (c, pok, fks) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          fun doOne fk = M.FD {kind = fk, var = M.FvReadOnly}
          val fks = Utils.Vector.cons (lenFd, Vector.map (fks, doOne))
        in
          M.MDD {pok = pok, fixed = fks, array = NONE}
        end

    val lenIndex = 0

    fun mddVar (c, pok, fk) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          val eltFd = M.FD {kind = fk, var = M.FvReadOnly}
          val f = Vector.new1 lenFd
          val a = SOME (lenIndex, eltFd)
        in M.MDD {pok = pok, fixed = f, array = a}
        end

    fun newFixed (c, pok, fks, os) =
        let
          val mdd = mddFixed (c, pok, fks)
          val inits =
              Utils.Vector.cons (M.SConstant (Uintp.int (c, Vector.length fks)), os)
          val rhs = M.RhsTuple {mdDesc = mdd, inits = inits}
        in rhs
        end

    fun newVar (c, pok, fk, len) =
        M.RhsTuple {mdDesc = mddVar (c, pok, fk), inits = Vector.new1 len}

    fun length (c, arr) =
        M.RhsTupleSub (M.TF {tupDesc = tdFixed (c, Vector.new0()),
                             tup = arr,
                             field = M.FiFixed lenIndex})

    fun sub (c, fk, arr, idx) =
        M.RhsTupleSub (M.TF {tupDesc = tdVar (c, fk),
                             tup = arr,
                             field = M.FiVariable idx})

    fun update (c, fk, arr, idx, ofVal) =
        M.RhsTupleSet {tupField = M.TF {tupDesc = tdVar (c, fk),
                                        tup = arr,
                                        field = M.FiVariable idx},
                       ofVal = ofVal}

    fun inited (c, pok, fk, arr) =
        M.RhsTupleInited {mdDesc = mddVar (c, pok, fk), tup = arr}

  end

  structure IndexedArray =
  struct

    fun fixedTyp (c, pok, d, ts) =
        let
          val f = Vector.concat [Vector.new2 (Uintp.t c, M.TIdx), ts]
          val f = Vector.map (f, fn t => (t, M.FvReadOnly))
        in
          Typ.fixedArray (pok, f)
        end

    fun varTyp (c, pok, t) =
        M.TTuple {pok = pok,
                  fixed = Vector.new2 ((Uintp.t c, M.FvReadOnly), (M.TIdx, M.FvReadOnly)),
                  array = (t, M.FvReadOnly)}

    fun tdFixed (c, fks) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          val idxFd = M.FD {kind = M.FkRef, var = M.FvReadOnly}
          fun doOne fk = M.FD {kind = fk, var = M.FvReadOnly}
          val fks = Vector.concat [Vector.new2 (lenFd, idxFd), Vector.map (fks, doOne)]
        in
          M.TD {fixed = fks, array = NONE}
        end

    fun tdVar (c, fk) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          val idxFd = M.FD {kind = M.FkRef, var = M.FvReadOnly}
          val eltFd = M.FD {kind = fk, var = M.FvReadOnly}
        in
          M.TD {fixed = Vector.new2 (lenFd, idxFd), array = SOME eltFd}
        end

    fun mddFixed (c, pok, fks) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          val idxFd = M.FD {kind = M.FkRef, var = M.FvReadOnly}
          fun doOne fk = M.FD {kind = fk, var = M.FvReadOnly}
          val fks = Vector.concat [Vector.new2 (lenFd, idxFd), Vector.map (fks, doOne)]
        in
          M.MDD {pok = pok, fixed = fks, array = NONE}
        end

    val lenIndex = 0
    val idxIndex = 1

    fun mddVar (c, pok, fk) =
        let
          val lenFd = M.FD {kind = Uintp.fieldKind c, var = M.FvReadOnly}
          val idxFd = M.FD {kind = M.FkRef, var = M.FvReadOnly}
          val eltFd = M.FD {kind = fk, var = M.FvReadOnly}
        in
          M.MDD {pok = pok, fixed = Vector.new2 (lenFd, idxFd), array = SOME (lenIndex, eltFd)}
        end

    fun newFixed (c, pok, d, fks, idxVar, os) =
        let
          val mdd = mddFixed (c, pok, fks)
          val leni = M.SConstant (Uintp.int (c, Vector.length fks))
          val inits =
              Vector.concat [Vector.new2 (leni, M.SVariable idxVar), os]
          val rhs = M.RhsTuple {mdDesc = mdd, inits = inits}
        in rhs
        end

    fun length (c, arr) =
        M.RhsTupleSub (M.TF {tupDesc = tdFixed (c, Vector.new0()),
                             tup = arr,
                             field = M.FiFixed lenIndex})

    fun index (c, fk, arr) =
        M.RhsTupleSub (M.TF {tupDesc = tdVar (c, fk),
                             tup = arr,
                             field = M.FiFixed idxIndex})

    fun idxSub (c, fk, arr, idx) =
        M.RhsTupleSub (M.TF {tupDesc = tdVar (c, fk),
                             tup = arr,
                             field = M.FiVariable idx})

  end

  structure Integer =
  struct

    val t = Prims.NumericTyp.tIntegerArbitrary
    val nt = MP.NtInteger MP.IpArbitrary
    val from =
     fn (nt', p) => M.RhsPrim {prim = MP.Prim (MP.PNumConvert {from = nt', to = nt}),
                               createThunks = false,
                               typs = Vector.new0 (),
                               args = Vector.new1 p}

    val fromIntegral = 
        fn (iat, p) => from (MP.NtInteger (MP.IpFixed iat), p)

    val fromUintp = 
        fn (config, p) => fromIntegral (Uintp.intArbTyp config, p)

    val fromSintp = 
        fn (config, p) => fromIntegral (Sintp.intArbTyp config, p)

    structure Opt = 
    struct
      val max = IntInf.- (IntInf.<< (IntInf.one, 0w30), IntInf.one)
      val min = IntInf.~ (IntInf.<< (IntInf.one, 0w30))
      val integerFits = 
       fn i => IntInf.>= (i, min) andalso IntInf.<= (i, max) 
      val rationalFits = 
       fn r => 
          (case Rat.toIntInf r
            of SOME i => integerFits i
             | NONE => false)
      val fromInteger = 
       fn i => if integerFits i then SOME (M.CInteger i) else NONE
      val fromRational = 
       fn r => Utils.Option.bind (Rat.toIntInf r, fromInteger)

    end (* structure Opt *)

  end (* structure Integer *)

  structure Rational =
  struct

    structure MP = Mil.Prims

    val t = Prims.NumericTyp.tRat
    val nt = MP.NtRat

    val from =
     fn (nt', p) => M.RhsPrim {prim = MP.Prim (MP.PNumConvert {from = nt', to = nt}),
                               createThunks = false,
                               typs = Vector.new0 (),
                               args = Vector.new1 p}

    val fromIntegral = 
        fn (iat, p) => from (MP.NtInteger (MP.IpFixed iat), p)

    val fromUintp = 
        fn (config, p) => fromIntegral (Uintp.intArbTyp config, p)

    val fromSintp = 
        fn (config, p) => fromIntegral (Sintp.intArbTyp config, p)

    structure Opt = 
    struct
      val max = Integer.Opt.max
      val min = Integer.Opt.min
      val integerFits = Integer.Opt.integerFits
      val rationalFits = Integer.Opt.rationalFits
      val fromInteger = 
       fn i => if integerFits i then SOME (M.CRat i) else NONE
      val fromRational = 
       fn r => Utils.Option.bind (Rat.toIntInf r, fromInteger)
    end (* structure Opt *)

  end (* structure Rational *)

  structure Def =
  struct

    datatype t = 
             DefGlobal of Mil.global
           | DefRhs of Mil.rhs

    structure Out =
    struct
      val tuple =
       fn d => 
          (case d 
            of DefGlobal (M.GTuple r) => SOME r
             | DefRhs (M.RhsTuple r) => SOME r
             | _ => NONE)
      val thunkValue =
       fn d => 
          (case d
            of DefGlobal (M.GThunkValue r) => SOME r
             | DefRhs (M.RhsThunkValue {typ, thunk, ofVal}) => SOME {typ = typ, ofVal = ofVal}
             | _ => NONE)
      val simple = 
       fn d => 
          (case d
            of DefGlobal (M.GSimple s) => SOME s
             | DefRhs (M.RhsSimple s) => SOME s
             | _ => NONE)
      val pFunction =
       fn d =>
          (case d
            of DefGlobal (M.GClosure r) => SOME r
             | DefRhs (M.RhsClosureInit {cls, code, fvs}) => SOME {code = code, fvs = fvs}
             | _ => NONE)
      val pSum =
       fn d =>
          (case d
            of DefGlobal (M.GPSum r) => SOME r
             | DefRhs (M.RhsPSum r) => SOME r
             | _ => NONE)
      val pSet =
       fn d =>
          (case d
            of DefGlobal (M.GPSet op1) => SOME op1
             | DefRhs (M.RhsPSetNew op1) => SOME op1
             | _ => NONE)

    end (* structure Out *)
  end (* structure Def *)

  structure Id =
  struct

    datatype t = 
             L of Mil.label    (* block label *)
           | I of int          (* numbered instruction *)
           | T of Mil.label    (* block transfer *)
           | G of Mil.variable (* global *)

    val compare = 
     fn (id1, id2) => 
        (case (id1, id2)
          of (L l1, L l2) => Compare.label (l1, l2)
           | (L _, _) => GREATER
           | (_, L _) => LESS
           | (I i1, I i2) => Int.compare (i1, i2)
           | (I _, _) => GREATER
           | (_, I _) => LESS
           | (T l1, T l2) => Compare.label (l1, l2)
           | (T _, _) => GREATER
           | (_, T _) => LESS
           | (G v1, G v2) => Compare.variable (v1, v2))

    val eq = Equality.fromCompare compare

    structure L = Layout

    val layout = 
        fn (si, id) => 
           (case id
             of L l => L.seq [L.str "L_",SymbolInfo.layoutLabel (si, l)]
              | I i => L.seq [L.str "I_",Int.layout i]
              | T l => L.seq [L.str "T_",SymbolInfo.layoutLabel (si, l)]
              | G v => L.seq [L.str "G_",SymbolInfo.layoutVariable (si, v)])

    structure Ord =
    struct
      type t = t
      val compare = compare
    end

    structure Set = SetF (Ord)
    structure Dict = DictF (Ord)
    structure ImpDict = DictImpF (Ord)

  end (* structure Id *)

  structure FlatTyp =
  struct

    (* Flat typs are the nullary super-types of the general types *)
    val fromTyp =
     fn (config, t) => 
        (case t
          of M.TAny                       => t
           | M.TAnyS vs                   => t
           | M.TNonRefPtr                 => t
           | M.TRef                       => t
           | M.TBits vs                   => t
           | M.TNone                      => t
           | M.TNumeric _                 => t
           | M.TBoolean                   => t
           | M.TName                      => t
           | M.TViVector et               => M.TBits (PrimsUtils.VectorSize.toValueSize (#vectorSize et))
           | M.TViMask et                 => M.TAny
           | M.TCode {cc, args, ress}     => M.TBits (ValueSize.ptrSize config)
           | M.TTuple {pok, fixed, array} => (case pok of M.PokNone => M.TRef | _ => M.TPAny)
           | M.TCString                   => t
           | M.TIdx                       => M.TRef
           | M.TContinuation ts           => M.TBits (ValueSize.ptrSize config)
           | M.TThunk t                   => M.TRef
           | M.TPAny                      => M.TPAny
           | M.TClosure {args, ress}      => M.TPAny
           | M.TPSum nts                  => M.TPAny
           | M.TPType {kind, over}        => M.TPAny
           | M.TPRef t                    => M.TPAny)

  end (* structure FlatTyp *)

  (* Compiler assumptions about pointers into the heap *)
  structure HeapModel =
  struct
    val null : Config.t -> IntInf.t = fn c => 0
    val isNull : Config.t * IntInf.t -> bool = fn (c, i) => i = 0
    val lowBitsSet : Config.t * IntInf.t -> bool = fn (c, i) => IntInf.andb (i, 3) <> 0
    val validRefConstant : Config.t * IntInf.t -> bool = 
     fn (config, i) => isNull (config, i) orelse lowBitsSet (config, i)
  end (* structure HeapModel *)
              
end
