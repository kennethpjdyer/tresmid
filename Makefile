
default: escript

docs: docs-build docs-sync 

docs-build:
	mix docs

docs-sync:
	rsync -aqdu doc/* /var/www/html/tresmid/

escript:
	mix escript.build

install: escript 
	mix escript.install


