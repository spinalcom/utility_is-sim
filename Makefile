
all:
	@echo "compiling utility_is-sim..."
	@python	bin/make.py

clean:
	@! test -e gen || rm -rf gen/ .gen/ models.js processes.js stylesheets.css
