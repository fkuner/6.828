
obj/user/primespipe.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 04 02 00 00       	call   800235 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 5f 16 00 00       	call   8016b0 <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	75 4b                	jne    8000a4 <primeproc+0x71>
	cprintf("%d\n", p);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	ff 75 e0             	pushl  -0x20(%ebp)
  80005f:	68 01 29 80 00       	push   $0x802901
  800064:	e8 07 03 00 00       	call   800370 <cprintf>
	if ((i=pipe(pfd)) < 0)
  800069:	89 3c 24             	mov    %edi,(%esp)
  80006c:	e8 d2 1c 00 00       	call   801d43 <pipe>
  800071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	85 c0                	test   %eax,%eax
  800079:	78 49                	js     8000c4 <primeproc+0x91>
		panic("pipe: %e", i);
	if ((id = fork()) < 0)
  80007b:	e8 80 10 00 00       	call   801100 <fork>
  800080:	85 c0                	test   %eax,%eax
  800082:	78 52                	js     8000d6 <primeproc+0xa3>
		panic("fork: %e", id);
	if (id == 0) {
  800084:	85 c0                	test   %eax,%eax
  800086:	75 60                	jne    8000e8 <primeproc+0xb5>
		close(fd);
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	53                   	push   %ebx
  80008c:	e8 5c 14 00 00       	call   8014ed <close>
		close(pfd[1]);
  800091:	83 c4 04             	add    $0x4,%esp
  800094:	ff 75 dc             	pushl  -0x24(%ebp)
  800097:	e8 51 14 00 00       	call   8014ed <close>
		fd = pfd[0];
  80009c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb a1                	jmp    800045 <primeproc+0x12>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ae:	0f 4e d0             	cmovle %eax,%edx
  8000b1:	52                   	push   %edx
  8000b2:	50                   	push   %eax
  8000b3:	68 c0 28 80 00       	push   $0x8028c0
  8000b8:	6a 15                	push   $0x15
  8000ba:	68 ef 28 80 00       	push   $0x8028ef
  8000bf:	e8 d1 01 00 00       	call   800295 <_panic>
		panic("pipe: %e", i);
  8000c4:	50                   	push   %eax
  8000c5:	68 05 29 80 00       	push   $0x802905
  8000ca:	6a 1b                	push   $0x1b
  8000cc:	68 ef 28 80 00       	push   $0x8028ef
  8000d1:	e8 bf 01 00 00       	call   800295 <_panic>
		panic("fork: %e", id);
  8000d6:	50                   	push   %eax
  8000d7:	68 06 2d 80 00       	push   $0x802d06
  8000dc:	6a 1d                	push   $0x1d
  8000de:	68 ef 28 80 00       	push   $0x8028ef
  8000e3:	e8 ad 01 00 00       	call   800295 <_panic>
	}

	close(pfd[0]);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ee:	e8 fa 13 00 00       	call   8014ed <close>
	wfd = pfd[1];
  8000f3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f6:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 04                	push   $0x4
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	e8 a8 15 00 00       	call   8016b0 <readn>
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	83 f8 04             	cmp    $0x4,%eax
  80010e:	75 42                	jne    800152 <primeproc+0x11f>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800113:	99                   	cltd   
  800114:	f7 7d e0             	idivl  -0x20(%ebp)
  800117:	85 d2                	test   %edx,%edx
  800119:	74 e1                	je     8000fc <primeproc+0xc9>
			if ((r=write(wfd, &i, 4)) != 4)
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 04                	push   $0x4
  800120:	56                   	push   %esi
  800121:	57                   	push   %edi
  800122:	e8 d0 15 00 00       	call   8016f7 <write>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	83 f8 04             	cmp    $0x4,%eax
  80012d:	74 cd                	je     8000fc <primeproc+0xc9>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	85 c0                	test   %eax,%eax
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	0f 4e d0             	cmovle %eax,%edx
  80013c:	52                   	push   %edx
  80013d:	50                   	push   %eax
  80013e:	ff 75 e0             	pushl  -0x20(%ebp)
  800141:	68 2a 29 80 00       	push   $0x80292a
  800146:	6a 2e                	push   $0x2e
  800148:	68 ef 28 80 00       	push   $0x8028ef
  80014d:	e8 43 01 00 00       	call   800295 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	85 c0                	test   %eax,%eax
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	0f 4e d0             	cmovle %eax,%edx
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	53                   	push   %ebx
  800162:	ff 75 e0             	pushl  -0x20(%ebp)
  800165:	68 0e 29 80 00       	push   $0x80290e
  80016a:	6a 2b                	push   $0x2b
  80016c:	68 ef 28 80 00       	push   $0x8028ef
  800171:	e8 1f 01 00 00       	call   800295 <_panic>

00800176 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	53                   	push   %ebx
  80017a:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017d:	c7 05 00 30 80 00 44 	movl   $0x802944,0x803000
  800184:	29 80 00 

	if ((i=pipe(p)) < 0)
  800187:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 b3 1b 00 00       	call   801d43 <pipe>
  800190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	85 c0                	test   %eax,%eax
  800198:	78 23                	js     8001bd <umain+0x47>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80019a:	e8 61 0f 00 00       	call   801100 <fork>
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	78 2c                	js     8001cf <umain+0x59>
		panic("fork: %e", id);

	if (id == 0) {
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	75 3a                	jne    8001e1 <umain+0x6b>
		close(p[1]);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 3b 13 00 00       	call   8014ed <close>
		primeproc(p[0]);
  8001b2:	83 c4 04             	add    $0x4,%esp
  8001b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b8:	e8 76 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001bd:	50                   	push   %eax
  8001be:	68 05 29 80 00       	push   $0x802905
  8001c3:	6a 3a                	push   $0x3a
  8001c5:	68 ef 28 80 00       	push   $0x8028ef
  8001ca:	e8 c6 00 00 00       	call   800295 <_panic>
		panic("fork: %e", id);
  8001cf:	50                   	push   %eax
  8001d0:	68 06 2d 80 00       	push   $0x802d06
  8001d5:	6a 3e                	push   $0x3e
  8001d7:	68 ef 28 80 00       	push   $0x8028ef
  8001dc:	e8 b4 00 00 00       	call   800295 <_panic>
	}

	close(p[0]);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e7:	e8 01 13 00 00       	call   8014ed <close>

	// feed all the integers through
	for (i=2;; i++)
  8001ec:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f3:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f6:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	6a 04                	push   $0x4
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800202:	e8 f0 14 00 00       	call   8016f7 <write>
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	83 f8 04             	cmp    $0x4,%eax
  80020d:	75 06                	jne    800215 <umain+0x9f>
	for (i=2;; i++)
  80020f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800213:	eb e4                	jmp    8001f9 <umain+0x83>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	ba 00 00 00 00       	mov    $0x0,%edx
  80021f:	0f 4e d0             	cmovle %eax,%edx
  800222:	52                   	push   %edx
  800223:	50                   	push   %eax
  800224:	68 4f 29 80 00       	push   $0x80294f
  800229:	6a 4a                	push   $0x4a
  80022b:	68 ef 28 80 00       	push   $0x8028ef
  800230:	e8 60 00 00 00       	call   800295 <_panic>

00800235 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
  80023a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80023d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800240:	e8 83 0b 00 00       	call   800dc8 <sys_getenvid>
  800245:	25 ff 03 00 00       	and    $0x3ff,%eax
  80024a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80024d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800252:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800257:	85 db                	test   %ebx,%ebx
  800259:	7e 07                	jle    800262 <libmain+0x2d>
		binaryname = argv[0];
  80025b:	8b 06                	mov    (%esi),%eax
  80025d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	e8 0a ff ff ff       	call   800176 <umain>

	// exit gracefully
	exit();
  80026c:	e8 0a 00 00 00       	call   80027b <exit>
}
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800281:	e8 92 12 00 00       	call   801518 <close_all>
	sys_env_destroy(0);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	6a 00                	push   $0x0
  80028b:	e8 f7 0a 00 00       	call   800d87 <sys_env_destroy>
}
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80029a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002a3:	e8 20 0b 00 00       	call   800dc8 <sys_getenvid>
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 0c             	pushl  0xc(%ebp)
  8002ae:	ff 75 08             	pushl  0x8(%ebp)
  8002b1:	56                   	push   %esi
  8002b2:	50                   	push   %eax
  8002b3:	68 74 29 80 00       	push   $0x802974
  8002b8:	e8 b3 00 00 00       	call   800370 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002bd:	83 c4 18             	add    $0x18,%esp
  8002c0:	53                   	push   %ebx
  8002c1:	ff 75 10             	pushl  0x10(%ebp)
  8002c4:	e8 56 00 00 00       	call   80031f <vcprintf>
	cprintf("\n");
  8002c9:	c7 04 24 03 29 80 00 	movl   $0x802903,(%esp)
  8002d0:	e8 9b 00 00 00       	call   800370 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d8:	cc                   	int3   
  8002d9:	eb fd                	jmp    8002d8 <_panic+0x43>

008002db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	53                   	push   %ebx
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e5:	8b 13                	mov    (%ebx),%edx
  8002e7:	8d 42 01             	lea    0x1(%edx),%eax
  8002ea:	89 03                	mov    %eax,(%ebx)
  8002ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f8:	74 09                	je     800303 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002fa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800301:	c9                   	leave  
  800302:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	68 ff 00 00 00       	push   $0xff
  80030b:	8d 43 08             	lea    0x8(%ebx),%eax
  80030e:	50                   	push   %eax
  80030f:	e8 36 0a 00 00       	call   800d4a <sys_cputs>
		b->idx = 0;
  800314:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	eb db                	jmp    8002fa <putch+0x1f>

0080031f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800328:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032f:	00 00 00 
	b.cnt = 0;
  800332:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800339:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800348:	50                   	push   %eax
  800349:	68 db 02 80 00       	push   $0x8002db
  80034e:	e8 1a 01 00 00       	call   80046d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800353:	83 c4 08             	add    $0x8,%esp
  800356:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80035c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800362:	50                   	push   %eax
  800363:	e8 e2 09 00 00       	call   800d4a <sys_cputs>

	return b.cnt;
}
  800368:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800376:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800379:	50                   	push   %eax
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 9d ff ff ff       	call   80031f <vcprintf>
	va_end(ap);

	return cnt;
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 1c             	sub    $0x1c,%esp
  80038d:	89 c7                	mov    %eax,%edi
  80038f:	89 d6                	mov    %edx,%esi
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80039d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003ab:	39 d3                	cmp    %edx,%ebx
  8003ad:	72 05                	jb     8003b4 <printnum+0x30>
  8003af:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003b2:	77 7a                	ja     80042e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	ff 75 18             	pushl  0x18(%ebp)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c0:	53                   	push   %ebx
  8003c1:	ff 75 10             	pushl  0x10(%ebp)
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d3:	e8 a8 22 00 00       	call   802680 <__udivdi3>
  8003d8:	83 c4 18             	add    $0x18,%esp
  8003db:	52                   	push   %edx
  8003dc:	50                   	push   %eax
  8003dd:	89 f2                	mov    %esi,%edx
  8003df:	89 f8                	mov    %edi,%eax
  8003e1:	e8 9e ff ff ff       	call   800384 <printnum>
  8003e6:	83 c4 20             	add    $0x20,%esp
  8003e9:	eb 13                	jmp    8003fe <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	56                   	push   %esi
  8003ef:	ff 75 18             	pushl  0x18(%ebp)
  8003f2:	ff d7                	call   *%edi
  8003f4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003f7:	83 eb 01             	sub    $0x1,%ebx
  8003fa:	85 db                	test   %ebx,%ebx
  8003fc:	7f ed                	jg     8003eb <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	56                   	push   %esi
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	ff 75 e4             	pushl  -0x1c(%ebp)
  800408:	ff 75 e0             	pushl  -0x20(%ebp)
  80040b:	ff 75 dc             	pushl  -0x24(%ebp)
  80040e:	ff 75 d8             	pushl  -0x28(%ebp)
  800411:	e8 8a 23 00 00       	call   8027a0 <__umoddi3>
  800416:	83 c4 14             	add    $0x14,%esp
  800419:	0f be 80 97 29 80 00 	movsbl 0x802997(%eax),%eax
  800420:	50                   	push   %eax
  800421:	ff d7                	call   *%edi
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800429:	5b                   	pop    %ebx
  80042a:	5e                   	pop    %esi
  80042b:	5f                   	pop    %edi
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    
  80042e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800431:	eb c4                	jmp    8003f7 <printnum+0x73>

00800433 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800439:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80043d:	8b 10                	mov    (%eax),%edx
  80043f:	3b 50 04             	cmp    0x4(%eax),%edx
  800442:	73 0a                	jae    80044e <sprintputch+0x1b>
		*b->buf++ = ch;
  800444:	8d 4a 01             	lea    0x1(%edx),%ecx
  800447:	89 08                	mov    %ecx,(%eax)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	88 02                	mov    %al,(%edx)
}
  80044e:	5d                   	pop    %ebp
  80044f:	c3                   	ret    

