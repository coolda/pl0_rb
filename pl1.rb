#!/usr/bin/ruby
### pl1.rb
load("error.rb")
require 'mysym2'
include Mysym

### kind would be
Kind_const		= 1
Kind_var		= 2
Kind_static		= 3
Kind_array		= 4
Kind_string		= 5
Kind_label		= 6
Kind_procedure	= 7
Kind_var_loco	= 8
Kind_const_loco = 9


=begin
$alfa = /[A-Za-z_]/
$white = /[ \t]/		### 0x20 || 0x9
$digit = /[\d]/
$minus = /-/
$period = /./
=end

def is_white(c)
	return /[ \t]/ === c.chr
end

def is_alpha(c)
	return /[A-Za-z_]/ === c.chr
end

def is_minus(c)
	return /-/ === c.chr
end

def is_digit(c)
	return /[\d]/ === c.chr
end

def is_alnum(c)
	return is_alpha(c) || is_digit(c)
end

def is_period(c)
	return /\./ === c.chr
end

def is_digidot(c)
	return is_digit(c) || is_period(c)
end

def is_digidotminus(c)
	return is_digit(c) || is_period(c) || is_minus(c)
end

def is_slash(c)
	return /\// === c.chr
end

def is_colon(c)
	return /:/ === c.chr
end

def is_eql(c)
	return /=/ === c.chr
end

def is_lf(c)
	return /\n/ === c.chr
end

def is_pound(c)
	return /#/ === c.chr
end

@symname = %w[  Sym_nul Sym_amper Sym_bakslash Sym_bang
				Sym_becomes Sym_begin Sym_bitwise_or Sym_bitwise_xor
				Sym_break Sym_call Sym_colon Sym_comma
				Sym_const Sym_continue Sym_do Sym_else
				Sym_end Sym_eql Sym_for Sym_geq
				Sym_goto Sym_gtr Sym_ident Sym_if
				Sym_in Sym_label Sym_lbrace Sym_lcurl 
				Sym_lf Sym_leq Sym_lparen Sym_lss
				Sym_minus Sym_modulo Sym_mult Sym_neq
				Sym_not	Sym_null Sym_number Sym_odd 
				Sym_period Sym_plus Sym_pound Sym_procedure
				Sym_question Sym_rbrace Sym_rcurl Sym_record
				Sym_return Sym_rparen Sym_semicolon Sym_slash
				Sym_space Sym_static Sym_then Sym_var
				Sym_while Sym_write ]

### using Hash
### h = {"apple"=>150, "banana"=>300, "lemon"=>300}
### p h['apple'] returns nil if not 

@rsvd = {"null"=>37, "begin"=>5, "break"=>8, "call"=>9,
		"const"=>12, "continue"=>13, "do"=>14, "else"=>15,
		"end"=>16, "for"=>18, "goto"=>20, "if"=>23,
		"in"=>24, "label"=>25, "procedure"=>43, "record"=>47, 
		"return"=>48, "static"=>53, "then"=>54, "var"=>55,
		"while"=>56, "write"=>57 }

@ssym = []
@ssym[10] 	=	Sym_lf			### 28	0xa	 10
@ssym[32]	=	Sym_space		### 52	0x20 32
@ssym[33]	=	Sym_bang		###	3 	0x21 33 !
@ssym[35]	=	Sym_pound		### 42	0x23 35 #
@ssym[37]	=	Sym_modulo		### 33	0x25 37 %
@ssym[38]	=	Sym_amper		###	1	0x26 38 &
@ssym[40]	= 	Sym_lparen		### 30	0x28 40 (
@ssym[41]	= 	Sym_rparen		### 49	0x29 41 )
@ssym[42]	=	Sym_mult		###	34	0x2a 42 *
@ssym[43]	=	Sym_plus		### 41	0x2b 43 +
@ssym[44]	=	Sym_comma		### 11	0x2c 44 ,
@ssym[45]	=	Sym_minus		### 32	0x2d 45 -
@ssym[46]	=	Sym_period		### 40	0x2e 46 .
@ssym[47]	=	Sym_slash		### 51	0x2f 47 /
@ssym[58]	=	Sym_colon 		### 10	0x3a 58 :
@ssym[59] 	= 	Sym_semicolon	### 50	0x3b 59 ;
@ssym[60]	=	Sym_lss			### 31	0x3c 60 <
@ssym[61]	= 	Sym_eql			### 17	0x3d 61 =
@ssym[62]	=	Sym_gtr			### 21	0x3e 62 >
@ssym[63]	=	Sym_question	### 44	0x3f 63 ?
@ssym[91]	=	Sym_lbrace		### 26	0x5b 91 [
@ssym[92]	=	Sym_bakslash	###	2	0x5c 92 \
@ssym[93]	=	Sym_rbrace		### 45	0x5d 93 ]
@ssym[94]	= 	Sym_bitwise_xor	### 7	0x5e 94 ^
@ssym[123]	= 	Sym_lcurl		### 27	0x7b 123 {
@ssym[124]	= 	Sym_bitwise_or	###	6	0x7c 124 |
@ssym[125]	= 	Sym_rcurl		### 46	0x7d 125 }
@ssym[126]	=	Sym_not			### 36	0x7e 126 ~


