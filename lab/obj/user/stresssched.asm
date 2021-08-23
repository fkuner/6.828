
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 3e 0c 00 00       	call   800c7b <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 6a 0f 00 00       	call   800fb3 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 40 0c 00 00       	call   800c9a <sys_yield>
		return;
  80005a:	eb 6e                	jmp    8000ca <umain+0x97>
	if (i == 20) {
  80005c:	83 fb 14             	cmp    $0x14,%ebx
  80005f:	74 f4                	je     800055 <umain+0x22>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800061:	89 f0                	mov    %esi,%eax
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	eb 02                	jmp    800074 <umain+0x41>
		asm volatile("pause");
  800072:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800074:	8b 50 54             	mov    0x54(%eax),%edx
  800077:	85 d2                	test   %edx,%edx
  800079:	75 f7                	jne    800072 <umain+0x3f>
  80007b:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800080:	e8 15 0c 00 00       	call   800c9a <sys_yield>
  800085:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008a:	a1 08 40 80 00       	mov    0x804008,%eax
  80008f:	83 c0 01             	add    $0x1,%eax
  800092:	a3 08 40 80 00       	mov    %eax,0x804008
		for (j = 0; j < 10000; j++)
  800097:	83 ea 01             	sub    $0x1,%edx
  80009a:	75 ee                	jne    80008a <umain+0x57>
	for (i = 0; i < 10; i++) {
  80009c:	83 eb 01             	sub    $0x1,%ebx
  80009f:	75 df                	jne    800080 <umain+0x4d>
	}

	if (counter != 10*10000)
  8000a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a6:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000ab:	75 24                	jne    8000d1 <umain+0x9e>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ad:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000b2:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b5:	8b 40 48             	mov    0x48(%eax),%eax
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	52                   	push   %edx
  8000bc:	50                   	push   %eax
  8000bd:	68 bb 27 80 00       	push   $0x8027bb
  8000c2:	e8 5c 01 00 00       	call   800223 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp

}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d6:	50                   	push   %eax
  8000d7:	68 80 27 80 00       	push   $0x802780
  8000dc:	6a 21                	push   $0x21
  8000de:	68 a8 27 80 00       	push   $0x8027a8
  8000e3:	e8 60 00 00 00       	call   800148 <_panic>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000f3:	e8 83 0b 00 00       	call   800c7b <sys_getenvid>
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	85 db                	test   %ebx,%ebx
  80010c:	7e 07                	jle    800115 <libmain+0x2d>
		binaryname = argv[0];
  80010e:	8b 06                	mov    (%esi),%eax
  800110:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0a 00 00 00       	call   80012e <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800134:	e8 92 12 00 00       	call   8013cb <close_all>
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 f7 0a 00 00       	call   800c3a <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80014d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800150:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800156:	e8 20 0b 00 00       	call   800c7b <sys_getenvid>
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	56                   	push   %esi
  800165:	50                   	push   %eax
  800166:	68 e4 27 80 00       	push   $0x8027e4
  80016b:	e8 b3 00 00 00       	call   800223 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800170:	83 c4 18             	add    $0x18,%esp
  800173:	53                   	push   %ebx
  800174:	ff 75 10             	pushl  0x10(%ebp)
  800177:	e8 56 00 00 00       	call   8001d2 <vcprintf>
	cprintf("\n");
  80017c:	c7 04 24 d7 27 80 00 	movl   $0x8027d7,(%esp)
  800183:	e8 9b 00 00 00       	call   800223 <cprintf>
  800188:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018b:	cc                   	int3   
  80018c:	eb fd                	jmp    80018b <_panic+0x43>

0080018e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	53                   	push   %ebx
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800198:	8b 13                	mov    (%ebx),%edx
  80019a:	8d 42 01             	lea    0x1(%edx),%eax
  80019d:	89 03                	mov    %eax,(%ebx)
  80019f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ab:	74 09                	je     8001b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	68 ff 00 00 00       	push   $0xff
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 36 0a 00 00       	call   800bfd <sys_cputs>
		b->idx = 0;
  8001c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	eb db                	jmp    8001ad <putch+0x1f>

008001d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e2:	00 00 00 
	b.cnt = 0;
  8001e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ef:	ff 75 0c             	pushl  0xc(%ebp)
  8001f2:	ff 75 08             	pushl  0x8(%ebp)
  8001f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	68 8e 01 80 00       	push   $0x80018e
  800201:	e8 1a 01 00 00       	call   800320 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800206:	83 c4 08             	add    $0x8,%esp
  800209:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	e8 e2 09 00 00       	call   800bfd <sys_cputs>

	return b.cnt;
}
  80021b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800229:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 9d ff ff ff       	call   8001d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 1c             	sub    $0x1c,%esp
  800240:	89 c7                	mov    %eax,%edi
  800242:	89 d6                	mov    %edx,%esi
  800244:	8b 45 08             	mov    0x8(%ebp),%eax
  800247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800250:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800253:	bb 00 00 00 00       	mov    $0x0,%ebx
  800258:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80025b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80025e:	39 d3                	cmp    %edx,%ebx
  800260:	72 05                	jb     800267 <printnum+0x30>
  800262:	39 45 10             	cmp    %eax,0x10(%ebp)
  800265:	77 7a                	ja     8002e1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 18             	pushl  0x18(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800273:	53                   	push   %ebx
  800274:	ff 75 10             	pushl  0x10(%ebp)
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027d:	ff 75 e0             	pushl  -0x20(%ebp)
  800280:	ff 75 dc             	pushl  -0x24(%ebp)
  800283:	ff 75 d8             	pushl  -0x28(%ebp)
  800286:	e8 a5 22 00 00       	call   802530 <__udivdi3>
  80028b:	83 c4 18             	add    $0x18,%esp
  80028e:	52                   	push   %edx
  80028f:	50                   	push   %eax
  800290:	89 f2                	mov    %esi,%edx
  800292:	89 f8                	mov    %edi,%eax
  800294:	e8 9e ff ff ff       	call   800237 <printnum>
  800299:	83 c4 20             	add    $0x20,%esp
  80029c:	eb 13                	jmp    8002b1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	56                   	push   %esi
  8002a2:	ff 75 18             	pushl  0x18(%ebp)
  8002a5:	ff d7                	call   *%edi
  8002a7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002aa:	83 eb 01             	sub    $0x1,%ebx
  8002ad:	85 db                	test   %ebx,%ebx
  8002af:	7f ed                	jg     80029e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	56                   	push   %esi
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002be:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c4:	e8 87 23 00 00       	call   802650 <__umoddi3>
  8002c9:	83 c4 14             	add    $0x14,%esp
  8002cc:	0f be 80 07 28 80 00 	movsbl 0x802807(%eax),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff d7                	call   *%edi
}
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    
  8002e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002e4:	eb c4                	jmp    8002aa <printnum+0x73>

