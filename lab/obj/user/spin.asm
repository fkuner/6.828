
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 40 27 80 00       	push   $0x802740
  80003f:	e8 66 01 00 00       	call   8001aa <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 f1 0e 00 00       	call   800f3a <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 b8 27 80 00       	push   $0x8027b8
  800058:	e8 4d 01 00 00       	call   8001aa <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 68 27 80 00       	push   $0x802768
  80006c:	e8 39 01 00 00       	call   8001aa <cprintf>
	sys_yield();
  800071:	e8 ab 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  800076:	e8 a6 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  80007b:	e8 a1 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  800080:	e8 9c 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  800085:	e8 97 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  80008a:	e8 92 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  80008f:	e8 8d 0b 00 00       	call   800c21 <sys_yield>
	sys_yield();
  800094:	e8 88 0b 00 00       	call   800c21 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 90 27 80 00 	movl   $0x802790,(%esp)
  8000a0:	e8 05 01 00 00       	call   8001aa <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 14 0b 00 00       	call   800bc1 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 3d 0b 00 00       	call   800c02 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 4c 12 00 00       	call   801352 <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 b1 0a 00 00       	call   800bc1 <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	53                   	push   %ebx
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011f:	8b 13                	mov    (%ebx),%edx
  800121:	8d 42 01             	lea    0x1(%edx),%eax
  800124:	89 03                	mov    %eax,(%ebx)
  800126:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800129:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800132:	74 09                	je     80013d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800134:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 ff 00 00 00       	push   $0xff
  800145:	8d 43 08             	lea    0x8(%ebx),%eax
  800148:	50                   	push   %eax
  800149:	e8 36 0a 00 00       	call   800b84 <sys_cputs>
		b->idx = 0;
  80014e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	eb db                	jmp    800134 <putch+0x1f>

00800159 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 15 01 80 00       	push   $0x800115
  800188:	e8 1a 01 00 00       	call   8002a7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 e2 09 00 00       	call   800b84 <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b3:	50                   	push   %eax
  8001b4:	ff 75 08             	pushl  0x8(%ebp)
  8001b7:	e8 9d ff ff ff       	call   800159 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	57                   	push   %edi
  8001c2:	56                   	push   %esi
  8001c3:	53                   	push   %ebx
  8001c4:	83 ec 1c             	sub    $0x1c,%esp
  8001c7:	89 c7                	mov    %eax,%edi
  8001c9:	89 d6                	mov    %edx,%esi
  8001cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e5:	39 d3                	cmp    %edx,%ebx
  8001e7:	72 05                	jb     8001ee <printnum+0x30>
  8001e9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ec:	77 7a                	ja     800268 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	ff 75 18             	pushl  0x18(%ebp)
  8001f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 10             	pushl  0x10(%ebp)
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	ff 75 e4             	pushl  -0x1c(%ebp)
  800204:	ff 75 e0             	pushl  -0x20(%ebp)
  800207:	ff 75 dc             	pushl  -0x24(%ebp)
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	e8 ee 22 00 00       	call   802500 <__udivdi3>
  800212:	83 c4 18             	add    $0x18,%esp
  800215:	52                   	push   %edx
  800216:	50                   	push   %eax
  800217:	89 f2                	mov    %esi,%edx
  800219:	89 f8                	mov    %edi,%eax
  80021b:	e8 9e ff ff ff       	call   8001be <printnum>
  800220:	83 c4 20             	add    $0x20,%esp
  800223:	eb 13                	jmp    800238 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	56                   	push   %esi
  800229:	ff 75 18             	pushl  0x18(%ebp)
  80022c:	ff d7                	call   *%edi
  80022e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800231:	83 eb 01             	sub    $0x1,%ebx
  800234:	85 db                	test   %ebx,%ebx
  800236:	7f ed                	jg     800225 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	56                   	push   %esi
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800242:	ff 75 e0             	pushl  -0x20(%ebp)
  800245:	ff 75 dc             	pushl  -0x24(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	e8 d0 23 00 00       	call   802620 <__umoddi3>
  800250:	83 c4 14             	add    $0x14,%esp
  800253:	0f be 80 e0 27 80 00 	movsbl 0x8027e0(%eax),%eax
  80025a:	50                   	push   %eax
  80025b:	ff d7                	call   *%edi
}
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800263:	5b                   	pop    %ebx
  800264:	5e                   	pop    %esi
  800265:	5f                   	pop    %edi
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    
  800268:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026b:	eb c4                	jmp    800231 <printnum+0x73>

0080026d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800273:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800277:	8b 10                	mov    (%eax),%edx
  800279:	3b 50 04             	cmp    0x4(%eax),%edx
  80027c:	73 0a                	jae    800288 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800281:	89 08                	mov    %ecx,(%eax)
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	88 02                	mov    %al,(%edx)
}
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    

0080028a <printfmt>:
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800290:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800293:	50                   	push   %eax
  800294:	ff 75 10             	pushl  0x10(%ebp)
  800297:	ff 75 0c             	pushl  0xc(%ebp)
  80029a:	ff 75 08             	pushl  0x8(%ebp)
  80029d:	e8 05 00 00 00       	call   8002a7 <vprintfmt>
}
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <vprintfmt>:
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 2c             	sub    $0x2c,%esp
  8002b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b9:	e9 21 04 00 00       	jmp    8006df <vprintfmt+0x438>
		padc = ' ';
  8002be:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002c9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002dc:	8d 47 01             	lea    0x1(%edi),%eax
  8002df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e2:	0f b6 17             	movzbl (%edi),%edx
  8002e5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e8:	3c 55                	cmp    $0x55,%al
  8002ea:	0f 87 90 04 00 00    	ja     800780 <vprintfmt+0x4d9>
  8002f0:	0f b6 c0             	movzbl %al,%eax
  8002f3:	ff 24 85 20 29 80 00 	jmp    *0x802920(,%eax,4)
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002fd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800301:	eb d9                	jmp    8002dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800306:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030a:	eb d0                	jmp    8002dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	0f b6 d2             	movzbl %dl,%edx
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800312:	b8 00 00 00 00       	mov    $0x0,%eax
  800317:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800321:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800324:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800327:	83 f9 09             	cmp    $0x9,%ecx
  80032a:	77 55                	ja     800381 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80032c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032f:	eb e9                	jmp    80031a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800339:	8b 45 14             	mov    0x14(%ebp),%eax
  80033c:	8d 40 04             	lea    0x4(%eax),%eax
  80033f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800349:	79 91                	jns    8002dc <vprintfmt+0x35>
				width = precision, precision = -1;
  80034b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80034e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800351:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800358:	eb 82                	jmp    8002dc <vprintfmt+0x35>
  80035a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035d:	85 c0                	test   %eax,%eax
  80035f:	ba 00 00 00 00       	mov    $0x0,%edx
  800364:	0f 49 d0             	cmovns %eax,%edx
  800367:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036d:	e9 6a ff ff ff       	jmp    8002dc <vprintfmt+0x35>
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800375:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80037c:	e9 5b ff ff ff       	jmp    8002dc <vprintfmt+0x35>
  800381:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	eb bc                	jmp    800345 <vprintfmt+0x9e>
			lflag++;
  800389:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038f:	e9 48 ff ff ff       	jmp    8002dc <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 78 04             	lea    0x4(%eax),%edi
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	53                   	push   %ebx
  80039e:	ff 30                	pushl  (%eax)
  8003a0:	ff d6                	call   *%esi
			break;
  8003a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a8:	e9 2f 03 00 00       	jmp    8006dc <vprintfmt+0x435>
			err = va_arg(ap, int);
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8d 78 04             	lea    0x4(%eax),%edi
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	99                   	cltd   
  8003b6:	31 d0                	xor    %edx,%eax
  8003b8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ba:	83 f8 0f             	cmp    $0xf,%eax
  8003bd:	7f 23                	jg     8003e2 <vprintfmt+0x13b>
  8003bf:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  8003c6:	85 d2                	test   %edx,%edx
  8003c8:	74 18                	je     8003e2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003ca:	52                   	push   %edx
  8003cb:	68 43 2c 80 00       	push   $0x802c43
  8003d0:	53                   	push   %ebx
  8003d1:	56                   	push   %esi
  8003d2:	e8 b3 fe ff ff       	call   80028a <printfmt>
  8003d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003da:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003dd:	e9 fa 02 00 00       	jmp    8006dc <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8003e2:	50                   	push   %eax
  8003e3:	68 f8 27 80 00       	push   $0x8027f8
  8003e8:	53                   	push   %ebx
  8003e9:	56                   	push   %esi
  8003ea:	e8 9b fe ff ff       	call   80028a <printfmt>
  8003ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f5:	e9 e2 02 00 00       	jmp    8006dc <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800408:	85 ff                	test   %edi,%edi
  80040a:	b8 f1 27 80 00       	mov    $0x8027f1,%eax
  80040f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800412:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800416:	0f 8e bd 00 00 00    	jle    8004d9 <vprintfmt+0x232>
  80041c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800420:	75 0e                	jne    800430 <vprintfmt+0x189>
  800422:	89 75 08             	mov    %esi,0x8(%ebp)
  800425:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800428:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80042e:	eb 6d                	jmp    80049d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 d0             	pushl  -0x30(%ebp)
  800436:	57                   	push   %edi
  800437:	e8 ec 03 00 00       	call   800828 <strnlen>
  80043c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043f:	29 c1                	sub    %eax,%ecx
  800441:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800444:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800447:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80044b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800451:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	eb 0f                	jmp    800464 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	53                   	push   %ebx
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ef 01             	sub    $0x1,%edi
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	85 ff                	test   %edi,%edi
  800466:	7f ed                	jg     800455 <vprintfmt+0x1ae>
  800468:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80046e:	85 c9                	test   %ecx,%ecx
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	0f 49 c1             	cmovns %ecx,%eax
  800478:	29 c1                	sub    %eax,%ecx
  80047a:	89 75 08             	mov    %esi,0x8(%ebp)
  80047d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800480:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800483:	89 cb                	mov    %ecx,%ebx
  800485:	eb 16                	jmp    80049d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800487:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048b:	75 31                	jne    8004be <vprintfmt+0x217>
					putch(ch, putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 0c             	pushl  0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	ff 55 08             	call   *0x8(%ebp)
  800497:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049a:	83 eb 01             	sub    $0x1,%ebx
  80049d:	83 c7 01             	add    $0x1,%edi
  8004a0:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a4:	0f be c2             	movsbl %dl,%eax
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	74 59                	je     800504 <vprintfmt+0x25d>
  8004ab:	85 f6                	test   %esi,%esi
  8004ad:	78 d8                	js     800487 <vprintfmt+0x1e0>
  8004af:	83 ee 01             	sub    $0x1,%esi
  8004b2:	79 d3                	jns    800487 <vprintfmt+0x1e0>
  8004b4:	89 df                	mov    %ebx,%edi
  8004b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bc:	eb 37                	jmp    8004f5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004be:	0f be d2             	movsbl %dl,%edx
  8004c1:	83 ea 20             	sub    $0x20,%edx
  8004c4:	83 fa 5e             	cmp    $0x5e,%edx
  8004c7:	76 c4                	jbe    80048d <vprintfmt+0x1e6>
					putch('?', putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	6a 3f                	push   $0x3f
  8004d1:	ff 55 08             	call   *0x8(%ebp)
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	eb c1                	jmp    80049a <vprintfmt+0x1f3>
  8004d9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e5:	eb b6                	jmp    80049d <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	6a 20                	push   $0x20
  8004ed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ef:	83 ef 01             	sub    $0x1,%edi
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 ff                	test   %edi,%edi
  8004f7:	7f ee                	jg     8004e7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	e9 d8 01 00 00       	jmp    8006dc <vprintfmt+0x435>
  800504:	89 df                	mov    %ebx,%edi
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050c:	eb e7                	jmp    8004f5 <vprintfmt+0x24e>
	if (lflag >= 2)
  80050e:	83 f9 01             	cmp    $0x1,%ecx
  800511:	7e 45                	jle    800558 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8b 50 04             	mov    0x4(%eax),%edx
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 40 08             	lea    0x8(%eax),%eax
  800527:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80052e:	79 62                	jns    800592 <vprintfmt+0x2eb>
				putch('-', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 2d                	push   $0x2d
  800536:	ff d6                	call   *%esi
				num = -(long long) num;
  800538:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80053e:	f7 d8                	neg    %eax
  800540:	83 d2 00             	adc    $0x0,%edx
  800543:	f7 da                	neg    %edx
  800545:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800548:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054e:	ba 0a 00 00 00       	mov    $0xa,%edx
  800553:	e9 66 01 00 00       	jmp    8006be <vprintfmt+0x417>
	else if (lflag)
  800558:	85 c9                	test   %ecx,%ecx
  80055a:	75 1b                	jne    800577 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 c1                	mov    %eax,%ecx
  800566:	c1 f9 1f             	sar    $0x1f,%ecx
  800569:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8d 40 04             	lea    0x4(%eax),%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
  800575:	eb b3                	jmp    80052a <vprintfmt+0x283>
		return va_arg(*ap, long);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057f:	89 c1                	mov    %eax,%ecx
  800581:	c1 f9 1f             	sar    $0x1f,%ecx
  800584:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	eb 98                	jmp    80052a <vprintfmt+0x283>
			base = 10;
  800592:	ba 0a 00 00 00       	mov    $0xa,%edx
  800597:	e9 22 01 00 00       	jmp    8006be <vprintfmt+0x417>
	if (lflag >= 2)
  80059c:	83 f9 01             	cmp    $0x1,%ecx
  80059f:	7e 21                	jle    8005c2 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 50 04             	mov    0x4(%eax),%edx
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 40 08             	lea    0x8(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005bd:	e9 fc 00 00 00       	jmp    8006be <vprintfmt+0x417>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	75 23                	jne    8005e9 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005df:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005e4:	e9 d5 00 00 00       	jmp    8006be <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800602:	ba 0a 00 00 00       	mov    $0xa,%edx
  800607:	e9 b2 00 00 00       	jmp    8006be <vprintfmt+0x417>
	if (lflag >= 2)
  80060c:	83 f9 01             	cmp    $0x1,%ecx
  80060f:	7e 42                	jle    800653 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 50 04             	mov    0x4(%eax),%edx
  800617:	8b 00                	mov    (%eax),%eax
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 08             	lea    0x8(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800628:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  80062d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800631:	0f 89 87 00 00 00    	jns    8006be <vprintfmt+0x417>
				putch('-', putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	6a 2d                	push   $0x2d
  80063d:	ff d6                	call   *%esi
				num = -(long long) num;
  80063f:	f7 5d d8             	negl   -0x28(%ebp)
  800642:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800646:	f7 5d dc             	negl   -0x24(%ebp)
  800649:	83 c4 10             	add    $0x10,%esp
			base = 8;
  80064c:	ba 08 00 00 00       	mov    $0x8,%edx
  800651:	eb 6b                	jmp    8006be <vprintfmt+0x417>
	else if (lflag)
  800653:	85 c9                	test   %ecx,%ecx
  800655:	75 1b                	jne    800672 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
  800670:	eb b6                	jmp    800628 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
  80068b:	eb 9b                	jmp    800628 <vprintfmt+0x381>
			putch('0', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 30                	push   $0x30
  800693:	ff d6                	call   *%esi
			putch('x', putdat);
  800695:	83 c4 08             	add    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 78                	push   $0x78
  80069b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ad:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b9:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006be:	83 ec 0c             	sub    $0xc,%esp
  8006c1:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006c5:	50                   	push   %eax
  8006c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c9:	52                   	push   %edx
  8006ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8006cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8006d0:	89 da                	mov    %ebx,%edx
  8006d2:	89 f0                	mov    %esi,%eax
  8006d4:	e8 e5 fa ff ff       	call   8001be <printnum>
			break;
  8006d9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006df:	83 c7 01             	add    $0x1,%edi
  8006e2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e6:	83 f8 25             	cmp    $0x25,%eax
  8006e9:	0f 84 cf fb ff ff    	je     8002be <vprintfmt+0x17>
			if (ch == '\0')
  8006ef:	85 c0                	test   %eax,%eax
  8006f1:	0f 84 a9 00 00 00    	je     8007a0 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	53                   	push   %ebx
  8006fb:	50                   	push   %eax
  8006fc:	ff d6                	call   *%esi
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	eb dc                	jmp    8006df <vprintfmt+0x438>
	if (lflag >= 2)
  800703:	83 f9 01             	cmp    $0x1,%ecx
  800706:	7e 1e                	jle    800726 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 50 04             	mov    0x4(%eax),%edx
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800713:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	ba 10 00 00 00       	mov    $0x10,%edx
  800724:	eb 98                	jmp    8006be <vprintfmt+0x417>
	else if (lflag)
  800726:	85 c9                	test   %ecx,%ecx
  800728:	75 23                	jne    80074d <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800743:	ba 10 00 00 00       	mov    $0x10,%edx
  800748:	e9 71 ff ff ff       	jmp    8006be <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 40 04             	lea    0x4(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800766:	ba 10 00 00 00       	mov    $0x10,%edx
  80076b:	e9 4e ff ff ff       	jmp    8006be <vprintfmt+0x417>
			putch(ch, putdat);
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	53                   	push   %ebx
  800774:	6a 25                	push   $0x25
  800776:	ff d6                	call   *%esi
			break;
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	e9 5c ff ff ff       	jmp    8006dc <vprintfmt+0x435>
			putch('%', putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	6a 25                	push   $0x25
  800786:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	89 f8                	mov    %edi,%eax
  80078d:	eb 03                	jmp    800792 <vprintfmt+0x4eb>
  80078f:	83 e8 01             	sub    $0x1,%eax
  800792:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800796:	75 f7                	jne    80078f <vprintfmt+0x4e8>
  800798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079b:	e9 3c ff ff ff       	jmp    8006dc <vprintfmt+0x435>
}
  8007a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a3:	5b                   	pop    %ebx
  8007a4:	5e                   	pop    %esi
  8007a5:	5f                   	pop    %edi
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 18             	sub    $0x18,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 26                	je     8007ef <vsnprintf+0x47>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 22                	jle    8007ef <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	ff 75 14             	pushl  0x14(%ebp)
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	68 6d 02 80 00       	push   $0x80026d
  8007dc:	e8 c6 fa ff ff       	call   8002a7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    
		return -E_INVAL;
  8007ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f4:	eb f7                	jmp    8007ed <vsnprintf+0x45>

008007f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007fc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ff:	50                   	push   %eax
  800800:	ff 75 10             	pushl  0x10(%ebp)
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	e8 9a ff ff ff       	call   8007a8 <vsnprintf>
	va_end(ap);

	return rc;
}
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	eb 03                	jmp    800820 <strlen+0x10>
		n++;
  80081d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800820:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800824:	75 f7                	jne    80081d <strlen+0xd>
	return n;
}
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	eb 03                	jmp    80083b <strnlen+0x13>
		n++;
  800838:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083b:	39 d0                	cmp    %edx,%eax
  80083d:	74 06                	je     800845 <strnlen+0x1d>
  80083f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800843:	75 f3                	jne    800838 <strnlen+0x10>
	return n;
}
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800851:	89 c2                	mov    %eax,%edx
  800853:	83 c1 01             	add    $0x1,%ecx
  800856:	83 c2 01             	add    $0x1,%edx
  800859:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80085d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800860:	84 db                	test   %bl,%bl
  800862:	75 ef                	jne    800853 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800864:	5b                   	pop    %ebx
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086e:	53                   	push   %ebx
  80086f:	e8 9c ff ff ff       	call   800810 <strlen>
  800874:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	01 d8                	add    %ebx,%eax
  80087c:	50                   	push   %eax
  80087d:	e8 c5 ff ff ff       	call   800847 <strcpy>
	return dst;
}
  800882:	89 d8                	mov    %ebx,%eax
  800884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	56                   	push   %esi
  80088d:	53                   	push   %ebx
  80088e:	8b 75 08             	mov    0x8(%ebp),%esi
  800891:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800894:	89 f3                	mov    %esi,%ebx
  800896:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800899:	89 f2                	mov    %esi,%edx
  80089b:	eb 0f                	jmp    8008ac <strncpy+0x23>
		*dst++ = *src;
  80089d:	83 c2 01             	add    $0x1,%edx
  8008a0:	0f b6 01             	movzbl (%ecx),%eax
  8008a3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a6:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a9:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008ac:	39 da                	cmp    %ebx,%edx
  8008ae:	75 ed                	jne    80089d <strncpy+0x14>
	}
	return ret;
}
  8008b0:	89 f0                	mov    %esi,%eax
  8008b2:	5b                   	pop    %ebx
  8008b3:	5e                   	pop    %esi
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008c4:	89 f0                	mov    %esi,%eax
  8008c6:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008ca:	85 c9                	test   %ecx,%ecx
  8008cc:	75 0b                	jne    8008d9 <strlcpy+0x23>
  8008ce:	eb 17                	jmp    8008e7 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d0:	83 c2 01             	add    $0x1,%edx
  8008d3:	83 c0 01             	add    $0x1,%eax
  8008d6:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008d9:	39 d8                	cmp    %ebx,%eax
  8008db:	74 07                	je     8008e4 <strlcpy+0x2e>
  8008dd:	0f b6 0a             	movzbl (%edx),%ecx
  8008e0:	84 c9                	test   %cl,%cl
  8008e2:	75 ec                	jne    8008d0 <strlcpy+0x1a>
		*dst = '\0';
  8008e4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e7:	29 f0                	sub    %esi,%eax
}
  8008e9:	5b                   	pop    %ebx
  8008ea:	5e                   	pop    %esi
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f6:	eb 06                	jmp    8008fe <strcmp+0x11>
		p++, q++;
  8008f8:	83 c1 01             	add    $0x1,%ecx
  8008fb:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008fe:	0f b6 01             	movzbl (%ecx),%eax
  800901:	84 c0                	test   %al,%al
  800903:	74 04                	je     800909 <strcmp+0x1c>
  800905:	3a 02                	cmp    (%edx),%al
  800907:	74 ef                	je     8008f8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800909:	0f b6 c0             	movzbl %al,%eax
  80090c:	0f b6 12             	movzbl (%edx),%edx
  80090f:	29 d0                	sub    %edx,%eax
}
  800911:	5d                   	pop    %ebp
  800912:	c3                   	ret    