00800450 <printfmt>:
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800456:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800459:	50                   	push   %eax
  80045a:	ff 75 10             	pushl  0x10(%ebp)
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	ff 75 08             	pushl  0x8(%ebp)
  800463:	e8 05 00 00 00       	call   80046d <vprintfmt>
}
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <vprintfmt>:
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	57                   	push   %edi
  800471:	56                   	push   %esi
  800472:	53                   	push   %ebx
  800473:	83 ec 2c             	sub    $0x2c,%esp
  800476:	8b 75 08             	mov    0x8(%ebp),%esi
  800479:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80047c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80047f:	e9 21 04 00 00       	jmp    8008a5 <vprintfmt+0x438>
		padc = ' ';
  800484:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800488:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80048f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800496:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8d 47 01             	lea    0x1(%edi),%eax
  8004a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a8:	0f b6 17             	movzbl (%edi),%edx
  8004ab:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ae:	3c 55                	cmp    $0x55,%al
  8004b0:	0f 87 90 04 00 00    	ja     800946 <vprintfmt+0x4d9>
  8004b6:	0f b6 c0             	movzbl %al,%eax
  8004b9:	ff 24 85 e0 2a 80 00 	jmp    *0x802ae0(,%eax,4)
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004c7:	eb d9                	jmp    8004a2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004cc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004d0:	eb d0                	jmp    8004a2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	0f b6 d2             	movzbl %dl,%edx
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004e7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ea:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ed:	83 f9 09             	cmp    $0x9,%ecx
  8004f0:	77 55                	ja     800547 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f5:	eb e9                	jmp    8004e0 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8d 40 04             	lea    0x4(%eax),%eax
  800505:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80050b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050f:	79 91                	jns    8004a2 <vprintfmt+0x35>
				width = precision, precision = -1;
  800511:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80051e:	eb 82                	jmp    8004a2 <vprintfmt+0x35>
  800520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800523:	85 c0                	test   %eax,%eax
  800525:	ba 00 00 00 00       	mov    $0x0,%edx
  80052a:	0f 49 d0             	cmovns %eax,%edx
  80052d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800533:	e9 6a ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80053b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800542:	e9 5b ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
  800547:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80054a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054d:	eb bc                	jmp    80050b <vprintfmt+0x9e>
			lflag++;
  80054f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800555:	e9 48 ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 78 04             	lea    0x4(%eax),%edi
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	ff 30                	pushl  (%eax)
  800566:	ff d6                	call   *%esi
			break;
  800568:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056e:	e9 2f 03 00 00       	jmp    8008a2 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8d 78 04             	lea    0x4(%eax),%edi
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	99                   	cltd   
  80057c:	31 d0                	xor    %edx,%eax
  80057e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800580:	83 f8 0f             	cmp    $0xf,%eax
  800583:	7f 23                	jg     8005a8 <vprintfmt+0x13b>
  800585:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  80058c:	85 d2                	test   %edx,%edx
  80058e:	74 18                	je     8005a8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800590:	52                   	push   %edx
  800591:	68 06 2e 80 00       	push   $0x802e06
  800596:	53                   	push   %ebx
  800597:	56                   	push   %esi
  800598:	e8 b3 fe ff ff       	call   800450 <printfmt>
  80059d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a3:	e9 fa 02 00 00       	jmp    8008a2 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8005a8:	50                   	push   %eax
  8005a9:	68 af 29 80 00       	push   $0x8029af
  8005ae:	53                   	push   %ebx
  8005af:	56                   	push   %esi
  8005b0:	e8 9b fe ff ff       	call   800450 <printfmt>
  8005b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005bb:	e9 e2 02 00 00       	jmp    8008a2 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	83 c0 04             	add    $0x4,%eax
  8005c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005ce:	85 ff                	test   %edi,%edi
  8005d0:	b8 a8 29 80 00       	mov    $0x8029a8,%eax
  8005d5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005dc:	0f 8e bd 00 00 00    	jle    80069f <vprintfmt+0x232>
  8005e2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005e6:	75 0e                	jne    8005f6 <vprintfmt+0x189>
  8005e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005eb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005ee:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f4:	eb 6d                	jmp    800663 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8005fc:	57                   	push   %edi
  8005fd:	e8 ec 03 00 00       	call   8009ee <strnlen>
  800602:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800605:	29 c1                	sub    %eax,%ecx
  800607:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80060a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80060d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800611:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800614:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800617:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800619:	eb 0f                	jmp    80062a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	ff 75 e0             	pushl  -0x20(%ebp)
  800622:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800624:	83 ef 01             	sub    $0x1,%edi
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	85 ff                	test   %edi,%edi
  80062c:	7f ed                	jg     80061b <vprintfmt+0x1ae>
  80062e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800631:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800634:	85 c9                	test   %ecx,%ecx
  800636:	b8 00 00 00 00       	mov    $0x0,%eax
  80063b:	0f 49 c1             	cmovns %ecx,%eax
  80063e:	29 c1                	sub    %eax,%ecx
  800640:	89 75 08             	mov    %esi,0x8(%ebp)
  800643:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800646:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800649:	89 cb                	mov    %ecx,%ebx
  80064b:	eb 16                	jmp    800663 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80064d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800651:	75 31                	jne    800684 <vprintfmt+0x217>
					putch(ch, putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	ff 75 0c             	pushl  0xc(%ebp)
  800659:	50                   	push   %eax
  80065a:	ff 55 08             	call   *0x8(%ebp)
  80065d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800660:	83 eb 01             	sub    $0x1,%ebx
  800663:	83 c7 01             	add    $0x1,%edi
  800666:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80066a:	0f be c2             	movsbl %dl,%eax
  80066d:	85 c0                	test   %eax,%eax
  80066f:	74 59                	je     8006ca <vprintfmt+0x25d>
  800671:	85 f6                	test   %esi,%esi
  800673:	78 d8                	js     80064d <vprintfmt+0x1e0>
  800675:	83 ee 01             	sub    $0x1,%esi
  800678:	79 d3                	jns    80064d <vprintfmt+0x1e0>
  80067a:	89 df                	mov    %ebx,%edi
  80067c:	8b 75 08             	mov    0x8(%ebp),%esi
  80067f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800682:	eb 37                	jmp    8006bb <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800684:	0f be d2             	movsbl %dl,%edx
  800687:	83 ea 20             	sub    $0x20,%edx
  80068a:	83 fa 5e             	cmp    $0x5e,%edx
  80068d:	76 c4                	jbe    800653 <vprintfmt+0x1e6>
					putch('?', putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	6a 3f                	push   $0x3f
  800697:	ff 55 08             	call   *0x8(%ebp)
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	eb c1                	jmp    800660 <vprintfmt+0x1f3>
  80069f:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ab:	eb b6                	jmp    800663 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 20                	push   $0x20
  8006b3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ee                	jg     8006ad <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	e9 d8 01 00 00       	jmp    8008a2 <vprintfmt+0x435>
  8006ca:	89 df                	mov    %ebx,%edi
  8006cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d2:	eb e7                	jmp    8006bb <vprintfmt+0x24e>
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7e 45                	jle    80071e <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 50 04             	mov    0x4(%eax),%edx
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 08             	lea    0x8(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f4:	79 62                	jns    800758 <vprintfmt+0x2eb>
				putch('-', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 2d                	push   $0x2d
  8006fc:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800701:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800704:	f7 d8                	neg    %eax
  800706:	83 d2 00             	adc    $0x0,%edx
  800709:	f7 da                	neg    %edx
  80070b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800711:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800714:	ba 0a 00 00 00       	mov    $0xa,%edx
  800719:	e9 66 01 00 00       	jmp    800884 <vprintfmt+0x417>
	else if (lflag)
  80071e:	85 c9                	test   %ecx,%ecx
  800720:	75 1b                	jne    80073d <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 c1                	mov    %eax,%ecx
  80072c:	c1 f9 1f             	sar    $0x1f,%ecx
  80072f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8d 40 04             	lea    0x4(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
  80073b:	eb b3                	jmp    8006f0 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800745:	89 c1                	mov    %eax,%ecx
  800747:	c1 f9 1f             	sar    $0x1f,%ecx
  80074a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
  800756:	eb 98                	jmp    8006f0 <vprintfmt+0x283>
			base = 10;
  800758:	ba 0a 00 00 00       	mov    $0xa,%edx
  80075d:	e9 22 01 00 00       	jmp    800884 <vprintfmt+0x417>
	if (lflag >= 2)
  800762:	83 f9 01             	cmp    $0x1,%ecx
  800765:	7e 21                	jle    800788 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 50 04             	mov    0x4(%eax),%edx
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800772:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8d 40 08             	lea    0x8(%eax),%eax
  80077b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80077e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800783:	e9 fc 00 00 00       	jmp    800884 <vprintfmt+0x417>
	else if (lflag)
  800788:	85 c9                	test   %ecx,%ecx
  80078a:	75 23                	jne    8007af <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007aa:	e9 d5 00 00 00       	jmp    800884 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8007cd:	e9 b2 00 00 00       	jmp    800884 <vprintfmt+0x417>
	if (lflag >= 2)
  8007d2:	83 f9 01             	cmp    $0x1,%ecx
  8007d5:	7e 42                	jle    800819 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 08             	lea    0x8(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ee:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8007f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007f7:	0f 89 87 00 00 00    	jns    800884 <vprintfmt+0x417>
				putch('-', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 2d                	push   $0x2d
  800803:	ff d6                	call   *%esi
				num = -(long long) num;
  800805:	f7 5d d8             	negl   -0x28(%ebp)
  800808:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80080c:	f7 5d dc             	negl   -0x24(%ebp)
  80080f:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800812:	ba 08 00 00 00       	mov    $0x8,%edx
  800817:	eb 6b                	jmp    800884 <vprintfmt+0x417>
	else if (lflag)
  800819:	85 c9                	test   %ecx,%ecx
  80081b:	75 1b                	jne    800838 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 04             	lea    0x4(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
  800836:	eb b6                	jmp    8007ee <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	ba 00 00 00 00       	mov    $0x0,%edx
  800842:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800845:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8d 40 04             	lea    0x4(%eax),%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
  800851:	eb 9b                	jmp    8007ee <vprintfmt+0x381>
			putch('0', putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	53                   	push   %ebx
  800857:	6a 30                	push   $0x30
  800859:	ff d6                	call   *%esi
			putch('x', putdat);
  80085b:	83 c4 08             	add    $0x8,%esp
  80085e:	53                   	push   %ebx
  80085f:	6a 78                	push   $0x78
  800861:	ff d6                	call   *%esi
			num = (unsigned long long)
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
  80086d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800870:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800873:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 40 04             	lea    0x4(%eax),%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087f:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800884:	83 ec 0c             	sub    $0xc,%esp
  800887:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80088b:	50                   	push   %eax
  80088c:	ff 75 e0             	pushl  -0x20(%ebp)
  80088f:	52                   	push   %edx
  800890:	ff 75 dc             	pushl  -0x24(%ebp)
  800893:	ff 75 d8             	pushl  -0x28(%ebp)
  800896:	89 da                	mov    %ebx,%edx
  800898:	89 f0                	mov    %esi,%eax
  80089a:	e8 e5 fa ff ff       	call   800384 <printnum>
			break;
  80089f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a5:	83 c7 01             	add    $0x1,%edi
  8008a8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ac:	83 f8 25             	cmp    $0x25,%eax
  8008af:	0f 84 cf fb ff ff    	je     800484 <vprintfmt+0x17>
			if (ch == '\0')
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	0f 84 a9 00 00 00    	je     800966 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	53                   	push   %ebx
  8008c1:	50                   	push   %eax
  8008c2:	ff d6                	call   *%esi
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	eb dc                	jmp    8008a5 <vprintfmt+0x438>
	if (lflag >= 2)
  8008c9:	83 f9 01             	cmp    $0x1,%ecx
  8008cc:	7e 1e                	jle    8008ec <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 50 04             	mov    0x4(%eax),%edx
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 40 08             	lea    0x8(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e5:	ba 10 00 00 00       	mov    $0x10,%edx
  8008ea:	eb 98                	jmp    800884 <vprintfmt+0x417>
	else if (lflag)
  8008ec:	85 c9                	test   %ecx,%ecx
  8008ee:	75 23                	jne    800913 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800900:	8b 45 14             	mov    0x14(%ebp),%eax
  800903:	8d 40 04             	lea    0x4(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800909:	ba 10 00 00 00       	mov    $0x10,%edx
  80090e:	e9 71 ff ff ff       	jmp    800884 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8d 40 04             	lea    0x4(%eax),%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092c:	ba 10 00 00 00       	mov    $0x10,%edx
  800931:	e9 4e ff ff ff       	jmp    800884 <vprintfmt+0x417>
			putch(ch, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	53                   	push   %ebx
  80093a:	6a 25                	push   $0x25
  80093c:	ff d6                	call   *%esi
			break;
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	e9 5c ff ff ff       	jmp    8008a2 <vprintfmt+0x435>
			putch('%', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	53                   	push   %ebx
  80094a:	6a 25                	push   $0x25
  80094c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 f8                	mov    %edi,%eax
  800953:	eb 03                	jmp    800958 <vprintfmt+0x4eb>
  800955:	83 e8 01             	sub    $0x1,%eax
  800958:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80095c:	75 f7                	jne    800955 <vprintfmt+0x4e8>
  80095e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800961:	e9 3c ff ff ff       	jmp    8008a2 <vprintfmt+0x435>
}
  800966:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800969:	5b                   	pop    %ebx
  80096a:	5e                   	pop    %esi
  80096b:	5f                   	pop    %edi
  80096c:	5d                   	pop    %ebp
  80096d:	c3                   	ret    

0080096e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 18             	sub    $0x18,%esp
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80097d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800981:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800984:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80098b:	85 c0                	test   %eax,%eax
  80098d:	74 26                	je     8009b5 <vsnprintf+0x47>
  80098f:	85 d2                	test   %edx,%edx
  800991:	7e 22                	jle    8009b5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800993:	ff 75 14             	pushl  0x14(%ebp)
  800996:	ff 75 10             	pushl  0x10(%ebp)
  800999:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80099c:	50                   	push   %eax
  80099d:	68 33 04 80 00       	push   $0x800433
  8009a2:	e8 c6 fa ff ff       	call   80046d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b0:	83 c4 10             	add    $0x10,%esp
}
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    
		return -E_INVAL;
  8009b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ba:	eb f7                	jmp    8009b3 <vsnprintf+0x45>

008009bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009c5:	50                   	push   %eax
  8009c6:	ff 75 10             	pushl  0x10(%ebp)
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	ff 75 08             	pushl  0x8(%ebp)
  8009cf:	e8 9a ff ff ff       	call   80096e <vsnprintf>
	va_end(ap);

	return rc;
}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    

008009d6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e1:	eb 03                	jmp    8009e6 <strlen+0x10>
		n++;
  8009e3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009e6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ea:	75 f7                	jne    8009e3 <strlen+0xd>
	return n;
}
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    

008009ee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fc:	eb 03                	jmp    800a01 <strnlen+0x13>
		n++;
  8009fe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a01:	39 d0                	cmp    %edx,%eax
  800a03:	74 06                	je     800a0b <strnlen+0x1d>
  800a05:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a09:	75 f3                	jne    8009fe <strnlen+0x10>
	return n;
}
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	53                   	push   %ebx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a17:	89 c2                	mov    %eax,%edx
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a23:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a26:	84 db                	test   %bl,%bl
  800a28:	75 ef                	jne    800a19 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a2a:	5b                   	pop    %ebx
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	53                   	push   %ebx
  800a31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a34:	53                   	push   %ebx
  800a35:	e8 9c ff ff ff       	call   8009d6 <strlen>
  800a3a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	01 d8                	add    %ebx,%eax
  800a42:	50                   	push   %eax
  800a43:	e8 c5 ff ff ff       	call   800a0d <strcpy>
	return dst;
}
  800a48:	89 d8                	mov    %ebx,%eax
  800a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	8b 75 08             	mov    0x8(%ebp),%esi
  800a57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a5a:	89 f3                	mov    %esi,%ebx
  800a5c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a5f:	89 f2                	mov    %esi,%edx
  800a61:	eb 0f                	jmp    800a72 <strncpy+0x23>
		*dst++ = *src;
  800a63:	83 c2 01             	add    $0x1,%edx
  800a66:	0f b6 01             	movzbl (%ecx),%eax
  800a69:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a6c:	80 39 01             	cmpb   $0x1,(%ecx)
  800a6f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a72:	39 da                	cmp    %ebx,%edx
  800a74:	75 ed                	jne    800a63 <strncpy+0x14>
	}
	return ret;
}
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	5b                   	pop    %ebx
  800a79:	5e                   	pop    %esi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 75 08             	mov    0x8(%ebp),%esi
  800a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a8a:	89 f0                	mov    %esi,%eax
  800a8c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a90:	85 c9                	test   %ecx,%ecx
  800a92:	75 0b                	jne    800a9f <strlcpy+0x23>
  800a94:	eb 17                	jmp    800aad <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a96:	83 c2 01             	add    $0x1,%edx
  800a99:	83 c0 01             	add    $0x1,%eax
  800a9c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a9f:	39 d8                	cmp    %ebx,%eax
  800aa1:	74 07                	je     800aaa <strlcpy+0x2e>
  800aa3:	0f b6 0a             	movzbl (%edx),%ecx
  800aa6:	84 c9                	test   %cl,%cl
  800aa8:	75 ec                	jne    800a96 <strlcpy+0x1a>
		*dst = '\0';
  800aaa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aad:	29 f0                	sub    %esi,%eax
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800abc:	eb 06                	jmp    800ac4 <strcmp+0x11>
		p++, q++;
  800abe:	83 c1 01             	add    $0x1,%ecx
  800ac1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ac4:	0f b6 01             	movzbl (%ecx),%eax
  800ac7:	84 c0                	test   %al,%al
  800ac9:	74 04                	je     800acf <strcmp+0x1c>
  800acb:	3a 02                	cmp    (%edx),%al
  800acd:	74 ef                	je     800abe <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800acf:	0f b6 c0             	movzbl %al,%eax
  800ad2:	0f b6 12             	movzbl (%edx),%edx
  800ad5:	29 d0                	sub    %edx,%eax
}
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	53                   	push   %ebx
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae3:	89 c3                	mov    %eax,%ebx
  800ae5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ae8:	eb 06                	jmp    800af0 <strncmp+0x17>
		n--, p++, q++;
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800af0:	39 d8                	cmp    %ebx,%eax
  800af2:	74 16                	je     800b0a <strncmp+0x31>
  800af4:	0f b6 08             	movzbl (%eax),%ecx
  800af7:	84 c9                	test   %cl,%cl
  800af9:	74 04                	je     800aff <strncmp+0x26>
  800afb:	3a 0a                	cmp    (%edx),%cl
  800afd:	74 eb                	je     800aea <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aff:	0f b6 00             	movzbl (%eax),%eax
  800b02:	0f b6 12             	movzbl (%edx),%edx
  800b05:	29 d0                	sub    %edx,%eax
}
  800b07:	5b                   	pop    %ebx
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    
		return 0;
  800b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0f:	eb f6                	jmp    800b07 <strncmp+0x2e>

00800b11 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1b:	0f b6 10             	movzbl (%eax),%edx
  800b1e:	84 d2                	test   %dl,%dl
  800b20:	74 09                	je     800b2b <strchr+0x1a>
		if (*s == c)
  800b22:	38 ca                	cmp    %cl,%dl
  800b24:	74 0a                	je     800b30 <strchr+0x1f>
	for (; *s; s++)
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	eb f0                	jmp    800b1b <strchr+0xa>
			return (char *) s;
	return 0;
  800b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3c:	eb 03                	jmp    800b41 <strfind+0xf>
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b44:	38 ca                	cmp    %cl,%dl
  800b46:	74 04                	je     800b4c <strfind+0x1a>
  800b48:	84 d2                	test   %dl,%dl
  800b4a:	75 f2                	jne    800b3e <strfind+0xc>
			break;
	return (char *) s;
}
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b5a:	85 c9                	test   %ecx,%ecx
  800b5c:	74 13                	je     800b71 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b5e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b64:	75 05                	jne    800b6b <memset+0x1d>
  800b66:	f6 c1 03             	test   $0x3,%cl
  800b69:	74 0d                	je     800b78 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6e:	fc                   	cld    
  800b6f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b71:	89 f8                	mov    %edi,%eax
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    
		c &= 0xFF;
  800b78:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b7c:	89 d3                	mov    %edx,%ebx
  800b7e:	c1 e3 08             	shl    $0x8,%ebx
  800b81:	89 d0                	mov    %edx,%eax
  800b83:	c1 e0 18             	shl    $0x18,%eax
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	c1 e6 10             	shl    $0x10,%esi
  800b8b:	09 f0                	or     %esi,%eax
  800b8d:	09 c2                	or     %eax,%edx
  800b8f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b91:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b94:	89 d0                	mov    %edx,%eax
  800b96:	fc                   	cld    
  800b97:	f3 ab                	rep stos %eax,%es:(%edi)
  800b99:	eb d6                	jmp    800b71 <memset+0x23>

00800b9b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba9:	39 c6                	cmp    %eax,%esi
  800bab:	73 35                	jae    800be2 <memmove+0x47>
  800bad:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	76 2e                	jbe    800be2 <memmove+0x47>
		s += n;
		d += n;
  800bb4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb7:	89 d6                	mov    %edx,%esi
  800bb9:	09 fe                	or     %edi,%esi
  800bbb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bc1:	74 0c                	je     800bcf <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bc3:	83 ef 01             	sub    $0x1,%edi
  800bc6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bc9:	fd                   	std    
  800bca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bcc:	fc                   	cld    
  800bcd:	eb 21                	jmp    800bf0 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcf:	f6 c1 03             	test   $0x3,%cl
  800bd2:	75 ef                	jne    800bc3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bd4:	83 ef 04             	sub    $0x4,%edi
  800bd7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bda:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bdd:	fd                   	std    
  800bde:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800be0:	eb ea                	jmp    800bcc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be2:	89 f2                	mov    %esi,%edx
  800be4:	09 c2                	or     %eax,%edx
  800be6:	f6 c2 03             	test   $0x3,%dl
  800be9:	74 09                	je     800bf4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800beb:	89 c7                	mov    %eax,%edi
  800bed:	fc                   	cld    
  800bee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf4:	f6 c1 03             	test   $0x3,%cl
  800bf7:	75 f2                	jne    800beb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bf9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bfc:	89 c7                	mov    %eax,%edi
  800bfe:	fc                   	cld    
  800bff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c01:	eb ed                	jmp    800bf0 <memmove+0x55>

00800c03 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c06:	ff 75 10             	pushl  0x10(%ebp)
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 87 ff ff ff       	call   800b9b <memmove>
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	56                   	push   %esi
  800c1a:	53                   	push   %ebx
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c21:	89 c6                	mov    %eax,%esi
  800c23:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c26:	39 f0                	cmp    %esi,%eax
  800c28:	74 1c                	je     800c46 <memcmp+0x30>
		if (*s1 != *s2)
  800c2a:	0f b6 08             	movzbl (%eax),%ecx
  800c2d:	0f b6 1a             	movzbl (%edx),%ebx
  800c30:	38 d9                	cmp    %bl,%cl
  800c32:	75 08                	jne    800c3c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c34:	83 c0 01             	add    $0x1,%eax
  800c37:	83 c2 01             	add    $0x1,%edx
  800c3a:	eb ea                	jmp    800c26 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c3c:	0f b6 c1             	movzbl %cl,%eax
  800c3f:	0f b6 db             	movzbl %bl,%ebx
  800c42:	29 d8                	sub    %ebx,%eax
  800c44:	eb 05                	jmp    800c4b <memcmp+0x35>
	}

	return 0;
  800c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4b:	5b                   	pop    %ebx
  800c4c:	5e                   	pop    %esi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c58:	89 c2                	mov    %eax,%edx
  800c5a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c5d:	39 d0                	cmp    %edx,%eax
  800c5f:	73 09                	jae    800c6a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c61:	38 08                	cmp    %cl,(%eax)
  800c63:	74 05                	je     800c6a <memfind+0x1b>
	for (; s < ends; s++)
  800c65:	83 c0 01             	add    $0x1,%eax
  800c68:	eb f3                	jmp    800c5d <memfind+0xe>
			break;
	return (void *) s;
}
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c78:	eb 03                	jmp    800c7d <strtol+0x11>
		s++;
  800c7a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c7d:	0f b6 01             	movzbl (%ecx),%eax
  800c80:	3c 20                	cmp    $0x20,%al
  800c82:	74 f6                	je     800c7a <strtol+0xe>
  800c84:	3c 09                	cmp    $0x9,%al
  800c86:	74 f2                	je     800c7a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c88:	3c 2b                	cmp    $0x2b,%al
  800c8a:	74 2e                	je     800cba <strtol+0x4e>
	int neg = 0;
  800c8c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c91:	3c 2d                	cmp    $0x2d,%al
  800c93:	74 2f                	je     800cc4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c95:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c9b:	75 05                	jne    800ca2 <strtol+0x36>
  800c9d:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca0:	74 2c                	je     800cce <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ca2:	85 db                	test   %ebx,%ebx
  800ca4:	75 0a                	jne    800cb0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cab:	80 39 30             	cmpb   $0x30,(%ecx)
  800cae:	74 28                	je     800cd8 <strtol+0x6c>
		base = 10;
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb8:	eb 50                	jmp    800d0a <strtol+0x9e>
		s++;
  800cba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc2:	eb d1                	jmp    800c95 <strtol+0x29>
		s++, neg = 1;
  800cc4:	83 c1 01             	add    $0x1,%ecx
  800cc7:	bf 01 00 00 00       	mov    $0x1,%edi
  800ccc:	eb c7                	jmp    800c95 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cce:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd2:	74 0e                	je     800ce2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cd4:	85 db                	test   %ebx,%ebx
  800cd6:	75 d8                	jne    800cb0 <strtol+0x44>
		s++, base = 8;
  800cd8:	83 c1 01             	add    $0x1,%ecx
  800cdb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ce0:	eb ce                	jmp    800cb0 <strtol+0x44>
		s += 2, base = 16;
  800ce2:	83 c1 02             	add    $0x2,%ecx
  800ce5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cea:	eb c4                	jmp    800cb0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cef:	89 f3                	mov    %esi,%ebx
  800cf1:	80 fb 19             	cmp    $0x19,%bl
  800cf4:	77 29                	ja     800d1f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cf6:	0f be d2             	movsbl %dl,%edx
  800cf9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cfc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cff:	7d 30                	jge    800d31 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d01:	83 c1 01             	add    $0x1,%ecx
  800d04:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d08:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0a:	0f b6 11             	movzbl (%ecx),%edx
  800d0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d10:	89 f3                	mov    %esi,%ebx
  800d12:	80 fb 09             	cmp    $0x9,%bl
  800d15:	77 d5                	ja     800cec <strtol+0x80>
			dig = *s - '0';
  800d17:	0f be d2             	movsbl %dl,%edx
  800d1a:	83 ea 30             	sub    $0x30,%edx
  800d1d:	eb dd                	jmp    800cfc <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d1f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d22:	89 f3                	mov    %esi,%ebx
  800d24:	80 fb 19             	cmp    $0x19,%bl
  800d27:	77 08                	ja     800d31 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d29:	0f be d2             	movsbl %dl,%edx
  800d2c:	83 ea 37             	sub    $0x37,%edx
  800d2f:	eb cb                	jmp    800cfc <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d35:	74 05                	je     800d3c <strtol+0xd0>
		*endptr = (char *) s;
  800d37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3c:	89 c2                	mov    %eax,%edx
  800d3e:	f7 da                	neg    %edx
  800d40:	85 ff                	test   %edi,%edi
  800d42:	0f 45 c2             	cmovne %edx,%eax
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	89 c3                	mov    %eax,%ebx
  800d5d:	89 c7                	mov    %eax,%edi
  800d5f:	89 c6                	mov    %eax,%esi
  800d61:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5f                   	pop    %edi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d73:	b8 01 00 00 00       	mov    $0x1,%eax
  800d78:	89 d1                	mov    %edx,%ecx
  800d7a:	89 d3                	mov    %edx,%ebx
  800d7c:	89 d7                	mov    %edx,%edi
  800d7e:	89 d6                	mov    %edx,%esi
  800d80:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9d:	89 cb                	mov    %ecx,%ebx
  800d9f:	89 cf                	mov    %ecx,%edi
  800da1:	89 ce                	mov    %ecx,%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 03                	push   $0x3
  800db7:	68 9f 2c 80 00       	push   $0x802c9f
  800dbc:	6a 23                	push   $0x23
  800dbe:	68 bc 2c 80 00       	push   $0x802cbc
  800dc3:	e8 cd f4 ff ff       	call   800295 <_panic>

