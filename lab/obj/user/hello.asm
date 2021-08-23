
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 20 23 80 00       	push   $0x802320
  80003e:	e8 10 01 00 00       	call   800153 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 08 40 80 00       	mov    0x804008,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 2e 23 80 00       	push   $0x80232e
  800054:	e8 fa 00 00 00       	call   800153 <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 3d 0b 00 00       	call   800bab <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800076:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800080:	85 db                	test   %ebx,%ebx
  800082:	7e 07                	jle    80008b <libmain+0x2d>
		binaryname = argv[0];
  800084:	8b 06                	mov    (%esi),%eax
  800086:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 0a 00 00 00       	call   8000a4 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000aa:	e8 20 0f 00 00       	call   800fcf <close_all>
	sys_env_destroy(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 b1 0a 00 00       	call   800b6a <sys_env_destroy>
}
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    

008000be <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c8:	8b 13                	mov    (%ebx),%edx
  8000ca:	8d 42 01             	lea    0x1(%edx),%eax
  8000cd:	89 03                	mov    %eax,(%ebx)
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000db:	74 09                	je     8000e6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000dd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	68 ff 00 00 00       	push   $0xff
  8000ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 36 0a 00 00       	call   800b2d <sys_cputs>
		b->idx = 0;
  8000f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	eb db                	jmp    8000dd <putch+0x1f>

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800112:	00 00 00 
	b.cnt = 0;
  800115:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012b:	50                   	push   %eax
  80012c:	68 be 00 80 00       	push   $0x8000be
  800131:	e8 1a 01 00 00       	call   800250 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	e8 e2 09 00 00       	call   800b2d <sys_cputs>

	return b.cnt;
}
  80014b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800159:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015c:	50                   	push   %eax
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	e8 9d ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 1c             	sub    $0x1c,%esp
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800180:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800183:	bb 00 00 00 00       	mov    $0x0,%ebx
  800188:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80018e:	39 d3                	cmp    %edx,%ebx
  800190:	72 05                	jb     800197 <printnum+0x30>
  800192:	39 45 10             	cmp    %eax,0x10(%ebp)
  800195:	77 7a                	ja     800211 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	ff 75 18             	pushl  0x18(%ebp)
  80019d:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a3:	53                   	push   %ebx
  8001a4:	ff 75 10             	pushl  0x10(%ebp)
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b6:	e8 25 1f 00 00       	call   8020e0 <__udivdi3>
  8001bb:	83 c4 18             	add    $0x18,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	89 f2                	mov    %esi,%edx
  8001c2:	89 f8                	mov    %edi,%eax
  8001c4:	e8 9e ff ff ff       	call   800167 <printnum>
  8001c9:	83 c4 20             	add    $0x20,%esp
  8001cc:	eb 13                	jmp    8001e1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	56                   	push   %esi
  8001d2:	ff 75 18             	pushl  0x18(%ebp)
  8001d5:	ff d7                	call   *%edi
  8001d7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001da:	83 eb 01             	sub    $0x1,%ebx
  8001dd:	85 db                	test   %ebx,%ebx
  8001df:	7f ed                	jg     8001ce <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	56                   	push   %esi
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f4:	e8 07 20 00 00       	call   802200 <__umoddi3>
  8001f9:	83 c4 14             	add    $0x14,%esp
  8001fc:	0f be 80 4f 23 80 00 	movsbl 0x80234f(%eax),%eax
  800203:	50                   	push   %eax
  800204:	ff d7                	call   *%edi
}
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5f                   	pop    %edi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    
  800211:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800214:	eb c4                	jmp    8001da <printnum+0x73>

