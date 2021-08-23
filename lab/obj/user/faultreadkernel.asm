
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	ff 35 00 00 10 f0    	pushl  0xf0100000
  80003f:	68 20 23 80 00       	push   $0x802320
  800044:	e8 fa 00 00 00       	call   800143 <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 3d 0b 00 00       	call   800b9b <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 20 0f 00 00       	call   800fbf <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 b1 0a 00 00       	call   800b5a <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	53                   	push   %ebx
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b8:	8b 13                	mov    (%ebx),%edx
  8000ba:	8d 42 01             	lea    0x1(%edx),%eax
  8000bd:	89 03                	mov    %eax,(%ebx)
  8000bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000cb:	74 09                	je     8000d6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000cd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 ff 00 00 00       	push   $0xff
  8000de:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e1:	50                   	push   %eax
  8000e2:	e8 36 0a 00 00       	call   800b1d <sys_cputs>
		b->idx = 0;
  8000e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb db                	jmp    8000cd <putch+0x1f>

008000f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800102:	00 00 00 
	b.cnt = 0;
  800105:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80010f:	ff 75 0c             	pushl  0xc(%ebp)
  800112:	ff 75 08             	pushl  0x8(%ebp)
  800115:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80011b:	50                   	push   %eax
  80011c:	68 ae 00 80 00       	push   $0x8000ae
  800121:	e8 1a 01 00 00       	call   800240 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800126:	83 c4 08             	add    $0x8,%esp
  800129:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80012f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800135:	50                   	push   %eax
  800136:	e8 e2 09 00 00       	call   800b1d <sys_cputs>

	return b.cnt;
}
  80013b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800149:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80014c:	50                   	push   %eax
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	e8 9d ff ff ff       	call   8000f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 1c             	sub    $0x1c,%esp
  800160:	89 c7                	mov    %eax,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	8b 45 08             	mov    0x8(%ebp),%eax
  800167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80016d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800173:	bb 00 00 00 00       	mov    $0x0,%ebx
  800178:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80017b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80017e:	39 d3                	cmp    %edx,%ebx
  800180:	72 05                	jb     800187 <printnum+0x30>
  800182:	39 45 10             	cmp    %eax,0x10(%ebp)
  800185:	77 7a                	ja     800201 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	ff 75 18             	pushl  0x18(%ebp)
  80018d:	8b 45 14             	mov    0x14(%ebp),%eax
  800190:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800193:	53                   	push   %ebx
  800194:	ff 75 10             	pushl  0x10(%ebp)
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80019d:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a6:	e8 25 1f 00 00       	call   8020d0 <__udivdi3>
  8001ab:	83 c4 18             	add    $0x18,%esp
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	89 f2                	mov    %esi,%edx
  8001b2:	89 f8                	mov    %edi,%eax
  8001b4:	e8 9e ff ff ff       	call   800157 <printnum>
  8001b9:	83 c4 20             	add    $0x20,%esp
  8001bc:	eb 13                	jmp    8001d1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	56                   	push   %esi
  8001c2:	ff 75 18             	pushl  0x18(%ebp)
  8001c5:	ff d7                	call   *%edi
  8001c7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001ca:	83 eb 01             	sub    $0x1,%ebx
  8001cd:	85 db                	test   %ebx,%ebx
  8001cf:	7f ed                	jg     8001be <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	56                   	push   %esi
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001db:	ff 75 e0             	pushl  -0x20(%ebp)
  8001de:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e4:	e8 07 20 00 00       	call   8021f0 <__umoddi3>
  8001e9:	83 c4 14             	add    $0x14,%esp
  8001ec:	0f be 80 51 23 80 00 	movsbl 0x802351(%eax),%eax
  8001f3:	50                   	push   %eax
  8001f4:	ff d7                	call   *%edi
}
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800204:	eb c4                	jmp    8001ca <printnum+0x73>

