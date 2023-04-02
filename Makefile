build:
	docker build -f Dockerfile --tag rosscalimlim/docker-latexmk .

run:
	docker run --rm -it rosscalimlim/docker-latexmk bash

clean:
	rm -f *.dvi *.pdf *.fls *.aux *.fdb_latexmk *.log
