
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 60 28 80 00       	push   $0x802860
  800041:	e8 c7 02 00 00       	call   80030d <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 8f 1c 00 00       	call   801ce0 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5d                	js     8000b5 <umain+0x82>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 40 10 00 00       	call   80109d <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 64                	js     8000c7 <umain+0x94>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	85 c0                	test   %eax,%eax
  800065:	74 72                	je     8000d9 <umain+0xa6>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800067:	89 fb                	mov    %edi,%ebx
  800069:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800072:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800078:	8b 43 54             	mov    0x54(%ebx),%eax
  80007b:	83 f8 02             	cmp    $0x2,%eax
  80007e:	0f 85 d1 00 00 00    	jne    800155 <umain+0x122>
		if (pipeisclosed(p[0]) != 0) {
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	ff 75 e0             	pushl  -0x20(%ebp)
  80008a:	e8 9a 1d 00 00       	call   801e29 <pipeisclosed>
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	85 c0                	test   %eax,%eax
  800094:	74 e2                	je     800078 <umain+0x45>
			cprintf("\nRACE: pipe appears closed\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 d0 28 80 00       	push   $0x8028d0
  80009e:	e8 6a 02 00 00       	call   80030d <cprintf>
			sys_env_destroy(r);
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 79 0c 00 00       	call   800d24 <sys_env_destroy>
			exit();
  8000ab:	e8 68 01 00 00       	call   800218 <exit>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	eb c3                	jmp    800078 <umain+0x45>
		panic("pipe: %e", r);
  8000b5:	50                   	push   %eax
  8000b6:	68 ae 28 80 00       	push   $0x8028ae
  8000bb:	6a 0d                	push   $0xd
  8000bd:	68 b7 28 80 00       	push   $0x8028b7
  8000c2:	e8 6b 01 00 00       	call   800232 <_panic>
		panic("fork: %e", r);
  8000c7:	50                   	push   %eax
  8000c8:	68 c6 2c 80 00       	push   $0x802cc6
  8000cd:	6a 0f                	push   $0xf
  8000cf:	68 b7 28 80 00       	push   $0x8028b7
  8000d4:	e8 59 01 00 00       	call   800232 <_panic>
		close(p[1]);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000df:	e8 a6 13 00 00       	call   80148a <close>
  8000e4:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e7:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e9:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ee:	eb 31                	jmp    800121 <umain+0xee>
			dup(p[0], 10);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	6a 0a                	push   $0xa
  8000f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f8:	e8 dd 13 00 00       	call   8014da <dup>
			sys_yield();
  8000fd:	e8 82 0c 00 00       	call   800d84 <sys_yield>
			close(10);
  800102:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800109:	e8 7c 13 00 00       	call   80148a <close>
			sys_yield();
  80010e:	e8 71 0c 00 00       	call   800d84 <sys_yield>
		for (i = 0; i < 200; i++) {
  800113:	83 c3 01             	add    $0x1,%ebx
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80011f:	74 2a                	je     80014b <umain+0x118>
			if (i % 10 == 0)
  800121:	89 d8                	mov    %ebx,%eax
  800123:	f7 ee                	imul   %esi
  800125:	c1 fa 02             	sar    $0x2,%edx
  800128:	89 d8                	mov    %ebx,%eax
  80012a:	c1 f8 1f             	sar    $0x1f,%eax
  80012d:	29 c2                	sub    %eax,%edx
  80012f:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800132:	01 c0                	add    %eax,%eax
  800134:	39 c3                	cmp    %eax,%ebx
  800136:	75 b8                	jne    8000f0 <umain+0xbd>
				cprintf("%d.", i);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	53                   	push   %ebx
  80013c:	68 cc 28 80 00       	push   $0x8028cc
  800141:	e8 c7 01 00 00       	call   80030d <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	eb a5                	jmp    8000f0 <umain+0xbd>
		exit();
  80014b:	e8 c8 00 00 00       	call   800218 <exit>
  800150:	e9 12 ff ff ff       	jmp    800067 <umain+0x34>
		}
	cprintf("child done with loop\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 ec 28 80 00       	push   $0x8028ec
  80015d:	e8 ab 01 00 00       	call   80030d <cprintf>
	if (pipeisclosed(p[0]))
  800162:	83 c4 04             	add    $0x4,%esp
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	e8 bc 1c 00 00       	call   801e29 <pipeisclosed>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	75 38                	jne    8001ac <umain+0x179>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800174:	83 ec 08             	sub    $0x8,%esp
  800177:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 d2 11 00 00       	call   801355 <fd_lookup>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	85 c0                	test   %eax,%eax
  800188:	78 36                	js     8001c0 <umain+0x18d>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 5a 11 00 00       	call   8012ef <fd2data>
	cprintf("race didn't happen\n");
  800195:	c7 04 24 1a 29 80 00 	movl   $0x80291a,(%esp)
  80019c:	e8 6c 01 00 00       	call   80030d <cprintf>
}
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5f                   	pop    %edi
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 84 28 80 00       	push   $0x802884
  8001b4:	6a 40                	push   $0x40
  8001b6:	68 b7 28 80 00       	push   $0x8028b7
  8001bb:	e8 72 00 00 00       	call   800232 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c0:	50                   	push   %eax
  8001c1:	68 02 29 80 00       	push   $0x802902
  8001c6:	6a 42                	push   $0x42
  8001c8:	68 b7 28 80 00       	push   $0x8028b7
  8001cd:	e8 60 00 00 00       	call   800232 <_panic>

008001d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 83 0b 00 00       	call   800d65 <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x2d>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80021e:	e8 92 12 00 00       	call   8014b5 <close_all>
	sys_env_destroy(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 f7 0a 00 00       	call   800d24 <sys_env_destroy>
}
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800237:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800240:	e8 20 0b 00 00       	call   800d65 <sys_getenvid>
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	56                   	push   %esi
  80024f:	50                   	push   %eax
  800250:	68 38 29 80 00       	push   $0x802938
  800255:	e8 b3 00 00 00       	call   80030d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	83 c4 18             	add    $0x18,%esp
  80025d:	53                   	push   %ebx
  80025e:	ff 75 10             	pushl  0x10(%ebp)
  800261:	e8 56 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  800266:	c7 04 24 ff 2d 80 00 	movl   $0x802dff,(%esp)
  80026d:	e8 9b 00 00 00       	call   80030d <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x43>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	53                   	push   %ebx
  80027c:	83 ec 04             	sub    $0x4,%esp
  80027f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800282:	8b 13                	mov    (%ebx),%edx
  800284:	8d 42 01             	lea    0x1(%edx),%eax
  800287:	89 03                	mov    %eax,(%ebx)
  800289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800290:	3d ff 00 00 00       	cmp    $0xff,%eax
  800295:	74 09                	je     8002a0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800297:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	68 ff 00 00 00       	push   $0xff
  8002a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ab:	50                   	push   %eax
  8002ac:	e8 36 0a 00 00       	call   800ce7 <sys_cputs>
		b->idx = 0;
  8002b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	eb db                	jmp    800297 <putch+0x1f>

008002bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	ff 75 0c             	pushl  0xc(%ebp)
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	68 78 02 80 00       	push   $0x800278
  8002eb:	e8 1a 01 00 00       	call   80040a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f0:	83 c4 08             	add    $0x8,%esp
  8002f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 e2 09 00 00       	call   800ce7 <sys_cputs>

	return b.cnt;
}
  800305:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800316:	50                   	push   %eax
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 9d ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 1c             	sub    $0x1c,%esp
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	89 d6                	mov    %edx,%esi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	8b 55 0c             	mov    0xc(%ebp),%edx
  800334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800337:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800342:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800345:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800348:	39 d3                	cmp    %edx,%ebx
  80034a:	72 05                	jb     800351 <printnum+0x30>
  80034c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80034f:	77 7a                	ja     8003cb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	ff 75 18             	pushl  0x18(%ebp)
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035d:	53                   	push   %ebx
  80035e:	ff 75 10             	pushl  0x10(%ebp)
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 e4             	pushl  -0x1c(%ebp)
  800367:	ff 75 e0             	pushl  -0x20(%ebp)
  80036a:	ff 75 dc             	pushl  -0x24(%ebp)
  80036d:	ff 75 d8             	pushl  -0x28(%ebp)
  800370:	e8 ab 22 00 00       	call   802620 <__udivdi3>
  800375:	83 c4 18             	add    $0x18,%esp
  800378:	52                   	push   %edx
  800379:	50                   	push   %eax
  80037a:	89 f2                	mov    %esi,%edx
  80037c:	89 f8                	mov    %edi,%eax
  80037e:	e8 9e ff ff ff       	call   800321 <printnum>
  800383:	83 c4 20             	add    $0x20,%esp
  800386:	eb 13                	jmp    80039b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	56                   	push   %esi
  80038c:	ff 75 18             	pushl  0x18(%ebp)
  80038f:	ff d7                	call   *%edi
  800391:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800394:	83 eb 01             	sub    $0x1,%ebx
  800397:	85 db                	test   %ebx,%ebx
  800399:	7f ed                	jg     800388 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ae:	e8 8d 23 00 00       	call   802740 <__umoddi3>
  8003b3:	83 c4 14             	add    $0x14,%esp
  8003b6:	0f be 80 5b 29 80 00 	movsbl 0x80295b(%eax),%eax
  8003bd:	50                   	push   %eax
  8003be:	ff d7                	call   *%edi
}
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    
  8003cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ce:	eb c4                	jmp    800394 <printnum+0x73>

