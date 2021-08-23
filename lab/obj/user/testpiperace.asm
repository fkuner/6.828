
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 bf 01 00 00       	call   8001f0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 80 28 80 00       	push   $0x802880
  800040:	e8 e6 02 00 00       	call   80032b <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 e4 1d 00 00       	call   801e34 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 5b                	js     8000b2 <umain+0x7f>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 5f 10 00 00       	call   8010bb <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 62                	js     8000c4 <umain+0x91>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	85 c0                	test   %eax,%eax
  800064:	74 70                	je     8000d6 <umain+0xa3>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	68 d1 28 80 00       	push   $0x8028d1
  80006f:	e8 b7 02 00 00       	call   80032b <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800074:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007a:	83 c4 08             	add    $0x8,%esp
  80007d:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800080:	c1 f8 02             	sar    $0x2,%eax
  800083:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  800089:	50                   	push   %eax
  80008a:	68 dc 28 80 00       	push   $0x8028dc
  80008f:	e8 97 02 00 00       	call   80032b <cprintf>
	dup(p[0], 10);
  800094:	83 c4 08             	add    $0x8,%esp
  800097:	6a 0a                	push   $0xa
  800099:	ff 75 f0             	pushl  -0x10(%ebp)
  80009c:	e8 52 15 00 00       	call   8015f3 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ad:	e9 92 00 00 00       	jmp    800144 <umain+0x111>
		panic("pipe: %e", r);
  8000b2:	50                   	push   %eax
  8000b3:	68 99 28 80 00       	push   $0x802899
  8000b8:	6a 0d                	push   $0xd
  8000ba:	68 a2 28 80 00       	push   $0x8028a2
  8000bf:	e8 8c 01 00 00       	call   800250 <_panic>
		panic("fork: %e", r);
  8000c4:	50                   	push   %eax
  8000c5:	68 06 2d 80 00       	push   $0x802d06
  8000ca:	6a 10                	push   $0x10
  8000cc:	68 a2 28 80 00       	push   $0x8028a2
  8000d1:	e8 7a 01 00 00       	call   800250 <_panic>
		close(p[1]);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dc:	e8 c2 14 00 00       	call   8015a3 <close>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000e9:	eb 0a                	jmp    8000f5 <umain+0xc2>
			sys_yield();
  8000eb:	e8 b2 0c 00 00       	call   800da2 <sys_yield>
		for (i=0; i<max; i++) {
  8000f0:	83 eb 01             	sub    $0x1,%ebx
  8000f3:	74 29                	je     80011e <umain+0xeb>
			if(pipeisclosed(p[0])){
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000fb:	e8 7d 1e 00 00       	call   801f7d <pipeisclosed>
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	85 c0                	test   %eax,%eax
  800105:	74 e4                	je     8000eb <umain+0xb8>
				cprintf("RACE: pipe appears closed\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 b6 28 80 00       	push   $0x8028b6
  80010f:	e8 17 02 00 00       	call   80032b <cprintf>
				exit();
  800114:	e8 1d 01 00 00       	call   800236 <exit>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	eb cd                	jmp    8000eb <umain+0xb8>
		ipc_recv(0,0,0);
  80011e:	83 ec 04             	sub    $0x4,%esp
  800121:	6a 00                	push   $0x0
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	e8 d1 11 00 00       	call   8012fd <ipc_recv>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	e9 32 ff ff ff       	jmp    800066 <umain+0x33>
		dup(p[0], 10);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	6a 0a                	push   $0xa
  800139:	ff 75 f0             	pushl  -0x10(%ebp)
  80013c:	e8 b2 14 00 00       	call   8015f3 <dup>
  800141:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800144:	8b 53 54             	mov    0x54(%ebx),%edx
  800147:	83 fa 02             	cmp    $0x2,%edx
  80014a:	74 e8                	je     800134 <umain+0x101>

	cprintf("child done with loop\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 e7 28 80 00       	push   $0x8028e7
  800154:	e8 d2 01 00 00       	call   80032b <cprintf>
	if (pipeisclosed(p[0]))
  800159:	83 c4 04             	add    $0x4,%esp
  80015c:	ff 75 f0             	pushl  -0x10(%ebp)
  80015f:	e8 19 1e 00 00       	call   801f7d <pipeisclosed>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	85 c0                	test   %eax,%eax
  800169:	75 48                	jne    8001b3 <umain+0x180>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800171:	50                   	push   %eax
  800172:	ff 75 f0             	pushl  -0x10(%ebp)
  800175:	e8 f4 12 00 00       	call   80146e <fd_lookup>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	78 46                	js     8001c7 <umain+0x194>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 ec             	pushl  -0x14(%ebp)
  800187:	e8 7c 12 00 00       	call   801408 <fd2data>
	if (pageref(va) != 3+1)
  80018c:	89 04 24             	mov    %eax,(%esp)
  80018f:	e8 94 1a 00 00       	call   801c28 <pageref>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	83 f8 04             	cmp    $0x4,%eax
  80019a:	74 3d                	je     8001d9 <umain+0x1a6>
		cprintf("\nchild detected race\n");
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 15 29 80 00       	push   $0x802915
  8001a4:	e8 82 01 00 00       	call   80032b <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001af:	5b                   	pop    %ebx
  8001b0:	5e                   	pop    %esi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	68 40 29 80 00       	push   $0x802940
  8001bb:	6a 3a                	push   $0x3a
  8001bd:	68 a2 28 80 00       	push   $0x8028a2
  8001c2:	e8 89 00 00 00       	call   800250 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c7:	50                   	push   %eax
  8001c8:	68 fd 28 80 00       	push   $0x8028fd
  8001cd:	6a 3c                	push   $0x3c
  8001cf:	68 a2 28 80 00       	push   $0x8028a2
  8001d4:	e8 77 00 00 00       	call   800250 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	68 c8 00 00 00       	push   $0xc8
  8001e1:	68 2b 29 80 00       	push   $0x80292b
  8001e6:	e8 40 01 00 00       	call   80032b <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
}
  8001ee:	eb bc                	jmp    8001ac <umain+0x179>

008001f0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8001fb:	e8 83 0b 00 00       	call   800d83 <sys_getenvid>
  800200:	25 ff 03 00 00       	and    $0x3ff,%eax
  800205:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800212:	85 db                	test   %ebx,%ebx
  800214:	7e 07                	jle    80021d <libmain+0x2d>
		binaryname = argv[0];
  800216:	8b 06                	mov    (%esi),%eax
  800218:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	e8 0c fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800227:	e8 0a 00 00 00       	call   800236 <exit>
}
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023c:	e8 8d 13 00 00       	call   8015ce <close_all>
	sys_env_destroy(0);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	6a 00                	push   $0x0
  800246:	e8 f7 0a 00 00       	call   800d42 <sys_env_destroy>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800255:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800258:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80025e:	e8 20 0b 00 00       	call   800d83 <sys_getenvid>
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	56                   	push   %esi
  80026d:	50                   	push   %eax
  80026e:	68 74 29 80 00       	push   $0x802974
  800273:	e8 b3 00 00 00       	call   80032b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800278:	83 c4 18             	add    $0x18,%esp
  80027b:	53                   	push   %ebx
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	e8 56 00 00 00       	call   8002da <vcprintf>
	cprintf("\n");
  800284:	c7 04 24 97 28 80 00 	movl   $0x802897,(%esp)
  80028b:	e8 9b 00 00 00       	call   80032b <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800293:	cc                   	int3   
  800294:	eb fd                	jmp    800293 <_panic+0x43>

00800296 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	53                   	push   %ebx
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a0:	8b 13                	mov    (%ebx),%edx
  8002a2:	8d 42 01             	lea    0x1(%edx),%eax
  8002a5:	89 03                	mov    %eax,(%ebx)
  8002a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b3:	74 09                	je     8002be <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	68 ff 00 00 00       	push   $0xff
  8002c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c9:	50                   	push   %eax
  8002ca:	e8 36 0a 00 00       	call   800d05 <sys_cputs>
		b->idx = 0;
  8002cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d5:	83 c4 10             	add    $0x10,%esp
  8002d8:	eb db                	jmp    8002b5 <putch+0x1f>

008002da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ea:	00 00 00 
	b.cnt = 0;
  8002ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	68 96 02 80 00       	push   $0x800296
  800309:	e8 1a 01 00 00       	call   800428 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030e:	83 c4 08             	add    $0x8,%esp
  800311:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800317:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031d:	50                   	push   %eax
  80031e:	e8 e2 09 00 00       	call   800d05 <sys_cputs>

	return b.cnt;
}
  800323:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800331:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800334:	50                   	push   %eax
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	e8 9d ff ff ff       	call   8002da <vcprintf>
	va_end(ap);

	return cnt;
}
  80033d:	c9                   	leave  
  80033e:	c3                   	ret    

