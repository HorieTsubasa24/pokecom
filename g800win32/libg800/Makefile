EXE = demo
LIB = g800.a
OBJS = mulu8.o mulu8bc.o mulu8de.o mulu8hl.o \
       mul8.o mul8bc.o mul8de.o mul8hl.o \
       divu8.o divu8bc.o divu8de.o divu8hl.o \
       div8.o div8bc.o div8de.o div8hl.o \
       rand.o \
       vvram.o line.o lineclip.o
.SUFFIXES: .asm .o

$(EXE).ihx: $(EXE).o $(LIB)
	sdcc -mz80 --code-loc 0x100 --data-loc 0 --no-std-crt0 -l $(LIB) -o $@ $(EXE).o
$(LIB): $(OBJS)
	rm -f $@
	for x in $(OBJS); do sdcclib -a $@ $$x; done
.asm.o:
	as-z80 -g -o $@ $<
arc:
	rm -r -f libg800
	mkdir libg800
	cp -p *.asm $(EXE).ihx $(LIB) Makefile readme.txt libg800/
	zip -u -9 libg800.zip libg800/*
	rm -r -f libg800
clean:
	rm -f *.map *.lnk *.sym $(OBJS) $(EXE).o $(EXE).ihx $(LIB)
