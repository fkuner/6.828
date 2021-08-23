
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 b9 11 00 00       	call   801205 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 08 40 80 00       	mov    0x804008,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 80 27 80 00       	push   $0x802780
  800060:	e8 ce 01 00 00       	call   800233 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 59 0f 00 00       	call   800fc3 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 30                	js     8000a3 <primeproc+0x70>
		panic("fork: %e", id);
	if (id == 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	74 c8                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800077:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 00                	push   $0x0
  80007f:	6a 00                	push   $0x0
  800081:	56                   	push   %esi
  800082:	e8 7e 11 00 00       	call   801205 <ipc_recv>
  800087:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800089:	99                   	cltd   
  80008a:	f7 fb                	idiv   %ebx
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	85 d2                	test   %edx,%edx
  800091:	74 e7                	je     80007a <primeproc+0x47>
			ipc_send(id, i, 0, 0);
  800093:	6a 00                	push   $0x0
  800095:	6a 00                	push   $0x0
  800097:	51                   	push   %ecx
  800098:	57                   	push   %edi
  800099:	e8 d0 11 00 00       	call   80126e <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 26 2b 80 00       	push   $0x802b26
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 8c 27 80 00       	push   $0x80278c
  8000b0:	e8 a3 00 00 00       	call   800158 <_panic>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 04 0f 00 00       	call   800fc3 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1c                	js     8000e1 <umain+0x2c>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	74 25                	je     8000f3 <umain+0x3e>
		ipc_send(id, i, 0, 0);
  8000ce:	6a 00                	push   $0x0
  8000d0:	6a 00                	push   $0x0
  8000d2:	53                   	push   %ebx
  8000d3:	56                   	push   %esi
  8000d4:	e8 95 11 00 00       	call   80126e <ipc_send>
	for (i = 2; ; i++)
  8000d9:	83 c3 01             	add    $0x1,%ebx
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	eb ed                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000e1:	50                   	push   %eax
  8000e2:	68 26 2b 80 00       	push   $0x802b26
  8000e7:	6a 2d                	push   $0x2d
  8000e9:	68 8c 27 80 00       	push   $0x80278c
  8000ee:	e8 65 00 00 00       	call   800158 <_panic>
		primeproc();
  8000f3:	e8 3b ff ff ff       	call   800033 <primeproc>

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800100:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800103:	e8 83 0b 00 00       	call   800c8b <sys_getenvid>
  800108:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800110:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800115:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011a:	85 db                	test   %ebx,%ebx
  80011c:	7e 07                	jle    800125 <libmain+0x2d>
		binaryname = argv[0];
  80011e:	8b 06                	mov    (%esi),%eax
  800120:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 86 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  80012f:	e8 0a 00 00 00       	call   80013e <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800144:	e8 8d 13 00 00       	call   8014d6 <close_all>
	sys_env_destroy(0);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	6a 00                	push   $0x0
  80014e:	e8 f7 0a 00 00       	call   800c4a <sys_env_destroy>
}
  800153:	83 c4 10             	add    $0x10,%esp
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80015d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800160:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800166:	e8 20 0b 00 00       	call   800c8b <sys_getenvid>
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	ff 75 0c             	pushl  0xc(%ebp)
  800171:	ff 75 08             	pushl  0x8(%ebp)
  800174:	56                   	push   %esi
  800175:	50                   	push   %eax
  800176:	68 a4 27 80 00       	push   $0x8027a4
  80017b:	e8 b3 00 00 00       	call   800233 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800180:	83 c4 18             	add    $0x18,%esp
  800183:	53                   	push   %ebx
  800184:	ff 75 10             	pushl  0x10(%ebp)
  800187:	e8 56 00 00 00       	call   8001e2 <vcprintf>
	cprintf("\n");
  80018c:	c7 04 24 73 2c 80 00 	movl   $0x802c73,(%esp)
  800193:	e8 9b 00 00 00       	call   800233 <cprintf>
  800198:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019b:	cc                   	int3   
  80019c:	eb fd                	jmp    80019b <_panic+0x43>

0080019e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	53                   	push   %ebx
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a8:	8b 13                	mov    (%ebx),%edx
  8001aa:	8d 42 01             	lea    0x1(%edx),%eax
  8001ad:	89 03                	mov    %eax,(%ebx)
  8001af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bb:	74 09                	je     8001c6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c6:	83 ec 08             	sub    $0x8,%esp
  8001c9:	68 ff 00 00 00       	push   $0xff
  8001ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d1:	50                   	push   %eax
  8001d2:	e8 36 0a 00 00       	call   800c0d <sys_cputs>
		b->idx = 0;
  8001d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001dd:	83 c4 10             	add    $0x10,%esp
  8001e0:	eb db                	jmp    8001bd <putch+0x1f>

008001e2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f2:	00 00 00 
	b.cnt = 0;
  8001f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ff:	ff 75 0c             	pushl  0xc(%ebp)
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020b:	50                   	push   %eax
  80020c:	68 9e 01 80 00       	push   $0x80019e
  800211:	e8 1a 01 00 00       	call   800330 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800216:	83 c4 08             	add    $0x8,%esp
  800219:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	e8 e2 09 00 00       	call   800c0d <sys_cputs>

	return b.cnt;
}
  80022b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800239:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	e8 9d ff ff ff       	call   8001e2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 1c             	sub    $0x1c,%esp
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 d6                	mov    %edx,%esi
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800260:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80026b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80026e:	39 d3                	cmp    %edx,%ebx
  800270:	72 05                	jb     800277 <printnum+0x30>
  800272:	39 45 10             	cmp    %eax,0x10(%ebp)
  800275:	77 7a                	ja     8002f1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	ff 75 18             	pushl  0x18(%ebp)
  80027d:	8b 45 14             	mov    0x14(%ebp),%eax
  800280:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800283:	53                   	push   %ebx
  800284:	ff 75 10             	pushl  0x10(%ebp)
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028d:	ff 75 e0             	pushl  -0x20(%ebp)
  800290:	ff 75 dc             	pushl  -0x24(%ebp)
  800293:	ff 75 d8             	pushl  -0x28(%ebp)
  800296:	e8 a5 22 00 00       	call   802540 <__udivdi3>
  80029b:	83 c4 18             	add    $0x18,%esp
  80029e:	52                   	push   %edx
  80029f:	50                   	push   %eax
  8002a0:	89 f2                	mov    %esi,%edx
  8002a2:	89 f8                	mov    %edi,%eax
  8002a4:	e8 9e ff ff ff       	call   800247 <printnum>
  8002a9:	83 c4 20             	add    $0x20,%esp
  8002ac:	eb 13                	jmp    8002c1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	56                   	push   %esi
  8002b2:	ff 75 18             	pushl  0x18(%ebp)
  8002b5:	ff d7                	call   *%edi
  8002b7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ba:	83 eb 01             	sub    $0x1,%ebx
  8002bd:	85 db                	test   %ebx,%ebx
  8002bf:	7f ed                	jg     8002ae <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	56                   	push   %esi
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	e8 87 23 00 00       	call   802660 <__umoddi3>
  8002d9:	83 c4 14             	add    $0x14,%esp
  8002dc:	0f be 80 c7 27 80 00 	movsbl 0x8027c7(%eax),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff d7                	call   *%edi
}
  8002e6:	83 c4 10             	add    $0x10,%esp
  8002e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ec:	5b                   	pop    %ebx
  8002ed:	5e                   	pop    %esi
  8002ee:	5f                   	pop    %edi
  8002ef:	5d                   	pop    %ebp
  8002f0:	c3                   	ret    
  8002f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002f4:	eb c4                	jmp    8002ba <printnum+0x73>

