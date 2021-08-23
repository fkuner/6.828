
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 40 80 00       	mov    0x804008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 40 29 80 00       	push   $0x802940
  800047:	e8 6a 01 00 00       	call   8001b6 <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 5e 29 80 00       	push   $0x80295e
  800056:	68 5e 29 80 00       	push   $0x80295e
  80005b:	e8 a4 1b 00 00       	call   801c04 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 66 29 80 00       	push   $0x802966
  80006f:	6a 09                	push   $0x9
  800071:	68 80 29 80 00       	push   $0x802980
  800076:	e8 60 00 00 00       	call   8000db <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 83 0b 00 00       	call   800c0e <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 db                	test   %ebx,%ebx
  80009f:	7e 07                	jle    8000a8 <libmain+0x2d>
		binaryname = argv[0];
  8000a1:	8b 06                	mov    (%esi),%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c7:	e8 66 0f 00 00       	call   801032 <close_all>
	sys_env_destroy(0);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 f7 0a 00 00       	call   800bcd <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000e3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e9:	e8 20 0b 00 00       	call   800c0e <sys_getenvid>
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 0c             	pushl  0xc(%ebp)
  8000f4:	ff 75 08             	pushl  0x8(%ebp)
  8000f7:	56                   	push   %esi
  8000f8:	50                   	push   %eax
  8000f9:	68 a0 29 80 00       	push   $0x8029a0
  8000fe:	e8 b3 00 00 00       	call   8001b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800103:	83 c4 18             	add    $0x18,%esp
  800106:	53                   	push   %ebx
  800107:	ff 75 10             	pushl  0x10(%ebp)
  80010a:	e8 56 00 00 00       	call   800165 <vcprintf>
	cprintf("\n");
  80010f:	c7 04 24 a8 2e 80 00 	movl   $0x802ea8,(%esp)
  800116:	e8 9b 00 00 00       	call   8001b6 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80011e:	cc                   	int3   
  80011f:	eb fd                	jmp    80011e <_panic+0x43>

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	53                   	push   %ebx
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012b:	8b 13                	mov    (%ebx),%edx
  80012d:	8d 42 01             	lea    0x1(%edx),%eax
  800130:	89 03                	mov    %eax,(%ebx)
  800132:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800135:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800139:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013e:	74 09                	je     800149 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800140:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800147:	c9                   	leave  
  800148:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 ff 00 00 00       	push   $0xff
  800151:	8d 43 08             	lea    0x8(%ebx),%eax
  800154:	50                   	push   %eax
  800155:	e8 36 0a 00 00       	call   800b90 <sys_cputs>
		b->idx = 0;
  80015a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	eb db                	jmp    800140 <putch+0x1f>

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	68 21 01 80 00       	push   $0x800121
  800194:	e8 1a 01 00 00       	call   8002b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 e2 09 00 00       	call   800b90 <sys_cputs>

	return b.cnt;
}
  8001ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bf:	50                   	push   %eax
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	e8 9d ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 1c             	sub    $0x1c,%esp
  8001d3:	89 c7                	mov    %eax,%edi
  8001d5:	89 d6                	mov    %edx,%esi
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f1:	39 d3                	cmp    %edx,%ebx
  8001f3:	72 05                	jb     8001fa <printnum+0x30>
  8001f5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f8:	77 7a                	ja     800274 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	8b 45 14             	mov    0x14(%ebp),%eax
  800203:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800206:	53                   	push   %ebx
  800207:	ff 75 10             	pushl  0x10(%ebp)
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800210:	ff 75 e0             	pushl  -0x20(%ebp)
  800213:	ff 75 dc             	pushl  -0x24(%ebp)
  800216:	ff 75 d8             	pushl  -0x28(%ebp)
  800219:	e8 d2 24 00 00       	call   8026f0 <__udivdi3>
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	89 f2                	mov    %esi,%edx
  800225:	89 f8                	mov    %edi,%eax
  800227:	e8 9e ff ff ff       	call   8001ca <printnum>
  80022c:	83 c4 20             	add    $0x20,%esp
  80022f:	eb 13                	jmp    800244 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	56                   	push   %esi
  800235:	ff 75 18             	pushl  0x18(%ebp)
  800238:	ff d7                	call   *%edi
  80023a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023d:	83 eb 01             	sub    $0x1,%ebx
  800240:	85 db                	test   %ebx,%ebx
  800242:	7f ed                	jg     800231 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	56                   	push   %esi
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024e:	ff 75 e0             	pushl  -0x20(%ebp)
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	e8 b4 25 00 00       	call   802810 <__umoddi3>
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	0f be 80 c3 29 80 00 	movsbl 0x8029c3(%eax),%eax
  800266:	50                   	push   %eax
  800267:	ff d7                	call   *%edi
}
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    
  800274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800277:	eb c4                	jmp    80023d <printnum+0x73>