008002e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800309:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030c:	50                   	push   %eax
  80030d:	ff 75 10             	pushl  0x10(%ebp)
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 05 00 00 00       	call   800320 <vprintfmt>
}
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <vprintfmt>:
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 2c             	sub    $0x2c,%esp
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800332:	e9 21 04 00 00       	jmp    800758 <vprintfmt+0x438>
		padc = ' ';
  800337:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80033b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800342:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8d 47 01             	lea    0x1(%edi),%eax
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035b:	0f b6 17             	movzbl (%edi),%edx
  80035e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800361:	3c 55                	cmp    $0x55,%al
  800363:	0f 87 90 04 00 00    	ja     8007f9 <vprintfmt+0x4d9>
  800369:	0f b6 c0             	movzbl %al,%eax
  80036c:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800376:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80037a:	eb d9                	jmp    800355 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80037f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800383:	eb d0                	jmp    800355 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	0f b6 d2             	movzbl %dl,%edx
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038b:	b8 00 00 00 00       	mov    $0x0,%eax
  800390:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800393:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a0:	83 f9 09             	cmp    $0x9,%ecx
  8003a3:	77 55                	ja     8003fa <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a8:	eb e9                	jmp    800393 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 40 04             	lea    0x4(%eax),%eax
  8003b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c2:	79 91                	jns    800355 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d1:	eb 82                	jmp    800355 <vprintfmt+0x35>
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	0f 49 d0             	cmovns %eax,%edx
  8003e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e6:	e9 6a ff ff ff       	jmp    800355 <vprintfmt+0x35>
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ee:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003f5:	e9 5b ff ff ff       	jmp    800355 <vprintfmt+0x35>
  8003fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800400:	eb bc                	jmp    8003be <vprintfmt+0x9e>
			lflag++;
  800402:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800408:	e9 48 ff ff ff       	jmp    800355 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8d 78 04             	lea    0x4(%eax),%edi
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	53                   	push   %ebx
  800417:	ff 30                	pushl  (%eax)
  800419:	ff d6                	call   *%esi
			break;
  80041b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800421:	e9 2f 03 00 00       	jmp    800755 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 78 04             	lea    0x4(%eax),%edi
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	99                   	cltd   
  80042f:	31 d0                	xor    %edx,%eax
  800431:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800433:	83 f8 0f             	cmp    $0xf,%eax
  800436:	7f 23                	jg     80045b <vprintfmt+0x13b>
  800438:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  80043f:	85 d2                	test   %edx,%edx
  800441:	74 18                	je     80045b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800443:	52                   	push   %edx
  800444:	68 66 2c 80 00       	push   $0x802c66
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 b3 fe ff ff       	call   800303 <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
  800456:	e9 fa 02 00 00       	jmp    800755 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80045b:	50                   	push   %eax
  80045c:	68 1f 28 80 00       	push   $0x80281f
  800461:	53                   	push   %ebx
  800462:	56                   	push   %esi
  800463:	e8 9b fe ff ff       	call   800303 <printfmt>
  800468:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046e:	e9 e2 02 00 00       	jmp    800755 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	83 c0 04             	add    $0x4,%eax
  800479:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800481:	85 ff                	test   %edi,%edi
  800483:	b8 18 28 80 00       	mov    $0x802818,%eax
  800488:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80048b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048f:	0f 8e bd 00 00 00    	jle    800552 <vprintfmt+0x232>
  800495:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800499:	75 0e                	jne    8004a9 <vprintfmt+0x189>
  80049b:	89 75 08             	mov    %esi,0x8(%ebp)
  80049e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a7:	eb 6d                	jmp    800516 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	ff 75 d0             	pushl  -0x30(%ebp)
  8004af:	57                   	push   %edi
  8004b0:	e8 ec 03 00 00       	call   8008a1 <strnlen>
  8004b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b8:	29 c1                	sub    %eax,%ecx
  8004ba:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004bd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ca:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	eb 0f                	jmp    8004dd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ed                	jg     8004ce <vprintfmt+0x1ae>
  8004e1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004e4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c1             	cmovns %ecx,%eax
  8004f1:	29 c1                	sub    %eax,%ecx
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004fc:	89 cb                	mov    %ecx,%ebx
  8004fe:	eb 16                	jmp    800516 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800500:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800504:	75 31                	jne    800537 <vprintfmt+0x217>
					putch(ch, putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	50                   	push   %eax
  80050d:	ff 55 08             	call   *0x8(%ebp)
  800510:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800513:	83 eb 01             	sub    $0x1,%ebx
  800516:	83 c7 01             	add    $0x1,%edi
  800519:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80051d:	0f be c2             	movsbl %dl,%eax
  800520:	85 c0                	test   %eax,%eax
  800522:	74 59                	je     80057d <vprintfmt+0x25d>
  800524:	85 f6                	test   %esi,%esi
  800526:	78 d8                	js     800500 <vprintfmt+0x1e0>
  800528:	83 ee 01             	sub    $0x1,%esi
  80052b:	79 d3                	jns    800500 <vprintfmt+0x1e0>
  80052d:	89 df                	mov    %ebx,%edi
  80052f:	8b 75 08             	mov    0x8(%ebp),%esi
  800532:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800535:	eb 37                	jmp    80056e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800537:	0f be d2             	movsbl %dl,%edx
  80053a:	83 ea 20             	sub    $0x20,%edx
  80053d:	83 fa 5e             	cmp    $0x5e,%edx
  800540:	76 c4                	jbe    800506 <vprintfmt+0x1e6>
					putch('?', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	6a 3f                	push   $0x3f
  80054a:	ff 55 08             	call   *0x8(%ebp)
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	eb c1                	jmp    800513 <vprintfmt+0x1f3>
  800552:	89 75 08             	mov    %esi,0x8(%ebp)
  800555:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800558:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80055e:	eb b6                	jmp    800516 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	6a 20                	push   $0x20
  800566:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800568:	83 ef 01             	sub    $0x1,%edi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	85 ff                	test   %edi,%edi
  800570:	7f ee                	jg     800560 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800572:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
  800578:	e9 d8 01 00 00       	jmp    800755 <vprintfmt+0x435>
  80057d:	89 df                	mov    %ebx,%edi
  80057f:	8b 75 08             	mov    0x8(%ebp),%esi
  800582:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800585:	eb e7                	jmp    80056e <vprintfmt+0x24e>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7e 45                	jle    8005d1 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 50 04             	mov    0x4(%eax),%edx
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800597:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 40 08             	lea    0x8(%eax),%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a7:	79 62                	jns    80060b <vprintfmt+0x2eb>
				putch('-', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 2d                	push   $0x2d
  8005af:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005b7:	f7 d8                	neg    %eax
  8005b9:	83 d2 00             	adc    $0x0,%edx
  8005bc:	f7 da                	neg    %edx
  8005be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005cc:	e9 66 01 00 00       	jmp    800737 <vprintfmt+0x417>
	else if (lflag)
  8005d1:	85 c9                	test   %ecx,%ecx
  8005d3:	75 1b                	jne    8005f0 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dd:	89 c1                	mov    %eax,%ecx
  8005df:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ee:	eb b3                	jmp    8005a3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 c1                	mov    %eax,%ecx
  8005fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
  800609:	eb 98                	jmp    8005a3 <vprintfmt+0x283>
			base = 10;
  80060b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800610:	e9 22 01 00 00       	jmp    800737 <vprintfmt+0x417>
	if (lflag >= 2)
  800615:	83 f9 01             	cmp    $0x1,%ecx
  800618:	7e 21                	jle    80063b <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 50 04             	mov    0x4(%eax),%edx
  800620:	8b 00                	mov    (%eax),%eax
  800622:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800625:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8d 40 08             	lea    0x8(%eax),%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800631:	ba 0a 00 00 00       	mov    $0xa,%edx
  800636:	e9 fc 00 00 00       	jmp    800737 <vprintfmt+0x417>
	else if (lflag)
  80063b:	85 c9                	test   %ecx,%ecx
  80063d:	75 23                	jne    800662 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	ba 0a 00 00 00       	mov    $0xa,%edx
  80065d:	e9 d5 00 00 00       	jmp    800737 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800680:	e9 b2 00 00 00       	jmp    800737 <vprintfmt+0x417>
	if (lflag >= 2)
  800685:	83 f9 01             	cmp    $0x1,%ecx
  800688:	7e 42                	jle    8006cc <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 50 04             	mov    0x4(%eax),%edx
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a1:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8006a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006aa:	0f 89 87 00 00 00    	jns    800737 <vprintfmt+0x417>
				putch('-', putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	6a 2d                	push   $0x2d
  8006b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b8:	f7 5d d8             	negl   -0x28(%ebp)
  8006bb:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8006bf:	f7 5d dc             	negl   -0x24(%ebp)
  8006c2:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006c5:	ba 08 00 00 00       	mov    $0x8,%edx
  8006ca:	eb 6b                	jmp    800737 <vprintfmt+0x417>
	else if (lflag)
  8006cc:	85 c9                	test   %ecx,%ecx
  8006ce:	75 1b                	jne    8006eb <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 04             	lea    0x4(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e9:	eb b6                	jmp    8006a1 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
  800704:	eb 9b                	jmp    8006a1 <vprintfmt+0x381>
			putch('0', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	6a 30                	push   $0x30
  80070c:	ff d6                	call   *%esi
			putch('x', putdat);
  80070e:	83 c4 08             	add    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 78                	push   $0x78
  800714:	ff d6                	call   *%esi
			num = (unsigned long long)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800723:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800726:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800732:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80073e:	50                   	push   %eax
  80073f:	ff 75 e0             	pushl  -0x20(%ebp)
  800742:	52                   	push   %edx
  800743:	ff 75 dc             	pushl  -0x24(%ebp)
  800746:	ff 75 d8             	pushl  -0x28(%ebp)
  800749:	89 da                	mov    %ebx,%edx
  80074b:	89 f0                	mov    %esi,%eax
  80074d:	e8 e5 fa ff ff       	call   800237 <printnum>
			break;
  800752:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800755:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800758:	83 c7 01             	add    $0x1,%edi
  80075b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80075f:	83 f8 25             	cmp    $0x25,%eax
  800762:	0f 84 cf fb ff ff    	je     800337 <vprintfmt+0x17>
			if (ch == '\0')
  800768:	85 c0                	test   %eax,%eax
  80076a:	0f 84 a9 00 00 00    	je     800819 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	53                   	push   %ebx
  800774:	50                   	push   %eax
  800775:	ff d6                	call   *%esi
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	eb dc                	jmp    800758 <vprintfmt+0x438>
	if (lflag >= 2)
  80077c:	83 f9 01             	cmp    $0x1,%ecx
  80077f:	7e 1e                	jle    80079f <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 50 04             	mov    0x4(%eax),%edx
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 08             	lea    0x8(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800798:	ba 10 00 00 00       	mov    $0x10,%edx
  80079d:	eb 98                	jmp    800737 <vprintfmt+0x417>
	else if (lflag)
  80079f:	85 c9                	test   %ecx,%ecx
  8007a1:	75 23                	jne    8007c6 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8d 40 04             	lea    0x4(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bc:	ba 10 00 00 00       	mov    $0x10,%edx
  8007c1:	e9 71 ff ff ff       	jmp    800737 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 04             	lea    0x4(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007df:	ba 10 00 00 00       	mov    $0x10,%edx
  8007e4:	e9 4e ff ff ff       	jmp    800737 <vprintfmt+0x417>
			putch(ch, putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	53                   	push   %ebx
  8007ed:	6a 25                	push   $0x25
  8007ef:	ff d6                	call   *%esi
			break;
  8007f1:	83 c4 10             	add    $0x10,%esp
  8007f4:	e9 5c ff ff ff       	jmp    800755 <vprintfmt+0x435>
			putch('%', putdat);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	53                   	push   %ebx
  8007fd:	6a 25                	push   $0x25
  8007ff:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	89 f8                	mov    %edi,%eax
  800806:	eb 03                	jmp    80080b <vprintfmt+0x4eb>
  800808:	83 e8 01             	sub    $0x1,%eax
  80080b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80080f:	75 f7                	jne    800808 <vprintfmt+0x4e8>
  800811:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800814:	e9 3c ff ff ff       	jmp    800755 <vprintfmt+0x435>
}
  800819:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80081c:	5b                   	pop    %ebx
  80081d:	5e                   	pop    %esi
  80081e:	5f                   	pop    %edi
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 18             	sub    $0x18,%esp
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800830:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800834:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800837:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083e:	85 c0                	test   %eax,%eax
  800840:	74 26                	je     800868 <vsnprintf+0x47>
  800842:	85 d2                	test   %edx,%edx
  800844:	7e 22                	jle    800868 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800846:	ff 75 14             	pushl  0x14(%ebp)
  800849:	ff 75 10             	pushl  0x10(%ebp)
  80084c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084f:	50                   	push   %eax
  800850:	68 e6 02 80 00       	push   $0x8002e6
  800855:	e8 c6 fa ff ff       	call   800320 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80085a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800863:	83 c4 10             	add    $0x10,%esp
}
  800866:	c9                   	leave  
  800867:	c3                   	ret    
		return -E_INVAL;
  800868:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80086d:	eb f7                	jmp    800866 <vsnprintf+0x45>

0080086f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800878:	50                   	push   %eax
  800879:	ff 75 10             	pushl  0x10(%ebp)
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	ff 75 08             	pushl  0x8(%ebp)
  800882:	e8 9a ff ff ff       	call   800821 <vsnprintf>
	va_end(ap);

	return rc;
}
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088f:	b8 00 00 00 00       	mov    $0x0,%eax
  800894:	eb 03                	jmp    800899 <strlen+0x10>
		n++;
  800896:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800899:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80089d:	75 f7                	jne    800896 <strlen+0xd>
	return n;
}
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8008af:	eb 03                	jmp    8008b4 <strnlen+0x13>
		n++;
  8008b1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b4:	39 d0                	cmp    %edx,%eax
  8008b6:	74 06                	je     8008be <strnlen+0x1d>
  8008b8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008bc:	75 f3                	jne    8008b1 <strnlen+0x10>
	return n;
}
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008ca:	89 c2                	mov    %eax,%edx
  8008cc:	83 c1 01             	add    $0x1,%ecx
  8008cf:	83 c2 01             	add    $0x1,%edx
  8008d2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008d6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008d9:	84 db                	test   %bl,%bl
  8008db:	75 ef                	jne    8008cc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008dd:	5b                   	pop    %ebx
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	53                   	push   %ebx
  8008e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e7:	53                   	push   %ebx
  8008e8:	e8 9c ff ff ff       	call   800889 <strlen>
  8008ed:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	50                   	push   %eax
  8008f6:	e8 c5 ff ff ff       	call   8008c0 <strcpy>
	return dst;
}
  8008fb:	89 d8                	mov    %ebx,%eax
  8008fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	56                   	push   %esi
  800906:	53                   	push   %ebx
  800907:	8b 75 08             	mov    0x8(%ebp),%esi
  80090a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090d:	89 f3                	mov    %esi,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800912:	89 f2                	mov    %esi,%edx
  800914:	eb 0f                	jmp    800925 <strncpy+0x23>
		*dst++ = *src;
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	0f b6 01             	movzbl (%ecx),%eax
  80091c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091f:	80 39 01             	cmpb   $0x1,(%ecx)
  800922:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800925:	39 da                	cmp    %ebx,%edx
  800927:	75 ed                	jne    800916 <strncpy+0x14>
	}
	return ret;
}
  800929:	89 f0                	mov    %esi,%eax
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 75 08             	mov    0x8(%ebp),%esi
  800937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80093d:	89 f0                	mov    %esi,%eax
  80093f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800943:	85 c9                	test   %ecx,%ecx
  800945:	75 0b                	jne    800952 <strlcpy+0x23>
  800947:	eb 17                	jmp    800960 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800949:	83 c2 01             	add    $0x1,%edx
  80094c:	83 c0 01             	add    $0x1,%eax
  80094f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800952:	39 d8                	cmp    %ebx,%eax
  800954:	74 07                	je     80095d <strlcpy+0x2e>
  800956:	0f b6 0a             	movzbl (%edx),%ecx
  800959:	84 c9                	test   %cl,%cl
  80095b:	75 ec                	jne    800949 <strlcpy+0x1a>
		*dst = '\0';
  80095d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800960:	29 f0                	sub    %esi,%eax
}
  800962:	5b                   	pop    %ebx
  800963:	5e                   	pop    %esi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096f:	eb 06                	jmp    800977 <strcmp+0x11>
		p++, q++;
  800971:	83 c1 01             	add    $0x1,%ecx
  800974:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800977:	0f b6 01             	movzbl (%ecx),%eax
  80097a:	84 c0                	test   %al,%al
  80097c:	74 04                	je     800982 <strcmp+0x1c>
  80097e:	3a 02                	cmp    (%edx),%al
  800980:	74 ef                	je     800971 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800982:	0f b6 c0             	movzbl %al,%eax
  800985:	0f b6 12             	movzbl (%edx),%edx
  800988:	29 d0                	sub    %edx,%eax
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	89 c3                	mov    %eax,%ebx
  800998:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80099b:	eb 06                	jmp    8009a3 <strncmp+0x17>
		n--, p++, q++;
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a3:	39 d8                	cmp    %ebx,%eax
  8009a5:	74 16                	je     8009bd <strncmp+0x31>
  8009a7:	0f b6 08             	movzbl (%eax),%ecx
  8009aa:	84 c9                	test   %cl,%cl
  8009ac:	74 04                	je     8009b2 <strncmp+0x26>
  8009ae:	3a 0a                	cmp    (%edx),%cl
  8009b0:	74 eb                	je     80099d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b2:	0f b6 00             	movzbl (%eax),%eax
  8009b5:	0f b6 12             	movzbl (%edx),%edx
  8009b8:	29 d0                	sub    %edx,%eax
}
  8009ba:	5b                   	pop    %ebx
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    
		return 0;
  8009bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c2:	eb f6                	jmp    8009ba <strncmp+0x2e>

008009c4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ce:	0f b6 10             	movzbl (%eax),%edx
  8009d1:	84 d2                	test   %dl,%dl
  8009d3:	74 09                	je     8009de <strchr+0x1a>
		if (*s == c)
  8009d5:	38 ca                	cmp    %cl,%dl
  8009d7:	74 0a                	je     8009e3 <strchr+0x1f>
	for (; *s; s++)
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	eb f0                	jmp    8009ce <strchr+0xa>
			return (char *) s;
	return 0;
  8009de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ef:	eb 03                	jmp    8009f4 <strfind+0xf>
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f7:	38 ca                	cmp    %cl,%dl
  8009f9:	74 04                	je     8009ff <strfind+0x1a>
  8009fb:	84 d2                	test   %dl,%dl
  8009fd:	75 f2                	jne    8009f1 <strfind+0xc>
			break;
	return (char *) s;
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	57                   	push   %edi
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0d:	85 c9                	test   %ecx,%ecx
  800a0f:	74 13                	je     800a24 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a11:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a17:	75 05                	jne    800a1e <memset+0x1d>
  800a19:	f6 c1 03             	test   $0x3,%cl
  800a1c:	74 0d                	je     800a2b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	fc                   	cld    
  800a22:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a24:	89 f8                	mov    %edi,%eax
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5f                   	pop    %edi
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    
		c &= 0xFF;
  800a2b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2f:	89 d3                	mov    %edx,%ebx
  800a31:	c1 e3 08             	shl    $0x8,%ebx
  800a34:	89 d0                	mov    %edx,%eax
  800a36:	c1 e0 18             	shl    $0x18,%eax
  800a39:	89 d6                	mov    %edx,%esi
  800a3b:	c1 e6 10             	shl    $0x10,%esi
  800a3e:	09 f0                	or     %esi,%eax
  800a40:	09 c2                	or     %eax,%edx
  800a42:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a44:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	fc                   	cld    
  800a4a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a4c:	eb d6                	jmp    800a24 <memset+0x23>

00800a4e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	57                   	push   %edi
  800a52:	56                   	push   %esi
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a5c:	39 c6                	cmp    %eax,%esi
  800a5e:	73 35                	jae    800a95 <memmove+0x47>
  800a60:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a63:	39 c2                	cmp    %eax,%edx
  800a65:	76 2e                	jbe    800a95 <memmove+0x47>
		s += n;
		d += n;
  800a67:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6a:	89 d6                	mov    %edx,%esi
  800a6c:	09 fe                	or     %edi,%esi
  800a6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a74:	74 0c                	je     800a82 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a76:	83 ef 01             	sub    $0x1,%edi
  800a79:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a7c:	fd                   	std    
  800a7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7f:	fc                   	cld    
  800a80:	eb 21                	jmp    800aa3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a82:	f6 c1 03             	test   $0x3,%cl
  800a85:	75 ef                	jne    800a76 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a87:	83 ef 04             	sub    $0x4,%edi
  800a8a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a8d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a90:	fd                   	std    
  800a91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a93:	eb ea                	jmp    800a7f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a95:	89 f2                	mov    %esi,%edx
  800a97:	09 c2                	or     %eax,%edx
  800a99:	f6 c2 03             	test   $0x3,%dl
  800a9c:	74 09                	je     800aa7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a9e:	89 c7                	mov    %eax,%edi
  800aa0:	fc                   	cld    
  800aa1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa3:	5e                   	pop    %esi
  800aa4:	5f                   	pop    %edi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa7:	f6 c1 03             	test   $0x3,%cl
  800aaa:	75 f2                	jne    800a9e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aaf:	89 c7                	mov    %eax,%edi
  800ab1:	fc                   	cld    
  800ab2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab4:	eb ed                	jmp    800aa3 <memmove+0x55>