00800216 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800220:	8b 10                	mov    (%eax),%edx
  800222:	3b 50 04             	cmp    0x4(%eax),%edx
  800225:	73 0a                	jae    800231 <sprintputch+0x1b>
		*b->buf++ = ch;
  800227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022a:	89 08                	mov    %ecx,(%eax)
  80022c:	8b 45 08             	mov    0x8(%ebp),%eax
  80022f:	88 02                	mov    %al,(%edx)
}
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <printfmt>:
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800239:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 10             	pushl  0x10(%ebp)
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 05 00 00 00       	call   800250 <vprintfmt>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <vprintfmt>:
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 2c             	sub    $0x2c,%esp
  800259:	8b 75 08             	mov    0x8(%ebp),%esi
  80025c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80025f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800262:	e9 21 04 00 00       	jmp    800688 <vprintfmt+0x438>
		padc = ' ';
  800267:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800272:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800279:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800280:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800285:	8d 47 01             	lea    0x1(%edi),%eax
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028b:	0f b6 17             	movzbl (%edi),%edx
  80028e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800291:	3c 55                	cmp    $0x55,%al
  800293:	0f 87 90 04 00 00    	ja     800729 <vprintfmt+0x4d9>
  800299:	0f b6 c0             	movzbl %al,%eax
  80029c:	ff 24 85 a0 24 80 00 	jmp    *0x8024a0(,%eax,4)
  8002a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a6:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002aa:	eb d9                	jmp    800285 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002af:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b3:	eb d0                	jmp    800285 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b5:	0f b6 d2             	movzbl %dl,%edx
  8002b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002cd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d0:	83 f9 09             	cmp    $0x9,%ecx
  8002d3:	77 55                	ja     80032a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002d5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d8:	eb e9                	jmp    8002c3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002da:	8b 45 14             	mov    0x14(%ebp),%eax
  8002dd:	8b 00                	mov    (%eax),%eax
  8002df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e5:	8d 40 04             	lea    0x4(%eax),%eax
  8002e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f2:	79 91                	jns    800285 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800301:	eb 82                	jmp    800285 <vprintfmt+0x35>
  800303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	0f 49 d0             	cmovns %eax,%edx
  800310:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800316:	e9 6a ff ff ff       	jmp    800285 <vprintfmt+0x35>
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80031e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800325:	e9 5b ff ff ff       	jmp    800285 <vprintfmt+0x35>
  80032a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800330:	eb bc                	jmp    8002ee <vprintfmt+0x9e>
			lflag++;
  800332:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800338:	e9 48 ff ff ff       	jmp    800285 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 78 04             	lea    0x4(%eax),%edi
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	53                   	push   %ebx
  800347:	ff 30                	pushl  (%eax)
  800349:	ff d6                	call   *%esi
			break;
  80034b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800351:	e9 2f 03 00 00       	jmp    800685 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800356:	8b 45 14             	mov    0x14(%ebp),%eax
  800359:	8d 78 04             	lea    0x4(%eax),%edi
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	99                   	cltd   
  80035f:	31 d0                	xor    %edx,%eax
  800361:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800363:	83 f8 0f             	cmp    $0xf,%eax
  800366:	7f 23                	jg     80038b <vprintfmt+0x13b>
  800368:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  80036f:	85 d2                	test   %edx,%edx
  800371:	74 18                	je     80038b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800373:	52                   	push   %edx
  800374:	68 5b 27 80 00       	push   $0x80275b
  800379:	53                   	push   %ebx
  80037a:	56                   	push   %esi
  80037b:	e8 b3 fe ff ff       	call   800233 <printfmt>
  800380:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
  800386:	e9 fa 02 00 00       	jmp    800685 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80038b:	50                   	push   %eax
  80038c:	68 67 23 80 00       	push   $0x802367
  800391:	53                   	push   %ebx
  800392:	56                   	push   %esi
  800393:	e8 9b fe ff ff       	call   800233 <printfmt>
  800398:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80039e:	e9 e2 02 00 00       	jmp    800685 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b1:	85 ff                	test   %edi,%edi
  8003b3:	b8 60 23 80 00       	mov    $0x802360,%eax
  8003b8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bf:	0f 8e bd 00 00 00    	jle    800482 <vprintfmt+0x232>
  8003c5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c9:	75 0e                	jne    8003d9 <vprintfmt+0x189>
  8003cb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ce:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003d4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d7:	eb 6d                	jmp    800446 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	ff 75 d0             	pushl  -0x30(%ebp)
  8003df:	57                   	push   %edi
  8003e0:	e8 ec 03 00 00       	call   8007d1 <strnlen>
  8003e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e8:	29 c1                	sub    %eax,%ecx
  8003ea:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003ed:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003fa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fc:	eb 0f                	jmp    80040d <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	53                   	push   %ebx
  800402:	ff 75 e0             	pushl  -0x20(%ebp)
  800405:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800407:	83 ef 01             	sub    $0x1,%edi
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	85 ff                	test   %edi,%edi
  80040f:	7f ed                	jg     8003fe <vprintfmt+0x1ae>
  800411:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800414:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800417:	85 c9                	test   %ecx,%ecx
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	0f 49 c1             	cmovns %ecx,%eax
  800421:	29 c1                	sub    %eax,%ecx
  800423:	89 75 08             	mov    %esi,0x8(%ebp)
  800426:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800429:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042c:	89 cb                	mov    %ecx,%ebx
  80042e:	eb 16                	jmp    800446 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800430:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800434:	75 31                	jne    800467 <vprintfmt+0x217>
					putch(ch, putdat);
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	ff 75 0c             	pushl  0xc(%ebp)
  80043c:	50                   	push   %eax
  80043d:	ff 55 08             	call   *0x8(%ebp)
  800440:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800443:	83 eb 01             	sub    $0x1,%ebx
  800446:	83 c7 01             	add    $0x1,%edi
  800449:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044d:	0f be c2             	movsbl %dl,%eax
  800450:	85 c0                	test   %eax,%eax
  800452:	74 59                	je     8004ad <vprintfmt+0x25d>
  800454:	85 f6                	test   %esi,%esi
  800456:	78 d8                	js     800430 <vprintfmt+0x1e0>
  800458:	83 ee 01             	sub    $0x1,%esi
  80045b:	79 d3                	jns    800430 <vprintfmt+0x1e0>
  80045d:	89 df                	mov    %ebx,%edi
  80045f:	8b 75 08             	mov    0x8(%ebp),%esi
  800462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800465:	eb 37                	jmp    80049e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800467:	0f be d2             	movsbl %dl,%edx
  80046a:	83 ea 20             	sub    $0x20,%edx
  80046d:	83 fa 5e             	cmp    $0x5e,%edx
  800470:	76 c4                	jbe    800436 <vprintfmt+0x1e6>
					putch('?', putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	6a 3f                	push   $0x3f
  80047a:	ff 55 08             	call   *0x8(%ebp)
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	eb c1                	jmp    800443 <vprintfmt+0x1f3>
  800482:	89 75 08             	mov    %esi,0x8(%ebp)
  800485:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800488:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048e:	eb b6                	jmp    800446 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	6a 20                	push   $0x20
  800496:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800498:	83 ef 01             	sub    $0x1,%edi
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	85 ff                	test   %edi,%edi
  8004a0:	7f ee                	jg     800490 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a8:	e9 d8 01 00 00       	jmp    800685 <vprintfmt+0x435>
  8004ad:	89 df                	mov    %ebx,%edi
  8004af:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b5:	eb e7                	jmp    80049e <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b7:	83 f9 01             	cmp    $0x1,%ecx
  8004ba:	7e 45                	jle    800501 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8b 50 04             	mov    0x4(%eax),%edx
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8d 40 08             	lea    0x8(%eax),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d7:	79 62                	jns    80053b <vprintfmt+0x2eb>
				putch('-', putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	6a 2d                	push   $0x2d
  8004df:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004e7:	f7 d8                	neg    %eax
  8004e9:	83 d2 00             	adc    $0x0,%edx
  8004ec:	f7 da                	neg    %edx
  8004ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004f4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8004fc:	e9 66 01 00 00       	jmp    800667 <vprintfmt+0x417>
	else if (lflag)
  800501:	85 c9                	test   %ecx,%ecx
  800503:	75 1b                	jne    800520 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050d:	89 c1                	mov    %eax,%ecx
  80050f:	c1 f9 1f             	sar    $0x1f,%ecx
  800512:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 40 04             	lea    0x4(%eax),%eax
  80051b:	89 45 14             	mov    %eax,0x14(%ebp)
  80051e:	eb b3                	jmp    8004d3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800528:	89 c1                	mov    %eax,%ecx
  80052a:	c1 f9 1f             	sar    $0x1f,%ecx
  80052d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800530:	8b 45 14             	mov    0x14(%ebp),%eax
  800533:	8d 40 04             	lea    0x4(%eax),%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
  800539:	eb 98                	jmp    8004d3 <vprintfmt+0x283>
			base = 10;
  80053b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800540:	e9 22 01 00 00       	jmp    800667 <vprintfmt+0x417>
	if (lflag >= 2)
  800545:	83 f9 01             	cmp    $0x1,%ecx
  800548:	7e 21                	jle    80056b <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 50 04             	mov    0x4(%eax),%edx
  800550:	8b 00                	mov    (%eax),%eax
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800555:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 40 08             	lea    0x8(%eax),%eax
  80055e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800561:	ba 0a 00 00 00       	mov    $0xa,%edx
  800566:	e9 fc 00 00 00       	jmp    800667 <vprintfmt+0x417>
	else if (lflag)
  80056b:	85 c9                	test   %ecx,%ecx
  80056d:	75 23                	jne    800592 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	ba 00 00 00 00       	mov    $0x0,%edx
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8d 40 04             	lea    0x4(%eax),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800588:	ba 0a 00 00 00       	mov    $0xa,%edx
  80058d:	e9 d5 00 00 00       	jmp    800667 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	ba 00 00 00 00       	mov    $0x0,%edx
  80059c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ab:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005b0:	e9 b2 00 00 00       	jmp    800667 <vprintfmt+0x417>
	if (lflag >= 2)
  8005b5:	83 f9 01             	cmp    $0x1,%ecx
  8005b8:	7e 42                	jle    8005fc <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 50 04             	mov    0x4(%eax),%edx
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8d 40 08             	lea    0x8(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d1:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8005d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005da:	0f 89 87 00 00 00    	jns    800667 <vprintfmt+0x417>
				putch('-', putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	53                   	push   %ebx
  8005e4:	6a 2d                	push   $0x2d
  8005e6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e8:	f7 5d d8             	negl   -0x28(%ebp)
  8005eb:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8005ef:	f7 5d dc             	negl   -0x24(%ebp)
  8005f2:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8005f5:	ba 08 00 00 00       	mov    $0x8,%edx
  8005fa:	eb 6b                	jmp    800667 <vprintfmt+0x417>
	else if (lflag)
  8005fc:	85 c9                	test   %ecx,%ecx
  8005fe:	75 1b                	jne    80061b <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	ba 00 00 00 00       	mov    $0x0,%edx
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 40 04             	lea    0x4(%eax),%eax
  800616:	89 45 14             	mov    %eax,0x14(%ebp)
  800619:	eb b6                	jmp    8005d1 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	ba 00 00 00 00       	mov    $0x0,%edx
  800625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800628:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	eb 9b                	jmp    8005d1 <vprintfmt+0x381>
			putch('0', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 30                	push   $0x30
  80063c:	ff d6                	call   *%esi
			putch('x', putdat);
  80063e:	83 c4 08             	add    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 78                	push   $0x78
  800644:	ff d6                	call   *%esi
			num = (unsigned long long)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	ba 00 00 00 00       	mov    $0x0,%edx
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800656:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800662:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800667:	83 ec 0c             	sub    $0xc,%esp
  80066a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	ff 75 e0             	pushl  -0x20(%ebp)
  800672:	52                   	push   %edx
  800673:	ff 75 dc             	pushl  -0x24(%ebp)
  800676:	ff 75 d8             	pushl  -0x28(%ebp)
  800679:	89 da                	mov    %ebx,%edx
  80067b:	89 f0                	mov    %esi,%eax
  80067d:	e8 e5 fa ff ff       	call   800167 <printnum>
			break;
  800682:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800685:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800688:	83 c7 01             	add    $0x1,%edi
  80068b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80068f:	83 f8 25             	cmp    $0x25,%eax
  800692:	0f 84 cf fb ff ff    	je     800267 <vprintfmt+0x17>
			if (ch == '\0')
  800698:	85 c0                	test   %eax,%eax
  80069a:	0f 84 a9 00 00 00    	je     800749 <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	50                   	push   %eax
  8006a5:	ff d6                	call   *%esi
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	eb dc                	jmp    800688 <vprintfmt+0x438>
	if (lflag >= 2)
  8006ac:	83 f9 01             	cmp    $0x1,%ecx
  8006af:	7e 1e                	jle    8006cf <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 08             	lea    0x8(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c8:	ba 10 00 00 00       	mov    $0x10,%edx
  8006cd:	eb 98                	jmp    800667 <vprintfmt+0x417>
	else if (lflag)
  8006cf:	85 c9                	test   %ecx,%ecx
  8006d1:	75 23                	jne    8006f6 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ec:	ba 10 00 00 00       	mov    $0x10,%edx
  8006f1:	e9 71 ff ff ff       	jmp    800667 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800700:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800703:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070f:	ba 10 00 00 00       	mov    $0x10,%edx
  800714:	e9 4e ff ff ff       	jmp    800667 <vprintfmt+0x417>
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 25                	push   $0x25
  80071f:	ff d6                	call   *%esi
			break;
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	e9 5c ff ff ff       	jmp    800685 <vprintfmt+0x435>
			putch('%', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	6a 25                	push   $0x25
  80072f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 f8                	mov    %edi,%eax
  800736:	eb 03                	jmp    80073b <vprintfmt+0x4eb>
  800738:	83 e8 01             	sub    $0x1,%eax
  80073b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80073f:	75 f7                	jne    800738 <vprintfmt+0x4e8>
  800741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800744:	e9 3c ff ff ff       	jmp    800685 <vprintfmt+0x435>
}
  800749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074c:	5b                   	pop    %ebx
  80074d:	5e                   	pop    %esi
  80074e:	5f                   	pop    %edi
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 18             	sub    $0x18,%esp
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800760:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800764:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 26                	je     800798 <vsnprintf+0x47>
  800772:	85 d2                	test   %edx,%edx
  800774:	7e 22                	jle    800798 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800776:	ff 75 14             	pushl  0x14(%ebp)
  800779:	ff 75 10             	pushl  0x10(%ebp)
  80077c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	68 16 02 80 00       	push   $0x800216
  800785:	e8 c6 fa ff ff       	call   800250 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800793:	83 c4 10             	add    $0x10,%esp
}
  800796:	c9                   	leave  
  800797:	c3                   	ret    
		return -E_INVAL;
  800798:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079d:	eb f7                	jmp    800796 <vsnprintf+0x45>

0080079f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a8:	50                   	push   %eax
  8007a9:	ff 75 10             	pushl  0x10(%ebp)
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	ff 75 08             	pushl  0x8(%ebp)
  8007b2:	e8 9a ff ff ff       	call   800751 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	eb 03                	jmp    8007c9 <strlen+0x10>
		n++;
  8007c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007cd:	75 f7                	jne    8007c6 <strlen+0xd>
	return n;
}
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	eb 03                	jmp    8007e4 <strnlen+0x13>
		n++;
  8007e1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e4:	39 d0                	cmp    %edx,%eax
  8007e6:	74 06                	je     8007ee <strnlen+0x1d>
  8007e8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007ec:	75 f3                	jne    8007e1 <strnlen+0x10>
	return n;
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	53                   	push   %ebx
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	83 c1 01             	add    $0x1,%ecx
  8007ff:	83 c2 01             	add    $0x1,%edx
  800802:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800806:	88 5a ff             	mov    %bl,-0x1(%edx)
  800809:	84 db                	test   %bl,%bl
  80080b:	75 ef                	jne    8007fc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80080d:	5b                   	pop    %ebx
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	53                   	push   %ebx
  800814:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800817:	53                   	push   %ebx
  800818:	e8 9c ff ff ff       	call   8007b9 <strlen>
  80081d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	01 d8                	add    %ebx,%eax
  800825:	50                   	push   %eax
  800826:	e8 c5 ff ff ff       	call   8007f0 <strcpy>
	return dst;
}
  80082b:	89 d8                	mov    %ebx,%eax
  80082d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083d:	89 f3                	mov    %esi,%ebx
  80083f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800842:	89 f2                	mov    %esi,%edx
  800844:	eb 0f                	jmp    800855 <strncpy+0x23>
		*dst++ = *src;
  800846:	83 c2 01             	add    $0x1,%edx
  800849:	0f b6 01             	movzbl (%ecx),%eax
  80084c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084f:	80 39 01             	cmpb   $0x1,(%ecx)
  800852:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800855:	39 da                	cmp    %ebx,%edx
  800857:	75 ed                	jne    800846 <strncpy+0x14>
	}
	return ret;
}
  800859:	89 f0                	mov    %esi,%eax
  80085b:	5b                   	pop    %ebx
  80085c:	5e                   	pop    %esi
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800873:	85 c9                	test   %ecx,%ecx
  800875:	75 0b                	jne    800882 <strlcpy+0x23>
  800877:	eb 17                	jmp    800890 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800879:	83 c2 01             	add    $0x1,%edx
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800882:	39 d8                	cmp    %ebx,%eax
  800884:	74 07                	je     80088d <strlcpy+0x2e>
  800886:	0f b6 0a             	movzbl (%edx),%ecx
  800889:	84 c9                	test   %cl,%cl
  80088b:	75 ec                	jne    800879 <strlcpy+0x1a>
		*dst = '\0';
  80088d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800890:	29 f0                	sub    %esi,%eax
}
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089f:	eb 06                	jmp    8008a7 <strcmp+0x11>
		p++, q++;
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	84 c0                	test   %al,%al
  8008ac:	74 04                	je     8008b2 <strcmp+0x1c>
  8008ae:	3a 02                	cmp    (%edx),%al
  8008b0:	74 ef                	je     8008a1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	0f b6 12             	movzbl (%edx),%edx
  8008b8:	29 d0                	sub    %edx,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	53                   	push   %ebx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	89 c3                	mov    %eax,%ebx
  8008c8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cb:	eb 06                	jmp    8008d3 <strncmp+0x17>
		n--, p++, q++;
  8008cd:	83 c0 01             	add    $0x1,%eax
  8008d0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d3:	39 d8                	cmp    %ebx,%eax
  8008d5:	74 16                	je     8008ed <strncmp+0x31>
  8008d7:	0f b6 08             	movzbl (%eax),%ecx
  8008da:	84 c9                	test   %cl,%cl
  8008dc:	74 04                	je     8008e2 <strncmp+0x26>
  8008de:	3a 0a                	cmp    (%edx),%cl
  8008e0:	74 eb                	je     8008cd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e2:	0f b6 00             	movzbl (%eax),%eax
  8008e5:	0f b6 12             	movzbl (%edx),%edx
  8008e8:	29 d0                	sub    %edx,%eax
}
  8008ea:	5b                   	pop    %ebx
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    
		return 0;
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f2:	eb f6                	jmp    8008ea <strncmp+0x2e>

008008f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fe:	0f b6 10             	movzbl (%eax),%edx
  800901:	84 d2                	test   %dl,%dl
  800903:	74 09                	je     80090e <strchr+0x1a>
		if (*s == c)
  800905:	38 ca                	cmp    %cl,%dl
  800907:	74 0a                	je     800913 <strchr+0x1f>
	for (; *s; s++)
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f0                	jmp    8008fe <strchr+0xa>
			return (char *) s;
	return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091f:	eb 03                	jmp    800924 <strfind+0xf>
  800921:	83 c0 01             	add    $0x1,%eax
  800924:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	74 04                	je     80092f <strfind+0x1a>
  80092b:	84 d2                	test   %dl,%dl
  80092d:	75 f2                	jne    800921 <strfind+0xc>
			break;
	return (char *) s;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	57                   	push   %edi
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	74 13                	je     800954 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800941:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800947:	75 05                	jne    80094e <memset+0x1d>
  800949:	f6 c1 03             	test   $0x3,%cl
  80094c:	74 0d                	je     80095b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	fc                   	cld    
  800952:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800954:	89 f8                	mov    %edi,%eax
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    
		c &= 0xFF;
  80095b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095f:	89 d3                	mov    %edx,%ebx
  800961:	c1 e3 08             	shl    $0x8,%ebx
  800964:	89 d0                	mov    %edx,%eax
  800966:	c1 e0 18             	shl    $0x18,%eax
  800969:	89 d6                	mov    %edx,%esi
  80096b:	c1 e6 10             	shl    $0x10,%esi
  80096e:	09 f0                	or     %esi,%eax
  800970:	09 c2                	or     %eax,%edx
  800972:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800974:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800977:	89 d0                	mov    %edx,%eax
  800979:	fc                   	cld    
  80097a:	f3 ab                	rep stos %eax,%es:(%edi)
  80097c:	eb d6                	jmp    800954 <memset+0x23>