00800206 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800210:	8b 10                	mov    (%eax),%edx
  800212:	3b 50 04             	cmp    0x4(%eax),%edx
  800215:	73 0a                	jae    800221 <sprintputch+0x1b>
		*b->buf++ = ch;
  800217:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021a:	89 08                	mov    %ecx,(%eax)
  80021c:	8b 45 08             	mov    0x8(%ebp),%eax
  80021f:	88 02                	mov    %al,(%edx)
}
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <printfmt>:
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800229:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 10             	pushl  0x10(%ebp)
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	e8 05 00 00 00       	call   800240 <vprintfmt>
}
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <vprintfmt>:
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 2c             	sub    $0x2c,%esp
  800249:	8b 75 08             	mov    0x8(%ebp),%esi
  80024c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80024f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800252:	e9 21 04 00 00       	jmp    800678 <vprintfmt+0x438>
		padc = ' ';
  800257:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80025b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800262:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800269:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800270:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800275:	8d 47 01             	lea    0x1(%edi),%eax
  800278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027b:	0f b6 17             	movzbl (%edi),%edx
  80027e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800281:	3c 55                	cmp    $0x55,%al
  800283:	0f 87 90 04 00 00    	ja     800719 <vprintfmt+0x4d9>
  800289:	0f b6 c0             	movzbl %al,%eax
  80028c:	ff 24 85 a0 24 80 00 	jmp    *0x8024a0(,%eax,4)
  800293:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800296:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80029a:	eb d9                	jmp    800275 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80029c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80029f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002a3:	eb d0                	jmp    800275 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002a5:	0f b6 d2             	movzbl %dl,%edx
  8002a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002c0:	83 f9 09             	cmp    $0x9,%ecx
  8002c3:	77 55                	ja     80031a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002c8:	eb e9                	jmp    8002b3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cd:	8b 00                	mov    (%eax),%eax
  8002cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d5:	8d 40 04             	lea    0x4(%eax),%eax
  8002d8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002e2:	79 91                	jns    800275 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f1:	eb 82                	jmp    800275 <vprintfmt+0x35>
  8002f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fd:	0f 49 d0             	cmovns %eax,%edx
  800300:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800306:	e9 6a ff ff ff       	jmp    800275 <vprintfmt+0x35>
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80030e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800315:	e9 5b ff ff ff       	jmp    800275 <vprintfmt+0x35>
  80031a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800320:	eb bc                	jmp    8002de <vprintfmt+0x9e>
			lflag++;
  800322:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800328:	e9 48 ff ff ff       	jmp    800275 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80032d:	8b 45 14             	mov    0x14(%ebp),%eax
  800330:	8d 78 04             	lea    0x4(%eax),%edi
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	53                   	push   %ebx
  800337:	ff 30                	pushl  (%eax)
  800339:	ff d6                	call   *%esi
			break;
  80033b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80033e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800341:	e9 2f 03 00 00       	jmp    800675 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800346:	8b 45 14             	mov    0x14(%ebp),%eax
  800349:	8d 78 04             	lea    0x4(%eax),%edi
  80034c:	8b 00                	mov    (%eax),%eax
  80034e:	99                   	cltd   
  80034f:	31 d0                	xor    %edx,%eax
  800351:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800353:	83 f8 0f             	cmp    $0xf,%eax
  800356:	7f 23                	jg     80037b <vprintfmt+0x13b>
  800358:	8b 14 85 00 26 80 00 	mov    0x802600(,%eax,4),%edx
  80035f:	85 d2                	test   %edx,%edx
  800361:	74 18                	je     80037b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800363:	52                   	push   %edx
  800364:	68 5b 27 80 00       	push   $0x80275b
  800369:	53                   	push   %ebx
  80036a:	56                   	push   %esi
  80036b:	e8 b3 fe ff ff       	call   800223 <printfmt>
  800370:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800373:	89 7d 14             	mov    %edi,0x14(%ebp)
  800376:	e9 fa 02 00 00       	jmp    800675 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  80037b:	50                   	push   %eax
  80037c:	68 69 23 80 00       	push   $0x802369
  800381:	53                   	push   %ebx
  800382:	56                   	push   %esi
  800383:	e8 9b fe ff ff       	call   800223 <printfmt>
  800388:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80038e:	e9 e2 02 00 00       	jmp    800675 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  800393:	8b 45 14             	mov    0x14(%ebp),%eax
  800396:	83 c0 04             	add    $0x4,%eax
  800399:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003a1:	85 ff                	test   %edi,%edi
  8003a3:	b8 62 23 80 00       	mov    $0x802362,%eax
  8003a8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003af:	0f 8e bd 00 00 00    	jle    800472 <vprintfmt+0x232>
  8003b5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003b9:	75 0e                	jne    8003c9 <vprintfmt+0x189>
  8003bb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003be:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003c1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003c7:	eb 6d                	jmp    800436 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	ff 75 d0             	pushl  -0x30(%ebp)
  8003cf:	57                   	push   %edi
  8003d0:	e8 ec 03 00 00       	call   8007c1 <strnlen>
  8003d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003d8:	29 c1                	sub    %eax,%ecx
  8003da:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003dd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003ea:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ec:	eb 0f                	jmp    8003fd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	53                   	push   %ebx
  8003f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f7:	83 ef 01             	sub    $0x1,%edi
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 ff                	test   %edi,%edi
  8003ff:	7f ed                	jg     8003ee <vprintfmt+0x1ae>
  800401:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800404:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800407:	85 c9                	test   %ecx,%ecx
  800409:	b8 00 00 00 00       	mov    $0x0,%eax
  80040e:	0f 49 c1             	cmovns %ecx,%eax
  800411:	29 c1                	sub    %eax,%ecx
  800413:	89 75 08             	mov    %esi,0x8(%ebp)
  800416:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800419:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80041c:	89 cb                	mov    %ecx,%ebx
  80041e:	eb 16                	jmp    800436 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800420:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800424:	75 31                	jne    800457 <vprintfmt+0x217>
					putch(ch, putdat);
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	ff 75 0c             	pushl  0xc(%ebp)
  80042c:	50                   	push   %eax
  80042d:	ff 55 08             	call   *0x8(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800433:	83 eb 01             	sub    $0x1,%ebx
  800436:	83 c7 01             	add    $0x1,%edi
  800439:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80043d:	0f be c2             	movsbl %dl,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 59                	je     80049d <vprintfmt+0x25d>
  800444:	85 f6                	test   %esi,%esi
  800446:	78 d8                	js     800420 <vprintfmt+0x1e0>
  800448:	83 ee 01             	sub    $0x1,%esi
  80044b:	79 d3                	jns    800420 <vprintfmt+0x1e0>
  80044d:	89 df                	mov    %ebx,%edi
  80044f:	8b 75 08             	mov    0x8(%ebp),%esi
  800452:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800455:	eb 37                	jmp    80048e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800457:	0f be d2             	movsbl %dl,%edx
  80045a:	83 ea 20             	sub    $0x20,%edx
  80045d:	83 fa 5e             	cmp    $0x5e,%edx
  800460:	76 c4                	jbe    800426 <vprintfmt+0x1e6>
					putch('?', putdat);
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	6a 3f                	push   $0x3f
  80046a:	ff 55 08             	call   *0x8(%ebp)
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	eb c1                	jmp    800433 <vprintfmt+0x1f3>
  800472:	89 75 08             	mov    %esi,0x8(%ebp)
  800475:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800478:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80047b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80047e:	eb b6                	jmp    800436 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	6a 20                	push   $0x20
  800486:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800488:	83 ef 01             	sub    $0x1,%edi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	85 ff                	test   %edi,%edi
  800490:	7f ee                	jg     800480 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800495:	89 45 14             	mov    %eax,0x14(%ebp)
  800498:	e9 d8 01 00 00       	jmp    800675 <vprintfmt+0x435>
  80049d:	89 df                	mov    %ebx,%edi
  80049f:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a5:	eb e7                	jmp    80048e <vprintfmt+0x24e>
	if (lflag >= 2)
  8004a7:	83 f9 01             	cmp    $0x1,%ecx
  8004aa:	7e 45                	jle    8004f1 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8b 50 04             	mov    0x4(%eax),%edx
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 08             	lea    0x8(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c7:	79 62                	jns    80052b <vprintfmt+0x2eb>
				putch('-', putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	53                   	push   %ebx
  8004cd:	6a 2d                	push   $0x2d
  8004cf:	ff d6                	call   *%esi
				num = -(long long) num;
  8004d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004d7:	f7 d8                	neg    %eax
  8004d9:	83 d2 00             	adc    $0x0,%edx
  8004dc:	f7 da                	neg    %edx
  8004de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004e7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8004ec:	e9 66 01 00 00       	jmp    800657 <vprintfmt+0x417>
	else if (lflag)
  8004f1:	85 c9                	test   %ecx,%ecx
  8004f3:	75 1b                	jne    800510 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  8004f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fd:	89 c1                	mov    %eax,%ecx
  8004ff:	c1 f9 1f             	sar    $0x1f,%ecx
  800502:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	eb b3                	jmp    8004c3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	89 c1                	mov    %eax,%ecx
  80051a:	c1 f9 1f             	sar    $0x1f,%ecx
  80051d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 40 04             	lea    0x4(%eax),%eax
  800526:	89 45 14             	mov    %eax,0x14(%ebp)
  800529:	eb 98                	jmp    8004c3 <vprintfmt+0x283>
			base = 10;
  80052b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800530:	e9 22 01 00 00       	jmp    800657 <vprintfmt+0x417>
	if (lflag >= 2)
  800535:	83 f9 01             	cmp    $0x1,%ecx
  800538:	7e 21                	jle    80055b <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 50 04             	mov    0x4(%eax),%edx
  800540:	8b 00                	mov    (%eax),%eax
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800545:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 40 08             	lea    0x8(%eax),%eax
  80054e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800551:	ba 0a 00 00 00       	mov    $0xa,%edx
  800556:	e9 fc 00 00 00       	jmp    800657 <vprintfmt+0x417>
	else if (lflag)
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	75 23                	jne    800582 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	ba 00 00 00 00       	mov    $0x0,%edx
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800578:	ba 0a 00 00 00       	mov    $0xa,%edx
  80057d:	e9 d5 00 00 00       	jmp    800657 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	ba 00 00 00 00       	mov    $0x0,%edx
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005a0:	e9 b2 00 00 00       	jmp    800657 <vprintfmt+0x417>
	if (lflag >= 2)
  8005a5:	83 f9 01             	cmp    $0x1,%ecx
  8005a8:	7e 42                	jle    8005ec <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 50 04             	mov    0x4(%eax),%edx
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 40 08             	lea    0x8(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8005c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ca:	0f 89 87 00 00 00    	jns    800657 <vprintfmt+0x417>
				putch('-', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 2d                	push   $0x2d
  8005d6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005d8:	f7 5d d8             	negl   -0x28(%ebp)
  8005db:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  8005df:	f7 5d dc             	negl   -0x24(%ebp)
  8005e2:	83 c4 10             	add    $0x10,%esp
			base = 8;
  8005e5:	ba 08 00 00 00       	mov    $0x8,%edx
  8005ea:	eb 6b                	jmp    800657 <vprintfmt+0x417>
	else if (lflag)
  8005ec:	85 c9                	test   %ecx,%ecx
  8005ee:	75 1b                	jne    80060b <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
  800609:	eb b6                	jmp    8005c1 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800618:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 40 04             	lea    0x4(%eax),%eax
  800621:	89 45 14             	mov    %eax,0x14(%ebp)
  800624:	eb 9b                	jmp    8005c1 <vprintfmt+0x381>
			putch('0', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 30                	push   $0x30
  80062c:	ff d6                	call   *%esi
			putch('x', putdat);
  80062e:	83 c4 08             	add    $0x8,%esp
  800631:	53                   	push   %ebx
  800632:	6a 78                	push   $0x78
  800634:	ff d6                	call   *%esi
			num = (unsigned long long)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	ba 00 00 00 00       	mov    $0x0,%edx
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800646:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800652:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80065e:	50                   	push   %eax
  80065f:	ff 75 e0             	pushl  -0x20(%ebp)
  800662:	52                   	push   %edx
  800663:	ff 75 dc             	pushl  -0x24(%ebp)
  800666:	ff 75 d8             	pushl  -0x28(%ebp)
  800669:	89 da                	mov    %ebx,%edx
  80066b:	89 f0                	mov    %esi,%eax
  80066d:	e8 e5 fa ff ff       	call   800157 <printnum>
			break;
  800672:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800675:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800678:	83 c7 01             	add    $0x1,%edi
  80067b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067f:	83 f8 25             	cmp    $0x25,%eax
  800682:	0f 84 cf fb ff ff    	je     800257 <vprintfmt+0x17>
			if (ch == '\0')
  800688:	85 c0                	test   %eax,%eax
  80068a:	0f 84 a9 00 00 00    	je     800739 <vprintfmt+0x4f9>
			putch(ch, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	50                   	push   %eax
  800695:	ff d6                	call   *%esi
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	eb dc                	jmp    800678 <vprintfmt+0x438>
	if (lflag >= 2)
  80069c:	83 f9 01             	cmp    $0x1,%ecx
  80069f:	7e 1e                	jle    8006bf <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 50 04             	mov    0x4(%eax),%edx
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 40 08             	lea    0x8(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	ba 10 00 00 00       	mov    $0x10,%edx
  8006bd:	eb 98                	jmp    800657 <vprintfmt+0x417>
	else if (lflag)
  8006bf:	85 c9                	test   %ecx,%ecx
  8006c1:	75 23                	jne    8006e6 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dc:	ba 10 00 00 00       	mov    $0x10,%edx
  8006e1:	e9 71 ff ff ff       	jmp    800657 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ff:	ba 10 00 00 00       	mov    $0x10,%edx
  800704:	e9 4e ff ff ff       	jmp    800657 <vprintfmt+0x417>
			putch(ch, putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 25                	push   $0x25
  80070f:	ff d6                	call   *%esi
			break;
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	e9 5c ff ff ff       	jmp    800675 <vprintfmt+0x435>
			putch('%', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 25                	push   $0x25
  80071f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	89 f8                	mov    %edi,%eax
  800726:	eb 03                	jmp    80072b <vprintfmt+0x4eb>
  800728:	83 e8 01             	sub    $0x1,%eax
  80072b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80072f:	75 f7                	jne    800728 <vprintfmt+0x4e8>
  800731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800734:	e9 3c ff ff ff       	jmp    800675 <vprintfmt+0x435>
}
  800739:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073c:	5b                   	pop    %ebx
  80073d:	5e                   	pop    %esi
  80073e:	5f                   	pop    %edi
  80073f:	5d                   	pop    %ebp
  800740:	c3                   	ret    

00800741 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 18             	sub    $0x18,%esp
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800750:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800754:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 26                	je     800788 <vsnprintf+0x47>
  800762:	85 d2                	test   %edx,%edx
  800764:	7e 22                	jle    800788 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800766:	ff 75 14             	pushl  0x14(%ebp)
  800769:	ff 75 10             	pushl  0x10(%ebp)
  80076c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80076f:	50                   	push   %eax
  800770:	68 06 02 80 00       	push   $0x800206
  800775:	e8 c6 fa ff ff       	call   800240 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800783:	83 c4 10             	add    $0x10,%esp
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    
		return -E_INVAL;
  800788:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80078d:	eb f7                	jmp    800786 <vsnprintf+0x45>

0080078f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800795:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800798:	50                   	push   %eax
  800799:	ff 75 10             	pushl  0x10(%ebp)
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	ff 75 08             	pushl  0x8(%ebp)
  8007a2:	e8 9a ff ff ff       	call   800741 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    

008007a9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007af:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b4:	eb 03                	jmp    8007b9 <strlen+0x10>
		n++;
  8007b6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007b9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007bd:	75 f7                	jne    8007b6 <strlen+0xd>
	return n;
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cf:	eb 03                	jmp    8007d4 <strnlen+0x13>
		n++;
  8007d1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d4:	39 d0                	cmp    %edx,%eax
  8007d6:	74 06                	je     8007de <strnlen+0x1d>
  8007d8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007dc:	75 f3                	jne    8007d1 <strnlen+0x10>
	return n;
}
  8007de:	5d                   	pop    %ebp
  8007df:	c3                   	ret    

008007e0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	53                   	push   %ebx
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ea:	89 c2                	mov    %eax,%edx
  8007ec:	83 c1 01             	add    $0x1,%ecx
  8007ef:	83 c2 01             	add    $0x1,%edx
  8007f2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f9:	84 db                	test   %bl,%bl
  8007fb:	75 ef                	jne    8007ec <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007fd:	5b                   	pop    %ebx
  8007fe:	5d                   	pop    %ebp
  8007ff:	c3                   	ret    

00800800 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800807:	53                   	push   %ebx
  800808:	e8 9c ff ff ff       	call   8007a9 <strlen>
  80080d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	01 d8                	add    %ebx,%eax
  800815:	50                   	push   %eax
  800816:	e8 c5 ff ff ff       	call   8007e0 <strcpy>
	return dst;
}
  80081b:	89 d8                	mov    %ebx,%eax
  80081d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	56                   	push   %esi
  800826:	53                   	push   %ebx
  800827:	8b 75 08             	mov    0x8(%ebp),%esi
  80082a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082d:	89 f3                	mov    %esi,%ebx
  80082f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800832:	89 f2                	mov    %esi,%edx
  800834:	eb 0f                	jmp    800845 <strncpy+0x23>
		*dst++ = *src;
  800836:	83 c2 01             	add    $0x1,%edx
  800839:	0f b6 01             	movzbl (%ecx),%eax
  80083c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083f:	80 39 01             	cmpb   $0x1,(%ecx)
  800842:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800845:	39 da                	cmp    %ebx,%edx
  800847:	75 ed                	jne    800836 <strncpy+0x14>
	}
	return ret;
}
  800849:	89 f0                	mov    %esi,%eax
  80084b:	5b                   	pop    %ebx
  80084c:	5e                   	pop    %esi
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	56                   	push   %esi
  800853:	53                   	push   %ebx
  800854:	8b 75 08             	mov    0x8(%ebp),%esi
  800857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80085d:	89 f0                	mov    %esi,%eax
  80085f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800863:	85 c9                	test   %ecx,%ecx
  800865:	75 0b                	jne    800872 <strlcpy+0x23>
  800867:	eb 17                	jmp    800880 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800869:	83 c2 01             	add    $0x1,%edx
  80086c:	83 c0 01             	add    $0x1,%eax
  80086f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800872:	39 d8                	cmp    %ebx,%eax
  800874:	74 07                	je     80087d <strlcpy+0x2e>
  800876:	0f b6 0a             	movzbl (%edx),%ecx
  800879:	84 c9                	test   %cl,%cl
  80087b:	75 ec                	jne    800869 <strlcpy+0x1a>
		*dst = '\0';
  80087d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800880:	29 f0                	sub    %esi,%eax
}
  800882:	5b                   	pop    %ebx
  800883:	5e                   	pop    %esi
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80088f:	eb 06                	jmp    800897 <strcmp+0x11>
		p++, q++;
  800891:	83 c1 01             	add    $0x1,%ecx
  800894:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800897:	0f b6 01             	movzbl (%ecx),%eax
  80089a:	84 c0                	test   %al,%al
  80089c:	74 04                	je     8008a2 <strcmp+0x1c>
  80089e:	3a 02                	cmp    (%edx),%al
  8008a0:	74 ef                	je     800891 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a2:	0f b6 c0             	movzbl %al,%eax
  8008a5:	0f b6 12             	movzbl (%edx),%edx
  8008a8:	29 d0                	sub    %edx,%eax
}
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	53                   	push   %ebx
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b6:	89 c3                	mov    %eax,%ebx
  8008b8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008bb:	eb 06                	jmp    8008c3 <strncmp+0x17>
		n--, p++, q++;
  8008bd:	83 c0 01             	add    $0x1,%eax
  8008c0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008c3:	39 d8                	cmp    %ebx,%eax
  8008c5:	74 16                	je     8008dd <strncmp+0x31>
  8008c7:	0f b6 08             	movzbl (%eax),%ecx
  8008ca:	84 c9                	test   %cl,%cl
  8008cc:	74 04                	je     8008d2 <strncmp+0x26>
  8008ce:	3a 0a                	cmp    (%edx),%cl
  8008d0:	74 eb                	je     8008bd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d2:	0f b6 00             	movzbl (%eax),%eax
  8008d5:	0f b6 12             	movzbl (%edx),%edx
  8008d8:	29 d0                	sub    %edx,%eax
}
  8008da:	5b                   	pop    %ebx
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    
		return 0;
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e2:	eb f6                	jmp    8008da <strncmp+0x2e>

008008e4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ee:	0f b6 10             	movzbl (%eax),%edx
  8008f1:	84 d2                	test   %dl,%dl
  8008f3:	74 09                	je     8008fe <strchr+0x1a>
		if (*s == c)
  8008f5:	38 ca                	cmp    %cl,%dl
  8008f7:	74 0a                	je     800903 <strchr+0x1f>
	for (; *s; s++)
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	eb f0                	jmp    8008ee <strchr+0xa>
			return (char *) s;
	return 0;
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090f:	eb 03                	jmp    800914 <strfind+0xf>
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800917:	38 ca                	cmp    %cl,%dl
  800919:	74 04                	je     80091f <strfind+0x1a>
  80091b:	84 d2                	test   %dl,%dl
  80091d:	75 f2                	jne    800911 <strfind+0xc>
			break;
	return (char *) s;
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	57                   	push   %edi
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092d:	85 c9                	test   %ecx,%ecx
  80092f:	74 13                	je     800944 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800931:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800937:	75 05                	jne    80093e <memset+0x1d>
  800939:	f6 c1 03             	test   $0x3,%cl
  80093c:	74 0d                	je     80094b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80093e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800941:	fc                   	cld    
  800942:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800944:	89 f8                	mov    %edi,%eax
  800946:	5b                   	pop    %ebx
  800947:	5e                   	pop    %esi
  800948:	5f                   	pop    %edi
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    
		c &= 0xFF;
  80094b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80094f:	89 d3                	mov    %edx,%ebx
  800951:	c1 e3 08             	shl    $0x8,%ebx
  800954:	89 d0                	mov    %edx,%eax
  800956:	c1 e0 18             	shl    $0x18,%eax
  800959:	89 d6                	mov    %edx,%esi
  80095b:	c1 e6 10             	shl    $0x10,%esi
  80095e:	09 f0                	or     %esi,%eax
  800960:	09 c2                	or     %eax,%edx
  800962:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800964:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800967:	89 d0                	mov    %edx,%eax
  800969:	fc                   	cld    
  80096a:	f3 ab                	rep stos %eax,%es:(%edi)
  80096c:	eb d6                	jmp    800944 <memset+0x23>

0080096e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	57                   	push   %edi
  800972:	56                   	push   %esi
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 75 0c             	mov    0xc(%ebp),%esi
  800979:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097c:	39 c6                	cmp    %eax,%esi
  80097e:	73 35                	jae    8009b5 <memmove+0x47>
  800980:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800983:	39 c2                	cmp    %eax,%edx
  800985:	76 2e                	jbe    8009b5 <memmove+0x47>
		s += n;
		d += n;
  800987:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098a:	89 d6                	mov    %edx,%esi
  80098c:	09 fe                	or     %edi,%esi
  80098e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800994:	74 0c                	je     8009a2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800996:	83 ef 01             	sub    $0x1,%edi
  800999:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80099c:	fd                   	std    
  80099d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80099f:	fc                   	cld    
  8009a0:	eb 21                	jmp    8009c3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a2:	f6 c1 03             	test   $0x3,%cl
  8009a5:	75 ef                	jne    800996 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a7:	83 ef 04             	sub    $0x4,%edi
  8009aa:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ad:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b0:	fd                   	std    
  8009b1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b3:	eb ea                	jmp    80099f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b5:	89 f2                	mov    %esi,%edx
  8009b7:	09 c2                	or     %eax,%edx
  8009b9:	f6 c2 03             	test   $0x3,%dl
  8009bc:	74 09                	je     8009c7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009be:	89 c7                	mov    %eax,%edi
  8009c0:	fc                   	cld    
  8009c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c3:	5e                   	pop    %esi
  8009c4:	5f                   	pop    %edi
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c7:	f6 c1 03             	test   $0x3,%cl
  8009ca:	75 f2                	jne    8009be <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009cc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009cf:	89 c7                	mov    %eax,%edi
  8009d1:	fc                   	cld    
  8009d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d4:	eb ed                	jmp    8009c3 <memmove+0x55>

008009d6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009d9:	ff 75 10             	pushl  0x10(%ebp)
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 87 ff ff ff       	call   80096e <memmove>
}
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	56                   	push   %esi
  8009ed:	53                   	push   %ebx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f4:	89 c6                	mov    %eax,%esi
  8009f6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f9:	39 f0                	cmp    %esi,%eax
  8009fb:	74 1c                	je     800a19 <memcmp+0x30>
		if (*s1 != *s2)
  8009fd:	0f b6 08             	movzbl (%eax),%ecx
  800a00:	0f b6 1a             	movzbl (%edx),%ebx
  800a03:	38 d9                	cmp    %bl,%cl
  800a05:	75 08                	jne    800a0f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a07:	83 c0 01             	add    $0x1,%eax
  800a0a:	83 c2 01             	add    $0x1,%edx
  800a0d:	eb ea                	jmp    8009f9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a0f:	0f b6 c1             	movzbl %cl,%eax
  800a12:	0f b6 db             	movzbl %bl,%ebx
  800a15:	29 d8                	sub    %ebx,%eax
  800a17:	eb 05                	jmp    800a1e <memcmp+0x35>
	}

	return 0;
  800a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1e:	5b                   	pop    %ebx
  800a1f:	5e                   	pop    %esi
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2b:	89 c2                	mov    %eax,%edx
  800a2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a30:	39 d0                	cmp    %edx,%eax
  800a32:	73 09                	jae    800a3d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a34:	38 08                	cmp    %cl,(%eax)
  800a36:	74 05                	je     800a3d <memfind+0x1b>
	for (; s < ends; s++)
  800a38:	83 c0 01             	add    $0x1,%eax
  800a3b:	eb f3                	jmp    800a30 <memfind+0xe>
			break;
	return (void *) s;
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	57                   	push   %edi
  800a43:	56                   	push   %esi
  800a44:	53                   	push   %ebx
  800a45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4b:	eb 03                	jmp    800a50 <strtol+0x11>
		s++;
  800a4d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a50:	0f b6 01             	movzbl (%ecx),%eax
  800a53:	3c 20                	cmp    $0x20,%al
  800a55:	74 f6                	je     800a4d <strtol+0xe>
  800a57:	3c 09                	cmp    $0x9,%al
  800a59:	74 f2                	je     800a4d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a5b:	3c 2b                	cmp    $0x2b,%al
  800a5d:	74 2e                	je     800a8d <strtol+0x4e>
	int neg = 0;
  800a5f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a64:	3c 2d                	cmp    $0x2d,%al
  800a66:	74 2f                	je     800a97 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a68:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a6e:	75 05                	jne    800a75 <strtol+0x36>
  800a70:	80 39 30             	cmpb   $0x30,(%ecx)
  800a73:	74 2c                	je     800aa1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a75:	85 db                	test   %ebx,%ebx
  800a77:	75 0a                	jne    800a83 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a79:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a7e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a81:	74 28                	je     800aab <strtol+0x6c>
		base = 10;
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
  800a88:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a8b:	eb 50                	jmp    800add <strtol+0x9e>
		s++;
  800a8d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a90:	bf 00 00 00 00       	mov    $0x0,%edi
  800a95:	eb d1                	jmp    800a68 <strtol+0x29>
		s++, neg = 1;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	bf 01 00 00 00       	mov    $0x1,%edi
  800a9f:	eb c7                	jmp    800a68 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa5:	74 0e                	je     800ab5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa7:	85 db                	test   %ebx,%ebx
  800aa9:	75 d8                	jne    800a83 <strtol+0x44>
		s++, base = 8;
  800aab:	83 c1 01             	add    $0x1,%ecx
  800aae:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ab3:	eb ce                	jmp    800a83 <strtol+0x44>
		s += 2, base = 16;
  800ab5:	83 c1 02             	add    $0x2,%ecx
  800ab8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800abd:	eb c4                	jmp    800a83 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800abf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ac2:	89 f3                	mov    %esi,%ebx
  800ac4:	80 fb 19             	cmp    $0x19,%bl
  800ac7:	77 29                	ja     800af2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ac9:	0f be d2             	movsbl %dl,%edx
  800acc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800acf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ad2:	7d 30                	jge    800b04 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad4:	83 c1 01             	add    $0x1,%ecx
  800ad7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800adb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800add:	0f b6 11             	movzbl (%ecx),%edx
  800ae0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ae3:	89 f3                	mov    %esi,%ebx
  800ae5:	80 fb 09             	cmp    $0x9,%bl
  800ae8:	77 d5                	ja     800abf <strtol+0x80>
			dig = *s - '0';
  800aea:	0f be d2             	movsbl %dl,%edx
  800aed:	83 ea 30             	sub    $0x30,%edx
  800af0:	eb dd                	jmp    800acf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800af2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af5:	89 f3                	mov    %esi,%ebx
  800af7:	80 fb 19             	cmp    $0x19,%bl
  800afa:	77 08                	ja     800b04 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800afc:	0f be d2             	movsbl %dl,%edx
  800aff:	83 ea 37             	sub    $0x37,%edx
  800b02:	eb cb                	jmp    800acf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b08:	74 05                	je     800b0f <strtol+0xd0>
		*endptr = (char *) s;
  800b0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b0f:	89 c2                	mov    %eax,%edx
  800b11:	f7 da                	neg    %edx
  800b13:	85 ff                	test   %edi,%edi
  800b15:	0f 45 c2             	cmovne %edx,%eax
}
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	57                   	push   %edi
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b23:	b8 00 00 00 00       	mov    $0x0,%eax
  800b28:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2e:	89 c3                	mov    %eax,%ebx
  800b30:	89 c7                	mov    %eax,%edi
  800b32:	89 c6                	mov    %eax,%esi
  800b34:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b36:	5b                   	pop    %ebx
  800b37:	5e                   	pop    %esi
  800b38:	5f                   	pop    %edi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	57                   	push   %edi
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4b:	89 d1                	mov    %edx,%ecx
  800b4d:	89 d3                	mov    %edx,%ebx
  800b4f:	89 d7                	mov    %edx,%edi
  800b51:	89 d6                	mov    %edx,%esi
  800b53:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5f                   	pop    %edi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b63:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b68:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b70:	89 cb                	mov    %ecx,%ebx
  800b72:	89 cf                	mov    %ecx,%edi
  800b74:	89 ce                	mov    %ecx,%esi
  800b76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b78:	85 c0                	test   %eax,%eax
  800b7a:	7f 08                	jg     800b84 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b84:	83 ec 0c             	sub    $0xc,%esp
  800b87:	50                   	push   %eax
  800b88:	6a 03                	push   $0x3
  800b8a:	68 5f 26 80 00       	push   $0x80265f
  800b8f:	6a 23                	push   $0x23
  800b91:	68 7c 26 80 00       	push   $0x80267c
  800b96:	e8 ad 13 00 00       	call   801f48 <_panic>

