import sys

d_filename = sys.argv[1]
h_filename = sys.argv[2]

assert d_filename != h_filename

d_file = open( d_filename, "r" )
h_file = open( h_filename, "w" )

saving_functions = False
bracket_depth = 0
for line in d_file.readlines( ):
	if saving_functions and bracket_depth == 1 and '}' not in line:
		out = line.strip( )
		
		if out.endswith( '{' ):
			out = out[:out.rfind(')')] + ');'
		
		h_file.write( out + '\n' )
	
	if line.startswith( 'extern (C) {' ):
		saving_functions = True
	
	if '{' in line:
		bracket_depth += 1
	
	if '}' in line:
		bracket_depth -= 1
		
		if bracket_depth == 0 and saving_functions:
			saving_functions = False
		
h_file.close( )
d_file.close( )