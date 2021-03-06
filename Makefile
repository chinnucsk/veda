ERL ?= erl
APP := veda

.PHONY: deps

all: deps
	@./rebar compile

deps:
	@./rebar get-deps

clean:
	@./rebar clean

distclean: clean
	@./rebar delete-deps

docs:
	@erl -noshell -run edoc_run application '$(APP)' '"."' '[]'

app:
	@./rebar compile skip_deps=true

start: app
	@exec erl +K true -pa $(PWD)/apps/*/ebin -pa $(PWD)/deps/*/ebin -boot start_sasl -s reloader -s veda@client -s veda@core -sname rmn

startclient: app
	@exec erl +K true -pa $(PWD)/apps/*/ebin -pa $(PWD)/deps/*/ebin -boot start_sasl -s reloader -s veda@client -sname rmn

startcore: app
	@exec erl +K true -pa $(PWD)/apps/*/ebin -pa $(PWD)/deps/*/ebin -boot start_sasl -s reloader -s veda@core -sname rmn

startproxy:
	@sudo haproxy -f dev.haproxy.cfg