00800913 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	53                   	push   %ebx
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091d:	89 c3                	mov    %eax,%ebx
  80091f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800922:	eb 06                	jmp    80092a <strncmp+0x17>
		n--, p++, q++;
  800924:	83 c0 01             	add    $0x1,%eax
  800927:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092a:	39 d8                	cmp    %ebx,%eax
  80092c:	74 16                	je     800944 <strncmp+0x31>
  80092e:	0f b6 08             	movzbl (%eax),%ecx
  800931:	84 c9                	test   %cl,%cl
  800933:	74 04                	je     800939 <strncmp+0x26>
  800935:	3a 0a                	cmp    (%edx),%cl
  800937:	74 eb                	je     800924 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800939:	0f b6 00             	movzbl (%eax),%eax
  80093c:	0f b6 12             	movzbl (%edx),%edx
  80093f:	29 d0                	sub    %edx,%eax
}
  800941:	5b                   	pop    %ebx
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    
		return 0;
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	eb f6                	jmp    800941 <strncmp+0x2e>

0080094b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800955:	0f b6 10             	movzbl (%eax),%edx
  800958:	84 d2                	test   %dl,%dl
  80095a:	74 09                	je     800965 <strchr+0x1a>
		if (*s == c)
  80095c:	38 ca                	cmp    %cl,%dl
  80095e:	74 0a                	je     80096a <strchr+0x1f>
	for (; *s; s++)
  800960:	83 c0 01             	add    $0x1,%eax
  800963:	eb f0                	jmp    800955 <strchr+0xa>
			return (char *) s;
	return 0;
  800965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800976:	eb 03                	jmp    80097b <strfind+0xf>
  800978:	83 c0 01             	add    $0x1,%eax
  80097b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80097e:	38 ca                	cmp    %cl,%dl
  800980:	74 04                	je     800986 <strfind+0x1a>
  800982:	84 d2                	test   %dl,%dl
  800984:	75 f2                	jne    800978 <strfind+0xc>
			break;
	return (char *) s;
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	57                   	push   %edi
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800991:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800994:	85 c9                	test   %ecx,%ecx
  800996:	74 13                	je     8009ab <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800998:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099e:	75 05                	jne    8009a5 <memset+0x1d>
  8009a0:	f6 c1 03             	test   $0x3,%cl
  8009a3:	74 0d                	je     8009b2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	fc                   	cld    
  8009a9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ab:	89 f8                	mov    %edi,%eax
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5f                   	pop    %edi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    
		c &= 0xFF;
  8009b2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b6:	89 d3                	mov    %edx,%ebx
  8009b8:	c1 e3 08             	shl    $0x8,%ebx
  8009bb:	89 d0                	mov    %edx,%eax
  8009bd:	c1 e0 18             	shl    $0x18,%eax
  8009c0:	89 d6                	mov    %edx,%esi
  8009c2:	c1 e6 10             	shl    $0x10,%esi
  8009c5:	09 f0                	or     %esi,%eax
  8009c7:	09 c2                	or     %eax,%edx
  8009c9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009cb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	fc                   	cld    
  8009d1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d3:	eb d6                	jmp    8009ab <memset+0x23>

008009d5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	57                   	push   %edi
  8009d9:	56                   	push   %esi
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e3:	39 c6                	cmp    %eax,%esi
  8009e5:	73 35                	jae    800a1c <memmove+0x47>
  8009e7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ea:	39 c2                	cmp    %eax,%edx
  8009ec:	76 2e                	jbe    800a1c <memmove+0x47>
		s += n;
		d += n;
  8009ee:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f1:	89 d6                	mov    %edx,%esi
  8009f3:	09 fe                	or     %edi,%esi
  8009f5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fb:	74 0c                	je     800a09 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009fd:	83 ef 01             	sub    $0x1,%edi
  800a00:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a03:	fd                   	std    
  800a04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a06:	fc                   	cld    
  800a07:	eb 21                	jmp    800a2a <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a09:	f6 c1 03             	test   $0x3,%cl
  800a0c:	75 ef                	jne    8009fd <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0e:	83 ef 04             	sub    $0x4,%edi
  800a11:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a14:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a17:	fd                   	std    
  800a18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1a:	eb ea                	jmp    800a06 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1c:	89 f2                	mov    %esi,%edx
  800a1e:	09 c2                	or     %eax,%edx
  800a20:	f6 c2 03             	test   $0x3,%dl
  800a23:	74 09                	je     800a2e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a25:	89 c7                	mov    %eax,%edi
  800a27:	fc                   	cld    
  800a28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2a:	5e                   	pop    %esi
  800a2b:	5f                   	pop    %edi
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2e:	f6 c1 03             	test   $0x3,%cl
  800a31:	75 f2                	jne    800a25 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a33:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a36:	89 c7                	mov    %eax,%edi
  800a38:	fc                   	cld    
  800a39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3b:	eb ed                	jmp    800a2a <memmove+0x55>