008002f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800300:	8b 10                	mov    (%eax),%edx
  800302:	3b 50 04             	cmp    0x4(%eax),%edx
  800305:	73 0a                	jae    800311 <sprintputch+0x1b>
		*b->buf++ = ch;
  800307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030a:	89 08                	mov    %ecx,(%eax)
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	88 02                	mov    %al,(%edx)
}
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <printfmt>:
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800319:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031c:	50                   	push   %eax
  80031d:	ff 75 10             	pushl  0x10(%ebp)
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 05 00 00 00       	call   800330 <vprintfmt>
}
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <vprintfmt>:
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 2c             	sub    $0x2c,%esp
  800339:	8b 75 08             	mov    0x8(%ebp),%esi
  80033c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800342:	e9 21 04 00 00       	jmp    800768 <vprintfmt+0x438>
		padc = ' ';
  800347:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80034b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800352:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800359:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800360:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8d 47 01             	lea    0x1(%edi),%eax
  800368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036b:	0f b6 17             	movzbl (%edi),%edx
  80036e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800371:	3c 55                	cmp    $0x55,%al
  800373:	0f 87 90 04 00 00    	ja     800809 <vprintfmt+0x4d9>
  800379:	0f b6 c0             	movzbl %al,%eax
  80037c:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800386:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80038a:	eb d9                	jmp    800365 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800393:	eb d0                	jmp    800365 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800395:	0f b6 d2             	movzbl %dl,%edx
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ad:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b0:	83 f9 09             	cmp    $0x9,%ecx
  8003b3:	77 55                	ja     80040a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b8:	eb e9                	jmp    8003a3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 40 04             	lea    0x4(%eax),%eax
  8003c8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d2:	79 91                	jns    800365 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003da:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003e1:	eb 82                	jmp    800365 <vprintfmt+0x35>
  8003e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e6:	85 c0                	test   %eax,%eax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	0f 49 d0             	cmovns %eax,%edx
  8003f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f6:	e9 6a ff ff ff       	jmp    800365 <vprintfmt+0x35>
  8003fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fe:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800405:	e9 5b ff ff ff       	jmp    800365 <vprintfmt+0x35>
  80040a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80040d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800410:	eb bc                	jmp    8003ce <vprintfmt+0x9e>
			lflag++;
  800412:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800418:	e9 48 ff ff ff       	jmp    800365 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8d 78 04             	lea    0x4(%eax),%edi
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	53                   	push   %ebx
  800427:	ff 30                	pushl  (%eax)
  800429:	ff d6                	call   *%esi
			break;
  80042b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800431:	e9 2f 03 00 00       	jmp    800765 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8d 78 04             	lea    0x4(%eax),%edi
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	99                   	cltd   
  80043f:	31 d0                	xor    %edx,%eax
  800441:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800443:	83 f8 0f             	cmp    $0xf,%eax
  800446:	7f 23                	jg     80046b <vprintfmt+0x13b>
  800448:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  80044f:	85 d2                	test   %edx,%edx
  800451:	74 18                	je     80046b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800453:	52                   	push   %edx
  800454:	68 3a 2c 80 00       	push   $0x802c3a
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 b3 fe ff ff       	call   800313 <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
  800466:	e9 fa 02 00 00       	jmp    800765 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80046b:	50                   	push   %eax
  80046c:	68 df 27 80 00       	push   $0x8027df
  800471:	53                   	push   %ebx
  800472:	56                   	push   %esi
  800473:	e8 9b fe ff ff       	call   800313 <printfmt>
  800478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047e:	e9 e2 02 00 00       	jmp    800765 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	83 c0 04             	add    $0x4,%eax
  800489:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800491:	85 ff                	test   %edi,%edi
  800493:	b8 d8 27 80 00       	mov    $0x8027d8,%eax
  800498:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80049b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049f:	0f 8e bd 00 00 00    	jle    800562 <vprintfmt+0x232>
  8004a5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a9:	75 0e                	jne    8004b9 <vprintfmt+0x189>
  8004ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b7:	eb 6d                	jmp    800526 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bf:	57                   	push   %edi
  8004c0:	e8 ec 03 00 00       	call   8008b1 <strnlen>
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004d0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004da:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	eb 0f                	jmp    8004ed <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ed                	jg     8004de <vprintfmt+0x1ae>
  8004f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004f7:	85 c9                	test   %ecx,%ecx
  8004f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fe:	0f 49 c1             	cmovns %ecx,%eax
  800501:	29 c1                	sub    %eax,%ecx
  800503:	89 75 08             	mov    %esi,0x8(%ebp)
  800506:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800509:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	eb 16                	jmp    800526 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	75 31                	jne    800547 <vprintfmt+0x217>
					putch(ch, putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	50                   	push   %eax
  80051d:	ff 55 08             	call   *0x8(%ebp)
  800520:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800523:	83 eb 01             	sub    $0x1,%ebx
  800526:	83 c7 01             	add    $0x1,%edi
  800529:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80052d:	0f be c2             	movsbl %dl,%eax
  800530:	85 c0                	test   %eax,%eax
  800532:	74 59                	je     80058d <vprintfmt+0x25d>
  800534:	85 f6                	test   %esi,%esi
  800536:	78 d8                	js     800510 <vprintfmt+0x1e0>
  800538:	83 ee 01             	sub    $0x1,%esi
  80053b:	79 d3                	jns    800510 <vprintfmt+0x1e0>
  80053d:	89 df                	mov    %ebx,%edi
  80053f:	8b 75 08             	mov    0x8(%ebp),%esi
  800542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800545:	eb 37                	jmp    80057e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800547:	0f be d2             	movsbl %dl,%edx
  80054a:	83 ea 20             	sub    $0x20,%edx
  80054d:	83 fa 5e             	cmp    $0x5e,%edx
  800550:	76 c4                	jbe    800516 <vprintfmt+0x1e6>
					putch('?', putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	6a 3f                	push   $0x3f
  80055a:	ff 55 08             	call   *0x8(%ebp)
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	eb c1                	jmp    800523 <vprintfmt+0x1f3>
  800562:	89 75 08             	mov    %esi,0x8(%ebp)
  800565:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800568:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80056e:	eb b6                	jmp    800526 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 20                	push   $0x20
  800576:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800578:	83 ef 01             	sub    $0x1,%edi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	85 ff                	test   %edi,%edi
  800580:	7f ee                	jg     800570 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800582:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	e9 d8 01 00 00       	jmp    800765 <vprintfmt+0x435>
  80058d:	89 df                	mov    %ebx,%edi
  80058f:	8b 75 08             	mov    0x8(%ebp),%esi
  800592:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800595:	eb e7                	jmp    80057e <vprintfmt+0x24e>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7e 45                	jle    8005e1 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b7:	79 62                	jns    80061b <vprintfmt+0x2eb>
				putch('-', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 2d                	push   $0x2d
  8005bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005c7:	f7 d8                	neg    %eax
  8005c9:	83 d2 00             	adc    $0x0,%edx
  8005cc:	f7 da                	neg    %edx
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005dc:	e9 66 01 00 00       	jmp    800747 <vprintfmt+0x417>
	else if (lflag)
  8005e1:	85 c9                	test   %ecx,%ecx
  8005e3:	75 1b                	jne    800600 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 c1                	mov    %eax,%ecx
  8005ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fe:	eb b3                	jmp    8005b3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 c1                	mov    %eax,%ecx
  80060a:	c1 f9 1f             	sar    $0x1f,%ecx
  80060d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 40 04             	lea    0x4(%eax),%eax
  800616:	89 45 14             	mov    %eax,0x14(%ebp)
  800619:	eb 98                	jmp    8005b3 <vprintfmt+0x283>
			base = 10;
  80061b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800620:	e9 22 01 00 00       	jmp    800747 <vprintfmt+0x417>
	if (lflag >= 2)
  800625:	83 f9 01             	cmp    $0x1,%ecx
  800628:	7e 21                	jle    80064b <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 50 04             	mov    0x4(%eax),%edx
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 08             	lea    0x8(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800641:	ba 0a 00 00 00       	mov    $0xa,%edx
  800646:	e9 fc 00 00 00       	jmp    800747 <vprintfmt+0x417>
	else if (lflag)
  80064b:	85 c9                	test   %ecx,%ecx
  80064d:	75 23                	jne    800672 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	ba 00 00 00 00       	mov    $0x0,%edx
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800668:	ba 0a 00 00 00       	mov    $0xa,%edx
  80066d:	e9 d5 00 00 00       	jmp    800747 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800690:	e9 b2 00 00 00       	jmp    800747 <vprintfmt+0x417>
	if (lflag >= 2)
  800695:	83 f9 01             	cmp    $0x1,%ecx
  800698:	7e 42                	jle    8006dc <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 50 04             	mov    0x4(%eax),%edx
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 08             	lea    0x8(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b1:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8006b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ba:	0f 89 87 00 00 00    	jns    800747 <vprintfmt+0x417>
				putch('-', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	6a 2d                	push   $0x2d
  8006c6:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c8:	f7 5d d8             	negl   -0x28(%ebp)
  8006cb:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8006cf:	f7 5d dc             	negl   -0x24(%ebp)
  8006d2:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8006d5:	ba 08 00 00 00       	mov    $0x8,%edx
  8006da:	eb 6b                	jmp    800747 <vprintfmt+0x417>
	else if (lflag)
  8006dc:	85 c9                	test   %ecx,%ecx
  8006de:	75 1b                	jne    8006fb <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f9:	eb b6                	jmp    8006b1 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
  800714:	eb 9b                	jmp    8006b1 <vprintfmt+0x381>
			putch('0', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 30                	push   $0x30
  80071c:	ff d6                	call   *%esi
			putch('x', putdat);
  80071e:	83 c4 08             	add    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 78                	push   $0x78
  800724:	ff d6                	call   *%esi
			num = (unsigned long long)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800733:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800736:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800742:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800747:	83 ec 0c             	sub    $0xc,%esp
  80074a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80074e:	50                   	push   %eax
  80074f:	ff 75 e0             	pushl  -0x20(%ebp)
  800752:	52                   	push   %edx
  800753:	ff 75 dc             	pushl  -0x24(%ebp)
  800756:	ff 75 d8             	pushl  -0x28(%ebp)
  800759:	89 da                	mov    %ebx,%edx
  80075b:	89 f0                	mov    %esi,%eax
  80075d:	e8 e5 fa ff ff       	call   800247 <printnum>
			break;
  800762:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800765:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800768:	83 c7 01             	add    $0x1,%edi
  80076b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076f:	83 f8 25             	cmp    $0x25,%eax
  800772:	0f 84 cf fb ff ff    	je     800347 <vprintfmt+0x17>
			if (ch == '\0')
  800778:	85 c0                	test   %eax,%eax
  80077a:	0f 84 a9 00 00 00    	je     800829 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	50                   	push   %eax
  800785:	ff d6                	call   *%esi
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	eb dc                	jmp    800768 <vprintfmt+0x438>
	if (lflag >= 2)
  80078c:	83 f9 01             	cmp    $0x1,%ecx
  80078f:	7e 1e                	jle    8007af <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 50 04             	mov    0x4(%eax),%edx
  800797:	8b 00                	mov    (%eax),%eax
  800799:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8d 40 08             	lea    0x8(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a8:	ba 10 00 00 00       	mov    $0x10,%edx
  8007ad:	eb 98                	jmp    800747 <vprintfmt+0x417>
	else if (lflag)
  8007af:	85 c9                	test   %ecx,%ecx
  8007b1:	75 23                	jne    8007d6 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8d 40 04             	lea    0x4(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cc:	ba 10 00 00 00       	mov    $0x10,%edx
  8007d1:	e9 71 ff ff ff       	jmp    800747 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ef:	ba 10 00 00 00       	mov    $0x10,%edx
  8007f4:	e9 4e ff ff ff       	jmp    800747 <vprintfmt+0x417>
			putch(ch, putdat);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	53                   	push   %ebx
  8007fd:	6a 25                	push   $0x25
  8007ff:	ff d6                	call   *%esi
			break;
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	e9 5c ff ff ff       	jmp    800765 <vprintfmt+0x435>
			putch('%', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	53                   	push   %ebx
  80080d:	6a 25                	push   $0x25
  80080f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	89 f8                	mov    %edi,%eax
  800816:	eb 03                	jmp    80081b <vprintfmt+0x4eb>
  800818:	83 e8 01             	sub    $0x1,%eax
  80081b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80081f:	75 f7                	jne    800818 <vprintfmt+0x4e8>
  800821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800824:	e9 3c ff ff ff       	jmp    800765 <vprintfmt+0x435>
}
  800829:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80082c:	5b                   	pop    %ebx
  80082d:	5e                   	pop    %esi
  80082e:	5f                   	pop    %edi
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 18             	sub    $0x18,%esp
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800840:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800844:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800847:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084e:	85 c0                	test   %eax,%eax
  800850:	74 26                	je     800878 <vsnprintf+0x47>
  800852:	85 d2                	test   %edx,%edx
  800854:	7e 22                	jle    800878 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800856:	ff 75 14             	pushl  0x14(%ebp)
  800859:	ff 75 10             	pushl  0x10(%ebp)
  80085c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80085f:	50                   	push   %eax
  800860:	68 f6 02 80 00       	push   $0x8002f6
  800865:	e8 c6 fa ff ff       	call   800330 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800873:	83 c4 10             	add    $0x10,%esp
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    
		return -E_INVAL;
  800878:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087d:	eb f7                	jmp    800876 <vsnprintf+0x45>

0080087f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800885:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800888:	50                   	push   %eax
  800889:	ff 75 10             	pushl  0x10(%ebp)
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	ff 75 08             	pushl  0x8(%ebp)
  800892:	e8 9a ff ff ff       	call   800831 <vsnprintf>
	va_end(ap);

	return rc;
}
  800897:	c9                   	leave  
  800898:	c3                   	ret    

00800899 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	eb 03                	jmp    8008a9 <strlen+0x10>
		n++;
  8008a6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008a9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ad:	75 f7                	jne    8008a6 <strlen+0xd>
	return n;
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bf:	eb 03                	jmp    8008c4 <strnlen+0x13>
		n++;
  8008c1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c4:	39 d0                	cmp    %edx,%eax
  8008c6:	74 06                	je     8008ce <strnlen+0x1d>
  8008c8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008cc:	75 f3                	jne    8008c1 <strnlen+0x10>
	return n;
}
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	53                   	push   %ebx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008da:	89 c2                	mov    %eax,%edx
  8008dc:	83 c1 01             	add    $0x1,%ecx
  8008df:	83 c2 01             	add    $0x1,%edx
  8008e2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e9:	84 db                	test   %bl,%bl
  8008eb:	75 ef                	jne    8008dc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008ed:	5b                   	pop    %ebx
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	53                   	push   %ebx
  8008f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f7:	53                   	push   %ebx
  8008f8:	e8 9c ff ff ff       	call   800899 <strlen>
  8008fd:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	01 d8                	add    %ebx,%eax
  800905:	50                   	push   %eax
  800906:	e8 c5 ff ff ff       	call   8008d0 <strcpy>
	return dst;
}
  80090b:	89 d8                	mov    %ebx,%eax
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	89 f3                	mov    %esi,%ebx
  80091f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800922:	89 f2                	mov    %esi,%edx
  800924:	eb 0f                	jmp    800935 <strncpy+0x23>
		*dst++ = *src;
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092f:	80 39 01             	cmpb   $0x1,(%ecx)
  800932:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800935:	39 da                	cmp    %ebx,%edx
  800937:	75 ed                	jne    800926 <strncpy+0x14>
	}
	return ret;
}
  800939:	89 f0                	mov    %esi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 75 08             	mov    0x8(%ebp),%esi
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094d:	89 f0                	mov    %esi,%eax
  80094f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800953:	85 c9                	test   %ecx,%ecx
  800955:	75 0b                	jne    800962 <strlcpy+0x23>
  800957:	eb 17                	jmp    800970 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800959:	83 c2 01             	add    $0x1,%edx
  80095c:	83 c0 01             	add    $0x1,%eax
  80095f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800962:	39 d8                	cmp    %ebx,%eax
  800964:	74 07                	je     80096d <strlcpy+0x2e>
  800966:	0f b6 0a             	movzbl (%edx),%ecx
  800969:	84 c9                	test   %cl,%cl
  80096b:	75 ec                	jne    800959 <strlcpy+0x1a>
		*dst = '\0';
  80096d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800970:	29 f0                	sub    %esi,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80097f:	eb 06                	jmp    800987 <strcmp+0x11>
		p++, q++;
  800981:	83 c1 01             	add    $0x1,%ecx
  800984:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800987:	0f b6 01             	movzbl (%ecx),%eax
  80098a:	84 c0                	test   %al,%al
  80098c:	74 04                	je     800992 <strcmp+0x1c>
  80098e:	3a 02                	cmp    (%edx),%al
  800990:	74 ef                	je     800981 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800992:	0f b6 c0             	movzbl %al,%eax
  800995:	0f b6 12             	movzbl (%edx),%edx
  800998:	29 d0                	sub    %edx,%eax
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 c3                	mov    %eax,%ebx
  8009a8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ab:	eb 06                	jmp    8009b3 <strncmp+0x17>
		n--, p++, q++;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b3:	39 d8                	cmp    %ebx,%eax
  8009b5:	74 16                	je     8009cd <strncmp+0x31>
  8009b7:	0f b6 08             	movzbl (%eax),%ecx
  8009ba:	84 c9                	test   %cl,%cl
  8009bc:	74 04                	je     8009c2 <strncmp+0x26>
  8009be:	3a 0a                	cmp    (%edx),%cl
  8009c0:	74 eb                	je     8009ad <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c2:	0f b6 00             	movzbl (%eax),%eax
  8009c5:	0f b6 12             	movzbl (%edx),%edx
  8009c8:	29 d0                	sub    %edx,%eax
}
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    
		return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d2:	eb f6                	jmp    8009ca <strncmp+0x2e>

008009d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009de:	0f b6 10             	movzbl (%eax),%edx
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	74 09                	je     8009ee <strchr+0x1a>
		if (*s == c)
  8009e5:	38 ca                	cmp    %cl,%dl
  8009e7:	74 0a                	je     8009f3 <strchr+0x1f>
	for (; *s; s++)
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	eb f0                	jmp    8009de <strchr+0xa>
			return (char *) s;
	return 0;
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ff:	eb 03                	jmp    800a04 <strfind+0xf>
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a07:	38 ca                	cmp    %cl,%dl
  800a09:	74 04                	je     800a0f <strfind+0x1a>
  800a0b:	84 d2                	test   %dl,%dl
  800a0d:	75 f2                	jne    800a01 <strfind+0xc>
			break;
	return (char *) s;
}
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a1d:	85 c9                	test   %ecx,%ecx
  800a1f:	74 13                	je     800a34 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a21:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a27:	75 05                	jne    800a2e <memset+0x1d>
  800a29:	f6 c1 03             	test   $0x3,%cl
  800a2c:	74 0d                	je     800a3b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	fc                   	cld    
  800a32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a34:	89 f8                	mov    %edi,%eax
  800a36:	5b                   	pop    %ebx
  800a37:	5e                   	pop    %esi
  800a38:	5f                   	pop    %edi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    
		c &= 0xFF;
  800a3b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a3f:	89 d3                	mov    %edx,%ebx
  800a41:	c1 e3 08             	shl    $0x8,%ebx
  800a44:	89 d0                	mov    %edx,%eax
  800a46:	c1 e0 18             	shl    $0x18,%eax
  800a49:	89 d6                	mov    %edx,%esi
  800a4b:	c1 e6 10             	shl    $0x10,%esi
  800a4e:	09 f0                	or     %esi,%eax
  800a50:	09 c2                	or     %eax,%edx
  800a52:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a54:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a57:	89 d0                	mov    %edx,%eax
  800a59:	fc                   	cld    
  800a5a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a5c:	eb d6                	jmp    800a34 <memset+0x23>

00800a5e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	57                   	push   %edi
  800a62:	56                   	push   %esi
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a6c:	39 c6                	cmp    %eax,%esi
  800a6e:	73 35                	jae    800aa5 <memmove+0x47>
  800a70:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a73:	39 c2                	cmp    %eax,%edx
  800a75:	76 2e                	jbe    800aa5 <memmove+0x47>
		s += n;
		d += n;
  800a77:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7a:	89 d6                	mov    %edx,%esi
  800a7c:	09 fe                	or     %edi,%esi
  800a7e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a84:	74 0c                	je     800a92 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a86:	83 ef 01             	sub    $0x1,%edi
  800a89:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a8c:	fd                   	std    
  800a8d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8f:	fc                   	cld    
  800a90:	eb 21                	jmp    800ab3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a92:	f6 c1 03             	test   $0x3,%cl
  800a95:	75 ef                	jne    800a86 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a97:	83 ef 04             	sub    $0x4,%edi
  800a9a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a9d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa0:	fd                   	std    
  800aa1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa3:	eb ea                	jmp    800a8f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa5:	89 f2                	mov    %esi,%edx
  800aa7:	09 c2                	or     %eax,%edx
  800aa9:	f6 c2 03             	test   $0x3,%dl
  800aac:	74 09                	je     800ab7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aae:	89 c7                	mov    %eax,%edi
  800ab0:	fc                   	cld    
  800ab1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab3:	5e                   	pop    %esi
  800ab4:	5f                   	pop    %edi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab7:	f6 c1 03             	test   $0x3,%cl
  800aba:	75 f2                	jne    800aae <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800abc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800abf:	89 c7                	mov    %eax,%edi
  800ac1:	fc                   	cld    
  800ac2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac4:	eb ed                	jmp    800ab3 <memmove+0x55>

00800ac6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ac9:	ff 75 10             	pushl  0x10(%ebp)
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	ff 75 08             	pushl  0x8(%ebp)
  800ad2:	e8 87 ff ff ff       	call   800a5e <memmove>
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 c6                	mov    %eax,%esi
  800ae6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae9:	39 f0                	cmp    %esi,%eax
  800aeb:	74 1c                	je     800b09 <memcmp+0x30>
		if (*s1 != *s2)
  800aed:	0f b6 08             	movzbl (%eax),%ecx
  800af0:	0f b6 1a             	movzbl (%edx),%ebx
  800af3:	38 d9                	cmp    %bl,%cl
  800af5:	75 08                	jne    800aff <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800af7:	83 c0 01             	add    $0x1,%eax
  800afa:	83 c2 01             	add    $0x1,%edx
  800afd:	eb ea                	jmp    800ae9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aff:	0f b6 c1             	movzbl %cl,%eax
  800b02:	0f b6 db             	movzbl %bl,%ebx
  800b05:	29 d8                	sub    %ebx,%eax
  800b07:	eb 05                	jmp    800b0e <memcmp+0x35>
	}

	return 0;
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b1b:	89 c2                	mov    %eax,%edx
  800b1d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b20:	39 d0                	cmp    %edx,%eax
  800b22:	73 09                	jae    800b2d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b24:	38 08                	cmp    %cl,(%eax)
  800b26:	74 05                	je     800b2d <memfind+0x1b>
	for (; s < ends; s++)
  800b28:	83 c0 01             	add    $0x1,%eax
  800b2b:	eb f3                	jmp    800b20 <memfind+0xe>
			break;
	return (void *) s;
}
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3b:	eb 03                	jmp    800b40 <strtol+0x11>
		s++;
  800b3d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b40:	0f b6 01             	movzbl (%ecx),%eax
  800b43:	3c 20                	cmp    $0x20,%al
  800b45:	74 f6                	je     800b3d <strtol+0xe>
  800b47:	3c 09                	cmp    $0x9,%al
  800b49:	74 f2                	je     800b3d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b4b:	3c 2b                	cmp    $0x2b,%al
  800b4d:	74 2e                	je     800b7d <strtol+0x4e>
	int neg = 0;
  800b4f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b54:	3c 2d                	cmp    $0x2d,%al
  800b56:	74 2f                	je     800b87 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b58:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b5e:	75 05                	jne    800b65 <strtol+0x36>
  800b60:	80 39 30             	cmpb   $0x30,(%ecx)
  800b63:	74 2c                	je     800b91 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b65:	85 db                	test   %ebx,%ebx
  800b67:	75 0a                	jne    800b73 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b69:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b71:	74 28                	je     800b9b <strtol+0x6c>
		base = 10;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b7b:	eb 50                	jmp    800bcd <strtol+0x9e>
		s++;
  800b7d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
  800b85:	eb d1                	jmp    800b58 <strtol+0x29>
		s++, neg = 1;
  800b87:	83 c1 01             	add    $0x1,%ecx
  800b8a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b8f:	eb c7                	jmp    800b58 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b95:	74 0e                	je     800ba5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b97:	85 db                	test   %ebx,%ebx
  800b99:	75 d8                	jne    800b73 <strtol+0x44>
		s++, base = 8;
  800b9b:	83 c1 01             	add    $0x1,%ecx
  800b9e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ba3:	eb ce                	jmp    800b73 <strtol+0x44>
		s += 2, base = 16;
  800ba5:	83 c1 02             	add    $0x2,%ecx
  800ba8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bad:	eb c4                	jmp    800b73 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800baf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bb2:	89 f3                	mov    %esi,%ebx
  800bb4:	80 fb 19             	cmp    $0x19,%bl
  800bb7:	77 29                	ja     800be2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bb9:	0f be d2             	movsbl %dl,%edx
  800bbc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bbf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bc2:	7d 30                	jge    800bf4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bc4:	83 c1 01             	add    $0x1,%ecx
  800bc7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bcb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bcd:	0f b6 11             	movzbl (%ecx),%edx
  800bd0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bd3:	89 f3                	mov    %esi,%ebx
  800bd5:	80 fb 09             	cmp    $0x9,%bl
  800bd8:	77 d5                	ja     800baf <strtol+0x80>
			dig = *s - '0';
  800bda:	0f be d2             	movsbl %dl,%edx
  800bdd:	83 ea 30             	sub    $0x30,%edx
  800be0:	eb dd                	jmp    800bbf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800be2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 19             	cmp    $0x19,%bl
  800bea:	77 08                	ja     800bf4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bec:	0f be d2             	movsbl %dl,%edx
  800bef:	83 ea 37             	sub    $0x37,%edx
  800bf2:	eb cb                	jmp    800bbf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf8:	74 05                	je     800bff <strtol+0xd0>
		*endptr = (char *) s;
  800bfa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bff:	89 c2                	mov    %eax,%edx
  800c01:	f7 da                	neg    %edx
  800c03:	85 ff                	test   %edi,%edi
  800c05:	0f 45 c2             	cmovne %edx,%eax
}
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	89 c3                	mov    %eax,%ebx
  800c20:	89 c7                	mov    %eax,%edi
  800c22:	89 c6                	mov    %eax,%esi
  800c24:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3b:	89 d1                	mov    %edx,%ecx
  800c3d:	89 d3                	mov    %edx,%ebx
  800c3f:	89 d7                	mov    %edx,%edi
  800c41:	89 d6                	mov    %edx,%esi
  800c43:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c53:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c60:	89 cb                	mov    %ecx,%ebx
  800c62:	89 cf                	mov    %ecx,%edi
  800c64:	89 ce                	mov    %ecx,%esi
  800c66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	7f 08                	jg     800c74 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	50                   	push   %eax
  800c78:	6a 03                	push   $0x3
  800c7a:	68 bf 2a 80 00       	push   $0x802abf
  800c7f:	6a 23                	push   $0x23
  800c81:	68 dc 2a 80 00       	push   $0x802adc
  800c86:	e8 cd f4 ff ff       	call   800158 <_panic>