00800279 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800283:	8b 10                	mov    (%eax),%edx
  800285:	3b 50 04             	cmp    0x4(%eax),%edx
  800288:	73 0a                	jae    800294 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028d:	89 08                	mov    %ecx,(%eax)
  80028f:	8b 45 08             	mov    0x8(%ebp),%eax
  800292:	88 02                	mov    %al,(%edx)
}
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <printfmt>:
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029f:	50                   	push   %eax
  8002a0:	ff 75 10             	pushl  0x10(%ebp)
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 05 00 00 00       	call   8002b3 <vprintfmt>
}
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <vprintfmt>:
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 2c             	sub    $0x2c,%esp
  8002bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c5:	e9 21 04 00 00       	jmp    8006eb <vprintfmt+0x438>
		padc = ' ';
  8002ca:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8d 47 01             	lea    0x1(%edi),%eax
  8002eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ee:	0f b6 17             	movzbl (%edi),%edx
  8002f1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f4:	3c 55                	cmp    $0x55,%al
  8002f6:	0f 87 90 04 00 00    	ja     80078c <vprintfmt+0x4d9>
  8002fc:	0f b6 c0             	movzbl %al,%eax
  8002ff:	ff 24 85 00 2b 80 00 	jmp    *0x802b00(,%eax,4)
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800309:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030d:	eb d9                	jmp    8002e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800312:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800316:	eb d0                	jmp    8002e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800318:	0f b6 d2             	movzbl %dl,%edx
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
  800323:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800326:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800329:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800330:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800333:	83 f9 09             	cmp    $0x9,%ecx
  800336:	77 55                	ja     80038d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800338:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033b:	eb e9                	jmp    800326 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800345:	8b 45 14             	mov    0x14(%ebp),%eax
  800348:	8d 40 04             	lea    0x4(%eax),%eax
  80034b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800351:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800355:	79 91                	jns    8002e8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800357:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800364:	eb 82                	jmp    8002e8 <vprintfmt+0x35>
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	85 c0                	test   %eax,%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	0f 49 d0             	cmovns %eax,%edx
  800373:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800379:	e9 6a ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
  80037e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800381:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800388:	e9 5b ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
  80038d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800390:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800393:	eb bc                	jmp    800351 <vprintfmt+0x9e>
			lflag++;
  800395:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039b:	e9 48 ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a3:	8d 78 04             	lea    0x4(%eax),%edi
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	53                   	push   %ebx
  8003aa:	ff 30                	pushl  (%eax)
  8003ac:	ff d6                	call   *%esi
			break;
  8003ae:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b4:	e9 2f 03 00 00       	jmp    8006e8 <vprintfmt+0x435>
			err = va_arg(ap, int);
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8d 78 04             	lea    0x4(%eax),%edi
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	99                   	cltd   
  8003c2:	31 d0                	xor    %edx,%eax
  8003c4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c6:	83 f8 0f             	cmp    $0xf,%eax
  8003c9:	7f 23                	jg     8003ee <vprintfmt+0x13b>
  8003cb:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  8003d2:	85 d2                	test   %edx,%edx
  8003d4:	74 18                	je     8003ee <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003d6:	52                   	push   %edx
  8003d7:	68 bb 2d 80 00       	push   $0x802dbb
  8003dc:	53                   	push   %ebx
  8003dd:	56                   	push   %esi
  8003de:	e8 b3 fe ff ff       	call   800296 <printfmt>
  8003e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e9:	e9 fa 02 00 00       	jmp    8006e8 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8003ee:	50                   	push   %eax
  8003ef:	68 db 29 80 00       	push   $0x8029db
  8003f4:	53                   	push   %ebx
  8003f5:	56                   	push   %esi
  8003f6:	e8 9b fe ff ff       	call   800296 <printfmt>
  8003fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800401:	e9 e2 02 00 00       	jmp    8006e8 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	83 c0 04             	add    $0x4,%eax
  80040c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800414:	85 ff                	test   %edi,%edi
  800416:	b8 d4 29 80 00       	mov    $0x8029d4,%eax
  80041b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80041e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800422:	0f 8e bd 00 00 00    	jle    8004e5 <vprintfmt+0x232>
  800428:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80042c:	75 0e                	jne    80043c <vprintfmt+0x189>
  80042e:	89 75 08             	mov    %esi,0x8(%ebp)
  800431:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800434:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800437:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80043a:	eb 6d                	jmp    8004a9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 d0             	pushl  -0x30(%ebp)
  800442:	57                   	push   %edi
  800443:	e8 ec 03 00 00       	call   800834 <strnlen>
  800448:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044b:	29 c1                	sub    %eax,%ecx
  80044d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800450:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800453:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800457:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80045d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045f:	eb 0f                	jmp    800470 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	53                   	push   %ebx
  800465:	ff 75 e0             	pushl  -0x20(%ebp)
  800468:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80046a:	83 ef 01             	sub    $0x1,%edi
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	85 ff                	test   %edi,%edi
  800472:	7f ed                	jg     800461 <vprintfmt+0x1ae>
  800474:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800477:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80047a:	85 c9                	test   %ecx,%ecx
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	0f 49 c1             	cmovns %ecx,%eax
  800484:	29 c1                	sub    %eax,%ecx
  800486:	89 75 08             	mov    %esi,0x8(%ebp)
  800489:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048f:	89 cb                	mov    %ecx,%ebx
  800491:	eb 16                	jmp    8004a9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800493:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800497:	75 31                	jne    8004ca <vprintfmt+0x217>
					putch(ch, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	ff 75 0c             	pushl  0xc(%ebp)
  80049f:	50                   	push   %eax
  8004a0:	ff 55 08             	call   *0x8(%ebp)
  8004a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a6:	83 eb 01             	sub    $0x1,%ebx
  8004a9:	83 c7 01             	add    $0x1,%edi
  8004ac:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004b0:	0f be c2             	movsbl %dl,%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	74 59                	je     800510 <vprintfmt+0x25d>
  8004b7:	85 f6                	test   %esi,%esi
  8004b9:	78 d8                	js     800493 <vprintfmt+0x1e0>
  8004bb:	83 ee 01             	sub    $0x1,%esi
  8004be:	79 d3                	jns    800493 <vprintfmt+0x1e0>
  8004c0:	89 df                	mov    %ebx,%edi
  8004c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c8:	eb 37                	jmp    800501 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ca:	0f be d2             	movsbl %dl,%edx
  8004cd:	83 ea 20             	sub    $0x20,%edx
  8004d0:	83 fa 5e             	cmp    $0x5e,%edx
  8004d3:	76 c4                	jbe    800499 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 0c             	pushl  0xc(%ebp)
  8004db:	6a 3f                	push   $0x3f
  8004dd:	ff 55 08             	call   *0x8(%ebp)
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	eb c1                	jmp    8004a6 <vprintfmt+0x1f3>
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f1:	eb b6                	jmp    8004a9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 20                	push   $0x20
  8004f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fb:	83 ef 01             	sub    $0x1,%edi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 ff                	test   %edi,%edi
  800503:	7f ee                	jg     8004f3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 d8 01 00 00       	jmp    8006e8 <vprintfmt+0x435>
  800510:	89 df                	mov    %ebx,%edi
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	eb e7                	jmp    800501 <vprintfmt+0x24e>
	if (lflag >= 2)
  80051a:	83 f9 01             	cmp    $0x1,%ecx
  80051d:	7e 45                	jle    800564 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8b 50 04             	mov    0x4(%eax),%edx
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 40 08             	lea    0x8(%eax),%eax
  800533:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800536:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80053a:	79 62                	jns    80059e <vprintfmt+0x2eb>
				putch('-', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	6a 2d                	push   $0x2d
  800542:	ff d6                	call   *%esi
				num = -(long long) num;
  800544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800547:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80054a:	f7 d8                	neg    %eax
  80054c:	83 d2 00             	adc    $0x0,%edx
  80054f:	f7 da                	neg    %edx
  800551:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800554:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800557:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80055a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80055f:	e9 66 01 00 00       	jmp    8006ca <vprintfmt+0x417>
	else if (lflag)
  800564:	85 c9                	test   %ecx,%ecx
  800566:	75 1b                	jne    800583 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	89 c1                	mov    %eax,%ecx
  800572:	c1 f9 1f             	sar    $0x1f,%ecx
  800575:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8d 40 04             	lea    0x4(%eax),%eax
  80057e:	89 45 14             	mov    %eax,0x14(%ebp)
  800581:	eb b3                	jmp    800536 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 c1                	mov    %eax,%ecx
  80058d:	c1 f9 1f             	sar    $0x1f,%ecx
  800590:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 40 04             	lea    0x4(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	eb 98                	jmp    800536 <vprintfmt+0x283>
			base = 10;
  80059e:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a3:	e9 22 01 00 00       	jmp    8006ca <vprintfmt+0x417>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7e 21                	jle    8005ce <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 50 04             	mov    0x4(%eax),%edx
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 40 08             	lea    0x8(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005c9:	e9 fc 00 00 00       	jmp    8006ca <vprintfmt+0x417>
	else if (lflag)
  8005ce:	85 c9                	test   %ecx,%ecx
  8005d0:	75 23                	jne    8005f5 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005eb:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005f0:	e9 d5 00 00 00       	jmp    8006ca <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800602:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 40 04             	lea    0x4(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800613:	e9 b2 00 00 00       	jmp    8006ca <vprintfmt+0x417>
	if (lflag >= 2)
  800618:	83 f9 01             	cmp    $0x1,%ecx
  80061b:	7e 42                	jle    80065f <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 50 04             	mov    0x4(%eax),%edx
  800623:	8b 00                	mov    (%eax),%eax
  800625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800628:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 40 08             	lea    0x8(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800634:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800639:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80063d:	0f 89 87 00 00 00    	jns    8006ca <vprintfmt+0x417>
				putch('-', putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	53                   	push   %ebx
  800647:	6a 2d                	push   $0x2d
  800649:	ff d6                	call   *%esi
				num = -(long long) num;
  80064b:	f7 5d d8             	negl   -0x28(%ebp)
  80064e:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800652:	f7 5d dc             	negl   -0x24(%ebp)
  800655:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800658:	ba 08 00 00 00       	mov    $0x8,%edx
  80065d:	eb 6b                	jmp    8006ca <vprintfmt+0x417>
	else if (lflag)
  80065f:	85 c9                	test   %ecx,%ecx
  800661:	75 1b                	jne    80067e <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	ba 00 00 00 00       	mov    $0x0,%edx
  80066d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800670:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
  80067c:	eb b6                	jmp    800634 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
  800697:	eb 9b                	jmp    800634 <vprintfmt+0x381>
			putch('0', putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	6a 30                	push   $0x30
  80069f:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a1:	83 c4 08             	add    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 78                	push   $0x78
  8006a7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006b9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c5:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006ca:	83 ec 0c             	sub    $0xc,%esp
  8006cd:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006d1:	50                   	push   %eax
  8006d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d5:	52                   	push   %edx
  8006d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8006d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8006dc:	89 da                	mov    %ebx,%edx
  8006de:	89 f0                	mov    %esi,%eax
  8006e0:	e8 e5 fa ff ff       	call   8001ca <printnum>
			break;
  8006e5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006eb:	83 c7 01             	add    $0x1,%edi
  8006ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f2:	83 f8 25             	cmp    $0x25,%eax
  8006f5:	0f 84 cf fb ff ff    	je     8002ca <vprintfmt+0x17>
			if (ch == '\0')
  8006fb:	85 c0                	test   %eax,%eax
  8006fd:	0f 84 a9 00 00 00    	je     8007ac <vprintfmt+0x4f9>
			putch(ch, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	50                   	push   %eax
  800708:	ff d6                	call   *%esi
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	eb dc                	jmp    8006eb <vprintfmt+0x438>
	if (lflag >= 2)
  80070f:	83 f9 01             	cmp    $0x1,%ecx
  800712:	7e 1e                	jle    800732 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 50 04             	mov    0x4(%eax),%edx
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 40 08             	lea    0x8(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072b:	ba 10 00 00 00       	mov    $0x10,%edx
  800730:	eb 98                	jmp    8006ca <vprintfmt+0x417>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	75 23                	jne    800759 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	ba 00 00 00 00       	mov    $0x0,%edx
  800740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074f:	ba 10 00 00 00       	mov    $0x10,%edx
  800754:	e9 71 ff ff ff       	jmp    8006ca <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800772:	ba 10 00 00 00       	mov    $0x10,%edx
  800777:	e9 4e ff ff ff       	jmp    8006ca <vprintfmt+0x417>
			putch(ch, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	6a 25                	push   $0x25
  800782:	ff d6                	call   *%esi
			break;
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	e9 5c ff ff ff       	jmp    8006e8 <vprintfmt+0x435>
			putch('%', putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	6a 25                	push   $0x25
  800792:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	89 f8                	mov    %edi,%eax
  800799:	eb 03                	jmp    80079e <vprintfmt+0x4eb>
  80079b:	83 e8 01             	sub    $0x1,%eax
  80079e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a2:	75 f7                	jne    80079b <vprintfmt+0x4e8>
  8007a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a7:	e9 3c ff ff ff       	jmp    8006e8 <vprintfmt+0x435>
}
  8007ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007af:	5b                   	pop    %ebx
  8007b0:	5e                   	pop    %esi
  8007b1:	5f                   	pop    %edi
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	83 ec 18             	sub    $0x18,%esp
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d1:	85 c0                	test   %eax,%eax
  8007d3:	74 26                	je     8007fb <vsnprintf+0x47>
  8007d5:	85 d2                	test   %edx,%edx
  8007d7:	7e 22                	jle    8007fb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d9:	ff 75 14             	pushl  0x14(%ebp)
  8007dc:	ff 75 10             	pushl  0x10(%ebp)
  8007df:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e2:	50                   	push   %eax
  8007e3:	68 79 02 80 00       	push   $0x800279
  8007e8:	e8 c6 fa ff ff       	call   8002b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
}
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    
		return -E_INVAL;
  8007fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800800:	eb f7                	jmp    8007f9 <vsnprintf+0x45>

00800802 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800808:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080b:	50                   	push   %eax
  80080c:	ff 75 10             	pushl  0x10(%ebp)
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	ff 75 08             	pushl  0x8(%ebp)
  800815:	e8 9a ff ff ff       	call   8007b4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800822:	b8 00 00 00 00       	mov    $0x0,%eax
  800827:	eb 03                	jmp    80082c <strlen+0x10>
		n++;
  800829:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80082c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800830:	75 f7                	jne    800829 <strlen+0xd>
	return n;
}
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083d:	b8 00 00 00 00       	mov    $0x0,%eax
  800842:	eb 03                	jmp    800847 <strnlen+0x13>
		n++;
  800844:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800847:	39 d0                	cmp    %edx,%eax
  800849:	74 06                	je     800851 <strnlen+0x1d>
  80084b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084f:	75 f3                	jne    800844 <strnlen+0x10>
	return n;
}
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	53                   	push   %ebx
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80085d:	89 c2                	mov    %eax,%edx
  80085f:	83 c1 01             	add    $0x1,%ecx
  800862:	83 c2 01             	add    $0x1,%edx
  800865:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800869:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086c:	84 db                	test   %bl,%bl
  80086e:	75 ef                	jne    80085f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800870:	5b                   	pop    %ebx
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	53                   	push   %ebx
  800877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80087a:	53                   	push   %ebx
  80087b:	e8 9c ff ff ff       	call   80081c <strlen>
  800880:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	01 d8                	add    %ebx,%eax
  800888:	50                   	push   %eax
  800889:	e8 c5 ff ff ff       	call   800853 <strcpy>
	return dst;
}
  80088e:	89 d8                	mov    %ebx,%eax
  800890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	8b 75 08             	mov    0x8(%ebp),%esi
  80089d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a0:	89 f3                	mov    %esi,%ebx
  8008a2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a5:	89 f2                	mov    %esi,%edx
  8008a7:	eb 0f                	jmp    8008b8 <strncpy+0x23>
		*dst++ = *src;
  8008a9:	83 c2 01             	add    $0x1,%edx
  8008ac:	0f b6 01             	movzbl (%ecx),%eax
  8008af:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b8:	39 da                	cmp    %ebx,%edx
  8008ba:	75 ed                	jne    8008a9 <strncpy+0x14>
	}
	return ret;
}
  8008bc:	89 f0                	mov    %esi,%eax
  8008be:	5b                   	pop    %ebx
  8008bf:	5e                   	pop    %esi
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008d0:	89 f0                	mov    %esi,%eax
  8008d2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d6:	85 c9                	test   %ecx,%ecx
  8008d8:	75 0b                	jne    8008e5 <strlcpy+0x23>
  8008da:	eb 17                	jmp    8008f3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008dc:	83 c2 01             	add    $0x1,%edx
  8008df:	83 c0 01             	add    $0x1,%eax
  8008e2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008e5:	39 d8                	cmp    %ebx,%eax
  8008e7:	74 07                	je     8008f0 <strlcpy+0x2e>
  8008e9:	0f b6 0a             	movzbl (%edx),%ecx
  8008ec:	84 c9                	test   %cl,%cl
  8008ee:	75 ec                	jne    8008dc <strlcpy+0x1a>
		*dst = '\0';
  8008f0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f3:	29 f0                	sub    %esi,%eax
}
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800902:	eb 06                	jmp    80090a <strcmp+0x11>
		p++, q++;
  800904:	83 c1 01             	add    $0x1,%ecx
  800907:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80090a:	0f b6 01             	movzbl (%ecx),%eax
  80090d:	84 c0                	test   %al,%al
  80090f:	74 04                	je     800915 <strcmp+0x1c>
  800911:	3a 02                	cmp    (%edx),%al
  800913:	74 ef                	je     800904 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800915:	0f b6 c0             	movzbl %al,%eax
  800918:	0f b6 12             	movzbl (%edx),%edx
  80091b:	29 d0                	sub    %edx,%eax
}
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	53                   	push   %ebx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 55 0c             	mov    0xc(%ebp),%edx
  800929:	89 c3                	mov    %eax,%ebx
  80092b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092e:	eb 06                	jmp    800936 <strncmp+0x17>
		n--, p++, q++;
  800930:	83 c0 01             	add    $0x1,%eax
  800933:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800936:	39 d8                	cmp    %ebx,%eax
  800938:	74 16                	je     800950 <strncmp+0x31>
  80093a:	0f b6 08             	movzbl (%eax),%ecx
  80093d:	84 c9                	test   %cl,%cl
  80093f:	74 04                	je     800945 <strncmp+0x26>
  800941:	3a 0a                	cmp    (%edx),%cl
  800943:	74 eb                	je     800930 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800945:	0f b6 00             	movzbl (%eax),%eax
  800948:	0f b6 12             	movzbl (%edx),%edx
  80094b:	29 d0                	sub    %edx,%eax
}
  80094d:	5b                   	pop    %ebx
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    
		return 0;
  800950:	b8 00 00 00 00       	mov    $0x0,%eax
  800955:	eb f6                	jmp    80094d <strncmp+0x2e>

00800957 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800961:	0f b6 10             	movzbl (%eax),%edx
  800964:	84 d2                	test   %dl,%dl
  800966:	74 09                	je     800971 <strchr+0x1a>
		if (*s == c)
  800968:	38 ca                	cmp    %cl,%dl
  80096a:	74 0a                	je     800976 <strchr+0x1f>
	for (; *s; s++)
  80096c:	83 c0 01             	add    $0x1,%eax
  80096f:	eb f0                	jmp    800961 <strchr+0xa>
			return (char *) s;
	return 0;
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800982:	eb 03                	jmp    800987 <strfind+0xf>
  800984:	83 c0 01             	add    $0x1,%eax
  800987:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80098a:	38 ca                	cmp    %cl,%dl
  80098c:	74 04                	je     800992 <strfind+0x1a>
  80098e:	84 d2                	test   %dl,%dl
  800990:	75 f2                	jne    800984 <strfind+0xc>
			break;
	return (char *) s;
}
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	57                   	push   %edi
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a0:	85 c9                	test   %ecx,%ecx
  8009a2:	74 13                	je     8009b7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009aa:	75 05                	jne    8009b1 <memset+0x1d>
  8009ac:	f6 c1 03             	test   $0x3,%cl
  8009af:	74 0d                	je     8009be <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	fc                   	cld    
  8009b5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b7:	89 f8                	mov    %edi,%eax
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5f                   	pop    %edi
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    
		c &= 0xFF;
  8009be:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c2:	89 d3                	mov    %edx,%ebx
  8009c4:	c1 e3 08             	shl    $0x8,%ebx
  8009c7:	89 d0                	mov    %edx,%eax
  8009c9:	c1 e0 18             	shl    $0x18,%eax
  8009cc:	89 d6                	mov    %edx,%esi
  8009ce:	c1 e6 10             	shl    $0x10,%esi
  8009d1:	09 f0                	or     %esi,%eax
  8009d3:	09 c2                	or     %eax,%edx
  8009d5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009da:	89 d0                	mov    %edx,%eax
  8009dc:	fc                   	cld    
  8009dd:	f3 ab                	rep stos %eax,%es:(%edi)
  8009df:	eb d6                	jmp    8009b7 <memset+0x23>

008009e1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	57                   	push   %edi
  8009e5:	56                   	push   %esi
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ef:	39 c6                	cmp    %eax,%esi
  8009f1:	73 35                	jae    800a28 <memmove+0x47>
  8009f3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f6:	39 c2                	cmp    %eax,%edx
  8009f8:	76 2e                	jbe    800a28 <memmove+0x47>
		s += n;
		d += n;
  8009fa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fd:	89 d6                	mov    %edx,%esi
  8009ff:	09 fe                	or     %edi,%esi
  800a01:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a07:	74 0c                	je     800a15 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a09:	83 ef 01             	sub    $0x1,%edi
  800a0c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0f:	fd                   	std    
  800a10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a12:	fc                   	cld    
  800a13:	eb 21                	jmp    800a36 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a15:	f6 c1 03             	test   $0x3,%cl
  800a18:	75 ef                	jne    800a09 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a1a:	83 ef 04             	sub    $0x4,%edi
  800a1d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a20:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a23:	fd                   	std    
  800a24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a26:	eb ea                	jmp    800a12 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a28:	89 f2                	mov    %esi,%edx
  800a2a:	09 c2                	or     %eax,%edx
  800a2c:	f6 c2 03             	test   $0x3,%dl
  800a2f:	74 09                	je     800a3a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a31:	89 c7                	mov    %eax,%edi
  800a33:	fc                   	cld    
  800a34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a36:	5e                   	pop    %esi
  800a37:	5f                   	pop    %edi
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3a:	f6 c1 03             	test   $0x3,%cl
  800a3d:	75 f2                	jne    800a31 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a42:	89 c7                	mov    %eax,%edi
  800a44:	fc                   	cld    
  800a45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a47:	eb ed                	jmp    800a36 <memmove+0x55>

00800a49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a4c:	ff 75 10             	pushl  0x10(%ebp)
  800a4f:	ff 75 0c             	pushl  0xc(%ebp)
  800a52:	ff 75 08             	pushl  0x8(%ebp)
  800a55:	e8 87 ff ff ff       	call   8009e1 <memmove>
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a67:	89 c6                	mov    %eax,%esi
  800a69:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6c:	39 f0                	cmp    %esi,%eax
  800a6e:	74 1c                	je     800a8c <memcmp+0x30>
		if (*s1 != *s2)
  800a70:	0f b6 08             	movzbl (%eax),%ecx
  800a73:	0f b6 1a             	movzbl (%edx),%ebx
  800a76:	38 d9                	cmp    %bl,%cl
  800a78:	75 08                	jne    800a82 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a7a:	83 c0 01             	add    $0x1,%eax
  800a7d:	83 c2 01             	add    $0x1,%edx
  800a80:	eb ea                	jmp    800a6c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a82:	0f b6 c1             	movzbl %cl,%eax
  800a85:	0f b6 db             	movzbl %bl,%ebx
  800a88:	29 d8                	sub    %ebx,%eax
  800a8a:	eb 05                	jmp    800a91 <memcmp+0x35>
	}

	return 0;
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a91:	5b                   	pop    %ebx
  800a92:	5e                   	pop    %esi
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9e:	89 c2                	mov    %eax,%edx
  800aa0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa3:	39 d0                	cmp    %edx,%eax
  800aa5:	73 09                	jae    800ab0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa7:	38 08                	cmp    %cl,(%eax)
  800aa9:	74 05                	je     800ab0 <memfind+0x1b>
	for (; s < ends; s++)
  800aab:	83 c0 01             	add    $0x1,%eax
  800aae:	eb f3                	jmp    800aa3 <memfind+0xe>
			break;
	return (void *) s;
}
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	57                   	push   %edi
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abe:	eb 03                	jmp    800ac3 <strtol+0x11>
		s++;
  800ac0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ac3:	0f b6 01             	movzbl (%ecx),%eax
  800ac6:	3c 20                	cmp    $0x20,%al
  800ac8:	74 f6                	je     800ac0 <strtol+0xe>
  800aca:	3c 09                	cmp    $0x9,%al
  800acc:	74 f2                	je     800ac0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ace:	3c 2b                	cmp    $0x2b,%al
  800ad0:	74 2e                	je     800b00 <strtol+0x4e>
	int neg = 0;
  800ad2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad7:	3c 2d                	cmp    $0x2d,%al
  800ad9:	74 2f                	je     800b0a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800adb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae1:	75 05                	jne    800ae8 <strtol+0x36>
  800ae3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae6:	74 2c                	je     800b14 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae8:	85 db                	test   %ebx,%ebx
  800aea:	75 0a                	jne    800af6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aec:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800af1:	80 39 30             	cmpb   $0x30,(%ecx)
  800af4:	74 28                	je     800b1e <strtol+0x6c>
		base = 10;
  800af6:	b8 00 00 00 00       	mov    $0x0,%eax
  800afb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800afe:	eb 50                	jmp    800b50 <strtol+0x9e>
		s++;
  800b00:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b03:	bf 00 00 00 00       	mov    $0x0,%edi
  800b08:	eb d1                	jmp    800adb <strtol+0x29>
		s++, neg = 1;
  800b0a:	83 c1 01             	add    $0x1,%ecx
  800b0d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b12:	eb c7                	jmp    800adb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b14:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b18:	74 0e                	je     800b28 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b1a:	85 db                	test   %ebx,%ebx
  800b1c:	75 d8                	jne    800af6 <strtol+0x44>
		s++, base = 8;
  800b1e:	83 c1 01             	add    $0x1,%ecx
  800b21:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b26:	eb ce                	jmp    800af6 <strtol+0x44>
		s += 2, base = 16;
  800b28:	83 c1 02             	add    $0x2,%ecx
  800b2b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b30:	eb c4                	jmp    800af6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b32:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b35:	89 f3                	mov    %esi,%ebx
  800b37:	80 fb 19             	cmp    $0x19,%bl
  800b3a:	77 29                	ja     800b65 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3c:	0f be d2             	movsbl %dl,%edx
  800b3f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b42:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b45:	7d 30                	jge    800b77 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b47:	83 c1 01             	add    $0x1,%ecx
  800b4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b50:	0f b6 11             	movzbl (%ecx),%edx
  800b53:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b56:	89 f3                	mov    %esi,%ebx
  800b58:	80 fb 09             	cmp    $0x9,%bl
  800b5b:	77 d5                	ja     800b32 <strtol+0x80>
			dig = *s - '0';
  800b5d:	0f be d2             	movsbl %dl,%edx
  800b60:	83 ea 30             	sub    $0x30,%edx
  800b63:	eb dd                	jmp    800b42 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b65:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b68:	89 f3                	mov    %esi,%ebx
  800b6a:	80 fb 19             	cmp    $0x19,%bl
  800b6d:	77 08                	ja     800b77 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b6f:	0f be d2             	movsbl %dl,%edx
  800b72:	83 ea 37             	sub    $0x37,%edx
  800b75:	eb cb                	jmp    800b42 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7b:	74 05                	je     800b82 <strtol+0xd0>
		*endptr = (char *) s;
  800b7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b80:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b82:	89 c2                	mov    %eax,%edx
  800b84:	f7 da                	neg    %edx
  800b86:	85 ff                	test   %edi,%edi
  800b88:	0f 45 c2             	cmovne %edx,%eax
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b96:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba1:	89 c3                	mov    %eax,%ebx
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	89 c6                	mov    %eax,%esi
  800ba7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <sys_cgetc>:

int
sys_cgetc(void)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bde:	b8 03 00 00 00       	mov    $0x3,%eax
  800be3:	89 cb                	mov    %ecx,%ebx
  800be5:	89 cf                	mov    %ecx,%edi
  800be7:	89 ce                	mov    %ecx,%esi
  800be9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800beb:	85 c0                	test   %eax,%eax
  800bed:	7f 08                	jg     800bf7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf7:	83 ec 0c             	sub    $0xc,%esp
  800bfa:	50                   	push   %eax
  800bfb:	6a 03                	push   $0x3
  800bfd:	68 bf 2c 80 00       	push   $0x802cbf
  800c02:	6a 23                	push   $0x23
  800c04:	68 dc 2c 80 00       	push   $0x802cdc
  800c09:	e8 cd f4 ff ff       	call   8000db <_panic>

00800c0e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	89 d3                	mov    %edx,%ebx
  800c22:	89 d7                	mov    %edx,%edi
  800c24:	89 d6                	mov    %edx,%esi
  800c26:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <sys_yield>:

void
sys_yield(void)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c3d:	89 d1                	mov    %edx,%ecx
  800c3f:	89 d3                	mov    %edx,%ebx
  800c41:	89 d7                	mov    %edx,%edi
  800c43:	89 d6                	mov    %edx,%esi
  800c45:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c55:	be 00 00 00 00       	mov    $0x0,%esi
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	b8 04 00 00 00       	mov    $0x4,%eax
  800c65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c68:	89 f7                	mov    %esi,%edi
  800c6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6c:	85 c0                	test   %eax,%eax
  800c6e:	7f 08                	jg     800c78 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c73:	5b                   	pop    %ebx
  800c74:	5e                   	pop    %esi
  800c75:	5f                   	pop    %edi
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c78:	83 ec 0c             	sub    $0xc,%esp
  800c7b:	50                   	push   %eax
  800c7c:	6a 04                	push   $0x4
  800c7e:	68 bf 2c 80 00       	push   $0x802cbf
  800c83:	6a 23                	push   $0x23
  800c85:	68 dc 2c 80 00       	push   $0x802cdc
  800c8a:	e8 4c f4 ff ff       	call   8000db <_panic>

00800c8f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca9:	8b 75 18             	mov    0x18(%ebp),%esi
  800cac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	7f 08                	jg     800cba <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cba:	83 ec 0c             	sub    $0xc,%esp
  800cbd:	50                   	push   %eax
  800cbe:	6a 05                	push   $0x5
  800cc0:	68 bf 2c 80 00       	push   $0x802cbf
  800cc5:	6a 23                	push   $0x23
  800cc7:	68 dc 2c 80 00       	push   $0x802cdc
  800ccc:	e8 0a f4 ff ff       	call   8000db <_panic>

00800cd1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cea:	89 df                	mov    %ebx,%edi
  800cec:	89 de                	mov    %ebx,%esi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 06                	push   $0x6
  800d02:	68 bf 2c 80 00       	push   $0x802cbf
  800d07:	6a 23                	push   $0x23
  800d09:	68 dc 2c 80 00       	push   $0x802cdc
  800d0e:	e8 c8 f3 ff ff       	call   8000db <_panic>

00800d13 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	b8 08 00 00 00       	mov    $0x8,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 08                	push   $0x8
  800d44:	68 bf 2c 80 00       	push   $0x802cbf
  800d49:	6a 23                	push   $0x23
  800d4b:	68 dc 2c 80 00       	push   $0x802cdc
  800d50:	e8 86 f3 ff ff       	call   8000db <_panic>

00800d55 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6e:	89 df                	mov    %ebx,%edi
  800d70:	89 de                	mov    %ebx,%esi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 09                	push   $0x9
  800d86:	68 bf 2c 80 00       	push   $0x802cbf
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 dc 2c 80 00       	push   $0x802cdc
  800d92:	e8 44 f3 ff ff       	call   8000db <_panic>

00800d97 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db0:	89 df                	mov    %ebx,%edi
  800db2:	89 de                	mov    %ebx,%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 0a                	push   $0xa
  800dc8:	68 bf 2c 80 00       	push   $0x802cbf
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 dc 2c 80 00       	push   $0x802cdc
  800dd4:	e8 02 f3 ff ff       	call   8000db <_panic>

00800dd9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dea:	be 00 00 00 00       	mov    $0x0,%esi
  800def:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e12:	89 cb                	mov    %ecx,%ebx
  800e14:	89 cf                	mov    %ecx,%edi
  800e16:	89 ce                	mov    %ecx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 0d                	push   $0xd
  800e2c:	68 bf 2c 80 00       	push   $0x802cbf
  800e31:	6a 23                	push   $0x23
  800e33:	68 dc 2c 80 00       	push   $0x802cdc
  800e38:	e8 9e f2 ff ff       	call   8000db <_panic>

00800e3d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e43:	ba 00 00 00 00       	mov    $0x0,%edx
  800e48:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e4d:	89 d1                	mov    %edx,%ecx
  800e4f:	89 d3                	mov    %edx,%ebx
  800e51:	89 d7                	mov    %edx,%edi
  800e53:	89 d6                	mov    %edx,%esi
  800e55:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	05 00 00 00 30       	add    $0x30000000,%eax
  800e67:	c1 e8 0c             	shr    $0xc,%eax
}
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e7c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e89:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e8e:	89 c2                	mov    %eax,%edx
  800e90:	c1 ea 16             	shr    $0x16,%edx
  800e93:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e9a:	f6 c2 01             	test   $0x1,%dl
  800e9d:	74 2a                	je     800ec9 <fd_alloc+0x46>
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	c1 ea 0c             	shr    $0xc,%edx
  800ea4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eab:	f6 c2 01             	test   $0x1,%dl
  800eae:	74 19                	je     800ec9 <fd_alloc+0x46>
  800eb0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eb5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eba:	75 d2                	jne    800e8e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ebc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ec2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ec7:	eb 07                	jmp    800ed0 <fd_alloc+0x4d>
			*fd_store = fd;
  800ec9:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ecb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ed8:	83 f8 1f             	cmp    $0x1f,%eax
  800edb:	77 36                	ja     800f13 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800edd:	c1 e0 0c             	shl    $0xc,%eax
  800ee0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	c1 ea 16             	shr    $0x16,%edx
  800eea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef1:	f6 c2 01             	test   $0x1,%dl
  800ef4:	74 24                	je     800f1a <fd_lookup+0x48>
  800ef6:	89 c2                	mov    %eax,%edx
  800ef8:	c1 ea 0c             	shr    $0xc,%edx
  800efb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f02:	f6 c2 01             	test   $0x1,%dl
  800f05:	74 1a                	je     800f21 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0a:	89 02                	mov    %eax,(%edx)
	return 0;
  800f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    
		return -E_INVAL;
  800f13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f18:	eb f7                	jmp    800f11 <fd_lookup+0x3f>
		return -E_INVAL;
  800f1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1f:	eb f0                	jmp    800f11 <fd_lookup+0x3f>
  800f21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f26:	eb e9                	jmp    800f11 <fd_lookup+0x3f>

00800f28 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f31:	ba 68 2d 80 00       	mov    $0x802d68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f36:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f3b:	39 08                	cmp    %ecx,(%eax)
  800f3d:	74 33                	je     800f72 <dev_lookup+0x4a>
  800f3f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f42:	8b 02                	mov    (%edx),%eax
  800f44:	85 c0                	test   %eax,%eax
  800f46:	75 f3                	jne    800f3b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f48:	a1 08 40 80 00       	mov    0x804008,%eax
  800f4d:	8b 40 48             	mov    0x48(%eax),%eax
  800f50:	83 ec 04             	sub    $0x4,%esp
  800f53:	51                   	push   %ecx
  800f54:	50                   	push   %eax
  800f55:	68 ec 2c 80 00       	push   $0x802cec
  800f5a:	e8 57 f2 ff ff       	call   8001b6 <cprintf>
	*dev = 0;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f68:	83 c4 10             	add    $0x10,%esp
  800f6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    
			*dev = devtab[i];
  800f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f75:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7c:	eb f2                	jmp    800f70 <dev_lookup+0x48>

00800f7e <fd_close>:
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
  800f84:	83 ec 1c             	sub    $0x1c,%esp
  800f87:	8b 75 08             	mov    0x8(%ebp),%esi
  800f8a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f8d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f90:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f91:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f97:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f9a:	50                   	push   %eax
  800f9b:	e8 32 ff ff ff       	call   800ed2 <fd_lookup>
  800fa0:	89 c3                	mov    %eax,%ebx
  800fa2:	83 c4 08             	add    $0x8,%esp
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	78 05                	js     800fae <fd_close+0x30>
	    || fd != fd2)
  800fa9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fac:	74 16                	je     800fc4 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fae:	89 f8                	mov    %edi,%eax
  800fb0:	84 c0                	test   %al,%al
  800fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb7:	0f 44 d8             	cmove  %eax,%ebx
}
  800fba:	89 d8                	mov    %ebx,%eax
  800fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fca:	50                   	push   %eax
  800fcb:	ff 36                	pushl  (%esi)
  800fcd:	e8 56 ff ff ff       	call   800f28 <dev_lookup>
  800fd2:	89 c3                	mov    %eax,%ebx
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	78 15                	js     800ff0 <fd_close+0x72>
		if (dev->dev_close)
  800fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fde:	8b 40 10             	mov    0x10(%eax),%eax
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	74 1b                	je     801000 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	56                   	push   %esi
  800fe9:	ff d0                	call   *%eax
  800feb:	89 c3                	mov    %eax,%ebx
  800fed:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	56                   	push   %esi
  800ff4:	6a 00                	push   $0x0
  800ff6:	e8 d6 fc ff ff       	call   800cd1 <sys_page_unmap>
	return r;
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	eb ba                	jmp    800fba <fd_close+0x3c>
			r = 0;
  801000:	bb 00 00 00 00       	mov    $0x0,%ebx
  801005:	eb e9                	jmp    800ff0 <fd_close+0x72>

00801007 <close>:

int
close(int fdnum)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80100d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801010:	50                   	push   %eax
  801011:	ff 75 08             	pushl  0x8(%ebp)
  801014:	e8 b9 fe ff ff       	call   800ed2 <fd_lookup>
  801019:	83 c4 08             	add    $0x8,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	78 10                	js     801030 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	6a 01                	push   $0x1
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	e8 51 ff ff ff       	call   800f7e <fd_close>
  80102d:	83 c4 10             	add    $0x10,%esp
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <close_all>:

void
close_all(void)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	53                   	push   %ebx
  801036:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801039:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	53                   	push   %ebx
  801042:	e8 c0 ff ff ff       	call   801007 <close>
	for (i = 0; i < MAXFD; i++)
  801047:	83 c3 01             	add    $0x1,%ebx
  80104a:	83 c4 10             	add    $0x10,%esp
  80104d:	83 fb 20             	cmp    $0x20,%ebx
  801050:	75 ec                	jne    80103e <close_all+0xc>
}
  801052:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801060:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801063:	50                   	push   %eax
  801064:	ff 75 08             	pushl  0x8(%ebp)
  801067:	e8 66 fe ff ff       	call   800ed2 <fd_lookup>
  80106c:	89 c3                	mov    %eax,%ebx
  80106e:	83 c4 08             	add    $0x8,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	0f 88 81 00 00 00    	js     8010fa <dup+0xa3>
		return r;
	close(newfdnum);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	e8 83 ff ff ff       	call   801007 <close>

	newfd = INDEX2FD(newfdnum);
  801084:	8b 75 0c             	mov    0xc(%ebp),%esi
  801087:	c1 e6 0c             	shl    $0xc,%esi
  80108a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801090:	83 c4 04             	add    $0x4,%esp
  801093:	ff 75 e4             	pushl  -0x1c(%ebp)
  801096:	e8 d1 fd ff ff       	call   800e6c <fd2data>
  80109b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80109d:	89 34 24             	mov    %esi,(%esp)
  8010a0:	e8 c7 fd ff ff       	call   800e6c <fd2data>
  8010a5:	83 c4 10             	add    $0x10,%esp
  8010a8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010aa:	89 d8                	mov    %ebx,%eax
  8010ac:	c1 e8 16             	shr    $0x16,%eax
  8010af:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010b6:	a8 01                	test   $0x1,%al
  8010b8:	74 11                	je     8010cb <dup+0x74>
  8010ba:	89 d8                	mov    %ebx,%eax
  8010bc:	c1 e8 0c             	shr    $0xc,%eax
  8010bf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010c6:	f6 c2 01             	test   $0x1,%dl
  8010c9:	75 39                	jne    801104 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010ce:	89 d0                	mov    %edx,%eax
  8010d0:	c1 e8 0c             	shr    $0xc,%eax
  8010d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8010e2:	50                   	push   %eax
  8010e3:	56                   	push   %esi
  8010e4:	6a 00                	push   $0x0
  8010e6:	52                   	push   %edx
  8010e7:	6a 00                	push   $0x0
  8010e9:	e8 a1 fb ff ff       	call   800c8f <sys_page_map>
  8010ee:	89 c3                	mov    %eax,%ebx
  8010f0:	83 c4 20             	add    $0x20,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 31                	js     801128 <dup+0xd1>
		goto err;

	return newfdnum;
  8010f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010fa:	89 d8                	mov    %ebx,%eax
  8010fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ff:	5b                   	pop    %ebx
  801100:	5e                   	pop    %esi
  801101:	5f                   	pop    %edi
  801102:	5d                   	pop    %ebp
  801103:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801104:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	25 07 0e 00 00       	and    $0xe07,%eax
  801113:	50                   	push   %eax
  801114:	57                   	push   %edi
  801115:	6a 00                	push   $0x0
  801117:	53                   	push   %ebx
  801118:	6a 00                	push   $0x0
  80111a:	e8 70 fb ff ff       	call   800c8f <sys_page_map>
  80111f:	89 c3                	mov    %eax,%ebx
  801121:	83 c4 20             	add    $0x20,%esp
  801124:	85 c0                	test   %eax,%eax
  801126:	79 a3                	jns    8010cb <dup+0x74>
	sys_page_unmap(0, newfd);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	56                   	push   %esi
  80112c:	6a 00                	push   $0x0
  80112e:	e8 9e fb ff ff       	call   800cd1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801133:	83 c4 08             	add    $0x8,%esp
  801136:	57                   	push   %edi
  801137:	6a 00                	push   $0x0
  801139:	e8 93 fb ff ff       	call   800cd1 <sys_page_unmap>
	return r;
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	eb b7                	jmp    8010fa <dup+0xa3>