00800a3d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a40:	ff 75 10             	pushl  0x10(%ebp)
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	ff 75 08             	pushl  0x8(%ebp)
  800a49:	e8 87 ff ff ff       	call   8009d5 <memmove>
}
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 c6                	mov    %eax,%esi
  800a5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a60:	39 f0                	cmp    %esi,%eax
  800a62:	74 1c                	je     800a80 <memcmp+0x30>
		if (*s1 != *s2)
  800a64:	0f b6 08             	movzbl (%eax),%ecx
  800a67:	0f b6 1a             	movzbl (%edx),%ebx
  800a6a:	38 d9                	cmp    %bl,%cl
  800a6c:	75 08                	jne    800a76 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	eb ea                	jmp    800a60 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a76:	0f b6 c1             	movzbl %cl,%eax
  800a79:	0f b6 db             	movzbl %bl,%ebx
  800a7c:	29 d8                	sub    %ebx,%eax
  800a7e:	eb 05                	jmp    800a85 <memcmp+0x35>
	}

	return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a92:	89 c2                	mov    %eax,%edx
  800a94:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a97:	39 d0                	cmp    %edx,%eax
  800a99:	73 09                	jae    800aa4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9b:	38 08                	cmp    %cl,(%eax)
  800a9d:	74 05                	je     800aa4 <memfind+0x1b>
	for (; s < ends; s++)
  800a9f:	83 c0 01             	add    $0x1,%eax
  800aa2:	eb f3                	jmp    800a97 <memfind+0xe>
			break;
	return (void *) s;
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	57                   	push   %edi
  800aaa:	56                   	push   %esi
  800aab:	53                   	push   %ebx
  800aac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab2:	eb 03                	jmp    800ab7 <strtol+0x11>
		s++;
  800ab4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab7:	0f b6 01             	movzbl (%ecx),%eax
  800aba:	3c 20                	cmp    $0x20,%al
  800abc:	74 f6                	je     800ab4 <strtol+0xe>
  800abe:	3c 09                	cmp    $0x9,%al
  800ac0:	74 f2                	je     800ab4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac2:	3c 2b                	cmp    $0x2b,%al
  800ac4:	74 2e                	je     800af4 <strtol+0x4e>
	int neg = 0;
  800ac6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800acb:	3c 2d                	cmp    $0x2d,%al
  800acd:	74 2f                	je     800afe <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad5:	75 05                	jne    800adc <strtol+0x36>
  800ad7:	80 39 30             	cmpb   $0x30,(%ecx)
  800ada:	74 2c                	je     800b08 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800adc:	85 db                	test   %ebx,%ebx
  800ade:	75 0a                	jne    800aea <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae0:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ae5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae8:	74 28                	je     800b12 <strtol+0x6c>
		base = 10;
  800aea:	b8 00 00 00 00       	mov    $0x0,%eax
  800aef:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af2:	eb 50                	jmp    800b44 <strtol+0x9e>
		s++;
  800af4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800af7:	bf 00 00 00 00       	mov    $0x0,%edi
  800afc:	eb d1                	jmp    800acf <strtol+0x29>
		s++, neg = 1;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	bf 01 00 00 00       	mov    $0x1,%edi
  800b06:	eb c7                	jmp    800acf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b08:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b0c:	74 0e                	je     800b1c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	75 d8                	jne    800aea <strtol+0x44>
		s++, base = 8;
  800b12:	83 c1 01             	add    $0x1,%ecx
  800b15:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1a:	eb ce                	jmp    800aea <strtol+0x44>
		s += 2, base = 16;
  800b1c:	83 c1 02             	add    $0x2,%ecx
  800b1f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b24:	eb c4                	jmp    800aea <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b26:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b29:	89 f3                	mov    %esi,%ebx
  800b2b:	80 fb 19             	cmp    $0x19,%bl
  800b2e:	77 29                	ja     800b59 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b30:	0f be d2             	movsbl %dl,%edx
  800b33:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b36:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b39:	7d 30                	jge    800b6b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b3b:	83 c1 01             	add    $0x1,%ecx
  800b3e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b42:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b44:	0f b6 11             	movzbl (%ecx),%edx
  800b47:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b4a:	89 f3                	mov    %esi,%ebx
  800b4c:	80 fb 09             	cmp    $0x9,%bl
  800b4f:	77 d5                	ja     800b26 <strtol+0x80>
			dig = *s - '0';
  800b51:	0f be d2             	movsbl %dl,%edx
  800b54:	83 ea 30             	sub    $0x30,%edx
  800b57:	eb dd                	jmp    800b36 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b59:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b5c:	89 f3                	mov    %esi,%ebx
  800b5e:	80 fb 19             	cmp    $0x19,%bl
  800b61:	77 08                	ja     800b6b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b63:	0f be d2             	movsbl %dl,%edx
  800b66:	83 ea 37             	sub    $0x37,%edx
  800b69:	eb cb                	jmp    800b36 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	74 05                	je     800b76 <strtol+0xd0>
		*endptr = (char *) s;
  800b71:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b74:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b76:	89 c2                	mov    %eax,%edx
  800b78:	f7 da                	neg    %edx
  800b7a:	85 ff                	test   %edi,%edi
  800b7c:	0f 45 c2             	cmovne %edx,%eax
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b95:	89 c3                	mov    %eax,%ebx
  800b97:	89 c7                	mov    %eax,%edi
  800b99:	89 c6                	mov    %eax,%esi
  800b9b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bad:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb2:	89 d1                	mov    %edx,%ecx
  800bb4:	89 d3                	mov    %edx,%ebx
  800bb6:	89 d7                	mov    %edx,%edi
  800bb8:	89 d6                	mov    %edx,%esi
  800bba:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5f                   	pop    %edi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	57                   	push   %edi
  800bc5:	56                   	push   %esi
  800bc6:	53                   	push   %ebx
  800bc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd7:	89 cb                	mov    %ecx,%ebx
  800bd9:	89 cf                	mov    %ecx,%edi
  800bdb:	89 ce                	mov    %ecx,%esi
  800bdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdf:	85 c0                	test   %eax,%eax
  800be1:	7f 08                	jg     800beb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800beb:	83 ec 0c             	sub    $0xc,%esp
  800bee:	50                   	push   %eax
  800bef:	6a 03                	push   $0x3
  800bf1:	68 df 2a 80 00       	push   $0x802adf
  800bf6:	6a 23                	push   $0x23
  800bf8:	68 fc 2a 80 00       	push   $0x802afc
  800bfd:	e8 d9 16 00 00       	call   8022db <_panic>

00800c02 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	57                   	push   %edi
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c08:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0d:	b8 02 00 00 00       	mov    $0x2,%eax
  800c12:	89 d1                	mov    %edx,%ecx
  800c14:	89 d3                	mov    %edx,%ebx
  800c16:	89 d7                	mov    %edx,%edi
  800c18:	89 d6                	mov    %edx,%esi
  800c1a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1c:	5b                   	pop    %ebx
  800c1d:	5e                   	pop    %esi
  800c1e:	5f                   	pop    %edi
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <sys_yield>:

void
sys_yield(void)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c31:	89 d1                	mov    %edx,%ecx
  800c33:	89 d3                	mov    %edx,%ebx
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	89 d6                	mov    %edx,%esi
  800c39:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
  800c46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c49:	be 00 00 00 00       	mov    $0x0,%esi
  800c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c54:	b8 04 00 00 00       	mov    $0x4,%eax
  800c59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5c:	89 f7                	mov    %esi,%edi
  800c5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c60:	85 c0                	test   %eax,%eax
  800c62:	7f 08                	jg     800c6c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 04                	push   $0x4
  800c72:	68 df 2a 80 00       	push   $0x802adf
  800c77:	6a 23                	push   $0x23
  800c79:	68 fc 2a 80 00       	push   $0x802afc
  800c7e:	e8 58 16 00 00       	call   8022db <_panic>

00800c83 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	b8 05 00 00 00       	mov    $0x5,%eax
  800c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c9d:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7f 08                	jg     800cae <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	83 ec 0c             	sub    $0xc,%esp
  800cb1:	50                   	push   %eax
  800cb2:	6a 05                	push   $0x5
  800cb4:	68 df 2a 80 00       	push   $0x802adf
  800cb9:	6a 23                	push   $0x23
  800cbb:	68 fc 2a 80 00       	push   $0x802afc
  800cc0:	e8 16 16 00 00       	call   8022db <_panic>

00800cc5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	b8 06 00 00 00       	mov    $0x6,%eax
  800cde:	89 df                	mov    %ebx,%edi
  800ce0:	89 de                	mov    %ebx,%esi
  800ce2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	7f 08                	jg     800cf0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf0:	83 ec 0c             	sub    $0xc,%esp
  800cf3:	50                   	push   %eax
  800cf4:	6a 06                	push   $0x6
  800cf6:	68 df 2a 80 00       	push   $0x802adf
  800cfb:	6a 23                	push   $0x23
  800cfd:	68 fc 2a 80 00       	push   $0x802afc
  800d02:	e8 d4 15 00 00       	call   8022db <_panic>

00800d07 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d20:	89 df                	mov    %ebx,%edi
  800d22:	89 de                	mov    %ebx,%esi
  800d24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7f 08                	jg     800d32 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d32:	83 ec 0c             	sub    $0xc,%esp
  800d35:	50                   	push   %eax
  800d36:	6a 08                	push   $0x8
  800d38:	68 df 2a 80 00       	push   $0x802adf
  800d3d:	6a 23                	push   $0x23
  800d3f:	68 fc 2a 80 00       	push   $0x802afc
  800d44:	e8 92 15 00 00       	call   8022db <_panic>

00800d49 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	b8 09 00 00 00       	mov    $0x9,%eax
  800d62:	89 df                	mov    %ebx,%edi
  800d64:	89 de                	mov    %ebx,%esi
  800d66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d68:	85 c0                	test   %eax,%eax
  800d6a:	7f 08                	jg     800d74 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 09                	push   $0x9
  800d7a:	68 df 2a 80 00       	push   $0x802adf
  800d7f:	6a 23                	push   $0x23
  800d81:	68 fc 2a 80 00       	push   $0x802afc
  800d86:	e8 50 15 00 00       	call   8022db <_panic>

00800d8b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da4:	89 df                	mov    %ebx,%edi
  800da6:	89 de                	mov    %ebx,%esi
  800da8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 0a                	push   $0xa
  800dbc:	68 df 2a 80 00       	push   $0x802adf
  800dc1:	6a 23                	push   $0x23
  800dc3:	68 fc 2a 80 00       	push   $0x802afc
  800dc8:	e8 0e 15 00 00       	call   8022db <_panic>

00800dcd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dde:	be 00 00 00 00       	mov    $0x0,%esi
  800de3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e06:	89 cb                	mov    %ecx,%ebx
  800e08:	89 cf                	mov    %ecx,%edi
  800e0a:	89 ce                	mov    %ecx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 0d                	push   $0xd
  800e20:	68 df 2a 80 00       	push   $0x802adf
  800e25:	6a 23                	push   $0x23
  800e27:	68 fc 2a 80 00       	push   $0x802afc
  800e2c:	e8 aa 14 00 00       	call   8022db <_panic>