00800b9b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba6:	b8 02 00 00 00       	mov    $0x2,%eax
  800bab:	89 d1                	mov    %edx,%ecx
  800bad:	89 d3                	mov    %edx,%ebx
  800baf:	89 d7                	mov    %edx,%edi
  800bb1:	89 d6                	mov    %edx,%esi
  800bb3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5f                   	pop    %edi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <sys_yield>:

void
sys_yield(void)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bca:	89 d1                	mov    %edx,%ecx
  800bcc:	89 d3                	mov    %edx,%ebx
  800bce:	89 d7                	mov    %edx,%edi
  800bd0:	89 d6                	mov    %edx,%esi
  800bd2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	57                   	push   %edi
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
  800bdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be2:	be 00 00 00 00       	mov    $0x0,%esi
  800be7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bed:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf5:	89 f7                	mov    %esi,%edi
  800bf7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf9:	85 c0                	test   %eax,%eax
  800bfb:	7f 08                	jg     800c05 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c05:	83 ec 0c             	sub    $0xc,%esp
  800c08:	50                   	push   %eax
  800c09:	6a 04                	push   $0x4
  800c0b:	68 5f 26 80 00       	push   $0x80265f
  800c10:	6a 23                	push   $0x23
  800c12:	68 7c 26 80 00       	push   $0x80267c
  800c17:	e8 2c 13 00 00       	call   801f48 <_panic>

00800c1c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
  800c22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c36:	8b 75 18             	mov    0x18(%ebp),%esi
  800c39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	7f 08                	jg     800c47 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c47:	83 ec 0c             	sub    $0xc,%esp
  800c4a:	50                   	push   %eax
  800c4b:	6a 05                	push   $0x5
  800c4d:	68 5f 26 80 00       	push   $0x80265f
  800c52:	6a 23                	push   $0x23
  800c54:	68 7c 26 80 00       	push   $0x80267c
  800c59:	e8 ea 12 00 00       	call   801f48 <_panic>

00800c5e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
  800c64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c72:	b8 06 00 00 00       	mov    $0x6,%eax
  800c77:	89 df                	mov    %ebx,%edi
  800c79:	89 de                	mov    %ebx,%esi
  800c7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	7f 08                	jg     800c89 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c89:	83 ec 0c             	sub    $0xc,%esp
  800c8c:	50                   	push   %eax
  800c8d:	6a 06                	push   $0x6
  800c8f:	68 5f 26 80 00       	push   $0x80265f
  800c94:	6a 23                	push   $0x23
  800c96:	68 7c 26 80 00       	push   $0x80267c
  800c9b:	e8 a8 12 00 00       	call   801f48 <_panic>

00800ca0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb9:	89 df                	mov    %ebx,%edi
  800cbb:	89 de                	mov    %ebx,%esi
  800cbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbf:	85 c0                	test   %eax,%eax
  800cc1:	7f 08                	jg     800ccb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccb:	83 ec 0c             	sub    $0xc,%esp
  800cce:	50                   	push   %eax
  800ccf:	6a 08                	push   $0x8
  800cd1:	68 5f 26 80 00       	push   $0x80265f
  800cd6:	6a 23                	push   $0x23
  800cd8:	68 7c 26 80 00       	push   $0x80267c
  800cdd:	e8 66 12 00 00       	call   801f48 <_panic>

00800ce2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf6:	b8 09 00 00 00       	mov    $0x9,%eax
  800cfb:	89 df                	mov    %ebx,%edi
  800cfd:	89 de                	mov    %ebx,%esi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	50                   	push   %eax
  800d11:	6a 09                	push   $0x9
  800d13:	68 5f 26 80 00       	push   $0x80265f
  800d18:	6a 23                	push   $0x23
  800d1a:	68 7c 26 80 00       	push   $0x80267c
  800d1f:	e8 24 12 00 00       	call   801f48 <_panic>

