
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
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
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 60 23 80 00       	push   $0x802360
  800048:	e8 42 01 00 00       	call   80018f <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 ac 0b 00 00       	call   800c06 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 80 23 80 00       	push   $0x802380
  80006c:	e8 1e 01 00 00       	call   80018f <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 08 40 80 00       	mov    0x804008,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 ac 23 80 00       	push   $0x8023ac
  80008d:	e8 fd 00 00 00       	call   80018f <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 3d 0b 00 00       	call   800be7 <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b7:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x2d>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
  8000cc:	e8 62 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d1:	e8 0a 00 00 00       	call   8000e0 <exit>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e6:	e8 20 0f 00 00       	call   80100b <close_all>
	sys_env_destroy(0);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 b1 0a 00 00       	call   800ba6 <sys_env_destroy>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	c9                   	leave  
  8000f9:	c3                   	ret    

008000fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800104:	8b 13                	mov    (%ebx),%edx
  800106:	8d 42 01             	lea    0x1(%edx),%eax
  800109:	89 03                	mov    %eax,(%ebx)
  80010b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800112:	3d ff 00 00 00       	cmp    $0xff,%eax
  800117:	74 09                	je     800122 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800119:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800120:	c9                   	leave  
  800121:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 36 0a 00 00       	call   800b69 <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	eb db                	jmp    800119 <putch+0x1f>

0080013e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800147:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014e:	00 00 00 
	b.cnt = 0;
  800151:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800158:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015b:	ff 75 0c             	pushl  0xc(%ebp)
  80015e:	ff 75 08             	pushl  0x8(%ebp)
  800161:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	68 fa 00 80 00       	push   $0x8000fa
  80016d:	e8 1a 01 00 00       	call   80028c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 e2 09 00 00       	call   800b69 <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800195:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800198:	50                   	push   %eax
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 9d ff ff ff       	call   80013e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 1c             	sub    $0x1c,%esp
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001c7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001ca:	39 d3                	cmp    %edx,%ebx
  8001cc:	72 05                	jb     8001d3 <printnum+0x30>
  8001ce:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d1:	77 7a                	ja     80024d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	ff 75 18             	pushl  0x18(%ebp)
  8001d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8001dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001df:	53                   	push   %ebx
  8001e0:	ff 75 10             	pushl  0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f2:	e8 19 1f 00 00       	call   802110 <__udivdi3>
  8001f7:	83 c4 18             	add    $0x18,%esp
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	89 f2                	mov    %esi,%edx
  8001fe:	89 f8                	mov    %edi,%eax
  800200:	e8 9e ff ff ff       	call   8001a3 <printnum>
  800205:	83 c4 20             	add    $0x20,%esp
  800208:	eb 13                	jmp    80021d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	56                   	push   %esi
  80020e:	ff 75 18             	pushl  0x18(%ebp)
  800211:	ff d7                	call   *%edi
  800213:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800216:	83 eb 01             	sub    $0x1,%ebx
  800219:	85 db                	test   %ebx,%ebx
  80021b:	7f ed                	jg     80020a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	83 ec 04             	sub    $0x4,%esp
  800224:	ff 75 e4             	pushl  -0x1c(%ebp)
  800227:	ff 75 e0             	pushl  -0x20(%ebp)
  80022a:	ff 75 dc             	pushl  -0x24(%ebp)
  80022d:	ff 75 d8             	pushl  -0x28(%ebp)
  800230:	e8 fb 1f 00 00       	call   802230 <__umoddi3>
  800235:	83 c4 14             	add    $0x14,%esp
  800238:	0f be 80 d5 23 80 00 	movsbl 0x8023d5(%eax),%eax
  80023f:	50                   	push   %eax
  800240:	ff d7                	call   *%edi
}
  800242:	83 c4 10             	add    $0x10,%esp
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
  80024d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800250:	eb c4                	jmp    800216 <printnum+0x73>