### null added
@keywd = %w[ null begin break call case const continue
	do else end for goto if jump procedure record 
	return static switch var while write ]


### n = keywd.index("enum")
### puts n
### will return nil if not exist
@ops = %w[ = *= /= %= += -= <<= >>= &= ^= |= ? : ||
			&& | ^ & == != < > <> <= >= << >> + -
			* / % ( ) ++ -- ~ ! [ ]
			. -> , ; { } #  \ ]

### for a code instruction print
### instruction names
@op_name =  %w[ nul lit opr lod sto cal inc jmp
				jpc wrt stp lid lda sid stx sty
				ldx ssy siz liz ]
### arithmetic opr names
@opr_name = %w[ ret neg add sub mul div odd inc
				eql neq lss leq gtr geq rtn ]
@fname = ''
@buf = ''		### code out to file 
@sdata = ''
@s_sz = 0
@look = ''
@peek1 = ''
@lk_cnt = 0
@cname = ''
@constname = nil
@cnum = ''
@fnumber = 0
@sym = 0
@code_arr = []
@cx = 0
@oldcx = 0
@table = []
@tx = 0
@addre = 4
$jmp_pos = 0
@level = 0
@inproc_flag = false

Code = Struct.new(:inst, :src, :dest)

def do_fileread
	if ARGV.length == 0 then
		puts "file name required!"
	end
	#puts ARGV	### array
	@fname = ARGV[0]
	f = open(@fname, "r")
	@sdata = f.read		### all the String data source code
	@s_sz = @sdata.length
	print "source_code size: ", @s_sz, "\n"
end

def emit(inst, src, dest)
	@code_arr[@cx] = Code.new(inst, src, dest)
	@cx += 1
end

def write_buf
	bufsz = @buf.size
	print "buf size", bufsz, "\n"
	outname = @fname + ".cod"
	file = File.open(outname, "w")
	file.write(@buf)
	file.close
end

def print_code
	print "code size: ", @cx, "\n"
	i = 0
	mysz = 0
	while i < @cx do
		n1 = @code_arr[i].inst
		n2 = @code_arr[i].src
		n3 = @code_arr[i].dest
		if n1 == Op_opr then
			n3 = @opr_name[n3]
		else
			n4 = Integer(n3)
			if n3 - n4 == 0 then
				n3 = n4
			end
		end
		print  i, "\t", @op_name[n1], " ", n2, ", ", n3, "\n"
		@buf << @op_name[n1]
		@buf << " "
		@buf << n2.to_s
		@buf << " "
		@buf << n3.to_s
		@buf << "\n"
		
		i += 1
	end
end


class Table_t
	def initialize
		@kind = 0
		@id = " "
		@lev = 0
		@adr = 0
		@value = 0
		@s = ""
		@pc = 0
	end
	attr_accessor :kind, :id, :lev, :adr, :value, :s, :pc
			
	def print_table
		printf("kind: %d\t", @kind)
		printf("id: %s\t", @id)
		printf("lev: %d\n", @lev)
		printf("address: %d\t", @adr)
		printf("value: %2.2f\t", @value)
		printf("string: %s\n", @s)
		printf("pc: %d\n", @pc)
	end
	
end

def set_table(k, name, val, str)
	p = Table_t.new
	p.kind = k
	p.id = name
	if k==Kind_const || k==Kind_label || k==Kind_procedure then
		p.adr = 0
	else
		p.adr = @addre
		@addre += 1
	end
	p.value = val
	p.s = str
	p.pc = @cx
	p.lev = @level
	@table.push(p)
	@tx += 1
end

def search(s)
	pos = 0
	@table.each do |p|
  		if p.id == s then
		  break
		else
			pos += 1
		end
	end

	if pos < @tx then
		return pos
	else
		return nil
	end
end

def dolook
	if @lk_cnt < @s_sz then
		@look = @sdata[@lk_cnt]
		@lk_cnt += 1
		if is_pound(@look) then
			puts "Sym_pound detected in dolook:"
			while @look != 10 do
				@look = @sdata[@lk_cnt]
				@lk_cnt += 1
			end
			dolook
		end
	else
		puts "No more look data"
		Process.exit
	end
end

def dopeek
	@peek1 = @sdata[@lk_cnt]
	return @peek1
end

def fixup(ci, adr)
### patch address into code array at specified code index
	@code_arr[ci].dest = adr
end

def match(sym_num, err_num)
	if @sym == sym_num then
		getsym
	else
		error(err_num)
	end
end

def match_delim			### see if sym is ';' or '\n'
	if @sym == Sym_semicolon then
		puts "semicolon detected:"
		getsym	### now we have Sym_lf here
		getsym 	### get rid Sym_lf
	elsif @sym == Sym_lf then
		puts "line feed detected:"
		getsym
	else
		error(6) 		### "Semicolon or line feed expected !"
	end
end

def constdecl
	print("cname in constdecl: ", @cname, "\n")
	print("symname in constdecl: ", @symname[@sym], "\n")
	### keep the const ident
	@constname = @cname
	getsym		
	if @sym == Sym_eql then
		getsym
	else
		error(3)
	end
	
	if @sym == Sym_number then	### set_table(k, name, val, str)
		if @inproc_flag then
			set_table(Kind_const_loco, @constname, @fnumber, "")
		else
			set_table(Kind_const, @constname, @fnumber, "")
		end
		@constname = ''
		getsym
	else
		error(2)			### "A number must follow after '=' !"
	end
end

def vardecl
#	match(Sym_ident, 4)		### "After 'var', follows an identifier!"
	puts @symname[@sym]
	print("cname in vardecl: ", @cname, "\n")
	if @inproc_flag then
		set_table(Kind_var_loco, @cname, 0, "")
	else
		set_table(Kind_var, @cname, 0, "")
	end
	getsym		### do not need this, goes strange if I put it
end

def constpart
	puts "constpart called"
	getsym
	constdecl
	print "what the sym when back from constdecl: ", @symname[@sym], "\n"
	while @sym == Sym_comma do
		getsym
		constdecl
	end
#	match_delim
	getsym
end

def varpart
	puts "varpart called"
	getsym
	vardecl
	print "sym when back from vardecl: ", @symname[@sym], "\n"
	while @sym == Sym_comma do
		getsym
		vardecl
	end
#	match_delim
	getsym
end

def procpart
	puts "procpart called"
	getsym
	if @sym == Sym_ident then
		set_table(Kind_procedure, @cname, @cx+1, "")
	else
		error(4)		### "After 'procedure', follows an identifier!"
	end
	print "sym in procpart: ", @symname[@sym], "\n"		### 22 ie Sym_ident
	getsym
	### @sym seems to have a ';' 
	### next will be in_proc_const, or var, or begin, 
	### set @inproc_flag
	### so, body of proc decl all should load
	### if lod from say main statement, flag is false, emit error
	@inproc_flag = true
	@level += 1
	block
	@level -= 1
	@inproc_flag = false
end

def getsym
	
	if !@cnum.empty? then
		@cnum = ''
	end
	if !@cname.empty? then
		@cname = ''
	end
#	if !@constname.empty? then
#		@constname = ''
#	end

	
	if is_white(@look) then
		while is_white(@look) do
			dolook
		end
	end
	
	if is_lf(@look) then
		dolook
	end
	
#	print "look at the top of getsym: ", @look, "\n"
	
	if is_alpha(@look) then
		while is_alnum(@look) do
			@cname << @look		### assin fixnum to charstr
			dolook
		end
		### see if it is in rsvd keywords
		n = @rsvd[@cname]
		if n != nil then
			printf("keyword of %d detected:\n", n)
			@sym = n
			puts @symname[n]
		else
			puts "identifier detected"
			@sym = Sym_ident
			puts @cname
		end
		
	elsif is_digit(@look) || is_minus(@look) then
		while is_digidotminus(@look) do
			@cnum << @look
			dolook
		end
		puts "number detected"
		@sym = Sym_number
		@fnumber = @cnum.to_f
#		printf("fnumber: %f\n", @fnumber)
			
	elsif is_colon(@look) then
		if is_eql(dopeek) then
			puts "Sym_becomes detected:"
			@sym = Sym_becomes
			dolook
			dolook
		end
		
	elsif is_period(@look) then
		puts "Sym_period detected:"
		@sym = Sym_period
#		Process.exit
	else
#		print "else_part of getsym: ", @look, "\n"
		@sym = @ssym[@look]
		printf("sym: %d\n", @sym)
		dolook
	end
end

def getkind(n)
	return @table[n].kind
end

def getlev(n)
	return @table[n].lev
end

def getadr(n)
	return @table[n].adr
end

def getvalue(n)
	return @table[n].value
end

def getpc(n)
	return @table[n].pc
end

def chek_error(symnumber, errnum)
	if !@sym==symnumber then
		error(errnum)
	end
end

def factor
	print "factor called sym is: ", @symname[@sym], "\n"
	i = 0
	k = 0
	if @sym == Sym_ident then
		i = search(@cname)
		if (i == nil) then
			error(11)
		end
		k = getkind(i)
		case k
			when Kind_procedure: error(21)
			when Kind_const: emit(Op_lit, 0, getvalue(i))
			when Kind_var: emit(Op_lod, (@level - getlev(i)), getadr(i))
			when Kind_const_loco
				if @inproc_flag then
					emit(Op_lit, 0, getvalue(i))
				else
					error(26)
				end
			when Kind_var_loco
				if @inproc_flag then
					emit(Op_lod, (@level - getlev(i)), getadr(i))
				else
					error(26)
				end
		end
		getsym
	elsif @sym == Sym_number then
		emit(Op_lit, 0, @fnumber)
		getsym
	elsif @sym == Sym_lparen then
		getsym
		expression
		match(Sym_rparen, 22)		### "Missing ')' !"
	else
		error(23)		### "This symbol cannot follow a factor !"
	end
end

def term
	symbol = 0
	factor
	print("sym after back from factor: ", @symname[@sym], "\n")
	while @sym == Sym_mult || @sym == Sym_slash do
		symbol = @sym
		getsym
		factor
		if symbol == Sym_mult then
			emit(Op_opr, 0, Opr_mul)
		else
			emit(Op_opr, 0, Opr_div)
		end
	end
end

def expression
	symbol = 0
	if @sym == Sym_plus || @sym == Sym_minus then
		symbol = @sym
		getsym
		term
		if symbol == Sym_minus then
			emit(Op_opr, 0, Opr_neg)
		end
	else
		term
	end
	
	while @sym == Sym_plus || @sym == Sym_minus do
		symbol = @sym
		getsym
		term
		print("symbol in expression: ", symbol, "\n")	### + == 40 - == 32
		if symbol == Sym_plus then 
			emit(Op_opr, 0, Opr_add)
		else 
			emit(Op_opr, 0, Opr_sub)
		end
	end
end

def chek_compari
	compari = [Sym_eql, Sym_geq, Sym_gtr, Sym_leq, Sym_lss, Sym_neq]
	n = compari.index(@sym)
	print "compari: ", n, "\n"
	if n == nil then
		error(20)		### "Comparison operator expected !"
	end
end

def condition
	print "condition called: sym: ", @symname[@sym], "\n"
	@compari_op = 0
	if @sym == Sym_odd then
    	getsym
    	expression
    	emit(Op_opr, 0, Opr_odd)
    else
		expression
		print "sym back from expression: ", @symname[@sym], "\n"
    	chek_compari
    	@compari_op = @sym
    	getsym
    	expression
    	case @compari_op
    		when Sym_eql: 	emit(Op_opr, 0, Opr_eql)
    		when Sym_geq: 	emit(Op_opr, 0, Opr_geq)
    		when Sym_gtr: 	emit(Op_opr, 0, Opr_gtr)
    		when Sym_leq: 	emit(Op_opr, 0, Opr_leq)
    		when Sym_lss: 	emit(Op_opr, 0, Opr_lss)
    		when Sym_neq: 	emit(Op_opr, 0, Opr_neq)
    		else
    			print "operator unknown: ", @symname[@compari_op], "\n"
    	end
  	end
end

def whilestmnt
	### while condition do statement
	print "while statement called: sym: ", @symname[@sym], "\n"
	fix1 = @cx
	getsym
	condition
	print "sym when back from condition: ", @symname[@sym], "\n"
	fix2 = @cx
	emit(Op_jpc, 0, 0)
	chek_error(Sym_do, 18) 		### "'do' expected !"
	getsym
	statement
	print "sym after back from statement in while: ", @symname[@sym], "\n"
	emit(Op_jmp, 0, fix1)
	fixup(fix2, @cx)
	getsym
end

def ifstmnt
	fix1 = 0
	fix2 = 0
	print "if statement called: sym: ", @symname[@sym], "\n"
	getsym
	condition
	print "sym after back from condition: ", @symname[@sym], "\n"
	chek_error(Sym_then, 16) 		### "'then' expected !"
	fix1 = @cx
	emit(Op_jpc, 0, 0)
	getsym
	statement
	print "sym after back from statement: ", @symname[@sym], "\n"
	if @sym == Sym_else then
		getsym
		fix2 = @cx
		emit(Op_jmp, 0, 0)
		fixup(fix1, @cx)
		statement
		fixup(fix2, @cx)
	else
		fixup(fix1, @cx)
	end
	print "sym at bottom of ifstmnt: ",  @symname[@sym], "\n"
end

def assignstmnt
	i = search(@cname)
	if i == nil then 
		error(11)
	end
	k = getkind(i)
	if k == Kind_const || k == Kind_const_loco || k == Kind_procedure then
		error(12)
	end
	if k == Kind_var_loco && @inproc_flag then
		getsym
		match(Sym_becomes, 13)
		expression
		emit(Op_sto, (@level-getlev(i)), getadr(i))
	end  
	if k == Kind_var_loco && !@inproc_flag then
		error(26)
	end
	if k == Kind_var then
		getsym
		match(Sym_becomes, 13)
		expression
		emit(Op_sto, (@level-getlev(i)), getadr(i))
	end  
end

def compoundstmnt

	getsym
	print("sym at the compoundstmnt: ", @symname[@sym], "\n")
	statement
	print("sym at the compoundstmnt after statement1: ", @symname[@sym], "\n")
	
	while @sym == Sym_semicolon do
		getsym
		statement
	end
	print("sym at the compoundstmnt after statement: ", @symname[@sym], "\n")
	### try this way
	getsym
#	match(Sym_end, 17);
end

def writestmnt
	getsym
	expression
	emit(Op_wrt, 0, 0)
end

def callstmnt
	print "call statement called: sym: ", @symname[@sym], "\n"
	### ok, next would be a func name
	getsym
	chek_error(Sym_ident, 14)
	### "After 'call' a procedure identifier is expected !"
	print "cname in call statement: ", @cname, "\n"
	i = search(@cname)
	if i == nil then 
		error(11)
	end
	k = getkind(i)
	if k != Kind_procedure then
		error(15)	### "Constant or variable identifier after call not allowed !"
	else
###		emit(Op_cal, 0, getvalue(i))
		emit(Op_cal, 0, getpc(i)+1)
	end
	getsym
	print "sym at the bottom of callstmnt: ", @symname[@sym], "\n"
end


def statement
	print "statement called: ", @symname[@sym], "\n"
	
	if @sym == Sym_ident then
		assignstmnt
	elsif @sym == Sym_call then
		callstmnt
	elsif @sym == Sym_if then
		ifstmnt
	elsif @sym == Sym_begin then
		compoundstmnt
	elsif @sym == Sym_while then
		whilestmnt
	elsif @sym == Sym_write then
		writestmnt
	else
		print "not appropriate sym for enter stmnt: ", @symname[@sym], "\n"
	end
end
   

def block
	$jmp_pos = @cx
	tx0 = @tx
	### weber var
	ppos = 0 		### procedure position or index in symbol table
	dindex = 3 		### data allocation index
	txfirst = @tx + 1 	### index of first declaration in block
	oldcdi = @cx 			### saves old code index
	currcdi = 0 			### current code index 

	emit(Op_jmp, 0, 0)
	getsym
	if @sym == Sym_const then
		constpart
	end
	print "after constpart in block: sym: ", @symname[@sym], "\n"
	### right now, ';' so inc this here
#	getsym
	if @sym == Sym_var then
		varpart
	end
	print "after varpart in block: sym: ", @symname[@sym], "\n"
	while @sym == Sym_procedure do
		procpart
	end
	currcdi = @cx
	fixup(oldcdi, currcdi)
#	@code_arr[1].dest = @cx;
	emit(Op_inc, 0, @addre)
	statement
	print "back from statement in block: sym ", @symname[@sym], "\n"
	### Sym_end then if no semicolon, wrap
	getsym
	print " after getsym back from statement in block: sym: ", @symname[@sym], "\n"
	
	if @sym == Sym_semicolon then
		getsym
		statement
	end
	emit(Op_opr, 0, Opr_ret)
	
end


def program
	do_fileread
	dolook
#	getsym
	block
end

program
print_code
write_buf
=begin
@table.each do |s|
	s.print_table
end
=end


