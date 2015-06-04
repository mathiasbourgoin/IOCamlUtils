VERSION=01-alpha
PACKAGES=js_of_ocaml,lwt,spoc
SYNTAX=js_of_ocaml.syntax
DIR=$(notdir $(CURDIR))
LIBNAME=$(shell tr '[:upper:]' '[:lower:]' <<< $(DIR))
SRC=Error.ml Cells.ml Bench.ml Display.ml
MLOBJ_B=$(SRC:.ml=.cmo)

cc=ocamlc

all : start | build 

start :
	@echo "\033[43m\033[30mBuilding $(DIR)\033[0m"


%.cmo:%.ml
	@echo  "\033[32m[$@]\033[0m" 
	@ocamlc -for-pack $(DIR)-c $< 2>>log


build : $(LIBNAME).cma

$(LIBNAME).cma : $(DIR).cmo
	@echo "\033[32m[$@]\033[0m"
	@ocamlfind ocamlc -thread -package $(PACKAGES) -a  -linkall -o $@ $<


$(DIR).cmo : $(MLOBJ_B)
	@echo "\033[32m[$@]\033[0m"
	@ocamlfind ocamlc -thread -pack -package $(PACKAGES)  -o $@ $(MLOBJ_B)

%.cmo:%.ml
	@echo "\033[32m[$@]\033[0m"
	@ocamlfind ocamlc -thread  -package $(PACKAGES)  -syntax camlp4o -package $(SYNTAX) -for-pack $(DIR) -c $< 2>>log

depend:
	ocamlfind ocamldep -syntax camlp4o -package $(SYNTAX) *.ml > .depend

include .depend


install : all uninstall META
	@echo "\033[43m\033[30mInstalling $(DIR)\033[0m"
	@ocamlfind install $(shell tr '[:upper:]' '[:lower:]' <<< $(DIR)) *.cma   *.cmi META 2>> log


uninstall :
	@echo "\033[43m\033[30mRemoving $(DIR)\033[0m"
	@ocamlfind remove $(shell tr '[:upper:]' '[:lower:]' <<< $(DIR)) 2>>log


META:
	@echo "\033[41m\033[30mGenerating META\033[0m"
	@echo "version = \"$(VERSION)\"" > META
	@echo "description = \"$(LIBNAME)\"" >> META
	@echo "requires = \"$(PACKAGES)\"" >> META
	@echo "archive(byte) = \"$(LIBNAME).cma\"" >> META
	@echo "browse_interfaces = \" Unit name: $(DIR) \"" >> META
	@echo "exists_if = \"$(LIBNAME).cma\"" >> META

clean : 
	rm -f  *.cm* *~ \#* *\# *.o *.a log