0080097e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	57                   	push   %edi
  800982:	56                   	push   %esi
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 75 0c             	mov    0xc(%ebp),%esi
  800989:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098c:	39 c6                	cmp    %eax,%esi
  80098e:	73 35                	jae    8009c5 <memmove+0x47>
  800990:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800993:	39 c2                	cmp    %eax,%edx
  800995:	76 2e                	jbe    8009c5 <memmove+0x47>
		s += n;
		d += n;
  800997:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099a:	89 d6                	mov    %edx,%esi
  80099c:	09 fe                	or     %edi,%esi
  80099e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a4:	74 0c                	je     8009b2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a6:	83 ef 01             	sub    $0x1,%edi
  8009a9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009af:	fc                   	cld    
  8009b0:	eb 21                	jmp    8009d3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	f6 c1 03             	test   $0x3,%cl
  8009b5:	75 ef                	jne    8009a6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b7:	83 ef 04             	sub    $0x4,%edi
  8009ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c3:	eb ea                	jmp    8009af <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c5:	89 f2                	mov    %esi,%edx
  8009c7:	09 c2                	or     %eax,%edx
  8009c9:	f6 c2 03             	test   $0x3,%dl
  8009cc:	74 09                	je     8009d7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ce:	89 c7                	mov    %eax,%edi
  8009d0:	fc                   	cld    
  8009d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d3:	5e                   	pop    %esi
  8009d4:	5f                   	pop    %edi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	75 f2                	jne    8009ce <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb ed                	jmp    8009d3 <memmove+0x55>

008009e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e9:	ff 75 10             	pushl  0x10(%ebp)
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	e8 87 ff ff ff       	call   80097e <memmove>
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	56                   	push   %esi
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a04:	89 c6                	mov    %eax,%esi
  800a06:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a09:	39 f0                	cmp    %esi,%eax
  800a0b:	74 1c                	je     800a29 <memcmp+0x30>
		if (*s1 != *s2)
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	0f b6 1a             	movzbl (%edx),%ebx
  800a13:	38 d9                	cmp    %bl,%cl
  800a15:	75 08                	jne    800a1f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	eb ea                	jmp    800a09 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a1f:	0f b6 c1             	movzbl %cl,%eax
  800a22:	0f b6 db             	movzbl %bl,%ebx
  800a25:	29 d8                	sub    %ebx,%eax
  800a27:	eb 05                	jmp    800a2e <memcmp+0x35>
	}

	return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2e:	5b                   	pop    %ebx
  800a2f:	5e                   	pop    %esi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a40:	39 d0                	cmp    %edx,%eax
  800a42:	73 09                	jae    800a4d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a44:	38 08                	cmp    %cl,(%eax)
  800a46:	74 05                	je     800a4d <memfind+0x1b>
	for (; s < ends; s++)
  800a48:	83 c0 01             	add    $0x1,%eax
  800a4b:	eb f3                	jmp    800a40 <memfind+0xe>
			break;
	return (void *) s;
}
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	57                   	push   %edi
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5b:	eb 03                	jmp    800a60 <strtol+0x11>
		s++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a60:	0f b6 01             	movzbl (%ecx),%eax
  800a63:	3c 20                	cmp    $0x20,%al
  800a65:	74 f6                	je     800a5d <strtol+0xe>
  800a67:	3c 09                	cmp    $0x9,%al
  800a69:	74 f2                	je     800a5d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a6b:	3c 2b                	cmp    $0x2b,%al
  800a6d:	74 2e                	je     800a9d <strtol+0x4e>
	int neg = 0;
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a74:	3c 2d                	cmp    $0x2d,%al
  800a76:	74 2f                	je     800aa7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7e:	75 05                	jne    800a85 <strtol+0x36>
  800a80:	80 39 30             	cmpb   $0x30,(%ecx)
  800a83:	74 2c                	je     800ab1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	75 0a                	jne    800a93 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a89:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a8e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a91:	74 28                	je     800abb <strtol+0x6c>
		base = 10;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9b:	eb 50                	jmp    800aed <strtol+0x9e>
		s++;
  800a9d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa5:	eb d1                	jmp    800a78 <strtol+0x29>
		s++, neg = 1;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	bf 01 00 00 00       	mov    $0x1,%edi
  800aaf:	eb c7                	jmp    800a78 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab5:	74 0e                	je     800ac5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	75 d8                	jne    800a93 <strtol+0x44>
		s++, base = 8;
  800abb:	83 c1 01             	add    $0x1,%ecx
  800abe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac3:	eb ce                	jmp    800a93 <strtol+0x44>
		s += 2, base = 16;
  800ac5:	83 c1 02             	add    $0x2,%ecx
  800ac8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800acd:	eb c4                	jmp    800a93 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800acf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad2:	89 f3                	mov    %esi,%ebx
  800ad4:	80 fb 19             	cmp    $0x19,%bl
  800ad7:	77 29                	ja     800b02 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad9:	0f be d2             	movsbl %dl,%edx
  800adc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800adf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae2:	7d 30                	jge    800b14 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae4:	83 c1 01             	add    $0x1,%ecx
  800ae7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aeb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aed:	0f b6 11             	movzbl (%ecx),%edx
  800af0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af3:	89 f3                	mov    %esi,%ebx
  800af5:	80 fb 09             	cmp    $0x9,%bl
  800af8:	77 d5                	ja     800acf <strtol+0x80>
			dig = *s - '0';
  800afa:	0f be d2             	movsbl %dl,%edx
  800afd:	83 ea 30             	sub    $0x30,%edx
  800b00:	eb dd                	jmp    800adf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b02:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b05:	89 f3                	mov    %esi,%ebx
  800b07:	80 fb 19             	cmp    $0x19,%bl
  800b0a:	77 08                	ja     800b14 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b0c:	0f be d2             	movsbl %dl,%edx
  800b0f:	83 ea 37             	sub    $0x37,%edx
  800b12:	eb cb                	jmp    800adf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b18:	74 05                	je     800b1f <strtol+0xd0>
		*endptr = (char *) s;
  800b1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	f7 da                	neg    %edx
  800b23:	85 ff                	test   %edi,%edi
  800b25:	0f 45 c2             	cmovne %edx,%eax
}
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5f                   	pop    %edi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
  800b38:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3e:	89 c3                	mov    %eax,%ebx
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	89 c6                	mov    %eax,%esi
  800b44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5f                   	pop    %edi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	57                   	push   %edi
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5b:	89 d1                	mov    %edx,%ecx
  800b5d:	89 d3                	mov    %edx,%ebx
  800b5f:	89 d7                	mov    %edx,%edi
  800b61:	89 d6                	mov    %edx,%esi
  800b63:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5f                   	pop    %edi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b80:	89 cb                	mov    %ecx,%ebx
  800b82:	89 cf                	mov    %ecx,%edi
  800b84:	89 ce                	mov    %ecx,%esi
  800b86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b88:	85 c0                	test   %eax,%eax
  800b8a:	7f 08                	jg     800b94 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	50                   	push   %eax
  800b98:	6a 03                	push   $0x3
  800b9a:	68 5f 26 80 00       	push   $0x80265f
  800b9f:	6a 23                	push   $0x23
  800ba1:	68 7c 26 80 00       	push   $0x80267c
  800ba6:	e8 ad 13 00 00       	call   801f58 <_panic>

00800bab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb6:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbb:	89 d1                	mov    %edx,%ecx
  800bbd:	89 d3                	mov    %edx,%ebx
  800bbf:	89 d7                	mov    %edx,%edi
  800bc1:	89 d6                	mov    %edx,%esi
  800bc3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <sys_yield>:

void
sys_yield(void)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bda:	89 d1                	mov    %edx,%ecx
  800bdc:	89 d3                	mov    %edx,%ebx
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf2:	be 00 00 00 00       	mov    $0x0,%esi
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	b8 04 00 00 00       	mov    $0x4,%eax
  800c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c05:	89 f7                	mov    %esi,%edi
  800c07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	7f 08                	jg     800c15 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	6a 04                	push   $0x4
  800c1b:	68 5f 26 80 00       	push   $0x80265f
  800c20:	6a 23                	push   $0x23
  800c22:	68 7c 26 80 00       	push   $0x80267c
  800c27:	e8 2c 13 00 00       	call   801f58 <_panic>

00800c2c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c46:	8b 75 18             	mov    0x18(%ebp),%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 05                	push   $0x5
  800c5d:	68 5f 26 80 00       	push   $0x80265f
  800c62:	6a 23                	push   $0x23
  800c64:	68 7c 26 80 00       	push   $0x80267c
  800c69:	e8 ea 12 00 00       	call   801f58 <_panic>

00800c6e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 06 00 00 00       	mov    $0x6,%eax
  800c87:	89 df                	mov    %ebx,%edi
  800c89:	89 de                	mov    %ebx,%esi
  800c8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 06                	push   $0x6
  800c9f:	68 5f 26 80 00       	push   $0x80265f
  800ca4:	6a 23                	push   $0x23
  800ca6:	68 7c 26 80 00       	push   $0x80267c
  800cab:	e8 a8 12 00 00       	call   801f58 <_panic>

00800cb0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 08                	push   $0x8
  800ce1:	68 5f 26 80 00       	push   $0x80265f
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 7c 26 80 00       	push   $0x80267c
  800ced:	e8 66 12 00 00       	call   801f58 <_panic>

00800cf2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	89 de                	mov    %ebx,%esi
  800d0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7f 08                	jg     800d1d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	50                   	push   %eax
  800d21:	6a 09                	push   $0x9
  800d23:	68 5f 26 80 00       	push   $0x80265f
  800d28:	6a 23                	push   $0x23
  800d2a:	68 7c 26 80 00       	push   $0x80267c
  800d2f:	e8 24 12 00 00       	call   801f58 <_panic>

00800d34 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d4d:	89 df                	mov    %ebx,%edi
  800d4f:	89 de                	mov    %ebx,%esi
  800d51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7f 08                	jg     800d5f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	50                   	push   %eax
  800d63:	6a 0a                	push   $0xa
  800d65:	68 5f 26 80 00       	push   $0x80265f
  800d6a:	6a 23                	push   $0x23
  800d6c:	68 7c 26 80 00       	push   $0x80267c
  800d71:	e8 e2 11 00 00       	call   801f58 <_panic>

00800d76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d87:	be 00 00 00 00       	mov    $0x0,%esi
  800d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d92:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	b8 0d 00 00 00       	mov    $0xd,%eax
  800daf:	89 cb                	mov    %ecx,%ebx
  800db1:	89 cf                	mov    %ecx,%edi
  800db3:	89 ce                	mov    %ecx,%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 0d                	push   $0xd
  800dc9:	68 5f 26 80 00       	push   $0x80265f
  800dce:	6a 23                	push   $0x23
  800dd0:	68 7c 26 80 00       	push   $0x80267c
  800dd5:	e8 7e 11 00 00       	call   801f58 <_panic>

00800dda <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
  800de5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dea:	89 d1                	mov    %edx,%ecx
  800dec:	89 d3                	mov    %edx,%ebx
  800dee:	89 d7                	mov    %edx,%edi
  800df0:	89 d6                	mov    %edx,%esi
  800df2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	05 00 00 00 30       	add    $0x30000000,%eax
  800e04:	c1 e8 0c             	shr    $0xc,%eax
}
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e19:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e26:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e2b:	89 c2                	mov    %eax,%edx
  800e2d:	c1 ea 16             	shr    $0x16,%edx
  800e30:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e37:	f6 c2 01             	test   $0x1,%dl
  800e3a:	74 2a                	je     800e66 <fd_alloc+0x46>
  800e3c:	89 c2                	mov    %eax,%edx
  800e3e:	c1 ea 0c             	shr    $0xc,%edx
  800e41:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e48:	f6 c2 01             	test   $0x1,%dl
  800e4b:	74 19                	je     800e66 <fd_alloc+0x46>
  800e4d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e52:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e57:	75 d2                	jne    800e2b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e59:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e5f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e64:	eb 07                	jmp    800e6d <fd_alloc+0x4d>
			*fd_store = fd;
  800e66:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e75:	83 f8 1f             	cmp    $0x1f,%eax
  800e78:	77 36                	ja     800eb0 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e7a:	c1 e0 0c             	shl    $0xc,%eax
  800e7d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e82:	89 c2                	mov    %eax,%edx
  800e84:	c1 ea 16             	shr    $0x16,%edx
  800e87:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e8e:	f6 c2 01             	test   $0x1,%dl
  800e91:	74 24                	je     800eb7 <fd_lookup+0x48>
  800e93:	89 c2                	mov    %eax,%edx
  800e95:	c1 ea 0c             	shr    $0xc,%edx
  800e98:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e9f:	f6 c2 01             	test   $0x1,%dl
  800ea2:	74 1a                	je     800ebe <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea7:	89 02                	mov    %eax,(%edx)
	return 0;
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		return -E_INVAL;
  800eb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb5:	eb f7                	jmp    800eae <fd_lookup+0x3f>
		return -E_INVAL;
  800eb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebc:	eb f0                	jmp    800eae <fd_lookup+0x3f>
  800ebe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec3:	eb e9                	jmp    800eae <fd_lookup+0x3f>