0080033f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	57                   	push   %edi
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 1c             	sub    $0x1c,%esp
  800348:	89 c7                	mov    %eax,%edi
  80034a:	89 d6                	mov    %edx,%esi
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800355:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80035b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800360:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800363:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800366:	39 d3                	cmp    %edx,%ebx
  800368:	72 05                	jb     80036f <printnum+0x30>
  80036a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80036d:	77 7a                	ja     8003e9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	ff 75 18             	pushl  0x18(%ebp)
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037b:	53                   	push   %ebx
  80037c:	ff 75 10             	pushl  0x10(%ebp)
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 e4             	pushl  -0x1c(%ebp)
  800385:	ff 75 e0             	pushl  -0x20(%ebp)
  800388:	ff 75 dc             	pushl  -0x24(%ebp)
  80038b:	ff 75 d8             	pushl  -0x28(%ebp)
  80038e:	e8 ad 22 00 00       	call   802640 <__udivdi3>
  800393:	83 c4 18             	add    $0x18,%esp
  800396:	52                   	push   %edx
  800397:	50                   	push   %eax
  800398:	89 f2                	mov    %esi,%edx
  80039a:	89 f8                	mov    %edi,%eax
  80039c:	e8 9e ff ff ff       	call   80033f <printnum>
  8003a1:	83 c4 20             	add    $0x20,%esp
  8003a4:	eb 13                	jmp    8003b9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	56                   	push   %esi
  8003aa:	ff 75 18             	pushl  0x18(%ebp)
  8003ad:	ff d7                	call   *%edi
  8003af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b2:	83 eb 01             	sub    $0x1,%ebx
  8003b5:	85 db                	test   %ebx,%ebx
  8003b7:	7f ed                	jg     8003a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	56                   	push   %esi
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cc:	e8 8f 23 00 00       	call   802760 <__umoddi3>
  8003d1:	83 c4 14             	add    $0x14,%esp
  8003d4:	0f be 80 97 29 80 00 	movsbl 0x802997(%eax),%eax
  8003db:	50                   	push   %eax
  8003dc:	ff d7                	call   *%edi
}
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    
  8003e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ec:	eb c4                	jmp    8003b2 <printnum+0x73>

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fd:	73 0a                	jae    800409 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800402:	89 08                	mov    %ecx,(%eax)
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	88 02                	mov    %al,(%edx)
}
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <printfmt>:
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800411:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800414:	50                   	push   %eax
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 05 00 00 00       	call   800428 <vprintfmt>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <vprintfmt>:
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	57                   	push   %edi
  80042c:	56                   	push   %esi
  80042d:	53                   	push   %ebx
  80042e:	83 ec 2c             	sub    $0x2c,%esp
  800431:	8b 75 08             	mov    0x8(%ebp),%esi
  800434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800437:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043a:	e9 21 04 00 00       	jmp    800860 <vprintfmt+0x438>
		padc = ' ';
  80043f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800443:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80044a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800451:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800458:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8d 47 01             	lea    0x1(%edi),%eax
  800460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800463:	0f b6 17             	movzbl (%edi),%edx
  800466:	8d 42 dd             	lea    -0x23(%edx),%eax
  800469:	3c 55                	cmp    $0x55,%al
  80046b:	0f 87 90 04 00 00    	ja     800901 <vprintfmt+0x4d9>
  800471:	0f b6 c0             	movzbl %al,%eax
  800474:	ff 24 85 e0 2a 80 00 	jmp    *0x802ae0(,%eax,4)
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800482:	eb d9                	jmp    80045d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800487:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80048b:	eb d0                	jmp    80045d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	0f b6 d2             	movzbl %dl,%edx
  800490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a8:	83 f9 09             	cmp    $0x9,%ecx
  8004ab:	77 55                	ja     800502 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b0:	eb e9                	jmp    80049b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 04             	lea    0x4(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ca:	79 91                	jns    80045d <vprintfmt+0x35>
				width = precision, precision = -1;
  8004cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d9:	eb 82                	jmp    80045d <vprintfmt+0x35>
  8004db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e5:	0f 49 d0             	cmovns %eax,%edx
  8004e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ee:	e9 6a ff ff ff       	jmp    80045d <vprintfmt+0x35>
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004fd:	e9 5b ff ff ff       	jmp    80045d <vprintfmt+0x35>
  800502:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800505:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800508:	eb bc                	jmp    8004c6 <vprintfmt+0x9e>
			lflag++;
  80050a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800510:	e9 48 ff ff ff       	jmp    80045d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 78 04             	lea    0x4(%eax),%edi
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	ff 30                	pushl  (%eax)
  800521:	ff d6                	call   *%esi
			break;
  800523:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800529:	e9 2f 03 00 00       	jmp    80085d <vprintfmt+0x435>
			err = va_arg(ap, int);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 78 04             	lea    0x4(%eax),%edi
  800534:	8b 00                	mov    (%eax),%eax
  800536:	99                   	cltd   
  800537:	31 d0                	xor    %edx,%eax
  800539:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053b:	83 f8 0f             	cmp    $0xf,%eax
  80053e:	7f 23                	jg     800563 <vprintfmt+0x13b>
  800540:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  800547:	85 d2                	test   %edx,%edx
  800549:	74 18                	je     800563 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80054b:	52                   	push   %edx
  80054c:	68 1a 2e 80 00       	push   $0x802e1a
  800551:	53                   	push   %ebx
  800552:	56                   	push   %esi
  800553:	e8 b3 fe ff ff       	call   80040b <printfmt>
  800558:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055e:	e9 fa 02 00 00       	jmp    80085d <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  800563:	50                   	push   %eax
  800564:	68 af 29 80 00       	push   $0x8029af
  800569:	53                   	push   %ebx
  80056a:	56                   	push   %esi
  80056b:	e8 9b fe ff ff       	call   80040b <printfmt>
  800570:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800573:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800576:	e9 e2 02 00 00       	jmp    80085d <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 c0 04             	add    $0x4,%eax
  800581:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800589:	85 ff                	test   %edi,%edi
  80058b:	b8 a8 29 80 00       	mov    $0x8029a8,%eax
  800590:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	0f 8e bd 00 00 00    	jle    80065a <vprintfmt+0x232>
  80059d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005a1:	75 0e                	jne    8005b1 <vprintfmt+0x189>
  8005a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005af:	eb 6d                	jmp    80061e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8005b7:	57                   	push   %edi
  8005b8:	e8 ec 03 00 00       	call   8009a9 <strnlen>
  8005bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c0:	29 c1                	sub    %eax,%ecx
  8005c2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	eb 0f                	jmp    8005e5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	ff 75 e0             	pushl  -0x20(%ebp)
  8005dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	83 ef 01             	sub    $0x1,%edi
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	85 ff                	test   %edi,%edi
  8005e7:	7f ed                	jg     8005d6 <vprintfmt+0x1ae>
  8005e9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005ec:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f6:	0f 49 c1             	cmovns %ecx,%eax
  8005f9:	29 c1                	sub    %eax,%ecx
  8005fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8005fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800601:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800604:	89 cb                	mov    %ecx,%ebx
  800606:	eb 16                	jmp    80061e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800608:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060c:	75 31                	jne    80063f <vprintfmt+0x217>
					putch(ch, putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	ff 55 08             	call   *0x8(%ebp)
  800618:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061b:	83 eb 01             	sub    $0x1,%ebx
  80061e:	83 c7 01             	add    $0x1,%edi
  800621:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800625:	0f be c2             	movsbl %dl,%eax
  800628:	85 c0                	test   %eax,%eax
  80062a:	74 59                	je     800685 <vprintfmt+0x25d>
  80062c:	85 f6                	test   %esi,%esi
  80062e:	78 d8                	js     800608 <vprintfmt+0x1e0>
  800630:	83 ee 01             	sub    $0x1,%esi
  800633:	79 d3                	jns    800608 <vprintfmt+0x1e0>
  800635:	89 df                	mov    %ebx,%edi
  800637:	8b 75 08             	mov    0x8(%ebp),%esi
  80063a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80063d:	eb 37                	jmp    800676 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80063f:	0f be d2             	movsbl %dl,%edx
  800642:	83 ea 20             	sub    $0x20,%edx
  800645:	83 fa 5e             	cmp    $0x5e,%edx
  800648:	76 c4                	jbe    80060e <vprintfmt+0x1e6>
					putch('?', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	6a 3f                	push   $0x3f
  800652:	ff 55 08             	call   *0x8(%ebp)
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb c1                	jmp    80061b <vprintfmt+0x1f3>
  80065a:	89 75 08             	mov    %esi,0x8(%ebp)
  80065d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800660:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800663:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800666:	eb b6                	jmp    80061e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 20                	push   $0x20
  80066e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800670:	83 ef 01             	sub    $0x1,%edi
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	85 ff                	test   %edi,%edi
  800678:	7f ee                	jg     800668 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80067a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
  800680:	e9 d8 01 00 00       	jmp    80085d <vprintfmt+0x435>
  800685:	89 df                	mov    %ebx,%edi
  800687:	8b 75 08             	mov    0x8(%ebp),%esi
  80068a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80068d:	eb e7                	jmp    800676 <vprintfmt+0x24e>
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 45                	jle    8006d9 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 08             	lea    0x8(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006af:	79 62                	jns    800713 <vprintfmt+0x2eb>
				putch('-', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 2d                	push   $0x2d
  8006b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006bf:	f7 d8                	neg    %eax
  8006c1:	83 d2 00             	adc    $0x0,%edx
  8006c4:	f7 da                	neg    %edx
  8006c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006cf:	ba 0a 00 00 00       	mov    $0xa,%edx
  8006d4:	e9 66 01 00 00       	jmp    80083f <vprintfmt+0x417>
	else if (lflag)
  8006d9:	85 c9                	test   %ecx,%ecx
  8006db:	75 1b                	jne    8006f8 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e5:	89 c1                	mov    %eax,%ecx
  8006e7:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 40 04             	lea    0x4(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f6:	eb b3                	jmp    8006ab <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800700:	89 c1                	mov    %eax,%ecx
  800702:	c1 f9 1f             	sar    $0x1f,%ecx
  800705:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
  800711:	eb 98                	jmp    8006ab <vprintfmt+0x283>
			base = 10;
  800713:	ba 0a 00 00 00       	mov    $0xa,%edx
  800718:	e9 22 01 00 00       	jmp    80083f <vprintfmt+0x417>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7e 21                	jle    800743 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 50 04             	mov    0x4(%eax),%edx
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 40 08             	lea    0x8(%eax),%eax
  800736:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800739:	ba 0a 00 00 00       	mov    $0xa,%edx
  80073e:	e9 fc 00 00 00       	jmp    80083f <vprintfmt+0x417>
	else if (lflag)
  800743:	85 c9                	test   %ecx,%ecx
  800745:	75 23                	jne    80076a <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800754:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800760:	ba 0a 00 00 00       	mov    $0xa,%edx
  800765:	e9 d5 00 00 00       	jmp    80083f <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 04             	lea    0x4(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800783:	ba 0a 00 00 00       	mov    $0xa,%edx
  800788:	e9 b2 00 00 00       	jmp    80083f <vprintfmt+0x417>
	if (lflag >= 2)
  80078d:	83 f9 01             	cmp    $0x1,%ecx
  800790:	7e 42                	jle    8007d4 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 50 04             	mov    0x4(%eax),%edx
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 08             	lea    0x8(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a9:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8007ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007b2:	0f 89 87 00 00 00    	jns    80083f <vprintfmt+0x417>
				putch('-', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	53                   	push   %ebx
  8007bc:	6a 2d                	push   $0x2d
  8007be:	ff d6                	call   *%esi
				num = -(long long) num;
  8007c0:	f7 5d d8             	negl   -0x28(%ebp)
  8007c3:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8007c7:	f7 5d dc             	negl   -0x24(%ebp)
  8007ca:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8007cd:	ba 08 00 00 00       	mov    $0x8,%edx
  8007d2:	eb 6b                	jmp    80083f <vprintfmt+0x417>
	else if (lflag)
  8007d4:	85 c9                	test   %ecx,%ecx
  8007d6:	75 1b                	jne    8007f3 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	eb b6                	jmp    8007a9 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800800:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
  80080c:	eb 9b                	jmp    8007a9 <vprintfmt+0x381>
			putch('0', putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	6a 30                	push   $0x30
  800814:	ff d6                	call   *%esi
			putch('x', putdat);
  800816:	83 c4 08             	add    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 78                	push   $0x78
  80081c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	ba 00 00 00 00       	mov    $0x0,%edx
  800828:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80082e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8d 40 04             	lea    0x4(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083a:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  80083f:	83 ec 0c             	sub    $0xc,%esp
  800842:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800846:	50                   	push   %eax
  800847:	ff 75 e0             	pushl  -0x20(%ebp)
  80084a:	52                   	push   %edx
  80084b:	ff 75 dc             	pushl  -0x24(%ebp)
  80084e:	ff 75 d8             	pushl  -0x28(%ebp)
  800851:	89 da                	mov    %ebx,%edx
  800853:	89 f0                	mov    %esi,%eax
  800855:	e8 e5 fa ff ff       	call   80033f <printnum>
			break;
  80085a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80085d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800860:	83 c7 01             	add    $0x1,%edi
  800863:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800867:	83 f8 25             	cmp    $0x25,%eax
  80086a:	0f 84 cf fb ff ff    	je     80043f <vprintfmt+0x17>
			if (ch == '\0')
  800870:	85 c0                	test   %eax,%eax
  800872:	0f 84 a9 00 00 00    	je     800921 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	53                   	push   %ebx
  80087c:	50                   	push   %eax
  80087d:	ff d6                	call   *%esi
  80087f:	83 c4 10             	add    $0x10,%esp
  800882:	eb dc                	jmp    800860 <vprintfmt+0x438>
	if (lflag >= 2)
  800884:	83 f9 01             	cmp    $0x1,%ecx
  800887:	7e 1e                	jle    8008a7 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8b 50 04             	mov    0x4(%eax),%edx
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800894:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 08             	lea    0x8(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a0:	ba 10 00 00 00       	mov    $0x10,%edx
  8008a5:	eb 98                	jmp    80083f <vprintfmt+0x417>
	else if (lflag)
  8008a7:	85 c9                	test   %ecx,%ecx
  8008a9:	75 23                	jne    8008ce <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8d 40 04             	lea    0x4(%eax),%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c4:	ba 10 00 00 00       	mov    $0x10,%edx
  8008c9:	e9 71 ff ff ff       	jmp    80083f <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	8d 40 04             	lea    0x4(%eax),%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e7:	ba 10 00 00 00       	mov    $0x10,%edx
  8008ec:	e9 4e ff ff ff       	jmp    80083f <vprintfmt+0x417>
			putch(ch, putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	53                   	push   %ebx
  8008f5:	6a 25                	push   $0x25
  8008f7:	ff d6                	call   *%esi
			break;
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	e9 5c ff ff ff       	jmp    80085d <vprintfmt+0x435>
			putch('%', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	53                   	push   %ebx
  800905:	6a 25                	push   $0x25
  800907:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	89 f8                	mov    %edi,%eax
  80090e:	eb 03                	jmp    800913 <vprintfmt+0x4eb>
  800910:	83 e8 01             	sub    $0x1,%eax
  800913:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800917:	75 f7                	jne    800910 <vprintfmt+0x4e8>
  800919:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091c:	e9 3c ff ff ff       	jmp    80085d <vprintfmt+0x435>
}
  800921:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5f                   	pop    %edi
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	83 ec 18             	sub    $0x18,%esp
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800935:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800938:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80093c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800946:	85 c0                	test   %eax,%eax
  800948:	74 26                	je     800970 <vsnprintf+0x47>
  80094a:	85 d2                	test   %edx,%edx
  80094c:	7e 22                	jle    800970 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094e:	ff 75 14             	pushl  0x14(%ebp)
  800951:	ff 75 10             	pushl  0x10(%ebp)
  800954:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	68 ee 03 80 00       	push   $0x8003ee
  80095d:	e8 c6 fa ff ff       	call   800428 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800965:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80096b:	83 c4 10             	add    $0x10,%esp
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    
		return -E_INVAL;
  800970:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800975:	eb f7                	jmp    80096e <vsnprintf+0x45>

00800977 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80097d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800980:	50                   	push   %eax
  800981:	ff 75 10             	pushl  0x10(%ebp)
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 9a ff ff ff       	call   800929 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800997:	b8 00 00 00 00       	mov    $0x0,%eax
  80099c:	eb 03                	jmp    8009a1 <strlen+0x10>
		n++;
  80099e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009a1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a5:	75 f7                	jne    80099e <strlen+0xd>
	return n;
}
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009af:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b7:	eb 03                	jmp    8009bc <strnlen+0x13>
		n++;
  8009b9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009bc:	39 d0                	cmp    %edx,%eax
  8009be:	74 06                	je     8009c6 <strnlen+0x1d>
  8009c0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009c4:	75 f3                	jne    8009b9 <strnlen+0x10>
	return n;
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d2:	89 c2                	mov    %eax,%edx
  8009d4:	83 c1 01             	add    $0x1,%ecx
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009de:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e1:	84 db                	test   %bl,%bl
  8009e3:	75 ef                	jne    8009d4 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009e5:	5b                   	pop    %ebx
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	53                   	push   %ebx
  8009ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ef:	53                   	push   %ebx
  8009f0:	e8 9c ff ff ff       	call   800991 <strlen>
  8009f5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	01 d8                	add    %ebx,%eax
  8009fd:	50                   	push   %eax
  8009fe:	e8 c5 ff ff ff       	call   8009c8 <strcpy>
	return dst;
}
  800a03:	89 d8                	mov    %ebx,%eax
  800a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a15:	89 f3                	mov    %esi,%ebx
  800a17:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1a:	89 f2                	mov    %esi,%edx
  800a1c:	eb 0f                	jmp    800a2d <strncpy+0x23>
		*dst++ = *src;
  800a1e:	83 c2 01             	add    $0x1,%edx
  800a21:	0f b6 01             	movzbl (%ecx),%eax
  800a24:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a27:	80 39 01             	cmpb   $0x1,(%ecx)
  800a2a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a2d:	39 da                	cmp    %ebx,%edx
  800a2f:	75 ed                	jne    800a1e <strncpy+0x14>
	}
	return ret;
}
  800a31:	89 f0                	mov    %esi,%eax
  800a33:	5b                   	pop    %ebx
  800a34:	5e                   	pop    %esi
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a45:	89 f0                	mov    %esi,%eax
  800a47:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a4b:	85 c9                	test   %ecx,%ecx
  800a4d:	75 0b                	jne    800a5a <strlcpy+0x23>
  800a4f:	eb 17                	jmp    800a68 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a51:	83 c2 01             	add    $0x1,%edx
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a5a:	39 d8                	cmp    %ebx,%eax
  800a5c:	74 07                	je     800a65 <strlcpy+0x2e>
  800a5e:	0f b6 0a             	movzbl (%edx),%ecx
  800a61:	84 c9                	test   %cl,%cl
  800a63:	75 ec                	jne    800a51 <strlcpy+0x1a>
		*dst = '\0';
  800a65:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a68:	29 f0                	sub    %esi,%eax
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a77:	eb 06                	jmp    800a7f <strcmp+0x11>
		p++, q++;
  800a79:	83 c1 01             	add    $0x1,%ecx
  800a7c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a7f:	0f b6 01             	movzbl (%ecx),%eax
  800a82:	84 c0                	test   %al,%al
  800a84:	74 04                	je     800a8a <strcmp+0x1c>
  800a86:	3a 02                	cmp    (%edx),%al
  800a88:	74 ef                	je     800a79 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8a:	0f b6 c0             	movzbl %al,%eax
  800a8d:	0f b6 12             	movzbl (%edx),%edx
  800a90:	29 d0                	sub    %edx,%eax
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	89 c3                	mov    %eax,%ebx
  800aa0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa3:	eb 06                	jmp    800aab <strncmp+0x17>
		n--, p++, q++;
  800aa5:	83 c0 01             	add    $0x1,%eax
  800aa8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aab:	39 d8                	cmp    %ebx,%eax
  800aad:	74 16                	je     800ac5 <strncmp+0x31>
  800aaf:	0f b6 08             	movzbl (%eax),%ecx
  800ab2:	84 c9                	test   %cl,%cl
  800ab4:	74 04                	je     800aba <strncmp+0x26>
  800ab6:	3a 0a                	cmp    (%edx),%cl
  800ab8:	74 eb                	je     800aa5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aba:	0f b6 00             	movzbl (%eax),%eax
  800abd:	0f b6 12             	movzbl (%edx),%edx
  800ac0:	29 d0                	sub    %edx,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    
		return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	eb f6                	jmp    800ac2 <strncmp+0x2e>

00800acc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad6:	0f b6 10             	movzbl (%eax),%edx
  800ad9:	84 d2                	test   %dl,%dl
  800adb:	74 09                	je     800ae6 <strchr+0x1a>
		if (*s == c)
  800add:	38 ca                	cmp    %cl,%dl
  800adf:	74 0a                	je     800aeb <strchr+0x1f>
	for (; *s; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f0                	jmp    800ad6 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af7:	eb 03                	jmp    800afc <strfind+0xf>
  800af9:	83 c0 01             	add    $0x1,%eax
  800afc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aff:	38 ca                	cmp    %cl,%dl
  800b01:	74 04                	je     800b07 <strfind+0x1a>
  800b03:	84 d2                	test   %dl,%dl
  800b05:	75 f2                	jne    800af9 <strfind+0xc>
			break;
	return (char *) s;
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b12:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b15:	85 c9                	test   %ecx,%ecx
  800b17:	74 13                	je     800b2c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b19:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b1f:	75 05                	jne    800b26 <memset+0x1d>
  800b21:	f6 c1 03             	test   $0x3,%cl
  800b24:	74 0d                	je     800b33 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b29:	fc                   	cld    
  800b2a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2c:	89 f8                	mov    %edi,%eax
  800b2e:	5b                   	pop    %ebx
  800b2f:	5e                   	pop    %esi
  800b30:	5f                   	pop    %edi
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    
		c &= 0xFF;
  800b33:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b37:	89 d3                	mov    %edx,%ebx
  800b39:	c1 e3 08             	shl    $0x8,%ebx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	c1 e0 18             	shl    $0x18,%eax
  800b41:	89 d6                	mov    %edx,%esi
  800b43:	c1 e6 10             	shl    $0x10,%esi
  800b46:	09 f0                	or     %esi,%eax
  800b48:	09 c2                	or     %eax,%edx
  800b4a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b4c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b4f:	89 d0                	mov    %edx,%eax
  800b51:	fc                   	cld    
  800b52:	f3 ab                	rep stos %eax,%es:(%edi)
  800b54:	eb d6                	jmp    800b2c <memset+0x23>

00800b56 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b61:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b64:	39 c6                	cmp    %eax,%esi
  800b66:	73 35                	jae    800b9d <memmove+0x47>
  800b68:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b6b:	39 c2                	cmp    %eax,%edx
  800b6d:	76 2e                	jbe    800b9d <memmove+0x47>
		s += n;
		d += n;
  800b6f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b72:	89 d6                	mov    %edx,%esi
  800b74:	09 fe                	or     %edi,%esi
  800b76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7c:	74 0c                	je     800b8a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7e:	83 ef 01             	sub    $0x1,%edi
  800b81:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b84:	fd                   	std    
  800b85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b87:	fc                   	cld    
  800b88:	eb 21                	jmp    800bab <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8a:	f6 c1 03             	test   $0x3,%cl
  800b8d:	75 ef                	jne    800b7e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b8f:	83 ef 04             	sub    $0x4,%edi
  800b92:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b95:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b98:	fd                   	std    
  800b99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9b:	eb ea                	jmp    800b87 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9d:	89 f2                	mov    %esi,%edx
  800b9f:	09 c2                	or     %eax,%edx
  800ba1:	f6 c2 03             	test   $0x3,%dl
  800ba4:	74 09                	je     800baf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba6:	89 c7                	mov    %eax,%edi
  800ba8:	fc                   	cld    
  800ba9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baf:	f6 c1 03             	test   $0x3,%cl
  800bb2:	75 f2                	jne    800ba6 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bb4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bb7:	89 c7                	mov    %eax,%edi
  800bb9:	fc                   	cld    
  800bba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bbc:	eb ed                	jmp    800bab <memmove+0x55>

00800bbe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800bc1:	ff 75 10             	pushl  0x10(%ebp)
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	ff 75 08             	pushl  0x8(%ebp)
  800bca:	e8 87 ff ff ff       	call   800b56 <memmove>
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdc:	89 c6                	mov    %eax,%esi
  800bde:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be1:	39 f0                	cmp    %esi,%eax
  800be3:	74 1c                	je     800c01 <memcmp+0x30>
		if (*s1 != *s2)
  800be5:	0f b6 08             	movzbl (%eax),%ecx
  800be8:	0f b6 1a             	movzbl (%edx),%ebx
  800beb:	38 d9                	cmp    %bl,%cl
  800bed:	75 08                	jne    800bf7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bef:	83 c0 01             	add    $0x1,%eax
  800bf2:	83 c2 01             	add    $0x1,%edx
  800bf5:	eb ea                	jmp    800be1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bf7:	0f b6 c1             	movzbl %cl,%eax
  800bfa:	0f b6 db             	movzbl %bl,%ebx
  800bfd:	29 d8                	sub    %ebx,%eax
  800bff:	eb 05                	jmp    800c06 <memcmp+0x35>
	}

	return 0;
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c13:	89 c2                	mov    %eax,%edx
  800c15:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c18:	39 d0                	cmp    %edx,%eax
  800c1a:	73 09                	jae    800c25 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1c:	38 08                	cmp    %cl,(%eax)
  800c1e:	74 05                	je     800c25 <memfind+0x1b>
	for (; s < ends; s++)
  800c20:	83 c0 01             	add    $0x1,%eax
  800c23:	eb f3                	jmp    800c18 <memfind+0xe>
			break;
	return (void *) s;
}
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c33:	eb 03                	jmp    800c38 <strtol+0x11>
		s++;
  800c35:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c38:	0f b6 01             	movzbl (%ecx),%eax
  800c3b:	3c 20                	cmp    $0x20,%al
  800c3d:	74 f6                	je     800c35 <strtol+0xe>
  800c3f:	3c 09                	cmp    $0x9,%al
  800c41:	74 f2                	je     800c35 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c43:	3c 2b                	cmp    $0x2b,%al
  800c45:	74 2e                	je     800c75 <strtol+0x4e>
	int neg = 0;
  800c47:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c4c:	3c 2d                	cmp    $0x2d,%al
  800c4e:	74 2f                	je     800c7f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c50:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c56:	75 05                	jne    800c5d <strtol+0x36>
  800c58:	80 39 30             	cmpb   $0x30,(%ecx)
  800c5b:	74 2c                	je     800c89 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c5d:	85 db                	test   %ebx,%ebx
  800c5f:	75 0a                	jne    800c6b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c61:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c66:	80 39 30             	cmpb   $0x30,(%ecx)
  800c69:	74 28                	je     800c93 <strtol+0x6c>
		base = 10;
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c70:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c73:	eb 50                	jmp    800cc5 <strtol+0x9e>
		s++;
  800c75:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c78:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7d:	eb d1                	jmp    800c50 <strtol+0x29>
		s++, neg = 1;
  800c7f:	83 c1 01             	add    $0x1,%ecx
  800c82:	bf 01 00 00 00       	mov    $0x1,%edi
  800c87:	eb c7                	jmp    800c50 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c89:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c8d:	74 0e                	je     800c9d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c8f:	85 db                	test   %ebx,%ebx
  800c91:	75 d8                	jne    800c6b <strtol+0x44>
		s++, base = 8;
  800c93:	83 c1 01             	add    $0x1,%ecx
  800c96:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c9b:	eb ce                	jmp    800c6b <strtol+0x44>
		s += 2, base = 16;
  800c9d:	83 c1 02             	add    $0x2,%ecx
  800ca0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca5:	eb c4                	jmp    800c6b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ca7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800caa:	89 f3                	mov    %esi,%ebx
  800cac:	80 fb 19             	cmp    $0x19,%bl
  800caf:	77 29                	ja     800cda <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cb1:	0f be d2             	movsbl %dl,%edx
  800cb4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cb7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cba:	7d 30                	jge    800cec <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cbc:	83 c1 01             	add    $0x1,%ecx
  800cbf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cc3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cc5:	0f b6 11             	movzbl (%ecx),%edx
  800cc8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ccb:	89 f3                	mov    %esi,%ebx
  800ccd:	80 fb 09             	cmp    $0x9,%bl
  800cd0:	77 d5                	ja     800ca7 <strtol+0x80>
			dig = *s - '0';
  800cd2:	0f be d2             	movsbl %dl,%edx
  800cd5:	83 ea 30             	sub    $0x30,%edx
  800cd8:	eb dd                	jmp    800cb7 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800cda:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cdd:	89 f3                	mov    %esi,%ebx
  800cdf:	80 fb 19             	cmp    $0x19,%bl
  800ce2:	77 08                	ja     800cec <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ce4:	0f be d2             	movsbl %dl,%edx
  800ce7:	83 ea 37             	sub    $0x37,%edx
  800cea:	eb cb                	jmp    800cb7 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf0:	74 05                	je     800cf7 <strtol+0xd0>
		*endptr = (char *) s;
  800cf2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cf5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	f7 da                	neg    %edx
  800cfb:	85 ff                	test   %edi,%edi
  800cfd:	0f 45 c2             	cmovne %edx,%eax
}
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	89 c3                	mov    %eax,%ebx
  800d18:	89 c7                	mov    %eax,%edi
  800d1a:	89 c6                	mov    %eax,%esi
  800d1c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d33:	89 d1                	mov    %edx,%ecx
  800d35:	89 d3                	mov    %edx,%ebx
  800d37:	89 d7                	mov    %edx,%edi
  800d39:	89 d6                	mov    %edx,%esi
  800d3b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	57                   	push   %edi
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
  800d48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	b8 03 00 00 00       	mov    $0x3,%eax
  800d58:	89 cb                	mov    %ecx,%ebx
  800d5a:	89 cf                	mov    %ecx,%edi
  800d5c:	89 ce                	mov    %ecx,%esi
  800d5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d60:	85 c0                	test   %eax,%eax
  800d62:	7f 08                	jg     800d6c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	50                   	push   %eax
  800d70:	6a 03                	push   $0x3
  800d72:	68 9f 2c 80 00       	push   $0x802c9f
  800d77:	6a 23                	push   $0x23
  800d79:	68 bc 2c 80 00       	push   $0x802cbc
  800d7e:	e8 cd f4 ff ff       	call   800250 <_panic>

00800d83 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d89:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d93:	89 d1                	mov    %edx,%ecx
  800d95:	89 d3                	mov    %edx,%ebx
  800d97:	89 d7                	mov    %edx,%edi
  800d99:	89 d6                	mov    %edx,%esi
  800d9b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <sys_yield>:

void
sys_yield(void)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dad:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db2:	89 d1                	mov    %edx,%ecx
  800db4:	89 d3                	mov    %edx,%ebx
  800db6:	89 d7                	mov    %edx,%edi
  800db8:	89 d6                	mov    %edx,%esi
  800dba:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	be 00 00 00 00       	mov    $0x0,%esi
  800dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd5:	b8 04 00 00 00       	mov    $0x4,%eax
  800dda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddd:	89 f7                	mov    %esi,%edi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 04                	push   $0x4
  800df3:	68 9f 2c 80 00       	push   $0x802c9f
  800df8:	6a 23                	push   $0x23
  800dfa:	68 bc 2c 80 00       	push   $0x802cbc
  800dff:	e8 4c f4 ff ff       	call   800250 <_panic>

00800e04 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	b8 05 00 00 00       	mov    $0x5,%eax
  800e18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1e:	8b 75 18             	mov    0x18(%ebp),%esi
  800e21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7f 08                	jg     800e2f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	50                   	push   %eax
  800e33:	6a 05                	push   $0x5
  800e35:	68 9f 2c 80 00       	push   $0x802c9f
  800e3a:	6a 23                	push   $0x23
  800e3c:	68 bc 2c 80 00       	push   $0x802cbc
  800e41:	e8 0a f4 ff ff       	call   800250 <_panic>

00800e46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 06 00 00 00       	mov    $0x6,%eax
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 06                	push   $0x6
  800e77:	68 9f 2c 80 00       	push   $0x802c9f
  800e7c:	6a 23                	push   $0x23
  800e7e:	68 bc 2c 80 00       	push   $0x802cbc
  800e83:	e8 c8 f3 ff ff       	call   800250 <_panic>

00800e88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 08                	push   $0x8
  800eb9:	68 9f 2c 80 00       	push   $0x802c9f
  800ebe:	6a 23                	push   $0x23
  800ec0:	68 bc 2c 80 00       	push   $0x802cbc
  800ec5:	e8 86 f3 ff ff       	call   800250 <_panic>

00800eca <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
  800ed0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ede:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	89 de                	mov    %ebx,%esi
  800ee7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	7f 08                	jg     800ef5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef5:	83 ec 0c             	sub    $0xc,%esp
  800ef8:	50                   	push   %eax
  800ef9:	6a 09                	push   $0x9
  800efb:	68 9f 2c 80 00       	push   $0x802c9f
  800f00:	6a 23                	push   $0x23
  800f02:	68 bc 2c 80 00       	push   $0x802cbc
  800f07:	e8 44 f3 ff ff       	call   800250 <_panic>

00800f0c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
  800f12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f25:	89 df                	mov    %ebx,%edi
  800f27:	89 de                	mov    %ebx,%esi
  800f29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	7f 08                	jg     800f37 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	50                   	push   %eax
  800f3b:	6a 0a                	push   $0xa
  800f3d:	68 9f 2c 80 00       	push   $0x802c9f
  800f42:	6a 23                	push   $0x23
  800f44:	68 bc 2c 80 00       	push   $0x802cbc
  800f49:	e8 02 f3 ff ff       	call   800250 <_panic>

00800f4e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f5f:	be 00 00 00 00       	mov    $0x0,%esi
  800f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f67:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f6a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	57                   	push   %edi
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
  800f77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f87:	89 cb                	mov    %ecx,%ebx
  800f89:	89 cf                	mov    %ecx,%edi
  800f8b:	89 ce                	mov    %ecx,%esi
  800f8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	7f 08                	jg     800f9b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	6a 0d                	push   $0xd
  800fa1:	68 9f 2c 80 00       	push   $0x802c9f
  800fa6:	6a 23                	push   $0x23
  800fa8:	68 bc 2c 80 00       	push   $0x802cbc
  800fad:	e8 9e f2 ff ff       	call   800250 <_panic>

00800fb2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbd:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fc2:	89 d1                	mov    %edx,%ecx
  800fc4:	89 d3                	mov    %edx,%ebx
  800fc6:	89 d7                	mov    %edx,%edi
  800fc8:	89 d6                	mov    %edx,%esi
  800fca:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	57                   	push   %edi
  800fd5:	56                   	push   %esi
  800fd6:	53                   	push   %ebx
  800fd7:	83 ec 1c             	sub    $0x1c,%esp
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800fdd:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800fdf:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800fe2:	89 d8                	mov    %ebx,%eax
  800fe4:	c1 e8 0c             	shr    $0xc,%eax
  800fe7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800ff1:	e8 8d fd ff ff       	call   800d83 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800ff6:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800ffc:	74 73                	je     801071 <pgfault+0xa0>
  800ffe:	89 c6                	mov    %eax,%esi
  801000:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  801007:	74 68                	je     801071 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	6a 07                	push   $0x7
  80100e:	68 00 f0 7f 00       	push   $0x7ff000
  801013:	50                   	push   %eax
  801014:	e8 a8 fd ff ff       	call   800dc1 <sys_page_alloc>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	75 65                	jne    801085 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801020:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801026:	83 ec 04             	sub    $0x4,%esp
  801029:	68 00 10 00 00       	push   $0x1000
  80102e:	53                   	push   %ebx
  80102f:	68 00 f0 7f 00       	push   $0x7ff000
  801034:	e8 85 fb ff ff       	call   800bbe <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801039:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801040:	53                   	push   %ebx
  801041:	56                   	push   %esi
  801042:	68 00 f0 7f 00       	push   $0x7ff000
  801047:	56                   	push   %esi
  801048:	e8 b7 fd ff ff       	call   800e04 <sys_page_map>
  80104d:	83 c4 20             	add    $0x20,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	75 43                	jne    801097 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	68 00 f0 7f 00       	push   $0x7ff000
  80105c:	56                   	push   %esi
  80105d:	e8 e4 fd ff ff       	call   800e46 <sys_page_unmap>
  801062:	83 c4 10             	add    $0x10,%esp
  801065:	85 c0                	test   %eax,%eax
  801067:	75 40                	jne    8010a9 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  801071:	83 ec 04             	sub    $0x4,%esp
  801074:	68 ca 2c 80 00       	push   $0x802cca
  801079:	6a 1f                	push   $0x1f
  80107b:	68 e8 2c 80 00       	push   $0x802ce8
  801080:	e8 cb f1 ff ff       	call   800250 <_panic>
	    panic("pgfault: %e", r);
  801085:	50                   	push   %eax
  801086:	68 f3 2c 80 00       	push   $0x802cf3
  80108b:	6a 2a                	push   $0x2a
  80108d:	68 e8 2c 80 00       	push   $0x802ce8
  801092:	e8 b9 f1 ff ff       	call   800250 <_panic>
	    panic("pgfault: %e", r);
  801097:	50                   	push   %eax
  801098:	68 f3 2c 80 00       	push   $0x802cf3
  80109d:	6a 2e                	push   $0x2e
  80109f:	68 e8 2c 80 00       	push   $0x802ce8
  8010a4:	e8 a7 f1 ff ff       	call   800250 <_panic>
	    panic("pgfault: %e", r);
  8010a9:	50                   	push   %eax
  8010aa:	68 f3 2c 80 00       	push   $0x802cf3
  8010af:	6a 31                	push   $0x31
  8010b1:	68 e8 2c 80 00       	push   $0x802ce8
  8010b6:	e8 95 f1 ff ff       	call   800250 <_panic>

008010bb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	57                   	push   %edi
  8010bf:	56                   	push   %esi
  8010c0:	53                   	push   %ebx
  8010c1:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  8010c4:	68 d1 0f 80 00       	push   $0x800fd1
  8010c9:	e8 c4 14 00 00       	call   802592 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010ce:	b8 07 00 00 00       	mov    $0x7,%eax
  8010d3:	cd 30                	int    $0x30
  8010d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	78 2b                	js     80110d <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010e2:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  8010e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010eb:	0f 85 b5 00 00 00    	jne    8011a6 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  8010f1:	e8 8d fc ff ff       	call   800d83 <sys_getenvid>
  8010f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010fb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801103:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  801108:	e9 8c 01 00 00       	jmp    801299 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  80110d:	50                   	push   %eax
  80110e:	68 ff 2c 80 00       	push   $0x802cff
  801113:	6a 77                	push   $0x77
  801115:	68 e8 2c 80 00       	push   $0x802ce8
  80111a:	e8 31 f1 ff ff       	call   800250 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  80111f:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801126:	83 ec 0c             	sub    $0xc,%esp
  801129:	25 07 0e 00 00       	and    $0xe07,%eax
  80112e:	50                   	push   %eax
  80112f:	57                   	push   %edi
  801130:	ff 75 e0             	pushl  -0x20(%ebp)
  801133:	57                   	push   %edi
  801134:	ff 75 e4             	pushl  -0x1c(%ebp)
  801137:	e8 c8 fc ff ff       	call   800e04 <sys_page_map>
  80113c:	83 c4 20             	add    $0x20,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	74 51                	je     801194 <fork+0xd9>
           panic("duppage: %e", r);
  801143:	50                   	push   %eax
  801144:	68 0f 2d 80 00       	push   $0x802d0f
  801149:	6a 4a                	push   $0x4a
  80114b:	68 e8 2c 80 00       	push   $0x802ce8
  801150:	e8 fb f0 ff ff       	call   800250 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	68 05 08 00 00       	push   $0x805
  80115d:	57                   	push   %edi
  80115e:	ff 75 e0             	pushl  -0x20(%ebp)
  801161:	57                   	push   %edi
  801162:	ff 75 e4             	pushl  -0x1c(%ebp)
  801165:	e8 9a fc ff ff       	call   800e04 <sys_page_map>
  80116a:	83 c4 20             	add    $0x20,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	0f 85 bc 00 00 00    	jne    801231 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	68 05 08 00 00       	push   $0x805
  80117d:	57                   	push   %edi
  80117e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801181:	50                   	push   %eax
  801182:	57                   	push   %edi
  801183:	50                   	push   %eax
  801184:	e8 7b fc ff ff       	call   800e04 <sys_page_map>
  801189:	83 c4 20             	add    $0x20,%esp
  80118c:	85 c0                	test   %eax,%eax
  80118e:	0f 85 af 00 00 00    	jne    801243 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801194:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80119a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011a0:	0f 84 af 00 00 00    	je     801255 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  8011a6:	89 d8                	mov    %ebx,%eax
  8011a8:	c1 e8 16             	shr    $0x16,%eax
  8011ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b2:	a8 01                	test   $0x1,%al
  8011b4:	74 de                	je     801194 <fork+0xd9>
  8011b6:	89 de                	mov    %ebx,%esi
  8011b8:	c1 ee 0c             	shr    $0xc,%esi
  8011bb:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011c2:	a8 01                	test   $0x1,%al
  8011c4:	74 ce                	je     801194 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8011c6:	e8 b8 fb ff ff       	call   800d83 <sys_getenvid>
  8011cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8011ce:	89 f7                	mov    %esi,%edi
  8011d0:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8011d3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011da:	f6 c4 04             	test   $0x4,%ah
  8011dd:	0f 85 3c ff ff ff    	jne    80111f <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8011e3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011ea:	a8 02                	test   $0x2,%al
  8011ec:	0f 85 63 ff ff ff    	jne    801155 <fork+0x9a>
  8011f2:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011f9:	f6 c4 08             	test   $0x8,%ah
  8011fc:	0f 85 53 ff ff ff    	jne    801155 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	6a 05                	push   $0x5
  801207:	57                   	push   %edi
  801208:	ff 75 e0             	pushl  -0x20(%ebp)
  80120b:	57                   	push   %edi
  80120c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120f:	e8 f0 fb ff ff       	call   800e04 <sys_page_map>
  801214:	83 c4 20             	add    $0x20,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	0f 84 75 ff ff ff    	je     801194 <fork+0xd9>
	        panic("duppage: %e", r);
  80121f:	50                   	push   %eax
  801220:	68 0f 2d 80 00       	push   $0x802d0f
  801225:	6a 55                	push   $0x55
  801227:	68 e8 2c 80 00       	push   $0x802ce8
  80122c:	e8 1f f0 ff ff       	call   800250 <_panic>
	        panic("duppage: %e", r);
  801231:	50                   	push   %eax
  801232:	68 0f 2d 80 00       	push   $0x802d0f
  801237:	6a 4e                	push   $0x4e
  801239:	68 e8 2c 80 00       	push   $0x802ce8
  80123e:	e8 0d f0 ff ff       	call   800250 <_panic>
	        panic("duppage: %e", r);
  801243:	50                   	push   %eax
  801244:	68 0f 2d 80 00       	push   $0x802d0f
  801249:	6a 51                	push   $0x51
  80124b:	68 e8 2c 80 00       	push   $0x802ce8
  801250:	e8 fb ef ff ff       	call   800250 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	6a 07                	push   $0x7
  80125a:	68 00 f0 bf ee       	push   $0xeebff000
  80125f:	ff 75 dc             	pushl  -0x24(%ebp)
  801262:	e8 5a fb ff ff       	call   800dc1 <sys_page_alloc>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 36                	jne    8012a4 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	68 0b 26 80 00       	push   $0x80260b
  801276:	ff 75 dc             	pushl  -0x24(%ebp)
  801279:	e8 8e fc ff ff       	call   800f0c <sys_env_set_pgfault_upcall>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	75 34                	jne    8012b9 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	6a 02                	push   $0x2
  80128a:	ff 75 dc             	pushl  -0x24(%ebp)
  80128d:	e8 f6 fb ff ff       	call   800e88 <sys_env_set_status>
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	75 35                	jne    8012ce <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801299:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80129c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    
	    panic("fork: %e", r);
  8012a4:	50                   	push   %eax
  8012a5:	68 06 2d 80 00       	push   $0x802d06
  8012aa:	68 8a 00 00 00       	push   $0x8a
  8012af:	68 e8 2c 80 00       	push   $0x802ce8
  8012b4:	e8 97 ef ff ff       	call   800250 <_panic>
	    panic("fork: %e", r);
  8012b9:	50                   	push   %eax
  8012ba:	68 06 2d 80 00       	push   $0x802d06
  8012bf:	68 8d 00 00 00       	push   $0x8d
  8012c4:	68 e8 2c 80 00       	push   $0x802ce8
  8012c9:	e8 82 ef ff ff       	call   800250 <_panic>
	    panic("fork: %e", r);
  8012ce:	50                   	push   %eax
  8012cf:	68 06 2d 80 00       	push   $0x802d06
  8012d4:	68 92 00 00 00       	push   $0x92
  8012d9:	68 e8 2c 80 00       	push   $0x802ce8
  8012de:	e8 6d ef ff ff       	call   800250 <_panic>

008012e3 <sfork>:

// Challenge!
int
sfork(void)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012e9:	68 1b 2d 80 00       	push   $0x802d1b
  8012ee:	68 9b 00 00 00       	push   $0x9b
  8012f3:	68 e8 2c 80 00       	push   $0x802ce8
  8012f8:	e8 53 ef ff ff       	call   800250 <_panic>

008012fd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	8b 75 08             	mov    0x8(%ebp),%esi
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80130b:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  80130d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801312:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	50                   	push   %eax
  801319:	e8 53 fc ff ff       	call   800f71 <sys_ipc_recv>
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	78 2b                	js     801350 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801325:	85 f6                	test   %esi,%esi
  801327:	74 0a                	je     801333 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801329:	a1 08 40 80 00       	mov    0x804008,%eax
  80132e:	8b 40 74             	mov    0x74(%eax),%eax
  801331:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801333:	85 db                	test   %ebx,%ebx
  801335:	74 0a                	je     801341 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801337:	a1 08 40 80 00       	mov    0x804008,%eax
  80133c:	8b 40 78             	mov    0x78(%eax),%eax
  80133f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801341:	a1 08 40 80 00       	mov    0x804008,%eax
  801346:	8b 40 70             	mov    0x70(%eax),%eax
}
  801349:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80134c:	5b                   	pop    %ebx
  80134d:	5e                   	pop    %esi
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    
	    if (from_env_store != NULL) {
  801350:	85 f6                	test   %esi,%esi
  801352:	74 06                	je     80135a <ipc_recv+0x5d>
	        *from_env_store = 0;
  801354:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	74 eb                	je     801349 <ipc_recv+0x4c>
	        *perm_store = 0;
  80135e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801364:	eb e3                	jmp    801349 <ipc_recv+0x4c>

00801366 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	57                   	push   %edi
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801372:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  801375:	85 f6                	test   %esi,%esi
  801377:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80137c:	0f 44 f0             	cmove  %eax,%esi
  80137f:	eb 09                	jmp    80138a <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  801381:	e8 1c fa ff ff       	call   800da2 <sys_yield>
	} while(r != 0);
  801386:	85 db                	test   %ebx,%ebx
  801388:	74 2d                	je     8013b7 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80138a:	ff 75 14             	pushl  0x14(%ebp)
  80138d:	56                   	push   %esi
  80138e:	ff 75 0c             	pushl  0xc(%ebp)
  801391:	57                   	push   %edi
  801392:	e8 b7 fb ff ff       	call   800f4e <sys_ipc_try_send>
  801397:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	79 e1                	jns    801381 <ipc_send+0x1b>
  8013a0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013a3:	74 dc                	je     801381 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8013a5:	50                   	push   %eax
  8013a6:	68 31 2d 80 00       	push   $0x802d31
  8013ab:	6a 45                	push   $0x45
  8013ad:	68 3e 2d 80 00       	push   $0x802d3e
  8013b2:	e8 99 ee ff ff       	call   800250 <_panic>
}
  8013b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ba:	5b                   	pop    %ebx
  8013bb:	5e                   	pop    %esi
  8013bc:	5f                   	pop    %edi
  8013bd:	5d                   	pop    %ebp
  8013be:	c3                   	ret    

008013bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013ca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013cd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013d3:	8b 52 50             	mov    0x50(%edx),%edx
  8013d6:	39 ca                	cmp    %ecx,%edx
  8013d8:	74 11                	je     8013eb <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8013da:	83 c0 01             	add    $0x1,%eax
  8013dd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013e2:	75 e6                	jne    8013ca <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e9:	eb 0b                	jmp    8013f6 <ipc_find_env+0x37>
			return envs[i].env_id;
  8013eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013f3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013f6:	5d                   	pop    %ebp
  8013f7:	c3                   	ret    

008013f8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	05 00 00 00 30       	add    $0x30000000,%eax
  801403:	c1 e8 0c             	shr    $0xc,%eax
}
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801413:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801418:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801425:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142a:	89 c2                	mov    %eax,%edx
  80142c:	c1 ea 16             	shr    $0x16,%edx
  80142f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801436:	f6 c2 01             	test   $0x1,%dl
  801439:	74 2a                	je     801465 <fd_alloc+0x46>
  80143b:	89 c2                	mov    %eax,%edx
  80143d:	c1 ea 0c             	shr    $0xc,%edx
  801440:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801447:	f6 c2 01             	test   $0x1,%dl
  80144a:	74 19                	je     801465 <fd_alloc+0x46>
  80144c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801451:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801456:	75 d2                	jne    80142a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801458:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80145e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801463:	eb 07                	jmp    80146c <fd_alloc+0x4d>
			*fd_store = fd;
  801465:	89 01                	mov    %eax,(%ecx)
			return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801474:	83 f8 1f             	cmp    $0x1f,%eax
  801477:	77 36                	ja     8014af <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801479:	c1 e0 0c             	shl    $0xc,%eax
  80147c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801481:	89 c2                	mov    %eax,%edx
  801483:	c1 ea 16             	shr    $0x16,%edx
  801486:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80148d:	f6 c2 01             	test   $0x1,%dl
  801490:	74 24                	je     8014b6 <fd_lookup+0x48>
  801492:	89 c2                	mov    %eax,%edx
  801494:	c1 ea 0c             	shr    $0xc,%edx
  801497:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80149e:	f6 c2 01             	test   $0x1,%dl
  8014a1:	74 1a                	je     8014bd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	89 02                	mov    %eax,(%edx)
	return 0;
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ad:	5d                   	pop    %ebp
  8014ae:	c3                   	ret    
		return -E_INVAL;
  8014af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b4:	eb f7                	jmp    8014ad <fd_lookup+0x3f>
		return -E_INVAL;
  8014b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bb:	eb f0                	jmp    8014ad <fd_lookup+0x3f>
  8014bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c2:	eb e9                	jmp    8014ad <fd_lookup+0x3f>

008014c4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cd:	ba c4 2d 80 00       	mov    $0x802dc4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014d2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014d7:	39 08                	cmp    %ecx,(%eax)
  8014d9:	74 33                	je     80150e <dev_lookup+0x4a>
  8014db:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014de:	8b 02                	mov    (%edx),%eax
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	75 f3                	jne    8014d7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8014e9:	8b 40 48             	mov    0x48(%eax),%eax
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	51                   	push   %ecx
  8014f0:	50                   	push   %eax
  8014f1:	68 48 2d 80 00       	push   $0x802d48
  8014f6:	e8 30 ee ff ff       	call   80032b <cprintf>
	*dev = 0;
  8014fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    
			*dev = devtab[i];
  80150e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801511:	89 01                	mov    %eax,(%ecx)
			return 0;
  801513:	b8 00 00 00 00       	mov    $0x0,%eax
  801518:	eb f2                	jmp    80150c <dev_lookup+0x48>

0080151a <fd_close>:
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	83 ec 1c             	sub    $0x1c,%esp
  801523:	8b 75 08             	mov    0x8(%ebp),%esi
  801526:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801529:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80152c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80152d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801533:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801536:	50                   	push   %eax
  801537:	e8 32 ff ff ff       	call   80146e <fd_lookup>
  80153c:	89 c3                	mov    %eax,%ebx
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 05                	js     80154a <fd_close+0x30>
	    || fd != fd2)
  801545:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801548:	74 16                	je     801560 <fd_close+0x46>
		return (must_exist ? r : 0);
  80154a:	89 f8                	mov    %edi,%eax
  80154c:	84 c0                	test   %al,%al
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	0f 44 d8             	cmove  %eax,%ebx
}
  801556:	89 d8                	mov    %ebx,%eax
  801558:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155b:	5b                   	pop    %ebx
  80155c:	5e                   	pop    %esi
  80155d:	5f                   	pop    %edi
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801566:	50                   	push   %eax
  801567:	ff 36                	pushl  (%esi)
  801569:	e8 56 ff ff ff       	call   8014c4 <dev_lookup>
  80156e:	89 c3                	mov    %eax,%ebx
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	85 c0                	test   %eax,%eax
  801575:	78 15                	js     80158c <fd_close+0x72>
		if (dev->dev_close)
  801577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157a:	8b 40 10             	mov    0x10(%eax),%eax
  80157d:	85 c0                	test   %eax,%eax
  80157f:	74 1b                	je     80159c <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801581:	83 ec 0c             	sub    $0xc,%esp
  801584:	56                   	push   %esi
  801585:	ff d0                	call   *%eax
  801587:	89 c3                	mov    %eax,%ebx
  801589:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	56                   	push   %esi
  801590:	6a 00                	push   $0x0
  801592:	e8 af f8 ff ff       	call   800e46 <sys_page_unmap>
	return r;
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	eb ba                	jmp    801556 <fd_close+0x3c>
			r = 0;
  80159c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a1:	eb e9                	jmp    80158c <fd_close+0x72>

008015a3 <close>:

int
close(int fdnum)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	ff 75 08             	pushl  0x8(%ebp)
  8015b0:	e8 b9 fe ff ff       	call   80146e <fd_lookup>
  8015b5:	83 c4 08             	add    $0x8,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 10                	js     8015cc <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	6a 01                	push   $0x1
  8015c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c4:	e8 51 ff ff ff       	call   80151a <fd_close>
  8015c9:	83 c4 10             	add    $0x10,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <close_all>:

void
close_all(void)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015da:	83 ec 0c             	sub    $0xc,%esp
  8015dd:	53                   	push   %ebx
  8015de:	e8 c0 ff ff ff       	call   8015a3 <close>
	for (i = 0; i < MAXFD; i++)
  8015e3:	83 c3 01             	add    $0x1,%ebx
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	83 fb 20             	cmp    $0x20,%ebx
  8015ec:	75 ec                	jne    8015da <close_all+0xc>
}
  8015ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	57                   	push   %edi
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	ff 75 08             	pushl  0x8(%ebp)
  801603:	e8 66 fe ff ff       	call   80146e <fd_lookup>
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	83 c4 08             	add    $0x8,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	0f 88 81 00 00 00    	js     801696 <dup+0xa3>
		return r;
	close(newfdnum);
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	e8 83 ff ff ff       	call   8015a3 <close>

	newfd = INDEX2FD(newfdnum);
  801620:	8b 75 0c             	mov    0xc(%ebp),%esi
  801623:	c1 e6 0c             	shl    $0xc,%esi
  801626:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80162c:	83 c4 04             	add    $0x4,%esp
  80162f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801632:	e8 d1 fd ff ff       	call   801408 <fd2data>
  801637:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801639:	89 34 24             	mov    %esi,(%esp)
  80163c:	e8 c7 fd ff ff       	call   801408 <fd2data>
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801646:	89 d8                	mov    %ebx,%eax
  801648:	c1 e8 16             	shr    $0x16,%eax
  80164b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801652:	a8 01                	test   $0x1,%al
  801654:	74 11                	je     801667 <dup+0x74>
  801656:	89 d8                	mov    %ebx,%eax
  801658:	c1 e8 0c             	shr    $0xc,%eax
  80165b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801662:	f6 c2 01             	test   $0x1,%dl
  801665:	75 39                	jne    8016a0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801667:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80166a:	89 d0                	mov    %edx,%eax
  80166c:	c1 e8 0c             	shr    $0xc,%eax
  80166f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801676:	83 ec 0c             	sub    $0xc,%esp
  801679:	25 07 0e 00 00       	and    $0xe07,%eax
  80167e:	50                   	push   %eax
  80167f:	56                   	push   %esi
  801680:	6a 00                	push   $0x0
  801682:	52                   	push   %edx
  801683:	6a 00                	push   $0x0
  801685:	e8 7a f7 ff ff       	call   800e04 <sys_page_map>
  80168a:	89 c3                	mov    %eax,%ebx
  80168c:	83 c4 20             	add    $0x20,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 31                	js     8016c4 <dup+0xd1>
		goto err;

	return newfdnum;
  801693:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801696:	89 d8                	mov    %ebx,%eax
  801698:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5f                   	pop    %edi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016a7:	83 ec 0c             	sub    $0xc,%esp
  8016aa:	25 07 0e 00 00       	and    $0xe07,%eax
  8016af:	50                   	push   %eax
  8016b0:	57                   	push   %edi
  8016b1:	6a 00                	push   $0x0
  8016b3:	53                   	push   %ebx
  8016b4:	6a 00                	push   $0x0
  8016b6:	e8 49 f7 ff ff       	call   800e04 <sys_page_map>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	83 c4 20             	add    $0x20,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	79 a3                	jns    801667 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	56                   	push   %esi
  8016c8:	6a 00                	push   $0x0
  8016ca:	e8 77 f7 ff ff       	call   800e46 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016cf:	83 c4 08             	add    $0x8,%esp
  8016d2:	57                   	push   %edi
  8016d3:	6a 00                	push   $0x0
  8016d5:	e8 6c f7 ff ff       	call   800e46 <sys_page_unmap>
	return r;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	eb b7                	jmp    801696 <dup+0xa3>

008016df <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 14             	sub    $0x14,%esp
  8016e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ec:	50                   	push   %eax
  8016ed:	53                   	push   %ebx
  8016ee:	e8 7b fd ff ff       	call   80146e <fd_lookup>
  8016f3:	83 c4 08             	add    $0x8,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 3f                	js     801739 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801700:	50                   	push   %eax
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	ff 30                	pushl  (%eax)
  801706:	e8 b9 fd ff ff       	call   8014c4 <dev_lookup>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 27                	js     801739 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801712:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801715:	8b 42 08             	mov    0x8(%edx),%eax
  801718:	83 e0 03             	and    $0x3,%eax
  80171b:	83 f8 01             	cmp    $0x1,%eax
  80171e:	74 1e                	je     80173e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	8b 40 08             	mov    0x8(%eax),%eax
  801726:	85 c0                	test   %eax,%eax
  801728:	74 35                	je     80175f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	ff 75 10             	pushl  0x10(%ebp)
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	52                   	push   %edx
  801734:	ff d0                	call   *%eax
  801736:	83 c4 10             	add    $0x10,%esp
}
  801739:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80173e:	a1 08 40 80 00       	mov    0x804008,%eax
  801743:	8b 40 48             	mov    0x48(%eax),%eax
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	53                   	push   %ebx
  80174a:	50                   	push   %eax
  80174b:	68 89 2d 80 00       	push   $0x802d89
  801750:	e8 d6 eb ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175d:	eb da                	jmp    801739 <read+0x5a>
		return -E_NOT_SUPP;
  80175f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801764:	eb d3                	jmp    801739 <read+0x5a>