00800252 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1b>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800275:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 10             	pushl  0x10(%ebp)
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	ff 75 08             	pushl  0x8(%ebp)
  800282:	e8 05 00 00 00       	call   80028c <vprintfmt>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <vprintfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 2c             	sub    $0x2c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 21 04 00 00       	jmp    8006c4 <vprintfmt+0x438>
		padc = ' ';
  8002a3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002a7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c1:	8d 47 01             	lea    0x1(%edi),%eax
  8002c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c7:	0f b6 17             	movzbl (%edi),%edx
  8002ca:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cd:	3c 55                	cmp    $0x55,%al
  8002cf:	0f 87 90 04 00 00    	ja     800765 <vprintfmt+0x4d9>
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  8002df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e6:	eb d9                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002eb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ef:	eb d0                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	0f b6 d2             	movzbl %dl,%edx
  8002f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800302:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800306:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800309:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030c:	83 f9 09             	cmp    $0x9,%ecx
  80030f:	77 55                	ja     800366 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800311:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800314:	eb e9                	jmp    8002ff <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800316:	8b 45 14             	mov    0x14(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031e:	8b 45 14             	mov    0x14(%ebp),%eax
  800321:	8d 40 04             	lea    0x4(%eax),%eax
  800324:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032e:	79 91                	jns    8002c1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800330:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800333:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800336:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80033d:	eb 82                	jmp    8002c1 <vprintfmt+0x35>
  80033f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800342:	85 c0                	test   %eax,%eax
  800344:	ba 00 00 00 00       	mov    $0x0,%edx
  800349:	0f 49 d0             	cmovns %eax,%edx
  80034c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800352:	e9 6a ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800361:	e9 5b ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800366:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800369:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036c:	eb bc                	jmp    80032a <vprintfmt+0x9e>
			lflag++;
  80036e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800374:	e9 48 ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800379:	8b 45 14             	mov    0x14(%ebp),%eax
  80037c:	8d 78 04             	lea    0x4(%eax),%edi
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	53                   	push   %ebx
  800383:	ff 30                	pushl  (%eax)
  800385:	ff d6                	call   *%esi
			break;
  800387:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80038d:	e9 2f 03 00 00       	jmp    8006c1 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	8d 78 04             	lea    0x4(%eax),%edi
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	99                   	cltd   
  80039b:	31 d0                	xor    %edx,%eax
  80039d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039f:	83 f8 0f             	cmp    $0xf,%eax
  8003a2:	7f 23                	jg     8003c7 <vprintfmt+0x13b>
  8003a4:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  8003ab:	85 d2                	test   %edx,%edx
  8003ad:	74 18                	je     8003c7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003af:	52                   	push   %edx
  8003b0:	68 db 27 80 00       	push   $0x8027db
  8003b5:	53                   	push   %ebx
  8003b6:	56                   	push   %esi
  8003b7:	e8 b3 fe ff ff       	call   80026f <printfmt>
  8003bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c2:	e9 fa 02 00 00       	jmp    8006c1 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8003c7:	50                   	push   %eax
  8003c8:	68 ed 23 80 00       	push   $0x8023ed
  8003cd:	53                   	push   %ebx
  8003ce:	56                   	push   %esi
  8003cf:	e8 9b fe ff ff       	call   80026f <printfmt>
  8003d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003da:	e9 e2 02 00 00       	jmp    8006c1 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	83 c0 04             	add    $0x4,%eax
  8003e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ed:	85 ff                	test   %edi,%edi
  8003ef:	b8 e6 23 80 00       	mov    $0x8023e6,%eax
  8003f4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fb:	0f 8e bd 00 00 00    	jle    8004be <vprintfmt+0x232>
  800401:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800405:	75 0e                	jne    800415 <vprintfmt+0x189>
  800407:	89 75 08             	mov    %esi,0x8(%ebp)
  80040a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80040d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800410:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800413:	eb 6d                	jmp    800482 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	ff 75 d0             	pushl  -0x30(%ebp)
  80041b:	57                   	push   %edi
  80041c:	e8 ec 03 00 00       	call   80080d <strnlen>
  800421:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800424:	29 c1                	sub    %eax,%ecx
  800426:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800429:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80042c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800436:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	eb 0f                	jmp    800449 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	53                   	push   %ebx
  80043e:	ff 75 e0             	pushl  -0x20(%ebp)
  800441:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800443:	83 ef 01             	sub    $0x1,%edi
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	85 ff                	test   %edi,%edi
  80044b:	7f ed                	jg     80043a <vprintfmt+0x1ae>
  80044d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800450:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800453:	85 c9                	test   %ecx,%ecx
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	0f 49 c1             	cmovns %ecx,%eax
  80045d:	29 c1                	sub    %eax,%ecx
  80045f:	89 75 08             	mov    %esi,0x8(%ebp)
  800462:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800465:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800468:	89 cb                	mov    %ecx,%ebx
  80046a:	eb 16                	jmp    800482 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80046c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800470:	75 31                	jne    8004a3 <vprintfmt+0x217>
					putch(ch, putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	50                   	push   %eax
  800479:	ff 55 08             	call   *0x8(%ebp)
  80047c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	83 c7 01             	add    $0x1,%edi
  800485:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800489:	0f be c2             	movsbl %dl,%eax
  80048c:	85 c0                	test   %eax,%eax
  80048e:	74 59                	je     8004e9 <vprintfmt+0x25d>
  800490:	85 f6                	test   %esi,%esi
  800492:	78 d8                	js     80046c <vprintfmt+0x1e0>
  800494:	83 ee 01             	sub    $0x1,%esi
  800497:	79 d3                	jns    80046c <vprintfmt+0x1e0>
  800499:	89 df                	mov    %ebx,%edi
  80049b:	8b 75 08             	mov    0x8(%ebp),%esi
  80049e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a1:	eb 37                	jmp    8004da <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a3:	0f be d2             	movsbl %dl,%edx
  8004a6:	83 ea 20             	sub    $0x20,%edx
  8004a9:	83 fa 5e             	cmp    $0x5e,%edx
  8004ac:	76 c4                	jbe    800472 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	6a 3f                	push   $0x3f
  8004b6:	ff 55 08             	call   *0x8(%ebp)
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	eb c1                	jmp    80047f <vprintfmt+0x1f3>
  8004be:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ca:	eb b6                	jmp    800482 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	53                   	push   %ebx
  8004d0:	6a 20                	push   $0x20
  8004d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d4:	83 ef 01             	sub    $0x1,%edi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	85 ff                	test   %edi,%edi
  8004dc:	7f ee                	jg     8004cc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e4:	e9 d8 01 00 00       	jmp    8006c1 <vprintfmt+0x435>
  8004e9:	89 df                	mov    %ebx,%edi
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f1:	eb e7                	jmp    8004da <vprintfmt+0x24e>
	if (lflag >= 2)
  8004f3:	83 f9 01             	cmp    $0x1,%ecx
  8004f6:	7e 45                	jle    80053d <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 50 04             	mov    0x4(%eax),%edx
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800503:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 40 08             	lea    0x8(%eax),%eax
  80050c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800513:	79 62                	jns    800577 <vprintfmt+0x2eb>
				putch('-', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 2d                	push   $0x2d
  80051b:	ff d6                	call   *%esi
				num = -(long long) num;
  80051d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800520:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800523:	f7 d8                	neg    %eax
  800525:	83 d2 00             	adc    $0x0,%edx
  800528:	f7 da                	neg    %edx
  80052a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800530:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800533:	ba 0a 00 00 00       	mov    $0xa,%edx
  800538:	e9 66 01 00 00       	jmp    8006a3 <vprintfmt+0x417>
	else if (lflag)
  80053d:	85 c9                	test   %ecx,%ecx
  80053f:	75 1b                	jne    80055c <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800549:	89 c1                	mov    %eax,%ecx
  80054b:	c1 f9 1f             	sar    $0x1f,%ecx
  80054e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	eb b3                	jmp    80050f <vprintfmt+0x283>
		return va_arg(*ap, long);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 c1                	mov    %eax,%ecx
  800566:	c1 f9 1f             	sar    $0x1f,%ecx
  800569:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8d 40 04             	lea    0x4(%eax),%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
  800575:	eb 98                	jmp    80050f <vprintfmt+0x283>
			base = 10;
  800577:	ba 0a 00 00 00       	mov    $0xa,%edx
  80057c:	e9 22 01 00 00       	jmp    8006a3 <vprintfmt+0x417>
	if (lflag >= 2)
  800581:	83 f9 01             	cmp    $0x1,%ecx
  800584:	7e 21                	jle    8005a7 <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 50 04             	mov    0x4(%eax),%edx
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800591:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 40 08             	lea    0x8(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059d:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a2:	e9 fc 00 00 00       	jmp    8006a3 <vprintfmt+0x417>
	else if (lflag)
  8005a7:	85 c9                	test   %ecx,%ecx
  8005a9:	75 23                	jne    8005ce <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 40 04             	lea    0x4(%eax),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005c9:	e9 d5 00 00 00       	jmp    8006a3 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005ec:	e9 b2 00 00 00       	jmp    8006a3 <vprintfmt+0x417>
	if (lflag >= 2)
  8005f1:	83 f9 01             	cmp    $0x1,%ecx
  8005f4:	7e 42                	jle    800638 <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 50 04             	mov    0x4(%eax),%edx
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 40 08             	lea    0x8(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060d:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  800612:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800616:	0f 89 87 00 00 00    	jns    8006a3 <vprintfmt+0x417>
				putch('-', putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	6a 2d                	push   $0x2d
  800622:	ff d6                	call   *%esi
				num = -(long long) num;
  800624:	f7 5d d8             	negl   -0x28(%ebp)
  800627:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  80062b:	f7 5d dc             	negl   -0x24(%ebp)
  80062e:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800631:	ba 08 00 00 00       	mov    $0x8,%edx
  800636:	eb 6b                	jmp    8006a3 <vprintfmt+0x417>
	else if (lflag)
  800638:	85 c9                	test   %ecx,%ecx
  80063a:	75 1b                	jne    800657 <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	ba 00 00 00 00       	mov    $0x0,%edx
  800646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800649:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
  800655:	eb b6                	jmp    80060d <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
  800670:	eb 9b                	jmp    80060d <vprintfmt+0x381>
			putch('0', putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	53                   	push   %ebx
  800676:	6a 30                	push   $0x30
  800678:	ff d6                	call   *%esi
			putch('x', putdat);
  80067a:	83 c4 08             	add    $0x8,%esp
  80067d:	53                   	push   %ebx
  80067e:	6a 78                	push   $0x78
  800680:	ff d6                	call   *%esi
			num = (unsigned long long)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
  80068c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800692:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069e:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  8006a3:	83 ec 0c             	sub    $0xc,%esp
  8006a6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006aa:	50                   	push   %eax
  8006ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ae:	52                   	push   %edx
  8006af:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b5:	89 da                	mov    %ebx,%edx
  8006b7:	89 f0                	mov    %esi,%eax
  8006b9:	e8 e5 fa ff ff       	call   8001a3 <printnum>
			break;
  8006be:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c4:	83 c7 01             	add    $0x1,%edi
  8006c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cb:	83 f8 25             	cmp    $0x25,%eax
  8006ce:	0f 84 cf fb ff ff    	je     8002a3 <vprintfmt+0x17>
			if (ch == '\0')
  8006d4:	85 c0                	test   %eax,%eax
  8006d6:	0f 84 a9 00 00 00    	je     800785 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	50                   	push   %eax
  8006e1:	ff d6                	call   *%esi
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	eb dc                	jmp    8006c4 <vprintfmt+0x438>
	if (lflag >= 2)
  8006e8:	83 f9 01             	cmp    $0x1,%ecx
  8006eb:	7e 1e                	jle    80070b <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 50 04             	mov    0x4(%eax),%edx
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800704:	ba 10 00 00 00       	mov    $0x10,%edx
  800709:	eb 98                	jmp    8006a3 <vprintfmt+0x417>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	75 23                	jne    800732 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	ba 00 00 00 00       	mov    $0x0,%edx
  800719:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800728:	ba 10 00 00 00       	mov    $0x10,%edx
  80072d:	e9 71 ff ff ff       	jmp    8006a3 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	ba 10 00 00 00       	mov    $0x10,%edx
  800750:	e9 4e ff ff ff       	jmp    8006a3 <vprintfmt+0x417>
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 25                	push   $0x25
  80075b:	ff d6                	call   *%esi
			break;
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	e9 5c ff ff ff       	jmp    8006c1 <vprintfmt+0x435>
			putch('%', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	6a 25                	push   $0x25
  80076b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 f8                	mov    %edi,%eax
  800772:	eb 03                	jmp    800777 <vprintfmt+0x4eb>
  800774:	83 e8 01             	sub    $0x1,%eax
  800777:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80077b:	75 f7                	jne    800774 <vprintfmt+0x4e8>
  80077d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800780:	e9 3c ff ff ff       	jmp    8006c1 <vprintfmt+0x435>
}
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 18             	sub    $0x18,%esp
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800799:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80079c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007aa:	85 c0                	test   %eax,%eax
  8007ac:	74 26                	je     8007d4 <vsnprintf+0x47>
  8007ae:	85 d2                	test   %edx,%edx
  8007b0:	7e 22                	jle    8007d4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b2:	ff 75 14             	pushl  0x14(%ebp)
  8007b5:	ff 75 10             	pushl  0x10(%ebp)
  8007b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bb:	50                   	push   %eax
  8007bc:	68 52 02 80 00       	push   $0x800252
  8007c1:	e8 c6 fa ff ff       	call   80028c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cf:	83 c4 10             	add    $0x10,%esp
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    
		return -E_INVAL;
  8007d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d9:	eb f7                	jmp    8007d2 <vsnprintf+0x45>

008007db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e4:	50                   	push   %eax
  8007e5:	ff 75 10             	pushl  0x10(%ebp)
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	ff 75 08             	pushl  0x8(%ebp)
  8007ee:	e8 9a ff ff ff       	call   80078d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	eb 03                	jmp    800805 <strlen+0x10>
		n++;
  800802:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800805:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800809:	75 f7                	jne    800802 <strlen+0xd>
	return n;
}
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800813:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	eb 03                	jmp    800820 <strnlen+0x13>
		n++;
  80081d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800820:	39 d0                	cmp    %edx,%eax
  800822:	74 06                	je     80082a <strnlen+0x1d>
  800824:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800828:	75 f3                	jne    80081d <strnlen+0x10>
	return n;
}
  80082a:	5d                   	pop    %ebp
  80082b:	c3                   	ret    

0080082c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800836:	89 c2                	mov    %eax,%edx
  800838:	83 c1 01             	add    $0x1,%ecx
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800842:	88 5a ff             	mov    %bl,-0x1(%edx)
  800845:	84 db                	test   %bl,%bl
  800847:	75 ef                	jne    800838 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800849:	5b                   	pop    %ebx
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	53                   	push   %ebx
  800850:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800853:	53                   	push   %ebx
  800854:	e8 9c ff ff ff       	call   8007f5 <strlen>
  800859:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	01 d8                	add    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	e8 c5 ff ff ff       	call   80082c <strcpy>
	return dst;
}
  800867:	89 d8                	mov    %ebx,%eax
  800869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086c:	c9                   	leave  
  80086d:	c3                   	ret    

0080086e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	56                   	push   %esi
  800872:	53                   	push   %ebx
  800873:	8b 75 08             	mov    0x8(%ebp),%esi
  800876:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800879:	89 f3                	mov    %esi,%ebx
  80087b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80087e:	89 f2                	mov    %esi,%edx
  800880:	eb 0f                	jmp    800891 <strncpy+0x23>
		*dst++ = *src;
  800882:	83 c2 01             	add    $0x1,%edx
  800885:	0f b6 01             	movzbl (%ecx),%eax
  800888:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088b:	80 39 01             	cmpb   $0x1,(%ecx)
  80088e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800891:	39 da                	cmp    %ebx,%edx
  800893:	75 ed                	jne    800882 <strncpy+0x14>
	}
	return ret;
}
  800895:	89 f0                	mov    %esi,%eax
  800897:	5b                   	pop    %ebx
  800898:	5e                   	pop    %esi
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
  8008a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008af:	85 c9                	test   %ecx,%ecx
  8008b1:	75 0b                	jne    8008be <strlcpy+0x23>
  8008b3:	eb 17                	jmp    8008cc <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b5:	83 c2 01             	add    $0x1,%edx
  8008b8:	83 c0 01             	add    $0x1,%eax
  8008bb:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008be:	39 d8                	cmp    %ebx,%eax
  8008c0:	74 07                	je     8008c9 <strlcpy+0x2e>
  8008c2:	0f b6 0a             	movzbl (%edx),%ecx
  8008c5:	84 c9                	test   %cl,%cl
  8008c7:	75 ec                	jne    8008b5 <strlcpy+0x1a>
		*dst = '\0';
  8008c9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008cc:	29 f0                	sub    %esi,%eax
}
  8008ce:	5b                   	pop    %ebx
  8008cf:	5e                   	pop    %esi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008db:	eb 06                	jmp    8008e3 <strcmp+0x11>
		p++, q++;
  8008dd:	83 c1 01             	add    $0x1,%ecx
  8008e0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008e3:	0f b6 01             	movzbl (%ecx),%eax
  8008e6:	84 c0                	test   %al,%al
  8008e8:	74 04                	je     8008ee <strcmp+0x1c>
  8008ea:	3a 02                	cmp    (%edx),%al
  8008ec:	74 ef                	je     8008dd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ee:	0f b6 c0             	movzbl %al,%eax
  8008f1:	0f b6 12             	movzbl (%edx),%edx
  8008f4:	29 d0                	sub    %edx,%eax
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	53                   	push   %ebx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800902:	89 c3                	mov    %eax,%ebx
  800904:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800907:	eb 06                	jmp    80090f <strncmp+0x17>
		n--, p++, q++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80090f:	39 d8                	cmp    %ebx,%eax
  800911:	74 16                	je     800929 <strncmp+0x31>
  800913:	0f b6 08             	movzbl (%eax),%ecx
  800916:	84 c9                	test   %cl,%cl
  800918:	74 04                	je     80091e <strncmp+0x26>
  80091a:	3a 0a                	cmp    (%edx),%cl
  80091c:	74 eb                	je     800909 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80091e:	0f b6 00             	movzbl (%eax),%eax
  800921:	0f b6 12             	movzbl (%edx),%edx
  800924:	29 d0                	sub    %edx,%eax
}
  800926:	5b                   	pop    %ebx
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    
		return 0;
  800929:	b8 00 00 00 00       	mov    $0x0,%eax
  80092e:	eb f6                	jmp    800926 <strncmp+0x2e>

00800930 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093a:	0f b6 10             	movzbl (%eax),%edx
  80093d:	84 d2                	test   %dl,%dl
  80093f:	74 09                	je     80094a <strchr+0x1a>
		if (*s == c)
  800941:	38 ca                	cmp    %cl,%dl
  800943:	74 0a                	je     80094f <strchr+0x1f>
	for (; *s; s++)
  800945:	83 c0 01             	add    $0x1,%eax
  800948:	eb f0                	jmp    80093a <strchr+0xa>
			return (char *) s;
	return 0;
  80094a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095b:	eb 03                	jmp    800960 <strfind+0xf>
  80095d:	83 c0 01             	add    $0x1,%eax
  800960:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800963:	38 ca                	cmp    %cl,%dl
  800965:	74 04                	je     80096b <strfind+0x1a>
  800967:	84 d2                	test   %dl,%dl
  800969:	75 f2                	jne    80095d <strfind+0xc>
			break;
	return (char *) s;
}
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	57                   	push   %edi
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	8b 7d 08             	mov    0x8(%ebp),%edi
  800976:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800979:	85 c9                	test   %ecx,%ecx
  80097b:	74 13                	je     800990 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800983:	75 05                	jne    80098a <memset+0x1d>
  800985:	f6 c1 03             	test   $0x3,%cl
  800988:	74 0d                	je     800997 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	fc                   	cld    
  80098e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800990:	89 f8                	mov    %edi,%eax
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5f                   	pop    %edi
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    
		c &= 0xFF;
  800997:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80099b:	89 d3                	mov    %edx,%ebx
  80099d:	c1 e3 08             	shl    $0x8,%ebx
  8009a0:	89 d0                	mov    %edx,%eax
  8009a2:	c1 e0 18             	shl    $0x18,%eax
  8009a5:	89 d6                	mov    %edx,%esi
  8009a7:	c1 e6 10             	shl    $0x10,%esi
  8009aa:	09 f0                	or     %esi,%eax
  8009ac:	09 c2                	or     %eax,%edx
  8009ae:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009b0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b3:	89 d0                	mov    %edx,%eax
  8009b5:	fc                   	cld    
  8009b6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b8:	eb d6                	jmp    800990 <memset+0x23>

008009ba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	57                   	push   %edi
  8009be:	56                   	push   %esi
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c8:	39 c6                	cmp    %eax,%esi
  8009ca:	73 35                	jae    800a01 <memmove+0x47>
  8009cc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cf:	39 c2                	cmp    %eax,%edx
  8009d1:	76 2e                	jbe    800a01 <memmove+0x47>
		s += n;
		d += n;
  8009d3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d6:	89 d6                	mov    %edx,%esi
  8009d8:	09 fe                	or     %edi,%esi
  8009da:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e0:	74 0c                	je     8009ee <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e2:	83 ef 01             	sub    $0x1,%edi
  8009e5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e8:	fd                   	std    
  8009e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009eb:	fc                   	cld    
  8009ec:	eb 21                	jmp    800a0f <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ee:	f6 c1 03             	test   $0x3,%cl
  8009f1:	75 ef                	jne    8009e2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f3:	83 ef 04             	sub    $0x4,%edi
  8009f6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009fc:	fd                   	std    
  8009fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ff:	eb ea                	jmp    8009eb <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a01:	89 f2                	mov    %esi,%edx
  800a03:	09 c2                	or     %eax,%edx
  800a05:	f6 c2 03             	test   $0x3,%dl
  800a08:	74 09                	je     800a13 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a0a:	89 c7                	mov    %eax,%edi
  800a0c:	fc                   	cld    
  800a0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a0f:	5e                   	pop    %esi
  800a10:	5f                   	pop    %edi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a13:	f6 c1 03             	test   $0x3,%cl
  800a16:	75 f2                	jne    800a0a <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a1b:	89 c7                	mov    %eax,%edi
  800a1d:	fc                   	cld    
  800a1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a20:	eb ed                	jmp    800a0f <memmove+0x55>