00801143 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	53                   	push   %ebx
  801147:	83 ec 14             	sub    $0x14,%esp
  80114a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80114d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801150:	50                   	push   %eax
  801151:	53                   	push   %ebx
  801152:	e8 7b fd ff ff       	call   800ed2 <fd_lookup>
  801157:	83 c4 08             	add    $0x8,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	78 3f                	js     80119d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801164:	50                   	push   %eax
  801165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801168:	ff 30                	pushl  (%eax)
  80116a:	e8 b9 fd ff ff       	call   800f28 <dev_lookup>
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	78 27                	js     80119d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801176:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801179:	8b 42 08             	mov    0x8(%edx),%eax
  80117c:	83 e0 03             	and    $0x3,%eax
  80117f:	83 f8 01             	cmp    $0x1,%eax
  801182:	74 1e                	je     8011a2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801187:	8b 40 08             	mov    0x8(%eax),%eax
  80118a:	85 c0                	test   %eax,%eax
  80118c:	74 35                	je     8011c3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80118e:	83 ec 04             	sub    $0x4,%esp
  801191:	ff 75 10             	pushl  0x10(%ebp)
  801194:	ff 75 0c             	pushl  0xc(%ebp)
  801197:	52                   	push   %edx
  801198:	ff d0                	call   *%eax
  80119a:	83 c4 10             	add    $0x10,%esp
}
  80119d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8011a7:	8b 40 48             	mov    0x48(%eax),%eax
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	53                   	push   %ebx
  8011ae:	50                   	push   %eax
  8011af:	68 2d 2d 80 00       	push   $0x802d2d
  8011b4:	e8 fd ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c1:	eb da                	jmp    80119d <read+0x5a>
		return -E_NOT_SUPP;
  8011c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c8:	eb d3                	jmp    80119d <read+0x5a>

008011ca <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	57                   	push   %edi
  8011ce:	56                   	push   %esi
  8011cf:	53                   	push   %ebx
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011d6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011de:	39 f3                	cmp    %esi,%ebx
  8011e0:	73 25                	jae    801207 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011e2:	83 ec 04             	sub    $0x4,%esp
  8011e5:	89 f0                	mov    %esi,%eax
  8011e7:	29 d8                	sub    %ebx,%eax
  8011e9:	50                   	push   %eax
  8011ea:	89 d8                	mov    %ebx,%eax
  8011ec:	03 45 0c             	add    0xc(%ebp),%eax
  8011ef:	50                   	push   %eax
  8011f0:	57                   	push   %edi
  8011f1:	e8 4d ff ff ff       	call   801143 <read>
		if (m < 0)
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 08                	js     801205 <readn+0x3b>
			return m;
		if (m == 0)
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	74 06                	je     801207 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801201:	01 c3                	add    %eax,%ebx
  801203:	eb d9                	jmp    8011de <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801205:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801207:	89 d8                	mov    %ebx,%eax
  801209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	53                   	push   %ebx
  801215:	83 ec 14             	sub    $0x14,%esp
  801218:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80121b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80121e:	50                   	push   %eax
  80121f:	53                   	push   %ebx
  801220:	e8 ad fc ff ff       	call   800ed2 <fd_lookup>
  801225:	83 c4 08             	add    $0x8,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 3a                	js     801266 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801232:	50                   	push   %eax
  801233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801236:	ff 30                	pushl  (%eax)
  801238:	e8 eb fc ff ff       	call   800f28 <dev_lookup>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	85 c0                	test   %eax,%eax
  801242:	78 22                	js     801266 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801247:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80124b:	74 1e                	je     80126b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801250:	8b 52 0c             	mov    0xc(%edx),%edx
  801253:	85 d2                	test   %edx,%edx
  801255:	74 35                	je     80128c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	ff 75 10             	pushl  0x10(%ebp)
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	50                   	push   %eax
  801261:	ff d2                	call   *%edx
  801263:	83 c4 10             	add    $0x10,%esp
}
  801266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801269:	c9                   	leave  
  80126a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80126b:	a1 08 40 80 00       	mov    0x804008,%eax
  801270:	8b 40 48             	mov    0x48(%eax),%eax
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	53                   	push   %ebx
  801277:	50                   	push   %eax
  801278:	68 49 2d 80 00       	push   $0x802d49
  80127d:	e8 34 ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128a:	eb da                	jmp    801266 <write+0x55>
		return -E_NOT_SUPP;
  80128c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801291:	eb d3                	jmp    801266 <write+0x55>

00801293 <seek>:

int
seek(int fdnum, off_t offset)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801299:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 2d fc ff ff       	call   800ed2 <fd_lookup>
  8012a5:	83 c4 08             	add    $0x8,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 0e                	js     8012ba <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	53                   	push   %ebx
  8012c0:	83 ec 14             	sub    $0x14,%esp
  8012c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	53                   	push   %ebx
  8012cb:	e8 02 fc ff ff       	call   800ed2 <fd_lookup>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 37                	js     80130e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012dd:	50                   	push   %eax
  8012de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e1:	ff 30                	pushl  (%eax)
  8012e3:	e8 40 fc ff ff       	call   800f28 <dev_lookup>
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 1f                	js     80130e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012f6:	74 1b                	je     801313 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fb:	8b 52 18             	mov    0x18(%edx),%edx
  8012fe:	85 d2                	test   %edx,%edx
  801300:	74 32                	je     801334 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	50                   	push   %eax
  801309:	ff d2                	call   *%edx
  80130b:	83 c4 10             	add    $0x10,%esp
}
  80130e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801311:	c9                   	leave  
  801312:	c3                   	ret    
			thisenv->env_id, fdnum);
  801313:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801318:	8b 40 48             	mov    0x48(%eax),%eax
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	53                   	push   %ebx
  80131f:	50                   	push   %eax
  801320:	68 0c 2d 80 00       	push   $0x802d0c
  801325:	e8 8c ee ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801332:	eb da                	jmp    80130e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801334:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801339:	eb d3                	jmp    80130e <ftruncate+0x52>

0080133b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	53                   	push   %ebx
  80133f:	83 ec 14             	sub    $0x14,%esp
  801342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801345:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 81 fb ff ff       	call   800ed2 <fd_lookup>
  801351:	83 c4 08             	add    $0x8,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 4b                	js     8013a3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801362:	ff 30                	pushl  (%eax)
  801364:	e8 bf fb ff ff       	call   800f28 <dev_lookup>
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	78 33                	js     8013a3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801373:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801377:	74 2f                	je     8013a8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801379:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80137c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801383:	00 00 00 
	stat->st_isdir = 0;
  801386:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80138d:	00 00 00 
	stat->st_dev = dev;
  801390:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	53                   	push   %ebx
  80139a:	ff 75 f0             	pushl  -0x10(%ebp)
  80139d:	ff 50 14             	call   *0x14(%eax)
  8013a0:	83 c4 10             	add    $0x10,%esp
}
  8013a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    
		return -E_NOT_SUPP;
  8013a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ad:	eb f4                	jmp    8013a3 <fstat+0x68>

008013af <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	56                   	push   %esi
  8013b3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	6a 00                	push   $0x0
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	e8 26 02 00 00       	call   8015e7 <open>
  8013c1:	89 c3                	mov    %eax,%ebx
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 1b                	js     8013e5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	ff 75 0c             	pushl  0xc(%ebp)
  8013d0:	50                   	push   %eax
  8013d1:	e8 65 ff ff ff       	call   80133b <fstat>
  8013d6:	89 c6                	mov    %eax,%esi
	close(fd);
  8013d8:	89 1c 24             	mov    %ebx,(%esp)
  8013db:	e8 27 fc ff ff       	call   801007 <close>
	return r;
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 f3                	mov    %esi,%ebx
}
  8013e5:	89 d8                	mov    %ebx,%eax
  8013e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ea:	5b                   	pop    %ebx
  8013eb:	5e                   	pop    %esi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	56                   	push   %esi
  8013f2:	53                   	push   %ebx
  8013f3:	89 c6                	mov    %eax,%esi
  8013f5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013f7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013fe:	74 27                	je     801427 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801400:	6a 07                	push   $0x7
  801402:	68 00 50 80 00       	push   $0x805000
  801407:	56                   	push   %esi
  801408:	ff 35 00 40 80 00    	pushl  0x804000
  80140e:	e8 06 12 00 00       	call   802619 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801413:	83 c4 0c             	add    $0xc,%esp
  801416:	6a 00                	push   $0x0
  801418:	53                   	push   %ebx
  801419:	6a 00                	push   $0x0
  80141b:	e8 90 11 00 00       	call   8025b0 <ipc_recv>
}
  801420:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801423:	5b                   	pop    %ebx
  801424:	5e                   	pop    %esi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801427:	83 ec 0c             	sub    $0xc,%esp
  80142a:	6a 01                	push   $0x1
  80142c:	e8 41 12 00 00       	call   802672 <ipc_find_env>
  801431:	a3 00 40 80 00       	mov    %eax,0x804000
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	eb c5                	jmp    801400 <fsipc+0x12>

0080143b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8b 40 0c             	mov    0xc(%eax),%eax
  801447:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801454:	ba 00 00 00 00       	mov    $0x0,%edx
  801459:	b8 02 00 00 00       	mov    $0x2,%eax
  80145e:	e8 8b ff ff ff       	call   8013ee <fsipc>
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <devfile_flush>:
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8b 40 0c             	mov    0xc(%eax),%eax
  801471:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801476:	ba 00 00 00 00       	mov    $0x0,%edx
  80147b:	b8 06 00 00 00       	mov    $0x6,%eax
  801480:	e8 69 ff ff ff       	call   8013ee <fsipc>
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <devfile_stat>:
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	53                   	push   %ebx
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8b 40 0c             	mov    0xc(%eax),%eax
  801497:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80149c:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a1:	b8 05 00 00 00       	mov    $0x5,%eax
  8014a6:	e8 43 ff ff ff       	call   8013ee <fsipc>
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 2c                	js     8014db <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	68 00 50 80 00       	push   $0x805000
  8014b7:	53                   	push   %ebx
  8014b8:	e8 96 f3 ff ff       	call   800853 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014bd:	a1 80 50 80 00       	mov    0x805080,%eax
  8014c2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014c8:	a1 84 50 80 00       	mov    0x805084,%eax
  8014cd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <devfile_write>:
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014f5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014fb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801501:	77 30                	ja     801533 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	53                   	push   %ebx
  801507:	ff 75 0c             	pushl  0xc(%ebp)
  80150a:	68 08 50 80 00       	push   $0x805008
  80150f:	e8 cd f4 ff ff       	call   8009e1 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801514:	ba 00 00 00 00       	mov    $0x0,%edx
  801519:	b8 04 00 00 00       	mov    $0x4,%eax
  80151e:	e8 cb fe ff ff       	call   8013ee <fsipc>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 04                	js     80152e <devfile_write+0x4e>
	assert(r <= n);
  80152a:	39 d8                	cmp    %ebx,%eax
  80152c:	77 1e                	ja     80154c <devfile_write+0x6c>
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801533:	68 7c 2d 80 00       	push   $0x802d7c
  801538:	68 a9 2d 80 00       	push   $0x802da9
  80153d:	68 94 00 00 00       	push   $0x94
  801542:	68 be 2d 80 00       	push   $0x802dbe
  801547:	e8 8f eb ff ff       	call   8000db <_panic>
	assert(r <= n);
  80154c:	68 c9 2d 80 00       	push   $0x802dc9
  801551:	68 a9 2d 80 00       	push   $0x802da9
  801556:	68 98 00 00 00       	push   $0x98
  80155b:	68 be 2d 80 00       	push   $0x802dbe
  801560:	e8 76 eb ff ff       	call   8000db <_panic>

00801565 <devfile_read>:
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
  80156a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8b 40 0c             	mov    0xc(%eax),%eax
  801573:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801578:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80157e:	ba 00 00 00 00       	mov    $0x0,%edx
  801583:	b8 03 00 00 00       	mov    $0x3,%eax
  801588:	e8 61 fe ff ff       	call   8013ee <fsipc>
  80158d:	89 c3                	mov    %eax,%ebx
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 1f                	js     8015b2 <devfile_read+0x4d>
	assert(r <= n);
  801593:	39 f0                	cmp    %esi,%eax
  801595:	77 24                	ja     8015bb <devfile_read+0x56>
	assert(r <= PGSIZE);
  801597:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80159c:	7f 33                	jg     8015d1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	50                   	push   %eax
  8015a2:	68 00 50 80 00       	push   $0x805000
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	e8 32 f4 ff ff       	call   8009e1 <memmove>
	return r;
  8015af:	83 c4 10             	add    $0x10,%esp
}
  8015b2:	89 d8                	mov    %ebx,%eax
  8015b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    
	assert(r <= n);
  8015bb:	68 c9 2d 80 00       	push   $0x802dc9
  8015c0:	68 a9 2d 80 00       	push   $0x802da9
  8015c5:	6a 7c                	push   $0x7c
  8015c7:	68 be 2d 80 00       	push   $0x802dbe
  8015cc:	e8 0a eb ff ff       	call   8000db <_panic>
	assert(r <= PGSIZE);
  8015d1:	68 d0 2d 80 00       	push   $0x802dd0
  8015d6:	68 a9 2d 80 00       	push   $0x802da9
  8015db:	6a 7d                	push   $0x7d
  8015dd:	68 be 2d 80 00       	push   $0x802dbe
  8015e2:	e8 f4 ea ff ff       	call   8000db <_panic>