00800d24 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3d:	89 df                	mov    %ebx,%edi
  800d3f:	89 de                	mov    %ebx,%esi
  800d41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7f 08                	jg     800d4f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	50                   	push   %eax
  800d53:	6a 0a                	push   $0xa
  800d55:	68 5f 26 80 00       	push   $0x80265f
  800d5a:	6a 23                	push   $0x23
  800d5c:	68 7c 26 80 00       	push   $0x80267c
  800d61:	e8 e2 11 00 00       	call   801f48 <_panic>

00800d66 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d72:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d77:	be 00 00 00 00       	mov    $0x0,%esi
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d82:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d9f:	89 cb                	mov    %ecx,%ebx
  800da1:	89 cf                	mov    %ecx,%edi
  800da3:	89 ce                	mov    %ecx,%esi
  800da5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	50                   	push   %eax
  800db7:	6a 0d                	push   $0xd
  800db9:	68 5f 26 80 00       	push   $0x80265f
  800dbe:	6a 23                	push   $0x23
  800dc0:	68 7c 26 80 00       	push   $0x80267c
  800dc5:	e8 7e 11 00 00       	call   801f48 <_panic>

00800dca <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dda:	89 d1                	mov    %edx,%ecx
  800ddc:	89 d3                	mov    %edx,%ebx
  800dde:	89 d7                	mov    %edx,%edi
  800de0:	89 d6                	mov    %edx,%esi
  800de2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	05 00 00 00 30       	add    $0x30000000,%eax
  800df4:	c1 e8 0c             	shr    $0xc,%eax
}
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e09:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e16:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e1b:	89 c2                	mov    %eax,%edx
  800e1d:	c1 ea 16             	shr    $0x16,%edx
  800e20:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e27:	f6 c2 01             	test   $0x1,%dl
  800e2a:	74 2a                	je     800e56 <fd_alloc+0x46>
  800e2c:	89 c2                	mov    %eax,%edx
  800e2e:	c1 ea 0c             	shr    $0xc,%edx
  800e31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e38:	f6 c2 01             	test   $0x1,%dl
  800e3b:	74 19                	je     800e56 <fd_alloc+0x46>
  800e3d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e42:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e47:	75 d2                	jne    800e1b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e49:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e4f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e54:	eb 07                	jmp    800e5d <fd_alloc+0x4d>
			*fd_store = fd;
  800e56:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e65:	83 f8 1f             	cmp    $0x1f,%eax
  800e68:	77 36                	ja     800ea0 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e6a:	c1 e0 0c             	shl    $0xc,%eax
  800e6d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e72:	89 c2                	mov    %eax,%edx
  800e74:	c1 ea 16             	shr    $0x16,%edx
  800e77:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e7e:	f6 c2 01             	test   $0x1,%dl
  800e81:	74 24                	je     800ea7 <fd_lookup+0x48>
  800e83:	89 c2                	mov    %eax,%edx
  800e85:	c1 ea 0c             	shr    $0xc,%edx
  800e88:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e8f:	f6 c2 01             	test   $0x1,%dl
  800e92:	74 1a                	je     800eae <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e97:	89 02                	mov    %eax,(%edx)
	return 0;
  800e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
		return -E_INVAL;
  800ea0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea5:	eb f7                	jmp    800e9e <fd_lookup+0x3f>
		return -E_INVAL;
  800ea7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eac:	eb f0                	jmp    800e9e <fd_lookup+0x3f>
  800eae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb3:	eb e9                	jmp    800e9e <fd_lookup+0x3f>

00800eb5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 08             	sub    $0x8,%esp
  800ebb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebe:	ba 08 27 80 00       	mov    $0x802708,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ec3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ec8:	39 08                	cmp    %ecx,(%eax)
  800eca:	74 33                	je     800eff <dev_lookup+0x4a>
  800ecc:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ecf:	8b 02                	mov    (%edx),%eax
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 f3                	jne    800ec8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ed5:	a1 08 40 80 00       	mov    0x804008,%eax
  800eda:	8b 40 48             	mov    0x48(%eax),%eax
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	51                   	push   %ecx
  800ee1:	50                   	push   %eax
  800ee2:	68 8c 26 80 00       	push   $0x80268c
  800ee7:	e8 57 f2 ff ff       	call   800143 <cprintf>
	*dev = 0;
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ef5:	83 c4 10             	add    $0x10,%esp
  800ef8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    
			*dev = devtab[i];
  800eff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f02:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f04:	b8 00 00 00 00       	mov    $0x0,%eax
  800f09:	eb f2                	jmp    800efd <dev_lookup+0x48>

00800f0b <fd_close>:
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	83 ec 1c             	sub    $0x1c,%esp
  800f14:	8b 75 08             	mov    0x8(%ebp),%esi
  800f17:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f1a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f1d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f24:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f27:	50                   	push   %eax
  800f28:	e8 32 ff ff ff       	call   800e5f <fd_lookup>
  800f2d:	89 c3                	mov    %eax,%ebx
  800f2f:	83 c4 08             	add    $0x8,%esp
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 05                	js     800f3b <fd_close+0x30>
	    || fd != fd2)
  800f36:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f39:	74 16                	je     800f51 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f3b:	89 f8                	mov    %edi,%eax
  800f3d:	84 c0                	test   %al,%al
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	0f 44 d8             	cmove  %eax,%ebx
}
  800f47:	89 d8                	mov    %ebx,%eax
  800f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f57:	50                   	push   %eax
  800f58:	ff 36                	pushl  (%esi)
  800f5a:	e8 56 ff ff ff       	call   800eb5 <dev_lookup>
  800f5f:	89 c3                	mov    %eax,%ebx
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	85 c0                	test   %eax,%eax
  800f66:	78 15                	js     800f7d <fd_close+0x72>
		if (dev->dev_close)
  800f68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f6b:	8b 40 10             	mov    0x10(%eax),%eax
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	74 1b                	je     800f8d <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f72:	83 ec 0c             	sub    $0xc,%esp
  800f75:	56                   	push   %esi
  800f76:	ff d0                	call   *%eax
  800f78:	89 c3                	mov    %eax,%ebx
  800f7a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f7d:	83 ec 08             	sub    $0x8,%esp
  800f80:	56                   	push   %esi
  800f81:	6a 00                	push   $0x0
  800f83:	e8 d6 fc ff ff       	call   800c5e <sys_page_unmap>
	return r;
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	eb ba                	jmp    800f47 <fd_close+0x3c>
			r = 0;
  800f8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f92:	eb e9                	jmp    800f7d <fd_close+0x72>

00800f94 <close>:

int
close(int fdnum)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f9d:	50                   	push   %eax
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	e8 b9 fe ff ff       	call   800e5f <fd_lookup>
  800fa6:	83 c4 08             	add    $0x8,%esp
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	78 10                	js     800fbd <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	6a 01                	push   $0x1
  800fb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb5:	e8 51 ff ff ff       	call   800f0b <fd_close>
  800fba:	83 c4 10             	add    $0x10,%esp
}
  800fbd:	c9                   	leave  
  800fbe:	c3                   	ret    

00800fbf <close_all>:

void
close_all(void)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	53                   	push   %ebx
  800fcf:	e8 c0 ff ff ff       	call   800f94 <close>
	for (i = 0; i < MAXFD; i++)
  800fd4:	83 c3 01             	add    $0x1,%ebx
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	83 fb 20             	cmp    $0x20,%ebx
  800fdd:	75 ec                	jne    800fcb <close_all+0xc>
}
  800fdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff0:	50                   	push   %eax
  800ff1:	ff 75 08             	pushl  0x8(%ebp)
  800ff4:	e8 66 fe ff ff       	call   800e5f <fd_lookup>
  800ff9:	89 c3                	mov    %eax,%ebx
  800ffb:	83 c4 08             	add    $0x8,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	0f 88 81 00 00 00    	js     801087 <dup+0xa3>
		return r;
	close(newfdnum);
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	e8 83 ff ff ff       	call   800f94 <close>

	newfd = INDEX2FD(newfdnum);
  801011:	8b 75 0c             	mov    0xc(%ebp),%esi
  801014:	c1 e6 0c             	shl    $0xc,%esi
  801017:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80101d:	83 c4 04             	add    $0x4,%esp
  801020:	ff 75 e4             	pushl  -0x1c(%ebp)
  801023:	e8 d1 fd ff ff       	call   800df9 <fd2data>
  801028:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80102a:	89 34 24             	mov    %esi,(%esp)
  80102d:	e8 c7 fd ff ff       	call   800df9 <fd2data>
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801037:	89 d8                	mov    %ebx,%eax
  801039:	c1 e8 16             	shr    $0x16,%eax
  80103c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801043:	a8 01                	test   $0x1,%al
  801045:	74 11                	je     801058 <dup+0x74>
  801047:	89 d8                	mov    %ebx,%eax
  801049:	c1 e8 0c             	shr    $0xc,%eax
  80104c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801053:	f6 c2 01             	test   $0x1,%dl
  801056:	75 39                	jne    801091 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801058:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105b:	89 d0                	mov    %edx,%eax
  80105d:	c1 e8 0c             	shr    $0xc,%eax
  801060:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801067:	83 ec 0c             	sub    $0xc,%esp
  80106a:	25 07 0e 00 00       	and    $0xe07,%eax
  80106f:	50                   	push   %eax
  801070:	56                   	push   %esi
  801071:	6a 00                	push   $0x0
  801073:	52                   	push   %edx
  801074:	6a 00                	push   $0x0
  801076:	e8 a1 fb ff ff       	call   800c1c <sys_page_map>
  80107b:	89 c3                	mov    %eax,%ebx
  80107d:	83 c4 20             	add    $0x20,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	78 31                	js     8010b5 <dup+0xd1>
		goto err;

	return newfdnum;
  801084:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801087:	89 d8                	mov    %ebx,%eax
  801089:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801091:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801098:	83 ec 0c             	sub    $0xc,%esp
  80109b:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a0:	50                   	push   %eax
  8010a1:	57                   	push   %edi
  8010a2:	6a 00                	push   $0x0
  8010a4:	53                   	push   %ebx
  8010a5:	6a 00                	push   $0x0
  8010a7:	e8 70 fb ff ff       	call   800c1c <sys_page_map>
  8010ac:	89 c3                	mov    %eax,%ebx
  8010ae:	83 c4 20             	add    $0x20,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	79 a3                	jns    801058 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	56                   	push   %esi
  8010b9:	6a 00                	push   $0x0
  8010bb:	e8 9e fb ff ff       	call   800c5e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010c0:	83 c4 08             	add    $0x8,%esp
  8010c3:	57                   	push   %edi
  8010c4:	6a 00                	push   $0x0
  8010c6:	e8 93 fb ff ff       	call   800c5e <sys_page_unmap>
	return r;
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	eb b7                	jmp    801087 <dup+0xa3>

008010d0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 14             	sub    $0x14,%esp
  8010d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010dd:	50                   	push   %eax
  8010de:	53                   	push   %ebx
  8010df:	e8 7b fd ff ff       	call   800e5f <fd_lookup>
  8010e4:	83 c4 08             	add    $0x8,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	78 3f                	js     80112a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010eb:	83 ec 08             	sub    $0x8,%esp
  8010ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f1:	50                   	push   %eax
  8010f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f5:	ff 30                	pushl  (%eax)
  8010f7:	e8 b9 fd ff ff       	call   800eb5 <dev_lookup>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 27                	js     80112a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801103:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801106:	8b 42 08             	mov    0x8(%edx),%eax
  801109:	83 e0 03             	and    $0x3,%eax
  80110c:	83 f8 01             	cmp    $0x1,%eax
  80110f:	74 1e                	je     80112f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801114:	8b 40 08             	mov    0x8(%eax),%eax
  801117:	85 c0                	test   %eax,%eax
  801119:	74 35                	je     801150 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80111b:	83 ec 04             	sub    $0x4,%esp
  80111e:	ff 75 10             	pushl  0x10(%ebp)
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	52                   	push   %edx
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
}
  80112a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80112f:	a1 08 40 80 00       	mov    0x804008,%eax
  801134:	8b 40 48             	mov    0x48(%eax),%eax
  801137:	83 ec 04             	sub    $0x4,%esp
  80113a:	53                   	push   %ebx
  80113b:	50                   	push   %eax
  80113c:	68 cd 26 80 00       	push   $0x8026cd
  801141:	e8 fd ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114e:	eb da                	jmp    80112a <read+0x5a>
		return -E_NOT_SUPP;
  801150:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801155:	eb d3                	jmp    80112a <read+0x5a>