008003d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003da:	8b 10                	mov    (%eax),%edx
  8003dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003df:	73 0a                	jae    8003eb <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e4:	89 08                	mov    %ecx,(%eax)
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	88 02                	mov    %al,(%edx)
}
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <printfmt>:
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f6:	50                   	push   %eax
  8003f7:	ff 75 10             	pushl  0x10(%ebp)
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	ff 75 08             	pushl  0x8(%ebp)
  800400:	e8 05 00 00 00       	call   80040a <vprintfmt>
}
  800405:	83 c4 10             	add    $0x10,%esp
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <vprintfmt>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	57                   	push   %edi
  80040e:	56                   	push   %esi
  80040f:	53                   	push   %ebx
  800410:	83 ec 2c             	sub    $0x2c,%esp
  800413:	8b 75 08             	mov    0x8(%ebp),%esi
  800416:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800419:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041c:	e9 21 04 00 00       	jmp    800842 <vprintfmt+0x438>
		padc = ' ';
  800421:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800425:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800433:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8d 47 01             	lea    0x1(%edi),%eax
  800442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800445:	0f b6 17             	movzbl (%edi),%edx
  800448:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044b:	3c 55                	cmp    $0x55,%al
  80044d:	0f 87 90 04 00 00    	ja     8008e3 <vprintfmt+0x4d9>
  800453:	0f b6 c0             	movzbl %al,%eax
  800456:	ff 24 85 a0 2a 80 00 	jmp    *0x802aa0(,%eax,4)
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800460:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800464:	eb d9                	jmp    80043f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800469:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80046d:	eb d0                	jmp    80043f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	0f b6 d2             	movzbl %dl,%edx
  800472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80047d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800480:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800484:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800487:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048a:	83 f9 09             	cmp    $0x9,%ecx
  80048d:	77 55                	ja     8004e4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80048f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800492:	eb e9                	jmp    80047d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	8d 40 04             	lea    0x4(%eax),%eax
  8004a2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ac:	79 91                	jns    80043f <vprintfmt+0x35>
				width = precision, precision = -1;
  8004ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004bb:	eb 82                	jmp    80043f <vprintfmt+0x35>
  8004bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	0f 49 d0             	cmovns %eax,%edx
  8004ca:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d0:	e9 6a ff ff ff       	jmp    80043f <vprintfmt+0x35>
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004df:	e9 5b ff ff ff       	jmp    80043f <vprintfmt+0x35>
  8004e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ea:	eb bc                	jmp    8004a8 <vprintfmt+0x9e>
			lflag++;
  8004ec:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f2:	e9 48 ff ff ff       	jmp    80043f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 78 04             	lea    0x4(%eax),%edi
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	53                   	push   %ebx
  800501:	ff 30                	pushl  (%eax)
  800503:	ff d6                	call   *%esi
			break;
  800505:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800508:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050b:	e9 2f 03 00 00       	jmp    80083f <vprintfmt+0x435>
			err = va_arg(ap, int);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 78 04             	lea    0x4(%eax),%edi
  800516:	8b 00                	mov    (%eax),%eax
  800518:	99                   	cltd   
  800519:	31 d0                	xor    %edx,%eax
  80051b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051d:	83 f8 0f             	cmp    $0xf,%eax
  800520:	7f 23                	jg     800545 <vprintfmt+0x13b>
  800522:	8b 14 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 18                	je     800545 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80052d:	52                   	push   %edx
  80052e:	68 c6 2d 80 00       	push   $0x802dc6
  800533:	53                   	push   %ebx
  800534:	56                   	push   %esi
  800535:	e8 b3 fe ff ff       	call   8003ed <printfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800540:	e9 fa 02 00 00       	jmp    80083f <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800545:	50                   	push   %eax
  800546:	68 73 29 80 00       	push   $0x802973
  80054b:	53                   	push   %ebx
  80054c:	56                   	push   %esi
  80054d:	e8 9b fe ff ff       	call   8003ed <printfmt>
  800552:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800555:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800558:	e9 e2 02 00 00       	jmp    80083f <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 c0 04             	add    $0x4,%eax
  800563:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056b:	85 ff                	test   %edi,%edi
  80056d:	b8 6c 29 80 00       	mov    $0x80296c,%eax
  800572:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800575:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800579:	0f 8e bd 00 00 00    	jle    80063c <vprintfmt+0x232>
  80057f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800583:	75 0e                	jne    800593 <vprintfmt+0x189>
  800585:	89 75 08             	mov    %esi,0x8(%ebp)
  800588:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80058e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800591:	eb 6d                	jmp    800600 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 d0             	pushl  -0x30(%ebp)
  800599:	57                   	push   %edi
  80059a:	e8 ec 03 00 00       	call   80098b <strnlen>
  80059f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a2:	29 c1                	sub    %eax,%ecx
  8005a4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005aa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b6:	eb 0f                	jmp    8005c7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	83 ef 01             	sub    $0x1,%edi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	85 ff                	test   %edi,%edi
  8005c9:	7f ed                	jg     8005b8 <vprintfmt+0x1ae>
  8005cb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005ce:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d1:	85 c9                	test   %ecx,%ecx
  8005d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d8:	0f 49 c1             	cmovns %ecx,%eax
  8005db:	29 c1                	sub    %eax,%ecx
  8005dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e6:	89 cb                	mov    %ecx,%ebx
  8005e8:	eb 16                	jmp    800600 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ee:	75 31                	jne    800621 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	ff 55 08             	call   *0x8(%ebp)
  8005fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fd:	83 eb 01             	sub    $0x1,%ebx
  800600:	83 c7 01             	add    $0x1,%edi
  800603:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800607:	0f be c2             	movsbl %dl,%eax
  80060a:	85 c0                	test   %eax,%eax
  80060c:	74 59                	je     800667 <vprintfmt+0x25d>
  80060e:	85 f6                	test   %esi,%esi
  800610:	78 d8                	js     8005ea <vprintfmt+0x1e0>
  800612:	83 ee 01             	sub    $0x1,%esi
  800615:	79 d3                	jns    8005ea <vprintfmt+0x1e0>
  800617:	89 df                	mov    %ebx,%edi
  800619:	8b 75 08             	mov    0x8(%ebp),%esi
  80061c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80061f:	eb 37                	jmp    800658 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800621:	0f be d2             	movsbl %dl,%edx
  800624:	83 ea 20             	sub    $0x20,%edx
  800627:	83 fa 5e             	cmp    $0x5e,%edx
  80062a:	76 c4                	jbe    8005f0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	6a 3f                	push   $0x3f
  800634:	ff 55 08             	call   *0x8(%ebp)
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	eb c1                	jmp    8005fd <vprintfmt+0x1f3>
  80063c:	89 75 08             	mov    %esi,0x8(%ebp)
  80063f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800642:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800645:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800648:	eb b6                	jmp    800600 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 20                	push   $0x20
  800650:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800652:	83 ef 01             	sub    $0x1,%edi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	85 ff                	test   %edi,%edi
  80065a:	7f ee                	jg     80064a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	e9 d8 01 00 00       	jmp    80083f <vprintfmt+0x435>
  800667:	89 df                	mov    %ebx,%edi
  800669:	8b 75 08             	mov    0x8(%ebp),%esi
  80066c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80066f:	eb e7                	jmp    800658 <vprintfmt+0x24e>
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7e 45                	jle    8006bb <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 50 04             	mov    0x4(%eax),%edx
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800691:	79 62                	jns    8006f5 <vprintfmt+0x2eb>
				putch('-', putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	53                   	push   %ebx
  800697:	6a 2d                	push   $0x2d
  800699:	ff d6                	call   *%esi
				num = -(long long) num;
  80069b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80069e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006a1:	f7 d8                	neg    %eax
  8006a3:	83 d2 00             	adc    $0x0,%edx
  8006a6:	f7 da                	neg    %edx
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ae:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006b6:	e9 66 01 00 00       	jmp    800821 <vprintfmt+0x417>
	else if (lflag)
  8006bb:	85 c9                	test   %ecx,%ecx
  8006bd:	75 1b                	jne    8006da <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 c1                	mov    %eax,%ecx
  8006c9:	c1 f9 1f             	sar    $0x1f,%ecx
  8006cc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8d 40 04             	lea    0x4(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d8:	eb b3                	jmp    80068d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e2:	89 c1                	mov    %eax,%ecx
  8006e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	eb 98                	jmp    80068d <vprintfmt+0x283>
			base = 10;
  8006f5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006fa:	e9 22 01 00 00       	jmp    800821 <vprintfmt+0x417>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7e 21                	jle    800725 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 50 04             	mov    0x4(%eax),%edx
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 40 08             	lea    0x8(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800720:	e9 fc 00 00 00       	jmp    800821 <vprintfmt+0x417>
	else if (lflag)
  800725:	85 c9                	test   %ecx,%ecx
  800727:	75 23                	jne    80074c <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800742:	ba 0a 00 00 00       	mov    $0xa,%edx
  800747:	e9 d5 00 00 00       	jmp    800821 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 40 04             	lea    0x4(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800765:	ba 0a 00 00 00       	mov    $0xa,%edx
  80076a:	e9 b2 00 00 00       	jmp    800821 <vprintfmt+0x417>
	if (lflag >= 2)
  80076f:	83 f9 01             	cmp    $0x1,%ecx
  800772:	7e 42                	jle    8007b6 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 50 04             	mov    0x4(%eax),%edx
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 40 08             	lea    0x8(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078b:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800790:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800794:	0f 89 87 00 00 00    	jns    800821 <vprintfmt+0x417>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	6a 2d                	push   $0x2d
  8007a0:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a2:	f7 5d d8             	negl   -0x28(%ebp)
  8007a5:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8007a9:	f7 5d dc             	negl   -0x24(%ebp)
  8007ac:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007af:	ba 08 00 00 00       	mov    $0x8,%edx
  8007b4:	eb 6b                	jmp    800821 <vprintfmt+0x417>
	else if (lflag)
  8007b6:	85 c9                	test   %ecx,%ecx
  8007b8:	75 1b                	jne    8007d5 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8d 40 04             	lea    0x4(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d3:	eb b6                	jmp    80078b <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ee:	eb 9b                	jmp    80078b <vprintfmt+0x381>
			putch('0', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	6a 30                	push   $0x30
  8007f6:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f8:	83 c4 08             	add    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	6a 78                	push   $0x78
  8007fe:	ff d6                	call   *%esi
			num = (unsigned long long)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800810:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8d 40 04             	lea    0x4(%eax),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081c:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800821:	83 ec 0c             	sub    $0xc,%esp
  800824:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800828:	50                   	push   %eax
  800829:	ff 75 e0             	pushl  -0x20(%ebp)
  80082c:	52                   	push   %edx
  80082d:	ff 75 dc             	pushl  -0x24(%ebp)
  800830:	ff 75 d8             	pushl  -0x28(%ebp)
  800833:	89 da                	mov    %ebx,%edx
  800835:	89 f0                	mov    %esi,%eax
  800837:	e8 e5 fa ff ff       	call   800321 <printnum>
			break;
  80083c:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80083f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800842:	83 c7 01             	add    $0x1,%edi
  800845:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800849:	83 f8 25             	cmp    $0x25,%eax
  80084c:	0f 84 cf fb ff ff    	je     800421 <vprintfmt+0x17>
			if (ch == '\0')
  800852:	85 c0                	test   %eax,%eax
  800854:	0f 84 a9 00 00 00    	je     800903 <vprintfmt+0x4f9>
			putch(ch, putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	53                   	push   %ebx
  80085e:	50                   	push   %eax
  80085f:	ff d6                	call   *%esi
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	eb dc                	jmp    800842 <vprintfmt+0x438>
	if (lflag >= 2)
  800866:	83 f9 01             	cmp    $0x1,%ecx
  800869:	7e 1e                	jle    800889 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 50 04             	mov    0x4(%eax),%edx
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800876:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8d 40 08             	lea    0x8(%eax),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800882:	ba 10 00 00 00       	mov    $0x10,%edx
  800887:	eb 98                	jmp    800821 <vprintfmt+0x417>
	else if (lflag)
  800889:	85 c9                	test   %ecx,%ecx
  80088b:	75 23                	jne    8008b0 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	ba 00 00 00 00       	mov    $0x0,%edx
  800897:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a6:	ba 10 00 00 00       	mov    $0x10,%edx
  8008ab:	e9 71 ff ff ff       	jmp    800821 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8b 00                	mov    (%eax),%eax
  8008b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	8d 40 04             	lea    0x4(%eax),%eax
  8008c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c9:	ba 10 00 00 00       	mov    $0x10,%edx
  8008ce:	e9 4e ff ff ff       	jmp    800821 <vprintfmt+0x417>
			putch(ch, putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	53                   	push   %ebx
  8008d7:	6a 25                	push   $0x25
  8008d9:	ff d6                	call   *%esi
			break;
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	e9 5c ff ff ff       	jmp    80083f <vprintfmt+0x435>
			putch('%', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	53                   	push   %ebx
  8008e7:	6a 25                	push   $0x25
  8008e9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 f8                	mov    %edi,%eax
  8008f0:	eb 03                	jmp    8008f5 <vprintfmt+0x4eb>
  8008f2:	83 e8 01             	sub    $0x1,%eax
  8008f5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008f9:	75 f7                	jne    8008f2 <vprintfmt+0x4e8>
  8008fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008fe:	e9 3c ff ff ff       	jmp    80083f <vprintfmt+0x435>
}
  800903:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800906:	5b                   	pop    %ebx
  800907:	5e                   	pop    %esi
  800908:	5f                   	pop    %edi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 18             	sub    $0x18,%esp
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800917:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80091e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800928:	85 c0                	test   %eax,%eax
  80092a:	74 26                	je     800952 <vsnprintf+0x47>
  80092c:	85 d2                	test   %edx,%edx
  80092e:	7e 22                	jle    800952 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800930:	ff 75 14             	pushl  0x14(%ebp)
  800933:	ff 75 10             	pushl  0x10(%ebp)
  800936:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800939:	50                   	push   %eax
  80093a:	68 d0 03 80 00       	push   $0x8003d0
  80093f:	e8 c6 fa ff ff       	call   80040a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800947:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094d:	83 c4 10             	add    $0x10,%esp
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    
		return -E_INVAL;
  800952:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800957:	eb f7                	jmp    800950 <vsnprintf+0x45>

00800959 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80095f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800962:	50                   	push   %eax
  800963:	ff 75 10             	pushl  0x10(%ebp)
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	ff 75 08             	pushl  0x8(%ebp)
  80096c:	e8 9a ff ff ff       	call   80090b <vsnprintf>
	va_end(ap);

	return rc;
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	eb 03                	jmp    800983 <strlen+0x10>
		n++;
  800980:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800987:	75 f7                	jne    800980 <strlen+0xd>
	return n;
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
  800999:	eb 03                	jmp    80099e <strnlen+0x13>
		n++;
  80099b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099e:	39 d0                	cmp    %edx,%eax
  8009a0:	74 06                	je     8009a8 <strnlen+0x1d>
  8009a2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a6:	75 f3                	jne    80099b <strnlen+0x10>
	return n;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b4:	89 c2                	mov    %eax,%edx
  8009b6:	83 c1 01             	add    $0x1,%ecx
  8009b9:	83 c2 01             	add    $0x1,%edx
  8009bc:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009c0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c3:	84 db                	test   %bl,%bl
  8009c5:	75 ef                	jne    8009b6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d1:	53                   	push   %ebx
  8009d2:	e8 9c ff ff ff       	call   800973 <strlen>
  8009d7:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	01 d8                	add    %ebx,%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 c5 ff ff ff       	call   8009aa <strcpy>
	return dst;
}
  8009e5:	89 d8                	mov    %ebx,%eax
  8009e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	56                   	push   %esi
  8009f0:	53                   	push   %ebx
  8009f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f7:	89 f3                	mov    %esi,%ebx
  8009f9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009fc:	89 f2                	mov    %esi,%edx
  8009fe:	eb 0f                	jmp    800a0f <strncpy+0x23>
		*dst++ = *src;
  800a00:	83 c2 01             	add    $0x1,%edx
  800a03:	0f b6 01             	movzbl (%ecx),%eax
  800a06:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a09:	80 39 01             	cmpb   $0x1,(%ecx)
  800a0c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a0f:	39 da                	cmp    %ebx,%edx
  800a11:	75 ed                	jne    800a00 <strncpy+0x14>
	}
	return ret;
}
  800a13:	89 f0                	mov    %esi,%eax
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	56                   	push   %esi
  800a1d:	53                   	push   %ebx
  800a1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a27:	89 f0                	mov    %esi,%eax
  800a29:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a2d:	85 c9                	test   %ecx,%ecx
  800a2f:	75 0b                	jne    800a3c <strlcpy+0x23>
  800a31:	eb 17                	jmp    800a4a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a3c:	39 d8                	cmp    %ebx,%eax
  800a3e:	74 07                	je     800a47 <strlcpy+0x2e>
  800a40:	0f b6 0a             	movzbl (%edx),%ecx
  800a43:	84 c9                	test   %cl,%cl
  800a45:	75 ec                	jne    800a33 <strlcpy+0x1a>
		*dst = '\0';
  800a47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4a:	29 f0                	sub    %esi,%eax
}
  800a4c:	5b                   	pop    %ebx
  800a4d:	5e                   	pop    %esi
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a56:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a59:	eb 06                	jmp    800a61 <strcmp+0x11>
		p++, q++;
  800a5b:	83 c1 01             	add    $0x1,%ecx
  800a5e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a61:	0f b6 01             	movzbl (%ecx),%eax
  800a64:	84 c0                	test   %al,%al
  800a66:	74 04                	je     800a6c <strcmp+0x1c>
  800a68:	3a 02                	cmp    (%edx),%al
  800a6a:	74 ef                	je     800a5b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6c:	0f b6 c0             	movzbl %al,%eax
  800a6f:	0f b6 12             	movzbl (%edx),%edx
  800a72:	29 d0                	sub    %edx,%eax
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	53                   	push   %ebx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	89 c3                	mov    %eax,%ebx
  800a82:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a85:	eb 06                	jmp    800a8d <strncmp+0x17>
		n--, p++, q++;
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a8d:	39 d8                	cmp    %ebx,%eax
  800a8f:	74 16                	je     800aa7 <strncmp+0x31>
  800a91:	0f b6 08             	movzbl (%eax),%ecx
  800a94:	84 c9                	test   %cl,%cl
  800a96:	74 04                	je     800a9c <strncmp+0x26>
  800a98:	3a 0a                	cmp    (%edx),%cl
  800a9a:	74 eb                	je     800a87 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9c:	0f b6 00             	movzbl (%eax),%eax
  800a9f:	0f b6 12             	movzbl (%edx),%edx
  800aa2:	29 d0                	sub    %edx,%eax
}
  800aa4:	5b                   	pop    %ebx
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    
		return 0;
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aac:	eb f6                	jmp    800aa4 <strncmp+0x2e>

00800aae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab8:	0f b6 10             	movzbl (%eax),%edx
  800abb:	84 d2                	test   %dl,%dl
  800abd:	74 09                	je     800ac8 <strchr+0x1a>
		if (*s == c)
  800abf:	38 ca                	cmp    %cl,%dl
  800ac1:	74 0a                	je     800acd <strchr+0x1f>
	for (; *s; s++)
  800ac3:	83 c0 01             	add    $0x1,%eax
  800ac6:	eb f0                	jmp    800ab8 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad9:	eb 03                	jmp    800ade <strfind+0xf>
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ae1:	38 ca                	cmp    %cl,%dl
  800ae3:	74 04                	je     800ae9 <strfind+0x1a>
  800ae5:	84 d2                	test   %dl,%dl
  800ae7:	75 f2                	jne    800adb <strfind+0xc>
			break;
	return (char *) s;
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	57                   	push   %edi
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
  800af1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af7:	85 c9                	test   %ecx,%ecx
  800af9:	74 13                	je     800b0e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b01:	75 05                	jne    800b08 <memset+0x1d>
  800b03:	f6 c1 03             	test   $0x3,%cl
  800b06:	74 0d                	je     800b15 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	fc                   	cld    
  800b0c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0e:	89 f8                	mov    %edi,%eax
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5f                   	pop    %edi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    
		c &= 0xFF;
  800b15:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b19:	89 d3                	mov    %edx,%ebx
  800b1b:	c1 e3 08             	shl    $0x8,%ebx
  800b1e:	89 d0                	mov    %edx,%eax
  800b20:	c1 e0 18             	shl    $0x18,%eax
  800b23:	89 d6                	mov    %edx,%esi
  800b25:	c1 e6 10             	shl    $0x10,%esi
  800b28:	09 f0                	or     %esi,%eax
  800b2a:	09 c2                	or     %eax,%edx
  800b2c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b2e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b31:	89 d0                	mov    %edx,%eax
  800b33:	fc                   	cld    
  800b34:	f3 ab                	rep stos %eax,%es:(%edi)
  800b36:	eb d6                	jmp    800b0e <memset+0x23>

00800b38 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b46:	39 c6                	cmp    %eax,%esi
  800b48:	73 35                	jae    800b7f <memmove+0x47>
  800b4a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	76 2e                	jbe    800b7f <memmove+0x47>
		s += n;
		d += n;
  800b51:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b54:	89 d6                	mov    %edx,%esi
  800b56:	09 fe                	or     %edi,%esi
  800b58:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5e:	74 0c                	je     800b6c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b60:	83 ef 01             	sub    $0x1,%edi
  800b63:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b66:	fd                   	std    
  800b67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b69:	fc                   	cld    
  800b6a:	eb 21                	jmp    800b8d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6c:	f6 c1 03             	test   $0x3,%cl
  800b6f:	75 ef                	jne    800b60 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b71:	83 ef 04             	sub    $0x4,%edi
  800b74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b77:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7d:	eb ea                	jmp    800b69 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7f:	89 f2                	mov    %esi,%edx
  800b81:	09 c2                	or     %eax,%edx
  800b83:	f6 c2 03             	test   $0x3,%dl
  800b86:	74 09                	je     800b91 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b88:	89 c7                	mov    %eax,%edi
  800b8a:	fc                   	cld    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b91:	f6 c1 03             	test   $0x3,%cl
  800b94:	75 f2                	jne    800b88 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b96:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b99:	89 c7                	mov    %eax,%edi
  800b9b:	fc                   	cld    
  800b9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9e:	eb ed                	jmp    800b8d <memmove+0x55>

00800ba0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ba3:	ff 75 10             	pushl  0x10(%ebp)
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 87 ff ff ff       	call   800b38 <memmove>
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbe:	89 c6                	mov    %eax,%esi
  800bc0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc3:	39 f0                	cmp    %esi,%eax
  800bc5:	74 1c                	je     800be3 <memcmp+0x30>
		if (*s1 != *s2)
  800bc7:	0f b6 08             	movzbl (%eax),%ecx
  800bca:	0f b6 1a             	movzbl (%edx),%ebx
  800bcd:	38 d9                	cmp    %bl,%cl
  800bcf:	75 08                	jne    800bd9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bd1:	83 c0 01             	add    $0x1,%eax
  800bd4:	83 c2 01             	add    $0x1,%edx
  800bd7:	eb ea                	jmp    800bc3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bd9:	0f b6 c1             	movzbl %cl,%eax
  800bdc:	0f b6 db             	movzbl %bl,%ebx
  800bdf:	29 d8                	sub    %ebx,%eax
  800be1:	eb 05                	jmp    800be8 <memcmp+0x35>
	}

	return 0;
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bf5:	89 c2                	mov    %eax,%edx
  800bf7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bfa:	39 d0                	cmp    %edx,%eax
  800bfc:	73 09                	jae    800c07 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bfe:	38 08                	cmp    %cl,(%eax)
  800c00:	74 05                	je     800c07 <memfind+0x1b>
	for (; s < ends; s++)
  800c02:	83 c0 01             	add    $0x1,%eax
  800c05:	eb f3                	jmp    800bfa <memfind+0xe>
			break;
	return (void *) s;
}
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    

00800c09 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c15:	eb 03                	jmp    800c1a <strtol+0x11>
		s++;
  800c17:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c1a:	0f b6 01             	movzbl (%ecx),%eax
  800c1d:	3c 20                	cmp    $0x20,%al
  800c1f:	74 f6                	je     800c17 <strtol+0xe>
  800c21:	3c 09                	cmp    $0x9,%al
  800c23:	74 f2                	je     800c17 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c25:	3c 2b                	cmp    $0x2b,%al
  800c27:	74 2e                	je     800c57 <strtol+0x4e>
	int neg = 0;
  800c29:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c2e:	3c 2d                	cmp    $0x2d,%al
  800c30:	74 2f                	je     800c61 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c32:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c38:	75 05                	jne    800c3f <strtol+0x36>
  800c3a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c3d:	74 2c                	je     800c6b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c3f:	85 db                	test   %ebx,%ebx
  800c41:	75 0a                	jne    800c4d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c43:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c48:	80 39 30             	cmpb   $0x30,(%ecx)
  800c4b:	74 28                	je     800c75 <strtol+0x6c>
		base = 10;
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c52:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c55:	eb 50                	jmp    800ca7 <strtol+0x9e>
		s++;
  800c57:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c5a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c5f:	eb d1                	jmp    800c32 <strtol+0x29>
		s++, neg = 1;
  800c61:	83 c1 01             	add    $0x1,%ecx
  800c64:	bf 01 00 00 00       	mov    $0x1,%edi
  800c69:	eb c7                	jmp    800c32 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c6f:	74 0e                	je     800c7f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c71:	85 db                	test   %ebx,%ebx
  800c73:	75 d8                	jne    800c4d <strtol+0x44>
		s++, base = 8;
  800c75:	83 c1 01             	add    $0x1,%ecx
  800c78:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c7d:	eb ce                	jmp    800c4d <strtol+0x44>
		s += 2, base = 16;
  800c7f:	83 c1 02             	add    $0x2,%ecx
  800c82:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c87:	eb c4                	jmp    800c4d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c89:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c8c:	89 f3                	mov    %esi,%ebx
  800c8e:	80 fb 19             	cmp    $0x19,%bl
  800c91:	77 29                	ja     800cbc <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c93:	0f be d2             	movsbl %dl,%edx
  800c96:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c99:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c9c:	7d 30                	jge    800cce <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c9e:	83 c1 01             	add    $0x1,%ecx
  800ca1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ca5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ca7:	0f b6 11             	movzbl (%ecx),%edx
  800caa:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cad:	89 f3                	mov    %esi,%ebx
  800caf:	80 fb 09             	cmp    $0x9,%bl
  800cb2:	77 d5                	ja     800c89 <strtol+0x80>
			dig = *s - '0';
  800cb4:	0f be d2             	movsbl %dl,%edx
  800cb7:	83 ea 30             	sub    $0x30,%edx
  800cba:	eb dd                	jmp    800c99 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800cbc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cbf:	89 f3                	mov    %esi,%ebx
  800cc1:	80 fb 19             	cmp    $0x19,%bl
  800cc4:	77 08                	ja     800cce <strtol+0xc5>
			dig = *s - 'A' + 10;
  800cc6:	0f be d2             	movsbl %dl,%edx
  800cc9:	83 ea 37             	sub    $0x37,%edx
  800ccc:	eb cb                	jmp    800c99 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd2:	74 05                	je     800cd9 <strtol+0xd0>
		*endptr = (char *) s;
  800cd4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cd9:	89 c2                	mov    %eax,%edx
  800cdb:	f7 da                	neg    %edx
  800cdd:	85 ff                	test   %edi,%edi
  800cdf:	0f 45 c2             	cmovne %edx,%eax
}
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	89 c3                	mov    %eax,%ebx
  800cfa:	89 c7                	mov    %eax,%edi
  800cfc:	89 c6                	mov    %eax,%esi
  800cfe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 01 00 00 00       	mov    $0x1,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	b8 03 00 00 00       	mov    $0x3,%eax
  800d3a:	89 cb                	mov    %ecx,%ebx
  800d3c:	89 cf                	mov    %ecx,%edi
  800d3e:	89 ce                	mov    %ecx,%esi
  800d40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	7f 08                	jg     800d4e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4e:	83 ec 0c             	sub    $0xc,%esp
  800d51:	50                   	push   %eax
  800d52:	6a 03                	push   $0x3
  800d54:	68 5f 2c 80 00       	push   $0x802c5f
  800d59:	6a 23                	push   $0x23
  800d5b:	68 7c 2c 80 00       	push   $0x802c7c
  800d60:	e8 cd f4 ff ff       	call   800232 <_panic>

00800d65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	b8 02 00 00 00       	mov    $0x2,%eax
  800d75:	89 d1                	mov    %edx,%ecx
  800d77:	89 d3                	mov    %edx,%ebx
  800d79:	89 d7                	mov    %edx,%edi
  800d7b:	89 d6                	mov    %edx,%esi
  800d7d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <sys_yield>:

void
sys_yield(void)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d94:	89 d1                	mov    %edx,%ecx
  800d96:	89 d3                	mov    %edx,%ebx
  800d98:	89 d7                	mov    %edx,%edi
  800d9a:	89 d6                	mov    %edx,%esi
  800d9c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbf:	89 f7                	mov    %esi,%edi
  800dc1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	7f 08                	jg     800dcf <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	50                   	push   %eax
  800dd3:	6a 04                	push   $0x4
  800dd5:	68 5f 2c 80 00       	push   $0x802c5f
  800dda:	6a 23                	push   $0x23
  800ddc:	68 7c 2c 80 00       	push   $0x802c7c
  800de1:	e8 4c f4 ff ff       	call   800232 <_panic>

00800de6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	b8 05 00 00 00       	mov    $0x5,%eax
  800dfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e00:	8b 75 18             	mov    0x18(%ebp),%esi
  800e03:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e05:	85 c0                	test   %eax,%eax
  800e07:	7f 08                	jg     800e11 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5f                   	pop    %edi
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e11:	83 ec 0c             	sub    $0xc,%esp
  800e14:	50                   	push   %eax
  800e15:	6a 05                	push   $0x5
  800e17:	68 5f 2c 80 00       	push   $0x802c5f
  800e1c:	6a 23                	push   $0x23
  800e1e:	68 7c 2c 80 00       	push   $0x802c7c
  800e23:	e8 0a f4 ff ff       	call   800232 <_panic>

00800e28 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3c:	b8 06 00 00 00       	mov    $0x6,%eax
  800e41:	89 df                	mov    %ebx,%edi
  800e43:	89 de                	mov    %ebx,%esi
  800e45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7f 08                	jg     800e53 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	6a 06                	push   $0x6
  800e59:	68 5f 2c 80 00       	push   $0x802c5f
  800e5e:	6a 23                	push   $0x23
  800e60:	68 7c 2c 80 00       	push   $0x802c7c
  800e65:	e8 c8 f3 ff ff       	call   800232 <_panic>

00800e6a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	89 de                	mov    %ebx,%esi
  800e87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7f 08                	jg     800e95 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	50                   	push   %eax
  800e99:	6a 08                	push   $0x8
  800e9b:	68 5f 2c 80 00       	push   $0x802c5f
  800ea0:	6a 23                	push   $0x23
  800ea2:	68 7c 2c 80 00       	push   $0x802c7c
  800ea7:	e8 86 f3 ff ff       	call   800232 <_panic>

00800eac <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec5:	89 df                	mov    %ebx,%edi
  800ec7:	89 de                	mov    %ebx,%esi
  800ec9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	7f 08                	jg     800ed7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	50                   	push   %eax
  800edb:	6a 09                	push   $0x9
  800edd:	68 5f 2c 80 00       	push   $0x802c5f
  800ee2:	6a 23                	push   $0x23
  800ee4:	68 7c 2c 80 00       	push   $0x802c7c
  800ee9:	e8 44 f3 ff ff       	call   800232 <_panic>

00800eee <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f07:	89 df                	mov    %ebx,%edi
  800f09:	89 de                	mov    %ebx,%esi
  800f0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	7f 08                	jg     800f19 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f19:	83 ec 0c             	sub    $0xc,%esp
  800f1c:	50                   	push   %eax
  800f1d:	6a 0a                	push   $0xa
  800f1f:	68 5f 2c 80 00       	push   $0x802c5f
  800f24:	6a 23                	push   $0x23
  800f26:	68 7c 2c 80 00       	push   $0x802c7c
  800f2b:	e8 02 f3 ff ff       	call   800232 <_panic>

00800f30 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f41:	be 00 00 00 00       	mov    $0x0,%esi
  800f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f49:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f69:	89 cb                	mov    %ecx,%ebx
  800f6b:	89 cf                	mov    %ecx,%edi
  800f6d:	89 ce                	mov    %ecx,%esi
  800f6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	7f 08                	jg     800f7d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	83 ec 0c             	sub    $0xc,%esp
  800f80:	50                   	push   %eax
  800f81:	6a 0d                	push   $0xd
  800f83:	68 5f 2c 80 00       	push   $0x802c5f
  800f88:	6a 23                	push   $0x23
  800f8a:	68 7c 2c 80 00       	push   $0x802c7c
  800f8f:	e8 9e f2 ff ff       	call   800232 <_panic>

00800f94 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fa4:	89 d1                	mov    %edx,%ecx
  800fa6:	89 d3                	mov    %edx,%ebx
  800fa8:	89 d7                	mov    %edx,%edi
  800faa:	89 d6                	mov    %edx,%esi
  800fac:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
  800fb9:	83 ec 1c             	sub    $0x1c,%esp
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800fbf:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800fc1:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800fc4:	89 d8                	mov    %ebx,%eax
  800fc6:	c1 e8 0c             	shr    $0xc,%eax
  800fc9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800fd3:	e8 8d fd ff ff       	call   800d65 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800fd8:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800fde:	74 73                	je     801053 <pgfault+0xa0>
  800fe0:	89 c6                	mov    %eax,%esi
  800fe2:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800fe9:	74 68                	je     801053 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800feb:	83 ec 04             	sub    $0x4,%esp
  800fee:	6a 07                	push   $0x7
  800ff0:	68 00 f0 7f 00       	push   $0x7ff000
  800ff5:	50                   	push   %eax
  800ff6:	e8 a8 fd ff ff       	call   800da3 <sys_page_alloc>
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	75 65                	jne    801067 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801002:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	68 00 10 00 00       	push   $0x1000
  801010:	53                   	push   %ebx
  801011:	68 00 f0 7f 00       	push   $0x7ff000
  801016:	e8 85 fb ff ff       	call   800ba0 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80101b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801022:	53                   	push   %ebx
  801023:	56                   	push   %esi
  801024:	68 00 f0 7f 00       	push   $0x7ff000
  801029:	56                   	push   %esi
  80102a:	e8 b7 fd ff ff       	call   800de6 <sys_page_map>
  80102f:	83 c4 20             	add    $0x20,%esp
  801032:	85 c0                	test   %eax,%eax
  801034:	75 43                	jne    801079 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	68 00 f0 7f 00       	push   $0x7ff000
  80103e:	56                   	push   %esi
  80103f:	e8 e4 fd ff ff       	call   800e28 <sys_page_unmap>
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	75 40                	jne    80108b <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  80104b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	68 8a 2c 80 00       	push   $0x802c8a
  80105b:	6a 1f                	push   $0x1f
  80105d:	68 a8 2c 80 00       	push   $0x802ca8
  801062:	e8 cb f1 ff ff       	call   800232 <_panic>
	    panic("pgfault: %e", r);
  801067:	50                   	push   %eax
  801068:	68 b3 2c 80 00       	push   $0x802cb3
  80106d:	6a 2a                	push   $0x2a
  80106f:	68 a8 2c 80 00       	push   $0x802ca8
  801074:	e8 b9 f1 ff ff       	call   800232 <_panic>
	    panic("pgfault: %e", r);
  801079:	50                   	push   %eax
  80107a:	68 b3 2c 80 00       	push   $0x802cb3
  80107f:	6a 2e                	push   $0x2e
  801081:	68 a8 2c 80 00       	push   $0x802ca8
  801086:	e8 a7 f1 ff ff       	call   800232 <_panic>
	    panic("pgfault: %e", r);
  80108b:	50                   	push   %eax
  80108c:	68 b3 2c 80 00       	push   $0x802cb3
  801091:	6a 31                	push   $0x31
  801093:	68 a8 2c 80 00       	push   $0x802ca8
  801098:	e8 95 f1 ff ff       	call   800232 <_panic>

0080109d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  8010a6:	68 b3 0f 80 00       	push   $0x800fb3
  8010ab:	e8 8e 13 00 00       	call   80243e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010b0:	b8 07 00 00 00       	mov    $0x7,%eax
  8010b5:	cd 30                	int    $0x30
  8010b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 2b                	js     8010ef <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010c4:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010cd:	0f 85 b5 00 00 00    	jne    801188 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  8010d3:	e8 8d fc ff ff       	call   800d65 <sys_getenvid>
  8010d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010e5:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  8010ea:	e9 8c 01 00 00       	jmp    80127b <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  8010ef:	50                   	push   %eax
  8010f0:	68 bf 2c 80 00       	push   $0x802cbf
  8010f5:	6a 77                	push   $0x77
  8010f7:	68 a8 2c 80 00       	push   $0x802ca8
  8010fc:	e8 31 f1 ff ff       	call   800232 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801101:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	25 07 0e 00 00       	and    $0xe07,%eax
  801110:	50                   	push   %eax
  801111:	57                   	push   %edi
  801112:	ff 75 e0             	pushl  -0x20(%ebp)
  801115:	57                   	push   %edi
  801116:	ff 75 e4             	pushl  -0x1c(%ebp)
  801119:	e8 c8 fc ff ff       	call   800de6 <sys_page_map>
  80111e:	83 c4 20             	add    $0x20,%esp
  801121:	85 c0                	test   %eax,%eax
  801123:	74 51                	je     801176 <fork+0xd9>
           panic("duppage: %e", r);
  801125:	50                   	push   %eax
  801126:	68 cf 2c 80 00       	push   $0x802ccf
  80112b:	6a 4a                	push   $0x4a
  80112d:	68 a8 2c 80 00       	push   $0x802ca8
  801132:	e8 fb f0 ff ff       	call   800232 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	68 05 08 00 00       	push   $0x805
  80113f:	57                   	push   %edi
  801140:	ff 75 e0             	pushl  -0x20(%ebp)
  801143:	57                   	push   %edi
  801144:	ff 75 e4             	pushl  -0x1c(%ebp)
  801147:	e8 9a fc ff ff       	call   800de6 <sys_page_map>
  80114c:	83 c4 20             	add    $0x20,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	0f 85 bc 00 00 00    	jne    801213 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	68 05 08 00 00       	push   $0x805
  80115f:	57                   	push   %edi
  801160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801163:	50                   	push   %eax
  801164:	57                   	push   %edi
  801165:	50                   	push   %eax
  801166:	e8 7b fc ff ff       	call   800de6 <sys_page_map>
  80116b:	83 c4 20             	add    $0x20,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	0f 85 af 00 00 00    	jne    801225 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801176:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80117c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801182:	0f 84 af 00 00 00    	je     801237 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801188:	89 d8                	mov    %ebx,%eax
  80118a:	c1 e8 16             	shr    $0x16,%eax
  80118d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801194:	a8 01                	test   $0x1,%al
  801196:	74 de                	je     801176 <fork+0xd9>
  801198:	89 de                	mov    %ebx,%esi
  80119a:	c1 ee 0c             	shr    $0xc,%esi
  80119d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011a4:	a8 01                	test   $0x1,%al
  8011a6:	74 ce                	je     801176 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8011a8:	e8 b8 fb ff ff       	call   800d65 <sys_getenvid>
  8011ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8011b0:	89 f7                	mov    %esi,%edi
  8011b2:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8011b5:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011bc:	f6 c4 04             	test   $0x4,%ah
  8011bf:	0f 85 3c ff ff ff    	jne    801101 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8011c5:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011cc:	a8 02                	test   $0x2,%al
  8011ce:	0f 85 63 ff ff ff    	jne    801137 <fork+0x9a>
  8011d4:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011db:	f6 c4 08             	test   $0x8,%ah
  8011de:	0f 85 53 ff ff ff    	jne    801137 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	6a 05                	push   $0x5
  8011e9:	57                   	push   %edi
  8011ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8011ed:	57                   	push   %edi
  8011ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f1:	e8 f0 fb ff ff       	call   800de6 <sys_page_map>
  8011f6:	83 c4 20             	add    $0x20,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	0f 84 75 ff ff ff    	je     801176 <fork+0xd9>
	        panic("duppage: %e", r);
  801201:	50                   	push   %eax
  801202:	68 cf 2c 80 00       	push   $0x802ccf
  801207:	6a 55                	push   $0x55
  801209:	68 a8 2c 80 00       	push   $0x802ca8
  80120e:	e8 1f f0 ff ff       	call   800232 <_panic>
	        panic("duppage: %e", r);
  801213:	50                   	push   %eax
  801214:	68 cf 2c 80 00       	push   $0x802ccf
  801219:	6a 4e                	push   $0x4e
  80121b:	68 a8 2c 80 00       	push   $0x802ca8
  801220:	e8 0d f0 ff ff       	call   800232 <_panic>
	        panic("duppage: %e", r);
  801225:	50                   	push   %eax
  801226:	68 cf 2c 80 00       	push   $0x802ccf
  80122b:	6a 51                	push   $0x51
  80122d:	68 a8 2c 80 00       	push   $0x802ca8
  801232:	e8 fb ef ff ff       	call   800232 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	6a 07                	push   $0x7
  80123c:	68 00 f0 bf ee       	push   $0xeebff000
  801241:	ff 75 dc             	pushl  -0x24(%ebp)
  801244:	e8 5a fb ff ff       	call   800da3 <sys_page_alloc>
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	75 36                	jne    801286 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	68 b7 24 80 00       	push   $0x8024b7
  801258:	ff 75 dc             	pushl  -0x24(%ebp)
  80125b:	e8 8e fc ff ff       	call   800eee <sys_env_set_pgfault_upcall>
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	75 34                	jne    80129b <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	6a 02                	push   $0x2
  80126c:	ff 75 dc             	pushl  -0x24(%ebp)
  80126f:	e8 f6 fb ff ff       	call   800e6a <sys_env_set_status>
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	75 35                	jne    8012b0 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  80127b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80127e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    
	    panic("fork: %e", r);
  801286:	50                   	push   %eax
  801287:	68 c6 2c 80 00       	push   $0x802cc6
  80128c:	68 8a 00 00 00       	push   $0x8a
  801291:	68 a8 2c 80 00       	push   $0x802ca8
  801296:	e8 97 ef ff ff       	call   800232 <_panic>
	    panic("fork: %e", r);
  80129b:	50                   	push   %eax
  80129c:	68 c6 2c 80 00       	push   $0x802cc6
  8012a1:	68 8d 00 00 00       	push   $0x8d
  8012a6:	68 a8 2c 80 00       	push   $0x802ca8
  8012ab:	e8 82 ef ff ff       	call   800232 <_panic>
	    panic("fork: %e", r);
  8012b0:	50                   	push   %eax
  8012b1:	68 c6 2c 80 00       	push   $0x802cc6
  8012b6:	68 92 00 00 00       	push   $0x92
  8012bb:	68 a8 2c 80 00       	push   $0x802ca8
  8012c0:	e8 6d ef ff ff       	call   800232 <_panic>

008012c5 <sfork>:

// Challenge!
int
sfork(void)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012cb:	68 db 2c 80 00       	push   $0x802cdb
  8012d0:	68 9b 00 00 00       	push   $0x9b
  8012d5:	68 a8 2c 80 00       	push   $0x802ca8
  8012da:	e8 53 ef ff ff       	call   800232 <_panic>

008012df <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ea:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ff:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    

00801306 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801311:	89 c2                	mov    %eax,%edx
  801313:	c1 ea 16             	shr    $0x16,%edx
  801316:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131d:	f6 c2 01             	test   $0x1,%dl
  801320:	74 2a                	je     80134c <fd_alloc+0x46>
  801322:	89 c2                	mov    %eax,%edx
  801324:	c1 ea 0c             	shr    $0xc,%edx
  801327:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132e:	f6 c2 01             	test   $0x1,%dl
  801331:	74 19                	je     80134c <fd_alloc+0x46>
  801333:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801338:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80133d:	75 d2                	jne    801311 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80133f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801345:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80134a:	eb 07                	jmp    801353 <fd_alloc+0x4d>
			*fd_store = fd;
  80134c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    

00801355 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80135b:	83 f8 1f             	cmp    $0x1f,%eax
  80135e:	77 36                	ja     801396 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801360:	c1 e0 0c             	shl    $0xc,%eax
  801363:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801368:	89 c2                	mov    %eax,%edx
  80136a:	c1 ea 16             	shr    $0x16,%edx
  80136d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801374:	f6 c2 01             	test   $0x1,%dl
  801377:	74 24                	je     80139d <fd_lookup+0x48>
  801379:	89 c2                	mov    %eax,%edx
  80137b:	c1 ea 0c             	shr    $0xc,%edx
  80137e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801385:	f6 c2 01             	test   $0x1,%dl
  801388:	74 1a                	je     8013a4 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80138a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138d:	89 02                	mov    %eax,(%edx)
	return 0;
  80138f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801394:	5d                   	pop    %ebp
  801395:	c3                   	ret    
		return -E_INVAL;
  801396:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139b:	eb f7                	jmp    801394 <fd_lookup+0x3f>
		return -E_INVAL;
  80139d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a2:	eb f0                	jmp    801394 <fd_lookup+0x3f>
  8013a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a9:	eb e9                	jmp    801394 <fd_lookup+0x3f>

008013ab <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b4:	ba 70 2d 80 00       	mov    $0x802d70,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013b9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013be:	39 08                	cmp    %ecx,(%eax)
  8013c0:	74 33                	je     8013f5 <dev_lookup+0x4a>
  8013c2:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013c5:	8b 02                	mov    (%edx),%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	75 f3                	jne    8013be <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d0:	8b 40 48             	mov    0x48(%eax),%eax
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	51                   	push   %ecx
  8013d7:	50                   	push   %eax
  8013d8:	68 f4 2c 80 00       	push   $0x802cf4
  8013dd:	e8 2b ef ff ff       	call   80030d <cprintf>
	*dev = 0;
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    
			*dev = devtab[i];
  8013f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ff:	eb f2                	jmp    8013f3 <dev_lookup+0x48>

00801401 <fd_close>:
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	57                   	push   %edi
  801405:	56                   	push   %esi
  801406:	53                   	push   %ebx
  801407:	83 ec 1c             	sub    $0x1c,%esp
  80140a:	8b 75 08             	mov    0x8(%ebp),%esi
  80140d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801410:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801413:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801414:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80141a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80141d:	50                   	push   %eax
  80141e:	e8 32 ff ff ff       	call   801355 <fd_lookup>
  801423:	89 c3                	mov    %eax,%ebx
  801425:	83 c4 08             	add    $0x8,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	78 05                	js     801431 <fd_close+0x30>
	    || fd != fd2)
  80142c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80142f:	74 16                	je     801447 <fd_close+0x46>
		return (must_exist ? r : 0);
  801431:	89 f8                	mov    %edi,%eax
  801433:	84 c0                	test   %al,%al
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
  80143a:	0f 44 d8             	cmove  %eax,%ebx
}
  80143d:	89 d8                	mov    %ebx,%eax
  80143f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5f                   	pop    %edi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80144d:	50                   	push   %eax
  80144e:	ff 36                	pushl  (%esi)
  801450:	e8 56 ff ff ff       	call   8013ab <dev_lookup>
  801455:	89 c3                	mov    %eax,%ebx
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 15                	js     801473 <fd_close+0x72>
		if (dev->dev_close)
  80145e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801461:	8b 40 10             	mov    0x10(%eax),%eax
  801464:	85 c0                	test   %eax,%eax
  801466:	74 1b                	je     801483 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801468:	83 ec 0c             	sub    $0xc,%esp
  80146b:	56                   	push   %esi
  80146c:	ff d0                	call   *%eax
  80146e:	89 c3                	mov    %eax,%ebx
  801470:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	56                   	push   %esi
  801477:	6a 00                	push   $0x0
  801479:	e8 aa f9 ff ff       	call   800e28 <sys_page_unmap>
	return r;
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	eb ba                	jmp    80143d <fd_close+0x3c>
			r = 0;
  801483:	bb 00 00 00 00       	mov    $0x0,%ebx
  801488:	eb e9                	jmp    801473 <fd_close+0x72>