00800ec5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 08             	sub    $0x8,%esp
  800ecb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ece:	ba 08 27 80 00       	mov    $0x802708,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ed3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ed8:	39 08                	cmp    %ecx,(%eax)
  800eda:	74 33                	je     800f0f <dev_lookup+0x4a>
  800edc:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800edf:	8b 02                	mov    (%edx),%eax
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	75 f3                	jne    800ed8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ee5:	a1 08 40 80 00       	mov    0x804008,%eax
  800eea:	8b 40 48             	mov    0x48(%eax),%eax
  800eed:	83 ec 04             	sub    $0x4,%esp
  800ef0:	51                   	push   %ecx
  800ef1:	50                   	push   %eax
  800ef2:	68 8c 26 80 00       	push   $0x80268c
  800ef7:	e8 57 f2 ff ff       	call   800153 <cprintf>
	*dev = 0;
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f05:	83 c4 10             	add    $0x10,%esp
  800f08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f0d:	c9                   	leave  
  800f0e:	c3                   	ret    
			*dev = devtab[i];
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
  800f19:	eb f2                	jmp    800f0d <dev_lookup+0x48>

00800f1b <fd_close>:
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
  800f21:	83 ec 1c             	sub    $0x1c,%esp
  800f24:	8b 75 08             	mov    0x8(%ebp),%esi
  800f27:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f2a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f2d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f2e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f34:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f37:	50                   	push   %eax
  800f38:	e8 32 ff ff ff       	call   800e6f <fd_lookup>
  800f3d:	89 c3                	mov    %eax,%ebx
  800f3f:	83 c4 08             	add    $0x8,%esp
  800f42:	85 c0                	test   %eax,%eax
  800f44:	78 05                	js     800f4b <fd_close+0x30>
	    || fd != fd2)
  800f46:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f49:	74 16                	je     800f61 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f4b:	89 f8                	mov    %edi,%eax
  800f4d:	84 c0                	test   %al,%al
  800f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f54:	0f 44 d8             	cmove  %eax,%ebx
}
  800f57:	89 d8                	mov    %ebx,%eax
  800f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f67:	50                   	push   %eax
  800f68:	ff 36                	pushl  (%esi)
  800f6a:	e8 56 ff ff ff       	call   800ec5 <dev_lookup>
  800f6f:	89 c3                	mov    %eax,%ebx
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	85 c0                	test   %eax,%eax
  800f76:	78 15                	js     800f8d <fd_close+0x72>
		if (dev->dev_close)
  800f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f7b:	8b 40 10             	mov    0x10(%eax),%eax
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	74 1b                	je     800f9d <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f82:	83 ec 0c             	sub    $0xc,%esp
  800f85:	56                   	push   %esi
  800f86:	ff d0                	call   *%eax
  800f88:	89 c3                	mov    %eax,%ebx
  800f8a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f8d:	83 ec 08             	sub    $0x8,%esp
  800f90:	56                   	push   %esi
  800f91:	6a 00                	push   $0x0
  800f93:	e8 d6 fc ff ff       	call   800c6e <sys_page_unmap>
	return r;
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	eb ba                	jmp    800f57 <fd_close+0x3c>
			r = 0;
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa2:	eb e9                	jmp    800f8d <fd_close+0x72>

00800fa4 <close>:

int
close(int fdnum)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800faa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fad:	50                   	push   %eax
  800fae:	ff 75 08             	pushl  0x8(%ebp)
  800fb1:	e8 b9 fe ff ff       	call   800e6f <fd_lookup>
  800fb6:	83 c4 08             	add    $0x8,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	78 10                	js     800fcd <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fbd:	83 ec 08             	sub    $0x8,%esp
  800fc0:	6a 01                	push   $0x1
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	e8 51 ff ff ff       	call   800f1b <fd_close>
  800fca:	83 c4 10             	add    $0x10,%esp
}
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <close_all>:

void
close_all(void)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	53                   	push   %ebx
  800fdf:	e8 c0 ff ff ff       	call   800fa4 <close>
	for (i = 0; i < MAXFD; i++)
  800fe4:	83 c3 01             	add    $0x1,%ebx
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	83 fb 20             	cmp    $0x20,%ebx
  800fed:	75 ec                	jne    800fdb <close_all+0xc>
}
  800fef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	57                   	push   %edi
  800ff8:	56                   	push   %esi
  800ff9:	53                   	push   %ebx
  800ffa:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800ffd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801000:	50                   	push   %eax
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 66 fe ff ff       	call   800e6f <fd_lookup>
  801009:	89 c3                	mov    %eax,%ebx
  80100b:	83 c4 08             	add    $0x8,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	0f 88 81 00 00 00    	js     801097 <dup+0xa3>
		return r;
	close(newfdnum);
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	e8 83 ff ff ff       	call   800fa4 <close>

	newfd = INDEX2FD(newfdnum);
  801021:	8b 75 0c             	mov    0xc(%ebp),%esi
  801024:	c1 e6 0c             	shl    $0xc,%esi
  801027:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80102d:	83 c4 04             	add    $0x4,%esp
  801030:	ff 75 e4             	pushl  -0x1c(%ebp)
  801033:	e8 d1 fd ff ff       	call   800e09 <fd2data>
  801038:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80103a:	89 34 24             	mov    %esi,(%esp)
  80103d:	e8 c7 fd ff ff       	call   800e09 <fd2data>
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801047:	89 d8                	mov    %ebx,%eax
  801049:	c1 e8 16             	shr    $0x16,%eax
  80104c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801053:	a8 01                	test   $0x1,%al
  801055:	74 11                	je     801068 <dup+0x74>
  801057:	89 d8                	mov    %ebx,%eax
  801059:	c1 e8 0c             	shr    $0xc,%eax
  80105c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801063:	f6 c2 01             	test   $0x1,%dl
  801066:	75 39                	jne    8010a1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801068:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80106b:	89 d0                	mov    %edx,%eax
  80106d:	c1 e8 0c             	shr    $0xc,%eax
  801070:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	25 07 0e 00 00       	and    $0xe07,%eax
  80107f:	50                   	push   %eax
  801080:	56                   	push   %esi
  801081:	6a 00                	push   $0x0
  801083:	52                   	push   %edx
  801084:	6a 00                	push   $0x0
  801086:	e8 a1 fb ff ff       	call   800c2c <sys_page_map>
  80108b:	89 c3                	mov    %eax,%ebx
  80108d:	83 c4 20             	add    $0x20,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	78 31                	js     8010c5 <dup+0xd1>
		goto err;

	return newfdnum;
  801094:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801097:	89 d8                	mov    %ebx,%eax
  801099:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a8:	83 ec 0c             	sub    $0xc,%esp
  8010ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8010b0:	50                   	push   %eax
  8010b1:	57                   	push   %edi
  8010b2:	6a 00                	push   $0x0
  8010b4:	53                   	push   %ebx
  8010b5:	6a 00                	push   $0x0
  8010b7:	e8 70 fb ff ff       	call   800c2c <sys_page_map>
  8010bc:	89 c3                	mov    %eax,%ebx
  8010be:	83 c4 20             	add    $0x20,%esp
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	79 a3                	jns    801068 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	56                   	push   %esi
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 9e fb ff ff       	call   800c6e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010d0:	83 c4 08             	add    $0x8,%esp
  8010d3:	57                   	push   %edi
  8010d4:	6a 00                	push   $0x0
  8010d6:	e8 93 fb ff ff       	call   800c6e <sys_page_unmap>
	return r;
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	eb b7                	jmp    801097 <dup+0xa3>

008010e0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 14             	sub    $0x14,%esp
  8010e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ed:	50                   	push   %eax
  8010ee:	53                   	push   %ebx
  8010ef:	e8 7b fd ff ff       	call   800e6f <fd_lookup>
  8010f4:	83 c4 08             	add    $0x8,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 3f                	js     80113a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801101:	50                   	push   %eax
  801102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801105:	ff 30                	pushl  (%eax)
  801107:	e8 b9 fd ff ff       	call   800ec5 <dev_lookup>
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 27                	js     80113a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801113:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801116:	8b 42 08             	mov    0x8(%edx),%eax
  801119:	83 e0 03             	and    $0x3,%eax
  80111c:	83 f8 01             	cmp    $0x1,%eax
  80111f:	74 1e                	je     80113f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801124:	8b 40 08             	mov    0x8(%eax),%eax
  801127:	85 c0                	test   %eax,%eax
  801129:	74 35                	je     801160 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	ff 75 10             	pushl  0x10(%ebp)
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	52                   	push   %edx
  801135:	ff d0                	call   *%eax
  801137:	83 c4 10             	add    $0x10,%esp
}
  80113a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80113f:	a1 08 40 80 00       	mov    0x804008,%eax
  801144:	8b 40 48             	mov    0x48(%eax),%eax
  801147:	83 ec 04             	sub    $0x4,%esp
  80114a:	53                   	push   %ebx
  80114b:	50                   	push   %eax
  80114c:	68 cd 26 80 00       	push   $0x8026cd
  801151:	e8 fd ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115e:	eb da                	jmp    80113a <read+0x5a>
		return -E_NOT_SUPP;
  801160:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801165:	eb d3                	jmp    80113a <read+0x5a>

00801167 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	57                   	push   %edi
  80116b:	56                   	push   %esi
  80116c:	53                   	push   %ebx
  80116d:	83 ec 0c             	sub    $0xc,%esp
  801170:	8b 7d 08             	mov    0x8(%ebp),%edi
  801173:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801176:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117b:	39 f3                	cmp    %esi,%ebx
  80117d:	73 25                	jae    8011a4 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	89 f0                	mov    %esi,%eax
  801184:	29 d8                	sub    %ebx,%eax
  801186:	50                   	push   %eax
  801187:	89 d8                	mov    %ebx,%eax
  801189:	03 45 0c             	add    0xc(%ebp),%eax
  80118c:	50                   	push   %eax
  80118d:	57                   	push   %edi
  80118e:	e8 4d ff ff ff       	call   8010e0 <read>
		if (m < 0)
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	85 c0                	test   %eax,%eax
  801198:	78 08                	js     8011a2 <readn+0x3b>
			return m;
		if (m == 0)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	74 06                	je     8011a4 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80119e:	01 c3                	add    %eax,%ebx
  8011a0:	eb d9                	jmp    80117b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011a2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011a4:	89 d8                	mov    %ebx,%eax
  8011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a9:	5b                   	pop    %ebx
  8011aa:	5e                   	pop    %esi
  8011ab:	5f                   	pop    %edi
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 14             	sub    $0x14,%esp
  8011b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	53                   	push   %ebx
  8011bd:	e8 ad fc ff ff       	call   800e6f <fd_lookup>
  8011c2:	83 c4 08             	add    $0x8,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 3a                	js     801203 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011cf:	50                   	push   %eax
  8011d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d3:	ff 30                	pushl  (%eax)
  8011d5:	e8 eb fc ff ff       	call   800ec5 <dev_lookup>
  8011da:	83 c4 10             	add    $0x10,%esp
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	78 22                	js     801203 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011e8:	74 1e                	je     801208 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8011f0:	85 d2                	test   %edx,%edx
  8011f2:	74 35                	je     801229 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011f4:	83 ec 04             	sub    $0x4,%esp
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	50                   	push   %eax
  8011fe:	ff d2                	call   *%edx
  801200:	83 c4 10             	add    $0x10,%esp
}
  801203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801206:	c9                   	leave  
  801207:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801208:	a1 08 40 80 00       	mov    0x804008,%eax
  80120d:	8b 40 48             	mov    0x48(%eax),%eax
  801210:	83 ec 04             	sub    $0x4,%esp
  801213:	53                   	push   %ebx
  801214:	50                   	push   %eax
  801215:	68 e9 26 80 00       	push   $0x8026e9
  80121a:	e8 34 ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801227:	eb da                	jmp    801203 <write+0x55>
		return -E_NOT_SUPP;
  801229:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80122e:	eb d3                	jmp    801203 <write+0x55>

00801230 <seek>:

int
seek(int fdnum, off_t offset)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801236:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801239:	50                   	push   %eax
  80123a:	ff 75 08             	pushl  0x8(%ebp)
  80123d:	e8 2d fc ff ff       	call   800e6f <fd_lookup>
  801242:	83 c4 08             	add    $0x8,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	78 0e                	js     801257 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801257:	c9                   	leave  
  801258:	c3                   	ret    