00800dc8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd8:	89 d1                	mov    %edx,%ecx
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	89 d6                	mov    %edx,%esi
  800de0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_yield>:

void
sys_yield(void)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ded:	ba 00 00 00 00       	mov    $0x0,%edx
  800df2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800df7:	89 d1                	mov    %edx,%ecx
  800df9:	89 d3                	mov    %edx,%ebx
  800dfb:	89 d7                	mov    %edx,%edi
  800dfd:	89 d6                	mov    %edx,%esi
  800dff:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	be 00 00 00 00       	mov    $0x0,%esi
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e22:	89 f7                	mov    %esi,%edi
  800e24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 04                	push   $0x4
  800e38:	68 9f 2c 80 00       	push   $0x802c9f
  800e3d:	6a 23                	push   $0x23
  800e3f:	68 bc 2c 80 00       	push   $0x802cbc
  800e44:	e8 4c f4 ff ff       	call   800295 <_panic>

00800e49 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e60:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e63:	8b 75 18             	mov    0x18(%ebp),%esi
  800e66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7f 08                	jg     800e74 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	50                   	push   %eax
  800e78:	6a 05                	push   $0x5
  800e7a:	68 9f 2c 80 00       	push   $0x802c9f
  800e7f:	6a 23                	push   $0x23
  800e81:	68 bc 2c 80 00       	push   $0x802cbc
  800e86:	e8 0a f4 ff ff       	call   800295 <_panic>

00800e8b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea4:	89 df                	mov    %ebx,%edi
  800ea6:	89 de                	mov    %ebx,%esi
  800ea8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 06                	push   $0x6
  800ebc:	68 9f 2c 80 00       	push   $0x802c9f
  800ec1:	6a 23                	push   $0x23
  800ec3:	68 bc 2c 80 00       	push   $0x802cbc
  800ec8:	e8 c8 f3 ff ff       	call   800295 <_panic>

00800ecd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 08                	push   $0x8
  800efe:	68 9f 2c 80 00       	push   $0x802c9f
  800f03:	6a 23                	push   $0x23
  800f05:	68 bc 2c 80 00       	push   $0x802cbc
  800f0a:	e8 86 f3 ff ff       	call   800295 <_panic>

00800f0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 09 00 00 00       	mov    $0x9,%eax
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7f 08                	jg     800f3a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	50                   	push   %eax
  800f3e:	6a 09                	push   $0x9
  800f40:	68 9f 2c 80 00       	push   $0x802c9f
  800f45:	6a 23                	push   $0x23
  800f47:	68 bc 2c 80 00       	push   $0x802cbc
  800f4c:	e8 44 f3 ff ff       	call   800295 <_panic>

00800f51 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6a:	89 df                	mov    %ebx,%edi
  800f6c:	89 de                	mov    %ebx,%esi
  800f6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	7f 08                	jg     800f7c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	50                   	push   %eax
  800f80:	6a 0a                	push   $0xa
  800f82:	68 9f 2c 80 00       	push   $0x802c9f
  800f87:	6a 23                	push   $0x23
  800f89:	68 bc 2c 80 00       	push   $0x802cbc
  800f8e:	e8 02 f3 ff ff       	call   800295 <_panic>

00800f93 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fa4:	be 00 00 00 00       	mov    $0x0,%esi
  800fa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800faf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fcc:	89 cb                	mov    %ecx,%ebx
  800fce:	89 cf                	mov    %ecx,%edi
  800fd0:	89 ce                	mov    %ecx,%esi
  800fd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7f 08                	jg     800fe0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	50                   	push   %eax
  800fe4:	6a 0d                	push   $0xd
  800fe6:	68 9f 2c 80 00       	push   $0x802c9f
  800feb:	6a 23                	push   $0x23
  800fed:	68 bc 2c 80 00       	push   $0x802cbc
  800ff2:	e8 9e f2 ff ff       	call   800295 <_panic>