0080148a <close>:

int
close(int fdnum)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801490:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	ff 75 08             	pushl  0x8(%ebp)
  801497:	e8 b9 fe ff ff       	call   801355 <fd_lookup>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 10                	js     8014b3 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	6a 01                	push   $0x1
  8014a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ab:	e8 51 ff ff ff       	call   801401 <fd_close>
  8014b0:	83 c4 10             	add    $0x10,%esp
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <close_all>:

void
close_all(void)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014bc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	53                   	push   %ebx
  8014c5:	e8 c0 ff ff ff       	call   80148a <close>
	for (i = 0; i < MAXFD; i++)
  8014ca:	83 c3 01             	add    $0x1,%ebx
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	83 fb 20             	cmp    $0x20,%ebx
  8014d3:	75 ec                	jne    8014c1 <close_all+0xc>
}
  8014d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	57                   	push   %edi
  8014de:	56                   	push   %esi
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014e3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014e6:	50                   	push   %eax
  8014e7:	ff 75 08             	pushl  0x8(%ebp)
  8014ea:	e8 66 fe ff ff       	call   801355 <fd_lookup>
  8014ef:	89 c3                	mov    %eax,%ebx
  8014f1:	83 c4 08             	add    $0x8,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	0f 88 81 00 00 00    	js     80157d <dup+0xa3>
		return r;
	close(newfdnum);
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	ff 75 0c             	pushl  0xc(%ebp)
  801502:	e8 83 ff ff ff       	call   80148a <close>

	newfd = INDEX2FD(newfdnum);
  801507:	8b 75 0c             	mov    0xc(%ebp),%esi
  80150a:	c1 e6 0c             	shl    $0xc,%esi
  80150d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801513:	83 c4 04             	add    $0x4,%esp
  801516:	ff 75 e4             	pushl  -0x1c(%ebp)
  801519:	e8 d1 fd ff ff       	call   8012ef <fd2data>
  80151e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801520:	89 34 24             	mov    %esi,(%esp)
  801523:	e8 c7 fd ff ff       	call   8012ef <fd2data>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80152d:	89 d8                	mov    %ebx,%eax
  80152f:	c1 e8 16             	shr    $0x16,%eax
  801532:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801539:	a8 01                	test   $0x1,%al
  80153b:	74 11                	je     80154e <dup+0x74>
  80153d:	89 d8                	mov    %ebx,%eax
  80153f:	c1 e8 0c             	shr    $0xc,%eax
  801542:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801549:	f6 c2 01             	test   $0x1,%dl
  80154c:	75 39                	jne    801587 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80154e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801551:	89 d0                	mov    %edx,%eax
  801553:	c1 e8 0c             	shr    $0xc,%eax
  801556:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	25 07 0e 00 00       	and    $0xe07,%eax
  801565:	50                   	push   %eax
  801566:	56                   	push   %esi
  801567:	6a 00                	push   $0x0
  801569:	52                   	push   %edx
  80156a:	6a 00                	push   $0x0
  80156c:	e8 75 f8 ff ff       	call   800de6 <sys_page_map>
  801571:	89 c3                	mov    %eax,%ebx
  801573:	83 c4 20             	add    $0x20,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 31                	js     8015ab <dup+0xd1>
		goto err;

	return newfdnum;
  80157a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80157d:	89 d8                	mov    %ebx,%eax
  80157f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5f                   	pop    %edi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801587:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80158e:	83 ec 0c             	sub    $0xc,%esp
  801591:	25 07 0e 00 00       	and    $0xe07,%eax
  801596:	50                   	push   %eax
  801597:	57                   	push   %edi
  801598:	6a 00                	push   $0x0
  80159a:	53                   	push   %ebx
  80159b:	6a 00                	push   $0x0
  80159d:	e8 44 f8 ff ff       	call   800de6 <sys_page_map>
  8015a2:	89 c3                	mov    %eax,%ebx
  8015a4:	83 c4 20             	add    $0x20,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	79 a3                	jns    80154e <dup+0x74>
	sys_page_unmap(0, newfd);
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	56                   	push   %esi
  8015af:	6a 00                	push   $0x0
  8015b1:	e8 72 f8 ff ff       	call   800e28 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015b6:	83 c4 08             	add    $0x8,%esp
  8015b9:	57                   	push   %edi
  8015ba:	6a 00                	push   $0x0
  8015bc:	e8 67 f8 ff ff       	call   800e28 <sys_page_unmap>
	return r;
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	eb b7                	jmp    80157d <dup+0xa3>