00801766 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	57                   	push   %edi
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801772:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801775:	bb 00 00 00 00       	mov    $0x0,%ebx
  80177a:	39 f3                	cmp    %esi,%ebx
  80177c:	73 25                	jae    8017a3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	89 f0                	mov    %esi,%eax
  801783:	29 d8                	sub    %ebx,%eax
  801785:	50                   	push   %eax
  801786:	89 d8                	mov    %ebx,%eax
  801788:	03 45 0c             	add    0xc(%ebp),%eax
  80178b:	50                   	push   %eax
  80178c:	57                   	push   %edi
  80178d:	e8 4d ff ff ff       	call   8016df <read>
		if (m < 0)
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	78 08                	js     8017a1 <readn+0x3b>
			return m;
		if (m == 0)
  801799:	85 c0                	test   %eax,%eax
  80179b:	74 06                	je     8017a3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80179d:	01 c3                	add    %eax,%ebx
  80179f:	eb d9                	jmp    80177a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017a1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017a3:	89 d8                	mov    %ebx,%eax
  8017a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a8:	5b                   	pop    %ebx
  8017a9:	5e                   	pop    %esi
  8017aa:	5f                   	pop    %edi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	53                   	push   %ebx
  8017b1:	83 ec 14             	sub    $0x14,%esp
  8017b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ba:	50                   	push   %eax
  8017bb:	53                   	push   %ebx
  8017bc:	e8 ad fc ff ff       	call   80146e <fd_lookup>
  8017c1:	83 c4 08             	add    $0x8,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 3a                	js     801802 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d2:	ff 30                	pushl  (%eax)
  8017d4:	e8 eb fc ff ff       	call   8014c4 <dev_lookup>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 22                	js     801802 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e7:	74 1e                	je     801807 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ec:	8b 52 0c             	mov    0xc(%edx),%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	74 35                	je     801828 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	ff 75 10             	pushl  0x10(%ebp)
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	50                   	push   %eax
  8017fd:	ff d2                	call   *%edx
  8017ff:	83 c4 10             	add    $0x10,%esp
}
  801802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801805:	c9                   	leave  
  801806:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801807:	a1 08 40 80 00       	mov    0x804008,%eax
  80180c:	8b 40 48             	mov    0x48(%eax),%eax
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	53                   	push   %ebx
  801813:	50                   	push   %eax
  801814:	68 a5 2d 80 00       	push   $0x802da5
  801819:	e8 0d eb ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801826:	eb da                	jmp    801802 <write+0x55>
		return -E_NOT_SUPP;
  801828:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182d:	eb d3                	jmp    801802 <write+0x55>