00800ab6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ab9:	ff 75 10             	pushl  0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 87 ff ff ff       	call   800a4e <memmove>
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad4:	89 c6                	mov    %eax,%esi
  800ad6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad9:	39 f0                	cmp    %esi,%eax
  800adb:	74 1c                	je     800af9 <memcmp+0x30>
		if (*s1 != *s2)
  800add:	0f b6 08             	movzbl (%eax),%ecx
  800ae0:	0f b6 1a             	movzbl (%edx),%ebx
  800ae3:	38 d9                	cmp    %bl,%cl
  800ae5:	75 08                	jne    800aef <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae7:	83 c0 01             	add    $0x1,%eax
  800aea:	83 c2 01             	add    $0x1,%edx
  800aed:	eb ea                	jmp    800ad9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aef:	0f b6 c1             	movzbl %cl,%eax
  800af2:	0f b6 db             	movzbl %bl,%ebx
  800af5:	29 d8                	sub    %ebx,%eax
  800af7:	eb 05                	jmp    800afe <memcmp+0x35>
	}

	return 0;
  800af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b0b:	89 c2                	mov    %eax,%edx
  800b0d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b10:	39 d0                	cmp    %edx,%eax
  800b12:	73 09                	jae    800b1d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b14:	38 08                	cmp    %cl,(%eax)
  800b16:	74 05                	je     800b1d <memfind+0x1b>
	for (; s < ends; s++)
  800b18:	83 c0 01             	add    $0x1,%eax
  800b1b:	eb f3                	jmp    800b10 <memfind+0xe>
			break;
	return (void *) s;
}
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	57                   	push   %edi
  800b23:	56                   	push   %esi
  800b24:	53                   	push   %ebx
  800b25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b2b:	eb 03                	jmp    800b30 <strtol+0x11>
		s++;
  800b2d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b30:	0f b6 01             	movzbl (%ecx),%eax
  800b33:	3c 20                	cmp    $0x20,%al
  800b35:	74 f6                	je     800b2d <strtol+0xe>
  800b37:	3c 09                	cmp    $0x9,%al
  800b39:	74 f2                	je     800b2d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b3b:	3c 2b                	cmp    $0x2b,%al
  800b3d:	74 2e                	je     800b6d <strtol+0x4e>
	int neg = 0;
  800b3f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b44:	3c 2d                	cmp    $0x2d,%al
  800b46:	74 2f                	je     800b77 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b48:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b4e:	75 05                	jne    800b55 <strtol+0x36>
  800b50:	80 39 30             	cmpb   $0x30,(%ecx)
  800b53:	74 2c                	je     800b81 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b55:	85 db                	test   %ebx,%ebx
  800b57:	75 0a                	jne    800b63 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b59:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b5e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b61:	74 28                	je     800b8b <strtol+0x6c>
		base = 10;
  800b63:	b8 00 00 00 00       	mov    $0x0,%eax
  800b68:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b6b:	eb 50                	jmp    800bbd <strtol+0x9e>
		s++;
  800b6d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
  800b75:	eb d1                	jmp    800b48 <strtol+0x29>
		s++, neg = 1;
  800b77:	83 c1 01             	add    $0x1,%ecx
  800b7a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b7f:	eb c7                	jmp    800b48 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b85:	74 0e                	je     800b95 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	75 d8                	jne    800b63 <strtol+0x44>
		s++, base = 8;
  800b8b:	83 c1 01             	add    $0x1,%ecx
  800b8e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b93:	eb ce                	jmp    800b63 <strtol+0x44>
		s += 2, base = 16;
  800b95:	83 c1 02             	add    $0x2,%ecx
  800b98:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b9d:	eb c4                	jmp    800b63 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b9f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ba2:	89 f3                	mov    %esi,%ebx
  800ba4:	80 fb 19             	cmp    $0x19,%bl
  800ba7:	77 29                	ja     800bd2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ba9:	0f be d2             	movsbl %dl,%edx
  800bac:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800baf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bb2:	7d 30                	jge    800be4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bb4:	83 c1 01             	add    $0x1,%ecx
  800bb7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bbb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bbd:	0f b6 11             	movzbl (%ecx),%edx
  800bc0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bc3:	89 f3                	mov    %esi,%ebx
  800bc5:	80 fb 09             	cmp    $0x9,%bl
  800bc8:	77 d5                	ja     800b9f <strtol+0x80>
			dig = *s - '0';
  800bca:	0f be d2             	movsbl %dl,%edx
  800bcd:	83 ea 30             	sub    $0x30,%edx
  800bd0:	eb dd                	jmp    800baf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bd2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bd5:	89 f3                	mov    %esi,%ebx
  800bd7:	80 fb 19             	cmp    $0x19,%bl
  800bda:	77 08                	ja     800be4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bdc:	0f be d2             	movsbl %dl,%edx
  800bdf:	83 ea 37             	sub    $0x37,%edx
  800be2:	eb cb                	jmp    800baf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be8:	74 05                	je     800bef <strtol+0xd0>
		*endptr = (char *) s;
  800bea:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bed:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bef:	89 c2                	mov    %eax,%edx
  800bf1:	f7 da                	neg    %edx
  800bf3:	85 ff                	test   %edi,%edi
  800bf5:	0f 45 c2             	cmovne %edx,%eax
}
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5f                   	pop    %edi
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c03:	b8 00 00 00 00       	mov    $0x0,%eax
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	89 c3                	mov    %eax,%ebx
  800c10:	89 c7                	mov    %eax,%edi
  800c12:	89 c6                	mov    %eax,%esi
  800c14:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5f                   	pop    %edi
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    

00800c1b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c21:	ba 00 00 00 00       	mov    $0x0,%edx
  800c26:	b8 01 00 00 00       	mov    $0x1,%eax
  800c2b:	89 d1                	mov    %edx,%ecx
  800c2d:	89 d3                	mov    %edx,%ebx
  800c2f:	89 d7                	mov    %edx,%edi
  800c31:	89 d6                	mov    %edx,%esi
  800c33:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c43:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	89 cb                	mov    %ecx,%ebx
  800c52:	89 cf                	mov    %ecx,%edi
  800c54:	89 ce                	mov    %ecx,%esi
  800c56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	7f 08                	jg     800c64 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c64:	83 ec 0c             	sub    $0xc,%esp
  800c67:	50                   	push   %eax
  800c68:	6a 03                	push   $0x3
  800c6a:	68 ff 2a 80 00       	push   $0x802aff
  800c6f:	6a 23                	push   $0x23
  800c71:	68 1c 2b 80 00       	push   $0x802b1c
  800c76:	e8 cd f4 ff ff       	call   800148 <_panic>

00800c7b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c81:	ba 00 00 00 00       	mov    $0x0,%edx
  800c86:	b8 02 00 00 00       	mov    $0x2,%eax
  800c8b:	89 d1                	mov    %edx,%ecx
  800c8d:	89 d3                	mov    %edx,%ebx
  800c8f:	89 d7                	mov    %edx,%edi
  800c91:	89 d6                	mov    %edx,%esi
  800c93:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <sys_yield>:

void
sys_yield(void)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800caa:	89 d1                	mov    %edx,%ecx
  800cac:	89 d3                	mov    %edx,%ebx
  800cae:	89 d7                	mov    %edx,%edi
  800cb0:	89 d6                	mov    %edx,%esi
  800cb2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
  800cbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc2:	be 00 00 00 00       	mov    $0x0,%esi
  800cc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccd:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd5:	89 f7                	mov    %esi,%edi
  800cd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7f 08                	jg     800ce5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	83 ec 0c             	sub    $0xc,%esp
  800ce8:	50                   	push   %eax
  800ce9:	6a 04                	push   $0x4
  800ceb:	68 ff 2a 80 00       	push   $0x802aff
  800cf0:	6a 23                	push   $0x23
  800cf2:	68 1c 2b 80 00       	push   $0x802b1c
  800cf7:	e8 4c f4 ff ff       	call   800148 <_panic>

00800cfc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d10:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d13:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d16:	8b 75 18             	mov    0x18(%ebp),%esi
  800d19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	7f 08                	jg     800d27 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	83 ec 0c             	sub    $0xc,%esp
  800d2a:	50                   	push   %eax
  800d2b:	6a 05                	push   $0x5
  800d2d:	68 ff 2a 80 00       	push   $0x802aff
  800d32:	6a 23                	push   $0x23
  800d34:	68 1c 2b 80 00       	push   $0x802b1c
  800d39:	e8 0a f4 ff ff       	call   800148 <_panic>

00800d3e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	57                   	push   %edi
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d52:	b8 06 00 00 00       	mov    $0x6,%eax
  800d57:	89 df                	mov    %ebx,%edi
  800d59:	89 de                	mov    %ebx,%esi
  800d5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 06                	push   $0x6
  800d6f:	68 ff 2a 80 00       	push   $0x802aff
  800d74:	6a 23                	push   $0x23
  800d76:	68 1c 2b 80 00       	push   $0x802b1c
  800d7b:	e8 c8 f3 ff ff       	call   800148 <_panic>

00800d80 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	b8 08 00 00 00       	mov    $0x8,%eax
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	89 de                	mov    %ebx,%esi
  800d9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 08                	push   $0x8
  800db1:	68 ff 2a 80 00       	push   $0x802aff
  800db6:	6a 23                	push   $0x23
  800db8:	68 1c 2b 80 00       	push   $0x802b1c
  800dbd:	e8 86 f3 ff ff       	call   800148 <_panic>

00800dc2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 09 00 00 00       	mov    $0x9,%eax
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800df1:	6a 09                	push   $0x9
  800df3:	68 ff 2a 80 00       	push   $0x802aff
  800df8:	6a 23                	push   $0x23
  800dfa:	68 1c 2b 80 00       	push   $0x802b1c
  800dff:	e8 44 f3 ff ff       	call   800148 <_panic>

00800e04 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e1d:	89 df                	mov    %ebx,%edi
  800e1f:	89 de                	mov    %ebx,%esi
  800e21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7f 08                	jg     800e2f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800e33:	6a 0a                	push   $0xa
  800e35:	68 ff 2a 80 00       	push   $0x802aff
  800e3a:	6a 23                	push   $0x23
  800e3c:	68 1c 2b 80 00       	push   $0x802b1c
  800e41:	e8 02 f3 ff ff       	call   800148 <_panic>

00800e46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e57:	be 00 00 00 00       	mov    $0x0,%esi
  800e5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e62:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 0d                	push   $0xd
  800e99:	68 ff 2a 80 00       	push   $0x802aff
  800e9e:	6a 23                	push   $0x23
  800ea0:	68 1c 2b 80 00       	push   $0x802b1c
  800ea5:	e8 9e f2 ff ff       	call   800148 <_panic>

00800eaa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eba:	89 d1                	mov    %edx,%ecx
  800ebc:	89 d3                	mov    %edx,%ebx
  800ebe:	89 d7                	mov    %edx,%edi
  800ec0:	89 d6                	mov    %edx,%esi
  800ec2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 1c             	sub    $0x1c,%esp
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800ed5:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800ed7:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800eda:	89 d8                	mov    %ebx,%eax
  800edc:	c1 e8 0c             	shr    $0xc,%eax
  800edf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ee6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800ee9:	e8 8d fd ff ff       	call   800c7b <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800eee:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800ef4:	74 73                	je     800f69 <pgfault+0xa0>
  800ef6:	89 c6                	mov    %eax,%esi
  800ef8:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800eff:	74 68                	je     800f69 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800f01:	83 ec 04             	sub    $0x4,%esp
  800f04:	6a 07                	push   $0x7
  800f06:	68 00 f0 7f 00       	push   $0x7ff000
  800f0b:	50                   	push   %eax
  800f0c:	e8 a8 fd ff ff       	call   800cb9 <sys_page_alloc>
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	85 c0                	test   %eax,%eax
  800f16:	75 65                	jne    800f7d <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	68 00 10 00 00       	push   $0x1000
  800f26:	53                   	push   %ebx
  800f27:	68 00 f0 7f 00       	push   $0x7ff000
  800f2c:	e8 85 fb ff ff       	call   800ab6 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800f31:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f38:	53                   	push   %ebx
  800f39:	56                   	push   %esi
  800f3a:	68 00 f0 7f 00       	push   $0x7ff000
  800f3f:	56                   	push   %esi
  800f40:	e8 b7 fd ff ff       	call   800cfc <sys_page_map>
  800f45:	83 c4 20             	add    $0x20,%esp
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 43                	jne    800f8f <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	68 00 f0 7f 00       	push   $0x7ff000
  800f54:	56                   	push   %esi
  800f55:	e8 e4 fd ff ff       	call   800d3e <sys_page_unmap>
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	75 40                	jne    800fa1 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800f69:	83 ec 04             	sub    $0x4,%esp
  800f6c:	68 2a 2b 80 00       	push   $0x802b2a
  800f71:	6a 1f                	push   $0x1f
  800f73:	68 48 2b 80 00       	push   $0x802b48
  800f78:	e8 cb f1 ff ff       	call   800148 <_panic>
	    panic("pgfault: %e", r);
  800f7d:	50                   	push   %eax
  800f7e:	68 53 2b 80 00       	push   $0x802b53
  800f83:	6a 2a                	push   $0x2a
  800f85:	68 48 2b 80 00       	push   $0x802b48
  800f8a:	e8 b9 f1 ff ff       	call   800148 <_panic>
	    panic("pgfault: %e", r);
  800f8f:	50                   	push   %eax
  800f90:	68 53 2b 80 00       	push   $0x802b53
  800f95:	6a 2e                	push   $0x2e
  800f97:	68 48 2b 80 00       	push   $0x802b48
  800f9c:	e8 a7 f1 ff ff       	call   800148 <_panic>
	    panic("pgfault: %e", r);
  800fa1:	50                   	push   %eax
  800fa2:	68 53 2b 80 00       	push   $0x802b53
  800fa7:	6a 31                	push   $0x31
  800fa9:	68 48 2b 80 00       	push   $0x802b48
  800fae:	e8 95 f1 ff ff       	call   800148 <_panic>