008015c6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	53                   	push   %ebx
  8015ca:	83 ec 14             	sub    $0x14,%esp
  8015cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d3:	50                   	push   %eax
  8015d4:	53                   	push   %ebx
  8015d5:	e8 7b fd ff ff       	call   801355 <fd_lookup>
  8015da:	83 c4 08             	add    $0x8,%esp
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 3f                	js     801620 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e7:	50                   	push   %eax
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	ff 30                	pushl  (%eax)
  8015ed:	e8 b9 fd ff ff       	call   8013ab <dev_lookup>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 27                	js     801620 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fc:	8b 42 08             	mov    0x8(%edx),%eax
  8015ff:	83 e0 03             	and    $0x3,%eax
  801602:	83 f8 01             	cmp    $0x1,%eax
  801605:	74 1e                	je     801625 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160a:	8b 40 08             	mov    0x8(%eax),%eax
  80160d:	85 c0                	test   %eax,%eax
  80160f:	74 35                	je     801646 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	ff 75 10             	pushl  0x10(%ebp)
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	52                   	push   %edx
  80161b:	ff d0                	call   *%eax
  80161d:	83 c4 10             	add    $0x10,%esp
}
  801620:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801623:	c9                   	leave  
  801624:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801625:	a1 08 40 80 00       	mov    0x804008,%eax
  80162a:	8b 40 48             	mov    0x48(%eax),%eax
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	53                   	push   %ebx
  801631:	50                   	push   %eax
  801632:	68 35 2d 80 00       	push   $0x802d35
  801637:	e8 d1 ec ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801644:	eb da                	jmp    801620 <read+0x5a>
		return -E_NOT_SUPP;
  801646:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164b:	eb d3                	jmp    801620 <read+0x5a>

