#!/usr/bin/ruby
### mysym2.rb
module Mysym
### instruction types
Op_nul		= 0
Op_lit		= 1
Op_opr		= 2
Op_lod		= 3
Op_sto		= 4
Op_cal		= 5
Op_inc		= 6
Op_jmp		= 7
Op_jpc		= 8
Op_wrt		= 9
Op_stp		= 10
Op_lid		= 11
Op_lda		= 12
Op_sid		= 13
Op_stx		= 14
Op_sty		= 15
Op_ldx		= 16
Op_ssy		= 17
Op_siz		= 18
Op_liz		= 19

### arithmetic operation types
Opr_ret		= 0
Opr_neg		= 1
Opr_add		= 2
Opr_sub		= 3
Opr_mul		= 4
Opr_div		= 5
Opr_odd		= 6
Opr_inc		= 7		### n++ or inc(n)
Opr_eql		= 8
Opr_neq		= 9
Opr_lss		= 10
Opr_leq		= 11
Opr_gtr		= 12
Opr_geq		= 13
Opr_rtn		= 14


Sym_nul 			= 0
Sym_amper			= 1
Sym_bakslash		= 2
Sym_bang			= 3
Sym_becomes			= 4
Sym_begin			= 5
Sym_bitwise_or		= 6	### " | "
Sym_bitwise_xor		= 7	### " ^ "
Sym_break			= 8
Sym_call			= 9
Sym_colon			= 10
Sym_comma			= 11	### ,
Sym_const			= 12
Sym_continue		= 13
Sym_do				= 14
Sym_else			= 15
Sym_end				= 16
Sym_eql				= 17
Sym_for				= 18
Sym_geq				= 19
Sym_goto			= 20
Sym_gtr 			= 21
Sym_ident			= 22
Sym_if				= 23
Sym_in				= 24
Sym_label			= 25
Sym_lbrace			= 26
Sym_lcurl			= 27
Sym_lf				= 28
Sym_leq				= 29
Sym_lparen			= 30
Sym_lss				= 31
Sym_minus			= 32
Sym_modulo			= 33
Sym_mult			= 34
Sym_neq				= 35
Sym_not				= 36
Sym_null			= 37
Sym_number			= 38
Sym_odd				= 39
Sym_period			= 40
Sym_plus			= 41
Sym_pound			= 42
Sym_procedure		= 43
Sym_question		= 44
Sym_rbrace			= 45
Sym_rcurl			= 46
Sym_record			= 47
Sym_return			= 48
Sym_rparen			= 49
Sym_semicolon		= 50
Sym_slash			= 51
Sym_space			= 52
Sym_static			= 53
Sym_then			= 54
Sym_var				= 55
Sym_while			= 56
Sym_write			= 57

end