008015e7 <open>:
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	56                   	push   %esi
  8015eb:	53                   	push   %ebx
  8015ec:	83 ec 1c             	sub    $0x1c,%esp
  8015ef:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015f2:	56                   	push   %esi
  8015f3:	e8 24 f2 ff ff       	call   80081c <strlen>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801600:	7f 6c                	jg     80166e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801602:	83 ec 0c             	sub    $0xc,%esp
  801605:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801608:	50                   	push   %eax
  801609:	e8 75 f8 ff ff       	call   800e83 <fd_alloc>
  80160e:	89 c3                	mov    %eax,%ebx
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	85 c0                	test   %eax,%eax
  801615:	78 3c                	js     801653 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801617:	83 ec 08             	sub    $0x8,%esp
  80161a:	56                   	push   %esi
  80161b:	68 00 50 80 00       	push   $0x805000
  801620:	e8 2e f2 ff ff       	call   800853 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801625:	8b 45 0c             	mov    0xc(%ebp),%eax
  801628:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80162d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801630:	b8 01 00 00 00       	mov    $0x1,%eax
  801635:	e8 b4 fd ff ff       	call   8013ee <fsipc>
  80163a:	89 c3                	mov    %eax,%ebx
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	85 c0                	test   %eax,%eax
  801641:	78 19                	js     80165c <open+0x75>
	return fd2num(fd);
  801643:	83 ec 0c             	sub    $0xc,%esp
  801646:	ff 75 f4             	pushl  -0xc(%ebp)
  801649:	e8 0e f8 ff ff       	call   800e5c <fd2num>
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	83 c4 10             	add    $0x10,%esp
}
  801653:	89 d8                	mov    %ebx,%eax
  801655:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801658:	5b                   	pop    %ebx
  801659:	5e                   	pop    %esi
  80165a:	5d                   	pop    %ebp
  80165b:	c3                   	ret    
		fd_close(fd, 0);
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	6a 00                	push   $0x0
  801661:	ff 75 f4             	pushl  -0xc(%ebp)
  801664:	e8 15 f9 ff ff       	call   800f7e <fd_close>
		return r;
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	eb e5                	jmp    801653 <open+0x6c>
		return -E_BAD_PATH;
  80166e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801673:	eb de                	jmp    801653 <open+0x6c>

00801675 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	b8 08 00 00 00       	mov    $0x8,%eax
  801685:	e8 64 fd ff ff       	call   8013ee <fsipc>
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	57                   	push   %edi
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
  801692:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 08             	pushl  0x8(%ebp)
  80169d:	e8 45 ff ff ff       	call   8015e7 <open>
  8016a2:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	0f 88 40 03 00 00    	js     8019f3 <spawn+0x367>
  8016b3:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 00 02 00 00       	push   $0x200
  8016bd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016c3:	50                   	push   %eax
  8016c4:	52                   	push   %edx
  8016c5:	e8 00 fb ff ff       	call   8011ca <readn>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016d2:	75 5d                	jne    801731 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8016d4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016db:	45 4c 46 
  8016de:	75 51                	jne    801731 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016e0:	b8 07 00 00 00       	mov    $0x7,%eax
  8016e5:	cd 30                	int    $0x30
  8016e7:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8016ed:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	0f 88 b6 04 00 00    	js     801bb1 <spawn+0x525>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8016fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801700:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801703:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801709:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80170f:	b9 11 00 00 00       	mov    $0x11,%ecx
  801714:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801716:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80171c:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801722:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801727:	be 00 00 00 00       	mov    $0x0,%esi
  80172c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80172f:	eb 4b                	jmp    80177c <spawn+0xf0>
		close(fd);
  801731:	83 ec 0c             	sub    $0xc,%esp
  801734:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80173a:	e8 c8 f8 ff ff       	call   801007 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80173f:	83 c4 0c             	add    $0xc,%esp
  801742:	68 7f 45 4c 46       	push   $0x464c457f
  801747:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80174d:	68 dc 2d 80 00       	push   $0x802ddc
  801752:	e8 5f ea ff ff       	call   8001b6 <cprintf>
		return -E_NOT_EXEC;
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801761:	ff ff ff 
  801764:	e9 8a 02 00 00       	jmp    8019f3 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801769:	83 ec 0c             	sub    $0xc,%esp
  80176c:	50                   	push   %eax
  80176d:	e8 aa f0 ff ff       	call   80081c <strlen>
  801772:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801776:	83 c3 01             	add    $0x1,%ebx
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801783:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801786:	85 c0                	test   %eax,%eax
  801788:	75 df                	jne    801769 <spawn+0xdd>
  80178a:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801790:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801796:	bf 00 10 40 00       	mov    $0x401000,%edi
  80179b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80179d:	89 fa                	mov    %edi,%edx
  80179f:	83 e2 fc             	and    $0xfffffffc,%edx
  8017a2:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8017a9:	29 c2                	sub    %eax,%edx
  8017ab:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8017b1:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017b4:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017b9:	0f 86 03 04 00 00    	jbe    801bc2 <spawn+0x536>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	6a 07                	push   $0x7
  8017c4:	68 00 00 40 00       	push   $0x400000
  8017c9:	6a 00                	push   $0x0
  8017cb:	e8 7c f4 ff ff       	call   800c4c <sys_page_alloc>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	0f 88 ec 03 00 00    	js     801bc7 <spawn+0x53b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8017db:	be 00 00 00 00       	mov    $0x0,%esi
  8017e0:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8017e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017e9:	eb 30                	jmp    80181b <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  8017eb:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8017f1:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8017f7:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  8017fa:	83 ec 08             	sub    $0x8,%esp
  8017fd:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801800:	57                   	push   %edi
  801801:	e8 4d f0 ff ff       	call   800853 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801806:	83 c4 04             	add    $0x4,%esp
  801809:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80180c:	e8 0b f0 ff ff       	call   80081c <strlen>
  801811:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801815:	83 c6 01             	add    $0x1,%esi
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801821:	7f c8                	jg     8017eb <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801823:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801829:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80182f:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801836:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80183c:	0f 85 8c 00 00 00    	jne    8018ce <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801842:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801848:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80184e:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801851:	89 f8                	mov    %edi,%eax
  801853:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801859:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80185c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801861:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	6a 07                	push   $0x7
  80186c:	68 00 d0 bf ee       	push   $0xeebfd000
  801871:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801877:	68 00 00 40 00       	push   $0x400000
  80187c:	6a 00                	push   $0x0
  80187e:	e8 0c f4 ff ff       	call   800c8f <sys_page_map>
  801883:	89 c3                	mov    %eax,%ebx
  801885:	83 c4 20             	add    $0x20,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	0f 88 57 03 00 00    	js     801be7 <spawn+0x55b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	68 00 00 40 00       	push   $0x400000
  801898:	6a 00                	push   $0x0
  80189a:	e8 32 f4 ff ff       	call   800cd1 <sys_page_unmap>
  80189f:	89 c3                	mov    %eax,%ebx
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	0f 88 3b 03 00 00    	js     801be7 <spawn+0x55b>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8018ac:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018b2:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8018b9:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018bf:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8018c6:	00 00 00 
  8018c9:	e9 56 01 00 00       	jmp    801a24 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018ce:	68 68 2e 80 00       	push   $0x802e68
  8018d3:	68 a9 2d 80 00       	push   $0x802da9
  8018d8:	68 f2 00 00 00       	push   $0xf2
  8018dd:	68 f6 2d 80 00       	push   $0x802df6
  8018e2:	e8 f4 e7 ff ff       	call   8000db <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	6a 07                	push   $0x7
  8018ec:	68 00 00 40 00       	push   $0x400000
  8018f1:	6a 00                	push   $0x0
  8018f3:	e8 54 f3 ff ff       	call   800c4c <sys_page_alloc>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	0f 88 cf 02 00 00    	js     801bd2 <spawn+0x546>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80190c:	01 f0                	add    %esi,%eax
  80190e:	50                   	push   %eax
  80190f:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801915:	e8 79 f9 ff ff       	call   801293 <seek>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	0f 88 b4 02 00 00    	js     801bd9 <spawn+0x54d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80192e:	29 f0                	sub    %esi,%eax
  801930:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801935:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80193a:	0f 47 c1             	cmova  %ecx,%eax
  80193d:	50                   	push   %eax
  80193e:	68 00 00 40 00       	push   $0x400000
  801943:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801949:	e8 7c f8 ff ff       	call   8011ca <readn>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	0f 88 87 02 00 00    	js     801be0 <spawn+0x554>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801959:	83 ec 0c             	sub    $0xc,%esp
  80195c:	57                   	push   %edi
  80195d:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801963:	56                   	push   %esi
  801964:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80196a:	68 00 00 40 00       	push   $0x400000
  80196f:	6a 00                	push   $0x0
  801971:	e8 19 f3 ff ff       	call   800c8f <sys_page_map>
  801976:	83 c4 20             	add    $0x20,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	0f 88 80 00 00 00    	js     801a01 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	68 00 00 40 00       	push   $0x400000
  801989:	6a 00                	push   $0x0
  80198b:	e8 41 f3 ff ff       	call   800cd1 <sys_page_unmap>
  801990:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801993:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801999:	89 de                	mov    %ebx,%esi
  80199b:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8019a1:	76 73                	jbe    801a16 <spawn+0x38a>
		if (i >= filesz) {
  8019a3:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8019a9:	0f 87 38 ff ff ff    	ja     8018e7 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	57                   	push   %edi
  8019b3:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8019b9:	56                   	push   %esi
  8019ba:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8019c0:	e8 87 f2 ff ff       	call   800c4c <sys_page_alloc>
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	79 c7                	jns    801993 <spawn+0x307>
  8019cc:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8019ce:	83 ec 0c             	sub    $0xc,%esp
  8019d1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019d7:	e8 f1 f1 ff ff       	call   800bcd <sys_env_destroy>
	close(fd);
  8019dc:	83 c4 04             	add    $0x4,%esp
  8019df:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8019e5:	e8 1d f6 ff ff       	call   801007 <close>
	return r;
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  8019f3:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019fc:	5b                   	pop    %ebx
  8019fd:	5e                   	pop    %esi
  8019fe:	5f                   	pop    %edi
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801a01:	50                   	push   %eax
  801a02:	68 02 2e 80 00       	push   $0x802e02
  801a07:	68 25 01 00 00       	push   $0x125
  801a0c:	68 f6 2d 80 00       	push   $0x802df6
  801a11:	e8 c5 e6 ff ff       	call   8000db <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a16:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801a1d:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801a24:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a2b:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801a31:	7e 71                	jle    801aa4 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801a33:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801a39:	83 39 01             	cmpl   $0x1,(%ecx)
  801a3c:	75 d8                	jne    801a16 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a3e:	8b 41 18             	mov    0x18(%ecx),%eax
  801a41:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a44:	83 f8 01             	cmp    $0x1,%eax
  801a47:	19 ff                	sbb    %edi,%edi
  801a49:	83 e7 fe             	and    $0xfffffffe,%edi
  801a4c:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a4f:	8b 71 04             	mov    0x4(%ecx),%esi
  801a52:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801a58:	8b 59 10             	mov    0x10(%ecx),%ebx
  801a5b:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801a61:	8b 41 14             	mov    0x14(%ecx),%eax
  801a64:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801a6a:	8b 51 08             	mov    0x8(%ecx),%edx
  801a6d:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801a73:	89 d0                	mov    %edx,%eax
  801a75:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a7a:	74 1e                	je     801a9a <spawn+0x40e>
		va -= i;
  801a7c:	29 c2                	sub    %eax,%edx
  801a7e:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801a84:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801a8a:	01 c3                	add    %eax,%ebx
  801a8c:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801a92:	29 c6                	sub    %eax,%esi
  801a94:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801a9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a9f:	e9 f5 fe ff ff       	jmp    801999 <spawn+0x30d>
	close(fd);
  801aa4:	83 ec 0c             	sub    $0xc,%esp
  801aa7:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801aad:	e8 55 f5 ff ff       	call   801007 <close>
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	envid_t parent_envid = sys_getenvid();
  801ab2:	e8 57 f1 ff ff       	call   800c0e <sys_getenvid>
  801ab7:	89 c6                	mov    %eax,%esi
  801ab9:	83 c4 10             	add    $0x10,%esp
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801abc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac1:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801ac7:	eb 0e                	jmp    801ad7 <spawn+0x44b>
  801ac9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801acf:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801ad5:	74 62                	je     801b39 <spawn+0x4ad>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_SHARE) == PTE_SHARE) {
  801ad7:	89 d8                	mov    %ebx,%eax
  801ad9:	c1 e8 16             	shr    $0x16,%eax
  801adc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ae3:	a8 01                	test   $0x1,%al
  801ae5:	74 e2                	je     801ac9 <spawn+0x43d>
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	c1 e8 0c             	shr    $0xc,%eax
  801aec:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801af3:	f6 c2 01             	test   $0x1,%dl
  801af6:	74 d1                	je     801ac9 <spawn+0x43d>
  801af8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801aff:	f6 c6 04             	test   $0x4,%dh
  801b02:	74 c5                	je     801ac9 <spawn+0x43d>
	        if ((r = sys_page_map(parent_envid, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) != 0) {
  801b04:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	25 07 0e 00 00       	and    $0xe07,%eax
  801b13:	50                   	push   %eax
  801b14:	53                   	push   %ebx
  801b15:	57                   	push   %edi
  801b16:	53                   	push   %ebx
  801b17:	56                   	push   %esi
  801b18:	e8 72 f1 ff ff       	call   800c8f <sys_page_map>
  801b1d:	83 c4 20             	add    $0x20,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	74 a5                	je     801ac9 <spawn+0x43d>
	            panic("copy_shared_pages: %e", r);
  801b24:	50                   	push   %eax
  801b25:	68 1f 2e 80 00       	push   $0x802e1f
  801b2a:	68 38 01 00 00       	push   $0x138
  801b2f:	68 f6 2d 80 00       	push   $0x802df6
  801b34:	e8 a2 e5 ff ff       	call   8000db <_panic>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801b39:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b40:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801b4c:	50                   	push   %eax
  801b4d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b53:	e8 fd f1 ff ff       	call   800d55 <sys_env_set_trapframe>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 28                	js     801b87 <spawn+0x4fb>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b5f:	83 ec 08             	sub    $0x8,%esp
  801b62:	6a 02                	push   $0x2
  801b64:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b6a:	e8 a4 f1 ff ff       	call   800d13 <sys_env_set_status>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 26                	js     801b9c <spawn+0x510>
	return child;
  801b76:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b7c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b82:	e9 6c fe ff ff       	jmp    8019f3 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801b87:	50                   	push   %eax
  801b88:	68 35 2e 80 00       	push   $0x802e35
  801b8d:	68 86 00 00 00       	push   $0x86
  801b92:	68 f6 2d 80 00       	push   $0x802df6
  801b97:	e8 3f e5 ff ff       	call   8000db <_panic>
		panic("sys_env_set_status: %e", r);
  801b9c:	50                   	push   %eax
  801b9d:	68 4f 2e 80 00       	push   $0x802e4f
  801ba2:	68 89 00 00 00       	push   $0x89
  801ba7:	68 f6 2d 80 00       	push   $0x802df6
  801bac:	e8 2a e5 ff ff       	call   8000db <_panic>
		return r;
  801bb1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bb7:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801bbd:	e9 31 fe ff ff       	jmp    8019f3 <spawn+0x367>
		return -E_NO_MEM;
  801bc2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801bc7:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801bcd:	e9 21 fe ff ff       	jmp    8019f3 <spawn+0x367>
  801bd2:	89 c7                	mov    %eax,%edi
  801bd4:	e9 f5 fd ff ff       	jmp    8019ce <spawn+0x342>
  801bd9:	89 c7                	mov    %eax,%edi
  801bdb:	e9 ee fd ff ff       	jmp    8019ce <spawn+0x342>
  801be0:	89 c7                	mov    %eax,%edi
  801be2:	e9 e7 fd ff ff       	jmp    8019ce <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	68 00 00 40 00       	push   $0x400000
  801bef:	6a 00                	push   $0x0
  801bf1:	e8 db f0 ff ff       	call   800cd1 <sys_page_unmap>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801bff:	e9 ef fd ff ff       	jmp    8019f3 <spawn+0x367>

00801c04 <spawnl>:
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	57                   	push   %edi
  801c08:	56                   	push   %esi
  801c09:	53                   	push   %ebx
  801c0a:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c0d:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c15:	eb 05                	jmp    801c1c <spawnl+0x18>
		argc++;
  801c17:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801c1a:	89 ca                	mov    %ecx,%edx
  801c1c:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c1f:	83 3a 00             	cmpl   $0x0,(%edx)
  801c22:	75 f3                	jne    801c17 <spawnl+0x13>
	const char *argv[argc+2];
  801c24:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801c2b:	83 e2 f0             	and    $0xfffffff0,%edx
  801c2e:	29 d4                	sub    %edx,%esp
  801c30:	8d 54 24 03          	lea    0x3(%esp),%edx
  801c34:	c1 ea 02             	shr    $0x2,%edx
  801c37:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801c3e:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c43:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c4a:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c51:	00 
	va_start(vl, arg0);
  801c52:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c55:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5c:	eb 0b                	jmp    801c69 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801c5e:	83 c0 01             	add    $0x1,%eax
  801c61:	8b 39                	mov    (%ecx),%edi
  801c63:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801c66:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801c69:	39 d0                	cmp    %edx,%eax
  801c6b:	75 f1                	jne    801c5e <spawnl+0x5a>
	return spawn(prog, argv);
  801c6d:	83 ec 08             	sub    $0x8,%esp
  801c70:	56                   	push   %esi
  801c71:	ff 75 08             	pushl  0x8(%ebp)
  801c74:	e8 13 fa ff ff       	call   80168c <spawn>
}
  801c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5f                   	pop    %edi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	56                   	push   %esi
  801c85:	53                   	push   %ebx
  801c86:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c89:	83 ec 0c             	sub    $0xc,%esp
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	e8 d8 f1 ff ff       	call   800e6c <fd2data>
  801c94:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c96:	83 c4 08             	add    $0x8,%esp
  801c99:	68 90 2e 80 00       	push   $0x802e90
  801c9e:	53                   	push   %ebx
  801c9f:	e8 af eb ff ff       	call   800853 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ca4:	8b 46 04             	mov    0x4(%esi),%eax
  801ca7:	2b 06                	sub    (%esi),%eax
  801ca9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801caf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cb6:	00 00 00 
	stat->st_dev = &devpipe;
  801cb9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cc0:	30 80 00 
	return 0;
}
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    

00801ccf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	53                   	push   %ebx
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cd9:	53                   	push   %ebx
  801cda:	6a 00                	push   $0x0
  801cdc:	e8 f0 ef ff ff       	call   800cd1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ce1:	89 1c 24             	mov    %ebx,(%esp)
  801ce4:	e8 83 f1 ff ff       	call   800e6c <fd2data>
  801ce9:	83 c4 08             	add    $0x8,%esp
  801cec:	50                   	push   %eax
  801ced:	6a 00                	push   $0x0
  801cef:	e8 dd ef ff ff       	call   800cd1 <sys_page_unmap>
}
  801cf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <_pipeisclosed>:
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	57                   	push   %edi
  801cfd:	56                   	push   %esi
  801cfe:	53                   	push   %ebx
  801cff:	83 ec 1c             	sub    $0x1c,%esp
  801d02:	89 c7                	mov    %eax,%edi
  801d04:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d06:	a1 08 40 80 00       	mov    0x804008,%eax
  801d0b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	57                   	push   %edi
  801d12:	e8 94 09 00 00       	call   8026ab <pageref>
  801d17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d1a:	89 34 24             	mov    %esi,(%esp)
  801d1d:	e8 89 09 00 00       	call   8026ab <pageref>
		nn = thisenv->env_runs;
  801d22:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d28:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	39 cb                	cmp    %ecx,%ebx
  801d30:	74 1b                	je     801d4d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d32:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d35:	75 cf                	jne    801d06 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d37:	8b 42 58             	mov    0x58(%edx),%eax
  801d3a:	6a 01                	push   $0x1
  801d3c:	50                   	push   %eax
  801d3d:	53                   	push   %ebx
  801d3e:	68 97 2e 80 00       	push   $0x802e97
  801d43:	e8 6e e4 ff ff       	call   8001b6 <cprintf>
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	eb b9                	jmp    801d06 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d4d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d50:	0f 94 c0             	sete   %al
  801d53:	0f b6 c0             	movzbl %al,%eax
}
  801d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d59:	5b                   	pop    %ebx
  801d5a:	5e                   	pop    %esi
  801d5b:	5f                   	pop    %edi
  801d5c:	5d                   	pop    %ebp
  801d5d:	c3                   	ret    

