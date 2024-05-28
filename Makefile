MKID=node $(TROUPE)/rt/built/p2p/mkid.mjs
MKALIASES=node $(TROUPE)/rt/built/p2p/mkaliases.js
START=$(TROUPE)/network.sh
LOCAL=$(TROUPE)/local.sh

LIBS := $(shell find libs -type f)
TESTS := $(shell find tests -type f)

run: build/node_dest.trp
	$(LOCAL) ./build/node_dest.trp

build/node_dest.trp: node.trp $(LIBS) $(TESTS)
	python build.py node.trp

zero.listener1:
	$(START) zero.trp --id=ids/node1.json  --rspawn=true --aliases=aliases.json --stdiolev={} #
zero.listener2:
	$(START) zero.trp --id=ids/node2.json  --rspawn=true --aliases=aliases.json --stdiolev={} # 
zero.listener3:
	$(START) zero.trp --id=ids/node3.json  --rspawn=true --aliases=aliases.json --stdiolev={} #
zero.listener4:
	$(START) zero.trp --id=ids/node4.json  --rspawn=true --aliases=aliases.json --stdiolev={} #
zero.listener5:
	$(START) zero.trp --id=ids/node5.json  --rspawn=true --aliases=aliases.json --stdiolev={} #

raft.dialer: build/node_dest.trp
	$(START) ./build/node_dest.trp --id=ids/raft-dialer.json --aliases=aliases.json

test.dialer: 
	$(START) test.trp --id=ids/raft-dialer.json --aliases=aliases.json # --debug --debugp2p


create-network-identifiers:
	mkdir -p ids 
	$(MKID) --outfile=ids/raft-dialer.json
	$(MKID) --outfile=ids/node1.json
	$(MKID) --outfile=ids/node2.json
	$(MKID) --outfile=ids/node3.json
	$(MKID) --outfile=ids/node4.json
	$(MKID) --outfile=ids/node5.json
	$(MKALIASES) --include ids/raft-dialer.json --include ids/node1.json --include ids/node2.json --include ids/node3.json --include ids/node4.json --include ids/node5.json --outfile aliases.json
