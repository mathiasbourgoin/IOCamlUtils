PACKAGES=js_of_ocaml,lwt
SYNTAX=js_of_ocaml.syntax
DIR=$(notdir $(CURDIR))

SRC=Error.ml Cells.ml
MLOBJ_B=$(SRC:.ml=.cmo)

cc=ocamlc

all : start | build 

start :
	@echo "\033[43m\033[30mBuilding $(DIR)\033[0m"


%.cmo:%.ml
	@echo  "\033[32m[$@]\033[0m" 
	@ocamlc -for-pack $(DIR)-c $< 2>>log


build : $(DIR).cma

$(DIR).cma : $(DIR).cmo
	@echo "\033[32m[$@]\033[0m"
	@ocamlfind ocamlc -pack -package $(PACKAGES)  -o $@ $(BYTES)

$(DIR).cmo : $(MLOBJ_B)
	@echo "\033[32m[$@]\033[0m"
	@ocamlfind ocamlc -pack -package $(PACKAGES)  -o $@ $(MLOBJ_B)

%.cmo:%.ml
	@echo "\033[32m[$@]\033[0m"
	@ocamlfind ocamlc  -package $(PACKAGES)  -syntax camlp4o -package $(SYNTAX) -for-pack $(DIR) -c $< 2>>log

depend:
	ocamlfind ocamldep -syntax camlp4o -package $(SYNTAX) *.ml > .depend

include .depend


install : all uninstall
	@echo "\033[43m\033[30mInstalling $(DIR)\033[0m"
	@ocamlfind install $(shell tr '[:upper:]' '[:lower:]' <<< $(DIR)) *.cma   *.cmi META 2>> log


uninstall :
	@echo "\033[43m\033[30mRemoving $(DIR)\033[0m"
	@ocamlfind remove $(shell tr '[:upper:]' '[:lower:]' <<< $(DIR)) 2>>log


clean : 
	rm -f  *.cm* *~ \#* *\# *.o *.a log