00801d5e <devpipe_write>:
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 28             	sub    $0x28,%esp
  801d67:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d6a:	56                   	push   %esi
  801d6b:	e8 fc f0 ff ff       	call   800e6c <fd2data>
  801d70:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d7d:	74 4f                	je     801dce <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d7f:	8b 43 04             	mov    0x4(%ebx),%eax
  801d82:	8b 0b                	mov    (%ebx),%ecx
  801d84:	8d 51 20             	lea    0x20(%ecx),%edx
  801d87:	39 d0                	cmp    %edx,%eax
  801d89:	72 14                	jb     801d9f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d8b:	89 da                	mov    %ebx,%edx
  801d8d:	89 f0                	mov    %esi,%eax
  801d8f:	e8 65 ff ff ff       	call   801cf9 <_pipeisclosed>
  801d94:	85 c0                	test   %eax,%eax
  801d96:	75 3a                	jne    801dd2 <devpipe_write+0x74>
			sys_yield();
  801d98:	e8 90 ee ff ff       	call   800c2d <sys_yield>
  801d9d:	eb e0                	jmp    801d7f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801da6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801da9:	89 c2                	mov    %eax,%edx
  801dab:	c1 fa 1f             	sar    $0x1f,%edx
  801dae:	89 d1                	mov    %edx,%ecx
  801db0:	c1 e9 1b             	shr    $0x1b,%ecx
  801db3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801db6:	83 e2 1f             	and    $0x1f,%edx
  801db9:	29 ca                	sub    %ecx,%edx
  801dbb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dbf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dc3:	83 c0 01             	add    $0x1,%eax
  801dc6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dc9:	83 c7 01             	add    $0x1,%edi
  801dcc:	eb ac                	jmp    801d7a <devpipe_write+0x1c>
	return i;
  801dce:	89 f8                	mov    %edi,%eax
  801dd0:	eb 05                	jmp    801dd7 <devpipe_write+0x79>
				return 0;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dda:	5b                   	pop    %ebx
  801ddb:	5e                   	pop    %esi
  801ddc:	5f                   	pop    %edi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <devpipe_read>:
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	57                   	push   %edi
  801de3:	56                   	push   %esi
  801de4:	53                   	push   %ebx
  801de5:	83 ec 18             	sub    $0x18,%esp
  801de8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801deb:	57                   	push   %edi
  801dec:	e8 7b f0 ff ff       	call   800e6c <fd2data>
  801df1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801df3:	83 c4 10             	add    $0x10,%esp
  801df6:	be 00 00 00 00       	mov    $0x0,%esi
  801dfb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dfe:	74 47                	je     801e47 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801e00:	8b 03                	mov    (%ebx),%eax
  801e02:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e05:	75 22                	jne    801e29 <devpipe_read+0x4a>
			if (i > 0)
  801e07:	85 f6                	test   %esi,%esi
  801e09:	75 14                	jne    801e1f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801e0b:	89 da                	mov    %ebx,%edx
  801e0d:	89 f8                	mov    %edi,%eax
  801e0f:	e8 e5 fe ff ff       	call   801cf9 <_pipeisclosed>
  801e14:	85 c0                	test   %eax,%eax
  801e16:	75 33                	jne    801e4b <devpipe_read+0x6c>
			sys_yield();
  801e18:	e8 10 ee ff ff       	call   800c2d <sys_yield>
  801e1d:	eb e1                	jmp    801e00 <devpipe_read+0x21>
				return i;
  801e1f:	89 f0                	mov    %esi,%eax
}
  801e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e24:	5b                   	pop    %ebx
  801e25:	5e                   	pop    %esi
  801e26:	5f                   	pop    %edi
  801e27:	5d                   	pop    %ebp
  801e28:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e29:	99                   	cltd   
  801e2a:	c1 ea 1b             	shr    $0x1b,%edx
  801e2d:	01 d0                	add    %edx,%eax
  801e2f:	83 e0 1f             	and    $0x1f,%eax
  801e32:	29 d0                	sub    %edx,%eax
  801e34:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e3c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e3f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e42:	83 c6 01             	add    $0x1,%esi
  801e45:	eb b4                	jmp    801dfb <devpipe_read+0x1c>
	return i;
  801e47:	89 f0                	mov    %esi,%eax
  801e49:	eb d6                	jmp    801e21 <devpipe_read+0x42>
				return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	eb cf                	jmp    801e21 <devpipe_read+0x42>

00801e52 <pipe>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	56                   	push   %esi
  801e56:	53                   	push   %ebx
  801e57:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5d:	50                   	push   %eax
  801e5e:	e8 20 f0 ff ff       	call   800e83 <fd_alloc>
  801e63:	89 c3                	mov    %eax,%ebx
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 5b                	js     801ec7 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 07 04 00 00       	push   $0x407
  801e74:	ff 75 f4             	pushl  -0xc(%ebp)
  801e77:	6a 00                	push   $0x0
  801e79:	e8 ce ed ff ff       	call   800c4c <sys_page_alloc>
  801e7e:	89 c3                	mov    %eax,%ebx
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	85 c0                	test   %eax,%eax
  801e85:	78 40                	js     801ec7 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e8d:	50                   	push   %eax
  801e8e:	e8 f0 ef ff ff       	call   800e83 <fd_alloc>
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	78 1b                	js     801eb7 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9c:	83 ec 04             	sub    $0x4,%esp
  801e9f:	68 07 04 00 00       	push   $0x407
  801ea4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 9e ed ff ff       	call   800c4c <sys_page_alloc>
  801eae:	89 c3                	mov    %eax,%ebx
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	79 19                	jns    801ed0 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801eb7:	83 ec 08             	sub    $0x8,%esp
  801eba:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebd:	6a 00                	push   $0x0
  801ebf:	e8 0d ee ff ff       	call   800cd1 <sys_page_unmap>
  801ec4:	83 c4 10             	add    $0x10,%esp
}
  801ec7:	89 d8                	mov    %ebx,%eax
  801ec9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ecc:	5b                   	pop    %ebx
  801ecd:	5e                   	pop    %esi
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    
	va = fd2data(fd0);
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed6:	e8 91 ef ff ff       	call   800e6c <fd2data>
  801edb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edd:	83 c4 0c             	add    $0xc,%esp
  801ee0:	68 07 04 00 00       	push   $0x407
  801ee5:	50                   	push   %eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	e8 5f ed ff ff       	call   800c4c <sys_page_alloc>
  801eed:	89 c3                	mov    %eax,%ebx
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	0f 88 8c 00 00 00    	js     801f86 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	ff 75 f0             	pushl  -0x10(%ebp)
  801f00:	e8 67 ef ff ff       	call   800e6c <fd2data>
  801f05:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f0c:	50                   	push   %eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	56                   	push   %esi
  801f10:	6a 00                	push   $0x0
  801f12:	e8 78 ed ff ff       	call   800c8f <sys_page_map>
  801f17:	89 c3                	mov    %eax,%ebx
  801f19:	83 c4 20             	add    $0x20,%esp
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 58                	js     801f78 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f29:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f38:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f3e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f50:	e8 07 ef ff ff       	call   800e5c <fd2num>
  801f55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f58:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f5a:	83 c4 04             	add    $0x4,%esp
  801f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f60:	e8 f7 ee ff ff       	call   800e5c <fd2num>
  801f65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f68:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f73:	e9 4f ff ff ff       	jmp    801ec7 <pipe+0x75>
	sys_page_unmap(0, va);
  801f78:	83 ec 08             	sub    $0x8,%esp
  801f7b:	56                   	push   %esi
  801f7c:	6a 00                	push   $0x0
  801f7e:	e8 4e ed ff ff       	call   800cd1 <sys_page_unmap>
  801f83:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f86:	83 ec 08             	sub    $0x8,%esp
  801f89:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 3e ed ff ff       	call   800cd1 <sys_page_unmap>
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	e9 1c ff ff ff       	jmp    801eb7 <pipe+0x65>

00801f9b <pipeisclosed>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa4:	50                   	push   %eax
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	e8 25 ef ff ff       	call   800ed2 <fd_lookup>
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	78 18                	js     801fcc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fba:	e8 ad ee ff ff       	call   800e6c <fd2data>
	return _pipeisclosed(fd, p);
  801fbf:	89 c2                	mov    %eax,%edx
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	e8 30 fd ff ff       	call   801cf9 <_pipeisclosed>
  801fc9:	83 c4 10             	add    $0x10,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fd4:	68 af 2e 80 00       	push   $0x802eaf
  801fd9:	ff 75 0c             	pushl  0xc(%ebp)
  801fdc:	e8 72 e8 ff ff       	call   800853 <strcpy>
	return 0;
}
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <devsock_close>:
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	53                   	push   %ebx
  801fec:	83 ec 10             	sub    $0x10,%esp
  801fef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ff2:	53                   	push   %ebx
  801ff3:	e8 b3 06 00 00       	call   8026ab <pageref>
  801ff8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ffb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802000:	83 f8 01             	cmp    $0x1,%eax
  802003:	74 07                	je     80200c <devsock_close+0x24>
}
  802005:	89 d0                	mov    %edx,%eax
  802007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	ff 73 0c             	pushl  0xc(%ebx)
  802012:	e8 b7 02 00 00       	call   8022ce <nsipc_close>
  802017:	89 c2                	mov    %eax,%edx
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	eb e7                	jmp    802005 <devsock_close+0x1d>

0080201e <devsock_write>:
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802024:	6a 00                	push   $0x0
  802026:	ff 75 10             	pushl  0x10(%ebp)
  802029:	ff 75 0c             	pushl  0xc(%ebp)
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	ff 70 0c             	pushl  0xc(%eax)
  802032:	e8 74 03 00 00       	call   8023ab <nsipc_send>
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <devsock_read>:
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80203f:	6a 00                	push   $0x0
  802041:	ff 75 10             	pushl  0x10(%ebp)
  802044:	ff 75 0c             	pushl  0xc(%ebp)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	ff 70 0c             	pushl  0xc(%eax)
  80204d:	e8 ed 02 00 00       	call   80233f <nsipc_recv>
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <fd2sockid>:
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80205a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	e8 6e ee ff ff       	call   800ed2 <fd_lookup>
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	85 c0                	test   %eax,%eax
  802069:	78 10                	js     80207b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  802074:	39 08                	cmp    %ecx,(%eax)
  802076:	75 05                	jne    80207d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802078:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    
		return -E_NOT_SUPP;
  80207d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802082:	eb f7                	jmp    80207b <fd2sockid+0x27>