0080182f <seek>:

int
seek(int fdnum, off_t offset)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801835:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801838:	50                   	push   %eax
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	e8 2d fc ff ff       	call   80146e <fd_lookup>
  801841:	83 c4 08             	add    $0x8,%esp
  801844:	85 c0                	test   %eax,%eax
  801846:	78 0e                	js     801856 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	53                   	push   %ebx
  80185c:	83 ec 14             	sub    $0x14,%esp
  80185f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801862:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801865:	50                   	push   %eax
  801866:	53                   	push   %ebx
  801867:	e8 02 fc ff ff       	call   80146e <fd_lookup>
  80186c:	83 c4 08             	add    $0x8,%esp
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 37                	js     8018aa <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187d:	ff 30                	pushl  (%eax)
  80187f:	e8 40 fc ff ff       	call   8014c4 <dev_lookup>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 1f                	js     8018aa <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801892:	74 1b                	je     8018af <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801897:	8b 52 18             	mov    0x18(%edx),%edx
  80189a:	85 d2                	test   %edx,%edx
  80189c:	74 32                	je     8018d0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	50                   	push   %eax
  8018a5:	ff d2                	call   *%edx
  8018a7:	83 c4 10             	add    $0x10,%esp
}
  8018aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018af:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b4:	8b 40 48             	mov    0x48(%eax),%eax
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	53                   	push   %ebx
  8018bb:	50                   	push   %eax
  8018bc:	68 68 2d 80 00       	push   $0x802d68
  8018c1:	e8 65 ea ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ce:	eb da                	jmp    8018aa <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d5:	eb d3                	jmp    8018aa <ftruncate+0x52>