00800a22 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a25:	ff 75 10             	pushl  0x10(%ebp)
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	ff 75 08             	pushl  0x8(%ebp)
  800a2e:	e8 87 ff ff ff       	call   8009ba <memmove>
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a40:	89 c6                	mov    %eax,%esi
  800a42:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a45:	39 f0                	cmp    %esi,%eax
  800a47:	74 1c                	je     800a65 <memcmp+0x30>
		if (*s1 != *s2)
  800a49:	0f b6 08             	movzbl (%eax),%ecx
  800a4c:	0f b6 1a             	movzbl (%edx),%ebx
  800a4f:	38 d9                	cmp    %bl,%cl
  800a51:	75 08                	jne    800a5b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a53:	83 c0 01             	add    $0x1,%eax
  800a56:	83 c2 01             	add    $0x1,%edx
  800a59:	eb ea                	jmp    800a45 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a5b:	0f b6 c1             	movzbl %cl,%eax
  800a5e:	0f b6 db             	movzbl %bl,%ebx
  800a61:	29 d8                	sub    %ebx,%eax
  800a63:	eb 05                	jmp    800a6a <memcmp+0x35>
	}

	return 0;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a77:	89 c2                	mov    %eax,%edx
  800a79:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a7c:	39 d0                	cmp    %edx,%eax
  800a7e:	73 09                	jae    800a89 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a80:	38 08                	cmp    %cl,(%eax)
  800a82:	74 05                	je     800a89 <memfind+0x1b>
	for (; s < ends; s++)
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	eb f3                	jmp    800a7c <memfind+0xe>
			break;
	return (void *) s;
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	57                   	push   %edi
  800a8f:	56                   	push   %esi
  800a90:	53                   	push   %ebx
  800a91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a97:	eb 03                	jmp    800a9c <strtol+0x11>
		s++;
  800a99:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a9c:	0f b6 01             	movzbl (%ecx),%eax
  800a9f:	3c 20                	cmp    $0x20,%al
  800aa1:	74 f6                	je     800a99 <strtol+0xe>
  800aa3:	3c 09                	cmp    $0x9,%al
  800aa5:	74 f2                	je     800a99 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aa7:	3c 2b                	cmp    $0x2b,%al
  800aa9:	74 2e                	je     800ad9 <strtol+0x4e>
	int neg = 0;
  800aab:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ab0:	3c 2d                	cmp    $0x2d,%al
  800ab2:	74 2f                	je     800ae3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aba:	75 05                	jne    800ac1 <strtol+0x36>
  800abc:	80 39 30             	cmpb   $0x30,(%ecx)
  800abf:	74 2c                	je     800aed <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ac1:	85 db                	test   %ebx,%ebx
  800ac3:	75 0a                	jne    800acf <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac5:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aca:	80 39 30             	cmpb   $0x30,(%ecx)
  800acd:	74 28                	je     800af7 <strtol+0x6c>
		base = 10;
  800acf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad7:	eb 50                	jmp    800b29 <strtol+0x9e>
		s++;
  800ad9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800adc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae1:	eb d1                	jmp    800ab4 <strtol+0x29>
		s++, neg = 1;
  800ae3:	83 c1 01             	add    $0x1,%ecx
  800ae6:	bf 01 00 00 00       	mov    $0x1,%edi
  800aeb:	eb c7                	jmp    800ab4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aed:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af1:	74 0e                	je     800b01 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800af3:	85 db                	test   %ebx,%ebx
  800af5:	75 d8                	jne    800acf <strtol+0x44>
		s++, base = 8;
  800af7:	83 c1 01             	add    $0x1,%ecx
  800afa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aff:	eb ce                	jmp    800acf <strtol+0x44>
		s += 2, base = 16;
  800b01:	83 c1 02             	add    $0x2,%ecx
  800b04:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b09:	eb c4                	jmp    800acf <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b0b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0e:	89 f3                	mov    %esi,%ebx
  800b10:	80 fb 19             	cmp    $0x19,%bl
  800b13:	77 29                	ja     800b3e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b15:	0f be d2             	movsbl %dl,%edx
  800b18:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b1b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1e:	7d 30                	jge    800b50 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b20:	83 c1 01             	add    $0x1,%ecx
  800b23:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b27:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b29:	0f b6 11             	movzbl (%ecx),%edx
  800b2c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2f:	89 f3                	mov    %esi,%ebx
  800b31:	80 fb 09             	cmp    $0x9,%bl
  800b34:	77 d5                	ja     800b0b <strtol+0x80>
			dig = *s - '0';
  800b36:	0f be d2             	movsbl %dl,%edx
  800b39:	83 ea 30             	sub    $0x30,%edx
  800b3c:	eb dd                	jmp    800b1b <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b3e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b41:	89 f3                	mov    %esi,%ebx
  800b43:	80 fb 19             	cmp    $0x19,%bl
  800b46:	77 08                	ja     800b50 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b48:	0f be d2             	movsbl %dl,%edx
  800b4b:	83 ea 37             	sub    $0x37,%edx
  800b4e:	eb cb                	jmp    800b1b <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b54:	74 05                	je     800b5b <strtol+0xd0>
		*endptr = (char *) s;
  800b56:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b59:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	f7 da                	neg    %edx
  800b5f:	85 ff                	test   %edi,%edi
  800b61:	0f 45 c2             	cmovne %edx,%eax
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5f                   	pop    %edi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7a:	89 c3                	mov    %eax,%ebx
  800b7c:	89 c7                	mov    %eax,%edi
  800b7e:	89 c6                	mov    %eax,%esi
  800b80:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	b8 01 00 00 00       	mov    $0x1,%eax
  800b97:	89 d1                	mov    %edx,%ecx
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	89 d7                	mov    %edx,%edi
  800b9d:	89 d6                	mov    %edx,%esi
  800b9f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
  800bac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800baf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bbc:	89 cb                	mov    %ecx,%ebx
  800bbe:	89 cf                	mov    %ecx,%edi
  800bc0:	89 ce                	mov    %ecx,%esi
  800bc2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc4:	85 c0                	test   %eax,%eax
  800bc6:	7f 08                	jg     800bd0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bcb:	5b                   	pop    %ebx
  800bcc:	5e                   	pop    %esi
  800bcd:	5f                   	pop    %edi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	50                   	push   %eax
  800bd4:	6a 03                	push   $0x3
  800bd6:	68 df 26 80 00       	push   $0x8026df
  800bdb:	6a 23                	push   $0x23
  800bdd:	68 fc 26 80 00       	push   $0x8026fc
  800be2:	e8 ad 13 00 00       	call   801f94 <_panic>

00800be7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bed:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf2:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf7:	89 d1                	mov    %edx,%ecx
  800bf9:	89 d3                	mov    %edx,%ebx
  800bfb:	89 d7                	mov    %edx,%edi
  800bfd:	89 d6                	mov    %edx,%esi
  800bff:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <sys_yield>:

void
sys_yield(void)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c11:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c16:	89 d1                	mov    %edx,%ecx
  800c18:	89 d3                	mov    %edx,%ebx
  800c1a:	89 d7                	mov    %edx,%edi
  800c1c:	89 d6                	mov    %edx,%esi
  800c1e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
  800c2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2e:	be 00 00 00 00       	mov    $0x0,%esi
  800c33:	8b 55 08             	mov    0x8(%ebp),%edx
  800c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c39:	b8 04 00 00 00       	mov    $0x4,%eax
  800c3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c41:	89 f7                	mov    %esi,%edi
  800c43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c45:	85 c0                	test   %eax,%eax
  800c47:	7f 08                	jg     800c51 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4c:	5b                   	pop    %ebx
  800c4d:	5e                   	pop    %esi
  800c4e:	5f                   	pop    %edi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c51:	83 ec 0c             	sub    $0xc,%esp
  800c54:	50                   	push   %eax
  800c55:	6a 04                	push   $0x4
  800c57:	68 df 26 80 00       	push   $0x8026df
  800c5c:	6a 23                	push   $0x23
  800c5e:	68 fc 26 80 00       	push   $0x8026fc
  800c63:	e8 2c 13 00 00       	call   801f94 <_panic>

00800c68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	57                   	push   %edi
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c71:	8b 55 08             	mov    0x8(%ebp),%edx
  800c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c77:	b8 05 00 00 00       	mov    $0x5,%eax
  800c7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c82:	8b 75 18             	mov    0x18(%ebp),%esi
  800c85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	7f 08                	jg     800c93 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	50                   	push   %eax
  800c97:	6a 05                	push   $0x5
  800c99:	68 df 26 80 00       	push   $0x8026df
  800c9e:	6a 23                	push   $0x23
  800ca0:	68 fc 26 80 00       	push   $0x8026fc
  800ca5:	e8 ea 12 00 00       	call   801f94 <_panic>

00800caa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbe:	b8 06 00 00 00       	mov    $0x6,%eax
  800cc3:	89 df                	mov    %ebx,%edi
  800cc5:	89 de                	mov    %ebx,%esi
  800cc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7f 08                	jg     800cd5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	50                   	push   %eax
  800cd9:	6a 06                	push   $0x6
  800cdb:	68 df 26 80 00       	push   $0x8026df
  800ce0:	6a 23                	push   $0x23
  800ce2:	68 fc 26 80 00       	push   $0x8026fc
  800ce7:	e8 a8 12 00 00       	call   801f94 <_panic>

00800cec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	b8 08 00 00 00       	mov    $0x8,%eax
  800d05:	89 df                	mov    %ebx,%edi
  800d07:	89 de                	mov    %ebx,%esi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 08                	push   $0x8
  800d1d:	68 df 26 80 00       	push   $0x8026df
  800d22:	6a 23                	push   $0x23
  800d24:	68 fc 26 80 00       	push   $0x8026fc
  800d29:	e8 66 12 00 00       	call   801f94 <_panic>

00800d2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 09 00 00 00       	mov    $0x9,%eax
  800d47:	89 df                	mov    %ebx,%edi
  800d49:	89 de                	mov    %ebx,%esi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 09                	push   $0x9
  800d5f:	68 df 26 80 00       	push   $0x8026df
  800d64:	6a 23                	push   $0x23
  800d66:	68 fc 26 80 00       	push   $0x8026fc
  800d6b:	e8 24 12 00 00       	call   801f94 <_panic>

00800d70 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 0a                	push   $0xa
  800da1:	68 df 26 80 00       	push   $0x8026df
  800da6:	6a 23                	push   $0x23
  800da8:	68 fc 26 80 00       	push   $0x8026fc
  800dad:	e8 e2 11 00 00       	call   801f94 <_panic>

00800db2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc3:	be 00 00 00 00       	mov    $0x0,%esi
  800dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dce:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
  800de6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800deb:	89 cb                	mov    %ecx,%ebx
  800ded:	89 cf                	mov    %ecx,%edi
  800def:	89 ce                	mov    %ecx,%esi
  800df1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	7f 08                	jg     800dff <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dff:	83 ec 0c             	sub    $0xc,%esp
  800e02:	50                   	push   %eax
  800e03:	6a 0d                	push   $0xd
  800e05:	68 df 26 80 00       	push   $0x8026df
  800e0a:	6a 23                	push   $0x23
  800e0c:	68 fc 26 80 00       	push   $0x8026fc
  800e11:	e8 7e 11 00 00       	call   801f94 <_panic>