00802084 <alloc_sockfd>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
  802089:	83 ec 1c             	sub    $0x1c,%esp
  80208c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80208e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802091:	50                   	push   %eax
  802092:	e8 ec ed ff ff       	call   800e83 <fd_alloc>
  802097:	89 c3                	mov    %eax,%ebx
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 43                	js     8020e3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	68 07 04 00 00       	push   $0x407
  8020a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ab:	6a 00                	push   $0x0
  8020ad:	e8 9a eb ff ff       	call   800c4c <sys_page_alloc>
  8020b2:	89 c3                	mov    %eax,%ebx
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 28                	js     8020e3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020d0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	50                   	push   %eax
  8020d7:	e8 80 ed ff ff       	call   800e5c <fd2num>
  8020dc:	89 c3                	mov    %eax,%ebx
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	eb 0c                	jmp    8020ef <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	56                   	push   %esi
  8020e7:	e8 e2 01 00 00       	call   8022ce <nsipc_close>
		return r;
  8020ec:	83 c4 10             	add    $0x10,%esp
}
  8020ef:	89 d8                	mov    %ebx,%eax
  8020f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f4:	5b                   	pop    %ebx
  8020f5:	5e                   	pop    %esi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    

008020f8 <accept>:
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	e8 4e ff ff ff       	call   802054 <fd2sockid>
  802106:	85 c0                	test   %eax,%eax
  802108:	78 1b                	js     802125 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80210a:	83 ec 04             	sub    $0x4,%esp
  80210d:	ff 75 10             	pushl  0x10(%ebp)
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	50                   	push   %eax
  802114:	e8 0e 01 00 00       	call   802227 <nsipc_accept>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 05                	js     802125 <accept+0x2d>
	return alloc_sockfd(r);
  802120:	e8 5f ff ff ff       	call   802084 <alloc_sockfd>
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <bind>:
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	e8 1f ff ff ff       	call   802054 <fd2sockid>
  802135:	85 c0                	test   %eax,%eax
  802137:	78 12                	js     80214b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802139:	83 ec 04             	sub    $0x4,%esp
  80213c:	ff 75 10             	pushl  0x10(%ebp)
  80213f:	ff 75 0c             	pushl  0xc(%ebp)
  802142:	50                   	push   %eax
  802143:	e8 2f 01 00 00       	call   802277 <nsipc_bind>
  802148:	83 c4 10             	add    $0x10,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <shutdown>:
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	e8 f9 fe ff ff       	call   802054 <fd2sockid>
  80215b:	85 c0                	test   %eax,%eax
  80215d:	78 0f                	js     80216e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80215f:	83 ec 08             	sub    $0x8,%esp
  802162:	ff 75 0c             	pushl  0xc(%ebp)
  802165:	50                   	push   %eax
  802166:	e8 41 01 00 00       	call   8022ac <nsipc_shutdown>
  80216b:	83 c4 10             	add    $0x10,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <connect>:
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	e8 d6 fe ff ff       	call   802054 <fd2sockid>
  80217e:	85 c0                	test   %eax,%eax
  802180:	78 12                	js     802194 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	ff 75 10             	pushl  0x10(%ebp)
  802188:	ff 75 0c             	pushl  0xc(%ebp)
  80218b:	50                   	push   %eax
  80218c:	e8 57 01 00 00       	call   8022e8 <nsipc_connect>
  802191:	83 c4 10             	add    $0x10,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <listen>:
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	e8 b0 fe ff ff       	call   802054 <fd2sockid>
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 0f                	js     8021b7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8021a8:	83 ec 08             	sub    $0x8,%esp
  8021ab:	ff 75 0c             	pushl  0xc(%ebp)
  8021ae:	50                   	push   %eax
  8021af:	e8 69 01 00 00       	call   80231d <nsipc_listen>
  8021b4:	83 c4 10             	add    $0x10,%esp
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021bf:	ff 75 10             	pushl  0x10(%ebp)
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	e8 3c 02 00 00       	call   802409 <nsipc_socket>
  8021cd:	83 c4 10             	add    $0x10,%esp
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	78 05                	js     8021d9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021d4:	e8 ab fe ff ff       	call   802084 <alloc_sockfd>
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	53                   	push   %ebx
  8021df:	83 ec 04             	sub    $0x4,%esp
  8021e2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021e4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8021eb:	74 26                	je     802213 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021ed:	6a 07                	push   $0x7
  8021ef:	68 00 60 80 00       	push   $0x806000
  8021f4:	53                   	push   %ebx
  8021f5:	ff 35 04 40 80 00    	pushl  0x804004
  8021fb:	e8 19 04 00 00       	call   802619 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802200:	83 c4 0c             	add    $0xc,%esp
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	e8 a2 03 00 00       	call   8025b0 <ipc_recv>
}
  80220e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802211:	c9                   	leave  
  802212:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802213:	83 ec 0c             	sub    $0xc,%esp
  802216:	6a 02                	push   $0x2
  802218:	e8 55 04 00 00       	call   802672 <ipc_find_env>
  80221d:	a3 04 40 80 00       	mov    %eax,0x804004
  802222:	83 c4 10             	add    $0x10,%esp
  802225:	eb c6                	jmp    8021ed <nsipc+0x12>

00802227 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802237:	8b 06                	mov    (%esi),%eax
  802239:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	e8 93 ff ff ff       	call   8021db <nsipc>
  802248:	89 c3                	mov    %eax,%ebx
  80224a:	85 c0                	test   %eax,%eax
  80224c:	78 20                	js     80226e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	ff 35 10 60 80 00    	pushl  0x806010
  802257:	68 00 60 80 00       	push   $0x806000
  80225c:	ff 75 0c             	pushl  0xc(%ebp)
  80225f:	e8 7d e7 ff ff       	call   8009e1 <memmove>
		*addrlen = ret->ret_addrlen;
  802264:	a1 10 60 80 00       	mov    0x806010,%eax
  802269:	89 06                	mov    %eax,(%esi)
  80226b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80226e:	89 d8                	mov    %ebx,%eax
  802270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    

00802277 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	53                   	push   %ebx
  80227b:	83 ec 08             	sub    $0x8,%esp
  80227e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802289:	53                   	push   %ebx
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	68 04 60 80 00       	push   $0x806004
  802292:	e8 4a e7 ff ff       	call   8009e1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802297:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80229d:	b8 02 00 00 00       	mov    $0x2,%eax
  8022a2:	e8 34 ff ff ff       	call   8021db <nsipc>
}
  8022a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8022ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8022c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8022c7:	e8 0f ff ff ff       	call   8021db <nsipc>
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <nsipc_close>:

int
nsipc_close(int s)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8022dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8022e1:	e8 f5 fe ff ff       	call   8021db <nsipc>
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	53                   	push   %ebx
  8022ec:	83 ec 08             	sub    $0x8,%esp
  8022ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022fa:	53                   	push   %ebx
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	68 04 60 80 00       	push   $0x806004
  802303:	e8 d9 e6 ff ff       	call   8009e1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802308:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80230e:	b8 05 00 00 00       	mov    $0x5,%eax
  802313:	e8 c3 fe ff ff       	call   8021db <nsipc>
}
  802318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802333:	b8 06 00 00 00       	mov    $0x6,%eax
  802338:	e8 9e fe ff ff       	call   8021db <nsipc>
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80234f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802355:	8b 45 14             	mov    0x14(%ebp),%eax
  802358:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80235d:	b8 07 00 00 00       	mov    $0x7,%eax
  802362:	e8 74 fe ff ff       	call   8021db <nsipc>
  802367:	89 c3                	mov    %eax,%ebx
  802369:	85 c0                	test   %eax,%eax
  80236b:	78 1f                	js     80238c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80236d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802372:	7f 21                	jg     802395 <nsipc_recv+0x56>
  802374:	39 c6                	cmp    %eax,%esi
  802376:	7c 1d                	jl     802395 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	50                   	push   %eax
  80237c:	68 00 60 80 00       	push   $0x806000
  802381:	ff 75 0c             	pushl  0xc(%ebp)
  802384:	e8 58 e6 ff ff       	call   8009e1 <memmove>
  802389:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80238c:	89 d8                	mov    %ebx,%eax
  80238e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802395:	68 bb 2e 80 00       	push   $0x802ebb
  80239a:	68 a9 2d 80 00       	push   $0x802da9
  80239f:	6a 62                	push   $0x62
  8023a1:	68 d0 2e 80 00       	push   $0x802ed0
  8023a6:	e8 30 dd ff ff       	call   8000db <_panic>

008023ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	53                   	push   %ebx
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8023bd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023c3:	7f 2e                	jg     8023f3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	53                   	push   %ebx
  8023c9:	ff 75 0c             	pushl  0xc(%ebp)
  8023cc:	68 0c 60 80 00       	push   $0x80600c
  8023d1:	e8 0b e6 ff ff       	call   8009e1 <memmove>
	nsipcbuf.send.req_size = size;
  8023d6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8023df:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e9:	e8 ed fd ff ff       	call   8021db <nsipc>
}
  8023ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    
	assert(size < 1600);
  8023f3:	68 dc 2e 80 00       	push   $0x802edc
  8023f8:	68 a9 2d 80 00       	push   $0x802da9
  8023fd:	6a 6d                	push   $0x6d
  8023ff:	68 d0 2e 80 00       	push   $0x802ed0
  802404:	e8 d2 dc ff ff       	call   8000db <_panic>

00802409 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80241f:	8b 45 10             	mov    0x10(%ebp),%eax
  802422:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802427:	b8 09 00 00 00       	mov    $0x9,%eax
  80242c:	e8 aa fd ff ff       	call   8021db <nsipc>
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
  80243b:	5d                   	pop    %ebp
  80243c:	c3                   	ret    

0080243d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802443:	68 e8 2e 80 00       	push   $0x802ee8
  802448:	ff 75 0c             	pushl  0xc(%ebp)
  80244b:	e8 03 e4 ff ff       	call   800853 <strcpy>
	return 0;
}
  802450:	b8 00 00 00 00       	mov    $0x0,%eax
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <devcons_write>:
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	57                   	push   %edi
  80245b:	56                   	push   %esi
  80245c:	53                   	push   %ebx
  80245d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802463:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802468:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80246e:	eb 2f                	jmp    80249f <devcons_write+0x48>
		m = n - tot;
  802470:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802473:	29 f3                	sub    %esi,%ebx
  802475:	83 fb 7f             	cmp    $0x7f,%ebx
  802478:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80247d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802480:	83 ec 04             	sub    $0x4,%esp
  802483:	53                   	push   %ebx
  802484:	89 f0                	mov    %esi,%eax
  802486:	03 45 0c             	add    0xc(%ebp),%eax
  802489:	50                   	push   %eax
  80248a:	57                   	push   %edi
  80248b:	e8 51 e5 ff ff       	call   8009e1 <memmove>
		sys_cputs(buf, m);
  802490:	83 c4 08             	add    $0x8,%esp
  802493:	53                   	push   %ebx
  802494:	57                   	push   %edi
  802495:	e8 f6 e6 ff ff       	call   800b90 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80249a:	01 de                	add    %ebx,%esi
  80249c:	83 c4 10             	add    $0x10,%esp
  80249f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a2:	72 cc                	jb     802470 <devcons_write+0x19>
}
  8024a4:	89 f0                	mov    %esi,%eax
  8024a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a9:	5b                   	pop    %ebx
  8024aa:	5e                   	pop    %esi
  8024ab:	5f                   	pop    %edi
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    

008024ae <devcons_read>:
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 08             	sub    $0x8,%esp
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bd:	75 07                	jne    8024c6 <devcons_read+0x18>
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    
		sys_yield();
  8024c1:	e8 67 e7 ff ff       	call   800c2d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024c6:	e8 e3 e6 ff ff       	call   800bae <sys_cgetc>
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 f2                	je     8024c1 <devcons_read+0x13>
	if (c < 0)
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	78 ec                	js     8024bf <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8024d3:	83 f8 04             	cmp    $0x4,%eax
  8024d6:	74 0c                	je     8024e4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	88 02                	mov    %al,(%edx)
	return 1;
  8024dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e2:	eb db                	jmp    8024bf <devcons_read+0x11>
		return 0;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	eb d4                	jmp    8024bf <devcons_read+0x11>

008024eb <cputchar>:
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024f7:	6a 01                	push   $0x1
  8024f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024fc:	50                   	push   %eax
  8024fd:	e8 8e e6 ff ff       	call   800b90 <sys_cputs>
}
  802502:	83 c4 10             	add    $0x10,%esp
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <getchar>:
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80250d:	6a 01                	push   $0x1
  80250f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802512:	50                   	push   %eax
  802513:	6a 00                	push   $0x0
  802515:	e8 29 ec ff ff       	call   801143 <read>
	if (r < 0)
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	85 c0                	test   %eax,%eax
  80251f:	78 08                	js     802529 <getchar+0x22>
	if (r < 1)
  802521:	85 c0                	test   %eax,%eax
  802523:	7e 06                	jle    80252b <getchar+0x24>
	return c;
  802525:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    
		return -E_EOF;
  80252b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802530:	eb f7                	jmp    802529 <getchar+0x22>

00802532 <iscons>:
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802538:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 08             	pushl  0x8(%ebp)
  80253f:	e8 8e e9 ff ff       	call   800ed2 <fd_lookup>
  802544:	83 c4 10             	add    $0x10,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	78 11                	js     80255c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802554:	39 10                	cmp    %edx,(%eax)
  802556:	0f 94 c0             	sete   %al
  802559:	0f b6 c0             	movzbl %al,%eax
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <opencons>:
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802567:	50                   	push   %eax
  802568:	e8 16 e9 ff ff       	call   800e83 <fd_alloc>
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	85 c0                	test   %eax,%eax
  802572:	78 3a                	js     8025ae <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 07 04 00 00       	push   $0x407
  80257c:	ff 75 f4             	pushl  -0xc(%ebp)
  80257f:	6a 00                	push   $0x0
  802581:	e8 c6 e6 ff ff       	call   800c4c <sys_page_alloc>
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	85 c0                	test   %eax,%eax
  80258b:	78 21                	js     8025ae <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802596:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	50                   	push   %eax
  8025a6:	e8 b1 e8 ff ff       	call   800e5c <fd2num>
  8025ab:	83 c4 10             	add    $0x10,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	56                   	push   %esi
  8025b4:	53                   	push   %ebx
  8025b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8025b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8025be:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8025c0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8025c5:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	50                   	push   %eax
  8025cc:	e8 2b e8 ff ff       	call   800dfc <sys_ipc_recv>
  8025d1:	83 c4 10             	add    $0x10,%esp
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	78 2b                	js     802603 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8025d8:	85 f6                	test   %esi,%esi
  8025da:	74 0a                	je     8025e6 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8025dc:	a1 08 40 80 00       	mov    0x804008,%eax
  8025e1:	8b 40 74             	mov    0x74(%eax),%eax
  8025e4:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8025e6:	85 db                	test   %ebx,%ebx
  8025e8:	74 0a                	je     8025f4 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8025ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8025ef:	8b 40 78             	mov    0x78(%eax),%eax
  8025f2:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8025f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8025f9:	8b 40 70             	mov    0x70(%eax),%eax
}
  8025fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025ff:	5b                   	pop    %ebx
  802600:	5e                   	pop    %esi
  802601:	5d                   	pop    %ebp
  802602:	c3                   	ret    
	    if (from_env_store != NULL) {
  802603:	85 f6                	test   %esi,%esi
  802605:	74 06                	je     80260d <ipc_recv+0x5d>
	        *from_env_store = 0;
  802607:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80260d:	85 db                	test   %ebx,%ebx
  80260f:	74 eb                	je     8025fc <ipc_recv+0x4c>
	        *perm_store = 0;
  802611:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802617:	eb e3                	jmp    8025fc <ipc_recv+0x4c>

00802619 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	57                   	push   %edi
  80261d:	56                   	push   %esi
  80261e:	53                   	push   %ebx
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	8b 7d 08             	mov    0x8(%ebp),%edi
  802625:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802628:	85 f6                	test   %esi,%esi
  80262a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80262f:	0f 44 f0             	cmove  %eax,%esi
  802632:	eb 09                	jmp    80263d <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802634:	e8 f4 e5 ff ff       	call   800c2d <sys_yield>
	} while(r != 0);
  802639:	85 db                	test   %ebx,%ebx
  80263b:	74 2d                	je     80266a <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80263d:	ff 75 14             	pushl  0x14(%ebp)
  802640:	56                   	push   %esi
  802641:	ff 75 0c             	pushl  0xc(%ebp)
  802644:	57                   	push   %edi
  802645:	e8 8f e7 ff ff       	call   800dd9 <sys_ipc_try_send>
  80264a:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80264c:	83 c4 10             	add    $0x10,%esp
  80264f:	85 c0                	test   %eax,%eax
  802651:	79 e1                	jns    802634 <ipc_send+0x1b>
  802653:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802656:	74 dc                	je     802634 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802658:	50                   	push   %eax
  802659:	68 f4 2e 80 00       	push   $0x802ef4
  80265e:	6a 45                	push   $0x45
  802660:	68 01 2f 80 00       	push   $0x802f01
  802665:	e8 71 da ff ff       	call   8000db <_panic>
}
  80266a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80266d:	5b                   	pop    %ebx
  80266e:	5e                   	pop    %esi
  80266f:	5f                   	pop    %edi
  802670:	5d                   	pop    %ebp
  802671:	c3                   	ret    