00801259 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	53                   	push   %ebx
  80125d:	83 ec 14             	sub    $0x14,%esp
  801260:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801263:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801266:	50                   	push   %eax
  801267:	53                   	push   %ebx
  801268:	e8 02 fc ff ff       	call   800e6f <fd_lookup>
  80126d:	83 c4 08             	add    $0x8,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 37                	js     8012ab <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127a:	50                   	push   %eax
  80127b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127e:	ff 30                	pushl  (%eax)
  801280:	e8 40 fc ff ff       	call   800ec5 <dev_lookup>
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	78 1f                	js     8012ab <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801293:	74 1b                	je     8012b0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801298:	8b 52 18             	mov    0x18(%edx),%edx
  80129b:	85 d2                	test   %edx,%edx
  80129d:	74 32                	je     8012d1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	ff 75 0c             	pushl  0xc(%ebp)
  8012a5:	50                   	push   %eax
  8012a6:	ff d2                	call   *%edx
  8012a8:	83 c4 10             	add    $0x10,%esp
}
  8012ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012b0:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012b5:	8b 40 48             	mov    0x48(%eax),%eax
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	53                   	push   %ebx
  8012bc:	50                   	push   %eax
  8012bd:	68 ac 26 80 00       	push   $0x8026ac
  8012c2:	e8 8c ee ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012cf:	eb da                	jmp    8012ab <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d6:	eb d3                	jmp    8012ab <ftruncate+0x52>

008012d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	53                   	push   %ebx
  8012dc:	83 ec 14             	sub    $0x14,%esp
  8012df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e5:	50                   	push   %eax
  8012e6:	ff 75 08             	pushl  0x8(%ebp)
  8012e9:	e8 81 fb ff ff       	call   800e6f <fd_lookup>
  8012ee:	83 c4 08             	add    $0x8,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	78 4b                	js     801340 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f5:	83 ec 08             	sub    $0x8,%esp
  8012f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fb:	50                   	push   %eax
  8012fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ff:	ff 30                	pushl  (%eax)
  801301:	e8 bf fb ff ff       	call   800ec5 <dev_lookup>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 33                	js     801340 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801314:	74 2f                	je     801345 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801316:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801319:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801320:	00 00 00 
	stat->st_isdir = 0;
  801323:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80132a:	00 00 00 
	stat->st_dev = dev;
  80132d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	53                   	push   %ebx
  801337:	ff 75 f0             	pushl  -0x10(%ebp)
  80133a:	ff 50 14             	call   *0x14(%eax)
  80133d:	83 c4 10             	add    $0x10,%esp
}
  801340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801343:	c9                   	leave  
  801344:	c3                   	ret    
		return -E_NOT_SUPP;
  801345:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134a:	eb f4                	jmp    801340 <fstat+0x68>

0080134c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	6a 00                	push   $0x0
  801356:	ff 75 08             	pushl  0x8(%ebp)
  801359:	e8 26 02 00 00       	call   801584 <open>
  80135e:	89 c3                	mov    %eax,%ebx
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 1b                	js     801382 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	ff 75 0c             	pushl  0xc(%ebp)
  80136d:	50                   	push   %eax
  80136e:	e8 65 ff ff ff       	call   8012d8 <fstat>
  801373:	89 c6                	mov    %eax,%esi
	close(fd);
  801375:	89 1c 24             	mov    %ebx,(%esp)
  801378:	e8 27 fc ff ff       	call   800fa4 <close>
	return r;
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	89 f3                	mov    %esi,%ebx
}
  801382:	89 d8                	mov    %ebx,%eax
  801384:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5d                   	pop    %ebp
  80138a:	c3                   	ret    

0080138b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	56                   	push   %esi
  80138f:	53                   	push   %ebx
  801390:	89 c6                	mov    %eax,%esi
  801392:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801394:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80139b:	74 27                	je     8013c4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80139d:	6a 07                	push   $0x7
  80139f:	68 00 50 80 00       	push   $0x805000
  8013a4:	56                   	push   %esi
  8013a5:	ff 35 00 40 80 00    	pushl  0x804000
  8013ab:	e8 57 0c 00 00       	call   802007 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013b0:	83 c4 0c             	add    $0xc,%esp
  8013b3:	6a 00                	push   $0x0
  8013b5:	53                   	push   %ebx
  8013b6:	6a 00                	push   $0x0
  8013b8:	e8 e1 0b 00 00       	call   801f9e <ipc_recv>
}
  8013bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013c4:	83 ec 0c             	sub    $0xc,%esp
  8013c7:	6a 01                	push   $0x1
  8013c9:	e8 92 0c 00 00       	call   802060 <ipc_find_env>
  8013ce:	a3 00 40 80 00       	mov    %eax,0x804000
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	eb c5                	jmp    80139d <fsipc+0x12>

008013d8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8013fb:	e8 8b ff ff ff       	call   80138b <fsipc>
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <devfile_flush>:
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8b 40 0c             	mov    0xc(%eax),%eax
  80140e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801413:	ba 00 00 00 00       	mov    $0x0,%edx
  801418:	b8 06 00 00 00       	mov    $0x6,%eax
  80141d:	e8 69 ff ff ff       	call   80138b <fsipc>
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <devfile_stat>:
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	53                   	push   %ebx
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8b 40 0c             	mov    0xc(%eax),%eax
  801434:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801439:	ba 00 00 00 00       	mov    $0x0,%edx
  80143e:	b8 05 00 00 00       	mov    $0x5,%eax
  801443:	e8 43 ff ff ff       	call   80138b <fsipc>
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 2c                	js     801478 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	68 00 50 80 00       	push   $0x805000
  801454:	53                   	push   %ebx
  801455:	e8 96 f3 ff ff       	call   8007f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80145a:	a1 80 50 80 00       	mov    0x805080,%eax
  80145f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801465:	a1 84 50 80 00       	mov    0x805084,%eax
  80146a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801478:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <devfile_write>:
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	53                   	push   %ebx
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8b 40 0c             	mov    0xc(%eax),%eax
  80148d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801492:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801498:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80149e:	77 30                	ja     8014d0 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	53                   	push   %ebx
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	68 08 50 80 00       	push   $0x805008
  8014ac:	e8 cd f4 ff ff       	call   80097e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8014bb:	e8 cb fe ff ff       	call   80138b <fsipc>
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 04                	js     8014cb <devfile_write+0x4e>
	assert(r <= n);
  8014c7:	39 d8                	cmp    %ebx,%eax
  8014c9:	77 1e                	ja     8014e9 <devfile_write+0x6c>
}
  8014cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014d0:	68 1c 27 80 00       	push   $0x80271c
  8014d5:	68 49 27 80 00       	push   $0x802749
  8014da:	68 94 00 00 00       	push   $0x94
  8014df:	68 5e 27 80 00       	push   $0x80275e
  8014e4:	e8 6f 0a 00 00       	call   801f58 <_panic>
	assert(r <= n);
  8014e9:	68 69 27 80 00       	push   $0x802769
  8014ee:	68 49 27 80 00       	push   $0x802749
  8014f3:	68 98 00 00 00       	push   $0x98
  8014f8:	68 5e 27 80 00       	push   $0x80275e
  8014fd:	e8 56 0a 00 00       	call   801f58 <_panic>

00801502 <devfile_read>:
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	56                   	push   %esi
  801506:	53                   	push   %ebx
  801507:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8b 40 0c             	mov    0xc(%eax),%eax
  801510:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801515:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80151b:	ba 00 00 00 00       	mov    $0x0,%edx
  801520:	b8 03 00 00 00       	mov    $0x3,%eax
  801525:	e8 61 fe ff ff       	call   80138b <fsipc>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 1f                	js     80154f <devfile_read+0x4d>
	assert(r <= n);
  801530:	39 f0                	cmp    %esi,%eax
  801532:	77 24                	ja     801558 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801534:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801539:	7f 33                	jg     80156e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	50                   	push   %eax
  80153f:	68 00 50 80 00       	push   $0x805000
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	e8 32 f4 ff ff       	call   80097e <memmove>
	return r;
  80154c:	83 c4 10             	add    $0x10,%esp
}
  80154f:	89 d8                	mov    %ebx,%eax
  801551:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
	assert(r <= n);
  801558:	68 69 27 80 00       	push   $0x802769
  80155d:	68 49 27 80 00       	push   $0x802749
  801562:	6a 7c                	push   $0x7c
  801564:	68 5e 27 80 00       	push   $0x80275e
  801569:	e8 ea 09 00 00       	call   801f58 <_panic>
	assert(r <= PGSIZE);
  80156e:	68 70 27 80 00       	push   $0x802770
  801573:	68 49 27 80 00       	push   $0x802749
  801578:	6a 7d                	push   $0x7d
  80157a:	68 5e 27 80 00       	push   $0x80275e
  80157f:	e8 d4 09 00 00       	call   801f58 <_panic>

00801584 <open>:
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	83 ec 1c             	sub    $0x1c,%esp
  80158c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80158f:	56                   	push   %esi
  801590:	e8 24 f2 ff ff       	call   8007b9 <strlen>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80159d:	7f 6c                	jg     80160b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80159f:	83 ec 0c             	sub    $0xc,%esp
  8015a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	e8 75 f8 ff ff       	call   800e20 <fd_alloc>
  8015ab:	89 c3                	mov    %eax,%ebx
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 3c                	js     8015f0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	56                   	push   %esi
  8015b8:	68 00 50 80 00       	push   $0x805000
  8015bd:	e8 2e f2 ff ff       	call   8007f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d2:	e8 b4 fd ff ff       	call   80138b <fsipc>
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 19                	js     8015f9 <open+0x75>
	return fd2num(fd);
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e6:	e8 0e f8 ff ff       	call   800df9 <fd2num>
  8015eb:	89 c3                	mov    %eax,%ebx
  8015ed:	83 c4 10             	add    $0x10,%esp
}
  8015f0:	89 d8                	mov    %ebx,%eax
  8015f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    
		fd_close(fd, 0);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	6a 00                	push   $0x0
  8015fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801601:	e8 15 f9 ff ff       	call   800f1b <fd_close>
		return r;
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	eb e5                	jmp    8015f0 <open+0x6c>
		return -E_BAD_PATH;
  80160b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801610:	eb de                	jmp    8015f0 <open+0x6c>

00801612 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	b8 08 00 00 00       	mov    $0x8,%eax
  801622:	e8 64 fd ff ff       	call   80138b <fsipc>
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	56                   	push   %esi
  80162d:	53                   	push   %ebx
  80162e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	e8 cd f7 ff ff       	call   800e09 <fd2data>
  80163c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80163e:	83 c4 08             	add    $0x8,%esp
  801641:	68 7c 27 80 00       	push   $0x80277c
  801646:	53                   	push   %ebx
  801647:	e8 a4 f1 ff ff       	call   8007f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80164c:	8b 46 04             	mov    0x4(%esi),%eax
  80164f:	2b 06                	sub    (%esi),%eax
  801651:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801657:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80165e:	00 00 00 
	stat->st_dev = &devpipe;
  801661:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801668:	30 80 00 
	return 0;
}
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
  801670:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	53                   	push   %ebx
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801681:	53                   	push   %ebx
  801682:	6a 00                	push   $0x0
  801684:	e8 e5 f5 ff ff       	call   800c6e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801689:	89 1c 24             	mov    %ebx,(%esp)
  80168c:	e8 78 f7 ff ff       	call   800e09 <fd2data>
  801691:	83 c4 08             	add    $0x8,%esp
  801694:	50                   	push   %eax
  801695:	6a 00                	push   $0x0
  801697:	e8 d2 f5 ff ff       	call   800c6e <sys_page_unmap>
}
  80169c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <_pipeisclosed>:
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	57                   	push   %edi
  8016a5:	56                   	push   %esi
  8016a6:	53                   	push   %ebx
  8016a7:	83 ec 1c             	sub    $0x1c,%esp
  8016aa:	89 c7                	mov    %eax,%edi
  8016ac:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016ae:	a1 08 40 80 00       	mov    0x804008,%eax
  8016b3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	57                   	push   %edi
  8016ba:	e8 da 09 00 00       	call   802099 <pageref>
  8016bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016c2:	89 34 24             	mov    %esi,(%esp)
  8016c5:	e8 cf 09 00 00       	call   802099 <pageref>
		nn = thisenv->env_runs;
  8016ca:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016d0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	39 cb                	cmp    %ecx,%ebx
  8016d8:	74 1b                	je     8016f5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016dd:	75 cf                	jne    8016ae <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016df:	8b 42 58             	mov    0x58(%edx),%eax
  8016e2:	6a 01                	push   $0x1
  8016e4:	50                   	push   %eax
  8016e5:	53                   	push   %ebx
  8016e6:	68 83 27 80 00       	push   $0x802783
  8016eb:	e8 63 ea ff ff       	call   800153 <cprintf>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	eb b9                	jmp    8016ae <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016f8:	0f 94 c0             	sete   %al
  8016fb:	0f b6 c0             	movzbl %al,%eax
}
  8016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5f                   	pop    %edi
  801704:	5d                   	pop    %ebp
  801705:	c3                   	ret    