00800c8b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c91:	ba 00 00 00 00       	mov    $0x0,%edx
  800c96:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9b:	89 d1                	mov    %edx,%ecx
  800c9d:	89 d3                	mov    %edx,%ebx
  800c9f:	89 d7                	mov    %edx,%edi
  800ca1:	89 d6                	mov    %edx,%esi
  800ca3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <sys_yield>:

void
sys_yield(void)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cba:	89 d1                	mov    %edx,%ecx
  800cbc:	89 d3                	mov    %edx,%ebx
  800cbe:	89 d7                	mov    %edx,%edi
  800cc0:	89 d6                	mov    %edx,%esi
  800cc2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd2:	be 00 00 00 00       	mov    $0x0,%esi
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdd:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce5:	89 f7                	mov    %esi,%edi
  800ce7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	7f 08                	jg     800cf5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf5:	83 ec 0c             	sub    $0xc,%esp
  800cf8:	50                   	push   %eax
  800cf9:	6a 04                	push   $0x4
  800cfb:	68 bf 2a 80 00       	push   $0x802abf
  800d00:	6a 23                	push   $0x23
  800d02:	68 dc 2a 80 00       	push   $0x802adc
  800d07:	e8 4c f4 ff ff       	call   800158 <_panic>

00800d0c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d20:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d23:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d26:	8b 75 18             	mov    0x18(%ebp),%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 05                	push   $0x5
  800d3d:	68 bf 2a 80 00       	push   $0x802abf
  800d42:	6a 23                	push   $0x23
  800d44:	68 dc 2a 80 00       	push   $0x802adc
  800d49:	e8 0a f4 ff ff       	call   800158 <_panic>

00800d4e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	b8 06 00 00 00       	mov    $0x6,%eax
  800d67:	89 df                	mov    %ebx,%edi
  800d69:	89 de                	mov    %ebx,%esi
  800d6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	7f 08                	jg     800d79 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	83 ec 0c             	sub    $0xc,%esp
  800d7c:	50                   	push   %eax
  800d7d:	6a 06                	push   $0x6
  800d7f:	68 bf 2a 80 00       	push   $0x802abf
  800d84:	6a 23                	push   $0x23
  800d86:	68 dc 2a 80 00       	push   $0x802adc
  800d8b:	e8 c8 f3 ff ff       	call   800158 <_panic>

00800d90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 08 00 00 00       	mov    $0x8,%eax
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 08                	push   $0x8
  800dc1:	68 bf 2a 80 00       	push   $0x802abf
  800dc6:	6a 23                	push   $0x23
  800dc8:	68 dc 2a 80 00       	push   $0x802adc
  800dcd:	e8 86 f3 ff ff       	call   800158 <_panic>

00800dd2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 09 00 00 00       	mov    $0x9,%eax
  800deb:	89 df                	mov    %ebx,%edi
  800ded:	89 de                	mov    %ebx,%esi
  800def:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 09                	push   $0x9
  800e03:	68 bf 2a 80 00       	push   $0x802abf
  800e08:	6a 23                	push   $0x23
  800e0a:	68 dc 2a 80 00       	push   $0x802adc
  800e0f:	e8 44 f3 ff ff       	call   800158 <_panic>

00800e14 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2d:	89 df                	mov    %ebx,%edi
  800e2f:	89 de                	mov    %ebx,%esi
  800e31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 0a                	push   $0xa
  800e45:	68 bf 2a 80 00       	push   $0x802abf
  800e4a:	6a 23                	push   $0x23
  800e4c:	68 dc 2a 80 00       	push   $0x802adc
  800e51:	e8 02 f3 ff ff       	call   800158 <_panic>

00800e56 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e67:	be 00 00 00 00       	mov    $0x0,%esi
  800e6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e72:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8f:	89 cb                	mov    %ecx,%ebx
  800e91:	89 cf                	mov    %ecx,%edi
  800e93:	89 ce                	mov    %ecx,%esi
  800e95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7f 08                	jg     800ea3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	50                   	push   %eax
  800ea7:	6a 0d                	push   $0xd
  800ea9:	68 bf 2a 80 00       	push   $0x802abf
  800eae:	6a 23                	push   $0x23
  800eb0:	68 dc 2a 80 00       	push   $0x802adc
  800eb5:	e8 9e f2 ff ff       	call   800158 <_panic>

00800eba <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eca:	89 d1                	mov    %edx,%ecx
  800ecc:	89 d3                	mov    %edx,%ebx
  800ece:	89 d7                	mov    %edx,%edi
  800ed0:	89 d6                	mov    %edx,%esi
  800ed2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 1c             	sub    $0x1c,%esp
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800ee5:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800ee7:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800eea:	89 d8                	mov    %ebx,%eax
  800eec:	c1 e8 0c             	shr    $0xc,%eax
  800eef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ef6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800ef9:	e8 8d fd ff ff       	call   800c8b <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800efe:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800f04:	74 73                	je     800f79 <pgfault+0xa0>
  800f06:	89 c6                	mov    %eax,%esi
  800f08:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800f0f:	74 68                	je     800f79 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800f11:	83 ec 04             	sub    $0x4,%esp
  800f14:	6a 07                	push   $0x7
  800f16:	68 00 f0 7f 00       	push   $0x7ff000
  800f1b:	50                   	push   %eax
  800f1c:	e8 a8 fd ff ff       	call   800cc9 <sys_page_alloc>
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 65                	jne    800f8d <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800f28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800f2e:	83 ec 04             	sub    $0x4,%esp
  800f31:	68 00 10 00 00       	push   $0x1000
  800f36:	53                   	push   %ebx
  800f37:	68 00 f0 7f 00       	push   $0x7ff000
  800f3c:	e8 85 fb ff ff       	call   800ac6 <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800f41:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f48:	53                   	push   %ebx
  800f49:	56                   	push   %esi
  800f4a:	68 00 f0 7f 00       	push   $0x7ff000
  800f4f:	56                   	push   %esi
  800f50:	e8 b7 fd ff ff       	call   800d0c <sys_page_map>
  800f55:	83 c4 20             	add    $0x20,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	75 43                	jne    800f9f <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	68 00 f0 7f 00       	push   $0x7ff000
  800f64:	56                   	push   %esi
  800f65:	e8 e4 fd ff ff       	call   800d4e <sys_page_unmap>
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 40                	jne    800fb1 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800f79:	83 ec 04             	sub    $0x4,%esp
  800f7c:	68 ea 2a 80 00       	push   $0x802aea
  800f81:	6a 1f                	push   $0x1f
  800f83:	68 08 2b 80 00       	push   $0x802b08
  800f88:	e8 cb f1 ff ff       	call   800158 <_panic>
	    panic("pgfault: %e", r);
  800f8d:	50                   	push   %eax
  800f8e:	68 13 2b 80 00       	push   $0x802b13
  800f93:	6a 2a                	push   $0x2a
  800f95:	68 08 2b 80 00       	push   $0x802b08
  800f9a:	e8 b9 f1 ff ff       	call   800158 <_panic>
	    panic("pgfault: %e", r);
  800f9f:	50                   	push   %eax
  800fa0:	68 13 2b 80 00       	push   $0x802b13
  800fa5:	6a 2e                	push   $0x2e
  800fa7:	68 08 2b 80 00       	push   $0x802b08
  800fac:	e8 a7 f1 ff ff       	call   800158 <_panic>
	    panic("pgfault: %e", r);
  800fb1:	50                   	push   %eax
  800fb2:	68 13 2b 80 00       	push   $0x802b13
  800fb7:	6a 31                	push   $0x31
  800fb9:	68 08 2b 80 00       	push   $0x802b08
  800fbe:	e8 95 f1 ff ff       	call   800158 <_panic>

