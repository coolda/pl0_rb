#!/usr/bin/ruby
### interp1.rb
require 'mysym2'
include Mysym

@scode = ''
@s_siz = 0
@code = []
@cx = 0
@stack = Array.new(512, 0)

Code = Struct.new(:opcode, :operand1, :operand2)

### instruction names
@op_name =  %w( nul lit opr lod sto cal inc jmp
				jpc wrt stp lid lda sid stx sty
				ldx ssy siz liz )
### arithmetic opr names
@opr_name = %w( ret neg add sub mul div odd inc
				eql neq lss leq gtr geq rtn )

def do_fileread
	if ARGV.length == 0 then
		puts "file name required!"
	end
	#puts ARGV	### array
	fname = ARGV[0]
	f = open(fname, "r")
	@scode = f.read		### all the String data source code
	@s_siz = @scode.length
	print "source_code size: ", @s_siz, "\n"
end

def emit(opcode, operand1, operand2)
	@code[@cx] = Code.new(opcode, operand1, operand2)
	@cx += 1
end

def do_toke			### typical data goes like  inc 0 nnn
	@i = 0			### alpha3 0x20 digit1 0x20 digit14
	@j = 0
	@l = 0
	@scode.each do |toke|
		puts toke
		a = toke[0, 3]
		@l = toke[4]-48	### shows 48 which is asc 0
		@i = @op_name.index(a)
		if @i == 2 then
			c = toke[6, 3]
###			print "what the c: ", c, "\n"
			@j = @opr_name.index(c)
		else
			d = toke[6, 14]
			@j = d.to_i
###			print "number case: ", @j, "\n"
		end
		emit(@i, @l, @j)
	end
	puts
end

def print_code
	print "code size: ", @cx, "\n"
	i = 0
	while i < @cx do
		print @code[i].opcode, " ",  @code[i].operand1, " ", @code[i].operand2, "\n"
		i += 1
	end
	puts
end

# =begin
def print_stack
###	sz = @stack.size
	i = 0
###	print "stack_size: ", sz, "\n"
	while i < 24 do
		print @stack[i], " "
		i += 1
	end
	puts
end
# =end

def base(lev, bass)
	b = bass
	while(lev > 0) do
		b = @stack[b]
		lev -= 1
	end
	return b
end

def interp
	pc = 0
	bp = 1
	sp = 0
	ix = 0
	iy = 0
#	@stack << 0
#	@stack << 0
#	@stack << 0
#	@stack << 0
	puts "Start PL0"
	begin
		case @code[pc].opcode
			when Op_lit
				sp += 1
				@stack[sp] = @code[pc].operand2
				pc += 1
				print "Op_lit: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_opr
				case @code[pc].operand2
					when Opr_ret
						sp = bp - 1
						pc = @stack[sp + 3]
						bp = @stack[sp + 2]
						print "Opr_ret: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
						print_stack
					when Opr_neg
						@stack[sp] = -@stack[sp]
						pc += 1
					when Opr_add
						sp -= 1
						@stack[sp] += @stack[sp + 1]
						pc += 1
					when Opr_sub
						sp -= 1
						@stack[sp] -= @stack[sp + 1]
						pc += 1
					when Opr_mul
						sp -= 1
						@stack[sp] *= @stack[sp + 1]
						pc += 1
					when Opr_div
						sp -= 1
						@stack[sp] /= @stack[sp + 1]
						pc += 1
					when Opr_odd
						@stack[sp] = @stack[sp] % 2
						pc += 1
					when Opr_inc:	pc += 1
					when Opr_eql
						sp -= 1
						if @stack[sp] == @stack[sp + 1] then
							@stack[sp] = 1
						else
							@stack[sp] = 0
						end
						pc += 1
					when Opr_neq
						sp -= 1
						if @stack[sp] != @stack[sp + 1] then
							@stack[sp] = 1
						else
							@stack[sp] = 0
						end
						pc += 1
					when Opr_lss
						sp -= 1
						if @stack[sp] < @stack[sp + 1] then
							@stack[sp] = 1
						else
							@stack[sp] = 0
						end
						pc += 1
					when Opr_leq
						sp -= 1
						if @stack[sp] <= @stack[sp + 1] then
							@stack[sp] = 1
						else
							@stack[sp] = 0
						end
						pc += 1
					when Opr_gtr
						sp -= 1
						if @stack[sp] > @stack[sp + 1] then
							@stack[sp] = 1
						else
							@stack[sp] = 0
						end
						pc += 1
					when Opr_geq
						sp -= 1
						if @stack[sp] >= @stack[sp + 1] then
							@stack[sp] = 1
						else
							@stack[sp] = 0
						end
						pc += 1
				end
			when Op_lod
				sp += 1
				@stack[sp] = @stack[base(@code[pc].operand1, bp) + @code[pc].operand2]
				pc += 1
				print "Op_lod: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_sto
				@stack[base(@code[pc].operand1,bp) + @code[pc].operand2] = @stack[sp]  
				pc += 1
				sp -= 1
				print "Op_sto: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_cal
				@stack[sp + 1] = base(@code[pc].operand1, bp)
				@stack[sp + 2] = bp
				@stack[sp + 3] = pc + 1
				bp = sp + 1
				pc = @code[pc].operand2
				print "Op_cal: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_inc
				sp += @code[pc].operand2
				pc += 1
				print "Op_inc: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_jmp
				pc = @code[pc].operand2
				print "Op_jmp: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_jpc
				if @stack[sp] == 0 then
					pc = @code[pc].operand2
				else
					pc += 1
				end
				sp -= 1
				print "Op_jpc: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_wrt
				print "Result: ", @stack[sp], "\n"
				sp -= 1
				pc += 1
				print "Op_wrt: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_stp
				@stack[sp + 3] = @stack[sp]
				pc += 1
				sp -= 1
				print "Op_stp: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_lid
				sp += 1
				@stack[sp] =
				@stack[@stack[base(@code[pc].operand1, bp) + @code[pc].operand2]]
				pc += 1
				print "Op_lid: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_ldx 	### ldx l,a : load @stack[base(l,bp)+a+x] to the top of stack
				sp += 1
				n = base(@code[pc].operand1, bp) + @code[pc].operand2 + ix
				@stack[sp] = @stack[n]
				pc += 1
				print "Op_ldx: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_ssy		### ssy l,a :    store the top of stack to s[base(l,bp)+a+iy]
				n = base(@code[pc].operand1, bp) + @code[pc].operand2 + iy
				@stack[n] = @stack[sp]
				sp -= 1
				pc += 1
				print "Op_ssy: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_stx		### stx 0,0 store the top of stack to ix
				ix = @stack[sp]
				sp -= 1
				pc += 1
				print "Op_stx: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_sty		### sty 0,0 store the top of stack into iy
				iy = @stack[sp]
				sp -= 1
				pc += 1
				print "Op_sty: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_lda
				sp += 1
				@stack[sp] = base(@code[pc].operand1, bp) + @code[pc].operand2
				pc += 1
				print "Op_lda: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack
			when Op_sid
				@stack[@stack[base(code[pc].operand1, bp) + @code[pc].operand2]] = @stack[sp]
				sp -= 1
				pc += 1
				print "Op_sid: pc: ", pc, " bp: ", bp, " sp: ", sp, "\n"
				print_stack	
			else
				puts "unknown"
				Process.exit
		end
	end until pc==0
	puts "End PL0"
end

def do_interp
	do_fileread
	do_toke
	print_code
	interp
end

do_interp