008018d7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	53                   	push   %ebx
  8018db:	83 ec 14             	sub    $0x14,%esp
  8018de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e4:	50                   	push   %eax
  8018e5:	ff 75 08             	pushl  0x8(%ebp)
  8018e8:	e8 81 fb ff ff       	call   80146e <fd_lookup>
  8018ed:	83 c4 08             	add    $0x8,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 4b                	js     80193f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f4:	83 ec 08             	sub    $0x8,%esp
  8018f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fa:	50                   	push   %eax
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fe:	ff 30                	pushl  (%eax)
  801900:	e8 bf fb ff ff       	call   8014c4 <dev_lookup>
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 33                	js     80193f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801913:	74 2f                	je     801944 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801915:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801918:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80191f:	00 00 00 
	stat->st_isdir = 0;
  801922:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801929:	00 00 00 
	stat->st_dev = dev;
  80192c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	53                   	push   %ebx
  801936:	ff 75 f0             	pushl  -0x10(%ebp)
  801939:	ff 50 14             	call   *0x14(%eax)
  80193c:	83 c4 10             	add    $0x10,%esp
}
  80193f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801942:	c9                   	leave  
  801943:	c3                   	ret    
		return -E_NOT_SUPP;
  801944:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801949:	eb f4                	jmp    80193f <fstat+0x68>

0080194b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	6a 00                	push   $0x0
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	e8 26 02 00 00       	call   801b83 <open>
  80195d:	89 c3                	mov    %eax,%ebx
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	78 1b                	js     801981 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	50                   	push   %eax
  80196d:	e8 65 ff ff ff       	call   8018d7 <fstat>
  801972:	89 c6                	mov    %eax,%esi
	close(fd);
  801974:	89 1c 24             	mov    %ebx,(%esp)
  801977:	e8 27 fc ff ff       	call   8015a3 <close>
	return r;
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	89 f3                	mov    %esi,%ebx
}
  801981:	89 d8                	mov    %ebx,%eax
  801983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	56                   	push   %esi
  80198e:	53                   	push   %ebx
  80198f:	89 c6                	mov    %eax,%esi
  801991:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801993:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80199a:	74 27                	je     8019c3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80199c:	6a 07                	push   $0x7
  80199e:	68 00 50 80 00       	push   $0x805000
  8019a3:	56                   	push   %esi
  8019a4:	ff 35 00 40 80 00    	pushl  0x804000
  8019aa:	e8 b7 f9 ff ff       	call   801366 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019af:	83 c4 0c             	add    $0xc,%esp
  8019b2:	6a 00                	push   $0x0
  8019b4:	53                   	push   %ebx
  8019b5:	6a 00                	push   $0x0
  8019b7:	e8 41 f9 ff ff       	call   8012fd <ipc_recv>
}
  8019bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c3:	83 ec 0c             	sub    $0xc,%esp
  8019c6:	6a 01                	push   $0x1
  8019c8:	e8 f2 f9 ff ff       	call   8013bf <ipc_find_env>
  8019cd:	a3 00 40 80 00       	mov    %eax,0x804000
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	eb c5                	jmp    80199c <fsipc+0x12>