00800fb3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
  800fb9:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  800fbc:	68 c9 0e 80 00       	push   $0x800ec9
  800fc1:	e8 8e 13 00 00       	call   802354 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fc6:	b8 07 00 00 00       	mov    $0x7,%eax
  800fcb:	cd 30                	int    $0x30
  800fcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 2b                	js     801005 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fda:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fe3:	0f 85 b5 00 00 00    	jne    80109e <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  800fe9:	e8 8d fc ff ff       	call   800c7b <sys_getenvid>
  800fee:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ff3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ff6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ffb:	a3 0c 40 80 00       	mov    %eax,0x80400c
	    return 0;
  801000:	e9 8c 01 00 00       	jmp    801191 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  801005:	50                   	push   %eax
  801006:	68 5f 2b 80 00       	push   $0x802b5f
  80100b:	6a 77                	push   $0x77
  80100d:	68 48 2b 80 00       	push   $0x802b48
  801012:	e8 31 f1 ff ff       	call   800148 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801017:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80101e:	83 ec 0c             	sub    $0xc,%esp
  801021:	25 07 0e 00 00       	and    $0xe07,%eax
  801026:	50                   	push   %eax
  801027:	57                   	push   %edi
  801028:	ff 75 e0             	pushl  -0x20(%ebp)
  80102b:	57                   	push   %edi
  80102c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80102f:	e8 c8 fc ff ff       	call   800cfc <sys_page_map>
  801034:	83 c4 20             	add    $0x20,%esp
  801037:	85 c0                	test   %eax,%eax
  801039:	74 51                	je     80108c <fork+0xd9>
           panic("duppage: %e", r);
  80103b:	50                   	push   %eax
  80103c:	68 6f 2b 80 00       	push   $0x802b6f
  801041:	6a 4a                	push   $0x4a
  801043:	68 48 2b 80 00       	push   $0x802b48
  801048:	e8 fb f0 ff ff       	call   800148 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	68 05 08 00 00       	push   $0x805
  801055:	57                   	push   %edi
  801056:	ff 75 e0             	pushl  -0x20(%ebp)
  801059:	57                   	push   %edi
  80105a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105d:	e8 9a fc ff ff       	call   800cfc <sys_page_map>
  801062:	83 c4 20             	add    $0x20,%esp
  801065:	85 c0                	test   %eax,%eax
  801067:	0f 85 bc 00 00 00    	jne    801129 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80106d:	83 ec 0c             	sub    $0xc,%esp
  801070:	68 05 08 00 00       	push   $0x805
  801075:	57                   	push   %edi
  801076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801079:	50                   	push   %eax
  80107a:	57                   	push   %edi
  80107b:	50                   	push   %eax
  80107c:	e8 7b fc ff ff       	call   800cfc <sys_page_map>
  801081:	83 c4 20             	add    $0x20,%esp
  801084:	85 c0                	test   %eax,%eax
  801086:	0f 85 af 00 00 00    	jne    80113b <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80108c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801092:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801098:	0f 84 af 00 00 00    	je     80114d <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  80109e:	89 d8                	mov    %ebx,%eax
  8010a0:	c1 e8 16             	shr    $0x16,%eax
  8010a3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010aa:	a8 01                	test   $0x1,%al
  8010ac:	74 de                	je     80108c <fork+0xd9>
  8010ae:	89 de                	mov    %ebx,%esi
  8010b0:	c1 ee 0c             	shr    $0xc,%esi
  8010b3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010ba:	a8 01                	test   $0x1,%al
  8010bc:	74 ce                	je     80108c <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8010be:	e8 b8 fb ff ff       	call   800c7b <sys_getenvid>
  8010c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8010c6:	89 f7                	mov    %esi,%edi
  8010c8:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8010cb:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010d2:	f6 c4 04             	test   $0x4,%ah
  8010d5:	0f 85 3c ff ff ff    	jne    801017 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8010db:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010e2:	a8 02                	test   $0x2,%al
  8010e4:	0f 85 63 ff ff ff    	jne    80104d <fork+0x9a>
  8010ea:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f1:	f6 c4 08             	test   $0x8,%ah
  8010f4:	0f 85 53 ff ff ff    	jne    80104d <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	6a 05                	push   $0x5
  8010ff:	57                   	push   %edi
  801100:	ff 75 e0             	pushl  -0x20(%ebp)
  801103:	57                   	push   %edi
  801104:	ff 75 e4             	pushl  -0x1c(%ebp)
  801107:	e8 f0 fb ff ff       	call   800cfc <sys_page_map>
  80110c:	83 c4 20             	add    $0x20,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	0f 84 75 ff ff ff    	je     80108c <fork+0xd9>
	        panic("duppage: %e", r);
  801117:	50                   	push   %eax
  801118:	68 6f 2b 80 00       	push   $0x802b6f
  80111d:	6a 55                	push   $0x55
  80111f:	68 48 2b 80 00       	push   $0x802b48
  801124:	e8 1f f0 ff ff       	call   800148 <_panic>
	        panic("duppage: %e", r);
  801129:	50                   	push   %eax
  80112a:	68 6f 2b 80 00       	push   $0x802b6f
  80112f:	6a 4e                	push   $0x4e
  801131:	68 48 2b 80 00       	push   $0x802b48
  801136:	e8 0d f0 ff ff       	call   800148 <_panic>
	        panic("duppage: %e", r);
  80113b:	50                   	push   %eax
  80113c:	68 6f 2b 80 00       	push   $0x802b6f
  801141:	6a 51                	push   $0x51
  801143:	68 48 2b 80 00       	push   $0x802b48
  801148:	e8 fb ef ff ff       	call   800148 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	6a 07                	push   $0x7
  801152:	68 00 f0 bf ee       	push   $0xeebff000
  801157:	ff 75 dc             	pushl  -0x24(%ebp)
  80115a:	e8 5a fb ff ff       	call   800cb9 <sys_page_alloc>
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	75 36                	jne    80119c <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801166:	83 ec 08             	sub    $0x8,%esp
  801169:	68 cd 23 80 00       	push   $0x8023cd
  80116e:	ff 75 dc             	pushl  -0x24(%ebp)
  801171:	e8 8e fc ff ff       	call   800e04 <sys_env_set_pgfault_upcall>
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	75 34                	jne    8011b1 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  80117d:	83 ec 08             	sub    $0x8,%esp
  801180:	6a 02                	push   $0x2
  801182:	ff 75 dc             	pushl  -0x24(%ebp)
  801185:	e8 f6 fb ff ff       	call   800d80 <sys_env_set_status>
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 35                	jne    8011c6 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801191:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    
	    panic("fork: %e", r);
  80119c:	50                   	push   %eax
  80119d:	68 66 2b 80 00       	push   $0x802b66
  8011a2:	68 8a 00 00 00       	push   $0x8a
  8011a7:	68 48 2b 80 00       	push   $0x802b48
  8011ac:	e8 97 ef ff ff       	call   800148 <_panic>
	    panic("fork: %e", r);
  8011b1:	50                   	push   %eax
  8011b2:	68 66 2b 80 00       	push   $0x802b66
  8011b7:	68 8d 00 00 00       	push   $0x8d
  8011bc:	68 48 2b 80 00       	push   $0x802b48
  8011c1:	e8 82 ef ff ff       	call   800148 <_panic>
	    panic("fork: %e", r);
  8011c6:	50                   	push   %eax
  8011c7:	68 66 2b 80 00       	push   $0x802b66
  8011cc:	68 92 00 00 00       	push   $0x92
  8011d1:	68 48 2b 80 00       	push   $0x802b48
  8011d6:	e8 6d ef ff ff       	call   800148 <_panic>

008011db <sfork>:

// Challenge!
int
sfork(void)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011e1:	68 7b 2b 80 00       	push   $0x802b7b
  8011e6:	68 9b 00 00 00       	push   $0x9b
  8011eb:	68 48 2b 80 00       	push   $0x802b48
  8011f0:	e8 53 ef ff ff       	call   800148 <_panic>

008011f5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	05 00 00 00 30       	add    $0x30000000,%eax
  801200:	c1 e8 0c             	shr    $0xc,%eax
}
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801210:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801215:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801222:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801227:	89 c2                	mov    %eax,%edx
  801229:	c1 ea 16             	shr    $0x16,%edx
  80122c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801233:	f6 c2 01             	test   $0x1,%dl
  801236:	74 2a                	je     801262 <fd_alloc+0x46>
  801238:	89 c2                	mov    %eax,%edx
  80123a:	c1 ea 0c             	shr    $0xc,%edx
  80123d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801244:	f6 c2 01             	test   $0x1,%dl
  801247:	74 19                	je     801262 <fd_alloc+0x46>
  801249:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80124e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801253:	75 d2                	jne    801227 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801255:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80125b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801260:	eb 07                	jmp    801269 <fd_alloc+0x4d>
			*fd_store = fd;
  801262:	89 01                	mov    %eax,(%ecx)
			return 0;
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801271:	83 f8 1f             	cmp    $0x1f,%eax
  801274:	77 36                	ja     8012ac <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801276:	c1 e0 0c             	shl    $0xc,%eax
  801279:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80127e:	89 c2                	mov    %eax,%edx
  801280:	c1 ea 16             	shr    $0x16,%edx
  801283:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80128a:	f6 c2 01             	test   $0x1,%dl
  80128d:	74 24                	je     8012b3 <fd_lookup+0x48>
  80128f:	89 c2                	mov    %eax,%edx
  801291:	c1 ea 0c             	shr    $0xc,%edx
  801294:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129b:	f6 c2 01             	test   $0x1,%dl
  80129e:	74 1a                	je     8012ba <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a3:	89 02                	mov    %eax,(%edx)
	return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    
		return -E_INVAL;
  8012ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b1:	eb f7                	jmp    8012aa <fd_lookup+0x3f>
		return -E_INVAL;
  8012b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b8:	eb f0                	jmp    8012aa <fd_lookup+0x3f>
  8012ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bf:	eb e9                	jmp    8012aa <fd_lookup+0x3f>

008012c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ca:	ba 10 2c 80 00       	mov    $0x802c10,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012cf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012d4:	39 08                	cmp    %ecx,(%eax)
  8012d6:	74 33                	je     80130b <dev_lookup+0x4a>
  8012d8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012db:	8b 02                	mov    (%edx),%eax
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	75 f3                	jne    8012d4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012e1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012e6:	8b 40 48             	mov    0x48(%eax),%eax
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	51                   	push   %ecx
  8012ed:	50                   	push   %eax
  8012ee:	68 94 2b 80 00       	push   $0x802b94
  8012f3:	e8 2b ef ff ff       	call   800223 <cprintf>
	*dev = 0;
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    
			*dev = devtab[i];
  80130b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
  801315:	eb f2                	jmp    801309 <dev_lookup+0x48>

00801317 <fd_close>:
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	57                   	push   %edi
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
  80131d:	83 ec 1c             	sub    $0x1c,%esp
  801320:	8b 75 08             	mov    0x8(%ebp),%esi
  801323:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801326:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801329:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80132a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801330:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801333:	50                   	push   %eax
  801334:	e8 32 ff ff ff       	call   80126b <fd_lookup>
  801339:	89 c3                	mov    %eax,%ebx
  80133b:	83 c4 08             	add    $0x8,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 05                	js     801347 <fd_close+0x30>
	    || fd != fd2)
  801342:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801345:	74 16                	je     80135d <fd_close+0x46>
		return (must_exist ? r : 0);
  801347:	89 f8                	mov    %edi,%eax
  801349:	84 c0                	test   %al,%al
  80134b:	b8 00 00 00 00       	mov    $0x0,%eax
  801350:	0f 44 d8             	cmove  %eax,%ebx
}
  801353:	89 d8                	mov    %ebx,%eax
  801355:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801358:	5b                   	pop    %ebx
  801359:	5e                   	pop    %esi
  80135a:	5f                   	pop    %edi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	ff 36                	pushl  (%esi)
  801366:	e8 56 ff ff ff       	call   8012c1 <dev_lookup>
  80136b:	89 c3                	mov    %eax,%ebx
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	78 15                	js     801389 <fd_close+0x72>
		if (dev->dev_close)
  801374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801377:	8b 40 10             	mov    0x10(%eax),%eax
  80137a:	85 c0                	test   %eax,%eax
  80137c:	74 1b                	je     801399 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	56                   	push   %esi
  801382:	ff d0                	call   *%eax
  801384:	89 c3                	mov    %eax,%ebx
  801386:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	56                   	push   %esi
  80138d:	6a 00                	push   $0x0
  80138f:	e8 aa f9 ff ff       	call   800d3e <sys_page_unmap>
	return r;
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	eb ba                	jmp    801353 <fd_close+0x3c>
			r = 0;
  801399:	bb 00 00 00 00       	mov    $0x0,%ebx
  80139e:	eb e9                	jmp    801389 <fd_close+0x72>

008013a0 <close>:

int
close(int fdnum)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 b9 fe ff ff       	call   80126b <fd_lookup>
  8013b2:	83 c4 08             	add    $0x8,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 10                	js     8013c9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	6a 01                	push   $0x1
  8013be:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c1:	e8 51 ff ff ff       	call   801317 <fd_close>
  8013c6:	83 c4 10             	add    $0x10,%esp
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <close_all>:

void
close_all(void)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	53                   	push   %ebx
  8013db:	e8 c0 ff ff ff       	call   8013a0 <close>
	for (i = 0; i < MAXFD; i++)
  8013e0:	83 c3 01             	add    $0x1,%ebx
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	83 fb 20             	cmp    $0x20,%ebx
  8013e9:	75 ec                	jne    8013d7 <close_all+0xc>
}
  8013eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 66 fe ff ff       	call   80126b <fd_lookup>
  801405:	89 c3                	mov    %eax,%ebx
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	0f 88 81 00 00 00    	js     801493 <dup+0xa3>
		return r;
	close(newfdnum);
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	e8 83 ff ff ff       	call   8013a0 <close>

	newfd = INDEX2FD(newfdnum);
  80141d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801420:	c1 e6 0c             	shl    $0xc,%esi
  801423:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801429:	83 c4 04             	add    $0x4,%esp
  80142c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80142f:	e8 d1 fd ff ff       	call   801205 <fd2data>
  801434:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801436:	89 34 24             	mov    %esi,(%esp)
  801439:	e8 c7 fd ff ff       	call   801205 <fd2data>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801443:	89 d8                	mov    %ebx,%eax
  801445:	c1 e8 16             	shr    $0x16,%eax
  801448:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80144f:	a8 01                	test   $0x1,%al
  801451:	74 11                	je     801464 <dup+0x74>
  801453:	89 d8                	mov    %ebx,%eax
  801455:	c1 e8 0c             	shr    $0xc,%eax
  801458:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80145f:	f6 c2 01             	test   $0x1,%dl
  801462:	75 39                	jne    80149d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801464:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801467:	89 d0                	mov    %edx,%eax
  801469:	c1 e8 0c             	shr    $0xc,%eax
  80146c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801473:	83 ec 0c             	sub    $0xc,%esp
  801476:	25 07 0e 00 00       	and    $0xe07,%eax
  80147b:	50                   	push   %eax
  80147c:	56                   	push   %esi
  80147d:	6a 00                	push   $0x0
  80147f:	52                   	push   %edx
  801480:	6a 00                	push   $0x0
  801482:	e8 75 f8 ff ff       	call   800cfc <sys_page_map>
  801487:	89 c3                	mov    %eax,%ebx
  801489:	83 c4 20             	add    $0x20,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 31                	js     8014c1 <dup+0xd1>
		goto err;

	return newfdnum;
  801490:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801493:	89 d8                	mov    %ebx,%eax
  801495:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801498:	5b                   	pop    %ebx
  801499:	5e                   	pop    %esi
  80149a:	5f                   	pop    %edi
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80149d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014a4:	83 ec 0c             	sub    $0xc,%esp
  8014a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ac:	50                   	push   %eax
  8014ad:	57                   	push   %edi
  8014ae:	6a 00                	push   $0x0
  8014b0:	53                   	push   %ebx
  8014b1:	6a 00                	push   $0x0
  8014b3:	e8 44 f8 ff ff       	call   800cfc <sys_page_map>
  8014b8:	89 c3                	mov    %eax,%ebx
  8014ba:	83 c4 20             	add    $0x20,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	79 a3                	jns    801464 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014c1:	83 ec 08             	sub    $0x8,%esp
  8014c4:	56                   	push   %esi
  8014c5:	6a 00                	push   $0x0
  8014c7:	e8 72 f8 ff ff       	call   800d3e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014cc:	83 c4 08             	add    $0x8,%esp
  8014cf:	57                   	push   %edi
  8014d0:	6a 00                	push   $0x0
  8014d2:	e8 67 f8 ff ff       	call   800d3e <sys_page_unmap>
	return r;
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	eb b7                	jmp    801493 <dup+0xa3>