00800fc3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  800fcc:	68 d9 0e 80 00       	push   $0x800ed9
  800fd1:	e8 89 14 00 00       	call   80245f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fd6:	b8 07 00 00 00       	mov    $0x7,%eax
  800fdb:	cd 30                	int    $0x30
  800fdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 2b                	js     801015 <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fea:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800fef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ff3:	0f 85 b5 00 00 00    	jne    8010ae <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  800ff9:	e8 8d fc ff ff       	call   800c8b <sys_getenvid>
  800ffe:	25 ff 03 00 00       	and    $0x3ff,%eax
  801003:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801006:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80100b:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  801010:	e9 8c 01 00 00       	jmp    8011a1 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  801015:	50                   	push   %eax
  801016:	68 1f 2b 80 00       	push   $0x802b1f
  80101b:	6a 77                	push   $0x77
  80101d:	68 08 2b 80 00       	push   $0x802b08
  801022:	e8 31 f1 ff ff       	call   800158 <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  801027:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	25 07 0e 00 00       	and    $0xe07,%eax
  801036:	50                   	push   %eax
  801037:	57                   	push   %edi
  801038:	ff 75 e0             	pushl  -0x20(%ebp)
  80103b:	57                   	push   %edi
  80103c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103f:	e8 c8 fc ff ff       	call   800d0c <sys_page_map>
  801044:	83 c4 20             	add    $0x20,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	74 51                	je     80109c <fork+0xd9>
           panic("duppage: %e", r);
  80104b:	50                   	push   %eax
  80104c:	68 2f 2b 80 00       	push   $0x802b2f
  801051:	6a 4a                	push   $0x4a
  801053:	68 08 2b 80 00       	push   $0x802b08
  801058:	e8 fb f0 ff ff       	call   800158 <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	68 05 08 00 00       	push   $0x805
  801065:	57                   	push   %edi
  801066:	ff 75 e0             	pushl  -0x20(%ebp)
  801069:	57                   	push   %edi
  80106a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80106d:	e8 9a fc ff ff       	call   800d0c <sys_page_map>
  801072:	83 c4 20             	add    $0x20,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	0f 85 bc 00 00 00    	jne    801139 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  80107d:	83 ec 0c             	sub    $0xc,%esp
  801080:	68 05 08 00 00       	push   $0x805
  801085:	57                   	push   %edi
  801086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801089:	50                   	push   %eax
  80108a:	57                   	push   %edi
  80108b:	50                   	push   %eax
  80108c:	e8 7b fc ff ff       	call   800d0c <sys_page_map>
  801091:	83 c4 20             	add    $0x20,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	0f 85 af 00 00 00    	jne    80114b <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80109c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010a2:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010a8:	0f 84 af 00 00 00    	je     80115d <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  8010ae:	89 d8                	mov    %ebx,%eax
  8010b0:	c1 e8 16             	shr    $0x16,%eax
  8010b3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ba:	a8 01                	test   $0x1,%al
  8010bc:	74 de                	je     80109c <fork+0xd9>
  8010be:	89 de                	mov    %ebx,%esi
  8010c0:	c1 ee 0c             	shr    $0xc,%esi
  8010c3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010ca:	a8 01                	test   $0x1,%al
  8010cc:	74 ce                	je     80109c <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  8010ce:	e8 b8 fb ff ff       	call   800c8b <sys_getenvid>
  8010d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  8010d6:	89 f7                	mov    %esi,%edi
  8010d8:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  8010db:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010e2:	f6 c4 04             	test   $0x4,%ah
  8010e5:	0f 85 3c ff ff ff    	jne    801027 <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  8010eb:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f2:	a8 02                	test   $0x2,%al
  8010f4:	0f 85 63 ff ff ff    	jne    80105d <fork+0x9a>
  8010fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801101:	f6 c4 08             	test   $0x8,%ah
  801104:	0f 85 53 ff ff ff    	jne    80105d <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	6a 05                	push   $0x5
  80110f:	57                   	push   %edi
  801110:	ff 75 e0             	pushl  -0x20(%ebp)
  801113:	57                   	push   %edi
  801114:	ff 75 e4             	pushl  -0x1c(%ebp)
  801117:	e8 f0 fb ff ff       	call   800d0c <sys_page_map>
  80111c:	83 c4 20             	add    $0x20,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	0f 84 75 ff ff ff    	je     80109c <fork+0xd9>
	        panic("duppage: %e", r);
  801127:	50                   	push   %eax
  801128:	68 2f 2b 80 00       	push   $0x802b2f
  80112d:	6a 55                	push   $0x55
  80112f:	68 08 2b 80 00       	push   $0x802b08
  801134:	e8 1f f0 ff ff       	call   800158 <_panic>
	        panic("duppage: %e", r);
  801139:	50                   	push   %eax
  80113a:	68 2f 2b 80 00       	push   $0x802b2f
  80113f:	6a 4e                	push   $0x4e
  801141:	68 08 2b 80 00       	push   $0x802b08
  801146:	e8 0d f0 ff ff       	call   800158 <_panic>
	        panic("duppage: %e", r);
  80114b:	50                   	push   %eax
  80114c:	68 2f 2b 80 00       	push   $0x802b2f
  801151:	6a 51                	push   $0x51
  801153:	68 08 2b 80 00       	push   $0x802b08
  801158:	e8 fb ef ff ff       	call   800158 <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80115d:	83 ec 04             	sub    $0x4,%esp
  801160:	6a 07                	push   $0x7
  801162:	68 00 f0 bf ee       	push   $0xeebff000
  801167:	ff 75 dc             	pushl  -0x24(%ebp)
  80116a:	e8 5a fb ff ff       	call   800cc9 <sys_page_alloc>
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	75 36                	jne    8011ac <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	68 d8 24 80 00       	push   $0x8024d8
  80117e:	ff 75 dc             	pushl  -0x24(%ebp)
  801181:	e8 8e fc ff ff       	call   800e14 <sys_env_set_pgfault_upcall>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	75 34                	jne    8011c1 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  80118d:	83 ec 08             	sub    $0x8,%esp
  801190:	6a 02                	push   $0x2
  801192:	ff 75 dc             	pushl  -0x24(%ebp)
  801195:	e8 f6 fb ff ff       	call   800d90 <sys_env_set_status>
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 35                	jne    8011d6 <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  8011a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    
	    panic("fork: %e", r);
  8011ac:	50                   	push   %eax
  8011ad:	68 26 2b 80 00       	push   $0x802b26
  8011b2:	68 8a 00 00 00       	push   $0x8a
  8011b7:	68 08 2b 80 00       	push   $0x802b08
  8011bc:	e8 97 ef ff ff       	call   800158 <_panic>
	    panic("fork: %e", r);
  8011c1:	50                   	push   %eax
  8011c2:	68 26 2b 80 00       	push   $0x802b26
  8011c7:	68 8d 00 00 00       	push   $0x8d
  8011cc:	68 08 2b 80 00       	push   $0x802b08
  8011d1:	e8 82 ef ff ff       	call   800158 <_panic>
	    panic("fork: %e", r);
  8011d6:	50                   	push   %eax
  8011d7:	68 26 2b 80 00       	push   $0x802b26
  8011dc:	68 92 00 00 00       	push   $0x92
  8011e1:	68 08 2b 80 00       	push   $0x802b08
  8011e6:	e8 6d ef ff ff       	call   800158 <_panic>

008011eb <sfork>:

// Challenge!
int
sfork(void)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011f1:	68 3b 2b 80 00       	push   $0x802b3b
  8011f6:	68 9b 00 00 00       	push   $0x9b
  8011fb:	68 08 2b 80 00       	push   $0x802b08
  801200:	e8 53 ef ff ff       	call   800158 <_panic>

00801205 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	8b 75 08             	mov    0x8(%ebp),%esi
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801213:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801215:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80121a:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  80121d:	83 ec 0c             	sub    $0xc,%esp
  801220:	50                   	push   %eax
  801221:	e8 53 fc ff ff       	call   800e79 <sys_ipc_recv>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	78 2b                	js     801258 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  80122d:	85 f6                	test   %esi,%esi
  80122f:	74 0a                	je     80123b <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801231:	a1 08 40 80 00       	mov    0x804008,%eax
  801236:	8b 40 74             	mov    0x74(%eax),%eax
  801239:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  80123b:	85 db                	test   %ebx,%ebx
  80123d:	74 0a                	je     801249 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  80123f:	a1 08 40 80 00       	mov    0x804008,%eax
  801244:	8b 40 78             	mov    0x78(%eax),%eax
  801247:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801249:	a1 08 40 80 00       	mov    0x804008,%eax
  80124e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801251:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    
	    if (from_env_store != NULL) {
  801258:	85 f6                	test   %esi,%esi
  80125a:	74 06                	je     801262 <ipc_recv+0x5d>
	        *from_env_store = 0;
  80125c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801262:	85 db                	test   %ebx,%ebx
  801264:	74 eb                	je     801251 <ipc_recv+0x4c>
	        *perm_store = 0;
  801266:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80126c:	eb e3                	jmp    801251 <ipc_recv+0x4c>

0080126e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	57                   	push   %edi
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
  801274:	83 ec 0c             	sub    $0xc,%esp
  801277:	8b 7d 08             	mov    0x8(%ebp),%edi
  80127a:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  80127d:	85 f6                	test   %esi,%esi
  80127f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801284:	0f 44 f0             	cmove  %eax,%esi
  801287:	eb 09                	jmp    801292 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  801289:	e8 1c fa ff ff       	call   800caa <sys_yield>
	} while(r != 0);
  80128e:	85 db                	test   %ebx,%ebx
  801290:	74 2d                	je     8012bf <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  801292:	ff 75 14             	pushl  0x14(%ebp)
  801295:	56                   	push   %esi
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	57                   	push   %edi
  80129a:	e8 b7 fb ff ff       	call   800e56 <sys_ipc_try_send>
  80129f:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	79 e1                	jns    801289 <ipc_send+0x1b>
  8012a8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012ab:	74 dc                	je     801289 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  8012ad:	50                   	push   %eax
  8012ae:	68 51 2b 80 00       	push   $0x802b51
  8012b3:	6a 45                	push   $0x45
  8012b5:	68 5e 2b 80 00       	push   $0x802b5e
  8012ba:	e8 99 ee ff ff       	call   800158 <_panic>
}
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012d2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012d5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012db:	8b 52 50             	mov    0x50(%edx),%edx
  8012de:	39 ca                	cmp    %ecx,%edx
  8012e0:	74 11                	je     8012f3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8012e2:	83 c0 01             	add    $0x1,%eax
  8012e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012ea:	75 e6                	jne    8012d2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	eb 0b                	jmp    8012fe <ipc_find_env+0x37>
			return envs[i].env_id;
  8012f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012fb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	05 00 00 00 30       	add    $0x30000000,%eax
  80130b:	c1 e8 0c             	shr    $0xc,%eax
}
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80131b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801320:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801325:	5d                   	pop    %ebp
  801326:	c3                   	ret    

00801327 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801332:	89 c2                	mov    %eax,%edx
  801334:	c1 ea 16             	shr    $0x16,%edx
  801337:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133e:	f6 c2 01             	test   $0x1,%dl
  801341:	74 2a                	je     80136d <fd_alloc+0x46>
  801343:	89 c2                	mov    %eax,%edx
  801345:	c1 ea 0c             	shr    $0xc,%edx
  801348:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134f:	f6 c2 01             	test   $0x1,%dl
  801352:	74 19                	je     80136d <fd_alloc+0x46>
  801354:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801359:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80135e:	75 d2                	jne    801332 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801360:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801366:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80136b:	eb 07                	jmp    801374 <fd_alloc+0x4d>
			*fd_store = fd;
  80136d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80137c:	83 f8 1f             	cmp    $0x1f,%eax
  80137f:	77 36                	ja     8013b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801381:	c1 e0 0c             	shl    $0xc,%eax
  801384:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801389:	89 c2                	mov    %eax,%edx
  80138b:	c1 ea 16             	shr    $0x16,%edx
  80138e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801395:	f6 c2 01             	test   $0x1,%dl
  801398:	74 24                	je     8013be <fd_lookup+0x48>
  80139a:	89 c2                	mov    %eax,%edx
  80139c:	c1 ea 0c             	shr    $0xc,%edx
  80139f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013a6:	f6 c2 01             	test   $0x1,%dl
  8013a9:	74 1a                	je     8013c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    
		return -E_INVAL;
  8013b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bc:	eb f7                	jmp    8013b5 <fd_lookup+0x3f>
		return -E_INVAL;
  8013be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c3:	eb f0                	jmp    8013b5 <fd_lookup+0x3f>
  8013c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ca:	eb e9                	jmp    8013b5 <fd_lookup+0x3f>

008013cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d5:	ba e4 2b 80 00       	mov    $0x802be4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013da:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013df:	39 08                	cmp    %ecx,(%eax)
  8013e1:	74 33                	je     801416 <dev_lookup+0x4a>
  8013e3:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013e6:	8b 02                	mov    (%edx),%eax
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	75 f3                	jne    8013df <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f1:	8b 40 48             	mov    0x48(%eax),%eax
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	51                   	push   %ecx
  8013f8:	50                   	push   %eax
  8013f9:	68 68 2b 80 00       	push   $0x802b68
  8013fe:	e8 30 ee ff ff       	call   800233 <cprintf>
	*dev = 0;
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    
			*dev = devtab[i];
  801416:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801419:	89 01                	mov    %eax,(%ecx)
			return 0;
  80141b:	b8 00 00 00 00       	mov    $0x0,%eax
  801420:	eb f2                	jmp    801414 <dev_lookup+0x48>

00801422 <fd_close>:
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	57                   	push   %edi
  801426:	56                   	push   %esi
  801427:	53                   	push   %ebx
  801428:	83 ec 1c             	sub    $0x1c,%esp
  80142b:	8b 75 08             	mov    0x8(%ebp),%esi
  80142e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801431:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801434:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801435:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80143b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80143e:	50                   	push   %eax
  80143f:	e8 32 ff ff ff       	call   801376 <fd_lookup>
  801444:	89 c3                	mov    %eax,%ebx
  801446:	83 c4 08             	add    $0x8,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 05                	js     801452 <fd_close+0x30>
	    || fd != fd2)
  80144d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801450:	74 16                	je     801468 <fd_close+0x46>
		return (must_exist ? r : 0);
  801452:	89 f8                	mov    %edi,%eax
  801454:	84 c0                	test   %al,%al
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
  80145b:	0f 44 d8             	cmove  %eax,%ebx
}
  80145e:	89 d8                	mov    %ebx,%eax
  801460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801463:	5b                   	pop    %ebx
  801464:	5e                   	pop    %esi
  801465:	5f                   	pop    %edi
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801468:	83 ec 08             	sub    $0x8,%esp
  80146b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	ff 36                	pushl  (%esi)
  801471:	e8 56 ff ff ff       	call   8013cc <dev_lookup>
  801476:	89 c3                	mov    %eax,%ebx
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 15                	js     801494 <fd_close+0x72>
		if (dev->dev_close)
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	8b 40 10             	mov    0x10(%eax),%eax
  801485:	85 c0                	test   %eax,%eax
  801487:	74 1b                	je     8014a4 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	56                   	push   %esi
  80148d:	ff d0                	call   *%eax
  80148f:	89 c3                	mov    %eax,%ebx
  801491:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	56                   	push   %esi
  801498:	6a 00                	push   $0x0
  80149a:	e8 af f8 ff ff       	call   800d4e <sys_page_unmap>
	return r;
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	eb ba                	jmp    80145e <fd_close+0x3c>
			r = 0;
  8014a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a9:	eb e9                	jmp    801494 <fd_close+0x72>