008019d7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019eb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	b8 02 00 00 00       	mov    $0x2,%eax
  8019fa:	e8 8b ff ff ff       	call   80198a <fsipc>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <devfile_flush>:
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
  801a17:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1c:	e8 69 ff ff ff       	call   80198a <fsipc>
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <devfile_stat>:
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	53                   	push   %ebx
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8b 40 0c             	mov    0xc(%eax),%eax
  801a33:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a38:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3d:	b8 05 00 00 00       	mov    $0x5,%eax
  801a42:	e8 43 ff ff ff       	call   80198a <fsipc>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 2c                	js     801a77 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	68 00 50 80 00       	push   $0x805000
  801a53:	53                   	push   %ebx
  801a54:	e8 6f ef ff ff       	call   8009c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a59:	a1 80 50 80 00       	mov    0x805080,%eax
  801a5e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a64:	a1 84 50 80 00       	mov    0x805084,%eax
  801a69:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <devfile_write>:
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801a91:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801a97:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a9d:	77 30                	ja     801acf <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	53                   	push   %ebx
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	68 08 50 80 00       	push   $0x805008
  801aab:	e8 a6 f0 ff ff       	call   800b56 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab5:	b8 04 00 00 00       	mov    $0x4,%eax
  801aba:	e8 cb fe ff ff       	call   80198a <fsipc>
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 04                	js     801aca <devfile_write+0x4e>
	assert(r <= n);
  801ac6:	39 d8                	cmp    %ebx,%eax
  801ac8:	77 1e                	ja     801ae8 <devfile_write+0x6c>
}
  801aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801acf:	68 d8 2d 80 00       	push   $0x802dd8
  801ad4:	68 08 2e 80 00       	push   $0x802e08
  801ad9:	68 94 00 00 00       	push   $0x94
  801ade:	68 1d 2e 80 00       	push   $0x802e1d
  801ae3:	e8 68 e7 ff ff       	call   800250 <_panic>
	assert(r <= n);
  801ae8:	68 28 2e 80 00       	push   $0x802e28
  801aed:	68 08 2e 80 00       	push   $0x802e08
  801af2:	68 98 00 00 00       	push   $0x98
  801af7:	68 1d 2e 80 00       	push   $0x802e1d
  801afc:	e8 4f e7 ff ff       	call   800250 <_panic>

00801b01 <devfile_read>:
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	56                   	push   %esi
  801b05:	53                   	push   %ebx
  801b06:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b14:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b24:	e8 61 fe ff ff       	call   80198a <fsipc>
  801b29:	89 c3                	mov    %eax,%ebx
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	78 1f                	js     801b4e <devfile_read+0x4d>
	assert(r <= n);
  801b2f:	39 f0                	cmp    %esi,%eax
  801b31:	77 24                	ja     801b57 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b33:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b38:	7f 33                	jg     801b6d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b3a:	83 ec 04             	sub    $0x4,%esp
  801b3d:	50                   	push   %eax
  801b3e:	68 00 50 80 00       	push   $0x805000
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	e8 0b f0 ff ff       	call   800b56 <memmove>
	return r;
  801b4b:	83 c4 10             	add    $0x10,%esp
}
  801b4e:	89 d8                	mov    %ebx,%eax
  801b50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    
	assert(r <= n);
  801b57:	68 28 2e 80 00       	push   $0x802e28
  801b5c:	68 08 2e 80 00       	push   $0x802e08
  801b61:	6a 7c                	push   $0x7c
  801b63:	68 1d 2e 80 00       	push   $0x802e1d
  801b68:	e8 e3 e6 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801b6d:	68 2f 2e 80 00       	push   $0x802e2f
  801b72:	68 08 2e 80 00       	push   $0x802e08
  801b77:	6a 7d                	push   $0x7d
  801b79:	68 1d 2e 80 00       	push   $0x802e1d
  801b7e:	e8 cd e6 ff ff       	call   800250 <_panic>

00801b83 <open>:
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 1c             	sub    $0x1c,%esp
  801b8b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b8e:	56                   	push   %esi
  801b8f:	e8 fd ed ff ff       	call   800991 <strlen>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b9c:	7f 6c                	jg     801c0a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba4:	50                   	push   %eax
  801ba5:	e8 75 f8 ff ff       	call   80141f <fd_alloc>
  801baa:	89 c3                	mov    %eax,%ebx
  801bac:	83 c4 10             	add    $0x10,%esp
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 3c                	js     801bef <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bb3:	83 ec 08             	sub    $0x8,%esp
  801bb6:	56                   	push   %esi
  801bb7:	68 00 50 80 00       	push   $0x805000
  801bbc:	e8 07 ee ff ff       	call   8009c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcc:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd1:	e8 b4 fd ff ff       	call   80198a <fsipc>
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 19                	js     801bf8 <open+0x75>
	return fd2num(fd);
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	ff 75 f4             	pushl  -0xc(%ebp)
  801be5:	e8 0e f8 ff ff       	call   8013f8 <fd2num>
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	83 c4 10             	add    $0x10,%esp
}
  801bef:	89 d8                	mov    %ebx,%eax
  801bf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
		fd_close(fd, 0);
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	6a 00                	push   $0x0
  801bfd:	ff 75 f4             	pushl  -0xc(%ebp)
  801c00:	e8 15 f9 ff ff       	call   80151a <fd_close>
		return r;
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	eb e5                	jmp    801bef <open+0x6c>
		return -E_BAD_PATH;
  801c0a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c0f:	eb de                	jmp    801bef <open+0x6c>

00801c11 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c17:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c21:	e8 64 fd ff ff       	call   80198a <fsipc>
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c2e:	89 d0                	mov    %edx,%eax
  801c30:	c1 e8 16             	shr    $0x16,%eax
  801c33:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801c3f:	f6 c1 01             	test   $0x1,%cl
  801c42:	74 1d                	je     801c61 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801c44:	c1 ea 0c             	shr    $0xc,%edx
  801c47:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c4e:	f6 c2 01             	test   $0x1,%dl
  801c51:	74 0e                	je     801c61 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c53:	c1 ea 0c             	shr    $0xc,%edx
  801c56:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c5d:	ef 
  801c5e:	0f b7 c0             	movzwl %ax,%eax
}
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    

00801c63 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
  801c68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c6b:	83 ec 0c             	sub    $0xc,%esp
  801c6e:	ff 75 08             	pushl  0x8(%ebp)
  801c71:	e8 92 f7 ff ff       	call   801408 <fd2data>
  801c76:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c78:	83 c4 08             	add    $0x8,%esp
  801c7b:	68 3b 2e 80 00       	push   $0x802e3b
  801c80:	53                   	push   %ebx
  801c81:	e8 42 ed ff ff       	call   8009c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c86:	8b 46 04             	mov    0x4(%esi),%eax
  801c89:	2b 06                	sub    (%esi),%eax
  801c8b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c91:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c98:	00 00 00 
	stat->st_dev = &devpipe;
  801c9b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ca2:	30 80 00 
	return 0;
}
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  801caa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5e                   	pop    %esi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    

00801cb1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	53                   	push   %ebx
  801cb5:	83 ec 0c             	sub    $0xc,%esp
  801cb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cbb:	53                   	push   %ebx
  801cbc:	6a 00                	push   $0x0
  801cbe:	e8 83 f1 ff ff       	call   800e46 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cc3:	89 1c 24             	mov    %ebx,(%esp)
  801cc6:	e8 3d f7 ff ff       	call   801408 <fd2data>
  801ccb:	83 c4 08             	add    $0x8,%esp
  801cce:	50                   	push   %eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	e8 70 f1 ff ff       	call   800e46 <sys_page_unmap>
}
  801cd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <_pipeisclosed>:
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	57                   	push   %edi
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 1c             	sub    $0x1c,%esp
  801ce4:	89 c7                	mov    %eax,%edi
  801ce6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ce8:	a1 08 40 80 00       	mov    0x804008,%eax
  801ced:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cf0:	83 ec 0c             	sub    $0xc,%esp
  801cf3:	57                   	push   %edi
  801cf4:	e8 2f ff ff ff       	call   801c28 <pageref>
  801cf9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cfc:	89 34 24             	mov    %esi,(%esp)
  801cff:	e8 24 ff ff ff       	call   801c28 <pageref>
		nn = thisenv->env_runs;
  801d04:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d0a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	39 cb                	cmp    %ecx,%ebx
  801d12:	74 1b                	je     801d2f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d14:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d17:	75 cf                	jne    801ce8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d19:	8b 42 58             	mov    0x58(%edx),%eax
  801d1c:	6a 01                	push   $0x1
  801d1e:	50                   	push   %eax
  801d1f:	53                   	push   %ebx
  801d20:	68 42 2e 80 00       	push   $0x802e42
  801d25:	e8 01 e6 ff ff       	call   80032b <cprintf>
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	eb b9                	jmp    801ce8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d2f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d32:	0f 94 c0             	sete   %al
  801d35:	0f b6 c0             	movzbl %al,%eax
}
  801d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5f                   	pop    %edi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    

00801d40 <devpipe_write>:
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	57                   	push   %edi
  801d44:	56                   	push   %esi
  801d45:	53                   	push   %ebx
  801d46:	83 ec 28             	sub    $0x28,%esp
  801d49:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d4c:	56                   	push   %esi
  801d4d:	e8 b6 f6 ff ff       	call   801408 <fd2data>
  801d52:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d5f:	74 4f                	je     801db0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d61:	8b 43 04             	mov    0x4(%ebx),%eax
  801d64:	8b 0b                	mov    (%ebx),%ecx
  801d66:	8d 51 20             	lea    0x20(%ecx),%edx
  801d69:	39 d0                	cmp    %edx,%eax
  801d6b:	72 14                	jb     801d81 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d6d:	89 da                	mov    %ebx,%edx
  801d6f:	89 f0                	mov    %esi,%eax
  801d71:	e8 65 ff ff ff       	call   801cdb <_pipeisclosed>
  801d76:	85 c0                	test   %eax,%eax
  801d78:	75 3a                	jne    801db4 <devpipe_write+0x74>
			sys_yield();
  801d7a:	e8 23 f0 ff ff       	call   800da2 <sys_yield>
  801d7f:	eb e0                	jmp    801d61 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d84:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d88:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d8b:	89 c2                	mov    %eax,%edx
  801d8d:	c1 fa 1f             	sar    $0x1f,%edx
  801d90:	89 d1                	mov    %edx,%ecx
  801d92:	c1 e9 1b             	shr    $0x1b,%ecx
  801d95:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d98:	83 e2 1f             	and    $0x1f,%edx
  801d9b:	29 ca                	sub    %ecx,%edx
  801d9d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801da1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801da5:	83 c0 01             	add    $0x1,%eax
  801da8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dab:	83 c7 01             	add    $0x1,%edi
  801dae:	eb ac                	jmp    801d5c <devpipe_write+0x1c>
	return i;
  801db0:	89 f8                	mov    %edi,%eax
  801db2:	eb 05                	jmp    801db9 <devpipe_write+0x79>
				return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dbc:	5b                   	pop    %ebx
  801dbd:	5e                   	pop    %esi
  801dbe:	5f                   	pop    %edi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    

00801dc1 <devpipe_read>:
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	57                   	push   %edi
  801dc5:	56                   	push   %esi
  801dc6:	53                   	push   %ebx
  801dc7:	83 ec 18             	sub    $0x18,%esp
  801dca:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dcd:	57                   	push   %edi
  801dce:	e8 35 f6 ff ff       	call   801408 <fd2data>
  801dd3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	be 00 00 00 00       	mov    $0x0,%esi
  801ddd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801de0:	74 47                	je     801e29 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801de2:	8b 03                	mov    (%ebx),%eax
  801de4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de7:	75 22                	jne    801e0b <devpipe_read+0x4a>
			if (i > 0)
  801de9:	85 f6                	test   %esi,%esi
  801deb:	75 14                	jne    801e01 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801ded:	89 da                	mov    %ebx,%edx
  801def:	89 f8                	mov    %edi,%eax
  801df1:	e8 e5 fe ff ff       	call   801cdb <_pipeisclosed>
  801df6:	85 c0                	test   %eax,%eax
  801df8:	75 33                	jne    801e2d <devpipe_read+0x6c>
			sys_yield();
  801dfa:	e8 a3 ef ff ff       	call   800da2 <sys_yield>
  801dff:	eb e1                	jmp    801de2 <devpipe_read+0x21>
				return i;
  801e01:	89 f0                	mov    %esi,%eax
}
  801e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5e                   	pop    %esi
  801e08:	5f                   	pop    %edi
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e0b:	99                   	cltd   
  801e0c:	c1 ea 1b             	shr    $0x1b,%edx
  801e0f:	01 d0                	add    %edx,%eax
  801e11:	83 e0 1f             	and    $0x1f,%eax
  801e14:	29 d0                	sub    %edx,%eax
  801e16:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e1e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e21:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e24:	83 c6 01             	add    $0x1,%esi
  801e27:	eb b4                	jmp    801ddd <devpipe_read+0x1c>
	return i;
  801e29:	89 f0                	mov    %esi,%eax
  801e2b:	eb d6                	jmp    801e03 <devpipe_read+0x42>
				return 0;
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e32:	eb cf                	jmp    801e03 <devpipe_read+0x42>

00801e34 <pipe>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
  801e39:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	e8 da f5 ff ff       	call   80141f <fd_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	78 5b                	js     801ea9 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	68 07 04 00 00       	push   $0x407
  801e56:	ff 75 f4             	pushl  -0xc(%ebp)
  801e59:	6a 00                	push   $0x0
  801e5b:	e8 61 ef ff ff       	call   800dc1 <sys_page_alloc>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 40                	js     801ea9 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e6f:	50                   	push   %eax
  801e70:	e8 aa f5 ff ff       	call   80141f <fd_alloc>
  801e75:	89 c3                	mov    %eax,%ebx
  801e77:	83 c4 10             	add    $0x10,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 1b                	js     801e99 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 07 04 00 00       	push   $0x407
  801e86:	ff 75 f0             	pushl  -0x10(%ebp)
  801e89:	6a 00                	push   $0x0
  801e8b:	e8 31 ef ff ff       	call   800dc1 <sys_page_alloc>
  801e90:	89 c3                	mov    %eax,%ebx
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	85 c0                	test   %eax,%eax
  801e97:	79 19                	jns    801eb2 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e99:	83 ec 08             	sub    $0x8,%esp
  801e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9f:	6a 00                	push   $0x0
  801ea1:	e8 a0 ef ff ff       	call   800e46 <sys_page_unmap>
  801ea6:	83 c4 10             	add    $0x10,%esp
}
  801ea9:	89 d8                	mov    %ebx,%eax
  801eab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eae:	5b                   	pop    %ebx
  801eaf:	5e                   	pop    %esi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    
	va = fd2data(fd0);
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb8:	e8 4b f5 ff ff       	call   801408 <fd2data>
  801ebd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebf:	83 c4 0c             	add    $0xc,%esp
  801ec2:	68 07 04 00 00       	push   $0x407
  801ec7:	50                   	push   %eax
  801ec8:	6a 00                	push   $0x0
  801eca:	e8 f2 ee ff ff       	call   800dc1 <sys_page_alloc>
  801ecf:	89 c3                	mov    %eax,%ebx
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	0f 88 8c 00 00 00    	js     801f68 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee2:	e8 21 f5 ff ff       	call   801408 <fd2data>
  801ee7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eee:	50                   	push   %eax
  801eef:	6a 00                	push   $0x0
  801ef1:	56                   	push   %esi
  801ef2:	6a 00                	push   $0x0
  801ef4:	e8 0b ef ff ff       	call   800e04 <sys_page_map>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	83 c4 20             	add    $0x20,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 58                	js     801f5a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f0b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f20:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f25:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f32:	e8 c1 f4 ff ff       	call   8013f8 <fd2num>
  801f37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f3c:	83 c4 04             	add    $0x4,%esp
  801f3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801f42:	e8 b1 f4 ff ff       	call   8013f8 <fd2num>
  801f47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f55:	e9 4f ff ff ff       	jmp    801ea9 <pipe+0x75>
	sys_page_unmap(0, va);
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	56                   	push   %esi
  801f5e:	6a 00                	push   $0x0
  801f60:	e8 e1 ee ff ff       	call   800e46 <sys_page_unmap>
  801f65:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6e:	6a 00                	push   $0x0
  801f70:	e8 d1 ee ff ff       	call   800e46 <sys_page_unmap>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	e9 1c ff ff ff       	jmp    801e99 <pipe+0x65>