0080164d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	57                   	push   %edi
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	83 ec 0c             	sub    $0xc,%esp
  801656:	8b 7d 08             	mov    0x8(%ebp),%edi
  801659:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80165c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801661:	39 f3                	cmp    %esi,%ebx
  801663:	73 25                	jae    80168a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	89 f0                	mov    %esi,%eax
  80166a:	29 d8                	sub    %ebx,%eax
  80166c:	50                   	push   %eax
  80166d:	89 d8                	mov    %ebx,%eax
  80166f:	03 45 0c             	add    0xc(%ebp),%eax
  801672:	50                   	push   %eax
  801673:	57                   	push   %edi
  801674:	e8 4d ff ff ff       	call   8015c6 <read>
		if (m < 0)
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 08                	js     801688 <readn+0x3b>
			return m;
		if (m == 0)
  801680:	85 c0                	test   %eax,%eax
  801682:	74 06                	je     80168a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801684:	01 c3                	add    %eax,%ebx
  801686:	eb d9                	jmp    801661 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801688:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80168a:	89 d8                	mov    %ebx,%eax
  80168c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5f                   	pop    %edi
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    

00801694 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	53                   	push   %ebx
  801698:	83 ec 14             	sub    $0x14,%esp
  80169b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a1:	50                   	push   %eax
  8016a2:	53                   	push   %ebx
  8016a3:	e8 ad fc ff ff       	call   801355 <fd_lookup>
  8016a8:	83 c4 08             	add    $0x8,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 3a                	js     8016e9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b5:	50                   	push   %eax
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	ff 30                	pushl  (%eax)
  8016bb:	e8 eb fc ff ff       	call   8013ab <dev_lookup>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 22                	js     8016e9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ce:	74 1e                	je     8016ee <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8016d6:	85 d2                	test   %edx,%edx
  8016d8:	74 35                	je     80170f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	50                   	push   %eax
  8016e4:	ff d2                	call   *%edx
  8016e6:	83 c4 10             	add    $0x10,%esp
}
  8016e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ee:	a1 08 40 80 00       	mov    0x804008,%eax
  8016f3:	8b 40 48             	mov    0x48(%eax),%eax
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	53                   	push   %ebx
  8016fa:	50                   	push   %eax
  8016fb:	68 51 2d 80 00       	push   $0x802d51
  801700:	e8 08 ec ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170d:	eb da                	jmp    8016e9 <write+0x55>
		return -E_NOT_SUPP;
  80170f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801714:	eb d3                	jmp    8016e9 <write+0x55>

00801716 <seek>:

int
seek(int fdnum, off_t offset)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 2d fc ff ff       	call   801355 <fd_lookup>
  801728:	83 c4 08             	add    $0x8,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 0e                	js     80173d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80172f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801732:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801735:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	53                   	push   %ebx
  801743:	83 ec 14             	sub    $0x14,%esp
  801746:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801749:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174c:	50                   	push   %eax
  80174d:	53                   	push   %ebx
  80174e:	e8 02 fc ff ff       	call   801355 <fd_lookup>
  801753:	83 c4 08             	add    $0x8,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 37                	js     801791 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80175a:	83 ec 08             	sub    $0x8,%esp
  80175d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	ff 30                	pushl  (%eax)
  801766:	e8 40 fc ff ff       	call   8013ab <dev_lookup>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 1f                	js     801791 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801775:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801779:	74 1b                	je     801796 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80177b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177e:	8b 52 18             	mov    0x18(%edx),%edx
  801781:	85 d2                	test   %edx,%edx
  801783:	74 32                	je     8017b7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801785:	83 ec 08             	sub    $0x8,%esp
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	50                   	push   %eax
  80178c:	ff d2                	call   *%edx
  80178e:	83 c4 10             	add    $0x10,%esp
}
  801791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801794:	c9                   	leave  
  801795:	c3                   	ret    
			thisenv->env_id, fdnum);
  801796:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80179b:	8b 40 48             	mov    0x48(%eax),%eax
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	53                   	push   %ebx
  8017a2:	50                   	push   %eax
  8017a3:	68 14 2d 80 00       	push   $0x802d14
  8017a8:	e8 60 eb ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b5:	eb da                	jmp    801791 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017bc:	eb d3                	jmp    801791 <ftruncate+0x52>

008017be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 14             	sub    $0x14,%esp
  8017c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017cb:	50                   	push   %eax
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	e8 81 fb ff ff       	call   801355 <fd_lookup>
  8017d4:	83 c4 08             	add    $0x8,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 4b                	js     801826 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e1:	50                   	push   %eax
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e5:	ff 30                	pushl  (%eax)
  8017e7:	e8 bf fb ff ff       	call   8013ab <dev_lookup>
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 33                	js     801826 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017fa:	74 2f                	je     80182b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017fc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017ff:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801806:	00 00 00 
	stat->st_isdir = 0;
  801809:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801810:	00 00 00 
	stat->st_dev = dev;
  801813:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	53                   	push   %ebx
  80181d:	ff 75 f0             	pushl  -0x10(%ebp)
  801820:	ff 50 14             	call   *0x14(%eax)
  801823:	83 c4 10             	add    $0x10,%esp
}
  801826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801829:	c9                   	leave  
  80182a:	c3                   	ret    
		return -E_NOT_SUPP;
  80182b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801830:	eb f4                	jmp    801826 <fstat+0x68>

00801832 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	56                   	push   %esi
  801836:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801837:	83 ec 08             	sub    $0x8,%esp
  80183a:	6a 00                	push   $0x0
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	e8 26 02 00 00       	call   801a6a <open>
  801844:	89 c3                	mov    %eax,%ebx
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	78 1b                	js     801868 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	50                   	push   %eax
  801854:	e8 65 ff ff ff       	call   8017be <fstat>
  801859:	89 c6                	mov    %eax,%esi
	close(fd);
  80185b:	89 1c 24             	mov    %ebx,(%esp)
  80185e:	e8 27 fc ff ff       	call   80148a <close>
	return r;
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	89 f3                	mov    %esi,%ebx
}
  801868:	89 d8                	mov    %ebx,%eax
  80186a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5e                   	pop    %esi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    

00801871 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	56                   	push   %esi
  801875:	53                   	push   %ebx
  801876:	89 c6                	mov    %eax,%esi
  801878:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80187a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801881:	74 27                	je     8018aa <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801883:	6a 07                	push   $0x7
  801885:	68 00 50 80 00       	push   $0x805000
  80188a:	56                   	push   %esi
  80188b:	ff 35 00 40 80 00    	pushl  0x804000
  801891:	e8 b0 0c 00 00       	call   802546 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801896:	83 c4 0c             	add    $0xc,%esp
  801899:	6a 00                	push   $0x0
  80189b:	53                   	push   %ebx
  80189c:	6a 00                	push   $0x0
  80189e:	e8 3a 0c 00 00       	call   8024dd <ipc_recv>
}
  8018a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018aa:	83 ec 0c             	sub    $0xc,%esp
  8018ad:	6a 01                	push   $0x1
  8018af:	e8 eb 0c 00 00       	call   80259f <ipc_find_env>
  8018b4:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	eb c5                	jmp    801883 <fsipc+0x12>

008018be <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ca:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	b8 02 00 00 00       	mov    $0x2,%eax
  8018e1:	e8 8b ff ff ff       	call   801871 <fsipc>
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <devfile_flush>:
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fe:	b8 06 00 00 00       	mov    $0x6,%eax
  801903:	e8 69 ff ff ff       	call   801871 <fsipc>
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <devfile_stat>:
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	8b 40 0c             	mov    0xc(%eax),%eax
  80191a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80191f:	ba 00 00 00 00       	mov    $0x0,%edx
  801924:	b8 05 00 00 00       	mov    $0x5,%eax
  801929:	e8 43 ff ff ff       	call   801871 <fsipc>
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 2c                	js     80195e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	68 00 50 80 00       	push   $0x805000
  80193a:	53                   	push   %ebx
  80193b:	e8 6a f0 ff ff       	call   8009aa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801940:	a1 80 50 80 00       	mov    0x805080,%eax
  801945:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80194b:	a1 84 50 80 00       	mov    0x805084,%eax
  801950:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <devfile_write>:
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	53                   	push   %ebx
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 40 0c             	mov    0xc(%eax),%eax
  801973:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801978:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80197e:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801984:	77 30                	ja     8019b6 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	53                   	push   %ebx
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	68 08 50 80 00       	push   $0x805008
  801992:	e8 a1 f1 ff ff       	call   800b38 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801997:	ba 00 00 00 00       	mov    $0x0,%edx
  80199c:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a1:	e8 cb fe ff ff       	call   801871 <fsipc>
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 04                	js     8019b1 <devfile_write+0x4e>
	assert(r <= n);
  8019ad:	39 d8                	cmp    %ebx,%eax
  8019af:	77 1e                	ja     8019cf <devfile_write+0x6c>
}
  8019b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019b6:	68 84 2d 80 00       	push   $0x802d84
  8019bb:	68 b4 2d 80 00       	push   $0x802db4
  8019c0:	68 94 00 00 00       	push   $0x94
  8019c5:	68 c9 2d 80 00       	push   $0x802dc9
  8019ca:	e8 63 e8 ff ff       	call   800232 <_panic>
	assert(r <= n);
  8019cf:	68 d4 2d 80 00       	push   $0x802dd4
  8019d4:	68 b4 2d 80 00       	push   $0x802db4
  8019d9:	68 98 00 00 00       	push   $0x98
  8019de:	68 c9 2d 80 00       	push   $0x802dc9
  8019e3:	e8 4a e8 ff ff       	call   800232 <_panic>

008019e8 <devfile_read>:
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	56                   	push   %esi
  8019ec:	53                   	push   %ebx
  8019ed:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019fb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	b8 03 00 00 00       	mov    $0x3,%eax
  801a0b:	e8 61 fe ff ff       	call   801871 <fsipc>
  801a10:	89 c3                	mov    %eax,%ebx
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 1f                	js     801a35 <devfile_read+0x4d>
	assert(r <= n);
  801a16:	39 f0                	cmp    %esi,%eax
  801a18:	77 24                	ja     801a3e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a1a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a1f:	7f 33                	jg     801a54 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	50                   	push   %eax
  801a25:	68 00 50 80 00       	push   $0x805000
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	e8 06 f1 ff ff       	call   800b38 <memmove>
	return r;
  801a32:	83 c4 10             	add    $0x10,%esp
}
  801a35:	89 d8                	mov    %ebx,%eax
  801a37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    
	assert(r <= n);
  801a3e:	68 d4 2d 80 00       	push   $0x802dd4
  801a43:	68 b4 2d 80 00       	push   $0x802db4
  801a48:	6a 7c                	push   $0x7c
  801a4a:	68 c9 2d 80 00       	push   $0x802dc9
  801a4f:	e8 de e7 ff ff       	call   800232 <_panic>
	assert(r <= PGSIZE);
  801a54:	68 db 2d 80 00       	push   $0x802ddb
  801a59:	68 b4 2d 80 00       	push   $0x802db4
  801a5e:	6a 7d                	push   $0x7d
  801a60:	68 c9 2d 80 00       	push   $0x802dc9
  801a65:	e8 c8 e7 ff ff       	call   800232 <_panic>