00802672 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80267d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802680:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802686:	8b 52 50             	mov    0x50(%edx),%edx
  802689:	39 ca                	cmp    %ecx,%edx
  80268b:	74 11                	je     80269e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80268d:	83 c0 01             	add    $0x1,%eax
  802690:	3d 00 04 00 00       	cmp    $0x400,%eax
  802695:	75 e6                	jne    80267d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	eb 0b                	jmp    8026a9 <ipc_find_env+0x37>
			return envs[i].env_id;
  80269e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026a6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    

008026ab <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026b1:	89 d0                	mov    %edx,%eax
  8026b3:	c1 e8 16             	shr    $0x16,%eax
  8026b6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026c2:	f6 c1 01             	test   $0x1,%cl
  8026c5:	74 1d                	je     8026e4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026c7:	c1 ea 0c             	shr    $0xc,%edx
  8026ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026d1:	f6 c2 01             	test   $0x1,%dl
  8026d4:	74 0e                	je     8026e4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026d6:	c1 ea 0c             	shr    $0xc,%edx
  8026d9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026e0:	ef 
  8026e1:	0f b7 c0             	movzwl %ax,%eax
}
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	66 90                	xchg   %ax,%ax
  8026e8:	66 90                	xchg   %ax,%ax
  8026ea:	66 90                	xchg   %ax,%ax
  8026ec:	66 90                	xchg   %ax,%ax
  8026ee:	66 90                	xchg   %ax,%ax

008026f0 <__udivdi3>:
  8026f0:	55                   	push   %ebp
  8026f1:	57                   	push   %edi
  8026f2:	56                   	push   %esi
  8026f3:	53                   	push   %ebx
  8026f4:	83 ec 1c             	sub    $0x1c,%esp
  8026f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802703:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802707:	85 d2                	test   %edx,%edx
  802709:	75 35                	jne    802740 <__udivdi3+0x50>
  80270b:	39 f3                	cmp    %esi,%ebx
  80270d:	0f 87 bd 00 00 00    	ja     8027d0 <__udivdi3+0xe0>
  802713:	85 db                	test   %ebx,%ebx
  802715:	89 d9                	mov    %ebx,%ecx
  802717:	75 0b                	jne    802724 <__udivdi3+0x34>
  802719:	b8 01 00 00 00       	mov    $0x1,%eax
  80271e:	31 d2                	xor    %edx,%edx
  802720:	f7 f3                	div    %ebx
  802722:	89 c1                	mov    %eax,%ecx
  802724:	31 d2                	xor    %edx,%edx
  802726:	89 f0                	mov    %esi,%eax
  802728:	f7 f1                	div    %ecx
  80272a:	89 c6                	mov    %eax,%esi
  80272c:	89 e8                	mov    %ebp,%eax
  80272e:	89 f7                	mov    %esi,%edi
  802730:	f7 f1                	div    %ecx
  802732:	89 fa                	mov    %edi,%edx
  802734:	83 c4 1c             	add    $0x1c,%esp
  802737:	5b                   	pop    %ebx
  802738:	5e                   	pop    %esi
  802739:	5f                   	pop    %edi
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    
  80273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802740:	39 f2                	cmp    %esi,%edx
  802742:	77 7c                	ja     8027c0 <__udivdi3+0xd0>
  802744:	0f bd fa             	bsr    %edx,%edi
  802747:	83 f7 1f             	xor    $0x1f,%edi
  80274a:	0f 84 98 00 00 00    	je     8027e8 <__udivdi3+0xf8>
  802750:	89 f9                	mov    %edi,%ecx
  802752:	b8 20 00 00 00       	mov    $0x20,%eax
  802757:	29 f8                	sub    %edi,%eax
  802759:	d3 e2                	shl    %cl,%edx
  80275b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80275f:	89 c1                	mov    %eax,%ecx
  802761:	89 da                	mov    %ebx,%edx
  802763:	d3 ea                	shr    %cl,%edx
  802765:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802769:	09 d1                	or     %edx,%ecx
  80276b:	89 f2                	mov    %esi,%edx
  80276d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802771:	89 f9                	mov    %edi,%ecx
  802773:	d3 e3                	shl    %cl,%ebx
  802775:	89 c1                	mov    %eax,%ecx
  802777:	d3 ea                	shr    %cl,%edx
  802779:	89 f9                	mov    %edi,%ecx
  80277b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80277f:	d3 e6                	shl    %cl,%esi
  802781:	89 eb                	mov    %ebp,%ebx
  802783:	89 c1                	mov    %eax,%ecx
  802785:	d3 eb                	shr    %cl,%ebx
  802787:	09 de                	or     %ebx,%esi
  802789:	89 f0                	mov    %esi,%eax
  80278b:	f7 74 24 08          	divl   0x8(%esp)
  80278f:	89 d6                	mov    %edx,%esi
  802791:	89 c3                	mov    %eax,%ebx
  802793:	f7 64 24 0c          	mull   0xc(%esp)
  802797:	39 d6                	cmp    %edx,%esi
  802799:	72 0c                	jb     8027a7 <__udivdi3+0xb7>
  80279b:	89 f9                	mov    %edi,%ecx
  80279d:	d3 e5                	shl    %cl,%ebp
  80279f:	39 c5                	cmp    %eax,%ebp
  8027a1:	73 5d                	jae    802800 <__udivdi3+0x110>
  8027a3:	39 d6                	cmp    %edx,%esi
  8027a5:	75 59                	jne    802800 <__udivdi3+0x110>
  8027a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027aa:	31 ff                	xor    %edi,%edi
  8027ac:	89 fa                	mov    %edi,%edx
  8027ae:	83 c4 1c             	add    $0x1c,%esp
  8027b1:	5b                   	pop    %ebx
  8027b2:	5e                   	pop    %esi
  8027b3:	5f                   	pop    %edi
  8027b4:	5d                   	pop    %ebp
  8027b5:	c3                   	ret    
  8027b6:	8d 76 00             	lea    0x0(%esi),%esi
  8027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8027c0:	31 ff                	xor    %edi,%edi
  8027c2:	31 c0                	xor    %eax,%eax
  8027c4:	89 fa                	mov    %edi,%edx
  8027c6:	83 c4 1c             	add    $0x1c,%esp
  8027c9:	5b                   	pop    %ebx
  8027ca:	5e                   	pop    %esi
  8027cb:	5f                   	pop    %edi
  8027cc:	5d                   	pop    %ebp
  8027cd:	c3                   	ret    
  8027ce:	66 90                	xchg   %ax,%ax
  8027d0:	31 ff                	xor    %edi,%edi
  8027d2:	89 e8                	mov    %ebp,%eax
  8027d4:	89 f2                	mov    %esi,%edx
  8027d6:	f7 f3                	div    %ebx
  8027d8:	89 fa                	mov    %edi,%edx
  8027da:	83 c4 1c             	add    $0x1c,%esp
  8027dd:	5b                   	pop    %ebx
  8027de:	5e                   	pop    %esi
  8027df:	5f                   	pop    %edi
  8027e0:	5d                   	pop    %ebp
  8027e1:	c3                   	ret    
  8027e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027e8:	39 f2                	cmp    %esi,%edx
  8027ea:	72 06                	jb     8027f2 <__udivdi3+0x102>
  8027ec:	31 c0                	xor    %eax,%eax
  8027ee:	39 eb                	cmp    %ebp,%ebx
  8027f0:	77 d2                	ja     8027c4 <__udivdi3+0xd4>
  8027f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f7:	eb cb                	jmp    8027c4 <__udivdi3+0xd4>
  8027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802800:	89 d8                	mov    %ebx,%eax
  802802:	31 ff                	xor    %edi,%edi
  802804:	eb be                	jmp    8027c4 <__udivdi3+0xd4>
  802806:	66 90                	xchg   %ax,%ax
  802808:	66 90                	xchg   %ax,%ax
  80280a:	66 90                	xchg   %ax,%ax
  80280c:	66 90                	xchg   %ax,%ax
  80280e:	66 90                	xchg   %ax,%ax

00802810 <__umoddi3>:
  802810:	55                   	push   %ebp
  802811:	57                   	push   %edi
  802812:	56                   	push   %esi
  802813:	53                   	push   %ebx
  802814:	83 ec 1c             	sub    $0x1c,%esp
  802817:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80281b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80281f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802827:	85 ed                	test   %ebp,%ebp
  802829:	89 f0                	mov    %esi,%eax
  80282b:	89 da                	mov    %ebx,%edx
  80282d:	75 19                	jne    802848 <__umoddi3+0x38>
  80282f:	39 df                	cmp    %ebx,%edi
  802831:	0f 86 b1 00 00 00    	jbe    8028e8 <__umoddi3+0xd8>
  802837:	f7 f7                	div    %edi
  802839:	89 d0                	mov    %edx,%eax
  80283b:	31 d2                	xor    %edx,%edx
  80283d:	83 c4 1c             	add    $0x1c,%esp
  802840:	5b                   	pop    %ebx
  802841:	5e                   	pop    %esi
  802842:	5f                   	pop    %edi
  802843:	5d                   	pop    %ebp
  802844:	c3                   	ret    
  802845:	8d 76 00             	lea    0x0(%esi),%esi
  802848:	39 dd                	cmp    %ebx,%ebp
  80284a:	77 f1                	ja     80283d <__umoddi3+0x2d>
  80284c:	0f bd cd             	bsr    %ebp,%ecx
  80284f:	83 f1 1f             	xor    $0x1f,%ecx
  802852:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802856:	0f 84 b4 00 00 00    	je     802910 <__umoddi3+0x100>
  80285c:	b8 20 00 00 00       	mov    $0x20,%eax
  802861:	89 c2                	mov    %eax,%edx
  802863:	8b 44 24 04          	mov    0x4(%esp),%eax
  802867:	29 c2                	sub    %eax,%edx
  802869:	89 c1                	mov    %eax,%ecx
  80286b:	89 f8                	mov    %edi,%eax
  80286d:	d3 e5                	shl    %cl,%ebp
  80286f:	89 d1                	mov    %edx,%ecx
  802871:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802875:	d3 e8                	shr    %cl,%eax
  802877:	09 c5                	or     %eax,%ebp
  802879:	8b 44 24 04          	mov    0x4(%esp),%eax
  80287d:	89 c1                	mov    %eax,%ecx
  80287f:	d3 e7                	shl    %cl,%edi
  802881:	89 d1                	mov    %edx,%ecx
  802883:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802887:	89 df                	mov    %ebx,%edi
  802889:	d3 ef                	shr    %cl,%edi
  80288b:	89 c1                	mov    %eax,%ecx
  80288d:	89 f0                	mov    %esi,%eax
  80288f:	d3 e3                	shl    %cl,%ebx
  802891:	89 d1                	mov    %edx,%ecx
  802893:	89 fa                	mov    %edi,%edx
  802895:	d3 e8                	shr    %cl,%eax
  802897:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80289c:	09 d8                	or     %ebx,%eax
  80289e:	f7 f5                	div    %ebp
  8028a0:	d3 e6                	shl    %cl,%esi
  8028a2:	89 d1                	mov    %edx,%ecx
  8028a4:	f7 64 24 08          	mull   0x8(%esp)
  8028a8:	39 d1                	cmp    %edx,%ecx
  8028aa:	89 c3                	mov    %eax,%ebx
  8028ac:	89 d7                	mov    %edx,%edi
  8028ae:	72 06                	jb     8028b6 <__umoddi3+0xa6>
  8028b0:	75 0e                	jne    8028c0 <__umoddi3+0xb0>
  8028b2:	39 c6                	cmp    %eax,%esi
  8028b4:	73 0a                	jae    8028c0 <__umoddi3+0xb0>
  8028b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8028ba:	19 ea                	sbb    %ebp,%edx
  8028bc:	89 d7                	mov    %edx,%edi
  8028be:	89 c3                	mov    %eax,%ebx
  8028c0:	89 ca                	mov    %ecx,%edx
  8028c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8028c7:	29 de                	sub    %ebx,%esi
  8028c9:	19 fa                	sbb    %edi,%edx
  8028cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8028cf:	89 d0                	mov    %edx,%eax
  8028d1:	d3 e0                	shl    %cl,%eax
  8028d3:	89 d9                	mov    %ebx,%ecx
  8028d5:	d3 ee                	shr    %cl,%esi
  8028d7:	d3 ea                	shr    %cl,%edx
  8028d9:	09 f0                	or     %esi,%eax
  8028db:	83 c4 1c             	add    $0x1c,%esp
  8028de:	5b                   	pop    %ebx
  8028df:	5e                   	pop    %esi
  8028e0:	5f                   	pop    %edi
  8028e1:	5d                   	pop    %ebp
  8028e2:	c3                   	ret    
  8028e3:	90                   	nop
  8028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	85 ff                	test   %edi,%edi
  8028ea:	89 f9                	mov    %edi,%ecx
  8028ec:	75 0b                	jne    8028f9 <__umoddi3+0xe9>
  8028ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f3:	31 d2                	xor    %edx,%edx
  8028f5:	f7 f7                	div    %edi
  8028f7:	89 c1                	mov    %eax,%ecx
  8028f9:	89 d8                	mov    %ebx,%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	f7 f1                	div    %ecx
  8028ff:	89 f0                	mov    %esi,%eax
  802901:	f7 f1                	div    %ecx
  802903:	e9 31 ff ff ff       	jmp    802839 <__umoddi3+0x29>
  802908:	90                   	nop
  802909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802910:	39 dd                	cmp    %ebx,%ebp
  802912:	72 08                	jb     80291c <__umoddi3+0x10c>
  802914:	39 f7                	cmp    %esi,%edi
  802916:	0f 87 21 ff ff ff    	ja     80283d <__umoddi3+0x2d>
  80291c:	89 da                	mov    %ebx,%edx
  80291e:	89 f0                	mov    %esi,%eax
  802920:	29 f8                	sub    %edi,%eax
  802922:	19 ea                	sbb    %ebp,%edx
  802924:	e9 14 ff ff ff       	jmp    80283d <__umoddi3+0x2d>
