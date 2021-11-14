clone:
	git clone https://github.com/nlsandler/write_a_c_compiler.git tmp/examples

lex stage:
	#!/usr/bin/env zsh
	set -euo pipefail

	for file in tmp/examples/stage_{{stage}}/**/*(.); do 
		bin/lex $file
	done