00801f7d <pipeisclosed>:
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f86:	50                   	push   %eax
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	e8 df f4 ff ff       	call   80146e <fd_lookup>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 18                	js     801fae <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9c:	e8 67 f4 ff ff       	call   801408 <fd2data>
	return _pipeisclosed(fd, p);
  801fa1:	89 c2                	mov    %eax,%edx
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	e8 30 fd ff ff       	call   801cdb <_pipeisclosed>
  801fab:	83 c4 10             	add    $0x10,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fb6:	68 5a 2e 80 00       	push   $0x802e5a
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	e8 05 ea ff ff       	call   8009c8 <strcpy>
	return 0;
}
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <devsock_close>:
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	53                   	push   %ebx
  801fce:	83 ec 10             	sub    $0x10,%esp
  801fd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fd4:	53                   	push   %ebx
  801fd5:	e8 4e fc ff ff       	call   801c28 <pageref>
  801fda:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fdd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fe2:	83 f8 01             	cmp    $0x1,%eax
  801fe5:	74 07                	je     801fee <devsock_close+0x24>
}
  801fe7:	89 d0                	mov    %edx,%eax
  801fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	ff 73 0c             	pushl  0xc(%ebx)
  801ff4:	e8 b7 02 00 00       	call   8022b0 <nsipc_close>
  801ff9:	89 c2                	mov    %eax,%edx
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	eb e7                	jmp    801fe7 <devsock_close+0x1d>

00802000 <devsock_write>:
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802006:	6a 00                	push   $0x0
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	ff 70 0c             	pushl  0xc(%eax)
  802014:	e8 74 03 00 00       	call   80238d <nsipc_send>
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <devsock_read>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802021:	6a 00                	push   $0x0
  802023:	ff 75 10             	pushl  0x10(%ebp)
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	ff 70 0c             	pushl  0xc(%eax)
  80202f:	e8 ed 02 00 00       	call   802321 <nsipc_recv>
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <fd2sockid>:
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80203c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80203f:	52                   	push   %edx
  802040:	50                   	push   %eax
  802041:	e8 28 f4 ff ff       	call   80146e <fd_lookup>
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	85 c0                	test   %eax,%eax
  80204b:	78 10                	js     80205d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  802056:	39 08                	cmp    %ecx,(%eax)
  802058:	75 05                	jne    80205f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80205a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    
		return -E_NOT_SUPP;
  80205f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802064:	eb f7                	jmp    80205d <fd2sockid+0x27>

00802066 <alloc_sockfd>:
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	83 ec 1c             	sub    $0x1c,%esp
  80206e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802073:	50                   	push   %eax
  802074:	e8 a6 f3 ff ff       	call   80141f <fd_alloc>
  802079:	89 c3                	mov    %eax,%ebx
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 43                	js     8020c5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	68 07 04 00 00       	push   $0x407
  80208a:	ff 75 f4             	pushl  -0xc(%ebp)
  80208d:	6a 00                	push   $0x0
  80208f:	e8 2d ed ff ff       	call   800dc1 <sys_page_alloc>
  802094:	89 c3                	mov    %eax,%ebx
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 28                	js     8020c5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020a6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020b2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	50                   	push   %eax
  8020b9:	e8 3a f3 ff ff       	call   8013f8 <fd2num>
  8020be:	89 c3                	mov    %eax,%ebx
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	eb 0c                	jmp    8020d1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020c5:	83 ec 0c             	sub    $0xc,%esp
  8020c8:	56                   	push   %esi
  8020c9:	e8 e2 01 00 00       	call   8022b0 <nsipc_close>
		return r;
  8020ce:	83 c4 10             	add    $0x10,%esp
}
  8020d1:	89 d8                	mov    %ebx,%eax
  8020d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <accept>:
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	e8 4e ff ff ff       	call   802036 <fd2sockid>
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	78 1b                	js     802107 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	ff 75 10             	pushl  0x10(%ebp)
  8020f2:	ff 75 0c             	pushl  0xc(%ebp)
  8020f5:	50                   	push   %eax
  8020f6:	e8 0e 01 00 00       	call   802209 <nsipc_accept>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 05                	js     802107 <accept+0x2d>
	return alloc_sockfd(r);
  802102:	e8 5f ff ff ff       	call   802066 <alloc_sockfd>
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <bind>:
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	e8 1f ff ff ff       	call   802036 <fd2sockid>
  802117:	85 c0                	test   %eax,%eax
  802119:	78 12                	js     80212d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	ff 75 10             	pushl  0x10(%ebp)
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	50                   	push   %eax
  802125:	e8 2f 01 00 00       	call   802259 <nsipc_bind>
  80212a:	83 c4 10             	add    $0x10,%esp
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <shutdown>:
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	e8 f9 fe ff ff       	call   802036 <fd2sockid>
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 0f                	js     802150 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802141:	83 ec 08             	sub    $0x8,%esp
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	50                   	push   %eax
  802148:	e8 41 01 00 00       	call   80228e <nsipc_shutdown>
  80214d:	83 c4 10             	add    $0x10,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <connect>:
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	e8 d6 fe ff ff       	call   802036 <fd2sockid>
  802160:	85 c0                	test   %eax,%eax
  802162:	78 12                	js     802176 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	ff 75 10             	pushl  0x10(%ebp)
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	50                   	push   %eax
  80216e:	e8 57 01 00 00       	call   8022ca <nsipc_connect>
  802173:	83 c4 10             	add    $0x10,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <listen>:
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	e8 b0 fe ff ff       	call   802036 <fd2sockid>
  802186:	85 c0                	test   %eax,%eax
  802188:	78 0f                	js     802199 <listen+0x21>
	return nsipc_listen(r, backlog);
  80218a:	83 ec 08             	sub    $0x8,%esp
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	50                   	push   %eax
  802191:	e8 69 01 00 00       	call   8022ff <nsipc_listen>
  802196:	83 c4 10             	add    $0x10,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <socket>:

int
socket(int domain, int type, int protocol)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021a1:	ff 75 10             	pushl  0x10(%ebp)
  8021a4:	ff 75 0c             	pushl  0xc(%ebp)
  8021a7:	ff 75 08             	pushl  0x8(%ebp)
  8021aa:	e8 3c 02 00 00       	call   8023eb <nsipc_socket>
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 05                	js     8021bb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021b6:	e8 ab fe ff ff       	call   802066 <alloc_sockfd>
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	53                   	push   %ebx
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021c6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8021cd:	74 26                	je     8021f5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021cf:	6a 07                	push   $0x7
  8021d1:	68 00 60 80 00       	push   $0x806000
  8021d6:	53                   	push   %ebx
  8021d7:	ff 35 04 40 80 00    	pushl  0x804004
  8021dd:	e8 84 f1 ff ff       	call   801366 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021e2:	83 c4 0c             	add    $0xc,%esp
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	e8 0d f1 ff ff       	call   8012fd <ipc_recv>
}
  8021f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	6a 02                	push   $0x2
  8021fa:	e8 c0 f1 ff ff       	call   8013bf <ipc_find_env>
  8021ff:	a3 04 40 80 00       	mov    %eax,0x804004
  802204:	83 c4 10             	add    $0x10,%esp
  802207:	eb c6                	jmp    8021cf <nsipc+0x12>

00802209 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	56                   	push   %esi
  80220d:	53                   	push   %ebx
  80220e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802219:	8b 06                	mov    (%esi),%eax
  80221b:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802220:	b8 01 00 00 00       	mov    $0x1,%eax
  802225:	e8 93 ff ff ff       	call   8021bd <nsipc>
  80222a:	89 c3                	mov    %eax,%ebx
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 20                	js     802250 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	ff 35 10 60 80 00    	pushl  0x806010
  802239:	68 00 60 80 00       	push   $0x806000
  80223e:	ff 75 0c             	pushl  0xc(%ebp)
  802241:	e8 10 e9 ff ff       	call   800b56 <memmove>
		*addrlen = ret->ret_addrlen;
  802246:	a1 10 60 80 00       	mov    0x806010,%eax
  80224b:	89 06                	mov    %eax,(%esi)
  80224d:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802250:	89 d8                	mov    %ebx,%eax
  802252:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    

00802259 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	53                   	push   %ebx
  80225d:	83 ec 08             	sub    $0x8,%esp
  802260:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80226b:	53                   	push   %ebx
  80226c:	ff 75 0c             	pushl  0xc(%ebp)
  80226f:	68 04 60 80 00       	push   $0x806004
  802274:	e8 dd e8 ff ff       	call   800b56 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802279:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80227f:	b8 02 00 00 00       	mov    $0x2,%eax
  802284:	e8 34 ff ff ff       	call   8021bd <nsipc>
}
  802289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8022a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8022a9:	e8 0f ff ff ff       	call   8021bd <nsipc>
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8022be:	b8 04 00 00 00       	mov    $0x4,%eax
  8022c3:	e8 f5 fe ff ff       	call   8021bd <nsipc>
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	53                   	push   %ebx
  8022ce:	83 ec 08             	sub    $0x8,%esp
  8022d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022dc:	53                   	push   %ebx
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	68 04 60 80 00       	push   $0x806004
  8022e5:	e8 6c e8 ff ff       	call   800b56 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022ea:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8022f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022f5:	e8 c3 fe ff ff       	call   8021bd <nsipc>
}
  8022fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80230d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802310:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802315:	b8 06 00 00 00       	mov    $0x6,%eax
  80231a:	e8 9e fe ff ff       	call   8021bd <nsipc>
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	56                   	push   %esi
  802325:	53                   	push   %ebx
  802326:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802331:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802337:	8b 45 14             	mov    0x14(%ebp),%eax
  80233a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80233f:	b8 07 00 00 00       	mov    $0x7,%eax
  802344:	e8 74 fe ff ff       	call   8021bd <nsipc>
  802349:	89 c3                	mov    %eax,%ebx
  80234b:	85 c0                	test   %eax,%eax
  80234d:	78 1f                	js     80236e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80234f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802354:	7f 21                	jg     802377 <nsipc_recv+0x56>
  802356:	39 c6                	cmp    %eax,%esi
  802358:	7c 1d                	jl     802377 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80235a:	83 ec 04             	sub    $0x4,%esp
  80235d:	50                   	push   %eax
  80235e:	68 00 60 80 00       	push   $0x806000
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	e8 eb e7 ff ff       	call   800b56 <memmove>
  80236b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80236e:	89 d8                	mov    %ebx,%eax
  802370:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802373:	5b                   	pop    %ebx
  802374:	5e                   	pop    %esi
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802377:	68 66 2e 80 00       	push   $0x802e66
  80237c:	68 08 2e 80 00       	push   $0x802e08
  802381:	6a 62                	push   $0x62
  802383:	68 7b 2e 80 00       	push   $0x802e7b
  802388:	e8 c3 de ff ff       	call   800250 <_panic>

0080238d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	53                   	push   %ebx
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80239f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023a5:	7f 2e                	jg     8023d5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	53                   	push   %ebx
  8023ab:	ff 75 0c             	pushl  0xc(%ebp)
  8023ae:	68 0c 60 80 00       	push   $0x80600c
  8023b3:	e8 9e e7 ff ff       	call   800b56 <memmove>
	nsipcbuf.send.req_size = size;
  8023b8:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023be:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023c6:	b8 08 00 00 00       	mov    $0x8,%eax
  8023cb:	e8 ed fd ff ff       	call   8021bd <nsipc>
}
  8023d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    
	assert(size < 1600);
  8023d5:	68 87 2e 80 00       	push   $0x802e87
  8023da:	68 08 2e 80 00       	push   $0x802e08
  8023df:	6a 6d                	push   $0x6d
  8023e1:	68 7b 2e 80 00       	push   $0x802e7b
  8023e6:	e8 65 de ff ff       	call   800250 <_panic>

008023eb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fc:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802401:	8b 45 10             	mov    0x10(%ebp),%eax
  802404:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802409:	b8 09 00 00 00       	mov    $0x9,%eax
  80240e:	e8 aa fd ff ff       	call   8021bd <nsipc>
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
  80241d:	5d                   	pop    %ebp
  80241e:	c3                   	ret    

0080241f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802425:	68 93 2e 80 00       	push   $0x802e93
  80242a:	ff 75 0c             	pushl  0xc(%ebp)
  80242d:	e8 96 e5 ff ff       	call   8009c8 <strcpy>
	return 0;
}
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <devcons_write>:
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	57                   	push   %edi
  80243d:	56                   	push   %esi
  80243e:	53                   	push   %ebx
  80243f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802445:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80244a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802450:	eb 2f                	jmp    802481 <devcons_write+0x48>
		m = n - tot;
  802452:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802455:	29 f3                	sub    %esi,%ebx
  802457:	83 fb 7f             	cmp    $0x7f,%ebx
  80245a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80245f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	53                   	push   %ebx
  802466:	89 f0                	mov    %esi,%eax
  802468:	03 45 0c             	add    0xc(%ebp),%eax
  80246b:	50                   	push   %eax
  80246c:	57                   	push   %edi
  80246d:	e8 e4 e6 ff ff       	call   800b56 <memmove>
		sys_cputs(buf, m);
  802472:	83 c4 08             	add    $0x8,%esp
  802475:	53                   	push   %ebx
  802476:	57                   	push   %edi
  802477:	e8 89 e8 ff ff       	call   800d05 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80247c:	01 de                	add    %ebx,%esi
  80247e:	83 c4 10             	add    $0x10,%esp
  802481:	3b 75 10             	cmp    0x10(%ebp),%esi
  802484:	72 cc                	jb     802452 <devcons_write+0x19>
}
  802486:	89 f0                	mov    %esi,%eax
  802488:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    

00802490 <devcons_read>:
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	83 ec 08             	sub    $0x8,%esp
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80249b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80249f:	75 07                	jne    8024a8 <devcons_read+0x18>
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    
		sys_yield();
  8024a3:	e8 fa e8 ff ff       	call   800da2 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024a8:	e8 76 e8 ff ff       	call   800d23 <sys_cgetc>
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 f2                	je     8024a3 <devcons_read+0x13>
	if (c < 0)
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	78 ec                	js     8024a1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8024b5:	83 f8 04             	cmp    $0x4,%eax
  8024b8:	74 0c                	je     8024c6 <devcons_read+0x36>
	*(char*)vbuf = c;
  8024ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bd:	88 02                	mov    %al,(%edx)
	return 1;
  8024bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c4:	eb db                	jmp    8024a1 <devcons_read+0x11>
		return 0;
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cb:	eb d4                	jmp    8024a1 <devcons_read+0x11>

008024cd <cputchar>:
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
  8024d0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024d9:	6a 01                	push   $0x1
  8024db:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024de:	50                   	push   %eax
  8024df:	e8 21 e8 ff ff       	call   800d05 <sys_cputs>
}
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <getchar>:
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024ef:	6a 01                	push   $0x1
  8024f1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024f4:	50                   	push   %eax
  8024f5:	6a 00                	push   $0x0
  8024f7:	e8 e3 f1 ff ff       	call   8016df <read>
	if (r < 0)
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	85 c0                	test   %eax,%eax
  802501:	78 08                	js     80250b <getchar+0x22>
	if (r < 1)
  802503:	85 c0                	test   %eax,%eax
  802505:	7e 06                	jle    80250d <getchar+0x24>
	return c;
  802507:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    
		return -E_EOF;
  80250d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802512:	eb f7                	jmp    80250b <getchar+0x22>