00800e31 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e37:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e41:	89 d1                	mov    %edx,%ecx
  800e43:	89 d3                	mov    %edx,%ebx
  800e45:	89 d7                	mov    %edx,%edi
  800e47:	89 d6                	mov    %edx,%esi
  800e49:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 1c             	sub    $0x1c,%esp
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
    void *addr = (void *) utf->utf_fault_va;
  800e5c:	8b 18                	mov    (%eax),%ebx
    uint32_t err = utf->utf_err;
  800e5e:	8b 78 04             	mov    0x4(%eax),%edi
    pte_t pte = uvpt[PGNUM(addr)];
  800e61:	89 d8                	mov    %ebx,%eax
  800e63:	c1 e8 0c             	shr    $0xc,%eax
  800e66:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    envid_t envid = sys_getenvid();
  800e70:	e8 8d fd ff ff       	call   800c02 <sys_getenvid>
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0 || (pte & PTE_COW) == 0) {
  800e75:	f7 c7 02 00 00 00    	test   $0x2,%edi
  800e7b:	74 73                	je     800ef0 <pgfault+0xa0>
  800e7d:	89 c6                	mov    %eax,%esi
  800e7f:	f7 45 e4 00 08 00 00 	testl  $0x800,-0x1c(%ebp)
  800e86:	74 68                	je     800ef0 <pgfault+0xa0>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(envid, PFTEMP, PTE_W | PTE_U | PTE_P)) != 0) {
  800e88:	83 ec 04             	sub    $0x4,%esp
  800e8b:	6a 07                	push   $0x7
  800e8d:	68 00 f0 7f 00       	push   $0x7ff000
  800e92:	50                   	push   %eax
  800e93:	e8 a8 fd ff ff       	call   800c40 <sys_page_alloc>
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 65                	jne    800f04 <pgfault+0xb4>
	    panic("pgfault: %e", r);
	}
	memcpy(PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  800e9f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  800ea5:	83 ec 04             	sub    $0x4,%esp
  800ea8:	68 00 10 00 00       	push   $0x1000
  800ead:	53                   	push   %ebx
  800eae:	68 00 f0 7f 00       	push   $0x7ff000
  800eb3:	e8 85 fb ff ff       	call   800a3d <memcpy>
	if ((r = sys_page_map(envid, PFTEMP, envid, ROUNDDOWN(addr, PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800eb8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ebf:	53                   	push   %ebx
  800ec0:	56                   	push   %esi
  800ec1:	68 00 f0 7f 00       	push   $0x7ff000
  800ec6:	56                   	push   %esi
  800ec7:	e8 b7 fd ff ff       	call   800c83 <sys_page_map>
  800ecc:	83 c4 20             	add    $0x20,%esp
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	75 43                	jne    800f16 <pgfault+0xc6>
	    panic("pgfault: %e", r);
	}
	if ((r = sys_page_unmap(envid, PFTEMP)) != 0) {
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	68 00 f0 7f 00       	push   $0x7ff000
  800edb:	56                   	push   %esi
  800edc:	e8 e4 fd ff ff       	call   800cc5 <sys_page_unmap>
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	75 40                	jne    800f28 <pgfault+0xd8>
	    panic("pgfault: %e", r);
	}
}
  800ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    
	    panic("pgfault: bad faulting access\n");
  800ef0:	83 ec 04             	sub    $0x4,%esp
  800ef3:	68 0a 2b 80 00       	push   $0x802b0a
  800ef8:	6a 1f                	push   $0x1f
  800efa:	68 28 2b 80 00       	push   $0x802b28
  800eff:	e8 d7 13 00 00       	call   8022db <_panic>
	    panic("pgfault: %e", r);
  800f04:	50                   	push   %eax
  800f05:	68 33 2b 80 00       	push   $0x802b33
  800f0a:	6a 2a                	push   $0x2a
  800f0c:	68 28 2b 80 00       	push   $0x802b28
  800f11:	e8 c5 13 00 00       	call   8022db <_panic>
	    panic("pgfault: %e", r);
  800f16:	50                   	push   %eax
  800f17:	68 33 2b 80 00       	push   $0x802b33
  800f1c:	6a 2e                	push   $0x2e
  800f1e:	68 28 2b 80 00       	push   $0x802b28
  800f23:	e8 b3 13 00 00       	call   8022db <_panic>
	    panic("pgfault: %e", r);
  800f28:	50                   	push   %eax
  800f29:	68 33 2b 80 00       	push   $0x802b33
  800f2e:	6a 31                	push   $0x31
  800f30:	68 28 2b 80 00       	push   $0x802b28
  800f35:	e8 a1 13 00 00       	call   8022db <_panic>

00800f3a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	envid_t envid;
	uint32_t addr;
	int r;

	set_pgfault_handler(pgfault);
  800f43:	68 50 0e 80 00       	push   $0x800e50
  800f48:	e8 d4 13 00 00       	call   802321 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f4d:	b8 07 00 00 00       	mov    $0x7,%eax
  800f52:	cd 30                	int    $0x30
  800f54:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f57:	89 45 e0             	mov    %eax,-0x20(%ebp)
	envid = sys_exofork();
	if (envid < 0) {
  800f5a:	83 c4 10             	add    $0x10,%esp
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	78 2b                	js     800f8c <fork+0x52>
	    thisenv = &envs[ENVX(sys_getenvid())];
	    return 0;
	}

	// copy the address space mappings to child
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
	if (envid == 0) {
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	0f 85 b5 00 00 00    	jne    801025 <fork+0xeb>
	    thisenv = &envs[ENVX(sys_getenvid())];
  800f70:	e8 8d fc ff ff       	call   800c02 <sys_getenvid>
  800f75:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f7a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f7d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f82:	a3 08 40 80 00       	mov    %eax,0x804008
	    return 0;
  800f87:	e9 8c 01 00 00       	jmp    801118 <fork+0x1de>
	    panic("sys_exofork: %e", envid);
  800f8c:	50                   	push   %eax
  800f8d:	68 3f 2b 80 00       	push   $0x802b3f
  800f92:	6a 77                	push   $0x77
  800f94:	68 28 2b 80 00       	push   $0x802b28
  800f99:	e8 3d 13 00 00       	call   8022db <_panic>
        if ((r = sys_page_map(parent_envid, va, envid, va, uvpt[pn] & PTE_SYSCALL)) != 0) {
  800f9e:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  800fa5:	83 ec 0c             	sub    $0xc,%esp
  800fa8:	25 07 0e 00 00       	and    $0xe07,%eax
  800fad:	50                   	push   %eax
  800fae:	57                   	push   %edi
  800faf:	ff 75 e0             	pushl  -0x20(%ebp)
  800fb2:	57                   	push   %edi
  800fb3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fb6:	e8 c8 fc ff ff       	call   800c83 <sys_page_map>
  800fbb:	83 c4 20             	add    $0x20,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	74 51                	je     801013 <fork+0xd9>
           panic("duppage: %e", r);
  800fc2:	50                   	push   %eax
  800fc3:	68 4f 2b 80 00       	push   $0x802b4f
  800fc8:	6a 4a                	push   $0x4a
  800fca:	68 28 2b 80 00       	push   $0x802b28
  800fcf:	e8 07 13 00 00       	call   8022db <_panic>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	68 05 08 00 00       	push   $0x805
  800fdc:	57                   	push   %edi
  800fdd:	ff 75 e0             	pushl  -0x20(%ebp)
  800fe0:	57                   	push   %edi
  800fe1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe4:	e8 9a fc ff ff       	call   800c83 <sys_page_map>
  800fe9:	83 c4 20             	add    $0x20,%esp
  800fec:	85 c0                	test   %eax,%eax
  800fee:	0f 85 bc 00 00 00    	jne    8010b0 <fork+0x176>
	    if ((r = sys_page_map(parent_envid, va, parent_envid, va, PTE_COW | PTE_U | PTE_P)) != 0) {
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	68 05 08 00 00       	push   $0x805
  800ffc:	57                   	push   %edi
  800ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801000:	50                   	push   %eax
  801001:	57                   	push   %edi
  801002:	50                   	push   %eax
  801003:	e8 7b fc ff ff       	call   800c83 <sys_page_map>
  801008:	83 c4 20             	add    $0x20,%esp
  80100b:	85 c0                	test   %eax,%eax
  80100d:	0f 85 af 00 00 00    	jne    8010c2 <fork+0x188>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801013:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801019:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80101f:	0f 84 af 00 00 00    	je     8010d4 <fork+0x19a>
	    if ((uvpd[PDX(addr)] & PTE_P) == PTE_P && (uvpt[PGNUM(addr)] & PTE_P) == PTE_P) {
  801025:	89 d8                	mov    %ebx,%eax
  801027:	c1 e8 16             	shr    $0x16,%eax
  80102a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801031:	a8 01                	test   $0x1,%al
  801033:	74 de                	je     801013 <fork+0xd9>
  801035:	89 de                	mov    %ebx,%esi
  801037:	c1 ee 0c             	shr    $0xc,%esi
  80103a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801041:	a8 01                	test   $0x1,%al
  801043:	74 ce                	je     801013 <fork+0xd9>
	envid_t parent_envid = sys_getenvid();
  801045:	e8 b8 fb ff ff       	call   800c02 <sys_getenvid>
  80104a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	void *va = (void *)(pn * PGSIZE);
  80104d:	89 f7                	mov    %esi,%edi
  80104f:	c1 e7 0c             	shl    $0xc,%edi
	if ((uvpt[pn] & PTE_SHARE) == PTE_SHARE) {
  801052:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801059:	f6 c4 04             	test   $0x4,%ah
  80105c:	0f 85 3c ff ff ff    	jne    800f9e <fork+0x64>
    } else if ((uvpt[pn] & PTE_W) == PTE_W || (uvpt[pn] & PTE_COW) == PTE_COW) {
  801062:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801069:	a8 02                	test   $0x2,%al
  80106b:	0f 85 63 ff ff ff    	jne    800fd4 <fork+0x9a>
  801071:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801078:	f6 c4 08             	test   $0x8,%ah
  80107b:	0f 85 53 ff ff ff    	jne    800fd4 <fork+0x9a>
	    if ((r = sys_page_map(parent_envid, va, envid, va, PTE_U | PTE_P)) != 0) {
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	6a 05                	push   $0x5
  801086:	57                   	push   %edi
  801087:	ff 75 e0             	pushl  -0x20(%ebp)
  80108a:	57                   	push   %edi
  80108b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80108e:	e8 f0 fb ff ff       	call   800c83 <sys_page_map>
  801093:	83 c4 20             	add    $0x20,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	0f 84 75 ff ff ff    	je     801013 <fork+0xd9>
	        panic("duppage: %e", r);
  80109e:	50                   	push   %eax
  80109f:	68 4f 2b 80 00       	push   $0x802b4f
  8010a4:	6a 55                	push   $0x55
  8010a6:	68 28 2b 80 00       	push   $0x802b28
  8010ab:	e8 2b 12 00 00       	call   8022db <_panic>
	        panic("duppage: %e", r);
  8010b0:	50                   	push   %eax
  8010b1:	68 4f 2b 80 00       	push   $0x802b4f
  8010b6:	6a 4e                	push   $0x4e
  8010b8:	68 28 2b 80 00       	push   $0x802b28
  8010bd:	e8 19 12 00 00       	call   8022db <_panic>
	        panic("duppage: %e", r);
  8010c2:	50                   	push   %eax
  8010c3:	68 4f 2b 80 00       	push   $0x802b4f
  8010c8:	6a 51                	push   $0x51
  8010ca:	68 28 2b 80 00       	push   $0x802b28
  8010cf:	e8 07 12 00 00       	call   8022db <_panic>
	}

	// allocate new page for child's user exception stack
	void _pgfault_upcall();

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  8010d4:	83 ec 04             	sub    $0x4,%esp
  8010d7:	6a 07                	push   $0x7
  8010d9:	68 00 f0 bf ee       	push   $0xeebff000
  8010de:	ff 75 dc             	pushl  -0x24(%ebp)
  8010e1:	e8 5a fb ff ff       	call   800c40 <sys_page_alloc>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	75 36                	jne    801123 <fork+0x1e9>
	    panic("fork: %e", r);
	}
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) != 0) {
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	68 9a 23 80 00       	push   $0x80239a
  8010f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8010f8:	e8 8e fc ff ff       	call   800d8b <sys_env_set_pgfault_upcall>
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	75 34                	jne    801138 <fork+0x1fe>
	    panic("fork: %e", r);
	}

	// mark the child as runnable
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) != 0)
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	6a 02                	push   $0x2
  801109:	ff 75 dc             	pushl  -0x24(%ebp)
  80110c:	e8 f6 fb ff ff       	call   800d07 <sys_env_set_status>
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	75 35                	jne    80114d <fork+0x213>
	    panic("fork: %e", r);

	return envid;
}
  801118:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80111b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111e:	5b                   	pop    %ebx
  80111f:	5e                   	pop    %esi
  801120:	5f                   	pop    %edi
  801121:	5d                   	pop    %ebp
  801122:	c3                   	ret    
	    panic("fork: %e", r);
  801123:	50                   	push   %eax
  801124:	68 46 2b 80 00       	push   $0x802b46
  801129:	68 8a 00 00 00       	push   $0x8a
  80112e:	68 28 2b 80 00       	push   $0x802b28
  801133:	e8 a3 11 00 00       	call   8022db <_panic>
	    panic("fork: %e", r);
  801138:	50                   	push   %eax
  801139:	68 46 2b 80 00       	push   $0x802b46
  80113e:	68 8d 00 00 00       	push   $0x8d
  801143:	68 28 2b 80 00       	push   $0x802b28
  801148:	e8 8e 11 00 00       	call   8022db <_panic>
	    panic("fork: %e", r);
  80114d:	50                   	push   %eax
  80114e:	68 46 2b 80 00       	push   $0x802b46
  801153:	68 92 00 00 00       	push   $0x92
  801158:	68 28 2b 80 00       	push   $0x802b28
  80115d:	e8 79 11 00 00       	call   8022db <_panic>

00801162 <sfork>:

// Challenge!
int
sfork(void)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801168:	68 5b 2b 80 00       	push   $0x802b5b
  80116d:	68 9b 00 00 00       	push   $0x9b
  801172:	68 28 2b 80 00       	push   $0x802b28
  801177:	e8 5f 11 00 00       	call   8022db <_panic>

0080117c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	05 00 00 00 30       	add    $0x30000000,%eax
  801187:	c1 e8 0c             	shr    $0xc,%eax
}
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	c1 ea 16             	shr    $0x16,%edx
  8011b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ba:	f6 c2 01             	test   $0x1,%dl
  8011bd:	74 2a                	je     8011e9 <fd_alloc+0x46>
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	c1 ea 0c             	shr    $0xc,%edx
  8011c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011cb:	f6 c2 01             	test   $0x1,%dl
  8011ce:	74 19                	je     8011e9 <fd_alloc+0x46>
  8011d0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011d5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011da:	75 d2                	jne    8011ae <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011dc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011e2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e7:	eb 07                	jmp    8011f0 <fd_alloc+0x4d>
			*fd_store = fd;
  8011e9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011f8:	83 f8 1f             	cmp    $0x1f,%eax
  8011fb:	77 36                	ja     801233 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011fd:	c1 e0 0c             	shl    $0xc,%eax
  801200:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801205:	89 c2                	mov    %eax,%edx
  801207:	c1 ea 16             	shr    $0x16,%edx
  80120a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801211:	f6 c2 01             	test   $0x1,%dl
  801214:	74 24                	je     80123a <fd_lookup+0x48>
  801216:	89 c2                	mov    %eax,%edx
  801218:	c1 ea 0c             	shr    $0xc,%edx
  80121b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801222:	f6 c2 01             	test   $0x1,%dl
  801225:	74 1a                	je     801241 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122a:	89 02                	mov    %eax,(%edx)
	return 0;
  80122c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    
		return -E_INVAL;
  801233:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801238:	eb f7                	jmp    801231 <fd_lookup+0x3f>
		return -E_INVAL;
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123f:	eb f0                	jmp    801231 <fd_lookup+0x3f>
  801241:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801246:	eb e9                	jmp    801231 <fd_lookup+0x3f>

00801248 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801251:	ba f0 2b 80 00       	mov    $0x802bf0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801256:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80125b:	39 08                	cmp    %ecx,(%eax)
  80125d:	74 33                	je     801292 <dev_lookup+0x4a>
  80125f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801262:	8b 02                	mov    (%edx),%eax
  801264:	85 c0                	test   %eax,%eax
  801266:	75 f3                	jne    80125b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801268:	a1 08 40 80 00       	mov    0x804008,%eax
  80126d:	8b 40 48             	mov    0x48(%eax),%eax
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	51                   	push   %ecx
  801274:	50                   	push   %eax
  801275:	68 74 2b 80 00       	push   $0x802b74
  80127a:	e8 2b ef ff ff       	call   8001aa <cprintf>
	*dev = 0;
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    
			*dev = devtab[i];
  801292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801295:	89 01                	mov    %eax,(%ecx)
			return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
  80129c:	eb f2                	jmp    801290 <dev_lookup+0x48>

0080129e <fd_close>:
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	57                   	push   %edi
  8012a2:	56                   	push   %esi
  8012a3:	53                   	push   %ebx
  8012a4:	83 ec 1c             	sub    $0x1c,%esp
  8012a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012b7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ba:	50                   	push   %eax
  8012bb:	e8 32 ff ff ff       	call   8011f2 <fd_lookup>
  8012c0:	89 c3                	mov    %eax,%ebx
  8012c2:	83 c4 08             	add    $0x8,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 05                	js     8012ce <fd_close+0x30>
	    || fd != fd2)
  8012c9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012cc:	74 16                	je     8012e4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012ce:	89 f8                	mov    %edi,%eax
  8012d0:	84 c0                	test   %al,%al
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d7:	0f 44 d8             	cmove  %eax,%ebx
}
  8012da:	89 d8                	mov    %ebx,%eax
  8012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	5f                   	pop    %edi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ea:	50                   	push   %eax
  8012eb:	ff 36                	pushl  (%esi)
  8012ed:	e8 56 ff ff ff       	call   801248 <dev_lookup>
  8012f2:	89 c3                	mov    %eax,%ebx
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 15                	js     801310 <fd_close+0x72>
		if (dev->dev_close)
  8012fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012fe:	8b 40 10             	mov    0x10(%eax),%eax
  801301:	85 c0                	test   %eax,%eax
  801303:	74 1b                	je     801320 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	56                   	push   %esi
  801309:	ff d0                	call   *%eax
  80130b:	89 c3                	mov    %eax,%ebx
  80130d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801310:	83 ec 08             	sub    $0x8,%esp
  801313:	56                   	push   %esi
  801314:	6a 00                	push   $0x0
  801316:	e8 aa f9 ff ff       	call   800cc5 <sys_page_unmap>
	return r;
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	eb ba                	jmp    8012da <fd_close+0x3c>
			r = 0;
  801320:	bb 00 00 00 00       	mov    $0x0,%ebx
  801325:	eb e9                	jmp    801310 <fd_close+0x72>

00801327 <close>:

int
close(int fdnum)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80132d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801330:	50                   	push   %eax
  801331:	ff 75 08             	pushl  0x8(%ebp)
  801334:	e8 b9 fe ff ff       	call   8011f2 <fd_lookup>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	78 10                	js     801350 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	6a 01                	push   $0x1
  801345:	ff 75 f4             	pushl  -0xc(%ebp)
  801348:	e8 51 ff ff ff       	call   80129e <fd_close>
  80134d:	83 c4 10             	add    $0x10,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <close_all>:

void
close_all(void)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	53                   	push   %ebx
  801356:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801359:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	53                   	push   %ebx
  801362:	e8 c0 ff ff ff       	call   801327 <close>
	for (i = 0; i < MAXFD; i++)
  801367:	83 c3 01             	add    $0x1,%ebx
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	83 fb 20             	cmp    $0x20,%ebx
  801370:	75 ec                	jne    80135e <close_all+0xc>
}
  801372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	57                   	push   %edi
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801380:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	e8 66 fe ff ff       	call   8011f2 <fd_lookup>
  80138c:	89 c3                	mov    %eax,%ebx
  80138e:	83 c4 08             	add    $0x8,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	0f 88 81 00 00 00    	js     80141a <dup+0xa3>
		return r;
	close(newfdnum);
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	e8 83 ff ff ff       	call   801327 <close>

	newfd = INDEX2FD(newfdnum);
  8013a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013a7:	c1 e6 0c             	shl    $0xc,%esi
  8013aa:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b0:	83 c4 04             	add    $0x4,%esp
  8013b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b6:	e8 d1 fd ff ff       	call   80118c <fd2data>
  8013bb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013bd:	89 34 24             	mov    %esi,(%esp)
  8013c0:	e8 c7 fd ff ff       	call   80118c <fd2data>
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013ca:	89 d8                	mov    %ebx,%eax
  8013cc:	c1 e8 16             	shr    $0x16,%eax
  8013cf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d6:	a8 01                	test   $0x1,%al
  8013d8:	74 11                	je     8013eb <dup+0x74>
  8013da:	89 d8                	mov    %ebx,%eax
  8013dc:	c1 e8 0c             	shr    $0xc,%eax
  8013df:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e6:	f6 c2 01             	test   $0x1,%dl
  8013e9:	75 39                	jne    801424 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ee:	89 d0                	mov    %edx,%eax
  8013f0:	c1 e8 0c             	shr    $0xc,%eax
  8013f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	25 07 0e 00 00       	and    $0xe07,%eax
  801402:	50                   	push   %eax
  801403:	56                   	push   %esi
  801404:	6a 00                	push   $0x0
  801406:	52                   	push   %edx
  801407:	6a 00                	push   $0x0
  801409:	e8 75 f8 ff ff       	call   800c83 <sys_page_map>
  80140e:	89 c3                	mov    %eax,%ebx
  801410:	83 c4 20             	add    $0x20,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	78 31                	js     801448 <dup+0xd1>
		goto err;

	return newfdnum;
  801417:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141a:	89 d8                	mov    %ebx,%eax
  80141c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141f:	5b                   	pop    %ebx
  801420:	5e                   	pop    %esi
  801421:	5f                   	pop    %edi
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801424:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142b:	83 ec 0c             	sub    $0xc,%esp
  80142e:	25 07 0e 00 00       	and    $0xe07,%eax
  801433:	50                   	push   %eax
  801434:	57                   	push   %edi
  801435:	6a 00                	push   $0x0
  801437:	53                   	push   %ebx
  801438:	6a 00                	push   $0x0
  80143a:	e8 44 f8 ff ff       	call   800c83 <sys_page_map>
  80143f:	89 c3                	mov    %eax,%ebx
  801441:	83 c4 20             	add    $0x20,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	79 a3                	jns    8013eb <dup+0x74>
	sys_page_unmap(0, newfd);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	56                   	push   %esi
  80144c:	6a 00                	push   $0x0
  80144e:	e8 72 f8 ff ff       	call   800cc5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801453:	83 c4 08             	add    $0x8,%esp
  801456:	57                   	push   %edi
  801457:	6a 00                	push   $0x0
  801459:	e8 67 f8 ff ff       	call   800cc5 <sys_page_unmap>
	return r;
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	eb b7                	jmp    80141a <dup+0xa3>