00801706 <devpipe_write>:
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	57                   	push   %edi
  80170a:	56                   	push   %esi
  80170b:	53                   	push   %ebx
  80170c:	83 ec 28             	sub    $0x28,%esp
  80170f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801712:	56                   	push   %esi
  801713:	e8 f1 f6 ff ff       	call   800e09 <fd2data>
  801718:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	bf 00 00 00 00       	mov    $0x0,%edi
  801722:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801725:	74 4f                	je     801776 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801727:	8b 43 04             	mov    0x4(%ebx),%eax
  80172a:	8b 0b                	mov    (%ebx),%ecx
  80172c:	8d 51 20             	lea    0x20(%ecx),%edx
  80172f:	39 d0                	cmp    %edx,%eax
  801731:	72 14                	jb     801747 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801733:	89 da                	mov    %ebx,%edx
  801735:	89 f0                	mov    %esi,%eax
  801737:	e8 65 ff ff ff       	call   8016a1 <_pipeisclosed>
  80173c:	85 c0                	test   %eax,%eax
  80173e:	75 3a                	jne    80177a <devpipe_write+0x74>
			sys_yield();
  801740:	e8 85 f4 ff ff       	call   800bca <sys_yield>
  801745:	eb e0                	jmp    801727 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801747:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80174e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801751:	89 c2                	mov    %eax,%edx
  801753:	c1 fa 1f             	sar    $0x1f,%edx
  801756:	89 d1                	mov    %edx,%ecx
  801758:	c1 e9 1b             	shr    $0x1b,%ecx
  80175b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80175e:	83 e2 1f             	and    $0x1f,%edx
  801761:	29 ca                	sub    %ecx,%edx
  801763:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801767:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80176b:	83 c0 01             	add    $0x1,%eax
  80176e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801771:	83 c7 01             	add    $0x1,%edi
  801774:	eb ac                	jmp    801722 <devpipe_write+0x1c>
	return i;
  801776:	89 f8                	mov    %edi,%eax
  801778:	eb 05                	jmp    80177f <devpipe_write+0x79>
				return 0;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801782:	5b                   	pop    %ebx
  801783:	5e                   	pop    %esi
  801784:	5f                   	pop    %edi
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    

00801787 <devpipe_read>:
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	57                   	push   %edi
  80178b:	56                   	push   %esi
  80178c:	53                   	push   %ebx
  80178d:	83 ec 18             	sub    $0x18,%esp
  801790:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801793:	57                   	push   %edi
  801794:	e8 70 f6 ff ff       	call   800e09 <fd2data>
  801799:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	be 00 00 00 00       	mov    $0x0,%esi
  8017a3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017a6:	74 47                	je     8017ef <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8017a8:	8b 03                	mov    (%ebx),%eax
  8017aa:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017ad:	75 22                	jne    8017d1 <devpipe_read+0x4a>
			if (i > 0)
  8017af:	85 f6                	test   %esi,%esi
  8017b1:	75 14                	jne    8017c7 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017b3:	89 da                	mov    %ebx,%edx
  8017b5:	89 f8                	mov    %edi,%eax
  8017b7:	e8 e5 fe ff ff       	call   8016a1 <_pipeisclosed>
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	75 33                	jne    8017f3 <devpipe_read+0x6c>
			sys_yield();
  8017c0:	e8 05 f4 ff ff       	call   800bca <sys_yield>
  8017c5:	eb e1                	jmp    8017a8 <devpipe_read+0x21>
				return i;
  8017c7:	89 f0                	mov    %esi,%eax
}
  8017c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cc:	5b                   	pop    %ebx
  8017cd:	5e                   	pop    %esi
  8017ce:	5f                   	pop    %edi
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017d1:	99                   	cltd   
  8017d2:	c1 ea 1b             	shr    $0x1b,%edx
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	83 e0 1f             	and    $0x1f,%eax
  8017da:	29 d0                	sub    %edx,%eax
  8017dc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017e7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017ea:	83 c6 01             	add    $0x1,%esi
  8017ed:	eb b4                	jmp    8017a3 <devpipe_read+0x1c>
	return i;
  8017ef:	89 f0                	mov    %esi,%eax
  8017f1:	eb d6                	jmp    8017c9 <devpipe_read+0x42>
				return 0;
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f8:	eb cf                	jmp    8017c9 <devpipe_read+0x42>

008017fa <pipe>:
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	56                   	push   %esi
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801802:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801805:	50                   	push   %eax
  801806:	e8 15 f6 ff ff       	call   800e20 <fd_alloc>
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	78 5b                	js     80186f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 07 04 00 00       	push   $0x407
  80181c:	ff 75 f4             	pushl  -0xc(%ebp)
  80181f:	6a 00                	push   $0x0
  801821:	e8 c3 f3 ff ff       	call   800be9 <sys_page_alloc>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 40                	js     80186f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80182f:	83 ec 0c             	sub    $0xc,%esp
  801832:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801835:	50                   	push   %eax
  801836:	e8 e5 f5 ff ff       	call   800e20 <fd_alloc>
  80183b:	89 c3                	mov    %eax,%ebx
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	78 1b                	js     80185f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	68 07 04 00 00       	push   $0x407
  80184c:	ff 75 f0             	pushl  -0x10(%ebp)
  80184f:	6a 00                	push   $0x0
  801851:	e8 93 f3 ff ff       	call   800be9 <sys_page_alloc>
  801856:	89 c3                	mov    %eax,%ebx
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	79 19                	jns    801878 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	ff 75 f4             	pushl  -0xc(%ebp)
  801865:	6a 00                	push   $0x0
  801867:	e8 02 f4 ff ff       	call   800c6e <sys_page_unmap>
  80186c:	83 c4 10             	add    $0x10,%esp
}
  80186f:	89 d8                	mov    %ebx,%eax
  801871:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801874:	5b                   	pop    %ebx
  801875:	5e                   	pop    %esi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
	va = fd2data(fd0);
  801878:	83 ec 0c             	sub    $0xc,%esp
  80187b:	ff 75 f4             	pushl  -0xc(%ebp)
  80187e:	e8 86 f5 ff ff       	call   800e09 <fd2data>
  801883:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801885:	83 c4 0c             	add    $0xc,%esp
  801888:	68 07 04 00 00       	push   $0x407
  80188d:	50                   	push   %eax
  80188e:	6a 00                	push   $0x0
  801890:	e8 54 f3 ff ff       	call   800be9 <sys_page_alloc>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	0f 88 8c 00 00 00    	js     80192e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a8:	e8 5c f5 ff ff       	call   800e09 <fd2data>
  8018ad:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018b4:	50                   	push   %eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	56                   	push   %esi
  8018b8:	6a 00                	push   $0x0
  8018ba:	e8 6d f3 ff ff       	call   800c2c <sys_page_map>
  8018bf:	89 c3                	mov    %eax,%ebx
  8018c1:	83 c4 20             	add    $0x20,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 58                	js     801920 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018eb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018f2:	83 ec 0c             	sub    $0xc,%esp
  8018f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f8:	e8 fc f4 ff ff       	call   800df9 <fd2num>
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801902:	83 c4 04             	add    $0x4,%esp
  801905:	ff 75 f0             	pushl  -0x10(%ebp)
  801908:	e8 ec f4 ff ff       	call   800df9 <fd2num>
  80190d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801910:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191b:	e9 4f ff ff ff       	jmp    80186f <pipe+0x75>
	sys_page_unmap(0, va);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	56                   	push   %esi
  801924:	6a 00                	push   $0x0
  801926:	e8 43 f3 ff ff       	call   800c6e <sys_page_unmap>
  80192b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	ff 75 f0             	pushl  -0x10(%ebp)
  801934:	6a 00                	push   $0x0
  801936:	e8 33 f3 ff ff       	call   800c6e <sys_page_unmap>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	e9 1c ff ff ff       	jmp    80185f <pipe+0x65>

00801943 <pipeisclosed>:
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801949:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194c:	50                   	push   %eax
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 1a f5 ff ff       	call   800e6f <fd_lookup>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 18                	js     801974 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 f4             	pushl  -0xc(%ebp)
  801962:	e8 a2 f4 ff ff       	call   800e09 <fd2data>
	return _pipeisclosed(fd, p);
  801967:	89 c2                	mov    %eax,%edx
  801969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196c:	e8 30 fd ff ff       	call   8016a1 <_pipeisclosed>
  801971:	83 c4 10             	add    $0x10,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80197c:	68 9b 27 80 00       	push   $0x80279b
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	e8 67 ee ff ff       	call   8007f0 <strcpy>
	return 0;
}
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <devsock_close>:
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	53                   	push   %ebx
  801994:	83 ec 10             	sub    $0x10,%esp
  801997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80199a:	53                   	push   %ebx
  80199b:	e8 f9 06 00 00       	call   802099 <pageref>
  8019a0:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019a3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019a8:	83 f8 01             	cmp    $0x1,%eax
  8019ab:	74 07                	je     8019b4 <devsock_close+0x24>
}
  8019ad:	89 d0                	mov    %edx,%eax
  8019af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	ff 73 0c             	pushl  0xc(%ebx)
  8019ba:	e8 b7 02 00 00       	call   801c76 <nsipc_close>
  8019bf:	89 c2                	mov    %eax,%edx
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	eb e7                	jmp    8019ad <devsock_close+0x1d>

008019c6 <devsock_write>:
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 10             	pushl  0x10(%ebp)
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	ff 70 0c             	pushl  0xc(%eax)
  8019da:	e8 74 03 00 00       	call   801d53 <nsipc_send>
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <devsock_read>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	ff 70 0c             	pushl  0xc(%eax)
  8019f5:	e8 ed 02 00 00       	call   801ce7 <nsipc_recv>
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <fd2sockid>:
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a02:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a05:	52                   	push   %edx
  801a06:	50                   	push   %eax
  801a07:	e8 63 f4 ff ff       	call   800e6f <fd_lookup>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 10                	js     801a23 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a16:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a1c:	39 08                	cmp    %ecx,(%eax)
  801a1e:	75 05                	jne    801a25 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a20:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    
		return -E_NOT_SUPP;
  801a25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2a:	eb f7                	jmp    801a23 <fd2sockid+0x27>

00801a2c <alloc_sockfd>:
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
  801a31:	83 ec 1c             	sub    $0x1c,%esp
  801a34:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a39:	50                   	push   %eax
  801a3a:	e8 e1 f3 ff ff       	call   800e20 <fd_alloc>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 43                	js     801a8b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	68 07 04 00 00       	push   $0x407
  801a50:	ff 75 f4             	pushl  -0xc(%ebp)
  801a53:	6a 00                	push   $0x0
  801a55:	e8 8f f1 ff ff       	call   800be9 <sys_page_alloc>
  801a5a:	89 c3                	mov    %eax,%ebx
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 28                	js     801a8b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a71:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a78:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	50                   	push   %eax
  801a7f:	e8 75 f3 ff ff       	call   800df9 <fd2num>
  801a84:	89 c3                	mov    %eax,%ebx
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	eb 0c                	jmp    801a97 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a8b:	83 ec 0c             	sub    $0xc,%esp
  801a8e:	56                   	push   %esi
  801a8f:	e8 e2 01 00 00       	call   801c76 <nsipc_close>
		return r;
  801a94:	83 c4 10             	add    $0x10,%esp
}
  801a97:	89 d8                	mov    %ebx,%eax
  801a99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9c:	5b                   	pop    %ebx
  801a9d:	5e                   	pop    %esi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <accept>:
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	e8 4e ff ff ff       	call   8019fc <fd2sockid>
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 1b                	js     801acd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	ff 75 10             	pushl  0x10(%ebp)
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	50                   	push   %eax
  801abc:	e8 0e 01 00 00       	call   801bcf <nsipc_accept>
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	78 05                	js     801acd <accept+0x2d>
	return alloc_sockfd(r);
  801ac8:	e8 5f ff ff ff       	call   801a2c <alloc_sockfd>
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <bind>:
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	e8 1f ff ff ff       	call   8019fc <fd2sockid>
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 12                	js     801af3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	ff 75 10             	pushl  0x10(%ebp)
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	50                   	push   %eax
  801aeb:	e8 2f 01 00 00       	call   801c1f <nsipc_bind>
  801af0:	83 c4 10             	add    $0x10,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <shutdown>:
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	e8 f9 fe ff ff       	call   8019fc <fd2sockid>
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 0f                	js     801b16 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	50                   	push   %eax
  801b0e:	e8 41 01 00 00       	call   801c54 <nsipc_shutdown>
  801b13:	83 c4 10             	add    $0x10,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <connect>:
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	e8 d6 fe ff ff       	call   8019fc <fd2sockid>
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 12                	js     801b3c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	ff 75 10             	pushl  0x10(%ebp)
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	50                   	push   %eax
  801b34:	e8 57 01 00 00       	call   801c90 <nsipc_connect>
  801b39:	83 c4 10             	add    $0x10,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <listen>:
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	e8 b0 fe ff ff       	call   8019fc <fd2sockid>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 0f                	js     801b5f <listen+0x21>
	return nsipc_listen(r, backlog);
  801b50:	83 ec 08             	sub    $0x8,%esp
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	50                   	push   %eax
  801b57:	e8 69 01 00 00       	call   801cc5 <nsipc_listen>
  801b5c:	83 c4 10             	add    $0x10,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	e8 3c 02 00 00       	call   801db1 <nsipc_socket>
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	85 c0                	test   %eax,%eax
  801b7a:	78 05                	js     801b81 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b7c:	e8 ab fe ff ff       	call   801a2c <alloc_sockfd>
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	53                   	push   %ebx
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b8c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b93:	74 26                	je     801bbb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b95:	6a 07                	push   $0x7
  801b97:	68 00 60 80 00       	push   $0x806000
  801b9c:	53                   	push   %ebx
  801b9d:	ff 35 04 40 80 00    	pushl  0x804004
  801ba3:	e8 5f 04 00 00       	call   802007 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ba8:	83 c4 0c             	add    $0xc,%esp
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	e8 e8 03 00 00       	call   801f9e <ipc_recv>
}
  801bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	6a 02                	push   $0x2
  801bc0:	e8 9b 04 00 00       	call   802060 <ipc_find_env>
  801bc5:	a3 04 40 80 00       	mov    %eax,0x804004
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	eb c6                	jmp    801b95 <nsipc+0x12>