00802514 <iscons>:
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80251a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251d:	50                   	push   %eax
  80251e:	ff 75 08             	pushl  0x8(%ebp)
  802521:	e8 48 ef ff ff       	call   80146e <fd_lookup>
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	85 c0                	test   %eax,%eax
  80252b:	78 11                	js     80253e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802536:	39 10                	cmp    %edx,(%eax)
  802538:	0f 94 c0             	sete   %al
  80253b:	0f b6 c0             	movzbl %al,%eax
}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <opencons>:
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	e8 d0 ee ff ff       	call   80141f <fd_alloc>
  80254f:	83 c4 10             	add    $0x10,%esp
  802552:	85 c0                	test   %eax,%eax
  802554:	78 3a                	js     802590 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	68 07 04 00 00       	push   $0x407
  80255e:	ff 75 f4             	pushl  -0xc(%ebp)
  802561:	6a 00                	push   $0x0
  802563:	e8 59 e8 ff ff       	call   800dc1 <sys_page_alloc>
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	85 c0                	test   %eax,%eax
  80256d:	78 21                	js     802590 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802578:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802584:	83 ec 0c             	sub    $0xc,%esp
  802587:	50                   	push   %eax
  802588:	e8 6b ee ff ff       	call   8013f8 <fd2num>
  80258d:	83 c4 10             	add    $0x10,%esp
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802598:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80259f:	74 0a                	je     8025ab <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8025ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8025b0:	8b 40 48             	mov    0x48(%eax),%eax
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	6a 07                	push   $0x7
  8025b8:	68 00 f0 bf ee       	push   $0xeebff000
  8025bd:	50                   	push   %eax
  8025be:	e8 fe e7 ff ff       	call   800dc1 <sys_page_alloc>
  8025c3:	83 c4 10             	add    $0x10,%esp
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	75 2f                	jne    8025f9 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  8025ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8025cf:	8b 40 48             	mov    0x48(%eax),%eax
  8025d2:	83 ec 08             	sub    $0x8,%esp
  8025d5:	68 0b 26 80 00       	push   $0x80260b
  8025da:	50                   	push   %eax
  8025db:	e8 2c e9 ff ff       	call   800f0c <sys_env_set_pgfault_upcall>
  8025e0:	83 c4 10             	add    $0x10,%esp
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	74 ba                	je     8025a1 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8025e7:	50                   	push   %eax
  8025e8:	68 9f 2e 80 00       	push   $0x802e9f
  8025ed:	6a 24                	push   $0x24
  8025ef:	68 b7 2e 80 00       	push   $0x802eb7
  8025f4:	e8 57 dc ff ff       	call   800250 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8025f9:	50                   	push   %eax
  8025fa:	68 9f 2e 80 00       	push   $0x802e9f
  8025ff:	6a 21                	push   $0x21
  802601:	68 b7 2e 80 00       	push   $0x802eb7
  802606:	e8 45 dc ff ff       	call   800250 <_panic>

0080260b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80260b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80260c:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802611:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802613:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  802616:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  80261a:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  80261d:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  802621:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  802625:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  802627:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  80262a:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  80262b:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  80262e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  80262f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802630:	c3                   	ret    
  802631:	66 90                	xchg   %ax,%ax
  802633:	66 90                	xchg   %ax,%ax
  802635:	66 90                	xchg   %ax,%ax
  802637:	66 90                	xchg   %ax,%ax
  802639:	66 90                	xchg   %ax,%ax
  80263b:	66 90                	xchg   %ax,%ax
  80263d:	66 90                	xchg   %ax,%ax
  80263f:	90                   	nop

00802640 <__udivdi3>:
  802640:	55                   	push   %ebp
  802641:	57                   	push   %edi
  802642:	56                   	push   %esi
  802643:	53                   	push   %ebx
  802644:	83 ec 1c             	sub    $0x1c,%esp
  802647:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80264b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80264f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802653:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802657:	85 d2                	test   %edx,%edx
  802659:	75 35                	jne    802690 <__udivdi3+0x50>
  80265b:	39 f3                	cmp    %esi,%ebx
  80265d:	0f 87 bd 00 00 00    	ja     802720 <__udivdi3+0xe0>
  802663:	85 db                	test   %ebx,%ebx
  802665:	89 d9                	mov    %ebx,%ecx
  802667:	75 0b                	jne    802674 <__udivdi3+0x34>
  802669:	b8 01 00 00 00       	mov    $0x1,%eax
  80266e:	31 d2                	xor    %edx,%edx
  802670:	f7 f3                	div    %ebx
  802672:	89 c1                	mov    %eax,%ecx
  802674:	31 d2                	xor    %edx,%edx
  802676:	89 f0                	mov    %esi,%eax
  802678:	f7 f1                	div    %ecx
  80267a:	89 c6                	mov    %eax,%esi
  80267c:	89 e8                	mov    %ebp,%eax
  80267e:	89 f7                	mov    %esi,%edi
  802680:	f7 f1                	div    %ecx
  802682:	89 fa                	mov    %edi,%edx
  802684:	83 c4 1c             	add    $0x1c,%esp
  802687:	5b                   	pop    %ebx
  802688:	5e                   	pop    %esi
  802689:	5f                   	pop    %edi
  80268a:	5d                   	pop    %ebp
  80268b:	c3                   	ret    
  80268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802690:	39 f2                	cmp    %esi,%edx
  802692:	77 7c                	ja     802710 <__udivdi3+0xd0>
  802694:	0f bd fa             	bsr    %edx,%edi
  802697:	83 f7 1f             	xor    $0x1f,%edi
  80269a:	0f 84 98 00 00 00    	je     802738 <__udivdi3+0xf8>
  8026a0:	89 f9                	mov    %edi,%ecx
  8026a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a7:	29 f8                	sub    %edi,%eax
  8026a9:	d3 e2                	shl    %cl,%edx
  8026ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026af:	89 c1                	mov    %eax,%ecx
  8026b1:	89 da                	mov    %ebx,%edx
  8026b3:	d3 ea                	shr    %cl,%edx
  8026b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026b9:	09 d1                	or     %edx,%ecx
  8026bb:	89 f2                	mov    %esi,%edx
  8026bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026c1:	89 f9                	mov    %edi,%ecx
  8026c3:	d3 e3                	shl    %cl,%ebx
  8026c5:	89 c1                	mov    %eax,%ecx
  8026c7:	d3 ea                	shr    %cl,%edx
  8026c9:	89 f9                	mov    %edi,%ecx
  8026cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026cf:	d3 e6                	shl    %cl,%esi
  8026d1:	89 eb                	mov    %ebp,%ebx
  8026d3:	89 c1                	mov    %eax,%ecx
  8026d5:	d3 eb                	shr    %cl,%ebx
  8026d7:	09 de                	or     %ebx,%esi
  8026d9:	89 f0                	mov    %esi,%eax
  8026db:	f7 74 24 08          	divl   0x8(%esp)
  8026df:	89 d6                	mov    %edx,%esi
  8026e1:	89 c3                	mov    %eax,%ebx
  8026e3:	f7 64 24 0c          	mull   0xc(%esp)
  8026e7:	39 d6                	cmp    %edx,%esi
  8026e9:	72 0c                	jb     8026f7 <__udivdi3+0xb7>
  8026eb:	89 f9                	mov    %edi,%ecx
  8026ed:	d3 e5                	shl    %cl,%ebp
  8026ef:	39 c5                	cmp    %eax,%ebp
  8026f1:	73 5d                	jae    802750 <__udivdi3+0x110>
  8026f3:	39 d6                	cmp    %edx,%esi
  8026f5:	75 59                	jne    802750 <__udivdi3+0x110>
  8026f7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026fa:	31 ff                	xor    %edi,%edi
  8026fc:	89 fa                	mov    %edi,%edx
  8026fe:	83 c4 1c             	add    $0x1c,%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    
  802706:	8d 76 00             	lea    0x0(%esi),%esi
  802709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802710:	31 ff                	xor    %edi,%edi
  802712:	31 c0                	xor    %eax,%eax
  802714:	89 fa                	mov    %edi,%edx
  802716:	83 c4 1c             	add    $0x1c,%esp
  802719:	5b                   	pop    %ebx
  80271a:	5e                   	pop    %esi
  80271b:	5f                   	pop    %edi
  80271c:	5d                   	pop    %ebp
  80271d:	c3                   	ret    
  80271e:	66 90                	xchg   %ax,%ax
  802720:	31 ff                	xor    %edi,%edi
  802722:	89 e8                	mov    %ebp,%eax
  802724:	89 f2                	mov    %esi,%edx
  802726:	f7 f3                	div    %ebx
  802728:	89 fa                	mov    %edi,%edx
  80272a:	83 c4 1c             	add    $0x1c,%esp
  80272d:	5b                   	pop    %ebx
  80272e:	5e                   	pop    %esi
  80272f:	5f                   	pop    %edi
  802730:	5d                   	pop    %ebp
  802731:	c3                   	ret    
  802732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802738:	39 f2                	cmp    %esi,%edx
  80273a:	72 06                	jb     802742 <__udivdi3+0x102>
  80273c:	31 c0                	xor    %eax,%eax
  80273e:	39 eb                	cmp    %ebp,%ebx
  802740:	77 d2                	ja     802714 <__udivdi3+0xd4>
  802742:	b8 01 00 00 00       	mov    $0x1,%eax
  802747:	eb cb                	jmp    802714 <__udivdi3+0xd4>
  802749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802750:	89 d8                	mov    %ebx,%eax
  802752:	31 ff                	xor    %edi,%edi
  802754:	eb be                	jmp    802714 <__udivdi3+0xd4>
  802756:	66 90                	xchg   %ax,%ax
  802758:	66 90                	xchg   %ax,%ax
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <__umoddi3>:
  802760:	55                   	push   %ebp
  802761:	57                   	push   %edi
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
  802764:	83 ec 1c             	sub    $0x1c,%esp
  802767:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80276b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80276f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802773:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802777:	85 ed                	test   %ebp,%ebp
  802779:	89 f0                	mov    %esi,%eax
  80277b:	89 da                	mov    %ebx,%edx
  80277d:	75 19                	jne    802798 <__umoddi3+0x38>
  80277f:	39 df                	cmp    %ebx,%edi
  802781:	0f 86 b1 00 00 00    	jbe    802838 <__umoddi3+0xd8>
  802787:	f7 f7                	div    %edi
  802789:	89 d0                	mov    %edx,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	83 c4 1c             	add    $0x1c,%esp
  802790:	5b                   	pop    %ebx
  802791:	5e                   	pop    %esi
  802792:	5f                   	pop    %edi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
  802795:	8d 76 00             	lea    0x0(%esi),%esi
  802798:	39 dd                	cmp    %ebx,%ebp
  80279a:	77 f1                	ja     80278d <__umoddi3+0x2d>
  80279c:	0f bd cd             	bsr    %ebp,%ecx
  80279f:	83 f1 1f             	xor    $0x1f,%ecx
  8027a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027a6:	0f 84 b4 00 00 00    	je     802860 <__umoddi3+0x100>
  8027ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8027b1:	89 c2                	mov    %eax,%edx
  8027b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027b7:	29 c2                	sub    %eax,%edx
  8027b9:	89 c1                	mov    %eax,%ecx
  8027bb:	89 f8                	mov    %edi,%eax
  8027bd:	d3 e5                	shl    %cl,%ebp
  8027bf:	89 d1                	mov    %edx,%ecx
  8027c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027c5:	d3 e8                	shr    %cl,%eax
  8027c7:	09 c5                	or     %eax,%ebp
  8027c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027cd:	89 c1                	mov    %eax,%ecx
  8027cf:	d3 e7                	shl    %cl,%edi
  8027d1:	89 d1                	mov    %edx,%ecx
  8027d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027d7:	89 df                	mov    %ebx,%edi
  8027d9:	d3 ef                	shr    %cl,%edi
  8027db:	89 c1                	mov    %eax,%ecx
  8027dd:	89 f0                	mov    %esi,%eax
  8027df:	d3 e3                	shl    %cl,%ebx
  8027e1:	89 d1                	mov    %edx,%ecx
  8027e3:	89 fa                	mov    %edi,%edx
  8027e5:	d3 e8                	shr    %cl,%eax
  8027e7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027ec:	09 d8                	or     %ebx,%eax
  8027ee:	f7 f5                	div    %ebp
  8027f0:	d3 e6                	shl    %cl,%esi
  8027f2:	89 d1                	mov    %edx,%ecx
  8027f4:	f7 64 24 08          	mull   0x8(%esp)
  8027f8:	39 d1                	cmp    %edx,%ecx
  8027fa:	89 c3                	mov    %eax,%ebx
  8027fc:	89 d7                	mov    %edx,%edi
  8027fe:	72 06                	jb     802806 <__umoddi3+0xa6>
  802800:	75 0e                	jne    802810 <__umoddi3+0xb0>
  802802:	39 c6                	cmp    %eax,%esi
  802804:	73 0a                	jae    802810 <__umoddi3+0xb0>
  802806:	2b 44 24 08          	sub    0x8(%esp),%eax
  80280a:	19 ea                	sbb    %ebp,%edx
  80280c:	89 d7                	mov    %edx,%edi
  80280e:	89 c3                	mov    %eax,%ebx
  802810:	89 ca                	mov    %ecx,%edx
  802812:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802817:	29 de                	sub    %ebx,%esi
  802819:	19 fa                	sbb    %edi,%edx
  80281b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80281f:	89 d0                	mov    %edx,%eax
  802821:	d3 e0                	shl    %cl,%eax
  802823:	89 d9                	mov    %ebx,%ecx
  802825:	d3 ee                	shr    %cl,%esi
  802827:	d3 ea                	shr    %cl,%edx
  802829:	09 f0                	or     %esi,%eax
  80282b:	83 c4 1c             	add    $0x1c,%esp
  80282e:	5b                   	pop    %ebx
  80282f:	5e                   	pop    %esi
  802830:	5f                   	pop    %edi
  802831:	5d                   	pop    %ebp
  802832:	c3                   	ret    
  802833:	90                   	nop
  802834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802838:	85 ff                	test   %edi,%edi
  80283a:	89 f9                	mov    %edi,%ecx
  80283c:	75 0b                	jne    802849 <__umoddi3+0xe9>
  80283e:	b8 01 00 00 00       	mov    $0x1,%eax
  802843:	31 d2                	xor    %edx,%edx
  802845:	f7 f7                	div    %edi
  802847:	89 c1                	mov    %eax,%ecx
  802849:	89 d8                	mov    %ebx,%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	f7 f1                	div    %ecx
  80284f:	89 f0                	mov    %esi,%eax
  802851:	f7 f1                	div    %ecx
  802853:	e9 31 ff ff ff       	jmp    802789 <__umoddi3+0x29>
  802858:	90                   	nop
  802859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802860:	39 dd                	cmp    %ebx,%ebp
  802862:	72 08                	jb     80286c <__umoddi3+0x10c>
  802864:	39 f7                	cmp    %esi,%edi
  802866:	0f 87 21 ff ff ff    	ja     80278d <__umoddi3+0x2d>
  80286c:	89 da                	mov    %ebx,%edx
  80286e:	89 f0                	mov    %esi,%eax
  802870:	29 f8                	sub    %edi,%eax
  802872:	19 ea                	sbb    %ebp,%edx
  802874:	e9 14 ff ff ff       	jmp    80278d <__umoddi3+0x2d>