00801a6a <open>:
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 1c             	sub    $0x1c,%esp
  801a72:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a75:	56                   	push   %esi
  801a76:	e8 f8 ee ff ff       	call   800973 <strlen>
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a83:	7f 6c                	jg     801af1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a85:	83 ec 0c             	sub    $0xc,%esp
  801a88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	e8 75 f8 ff ff       	call   801306 <fd_alloc>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 3c                	js     801ad6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a9a:	83 ec 08             	sub    $0x8,%esp
  801a9d:	56                   	push   %esi
  801a9e:	68 00 50 80 00       	push   $0x805000
  801aa3:	e8 02 ef ff ff       	call   8009aa <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aab:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab8:	e8 b4 fd ff ff       	call   801871 <fsipc>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 19                	js     801adf <open+0x75>
	return fd2num(fd);
  801ac6:	83 ec 0c             	sub    $0xc,%esp
  801ac9:	ff 75 f4             	pushl  -0xc(%ebp)
  801acc:	e8 0e f8 ff ff       	call   8012df <fd2num>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	83 c4 10             	add    $0x10,%esp
}
  801ad6:	89 d8                	mov    %ebx,%eax
  801ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5d                   	pop    %ebp
  801ade:	c3                   	ret    
		fd_close(fd, 0);
  801adf:	83 ec 08             	sub    $0x8,%esp
  801ae2:	6a 00                	push   $0x0
  801ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae7:	e8 15 f9 ff ff       	call   801401 <fd_close>
		return r;
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	eb e5                	jmp    801ad6 <open+0x6c>
		return -E_BAD_PATH;
  801af1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801af6:	eb de                	jmp    801ad6 <open+0x6c>

00801af8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801afe:	ba 00 00 00 00       	mov    $0x0,%edx
  801b03:	b8 08 00 00 00       	mov    $0x8,%eax
  801b08:	e8 64 fd ff ff       	call   801871 <fsipc>
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b17:	83 ec 0c             	sub    $0xc,%esp
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 cd f7 ff ff       	call   8012ef <fd2data>
  801b22:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b24:	83 c4 08             	add    $0x8,%esp
  801b27:	68 e7 2d 80 00       	push   $0x802de7
  801b2c:	53                   	push   %ebx
  801b2d:	e8 78 ee ff ff       	call   8009aa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b32:	8b 46 04             	mov    0x4(%esi),%eax
  801b35:	2b 06                	sub    (%esi),%eax
  801b37:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b3d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b44:	00 00 00 
	stat->st_dev = &devpipe;
  801b47:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b4e:	30 80 00 
	return 0;
}
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
  801b56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b59:	5b                   	pop    %ebx
  801b5a:	5e                   	pop    %esi
  801b5b:	5d                   	pop    %ebp
  801b5c:	c3                   	ret    

00801b5d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	53                   	push   %ebx
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b67:	53                   	push   %ebx
  801b68:	6a 00                	push   $0x0
  801b6a:	e8 b9 f2 ff ff       	call   800e28 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b6f:	89 1c 24             	mov    %ebx,(%esp)
  801b72:	e8 78 f7 ff ff       	call   8012ef <fd2data>
  801b77:	83 c4 08             	add    $0x8,%esp
  801b7a:	50                   	push   %eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	e8 a6 f2 ff ff       	call   800e28 <sys_page_unmap>
}
  801b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <_pipeisclosed>:
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	57                   	push   %edi
  801b8b:	56                   	push   %esi
  801b8c:	53                   	push   %ebx
  801b8d:	83 ec 1c             	sub    $0x1c,%esp
  801b90:	89 c7                	mov    %eax,%edi
  801b92:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b94:	a1 08 40 80 00       	mov    0x804008,%eax
  801b99:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b9c:	83 ec 0c             	sub    $0xc,%esp
  801b9f:	57                   	push   %edi
  801ba0:	e8 33 0a 00 00       	call   8025d8 <pageref>
  801ba5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba8:	89 34 24             	mov    %esi,(%esp)
  801bab:	e8 28 0a 00 00       	call   8025d8 <pageref>
		nn = thisenv->env_runs;
  801bb0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bb6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	39 cb                	cmp    %ecx,%ebx
  801bbe:	74 1b                	je     801bdb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bc0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc3:	75 cf                	jne    801b94 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bc5:	8b 42 58             	mov    0x58(%edx),%eax
  801bc8:	6a 01                	push   $0x1
  801bca:	50                   	push   %eax
  801bcb:	53                   	push   %ebx
  801bcc:	68 ee 2d 80 00       	push   $0x802dee
  801bd1:	e8 37 e7 ff ff       	call   80030d <cprintf>
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	eb b9                	jmp    801b94 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bdb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bde:	0f 94 c0             	sete   %al
  801be1:	0f b6 c0             	movzbl %al,%eax
}
  801be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <devpipe_write>:
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	57                   	push   %edi
  801bf0:	56                   	push   %esi
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 28             	sub    $0x28,%esp
  801bf5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bf8:	56                   	push   %esi
  801bf9:	e8 f1 f6 ff ff       	call   8012ef <fd2data>
  801bfe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	bf 00 00 00 00       	mov    $0x0,%edi
  801c08:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c0b:	74 4f                	je     801c5c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c0d:	8b 43 04             	mov    0x4(%ebx),%eax
  801c10:	8b 0b                	mov    (%ebx),%ecx
  801c12:	8d 51 20             	lea    0x20(%ecx),%edx
  801c15:	39 d0                	cmp    %edx,%eax
  801c17:	72 14                	jb     801c2d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c19:	89 da                	mov    %ebx,%edx
  801c1b:	89 f0                	mov    %esi,%eax
  801c1d:	e8 65 ff ff ff       	call   801b87 <_pipeisclosed>
  801c22:	85 c0                	test   %eax,%eax
  801c24:	75 3a                	jne    801c60 <devpipe_write+0x74>
			sys_yield();
  801c26:	e8 59 f1 ff ff       	call   800d84 <sys_yield>
  801c2b:	eb e0                	jmp    801c0d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c30:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c34:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c37:	89 c2                	mov    %eax,%edx
  801c39:	c1 fa 1f             	sar    $0x1f,%edx
  801c3c:	89 d1                	mov    %edx,%ecx
  801c3e:	c1 e9 1b             	shr    $0x1b,%ecx
  801c41:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c44:	83 e2 1f             	and    $0x1f,%edx
  801c47:	29 ca                	sub    %ecx,%edx
  801c49:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c4d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c51:	83 c0 01             	add    $0x1,%eax
  801c54:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c57:	83 c7 01             	add    $0x1,%edi
  801c5a:	eb ac                	jmp    801c08 <devpipe_write+0x1c>
	return i;
  801c5c:	89 f8                	mov    %edi,%eax
  801c5e:	eb 05                	jmp    801c65 <devpipe_write+0x79>
				return 0;
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5f                   	pop    %edi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <devpipe_read>:
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	57                   	push   %edi
  801c71:	56                   	push   %esi
  801c72:	53                   	push   %ebx
  801c73:	83 ec 18             	sub    $0x18,%esp
  801c76:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c79:	57                   	push   %edi
  801c7a:	e8 70 f6 ff ff       	call   8012ef <fd2data>
  801c7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	be 00 00 00 00       	mov    $0x0,%esi
  801c89:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c8c:	74 47                	je     801cd5 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c8e:	8b 03                	mov    (%ebx),%eax
  801c90:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c93:	75 22                	jne    801cb7 <devpipe_read+0x4a>
			if (i > 0)
  801c95:	85 f6                	test   %esi,%esi
  801c97:	75 14                	jne    801cad <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c99:	89 da                	mov    %ebx,%edx
  801c9b:	89 f8                	mov    %edi,%eax
  801c9d:	e8 e5 fe ff ff       	call   801b87 <_pipeisclosed>
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	75 33                	jne    801cd9 <devpipe_read+0x6c>
			sys_yield();
  801ca6:	e8 d9 f0 ff ff       	call   800d84 <sys_yield>
  801cab:	eb e1                	jmp    801c8e <devpipe_read+0x21>
				return i;
  801cad:	89 f0                	mov    %esi,%eax
}
  801caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb7:	99                   	cltd   
  801cb8:	c1 ea 1b             	shr    $0x1b,%edx
  801cbb:	01 d0                	add    %edx,%eax
  801cbd:	83 e0 1f             	and    $0x1f,%eax
  801cc0:	29 d0                	sub    %edx,%eax
  801cc2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cca:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ccd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cd0:	83 c6 01             	add    $0x1,%esi
  801cd3:	eb b4                	jmp    801c89 <devpipe_read+0x1c>
	return i;
  801cd5:	89 f0                	mov    %esi,%eax
  801cd7:	eb d6                	jmp    801caf <devpipe_read+0x42>
				return 0;
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	eb cf                	jmp    801caf <devpipe_read+0x42>

00801ce0 <pipe>:
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ceb:	50                   	push   %eax
  801cec:	e8 15 f6 ff ff       	call   801306 <fd_alloc>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	83 c4 10             	add    $0x10,%esp
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	78 5b                	js     801d55 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	68 07 04 00 00       	push   $0x407
  801d02:	ff 75 f4             	pushl  -0xc(%ebp)
  801d05:	6a 00                	push   $0x0
  801d07:	e8 97 f0 ff ff       	call   800da3 <sys_page_alloc>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 40                	js     801d55 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d1b:	50                   	push   %eax
  801d1c:	e8 e5 f5 ff ff       	call   801306 <fd_alloc>
  801d21:	89 c3                	mov    %eax,%ebx
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 1b                	js     801d45 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	68 07 04 00 00       	push   $0x407
  801d32:	ff 75 f0             	pushl  -0x10(%ebp)
  801d35:	6a 00                	push   $0x0
  801d37:	e8 67 f0 ff ff       	call   800da3 <sys_page_alloc>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	85 c0                	test   %eax,%eax
  801d43:	79 19                	jns    801d5e <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4b:	6a 00                	push   $0x0
  801d4d:	e8 d6 f0 ff ff       	call   800e28 <sys_page_unmap>
  801d52:	83 c4 10             	add    $0x10,%esp
}
  801d55:	89 d8                	mov    %ebx,%eax
  801d57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5a:	5b                   	pop    %ebx
  801d5b:	5e                   	pop    %esi
  801d5c:	5d                   	pop    %ebp
  801d5d:	c3                   	ret    
	va = fd2data(fd0);
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	ff 75 f4             	pushl  -0xc(%ebp)
  801d64:	e8 86 f5 ff ff       	call   8012ef <fd2data>
  801d69:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6b:	83 c4 0c             	add    $0xc,%esp
  801d6e:	68 07 04 00 00       	push   $0x407
  801d73:	50                   	push   %eax
  801d74:	6a 00                	push   $0x0
  801d76:	e8 28 f0 ff ff       	call   800da3 <sys_page_alloc>
  801d7b:	89 c3                	mov    %eax,%ebx
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	85 c0                	test   %eax,%eax
  801d82:	0f 88 8c 00 00 00    	js     801e14 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d88:	83 ec 0c             	sub    $0xc,%esp
  801d8b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d8e:	e8 5c f5 ff ff       	call   8012ef <fd2data>
  801d93:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d9a:	50                   	push   %eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	56                   	push   %esi
  801d9e:	6a 00                	push   $0x0
  801da0:	e8 41 f0 ff ff       	call   800de6 <sys_page_map>
  801da5:	89 c3                	mov    %eax,%ebx
  801da7:	83 c4 20             	add    $0x20,%esp
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 58                	js     801e06 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801db7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dcc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dde:	e8 fc f4 ff ff       	call   8012df <fd2num>
  801de3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801de8:	83 c4 04             	add    $0x4,%esp
  801deb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dee:	e8 ec f4 ff ff       	call   8012df <fd2num>
  801df3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e01:	e9 4f ff ff ff       	jmp    801d55 <pipe+0x75>
	sys_page_unmap(0, va);
  801e06:	83 ec 08             	sub    $0x8,%esp
  801e09:	56                   	push   %esi
  801e0a:	6a 00                	push   $0x0
  801e0c:	e8 17 f0 ff ff       	call   800e28 <sys_page_unmap>
  801e11:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e14:	83 ec 08             	sub    $0x8,%esp
  801e17:	ff 75 f0             	pushl  -0x10(%ebp)
  801e1a:	6a 00                	push   $0x0
  801e1c:	e8 07 f0 ff ff       	call   800e28 <sys_page_unmap>
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	e9 1c ff ff ff       	jmp    801d45 <pipe+0x65>

00801e29 <pipeisclosed>:
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e32:	50                   	push   %eax
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	e8 1a f5 ff ff       	call   801355 <fd_lookup>
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	78 18                	js     801e5a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	ff 75 f4             	pushl  -0xc(%ebp)
  801e48:	e8 a2 f4 ff ff       	call   8012ef <fd2data>
	return _pipeisclosed(fd, p);
  801e4d:	89 c2                	mov    %eax,%edx
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	e8 30 fd ff ff       	call   801b87 <_pipeisclosed>
  801e57:	83 c4 10             	add    $0x10,%esp
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e62:	68 06 2e 80 00       	push   $0x802e06
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	e8 3b eb ff ff       	call   8009aa <strcpy>
	return 0;
}
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <devsock_close>:
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	53                   	push   %ebx
  801e7a:	83 ec 10             	sub    $0x10,%esp
  801e7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e80:	53                   	push   %ebx
  801e81:	e8 52 07 00 00       	call   8025d8 <pageref>
  801e86:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e89:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e8e:	83 f8 01             	cmp    $0x1,%eax
  801e91:	74 07                	je     801e9a <devsock_close+0x24>
}
  801e93:	89 d0                	mov    %edx,%eax
  801e95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	ff 73 0c             	pushl  0xc(%ebx)
  801ea0:	e8 b7 02 00 00       	call   80215c <nsipc_close>
  801ea5:	89 c2                	mov    %eax,%edx
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	eb e7                	jmp    801e93 <devsock_close+0x1d>

00801eac <devsock_write>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	ff 75 10             	pushl  0x10(%ebp)
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	ff 70 0c             	pushl  0xc(%eax)
  801ec0:	e8 74 03 00 00       	call   802239 <nsipc_send>
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <devsock_read>:
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	ff 75 10             	pushl  0x10(%ebp)
  801ed2:	ff 75 0c             	pushl  0xc(%ebp)
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	ff 70 0c             	pushl  0xc(%eax)
  801edb:	e8 ed 02 00 00       	call   8021cd <nsipc_recv>
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <fd2sockid>:
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ee8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	e8 63 f4 ff ff       	call   801355 <fd_lookup>
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	78 10                	js     801f09 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801f02:	39 08                	cmp    %ecx,(%eax)
  801f04:	75 05                	jne    801f0b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f06:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    
		return -E_NOT_SUPP;
  801f0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f10:	eb f7                	jmp    801f09 <fd2sockid+0x27>