00801bcf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bdf:	8b 06                	mov    (%esi),%eax
  801be1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801be6:	b8 01 00 00 00       	mov    $0x1,%eax
  801beb:	e8 93 ff ff ff       	call   801b83 <nsipc>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 20                	js     801c16 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	ff 35 10 60 80 00    	pushl  0x806010
  801bff:	68 00 60 80 00       	push   $0x806000
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	e8 72 ed ff ff       	call   80097e <memmove>
		*addrlen = ret->ret_addrlen;
  801c0c:	a1 10 60 80 00       	mov    0x806010,%eax
  801c11:	89 06                	mov    %eax,(%esi)
  801c13:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c16:	89 d8                	mov    %ebx,%eax
  801c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    

00801c1f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	53                   	push   %ebx
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c31:	53                   	push   %ebx
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	68 04 60 80 00       	push   $0x806004
  801c3a:	e8 3f ed ff ff       	call   80097e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c3f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c45:	b8 02 00 00 00       	mov    $0x2,%eax
  801c4a:	e8 34 ff ff ff       	call   801b83 <nsipc>
}
  801c4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c6a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c6f:	e8 0f ff ff ff       	call   801b83 <nsipc>
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <nsipc_close>:

int
nsipc_close(int s)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c84:	b8 04 00 00 00       	mov    $0x4,%eax
  801c89:	e8 f5 fe ff ff       	call   801b83 <nsipc>
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 08             	sub    $0x8,%esp
  801c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ca2:	53                   	push   %ebx
  801ca3:	ff 75 0c             	pushl  0xc(%ebp)
  801ca6:	68 04 60 80 00       	push   $0x806004
  801cab:	e8 ce ec ff ff       	call   80097e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cb0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cb6:	b8 05 00 00 00       	mov    $0x5,%eax
  801cbb:	e8 c3 fe ff ff       	call   801b83 <nsipc>
}
  801cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cdb:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce0:	e8 9e fe ff ff       	call   801b83 <nsipc>
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	56                   	push   %esi
  801ceb:	53                   	push   %ebx
  801cec:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cf7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801d00:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d05:	b8 07 00 00 00       	mov    $0x7,%eax
  801d0a:	e8 74 fe ff ff       	call   801b83 <nsipc>
  801d0f:	89 c3                	mov    %eax,%ebx
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 1f                	js     801d34 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d15:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d1a:	7f 21                	jg     801d3d <nsipc_recv+0x56>
  801d1c:	39 c6                	cmp    %eax,%esi
  801d1e:	7c 1d                	jl     801d3d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	50                   	push   %eax
  801d24:	68 00 60 80 00       	push   $0x806000
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	e8 4d ec ff ff       	call   80097e <memmove>
  801d31:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d39:	5b                   	pop    %ebx
  801d3a:	5e                   	pop    %esi
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d3d:	68 a7 27 80 00       	push   $0x8027a7
  801d42:	68 49 27 80 00       	push   $0x802749
  801d47:	6a 62                	push   $0x62
  801d49:	68 bc 27 80 00       	push   $0x8027bc
  801d4e:	e8 05 02 00 00       	call   801f58 <_panic>

00801d53 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	53                   	push   %ebx
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d65:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d6b:	7f 2e                	jg     801d9b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	53                   	push   %ebx
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	68 0c 60 80 00       	push   $0x80600c
  801d79:	e8 00 ec ff ff       	call   80097e <memmove>
	nsipcbuf.send.req_size = size;
  801d7e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d84:	8b 45 14             	mov    0x14(%ebp),%eax
  801d87:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d8c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d91:	e8 ed fd ff ff       	call   801b83 <nsipc>
}
  801d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    
	assert(size < 1600);
  801d9b:	68 c8 27 80 00       	push   $0x8027c8
  801da0:	68 49 27 80 00       	push   $0x802749
  801da5:	6a 6d                	push   $0x6d
  801da7:	68 bc 27 80 00       	push   $0x8027bc
  801dac:	e8 a7 01 00 00       	call   801f58 <_panic>

00801db1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dca:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dcf:	b8 09 00 00 00       	mov    $0x9,%eax
  801dd4:	e8 aa fd ff ff       	call   801b83 <nsipc>
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    

00801de5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801deb:	68 d4 27 80 00       	push   $0x8027d4
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	e8 f8 e9 ff ff       	call   8007f0 <strcpy>
	return 0;
}
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <devcons_write>:
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	57                   	push   %edi
  801e03:	56                   	push   %esi
  801e04:	53                   	push   %ebx
  801e05:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e0b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e10:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e16:	eb 2f                	jmp    801e47 <devcons_write+0x48>
		m = n - tot;
  801e18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e1b:	29 f3                	sub    %esi,%ebx
  801e1d:	83 fb 7f             	cmp    $0x7f,%ebx
  801e20:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e25:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	53                   	push   %ebx
  801e2c:	89 f0                	mov    %esi,%eax
  801e2e:	03 45 0c             	add    0xc(%ebp),%eax
  801e31:	50                   	push   %eax
  801e32:	57                   	push   %edi
  801e33:	e8 46 eb ff ff       	call   80097e <memmove>
		sys_cputs(buf, m);
  801e38:	83 c4 08             	add    $0x8,%esp
  801e3b:	53                   	push   %ebx
  801e3c:	57                   	push   %edi
  801e3d:	e8 eb ec ff ff       	call   800b2d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e42:	01 de                	add    %ebx,%esi
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e4a:	72 cc                	jb     801e18 <devcons_write+0x19>
}
  801e4c:	89 f0                	mov    %esi,%eax
  801e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    

00801e56 <devcons_read>:
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e65:	75 07                	jne    801e6e <devcons_read+0x18>
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    
		sys_yield();
  801e69:	e8 5c ed ff ff       	call   800bca <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e6e:	e8 d8 ec ff ff       	call   800b4b <sys_cgetc>
  801e73:	85 c0                	test   %eax,%eax
  801e75:	74 f2                	je     801e69 <devcons_read+0x13>
	if (c < 0)
  801e77:	85 c0                	test   %eax,%eax
  801e79:	78 ec                	js     801e67 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e7b:	83 f8 04             	cmp    $0x4,%eax
  801e7e:	74 0c                	je     801e8c <devcons_read+0x36>
	*(char*)vbuf = c;
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	88 02                	mov    %al,(%edx)
	return 1;
  801e85:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8a:	eb db                	jmp    801e67 <devcons_read+0x11>
		return 0;
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e91:	eb d4                	jmp    801e67 <devcons_read+0x11>

00801e93 <cputchar>:
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e9f:	6a 01                	push   $0x1
  801ea1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea4:	50                   	push   %eax
  801ea5:	e8 83 ec ff ff       	call   800b2d <sys_cputs>
}
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <getchar>:
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801eb5:	6a 01                	push   $0x1
  801eb7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eba:	50                   	push   %eax
  801ebb:	6a 00                	push   $0x0
  801ebd:	e8 1e f2 ff ff       	call   8010e0 <read>
	if (r < 0)
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	78 08                	js     801ed1 <getchar+0x22>
	if (r < 1)
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	7e 06                	jle    801ed3 <getchar+0x24>
	return c;
  801ecd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    
		return -E_EOF;
  801ed3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ed8:	eb f7                	jmp    801ed1 <getchar+0x22>

00801eda <iscons>:
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ee0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee3:	50                   	push   %eax
  801ee4:	ff 75 08             	pushl  0x8(%ebp)
  801ee7:	e8 83 ef ff ff       	call   800e6f <fd_lookup>
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 11                	js     801f04 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801efc:	39 10                	cmp    %edx,(%eax)
  801efe:	0f 94 c0             	sete   %al
  801f01:	0f b6 c0             	movzbl %al,%eax
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <opencons>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0f:	50                   	push   %eax
  801f10:	e8 0b ef ff ff       	call   800e20 <fd_alloc>
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 3a                	js     801f56 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 07 04 00 00       	push   $0x407
  801f24:	ff 75 f4             	pushl  -0xc(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 bb ec ff ff       	call   800be9 <sys_page_alloc>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 21                	js     801f56 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f3e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	50                   	push   %eax
  801f4e:	e8 a6 ee ff ff       	call   800df9 <fd2num>
  801f53:	83 c4 10             	add    $0x10,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	56                   	push   %esi
  801f5c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f5d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f60:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f66:	e8 40 ec ff ff       	call   800bab <sys_getenvid>
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	ff 75 0c             	pushl  0xc(%ebp)
  801f71:	ff 75 08             	pushl  0x8(%ebp)
  801f74:	56                   	push   %esi
  801f75:	50                   	push   %eax
  801f76:	68 e0 27 80 00       	push   $0x8027e0
  801f7b:	e8 d3 e1 ff ff       	call   800153 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f80:	83 c4 18             	add    $0x18,%esp
  801f83:	53                   	push   %ebx
  801f84:	ff 75 10             	pushl  0x10(%ebp)
  801f87:	e8 76 e1 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  801f8c:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  801f93:	e8 bb e1 ff ff       	call   800153 <cprintf>
  801f98:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f9b:	cc                   	int3   
  801f9c:	eb fd                	jmp    801f9b <_panic+0x43>

00801f9e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801fac:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801fae:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fb3:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	50                   	push   %eax
  801fba:	e8 da ed ff ff       	call   800d99 <sys_ipc_recv>
  801fbf:	83 c4 10             	add    $0x10,%esp
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 2b                	js     801ff1 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fc6:	85 f6                	test   %esi,%esi
  801fc8:	74 0a                	je     801fd4 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fca:	a1 08 40 80 00       	mov    0x804008,%eax
  801fcf:	8b 40 74             	mov    0x74(%eax),%eax
  801fd2:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fd4:	85 db                	test   %ebx,%ebx
  801fd6:	74 0a                	je     801fe2 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fd8:	a1 08 40 80 00       	mov    0x804008,%eax
  801fdd:	8b 40 78             	mov    0x78(%eax),%eax
  801fe0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fe2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fe7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fed:	5b                   	pop    %ebx
  801fee:	5e                   	pop    %esi
  801fef:	5d                   	pop    %ebp
  801ff0:	c3                   	ret    
	    if (from_env_store != NULL) {
  801ff1:	85 f6                	test   %esi,%esi
  801ff3:	74 06                	je     801ffb <ipc_recv+0x5d>
	        *from_env_store = 0;
  801ff5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801ffb:	85 db                	test   %ebx,%ebx
  801ffd:	74 eb                	je     801fea <ipc_recv+0x4c>
	        *perm_store = 0;
  801fff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802005:	eb e3                	jmp    801fea <ipc_recv+0x4c>

00802007 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	57                   	push   %edi
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	8b 7d 08             	mov    0x8(%ebp),%edi
  802013:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802016:	85 f6                	test   %esi,%esi
  802018:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80201d:	0f 44 f0             	cmove  %eax,%esi
  802020:	eb 09                	jmp    80202b <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802022:	e8 a3 eb ff ff       	call   800bca <sys_yield>
	} while(r != 0);
  802027:	85 db                	test   %ebx,%ebx
  802029:	74 2d                	je     802058 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80202b:	ff 75 14             	pushl  0x14(%ebp)
  80202e:	56                   	push   %esi
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	57                   	push   %edi
  802033:	e8 3e ed ff ff       	call   800d76 <sys_ipc_try_send>
  802038:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	79 e1                	jns    802022 <ipc_send+0x1b>
  802041:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802044:	74 dc                	je     802022 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802046:	50                   	push   %eax
  802047:	68 04 28 80 00       	push   $0x802804
  80204c:	6a 45                	push   $0x45
  80204e:	68 11 28 80 00       	push   $0x802811
  802053:	e8 00 ff ff ff       	call   801f58 <_panic>
}
  802058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205b:	5b                   	pop    %ebx
  80205c:	5e                   	pop    %esi
  80205d:	5f                   	pop    %edi
  80205e:	5d                   	pop    %ebp
  80205f:	c3                   	ret    