00800ff7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffd:	ba 00 00 00 00       	mov    $0x0,%edx
  801002:	b8 0e 00 00 00       	mov    $0xe,%eax
  801007:	89 d1                	mov    %edx,%ecx
  801009:	89 d3                	mov    %edx,%ebx
  80100b:	89 d7                	mov    %edx,%edi
  80100d:	89 d6                	mov    %edx,%esi
  80100f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
  80101c:	83 ec 1c             	sub    $0x1c,%esp
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  801022:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  801024:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  801027:	89 d8                	mov    %ebx,%eax
  801029:	c1 e8 0c             	shr    $0xc,%eax
  80102c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  801036:	e8 8d fd ff ff       	call   800dc8 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  80103b:	f7 c7 02 00 00 00    	test   $0x2,%edi
  801041:	74 73                	je     8010b6 <pgfault+0xa0>
  801043:	89 c6                	mov    %eax,%esi
  801045:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  80104c:	74 68                	je     8010b6 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  80104e:	83 ec 04             	sub    $0x4,%esp
  801051:	6a 07                	push   $0x7
  801053:	68 00 f0 7f 00       	push   $0x7ff000
  801058:	50                   	push   %eax
  801059:	e8 a8 fd ff ff       	call   800e06 <sys_page_alloc>
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	75 65                	jne    8010ca <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801065:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80106b:	83 ec 04             	sub    $0x4,%esp
  80106e:	68 00 10 00 00       	push   $0x1000
  801073:	53                   	push   %ebx
  801074:	68 00 f0 7f 00       	push   $0x7ff000
  801079:	e8 85 fb ff ff       	call   800c03 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80107e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801085:	53                   	push   %ebx
  801086:	56                   	push   %esi
  801087:	68 00 f0 7f 00       	push   $0x7ff000
  80108c:	56                   	push   %esi
  80108d:	e8 b7 fd ff ff       	call   800e49 <sys_page_map>
  801092:	83 c4 20             	add    $0x20,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	75 43                	jne    8010dc <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  801099:	83 ec 08             	sub    $0x8,%esp
  80109c:	68 00 f0 7f 00       	push   $0x7ff000
  8010a1:	56                   	push   %esi
  8010a2:	e8 e4 fd ff ff       	call   800e8b <sys_page_unmap>
  8010a7:	83 c4 10             	add    $0x10,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 40                	jne    8010ee <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  8010ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  8010b6:	83 ec 04             	sub    $0x4,%esp
  8010b9:	68 ca 2c 80 00       	push   $0x802cca
  8010be:	6a 1f                	push   $0x1f
  8010c0:	68 e8 2c 80 00       	push   $0x802ce8
  8010c5:	e8 cb f1 ff ff       	call   800295 <_panic>
	    panic("pgfault: %e", r);
  8010ca:	50                   	push   %eax
  8010cb:	68 f3 2c 80 00       	push   $0x802cf3
  8010d0:	6a 2a                	push   $0x2a
  8010d2:	68 e8 2c 80 00       	push   $0x802ce8
  8010d7:	e8 b9 f1 ff ff       	call   800295 <_panic>
	    panic("pgfault: %e", r);
  8010dc:	50                   	push   %eax
  8010dd:	68 f3 2c 80 00       	push   $0x802cf3
  8010e2:	6a 2e                	push   $0x2e
  8010e4:	68 e8 2c 80 00       	push   $0x802ce8
  8010e9:	e8 a7 f1 ff ff       	call   800295 <_panic>
	    panic("pgfault: %e", r);
  8010ee:	50                   	push   %eax
  8010ef:	68 f3 2c 80 00       	push   $0x802cf3
  8010f4:	6a 31                	push   $0x31
  8010f6:	68 e8 2c 80 00       	push   $0x802ce8
  8010fb:	e8 95 f1 ff ff       	call   800295 <_panic>

00801100 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  801109:	68 16 10 80 00       	push   $0x801016
  80110e:	e8 8e 13 00 00       	call   8024a1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801113:	b8 07 00 00 00       	mov    $0x7,%eax
  801118:	cd 30                	int    $0x30
  80111a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80111d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	78 2b                	js     801152 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801127:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  80112c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801130:	0f 85 b5 00 00 00    	jne    8011eb <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  801136:	e8 8d fc ff ff       	call   800dc8 <sys_getenvid>
  80113b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801140:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801143:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801148:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  80114d:	e9 8c 01 00 00       	jmp    8012de <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  801152:	50                   	push   %eax
  801153:	68 ff 2c 80 00       	push   $0x802cff
  801158:	6a 77                	push   $0x77
  80115a:	68 e8 2c 80 00       	push   $0x802ce8
  80115f:	e8 31 f1 ff ff       	call   800295 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801164:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	25 07 0e 00 00       	and    $0xe07,%eax
  801173:	50                   	push   %eax
  801174:	57                   	push   %edi
  801175:	ff 75 e0             	pushl  -0x20(%ebp)
  801178:	57                   	push   %edi
  801179:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117c:	e8 c8 fc ff ff       	call   800e49 <sys_page_map>
  801181:	83 c4 20             	add    $0x20,%esp
  801184:	85 c0                	test   %eax,%eax
  801186:	74 51                	je     8011d9 <fork+0xd9>
           panic("duppage: %e", r);
  801188:	50                   	push   %eax
  801189:	68 0f 2d 80 00       	push   $0x802d0f
  80118e:	6a 4a                	push   $0x4a
  801190:	68 e8 2c 80 00       	push   $0x802ce8
  801195:	e8 fb f0 ff ff       	call   800295 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	68 05 08 00 00       	push   $0x805
  8011a2:	57                   	push   %edi
  8011a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8011a6:	57                   	push   %edi
  8011a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011aa:	e8 9a fc ff ff       	call   800e49 <sys_page_map>
  8011af:	83 c4 20             	add    $0x20,%esp
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	0f 85 bc 00 00 00    	jne    801276 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	68 05 08 00 00       	push   $0x805
  8011c2:	57                   	push   %edi
  8011c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c6:	50                   	push   %eax
  8011c7:	57                   	push   %edi
  8011c8:	50                   	push   %eax
  8011c9:	e8 7b fc ff ff       	call   800e49 <sys_page_map>
  8011ce:	83 c4 20             	add    $0x20,%esp
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	0f 85 af 00 00 00    	jne    801288 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8011d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011df:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011e5:	0f 84 af 00 00 00    	je     80129a <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  8011eb:	89 d8                	mov    %ebx,%eax
  8011ed:	c1 e8 16             	shr    $0x16,%eax
  8011f0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f7:	a8 01                	test   $0x1,%al
  8011f9:	74 de                	je     8011d9 <fork+0xd9>
  8011fb:	89 de                	mov    %ebx,%esi
  8011fd:	c1 ee 0c             	shr    $0xc,%esi
  801200:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801207:	a8 01                	test   $0x1,%al
  801209:	74 ce                	je     8011d9 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  80120b:	e8 b8 fb ff ff       	call   800dc8 <sys_getenvid>
  801210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  801213:	89 f7                	mov    %esi,%edi
  801215:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801218:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80121f:	f6 c4 04             	test   $0x4,%ah
  801222:	0f 85 3c ff ff ff    	jne    801164 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801228:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80122f:	a8 02                	test   $0x2,%al
  801231:	0f 85 63 ff ff ff    	jne    80119a <fork+0x9a>
  801237:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80123e:	f6 c4 08             	test   $0x8,%ah
  801241:	0f 85 53 ff ff ff    	jne    80119a <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	6a 05                	push   $0x5
  80124c:	57                   	push   %edi
  80124d:	ff 75 e0             	pushl  -0x20(%ebp)
  801250:	57                   	push   %edi
  801251:	ff 75 e4             	pushl  -0x1c(%ebp)
  801254:	e8 f0 fb ff ff       	call   800e49 <sys_page_map>
  801259:	83 c4 20             	add    $0x20,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	0f 84 75 ff ff ff    	je     8011d9 <fork+0xd9>
	        panic("duppage: %e", r);
  801264:	50                   	push   %eax
  801265:	68 0f 2d 80 00       	push   $0x802d0f
  80126a:	6a 55                	push   $0x55
  80126c:	68 e8 2c 80 00       	push   $0x802ce8
  801271:	e8 1f f0 ff ff       	call   800295 <_panic>
	        panic("duppage: %e", r);
  801276:	50                   	push   %eax
  801277:	68 0f 2d 80 00       	push   $0x802d0f
  80127c:	6a 4e                	push   $0x4e
  80127e:	68 e8 2c 80 00       	push   $0x802ce8
  801283:	e8 0d f0 ff ff       	call   800295 <_panic>
	        panic("duppage: %e", r);
  801288:	50                   	push   %eax
  801289:	68 0f 2d 80 00       	push   $0x802d0f
  80128e:	6a 51                	push   $0x51
  801290:	68 e8 2c 80 00       	push   $0x802ce8
  801295:	e8 fb ef ff ff       	call   800295 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80129a:	83 ec 04             	sub    $0x4,%esp
  80129d:	6a 07                	push   $0x7
  80129f:	68 00 f0 bf ee       	push   $0xeebff000
  8012a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8012a7:	e8 5a fb ff ff       	call   800e06 <sys_page_alloc>
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	75 36                	jne    8012e9 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	68 1a 25 80 00       	push   $0x80251a
  8012bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8012be:	e8 8e fc ff ff       	call   800f51 <sys_env_set_pgfault_upcall>
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	75 34                	jne    8012fe <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	6a 02                	push   $0x2
  8012cf:	ff 75 dc             	pushl  -0x24(%ebp)
  8012d2:	e8 f6 fb ff ff       	call   800ecd <sys_env_set_status>
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	75 35                	jne    801313 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  8012de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    
	    panic("fork: %e", r);
  8012e9:	50                   	push   %eax
  8012ea:	68 06 2d 80 00       	push   $0x802d06
  8012ef:	68 8a 00 00 00       	push   $0x8a
  8012f4:	68 e8 2c 80 00       	push   $0x802ce8
  8012f9:	e8 97 ef ff ff       	call   800295 <_panic>
	    panic("fork: %e", r);
  8012fe:	50                   	push   %eax
  8012ff:	68 06 2d 80 00       	push   $0x802d06
  801304:	68 8d 00 00 00       	push   $0x8d
  801309:	68 e8 2c 80 00       	push   $0x802ce8
  80130e:	e8 82 ef ff ff       	call   800295 <_panic>
	    panic("fork: %e", r);
  801313:	50                   	push   %eax
  801314:	68 06 2d 80 00       	push   $0x802d06
  801319:	68 92 00 00 00       	push   $0x92
  80131e:	68 e8 2c 80 00       	push   $0x802ce8
  801323:	e8 6d ef ff ff       	call   800295 <_panic>

00801328 <sfork>:

// Challenge!
int
sfork(void)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80132e:	68 1b 2d 80 00       	push   $0x802d1b
  801333:	68 9b 00 00 00       	push   $0x9b
  801338:	68 e8 2c 80 00       	push   $0x802ce8
  80133d:	e8 53 ef ff ff       	call   800295 <_panic>

00801342 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	05 00 00 00 30       	add    $0x30000000,%eax
  80134d:	c1 e8 0c             	shr    $0xc,%eax
}
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80135d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801362:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801374:	89 c2                	mov    %eax,%edx
  801376:	c1 ea 16             	shr    $0x16,%edx
  801379:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801380:	f6 c2 01             	test   $0x1,%dl
  801383:	74 2a                	je     8013af <fd_alloc+0x46>
  801385:	89 c2                	mov    %eax,%edx
  801387:	c1 ea 0c             	shr    $0xc,%edx
  80138a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801391:	f6 c2 01             	test   $0x1,%dl
  801394:	74 19                	je     8013af <fd_alloc+0x46>
  801396:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80139b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013a0:	75 d2                	jne    801374 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013a2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013a8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013ad:	eb 07                	jmp    8013b6 <fd_alloc+0x4d>
			*fd_store = fd;
  8013af:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013be:	83 f8 1f             	cmp    $0x1f,%eax
  8013c1:	77 36                	ja     8013f9 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013c3:	c1 e0 0c             	shl    $0xc,%eax
  8013c6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013cb:	89 c2                	mov    %eax,%edx
  8013cd:	c1 ea 16             	shr    $0x16,%edx
  8013d0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d7:	f6 c2 01             	test   $0x1,%dl
  8013da:	74 24                	je     801400 <fd_lookup+0x48>
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	c1 ea 0c             	shr    $0xc,%edx
  8013e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e8:	f6 c2 01             	test   $0x1,%dl
  8013eb:	74 1a                	je     801407 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f0:	89 02                	mov    %eax,(%edx)
	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	5d                   	pop    %ebp
  8013f8:	c3                   	ret    
		return -E_INVAL;
  8013f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fe:	eb f7                	jmp    8013f7 <fd_lookup+0x3f>
		return -E_INVAL;
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801405:	eb f0                	jmp    8013f7 <fd_lookup+0x3f>
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb e9                	jmp    8013f7 <fd_lookup+0x3f>

0080140e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 08             	sub    $0x8,%esp
  801414:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801417:	ba b0 2d 80 00       	mov    $0x802db0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80141c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801421:	39 08                	cmp    %ecx,(%eax)
  801423:	74 33                	je     801458 <dev_lookup+0x4a>
  801425:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801428:	8b 02                	mov    (%edx),%eax
  80142a:	85 c0                	test   %eax,%eax
  80142c:	75 f3                	jne    801421 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80142e:	a1 08 40 80 00       	mov    0x804008,%eax
  801433:	8b 40 48             	mov    0x48(%eax),%eax
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	51                   	push   %ecx
  80143a:	50                   	push   %eax
  80143b:	68 34 2d 80 00       	push   $0x802d34
  801440:	e8 2b ef ff ff       	call   800370 <cprintf>
	*dev = 0;
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    
			*dev = devtab[i];
  801458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	eb f2                	jmp    801456 <dev_lookup+0x48>

00801464 <fd_close>:
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 1c             	sub    $0x1c,%esp
  80146d:	8b 75 08             	mov    0x8(%ebp),%esi
  801470:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801473:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801476:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801477:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80147d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801480:	50                   	push   %eax
  801481:	e8 32 ff ff ff       	call   8013b8 <fd_lookup>
  801486:	89 c3                	mov    %eax,%ebx
  801488:	83 c4 08             	add    $0x8,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 05                	js     801494 <fd_close+0x30>
	    || fd != fd2)
  80148f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801492:	74 16                	je     8014aa <fd_close+0x46>
		return (must_exist ? r : 0);
  801494:	89 f8                	mov    %edi,%eax
  801496:	84 c0                	test   %al,%al
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
  80149d:	0f 44 d8             	cmove  %eax,%ebx
}
  8014a0:	89 d8                	mov    %ebx,%eax
  8014a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5e                   	pop    %esi
  8014a7:	5f                   	pop    %edi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	ff 36                	pushl  (%esi)
  8014b3:	e8 56 ff ff ff       	call   80140e <dev_lookup>
  8014b8:	89 c3                	mov    %eax,%ebx
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 15                	js     8014d6 <fd_close+0x72>
		if (dev->dev_close)
  8014c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c4:	8b 40 10             	mov    0x10(%eax),%eax
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	74 1b                	je     8014e6 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8014cb:	83 ec 0c             	sub    $0xc,%esp
  8014ce:	56                   	push   %esi
  8014cf:	ff d0                	call   *%eax
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	56                   	push   %esi
  8014da:	6a 00                	push   $0x0
  8014dc:	e8 aa f9 ff ff       	call   800e8b <sys_page_unmap>
	return r;
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	eb ba                	jmp    8014a0 <fd_close+0x3c>
			r = 0;
  8014e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014eb:	eb e9                	jmp    8014d6 <fd_close+0x72>

008014ed <close>:

int
close(int fdnum)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 b9 fe ff ff       	call   8013b8 <fd_lookup>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 10                	js     801516 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801506:	83 ec 08             	sub    $0x8,%esp
  801509:	6a 01                	push   $0x1
  80150b:	ff 75 f4             	pushl  -0xc(%ebp)
  80150e:	e8 51 ff ff ff       	call   801464 <fd_close>
  801513:	83 c4 10             	add    $0x10,%esp
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <close_all>:

void
close_all(void)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	53                   	push   %ebx
  80151c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80151f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801524:	83 ec 0c             	sub    $0xc,%esp
  801527:	53                   	push   %ebx
  801528:	e8 c0 ff ff ff       	call   8014ed <close>
	for (i = 0; i < MAXFD; i++)
  80152d:	83 c3 01             	add    $0x1,%ebx
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	83 fb 20             	cmp    $0x20,%ebx
  801536:	75 ec                	jne    801524 <close_all+0xc>
}
  801538:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	57                   	push   %edi
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801546:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 08             	pushl  0x8(%ebp)
  80154d:	e8 66 fe ff ff       	call   8013b8 <fd_lookup>
  801552:	89 c3                	mov    %eax,%ebx
  801554:	83 c4 08             	add    $0x8,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	0f 88 81 00 00 00    	js     8015e0 <dup+0xa3>
		return r;
	close(newfdnum);
  80155f:	83 ec 0c             	sub    $0xc,%esp
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	e8 83 ff ff ff       	call   8014ed <close>

	newfd = INDEX2FD(newfdnum);
  80156a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80156d:	c1 e6 0c             	shl    $0xc,%esi
  801570:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801576:	83 c4 04             	add    $0x4,%esp
  801579:	ff 75 e4             	pushl  -0x1c(%ebp)
  80157c:	e8 d1 fd ff ff       	call   801352 <fd2data>
  801581:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801583:	89 34 24             	mov    %esi,(%esp)
  801586:	e8 c7 fd ff ff       	call   801352 <fd2data>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801590:	89 d8                	mov    %ebx,%eax
  801592:	c1 e8 16             	shr    $0x16,%eax
  801595:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80159c:	a8 01                	test   $0x1,%al
  80159e:	74 11                	je     8015b1 <dup+0x74>
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	c1 e8 0c             	shr    $0xc,%eax
  8015a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015ac:	f6 c2 01             	test   $0x1,%dl
  8015af:	75 39                	jne    8015ea <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	c1 e8 0c             	shr    $0xc,%eax
  8015b9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c8:	50                   	push   %eax
  8015c9:	56                   	push   %esi
  8015ca:	6a 00                	push   $0x0
  8015cc:	52                   	push   %edx
  8015cd:	6a 00                	push   $0x0
  8015cf:	e8 75 f8 ff ff       	call   800e49 <sys_page_map>
  8015d4:	89 c3                	mov    %eax,%ebx
  8015d6:	83 c4 20             	add    $0x20,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 31                	js     80160e <dup+0xd1>
		goto err;

	return newfdnum;
  8015dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5f                   	pop    %edi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f9:	50                   	push   %eax
  8015fa:	57                   	push   %edi
  8015fb:	6a 00                	push   $0x0
  8015fd:	53                   	push   %ebx
  8015fe:	6a 00                	push   $0x0
  801600:	e8 44 f8 ff ff       	call   800e49 <sys_page_map>
  801605:	89 c3                	mov    %eax,%ebx
  801607:	83 c4 20             	add    $0x20,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	79 a3                	jns    8015b1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	56                   	push   %esi
  801612:	6a 00                	push   $0x0
  801614:	e8 72 f8 ff ff       	call   800e8b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801619:	83 c4 08             	add    $0x8,%esp
  80161c:	57                   	push   %edi
  80161d:	6a 00                	push   $0x0
  80161f:	e8 67 f8 ff ff       	call   800e8b <sys_page_unmap>
	return r;
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	eb b7                	jmp    8015e0 <dup+0xa3>

00801629 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	53                   	push   %ebx
  80162d:	83 ec 14             	sub    $0x14,%esp
  801630:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801633:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801636:	50                   	push   %eax
  801637:	53                   	push   %ebx
  801638:	e8 7b fd ff ff       	call   8013b8 <fd_lookup>
  80163d:	83 c4 08             	add    $0x8,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 3f                	js     801683 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164a:	50                   	push   %eax
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	ff 30                	pushl  (%eax)
  801650:	e8 b9 fd ff ff       	call   80140e <dev_lookup>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 27                	js     801683 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80165c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165f:	8b 42 08             	mov    0x8(%edx),%eax
  801662:	83 e0 03             	and    $0x3,%eax
  801665:	83 f8 01             	cmp    $0x1,%eax
  801668:	74 1e                	je     801688 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 40 08             	mov    0x8(%eax),%eax
  801670:	85 c0                	test   %eax,%eax
  801672:	74 35                	je     8016a9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	ff 75 10             	pushl  0x10(%ebp)
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	52                   	push   %edx
  80167e:	ff d0                	call   *%eax
  801680:	83 c4 10             	add    $0x10,%esp
}
  801683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801686:	c9                   	leave  
  801687:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801688:	a1 08 40 80 00       	mov    0x804008,%eax
  80168d:	8b 40 48             	mov    0x48(%eax),%eax
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	53                   	push   %ebx
  801694:	50                   	push   %eax
  801695:	68 75 2d 80 00       	push   $0x802d75
  80169a:	e8 d1 ec ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a7:	eb da                	jmp    801683 <read+0x5a>
		return -E_NOT_SUPP;
  8016a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ae:	eb d3                	jmp    801683 <read+0x5a>

008016b0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016bc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c4:	39 f3                	cmp    %esi,%ebx
  8016c6:	73 25                	jae    8016ed <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	89 f0                	mov    %esi,%eax
  8016cd:	29 d8                	sub    %ebx,%eax
  8016cf:	50                   	push   %eax
  8016d0:	89 d8                	mov    %ebx,%eax
  8016d2:	03 45 0c             	add    0xc(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	57                   	push   %edi
  8016d7:	e8 4d ff ff ff       	call   801629 <read>
		if (m < 0)
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 08                	js     8016eb <readn+0x3b>
			return m;
		if (m == 0)
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	74 06                	je     8016ed <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8016e7:	01 c3                	add    %eax,%ebx
  8016e9:	eb d9                	jmp    8016c4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016eb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	53                   	push   %ebx
  8016fb:	83 ec 14             	sub    $0x14,%esp
  8016fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801704:	50                   	push   %eax
  801705:	53                   	push   %ebx
  801706:	e8 ad fc ff ff       	call   8013b8 <fd_lookup>
  80170b:	83 c4 08             	add    $0x8,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 3a                	js     80174c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801718:	50                   	push   %eax
  801719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171c:	ff 30                	pushl  (%eax)
  80171e:	e8 eb fc ff ff       	call   80140e <dev_lookup>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	78 22                	js     80174c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801731:	74 1e                	je     801751 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801736:	8b 52 0c             	mov    0xc(%edx),%edx
  801739:	85 d2                	test   %edx,%edx
  80173b:	74 35                	je     801772 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	ff 75 10             	pushl  0x10(%ebp)
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	50                   	push   %eax
  801747:	ff d2                	call   *%edx
  801749:	83 c4 10             	add    $0x10,%esp
}
  80174c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174f:	c9                   	leave  
  801750:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801751:	a1 08 40 80 00       	mov    0x804008,%eax
  801756:	8b 40 48             	mov    0x48(%eax),%eax
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	53                   	push   %ebx
  80175d:	50                   	push   %eax
  80175e:	68 91 2d 80 00       	push   $0x802d91
  801763:	e8 08 ec ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801770:	eb da                	jmp    80174c <write+0x55>
		return -E_NOT_SUPP;
  801772:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801777:	eb d3                	jmp    80174c <write+0x55>

00801779 <seek>:

int
seek(int fdnum, off_t offset)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80177f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801782:	50                   	push   %eax
  801783:	ff 75 08             	pushl  0x8(%ebp)
  801786:	e8 2d fc ff ff       	call   8013b8 <fd_lookup>
  80178b:	83 c4 08             	add    $0x8,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 0e                	js     8017a0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801798:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 14             	sub    $0x14,%esp
  8017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017af:	50                   	push   %eax
  8017b0:	53                   	push   %ebx
  8017b1:	e8 02 fc ff ff       	call   8013b8 <fd_lookup>
  8017b6:	83 c4 08             	add    $0x8,%esp
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 37                	js     8017f4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c3:	50                   	push   %eax
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c7:	ff 30                	pushl  (%eax)
  8017c9:	e8 40 fc ff ff       	call   80140e <dev_lookup>
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 1f                	js     8017f4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017dc:	74 1b                	je     8017f9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 52 18             	mov    0x18(%edx),%edx
  8017e4:	85 d2                	test   %edx,%edx
  8017e6:	74 32                	je     80181a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017e8:	83 ec 08             	sub    $0x8,%esp
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	50                   	push   %eax
  8017ef:	ff d2                	call   *%edx
  8017f1:	83 c4 10             	add    $0x10,%esp
}
  8017f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017f9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017fe:	8b 40 48             	mov    0x48(%eax),%eax
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	53                   	push   %ebx
  801805:	50                   	push   %eax
  801806:	68 54 2d 80 00       	push   $0x802d54
  80180b:	e8 60 eb ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801818:	eb da                	jmp    8017f4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80181a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181f:	eb d3                	jmp    8017f4 <ftruncate+0x52>

00801821 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	53                   	push   %ebx
  801825:	83 ec 14             	sub    $0x14,%esp
  801828:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80182e:	50                   	push   %eax
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 81 fb ff ff       	call   8013b8 <fd_lookup>
  801837:	83 c4 08             	add    $0x8,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 4b                	js     801889 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801844:	50                   	push   %eax
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801848:	ff 30                	pushl  (%eax)
  80184a:	e8 bf fb ff ff       	call   80140e <dev_lookup>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	78 33                	js     801889 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801859:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80185d:	74 2f                	je     80188e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80185f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801862:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801869:	00 00 00 
	stat->st_isdir = 0;
  80186c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801873:	00 00 00 
	stat->st_dev = dev;
  801876:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	53                   	push   %ebx
  801880:	ff 75 f0             	pushl  -0x10(%ebp)
  801883:	ff 50 14             	call   *0x14(%eax)
  801886:	83 c4 10             	add    $0x10,%esp
}
  801889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    
		return -E_NOT_SUPP;
  80188e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801893:	eb f4                	jmp    801889 <fstat+0x68>

00801895 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 26 02 00 00       	call   801acd <open>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 1b                	js     8018cb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	e8 65 ff ff ff       	call   801821 <fstat>
  8018bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8018be:	89 1c 24             	mov    %ebx,(%esp)
  8018c1:	e8 27 fc ff ff       	call   8014ed <close>
	return r;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 f3                	mov    %esi,%ebx
}
  8018cb:	89 d8                	mov    %ebx,%eax
  8018cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d0:	5b                   	pop    %ebx
  8018d1:	5e                   	pop    %esi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	89 c6                	mov    %eax,%esi
  8018db:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018dd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018e4:	74 27                	je     80190d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018e6:	6a 07                	push   $0x7
  8018e8:	68 00 50 80 00       	push   $0x805000
  8018ed:	56                   	push   %esi
  8018ee:	ff 35 00 40 80 00    	pushl  0x804000
  8018f4:	e8 b0 0c 00 00       	call   8025a9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018f9:	83 c4 0c             	add    $0xc,%esp
  8018fc:	6a 00                	push   $0x0
  8018fe:	53                   	push   %ebx
  8018ff:	6a 00                	push   $0x0
  801901:	e8 3a 0c 00 00       	call   802540 <ipc_recv>
}
  801906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	6a 01                	push   $0x1
  801912:	e8 eb 0c 00 00       	call   802602 <ipc_find_env>
  801917:	a3 00 40 80 00       	mov    %eax,0x804000
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	eb c5                	jmp    8018e6 <fsipc+0x12>

00801921 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	8b 40 0c             	mov    0xc(%eax),%eax
  80192d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801932:	8b 45 0c             	mov    0xc(%ebp),%eax
  801935:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80193a:	ba 00 00 00 00       	mov    $0x0,%edx
  80193f:	b8 02 00 00 00       	mov    $0x2,%eax
  801944:	e8 8b ff ff ff       	call   8018d4 <fsipc>
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <devfile_flush>:
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8b 40 0c             	mov    0xc(%eax),%eax
  801957:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80195c:	ba 00 00 00 00       	mov    $0x0,%edx
  801961:	b8 06 00 00 00       	mov    $0x6,%eax
  801966:	e8 69 ff ff ff       	call   8018d4 <fsipc>
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devfile_stat>:
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	8b 40 0c             	mov    0xc(%eax),%eax
  80197d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
  801987:	b8 05 00 00 00       	mov    $0x5,%eax
  80198c:	e8 43 ff ff ff       	call   8018d4 <fsipc>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 2c                	js     8019c1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801995:	83 ec 08             	sub    $0x8,%esp
  801998:	68 00 50 80 00       	push   $0x805000
  80199d:	53                   	push   %ebx
  80199e:	e8 6a f0 ff ff       	call   800a0d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019a3:	a1 80 50 80 00       	mov    0x805080,%eax
  8019a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ae:	a1 84 50 80 00       	mov    0x805084,%eax
  8019b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <devfile_write>:
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019db:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019e1:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019e7:	77 30                	ja     801a19 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	53                   	push   %ebx
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	68 08 50 80 00       	push   $0x805008
  8019f5:	e8 a1 f1 ff ff       	call   800b9b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ff:	b8 04 00 00 00       	mov    $0x4,%eax
  801a04:	e8 cb fe ff ff       	call   8018d4 <fsipc>
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	78 04                	js     801a14 <devfile_write+0x4e>
	assert(r <= n);
  801a10:	39 d8                	cmp    %ebx,%eax
  801a12:	77 1e                	ja     801a32 <devfile_write+0x6c>
}
  801a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a19:	68 c4 2d 80 00       	push   $0x802dc4
  801a1e:	68 f4 2d 80 00       	push   $0x802df4
  801a23:	68 94 00 00 00       	push   $0x94
  801a28:	68 09 2e 80 00       	push   $0x802e09
  801a2d:	e8 63 e8 ff ff       	call   800295 <_panic>
	assert(r <= n);
  801a32:	68 14 2e 80 00       	push   $0x802e14
  801a37:	68 f4 2d 80 00       	push   $0x802df4
  801a3c:	68 98 00 00 00       	push   $0x98
  801a41:	68 09 2e 80 00       	push   $0x802e09
  801a46:	e8 4a e8 ff ff       	call   800295 <_panic>

00801a4b <devfile_read>:
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
  801a50:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	8b 40 0c             	mov    0xc(%eax),%eax
  801a59:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a5e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 03 00 00 00       	mov    $0x3,%eax
  801a6e:	e8 61 fe ff ff       	call   8018d4 <fsipc>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 1f                	js     801a98 <devfile_read+0x4d>
	assert(r <= n);
  801a79:	39 f0                	cmp    %esi,%eax
  801a7b:	77 24                	ja     801aa1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a7d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a82:	7f 33                	jg     801ab7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	50                   	push   %eax
  801a88:	68 00 50 80 00       	push   $0x805000
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	e8 06 f1 ff ff       	call   800b9b <memmove>
	return r;
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    
	assert(r <= n);
  801aa1:	68 14 2e 80 00       	push   $0x802e14
  801aa6:	68 f4 2d 80 00       	push   $0x802df4
  801aab:	6a 7c                	push   $0x7c
  801aad:	68 09 2e 80 00       	push   $0x802e09
  801ab2:	e8 de e7 ff ff       	call   800295 <_panic>
	assert(r <= PGSIZE);
  801ab7:	68 1b 2e 80 00       	push   $0x802e1b
  801abc:	68 f4 2d 80 00       	push   $0x802df4
  801ac1:	6a 7d                	push   $0x7d
  801ac3:	68 09 2e 80 00       	push   $0x802e09
  801ac8:	e8 c8 e7 ff ff       	call   800295 <_panic>