00800e16 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e21:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e26:	89 d1                	mov    %edx,%ecx
  800e28:	89 d3                	mov    %edx,%ebx
  800e2a:	89 d7                	mov    %edx,%edi
  800e2c:	89 d6                	mov    %edx,%esi
  800e2e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	05 00 00 00 30       	add    $0x30000000,%eax
  800e40:	c1 e8 0c             	shr    $0xc,%eax
}
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e55:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e62:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	c1 ea 16             	shr    $0x16,%edx
  800e6c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e73:	f6 c2 01             	test   $0x1,%dl
  800e76:	74 2a                	je     800ea2 <fd_alloc+0x46>
  800e78:	89 c2                	mov    %eax,%edx
  800e7a:	c1 ea 0c             	shr    $0xc,%edx
  800e7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e84:	f6 c2 01             	test   $0x1,%dl
  800e87:	74 19                	je     800ea2 <fd_alloc+0x46>
  800e89:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e8e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e93:	75 d2                	jne    800e67 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e95:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e9b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ea0:	eb 07                	jmp    800ea9 <fd_alloc+0x4d>
			*fd_store = fd;
  800ea2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eb1:	83 f8 1f             	cmp    $0x1f,%eax
  800eb4:	77 36                	ja     800eec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eb6:	c1 e0 0c             	shl    $0xc,%eax
  800eb9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ebe:	89 c2                	mov    %eax,%edx
  800ec0:	c1 ea 16             	shr    $0x16,%edx
  800ec3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eca:	f6 c2 01             	test   $0x1,%dl
  800ecd:	74 24                	je     800ef3 <fd_lookup+0x48>
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	c1 ea 0c             	shr    $0xc,%edx
  800ed4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800edb:	f6 c2 01             	test   $0x1,%dl
  800ede:	74 1a                	je     800efa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee3:	89 02                	mov    %eax,(%edx)
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    
		return -E_INVAL;
  800eec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef1:	eb f7                	jmp    800eea <fd_lookup+0x3f>
		return -E_INVAL;
  800ef3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef8:	eb f0                	jmp    800eea <fd_lookup+0x3f>
  800efa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eff:	eb e9                	jmp    800eea <fd_lookup+0x3f>

00800f01 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0a:	ba 88 27 80 00       	mov    $0x802788,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f0f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f14:	39 08                	cmp    %ecx,(%eax)
  800f16:	74 33                	je     800f4b <dev_lookup+0x4a>
  800f18:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f1b:	8b 02                	mov    (%edx),%eax
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	75 f3                	jne    800f14 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f21:	a1 08 40 80 00       	mov    0x804008,%eax
  800f26:	8b 40 48             	mov    0x48(%eax),%eax
  800f29:	83 ec 04             	sub    $0x4,%esp
  800f2c:	51                   	push   %ecx
  800f2d:	50                   	push   %eax
  800f2e:	68 0c 27 80 00       	push   $0x80270c
  800f33:	e8 57 f2 ff ff       	call   80018f <cprintf>
	*dev = 0;
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f41:	83 c4 10             	add    $0x10,%esp
  800f44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    
			*dev = devtab[i];
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f50:	b8 00 00 00 00       	mov    $0x0,%eax
  800f55:	eb f2                	jmp    800f49 <dev_lookup+0x48>

00800f57 <fd_close>:
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
  800f5d:	83 ec 1c             	sub    $0x1c,%esp
  800f60:	8b 75 08             	mov    0x8(%ebp),%esi
  800f63:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f69:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f6a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f70:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f73:	50                   	push   %eax
  800f74:	e8 32 ff ff ff       	call   800eab <fd_lookup>
  800f79:	89 c3                	mov    %eax,%ebx
  800f7b:	83 c4 08             	add    $0x8,%esp
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	78 05                	js     800f87 <fd_close+0x30>
	    || fd != fd2)
  800f82:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f85:	74 16                	je     800f9d <fd_close+0x46>
		return (must_exist ? r : 0);
  800f87:	89 f8                	mov    %edi,%eax
  800f89:	84 c0                	test   %al,%al
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f90:	0f 44 d8             	cmove  %eax,%ebx
}
  800f93:	89 d8                	mov    %ebx,%eax
  800f95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fa3:	50                   	push   %eax
  800fa4:	ff 36                	pushl  (%esi)
  800fa6:	e8 56 ff ff ff       	call   800f01 <dev_lookup>
  800fab:	89 c3                	mov    %eax,%ebx
  800fad:	83 c4 10             	add    $0x10,%esp
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	78 15                	js     800fc9 <fd_close+0x72>
		if (dev->dev_close)
  800fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb7:	8b 40 10             	mov    0x10(%eax),%eax
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	74 1b                	je     800fd9 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fbe:	83 ec 0c             	sub    $0xc,%esp
  800fc1:	56                   	push   %esi
  800fc2:	ff d0                	call   *%eax
  800fc4:	89 c3                	mov    %eax,%ebx
  800fc6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	56                   	push   %esi
  800fcd:	6a 00                	push   $0x0
  800fcf:	e8 d6 fc ff ff       	call   800caa <sys_page_unmap>
	return r;
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	eb ba                	jmp    800f93 <fd_close+0x3c>
			r = 0;
  800fd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fde:	eb e9                	jmp    800fc9 <fd_close+0x72>

00800fe0 <close>:

int
close(int fdnum)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fe9:	50                   	push   %eax
  800fea:	ff 75 08             	pushl  0x8(%ebp)
  800fed:	e8 b9 fe ff ff       	call   800eab <fd_lookup>
  800ff2:	83 c4 08             	add    $0x8,%esp
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	78 10                	js     801009 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	6a 01                	push   $0x1
  800ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  801001:	e8 51 ff ff ff       	call   800f57 <fd_close>
  801006:	83 c4 10             	add    $0x10,%esp
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <close_all>:

void
close_all(void)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	53                   	push   %ebx
  80100f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	53                   	push   %ebx
  80101b:	e8 c0 ff ff ff       	call   800fe0 <close>
	for (i = 0; i < MAXFD; i++)
  801020:	83 c3 01             	add    $0x1,%ebx
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	83 fb 20             	cmp    $0x20,%ebx
  801029:	75 ec                	jne    801017 <close_all+0xc>
}
  80102b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
  801036:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801039:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80103c:	50                   	push   %eax
  80103d:	ff 75 08             	pushl  0x8(%ebp)
  801040:	e8 66 fe ff ff       	call   800eab <fd_lookup>
  801045:	89 c3                	mov    %eax,%ebx
  801047:	83 c4 08             	add    $0x8,%esp
  80104a:	85 c0                	test   %eax,%eax
  80104c:	0f 88 81 00 00 00    	js     8010d3 <dup+0xa3>
		return r;
	close(newfdnum);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	ff 75 0c             	pushl  0xc(%ebp)
  801058:	e8 83 ff ff ff       	call   800fe0 <close>

	newfd = INDEX2FD(newfdnum);
  80105d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801060:	c1 e6 0c             	shl    $0xc,%esi
  801063:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801069:	83 c4 04             	add    $0x4,%esp
  80106c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80106f:	e8 d1 fd ff ff       	call   800e45 <fd2data>
  801074:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801076:	89 34 24             	mov    %esi,(%esp)
  801079:	e8 c7 fd ff ff       	call   800e45 <fd2data>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801083:	89 d8                	mov    %ebx,%eax
  801085:	c1 e8 16             	shr    $0x16,%eax
  801088:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80108f:	a8 01                	test   $0x1,%al
  801091:	74 11                	je     8010a4 <dup+0x74>
  801093:	89 d8                	mov    %ebx,%eax
  801095:	c1 e8 0c             	shr    $0xc,%eax
  801098:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	75 39                	jne    8010dd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010a7:	89 d0                	mov    %edx,%eax
  8010a9:	c1 e8 0c             	shr    $0xc,%eax
  8010ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8010bb:	50                   	push   %eax
  8010bc:	56                   	push   %esi
  8010bd:	6a 00                	push   $0x0
  8010bf:	52                   	push   %edx
  8010c0:	6a 00                	push   $0x0
  8010c2:	e8 a1 fb ff ff       	call   800c68 <sys_page_map>
  8010c7:	89 c3                	mov    %eax,%ebx
  8010c9:	83 c4 20             	add    $0x20,%esp
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	78 31                	js     801101 <dup+0xd1>
		goto err;

	return newfdnum;
  8010d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010d3:	89 d8                	mov    %ebx,%eax
  8010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5f                   	pop    %edi
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010e4:	83 ec 0c             	sub    $0xc,%esp
  8010e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ec:	50                   	push   %eax
  8010ed:	57                   	push   %edi
  8010ee:	6a 00                	push   $0x0
  8010f0:	53                   	push   %ebx
  8010f1:	6a 00                	push   $0x0
  8010f3:	e8 70 fb ff ff       	call   800c68 <sys_page_map>
  8010f8:	89 c3                	mov    %eax,%ebx
  8010fa:	83 c4 20             	add    $0x20,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	79 a3                	jns    8010a4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	56                   	push   %esi
  801105:	6a 00                	push   $0x0
  801107:	e8 9e fb ff ff       	call   800caa <sys_page_unmap>
	sys_page_unmap(0, nva);
  80110c:	83 c4 08             	add    $0x8,%esp
  80110f:	57                   	push   %edi
  801110:	6a 00                	push   $0x0
  801112:	e8 93 fb ff ff       	call   800caa <sys_page_unmap>
	return r;
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	eb b7                	jmp    8010d3 <dup+0xa3>

0080111c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	53                   	push   %ebx
  801120:	83 ec 14             	sub    $0x14,%esp
  801123:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801126:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801129:	50                   	push   %eax
  80112a:	53                   	push   %ebx
  80112b:	e8 7b fd ff ff       	call   800eab <fd_lookup>
  801130:	83 c4 08             	add    $0x8,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	78 3f                	js     801176 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801137:	83 ec 08             	sub    $0x8,%esp
  80113a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80113d:	50                   	push   %eax
  80113e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801141:	ff 30                	pushl  (%eax)
  801143:	e8 b9 fd ff ff       	call   800f01 <dev_lookup>
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	85 c0                	test   %eax,%eax
  80114d:	78 27                	js     801176 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80114f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801152:	8b 42 08             	mov    0x8(%edx),%eax
  801155:	83 e0 03             	and    $0x3,%eax
  801158:	83 f8 01             	cmp    $0x1,%eax
  80115b:	74 1e                	je     80117b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80115d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801160:	8b 40 08             	mov    0x8(%eax),%eax
  801163:	85 c0                	test   %eax,%eax
  801165:	74 35                	je     80119c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	ff 75 10             	pushl  0x10(%ebp)
  80116d:	ff 75 0c             	pushl  0xc(%ebp)
  801170:	52                   	push   %edx
  801171:	ff d0                	call   *%eax
  801173:	83 c4 10             	add    $0x10,%esp
}
  801176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801179:	c9                   	leave  
  80117a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80117b:	a1 08 40 80 00       	mov    0x804008,%eax
  801180:	8b 40 48             	mov    0x48(%eax),%eax
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	53                   	push   %ebx
  801187:	50                   	push   %eax
  801188:	68 4d 27 80 00       	push   $0x80274d
  80118d:	e8 fd ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119a:	eb da                	jmp    801176 <read+0x5a>
		return -E_NOT_SUPP;
  80119c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011a1:	eb d3                	jmp    801176 <read+0x5a>

008011a3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	57                   	push   %edi
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 0c             	sub    $0xc,%esp
  8011ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b7:	39 f3                	cmp    %esi,%ebx
  8011b9:	73 25                	jae    8011e0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	89 f0                	mov    %esi,%eax
  8011c0:	29 d8                	sub    %ebx,%eax
  8011c2:	50                   	push   %eax
  8011c3:	89 d8                	mov    %ebx,%eax
  8011c5:	03 45 0c             	add    0xc(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	57                   	push   %edi
  8011ca:	e8 4d ff ff ff       	call   80111c <read>
		if (m < 0)
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	78 08                	js     8011de <readn+0x3b>
			return m;
		if (m == 0)
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	74 06                	je     8011e0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011da:	01 c3                	add    %eax,%ebx
  8011dc:	eb d9                	jmp    8011b7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011de:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011e0:	89 d8                	mov    %ebx,%eax
  8011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 14             	sub    $0x14,%esp
  8011f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f7:	50                   	push   %eax
  8011f8:	53                   	push   %ebx
  8011f9:	e8 ad fc ff ff       	call   800eab <fd_lookup>
  8011fe:	83 c4 08             	add    $0x8,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	78 3a                	js     80123f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801205:	83 ec 08             	sub    $0x8,%esp
  801208:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120b:	50                   	push   %eax
  80120c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120f:	ff 30                	pushl  (%eax)
  801211:	e8 eb fc ff ff       	call   800f01 <dev_lookup>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 22                	js     80123f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80121d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801220:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801224:	74 1e                	je     801244 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801229:	8b 52 0c             	mov    0xc(%edx),%edx
  80122c:	85 d2                	test   %edx,%edx
  80122e:	74 35                	je     801265 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	ff 75 10             	pushl  0x10(%ebp)
  801236:	ff 75 0c             	pushl  0xc(%ebp)
  801239:	50                   	push   %eax
  80123a:	ff d2                	call   *%edx
  80123c:	83 c4 10             	add    $0x10,%esp
}
  80123f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801242:	c9                   	leave  
  801243:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801244:	a1 08 40 80 00       	mov    0x804008,%eax
  801249:	8b 40 48             	mov    0x48(%eax),%eax
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	53                   	push   %ebx
  801250:	50                   	push   %eax
  801251:	68 69 27 80 00       	push   $0x802769
  801256:	e8 34 ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  80125b:	83 c4 10             	add    $0x10,%esp
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801263:	eb da                	jmp    80123f <write+0x55>
		return -E_NOT_SUPP;
  801265:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80126a:	eb d3                	jmp    80123f <write+0x55>