008014ab <close>:

int
close(int fdnum)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b4:	50                   	push   %eax
  8014b5:	ff 75 08             	pushl  0x8(%ebp)
  8014b8:	e8 b9 fe ff ff       	call   801376 <fd_lookup>
  8014bd:	83 c4 08             	add    $0x8,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 10                	js     8014d4 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	6a 01                	push   $0x1
  8014c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8014cc:	e8 51 ff ff ff       	call   801422 <fd_close>
  8014d1:	83 c4 10             	add    $0x10,%esp
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <close_all>:

void
close_all(void)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	53                   	push   %ebx
  8014e6:	e8 c0 ff ff ff       	call   8014ab <close>
	for (i = 0; i < MAXFD; i++)
  8014eb:	83 c3 01             	add    $0x1,%ebx
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	83 fb 20             	cmp    $0x20,%ebx
  8014f4:	75 ec                	jne    8014e2 <close_all+0xc>
}
  8014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	57                   	push   %edi
  8014ff:	56                   	push   %esi
  801500:	53                   	push   %ebx
  801501:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801504:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801507:	50                   	push   %eax
  801508:	ff 75 08             	pushl  0x8(%ebp)
  80150b:	e8 66 fe ff ff       	call   801376 <fd_lookup>
  801510:	89 c3                	mov    %eax,%ebx
  801512:	83 c4 08             	add    $0x8,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	0f 88 81 00 00 00    	js     80159e <dup+0xa3>
		return r;
	close(newfdnum);
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	e8 83 ff ff ff       	call   8014ab <close>

	newfd = INDEX2FD(newfdnum);
  801528:	8b 75 0c             	mov    0xc(%ebp),%esi
  80152b:	c1 e6 0c             	shl    $0xc,%esi
  80152e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801534:	83 c4 04             	add    $0x4,%esp
  801537:	ff 75 e4             	pushl  -0x1c(%ebp)
  80153a:	e8 d1 fd ff ff       	call   801310 <fd2data>
  80153f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801541:	89 34 24             	mov    %esi,(%esp)
  801544:	e8 c7 fd ff ff       	call   801310 <fd2data>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80154e:	89 d8                	mov    %ebx,%eax
  801550:	c1 e8 16             	shr    $0x16,%eax
  801553:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80155a:	a8 01                	test   $0x1,%al
  80155c:	74 11                	je     80156f <dup+0x74>
  80155e:	89 d8                	mov    %ebx,%eax
  801560:	c1 e8 0c             	shr    $0xc,%eax
  801563:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80156a:	f6 c2 01             	test   $0x1,%dl
  80156d:	75 39                	jne    8015a8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80156f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801572:	89 d0                	mov    %edx,%eax
  801574:	c1 e8 0c             	shr    $0xc,%eax
  801577:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	25 07 0e 00 00       	and    $0xe07,%eax
  801586:	50                   	push   %eax
  801587:	56                   	push   %esi
  801588:	6a 00                	push   $0x0
  80158a:	52                   	push   %edx
  80158b:	6a 00                	push   $0x0
  80158d:	e8 7a f7 ff ff       	call   800d0c <sys_page_map>
  801592:	89 c3                	mov    %eax,%ebx
  801594:	83 c4 20             	add    $0x20,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	78 31                	js     8015cc <dup+0xd1>
		goto err;

	return newfdnum;
  80159b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80159e:	89 d8                	mov    %ebx,%eax
  8015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5f                   	pop    %edi
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b7:	50                   	push   %eax
  8015b8:	57                   	push   %edi
  8015b9:	6a 00                	push   $0x0
  8015bb:	53                   	push   %ebx
  8015bc:	6a 00                	push   $0x0
  8015be:	e8 49 f7 ff ff       	call   800d0c <sys_page_map>
  8015c3:	89 c3                	mov    %eax,%ebx
  8015c5:	83 c4 20             	add    $0x20,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	79 a3                	jns    80156f <dup+0x74>
	sys_page_unmap(0, newfd);
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	56                   	push   %esi
  8015d0:	6a 00                	push   $0x0
  8015d2:	e8 77 f7 ff ff       	call   800d4e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015d7:	83 c4 08             	add    $0x8,%esp
  8015da:	57                   	push   %edi
  8015db:	6a 00                	push   $0x0
  8015dd:	e8 6c f7 ff ff       	call   800d4e <sys_page_unmap>
	return r;
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	eb b7                	jmp    80159e <dup+0xa3>

008015e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	53                   	push   %ebx
  8015eb:	83 ec 14             	sub    $0x14,%esp
  8015ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f4:	50                   	push   %eax
  8015f5:	53                   	push   %ebx
  8015f6:	e8 7b fd ff ff       	call   801376 <fd_lookup>
  8015fb:	83 c4 08             	add    $0x8,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 3f                	js     801641 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801608:	50                   	push   %eax
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160c:	ff 30                	pushl  (%eax)
  80160e:	e8 b9 fd ff ff       	call   8013cc <dev_lookup>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 27                	js     801641 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80161a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161d:	8b 42 08             	mov    0x8(%edx),%eax
  801620:	83 e0 03             	and    $0x3,%eax
  801623:	83 f8 01             	cmp    $0x1,%eax
  801626:	74 1e                	je     801646 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	8b 40 08             	mov    0x8(%eax),%eax
  80162e:	85 c0                	test   %eax,%eax
  801630:	74 35                	je     801667 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	ff 75 10             	pushl  0x10(%ebp)
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	52                   	push   %edx
  80163c:	ff d0                	call   *%eax
  80163e:	83 c4 10             	add    $0x10,%esp
}
  801641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801644:	c9                   	leave  
  801645:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801646:	a1 08 40 80 00       	mov    0x804008,%eax
  80164b:	8b 40 48             	mov    0x48(%eax),%eax
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	53                   	push   %ebx
  801652:	50                   	push   %eax
  801653:	68 a9 2b 80 00       	push   $0x802ba9
  801658:	e8 d6 eb ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801665:	eb da                	jmp    801641 <read+0x5a>
		return -E_NOT_SUPP;
  801667:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166c:	eb d3                	jmp    801641 <read+0x5a>

0080166e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 0c             	sub    $0xc,%esp
  801677:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80167d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801682:	39 f3                	cmp    %esi,%ebx
  801684:	73 25                	jae    8016ab <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	89 f0                	mov    %esi,%eax
  80168b:	29 d8                	sub    %ebx,%eax
  80168d:	50                   	push   %eax
  80168e:	89 d8                	mov    %ebx,%eax
  801690:	03 45 0c             	add    0xc(%ebp),%eax
  801693:	50                   	push   %eax
  801694:	57                   	push   %edi
  801695:	e8 4d ff ff ff       	call   8015e7 <read>
		if (m < 0)
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 08                	js     8016a9 <readn+0x3b>
			return m;
		if (m == 0)
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	74 06                	je     8016ab <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8016a5:	01 c3                	add    %eax,%ebx
  8016a7:	eb d9                	jmp    801682 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ab:	89 d8                	mov    %ebx,%eax
  8016ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5f                   	pop    %edi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 14             	sub    $0x14,%esp
  8016bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c2:	50                   	push   %eax
  8016c3:	53                   	push   %ebx
  8016c4:	e8 ad fc ff ff       	call   801376 <fd_lookup>
  8016c9:	83 c4 08             	add    $0x8,%esp
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 3a                	js     80170a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d6:	50                   	push   %eax
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	ff 30                	pushl  (%eax)
  8016dc:	e8 eb fc ff ff       	call   8013cc <dev_lookup>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 22                	js     80170a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016eb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ef:	74 1e                	je     80170f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8016f7:	85 d2                	test   %edx,%edx
  8016f9:	74 35                	je     801730 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	ff 75 10             	pushl  0x10(%ebp)
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	50                   	push   %eax
  801705:	ff d2                	call   *%edx
  801707:	83 c4 10             	add    $0x10,%esp
}
  80170a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80170f:	a1 08 40 80 00       	mov    0x804008,%eax
  801714:	8b 40 48             	mov    0x48(%eax),%eax
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	53                   	push   %ebx
  80171b:	50                   	push   %eax
  80171c:	68 c5 2b 80 00       	push   $0x802bc5
  801721:	e8 0d eb ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172e:	eb da                	jmp    80170a <write+0x55>
		return -E_NOT_SUPP;
  801730:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801735:	eb d3                	jmp    80170a <write+0x55>

00801737 <seek>:

int
seek(int fdnum, off_t offset)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80173d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801740:	50                   	push   %eax
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 2d fc ff ff       	call   801376 <fd_lookup>
  801749:	83 c4 08             	add    $0x8,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	78 0e                	js     80175e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801756:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	53                   	push   %ebx
  801764:	83 ec 14             	sub    $0x14,%esp
  801767:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80176a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176d:	50                   	push   %eax
  80176e:	53                   	push   %ebx
  80176f:	e8 02 fc ff ff       	call   801376 <fd_lookup>
  801774:	83 c4 08             	add    $0x8,%esp
  801777:	85 c0                	test   %eax,%eax
  801779:	78 37                	js     8017b2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	ff 30                	pushl  (%eax)
  801787:	e8 40 fc ff ff       	call   8013cc <dev_lookup>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	85 c0                	test   %eax,%eax
  801791:	78 1f                	js     8017b2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80179a:	74 1b                	je     8017b7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80179c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179f:	8b 52 18             	mov    0x18(%edx),%edx
  8017a2:	85 d2                	test   %edx,%edx
  8017a4:	74 32                	je     8017d8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	50                   	push   %eax
  8017ad:	ff d2                	call   *%edx
  8017af:	83 c4 10             	add    $0x10,%esp
}
  8017b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017b7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017bc:	8b 40 48             	mov    0x48(%eax),%eax
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	53                   	push   %ebx
  8017c3:	50                   	push   %eax
  8017c4:	68 88 2b 80 00       	push   $0x802b88
  8017c9:	e8 65 ea ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d6:	eb da                	jmp    8017b2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017dd:	eb d3                	jmp    8017b2 <ftruncate+0x52>

008017df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 14             	sub    $0x14,%esp
  8017e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ec:	50                   	push   %eax
  8017ed:	ff 75 08             	pushl  0x8(%ebp)
  8017f0:	e8 81 fb ff ff       	call   801376 <fd_lookup>
  8017f5:	83 c4 08             	add    $0x8,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 4b                	js     801847 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fc:	83 ec 08             	sub    $0x8,%esp
  8017ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801802:	50                   	push   %eax
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	ff 30                	pushl  (%eax)
  801808:	e8 bf fb ff ff       	call   8013cc <dev_lookup>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	78 33                	js     801847 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801817:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80181b:	74 2f                	je     80184c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80181d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801820:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801827:	00 00 00 
	stat->st_isdir = 0;
  80182a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801831:	00 00 00 
	stat->st_dev = dev;
  801834:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	53                   	push   %ebx
  80183e:	ff 75 f0             	pushl  -0x10(%ebp)
  801841:	ff 50 14             	call   *0x14(%eax)
  801844:	83 c4 10             	add    $0x10,%esp
}
  801847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    
		return -E_NOT_SUPP;
  80184c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801851:	eb f4                	jmp    801847 <fstat+0x68>

00801853 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	6a 00                	push   $0x0
  80185d:	ff 75 08             	pushl  0x8(%ebp)
  801860:	e8 26 02 00 00       	call   801a8b <open>
  801865:	89 c3                	mov    %eax,%ebx
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 1b                	js     801889 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	50                   	push   %eax
  801875:	e8 65 ff ff ff       	call   8017df <fstat>
  80187a:	89 c6                	mov    %eax,%esi
	close(fd);
  80187c:	89 1c 24             	mov    %ebx,(%esp)
  80187f:	e8 27 fc ff ff       	call   8014ab <close>
	return r;
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	89 f3                	mov    %esi,%ebx
}
  801889:	89 d8                	mov    %ebx,%eax
  80188b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    

00801892 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	56                   	push   %esi
  801896:	53                   	push   %ebx
  801897:	89 c6                	mov    %eax,%esi
  801899:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80189b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018a2:	74 27                	je     8018cb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018a4:	6a 07                	push   $0x7
  8018a6:	68 00 50 80 00       	push   $0x805000
  8018ab:	56                   	push   %esi
  8018ac:	ff 35 00 40 80 00    	pushl  0x804000
  8018b2:	e8 b7 f9 ff ff       	call   80126e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018b7:	83 c4 0c             	add    $0xc,%esp
  8018ba:	6a 00                	push   $0x0
  8018bc:	53                   	push   %ebx
  8018bd:	6a 00                	push   $0x0
  8018bf:	e8 41 f9 ff ff       	call   801205 <ipc_recv>
}
  8018c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5d                   	pop    %ebp
  8018ca:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	6a 01                	push   $0x1
  8018d0:	e8 f2 f9 ff ff       	call   8012c7 <ipc_find_env>
  8018d5:	a3 00 40 80 00       	mov    %eax,0x804000
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	eb c5                	jmp    8018a4 <fsipc+0x12>