00801acd <open>:
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	56                   	push   %esi
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 1c             	sub    $0x1c,%esp
  801ad5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ad8:	56                   	push   %esi
  801ad9:	e8 f8 ee ff ff       	call   8009d6 <strlen>
  801ade:	83 c4 10             	add    $0x10,%esp
  801ae1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae6:	7f 6c                	jg     801b54 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ae8:	83 ec 0c             	sub    $0xc,%esp
  801aeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aee:	50                   	push   %eax
  801aef:	e8 75 f8 ff ff       	call   801369 <fd_alloc>
  801af4:	89 c3                	mov    %eax,%ebx
  801af6:	83 c4 10             	add    $0x10,%esp
  801af9:	85 c0                	test   %eax,%eax
  801afb:	78 3c                	js     801b39 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	56                   	push   %esi
  801b01:	68 00 50 80 00       	push   $0x805000
  801b06:	e8 02 ef ff ff       	call   800a0d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b16:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1b:	e8 b4 fd ff ff       	call   8018d4 <fsipc>
  801b20:	89 c3                	mov    %eax,%ebx
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 19                	js     801b42 <open+0x75>
	return fd2num(fd);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2f:	e8 0e f8 ff ff       	call   801342 <fd2num>
  801b34:	89 c3                	mov    %eax,%ebx
  801b36:	83 c4 10             	add    $0x10,%esp
}
  801b39:	89 d8                	mov    %ebx,%eax
  801b3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    
		fd_close(fd, 0);
  801b42:	83 ec 08             	sub    $0x8,%esp
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4a:	e8 15 f9 ff ff       	call   801464 <fd_close>
		return r;
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	eb e5                	jmp    801b39 <open+0x6c>
		return -E_BAD_PATH;
  801b54:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b59:	eb de                	jmp    801b39 <open+0x6c>

00801b5b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b61:	ba 00 00 00 00       	mov    $0x0,%edx
  801b66:	b8 08 00 00 00       	mov    $0x8,%eax
  801b6b:	e8 64 fd ff ff       	call   8018d4 <fsipc>
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	e8 cd f7 ff ff       	call   801352 <fd2data>
  801b85:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b87:	83 c4 08             	add    $0x8,%esp
  801b8a:	68 27 2e 80 00       	push   $0x802e27
  801b8f:	53                   	push   %ebx
  801b90:	e8 78 ee ff ff       	call   800a0d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b95:	8b 46 04             	mov    0x4(%esi),%eax
  801b98:	2b 06                	sub    (%esi),%eax
  801b9a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ba0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba7:	00 00 00 
	stat->st_dev = &devpipe;
  801baa:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bb1:	30 80 00 
	return 0;
}
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bca:	53                   	push   %ebx
  801bcb:	6a 00                	push   $0x0
  801bcd:	e8 b9 f2 ff ff       	call   800e8b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bd2:	89 1c 24             	mov    %ebx,(%esp)
  801bd5:	e8 78 f7 ff ff       	call   801352 <fd2data>
  801bda:	83 c4 08             	add    $0x8,%esp
  801bdd:	50                   	push   %eax
  801bde:	6a 00                	push   $0x0
  801be0:	e8 a6 f2 ff ff       	call   800e8b <sys_page_unmap>
}
  801be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <_pipeisclosed>:
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	57                   	push   %edi
  801bee:	56                   	push   %esi
  801bef:	53                   	push   %ebx
  801bf0:	83 ec 1c             	sub    $0x1c,%esp
  801bf3:	89 c7                	mov    %eax,%edi
  801bf5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bf7:	a1 08 40 80 00       	mov    0x804008,%eax
  801bfc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	57                   	push   %edi
  801c03:	e8 33 0a 00 00       	call   80263b <pageref>
  801c08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c0b:	89 34 24             	mov    %esi,(%esp)
  801c0e:	e8 28 0a 00 00       	call   80263b <pageref>
		nn = thisenv->env_runs;
  801c13:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c19:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	39 cb                	cmp    %ecx,%ebx
  801c21:	74 1b                	je     801c3e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c23:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c26:	75 cf                	jne    801bf7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c28:	8b 42 58             	mov    0x58(%edx),%eax
  801c2b:	6a 01                	push   $0x1
  801c2d:	50                   	push   %eax
  801c2e:	53                   	push   %ebx
  801c2f:	68 2e 2e 80 00       	push   $0x802e2e
  801c34:	e8 37 e7 ff ff       	call   800370 <cprintf>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	eb b9                	jmp    801bf7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c41:	0f 94 c0             	sete   %al
  801c44:	0f b6 c0             	movzbl %al,%eax
}
  801c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5f                   	pop    %edi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    

00801c4f <devpipe_write>:
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	57                   	push   %edi
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	83 ec 28             	sub    $0x28,%esp
  801c58:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c5b:	56                   	push   %esi
  801c5c:	e8 f1 f6 ff ff       	call   801352 <fd2data>
  801c61:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c6e:	74 4f                	je     801cbf <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c70:	8b 43 04             	mov    0x4(%ebx),%eax
  801c73:	8b 0b                	mov    (%ebx),%ecx
  801c75:	8d 51 20             	lea    0x20(%ecx),%edx
  801c78:	39 d0                	cmp    %edx,%eax
  801c7a:	72 14                	jb     801c90 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c7c:	89 da                	mov    %ebx,%edx
  801c7e:	89 f0                	mov    %esi,%eax
  801c80:	e8 65 ff ff ff       	call   801bea <_pipeisclosed>
  801c85:	85 c0                	test   %eax,%eax
  801c87:	75 3a                	jne    801cc3 <devpipe_write+0x74>
			sys_yield();
  801c89:	e8 59 f1 ff ff       	call   800de7 <sys_yield>
  801c8e:	eb e0                	jmp    801c70 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c93:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c97:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c9a:	89 c2                	mov    %eax,%edx
  801c9c:	c1 fa 1f             	sar    $0x1f,%edx
  801c9f:	89 d1                	mov    %edx,%ecx
  801ca1:	c1 e9 1b             	shr    $0x1b,%ecx
  801ca4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ca7:	83 e2 1f             	and    $0x1f,%edx
  801caa:	29 ca                	sub    %ecx,%edx
  801cac:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cb0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cb4:	83 c0 01             	add    $0x1,%eax
  801cb7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cba:	83 c7 01             	add    $0x1,%edi
  801cbd:	eb ac                	jmp    801c6b <devpipe_write+0x1c>
	return i;
  801cbf:	89 f8                	mov    %edi,%eax
  801cc1:	eb 05                	jmp    801cc8 <devpipe_write+0x79>
				return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5f                   	pop    %edi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    

00801cd0 <devpipe_read>:
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 18             	sub    $0x18,%esp
  801cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cdc:	57                   	push   %edi
  801cdd:	e8 70 f6 ff ff       	call   801352 <fd2data>
  801ce2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	be 00 00 00 00       	mov    $0x0,%esi
  801cec:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cef:	74 47                	je     801d38 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801cf1:	8b 03                	mov    (%ebx),%eax
  801cf3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cf6:	75 22                	jne    801d1a <devpipe_read+0x4a>
			if (i > 0)
  801cf8:	85 f6                	test   %esi,%esi
  801cfa:	75 14                	jne    801d10 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801cfc:	89 da                	mov    %ebx,%edx
  801cfe:	89 f8                	mov    %edi,%eax
  801d00:	e8 e5 fe ff ff       	call   801bea <_pipeisclosed>
  801d05:	85 c0                	test   %eax,%eax
  801d07:	75 33                	jne    801d3c <devpipe_read+0x6c>
			sys_yield();
  801d09:	e8 d9 f0 ff ff       	call   800de7 <sys_yield>
  801d0e:	eb e1                	jmp    801cf1 <devpipe_read+0x21>
				return i;
  801d10:	89 f0                	mov    %esi,%eax
}
  801d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5f                   	pop    %edi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d1a:	99                   	cltd   
  801d1b:	c1 ea 1b             	shr    $0x1b,%edx
  801d1e:	01 d0                	add    %edx,%eax
  801d20:	83 e0 1f             	and    $0x1f,%eax
  801d23:	29 d0                	sub    %edx,%eax
  801d25:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d2d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d30:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d33:	83 c6 01             	add    $0x1,%esi
  801d36:	eb b4                	jmp    801cec <devpipe_read+0x1c>
	return i;
  801d38:	89 f0                	mov    %esi,%eax
  801d3a:	eb d6                	jmp    801d12 <devpipe_read+0x42>
				return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d41:	eb cf                	jmp    801d12 <devpipe_read+0x42>

00801d43 <pipe>:
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4e:	50                   	push   %eax
  801d4f:	e8 15 f6 ff ff       	call   801369 <fd_alloc>
  801d54:	89 c3                	mov    %eax,%ebx
  801d56:	83 c4 10             	add    $0x10,%esp
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 5b                	js     801db8 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	68 07 04 00 00       	push   $0x407
  801d65:	ff 75 f4             	pushl  -0xc(%ebp)
  801d68:	6a 00                	push   $0x0
  801d6a:	e8 97 f0 ff ff       	call   800e06 <sys_page_alloc>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	78 40                	js     801db8 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d7e:	50                   	push   %eax
  801d7f:	e8 e5 f5 ff ff       	call   801369 <fd_alloc>
  801d84:	89 c3                	mov    %eax,%ebx
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	78 1b                	js     801da8 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	68 07 04 00 00       	push   $0x407
  801d95:	ff 75 f0             	pushl  -0x10(%ebp)
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 67 f0 ff ff       	call   800e06 <sys_page_alloc>
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	79 19                	jns    801dc1 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801da8:	83 ec 08             	sub    $0x8,%esp
  801dab:	ff 75 f4             	pushl  -0xc(%ebp)
  801dae:	6a 00                	push   $0x0
  801db0:	e8 d6 f0 ff ff       	call   800e8b <sys_page_unmap>
  801db5:	83 c4 10             	add    $0x10,%esp
}
  801db8:	89 d8                	mov    %ebx,%eax
  801dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    
	va = fd2data(fd0);
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc7:	e8 86 f5 ff ff       	call   801352 <fd2data>
  801dcc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dce:	83 c4 0c             	add    $0xc,%esp
  801dd1:	68 07 04 00 00       	push   $0x407
  801dd6:	50                   	push   %eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	e8 28 f0 ff ff       	call   800e06 <sys_page_alloc>
  801dde:	89 c3                	mov    %eax,%ebx
  801de0:	83 c4 10             	add    $0x10,%esp
  801de3:	85 c0                	test   %eax,%eax
  801de5:	0f 88 8c 00 00 00    	js     801e77 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801deb:	83 ec 0c             	sub    $0xc,%esp
  801dee:	ff 75 f0             	pushl  -0x10(%ebp)
  801df1:	e8 5c f5 ff ff       	call   801352 <fd2data>
  801df6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dfd:	50                   	push   %eax
  801dfe:	6a 00                	push   $0x0
  801e00:	56                   	push   %esi
  801e01:	6a 00                	push   $0x0
  801e03:	e8 41 f0 ff ff       	call   800e49 <sys_page_map>
  801e08:	89 c3                	mov    %eax,%ebx
  801e0a:	83 c4 20             	add    $0x20,%esp
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 58                	js     801e69 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e1a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e29:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e2f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e34:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e41:	e8 fc f4 ff ff       	call   801342 <fd2num>
  801e46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e49:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e4b:	83 c4 04             	add    $0x4,%esp
  801e4e:	ff 75 f0             	pushl  -0x10(%ebp)
  801e51:	e8 ec f4 ff ff       	call   801342 <fd2num>
  801e56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e59:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e64:	e9 4f ff ff ff       	jmp    801db8 <pipe+0x75>
	sys_page_unmap(0, va);
  801e69:	83 ec 08             	sub    $0x8,%esp
  801e6c:	56                   	push   %esi
  801e6d:	6a 00                	push   $0x0
  801e6f:	e8 17 f0 ff ff       	call   800e8b <sys_page_unmap>
  801e74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7d:	6a 00                	push   $0x0
  801e7f:	e8 07 f0 ff ff       	call   800e8b <sys_page_unmap>
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	e9 1c ff ff ff       	jmp    801da8 <pipe+0x65>

00801e8c <pipeisclosed>:
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e95:	50                   	push   %eax
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	e8 1a f5 ff ff       	call   8013b8 <fd_lookup>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 18                	js     801ebd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eab:	e8 a2 f4 ff ff       	call   801352 <fd2data>
	return _pipeisclosed(fd, p);
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	e8 30 fd ff ff       	call   801bea <_pipeisclosed>
  801eba:	83 c4 10             	add    $0x10,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ec5:	68 41 2e 80 00       	push   $0x802e41
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	e8 3b eb ff ff       	call   800a0d <strcpy>
	return 0;
}
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <devsock_close>:
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	53                   	push   %ebx
  801edd:	83 ec 10             	sub    $0x10,%esp
  801ee0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ee3:	53                   	push   %ebx
  801ee4:	e8 52 07 00 00       	call   80263b <pageref>
  801ee9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801eec:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ef1:	83 f8 01             	cmp    $0x1,%eax
  801ef4:	74 07                	je     801efd <devsock_close+0x24>
}
  801ef6:	89 d0                	mov    %edx,%eax
  801ef8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 73 0c             	pushl  0xc(%ebx)
  801f03:	e8 b7 02 00 00       	call   8021bf <nsipc_close>
  801f08:	89 c2                	mov    %eax,%edx
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	eb e7                	jmp    801ef6 <devsock_close+0x1d>

00801f0f <devsock_write>:
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	ff 75 10             	pushl  0x10(%ebp)
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	ff 70 0c             	pushl  0xc(%eax)
  801f23:	e8 74 03 00 00       	call   80229c <nsipc_send>
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <devsock_read>:
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	ff 75 10             	pushl  0x10(%ebp)
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	ff 70 0c             	pushl  0xc(%eax)
  801f3e:	e8 ed 02 00 00       	call   802230 <nsipc_recv>
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <fd2sockid>:
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f4b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	e8 63 f4 ff ff       	call   8013b8 <fd_lookup>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 10                	js     801f6c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801f65:	39 08                	cmp    %ecx,(%eax)
  801f67:	75 05                	jne    801f6e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f69:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    
		return -E_NOT_SUPP;
  801f6e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f73:	eb f7                	jmp    801f6c <fd2sockid+0x27>

00801f75 <alloc_sockfd>:
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	56                   	push   %esi
  801f79:	53                   	push   %ebx
  801f7a:	83 ec 1c             	sub    $0x1c,%esp
  801f7d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f82:	50                   	push   %eax
  801f83:	e8 e1 f3 ff ff       	call   801369 <fd_alloc>
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	78 43                	js     801fd4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	68 07 04 00 00       	push   $0x407
  801f99:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9c:	6a 00                	push   $0x0
  801f9e:	e8 63 ee ff ff       	call   800e06 <sys_page_alloc>
  801fa3:	89 c3                	mov    %eax,%ebx
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 28                	js     801fd4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fb5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fc1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	50                   	push   %eax
  801fc8:	e8 75 f3 ff ff       	call   801342 <fd2num>
  801fcd:	89 c3                	mov    %eax,%ebx
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	eb 0c                	jmp    801fe0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	56                   	push   %esi
  801fd8:	e8 e2 01 00 00       	call   8021bf <nsipc_close>
		return r;
  801fdd:	83 c4 10             	add    $0x10,%esp
}
  801fe0:	89 d8                	mov    %ebx,%eax
  801fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe5:	5b                   	pop    %ebx
  801fe6:	5e                   	pop    %esi
  801fe7:	5d                   	pop    %ebp
  801fe8:	c3                   	ret    