00801157 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	57                   	push   %edi
  80115b:	56                   	push   %esi
  80115c:	53                   	push   %ebx
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	8b 7d 08             	mov    0x8(%ebp),%edi
  801163:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801166:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116b:	39 f3                	cmp    %esi,%ebx
  80116d:	73 25                	jae    801194 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	89 f0                	mov    %esi,%eax
  801174:	29 d8                	sub    %ebx,%eax
  801176:	50                   	push   %eax
  801177:	89 d8                	mov    %ebx,%eax
  801179:	03 45 0c             	add    0xc(%ebp),%eax
  80117c:	50                   	push   %eax
  80117d:	57                   	push   %edi
  80117e:	e8 4d ff ff ff       	call   8010d0 <read>
		if (m < 0)
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	78 08                	js     801192 <readn+0x3b>
			return m;
		if (m == 0)
  80118a:	85 c0                	test   %eax,%eax
  80118c:	74 06                	je     801194 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80118e:	01 c3                	add    %eax,%ebx
  801190:	eb d9                	jmp    80116b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801192:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801194:	89 d8                	mov    %ebx,%eax
  801196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 14             	sub    $0x14,%esp
  8011a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ab:	50                   	push   %eax
  8011ac:	53                   	push   %ebx
  8011ad:	e8 ad fc ff ff       	call   800e5f <fd_lookup>
  8011b2:	83 c4 08             	add    $0x8,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 3a                	js     8011f3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011bf:	50                   	push   %eax
  8011c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c3:	ff 30                	pushl  (%eax)
  8011c5:	e8 eb fc ff ff       	call   800eb5 <dev_lookup>
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	78 22                	js     8011f3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011d8:	74 1e                	je     8011f8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8011e0:	85 d2                	test   %edx,%edx
  8011e2:	74 35                	je     801219 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	ff 75 10             	pushl  0x10(%ebp)
  8011ea:	ff 75 0c             	pushl  0xc(%ebp)
  8011ed:	50                   	push   %eax
  8011ee:	ff d2                	call   *%edx
  8011f0:	83 c4 10             	add    $0x10,%esp
}
  8011f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f8:	a1 08 40 80 00       	mov    0x804008,%eax
  8011fd:	8b 40 48             	mov    0x48(%eax),%eax
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	53                   	push   %ebx
  801204:	50                   	push   %eax
  801205:	68 e9 26 80 00       	push   $0x8026e9
  80120a:	e8 34 ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801217:	eb da                	jmp    8011f3 <write+0x55>
		return -E_NOT_SUPP;
  801219:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80121e:	eb d3                	jmp    8011f3 <write+0x55>

00801220 <seek>:

int
seek(int fdnum, off_t offset)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801226:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801229:	50                   	push   %eax
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 2d fc ff ff       	call   800e5f <fd_lookup>
  801232:	83 c4 08             	add    $0x8,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 0e                	js     801247 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	53                   	push   %ebx
  80124d:	83 ec 14             	sub    $0x14,%esp
  801250:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801253:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801256:	50                   	push   %eax
  801257:	53                   	push   %ebx
  801258:	e8 02 fc ff ff       	call   800e5f <fd_lookup>
  80125d:	83 c4 08             	add    $0x8,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	78 37                	js     80129b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801264:	83 ec 08             	sub    $0x8,%esp
  801267:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126a:	50                   	push   %eax
  80126b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126e:	ff 30                	pushl  (%eax)
  801270:	e8 40 fc ff ff       	call   800eb5 <dev_lookup>
  801275:	83 c4 10             	add    $0x10,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	78 1f                	js     80129b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801283:	74 1b                	je     8012a0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801285:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801288:	8b 52 18             	mov    0x18(%edx),%edx
  80128b:	85 d2                	test   %edx,%edx
  80128d:	74 32                	je     8012c1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	ff 75 0c             	pushl  0xc(%ebp)
  801295:	50                   	push   %eax
  801296:	ff d2                	call   *%edx
  801298:	83 c4 10             	add    $0x10,%esp
}
  80129b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012a0:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012a5:	8b 40 48             	mov    0x48(%eax),%eax
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	50                   	push   %eax
  8012ad:	68 ac 26 80 00       	push   $0x8026ac
  8012b2:	e8 8c ee ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  8012b7:	83 c4 10             	add    $0x10,%esp
  8012ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bf:	eb da                	jmp    80129b <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c6:	eb d3                	jmp    80129b <ftruncate+0x52>

008012c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	53                   	push   %ebx
  8012cc:	83 ec 14             	sub    $0x14,%esp
  8012cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d5:	50                   	push   %eax
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 81 fb ff ff       	call   800e5f <fd_lookup>
  8012de:	83 c4 08             	add    $0x8,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	78 4b                	js     801330 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ef:	ff 30                	pushl  (%eax)
  8012f1:	e8 bf fb ff ff       	call   800eb5 <dev_lookup>
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	78 33                	js     801330 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801300:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801304:	74 2f                	je     801335 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801306:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801309:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801310:	00 00 00 
	stat->st_isdir = 0;
  801313:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80131a:	00 00 00 
	stat->st_dev = dev;
  80131d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	53                   	push   %ebx
  801327:	ff 75 f0             	pushl  -0x10(%ebp)
  80132a:	ff 50 14             	call   *0x14(%eax)
  80132d:	83 c4 10             	add    $0x10,%esp
}
  801330:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801333:	c9                   	leave  
  801334:	c3                   	ret    
		return -E_NOT_SUPP;
  801335:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133a:	eb f4                	jmp    801330 <fstat+0x68>

0080133c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	56                   	push   %esi
  801340:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	6a 00                	push   $0x0
  801346:	ff 75 08             	pushl  0x8(%ebp)
  801349:	e8 26 02 00 00       	call   801574 <open>
  80134e:	89 c3                	mov    %eax,%ebx
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	78 1b                	js     801372 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801357:	83 ec 08             	sub    $0x8,%esp
  80135a:	ff 75 0c             	pushl  0xc(%ebp)
  80135d:	50                   	push   %eax
  80135e:	e8 65 ff ff ff       	call   8012c8 <fstat>
  801363:	89 c6                	mov    %eax,%esi
	close(fd);
  801365:	89 1c 24             	mov    %ebx,(%esp)
  801368:	e8 27 fc ff ff       	call   800f94 <close>
	return r;
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	89 f3                	mov    %esi,%ebx
}
  801372:	89 d8                	mov    %ebx,%eax
  801374:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801377:	5b                   	pop    %ebx
  801378:	5e                   	pop    %esi
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	89 c6                	mov    %eax,%esi
  801382:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801384:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80138b:	74 27                	je     8013b4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80138d:	6a 07                	push   $0x7
  80138f:	68 00 50 80 00       	push   $0x805000
  801394:	56                   	push   %esi
  801395:	ff 35 00 40 80 00    	pushl  0x804000
  80139b:	e8 57 0c 00 00       	call   801ff7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013a0:	83 c4 0c             	add    $0xc,%esp
  8013a3:	6a 00                	push   $0x0
  8013a5:	53                   	push   %ebx
  8013a6:	6a 00                	push   $0x0
  8013a8:	e8 e1 0b 00 00       	call   801f8e <ipc_recv>
}
  8013ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5e                   	pop    %esi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	6a 01                	push   $0x1
  8013b9:	e8 92 0c 00 00       	call   802050 <ipc_find_env>
  8013be:	a3 00 40 80 00       	mov    %eax,0x804000
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	eb c5                	jmp    80138d <fsipc+0x12>

008013c8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8013d4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8013eb:	e8 8b ff ff ff       	call   80137b <fsipc>
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <devfile_flush>:
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8013fe:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801403:	ba 00 00 00 00       	mov    $0x0,%edx
  801408:	b8 06 00 00 00       	mov    $0x6,%eax
  80140d:	e8 69 ff ff ff       	call   80137b <fsipc>
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <devfile_stat>:
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	53                   	push   %ebx
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8b 40 0c             	mov    0xc(%eax),%eax
  801424:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801429:	ba 00 00 00 00       	mov    $0x0,%edx
  80142e:	b8 05 00 00 00       	mov    $0x5,%eax
  801433:	e8 43 ff ff ff       	call   80137b <fsipc>
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 2c                	js     801468 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	68 00 50 80 00       	push   $0x805000
  801444:	53                   	push   %ebx
  801445:	e8 96 f3 ff ff       	call   8007e0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80144a:	a1 80 50 80 00       	mov    0x805080,%eax
  80144f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801455:	a1 84 50 80 00       	mov    0x805084,%eax
  80145a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <devfile_write>:
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	53                   	push   %ebx
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8b 40 0c             	mov    0xc(%eax),%eax
  80147d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801482:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801488:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80148e:	77 30                	ja     8014c0 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	53                   	push   %ebx
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	68 08 50 80 00       	push   $0x805008
  80149c:	e8 cd f4 ff ff       	call   80096e <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a6:	b8 04 00 00 00       	mov    $0x4,%eax
  8014ab:	e8 cb fe ff ff       	call   80137b <fsipc>
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 04                	js     8014bb <devfile_write+0x4e>
	assert(r <= n);
  8014b7:	39 d8                	cmp    %ebx,%eax
  8014b9:	77 1e                	ja     8014d9 <devfile_write+0x6c>
}
  8014bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  8014c0:	68 1c 27 80 00       	push   $0x80271c
  8014c5:	68 49 27 80 00       	push   $0x802749
  8014ca:	68 94 00 00 00       	push   $0x94
  8014cf:	68 5e 27 80 00       	push   $0x80275e
  8014d4:	e8 6f 0a 00 00       	call   801f48 <_panic>
	assert(r <= n);
  8014d9:	68 69 27 80 00       	push   $0x802769
  8014de:	68 49 27 80 00       	push   $0x802749
  8014e3:	68 98 00 00 00       	push   $0x98
  8014e8:	68 5e 27 80 00       	push   $0x80275e
  8014ed:	e8 56 0a 00 00       	call   801f48 <_panic>

008014f2 <devfile_read>:
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
  8014f7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801500:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801505:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80150b:	ba 00 00 00 00       	mov    $0x0,%edx
  801510:	b8 03 00 00 00       	mov    $0x3,%eax
  801515:	e8 61 fe ff ff       	call   80137b <fsipc>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 1f                	js     80153f <devfile_read+0x4d>
	assert(r <= n);
  801520:	39 f0                	cmp    %esi,%eax
  801522:	77 24                	ja     801548 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801524:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801529:	7f 33                	jg     80155e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	50                   	push   %eax
  80152f:	68 00 50 80 00       	push   $0x805000
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	e8 32 f4 ff ff       	call   80096e <memmove>
	return r;
  80153c:	83 c4 10             	add    $0x10,%esp
}
  80153f:	89 d8                	mov    %ebx,%eax
  801541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    
	assert(r <= n);
  801548:	68 69 27 80 00       	push   $0x802769
  80154d:	68 49 27 80 00       	push   $0x802749
  801552:	6a 7c                	push   $0x7c
  801554:	68 5e 27 80 00       	push   $0x80275e
  801559:	e8 ea 09 00 00       	call   801f48 <_panic>
	assert(r <= PGSIZE);
  80155e:	68 70 27 80 00       	push   $0x802770
  801563:	68 49 27 80 00       	push   $0x802749
  801568:	6a 7d                	push   $0x7d
  80156a:	68 5e 27 80 00       	push   $0x80275e
  80156f:	e8 d4 09 00 00       	call   801f48 <_panic>

00801574 <open>:
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	56                   	push   %esi
  801578:	53                   	push   %ebx
  801579:	83 ec 1c             	sub    $0x1c,%esp
  80157c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80157f:	56                   	push   %esi
  801580:	e8 24 f2 ff ff       	call   8007a9 <strlen>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80158d:	7f 6c                	jg     8015fb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80158f:	83 ec 0c             	sub    $0xc,%esp
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	e8 75 f8 ff ff       	call   800e10 <fd_alloc>
  80159b:	89 c3                	mov    %eax,%ebx
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 3c                	js     8015e0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	56                   	push   %esi
  8015a8:	68 00 50 80 00       	push   $0x805000
  8015ad:	e8 2e f2 ff ff       	call   8007e0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c2:	e8 b4 fd ff ff       	call   80137b <fsipc>
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 19                	js     8015e9 <open+0x75>
	return fd2num(fd);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d6:	e8 0e f8 ff ff       	call   800de9 <fd2num>
  8015db:	89 c3                	mov    %eax,%ebx
  8015dd:	83 c4 10             	add    $0x10,%esp
}
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    
		fd_close(fd, 0);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	6a 00                	push   $0x0
  8015ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f1:	e8 15 f9 ff ff       	call   800f0b <fd_close>
		return r;
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	eb e5                	jmp    8015e0 <open+0x6c>
		return -E_BAD_PATH;
  8015fb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801600:	eb de                	jmp    8015e0 <open+0x6c>

00801602 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	b8 08 00 00 00       	mov    $0x8,%eax
  801612:	e8 64 fd ff ff       	call   80137b <fsipc>
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801621:	83 ec 0c             	sub    $0xc,%esp
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	e8 cd f7 ff ff       	call   800df9 <fd2data>
  80162c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80162e:	83 c4 08             	add    $0x8,%esp
  801631:	68 7c 27 80 00       	push   $0x80277c
  801636:	53                   	push   %ebx
  801637:	e8 a4 f1 ff ff       	call   8007e0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80163c:	8b 46 04             	mov    0x4(%esi),%eax
  80163f:	2b 06                	sub    (%esi),%eax
  801641:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801647:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80164e:	00 00 00 
	stat->st_dev = &devpipe;
  801651:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801658:	30 80 00 
	return 0;
}
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801663:	5b                   	pop    %ebx
  801664:	5e                   	pop    %esi
  801665:	5d                   	pop    %ebp
  801666:	c3                   	ret    

