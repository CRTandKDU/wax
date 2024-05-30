WAXC		= ..\waxc.exe
WASI_WAXC	= ..\wasi_waxc.exe
WAXCOMPILER	= $(WAXC)

# Tentative implicit rules for WASM (use setenv.bat in this dir first).
%.wasm: %.wat
	wat2wasm $<

%.wat: %.wax
	-$(WAXCOMPILER) --wat $@ $<

tools: ..\src\to_wat.c
	gcc -o $(WAXC) ..\src\waxc.c
	gcc -D WASI -o $(WASI_WAXC) ..\src\waxc.c
