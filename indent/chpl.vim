" Vim indent file
" Language:	Chapel
" Maintainer:	Francisco Souza <f@souza.cc>
" Last Change:	2016 April 25

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

" Use built-in in C/C++ style
setlocal nolisp
setlocal indentexpr=ChapelIndent()

if exists("ChapelIndent")
	finish
endif

function ChapelIndent()
	let line = getline(v:lnum)
	let previousNum = prevnonblank(v:lnum - 1)
	let beforePreviousNum = previousNum - 1
	let beforePrevious = getline(beforePreviousNum)
	let previous = getline(previousNum)
	let indentation = indent(previousNum)

	if previous =~ '\(do\|then\)\s*$' || previous =~ '^\s*else\s*$'
		return indentation + shiftwidth()
	endif

	if previous =~ '[{(]\s*$'
		let indentation += shiftwidth()
	elseif beforePrevious =~ 'then\s*$'
		" Maybe there's an else
		let indentation -= shiftwidth()
	else
		while beforePrevious =~ 'do\s*$' || beforePrevious =~ '^\s*else\s*$'
			let indentation -= shiftwidth()
			let beforePreviousNum -= 1
			echo "before if: ".beforePreviousNum
			if beforePrevious =~ '^\s*else\s*$'
				" search for the matching if ... then
				let beforePreviousNum -= 1
				let beforePrevious = getline(beforePreviousNum)
				while beforePrevious !~ '^\s*if .\+ then\s*$'
					let beforePreviousNum -= 1
					let beforePrevious = getline(beforePreviousNum)
				endwhile
				let beforePreviousNum -= 1
			endif
			echo "after if: ".beforePreviousNum
			let beforePrevious = getline(beforePreviousNum)
		endwhile

		if beforePrevious =~ 'then\s*$'
			let indentation -= shiftwidth()
		endif
	endif

	if line =~ '^\s*[)}]'
		let indentation -= shiftwidth()
	endif

	return indentation
endfunction