0080126c <seek>:

int
seek(int fdnum, off_t offset)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801272:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801275:	50                   	push   %eax
  801276:	ff 75 08             	pushl  0x8(%ebp)
  801279:	e8 2d fc ff ff       	call   800eab <fd_lookup>
  80127e:	83 c4 08             	add    $0x8,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 0e                	js     801293 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801285:	8b 55 0c             	mov    0xc(%ebp),%edx
  801288:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80128e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	53                   	push   %ebx
  801299:	83 ec 14             	sub    $0x14,%esp
  80129c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	53                   	push   %ebx
  8012a4:	e8 02 fc ff ff       	call   800eab <fd_lookup>
  8012a9:	83 c4 08             	add    $0x8,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 37                	js     8012e7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b6:	50                   	push   %eax
  8012b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ba:	ff 30                	pushl  (%eax)
  8012bc:	e8 40 fc ff ff       	call   800f01 <dev_lookup>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	78 1f                	js     8012e7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012cf:	74 1b                	je     8012ec <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d4:	8b 52 18             	mov    0x18(%edx),%edx
  8012d7:	85 d2                	test   %edx,%edx
  8012d9:	74 32                	je     80130d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012db:	83 ec 08             	sub    $0x8,%esp
  8012de:	ff 75 0c             	pushl  0xc(%ebp)
  8012e1:	50                   	push   %eax
  8012e2:	ff d2                	call   *%edx
  8012e4:	83 c4 10             	add    $0x10,%esp
}
  8012e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012ec:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012f1:	8b 40 48             	mov    0x48(%eax),%eax
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	53                   	push   %ebx
  8012f8:	50                   	push   %eax
  8012f9:	68 2c 27 80 00       	push   $0x80272c
  8012fe:	e8 8c ee ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130b:	eb da                	jmp    8012e7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80130d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801312:	eb d3                	jmp    8012e7 <ftruncate+0x52>

00801314 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	53                   	push   %ebx
  801318:	83 ec 14             	sub    $0x14,%esp
  80131b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801321:	50                   	push   %eax
  801322:	ff 75 08             	pushl  0x8(%ebp)
  801325:	e8 81 fb ff ff       	call   800eab <fd_lookup>
  80132a:	83 c4 08             	add    $0x8,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 4b                	js     80137c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801331:	83 ec 08             	sub    $0x8,%esp
  801334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133b:	ff 30                	pushl  (%eax)
  80133d:	e8 bf fb ff ff       	call   800f01 <dev_lookup>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 33                	js     80137c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801350:	74 2f                	je     801381 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801352:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801355:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80135c:	00 00 00 
	stat->st_isdir = 0;
  80135f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801366:	00 00 00 
	stat->st_dev = dev;
  801369:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80136f:	83 ec 08             	sub    $0x8,%esp
  801372:	53                   	push   %ebx
  801373:	ff 75 f0             	pushl  -0x10(%ebp)
  801376:	ff 50 14             	call   *0x14(%eax)
  801379:	83 c4 10             	add    $0x10,%esp
}
  80137c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137f:	c9                   	leave  
  801380:	c3                   	ret    
		return -E_NOT_SUPP;
  801381:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801386:	eb f4                	jmp    80137c <fstat+0x68>

00801388 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	6a 00                	push   $0x0
  801392:	ff 75 08             	pushl  0x8(%ebp)
  801395:	e8 26 02 00 00       	call   8015c0 <open>
  80139a:	89 c3                	mov    %eax,%ebx
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 1b                	js     8013be <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013a3:	83 ec 08             	sub    $0x8,%esp
  8013a6:	ff 75 0c             	pushl  0xc(%ebp)
  8013a9:	50                   	push   %eax
  8013aa:	e8 65 ff ff ff       	call   801314 <fstat>
  8013af:	89 c6                	mov    %eax,%esi
	close(fd);
  8013b1:	89 1c 24             	mov    %ebx,(%esp)
  8013b4:	e8 27 fc ff ff       	call   800fe0 <close>
	return r;
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	89 f3                	mov    %esi,%ebx
}
  8013be:	89 d8                	mov    %ebx,%eax
  8013c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c3:	5b                   	pop    %ebx
  8013c4:	5e                   	pop    %esi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	56                   	push   %esi
  8013cb:	53                   	push   %ebx
  8013cc:	89 c6                	mov    %eax,%esi
  8013ce:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013d0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013d7:	74 27                	je     801400 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013d9:	6a 07                	push   $0x7
  8013db:	68 00 50 80 00       	push   $0x805000
  8013e0:	56                   	push   %esi
  8013e1:	ff 35 00 40 80 00    	pushl  0x804000
  8013e7:	e8 57 0c 00 00       	call   802043 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013ec:	83 c4 0c             	add    $0xc,%esp
  8013ef:	6a 00                	push   $0x0
  8013f1:	53                   	push   %ebx
  8013f2:	6a 00                	push   $0x0
  8013f4:	e8 e1 0b 00 00       	call   801fda <ipc_recv>
}
  8013f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013fc:	5b                   	pop    %ebx
  8013fd:	5e                   	pop    %esi
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	6a 01                	push   $0x1
  801405:	e8 92 0c 00 00       	call   80209c <ipc_find_env>
  80140a:	a3 00 40 80 00       	mov    %eax,0x804000
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	eb c5                	jmp    8013d9 <fsipc+0x12>

00801414 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8b 40 0c             	mov    0xc(%eax),%eax
  801420:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80142d:	ba 00 00 00 00       	mov    $0x0,%edx
  801432:	b8 02 00 00 00       	mov    $0x2,%eax
  801437:	e8 8b ff ff ff       	call   8013c7 <fsipc>
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <devfile_flush>:
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 40 0c             	mov    0xc(%eax),%eax
  80144a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80144f:	ba 00 00 00 00       	mov    $0x0,%edx
  801454:	b8 06 00 00 00       	mov    $0x6,%eax
  801459:	e8 69 ff ff ff       	call   8013c7 <fsipc>
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <devfile_stat>:
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8b 40 0c             	mov    0xc(%eax),%eax
  801470:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801475:	ba 00 00 00 00       	mov    $0x0,%edx
  80147a:	b8 05 00 00 00       	mov    $0x5,%eax
  80147f:	e8 43 ff ff ff       	call   8013c7 <fsipc>
  801484:	85 c0                	test   %eax,%eax
  801486:	78 2c                	js     8014b4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	68 00 50 80 00       	push   $0x805000
  801490:	53                   	push   %ebx
  801491:	e8 96 f3 ff ff       	call   80082c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801496:	a1 80 50 80 00       	mov    0x805080,%eax
  80149b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014a1:	a1 84 50 80 00       	mov    0x805084,%eax
  8014a6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <devfile_write>:
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	53                   	push   %ebx
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8014ce:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014d4:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014da:	77 30                	ja     80150c <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	53                   	push   %ebx
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	68 08 50 80 00       	push   $0x805008
  8014e8:	e8 cd f4 ff ff       	call   8009ba <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	b8 04 00 00 00       	mov    $0x4,%eax
  8014f7:	e8 cb fe ff ff       	call   8013c7 <fsipc>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 04                	js     801507 <devfile_write+0x4e>
	assert(r <= n);
  801503:	39 d8                	cmp    %ebx,%eax
  801505:	77 1e                	ja     801525 <devfile_write+0x6c>
}
  801507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  80150c:	68 9c 27 80 00       	push   $0x80279c
  801511:	68 c9 27 80 00       	push   $0x8027c9
  801516:	68 94 00 00 00       	push   $0x94
  80151b:	68 de 27 80 00       	push   $0x8027de
  801520:	e8 6f 0a 00 00       	call   801f94 <_panic>
	assert(r <= n);
  801525:	68 e9 27 80 00       	push   $0x8027e9
  80152a:	68 c9 27 80 00       	push   $0x8027c9
  80152f:	68 98 00 00 00       	push   $0x98
  801534:	68 de 27 80 00       	push   $0x8027de
  801539:	e8 56 0a 00 00       	call   801f94 <_panic>

0080153e <devfile_read>:
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8b 40 0c             	mov    0xc(%eax),%eax
  80154c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801551:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801557:	ba 00 00 00 00       	mov    $0x0,%edx
  80155c:	b8 03 00 00 00       	mov    $0x3,%eax
  801561:	e8 61 fe ff ff       	call   8013c7 <fsipc>
  801566:	89 c3                	mov    %eax,%ebx
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 1f                	js     80158b <devfile_read+0x4d>
	assert(r <= n);
  80156c:	39 f0                	cmp    %esi,%eax
  80156e:	77 24                	ja     801594 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801570:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801575:	7f 33                	jg     8015aa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	50                   	push   %eax
  80157b:	68 00 50 80 00       	push   $0x805000
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	e8 32 f4 ff ff       	call   8009ba <memmove>
	return r;
  801588:	83 c4 10             	add    $0x10,%esp
}
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    
	assert(r <= n);
  801594:	68 e9 27 80 00       	push   $0x8027e9
  801599:	68 c9 27 80 00       	push   $0x8027c9
  80159e:	6a 7c                	push   $0x7c
  8015a0:	68 de 27 80 00       	push   $0x8027de
  8015a5:	e8 ea 09 00 00       	call   801f94 <_panic>
	assert(r <= PGSIZE);
  8015aa:	68 f0 27 80 00       	push   $0x8027f0
  8015af:	68 c9 27 80 00       	push   $0x8027c9
  8015b4:	6a 7d                	push   $0x7d
  8015b6:	68 de 27 80 00       	push   $0x8027de
  8015bb:	e8 d4 09 00 00       	call   801f94 <_panic>

008015c0 <open>:
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	83 ec 1c             	sub    $0x1c,%esp
  8015c8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015cb:	56                   	push   %esi
  8015cc:	e8 24 f2 ff ff       	call   8007f5 <strlen>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015d9:	7f 6c                	jg     801647 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	e8 75 f8 ff ff       	call   800e5c <fd_alloc>
  8015e7:	89 c3                	mov    %eax,%ebx
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 3c                	js     80162c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	56                   	push   %esi
  8015f4:	68 00 50 80 00       	push   $0x805000
  8015f9:	e8 2e f2 ff ff       	call   80082c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801609:	b8 01 00 00 00       	mov    $0x1,%eax
  80160e:	e8 b4 fd ff ff       	call   8013c7 <fsipc>
  801613:	89 c3                	mov    %eax,%ebx
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 19                	js     801635 <open+0x75>
	return fd2num(fd);
  80161c:	83 ec 0c             	sub    $0xc,%esp
  80161f:	ff 75 f4             	pushl  -0xc(%ebp)
  801622:	e8 0e f8 ff ff       	call   800e35 <fd2num>
  801627:	89 c3                	mov    %eax,%ebx
  801629:	83 c4 10             	add    $0x10,%esp
}
  80162c:	89 d8                	mov    %ebx,%eax
  80162e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    
		fd_close(fd, 0);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	6a 00                	push   $0x0
  80163a:	ff 75 f4             	pushl  -0xc(%ebp)
  80163d:	e8 15 f9 ff ff       	call   800f57 <fd_close>
		return r;
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	eb e5                	jmp    80162c <open+0x6c>
		return -E_BAD_PATH;
  801647:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80164c:	eb de                	jmp    80162c <open+0x6c>

0080164e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801654:	ba 00 00 00 00       	mov    $0x0,%edx
  801659:	b8 08 00 00 00       	mov    $0x8,%eax
  80165e:	e8 64 fd ff ff       	call   8013c7 <fsipc>
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	56                   	push   %esi
  801669:	53                   	push   %ebx
  80166a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 cd f7 ff ff       	call   800e45 <fd2data>
  801678:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80167a:	83 c4 08             	add    $0x8,%esp
  80167d:	68 fc 27 80 00       	push   $0x8027fc
  801682:	53                   	push   %ebx
  801683:	e8 a4 f1 ff ff       	call   80082c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801688:	8b 46 04             	mov    0x4(%esi),%eax
  80168b:	2b 06                	sub    (%esi),%eax
  80168d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801693:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80169a:	00 00 00 
	stat->st_dev = &devpipe;
  80169d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016a4:	30 80 00 
	return 0;
}
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016af:	5b                   	pop    %ebx
  8016b0:	5e                   	pop    %esi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    