00801f12 <alloc_sockfd>:
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	83 ec 1c             	sub    $0x1c,%esp
  801f1a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1f:	50                   	push   %eax
  801f20:	e8 e1 f3 ff ff       	call   801306 <fd_alloc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 43                	js     801f71 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	68 07 04 00 00       	push   $0x407
  801f36:	ff 75 f4             	pushl  -0xc(%ebp)
  801f39:	6a 00                	push   $0x0
  801f3b:	e8 63 ee ff ff       	call   800da3 <sys_page_alloc>
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	78 28                	js     801f71 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f52:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f5e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	50                   	push   %eax
  801f65:	e8 75 f3 ff ff       	call   8012df <fd2num>
  801f6a:	89 c3                	mov    %eax,%ebx
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	eb 0c                	jmp    801f7d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	56                   	push   %esi
  801f75:	e8 e2 01 00 00       	call   80215c <nsipc_close>
		return r;
  801f7a:	83 c4 10             	add    $0x10,%esp
}
  801f7d:	89 d8                	mov    %ebx,%eax
  801f7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f82:	5b                   	pop    %ebx
  801f83:	5e                   	pop    %esi
  801f84:	5d                   	pop    %ebp
  801f85:	c3                   	ret    

00801f86 <accept>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	e8 4e ff ff ff       	call   801ee2 <fd2sockid>
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 1b                	js     801fb3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f98:	83 ec 04             	sub    $0x4,%esp
  801f9b:	ff 75 10             	pushl  0x10(%ebp)
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	50                   	push   %eax
  801fa2:	e8 0e 01 00 00       	call   8020b5 <nsipc_accept>
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	85 c0                	test   %eax,%eax
  801fac:	78 05                	js     801fb3 <accept+0x2d>
	return alloc_sockfd(r);
  801fae:	e8 5f ff ff ff       	call   801f12 <alloc_sockfd>
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <bind>:
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	e8 1f ff ff ff       	call   801ee2 <fd2sockid>
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	78 12                	js     801fd9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	ff 75 10             	pushl  0x10(%ebp)
  801fcd:	ff 75 0c             	pushl  0xc(%ebp)
  801fd0:	50                   	push   %eax
  801fd1:	e8 2f 01 00 00       	call   802105 <nsipc_bind>
  801fd6:	83 c4 10             	add    $0x10,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <shutdown>:
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	e8 f9 fe ff ff       	call   801ee2 <fd2sockid>
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 0f                	js     801ffc <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fed:	83 ec 08             	sub    $0x8,%esp
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	50                   	push   %eax
  801ff4:	e8 41 01 00 00       	call   80213a <nsipc_shutdown>
  801ff9:	83 c4 10             	add    $0x10,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <connect>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	e8 d6 fe ff ff       	call   801ee2 <fd2sockid>
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 12                	js     802022 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	ff 75 10             	pushl  0x10(%ebp)
  802016:	ff 75 0c             	pushl  0xc(%ebp)
  802019:	50                   	push   %eax
  80201a:	e8 57 01 00 00       	call   802176 <nsipc_connect>
  80201f:	83 c4 10             	add    $0x10,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <listen>:
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	e8 b0 fe ff ff       	call   801ee2 <fd2sockid>
  802032:	85 c0                	test   %eax,%eax
  802034:	78 0f                	js     802045 <listen+0x21>
	return nsipc_listen(r, backlog);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	50                   	push   %eax
  80203d:	e8 69 01 00 00       	call   8021ab <nsipc_listen>
  802042:	83 c4 10             	add    $0x10,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <socket>:

int
socket(int domain, int type, int protocol)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204d:	ff 75 10             	pushl  0x10(%ebp)
  802050:	ff 75 0c             	pushl  0xc(%ebp)
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	e8 3c 02 00 00       	call   802297 <nsipc_socket>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 05                	js     802067 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802062:	e8 ab fe ff ff       	call   801f12 <alloc_sockfd>
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	53                   	push   %ebx
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802072:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  802079:	74 26                	je     8020a1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80207b:	6a 07                	push   $0x7
  80207d:	68 00 60 80 00       	push   $0x806000
  802082:	53                   	push   %ebx
  802083:	ff 35 04 40 80 00    	pushl  0x804004
  802089:	e8 b8 04 00 00       	call   802546 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80208e:	83 c4 0c             	add    $0xc,%esp
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	e8 41 04 00 00       	call   8024dd <ipc_recv>
}
  80209c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	6a 02                	push   $0x2
  8020a6:	e8 f4 04 00 00       	call   80259f <ipc_find_env>
  8020ab:	a3 04 40 80 00       	mov    %eax,0x804004
  8020b0:	83 c4 10             	add    $0x10,%esp
  8020b3:	eb c6                	jmp    80207b <nsipc+0x12>

008020b5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	56                   	push   %esi
  8020b9:	53                   	push   %ebx
  8020ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020c5:	8b 06                	mov    (%esi),%eax
  8020c7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d1:	e8 93 ff ff ff       	call   802069 <nsipc>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 20                	js     8020fc <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	ff 35 10 60 80 00    	pushl  0x806010
  8020e5:	68 00 60 80 00       	push   $0x806000
  8020ea:	ff 75 0c             	pushl  0xc(%ebp)
  8020ed:	e8 46 ea ff ff       	call   800b38 <memmove>
		*addrlen = ret->ret_addrlen;
  8020f2:	a1 10 60 80 00       	mov    0x806010,%eax
  8020f7:	89 06                	mov    %eax,(%esi)
  8020f9:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8020fc:	89 d8                	mov    %ebx,%eax
  8020fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    

00802105 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 08             	sub    $0x8,%esp
  80210c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802117:	53                   	push   %ebx
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	68 04 60 80 00       	push   $0x806004
  802120:	e8 13 ea ff ff       	call   800b38 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802125:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80212b:	b8 02 00 00 00       	mov    $0x2,%eax
  802130:	e8 34 ff ff ff       	call   802069 <nsipc>
}
  802135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802150:	b8 03 00 00 00       	mov    $0x3,%eax
  802155:	e8 0f ff ff ff       	call   802069 <nsipc>
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <nsipc_close>:

int
nsipc_close(int s)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80216a:	b8 04 00 00 00       	mov    $0x4,%eax
  80216f:	e8 f5 fe ff ff       	call   802069 <nsipc>
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	53                   	push   %ebx
  80217a:	83 ec 08             	sub    $0x8,%esp
  80217d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802188:	53                   	push   %ebx
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	68 04 60 80 00       	push   $0x806004
  802191:	e8 a2 e9 ff ff       	call   800b38 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802196:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80219c:	b8 05 00 00 00       	mov    $0x5,%eax
  8021a1:	e8 c3 fe ff ff       	call   802069 <nsipc>
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8021c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8021c6:	e8 9e fe ff ff       	call   802069 <nsipc>
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8021dd:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8021e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f0:	e8 74 fe ff ff       	call   802069 <nsipc>
  8021f5:	89 c3                	mov    %eax,%ebx
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	78 1f                	js     80221a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021fb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802200:	7f 21                	jg     802223 <nsipc_recv+0x56>
  802202:	39 c6                	cmp    %eax,%esi
  802204:	7c 1d                	jl     802223 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	50                   	push   %eax
  80220a:	68 00 60 80 00       	push   $0x806000
  80220f:	ff 75 0c             	pushl  0xc(%ebp)
  802212:	e8 21 e9 ff ff       	call   800b38 <memmove>
  802217:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80221a:	89 d8                	mov    %ebx,%eax
  80221c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221f:	5b                   	pop    %ebx
  802220:	5e                   	pop    %esi
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802223:	68 12 2e 80 00       	push   $0x802e12
  802228:	68 b4 2d 80 00       	push   $0x802db4
  80222d:	6a 62                	push   $0x62
  80222f:	68 27 2e 80 00       	push   $0x802e27
  802234:	e8 f9 df ff ff       	call   800232 <_panic>

00802239 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	53                   	push   %ebx
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80224b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802251:	7f 2e                	jg     802281 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	53                   	push   %ebx
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	68 0c 60 80 00       	push   $0x80600c
  80225f:	e8 d4 e8 ff ff       	call   800b38 <memmove>
	nsipcbuf.send.req_size = size;
  802264:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80226a:	8b 45 14             	mov    0x14(%ebp),%eax
  80226d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802272:	b8 08 00 00 00       	mov    $0x8,%eax
  802277:	e8 ed fd ff ff       	call   802069 <nsipc>
}
  80227c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227f:	c9                   	leave  
  802280:	c3                   	ret    
	assert(size < 1600);
  802281:	68 33 2e 80 00       	push   $0x802e33
  802286:	68 b4 2d 80 00       	push   $0x802db4
  80228b:	6a 6d                	push   $0x6d
  80228d:	68 27 2e 80 00       	push   $0x802e27
  802292:	e8 9b df ff ff       	call   800232 <_panic>

00802297 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a8:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8022ba:	e8 aa fd ff ff       	call   802069 <nsipc>
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    

008022cb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022d1:	68 3f 2e 80 00       	push   $0x802e3f
  8022d6:	ff 75 0c             	pushl  0xc(%ebp)
  8022d9:	e8 cc e6 ff ff       	call   8009aa <strcpy>
	return 0;
}
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <devcons_write>:
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	57                   	push   %edi
  8022e9:	56                   	push   %esi
  8022ea:	53                   	push   %ebx
  8022eb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022f1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022f6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022fc:	eb 2f                	jmp    80232d <devcons_write+0x48>
		m = n - tot;
  8022fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802301:	29 f3                	sub    %esi,%ebx
  802303:	83 fb 7f             	cmp    $0x7f,%ebx
  802306:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80230b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	53                   	push   %ebx
  802312:	89 f0                	mov    %esi,%eax
  802314:	03 45 0c             	add    0xc(%ebp),%eax
  802317:	50                   	push   %eax
  802318:	57                   	push   %edi
  802319:	e8 1a e8 ff ff       	call   800b38 <memmove>
		sys_cputs(buf, m);
  80231e:	83 c4 08             	add    $0x8,%esp
  802321:	53                   	push   %ebx
  802322:	57                   	push   %edi
  802323:	e8 bf e9 ff ff       	call   800ce7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802328:	01 de                	add    %ebx,%esi
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802330:	72 cc                	jb     8022fe <devcons_write+0x19>
}
  802332:	89 f0                	mov    %esi,%eax
  802334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <devcons_read>:
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 08             	sub    $0x8,%esp
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802347:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234b:	75 07                	jne    802354 <devcons_read+0x18>
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    
		sys_yield();
  80234f:	e8 30 ea ff ff       	call   800d84 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802354:	e8 ac e9 ff ff       	call   800d05 <sys_cgetc>
  802359:	85 c0                	test   %eax,%eax
  80235b:	74 f2                	je     80234f <devcons_read+0x13>
	if (c < 0)
  80235d:	85 c0                	test   %eax,%eax
  80235f:	78 ec                	js     80234d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802361:	83 f8 04             	cmp    $0x4,%eax
  802364:	74 0c                	je     802372 <devcons_read+0x36>
	*(char*)vbuf = c;
  802366:	8b 55 0c             	mov    0xc(%ebp),%edx
  802369:	88 02                	mov    %al,(%edx)
	return 1;
  80236b:	b8 01 00 00 00       	mov    $0x1,%eax
  802370:	eb db                	jmp    80234d <devcons_read+0x11>
		return 0;
  802372:	b8 00 00 00 00       	mov    $0x0,%eax
  802377:	eb d4                	jmp    80234d <devcons_read+0x11>

00802379 <cputchar>:
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802385:	6a 01                	push   $0x1
  802387:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80238a:	50                   	push   %eax
  80238b:	e8 57 e9 ff ff       	call   800ce7 <sys_cputs>
}
  802390:	83 c4 10             	add    $0x10,%esp
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <getchar>:
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80239b:	6a 01                	push   $0x1
  80239d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a0:	50                   	push   %eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	e8 1e f2 ff ff       	call   8015c6 <read>
	if (r < 0)
  8023a8:	83 c4 10             	add    $0x10,%esp
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	78 08                	js     8023b7 <getchar+0x22>
	if (r < 1)
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	7e 06                	jle    8023b9 <getchar+0x24>
	return c;
  8023b3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    
		return -E_EOF;
  8023b9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023be:	eb f7                	jmp    8023b7 <getchar+0x22>

008023c0 <iscons>:
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023c9:	50                   	push   %eax
  8023ca:	ff 75 08             	pushl  0x8(%ebp)
  8023cd:	e8 83 ef ff ff       	call   801355 <fd_lookup>
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	85 c0                	test   %eax,%eax
  8023d7:	78 11                	js     8023ea <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023e2:	39 10                	cmp    %edx,(%eax)
  8023e4:	0f 94 c0             	sete   %al
  8023e7:	0f b6 c0             	movzbl %al,%eax
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <opencons>:
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f5:	50                   	push   %eax
  8023f6:	e8 0b ef ff ff       	call   801306 <fd_alloc>
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	85 c0                	test   %eax,%eax
  802400:	78 3a                	js     80243c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 07 04 00 00       	push   $0x407
  80240a:	ff 75 f4             	pushl  -0xc(%ebp)
  80240d:	6a 00                	push   $0x0
  80240f:	e8 8f e9 ff ff       	call   800da3 <sys_page_alloc>
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	85 c0                	test   %eax,%eax
  802419:	78 21                	js     80243c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802424:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802430:	83 ec 0c             	sub    $0xc,%esp
  802433:	50                   	push   %eax
  802434:	e8 a6 ee ff ff       	call   8012df <fd2num>
  802439:	83 c4 10             	add    $0x10,%esp
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802444:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80244b:	74 0a                	je     802457 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802457:	a1 08 40 80 00       	mov    0x804008,%eax
  80245c:	8b 40 48             	mov    0x48(%eax),%eax
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	6a 07                	push   $0x7
  802464:	68 00 f0 bf ee       	push   $0xeebff000
  802469:	50                   	push   %eax
  80246a:	e8 34 e9 ff ff       	call   800da3 <sys_page_alloc>
  80246f:	83 c4 10             	add    $0x10,%esp
  802472:	85 c0                	test   %eax,%eax
  802474:	75 2f                	jne    8024a5 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802476:	a1 08 40 80 00       	mov    0x804008,%eax
  80247b:	8b 40 48             	mov    0x48(%eax),%eax
  80247e:	83 ec 08             	sub    $0x8,%esp
  802481:	68 b7 24 80 00       	push   $0x8024b7
  802486:	50                   	push   %eax
  802487:	e8 62 ea ff ff       	call   800eee <sys_env_set_pgfault_upcall>
  80248c:	83 c4 10             	add    $0x10,%esp
  80248f:	85 c0                	test   %eax,%eax
  802491:	74 ba                	je     80244d <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802493:	50                   	push   %eax
  802494:	68 4b 2e 80 00       	push   $0x802e4b
  802499:	6a 24                	push   $0x24
  80249b:	68 63 2e 80 00       	push   $0x802e63
  8024a0:	e8 8d dd ff ff       	call   800232 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8024a5:	50                   	push   %eax
  8024a6:	68 4b 2e 80 00       	push   $0x802e4b
  8024ab:	6a 21                	push   $0x21
  8024ad:	68 63 2e 80 00       	push   $0x802e63
  8024b2:	e8 7b dd ff ff       	call   800232 <_panic>

008024b7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024b7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024b8:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024bd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024bf:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8024c2:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8024c6:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8024c9:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8024cd:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8024d1:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8024d3:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8024d6:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8024d7:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8024da:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8024db:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8024dc:	c3                   	ret    