00801667 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801671:	53                   	push   %ebx
  801672:	6a 00                	push   $0x0
  801674:	e8 e5 f5 ff ff       	call   800c5e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801679:	89 1c 24             	mov    %ebx,(%esp)
  80167c:	e8 78 f7 ff ff       	call   800df9 <fd2data>
  801681:	83 c4 08             	add    $0x8,%esp
  801684:	50                   	push   %eax
  801685:	6a 00                	push   $0x0
  801687:	e8 d2 f5 ff ff       	call   800c5e <sys_page_unmap>
}
  80168c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <_pipeisclosed>:
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	57                   	push   %edi
  801695:	56                   	push   %esi
  801696:	53                   	push   %ebx
  801697:	83 ec 1c             	sub    $0x1c,%esp
  80169a:	89 c7                	mov    %eax,%edi
  80169c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80169e:	a1 08 40 80 00       	mov    0x804008,%eax
  8016a3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016a6:	83 ec 0c             	sub    $0xc,%esp
  8016a9:	57                   	push   %edi
  8016aa:	e8 da 09 00 00       	call   802089 <pageref>
  8016af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016b2:	89 34 24             	mov    %esi,(%esp)
  8016b5:	e8 cf 09 00 00       	call   802089 <pageref>
		nn = thisenv->env_runs;
  8016ba:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016c0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	39 cb                	cmp    %ecx,%ebx
  8016c8:	74 1b                	je     8016e5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016cd:	75 cf                	jne    80169e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016cf:	8b 42 58             	mov    0x58(%edx),%eax
  8016d2:	6a 01                	push   $0x1
  8016d4:	50                   	push   %eax
  8016d5:	53                   	push   %ebx
  8016d6:	68 83 27 80 00       	push   $0x802783
  8016db:	e8 63 ea ff ff       	call   800143 <cprintf>
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	eb b9                	jmp    80169e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016e5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016e8:	0f 94 c0             	sete   %al
  8016eb:	0f b6 c0             	movzbl %al,%eax
}
  8016ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5f                   	pop    %edi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <devpipe_write>:
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	57                   	push   %edi
  8016fa:	56                   	push   %esi
  8016fb:	53                   	push   %ebx
  8016fc:	83 ec 28             	sub    $0x28,%esp
  8016ff:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801702:	56                   	push   %esi
  801703:	e8 f1 f6 ff ff       	call   800df9 <fd2data>
  801708:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80170a:	83 c4 10             	add    $0x10,%esp
  80170d:	bf 00 00 00 00       	mov    $0x0,%edi
  801712:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801715:	74 4f                	je     801766 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801717:	8b 43 04             	mov    0x4(%ebx),%eax
  80171a:	8b 0b                	mov    (%ebx),%ecx
  80171c:	8d 51 20             	lea    0x20(%ecx),%edx
  80171f:	39 d0                	cmp    %edx,%eax
  801721:	72 14                	jb     801737 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801723:	89 da                	mov    %ebx,%edx
  801725:	89 f0                	mov    %esi,%eax
  801727:	e8 65 ff ff ff       	call   801691 <_pipeisclosed>
  80172c:	85 c0                	test   %eax,%eax
  80172e:	75 3a                	jne    80176a <devpipe_write+0x74>
			sys_yield();
  801730:	e8 85 f4 ff ff       	call   800bba <sys_yield>
  801735:	eb e0                	jmp    801717 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801737:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80173e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801741:	89 c2                	mov    %eax,%edx
  801743:	c1 fa 1f             	sar    $0x1f,%edx
  801746:	89 d1                	mov    %edx,%ecx
  801748:	c1 e9 1b             	shr    $0x1b,%ecx
  80174b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80174e:	83 e2 1f             	and    $0x1f,%edx
  801751:	29 ca                	sub    %ecx,%edx
  801753:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801757:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80175b:	83 c0 01             	add    $0x1,%eax
  80175e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801761:	83 c7 01             	add    $0x1,%edi
  801764:	eb ac                	jmp    801712 <devpipe_write+0x1c>
	return i;
  801766:	89 f8                	mov    %edi,%eax
  801768:	eb 05                	jmp    80176f <devpipe_write+0x79>
				return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801772:	5b                   	pop    %ebx
  801773:	5e                   	pop    %esi
  801774:	5f                   	pop    %edi
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <devpipe_read>:
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	57                   	push   %edi
  80177b:	56                   	push   %esi
  80177c:	53                   	push   %ebx
  80177d:	83 ec 18             	sub    $0x18,%esp
  801780:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801783:	57                   	push   %edi
  801784:	e8 70 f6 ff ff       	call   800df9 <fd2data>
  801789:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	be 00 00 00 00       	mov    $0x0,%esi
  801793:	3b 75 10             	cmp    0x10(%ebp),%esi
  801796:	74 47                	je     8017df <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801798:	8b 03                	mov    (%ebx),%eax
  80179a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80179d:	75 22                	jne    8017c1 <devpipe_read+0x4a>
			if (i > 0)
  80179f:	85 f6                	test   %esi,%esi
  8017a1:	75 14                	jne    8017b7 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017a3:	89 da                	mov    %ebx,%edx
  8017a5:	89 f8                	mov    %edi,%eax
  8017a7:	e8 e5 fe ff ff       	call   801691 <_pipeisclosed>
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	75 33                	jne    8017e3 <devpipe_read+0x6c>
			sys_yield();
  8017b0:	e8 05 f4 ff ff       	call   800bba <sys_yield>
  8017b5:	eb e1                	jmp    801798 <devpipe_read+0x21>
				return i;
  8017b7:	89 f0                	mov    %esi,%eax
}
  8017b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017bc:	5b                   	pop    %ebx
  8017bd:	5e                   	pop    %esi
  8017be:	5f                   	pop    %edi
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017c1:	99                   	cltd   
  8017c2:	c1 ea 1b             	shr    $0x1b,%edx
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	83 e0 1f             	and    $0x1f,%eax
  8017ca:	29 d0                	sub    %edx,%eax
  8017cc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8017d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8017d7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8017da:	83 c6 01             	add    $0x1,%esi
  8017dd:	eb b4                	jmp    801793 <devpipe_read+0x1c>
	return i;
  8017df:	89 f0                	mov    %esi,%eax
  8017e1:	eb d6                	jmp    8017b9 <devpipe_read+0x42>
				return 0;
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	eb cf                	jmp    8017b9 <devpipe_read+0x42>

008017ea <pipe>:
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	56                   	push   %esi
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f5:	50                   	push   %eax
  8017f6:	e8 15 f6 ff ff       	call   800e10 <fd_alloc>
  8017fb:	89 c3                	mov    %eax,%ebx
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 5b                	js     80185f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	68 07 04 00 00       	push   $0x407
  80180c:	ff 75 f4             	pushl  -0xc(%ebp)
  80180f:	6a 00                	push   $0x0
  801811:	e8 c3 f3 ff ff       	call   800bd9 <sys_page_alloc>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 40                	js     80185f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801825:	50                   	push   %eax
  801826:	e8 e5 f5 ff ff       	call   800e10 <fd_alloc>
  80182b:	89 c3                	mov    %eax,%ebx
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	78 1b                	js     80184f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 07 04 00 00       	push   $0x407
  80183c:	ff 75 f0             	pushl  -0x10(%ebp)
  80183f:	6a 00                	push   $0x0
  801841:	e8 93 f3 ff ff       	call   800bd9 <sys_page_alloc>
  801846:	89 c3                	mov    %eax,%ebx
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	79 19                	jns    801868 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	ff 75 f4             	pushl  -0xc(%ebp)
  801855:	6a 00                	push   $0x0
  801857:	e8 02 f4 ff ff       	call   800c5e <sys_page_unmap>
  80185c:	83 c4 10             	add    $0x10,%esp
}
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    
	va = fd2data(fd0);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 f4             	pushl  -0xc(%ebp)
  80186e:	e8 86 f5 ff ff       	call   800df9 <fd2data>
  801873:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801875:	83 c4 0c             	add    $0xc,%esp
  801878:	68 07 04 00 00       	push   $0x407
  80187d:	50                   	push   %eax
  80187e:	6a 00                	push   $0x0
  801880:	e8 54 f3 ff ff       	call   800bd9 <sys_page_alloc>
  801885:	89 c3                	mov    %eax,%ebx
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	0f 88 8c 00 00 00    	js     80191e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	ff 75 f0             	pushl  -0x10(%ebp)
  801898:	e8 5c f5 ff ff       	call   800df9 <fd2data>
  80189d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018a4:	50                   	push   %eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	56                   	push   %esi
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 6d f3 ff ff       	call   800c1c <sys_page_map>
  8018af:	89 c3                	mov    %eax,%ebx
  8018b1:	83 c4 20             	add    $0x20,%esp
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 58                	js     801910 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8018b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018c1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018d6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018db:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e8:	e8 fc f4 ff ff       	call   800de9 <fd2num>
  8018ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018f2:	83 c4 04             	add    $0x4,%esp
  8018f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f8:	e8 ec f4 ff ff       	call   800de9 <fd2num>
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	bb 00 00 00 00       	mov    $0x0,%ebx
  80190b:	e9 4f ff ff ff       	jmp    80185f <pipe+0x75>
	sys_page_unmap(0, va);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	56                   	push   %esi
  801914:	6a 00                	push   $0x0
  801916:	e8 43 f3 ff ff       	call   800c5e <sys_page_unmap>
  80191b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	ff 75 f0             	pushl  -0x10(%ebp)
  801924:	6a 00                	push   $0x0
  801926:	e8 33 f3 ff ff       	call   800c5e <sys_page_unmap>
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	e9 1c ff ff ff       	jmp    80184f <pipe+0x65>

00801933 <pipeisclosed>:
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	e8 1a f5 ff ff       	call   800e5f <fd_lookup>
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 18                	js     801964 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	ff 75 f4             	pushl  -0xc(%ebp)
  801952:	e8 a2 f4 ff ff       	call   800df9 <fd2data>
	return _pipeisclosed(fd, p);
  801957:	89 c2                	mov    %eax,%edx
  801959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195c:	e8 30 fd ff ff       	call   801691 <_pipeisclosed>
  801961:	83 c4 10             	add    $0x10,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80196c:	68 9b 27 80 00       	push   $0x80279b
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	e8 67 ee ff ff       	call   8007e0 <strcpy>
	return 0;
}
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <devsock_close>:
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 10             	sub    $0x10,%esp
  801987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80198a:	53                   	push   %ebx
  80198b:	e8 f9 06 00 00       	call   802089 <pageref>
  801990:	83 c4 10             	add    $0x10,%esp
		return 0;
  801993:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801998:	83 f8 01             	cmp    $0x1,%eax
  80199b:	74 07                	je     8019a4 <devsock_close+0x24>
}
  80199d:	89 d0                	mov    %edx,%eax
  80199f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	ff 73 0c             	pushl  0xc(%ebx)
  8019aa:	e8 b7 02 00 00       	call   801c66 <nsipc_close>
  8019af:	89 c2                	mov    %eax,%edx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	eb e7                	jmp    80199d <devsock_close+0x1d>

008019b6 <devsock_write>:
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	ff 70 0c             	pushl  0xc(%eax)
  8019ca:	e8 74 03 00 00       	call   801d43 <nsipc_send>
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <devsock_read>:
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 10             	pushl  0x10(%ebp)
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	ff 70 0c             	pushl  0xc(%eax)
  8019e5:	e8 ed 02 00 00       	call   801cd7 <nsipc_recv>
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <fd2sockid>:
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019f5:	52                   	push   %edx
  8019f6:	50                   	push   %eax
  8019f7:	e8 63 f4 ff ff       	call   800e5f <fd_lookup>
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 10                	js     801a13 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a06:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801a0c:	39 08                	cmp    %ecx,(%eax)
  801a0e:	75 05                	jne    801a15 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a10:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    
		return -E_NOT_SUPP;
  801a15:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a1a:	eb f7                	jmp    801a13 <fd2sockid+0x27>

00801a1c <alloc_sockfd>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	56                   	push   %esi
  801a20:	53                   	push   %ebx
  801a21:	83 ec 1c             	sub    $0x1c,%esp
  801a24:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a29:	50                   	push   %eax
  801a2a:	e8 e1 f3 ff ff       	call   800e10 <fd_alloc>
  801a2f:	89 c3                	mov    %eax,%ebx
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 43                	js     801a7b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	68 07 04 00 00       	push   $0x407
  801a40:	ff 75 f4             	pushl  -0xc(%ebp)
  801a43:	6a 00                	push   $0x0
  801a45:	e8 8f f1 ff ff       	call   800bd9 <sys_page_alloc>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	83 c4 10             	add    $0x10,%esp
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 28                	js     801a7b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a56:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a68:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	50                   	push   %eax
  801a6f:	e8 75 f3 ff ff       	call   800de9 <fd2num>
  801a74:	89 c3                	mov    %eax,%ebx
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	eb 0c                	jmp    801a87 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	56                   	push   %esi
  801a7f:	e8 e2 01 00 00       	call   801c66 <nsipc_close>
		return r;
  801a84:	83 c4 10             	add    $0x10,%esp
}
  801a87:	89 d8                	mov    %ebx,%eax
  801a89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    