008016b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016bd:	53                   	push   %ebx
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 e5 f5 ff ff       	call   800caa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016c5:	89 1c 24             	mov    %ebx,(%esp)
  8016c8:	e8 78 f7 ff ff       	call   800e45 <fd2data>
  8016cd:	83 c4 08             	add    $0x8,%esp
  8016d0:	50                   	push   %eax
  8016d1:	6a 00                	push   $0x0
  8016d3:	e8 d2 f5 ff ff       	call   800caa <sys_page_unmap>
}
  8016d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <_pipeisclosed>:
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	57                   	push   %edi
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 1c             	sub    $0x1c,%esp
  8016e6:	89 c7                	mov    %eax,%edi
  8016e8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8016ef:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	57                   	push   %edi
  8016f6:	e8 da 09 00 00       	call   8020d5 <pageref>
  8016fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016fe:	89 34 24             	mov    %esi,(%esp)
  801701:	e8 cf 09 00 00       	call   8020d5 <pageref>
		nn = thisenv->env_runs;
  801706:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80170c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	39 cb                	cmp    %ecx,%ebx
  801714:	74 1b                	je     801731 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801716:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801719:	75 cf                	jne    8016ea <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80171b:	8b 42 58             	mov    0x58(%edx),%eax
  80171e:	6a 01                	push   $0x1
  801720:	50                   	push   %eax
  801721:	53                   	push   %ebx
  801722:	68 03 28 80 00       	push   $0x802803
  801727:	e8 63 ea ff ff       	call   80018f <cprintf>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	eb b9                	jmp    8016ea <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801731:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801734:	0f 94 c0             	sete   %al
  801737:	0f b6 c0             	movzbl %al,%eax
}
  80173a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5f                   	pop    %edi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    

00801742 <devpipe_write>:
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	57                   	push   %edi
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
  801748:	83 ec 28             	sub    $0x28,%esp
  80174b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80174e:	56                   	push   %esi
  80174f:	e8 f1 f6 ff ff       	call   800e45 <fd2data>
  801754:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	bf 00 00 00 00       	mov    $0x0,%edi
  80175e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801761:	74 4f                	je     8017b2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801763:	8b 43 04             	mov    0x4(%ebx),%eax
  801766:	8b 0b                	mov    (%ebx),%ecx
  801768:	8d 51 20             	lea    0x20(%ecx),%edx
  80176b:	39 d0                	cmp    %edx,%eax
  80176d:	72 14                	jb     801783 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80176f:	89 da                	mov    %ebx,%edx
  801771:	89 f0                	mov    %esi,%eax
  801773:	e8 65 ff ff ff       	call   8016dd <_pipeisclosed>
  801778:	85 c0                	test   %eax,%eax
  80177a:	75 3a                	jne    8017b6 <devpipe_write+0x74>
			sys_yield();
  80177c:	e8 85 f4 ff ff       	call   800c06 <sys_yield>
  801781:	eb e0                	jmp    801763 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801786:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80178a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80178d:	89 c2                	mov    %eax,%edx
  80178f:	c1 fa 1f             	sar    $0x1f,%edx
  801792:	89 d1                	mov    %edx,%ecx
  801794:	c1 e9 1b             	shr    $0x1b,%ecx
  801797:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80179a:	83 e2 1f             	and    $0x1f,%edx
  80179d:	29 ca                	sub    %ecx,%edx
  80179f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017a3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017a7:	83 c0 01             	add    $0x1,%eax
  8017aa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017ad:	83 c7 01             	add    $0x1,%edi
  8017b0:	eb ac                	jmp    80175e <devpipe_write+0x1c>
	return i;
  8017b2:	89 f8                	mov    %edi,%eax
  8017b4:	eb 05                	jmp    8017bb <devpipe_write+0x79>
				return 0;
  8017b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017be:	5b                   	pop    %ebx
  8017bf:	5e                   	pop    %esi
  8017c0:	5f                   	pop    %edi
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <devpipe_read>:
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	57                   	push   %edi
  8017c7:	56                   	push   %esi
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 18             	sub    $0x18,%esp
  8017cc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017cf:	57                   	push   %edi
  8017d0:	e8 70 f6 ff ff       	call   800e45 <fd2data>
  8017d5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	be 00 00 00 00       	mov    $0x0,%esi
  8017df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017e2:	74 47                	je     80182b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8017e4:	8b 03                	mov    (%ebx),%eax
  8017e6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017e9:	75 22                	jne    80180d <devpipe_read+0x4a>
			if (i > 0)
  8017eb:	85 f6                	test   %esi,%esi
  8017ed:	75 14                	jne    801803 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017ef:	89 da                	mov    %ebx,%edx
  8017f1:	89 f8                	mov    %edi,%eax
  8017f3:	e8 e5 fe ff ff       	call   8016dd <_pipeisclosed>
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	75 33                	jne    80182f <devpipe_read+0x6c>
			sys_yield();
  8017fc:	e8 05 f4 ff ff       	call   800c06 <sys_yield>
  801801:	eb e1                	jmp    8017e4 <devpipe_read+0x21>
				return i;
  801803:	89 f0                	mov    %esi,%eax
}
  801805:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5f                   	pop    %edi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80180d:	99                   	cltd   
  80180e:	c1 ea 1b             	shr    $0x1b,%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	83 e0 1f             	and    $0x1f,%eax
  801816:	29 d0                	sub    %edx,%eax
  801818:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80181d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801820:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801823:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801826:	83 c6 01             	add    $0x1,%esi
  801829:	eb b4                	jmp    8017df <devpipe_read+0x1c>
	return i;
  80182b:	89 f0                	mov    %esi,%eax
  80182d:	eb d6                	jmp    801805 <devpipe_read+0x42>
				return 0;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb cf                	jmp    801805 <devpipe_read+0x42>

00801836 <pipe>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80183e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801841:	50                   	push   %eax
  801842:	e8 15 f6 ff ff       	call   800e5c <fd_alloc>
  801847:	89 c3                	mov    %eax,%ebx
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 5b                	js     8018ab <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 07 04 00 00       	push   $0x407
  801858:	ff 75 f4             	pushl  -0xc(%ebp)
  80185b:	6a 00                	push   $0x0
  80185d:	e8 c3 f3 ff ff       	call   800c25 <sys_page_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 40                	js     8018ab <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801871:	50                   	push   %eax
  801872:	e8 e5 f5 ff ff       	call   800e5c <fd_alloc>
  801877:	89 c3                	mov    %eax,%ebx
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 1b                	js     80189b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	68 07 04 00 00       	push   $0x407
  801888:	ff 75 f0             	pushl  -0x10(%ebp)
  80188b:	6a 00                	push   $0x0
  80188d:	e8 93 f3 ff ff       	call   800c25 <sys_page_alloc>
  801892:	89 c3                	mov    %eax,%ebx
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	79 19                	jns    8018b4 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a1:	6a 00                	push   $0x0
  8018a3:	e8 02 f4 ff ff       	call   800caa <sys_page_unmap>
  8018a8:	83 c4 10             	add    $0x10,%esp
}
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    
	va = fd2data(fd0);
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ba:	e8 86 f5 ff ff       	call   800e45 <fd2data>
  8018bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018c1:	83 c4 0c             	add    $0xc,%esp
  8018c4:	68 07 04 00 00       	push   $0x407
  8018c9:	50                   	push   %eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	e8 54 f3 ff ff       	call   800c25 <sys_page_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	0f 88 8c 00 00 00    	js     80196a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e4:	e8 5c f5 ff ff       	call   800e45 <fd2data>
  8018e9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018f0:	50                   	push   %eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	56                   	push   %esi
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 6d f3 ff ff       	call   800c68 <sys_page_map>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 20             	add    $0x20,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	78 58                	js     80195c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80190d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801922:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	ff 75 f4             	pushl  -0xc(%ebp)
  801934:	e8 fc f4 ff ff       	call   800e35 <fd2num>
  801939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80193e:	83 c4 04             	add    $0x4,%esp
  801941:	ff 75 f0             	pushl  -0x10(%ebp)
  801944:	e8 ec f4 ff ff       	call   800e35 <fd2num>
  801949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	bb 00 00 00 00       	mov    $0x0,%ebx
  801957:	e9 4f ff ff ff       	jmp    8018ab <pipe+0x75>
	sys_page_unmap(0, va);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	56                   	push   %esi
  801960:	6a 00                	push   $0x0
  801962:	e8 43 f3 ff ff       	call   800caa <sys_page_unmap>
  801967:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	ff 75 f0             	pushl  -0x10(%ebp)
  801970:	6a 00                	push   $0x0
  801972:	e8 33 f3 ff ff       	call   800caa <sys_page_unmap>
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	e9 1c ff ff ff       	jmp    80189b <pipe+0x65>

0080197f <pipeisclosed>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801985:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801988:	50                   	push   %eax
  801989:	ff 75 08             	pushl  0x8(%ebp)
  80198c:	e8 1a f5 ff ff       	call   800eab <fd_lookup>
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	78 18                	js     8019b0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801998:	83 ec 0c             	sub    $0xc,%esp
  80199b:	ff 75 f4             	pushl  -0xc(%ebp)
  80199e:	e8 a2 f4 ff ff       	call   800e45 <fd2data>
	return _pipeisclosed(fd, p);
  8019a3:	89 c2                	mov    %eax,%edx
  8019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a8:	e8 30 fd ff ff       	call   8016dd <_pipeisclosed>
  8019ad:	83 c4 10             	add    $0x10,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019b8:	68 1b 28 80 00       	push   $0x80281b
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	e8 67 ee ff ff       	call   80082c <strcpy>
	return 0;
}
  8019c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <devsock_close>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 10             	sub    $0x10,%esp
  8019d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019d6:	53                   	push   %ebx
  8019d7:	e8 f9 06 00 00       	call   8020d5 <pageref>
  8019dc:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019df:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019e4:	83 f8 01             	cmp    $0x1,%eax
  8019e7:	74 07                	je     8019f0 <devsock_close+0x24>
}
  8019e9:	89 d0                	mov    %edx,%eax
  8019eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	ff 73 0c             	pushl  0xc(%ebx)
  8019f6:	e8 b7 02 00 00       	call   801cb2 <nsipc_close>
  8019fb:	89 c2                	mov    %eax,%edx
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	eb e7                	jmp    8019e9 <devsock_close+0x1d>

00801a02 <devsock_write>:
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 10             	pushl  0x10(%ebp)
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	ff 70 0c             	pushl  0xc(%eax)
  801a16:	e8 74 03 00 00       	call   801d8f <nsipc_send>
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <devsock_read>:
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	ff 75 10             	pushl  0x10(%ebp)
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff 70 0c             	pushl  0xc(%eax)
  801a31:	e8 ed 02 00 00       	call   801d23 <nsipc_recv>
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <fd2sockid>:
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a3e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	e8 63 f4 ff ff       	call   800eab <fd_lookup>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 10                	js     801a5f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a58:	39 08                	cmp    %ecx,(%eax)
  801a5a:	75 05                	jne    801a61 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a5c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    
		return -E_NOT_SUPP;
  801a61:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a66:	eb f7                	jmp    801a5f <fd2sockid+0x27>

00801a68 <alloc_sockfd>:
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	56                   	push   %esi
  801a6c:	53                   	push   %ebx
  801a6d:	83 ec 1c             	sub    $0x1c,%esp
  801a70:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a75:	50                   	push   %eax
  801a76:	e8 e1 f3 ff ff       	call   800e5c <fd_alloc>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 43                	js     801ac7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 07 04 00 00       	push   $0x407
  801a8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8f:	6a 00                	push   $0x0
  801a91:	e8 8f f1 ff ff       	call   800c25 <sys_page_alloc>
  801a96:	89 c3                	mov    %eax,%ebx
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 28                	js     801ac7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aa8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aad:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ab4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ab7:	83 ec 0c             	sub    $0xc,%esp
  801aba:	50                   	push   %eax
  801abb:	e8 75 f3 ff ff       	call   800e35 <fd2num>
  801ac0:	89 c3                	mov    %eax,%ebx
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	eb 0c                	jmp    801ad3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ac7:	83 ec 0c             	sub    $0xc,%esp
  801aca:	56                   	push   %esi
  801acb:	e8 e2 01 00 00       	call   801cb2 <nsipc_close>
		return r;
  801ad0:	83 c4 10             	add    $0x10,%esp
}
  801ad3:	89 d8                	mov    %ebx,%eax
  801ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5e                   	pop    %esi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    

00801adc <accept>:
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	e8 4e ff ff ff       	call   801a38 <fd2sockid>
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 1b                	js     801b09 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	ff 75 10             	pushl  0x10(%ebp)
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	e8 0e 01 00 00       	call   801c0b <nsipc_accept>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 05                	js     801b09 <accept+0x2d>
	return alloc_sockfd(r);
  801b04:	e8 5f ff ff ff       	call   801a68 <alloc_sockfd>
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <bind>:
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	e8 1f ff ff ff       	call   801a38 <fd2sockid>
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	78 12                	js     801b2f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	ff 75 10             	pushl  0x10(%ebp)
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	e8 2f 01 00 00       	call   801c5b <nsipc_bind>
  801b2c:	83 c4 10             	add    $0x10,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <shutdown>:
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	e8 f9 fe ff ff       	call   801a38 <fd2sockid>
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 0f                	js     801b52 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	50                   	push   %eax
  801b4a:	e8 41 01 00 00       	call   801c90 <nsipc_shutdown>
  801b4f:	83 c4 10             	add    $0x10,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <connect>:
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	e8 d6 fe ff ff       	call   801a38 <fd2sockid>
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 12                	js     801b78 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	50                   	push   %eax
  801b70:	e8 57 01 00 00       	call   801ccc <nsipc_connect>
  801b75:	83 c4 10             	add    $0x10,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <listen>:
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	e8 b0 fe ff ff       	call   801a38 <fd2sockid>
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	78 0f                	js     801b9b <listen+0x21>
	return nsipc_listen(r, backlog);
  801b8c:	83 ec 08             	sub    $0x8,%esp
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	50                   	push   %eax
  801b93:	e8 69 01 00 00       	call   801d01 <nsipc_listen>
  801b98:	83 c4 10             	add    $0x10,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <socket>:

int
socket(int domain, int type, int protocol)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ba3:	ff 75 10             	pushl  0x10(%ebp)
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	e8 3c 02 00 00       	call   801ded <nsipc_socket>
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 05                	js     801bbd <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bb8:	e8 ab fe ff ff       	call   801a68 <alloc_sockfd>
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	53                   	push   %ebx
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bc8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bcf:	74 26                	je     801bf7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd1:	6a 07                	push   $0x7
  801bd3:	68 00 60 80 00       	push   $0x806000
  801bd8:	53                   	push   %ebx
  801bd9:	ff 35 04 40 80 00    	pushl  0x804004
  801bdf:	e8 5f 04 00 00       	call   802043 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be4:	83 c4 0c             	add    $0xc,%esp
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	e8 e8 03 00 00       	call   801fda <ipc_recv>
}
  801bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	6a 02                	push   $0x2
  801bfc:	e8 9b 04 00 00       	call   80209c <ipc_find_env>
  801c01:	a3 04 40 80 00       	mov    %eax,0x804004
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	eb c6                	jmp    801bd1 <nsipc+0x12>

00801c0b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c1b:	8b 06                	mov    (%esi),%eax
  801c1d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	e8 93 ff ff ff       	call   801bbf <nsipc>
  801c2c:	89 c3                	mov    %eax,%ebx
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	78 20                	js     801c52 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	ff 35 10 60 80 00    	pushl  0x806010
  801c3b:	68 00 60 80 00       	push   $0x806000
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	e8 72 ed ff ff       	call   8009ba <memmove>
		*addrlen = ret->ret_addrlen;
  801c48:	a1 10 60 80 00       	mov    0x806010,%eax
  801c4d:	89 06                	mov    %eax,(%esi)
  801c4f:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c52:	89 d8                	mov    %ebx,%eax
  801c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    

00801c5b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	53                   	push   %ebx
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c6d:	53                   	push   %ebx
  801c6e:	ff 75 0c             	pushl  0xc(%ebp)
  801c71:	68 04 60 80 00       	push   $0x806004
  801c76:	e8 3f ed ff ff       	call   8009ba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c7b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c81:	b8 02 00 00 00       	mov    $0x2,%eax
  801c86:	e8 34 ff ff ff       	call   801bbf <nsipc>
}
  801c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ca6:	b8 03 00 00 00       	mov    $0x3,%eax
  801cab:	e8 0f ff ff ff       	call   801bbf <nsipc>
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <nsipc_close>:

int
nsipc_close(int s)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cc0:	b8 04 00 00 00       	mov    $0x4,%eax
  801cc5:	e8 f5 fe ff ff       	call   801bbf <nsipc>
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cde:	53                   	push   %ebx
  801cdf:	ff 75 0c             	pushl  0xc(%ebp)
  801ce2:	68 04 60 80 00       	push   $0x806004
  801ce7:	e8 ce ec ff ff       	call   8009ba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cec:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cf2:	b8 05 00 00 00       	mov    $0x5,%eax
  801cf7:	e8 c3 fe ff ff       	call   801bbf <nsipc>
}
  801cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d12:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d17:	b8 06 00 00 00       	mov    $0x6,%eax
  801d1c:	e8 9e fe ff ff       	call   801bbf <nsipc>
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d33:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d39:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d41:	b8 07 00 00 00       	mov    $0x7,%eax
  801d46:	e8 74 fe ff ff       	call   801bbf <nsipc>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 1f                	js     801d70 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d51:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d56:	7f 21                	jg     801d79 <nsipc_recv+0x56>
  801d58:	39 c6                	cmp    %eax,%esi
  801d5a:	7c 1d                	jl     801d79 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	50                   	push   %eax
  801d60:	68 00 60 80 00       	push   $0x806000
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	e8 4d ec ff ff       	call   8009ba <memmove>
  801d6d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d70:	89 d8                	mov    %ebx,%eax
  801d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d79:	68 27 28 80 00       	push   $0x802827
  801d7e:	68 c9 27 80 00       	push   $0x8027c9
  801d83:	6a 62                	push   $0x62
  801d85:	68 3c 28 80 00       	push   $0x80283c
  801d8a:	e8 05 02 00 00       	call   801f94 <_panic>

00801d8f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	53                   	push   %ebx
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801da1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801da7:	7f 2e                	jg     801dd7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	53                   	push   %ebx
  801dad:	ff 75 0c             	pushl  0xc(%ebp)
  801db0:	68 0c 60 80 00       	push   $0x80600c
  801db5:	e8 00 ec ff ff       	call   8009ba <memmove>
	nsipcbuf.send.req_size = size;
  801dba:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dc8:	b8 08 00 00 00       	mov    $0x8,%eax
  801dcd:	e8 ed fd ff ff       	call   801bbf <nsipc>
}
  801dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    
	assert(size < 1600);
  801dd7:	68 48 28 80 00       	push   $0x802848
  801ddc:	68 c9 27 80 00       	push   $0x8027c9
  801de1:	6a 6d                	push   $0x6d
  801de3:	68 3c 28 80 00       	push   $0x80283c
  801de8:	e8 a7 01 00 00       	call   801f94 <_panic>

00801ded <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfe:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e03:	8b 45 10             	mov    0x10(%ebp),%eax
  801e06:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e0b:	b8 09 00 00 00       	mov    $0x9,%eax
  801e10:	e8 aa fd ff ff       	call   801bbf <nsipc>
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    

00801e21 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e27:	68 54 28 80 00       	push   $0x802854
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	e8 f8 e9 ff ff       	call   80082c <strcpy>
	return 0;
}
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <devcons_write>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	57                   	push   %edi
  801e3f:	56                   	push   %esi
  801e40:	53                   	push   %ebx
  801e41:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e47:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e4c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e52:	eb 2f                	jmp    801e83 <devcons_write+0x48>
		m = n - tot;
  801e54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e57:	29 f3                	sub    %esi,%ebx
  801e59:	83 fb 7f             	cmp    $0x7f,%ebx
  801e5c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e61:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	53                   	push   %ebx
  801e68:	89 f0                	mov    %esi,%eax
  801e6a:	03 45 0c             	add    0xc(%ebp),%eax
  801e6d:	50                   	push   %eax
  801e6e:	57                   	push   %edi
  801e6f:	e8 46 eb ff ff       	call   8009ba <memmove>
		sys_cputs(buf, m);
  801e74:	83 c4 08             	add    $0x8,%esp
  801e77:	53                   	push   %ebx
  801e78:	57                   	push   %edi
  801e79:	e8 eb ec ff ff       	call   800b69 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e7e:	01 de                	add    %ebx,%esi
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e86:	72 cc                	jb     801e54 <devcons_write+0x19>
}
  801e88:	89 f0                	mov    %esi,%eax
  801e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5e                   	pop    %esi
  801e8f:	5f                   	pop    %edi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    

00801e92 <devcons_read>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea1:	75 07                	jne    801eaa <devcons_read+0x18>
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    
		sys_yield();
  801ea5:	e8 5c ed ff ff       	call   800c06 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801eaa:	e8 d8 ec ff ff       	call   800b87 <sys_cgetc>
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	74 f2                	je     801ea5 <devcons_read+0x13>
	if (c < 0)
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 ec                	js     801ea3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801eb7:	83 f8 04             	cmp    $0x4,%eax
  801eba:	74 0c                	je     801ec8 <devcons_read+0x36>
	*(char*)vbuf = c;
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	88 02                	mov    %al,(%edx)
	return 1;
  801ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec6:	eb db                	jmp    801ea3 <devcons_read+0x11>
		return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecd:	eb d4                	jmp    801ea3 <devcons_read+0x11>

00801ecf <cputchar>:
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801edb:	6a 01                	push   $0x1
  801edd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ee0:	50                   	push   %eax
  801ee1:	e8 83 ec ff ff       	call   800b69 <sys_cputs>
}
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <getchar>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ef1:	6a 01                	push   $0x1
  801ef3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ef6:	50                   	push   %eax
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 1e f2 ff ff       	call   80111c <read>
	if (r < 0)
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 08                	js     801f0d <getchar+0x22>
	if (r < 1)
  801f05:	85 c0                	test   %eax,%eax
  801f07:	7e 06                	jle    801f0f <getchar+0x24>
	return c;
  801f09:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    
		return -E_EOF;
  801f0f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f14:	eb f7                	jmp    801f0d <getchar+0x22>

00801f16 <iscons>:
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1f:	50                   	push   %eax
  801f20:	ff 75 08             	pushl  0x8(%ebp)
  801f23:	e8 83 ef ff ff       	call   800eab <fd_lookup>
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 11                	js     801f40 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f38:	39 10                	cmp    %edx,(%eax)
  801f3a:	0f 94 c0             	sete   %al
  801f3d:	0f b6 c0             	movzbl %al,%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <opencons>:
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4b:	50                   	push   %eax
  801f4c:	e8 0b ef ff ff       	call   800e5c <fd_alloc>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 3a                	js     801f92 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	68 07 04 00 00       	push   $0x407
  801f60:	ff 75 f4             	pushl  -0xc(%ebp)
  801f63:	6a 00                	push   $0x0
  801f65:	e8 bb ec ff ff       	call   800c25 <sys_page_alloc>
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	78 21                	js     801f92 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f7a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	50                   	push   %eax
  801f8a:	e8 a6 ee ff ff       	call   800e35 <fd2num>
  801f8f:	83 c4 10             	add    $0x10,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f99:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f9c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801fa2:	e8 40 ec ff ff       	call   800be7 <sys_getenvid>
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	56                   	push   %esi
  801fb1:	50                   	push   %eax
  801fb2:	68 60 28 80 00       	push   $0x802860
  801fb7:	e8 d3 e1 ff ff       	call   80018f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801fbc:	83 c4 18             	add    $0x18,%esp
  801fbf:	53                   	push   %ebx
  801fc0:	ff 75 10             	pushl  0x10(%ebp)
  801fc3:	e8 76 e1 ff ff       	call   80013e <vcprintf>
	cprintf("\n");
  801fc8:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  801fcf:	e8 bb e1 ff ff       	call   80018f <cprintf>
  801fd4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801fd7:	cc                   	int3   
  801fd8:	eb fd                	jmp    801fd7 <_panic+0x43>

00801fda <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	56                   	push   %esi
  801fde:	53                   	push   %ebx
  801fdf:	8b 75 08             	mov    0x8(%ebp),%esi
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801fe8:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801fea:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fef:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	50                   	push   %eax
  801ff6:	e8 da ed ff ff       	call   800dd5 <sys_ipc_recv>
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	85 c0                	test   %eax,%eax
  802000:	78 2b                	js     80202d <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802002:	85 f6                	test   %esi,%esi
  802004:	74 0a                	je     802010 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  802006:	a1 08 40 80 00       	mov    0x804008,%eax
  80200b:	8b 40 74             	mov    0x74(%eax),%eax
  80200e:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802010:	85 db                	test   %ebx,%ebx
  802012:	74 0a                	je     80201e <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802014:	a1 08 40 80 00       	mov    0x804008,%eax
  802019:	8b 40 78             	mov    0x78(%eax),%eax
  80201c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80201e:	a1 08 40 80 00       	mov    0x804008,%eax
  802023:	8b 40 70             	mov    0x70(%eax),%eax
}
  802026:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5d                   	pop    %ebp
  80202c:	c3                   	ret    
	    if (from_env_store != NULL) {
  80202d:	85 f6                	test   %esi,%esi
  80202f:	74 06                	je     802037 <ipc_recv+0x5d>
	        *from_env_store = 0;
  802031:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  802037:	85 db                	test   %ebx,%ebx
  802039:	74 eb                	je     802026 <ipc_recv+0x4c>
	        *perm_store = 0;
  80203b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802041:	eb e3                	jmp    802026 <ipc_recv+0x4c>

00802043 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	57                   	push   %edi
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80204f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802052:	85 f6                	test   %esi,%esi
  802054:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802059:	0f 44 f0             	cmove  %eax,%esi
  80205c:	eb 09                	jmp    802067 <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  80205e:	e8 a3 eb ff ff       	call   800c06 <sys_yield>
	} while(r != 0);
  802063:	85 db                	test   %ebx,%ebx
  802065:	74 2d                	je     802094 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  802067:	ff 75 14             	pushl  0x14(%ebp)
  80206a:	56                   	push   %esi
  80206b:	ff 75 0c             	pushl  0xc(%ebp)
  80206e:	57                   	push   %edi
  80206f:	e8 3e ed ff ff       	call   800db2 <sys_ipc_try_send>
  802074:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	79 e1                	jns    80205e <ipc_send+0x1b>
  80207d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802080:	74 dc                	je     80205e <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802082:	50                   	push   %eax
  802083:	68 84 28 80 00       	push   $0x802884
  802088:	6a 45                	push   $0x45
  80208a:	68 91 28 80 00       	push   $0x802891
  80208f:	e8 00 ff ff ff       	call   801f94 <_panic>
}
  802094:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    