008014dc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 14             	sub    $0x14,%esp
  8014e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e9:	50                   	push   %eax
  8014ea:	53                   	push   %ebx
  8014eb:	e8 7b fd ff ff       	call   80126b <fd_lookup>
  8014f0:	83 c4 08             	add    $0x8,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 3f                	js     801536 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fd:	50                   	push   %eax
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	ff 30                	pushl  (%eax)
  801503:	e8 b9 fd ff ff       	call   8012c1 <dev_lookup>
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 27                	js     801536 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80150f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801512:	8b 42 08             	mov    0x8(%edx),%eax
  801515:	83 e0 03             	and    $0x3,%eax
  801518:	83 f8 01             	cmp    $0x1,%eax
  80151b:	74 1e                	je     80153b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801520:	8b 40 08             	mov    0x8(%eax),%eax
  801523:	85 c0                	test   %eax,%eax
  801525:	74 35                	je     80155c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	ff 75 10             	pushl  0x10(%ebp)
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	52                   	push   %edx
  801531:	ff d0                	call   *%eax
  801533:	83 c4 10             	add    $0x10,%esp
}
  801536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801539:	c9                   	leave  
  80153a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80153b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801540:	8b 40 48             	mov    0x48(%eax),%eax
  801543:	83 ec 04             	sub    $0x4,%esp
  801546:	53                   	push   %ebx
  801547:	50                   	push   %eax
  801548:	68 d5 2b 80 00       	push   $0x802bd5
  80154d:	e8 d1 ec ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155a:	eb da                	jmp    801536 <read+0x5a>
		return -E_NOT_SUPP;
  80155c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801561:	eb d3                	jmp    801536 <read+0x5a>

00801563 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	57                   	push   %edi
  801567:	56                   	push   %esi
  801568:	53                   	push   %ebx
  801569:	83 ec 0c             	sub    $0xc,%esp
  80156c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80156f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801572:	bb 00 00 00 00       	mov    $0x0,%ebx
  801577:	39 f3                	cmp    %esi,%ebx
  801579:	73 25                	jae    8015a0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	89 f0                	mov    %esi,%eax
  801580:	29 d8                	sub    %ebx,%eax
  801582:	50                   	push   %eax
  801583:	89 d8                	mov    %ebx,%eax
  801585:	03 45 0c             	add    0xc(%ebp),%eax
  801588:	50                   	push   %eax
  801589:	57                   	push   %edi
  80158a:	e8 4d ff ff ff       	call   8014dc <read>
		if (m < 0)
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 08                	js     80159e <readn+0x3b>
			return m;
		if (m == 0)
  801596:	85 c0                	test   %eax,%eax
  801598:	74 06                	je     8015a0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80159a:	01 c3                	add    %eax,%ebx
  80159c:	eb d9                	jmp    801577 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015a0:	89 d8                	mov    %ebx,%eax
  8015a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 14             	sub    $0x14,%esp
  8015b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b7:	50                   	push   %eax
  8015b8:	53                   	push   %ebx
  8015b9:	e8 ad fc ff ff       	call   80126b <fd_lookup>
  8015be:	83 c4 08             	add    $0x8,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 3a                	js     8015ff <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cb:	50                   	push   %eax
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	ff 30                	pushl  (%eax)
  8015d1:	e8 eb fc ff ff       	call   8012c1 <dev_lookup>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 22                	js     8015ff <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015e4:	74 1e                	je     801604 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ec:	85 d2                	test   %edx,%edx
  8015ee:	74 35                	je     801625 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	ff 75 10             	pushl  0x10(%ebp)
  8015f6:	ff 75 0c             	pushl  0xc(%ebp)
  8015f9:	50                   	push   %eax
  8015fa:	ff d2                	call   *%edx
  8015fc:	83 c4 10             	add    $0x10,%esp
}
  8015ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801602:	c9                   	leave  
  801603:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801604:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801609:	8b 40 48             	mov    0x48(%eax),%eax
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	53                   	push   %ebx
  801610:	50                   	push   %eax
  801611:	68 f1 2b 80 00       	push   $0x802bf1
  801616:	e8 08 ec ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801623:	eb da                	jmp    8015ff <write+0x55>
		return -E_NOT_SUPP;
  801625:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162a:	eb d3                	jmp    8015ff <write+0x55>

0080162c <seek>:

int
seek(int fdnum, off_t offset)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801632:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801635:	50                   	push   %eax
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 2d fc ff ff       	call   80126b <fd_lookup>
  80163e:	83 c4 08             	add    $0x8,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 0e                	js     801653 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80164e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	53                   	push   %ebx
  801659:	83 ec 14             	sub    $0x14,%esp
  80165c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801662:	50                   	push   %eax
  801663:	53                   	push   %ebx
  801664:	e8 02 fc ff ff       	call   80126b <fd_lookup>
  801669:	83 c4 08             	add    $0x8,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 37                	js     8016a7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	ff 30                	pushl  (%eax)
  80167c:	e8 40 fc ff ff       	call   8012c1 <dev_lookup>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 1f                	js     8016a7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80168f:	74 1b                	je     8016ac <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801691:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801694:	8b 52 18             	mov    0x18(%edx),%edx
  801697:	85 d2                	test   %edx,%edx
  801699:	74 32                	je     8016cd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	50                   	push   %eax
  8016a2:	ff d2                	call   *%edx
  8016a4:	83 c4 10             	add    $0x10,%esp
}
  8016a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016ac:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b1:	8b 40 48             	mov    0x48(%eax),%eax
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	53                   	push   %ebx
  8016b8:	50                   	push   %eax
  8016b9:	68 b4 2b 80 00       	push   $0x802bb4
  8016be:	e8 60 eb ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cb:	eb da                	jmp    8016a7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d2:	eb d3                	jmp    8016a7 <ftruncate+0x52>

008016d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	53                   	push   %ebx
  8016d8:	83 ec 14             	sub    $0x14,%esp
  8016db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e1:	50                   	push   %eax
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	e8 81 fb ff ff       	call   80126b <fd_lookup>
  8016ea:	83 c4 08             	add    $0x8,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 4b                	js     80173c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	ff 30                	pushl  (%eax)
  8016fd:	e8 bf fb ff ff       	call   8012c1 <dev_lookup>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 33                	js     80173c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801710:	74 2f                	je     801741 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801712:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801715:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80171c:	00 00 00 
	stat->st_isdir = 0;
  80171f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801726:	00 00 00 
	stat->st_dev = dev;
  801729:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	53                   	push   %ebx
  801733:	ff 75 f0             	pushl  -0x10(%ebp)
  801736:	ff 50 14             	call   *0x14(%eax)
  801739:	83 c4 10             	add    $0x10,%esp
}
  80173c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173f:	c9                   	leave  
  801740:	c3                   	ret    
		return -E_NOT_SUPP;
  801741:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801746:	eb f4                	jmp    80173c <fstat+0x68>

00801748 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	56                   	push   %esi
  80174c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	6a 00                	push   $0x0
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	e8 26 02 00 00       	call   801980 <open>
  80175a:	89 c3                	mov    %eax,%ebx
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 1b                	js     80177e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	50                   	push   %eax
  80176a:	e8 65 ff ff ff       	call   8016d4 <fstat>
  80176f:	89 c6                	mov    %eax,%esi
	close(fd);
  801771:	89 1c 24             	mov    %ebx,(%esp)
  801774:	e8 27 fc ff ff       	call   8013a0 <close>
	return r;
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	89 f3                	mov    %esi,%ebx
}
  80177e:	89 d8                	mov    %ebx,%eax
  801780:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    

00801787 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	56                   	push   %esi
  80178b:	53                   	push   %ebx
  80178c:	89 c6                	mov    %eax,%esi
  80178e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801790:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801797:	74 27                	je     8017c0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801799:	6a 07                	push   $0x7
  80179b:	68 00 50 80 00       	push   $0x805000
  8017a0:	56                   	push   %esi
  8017a1:	ff 35 00 40 80 00    	pushl  0x804000
  8017a7:	e8 b0 0c 00 00       	call   80245c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ac:	83 c4 0c             	add    $0xc,%esp
  8017af:	6a 00                	push   $0x0
  8017b1:	53                   	push   %ebx
  8017b2:	6a 00                	push   $0x0
  8017b4:	e8 3a 0c 00 00       	call   8023f3 <ipc_recv>
}
  8017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bc:	5b                   	pop    %ebx
  8017bd:	5e                   	pop    %esi
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017c0:	83 ec 0c             	sub    $0xc,%esp
  8017c3:	6a 01                	push   $0x1
  8017c5:	e8 eb 0c 00 00       	call   8024b5 <ipc_find_env>
  8017ca:	a3 00 40 80 00       	mov    %eax,0x804000
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	eb c5                	jmp    801799 <fsipc+0x12>

008017d4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f7:	e8 8b ff ff ff       	call   801787 <fsipc>
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <devfile_flush>:
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8b 40 0c             	mov    0xc(%eax),%eax
  80180a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80180f:	ba 00 00 00 00       	mov    $0x0,%edx
  801814:	b8 06 00 00 00       	mov    $0x6,%eax
  801819:	e8 69 ff ff ff       	call   801787 <fsipc>
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <devfile_stat>:
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	53                   	push   %ebx
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8b 40 0c             	mov    0xc(%eax),%eax
  801830:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801835:	ba 00 00 00 00       	mov    $0x0,%edx
  80183a:	b8 05 00 00 00       	mov    $0x5,%eax
  80183f:	e8 43 ff ff ff       	call   801787 <fsipc>
  801844:	85 c0                	test   %eax,%eax
  801846:	78 2c                	js     801874 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801848:	83 ec 08             	sub    $0x8,%esp
  80184b:	68 00 50 80 00       	push   $0x805000
  801850:	53                   	push   %ebx
  801851:	e8 6a f0 ff ff       	call   8008c0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801856:	a1 80 50 80 00       	mov    0x805080,%eax
  80185b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801861:	a1 84 50 80 00       	mov    0x805084,%eax
  801866:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <devfile_write>:
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	53                   	push   %ebx
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 40 0c             	mov    0xc(%eax),%eax
  801889:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80188e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801894:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80189a:	77 30                	ja     8018cc <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	53                   	push   %ebx
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	68 08 50 80 00       	push   $0x805008
  8018a8:	e8 a1 f1 ff ff       	call   800a4e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	b8 04 00 00 00       	mov    $0x4,%eax
  8018b7:	e8 cb fe ff ff       	call   801787 <fsipc>
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 04                	js     8018c7 <devfile_write+0x4e>
	assert(r <= n);
  8018c3:	39 d8                	cmp    %ebx,%eax
  8018c5:	77 1e                	ja     8018e5 <devfile_write+0x6c>
}
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8018cc:	68 24 2c 80 00       	push   $0x802c24
  8018d1:	68 54 2c 80 00       	push   $0x802c54
  8018d6:	68 94 00 00 00       	push   $0x94
  8018db:	68 69 2c 80 00       	push   $0x802c69
  8018e0:	e8 63 e8 ff ff       	call   800148 <_panic>
	assert(r <= n);
  8018e5:	68 74 2c 80 00       	push   $0x802c74
  8018ea:	68 54 2c 80 00       	push   $0x802c54
  8018ef:	68 98 00 00 00       	push   $0x98
  8018f4:	68 69 2c 80 00       	push   $0x802c69
  8018f9:	e8 4a e8 ff ff       	call   800148 <_panic>

008018fe <devfile_read>:
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8b 40 0c             	mov    0xc(%eax),%eax
  80190c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801911:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	b8 03 00 00 00       	mov    $0x3,%eax
  801921:	e8 61 fe ff ff       	call   801787 <fsipc>
  801926:	89 c3                	mov    %eax,%ebx
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 1f                	js     80194b <devfile_read+0x4d>
	assert(r <= n);
  80192c:	39 f0                	cmp    %esi,%eax
  80192e:	77 24                	ja     801954 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801930:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801935:	7f 33                	jg     80196a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801937:	83 ec 04             	sub    $0x4,%esp
  80193a:	50                   	push   %eax
  80193b:	68 00 50 80 00       	push   $0x805000
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	e8 06 f1 ff ff       	call   800a4e <memmove>
	return r;
  801948:	83 c4 10             	add    $0x10,%esp
}
  80194b:	89 d8                	mov    %ebx,%eax
  80194d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    
	assert(r <= n);
  801954:	68 74 2c 80 00       	push   $0x802c74
  801959:	68 54 2c 80 00       	push   $0x802c54
  80195e:	6a 7c                	push   $0x7c
  801960:	68 69 2c 80 00       	push   $0x802c69
  801965:	e8 de e7 ff ff       	call   800148 <_panic>
	assert(r <= PGSIZE);
  80196a:	68 7b 2c 80 00       	push   $0x802c7b
  80196f:	68 54 2c 80 00       	push   $0x802c54
  801974:	6a 7d                	push   $0x7d
  801976:	68 69 2c 80 00       	push   $0x802c69
  80197b:	e8 c8 e7 ff ff       	call   800148 <_panic>

00801980 <open>:
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
  801985:	83 ec 1c             	sub    $0x1c,%esp
  801988:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80198b:	56                   	push   %esi
  80198c:	e8 f8 ee ff ff       	call   800889 <strlen>
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801999:	7f 6c                	jg     801a07 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80199b:	83 ec 0c             	sub    $0xc,%esp
  80199e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a1:	50                   	push   %eax
  8019a2:	e8 75 f8 ff ff       	call   80121c <fd_alloc>
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 3c                	js     8019ec <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	56                   	push   %esi
  8019b4:	68 00 50 80 00       	push   $0x805000
  8019b9:	e8 02 ef ff ff       	call   8008c0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ce:	e8 b4 fd ff ff       	call   801787 <fsipc>
  8019d3:	89 c3                	mov    %eax,%ebx
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 19                	js     8019f5 <open+0x75>
	return fd2num(fd);
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e2:	e8 0e f8 ff ff       	call   8011f5 <fd2num>
  8019e7:	89 c3                	mov    %eax,%ebx
  8019e9:	83 c4 10             	add    $0x10,%esp
}
  8019ec:	89 d8                	mov    %ebx,%eax
  8019ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5e                   	pop    %esi
  8019f3:	5d                   	pop    %ebp
  8019f4:	c3                   	ret    
		fd_close(fd, 0);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fd:	e8 15 f9 ff ff       	call   801317 <fd_close>
		return r;
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	eb e5                	jmp    8019ec <open+0x6c>
		return -E_BAD_PATH;
  801a07:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a0c:	eb de                	jmp    8019ec <open+0x6c>