00801463 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	53                   	push   %ebx
  801467:	83 ec 14             	sub    $0x14,%esp
  80146a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801470:	50                   	push   %eax
  801471:	53                   	push   %ebx
  801472:	e8 7b fd ff ff       	call   8011f2 <fd_lookup>
  801477:	83 c4 08             	add    $0x8,%esp
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 3f                	js     8014bd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801484:	50                   	push   %eax
  801485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801488:	ff 30                	pushl  (%eax)
  80148a:	e8 b9 fd ff ff       	call   801248 <dev_lookup>
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	78 27                	js     8014bd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801496:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801499:	8b 42 08             	mov    0x8(%edx),%eax
  80149c:	83 e0 03             	and    $0x3,%eax
  80149f:	83 f8 01             	cmp    $0x1,%eax
  8014a2:	74 1e                	je     8014c2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a7:	8b 40 08             	mov    0x8(%eax),%eax
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	74 35                	je     8014e3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ae:	83 ec 04             	sub    $0x4,%esp
  8014b1:	ff 75 10             	pushl  0x10(%ebp)
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	52                   	push   %edx
  8014b8:	ff d0                	call   *%eax
  8014ba:	83 c4 10             	add    $0x10,%esp
}
  8014bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c2:	a1 08 40 80 00       	mov    0x804008,%eax
  8014c7:	8b 40 48             	mov    0x48(%eax),%eax
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	53                   	push   %ebx
  8014ce:	50                   	push   %eax
  8014cf:	68 b5 2b 80 00       	push   $0x802bb5
  8014d4:	e8 d1 ec ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e1:	eb da                	jmp    8014bd <read+0x5a>
		return -E_NOT_SUPP;
  8014e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e8:	eb d3                	jmp    8014bd <read+0x5a>

008014ea <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	57                   	push   %edi
  8014ee:	56                   	push   %esi
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 0c             	sub    $0xc,%esp
  8014f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fe:	39 f3                	cmp    %esi,%ebx
  801500:	73 25                	jae    801527 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	89 f0                	mov    %esi,%eax
  801507:	29 d8                	sub    %ebx,%eax
  801509:	50                   	push   %eax
  80150a:	89 d8                	mov    %ebx,%eax
  80150c:	03 45 0c             	add    0xc(%ebp),%eax
  80150f:	50                   	push   %eax
  801510:	57                   	push   %edi
  801511:	e8 4d ff ff ff       	call   801463 <read>
		if (m < 0)
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 08                	js     801525 <readn+0x3b>
			return m;
		if (m == 0)
  80151d:	85 c0                	test   %eax,%eax
  80151f:	74 06                	je     801527 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801521:	01 c3                	add    %eax,%ebx
  801523:	eb d9                	jmp    8014fe <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801525:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801527:	89 d8                	mov    %ebx,%eax
  801529:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152c:	5b                   	pop    %ebx
  80152d:	5e                   	pop    %esi
  80152e:	5f                   	pop    %edi
  80152f:	5d                   	pop    %ebp
  801530:	c3                   	ret    

00801531 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	53                   	push   %ebx
  801535:	83 ec 14             	sub    $0x14,%esp
  801538:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	53                   	push   %ebx
  801540:	e8 ad fc ff ff       	call   8011f2 <fd_lookup>
  801545:	83 c4 08             	add    $0x8,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 3a                	js     801586 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801552:	50                   	push   %eax
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	ff 30                	pushl  (%eax)
  801558:	e8 eb fc ff ff       	call   801248 <dev_lookup>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 22                	js     801586 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801567:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156b:	74 1e                	je     80158b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80156d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801570:	8b 52 0c             	mov    0xc(%edx),%edx
  801573:	85 d2                	test   %edx,%edx
  801575:	74 35                	je     8015ac <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	50                   	push   %eax
  801581:	ff d2                	call   *%edx
  801583:	83 c4 10             	add    $0x10,%esp
}
  801586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801589:	c9                   	leave  
  80158a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80158b:	a1 08 40 80 00       	mov    0x804008,%eax
  801590:	8b 40 48             	mov    0x48(%eax),%eax
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	53                   	push   %ebx
  801597:	50                   	push   %eax
  801598:	68 d1 2b 80 00       	push   $0x802bd1
  80159d:	e8 08 ec ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015aa:	eb da                	jmp    801586 <write+0x55>
		return -E_NOT_SUPP;
  8015ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b1:	eb d3                	jmp    801586 <write+0x55>

008015b3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b9:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015bc:	50                   	push   %eax
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	e8 2d fc ff ff       	call   8011f2 <fd_lookup>
  8015c5:	83 c4 08             	add    $0x8,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 0e                	js     8015da <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 14             	sub    $0x14,%esp
  8015e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e9:	50                   	push   %eax
  8015ea:	53                   	push   %ebx
  8015eb:	e8 02 fc ff ff       	call   8011f2 <fd_lookup>
  8015f0:	83 c4 08             	add    $0x8,%esp
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 37                	js     80162e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fd:	50                   	push   %eax
  8015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801601:	ff 30                	pushl  (%eax)
  801603:	e8 40 fc ff ff       	call   801248 <dev_lookup>
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 1f                	js     80162e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801616:	74 1b                	je     801633 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161b:	8b 52 18             	mov    0x18(%edx),%edx
  80161e:	85 d2                	test   %edx,%edx
  801620:	74 32                	je     801654 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	50                   	push   %eax
  801629:	ff d2                	call   *%edx
  80162b:	83 c4 10             	add    $0x10,%esp
}
  80162e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801631:	c9                   	leave  
  801632:	c3                   	ret    
			thisenv->env_id, fdnum);
  801633:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801638:	8b 40 48             	mov    0x48(%eax),%eax
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	53                   	push   %ebx
  80163f:	50                   	push   %eax
  801640:	68 94 2b 80 00       	push   $0x802b94
  801645:	e8 60 eb ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801652:	eb da                	jmp    80162e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801654:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801659:	eb d3                	jmp    80162e <ftruncate+0x52>

0080165b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 14             	sub    $0x14,%esp
  801662:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801665:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801668:	50                   	push   %eax
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	e8 81 fb ff ff       	call   8011f2 <fd_lookup>
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	85 c0                	test   %eax,%eax
  801676:	78 4b                	js     8016c3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	ff 30                	pushl  (%eax)
  801684:	e8 bf fb ff ff       	call   801248 <dev_lookup>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 33                	js     8016c3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801697:	74 2f                	je     8016c8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801699:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a3:	00 00 00 
	stat->st_isdir = 0;
  8016a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ad:	00 00 00 
	stat->st_dev = dev;
  8016b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	53                   	push   %ebx
  8016ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8016bd:	ff 50 14             	call   *0x14(%eax)
  8016c0:	83 c4 10             	add    $0x10,%esp
}
  8016c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cd:	eb f4                	jmp    8016c3 <fstat+0x68>

008016cf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d4:	83 ec 08             	sub    $0x8,%esp
  8016d7:	6a 00                	push   $0x0
  8016d9:	ff 75 08             	pushl  0x8(%ebp)
  8016dc:	e8 26 02 00 00       	call   801907 <open>
  8016e1:	89 c3                	mov    %eax,%ebx
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 1b                	js     801705 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	50                   	push   %eax
  8016f1:	e8 65 ff ff ff       	call   80165b <fstat>
  8016f6:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f8:	89 1c 24             	mov    %ebx,(%esp)
  8016fb:	e8 27 fc ff ff       	call   801327 <close>
	return r;
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 f3                	mov    %esi,%ebx
}
  801705:	89 d8                	mov    %ebx,%eax
  801707:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5e                   	pop    %esi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	56                   	push   %esi
  801712:	53                   	push   %ebx
  801713:	89 c6                	mov    %eax,%esi
  801715:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801717:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80171e:	74 27                	je     801747 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801720:	6a 07                	push   $0x7
  801722:	68 00 50 80 00       	push   $0x805000
  801727:	56                   	push   %esi
  801728:	ff 35 00 40 80 00    	pushl  0x804000
  80172e:	e8 f6 0c 00 00       	call   802429 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801733:	83 c4 0c             	add    $0xc,%esp
  801736:	6a 00                	push   $0x0
  801738:	53                   	push   %ebx
  801739:	6a 00                	push   $0x0
  80173b:	e8 80 0c 00 00       	call   8023c0 <ipc_recv>
}
  801740:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	6a 01                	push   $0x1
  80174c:	e8 31 0d 00 00       	call   802482 <ipc_find_env>
  801751:	a3 00 40 80 00       	mov    %eax,0x804000
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	eb c5                	jmp    801720 <fsipc+0x12>

0080175b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8b 40 0c             	mov    0xc(%eax),%eax
  801767:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801774:	ba 00 00 00 00       	mov    $0x0,%edx
  801779:	b8 02 00 00 00       	mov    $0x2,%eax
  80177e:	e8 8b ff ff ff       	call   80170e <fsipc>
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <devfile_flush>:
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8b 40 0c             	mov    0xc(%eax),%eax
  801791:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a0:	e8 69 ff ff ff       	call   80170e <fsipc>
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <devfile_stat>:
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c1:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c6:	e8 43 ff ff ff       	call   80170e <fsipc>
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 2c                	js     8017fb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	68 00 50 80 00       	push   $0x805000
  8017d7:	53                   	push   %ebx
  8017d8:	e8 6a f0 ff ff       	call   800847 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017dd:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017e8:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ed:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <devfile_write>:
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 40 0c             	mov    0xc(%eax),%eax
  801810:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801815:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80181b:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801821:	77 30                	ja     801853 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	53                   	push   %ebx
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	68 08 50 80 00       	push   $0x805008
  80182f:	e8 a1 f1 ff ff       	call   8009d5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801834:	ba 00 00 00 00       	mov    $0x0,%edx
  801839:	b8 04 00 00 00       	mov    $0x4,%eax
  80183e:	e8 cb fe ff ff       	call   80170e <fsipc>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	85 c0                	test   %eax,%eax
  801848:	78 04                	js     80184e <devfile_write+0x4e>
	assert(r <= n);
  80184a:	39 d8                	cmp    %ebx,%eax
  80184c:	77 1e                	ja     80186c <devfile_write+0x6c>
}
  80184e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801851:	c9                   	leave  
  801852:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801853:	68 04 2c 80 00       	push   $0x802c04
  801858:	68 31 2c 80 00       	push   $0x802c31
  80185d:	68 94 00 00 00       	push   $0x94
  801862:	68 46 2c 80 00       	push   $0x802c46
  801867:	e8 6f 0a 00 00       	call   8022db <_panic>
	assert(r <= n);
  80186c:	68 51 2c 80 00       	push   $0x802c51
  801871:	68 31 2c 80 00       	push   $0x802c31
  801876:	68 98 00 00 00       	push   $0x98
  80187b:	68 46 2c 80 00       	push   $0x802c46
  801880:	e8 56 0a 00 00       	call   8022db <_panic>

00801885 <devfile_read>:
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
  80188a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	8b 40 0c             	mov    0xc(%eax),%eax
  801893:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801898:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a8:	e8 61 fe ff ff       	call   80170e <fsipc>
  8018ad:	89 c3                	mov    %eax,%ebx
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	78 1f                	js     8018d2 <devfile_read+0x4d>
	assert(r <= n);
  8018b3:	39 f0                	cmp    %esi,%eax
  8018b5:	77 24                	ja     8018db <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018b7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018bc:	7f 33                	jg     8018f1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	50                   	push   %eax
  8018c2:	68 00 50 80 00       	push   $0x805000
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	e8 06 f1 ff ff       	call   8009d5 <memmove>
	return r;
  8018cf:	83 c4 10             	add    $0x10,%esp
}
  8018d2:	89 d8                	mov    %ebx,%eax
  8018d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    
	assert(r <= n);
  8018db:	68 51 2c 80 00       	push   $0x802c51
  8018e0:	68 31 2c 80 00       	push   $0x802c31
  8018e5:	6a 7c                	push   $0x7c
  8018e7:	68 46 2c 80 00       	push   $0x802c46
  8018ec:	e8 ea 09 00 00       	call   8022db <_panic>
	assert(r <= PGSIZE);
  8018f1:	68 58 2c 80 00       	push   $0x802c58
  8018f6:	68 31 2c 80 00       	push   $0x802c31
  8018fb:	6a 7d                	push   $0x7d
  8018fd:	68 46 2c 80 00       	push   $0x802c46
  801902:	e8 d4 09 00 00       	call   8022db <_panic>

00801907 <open>:
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	83 ec 1c             	sub    $0x1c,%esp
  80190f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801912:	56                   	push   %esi
  801913:	e8 f8 ee ff ff       	call   800810 <strlen>
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801920:	7f 6c                	jg     80198e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801922:	83 ec 0c             	sub    $0xc,%esp
  801925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801928:	50                   	push   %eax
  801929:	e8 75 f8 ff ff       	call   8011a3 <fd_alloc>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	85 c0                	test   %eax,%eax
  801935:	78 3c                	js     801973 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	56                   	push   %esi
  80193b:	68 00 50 80 00       	push   $0x805000
  801940:	e8 02 ef ff ff       	call   800847 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80194d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801950:	b8 01 00 00 00       	mov    $0x1,%eax
  801955:	e8 b4 fd ff ff       	call   80170e <fsipc>
  80195a:	89 c3                	mov    %eax,%ebx
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 19                	js     80197c <open+0x75>
	return fd2num(fd);
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	ff 75 f4             	pushl  -0xc(%ebp)
  801969:	e8 0e f8 ff ff       	call   80117c <fd2num>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	83 c4 10             	add    $0x10,%esp
}
  801973:	89 d8                	mov    %ebx,%eax
  801975:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801978:	5b                   	pop    %ebx
  801979:	5e                   	pop    %esi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
		fd_close(fd, 0);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 f4             	pushl  -0xc(%ebp)
  801984:	e8 15 f9 ff ff       	call   80129e <fd_close>
		return r;
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	eb e5                	jmp    801973 <open+0x6c>
		return -E_BAD_PATH;
  80198e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801993:	eb de                	jmp    801973 <open+0x6c>