0080209c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020a7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020aa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020b0:	8b 52 50             	mov    0x50(%edx),%edx
  8020b3:	39 ca                	cmp    %ecx,%edx
  8020b5:	74 11                	je     8020c8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020b7:	83 c0 01             	add    $0x1,%eax
  8020ba:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020bf:	75 e6                	jne    8020a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c6:	eb 0b                	jmp    8020d3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020c8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020d0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    

008020d5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020db:	89 d0                	mov    %edx,%eax
  8020dd:	c1 e8 16             	shr    $0x16,%eax
  8020e0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020ec:	f6 c1 01             	test   $0x1,%cl
  8020ef:	74 1d                	je     80210e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020f1:	c1 ea 0c             	shr    $0xc,%edx
  8020f4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020fb:	f6 c2 01             	test   $0x1,%dl
  8020fe:	74 0e                	je     80210e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802100:	c1 ea 0c             	shr    $0xc,%edx
  802103:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80210a:	ef 
  80210b:	0f b7 c0             	movzwl %ax,%eax
}
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    

00802110 <__udivdi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80211b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80211f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802123:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802127:	85 d2                	test   %edx,%edx
  802129:	75 35                	jne    802160 <__udivdi3+0x50>
  80212b:	39 f3                	cmp    %esi,%ebx
  80212d:	0f 87 bd 00 00 00    	ja     8021f0 <__udivdi3+0xe0>
  802133:	85 db                	test   %ebx,%ebx
  802135:	89 d9                	mov    %ebx,%ecx
  802137:	75 0b                	jne    802144 <__udivdi3+0x34>
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
  80213e:	31 d2                	xor    %edx,%edx
  802140:	f7 f3                	div    %ebx
  802142:	89 c1                	mov    %eax,%ecx
  802144:	31 d2                	xor    %edx,%edx
  802146:	89 f0                	mov    %esi,%eax
  802148:	f7 f1                	div    %ecx
  80214a:	89 c6                	mov    %eax,%esi
  80214c:	89 e8                	mov    %ebp,%eax
  80214e:	89 f7                	mov    %esi,%edi
  802150:	f7 f1                	div    %ecx
  802152:	89 fa                	mov    %edi,%edx
  802154:	83 c4 1c             	add    $0x1c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802160:	39 f2                	cmp    %esi,%edx
  802162:	77 7c                	ja     8021e0 <__udivdi3+0xd0>
  802164:	0f bd fa             	bsr    %edx,%edi
  802167:	83 f7 1f             	xor    $0x1f,%edi
  80216a:	0f 84 98 00 00 00    	je     802208 <__udivdi3+0xf8>
  802170:	89 f9                	mov    %edi,%ecx
  802172:	b8 20 00 00 00       	mov    $0x20,%eax
  802177:	29 f8                	sub    %edi,%eax
  802179:	d3 e2                	shl    %cl,%edx
  80217b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80217f:	89 c1                	mov    %eax,%ecx
  802181:	89 da                	mov    %ebx,%edx
  802183:	d3 ea                	shr    %cl,%edx
  802185:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802189:	09 d1                	or     %edx,%ecx
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802191:	89 f9                	mov    %edi,%ecx
  802193:	d3 e3                	shl    %cl,%ebx
  802195:	89 c1                	mov    %eax,%ecx
  802197:	d3 ea                	shr    %cl,%edx
  802199:	89 f9                	mov    %edi,%ecx
  80219b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80219f:	d3 e6                	shl    %cl,%esi
  8021a1:	89 eb                	mov    %ebp,%ebx
  8021a3:	89 c1                	mov    %eax,%ecx
  8021a5:	d3 eb                	shr    %cl,%ebx
  8021a7:	09 de                	or     %ebx,%esi
  8021a9:	89 f0                	mov    %esi,%eax
  8021ab:	f7 74 24 08          	divl   0x8(%esp)
  8021af:	89 d6                	mov    %edx,%esi
  8021b1:	89 c3                	mov    %eax,%ebx
  8021b3:	f7 64 24 0c          	mull   0xc(%esp)
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 0c                	jb     8021c7 <__udivdi3+0xb7>
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e5                	shl    %cl,%ebp
  8021bf:	39 c5                	cmp    %eax,%ebp
  8021c1:	73 5d                	jae    802220 <__udivdi3+0x110>
  8021c3:	39 d6                	cmp    %edx,%esi
  8021c5:	75 59                	jne    802220 <__udivdi3+0x110>
  8021c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021ca:	31 ff                	xor    %edi,%edi
  8021cc:	89 fa                	mov    %edi,%edx
  8021ce:	83 c4 1c             	add    $0x1c,%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5f                   	pop    %edi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    
  8021d6:	8d 76 00             	lea    0x0(%esi),%esi
  8021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021e0:	31 ff                	xor    %edi,%edi
  8021e2:	31 c0                	xor    %eax,%eax
  8021e4:	89 fa                	mov    %edi,%edx
  8021e6:	83 c4 1c             	add    $0x1c,%esp
  8021e9:	5b                   	pop    %ebx
  8021ea:	5e                   	pop    %esi
  8021eb:	5f                   	pop    %edi
  8021ec:	5d                   	pop    %ebp
  8021ed:	c3                   	ret    
  8021ee:	66 90                	xchg   %ax,%ax
  8021f0:	31 ff                	xor    %edi,%edi
  8021f2:	89 e8                	mov    %ebp,%eax
  8021f4:	89 f2                	mov    %esi,%edx
  8021f6:	f7 f3                	div    %ebx
  8021f8:	89 fa                	mov    %edi,%edx
  8021fa:	83 c4 1c             	add    $0x1c,%esp
  8021fd:	5b                   	pop    %ebx
  8021fe:	5e                   	pop    %esi
  8021ff:	5f                   	pop    %edi
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    
  802202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	72 06                	jb     802212 <__udivdi3+0x102>
  80220c:	31 c0                	xor    %eax,%eax
  80220e:	39 eb                	cmp    %ebp,%ebx
  802210:	77 d2                	ja     8021e4 <__udivdi3+0xd4>
  802212:	b8 01 00 00 00       	mov    $0x1,%eax
  802217:	eb cb                	jmp    8021e4 <__udivdi3+0xd4>
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	89 d8                	mov    %ebx,%eax
  802222:	31 ff                	xor    %edi,%edi
  802224:	eb be                	jmp    8021e4 <__udivdi3+0xd4>
  802226:	66 90                	xchg   %ax,%ax
  802228:	66 90                	xchg   %ax,%ax
  80222a:	66 90                	xchg   %ax,%ax
  80222c:	66 90                	xchg   %ax,%ax
  80222e:	66 90                	xchg   %ax,%ax

00802230 <__umoddi3>:
  802230:	55                   	push   %ebp
  802231:	57                   	push   %edi
  802232:	56                   	push   %esi
  802233:	53                   	push   %ebx
  802234:	83 ec 1c             	sub    $0x1c,%esp
  802237:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80223b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80223f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802247:	85 ed                	test   %ebp,%ebp
  802249:	89 f0                	mov    %esi,%eax
  80224b:	89 da                	mov    %ebx,%edx
  80224d:	75 19                	jne    802268 <__umoddi3+0x38>
  80224f:	39 df                	cmp    %ebx,%edi
  802251:	0f 86 b1 00 00 00    	jbe    802308 <__umoddi3+0xd8>
  802257:	f7 f7                	div    %edi
  802259:	89 d0                	mov    %edx,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	83 c4 1c             	add    $0x1c,%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5f                   	pop    %edi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
  802265:	8d 76 00             	lea    0x0(%esi),%esi
  802268:	39 dd                	cmp    %ebx,%ebp
  80226a:	77 f1                	ja     80225d <__umoddi3+0x2d>
  80226c:	0f bd cd             	bsr    %ebp,%ecx
  80226f:	83 f1 1f             	xor    $0x1f,%ecx
  802272:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802276:	0f 84 b4 00 00 00    	je     802330 <__umoddi3+0x100>
  80227c:	b8 20 00 00 00       	mov    $0x20,%eax
  802281:	89 c2                	mov    %eax,%edx
  802283:	8b 44 24 04          	mov    0x4(%esp),%eax
  802287:	29 c2                	sub    %eax,%edx
  802289:	89 c1                	mov    %eax,%ecx
  80228b:	89 f8                	mov    %edi,%eax
  80228d:	d3 e5                	shl    %cl,%ebp
  80228f:	89 d1                	mov    %edx,%ecx
  802291:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802295:	d3 e8                	shr    %cl,%eax
  802297:	09 c5                	or     %eax,%ebp
  802299:	8b 44 24 04          	mov    0x4(%esp),%eax
  80229d:	89 c1                	mov    %eax,%ecx
  80229f:	d3 e7                	shl    %cl,%edi
  8022a1:	89 d1                	mov    %edx,%ecx
  8022a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022a7:	89 df                	mov    %ebx,%edi
  8022a9:	d3 ef                	shr    %cl,%edi
  8022ab:	89 c1                	mov    %eax,%ecx
  8022ad:	89 f0                	mov    %esi,%eax
  8022af:	d3 e3                	shl    %cl,%ebx
  8022b1:	89 d1                	mov    %edx,%ecx
  8022b3:	89 fa                	mov    %edi,%edx
  8022b5:	d3 e8                	shr    %cl,%eax
  8022b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022bc:	09 d8                	or     %ebx,%eax
  8022be:	f7 f5                	div    %ebp
  8022c0:	d3 e6                	shl    %cl,%esi
  8022c2:	89 d1                	mov    %edx,%ecx
  8022c4:	f7 64 24 08          	mull   0x8(%esp)
  8022c8:	39 d1                	cmp    %edx,%ecx
  8022ca:	89 c3                	mov    %eax,%ebx
  8022cc:	89 d7                	mov    %edx,%edi
  8022ce:	72 06                	jb     8022d6 <__umoddi3+0xa6>
  8022d0:	75 0e                	jne    8022e0 <__umoddi3+0xb0>
  8022d2:	39 c6                	cmp    %eax,%esi
  8022d4:	73 0a                	jae    8022e0 <__umoddi3+0xb0>
  8022d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022da:	19 ea                	sbb    %ebp,%edx
  8022dc:	89 d7                	mov    %edx,%edi
  8022de:	89 c3                	mov    %eax,%ebx
  8022e0:	89 ca                	mov    %ecx,%edx
  8022e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022e7:	29 de                	sub    %ebx,%esi
  8022e9:	19 fa                	sbb    %edi,%edx
  8022eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022ef:	89 d0                	mov    %edx,%eax
  8022f1:	d3 e0                	shl    %cl,%eax
  8022f3:	89 d9                	mov    %ebx,%ecx
  8022f5:	d3 ee                	shr    %cl,%esi
  8022f7:	d3 ea                	shr    %cl,%edx
  8022f9:	09 f0                	or     %esi,%eax
  8022fb:	83 c4 1c             	add    $0x1c,%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5e                   	pop    %esi
  802300:	5f                   	pop    %edi
  802301:	5d                   	pop    %ebp
  802302:	c3                   	ret    
  802303:	90                   	nop
  802304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802308:	85 ff                	test   %edi,%edi
  80230a:	89 f9                	mov    %edi,%ecx
  80230c:	75 0b                	jne    802319 <__umoddi3+0xe9>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f7                	div    %edi
  802317:	89 c1                	mov    %eax,%ecx
  802319:	89 d8                	mov    %ebx,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f1                	div    %ecx
  80231f:	89 f0                	mov    %esi,%eax
  802321:	f7 f1                	div    %ecx
  802323:	e9 31 ff ff ff       	jmp    802259 <__umoddi3+0x29>
  802328:	90                   	nop
  802329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802330:	39 dd                	cmp    %ebx,%ebp
  802332:	72 08                	jb     80233c <__umoddi3+0x10c>
  802334:	39 f7                	cmp    %esi,%edi
  802336:	0f 87 21 ff ff ff    	ja     80225d <__umoddi3+0x2d>
  80233c:	89 da                	mov    %ebx,%edx
  80233e:	89 f0                	mov    %esi,%eax
  802340:	29 f8                	sub    %edi,%eax
  802342:	19 ea                	sbb    %ebp,%edx
  802344:	e9 14 ff ff ff       	jmp    80225d <__umoddi3+0x2d>