00801a0e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	b8 08 00 00 00       	mov    $0x8,%eax
  801a1e:	e8 64 fd ff ff       	call   801787 <fsipc>
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	56                   	push   %esi
  801a29:	53                   	push   %ebx
  801a2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	ff 75 08             	pushl  0x8(%ebp)
  801a33:	e8 cd f7 ff ff       	call   801205 <fd2data>
  801a38:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	68 87 2c 80 00       	push   $0x802c87
  801a42:	53                   	push   %ebx
  801a43:	e8 78 ee ff ff       	call   8008c0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a48:	8b 46 04             	mov    0x4(%esi),%eax
  801a4b:	2b 06                	sub    (%esi),%eax
  801a4d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a53:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a5a:	00 00 00 
	stat->st_dev = &devpipe;
  801a5d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a64:	30 80 00 
	return 0;
}
  801a67:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    

00801a73 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	53                   	push   %ebx
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a7d:	53                   	push   %ebx
  801a7e:	6a 00                	push   $0x0
  801a80:	e8 b9 f2 ff ff       	call   800d3e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a85:	89 1c 24             	mov    %ebx,(%esp)
  801a88:	e8 78 f7 ff ff       	call   801205 <fd2data>
  801a8d:	83 c4 08             	add    $0x8,%esp
  801a90:	50                   	push   %eax
  801a91:	6a 00                	push   $0x0
  801a93:	e8 a6 f2 ff ff       	call   800d3e <sys_page_unmap>
}
  801a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <_pipeisclosed>:
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	57                   	push   %edi
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
  801aa3:	83 ec 1c             	sub    $0x1c,%esp
  801aa6:	89 c7                	mov    %eax,%edi
  801aa8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801aaa:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801aaf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	57                   	push   %edi
  801ab6:	e8 33 0a 00 00       	call   8024ee <pageref>
  801abb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801abe:	89 34 24             	mov    %esi,(%esp)
  801ac1:	e8 28 0a 00 00       	call   8024ee <pageref>
		nn = thisenv->env_runs;
  801ac6:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801acc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	39 cb                	cmp    %ecx,%ebx
  801ad4:	74 1b                	je     801af1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ad6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ad9:	75 cf                	jne    801aaa <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801adb:	8b 42 58             	mov    0x58(%edx),%eax
  801ade:	6a 01                	push   $0x1
  801ae0:	50                   	push   %eax
  801ae1:	53                   	push   %ebx
  801ae2:	68 8e 2c 80 00       	push   $0x802c8e
  801ae7:	e8 37 e7 ff ff       	call   800223 <cprintf>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	eb b9                	jmp    801aaa <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801af1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801af4:	0f 94 c0             	sete   %al
  801af7:	0f b6 c0             	movzbl %al,%eax
}
  801afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5f                   	pop    %edi
  801b00:	5d                   	pop    %ebp
  801b01:	c3                   	ret    

00801b02 <devpipe_write>:
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 28             	sub    $0x28,%esp
  801b0b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b0e:	56                   	push   %esi
  801b0f:	e8 f1 f6 ff ff       	call   801205 <fd2data>
  801b14:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b21:	74 4f                	je     801b72 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b23:	8b 43 04             	mov    0x4(%ebx),%eax
  801b26:	8b 0b                	mov    (%ebx),%ecx
  801b28:	8d 51 20             	lea    0x20(%ecx),%edx
  801b2b:	39 d0                	cmp    %edx,%eax
  801b2d:	72 14                	jb     801b43 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b2f:	89 da                	mov    %ebx,%edx
  801b31:	89 f0                	mov    %esi,%eax
  801b33:	e8 65 ff ff ff       	call   801a9d <_pipeisclosed>
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	75 3a                	jne    801b76 <devpipe_write+0x74>
			sys_yield();
  801b3c:	e8 59 f1 ff ff       	call   800c9a <sys_yield>
  801b41:	eb e0                	jmp    801b23 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b46:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b4a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b4d:	89 c2                	mov    %eax,%edx
  801b4f:	c1 fa 1f             	sar    $0x1f,%edx
  801b52:	89 d1                	mov    %edx,%ecx
  801b54:	c1 e9 1b             	shr    $0x1b,%ecx
  801b57:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b5a:	83 e2 1f             	and    $0x1f,%edx
  801b5d:	29 ca                	sub    %ecx,%edx
  801b5f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b63:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b67:	83 c0 01             	add    $0x1,%eax
  801b6a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b6d:	83 c7 01             	add    $0x1,%edi
  801b70:	eb ac                	jmp    801b1e <devpipe_write+0x1c>
	return i;
  801b72:	89 f8                	mov    %edi,%eax
  801b74:	eb 05                	jmp    801b7b <devpipe_write+0x79>
				return 0;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5e                   	pop    %esi
  801b80:	5f                   	pop    %edi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <devpipe_read>:
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	57                   	push   %edi
  801b87:	56                   	push   %esi
  801b88:	53                   	push   %ebx
  801b89:	83 ec 18             	sub    $0x18,%esp
  801b8c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b8f:	57                   	push   %edi
  801b90:	e8 70 f6 ff ff       	call   801205 <fd2data>
  801b95:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	be 00 00 00 00       	mov    $0x0,%esi
  801b9f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ba2:	74 47                	je     801beb <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801ba4:	8b 03                	mov    (%ebx),%eax
  801ba6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ba9:	75 22                	jne    801bcd <devpipe_read+0x4a>
			if (i > 0)
  801bab:	85 f6                	test   %esi,%esi
  801bad:	75 14                	jne    801bc3 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801baf:	89 da                	mov    %ebx,%edx
  801bb1:	89 f8                	mov    %edi,%eax
  801bb3:	e8 e5 fe ff ff       	call   801a9d <_pipeisclosed>
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	75 33                	jne    801bef <devpipe_read+0x6c>
			sys_yield();
  801bbc:	e8 d9 f0 ff ff       	call   800c9a <sys_yield>
  801bc1:	eb e1                	jmp    801ba4 <devpipe_read+0x21>
				return i;
  801bc3:	89 f0                	mov    %esi,%eax
}
  801bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5f                   	pop    %edi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bcd:	99                   	cltd   
  801bce:	c1 ea 1b             	shr    $0x1b,%edx
  801bd1:	01 d0                	add    %edx,%eax
  801bd3:	83 e0 1f             	and    $0x1f,%eax
  801bd6:	29 d0                	sub    %edx,%eax
  801bd8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801be0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801be3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801be6:	83 c6 01             	add    $0x1,%esi
  801be9:	eb b4                	jmp    801b9f <devpipe_read+0x1c>
	return i;
  801beb:	89 f0                	mov    %esi,%eax
  801bed:	eb d6                	jmp    801bc5 <devpipe_read+0x42>
				return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf4:	eb cf                	jmp    801bc5 <devpipe_read+0x42>

00801bf6 <pipe>:
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	56                   	push   %esi
  801bfa:	53                   	push   %ebx
  801bfb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c01:	50                   	push   %eax
  801c02:	e8 15 f6 ff ff       	call   80121c <fd_alloc>
  801c07:	89 c3                	mov    %eax,%ebx
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	78 5b                	js     801c6b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	68 07 04 00 00       	push   $0x407
  801c18:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1b:	6a 00                	push   $0x0
  801c1d:	e8 97 f0 ff ff       	call   800cb9 <sys_page_alloc>
  801c22:	89 c3                	mov    %eax,%ebx
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	85 c0                	test   %eax,%eax
  801c29:	78 40                	js     801c6b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c2b:	83 ec 0c             	sub    $0xc,%esp
  801c2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c31:	50                   	push   %eax
  801c32:	e8 e5 f5 ff ff       	call   80121c <fd_alloc>
  801c37:	89 c3                	mov    %eax,%ebx
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 1b                	js     801c5b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	68 07 04 00 00       	push   $0x407
  801c48:	ff 75 f0             	pushl  -0x10(%ebp)
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 67 f0 ff ff       	call   800cb9 <sys_page_alloc>
  801c52:	89 c3                	mov    %eax,%ebx
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	85 c0                	test   %eax,%eax
  801c59:	79 19                	jns    801c74 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c5b:	83 ec 08             	sub    $0x8,%esp
  801c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c61:	6a 00                	push   $0x0
  801c63:	e8 d6 f0 ff ff       	call   800d3e <sys_page_unmap>
  801c68:	83 c4 10             	add    $0x10,%esp
}
  801c6b:	89 d8                	mov    %ebx,%eax
  801c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    
	va = fd2data(fd0);
  801c74:	83 ec 0c             	sub    $0xc,%esp
  801c77:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7a:	e8 86 f5 ff ff       	call   801205 <fd2data>
  801c7f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c81:	83 c4 0c             	add    $0xc,%esp
  801c84:	68 07 04 00 00       	push   $0x407
  801c89:	50                   	push   %eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	e8 28 f0 ff ff       	call   800cb9 <sys_page_alloc>
  801c91:	89 c3                	mov    %eax,%ebx
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	85 c0                	test   %eax,%eax
  801c98:	0f 88 8c 00 00 00    	js     801d2a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c9e:	83 ec 0c             	sub    $0xc,%esp
  801ca1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca4:	e8 5c f5 ff ff       	call   801205 <fd2data>
  801ca9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801cb0:	50                   	push   %eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	56                   	push   %esi
  801cb4:	6a 00                	push   $0x0
  801cb6:	e8 41 f0 ff ff       	call   800cfc <sys_page_map>
  801cbb:	89 c3                	mov    %eax,%ebx
  801cbd:	83 c4 20             	add    $0x20,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 58                	js     801d1c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ccd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ce2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf4:	e8 fc f4 ff ff       	call   8011f5 <fd2num>
  801cf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cfe:	83 c4 04             	add    $0x4,%esp
  801d01:	ff 75 f0             	pushl  -0x10(%ebp)
  801d04:	e8 ec f4 ff ff       	call   8011f5 <fd2num>
  801d09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d17:	e9 4f ff ff ff       	jmp    801c6b <pipe+0x75>
	sys_page_unmap(0, va);
  801d1c:	83 ec 08             	sub    $0x8,%esp
  801d1f:	56                   	push   %esi
  801d20:	6a 00                	push   $0x0
  801d22:	e8 17 f0 ff ff       	call   800d3e <sys_page_unmap>
  801d27:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d30:	6a 00                	push   $0x0
  801d32:	e8 07 f0 ff ff       	call   800d3e <sys_page_unmap>
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	e9 1c ff ff ff       	jmp    801c5b <pipe+0x65>

00801d3f <pipeisclosed>:
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d48:	50                   	push   %eax
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	e8 1a f5 ff ff       	call   80126b <fd_lookup>
  801d51:	83 c4 10             	add    $0x10,%esp
  801d54:	85 c0                	test   %eax,%eax
  801d56:	78 18                	js     801d70 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d58:	83 ec 0c             	sub    $0xc,%esp
  801d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5e:	e8 a2 f4 ff ff       	call   801205 <fd2data>
	return _pipeisclosed(fd, p);
  801d63:	89 c2                	mov    %eax,%edx
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	e8 30 fd ff ff       	call   801a9d <_pipeisclosed>
  801d6d:	83 c4 10             	add    $0x10,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d78:	68 a6 2c 80 00       	push   $0x802ca6
  801d7d:	ff 75 0c             	pushl  0xc(%ebp)
  801d80:	e8 3b eb ff ff       	call   8008c0 <strcpy>
	return 0;
}
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <devsock_close>:
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 10             	sub    $0x10,%esp
  801d93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d96:	53                   	push   %ebx
  801d97:	e8 52 07 00 00       	call   8024ee <pageref>
  801d9c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d9f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801da4:	83 f8 01             	cmp    $0x1,%eax
  801da7:	74 07                	je     801db0 <devsock_close+0x24>
}
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801db0:	83 ec 0c             	sub    $0xc,%esp
  801db3:	ff 73 0c             	pushl  0xc(%ebx)
  801db6:	e8 b7 02 00 00       	call   802072 <nsipc_close>
  801dbb:	89 c2                	mov    %eax,%edx
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	eb e7                	jmp    801da9 <devsock_close+0x1d>

00801dc2 <devsock_write>:
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	ff 75 10             	pushl  0x10(%ebp)
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	ff 70 0c             	pushl  0xc(%eax)
  801dd6:	e8 74 03 00 00       	call   80214f <nsipc_send>
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <devsock_read>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	ff 75 10             	pushl  0x10(%ebp)
  801de8:	ff 75 0c             	pushl  0xc(%ebp)
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	ff 70 0c             	pushl  0xc(%eax)
  801df1:	e8 ed 02 00 00       	call   8020e3 <nsipc_recv>
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <fd2sockid>:
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dfe:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e01:	52                   	push   %edx
  801e02:	50                   	push   %eax
  801e03:	e8 63 f4 ff ff       	call   80126b <fd_lookup>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 10                	js     801e1f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801e18:	39 08                	cmp    %ecx,(%eax)
  801e1a:	75 05                	jne    801e21 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e1c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    
		return -E_NOT_SUPP;
  801e21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e26:	eb f7                	jmp    801e1f <fd2sockid+0x27>

00801e28 <alloc_sockfd>:
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	56                   	push   %esi
  801e2c:	53                   	push   %ebx
  801e2d:	83 ec 1c             	sub    $0x1c,%esp
  801e30:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e35:	50                   	push   %eax
  801e36:	e8 e1 f3 ff ff       	call   80121c <fd_alloc>
  801e3b:	89 c3                	mov    %eax,%ebx
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 43                	js     801e87 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	68 07 04 00 00       	push   $0x407
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	6a 00                	push   $0x0
  801e51:	e8 63 ee ff ff       	call   800cb9 <sys_page_alloc>
  801e56:	89 c3                	mov    %eax,%ebx
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	78 28                	js     801e87 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e68:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e74:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e77:	83 ec 0c             	sub    $0xc,%esp
  801e7a:	50                   	push   %eax
  801e7b:	e8 75 f3 ff ff       	call   8011f5 <fd2num>
  801e80:	89 c3                	mov    %eax,%ebx
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	eb 0c                	jmp    801e93 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	56                   	push   %esi
  801e8b:	e8 e2 01 00 00       	call   802072 <nsipc_close>
		return r;
  801e90:	83 c4 10             	add    $0x10,%esp
}
  801e93:	89 d8                	mov    %ebx,%eax
  801e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    

