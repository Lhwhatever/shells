.PHONY: batc
batc:
	@echo 'Installing batc'
	@chmod u+x ${PWD}/batc
	@sudo ln -s ${PWD}/batc /usr/local/bin/batc
	@echo 'batc installed'
