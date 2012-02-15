#!/usr/bin/ruby
### error.rb

#### load("error.rb")
@err = [ "", 
		"Use '=' instead of ':=' for the const",
		"A number must follow after '=' !",
		"The identifier must be followed by '=' !",
		"After 'const', 'var' or 'procedure' follows an identifier !",
		"Semicolon or comma missing !",
		"Semicolon or line feed expected !",
		"Statement or declaration expected !",
		"Symbol following the statements of the block not correct !",
		"Period expected !",
		"Incorrect use of a symbol within a statement !",

		"Undeclared identifier !",
		"Assignments to a constant or procedure name not allowed !",
		"Assignment operator is ':=' !",
		"After 'call' a procedure identifier is expected !",
		"Constant or variable identifier after call not allowed !",
		"'then' expected !",
		"'end' or ';' expected !",
		"'do' expected !",
		"Illegal symbol following a statement !",
		"Comparison operator expected !",

		"procedure identifier within an expression not allowed !",
		"Missing ')' !",
		"This symbol cannot follow a factor !",
		"An Expression may not start with this symbol !",
		"':=' expected !",
		"Can not assign or access to a local variable",
		"",
		"",
		"",
		"max. no. of digits==14 in numbers exceeded!",
		
		"program too long ! maximum address 2047 exceeded!",
		"procedure nesting too deep !",
		"identifier expected !",
		"semicolon missing !",
		"'until' expected !",
		"'of' expected !",
		"Case table overflow !",
		"':' expected !",
		"Number expected !",
		"Multiple definition of case label !",

		"'end' expected !",
		"String expected !",
		"Missing '(' !",
		"'to' or 'downto' expected !",
		"Multiple declaration in block !",
		"Illegal symbol following a '[' !",
		"'[' expected !",
		"']' expected !",
		"Symbol table full !",
		"Array dimension <= 0 !" ]
		
def error(n)
	printf("Error!: %d: %s\n", n, @err[n])
	Process.exit
end