00801fe9 <accept>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	e8 4e ff ff ff       	call   801f45 <fd2sockid>
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	78 1b                	js     802016 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ffb:	83 ec 04             	sub    $0x4,%esp
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	ff 75 0c             	pushl  0xc(%ebp)
  802004:	50                   	push   %eax
  802005:	e8 0e 01 00 00       	call   802118 <nsipc_accept>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 05                	js     802016 <accept+0x2d>
	return alloc_sockfd(r);
  802011:	e8 5f ff ff ff       	call   801f75 <alloc_sockfd>
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <bind>:
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	e8 1f ff ff ff       	call   801f45 <fd2sockid>
  802026:	85 c0                	test   %eax,%eax
  802028:	78 12                	js     80203c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	ff 75 10             	pushl  0x10(%ebp)
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	e8 2f 01 00 00       	call   802168 <nsipc_bind>
  802039:	83 c4 10             	add    $0x10,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <shutdown>:
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	e8 f9 fe ff ff       	call   801f45 <fd2sockid>
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 0f                	js     80205f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802050:	83 ec 08             	sub    $0x8,%esp
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	50                   	push   %eax
  802057:	e8 41 01 00 00       	call   80219d <nsipc_shutdown>
  80205c:	83 c4 10             	add    $0x10,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <connect>:
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	e8 d6 fe ff ff       	call   801f45 <fd2sockid>
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 12                	js     802085 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	ff 75 10             	pushl  0x10(%ebp)
  802079:	ff 75 0c             	pushl  0xc(%ebp)
  80207c:	50                   	push   %eax
  80207d:	e8 57 01 00 00       	call   8021d9 <nsipc_connect>
  802082:	83 c4 10             	add    $0x10,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <listen>:
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	e8 b0 fe ff ff       	call   801f45 <fd2sockid>
  802095:	85 c0                	test   %eax,%eax
  802097:	78 0f                	js     8020a8 <listen+0x21>
	return nsipc_listen(r, backlog);
  802099:	83 ec 08             	sub    $0x8,%esp
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	50                   	push   %eax
  8020a0:	e8 69 01 00 00       	call   80220e <nsipc_listen>
  8020a5:	83 c4 10             	add    $0x10,%esp
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <socket>:

int
socket(int domain, int type, int protocol)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020b0:	ff 75 10             	pushl  0x10(%ebp)
  8020b3:	ff 75 0c             	pushl  0xc(%ebp)
  8020b6:	ff 75 08             	pushl  0x8(%ebp)
  8020b9:	e8 3c 02 00 00       	call   8022fa <nsipc_socket>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	78 05                	js     8020ca <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020c5:	e8 ab fe ff ff       	call   801f75 <alloc_sockfd>
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020d5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8020dc:	74 26                	je     802104 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020de:	6a 07                	push   $0x7
  8020e0:	68 00 60 80 00       	push   $0x806000
  8020e5:	53                   	push   %ebx
  8020e6:	ff 35 04 40 80 00    	pushl  0x804004
  8020ec:	e8 b8 04 00 00       	call   8025a9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020f1:	83 c4 0c             	add    $0xc,%esp
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	e8 41 04 00 00       	call   802540 <ipc_recv>
}
  8020ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802102:	c9                   	leave  
  802103:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	6a 02                	push   $0x2
  802109:	e8 f4 04 00 00       	call   802602 <ipc_find_env>
  80210e:	a3 04 40 80 00       	mov    %eax,0x804004
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	eb c6                	jmp    8020de <nsipc+0x12>

00802118 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	56                   	push   %esi
  80211c:	53                   	push   %ebx
  80211d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802128:	8b 06                	mov    (%esi),%eax
  80212a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80212f:	b8 01 00 00 00       	mov    $0x1,%eax
  802134:	e8 93 ff ff ff       	call   8020cc <nsipc>
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	85 c0                	test   %eax,%eax
  80213d:	78 20                	js     80215f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	ff 35 10 60 80 00    	pushl  0x806010
  802148:	68 00 60 80 00       	push   $0x806000
  80214d:	ff 75 0c             	pushl  0xc(%ebp)
  802150:	e8 46 ea ff ff       	call   800b9b <memmove>
		*addrlen = ret->ret_addrlen;
  802155:	a1 10 60 80 00       	mov    0x806010,%eax
  80215a:	89 06                	mov    %eax,(%esi)
  80215c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80215f:	89 d8                	mov    %ebx,%eax
  802161:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802164:	5b                   	pop    %ebx
  802165:	5e                   	pop    %esi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    

00802168 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	53                   	push   %ebx
  80216c:	83 ec 08             	sub    $0x8,%esp
  80216f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80217a:	53                   	push   %ebx
  80217b:	ff 75 0c             	pushl  0xc(%ebp)
  80217e:	68 04 60 80 00       	push   $0x806004
  802183:	e8 13 ea ff ff       	call   800b9b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802188:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80218e:	b8 02 00 00 00       	mov    $0x2,%eax
  802193:	e8 34 ff ff ff       	call   8020cc <nsipc>
}
  802198:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8021b3:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b8:	e8 0f ff ff ff       	call   8020cc <nsipc>
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <nsipc_close>:

int
nsipc_close(int s)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8021cd:	b8 04 00 00 00       	mov    $0x4,%eax
  8021d2:	e8 f5 fe ff ff       	call   8020cc <nsipc>
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	53                   	push   %ebx
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021eb:	53                   	push   %ebx
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	68 04 60 80 00       	push   $0x806004
  8021f4:	e8 a2 e9 ff ff       	call   800b9b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8021ff:	b8 05 00 00 00       	mov    $0x5,%eax
  802204:	e8 c3 fe ff ff       	call   8020cc <nsipc>
}
  802209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802224:	b8 06 00 00 00       	mov    $0x6,%eax
  802229:	e8 9e fe ff ff       	call   8020cc <nsipc>
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	56                   	push   %esi
  802234:	53                   	push   %ebx
  802235:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802240:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802246:	8b 45 14             	mov    0x14(%ebp),%eax
  802249:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80224e:	b8 07 00 00 00       	mov    $0x7,%eax
  802253:	e8 74 fe ff ff       	call   8020cc <nsipc>
  802258:	89 c3                	mov    %eax,%ebx
  80225a:	85 c0                	test   %eax,%eax
  80225c:	78 1f                	js     80227d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80225e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802263:	7f 21                	jg     802286 <nsipc_recv+0x56>
  802265:	39 c6                	cmp    %eax,%esi
  802267:	7c 1d                	jl     802286 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802269:	83 ec 04             	sub    $0x4,%esp
  80226c:	50                   	push   %eax
  80226d:	68 00 60 80 00       	push   $0x806000
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	e8 21 e9 ff ff       	call   800b9b <memmove>
  80227a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80227d:	89 d8                	mov    %ebx,%eax
  80227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802282:	5b                   	pop    %ebx
  802283:	5e                   	pop    %esi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802286:	68 4d 2e 80 00       	push   $0x802e4d
  80228b:	68 f4 2d 80 00       	push   $0x802df4
  802290:	6a 62                	push   $0x62
  802292:	68 62 2e 80 00       	push   $0x802e62
  802297:	e8 f9 df ff ff       	call   800295 <_panic>

0080229c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	53                   	push   %ebx
  8022a0:	83 ec 04             	sub    $0x4,%esp
  8022a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8022ae:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022b4:	7f 2e                	jg     8022e4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b6:	83 ec 04             	sub    $0x4,%esp
  8022b9:	53                   	push   %ebx
  8022ba:	ff 75 0c             	pushl  0xc(%ebp)
  8022bd:	68 0c 60 80 00       	push   $0x80600c
  8022c2:	e8 d4 e8 ff ff       	call   800b9b <memmove>
	nsipcbuf.send.req_size = size;
  8022c7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8022da:	e8 ed fd ff ff       	call   8020cc <nsipc>
}
  8022df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    
	assert(size < 1600);
  8022e4:	68 6e 2e 80 00       	push   $0x802e6e
  8022e9:	68 f4 2d 80 00       	push   $0x802df4
  8022ee:	6a 6d                	push   $0x6d
  8022f0:	68 62 2e 80 00       	push   $0x802e62
  8022f5:	e8 9b df ff ff       	call   800295 <_panic>

008022fa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802310:	8b 45 10             	mov    0x10(%ebp),%eax
  802313:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802318:	b8 09 00 00 00       	mov    $0x9,%eax
  80231d:	e8 aa fd ff ff       	call   8020cc <nsipc>
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    

0080232e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802334:	68 7a 2e 80 00       	push   $0x802e7a
  802339:	ff 75 0c             	pushl  0xc(%ebp)
  80233c:	e8 cc e6 ff ff       	call   800a0d <strcpy>
	return 0;
}
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <devcons_write>:
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	57                   	push   %edi
  80234c:	56                   	push   %esi
  80234d:	53                   	push   %ebx
  80234e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802354:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802359:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80235f:	eb 2f                	jmp    802390 <devcons_write+0x48>
		m = n - tot;
  802361:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802364:	29 f3                	sub    %esi,%ebx
  802366:	83 fb 7f             	cmp    $0x7f,%ebx
  802369:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80236e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	53                   	push   %ebx
  802375:	89 f0                	mov    %esi,%eax
  802377:	03 45 0c             	add    0xc(%ebp),%eax
  80237a:	50                   	push   %eax
  80237b:	57                   	push   %edi
  80237c:	e8 1a e8 ff ff       	call   800b9b <memmove>
		sys_cputs(buf, m);
  802381:	83 c4 08             	add    $0x8,%esp
  802384:	53                   	push   %ebx
  802385:	57                   	push   %edi
  802386:	e8 bf e9 ff ff       	call   800d4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80238b:	01 de                	add    %ebx,%esi
  80238d:	83 c4 10             	add    $0x10,%esp
  802390:	3b 75 10             	cmp    0x10(%ebp),%esi
  802393:	72 cc                	jb     802361 <devcons_write+0x19>
}
  802395:	89 f0                	mov    %esi,%eax
  802397:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80239a:	5b                   	pop    %ebx
  80239b:	5e                   	pop    %esi
  80239c:	5f                   	pop    %edi
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    

0080239f <devcons_read>:
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	83 ec 08             	sub    $0x8,%esp
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023ae:	75 07                	jne    8023b7 <devcons_read+0x18>
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    
		sys_yield();
  8023b2:	e8 30 ea ff ff       	call   800de7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8023b7:	e8 ac e9 ff ff       	call   800d68 <sys_cgetc>
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 f2                	je     8023b2 <devcons_read+0x13>
	if (c < 0)
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	78 ec                	js     8023b0 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8023c4:	83 f8 04             	cmp    $0x4,%eax
  8023c7:	74 0c                	je     8023d5 <devcons_read+0x36>
	*(char*)vbuf = c;
  8023c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cc:	88 02                	mov    %al,(%edx)
	return 1;
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb db                	jmp    8023b0 <devcons_read+0x11>
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	eb d4                	jmp    8023b0 <devcons_read+0x11>

008023dc <cputchar>:
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023e8:	6a 01                	push   $0x1
  8023ea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023ed:	50                   	push   %eax
  8023ee:	e8 57 e9 ff ff       	call   800d4a <sys_cputs>
}
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <getchar>:
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023fe:	6a 01                	push   $0x1
  802400:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802403:	50                   	push   %eax
  802404:	6a 00                	push   $0x0
  802406:	e8 1e f2 ff ff       	call   801629 <read>
	if (r < 0)
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	85 c0                	test   %eax,%eax
  802410:	78 08                	js     80241a <getchar+0x22>
	if (r < 1)
  802412:	85 c0                	test   %eax,%eax
  802414:	7e 06                	jle    80241c <getchar+0x24>
	return c;
  802416:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    
		return -E_EOF;
  80241c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802421:	eb f7                	jmp    80241a <getchar+0x22>

00802423 <iscons>:
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802429:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80242c:	50                   	push   %eax
  80242d:	ff 75 08             	pushl  0x8(%ebp)
  802430:	e8 83 ef ff ff       	call   8013b8 <fd_lookup>
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 11                	js     80244d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802445:	39 10                	cmp    %edx,(%eax)
  802447:	0f 94 c0             	sete   %al
  80244a:	0f b6 c0             	movzbl %al,%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <opencons>:
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802458:	50                   	push   %eax
  802459:	e8 0b ef ff ff       	call   801369 <fd_alloc>
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	85 c0                	test   %eax,%eax
  802463:	78 3a                	js     80249f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802465:	83 ec 04             	sub    $0x4,%esp
  802468:	68 07 04 00 00       	push   $0x407
  80246d:	ff 75 f4             	pushl  -0xc(%ebp)
  802470:	6a 00                	push   $0x0
  802472:	e8 8f e9 ff ff       	call   800e06 <sys_page_alloc>
  802477:	83 c4 10             	add    $0x10,%esp
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 21                	js     80249f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802487:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	50                   	push   %eax
  802497:	e8 a6 ee ff ff       	call   801342 <fd2num>
  80249c:	83 c4 10             	add    $0x10,%esp
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8024a7:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8024ae:	74 0a                	je     8024ba <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8024ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8024bf:	8b 40 48             	mov    0x48(%eax),%eax
  8024c2:	83 ec 04             	sub    $0x4,%esp
  8024c5:	6a 07                	push   $0x7
  8024c7:	68 00 f0 bf ee       	push   $0xeebff000
  8024cc:	50                   	push   %eax
  8024cd:	e8 34 e9 ff ff       	call   800e06 <sys_page_alloc>
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	75 2f                	jne    802508 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8024d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8024de:	8b 40 48             	mov    0x48(%eax),%eax
  8024e1:	83 ec 08             	sub    $0x8,%esp
  8024e4:	68 1a 25 80 00       	push   $0x80251a
  8024e9:	50                   	push   %eax
  8024ea:	e8 62 ea ff ff       	call   800f51 <sys_env_set_pgfault_upcall>
  8024ef:	83 c4 10             	add    $0x10,%esp
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 ba                	je     8024b0 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8024f6:	50                   	push   %eax
  8024f7:	68 86 2e 80 00       	push   $0x802e86
  8024fc:	6a 24                	push   $0x24
  8024fe:	68 9e 2e 80 00       	push   $0x802e9e
  802503:	e8 8d dd ff ff       	call   800295 <_panic>
		    panic("set_pgfault_handler: %e", r);
  802508:	50                   	push   %eax
  802509:	68 86 2e 80 00       	push   $0x802e86
  80250e:	6a 21                	push   $0x21
  802510:	68 9e 2e 80 00       	push   $0x802e9e
  802515:	e8 7b dd ff ff       	call   800295 <_panic>

0080251a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80251a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80251b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802520:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802522:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802525:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  802529:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  80252c:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802530:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802534:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802536:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  802539:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  80253a:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  80253d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80253e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80253f:	c3                   	ret    