008018df <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8018eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801902:	e8 8b ff ff ff       	call   801892 <fsipc>
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <devfile_flush>:
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8b 40 0c             	mov    0xc(%eax),%eax
  801915:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80191a:	ba 00 00 00 00       	mov    $0x0,%edx
  80191f:	b8 06 00 00 00       	mov    $0x6,%eax
  801924:	e8 69 ff ff ff       	call   801892 <fsipc>
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <devfile_stat>:
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	53                   	push   %ebx
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
  80193b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801940:	ba 00 00 00 00       	mov    $0x0,%edx
  801945:	b8 05 00 00 00       	mov    $0x5,%eax
  80194a:	e8 43 ff ff ff       	call   801892 <fsipc>
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 2c                	js     80197f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801953:	83 ec 08             	sub    $0x8,%esp
  801956:	68 00 50 80 00       	push   $0x805000
  80195b:	53                   	push   %ebx
  80195c:	e8 6f ef ff ff       	call   8008d0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801961:	a1 80 50 80 00       	mov    0x805080,%eax
  801966:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80196c:	a1 84 50 80 00       	mov    0x805084,%eax
  801971:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <devfile_write>:
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	53                   	push   %ebx
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	8b 40 0c             	mov    0xc(%eax),%eax
  801994:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801999:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80199f:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019a5:	77 30                	ja     8019d7 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	53                   	push   %ebx
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	68 08 50 80 00       	push   $0x805008
  8019b3:	e8 a6 f0 ff ff       	call   800a5e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bd:	b8 04 00 00 00       	mov    $0x4,%eax
  8019c2:	e8 cb fe ff ff       	call   801892 <fsipc>
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 04                	js     8019d2 <devfile_write+0x4e>
	assert(r <= n);
  8019ce:	39 d8                	cmp    %ebx,%eax
  8019d0:	77 1e                	ja     8019f0 <devfile_write+0x6c>
}
  8019d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8019d7:	68 f8 2b 80 00       	push   $0x802bf8
  8019dc:	68 28 2c 80 00       	push   $0x802c28
  8019e1:	68 94 00 00 00       	push   $0x94
  8019e6:	68 3d 2c 80 00       	push   $0x802c3d
  8019eb:	e8 68 e7 ff ff       	call   800158 <_panic>
	assert(r <= n);
  8019f0:	68 48 2c 80 00       	push   $0x802c48
  8019f5:	68 28 2c 80 00       	push   $0x802c28
  8019fa:	68 98 00 00 00       	push   $0x98
  8019ff:	68 3d 2c 80 00       	push   $0x802c3d
  801a04:	e8 4f e7 ff ff       	call   800158 <_panic>

00801a09 <devfile_read>:
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
  801a0e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	8b 40 0c             	mov    0xc(%eax),%eax
  801a17:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a1c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a22:	ba 00 00 00 00       	mov    $0x0,%edx
  801a27:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2c:	e8 61 fe ff ff       	call   801892 <fsipc>
  801a31:	89 c3                	mov    %eax,%ebx
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 1f                	js     801a56 <devfile_read+0x4d>
	assert(r <= n);
  801a37:	39 f0                	cmp    %esi,%eax
  801a39:	77 24                	ja     801a5f <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a3b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a40:	7f 33                	jg     801a75 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	50                   	push   %eax
  801a46:	68 00 50 80 00       	push   $0x805000
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	e8 0b f0 ff ff       	call   800a5e <memmove>
	return r;
  801a53:	83 c4 10             	add    $0x10,%esp
}
  801a56:	89 d8                	mov    %ebx,%eax
  801a58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    
	assert(r <= n);
  801a5f:	68 48 2c 80 00       	push   $0x802c48
  801a64:	68 28 2c 80 00       	push   $0x802c28
  801a69:	6a 7c                	push   $0x7c
  801a6b:	68 3d 2c 80 00       	push   $0x802c3d
  801a70:	e8 e3 e6 ff ff       	call   800158 <_panic>
	assert(r <= PGSIZE);
  801a75:	68 4f 2c 80 00       	push   $0x802c4f
  801a7a:	68 28 2c 80 00       	push   $0x802c28
  801a7f:	6a 7d                	push   $0x7d
  801a81:	68 3d 2c 80 00       	push   $0x802c3d
  801a86:	e8 cd e6 ff ff       	call   800158 <_panic>

00801a8b <open>:
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 1c             	sub    $0x1c,%esp
  801a93:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a96:	56                   	push   %esi
  801a97:	e8 fd ed ff ff       	call   800899 <strlen>
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa4:	7f 6c                	jg     801b12 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801aa6:	83 ec 0c             	sub    $0xc,%esp
  801aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aac:	50                   	push   %eax
  801aad:	e8 75 f8 ff ff       	call   801327 <fd_alloc>
  801ab2:	89 c3                	mov    %eax,%ebx
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 3c                	js     801af7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801abb:	83 ec 08             	sub    $0x8,%esp
  801abe:	56                   	push   %esi
  801abf:	68 00 50 80 00       	push   $0x805000
  801ac4:	e8 07 ee ff ff       	call   8008d0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad9:	e8 b4 fd ff ff       	call   801892 <fsipc>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 19                	js     801b00 <open+0x75>
	return fd2num(fd);
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	ff 75 f4             	pushl  -0xc(%ebp)
  801aed:	e8 0e f8 ff ff       	call   801300 <fd2num>
  801af2:	89 c3                	mov    %eax,%ebx
  801af4:	83 c4 10             	add    $0x10,%esp
}
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
		fd_close(fd, 0);
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	6a 00                	push   $0x0
  801b05:	ff 75 f4             	pushl  -0xc(%ebp)
  801b08:	e8 15 f9 ff ff       	call   801422 <fd_close>
		return r;
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	eb e5                	jmp    801af7 <open+0x6c>
		return -E_BAD_PATH;
  801b12:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b17:	eb de                	jmp    801af7 <open+0x6c>

00801b19 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b24:	b8 08 00 00 00       	mov    $0x8,%eax
  801b29:	e8 64 fd ff ff       	call   801892 <fsipc>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	e8 cd f7 ff ff       	call   801310 <fd2data>
  801b43:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b45:	83 c4 08             	add    $0x8,%esp
  801b48:	68 5b 2c 80 00       	push   $0x802c5b
  801b4d:	53                   	push   %ebx
  801b4e:	e8 7d ed ff ff       	call   8008d0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b53:	8b 46 04             	mov    0x4(%esi),%eax
  801b56:	2b 06                	sub    (%esi),%eax
  801b58:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b5e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b65:	00 00 00 
	stat->st_dev = &devpipe;
  801b68:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b6f:	30 80 00 
	return 0;
}
  801b72:	b8 00 00 00 00       	mov    $0x0,%eax
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    

00801b7e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	53                   	push   %ebx
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b88:	53                   	push   %ebx
  801b89:	6a 00                	push   $0x0
  801b8b:	e8 be f1 ff ff       	call   800d4e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b90:	89 1c 24             	mov    %ebx,(%esp)
  801b93:	e8 78 f7 ff ff       	call   801310 <fd2data>
  801b98:	83 c4 08             	add    $0x8,%esp
  801b9b:	50                   	push   %eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	e8 ab f1 ff ff       	call   800d4e <sys_page_unmap>
}
  801ba3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <_pipeisclosed>:
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	57                   	push   %edi
  801bac:	56                   	push   %esi
  801bad:	53                   	push   %ebx
  801bae:	83 ec 1c             	sub    $0x1c,%esp
  801bb1:	89 c7                	mov    %eax,%edi
  801bb3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bb5:	a1 08 40 80 00       	mov    0x804008,%eax
  801bba:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	57                   	push   %edi
  801bc1:	e8 38 09 00 00       	call   8024fe <pageref>
  801bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bc9:	89 34 24             	mov    %esi,(%esp)
  801bcc:	e8 2d 09 00 00       	call   8024fe <pageref>
		nn = thisenv->env_runs;
  801bd1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bd7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	39 cb                	cmp    %ecx,%ebx
  801bdf:	74 1b                	je     801bfc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801be1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801be4:	75 cf                	jne    801bb5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801be6:	8b 42 58             	mov    0x58(%edx),%eax
  801be9:	6a 01                	push   $0x1
  801beb:	50                   	push   %eax
  801bec:	53                   	push   %ebx
  801bed:	68 62 2c 80 00       	push   $0x802c62
  801bf2:	e8 3c e6 ff ff       	call   800233 <cprintf>
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	eb b9                	jmp    801bb5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bfc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bff:	0f 94 c0             	sete   %al
  801c02:	0f b6 c0             	movzbl %al,%eax
}
  801c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    

00801c0d <devpipe_write>:
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	57                   	push   %edi
  801c11:	56                   	push   %esi
  801c12:	53                   	push   %ebx
  801c13:	83 ec 28             	sub    $0x28,%esp
  801c16:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c19:	56                   	push   %esi
  801c1a:	e8 f1 f6 ff ff       	call   801310 <fd2data>
  801c1f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	bf 00 00 00 00       	mov    $0x0,%edi
  801c29:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c2c:	74 4f                	je     801c7d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c2e:	8b 43 04             	mov    0x4(%ebx),%eax
  801c31:	8b 0b                	mov    (%ebx),%ecx
  801c33:	8d 51 20             	lea    0x20(%ecx),%edx
  801c36:	39 d0                	cmp    %edx,%eax
  801c38:	72 14                	jb     801c4e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c3a:	89 da                	mov    %ebx,%edx
  801c3c:	89 f0                	mov    %esi,%eax
  801c3e:	e8 65 ff ff ff       	call   801ba8 <_pipeisclosed>
  801c43:	85 c0                	test   %eax,%eax
  801c45:	75 3a                	jne    801c81 <devpipe_write+0x74>
			sys_yield();
  801c47:	e8 5e f0 ff ff       	call   800caa <sys_yield>
  801c4c:	eb e0                	jmp    801c2e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c51:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c55:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c58:	89 c2                	mov    %eax,%edx
  801c5a:	c1 fa 1f             	sar    $0x1f,%edx
  801c5d:	89 d1                	mov    %edx,%ecx
  801c5f:	c1 e9 1b             	shr    $0x1b,%ecx
  801c62:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c65:	83 e2 1f             	and    $0x1f,%edx
  801c68:	29 ca                	sub    %ecx,%edx
  801c6a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c6e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c72:	83 c0 01             	add    $0x1,%eax
  801c75:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c78:	83 c7 01             	add    $0x1,%edi
  801c7b:	eb ac                	jmp    801c29 <devpipe_write+0x1c>
	return i;
  801c7d:	89 f8                	mov    %edi,%eax
  801c7f:	eb 05                	jmp    801c86 <devpipe_write+0x79>
				return 0;
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c89:	5b                   	pop    %ebx
  801c8a:	5e                   	pop    %esi
  801c8b:	5f                   	pop    %edi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <devpipe_read>:
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	57                   	push   %edi
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 18             	sub    $0x18,%esp
  801c97:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c9a:	57                   	push   %edi
  801c9b:	e8 70 f6 ff ff       	call   801310 <fd2data>
  801ca0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	be 00 00 00 00       	mov    $0x0,%esi
  801caa:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cad:	74 47                	je     801cf6 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801caf:	8b 03                	mov    (%ebx),%eax
  801cb1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cb4:	75 22                	jne    801cd8 <devpipe_read+0x4a>
			if (i > 0)
  801cb6:	85 f6                	test   %esi,%esi
  801cb8:	75 14                	jne    801cce <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801cba:	89 da                	mov    %ebx,%edx
  801cbc:	89 f8                	mov    %edi,%eax
  801cbe:	e8 e5 fe ff ff       	call   801ba8 <_pipeisclosed>
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	75 33                	jne    801cfa <devpipe_read+0x6c>
			sys_yield();
  801cc7:	e8 de ef ff ff       	call   800caa <sys_yield>
  801ccc:	eb e1                	jmp    801caf <devpipe_read+0x21>
				return i;
  801cce:	89 f0                	mov    %esi,%eax
}
  801cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cd8:	99                   	cltd   
  801cd9:	c1 ea 1b             	shr    $0x1b,%edx
  801cdc:	01 d0                	add    %edx,%eax
  801cde:	83 e0 1f             	and    $0x1f,%eax
  801ce1:	29 d0                	sub    %edx,%eax
  801ce3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ceb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cee:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cf1:	83 c6 01             	add    $0x1,%esi
  801cf4:	eb b4                	jmp    801caa <devpipe_read+0x1c>
	return i;
  801cf6:	89 f0                	mov    %esi,%eax
  801cf8:	eb d6                	jmp    801cd0 <devpipe_read+0x42>
				return 0;
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	eb cf                	jmp    801cd0 <devpipe_read+0x42>

00801d01 <pipe>:
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	56                   	push   %esi
  801d05:	53                   	push   %ebx
  801d06:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0c:	50                   	push   %eax
  801d0d:	e8 15 f6 ff ff       	call   801327 <fd_alloc>
  801d12:	89 c3                	mov    %eax,%ebx
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	78 5b                	js     801d76 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	68 07 04 00 00       	push   $0x407
  801d23:	ff 75 f4             	pushl  -0xc(%ebp)
  801d26:	6a 00                	push   $0x0
  801d28:	e8 9c ef ff ff       	call   800cc9 <sys_page_alloc>
  801d2d:	89 c3                	mov    %eax,%ebx
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	78 40                	js     801d76 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3c:	50                   	push   %eax
  801d3d:	e8 e5 f5 ff ff       	call   801327 <fd_alloc>
  801d42:	89 c3                	mov    %eax,%ebx
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	85 c0                	test   %eax,%eax
  801d49:	78 1b                	js     801d66 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d4b:	83 ec 04             	sub    $0x4,%esp
  801d4e:	68 07 04 00 00       	push   $0x407
  801d53:	ff 75 f0             	pushl  -0x10(%ebp)
  801d56:	6a 00                	push   $0x0
  801d58:	e8 6c ef ff ff       	call   800cc9 <sys_page_alloc>
  801d5d:	89 c3                	mov    %eax,%ebx
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	85 c0                	test   %eax,%eax
  801d64:	79 19                	jns    801d7f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d66:	83 ec 08             	sub    $0x8,%esp
  801d69:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6c:	6a 00                	push   $0x0
  801d6e:	e8 db ef ff ff       	call   800d4e <sys_page_unmap>
  801d73:	83 c4 10             	add    $0x10,%esp
}
  801d76:	89 d8                	mov    %ebx,%eax
  801d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    
	va = fd2data(fd0);
  801d7f:	83 ec 0c             	sub    $0xc,%esp
  801d82:	ff 75 f4             	pushl  -0xc(%ebp)
  801d85:	e8 86 f5 ff ff       	call   801310 <fd2data>
  801d8a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8c:	83 c4 0c             	add    $0xc,%esp
  801d8f:	68 07 04 00 00       	push   $0x407
  801d94:	50                   	push   %eax
  801d95:	6a 00                	push   $0x0
  801d97:	e8 2d ef ff ff       	call   800cc9 <sys_page_alloc>
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	85 c0                	test   %eax,%eax
  801da3:	0f 88 8c 00 00 00    	js     801e35 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	ff 75 f0             	pushl  -0x10(%ebp)
  801daf:	e8 5c f5 ff ff       	call   801310 <fd2data>
  801db4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dbb:	50                   	push   %eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	56                   	push   %esi
  801dbf:	6a 00                	push   $0x0
  801dc1:	e8 46 ef ff ff       	call   800d0c <sys_page_map>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	83 c4 20             	add    $0x20,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 58                	js     801e27 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dd8:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ded:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801df9:	83 ec 0c             	sub    $0xc,%esp
  801dfc:	ff 75 f4             	pushl  -0xc(%ebp)
  801dff:	e8 fc f4 ff ff       	call   801300 <fd2num>
  801e04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e07:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e09:	83 c4 04             	add    $0x4,%esp
  801e0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0f:	e8 ec f4 ff ff       	call   801300 <fd2num>
  801e14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e17:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e22:	e9 4f ff ff ff       	jmp    801d76 <pipe+0x75>
	sys_page_unmap(0, va);
  801e27:	83 ec 08             	sub    $0x8,%esp
  801e2a:	56                   	push   %esi
  801e2b:	6a 00                	push   $0x0
  801e2d:	e8 1c ef ff ff       	call   800d4e <sys_page_unmap>
  801e32:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e35:	83 ec 08             	sub    $0x8,%esp
  801e38:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3b:	6a 00                	push   $0x0
  801e3d:	e8 0c ef ff ff       	call   800d4e <sys_page_unmap>
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	e9 1c ff ff ff       	jmp    801d66 <pipe+0x65>