00802060 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80206b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80206e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802074:	8b 52 50             	mov    0x50(%edx),%edx
  802077:	39 ca                	cmp    %ecx,%edx
  802079:	74 11                	je     80208c <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80207b:	83 c0 01             	add    $0x1,%eax
  80207e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802083:	75 e6                	jne    80206b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	eb 0b                	jmp    802097 <ipc_find_env+0x37>
			return envs[i].env_id;
  80208c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80208f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802094:	8b 40 48             	mov    0x48(%eax),%eax
}
  802097:	5d                   	pop    %ebp
  802098:	c3                   	ret    

00802099 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80209f:	89 d0                	mov    %edx,%eax
  8020a1:	c1 e8 16             	shr    $0x16,%eax
  8020a4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020b0:	f6 c1 01             	test   $0x1,%cl
  8020b3:	74 1d                	je     8020d2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020b5:	c1 ea 0c             	shr    $0xc,%edx
  8020b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020bf:	f6 c2 01             	test   $0x1,%dl
  8020c2:	74 0e                	je     8020d2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020c4:	c1 ea 0c             	shr    $0xc,%edx
  8020c7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020ce:	ef 
  8020cf:	0f b7 c0             	movzwl %ax,%eax
}
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	66 90                	xchg   %ax,%ax
  8020d6:	66 90                	xchg   %ax,%ax
  8020d8:	66 90                	xchg   %ax,%ax
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	66 90                	xchg   %ax,%ax
  8020de:	66 90                	xchg   %ax,%ax

008020e0 <__udivdi3>:
  8020e0:	55                   	push   %ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 1c             	sub    $0x1c,%esp
  8020e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020f7:	85 d2                	test   %edx,%edx
  8020f9:	75 35                	jne    802130 <__udivdi3+0x50>
  8020fb:	39 f3                	cmp    %esi,%ebx
  8020fd:	0f 87 bd 00 00 00    	ja     8021c0 <__udivdi3+0xe0>
  802103:	85 db                	test   %ebx,%ebx
  802105:	89 d9                	mov    %ebx,%ecx
  802107:	75 0b                	jne    802114 <__udivdi3+0x34>
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
  80210e:	31 d2                	xor    %edx,%edx
  802110:	f7 f3                	div    %ebx
  802112:	89 c1                	mov    %eax,%ecx
  802114:	31 d2                	xor    %edx,%edx
  802116:	89 f0                	mov    %esi,%eax
  802118:	f7 f1                	div    %ecx
  80211a:	89 c6                	mov    %eax,%esi
  80211c:	89 e8                	mov    %ebp,%eax
  80211e:	89 f7                	mov    %esi,%edi
  802120:	f7 f1                	div    %ecx
  802122:	89 fa                	mov    %edi,%edx
  802124:	83 c4 1c             	add    $0x1c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
  80212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802130:	39 f2                	cmp    %esi,%edx
  802132:	77 7c                	ja     8021b0 <__udivdi3+0xd0>
  802134:	0f bd fa             	bsr    %edx,%edi
  802137:	83 f7 1f             	xor    $0x1f,%edi
  80213a:	0f 84 98 00 00 00    	je     8021d8 <__udivdi3+0xf8>
  802140:	89 f9                	mov    %edi,%ecx
  802142:	b8 20 00 00 00       	mov    $0x20,%eax
  802147:	29 f8                	sub    %edi,%eax
  802149:	d3 e2                	shl    %cl,%edx
  80214b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	89 da                	mov    %ebx,%edx
  802153:	d3 ea                	shr    %cl,%edx
  802155:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802159:	09 d1                	or     %edx,%ecx
  80215b:	89 f2                	mov    %esi,%edx
  80215d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802161:	89 f9                	mov    %edi,%ecx
  802163:	d3 e3                	shl    %cl,%ebx
  802165:	89 c1                	mov    %eax,%ecx
  802167:	d3 ea                	shr    %cl,%edx
  802169:	89 f9                	mov    %edi,%ecx
  80216b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80216f:	d3 e6                	shl    %cl,%esi
  802171:	89 eb                	mov    %ebp,%ebx
  802173:	89 c1                	mov    %eax,%ecx
  802175:	d3 eb                	shr    %cl,%ebx
  802177:	09 de                	or     %ebx,%esi
  802179:	89 f0                	mov    %esi,%eax
  80217b:	f7 74 24 08          	divl   0x8(%esp)
  80217f:	89 d6                	mov    %edx,%esi
  802181:	89 c3                	mov    %eax,%ebx
  802183:	f7 64 24 0c          	mull   0xc(%esp)
  802187:	39 d6                	cmp    %edx,%esi
  802189:	72 0c                	jb     802197 <__udivdi3+0xb7>
  80218b:	89 f9                	mov    %edi,%ecx
  80218d:	d3 e5                	shl    %cl,%ebp
  80218f:	39 c5                	cmp    %eax,%ebp
  802191:	73 5d                	jae    8021f0 <__udivdi3+0x110>
  802193:	39 d6                	cmp    %edx,%esi
  802195:	75 59                	jne    8021f0 <__udivdi3+0x110>
  802197:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80219a:	31 ff                	xor    %edi,%edi
  80219c:	89 fa                	mov    %edi,%edx
  80219e:	83 c4 1c             	add    $0x1c,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    
  8021a6:	8d 76 00             	lea    0x0(%esi),%esi
  8021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021b0:	31 ff                	xor    %edi,%edi
  8021b2:	31 c0                	xor    %eax,%eax
  8021b4:	89 fa                	mov    %edi,%edx
  8021b6:	83 c4 1c             	add    $0x1c,%esp
  8021b9:	5b                   	pop    %ebx
  8021ba:	5e                   	pop    %esi
  8021bb:	5f                   	pop    %edi
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	31 ff                	xor    %edi,%edi
  8021c2:	89 e8                	mov    %ebp,%eax
  8021c4:	89 f2                	mov    %esi,%edx
  8021c6:	f7 f3                	div    %ebx
  8021c8:	89 fa                	mov    %edi,%edx
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	72 06                	jb     8021e2 <__udivdi3+0x102>
  8021dc:	31 c0                	xor    %eax,%eax
  8021de:	39 eb                	cmp    %ebp,%ebx
  8021e0:	77 d2                	ja     8021b4 <__udivdi3+0xd4>
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb cb                	jmp    8021b4 <__udivdi3+0xd4>
  8021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	31 ff                	xor    %edi,%edi
  8021f4:	eb be                	jmp    8021b4 <__udivdi3+0xd4>
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	66 90                	xchg   %ax,%ax
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__umoddi3>:
  802200:	55                   	push   %ebp
  802201:	57                   	push   %edi
  802202:	56                   	push   %esi
  802203:	53                   	push   %ebx
  802204:	83 ec 1c             	sub    $0x1c,%esp
  802207:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80220b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80220f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802213:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802217:	85 ed                	test   %ebp,%ebp
  802219:	89 f0                	mov    %esi,%eax
  80221b:	89 da                	mov    %ebx,%edx
  80221d:	75 19                	jne    802238 <__umoddi3+0x38>
  80221f:	39 df                	cmp    %ebx,%edi
  802221:	0f 86 b1 00 00 00    	jbe    8022d8 <__umoddi3+0xd8>
  802227:	f7 f7                	div    %edi
  802229:	89 d0                	mov    %edx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	39 dd                	cmp    %ebx,%ebp
  80223a:	77 f1                	ja     80222d <__umoddi3+0x2d>
  80223c:	0f bd cd             	bsr    %ebp,%ecx
  80223f:	83 f1 1f             	xor    $0x1f,%ecx
  802242:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802246:	0f 84 b4 00 00 00    	je     802300 <__umoddi3+0x100>
  80224c:	b8 20 00 00 00       	mov    $0x20,%eax
  802251:	89 c2                	mov    %eax,%edx
  802253:	8b 44 24 04          	mov    0x4(%esp),%eax
  802257:	29 c2                	sub    %eax,%edx
  802259:	89 c1                	mov    %eax,%ecx
  80225b:	89 f8                	mov    %edi,%eax
  80225d:	d3 e5                	shl    %cl,%ebp
  80225f:	89 d1                	mov    %edx,%ecx
  802261:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802265:	d3 e8                	shr    %cl,%eax
  802267:	09 c5                	or     %eax,%ebp
  802269:	8b 44 24 04          	mov    0x4(%esp),%eax
  80226d:	89 c1                	mov    %eax,%ecx
  80226f:	d3 e7                	shl    %cl,%edi
  802271:	89 d1                	mov    %edx,%ecx
  802273:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802277:	89 df                	mov    %ebx,%edi
  802279:	d3 ef                	shr    %cl,%edi
  80227b:	89 c1                	mov    %eax,%ecx
  80227d:	89 f0                	mov    %esi,%eax
  80227f:	d3 e3                	shl    %cl,%ebx
  802281:	89 d1                	mov    %edx,%ecx
  802283:	89 fa                	mov    %edi,%edx
  802285:	d3 e8                	shr    %cl,%eax
  802287:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80228c:	09 d8                	or     %ebx,%eax
  80228e:	f7 f5                	div    %ebp
  802290:	d3 e6                	shl    %cl,%esi
  802292:	89 d1                	mov    %edx,%ecx
  802294:	f7 64 24 08          	mull   0x8(%esp)
  802298:	39 d1                	cmp    %edx,%ecx
  80229a:	89 c3                	mov    %eax,%ebx
  80229c:	89 d7                	mov    %edx,%edi
  80229e:	72 06                	jb     8022a6 <__umoddi3+0xa6>
  8022a0:	75 0e                	jne    8022b0 <__umoddi3+0xb0>
  8022a2:	39 c6                	cmp    %eax,%esi
  8022a4:	73 0a                	jae    8022b0 <__umoddi3+0xb0>
  8022a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022aa:	19 ea                	sbb    %ebp,%edx
  8022ac:	89 d7                	mov    %edx,%edi
  8022ae:	89 c3                	mov    %eax,%ebx
  8022b0:	89 ca                	mov    %ecx,%edx
  8022b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022b7:	29 de                	sub    %ebx,%esi
  8022b9:	19 fa                	sbb    %edi,%edx
  8022bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022bf:	89 d0                	mov    %edx,%eax
  8022c1:	d3 e0                	shl    %cl,%eax
  8022c3:	89 d9                	mov    %ebx,%ecx
  8022c5:	d3 ee                	shr    %cl,%esi
  8022c7:	d3 ea                	shr    %cl,%edx
  8022c9:	09 f0                	or     %esi,%eax
  8022cb:	83 c4 1c             	add    $0x1c,%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5f                   	pop    %edi
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    
  8022d3:	90                   	nop
  8022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	85 ff                	test   %edi,%edi
  8022da:	89 f9                	mov    %edi,%ecx
  8022dc:	75 0b                	jne    8022e9 <__umoddi3+0xe9>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f7                	div    %edi
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	89 d8                	mov    %ebx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 f0                	mov    %esi,%eax
  8022f1:	f7 f1                	div    %ecx
  8022f3:	e9 31 ff ff ff       	jmp    802229 <__umoddi3+0x29>
  8022f8:	90                   	nop
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	39 dd                	cmp    %ebx,%ebp
  802302:	72 08                	jb     80230c <__umoddi3+0x10c>
  802304:	39 f7                	cmp    %esi,%edi
  802306:	0f 87 21 ff ff ff    	ja     80222d <__umoddi3+0x2d>
  80230c:	89 da                	mov    %ebx,%edx
  80230e:	89 f0                	mov    %esi,%eax
  802310:	29 f8                	sub    %edi,%eax
  802312:	19 ea                	sbb    %ebp,%edx
  802314:	e9 14 ff ff ff       	jmp    80222d <__umoddi3+0x2d>