00802540 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	56                   	push   %esi
  802544:	53                   	push   %ebx
  802545:	8b 75 08             	mov    0x8(%ebp),%esi
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80254e:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802550:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802555:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802558:	83 ec 0c             	sub    $0xc,%esp
  80255b:	50                   	push   %eax
  80255c:	e8 55 ea ff ff       	call   800fb6 <sys_ipc_recv>
  802561:	83 c4 10             	add    $0x10,%esp
  802564:	85 c0                	test   %eax,%eax
  802566:	78 2b                	js     802593 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802568:	85 f6                	test   %esi,%esi
  80256a:	74 0a                	je     802576 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80256c:	a1 08 40 80 00       	mov    0x804008,%eax
  802571:	8b 40 74             	mov    0x74(%eax),%eax
  802574:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802576:	85 db                	test   %ebx,%ebx
  802578:	74 0a                	je     802584 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80257a:	a1 08 40 80 00       	mov    0x804008,%eax
  80257f:	8b 40 78             	mov    0x78(%eax),%eax
  802582:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802584:	a1 08 40 80 00       	mov    0x804008,%eax
  802589:	8b 40 70             	mov    0x70(%eax),%eax
}
  80258c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80258f:	5b                   	pop    %ebx
  802590:	5e                   	pop    %esi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
	    if (from_env_store != NULL) {
  802593:	85 f6                	test   %esi,%esi
  802595:	74 06                	je     80259d <ipc_recv+0x5d>
	        *from_env_store = 0;
  802597:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80259d:	85 db                	test   %ebx,%ebx
  80259f:	74 eb                	je     80258c <ipc_recv+0x4c>
	        *perm_store = 0;
  8025a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8025a7:	eb e3                	jmp    80258c <ipc_recv+0x4c>

008025a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	57                   	push   %edi
  8025ad:	56                   	push   %esi
  8025ae:	53                   	push   %ebx
  8025af:	83 ec 0c             	sub    $0xc,%esp
  8025b2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025b5:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8025b8:	85 f6                	test   %esi,%esi
  8025ba:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025bf:	0f 44 f0             	cmove  %eax,%esi
  8025c2:	eb 09                	jmp    8025cd <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8025c4:	e8 1e e8 ff ff       	call   800de7 <sys_yield>
	} while(r != 0);
  8025c9:	85 db                	test   %ebx,%ebx
  8025cb:	74 2d                	je     8025fa <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8025cd:	ff 75 14             	pushl  0x14(%ebp)
  8025d0:	56                   	push   %esi
  8025d1:	ff 75 0c             	pushl  0xc(%ebp)
  8025d4:	57                   	push   %edi
  8025d5:	e8 b9 e9 ff ff       	call   800f93 <sys_ipc_try_send>
  8025da:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8025dc:	83 c4 10             	add    $0x10,%esp
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	79 e1                	jns    8025c4 <ipc_send+0x1b>
  8025e3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025e6:	74 dc                	je     8025c4 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8025e8:	50                   	push   %eax
  8025e9:	68 ac 2e 80 00       	push   $0x802eac
  8025ee:	6a 45                	push   $0x45
  8025f0:	68 b9 2e 80 00       	push   $0x802eb9
  8025f5:	e8 9b dc ff ff       	call   800295 <_panic>
}
  8025fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025fd:	5b                   	pop    %ebx
  8025fe:	5e                   	pop    %esi
  8025ff:	5f                   	pop    %edi
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    

00802602 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802608:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80260d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802610:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802616:	8b 52 50             	mov    0x50(%edx),%edx
  802619:	39 ca                	cmp    %ecx,%edx
  80261b:	74 11                	je     80262e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80261d:	83 c0 01             	add    $0x1,%eax
  802620:	3d 00 04 00 00       	cmp    $0x400,%eax
  802625:	75 e6                	jne    80260d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
  80262c:	eb 0b                	jmp    802639 <ipc_find_env+0x37>
			return envs[i].env_id;
  80262e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802631:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802636:	8b 40 48             	mov    0x48(%eax),%eax
}
  802639:	5d                   	pop    %ebp
  80263a:	c3                   	ret    

0080263b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802641:	89 d0                	mov    %edx,%eax
  802643:	c1 e8 16             	shr    $0x16,%eax
  802646:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802652:	f6 c1 01             	test   $0x1,%cl
  802655:	74 1d                	je     802674 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802657:	c1 ea 0c             	shr    $0xc,%edx
  80265a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802661:	f6 c2 01             	test   $0x1,%dl
  802664:	74 0e                	je     802674 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802666:	c1 ea 0c             	shr    $0xc,%edx
  802669:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802670:	ef 
  802671:	0f b7 c0             	movzwl %ax,%eax
}
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	66 90                	xchg   %ax,%ax
  802678:	66 90                	xchg   %ax,%ax
  80267a:	66 90                	xchg   %ax,%ax
  80267c:	66 90                	xchg   %ax,%ax
  80267e:	66 90                	xchg   %ax,%ax

00802680 <__udivdi3>:
  802680:	55                   	push   %ebp
  802681:	57                   	push   %edi
  802682:	56                   	push   %esi
  802683:	53                   	push   %ebx
  802684:	83 ec 1c             	sub    $0x1c,%esp
  802687:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80268b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80268f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802693:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802697:	85 d2                	test   %edx,%edx
  802699:	75 35                	jne    8026d0 <__udivdi3+0x50>
  80269b:	39 f3                	cmp    %esi,%ebx
  80269d:	0f 87 bd 00 00 00    	ja     802760 <__udivdi3+0xe0>
  8026a3:	85 db                	test   %ebx,%ebx
  8026a5:	89 d9                	mov    %ebx,%ecx
  8026a7:	75 0b                	jne    8026b4 <__udivdi3+0x34>
  8026a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ae:	31 d2                	xor    %edx,%edx
  8026b0:	f7 f3                	div    %ebx
  8026b2:	89 c1                	mov    %eax,%ecx
  8026b4:	31 d2                	xor    %edx,%edx
  8026b6:	89 f0                	mov    %esi,%eax
  8026b8:	f7 f1                	div    %ecx
  8026ba:	89 c6                	mov    %eax,%esi
  8026bc:	89 e8                	mov    %ebp,%eax
  8026be:	89 f7                	mov    %esi,%edi
  8026c0:	f7 f1                	div    %ecx
  8026c2:	89 fa                	mov    %edi,%edx
  8026c4:	83 c4 1c             	add    $0x1c,%esp
  8026c7:	5b                   	pop    %ebx
  8026c8:	5e                   	pop    %esi
  8026c9:	5f                   	pop    %edi
  8026ca:	5d                   	pop    %ebp
  8026cb:	c3                   	ret    
  8026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d0:	39 f2                	cmp    %esi,%edx
  8026d2:	77 7c                	ja     802750 <__udivdi3+0xd0>
  8026d4:	0f bd fa             	bsr    %edx,%edi
  8026d7:	83 f7 1f             	xor    $0x1f,%edi
  8026da:	0f 84 98 00 00 00    	je     802778 <__udivdi3+0xf8>
  8026e0:	89 f9                	mov    %edi,%ecx
  8026e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026e7:	29 f8                	sub    %edi,%eax
  8026e9:	d3 e2                	shl    %cl,%edx
  8026eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ef:	89 c1                	mov    %eax,%ecx
  8026f1:	89 da                	mov    %ebx,%edx
  8026f3:	d3 ea                	shr    %cl,%edx
  8026f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026f9:	09 d1                	or     %edx,%ecx
  8026fb:	89 f2                	mov    %esi,%edx
  8026fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802701:	89 f9                	mov    %edi,%ecx
  802703:	d3 e3                	shl    %cl,%ebx
  802705:	89 c1                	mov    %eax,%ecx
  802707:	d3 ea                	shr    %cl,%edx
  802709:	89 f9                	mov    %edi,%ecx
  80270b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80270f:	d3 e6                	shl    %cl,%esi
  802711:	89 eb                	mov    %ebp,%ebx
  802713:	89 c1                	mov    %eax,%ecx
  802715:	d3 eb                	shr    %cl,%ebx
  802717:	09 de                	or     %ebx,%esi
  802719:	89 f0                	mov    %esi,%eax
  80271b:	f7 74 24 08          	divl   0x8(%esp)
  80271f:	89 d6                	mov    %edx,%esi
  802721:	89 c3                	mov    %eax,%ebx
  802723:	f7 64 24 0c          	mull   0xc(%esp)
  802727:	39 d6                	cmp    %edx,%esi
  802729:	72 0c                	jb     802737 <__udivdi3+0xb7>
  80272b:	89 f9                	mov    %edi,%ecx
  80272d:	d3 e5                	shl    %cl,%ebp
  80272f:	39 c5                	cmp    %eax,%ebp
  802731:	73 5d                	jae    802790 <__udivdi3+0x110>
  802733:	39 d6                	cmp    %edx,%esi
  802735:	75 59                	jne    802790 <__udivdi3+0x110>
  802737:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80273a:	31 ff                	xor    %edi,%edi
  80273c:	89 fa                	mov    %edi,%edx
  80273e:	83 c4 1c             	add    $0x1c,%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    
  802746:	8d 76 00             	lea    0x0(%esi),%esi
  802749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802750:	31 ff                	xor    %edi,%edi
  802752:	31 c0                	xor    %eax,%eax
  802754:	89 fa                	mov    %edi,%edx
  802756:	83 c4 1c             	add    $0x1c,%esp
  802759:	5b                   	pop    %ebx
  80275a:	5e                   	pop    %esi
  80275b:	5f                   	pop    %edi
  80275c:	5d                   	pop    %ebp
  80275d:	c3                   	ret    
  80275e:	66 90                	xchg   %ax,%ax
  802760:	31 ff                	xor    %edi,%edi
  802762:	89 e8                	mov    %ebp,%eax
  802764:	89 f2                	mov    %esi,%edx
  802766:	f7 f3                	div    %ebx
  802768:	89 fa                	mov    %edi,%edx
  80276a:	83 c4 1c             	add    $0x1c,%esp
  80276d:	5b                   	pop    %ebx
  80276e:	5e                   	pop    %esi
  80276f:	5f                   	pop    %edi
  802770:	5d                   	pop    %ebp
  802771:	c3                   	ret    
  802772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	72 06                	jb     802782 <__udivdi3+0x102>
  80277c:	31 c0                	xor    %eax,%eax
  80277e:	39 eb                	cmp    %ebp,%ebx
  802780:	77 d2                	ja     802754 <__udivdi3+0xd4>
  802782:	b8 01 00 00 00       	mov    $0x1,%eax
  802787:	eb cb                	jmp    802754 <__udivdi3+0xd4>
  802789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802790:	89 d8                	mov    %ebx,%eax
  802792:	31 ff                	xor    %edi,%edi
  802794:	eb be                	jmp    802754 <__udivdi3+0xd4>
  802796:	66 90                	xchg   %ax,%ax
  802798:	66 90                	xchg   %ax,%ax
  80279a:	66 90                	xchg   %ax,%ax
  80279c:	66 90                	xchg   %ax,%ax
  80279e:	66 90                	xchg   %ax,%ax

008027a0 <__umoddi3>:
  8027a0:	55                   	push   %ebp
  8027a1:	57                   	push   %edi
  8027a2:	56                   	push   %esi
  8027a3:	53                   	push   %ebx
  8027a4:	83 ec 1c             	sub    $0x1c,%esp
  8027a7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8027ab:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027af:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8027b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027b7:	85 ed                	test   %ebp,%ebp
  8027b9:	89 f0                	mov    %esi,%eax
  8027bb:	89 da                	mov    %ebx,%edx
  8027bd:	75 19                	jne    8027d8 <__umoddi3+0x38>
  8027bf:	39 df                	cmp    %ebx,%edi
  8027c1:	0f 86 b1 00 00 00    	jbe    802878 <__umoddi3+0xd8>
  8027c7:	f7 f7                	div    %edi
  8027c9:	89 d0                	mov    %edx,%eax
  8027cb:	31 d2                	xor    %edx,%edx
  8027cd:	83 c4 1c             	add    $0x1c,%esp
  8027d0:	5b                   	pop    %ebx
  8027d1:	5e                   	pop    %esi
  8027d2:	5f                   	pop    %edi
  8027d3:	5d                   	pop    %ebp
  8027d4:	c3                   	ret    
  8027d5:	8d 76 00             	lea    0x0(%esi),%esi
  8027d8:	39 dd                	cmp    %ebx,%ebp
  8027da:	77 f1                	ja     8027cd <__umoddi3+0x2d>
  8027dc:	0f bd cd             	bsr    %ebp,%ecx
  8027df:	83 f1 1f             	xor    $0x1f,%ecx
  8027e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027e6:	0f 84 b4 00 00 00    	je     8028a0 <__umoddi3+0x100>
  8027ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8027f1:	89 c2                	mov    %eax,%edx
  8027f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027f7:	29 c2                	sub    %eax,%edx
  8027f9:	89 c1                	mov    %eax,%ecx
  8027fb:	89 f8                	mov    %edi,%eax
  8027fd:	d3 e5                	shl    %cl,%ebp
  8027ff:	89 d1                	mov    %edx,%ecx
  802801:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802805:	d3 e8                	shr    %cl,%eax
  802807:	09 c5                	or     %eax,%ebp
  802809:	8b 44 24 04          	mov    0x4(%esp),%eax
  80280d:	89 c1                	mov    %eax,%ecx
  80280f:	d3 e7                	shl    %cl,%edi
  802811:	89 d1                	mov    %edx,%ecx
  802813:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802817:	89 df                	mov    %ebx,%edi
  802819:	d3 ef                	shr    %cl,%edi
  80281b:	89 c1                	mov    %eax,%ecx
  80281d:	89 f0                	mov    %esi,%eax
  80281f:	d3 e3                	shl    %cl,%ebx
  802821:	89 d1                	mov    %edx,%ecx
  802823:	89 fa                	mov    %edi,%edx
  802825:	d3 e8                	shr    %cl,%eax
  802827:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80282c:	09 d8                	or     %ebx,%eax
  80282e:	f7 f5                	div    %ebp
  802830:	d3 e6                	shl    %cl,%esi
  802832:	89 d1                	mov    %edx,%ecx
  802834:	f7 64 24 08          	mull   0x8(%esp)
  802838:	39 d1                	cmp    %edx,%ecx
  80283a:	89 c3                	mov    %eax,%ebx
  80283c:	89 d7                	mov    %edx,%edi
  80283e:	72 06                	jb     802846 <__umoddi3+0xa6>
  802840:	75 0e                	jne    802850 <__umoddi3+0xb0>
  802842:	39 c6                	cmp    %eax,%esi
  802844:	73 0a                	jae    802850 <__umoddi3+0xb0>
  802846:	2b 44 24 08          	sub    0x8(%esp),%eax
  80284a:	19 ea                	sbb    %ebp,%edx
  80284c:	89 d7                	mov    %edx,%edi
  80284e:	89 c3                	mov    %eax,%ebx
  802850:	89 ca                	mov    %ecx,%edx
  802852:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802857:	29 de                	sub    %ebx,%esi
  802859:	19 fa                	sbb    %edi,%edx
  80285b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	d3 e0                	shl    %cl,%eax
  802863:	89 d9                	mov    %ebx,%ecx
  802865:	d3 ee                	shr    %cl,%esi
  802867:	d3 ea                	shr    %cl,%edx
  802869:	09 f0                	or     %esi,%eax
  80286b:	83 c4 1c             	add    $0x1c,%esp
  80286e:	5b                   	pop    %ebx
  80286f:	5e                   	pop    %esi
  802870:	5f                   	pop    %edi
  802871:	5d                   	pop    %ebp
  802872:	c3                   	ret    
  802873:	90                   	nop
  802874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802878:	85 ff                	test   %edi,%edi
  80287a:	89 f9                	mov    %edi,%ecx
  80287c:	75 0b                	jne    802889 <__umoddi3+0xe9>
  80287e:	b8 01 00 00 00       	mov    $0x1,%eax
  802883:	31 d2                	xor    %edx,%edx
  802885:	f7 f7                	div    %edi
  802887:	89 c1                	mov    %eax,%ecx
  802889:	89 d8                	mov    %ebx,%eax
  80288b:	31 d2                	xor    %edx,%edx
  80288d:	f7 f1                	div    %ecx
  80288f:	89 f0                	mov    %esi,%eax
  802891:	f7 f1                	div    %ecx
  802893:	e9 31 ff ff ff       	jmp    8027c9 <__umoddi3+0x29>
  802898:	90                   	nop
  802899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	39 dd                	cmp    %ebx,%ebp
  8028a2:	72 08                	jb     8028ac <__umoddi3+0x10c>
  8028a4:	39 f7                	cmp    %esi,%edi
  8028a6:	0f 87 21 ff ff ff    	ja     8027cd <__umoddi3+0x2d>
  8028ac:	89 da                	mov    %ebx,%edx
  8028ae:	89 f0                	mov    %esi,%eax
  8028b0:	29 f8                	sub    %edi,%eax
  8028b2:	19 ea                	sbb    %ebp,%edx
  8028b4:	e9 14 ff ff ff       	jmp    8027cd <__umoddi3+0x2d>