00801995 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80199b:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019a5:	e8 64 fd ff ff       	call   80170e <fsipc>
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	56                   	push   %esi
  8019b0:	53                   	push   %ebx
  8019b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 cd f7 ff ff       	call   80118c <fd2data>
  8019bf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019c1:	83 c4 08             	add    $0x8,%esp
  8019c4:	68 64 2c 80 00       	push   $0x802c64
  8019c9:	53                   	push   %ebx
  8019ca:	e8 78 ee ff ff       	call   800847 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019cf:	8b 46 04             	mov    0x4(%esi),%eax
  8019d2:	2b 06                	sub    (%esi),%eax
  8019d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019da:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e1:	00 00 00 
	stat->st_dev = &devpipe;
  8019e4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019eb:	30 80 00 
	return 0;
}
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    

008019fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	53                   	push   %ebx
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a04:	53                   	push   %ebx
  801a05:	6a 00                	push   $0x0
  801a07:	e8 b9 f2 ff ff       	call   800cc5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a0c:	89 1c 24             	mov    %ebx,(%esp)
  801a0f:	e8 78 f7 ff ff       	call   80118c <fd2data>
  801a14:	83 c4 08             	add    $0x8,%esp
  801a17:	50                   	push   %eax
  801a18:	6a 00                	push   $0x0
  801a1a:	e8 a6 f2 ff ff       	call   800cc5 <sys_page_unmap>
}
  801a1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <_pipeisclosed>:
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	57                   	push   %edi
  801a28:	56                   	push   %esi
  801a29:	53                   	push   %ebx
  801a2a:	83 ec 1c             	sub    $0x1c,%esp
  801a2d:	89 c7                	mov    %eax,%edi
  801a2f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a31:	a1 08 40 80 00       	mov    0x804008,%eax
  801a36:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	57                   	push   %edi
  801a3d:	e8 79 0a 00 00       	call   8024bb <pageref>
  801a42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a45:	89 34 24             	mov    %esi,(%esp)
  801a48:	e8 6e 0a 00 00       	call   8024bb <pageref>
		nn = thisenv->env_runs;
  801a4d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a53:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	39 cb                	cmp    %ecx,%ebx
  801a5b:	74 1b                	je     801a78 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a5d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a60:	75 cf                	jne    801a31 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a62:	8b 42 58             	mov    0x58(%edx),%eax
  801a65:	6a 01                	push   $0x1
  801a67:	50                   	push   %eax
  801a68:	53                   	push   %ebx
  801a69:	68 6b 2c 80 00       	push   $0x802c6b
  801a6e:	e8 37 e7 ff ff       	call   8001aa <cprintf>
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	eb b9                	jmp    801a31 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a78:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a7b:	0f 94 c0             	sete   %al
  801a7e:	0f b6 c0             	movzbl %al,%eax
}
  801a81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5f                   	pop    %edi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <devpipe_write>:
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	57                   	push   %edi
  801a8d:	56                   	push   %esi
  801a8e:	53                   	push   %ebx
  801a8f:	83 ec 28             	sub    $0x28,%esp
  801a92:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a95:	56                   	push   %esi
  801a96:	e8 f1 f6 ff ff       	call   80118c <fd2data>
  801a9b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801aa8:	74 4f                	je     801af9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801aaa:	8b 43 04             	mov    0x4(%ebx),%eax
  801aad:	8b 0b                	mov    (%ebx),%ecx
  801aaf:	8d 51 20             	lea    0x20(%ecx),%edx
  801ab2:	39 d0                	cmp    %edx,%eax
  801ab4:	72 14                	jb     801aca <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ab6:	89 da                	mov    %ebx,%edx
  801ab8:	89 f0                	mov    %esi,%eax
  801aba:	e8 65 ff ff ff       	call   801a24 <_pipeisclosed>
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 3a                	jne    801afd <devpipe_write+0x74>
			sys_yield();
  801ac3:	e8 59 f1 ff ff       	call   800c21 <sys_yield>
  801ac8:	eb e0                	jmp    801aaa <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801acd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ad1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	c1 fa 1f             	sar    $0x1f,%edx
  801ad9:	89 d1                	mov    %edx,%ecx
  801adb:	c1 e9 1b             	shr    $0x1b,%ecx
  801ade:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ae1:	83 e2 1f             	and    $0x1f,%edx
  801ae4:	29 ca                	sub    %ecx,%edx
  801ae6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aea:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801aee:	83 c0 01             	add    $0x1,%eax
  801af1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801af4:	83 c7 01             	add    $0x1,%edi
  801af7:	eb ac                	jmp    801aa5 <devpipe_write+0x1c>
	return i;
  801af9:	89 f8                	mov    %edi,%eax
  801afb:	eb 05                	jmp    801b02 <devpipe_write+0x79>
				return 0;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5e                   	pop    %esi
  801b07:	5f                   	pop    %edi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <devpipe_read>:
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 18             	sub    $0x18,%esp
  801b13:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b16:	57                   	push   %edi
  801b17:	e8 70 f6 ff ff       	call   80118c <fd2data>
  801b1c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	be 00 00 00 00       	mov    $0x0,%esi
  801b26:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b29:	74 47                	je     801b72 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b2b:	8b 03                	mov    (%ebx),%eax
  801b2d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b30:	75 22                	jne    801b54 <devpipe_read+0x4a>
			if (i > 0)
  801b32:	85 f6                	test   %esi,%esi
  801b34:	75 14                	jne    801b4a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b36:	89 da                	mov    %ebx,%edx
  801b38:	89 f8                	mov    %edi,%eax
  801b3a:	e8 e5 fe ff ff       	call   801a24 <_pipeisclosed>
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	75 33                	jne    801b76 <devpipe_read+0x6c>
			sys_yield();
  801b43:	e8 d9 f0 ff ff       	call   800c21 <sys_yield>
  801b48:	eb e1                	jmp    801b2b <devpipe_read+0x21>
				return i;
  801b4a:	89 f0                	mov    %esi,%eax
}
  801b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b54:	99                   	cltd   
  801b55:	c1 ea 1b             	shr    $0x1b,%edx
  801b58:	01 d0                	add    %edx,%eax
  801b5a:	83 e0 1f             	and    $0x1f,%eax
  801b5d:	29 d0                	sub    %edx,%eax
  801b5f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b67:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b6a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b6d:	83 c6 01             	add    $0x1,%esi
  801b70:	eb b4                	jmp    801b26 <devpipe_read+0x1c>
	return i;
  801b72:	89 f0                	mov    %esi,%eax
  801b74:	eb d6                	jmp    801b4c <devpipe_read+0x42>
				return 0;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	eb cf                	jmp    801b4c <devpipe_read+0x42>

00801b7d <pipe>:
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	56                   	push   %esi
  801b81:	53                   	push   %ebx
  801b82:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b88:	50                   	push   %eax
  801b89:	e8 15 f6 ff ff       	call   8011a3 <fd_alloc>
  801b8e:	89 c3                	mov    %eax,%ebx
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	85 c0                	test   %eax,%eax
  801b95:	78 5b                	js     801bf2 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	68 07 04 00 00       	push   $0x407
  801b9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 97 f0 ff ff       	call   800c40 <sys_page_alloc>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 40                	js     801bf2 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb8:	50                   	push   %eax
  801bb9:	e8 e5 f5 ff ff       	call   8011a3 <fd_alloc>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 1b                	js     801be2 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	68 07 04 00 00       	push   $0x407
  801bcf:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd2:	6a 00                	push   $0x0
  801bd4:	e8 67 f0 ff ff       	call   800c40 <sys_page_alloc>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	85 c0                	test   %eax,%eax
  801be0:	79 19                	jns    801bfb <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801be2:	83 ec 08             	sub    $0x8,%esp
  801be5:	ff 75 f4             	pushl  -0xc(%ebp)
  801be8:	6a 00                	push   $0x0
  801bea:	e8 d6 f0 ff ff       	call   800cc5 <sys_page_unmap>
  801bef:	83 c4 10             	add    $0x10,%esp
}
  801bf2:	89 d8                	mov    %ebx,%eax
  801bf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5d                   	pop    %ebp
  801bfa:	c3                   	ret    
	va = fd2data(fd0);
  801bfb:	83 ec 0c             	sub    $0xc,%esp
  801bfe:	ff 75 f4             	pushl  -0xc(%ebp)
  801c01:	e8 86 f5 ff ff       	call   80118c <fd2data>
  801c06:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c08:	83 c4 0c             	add    $0xc,%esp
  801c0b:	68 07 04 00 00       	push   $0x407
  801c10:	50                   	push   %eax
  801c11:	6a 00                	push   $0x0
  801c13:	e8 28 f0 ff ff       	call   800c40 <sys_page_alloc>
  801c18:	89 c3                	mov    %eax,%ebx
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	0f 88 8c 00 00 00    	js     801cb1 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c25:	83 ec 0c             	sub    $0xc,%esp
  801c28:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2b:	e8 5c f5 ff ff       	call   80118c <fd2data>
  801c30:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c37:	50                   	push   %eax
  801c38:	6a 00                	push   $0x0
  801c3a:	56                   	push   %esi
  801c3b:	6a 00                	push   $0x0
  801c3d:	e8 41 f0 ff ff       	call   800c83 <sys_page_map>
  801c42:	89 c3                	mov    %eax,%ebx
  801c44:	83 c4 20             	add    $0x20,%esp
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 58                	js     801ca3 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c54:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c63:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c69:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7b:	e8 fc f4 ff ff       	call   80117c <fd2num>
  801c80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c83:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c85:	83 c4 04             	add    $0x4,%esp
  801c88:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8b:	e8 ec f4 ff ff       	call   80117c <fd2num>
  801c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c93:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c9e:	e9 4f ff ff ff       	jmp    801bf2 <pipe+0x75>
	sys_page_unmap(0, va);
  801ca3:	83 ec 08             	sub    $0x8,%esp
  801ca6:	56                   	push   %esi
  801ca7:	6a 00                	push   $0x0
  801ca9:	e8 17 f0 ff ff       	call   800cc5 <sys_page_unmap>
  801cae:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb7:	6a 00                	push   $0x0
  801cb9:	e8 07 f0 ff ff       	call   800cc5 <sys_page_unmap>
  801cbe:	83 c4 10             	add    $0x10,%esp
  801cc1:	e9 1c ff ff ff       	jmp    801be2 <pipe+0x65>

00801cc6 <pipeisclosed>:
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccf:	50                   	push   %eax
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	e8 1a f5 ff ff       	call   8011f2 <fd_lookup>
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 18                	js     801cf7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce5:	e8 a2 f4 ff ff       	call   80118c <fd2data>
	return _pipeisclosed(fd, p);
  801cea:	89 c2                	mov    %eax,%edx
  801cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cef:	e8 30 fd ff ff       	call   801a24 <_pipeisclosed>
  801cf4:	83 c4 10             	add    $0x10,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cff:	68 83 2c 80 00       	push   $0x802c83
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	e8 3b eb ff ff       	call   800847 <strcpy>
	return 0;
}
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <devsock_close>:
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 10             	sub    $0x10,%esp
  801d1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d1d:	53                   	push   %ebx
  801d1e:	e8 98 07 00 00       	call   8024bb <pageref>
  801d23:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801d2b:	83 f8 01             	cmp    $0x1,%eax
  801d2e:	74 07                	je     801d37 <devsock_close+0x24>
}
  801d30:	89 d0                	mov    %edx,%eax
  801d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d37:	83 ec 0c             	sub    $0xc,%esp
  801d3a:	ff 73 0c             	pushl  0xc(%ebx)
  801d3d:	e8 b7 02 00 00       	call   801ff9 <nsipc_close>
  801d42:	89 c2                	mov    %eax,%edx
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	eb e7                	jmp    801d30 <devsock_close+0x1d>

00801d49 <devsock_write>:
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 10             	pushl  0x10(%ebp)
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	ff 70 0c             	pushl  0xc(%eax)
  801d5d:	e8 74 03 00 00       	call   8020d6 <nsipc_send>
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <devsock_read>:
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	ff 75 10             	pushl  0x10(%ebp)
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	ff 70 0c             	pushl  0xc(%eax)
  801d78:	e8 ed 02 00 00       	call   80206a <nsipc_recv>
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <fd2sockid>:
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d85:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	e8 63 f4 ff ff       	call   8011f2 <fd_lookup>
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	85 c0                	test   %eax,%eax
  801d94:	78 10                	js     801da6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d9f:	39 08                	cmp    %ecx,(%eax)
  801da1:	75 05                	jne    801da8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801da3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    
		return -E_NOT_SUPP;
  801da8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dad:	eb f7                	jmp    801da6 <fd2sockid+0x27>