008024dd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	56                   	push   %esi
  8024e1:	53                   	push   %ebx
  8024e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8024e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8024eb:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8024ed:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8024f2:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8024f5:	83 ec 0c             	sub    $0xc,%esp
  8024f8:	50                   	push   %eax
  8024f9:	e8 55 ea ff ff       	call   800f53 <sys_ipc_recv>
  8024fe:	83 c4 10             	add    $0x10,%esp
  802501:	85 c0                	test   %eax,%eax
  802503:	78 2b                	js     802530 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802505:	85 f6                	test   %esi,%esi
  802507:	74 0a                	je     802513 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802509:	a1 08 40 80 00       	mov    0x804008,%eax
  80250e:	8b 40 74             	mov    0x74(%eax),%eax
  802511:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802513:	85 db                	test   %ebx,%ebx
  802515:	74 0a                	je     802521 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802517:	a1 08 40 80 00       	mov    0x804008,%eax
  80251c:	8b 40 78             	mov    0x78(%eax),%eax
  80251f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802521:	a1 08 40 80 00       	mov    0x804008,%eax
  802526:	8b 40 70             	mov    0x70(%eax),%eax
}
  802529:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
	    if (from_env_store != NULL) {
  802530:	85 f6                	test   %esi,%esi
  802532:	74 06                	je     80253a <ipc_recv+0x5d>
	        *from_env_store = 0;
  802534:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	74 eb                	je     802529 <ipc_recv+0x4c>
	        *perm_store = 0;
  80253e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802544:	eb e3                	jmp    802529 <ipc_recv+0x4c>

00802546 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	57                   	push   %edi
  80254a:	56                   	push   %esi
  80254b:	53                   	push   %ebx
  80254c:	83 ec 0c             	sub    $0xc,%esp
  80254f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802552:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802555:	85 f6                	test   %esi,%esi
  802557:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80255c:	0f 44 f0             	cmove  %eax,%esi
  80255f:	eb 09                	jmp    80256a <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802561:	e8 1e e8 ff ff       	call   800d84 <sys_yield>
	} while(r != 0);
  802566:	85 db                	test   %ebx,%ebx
  802568:	74 2d                	je     802597 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80256a:	ff 75 14             	pushl  0x14(%ebp)
  80256d:	56                   	push   %esi
  80256e:	ff 75 0c             	pushl  0xc(%ebp)
  802571:	57                   	push   %edi
  802572:	e8 b9 e9 ff ff       	call   800f30 <sys_ipc_try_send>
  802577:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	85 c0                	test   %eax,%eax
  80257e:	79 e1                	jns    802561 <ipc_send+0x1b>
  802580:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802583:	74 dc                	je     802561 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802585:	50                   	push   %eax
  802586:	68 71 2e 80 00       	push   $0x802e71
  80258b:	6a 45                	push   $0x45
  80258d:	68 7e 2e 80 00       	push   $0x802e7e
  802592:	e8 9b dc ff ff       	call   800232 <_panic>
}
  802597:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80259a:	5b                   	pop    %ebx
  80259b:	5e                   	pop    %esi
  80259c:	5f                   	pop    %edi
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    

0080259f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025aa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025ad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025b3:	8b 52 50             	mov    0x50(%edx),%edx
  8025b6:	39 ca                	cmp    %ecx,%edx
  8025b8:	74 11                	je     8025cb <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025ba:	83 c0 01             	add    $0x1,%eax
  8025bd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025c2:	75 e6                	jne    8025aa <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c9:	eb 0b                	jmp    8025d6 <ipc_find_env+0x37>
			return envs[i].env_id;
  8025cb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025d3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025d6:	5d                   	pop    %ebp
  8025d7:	c3                   	ret    

008025d8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025de:	89 d0                	mov    %edx,%eax
  8025e0:	c1 e8 16             	shr    $0x16,%eax
  8025e3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025ef:	f6 c1 01             	test   $0x1,%cl
  8025f2:	74 1d                	je     802611 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025f4:	c1 ea 0c             	shr    $0xc,%edx
  8025f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025fe:	f6 c2 01             	test   $0x1,%dl
  802601:	74 0e                	je     802611 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802603:	c1 ea 0c             	shr    $0xc,%edx
  802606:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80260d:	ef 
  80260e:	0f b7 c0             	movzwl %ax,%eax
}
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    
  802613:	66 90                	xchg   %ax,%ax
  802615:	66 90                	xchg   %ax,%ax
  802617:	66 90                	xchg   %ax,%ax
  802619:	66 90                	xchg   %ax,%ax
  80261b:	66 90                	xchg   %ax,%ax
  80261d:	66 90                	xchg   %ax,%ax
  80261f:	90                   	nop

00802620 <__udivdi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80262b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80262f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802633:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802637:	85 d2                	test   %edx,%edx
  802639:	75 35                	jne    802670 <__udivdi3+0x50>
  80263b:	39 f3                	cmp    %esi,%ebx
  80263d:	0f 87 bd 00 00 00    	ja     802700 <__udivdi3+0xe0>
  802643:	85 db                	test   %ebx,%ebx
  802645:	89 d9                	mov    %ebx,%ecx
  802647:	75 0b                	jne    802654 <__udivdi3+0x34>
  802649:	b8 01 00 00 00       	mov    $0x1,%eax
  80264e:	31 d2                	xor    %edx,%edx
  802650:	f7 f3                	div    %ebx
  802652:	89 c1                	mov    %eax,%ecx
  802654:	31 d2                	xor    %edx,%edx
  802656:	89 f0                	mov    %esi,%eax
  802658:	f7 f1                	div    %ecx
  80265a:	89 c6                	mov    %eax,%esi
  80265c:	89 e8                	mov    %ebp,%eax
  80265e:	89 f7                	mov    %esi,%edi
  802660:	f7 f1                	div    %ecx
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 1c             	add    $0x1c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	39 f2                	cmp    %esi,%edx
  802672:	77 7c                	ja     8026f0 <__udivdi3+0xd0>
  802674:	0f bd fa             	bsr    %edx,%edi
  802677:	83 f7 1f             	xor    $0x1f,%edi
  80267a:	0f 84 98 00 00 00    	je     802718 <__udivdi3+0xf8>
  802680:	89 f9                	mov    %edi,%ecx
  802682:	b8 20 00 00 00       	mov    $0x20,%eax
  802687:	29 f8                	sub    %edi,%eax
  802689:	d3 e2                	shl    %cl,%edx
  80268b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	89 da                	mov    %ebx,%edx
  802693:	d3 ea                	shr    %cl,%edx
  802695:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802699:	09 d1                	or     %edx,%ecx
  80269b:	89 f2                	mov    %esi,%edx
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 f9                	mov    %edi,%ecx
  8026a3:	d3 e3                	shl    %cl,%ebx
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	d3 ea                	shr    %cl,%edx
  8026a9:	89 f9                	mov    %edi,%ecx
  8026ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026af:	d3 e6                	shl    %cl,%esi
  8026b1:	89 eb                	mov    %ebp,%ebx
  8026b3:	89 c1                	mov    %eax,%ecx
  8026b5:	d3 eb                	shr    %cl,%ebx
  8026b7:	09 de                	or     %ebx,%esi
  8026b9:	89 f0                	mov    %esi,%eax
  8026bb:	f7 74 24 08          	divl   0x8(%esp)
  8026bf:	89 d6                	mov    %edx,%esi
  8026c1:	89 c3                	mov    %eax,%ebx
  8026c3:	f7 64 24 0c          	mull   0xc(%esp)
  8026c7:	39 d6                	cmp    %edx,%esi
  8026c9:	72 0c                	jb     8026d7 <__udivdi3+0xb7>
  8026cb:	89 f9                	mov    %edi,%ecx
  8026cd:	d3 e5                	shl    %cl,%ebp
  8026cf:	39 c5                	cmp    %eax,%ebp
  8026d1:	73 5d                	jae    802730 <__udivdi3+0x110>
  8026d3:	39 d6                	cmp    %edx,%esi
  8026d5:	75 59                	jne    802730 <__udivdi3+0x110>
  8026d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026da:	31 ff                	xor    %edi,%edi
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d 76 00             	lea    0x0(%esi),%esi
  8026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8026f0:	31 ff                	xor    %edi,%edi
  8026f2:	31 c0                	xor    %eax,%eax
  8026f4:	89 fa                	mov    %edi,%edx
  8026f6:	83 c4 1c             	add    $0x1c,%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
  8026fe:	66 90                	xchg   %ax,%ax
  802700:	31 ff                	xor    %edi,%edi
  802702:	89 e8                	mov    %ebp,%eax
  802704:	89 f2                	mov    %esi,%edx
  802706:	f7 f3                	div    %ebx
  802708:	89 fa                	mov    %edi,%edx
  80270a:	83 c4 1c             	add    $0x1c,%esp
  80270d:	5b                   	pop    %ebx
  80270e:	5e                   	pop    %esi
  80270f:	5f                   	pop    %edi
  802710:	5d                   	pop    %ebp
  802711:	c3                   	ret    
  802712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802718:	39 f2                	cmp    %esi,%edx
  80271a:	72 06                	jb     802722 <__udivdi3+0x102>
  80271c:	31 c0                	xor    %eax,%eax
  80271e:	39 eb                	cmp    %ebp,%ebx
  802720:	77 d2                	ja     8026f4 <__udivdi3+0xd4>
  802722:	b8 01 00 00 00       	mov    $0x1,%eax
  802727:	eb cb                	jmp    8026f4 <__udivdi3+0xd4>
  802729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802730:	89 d8                	mov    %ebx,%eax
  802732:	31 ff                	xor    %edi,%edi
  802734:	eb be                	jmp    8026f4 <__udivdi3+0xd4>
  802736:	66 90                	xchg   %ax,%ax
  802738:	66 90                	xchg   %ax,%ax
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__umoddi3>:
  802740:	55                   	push   %ebp
  802741:	57                   	push   %edi
  802742:	56                   	push   %esi
  802743:	53                   	push   %ebx
  802744:	83 ec 1c             	sub    $0x1c,%esp
  802747:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80274b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80274f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802757:	85 ed                	test   %ebp,%ebp
  802759:	89 f0                	mov    %esi,%eax
  80275b:	89 da                	mov    %ebx,%edx
  80275d:	75 19                	jne    802778 <__umoddi3+0x38>
  80275f:	39 df                	cmp    %ebx,%edi
  802761:	0f 86 b1 00 00 00    	jbe    802818 <__umoddi3+0xd8>
  802767:	f7 f7                	div    %edi
  802769:	89 d0                	mov    %edx,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	39 dd                	cmp    %ebx,%ebp
  80277a:	77 f1                	ja     80276d <__umoddi3+0x2d>
  80277c:	0f bd cd             	bsr    %ebp,%ecx
  80277f:	83 f1 1f             	xor    $0x1f,%ecx
  802782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802786:	0f 84 b4 00 00 00    	je     802840 <__umoddi3+0x100>
  80278c:	b8 20 00 00 00       	mov    $0x20,%eax
  802791:	89 c2                	mov    %eax,%edx
  802793:	8b 44 24 04          	mov    0x4(%esp),%eax
  802797:	29 c2                	sub    %eax,%edx
  802799:	89 c1                	mov    %eax,%ecx
  80279b:	89 f8                	mov    %edi,%eax
  80279d:	d3 e5                	shl    %cl,%ebp
  80279f:	89 d1                	mov    %edx,%ecx
  8027a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	09 c5                	or     %eax,%ebp
  8027a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	d3 e7                	shl    %cl,%edi
  8027b1:	89 d1                	mov    %edx,%ecx
  8027b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027b7:	89 df                	mov    %ebx,%edi
  8027b9:	d3 ef                	shr    %cl,%edi
  8027bb:	89 c1                	mov    %eax,%ecx
  8027bd:	89 f0                	mov    %esi,%eax
  8027bf:	d3 e3                	shl    %cl,%ebx
  8027c1:	89 d1                	mov    %edx,%ecx
  8027c3:	89 fa                	mov    %edi,%edx
  8027c5:	d3 e8                	shr    %cl,%eax
  8027c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027cc:	09 d8                	or     %ebx,%eax
  8027ce:	f7 f5                	div    %ebp
  8027d0:	d3 e6                	shl    %cl,%esi
  8027d2:	89 d1                	mov    %edx,%ecx
  8027d4:	f7 64 24 08          	mull   0x8(%esp)
  8027d8:	39 d1                	cmp    %edx,%ecx
  8027da:	89 c3                	mov    %eax,%ebx
  8027dc:	89 d7                	mov    %edx,%edi
  8027de:	72 06                	jb     8027e6 <__umoddi3+0xa6>
  8027e0:	75 0e                	jne    8027f0 <__umoddi3+0xb0>
  8027e2:	39 c6                	cmp    %eax,%esi
  8027e4:	73 0a                	jae    8027f0 <__umoddi3+0xb0>
  8027e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027ea:	19 ea                	sbb    %ebp,%edx
  8027ec:	89 d7                	mov    %edx,%edi
  8027ee:	89 c3                	mov    %eax,%ebx
  8027f0:	89 ca                	mov    %ecx,%edx
  8027f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8027f7:	29 de                	sub    %ebx,%esi
  8027f9:	19 fa                	sbb    %edi,%edx
  8027fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	d3 e0                	shl    %cl,%eax
  802803:	89 d9                	mov    %ebx,%ecx
  802805:	d3 ee                	shr    %cl,%esi
  802807:	d3 ea                	shr    %cl,%edx
  802809:	09 f0                	or     %esi,%eax
  80280b:	83 c4 1c             	add    $0x1c,%esp
  80280e:	5b                   	pop    %ebx
  80280f:	5e                   	pop    %esi
  802810:	5f                   	pop    %edi
  802811:	5d                   	pop    %ebp
  802812:	c3                   	ret    
  802813:	90                   	nop
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	85 ff                	test   %edi,%edi
  80281a:	89 f9                	mov    %edi,%ecx
  80281c:	75 0b                	jne    802829 <__umoddi3+0xe9>
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
  802823:	31 d2                	xor    %edx,%edx
  802825:	f7 f7                	div    %edi
  802827:	89 c1                	mov    %eax,%ecx
  802829:	89 d8                	mov    %ebx,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	f7 f1                	div    %ecx
  80282f:	89 f0                	mov    %esi,%eax
  802831:	f7 f1                	div    %ecx
  802833:	e9 31 ff ff ff       	jmp    802769 <__umoddi3+0x29>
  802838:	90                   	nop
  802839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802840:	39 dd                	cmp    %ebx,%ebp
  802842:	72 08                	jb     80284c <__umoddi3+0x10c>
  802844:	39 f7                	cmp    %esi,%edi
  802846:	0f 87 21 ff ff ff    	ja     80276d <__umoddi3+0x2d>
  80284c:	89 da                	mov    %ebx,%edx
  80284e:	89 f0                	mov    %esi,%eax
  802850:	29 f8                	sub    %edi,%eax
  802852:	19 ea                	sbb    %ebp,%edx
  802854:	e9 14 ff ff ff       	jmp    80276d <__umoddi3+0x2d>