00801e4a <pipeisclosed>:
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e53:	50                   	push   %eax
  801e54:	ff 75 08             	pushl  0x8(%ebp)
  801e57:	e8 1a f5 ff ff       	call   801376 <fd_lookup>
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	78 18                	js     801e7b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	ff 75 f4             	pushl  -0xc(%ebp)
  801e69:	e8 a2 f4 ff ff       	call   801310 <fd2data>
	return _pipeisclosed(fd, p);
  801e6e:	89 c2                	mov    %eax,%edx
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	e8 30 fd ff ff       	call   801ba8 <_pipeisclosed>
  801e78:	83 c4 10             	add    $0x10,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e83:	68 7a 2c 80 00       	push   $0x802c7a
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	e8 40 ea ff ff       	call   8008d0 <strcpy>
	return 0;
}
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <devsock_close>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 10             	sub    $0x10,%esp
  801e9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ea1:	53                   	push   %ebx
  801ea2:	e8 57 06 00 00       	call   8024fe <pageref>
  801ea7:	83 c4 10             	add    $0x10,%esp
		return 0;
  801eaa:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801eaf:	83 f8 01             	cmp    $0x1,%eax
  801eb2:	74 07                	je     801ebb <devsock_close+0x24>
}
  801eb4:	89 d0                	mov    %edx,%eax
  801eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	ff 73 0c             	pushl  0xc(%ebx)
  801ec1:	e8 b7 02 00 00       	call   80217d <nsipc_close>
  801ec6:	89 c2                	mov    %eax,%edx
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	eb e7                	jmp    801eb4 <devsock_close+0x1d>

00801ecd <devsock_write>:
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ed3:	6a 00                	push   $0x0
  801ed5:	ff 75 10             	pushl  0x10(%ebp)
  801ed8:	ff 75 0c             	pushl  0xc(%ebp)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	ff 70 0c             	pushl  0xc(%eax)
  801ee1:	e8 74 03 00 00       	call   80225a <nsipc_send>
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <devsock_read>:
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	ff 75 10             	pushl  0x10(%ebp)
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	ff 70 0c             	pushl  0xc(%eax)
  801efc:	e8 ed 02 00 00       	call   8021ee <nsipc_recv>
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <fd2sockid>:
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f09:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	e8 63 f4 ff ff       	call   801376 <fd_lookup>
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 10                	js     801f2a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801f23:	39 08                	cmp    %ecx,(%eax)
  801f25:	75 05                	jne    801f2c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f27:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    
		return -E_NOT_SUPP;
  801f2c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f31:	eb f7                	jmp    801f2a <fd2sockid+0x27>

00801f33 <alloc_sockfd>:
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	56                   	push   %esi
  801f37:	53                   	push   %ebx
  801f38:	83 ec 1c             	sub    $0x1c,%esp
  801f3b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f40:	50                   	push   %eax
  801f41:	e8 e1 f3 ff ff       	call   801327 <fd_alloc>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 43                	js     801f92 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f4f:	83 ec 04             	sub    $0x4,%esp
  801f52:	68 07 04 00 00       	push   $0x407
  801f57:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5a:	6a 00                	push   $0x0
  801f5c:	e8 68 ed ff ff       	call   800cc9 <sys_page_alloc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 28                	js     801f92 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f73:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f7f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	50                   	push   %eax
  801f86:	e8 75 f3 ff ff       	call   801300 <fd2num>
  801f8b:	89 c3                	mov    %eax,%ebx
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	eb 0c                	jmp    801f9e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	56                   	push   %esi
  801f96:	e8 e2 01 00 00       	call   80217d <nsipc_close>
		return r;
  801f9b:	83 c4 10             	add    $0x10,%esp
}
  801f9e:	89 d8                	mov    %ebx,%eax
  801fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <accept>:
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	e8 4e ff ff ff       	call   801f03 <fd2sockid>
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 1b                	js     801fd4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	ff 75 10             	pushl  0x10(%ebp)
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	50                   	push   %eax
  801fc3:	e8 0e 01 00 00       	call   8020d6 <nsipc_accept>
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 05                	js     801fd4 <accept+0x2d>
	return alloc_sockfd(r);
  801fcf:	e8 5f ff ff ff       	call   801f33 <alloc_sockfd>
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <bind>:
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	e8 1f ff ff ff       	call   801f03 <fd2sockid>
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 12                	js     801ffa <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	ff 75 10             	pushl  0x10(%ebp)
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	50                   	push   %eax
  801ff2:	e8 2f 01 00 00       	call   802126 <nsipc_bind>
  801ff7:	83 c4 10             	add    $0x10,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <shutdown>:
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	e8 f9 fe ff ff       	call   801f03 <fd2sockid>
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 0f                	js     80201d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	50                   	push   %eax
  802015:	e8 41 01 00 00       	call   80215b <nsipc_shutdown>
  80201a:	83 c4 10             	add    $0x10,%esp
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <connect>:
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	e8 d6 fe ff ff       	call   801f03 <fd2sockid>
  80202d:	85 c0                	test   %eax,%eax
  80202f:	78 12                	js     802043 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	ff 75 10             	pushl  0x10(%ebp)
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	50                   	push   %eax
  80203b:	e8 57 01 00 00       	call   802197 <nsipc_connect>
  802040:	83 c4 10             	add    $0x10,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <listen>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	e8 b0 fe ff ff       	call   801f03 <fd2sockid>
  802053:	85 c0                	test   %eax,%eax
  802055:	78 0f                	js     802066 <listen+0x21>
	return nsipc_listen(r, backlog);
  802057:	83 ec 08             	sub    $0x8,%esp
  80205a:	ff 75 0c             	pushl  0xc(%ebp)
  80205d:	50                   	push   %eax
  80205e:	e8 69 01 00 00       	call   8021cc <nsipc_listen>
  802063:	83 c4 10             	add    $0x10,%esp
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <socket>:

int
socket(int domain, int type, int protocol)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80206e:	ff 75 10             	pushl  0x10(%ebp)
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 3c 02 00 00       	call   8022b8 <nsipc_socket>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 05                	js     802088 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802083:	e8 ab fe ff ff       	call   801f33 <alloc_sockfd>
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	53                   	push   %ebx
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802093:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80209a:	74 26                	je     8020c2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80209c:	6a 07                	push   $0x7
  80209e:	68 00 60 80 00       	push   $0x806000
  8020a3:	53                   	push   %ebx
  8020a4:	ff 35 04 40 80 00    	pushl  0x804004
  8020aa:	e8 bf f1 ff ff       	call   80126e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020af:	83 c4 0c             	add    $0xc,%esp
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	e8 48 f1 ff ff       	call   801205 <ipc_recv>
}
  8020bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	6a 02                	push   $0x2
  8020c7:	e8 fb f1 ff ff       	call   8012c7 <ipc_find_env>
  8020cc:	a3 04 40 80 00       	mov    %eax,0x804004
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	eb c6                	jmp    80209c <nsipc+0x12>

008020d6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	56                   	push   %esi
  8020da:	53                   	push   %ebx
  8020db:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020e6:	8b 06                	mov    (%esi),%eax
  8020e8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f2:	e8 93 ff ff ff       	call   80208a <nsipc>
  8020f7:	89 c3                	mov    %eax,%ebx
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 20                	js     80211d <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	ff 35 10 60 80 00    	pushl  0x806010
  802106:	68 00 60 80 00       	push   $0x806000
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	e8 4b e9 ff ff       	call   800a5e <memmove>
		*addrlen = ret->ret_addrlen;
  802113:	a1 10 60 80 00       	mov    0x806010,%eax
  802118:	89 06                	mov    %eax,(%esi)
  80211a:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80211d:	89 d8                	mov    %ebx,%eax
  80211f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802122:	5b                   	pop    %ebx
  802123:	5e                   	pop    %esi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	53                   	push   %ebx
  80212a:	83 ec 08             	sub    $0x8,%esp
  80212d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802138:	53                   	push   %ebx
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	68 04 60 80 00       	push   $0x806004
  802141:	e8 18 e9 ff ff       	call   800a5e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802146:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80214c:	b8 02 00 00 00       	mov    $0x2,%eax
  802151:	e8 34 ff ff ff       	call   80208a <nsipc>
}
  802156:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802171:	b8 03 00 00 00       	mov    $0x3,%eax
  802176:	e8 0f ff ff ff       	call   80208a <nsipc>
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <nsipc_close>:

int
nsipc_close(int s)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80218b:	b8 04 00 00 00       	mov    $0x4,%eax
  802190:	e8 f5 fe ff ff       	call   80208a <nsipc>
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	53                   	push   %ebx
  80219b:	83 ec 08             	sub    $0x8,%esp
  80219e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021a9:	53                   	push   %ebx
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	68 04 60 80 00       	push   $0x806004
  8021b2:	e8 a7 e8 ff ff       	call   800a5e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021b7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8021bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8021c2:	e8 c3 fe ff ff       	call   80208a <nsipc>
}
  8021c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8021e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8021e7:	e8 9e fe ff ff       	call   80208a <nsipc>
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8021fe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802204:	8b 45 14             	mov    0x14(%ebp),%eax
  802207:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80220c:	b8 07 00 00 00       	mov    $0x7,%eax
  802211:	e8 74 fe ff ff       	call   80208a <nsipc>
  802216:	89 c3                	mov    %eax,%ebx
  802218:	85 c0                	test   %eax,%eax
  80221a:	78 1f                	js     80223b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80221c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802221:	7f 21                	jg     802244 <nsipc_recv+0x56>
  802223:	39 c6                	cmp    %eax,%esi
  802225:	7c 1d                	jl     802244 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	50                   	push   %eax
  80222b:	68 00 60 80 00       	push   $0x806000
  802230:	ff 75 0c             	pushl  0xc(%ebp)
  802233:	e8 26 e8 ff ff       	call   800a5e <memmove>
  802238:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80223b:	89 d8                	mov    %ebx,%eax
  80223d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802244:	68 86 2c 80 00       	push   $0x802c86
  802249:	68 28 2c 80 00       	push   $0x802c28
  80224e:	6a 62                	push   $0x62
  802250:	68 9b 2c 80 00       	push   $0x802c9b
  802255:	e8 fe de ff ff       	call   800158 <_panic>

0080225a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	53                   	push   %ebx
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80226c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802272:	7f 2e                	jg     8022a2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	53                   	push   %ebx
  802278:	ff 75 0c             	pushl  0xc(%ebp)
  80227b:	68 0c 60 80 00       	push   $0x80600c
  802280:	e8 d9 e7 ff ff       	call   800a5e <memmove>
	nsipcbuf.send.req_size = size;
  802285:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80228b:	8b 45 14             	mov    0x14(%ebp),%eax
  80228e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802293:	b8 08 00 00 00       	mov    $0x8,%eax
  802298:	e8 ed fd ff ff       	call   80208a <nsipc>
}
  80229d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    
	assert(size < 1600);
  8022a2:	68 a7 2c 80 00       	push   $0x802ca7
  8022a7:	68 28 2c 80 00       	push   $0x802c28
  8022ac:	6a 6d                	push   $0x6d
  8022ae:	68 9b 2c 80 00       	push   $0x802c9b
  8022b3:	e8 a0 de ff ff       	call   800158 <_panic>

008022b8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022d6:	b8 09 00 00 00       	mov    $0x9,%eax
  8022db:	e8 aa fd ff ff       	call   80208a <nsipc>
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ea:	5d                   	pop    %ebp
  8022eb:	c3                   	ret    

008022ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022f2:	68 b3 2c 80 00       	push   $0x802cb3
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	e8 d1 e5 ff ff       	call   8008d0 <strcpy>
	return 0;
}
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <devcons_write>:
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	57                   	push   %edi
  80230a:	56                   	push   %esi
  80230b:	53                   	push   %ebx
  80230c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802312:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802317:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80231d:	eb 2f                	jmp    80234e <devcons_write+0x48>
		m = n - tot;
  80231f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802322:	29 f3                	sub    %esi,%ebx
  802324:	83 fb 7f             	cmp    $0x7f,%ebx
  802327:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80232c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	53                   	push   %ebx
  802333:	89 f0                	mov    %esi,%eax
  802335:	03 45 0c             	add    0xc(%ebp),%eax
  802338:	50                   	push   %eax
  802339:	57                   	push   %edi
  80233a:	e8 1f e7 ff ff       	call   800a5e <memmove>
		sys_cputs(buf, m);
  80233f:	83 c4 08             	add    $0x8,%esp
  802342:	53                   	push   %ebx
  802343:	57                   	push   %edi
  802344:	e8 c4 e8 ff ff       	call   800c0d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802349:	01 de                	add    %ebx,%esi
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802351:	72 cc                	jb     80231f <devcons_write+0x19>
}
  802353:	89 f0                	mov    %esi,%eax
  802355:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802358:	5b                   	pop    %ebx
  802359:	5e                   	pop    %esi
  80235a:	5f                   	pop    %edi
  80235b:	5d                   	pop    %ebp
  80235c:	c3                   	ret    