00801daf <alloc_sockfd>:
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	56                   	push   %esi
  801db3:	53                   	push   %ebx
  801db4:	83 ec 1c             	sub    $0x1c,%esp
  801db7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801db9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dbc:	50                   	push   %eax
  801dbd:	e8 e1 f3 ff ff       	call   8011a3 <fd_alloc>
  801dc2:	89 c3                	mov    %eax,%ebx
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	78 43                	js     801e0e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	68 07 04 00 00       	push   $0x407
  801dd3:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd6:	6a 00                	push   $0x0
  801dd8:	e8 63 ee ff ff       	call   800c40 <sys_page_alloc>
  801ddd:	89 c3                	mov    %eax,%ebx
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 28                	js     801e0e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801def:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dfb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	50                   	push   %eax
  801e02:	e8 75 f3 ff ff       	call   80117c <fd2num>
  801e07:	89 c3                	mov    %eax,%ebx
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	eb 0c                	jmp    801e1a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	56                   	push   %esi
  801e12:	e8 e2 01 00 00       	call   801ff9 <nsipc_close>
		return r;
  801e17:	83 c4 10             	add    $0x10,%esp
}
  801e1a:	89 d8                	mov    %ebx,%eax
  801e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <accept>:
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	e8 4e ff ff ff       	call   801d7f <fd2sockid>
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 1b                	js     801e50 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	ff 75 10             	pushl  0x10(%ebp)
  801e3b:	ff 75 0c             	pushl  0xc(%ebp)
  801e3e:	50                   	push   %eax
  801e3f:	e8 0e 01 00 00       	call   801f52 <nsipc_accept>
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 05                	js     801e50 <accept+0x2d>
	return alloc_sockfd(r);
  801e4b:	e8 5f ff ff ff       	call   801daf <alloc_sockfd>
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <bind>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	e8 1f ff ff ff       	call   801d7f <fd2sockid>
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 12                	js     801e76 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	ff 75 10             	pushl  0x10(%ebp)
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	50                   	push   %eax
  801e6e:	e8 2f 01 00 00       	call   801fa2 <nsipc_bind>
  801e73:	83 c4 10             	add    $0x10,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <shutdown>:
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	e8 f9 fe ff ff       	call   801d7f <fd2sockid>
  801e86:	85 c0                	test   %eax,%eax
  801e88:	78 0f                	js     801e99 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	50                   	push   %eax
  801e91:	e8 41 01 00 00       	call   801fd7 <nsipc_shutdown>
  801e96:	83 c4 10             	add    $0x10,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <connect>:
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	e8 d6 fe ff ff       	call   801d7f <fd2sockid>
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 12                	js     801ebf <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	ff 75 10             	pushl  0x10(%ebp)
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	50                   	push   %eax
  801eb7:	e8 57 01 00 00       	call   802013 <nsipc_connect>
  801ebc:	83 c4 10             	add    $0x10,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <listen>:
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	e8 b0 fe ff ff       	call   801d7f <fd2sockid>
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 0f                	js     801ee2 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	ff 75 0c             	pushl  0xc(%ebp)
  801ed9:	50                   	push   %eax
  801eda:	e8 69 01 00 00       	call   802048 <nsipc_listen>
  801edf:	83 c4 10             	add    $0x10,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eea:	ff 75 10             	pushl  0x10(%ebp)
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	e8 3c 02 00 00       	call   802134 <nsipc_socket>
  801ef8:	83 c4 10             	add    $0x10,%esp
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 05                	js     801f04 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801eff:	e8 ab fe ff ff       	call   801daf <alloc_sockfd>
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f0f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f16:	74 26                	je     801f3e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f18:	6a 07                	push   $0x7
  801f1a:	68 00 60 80 00       	push   $0x806000
  801f1f:	53                   	push   %ebx
  801f20:	ff 35 04 40 80 00    	pushl  0x804004
  801f26:	e8 fe 04 00 00       	call   802429 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f2b:	83 c4 0c             	add    $0xc,%esp
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	e8 87 04 00 00       	call   8023c0 <ipc_recv>
}
  801f39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	6a 02                	push   $0x2
  801f43:	e8 3a 05 00 00       	call   802482 <ipc_find_env>
  801f48:	a3 04 40 80 00       	mov    %eax,0x804004
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	eb c6                	jmp    801f18 <nsipc+0x12>

00801f52 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	56                   	push   %esi
  801f56:	53                   	push   %ebx
  801f57:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f62:	8b 06                	mov    (%esi),%eax
  801f64:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f69:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6e:	e8 93 ff ff ff       	call   801f06 <nsipc>
  801f73:	89 c3                	mov    %eax,%ebx
  801f75:	85 c0                	test   %eax,%eax
  801f77:	78 20                	js     801f99 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	ff 35 10 60 80 00    	pushl  0x806010
  801f82:	68 00 60 80 00       	push   $0x806000
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	e8 46 ea ff ff       	call   8009d5 <memmove>
		*addrlen = ret->ret_addrlen;
  801f8f:	a1 10 60 80 00       	mov    0x806010,%eax
  801f94:	89 06                	mov    %eax,(%esi)
  801f96:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801f99:	89 d8                	mov    %ebx,%eax
  801f9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9e:	5b                   	pop    %ebx
  801f9f:	5e                   	pop    %esi
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    

00801fa2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	53                   	push   %ebx
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fb4:	53                   	push   %ebx
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	68 04 60 80 00       	push   $0x806004
  801fbd:	e8 13 ea ff ff       	call   8009d5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fc2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fc8:	b8 02 00 00 00       	mov    $0x2,%eax
  801fcd:	e8 34 ff ff ff       	call   801f06 <nsipc>
}
  801fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fed:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff2:	e8 0f ff ff ff       	call   801f06 <nsipc>
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <nsipc_close>:

int
nsipc_close(int s)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802007:	b8 04 00 00 00       	mov    $0x4,%eax
  80200c:	e8 f5 fe ff ff       	call   801f06 <nsipc>
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	53                   	push   %ebx
  802017:	83 ec 08             	sub    $0x8,%esp
  80201a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802025:	53                   	push   %ebx
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	68 04 60 80 00       	push   $0x806004
  80202e:	e8 a2 e9 ff ff       	call   8009d5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802033:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802039:	b8 05 00 00 00       	mov    $0x5,%eax
  80203e:	e8 c3 fe ff ff       	call   801f06 <nsipc>
}
  802043:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80205e:	b8 06 00 00 00       	mov    $0x6,%eax
  802063:	e8 9e fe ff ff       	call   801f06 <nsipc>
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	56                   	push   %esi
  80206e:	53                   	push   %ebx
  80206f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80207a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802080:	8b 45 14             	mov    0x14(%ebp),%eax
  802083:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802088:	b8 07 00 00 00       	mov    $0x7,%eax
  80208d:	e8 74 fe ff ff       	call   801f06 <nsipc>
  802092:	89 c3                	mov    %eax,%ebx
  802094:	85 c0                	test   %eax,%eax
  802096:	78 1f                	js     8020b7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802098:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80209d:	7f 21                	jg     8020c0 <nsipc_recv+0x56>
  80209f:	39 c6                	cmp    %eax,%esi
  8020a1:	7c 1d                	jl     8020c0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	50                   	push   %eax
  8020a7:	68 00 60 80 00       	push   $0x806000
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	e8 21 e9 ff ff       	call   8009d5 <memmove>
  8020b4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020b7:	89 d8                	mov    %ebx,%eax
  8020b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020bc:	5b                   	pop    %ebx
  8020bd:	5e                   	pop    %esi
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020c0:	68 8f 2c 80 00       	push   $0x802c8f
  8020c5:	68 31 2c 80 00       	push   $0x802c31
  8020ca:	6a 62                	push   $0x62
  8020cc:	68 a4 2c 80 00       	push   $0x802ca4
  8020d1:	e8 05 02 00 00       	call   8022db <_panic>

008020d6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020e8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020ee:	7f 2e                	jg     80211e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	53                   	push   %ebx
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	68 0c 60 80 00       	push   $0x80600c
  8020fc:	e8 d4 e8 ff ff       	call   8009d5 <memmove>
	nsipcbuf.send.req_size = size;
  802101:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802107:	8b 45 14             	mov    0x14(%ebp),%eax
  80210a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80210f:	b8 08 00 00 00       	mov    $0x8,%eax
  802114:	e8 ed fd ff ff       	call   801f06 <nsipc>
}
  802119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    
	assert(size < 1600);
  80211e:	68 b0 2c 80 00       	push   $0x802cb0
  802123:	68 31 2c 80 00       	push   $0x802c31
  802128:	6a 6d                	push   $0x6d
  80212a:	68 a4 2c 80 00       	push   $0x802ca4
  80212f:	e8 a7 01 00 00       	call   8022db <_panic>

00802134 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802142:	8b 45 0c             	mov    0xc(%ebp),%eax
  802145:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80214a:	8b 45 10             	mov    0x10(%ebp),%eax
  80214d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802152:	b8 09 00 00 00       	mov    $0x9,%eax
  802157:	e8 aa fd ff ff       	call   801f06 <nsipc>
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    

00802168 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80216e:	68 bc 2c 80 00       	push   $0x802cbc
  802173:	ff 75 0c             	pushl  0xc(%ebp)
  802176:	e8 cc e6 ff ff       	call   800847 <strcpy>
	return 0;
}
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <devcons_write>:
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80218e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802193:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802199:	eb 2f                	jmp    8021ca <devcons_write+0x48>
		m = n - tot;
  80219b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80219e:	29 f3                	sub    %esi,%ebx
  8021a0:	83 fb 7f             	cmp    $0x7f,%ebx
  8021a3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021a8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021ab:	83 ec 04             	sub    $0x4,%esp
  8021ae:	53                   	push   %ebx
  8021af:	89 f0                	mov    %esi,%eax
  8021b1:	03 45 0c             	add    0xc(%ebp),%eax
  8021b4:	50                   	push   %eax
  8021b5:	57                   	push   %edi
  8021b6:	e8 1a e8 ff ff       	call   8009d5 <memmove>
		sys_cputs(buf, m);
  8021bb:	83 c4 08             	add    $0x8,%esp
  8021be:	53                   	push   %ebx
  8021bf:	57                   	push   %edi
  8021c0:	e8 bf e9 ff ff       	call   800b84 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021c5:	01 de                	add    %ebx,%esi
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021cd:	72 cc                	jb     80219b <devcons_write+0x19>
}
  8021cf:	89 f0                	mov    %esi,%eax
  8021d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d4:	5b                   	pop    %ebx
  8021d5:	5e                   	pop    %esi
  8021d6:	5f                   	pop    %edi
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <devcons_read>:
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 08             	sub    $0x8,%esp
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e8:	75 07                	jne    8021f1 <devcons_read+0x18>
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    
		sys_yield();
  8021ec:	e8 30 ea ff ff       	call   800c21 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8021f1:	e8 ac e9 ff ff       	call   800ba2 <sys_cgetc>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	74 f2                	je     8021ec <devcons_read+0x13>
	if (c < 0)
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 ec                	js     8021ea <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8021fe:	83 f8 04             	cmp    $0x4,%eax
  802201:	74 0c                	je     80220f <devcons_read+0x36>
	*(char*)vbuf = c;
  802203:	8b 55 0c             	mov    0xc(%ebp),%edx
  802206:	88 02                	mov    %al,(%edx)
	return 1;
  802208:	b8 01 00 00 00       	mov    $0x1,%eax
  80220d:	eb db                	jmp    8021ea <devcons_read+0x11>
		return 0;
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	eb d4                	jmp    8021ea <devcons_read+0x11>

00802216 <cputchar>:
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802222:	6a 01                	push   $0x1
  802224:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802227:	50                   	push   %eax
  802228:	e8 57 e9 ff ff       	call   800b84 <sys_cputs>
}
  80222d:	83 c4 10             	add    $0x10,%esp
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <getchar>:
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802238:	6a 01                	push   $0x1
  80223a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223d:	50                   	push   %eax
  80223e:	6a 00                	push   $0x0
  802240:	e8 1e f2 ff ff       	call   801463 <read>
	if (r < 0)
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 08                	js     802254 <getchar+0x22>
	if (r < 1)
  80224c:	85 c0                	test   %eax,%eax
  80224e:	7e 06                	jle    802256 <getchar+0x24>
	return c;
  802250:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    
		return -E_EOF;
  802256:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80225b:	eb f7                	jmp    802254 <getchar+0x22>

0080225d <iscons>:
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802266:	50                   	push   %eax
  802267:	ff 75 08             	pushl  0x8(%ebp)
  80226a:	e8 83 ef ff ff       	call   8011f2 <fd_lookup>
  80226f:	83 c4 10             	add    $0x10,%esp
  802272:	85 c0                	test   %eax,%eax
  802274:	78 11                	js     802287 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80227f:	39 10                	cmp    %edx,(%eax)
  802281:	0f 94 c0             	sete   %al
  802284:	0f b6 c0             	movzbl %al,%eax
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <opencons>:
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80228f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802292:	50                   	push   %eax
  802293:	e8 0b ef ff ff       	call   8011a3 <fd_alloc>
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	85 c0                	test   %eax,%eax
  80229d:	78 3a                	js     8022d9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 07 04 00 00       	push   $0x407
  8022a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8022aa:	6a 00                	push   $0x0
  8022ac:	e8 8f e9 ff ff       	call   800c40 <sys_page_alloc>
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	78 21                	js     8022d9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022cd:	83 ec 0c             	sub    $0xc,%esp
  8022d0:	50                   	push   %eax
  8022d1:	e8 a6 ee ff ff       	call   80117c <fd2num>
  8022d6:	83 c4 10             	add    $0x10,%esp
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8022e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022e3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022e9:	e8 14 e9 ff ff       	call   800c02 <sys_getenvid>
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	56                   	push   %esi
  8022f8:	50                   	push   %eax
  8022f9:	68 c8 2c 80 00       	push   $0x802cc8
  8022fe:	e8 a7 de ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802303:	83 c4 18             	add    $0x18,%esp
  802306:	53                   	push   %ebx
  802307:	ff 75 10             	pushl  0x10(%ebp)
  80230a:	e8 4a de ff ff       	call   800159 <vcprintf>
	cprintf("\n");
  80230f:	c7 04 24 d4 27 80 00 	movl   $0x8027d4,(%esp)
  802316:	e8 8f de ff ff       	call   8001aa <cprintf>
  80231b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80231e:	cc                   	int3   
  80231f:	eb fd                	jmp    80231e <_panic+0x43>

00802321 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802327:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80232e:	74 0a                	je     80233a <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  80233a:	a1 08 40 80 00       	mov    0x804008,%eax
  80233f:	8b 40 48             	mov    0x48(%eax),%eax
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	6a 07                	push   $0x7
  802347:	68 00 f0 bf ee       	push   $0xeebff000
  80234c:	50                   	push   %eax
  80234d:	e8 ee e8 ff ff       	call   800c40 <sys_page_alloc>
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	85 c0                	test   %eax,%eax
  802357:	75 2f                	jne    802388 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  802359:	a1 08 40 80 00       	mov    0x804008,%eax
  80235e:	8b 40 48             	mov    0x48(%eax),%eax
  802361:	83 ec 08             	sub    $0x8,%esp
  802364:	68 9a 23 80 00       	push   $0x80239a
  802369:	50                   	push   %eax
  80236a:	e8 1c ea ff ff       	call   800d8b <sys_env_set_pgfault_upcall>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	85 c0                	test   %eax,%eax
  802374:	74 ba                	je     802330 <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  802376:	50                   	push   %eax
  802377:	68 ec 2c 80 00       	push   $0x802cec
  80237c:	6a 24                	push   $0x24
  80237e:	68 04 2d 80 00       	push   $0x802d04
  802383:	e8 53 ff ff ff       	call   8022db <_panic>
		    panic("set_pgfault_handler: %e", r);
  802388:	50                   	push   %eax
  802389:	68 ec 2c 80 00       	push   $0x802cec
  80238e:	6a 21                	push   $0x21
  802390:	68 04 2d 80 00       	push   $0x802d04
  802395:	e8 41 ff ff ff       	call   8022db <_panic>

0080239a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80239a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80239b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8023a0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023a2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  8023a5:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  8023a9:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  8023ac:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  8023b0:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  8023b4:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  8023b6:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  8023b9:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  8023ba:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  8023bd:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  8023be:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8023bf:	c3                   	ret    