00801a90 <accept>:
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	e8 4e ff ff ff       	call   8019ec <fd2sockid>
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 1b                	js     801abd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	ff 75 10             	pushl  0x10(%ebp)
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	50                   	push   %eax
  801aac:	e8 0e 01 00 00       	call   801bbf <nsipc_accept>
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	78 05                	js     801abd <accept+0x2d>
	return alloc_sockfd(r);
  801ab8:	e8 5f ff ff ff       	call   801a1c <alloc_sockfd>
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <bind>:
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	e8 1f ff ff ff       	call   8019ec <fd2sockid>
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 12                	js     801ae3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	ff 75 10             	pushl  0x10(%ebp)
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	e8 2f 01 00 00       	call   801c0f <nsipc_bind>
  801ae0:	83 c4 10             	add    $0x10,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <shutdown>:
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	e8 f9 fe ff ff       	call   8019ec <fd2sockid>
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 0f                	js     801b06 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801af7:	83 ec 08             	sub    $0x8,%esp
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	50                   	push   %eax
  801afe:	e8 41 01 00 00       	call   801c44 <nsipc_shutdown>
  801b03:	83 c4 10             	add    $0x10,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <connect>:
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	e8 d6 fe ff ff       	call   8019ec <fd2sockid>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 12                	js     801b2c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	50                   	push   %eax
  801b24:	e8 57 01 00 00       	call   801c80 <nsipc_connect>
  801b29:	83 c4 10             	add    $0x10,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <listen>:
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	e8 b0 fe ff ff       	call   8019ec <fd2sockid>
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 0f                	js     801b4f <listen+0x21>
	return nsipc_listen(r, backlog);
  801b40:	83 ec 08             	sub    $0x8,%esp
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	50                   	push   %eax
  801b47:	e8 69 01 00 00       	call   801cb5 <nsipc_listen>
  801b4c:	83 c4 10             	add    $0x10,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b57:	ff 75 10             	pushl  0x10(%ebp)
  801b5a:	ff 75 0c             	pushl  0xc(%ebp)
  801b5d:	ff 75 08             	pushl  0x8(%ebp)
  801b60:	e8 3c 02 00 00       	call   801da1 <nsipc_socket>
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 05                	js     801b71 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b6c:	e8 ab fe ff ff       	call   801a1c <alloc_sockfd>
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	53                   	push   %ebx
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b7c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b83:	74 26                	je     801bab <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b85:	6a 07                	push   $0x7
  801b87:	68 00 60 80 00       	push   $0x806000
  801b8c:	53                   	push   %ebx
  801b8d:	ff 35 04 40 80 00    	pushl  0x804004
  801b93:	e8 5f 04 00 00       	call   801ff7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b98:	83 c4 0c             	add    $0xc,%esp
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	e8 e8 03 00 00       	call   801f8e <ipc_recv>
}
  801ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bab:	83 ec 0c             	sub    $0xc,%esp
  801bae:	6a 02                	push   $0x2
  801bb0:	e8 9b 04 00 00       	call   802050 <ipc_find_env>
  801bb5:	a3 04 40 80 00       	mov    %eax,0x804004
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	eb c6                	jmp    801b85 <nsipc+0x12>

00801bbf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bcf:	8b 06                	mov    (%esi),%eax
  801bd1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	e8 93 ff ff ff       	call   801b73 <nsipc>
  801be0:	89 c3                	mov    %eax,%ebx
  801be2:	85 c0                	test   %eax,%eax
  801be4:	78 20                	js     801c06 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	ff 35 10 60 80 00    	pushl  0x806010
  801bef:	68 00 60 80 00       	push   $0x806000
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	e8 72 ed ff ff       	call   80096e <memmove>
		*addrlen = ret->ret_addrlen;
  801bfc:	a1 10 60 80 00       	mov    0x806010,%eax
  801c01:	89 06                	mov    %eax,(%esi)
  801c03:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c06:	89 d8                	mov    %ebx,%eax
  801c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    

00801c0f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	53                   	push   %ebx
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c21:	53                   	push   %ebx
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	68 04 60 80 00       	push   $0x806004
  801c2a:	e8 3f ed ff ff       	call   80096e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c2f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c35:	b8 02 00 00 00       	mov    $0x2,%eax
  801c3a:	e8 34 ff ff ff       	call   801b73 <nsipc>
}
  801c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5f:	e8 0f ff ff ff       	call   801b73 <nsipc>
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <nsipc_close>:

int
nsipc_close(int s)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c74:	b8 04 00 00 00       	mov    $0x4,%eax
  801c79:	e8 f5 fe ff ff       	call   801b73 <nsipc>
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	53                   	push   %ebx
  801c84:	83 ec 08             	sub    $0x8,%esp
  801c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c92:	53                   	push   %ebx
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	68 04 60 80 00       	push   $0x806004
  801c9b:	e8 ce ec ff ff       	call   80096e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ca0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ca6:	b8 05 00 00 00       	mov    $0x5,%eax
  801cab:	e8 c3 fe ff ff       	call   801b73 <nsipc>
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ccb:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd0:	e8 9e fe ff ff       	call   801b73 <nsipc>
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ce7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cf5:	b8 07 00 00 00       	mov    $0x7,%eax
  801cfa:	e8 74 fe ff ff       	call   801b73 <nsipc>
  801cff:	89 c3                	mov    %eax,%ebx
  801d01:	85 c0                	test   %eax,%eax
  801d03:	78 1f                	js     801d24 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d05:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d0a:	7f 21                	jg     801d2d <nsipc_recv+0x56>
  801d0c:	39 c6                	cmp    %eax,%esi
  801d0e:	7c 1d                	jl     801d2d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d10:	83 ec 04             	sub    $0x4,%esp
  801d13:	50                   	push   %eax
  801d14:	68 00 60 80 00       	push   $0x806000
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	e8 4d ec ff ff       	call   80096e <memmove>
  801d21:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d24:	89 d8                	mov    %ebx,%eax
  801d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d29:	5b                   	pop    %ebx
  801d2a:	5e                   	pop    %esi
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d2d:	68 a7 27 80 00       	push   $0x8027a7
  801d32:	68 49 27 80 00       	push   $0x802749
  801d37:	6a 62                	push   $0x62
  801d39:	68 bc 27 80 00       	push   $0x8027bc
  801d3e:	e8 05 02 00 00       	call   801f48 <_panic>

00801d43 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	53                   	push   %ebx
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d55:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d5b:	7f 2e                	jg     801d8b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	53                   	push   %ebx
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	68 0c 60 80 00       	push   $0x80600c
  801d69:	e8 00 ec ff ff       	call   80096e <memmove>
	nsipcbuf.send.req_size = size;
  801d6e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d74:	8b 45 14             	mov    0x14(%ebp),%eax
  801d77:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d7c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d81:	e8 ed fd ff ff       	call   801b73 <nsipc>
}
  801d86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    
	assert(size < 1600);
  801d8b:	68 c8 27 80 00       	push   $0x8027c8
  801d90:	68 49 27 80 00       	push   $0x802749
  801d95:	6a 6d                	push   $0x6d
  801d97:	68 bc 27 80 00       	push   $0x8027bc
  801d9c:	e8 a7 01 00 00       	call   801f48 <_panic>

00801da1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801db7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dba:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dbf:	b8 09 00 00 00       	mov    $0x9,%eax
  801dc4:	e8 aa fd ff ff       	call   801b73 <nsipc>
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    

00801dd5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ddb:	68 d4 27 80 00       	push   $0x8027d4
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	e8 f8 e9 ff ff       	call   8007e0 <strcpy>
	return 0;
}
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <devcons_write>:
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	57                   	push   %edi
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801dfb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e00:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e06:	eb 2f                	jmp    801e37 <devcons_write+0x48>
		m = n - tot;
  801e08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e0b:	29 f3                	sub    %esi,%ebx
  801e0d:	83 fb 7f             	cmp    $0x7f,%ebx
  801e10:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e15:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	53                   	push   %ebx
  801e1c:	89 f0                	mov    %esi,%eax
  801e1e:	03 45 0c             	add    0xc(%ebp),%eax
  801e21:	50                   	push   %eax
  801e22:	57                   	push   %edi
  801e23:	e8 46 eb ff ff       	call   80096e <memmove>
		sys_cputs(buf, m);
  801e28:	83 c4 08             	add    $0x8,%esp
  801e2b:	53                   	push   %ebx
  801e2c:	57                   	push   %edi
  801e2d:	e8 eb ec ff ff       	call   800b1d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e32:	01 de                	add    %ebx,%esi
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e3a:	72 cc                	jb     801e08 <devcons_write+0x19>
}
  801e3c:	89 f0                	mov    %esi,%eax
  801e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5f                   	pop    %edi
  801e44:	5d                   	pop    %ebp
  801e45:	c3                   	ret    

00801e46 <devcons_read>:
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e55:	75 07                	jne    801e5e <devcons_read+0x18>
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    
		sys_yield();
  801e59:	e8 5c ed ff ff       	call   800bba <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e5e:	e8 d8 ec ff ff       	call   800b3b <sys_cgetc>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 f2                	je     801e59 <devcons_read+0x13>
	if (c < 0)
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 ec                	js     801e57 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e6b:	83 f8 04             	cmp    $0x4,%eax
  801e6e:	74 0c                	je     801e7c <devcons_read+0x36>
	*(char*)vbuf = c;
  801e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e73:	88 02                	mov    %al,(%edx)
	return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb db                	jmp    801e57 <devcons_read+0x11>
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e81:	eb d4                	jmp    801e57 <devcons_read+0x11>

00801e83 <cputchar>:
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e8f:	6a 01                	push   $0x1
  801e91:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e94:	50                   	push   %eax
  801e95:	e8 83 ec ff ff       	call   800b1d <sys_cputs>
}
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <getchar>:
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ea5:	6a 01                	push   $0x1
  801ea7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eaa:	50                   	push   %eax
  801eab:	6a 00                	push   $0x0
  801ead:	e8 1e f2 ff ff       	call   8010d0 <read>
	if (r < 0)
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 08                	js     801ec1 <getchar+0x22>
	if (r < 1)
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	7e 06                	jle    801ec3 <getchar+0x24>
	return c;
  801ebd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    
		return -E_EOF;
  801ec3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ec8:	eb f7                	jmp    801ec1 <getchar+0x22>

00801eca <iscons>:
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed3:	50                   	push   %eax
  801ed4:	ff 75 08             	pushl  0x8(%ebp)
  801ed7:	e8 83 ef ff ff       	call   800e5f <fd_lookup>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 11                	js     801ef4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801eec:	39 10                	cmp    %edx,(%eax)
  801eee:	0f 94 c0             	sete   %al
  801ef1:	0f b6 c0             	movzbl %al,%eax
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <opencons>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eff:	50                   	push   %eax
  801f00:	e8 0b ef ff ff       	call   800e10 <fd_alloc>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 3a                	js     801f46 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	68 07 04 00 00       	push   $0x407
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	6a 00                	push   $0x0
  801f19:	e8 bb ec ff ff       	call   800bd9 <sys_page_alloc>
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 21                	js     801f46 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f2e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	50                   	push   %eax
  801f3e:	e8 a6 ee ff ff       	call   800de9 <fd2num>
  801f43:	83 c4 10             	add    $0x10,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	56                   	push   %esi
  801f4c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f4d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f50:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f56:	e8 40 ec ff ff       	call   800b9b <sys_getenvid>
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	ff 75 08             	pushl  0x8(%ebp)
  801f64:	56                   	push   %esi
  801f65:	50                   	push   %eax
  801f66:	68 e0 27 80 00       	push   $0x8027e0
  801f6b:	e8 d3 e1 ff ff       	call   800143 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f70:	83 c4 18             	add    $0x18,%esp
  801f73:	53                   	push   %ebx
  801f74:	ff 75 10             	pushl  0x10(%ebp)
  801f77:	e8 76 e1 ff ff       	call   8000f2 <vcprintf>
	cprintf("\n");
  801f7c:	c7 04 24 94 27 80 00 	movl   $0x802794,(%esp)
  801f83:	e8 bb e1 ff ff       	call   800143 <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f8b:	cc                   	int3   
  801f8c:	eb fd                	jmp    801f8b <_panic+0x43>