0080235d <devcons_read>:
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 08             	sub    $0x8,%esp
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802368:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80236c:	75 07                	jne    802375 <devcons_read+0x18>
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    
		sys_yield();
  802370:	e8 35 e9 ff ff       	call   800caa <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802375:	e8 b1 e8 ff ff       	call   800c2b <sys_cgetc>
  80237a:	85 c0                	test   %eax,%eax
  80237c:	74 f2                	je     802370 <devcons_read+0x13>
	if (c < 0)
  80237e:	85 c0                	test   %eax,%eax
  802380:	78 ec                	js     80236e <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802382:	83 f8 04             	cmp    $0x4,%eax
  802385:	74 0c                	je     802393 <devcons_read+0x36>
	*(char*)vbuf = c;
  802387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238a:	88 02                	mov    %al,(%edx)
	return 1;
  80238c:	b8 01 00 00 00       	mov    $0x1,%eax
  802391:	eb db                	jmp    80236e <devcons_read+0x11>
		return 0;
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	eb d4                	jmp    80236e <devcons_read+0x11>

0080239a <cputchar>:
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023a6:	6a 01                	push   $0x1
  8023a8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023ab:	50                   	push   %eax
  8023ac:	e8 5c e8 ff ff       	call   800c0d <sys_cputs>
}
  8023b1:	83 c4 10             	add    $0x10,%esp
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <getchar>:
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023bc:	6a 01                	push   $0x1
  8023be:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023c1:	50                   	push   %eax
  8023c2:	6a 00                	push   $0x0
  8023c4:	e8 1e f2 ff ff       	call   8015e7 <read>
	if (r < 0)
  8023c9:	83 c4 10             	add    $0x10,%esp
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 08                	js     8023d8 <getchar+0x22>
	if (r < 1)
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	7e 06                	jle    8023da <getchar+0x24>
	return c;
  8023d4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    
		return -E_EOF;
  8023da:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023df:	eb f7                	jmp    8023d8 <getchar+0x22>

008023e1 <iscons>:
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ea:	50                   	push   %eax
  8023eb:	ff 75 08             	pushl  0x8(%ebp)
  8023ee:	e8 83 ef ff ff       	call   801376 <fd_lookup>
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	78 11                	js     80240b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802403:	39 10                	cmp    %edx,(%eax)
  802405:	0f 94 c0             	sete   %al
  802408:	0f b6 c0             	movzbl %al,%eax
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <opencons>:
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802413:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802416:	50                   	push   %eax
  802417:	e8 0b ef ff ff       	call   801327 <fd_alloc>
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	85 c0                	test   %eax,%eax
  802421:	78 3a                	js     80245d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	68 07 04 00 00       	push   $0x407
  80242b:	ff 75 f4             	pushl  -0xc(%ebp)
  80242e:	6a 00                	push   $0x0
  802430:	e8 94 e8 ff ff       	call   800cc9 <sys_page_alloc>
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 21                	js     80245d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802445:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802451:	83 ec 0c             	sub    $0xc,%esp
  802454:	50                   	push   %eax
  802455:	e8 a6 ee ff ff       	call   801300 <fd2num>
  80245a:	83 c4 10             	add    $0x10,%esp
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802465:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80246c:	74 0a                	je     802478 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  802478:	a1 08 40 80 00       	mov    0x804008,%eax
  80247d:	8b 40 48             	mov    0x48(%eax),%eax
  802480:	83 ec 04             	sub    $0x4,%esp
  802483:	6a 07                	push   $0x7
  802485:	68 00 f0 bf ee       	push   $0xeebff000
  80248a:	50                   	push   %eax
  80248b:	e8 39 e8 ff ff       	call   800cc9 <sys_page_alloc>
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	85 c0                	test   %eax,%eax
  802495:	75 2f                	jne    8024c6 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802497:	a1 08 40 80 00       	mov    0x804008,%eax
  80249c:	8b 40 48             	mov    0x48(%eax),%eax
  80249f:	83 ec 08             	sub    $0x8,%esp
  8024a2:	68 d8 24 80 00       	push   $0x8024d8
  8024a7:	50                   	push   %eax
  8024a8:	e8 67 e9 ff ff       	call   800e14 <sys_env_set_pgfault_upcall>
  8024ad:	83 c4 10             	add    $0x10,%esp
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 ba                	je     80246e <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  8024b4:	50                   	push   %eax
  8024b5:	68 bf 2c 80 00       	push   $0x802cbf
  8024ba:	6a 24                	push   $0x24
  8024bc:	68 d7 2c 80 00       	push   $0x802cd7
  8024c1:	e8 92 dc ff ff       	call   800158 <_panic>
		    panic("set_pgfault_handler: %e", r);
  8024c6:	50                   	push   %eax
  8024c7:	68 bf 2c 80 00       	push   $0x802cbf
  8024cc:	6a 21                	push   $0x21
  8024ce:	68 d7 2c 80 00       	push   $0x802cd7
  8024d3:	e8 80 dc ff ff       	call   800158 <_panic>

008024d8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024d9:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024e0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8024e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8024e7:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8024ea:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8024ee:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8024f2:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8024f4:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8024f7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8024f8:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8024fb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8024fc:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8024fd:	c3                   	ret    

008024fe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802504:	89 d0                	mov    %edx,%eax
  802506:	c1 e8 16             	shr    $0x16,%eax
  802509:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802515:	f6 c1 01             	test   $0x1,%cl
  802518:	74 1d                	je     802537 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80251a:	c1 ea 0c             	shr    $0xc,%edx
  80251d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802524:	f6 c2 01             	test   $0x1,%dl
  802527:	74 0e                	je     802537 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802529:	c1 ea 0c             	shr    $0xc,%edx
  80252c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802533:	ef 
  802534:	0f b7 c0             	movzwl %ax,%eax
}
  802537:	5d                   	pop    %ebp
  802538:	c3                   	ret    
  802539:	66 90                	xchg   %ax,%ax
  80253b:	66 90                	xchg   %ax,%ax
  80253d:	66 90                	xchg   %ax,%ax
  80253f:	90                   	nop

00802540 <__udivdi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	83 ec 1c             	sub    $0x1c,%esp
  802547:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80254b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80254f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802553:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802557:	85 d2                	test   %edx,%edx
  802559:	75 35                	jne    802590 <__udivdi3+0x50>
  80255b:	39 f3                	cmp    %esi,%ebx
  80255d:	0f 87 bd 00 00 00    	ja     802620 <__udivdi3+0xe0>
  802563:	85 db                	test   %ebx,%ebx
  802565:	89 d9                	mov    %ebx,%ecx
  802567:	75 0b                	jne    802574 <__udivdi3+0x34>
  802569:	b8 01 00 00 00       	mov    $0x1,%eax
  80256e:	31 d2                	xor    %edx,%edx
  802570:	f7 f3                	div    %ebx
  802572:	89 c1                	mov    %eax,%ecx
  802574:	31 d2                	xor    %edx,%edx
  802576:	89 f0                	mov    %esi,%eax
  802578:	f7 f1                	div    %ecx
  80257a:	89 c6                	mov    %eax,%esi
  80257c:	89 e8                	mov    %ebp,%eax
  80257e:	89 f7                	mov    %esi,%edi
  802580:	f7 f1                	div    %ecx
  802582:	89 fa                	mov    %edi,%edx
  802584:	83 c4 1c             	add    $0x1c,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
  80258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802590:	39 f2                	cmp    %esi,%edx
  802592:	77 7c                	ja     802610 <__udivdi3+0xd0>
  802594:	0f bd fa             	bsr    %edx,%edi
  802597:	83 f7 1f             	xor    $0x1f,%edi
  80259a:	0f 84 98 00 00 00    	je     802638 <__udivdi3+0xf8>
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	d3 e6                	shl    %cl,%esi
  8025d1:	89 eb                	mov    %ebp,%ebx
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 0c                	jb     8025f7 <__udivdi3+0xb7>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 5d                	jae    802650 <__udivdi3+0x110>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	75 59                	jne    802650 <__udivdi3+0x110>
  8025f7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025fa:	31 ff                	xor    %edi,%edi
  8025fc:	89 fa                	mov    %edi,%edx
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	8d 76 00             	lea    0x0(%esi),%esi
  802609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802610:	31 ff                	xor    %edi,%edi
  802612:	31 c0                	xor    %eax,%eax
  802614:	89 fa                	mov    %edi,%edx
  802616:	83 c4 1c             	add    $0x1c,%esp
  802619:	5b                   	pop    %ebx
  80261a:	5e                   	pop    %esi
  80261b:	5f                   	pop    %edi
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    
  80261e:	66 90                	xchg   %ax,%ax
  802620:	31 ff                	xor    %edi,%edi
  802622:	89 e8                	mov    %ebp,%eax
  802624:	89 f2                	mov    %esi,%edx
  802626:	f7 f3                	div    %ebx
  802628:	89 fa                	mov    %edi,%edx
  80262a:	83 c4 1c             	add    $0x1c,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    
  802632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802638:	39 f2                	cmp    %esi,%edx
  80263a:	72 06                	jb     802642 <__udivdi3+0x102>
  80263c:	31 c0                	xor    %eax,%eax
  80263e:	39 eb                	cmp    %ebp,%ebx
  802640:	77 d2                	ja     802614 <__udivdi3+0xd4>
  802642:	b8 01 00 00 00       	mov    $0x1,%eax
  802647:	eb cb                	jmp    802614 <__udivdi3+0xd4>
  802649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802650:	89 d8                	mov    %ebx,%eax
  802652:	31 ff                	xor    %edi,%edi
  802654:	eb be                	jmp    802614 <__udivdi3+0xd4>
  802656:	66 90                	xchg   %ax,%ax
  802658:	66 90                	xchg   %ax,%ax
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__umoddi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80266b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80266f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802677:	85 ed                	test   %ebp,%ebp
  802679:	89 f0                	mov    %esi,%eax
  80267b:	89 da                	mov    %ebx,%edx
  80267d:	75 19                	jne    802698 <__umoddi3+0x38>
  80267f:	39 df                	cmp    %ebx,%edi
  802681:	0f 86 b1 00 00 00    	jbe    802738 <__umoddi3+0xd8>
  802687:	f7 f7                	div    %edi
  802689:	89 d0                	mov    %edx,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	83 c4 1c             	add    $0x1c,%esp
  802690:	5b                   	pop    %ebx
  802691:	5e                   	pop    %esi
  802692:	5f                   	pop    %edi
  802693:	5d                   	pop    %ebp
  802694:	c3                   	ret    
  802695:	8d 76 00             	lea    0x0(%esi),%esi
  802698:	39 dd                	cmp    %ebx,%ebp
  80269a:	77 f1                	ja     80268d <__umoddi3+0x2d>
  80269c:	0f bd cd             	bsr    %ebp,%ecx
  80269f:	83 f1 1f             	xor    $0x1f,%ecx
  8026a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026a6:	0f 84 b4 00 00 00    	je     802760 <__umoddi3+0x100>
  8026ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b1:	89 c2                	mov    %eax,%edx
  8026b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026b7:	29 c2                	sub    %eax,%edx
  8026b9:	89 c1                	mov    %eax,%ecx
  8026bb:	89 f8                	mov    %edi,%eax
  8026bd:	d3 e5                	shl    %cl,%ebp
  8026bf:	89 d1                	mov    %edx,%ecx
  8026c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026c5:	d3 e8                	shr    %cl,%eax
  8026c7:	09 c5                	or     %eax,%ebp
  8026c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026cd:	89 c1                	mov    %eax,%ecx
  8026cf:	d3 e7                	shl    %cl,%edi
  8026d1:	89 d1                	mov    %edx,%ecx
  8026d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026d7:	89 df                	mov    %ebx,%edi
  8026d9:	d3 ef                	shr    %cl,%edi
  8026db:	89 c1                	mov    %eax,%ecx
  8026dd:	89 f0                	mov    %esi,%eax
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 d1                	mov    %edx,%ecx
  8026e3:	89 fa                	mov    %edi,%edx
  8026e5:	d3 e8                	shr    %cl,%eax
  8026e7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ec:	09 d8                	or     %ebx,%eax
  8026ee:	f7 f5                	div    %ebp
  8026f0:	d3 e6                	shl    %cl,%esi
  8026f2:	89 d1                	mov    %edx,%ecx
  8026f4:	f7 64 24 08          	mull   0x8(%esp)
  8026f8:	39 d1                	cmp    %edx,%ecx
  8026fa:	89 c3                	mov    %eax,%ebx
  8026fc:	89 d7                	mov    %edx,%edi
  8026fe:	72 06                	jb     802706 <__umoddi3+0xa6>
  802700:	75 0e                	jne    802710 <__umoddi3+0xb0>
  802702:	39 c6                	cmp    %eax,%esi
  802704:	73 0a                	jae    802710 <__umoddi3+0xb0>
  802706:	2b 44 24 08          	sub    0x8(%esp),%eax
  80270a:	19 ea                	sbb    %ebp,%edx
  80270c:	89 d7                	mov    %edx,%edi
  80270e:	89 c3                	mov    %eax,%ebx
  802710:	89 ca                	mov    %ecx,%edx
  802712:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802717:	29 de                	sub    %ebx,%esi
  802719:	19 fa                	sbb    %edi,%edx
  80271b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80271f:	89 d0                	mov    %edx,%eax
  802721:	d3 e0                	shl    %cl,%eax
  802723:	89 d9                	mov    %ebx,%ecx
  802725:	d3 ee                	shr    %cl,%esi
  802727:	d3 ea                	shr    %cl,%edx
  802729:	09 f0                	or     %esi,%eax
  80272b:	83 c4 1c             	add    $0x1c,%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5f                   	pop    %edi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    
  802733:	90                   	nop
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	85 ff                	test   %edi,%edi
  80273a:	89 f9                	mov    %edi,%ecx
  80273c:	75 0b                	jne    802749 <__umoddi3+0xe9>
  80273e:	b8 01 00 00 00       	mov    $0x1,%eax
  802743:	31 d2                	xor    %edx,%edx
  802745:	f7 f7                	div    %edi
  802747:	89 c1                	mov    %eax,%ecx
  802749:	89 d8                	mov    %ebx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	f7 f1                	div    %ecx
  80274f:	89 f0                	mov    %esi,%eax
  802751:	f7 f1                	div    %ecx
  802753:	e9 31 ff ff ff       	jmp    802689 <__umoddi3+0x29>
  802758:	90                   	nop
  802759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802760:	39 dd                	cmp    %ebx,%ebp
  802762:	72 08                	jb     80276c <__umoddi3+0x10c>
  802764:	39 f7                	cmp    %esi,%edi
  802766:	0f 87 21 ff ff ff    	ja     80268d <__umoddi3+0x2d>
  80276c:	89 da                	mov    %ebx,%edx
  80276e:	89 f0                	mov    %esi,%eax
  802770:	29 f8                	sub    %edi,%eax
  802772:	19 ea                	sbb    %ebp,%edx
  802774:	e9 14 ff ff ff       	jmp    80268d <__umoddi3+0x2d>
