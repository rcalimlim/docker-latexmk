build:
	docker build -f Dockerfile --tag rosscalimlim/docker-latexmk .

run:
	docker run --rm -v "${PWD}":/home rosscalimlim/docker-latexmk

test:
	docker run --rm -v "${PWD}":/home rosscalimlim/docker-latexmk -lualatex -pdf basic

clean:
	rm -f *.dvi *.pdf *.fls *.aux *.fdb_latexmk *.log