00801e9c <accept>:
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	e8 4e ff ff ff       	call   801df8 <fd2sockid>
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 1b                	js     801ec9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	ff 75 10             	pushl  0x10(%ebp)
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	50                   	push   %eax
  801eb8:	e8 0e 01 00 00       	call   801fcb <nsipc_accept>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 05                	js     801ec9 <accept+0x2d>
	return alloc_sockfd(r);
  801ec4:	e8 5f ff ff ff       	call   801e28 <alloc_sockfd>
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <bind>:
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	e8 1f ff ff ff       	call   801df8 <fd2sockid>
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	78 12                	js     801eef <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	ff 75 10             	pushl  0x10(%ebp)
  801ee3:	ff 75 0c             	pushl  0xc(%ebp)
  801ee6:	50                   	push   %eax
  801ee7:	e8 2f 01 00 00       	call   80201b <nsipc_bind>
  801eec:	83 c4 10             	add    $0x10,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <shutdown>:
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	e8 f9 fe ff ff       	call   801df8 <fd2sockid>
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 0f                	js     801f12 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f03:	83 ec 08             	sub    $0x8,%esp
  801f06:	ff 75 0c             	pushl  0xc(%ebp)
  801f09:	50                   	push   %eax
  801f0a:	e8 41 01 00 00       	call   802050 <nsipc_shutdown>
  801f0f:	83 c4 10             	add    $0x10,%esp
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <connect>:
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	e8 d6 fe ff ff       	call   801df8 <fd2sockid>
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 12                	js     801f38 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	ff 75 10             	pushl  0x10(%ebp)
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	50                   	push   %eax
  801f30:	e8 57 01 00 00       	call   80208c <nsipc_connect>
  801f35:	83 c4 10             	add    $0x10,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <listen>:
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	e8 b0 fe ff ff       	call   801df8 <fd2sockid>
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 0f                	js     801f5b <listen+0x21>
	return nsipc_listen(r, backlog);
  801f4c:	83 ec 08             	sub    $0x8,%esp
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	50                   	push   %eax
  801f53:	e8 69 01 00 00       	call   8020c1 <nsipc_listen>
  801f58:	83 c4 10             	add    $0x10,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <socket>:

int
socket(int domain, int type, int protocol)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f63:	ff 75 10             	pushl  0x10(%ebp)
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 3c 02 00 00       	call   8021ad <nsipc_socket>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 05                	js     801f7d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801f78:	e8 ab fe ff ff       	call   801e28 <alloc_sockfd>
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	53                   	push   %ebx
  801f83:	83 ec 04             	sub    $0x4,%esp
  801f86:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f88:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f8f:	74 26                	je     801fb7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f91:	6a 07                	push   $0x7
  801f93:	68 00 60 80 00       	push   $0x806000
  801f98:	53                   	push   %ebx
  801f99:	ff 35 04 40 80 00    	pushl  0x804004
  801f9f:	e8 b8 04 00 00       	call   80245c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fa4:	83 c4 0c             	add    $0xc,%esp
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	e8 41 04 00 00       	call   8023f3 <ipc_recv>
}
  801fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	6a 02                	push   $0x2
  801fbc:	e8 f4 04 00 00       	call   8024b5 <ipc_find_env>
  801fc1:	a3 04 40 80 00       	mov    %eax,0x804004
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	eb c6                	jmp    801f91 <nsipc+0x12>

00801fcb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fdb:	8b 06                	mov    (%esi),%eax
  801fdd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe7:	e8 93 ff ff ff       	call   801f7f <nsipc>
  801fec:	89 c3                	mov    %eax,%ebx
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	78 20                	js     802012 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	ff 35 10 60 80 00    	pushl  0x806010
  801ffb:	68 00 60 80 00       	push   $0x806000
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	e8 46 ea ff ff       	call   800a4e <memmove>
		*addrlen = ret->ret_addrlen;
  802008:	a1 10 60 80 00       	mov    0x806010,%eax
  80200d:	89 06                	mov    %eax,(%esi)
  80200f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  802012:	89 d8                	mov    %ebx,%eax
  802014:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    

0080201b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	53                   	push   %ebx
  80201f:	83 ec 08             	sub    $0x8,%esp
  802022:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80202d:	53                   	push   %ebx
  80202e:	ff 75 0c             	pushl  0xc(%ebp)
  802031:	68 04 60 80 00       	push   $0x806004
  802036:	e8 13 ea ff ff       	call   800a4e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80203b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802041:	b8 02 00 00 00       	mov    $0x2,%eax
  802046:	e8 34 ff ff ff       	call   801f7f <nsipc>
}
  80204b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80205e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802061:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802066:	b8 03 00 00 00       	mov    $0x3,%eax
  80206b:	e8 0f ff ff ff       	call   801f7f <nsipc>
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <nsipc_close>:

int
nsipc_close(int s)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802080:	b8 04 00 00 00       	mov    $0x4,%eax
  802085:	e8 f5 fe ff ff       	call   801f7f <nsipc>
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	53                   	push   %ebx
  802090:	83 ec 08             	sub    $0x8,%esp
  802093:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80209e:	53                   	push   %ebx
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	68 04 60 80 00       	push   $0x806004
  8020a7:	e8 a2 e9 ff ff       	call   800a4e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020ac:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8020b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8020b7:	e8 c3 fe ff ff       	call   801f7f <nsipc>
}
  8020bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8020d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8020dc:	e8 9e fe ff ff       	call   801f7f <nsipc>
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
  8020e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020f3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802101:	b8 07 00 00 00       	mov    $0x7,%eax
  802106:	e8 74 fe ff ff       	call   801f7f <nsipc>
  80210b:	89 c3                	mov    %eax,%ebx
  80210d:	85 c0                	test   %eax,%eax
  80210f:	78 1f                	js     802130 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802111:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802116:	7f 21                	jg     802139 <nsipc_recv+0x56>
  802118:	39 c6                	cmp    %eax,%esi
  80211a:	7c 1d                	jl     802139 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	50                   	push   %eax
  802120:	68 00 60 80 00       	push   $0x806000
  802125:	ff 75 0c             	pushl  0xc(%ebp)
  802128:	e8 21 e9 ff ff       	call   800a4e <memmove>
  80212d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802130:	89 d8                	mov    %ebx,%eax
  802132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802139:	68 b2 2c 80 00       	push   $0x802cb2
  80213e:	68 54 2c 80 00       	push   $0x802c54
  802143:	6a 62                	push   $0x62
  802145:	68 c7 2c 80 00       	push   $0x802cc7
  80214a:	e8 f9 df ff ff       	call   800148 <_panic>

0080214f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	53                   	push   %ebx
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802161:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802167:	7f 2e                	jg     802197 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	53                   	push   %ebx
  80216d:	ff 75 0c             	pushl  0xc(%ebp)
  802170:	68 0c 60 80 00       	push   $0x80600c
  802175:	e8 d4 e8 ff ff       	call   800a4e <memmove>
	nsipcbuf.send.req_size = size;
  80217a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802180:	8b 45 14             	mov    0x14(%ebp),%eax
  802183:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802188:	b8 08 00 00 00       	mov    $0x8,%eax
  80218d:	e8 ed fd ff ff       	call   801f7f <nsipc>
}
  802192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802195:	c9                   	leave  
  802196:	c3                   	ret    
	assert(size < 1600);
  802197:	68 d3 2c 80 00       	push   $0x802cd3
  80219c:	68 54 2c 80 00       	push   $0x802c54
  8021a1:	6a 6d                	push   $0x6d
  8021a3:	68 c7 2c 80 00       	push   $0x802cc7
  8021a8:	e8 9b df ff ff       	call   800148 <_panic>

008021ad <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8021bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021be:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8021c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8021cb:	b8 09 00 00 00       	mov    $0x9,%eax
  8021d0:	e8 aa fd ff ff       	call   801f7f <nsipc>
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    

008021e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021e7:	68 df 2c 80 00       	push   $0x802cdf
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	e8 cc e6 ff ff       	call   8008c0 <strcpy>
	return 0;
}
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <devcons_write>:
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	57                   	push   %edi
  8021ff:	56                   	push   %esi
  802200:	53                   	push   %ebx
  802201:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802207:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80220c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802212:	eb 2f                	jmp    802243 <devcons_write+0x48>
		m = n - tot;
  802214:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802217:	29 f3                	sub    %esi,%ebx
  802219:	83 fb 7f             	cmp    $0x7f,%ebx
  80221c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802221:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	53                   	push   %ebx
  802228:	89 f0                	mov    %esi,%eax
  80222a:	03 45 0c             	add    0xc(%ebp),%eax
  80222d:	50                   	push   %eax
  80222e:	57                   	push   %edi
  80222f:	e8 1a e8 ff ff       	call   800a4e <memmove>
		sys_cputs(buf, m);
  802234:	83 c4 08             	add    $0x8,%esp
  802237:	53                   	push   %ebx
  802238:	57                   	push   %edi
  802239:	e8 bf e9 ff ff       	call   800bfd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80223e:	01 de                	add    %ebx,%esi
  802240:	83 c4 10             	add    $0x10,%esp
  802243:	3b 75 10             	cmp    0x10(%ebp),%esi
  802246:	72 cc                	jb     802214 <devcons_write+0x19>
}
  802248:	89 f0                	mov    %esi,%eax
  80224a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    

00802252 <devcons_read>:
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80225d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802261:	75 07                	jne    80226a <devcons_read+0x18>
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    
		sys_yield();
  802265:	e8 30 ea ff ff       	call   800c9a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80226a:	e8 ac e9 ff ff       	call   800c1b <sys_cgetc>
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 f2                	je     802265 <devcons_read+0x13>
	if (c < 0)
  802273:	85 c0                	test   %eax,%eax
  802275:	78 ec                	js     802263 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802277:	83 f8 04             	cmp    $0x4,%eax
  80227a:	74 0c                	je     802288 <devcons_read+0x36>
	*(char*)vbuf = c;
  80227c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227f:	88 02                	mov    %al,(%edx)
	return 1;
  802281:	b8 01 00 00 00       	mov    $0x1,%eax
  802286:	eb db                	jmp    802263 <devcons_read+0x11>
		return 0;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
  80228d:	eb d4                	jmp    802263 <devcons_read+0x11>

0080228f <cputchar>:
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80229b:	6a 01                	push   $0x1
  80229d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022a0:	50                   	push   %eax
  8022a1:	e8 57 e9 ff ff       	call   800bfd <sys_cputs>
}
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <getchar>:
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022b1:	6a 01                	push   $0x1
  8022b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022b6:	50                   	push   %eax
  8022b7:	6a 00                	push   $0x0
  8022b9:	e8 1e f2 ff ff       	call   8014dc <read>
	if (r < 0)
  8022be:	83 c4 10             	add    $0x10,%esp
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	78 08                	js     8022cd <getchar+0x22>
	if (r < 1)
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	7e 06                	jle    8022cf <getchar+0x24>
	return c;
  8022c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    
		return -E_EOF;
  8022cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022d4:	eb f7                	jmp    8022cd <getchar+0x22>

008022d6 <iscons>:
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022df:	50                   	push   %eax
  8022e0:	ff 75 08             	pushl  0x8(%ebp)
  8022e3:	e8 83 ef ff ff       	call   80126b <fd_lookup>
  8022e8:	83 c4 10             	add    $0x10,%esp
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	78 11                	js     802300 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022f8:	39 10                	cmp    %edx,(%eax)
  8022fa:	0f 94 c0             	sete   %al
  8022fd:	0f b6 c0             	movzbl %al,%eax
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <opencons>:
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802308:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80230b:	50                   	push   %eax
  80230c:	e8 0b ef ff ff       	call   80121c <fd_alloc>
  802311:	83 c4 10             	add    $0x10,%esp
  802314:	85 c0                	test   %eax,%eax
  802316:	78 3a                	js     802352 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	68 07 04 00 00       	push   $0x407
  802320:	ff 75 f4             	pushl  -0xc(%ebp)
  802323:	6a 00                	push   $0x0
  802325:	e8 8f e9 ff ff       	call   800cb9 <sys_page_alloc>
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	85 c0                	test   %eax,%eax
  80232f:	78 21                	js     802352 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80233a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802346:	83 ec 0c             	sub    $0xc,%esp
  802349:	50                   	push   %eax
  80234a:	e8 a6 ee ff ff       	call   8011f5 <fd2num>
  80234f:	83 c4 10             	add    $0x10,%esp
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80235a:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802361:	74 0a                	je     80236d <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80236d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802372:	8b 40 48             	mov    0x48(%eax),%eax
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	6a 07                	push   $0x7
  80237a:	68 00 f0 bf ee       	push   $0xeebff000
  80237f:	50                   	push   %eax
  802380:	e8 34 e9 ff ff       	call   800cb9 <sys_page_alloc>
  802385:	83 c4 10             	add    $0x10,%esp
  802388:	85 c0                	test   %eax,%eax
  80238a:	75 2f                	jne    8023bb <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  80238c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802391:	8b 40 48             	mov    0x48(%eax),%eax
  802394:	83 ec 08             	sub    $0x8,%esp
  802397:	68 cd 23 80 00       	push   $0x8023cd
  80239c:	50                   	push   %eax
  80239d:	e8 62 ea ff ff       	call   800e04 <sys_env_set_pgfault_upcall>
  8023a2:	83 c4 10             	add    $0x10,%esp
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	74 ba                	je     802363 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8023a9:	50                   	push   %eax
  8023aa:	68 eb 2c 80 00       	push   $0x802ceb
  8023af:	6a 24                	push   $0x24
  8023b1:	68 03 2d 80 00       	push   $0x802d03
  8023b6:	e8 8d dd ff ff       	call   800148 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8023bb:	50                   	push   %eax
  8023bc:	68 eb 2c 80 00       	push   $0x802ceb
  8023c1:	6a 21                	push   $0x21
  8023c3:	68 03 2d 80 00       	push   $0x802d03
  8023c8:	e8 7b dd ff ff       	call   800148 <_panic>

008023cd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023cd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023ce:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8023d3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023d5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8023d8:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8023dc:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8023df:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8023e3:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8023e7:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8023e9:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8023ec:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8023ed:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8023f0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8023f1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8023f2:	c3                   	ret    