008023c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	56                   	push   %esi
  8023c4:	53                   	push   %ebx
  8023c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8023c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  8023ce:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  8023d0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023d5:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	50                   	push   %eax
  8023dc:	e8 0f ea ff ff       	call   800df0 <sys_ipc_recv>
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 2b                	js     802413 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  8023e8:	85 f6                	test   %esi,%esi
  8023ea:	74 0a                	je     8023f6 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  8023ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8023f1:	8b 40 74             	mov    0x74(%eax),%eax
  8023f4:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  8023f6:	85 db                	test   %ebx,%ebx
  8023f8:	74 0a                	je     802404 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  8023fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ff:	8b 40 78             	mov    0x78(%eax),%eax
  802402:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802404:	a1 08 40 80 00       	mov    0x804008,%eax
  802409:	8b 40 70             	mov    0x70(%eax),%eax
}
  80240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80240f:	5b                   	pop    %ebx
  802410:	5e                   	pop    %esi
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    
	    if (from_env_store != NULL) {
  802413:	85 f6                	test   %esi,%esi
  802415:	74 06                	je     80241d <ipc_recv+0x5d>
	        *from_env_store = 0;
  802417:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  80241d:	85 db                	test   %ebx,%ebx
  80241f:	74 eb                	je     80240c <ipc_recv+0x4c>
	        *perm_store = 0;
  802421:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802427:	eb e3                	jmp    80240c <ipc_recv+0x4c>

00802429 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	57                   	push   %edi
  80242d:	56                   	push   %esi
  80242e:	53                   	push   %ebx
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	8b 7d 08             	mov    0x8(%ebp),%edi
  802435:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802438:	85 f6                	test   %esi,%esi
  80243a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80243f:	0f 44 f0             	cmove  %eax,%esi
  802442:	eb 09                	jmp    80244d <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802444:	e8 d8 e7 ff ff       	call   800c21 <sys_yield>
	} while(r != 0);
  802449:	85 db                	test   %ebx,%ebx
  80244b:	74 2d                	je     80247a <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80244d:	ff 75 14             	pushl  0x14(%ebp)
  802450:	56                   	push   %esi
  802451:	ff 75 0c             	pushl  0xc(%ebp)
  802454:	57                   	push   %edi
  802455:	e8 73 e9 ff ff       	call   800dcd <sys_ipc_try_send>
  80245a:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	85 c0                	test   %eax,%eax
  802461:	79 e1                	jns    802444 <ipc_send+0x1b>
  802463:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802466:	74 dc                	je     802444 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802468:	50                   	push   %eax
  802469:	68 12 2d 80 00       	push   $0x802d12
  80246e:	6a 45                	push   $0x45
  802470:	68 1f 2d 80 00       	push   $0x802d1f
  802475:	e8 61 fe ff ff       	call   8022db <_panic>
}
  80247a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5f                   	pop    %edi
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802490:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802496:	8b 52 50             	mov    0x50(%edx),%edx
  802499:	39 ca                	cmp    %ecx,%edx
  80249b:	74 11                	je     8024ae <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80249d:	83 c0 01             	add    $0x1,%eax
  8024a0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024a5:	75 e6                	jne    80248d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	eb 0b                	jmp    8024b9 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024ae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024b6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024b9:	5d                   	pop    %ebp
  8024ba:	c3                   	ret    

008024bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024c1:	89 d0                	mov    %edx,%eax
  8024c3:	c1 e8 16             	shr    $0x16,%eax
  8024c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d2:	f6 c1 01             	test   $0x1,%cl
  8024d5:	74 1d                	je     8024f4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024d7:	c1 ea 0c             	shr    $0xc,%edx
  8024da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024e1:	f6 c2 01             	test   $0x1,%dl
  8024e4:	74 0e                	je     8024f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024e6:	c1 ea 0c             	shr    $0xc,%edx
  8024e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024f0:	ef 
  8024f1:	0f b7 c0             	movzwl %ax,%eax
}
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80250f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802513:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802517:	85 d2                	test   %edx,%edx
  802519:	75 35                	jne    802550 <__udivdi3+0x50>
  80251b:	39 f3                	cmp    %esi,%ebx
  80251d:	0f 87 bd 00 00 00    	ja     8025e0 <__udivdi3+0xe0>
  802523:	85 db                	test   %ebx,%ebx
  802525:	89 d9                	mov    %ebx,%ecx
  802527:	75 0b                	jne    802534 <__udivdi3+0x34>
  802529:	b8 01 00 00 00       	mov    $0x1,%eax
  80252e:	31 d2                	xor    %edx,%edx
  802530:	f7 f3                	div    %ebx
  802532:	89 c1                	mov    %eax,%ecx
  802534:	31 d2                	xor    %edx,%edx
  802536:	89 f0                	mov    %esi,%eax
  802538:	f7 f1                	div    %ecx
  80253a:	89 c6                	mov    %eax,%esi
  80253c:	89 e8                	mov    %ebp,%eax
  80253e:	89 f7                	mov    %esi,%edi
  802540:	f7 f1                	div    %ecx
  802542:	89 fa                	mov    %edi,%edx
  802544:	83 c4 1c             	add    $0x1c,%esp
  802547:	5b                   	pop    %ebx
  802548:	5e                   	pop    %esi
  802549:	5f                   	pop    %edi
  80254a:	5d                   	pop    %ebp
  80254b:	c3                   	ret    
  80254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802550:	39 f2                	cmp    %esi,%edx
  802552:	77 7c                	ja     8025d0 <__udivdi3+0xd0>
  802554:	0f bd fa             	bsr    %edx,%edi
  802557:	83 f7 1f             	xor    $0x1f,%edi
  80255a:	0f 84 98 00 00 00    	je     8025f8 <__udivdi3+0xf8>
  802560:	89 f9                	mov    %edi,%ecx
  802562:	b8 20 00 00 00       	mov    $0x20,%eax
  802567:	29 f8                	sub    %edi,%eax
  802569:	d3 e2                	shl    %cl,%edx
  80256b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80256f:	89 c1                	mov    %eax,%ecx
  802571:	89 da                	mov    %ebx,%edx
  802573:	d3 ea                	shr    %cl,%edx
  802575:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802579:	09 d1                	or     %edx,%ecx
  80257b:	89 f2                	mov    %esi,%edx
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 f9                	mov    %edi,%ecx
  802583:	d3 e3                	shl    %cl,%ebx
  802585:	89 c1                	mov    %eax,%ecx
  802587:	d3 ea                	shr    %cl,%edx
  802589:	89 f9                	mov    %edi,%ecx
  80258b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80258f:	d3 e6                	shl    %cl,%esi
  802591:	89 eb                	mov    %ebp,%ebx
  802593:	89 c1                	mov    %eax,%ecx
  802595:	d3 eb                	shr    %cl,%ebx
  802597:	09 de                	or     %ebx,%esi
  802599:	89 f0                	mov    %esi,%eax
  80259b:	f7 74 24 08          	divl   0x8(%esp)
  80259f:	89 d6                	mov    %edx,%esi
  8025a1:	89 c3                	mov    %eax,%ebx
  8025a3:	f7 64 24 0c          	mull   0xc(%esp)
  8025a7:	39 d6                	cmp    %edx,%esi
  8025a9:	72 0c                	jb     8025b7 <__udivdi3+0xb7>
  8025ab:	89 f9                	mov    %edi,%ecx
  8025ad:	d3 e5                	shl    %cl,%ebp
  8025af:	39 c5                	cmp    %eax,%ebp
  8025b1:	73 5d                	jae    802610 <__udivdi3+0x110>
  8025b3:	39 d6                	cmp    %edx,%esi
  8025b5:	75 59                	jne    802610 <__udivdi3+0x110>
  8025b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ba:	31 ff                	xor    %edi,%edi
  8025bc:	89 fa                	mov    %edi,%edx
  8025be:	83 c4 1c             	add    $0x1c,%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	8d 76 00             	lea    0x0(%esi),%esi
  8025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8025d0:	31 ff                	xor    %edi,%edi
  8025d2:	31 c0                	xor    %eax,%eax
  8025d4:	89 fa                	mov    %edi,%edx
  8025d6:	83 c4 1c             	add    $0x1c,%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5f                   	pop    %edi
  8025dc:	5d                   	pop    %ebp
  8025dd:	c3                   	ret    
  8025de:	66 90                	xchg   %ax,%ax
  8025e0:	31 ff                	xor    %edi,%edi
  8025e2:	89 e8                	mov    %ebp,%eax
  8025e4:	89 f2                	mov    %esi,%edx
  8025e6:	f7 f3                	div    %ebx
  8025e8:	89 fa                	mov    %edi,%edx
  8025ea:	83 c4 1c             	add    $0x1c,%esp
  8025ed:	5b                   	pop    %ebx
  8025ee:	5e                   	pop    %esi
  8025ef:	5f                   	pop    %edi
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    
  8025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025f8:	39 f2                	cmp    %esi,%edx
  8025fa:	72 06                	jb     802602 <__udivdi3+0x102>
  8025fc:	31 c0                	xor    %eax,%eax
  8025fe:	39 eb                	cmp    %ebp,%ebx
  802600:	77 d2                	ja     8025d4 <__udivdi3+0xd4>
  802602:	b8 01 00 00 00       	mov    $0x1,%eax
  802607:	eb cb                	jmp    8025d4 <__udivdi3+0xd4>
  802609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802610:	89 d8                	mov    %ebx,%eax
  802612:	31 ff                	xor    %edi,%edi
  802614:	eb be                	jmp    8025d4 <__udivdi3+0xd4>
  802616:	66 90                	xchg   %ax,%ax
  802618:	66 90                	xchg   %ax,%ax
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__umoddi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80262b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80262f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802637:	85 ed                	test   %ebp,%ebp
  802639:	89 f0                	mov    %esi,%eax
  80263b:	89 da                	mov    %ebx,%edx
  80263d:	75 19                	jne    802658 <__umoddi3+0x38>
  80263f:	39 df                	cmp    %ebx,%edi
  802641:	0f 86 b1 00 00 00    	jbe    8026f8 <__umoddi3+0xd8>
  802647:	f7 f7                	div    %edi
  802649:	89 d0                	mov    %edx,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	83 c4 1c             	add    $0x1c,%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    
  802655:	8d 76 00             	lea    0x0(%esi),%esi
  802658:	39 dd                	cmp    %ebx,%ebp
  80265a:	77 f1                	ja     80264d <__umoddi3+0x2d>
  80265c:	0f bd cd             	bsr    %ebp,%ecx
  80265f:	83 f1 1f             	xor    $0x1f,%ecx
  802662:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802666:	0f 84 b4 00 00 00    	je     802720 <__umoddi3+0x100>
  80266c:	b8 20 00 00 00       	mov    $0x20,%eax
  802671:	89 c2                	mov    %eax,%edx
  802673:	8b 44 24 04          	mov    0x4(%esp),%eax
  802677:	29 c2                	sub    %eax,%edx
  802679:	89 c1                	mov    %eax,%ecx
  80267b:	89 f8                	mov    %edi,%eax
  80267d:	d3 e5                	shl    %cl,%ebp
  80267f:	89 d1                	mov    %edx,%ecx
  802681:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802685:	d3 e8                	shr    %cl,%eax
  802687:	09 c5                	or     %eax,%ebp
  802689:	8b 44 24 04          	mov    0x4(%esp),%eax
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	d3 e7                	shl    %cl,%edi
  802691:	89 d1                	mov    %edx,%ecx
  802693:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802697:	89 df                	mov    %ebx,%edi
  802699:	d3 ef                	shr    %cl,%edi
  80269b:	89 c1                	mov    %eax,%ecx
  80269d:	89 f0                	mov    %esi,%eax
  80269f:	d3 e3                	shl    %cl,%ebx
  8026a1:	89 d1                	mov    %edx,%ecx
  8026a3:	89 fa                	mov    %edi,%edx
  8026a5:	d3 e8                	shr    %cl,%eax
  8026a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ac:	09 d8                	or     %ebx,%eax
  8026ae:	f7 f5                	div    %ebp
  8026b0:	d3 e6                	shl    %cl,%esi
  8026b2:	89 d1                	mov    %edx,%ecx
  8026b4:	f7 64 24 08          	mull   0x8(%esp)
  8026b8:	39 d1                	cmp    %edx,%ecx
  8026ba:	89 c3                	mov    %eax,%ebx
  8026bc:	89 d7                	mov    %edx,%edi
  8026be:	72 06                	jb     8026c6 <__umoddi3+0xa6>
  8026c0:	75 0e                	jne    8026d0 <__umoddi3+0xb0>
  8026c2:	39 c6                	cmp    %eax,%esi
  8026c4:	73 0a                	jae    8026d0 <__umoddi3+0xb0>
  8026c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026ca:	19 ea                	sbb    %ebp,%edx
  8026cc:	89 d7                	mov    %edx,%edi
  8026ce:	89 c3                	mov    %eax,%ebx
  8026d0:	89 ca                	mov    %ecx,%edx
  8026d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8026d7:	29 de                	sub    %ebx,%esi
  8026d9:	19 fa                	sbb    %edi,%edx
  8026db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8026df:	89 d0                	mov    %edx,%eax
  8026e1:	d3 e0                	shl    %cl,%eax
  8026e3:	89 d9                	mov    %ebx,%ecx
  8026e5:	d3 ee                	shr    %cl,%esi
  8026e7:	d3 ea                	shr    %cl,%edx
  8026e9:	09 f0                	or     %esi,%eax
  8026eb:	83 c4 1c             	add    $0x1c,%esp
  8026ee:	5b                   	pop    %ebx
  8026ef:	5e                   	pop    %esi
  8026f0:	5f                   	pop    %edi
  8026f1:	5d                   	pop    %ebp
  8026f2:	c3                   	ret    
  8026f3:	90                   	nop
  8026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	85 ff                	test   %edi,%edi
  8026fa:	89 f9                	mov    %edi,%ecx
  8026fc:	75 0b                	jne    802709 <__umoddi3+0xe9>
  8026fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802703:	31 d2                	xor    %edx,%edx
  802705:	f7 f7                	div    %edi
  802707:	89 c1                	mov    %eax,%ecx
  802709:	89 d8                	mov    %ebx,%eax
  80270b:	31 d2                	xor    %edx,%edx
  80270d:	f7 f1                	div    %ecx
  80270f:	89 f0                	mov    %esi,%eax
  802711:	f7 f1                	div    %ecx
  802713:	e9 31 ff ff ff       	jmp    802649 <__umoddi3+0x29>
  802718:	90                   	nop
  802719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802720:	39 dd                	cmp    %ebx,%ebp
  802722:	72 08                	jb     80272c <__umoddi3+0x10c>
  802724:	39 f7                	cmp    %esi,%edi
  802726:	0f 87 21 ff ff ff    	ja     80264d <__umoddi3+0x2d>
  80272c:	89 da                	mov    %ebx,%edx
  80272e:	89 f0                	mov    %esi,%eax
  802730:	29 f8                	sub    %edi,%eax
  802732:	19 ea                	sbb    %ebp,%edx
  802734:	e9 14 ff ff ff       	jmp    80264d <__umoddi3+0x2d>
