MODULES=main introState endState position gameGaugesDict drawable rect state author world item effect gauges character imageHandler
OBJECTS=$(MODULES:=.cmo)
MLS=$(MODULES:=.ml)
MLIS=$(MODULES:=.mli)
TEST=test.byte
MAIN=main.byte
OCAMLBUILD=ocamlbuild -use-ocamlfind
PKGS=unix,oUnit,str,graphics,yojson,camlimages,camlimages.graphics,camlimages.png,camlimages.all

default: build
	OCAMLRUNPARAM=b utop

build:
	# $(OCAMLBUILD) $(OBJECTS) && js_of_ocaml +graphics.js $(MAIN)
	$(OCAMLBUILD) $(OBJECTS)

main: 
	$(OCAMLBUILD) $(MAIN) && ./$(MAIN)

test:
	$(OCAMLBUILD) -tag 'debug' $(TEST) && ./$(TEST) -runner sequential

bisect-test:
	BISECT_COVERAGE=YES $(OCAMLBUILD) -tag 'debug' $(TEST) \
		&& ./$(TEST)

play:
	$(OCAMLBUILD) -tag 'debug' $(MAIN) && OCAMLRUNPARAM=b ./$(MAIN)

zip:
	zip src.zip *.ml* *.json *.sh _tags .merlin .ocamlformat .ocamlinit LICENSE Makefile	
	
docs: docs-public docs-private
	
docs-public: build
	mkdir -p _doc.public
	ocamlfind ocamldoc -I _build -package graphics,yojson,ANSITerminal,camlimages.all \
		-html -stars -d _doc.public $(MLIS)

docs-private: build
	mkdir -p _doc.private
	ocamlfind ocamldoc -I _build -package graphics,yojson,ANSITerminal,camlimages.all \
		-html -stars -d _doc.private \
		-inv-merge-ml-mli -m A $(MLIS) $(MLS)

clean:
	ocamlbuild -clean
	rm -rf _doc.public _doc.private src.zip