008023f3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	56                   	push   %esi
  8023f7:	53                   	push   %ebx
  8023f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  802401:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  802403:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802408:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	50                   	push   %eax
  80240f:	e8 55 ea ff ff       	call   800e69 <sys_ipc_recv>
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	85 c0                	test   %eax,%eax
  802419:	78 2b                	js     802446 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80241b:	85 f6                	test   %esi,%esi
  80241d:	74 0a                	je     802429 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80241f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802424:	8b 40 74             	mov    0x74(%eax),%eax
  802427:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802429:	85 db                	test   %ebx,%ebx
  80242b:	74 0a                	je     802437 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80242d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802432:	8b 40 78             	mov    0x78(%eax),%eax
  802435:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802437:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80243c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80243f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802442:	5b                   	pop    %ebx
  802443:	5e                   	pop    %esi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
	    if (from_env_store != NULL) {
  802446:	85 f6                	test   %esi,%esi
  802448:	74 06                	je     802450 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80244a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802450:	85 db                	test   %ebx,%ebx
  802452:	74 eb                	je     80243f <ipc_recv+0x4c>
	        *perm_store = 0;
  802454:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80245a:	eb e3                	jmp    80243f <ipc_recv+0x4c>

0080245c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	57                   	push   %edi
  802460:	56                   	push   %esi
  802461:	53                   	push   %ebx
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	8b 7d 08             	mov    0x8(%ebp),%edi
  802468:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80246b:	85 f6                	test   %esi,%esi
  80246d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802472:	0f 44 f0             	cmove  %eax,%esi
  802475:	eb 09                	jmp    802480 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802477:	e8 1e e8 ff ff       	call   800c9a <sys_yield>
	} while(r != 0);
  80247c:	85 db                	test   %ebx,%ebx
  80247e:	74 2d                	je     8024ad <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802480:	ff 75 14             	pushl  0x14(%ebp)
  802483:	56                   	push   %esi
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	57                   	push   %edi
  802488:	e8 b9 e9 ff ff       	call   800e46 <sys_ipc_try_send>
  80248d:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	85 c0                	test   %eax,%eax
  802494:	79 e1                	jns    802477 <ipc_send+0x1b>
  802496:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802499:	74 dc                	je     802477 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  80249b:	50                   	push   %eax
  80249c:	68 11 2d 80 00       	push   $0x802d11
  8024a1:	6a 45                	push   $0x45
  8024a3:	68 1e 2d 80 00       	push   $0x802d1e
  8024a8:	e8 9b dc ff ff       	call   800148 <_panic>
}
  8024ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b0:	5b                   	pop    %ebx
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    

008024b5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024c0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024c3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024c9:	8b 52 50             	mov    0x50(%edx),%edx
  8024cc:	39 ca                	cmp    %ecx,%edx
  8024ce:	74 11                	je     8024e1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024d0:	83 c0 01             	add    $0x1,%eax
  8024d3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024d8:	75 e6                	jne    8024c0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	eb 0b                	jmp    8024ec <ipc_find_env+0x37>
			return envs[i].env_id;
  8024e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024e9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024ec:	5d                   	pop    %ebp
  8024ed:	c3                   	ret    

008024ee <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024f4:	89 d0                	mov    %edx,%eax
  8024f6:	c1 e8 16             	shr    $0x16,%eax
  8024f9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802505:	f6 c1 01             	test   $0x1,%cl
  802508:	74 1d                	je     802527 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80250a:	c1 ea 0c             	shr    $0xc,%edx
  80250d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802514:	f6 c2 01             	test   $0x1,%dl
  802517:	74 0e                	je     802527 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802519:	c1 ea 0c             	shr    $0xc,%edx
  80251c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802523:	ef 
  802524:	0f b7 c0             	movzwl %ax,%eax
}
  802527:	5d                   	pop    %ebp
  802528:	c3                   	ret    
  802529:	66 90                	xchg   %ax,%ax
  80252b:	66 90                	xchg   %ax,%ax
  80252d:	66 90                	xchg   %ax,%ax
  80252f:	90                   	nop

00802530 <__udivdi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	53                   	push   %ebx
  802534:	83 ec 1c             	sub    $0x1c,%esp
  802537:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80253b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80253f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802543:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802547:	85 d2                	test   %edx,%edx
  802549:	75 35                	jne    802580 <__udivdi3+0x50>
  80254b:	39 f3                	cmp    %esi,%ebx
  80254d:	0f 87 bd 00 00 00    	ja     802610 <__udivdi3+0xe0>
  802553:	85 db                	test   %ebx,%ebx
  802555:	89 d9                	mov    %ebx,%ecx
  802557:	75 0b                	jne    802564 <__udivdi3+0x34>
  802559:	b8 01 00 00 00       	mov    $0x1,%eax
  80255e:	31 d2                	xor    %edx,%edx
  802560:	f7 f3                	div    %ebx
  802562:	89 c1                	mov    %eax,%ecx
  802564:	31 d2                	xor    %edx,%edx
  802566:	89 f0                	mov    %esi,%eax
  802568:	f7 f1                	div    %ecx
  80256a:	89 c6                	mov    %eax,%esi
  80256c:	89 e8                	mov    %ebp,%eax
  80256e:	89 f7                	mov    %esi,%edi
  802570:	f7 f1                	div    %ecx
  802572:	89 fa                	mov    %edi,%edx
  802574:	83 c4 1c             	add    $0x1c,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5f                   	pop    %edi
  80257a:	5d                   	pop    %ebp
  80257b:	c3                   	ret    
  80257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802580:	39 f2                	cmp    %esi,%edx
  802582:	77 7c                	ja     802600 <__udivdi3+0xd0>
  802584:	0f bd fa             	bsr    %edx,%edi
  802587:	83 f7 1f             	xor    $0x1f,%edi
  80258a:	0f 84 98 00 00 00    	je     802628 <__udivdi3+0xf8>
  802590:	89 f9                	mov    %edi,%ecx
  802592:	b8 20 00 00 00       	mov    $0x20,%eax
  802597:	29 f8                	sub    %edi,%eax
  802599:	d3 e2                	shl    %cl,%edx
  80259b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80259f:	89 c1                	mov    %eax,%ecx
  8025a1:	89 da                	mov    %ebx,%edx
  8025a3:	d3 ea                	shr    %cl,%edx
  8025a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a9:	09 d1                	or     %edx,%ecx
  8025ab:	89 f2                	mov    %esi,%edx
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 f9                	mov    %edi,%ecx
  8025b3:	d3 e3                	shl    %cl,%ebx
  8025b5:	89 c1                	mov    %eax,%ecx
  8025b7:	d3 ea                	shr    %cl,%edx
  8025b9:	89 f9                	mov    %edi,%ecx
  8025bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025bf:	d3 e6                	shl    %cl,%esi
  8025c1:	89 eb                	mov    %ebp,%ebx
  8025c3:	89 c1                	mov    %eax,%ecx
  8025c5:	d3 eb                	shr    %cl,%ebx
  8025c7:	09 de                	or     %ebx,%esi
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	f7 74 24 08          	divl   0x8(%esp)
  8025cf:	89 d6                	mov    %edx,%esi
  8025d1:	89 c3                	mov    %eax,%ebx
  8025d3:	f7 64 24 0c          	mull   0xc(%esp)
  8025d7:	39 d6                	cmp    %edx,%esi
  8025d9:	72 0c                	jb     8025e7 <__udivdi3+0xb7>
  8025db:	89 f9                	mov    %edi,%ecx
  8025dd:	d3 e5                	shl    %cl,%ebp
  8025df:	39 c5                	cmp    %eax,%ebp
  8025e1:	73 5d                	jae    802640 <__udivdi3+0x110>
  8025e3:	39 d6                	cmp    %edx,%esi
  8025e5:	75 59                	jne    802640 <__udivdi3+0x110>
  8025e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ea:	31 ff                	xor    %edi,%edi
  8025ec:	89 fa                	mov    %edi,%edx
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d 76 00             	lea    0x0(%esi),%esi
  8025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802600:	31 ff                	xor    %edi,%edi
  802602:	31 c0                	xor    %eax,%eax
  802604:	89 fa                	mov    %edi,%edx
  802606:	83 c4 1c             	add    $0x1c,%esp
  802609:	5b                   	pop    %ebx
  80260a:	5e                   	pop    %esi
  80260b:	5f                   	pop    %edi
  80260c:	5d                   	pop    %ebp
  80260d:	c3                   	ret    
  80260e:	66 90                	xchg   %ax,%ax
  802610:	31 ff                	xor    %edi,%edi
  802612:	89 e8                	mov    %ebp,%eax
  802614:	89 f2                	mov    %esi,%edx
  802616:	f7 f3                	div    %ebx
  802618:	89 fa                	mov    %edi,%edx
  80261a:	83 c4 1c             	add    $0x1c,%esp
  80261d:	5b                   	pop    %ebx
  80261e:	5e                   	pop    %esi
  80261f:	5f                   	pop    %edi
  802620:	5d                   	pop    %ebp
  802621:	c3                   	ret    
  802622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	72 06                	jb     802632 <__udivdi3+0x102>
  80262c:	31 c0                	xor    %eax,%eax
  80262e:	39 eb                	cmp    %ebp,%ebx
  802630:	77 d2                	ja     802604 <__udivdi3+0xd4>
  802632:	b8 01 00 00 00       	mov    $0x1,%eax
  802637:	eb cb                	jmp    802604 <__udivdi3+0xd4>
  802639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802640:	89 d8                	mov    %ebx,%eax
  802642:	31 ff                	xor    %edi,%edi
  802644:	eb be                	jmp    802604 <__udivdi3+0xd4>
  802646:	66 90                	xchg   %ax,%ax
  802648:	66 90                	xchg   %ax,%ax
  80264a:	66 90                	xchg   %ax,%ax
  80264c:	66 90                	xchg   %ax,%ax
  80264e:	66 90                	xchg   %ax,%ax

00802650 <__umoddi3>:
  802650:	55                   	push   %ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 1c             	sub    $0x1c,%esp
  802657:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80265b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80265f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802663:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802667:	85 ed                	test   %ebp,%ebp
  802669:	89 f0                	mov    %esi,%eax
  80266b:	89 da                	mov    %ebx,%edx
  80266d:	75 19                	jne    802688 <__umoddi3+0x38>
  80266f:	39 df                	cmp    %ebx,%edi
  802671:	0f 86 b1 00 00 00    	jbe    802728 <__umoddi3+0xd8>
  802677:	f7 f7                	div    %edi
  802679:	89 d0                	mov    %edx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	83 c4 1c             	add    $0x1c,%esp
  802680:	5b                   	pop    %ebx
  802681:	5e                   	pop    %esi
  802682:	5f                   	pop    %edi
  802683:	5d                   	pop    %ebp
  802684:	c3                   	ret    
  802685:	8d 76 00             	lea    0x0(%esi),%esi
  802688:	39 dd                	cmp    %ebx,%ebp
  80268a:	77 f1                	ja     80267d <__umoddi3+0x2d>
  80268c:	0f bd cd             	bsr    %ebp,%ecx
  80268f:	83 f1 1f             	xor    $0x1f,%ecx
  802692:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802696:	0f 84 b4 00 00 00    	je     802750 <__umoddi3+0x100>
  80269c:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a1:	89 c2                	mov    %eax,%edx
  8026a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026a7:	29 c2                	sub    %eax,%edx
  8026a9:	89 c1                	mov    %eax,%ecx
  8026ab:	89 f8                	mov    %edi,%eax
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	89 d1                	mov    %edx,%ecx
  8026b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026b5:	d3 e8                	shr    %cl,%eax
  8026b7:	09 c5                	or     %eax,%ebp
  8026b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	d3 e7                	shl    %cl,%edi
  8026c1:	89 d1                	mov    %edx,%ecx
  8026c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026c7:	89 df                	mov    %ebx,%edi
  8026c9:	d3 ef                	shr    %cl,%edi
  8026cb:	89 c1                	mov    %eax,%ecx
  8026cd:	89 f0                	mov    %esi,%eax
  8026cf:	d3 e3                	shl    %cl,%ebx
  8026d1:	89 d1                	mov    %edx,%ecx
  8026d3:	89 fa                	mov    %edi,%edx
  8026d5:	d3 e8                	shr    %cl,%eax
  8026d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026dc:	09 d8                	or     %ebx,%eax
  8026de:	f7 f5                	div    %ebp
  8026e0:	d3 e6                	shl    %cl,%esi
  8026e2:	89 d1                	mov    %edx,%ecx
  8026e4:	f7 64 24 08          	mull   0x8(%esp)
  8026e8:	39 d1                	cmp    %edx,%ecx
  8026ea:	89 c3                	mov    %eax,%ebx
  8026ec:	89 d7                	mov    %edx,%edi
  8026ee:	72 06                	jb     8026f6 <__umoddi3+0xa6>
  8026f0:	75 0e                	jne    802700 <__umoddi3+0xb0>
  8026f2:	39 c6                	cmp    %eax,%esi
  8026f4:	73 0a                	jae    802700 <__umoddi3+0xb0>
  8026f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026fa:	19 ea                	sbb    %ebp,%edx
  8026fc:	89 d7                	mov    %edx,%edi
  8026fe:	89 c3                	mov    %eax,%ebx
  802700:	89 ca                	mov    %ecx,%edx
  802702:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802707:	29 de                	sub    %ebx,%esi
  802709:	19 fa                	sbb    %edi,%edx
  80270b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80270f:	89 d0                	mov    %edx,%eax
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 d9                	mov    %ebx,%ecx
  802715:	d3 ee                	shr    %cl,%esi
  802717:	d3 ea                	shr    %cl,%edx
  802719:	09 f0                	or     %esi,%eax
  80271b:	83 c4 1c             	add    $0x1c,%esp
  80271e:	5b                   	pop    %ebx
  80271f:	5e                   	pop    %esi
  802720:	5f                   	pop    %edi
  802721:	5d                   	pop    %ebp
  802722:	c3                   	ret    
  802723:	90                   	nop
  802724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802728:	85 ff                	test   %edi,%edi
  80272a:	89 f9                	mov    %edi,%ecx
  80272c:	75 0b                	jne    802739 <__umoddi3+0xe9>
  80272e:	b8 01 00 00 00       	mov    $0x1,%eax
  802733:	31 d2                	xor    %edx,%edx
  802735:	f7 f7                	div    %edi
  802737:	89 c1                	mov    %eax,%ecx
  802739:	89 d8                	mov    %ebx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f1                	div    %ecx
  80273f:	89 f0                	mov    %esi,%eax
  802741:	f7 f1                	div    %ecx
  802743:	e9 31 ff ff ff       	jmp    802679 <__umoddi3+0x29>
  802748:	90                   	nop
  802749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802750:	39 dd                	cmp    %ebx,%ebp
  802752:	72 08                	jb     80275c <__umoddi3+0x10c>
  802754:	39 f7                	cmp    %esi,%edi
  802756:	0f 87 21 ff ff ff    	ja     80267d <__umoddi3+0x2d>
  80275c:	89 da                	mov    %ebx,%edx
  80275e:	89 f0                	mov    %esi,%eax
  802760:	29 f8                	sub    %edi,%eax
  802762:	19 ea                	sbb    %ebp,%edx
  802764:	e9 14 ff ff ff       	jmp    80267d <__umoddi3+0x2d>