00801f8e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	56                   	push   %esi
  801f92:	53                   	push   %ebx
  801f93:	8b 75 08             	mov    0x8(%ebp),%esi
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  801f9c:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  801f9e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fa3:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	50                   	push   %eax
  801faa:	e8 da ed ff ff       	call   800d89 <sys_ipc_recv>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 2b                	js     801fe1 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  801fb6:	85 f6                	test   %esi,%esi
  801fb8:	74 0a                	je     801fc4 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  801fba:	a1 08 40 80 00       	mov    0x804008,%eax
  801fbf:	8b 40 74             	mov    0x74(%eax),%eax
  801fc2:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  801fc4:	85 db                	test   %ebx,%ebx
  801fc6:	74 0a                	je     801fd2 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  801fc8:	a1 08 40 80 00       	mov    0x804008,%eax
  801fcd:	8b 40 78             	mov    0x78(%eax),%eax
  801fd0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801fd2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    
	    if (from_env_store != NULL) {
  801fe1:	85 f6                	test   %esi,%esi
  801fe3:	74 06                	je     801feb <ipc_recv+0x5d>
	        *from_env_store = 0;
  801fe5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  801feb:	85 db                	test   %ebx,%ebx
  801fed:	74 eb                	je     801fda <ipc_recv+0x4c>
	        *perm_store = 0;
  801fef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ff5:	eb e3                	jmp    801fda <ipc_recv+0x4c>

00801ff7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	57                   	push   %edi
  801ffb:	56                   	push   %esi
  801ffc:	53                   	push   %ebx
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	8b 7d 08             	mov    0x8(%ebp),%edi
  802003:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  802006:	85 f6                	test   %esi,%esi
  802008:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80200d:	0f 44 f0             	cmove  %eax,%esi
  802010:	eb 09                	jmp    80201b <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  802012:	e8 a3 eb ff ff       	call   800bba <sys_yield>
	} while(r != 0);
  802017:	85 db                	test   %ebx,%ebx
  802019:	74 2d                	je     802048 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  80201b:	ff 75 14             	pushl  0x14(%ebp)
  80201e:	56                   	push   %esi
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	57                   	push   %edi
  802023:	e8 3e ed ff ff       	call   800d66 <sys_ipc_try_send>
  802028:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	79 e1                	jns    802012 <ipc_send+0x1b>
  802031:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802034:	74 dc                	je     802012 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802036:	50                   	push   %eax
  802037:	68 04 28 80 00       	push   $0x802804
  80203c:	6a 45                	push   $0x45
  80203e:	68 11 28 80 00       	push   $0x802811
  802043:	e8 00 ff ff ff       	call   801f48 <_panic>
}
  802048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80205b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80205e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802064:	8b 52 50             	mov    0x50(%edx),%edx
  802067:	39 ca                	cmp    %ecx,%edx
  802069:	74 11                	je     80207c <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80206b:	83 c0 01             	add    $0x1,%eax
  80206e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802073:	75 e6                	jne    80205b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	eb 0b                	jmp    802087 <ipc_find_env+0x37>
			return envs[i].env_id;
  80207c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80207f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802084:	8b 40 48             	mov    0x48(%eax),%eax
}
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80208f:	89 d0                	mov    %edx,%eax
  802091:	c1 e8 16             	shr    $0x16,%eax
  802094:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020a0:	f6 c1 01             	test   $0x1,%cl
  8020a3:	74 1d                	je     8020c2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020a5:	c1 ea 0c             	shr    $0xc,%edx
  8020a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020af:	f6 c2 01             	test   $0x1,%dl
  8020b2:	74 0e                	je     8020c2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b4:	c1 ea 0c             	shr    $0xc,%edx
  8020b7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020be:	ef 
  8020bf:	0f b7 c0             	movzwl %ax,%eax
}
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    
  8020c4:	66 90                	xchg   %ax,%ax
  8020c6:	66 90                	xchg   %ax,%ax
  8020c8:	66 90                	xchg   %ax,%ax
  8020ca:	66 90                	xchg   %ax,%ax
  8020cc:	66 90                	xchg   %ax,%ax
  8020ce:	66 90                	xchg   %ax,%ax

008020d0 <__udivdi3>:
  8020d0:	55                   	push   %ebp
  8020d1:	57                   	push   %edi
  8020d2:	56                   	push   %esi
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 1c             	sub    $0x1c,%esp
  8020d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020e7:	85 d2                	test   %edx,%edx
  8020e9:	75 35                	jne    802120 <__udivdi3+0x50>
  8020eb:	39 f3                	cmp    %esi,%ebx
  8020ed:	0f 87 bd 00 00 00    	ja     8021b0 <__udivdi3+0xe0>
  8020f3:	85 db                	test   %ebx,%ebx
  8020f5:	89 d9                	mov    %ebx,%ecx
  8020f7:	75 0b                	jne    802104 <__udivdi3+0x34>
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	31 d2                	xor    %edx,%edx
  802100:	f7 f3                	div    %ebx
  802102:	89 c1                	mov    %eax,%ecx
  802104:	31 d2                	xor    %edx,%edx
  802106:	89 f0                	mov    %esi,%eax
  802108:	f7 f1                	div    %ecx
  80210a:	89 c6                	mov    %eax,%esi
  80210c:	89 e8                	mov    %ebp,%eax
  80210e:	89 f7                	mov    %esi,%edi
  802110:	f7 f1                	div    %ecx
  802112:	89 fa                	mov    %edi,%edx
  802114:	83 c4 1c             	add    $0x1c,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    
  80211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802120:	39 f2                	cmp    %esi,%edx
  802122:	77 7c                	ja     8021a0 <__udivdi3+0xd0>
  802124:	0f bd fa             	bsr    %edx,%edi
  802127:	83 f7 1f             	xor    $0x1f,%edi
  80212a:	0f 84 98 00 00 00    	je     8021c8 <__udivdi3+0xf8>
  802130:	89 f9                	mov    %edi,%ecx
  802132:	b8 20 00 00 00       	mov    $0x20,%eax
  802137:	29 f8                	sub    %edi,%eax
  802139:	d3 e2                	shl    %cl,%edx
  80213b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80213f:	89 c1                	mov    %eax,%ecx
  802141:	89 da                	mov    %ebx,%edx
  802143:	d3 ea                	shr    %cl,%edx
  802145:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802149:	09 d1                	or     %edx,%ecx
  80214b:	89 f2                	mov    %esi,%edx
  80214d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802151:	89 f9                	mov    %edi,%ecx
  802153:	d3 e3                	shl    %cl,%ebx
  802155:	89 c1                	mov    %eax,%ecx
  802157:	d3 ea                	shr    %cl,%edx
  802159:	89 f9                	mov    %edi,%ecx
  80215b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80215f:	d3 e6                	shl    %cl,%esi
  802161:	89 eb                	mov    %ebp,%ebx
  802163:	89 c1                	mov    %eax,%ecx
  802165:	d3 eb                	shr    %cl,%ebx
  802167:	09 de                	or     %ebx,%esi
  802169:	89 f0                	mov    %esi,%eax
  80216b:	f7 74 24 08          	divl   0x8(%esp)
  80216f:	89 d6                	mov    %edx,%esi
  802171:	89 c3                	mov    %eax,%ebx
  802173:	f7 64 24 0c          	mull   0xc(%esp)
  802177:	39 d6                	cmp    %edx,%esi
  802179:	72 0c                	jb     802187 <__udivdi3+0xb7>
  80217b:	89 f9                	mov    %edi,%ecx
  80217d:	d3 e5                	shl    %cl,%ebp
  80217f:	39 c5                	cmp    %eax,%ebp
  802181:	73 5d                	jae    8021e0 <__udivdi3+0x110>
  802183:	39 d6                	cmp    %edx,%esi
  802185:	75 59                	jne    8021e0 <__udivdi3+0x110>
  802187:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80218a:	31 ff                	xor    %edi,%edi
  80218c:	89 fa                	mov    %edi,%edx
  80218e:	83 c4 1c             	add    $0x1c,%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5f                   	pop    %edi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    
  802196:	8d 76 00             	lea    0x0(%esi),%esi
  802199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	31 c0                	xor    %eax,%eax
  8021a4:	89 fa                	mov    %edi,%edx
  8021a6:	83 c4 1c             	add    $0x1c,%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5f                   	pop    %edi
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	31 ff                	xor    %edi,%edi
  8021b2:	89 e8                	mov    %ebp,%eax
  8021b4:	89 f2                	mov    %esi,%edx
  8021b6:	f7 f3                	div    %ebx
  8021b8:	89 fa                	mov    %edi,%edx
  8021ba:	83 c4 1c             	add    $0x1c,%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
  8021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	72 06                	jb     8021d2 <__udivdi3+0x102>
  8021cc:	31 c0                	xor    %eax,%eax
  8021ce:	39 eb                	cmp    %ebp,%ebx
  8021d0:	77 d2                	ja     8021a4 <__udivdi3+0xd4>
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb cb                	jmp    8021a4 <__udivdi3+0xd4>
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	89 d8                	mov    %ebx,%eax
  8021e2:	31 ff                	xor    %edi,%edi
  8021e4:	eb be                	jmp    8021a4 <__udivdi3+0xd4>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	66 90                	xchg   %ax,%ax
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	55                   	push   %ebp
  8021f1:	57                   	push   %edi
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	83 ec 1c             	sub    $0x1c,%esp
  8021f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802203:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802207:	85 ed                	test   %ebp,%ebp
  802209:	89 f0                	mov    %esi,%eax
  80220b:	89 da                	mov    %ebx,%edx
  80220d:	75 19                	jne    802228 <__umoddi3+0x38>
  80220f:	39 df                	cmp    %ebx,%edi
  802211:	0f 86 b1 00 00 00    	jbe    8022c8 <__umoddi3+0xd8>
  802217:	f7 f7                	div    %edi
  802219:	89 d0                	mov    %edx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	39 dd                	cmp    %ebx,%ebp
  80222a:	77 f1                	ja     80221d <__umoddi3+0x2d>
  80222c:	0f bd cd             	bsr    %ebp,%ecx
  80222f:	83 f1 1f             	xor    $0x1f,%ecx
  802232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802236:	0f 84 b4 00 00 00    	je     8022f0 <__umoddi3+0x100>
  80223c:	b8 20 00 00 00       	mov    $0x20,%eax
  802241:	89 c2                	mov    %eax,%edx
  802243:	8b 44 24 04          	mov    0x4(%esp),%eax
  802247:	29 c2                	sub    %eax,%edx
  802249:	89 c1                	mov    %eax,%ecx
  80224b:	89 f8                	mov    %edi,%eax
  80224d:	d3 e5                	shl    %cl,%ebp
  80224f:	89 d1                	mov    %edx,%ecx
  802251:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802255:	d3 e8                	shr    %cl,%eax
  802257:	09 c5                	or     %eax,%ebp
  802259:	8b 44 24 04          	mov    0x4(%esp),%eax
  80225d:	89 c1                	mov    %eax,%ecx
  80225f:	d3 e7                	shl    %cl,%edi
  802261:	89 d1                	mov    %edx,%ecx
  802263:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802267:	89 df                	mov    %ebx,%edi
  802269:	d3 ef                	shr    %cl,%edi
  80226b:	89 c1                	mov    %eax,%ecx
  80226d:	89 f0                	mov    %esi,%eax
  80226f:	d3 e3                	shl    %cl,%ebx
  802271:	89 d1                	mov    %edx,%ecx
  802273:	89 fa                	mov    %edi,%edx
  802275:	d3 e8                	shr    %cl,%eax
  802277:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80227c:	09 d8                	or     %ebx,%eax
  80227e:	f7 f5                	div    %ebp
  802280:	d3 e6                	shl    %cl,%esi
  802282:	89 d1                	mov    %edx,%ecx
  802284:	f7 64 24 08          	mull   0x8(%esp)
  802288:	39 d1                	cmp    %edx,%ecx
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	89 d7                	mov    %edx,%edi
  80228e:	72 06                	jb     802296 <__umoddi3+0xa6>
  802290:	75 0e                	jne    8022a0 <__umoddi3+0xb0>
  802292:	39 c6                	cmp    %eax,%esi
  802294:	73 0a                	jae    8022a0 <__umoddi3+0xb0>
  802296:	2b 44 24 08          	sub    0x8(%esp),%eax
  80229a:	19 ea                	sbb    %ebp,%edx
  80229c:	89 d7                	mov    %edx,%edi
  80229e:	89 c3                	mov    %eax,%ebx
  8022a0:	89 ca                	mov    %ecx,%edx
  8022a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022a7:	29 de                	sub    %ebx,%esi
  8022a9:	19 fa                	sbb    %edi,%edx
  8022ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 d9                	mov    %ebx,%ecx
  8022b5:	d3 ee                	shr    %cl,%esi
  8022b7:	d3 ea                	shr    %cl,%edx
  8022b9:	09 f0                	or     %esi,%eax
  8022bb:	83 c4 1c             	add    $0x1c,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	90                   	nop
  8022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	85 ff                	test   %edi,%edi
  8022ca:	89 f9                	mov    %edi,%ecx
  8022cc:	75 0b                	jne    8022d9 <__umoddi3+0xe9>
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f7                	div    %edi
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f1                	div    %ecx
  8022df:	89 f0                	mov    %esi,%eax
  8022e1:	f7 f1                	div    %ecx
  8022e3:	e9 31 ff ff ff       	jmp    802219 <__umoddi3+0x29>
  8022e8:	90                   	nop
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	39 dd                	cmp    %ebx,%ebp
  8022f2:	72 08                	jb     8022fc <__umoddi3+0x10c>
  8022f4:	39 f7                	cmp    %esi,%edi
  8022f6:	0f 87 21 ff ff ff    	ja     80221d <__umoddi3+0x2d>
  8022fc:	89 da                	mov    %ebx,%edx
  8022fe:	89 f0                	mov    %esi,%eax
  802300:	29 f8                	sub    %edi,%eax
  802302:	19 ea                	sbb    %ebp,%edx
  802304:	e9 14 ff ff ff       	jmp    80221d <__umoddi3+0x2d>
