
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 e0 23 80 00       	push   $0x8023e0
  80004a:	e8 26 01 00 00       	call   800175 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 79 0b 00 00       	call   800bcd <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 30 0b 00 00       	call   800b8c <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 aa 0d 00 00       	call   800e1b <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
    thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 3d 0b 00 00       	call   800bcd <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	85 db                	test   %ebx,%ebx
  8000a4:	7e 07                	jle    8000ad <libmain+0x2d>
		binaryname = argv[0];
  8000a6:	8b 06                	mov    (%esi),%eax
  8000a8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
  8000b2:	e8 aa ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0a 00 00 00       	call   8000c6 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000cc:	e8 bf 0f 00 00       	call   801090 <close_all>
	sys_env_destroy(0);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	6a 00                	push   $0x0
  8000d6:	e8 b1 0a 00 00       	call   800b8c <sys_env_destroy>
}
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ea:	8b 13                	mov    (%ebx),%edx
  8000ec:	8d 42 01             	lea    0x1(%edx),%eax
  8000ef:	89 03                	mov    %eax,(%ebx)
  8000f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fd:	74 09                	je     800108 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800106:	c9                   	leave  
  800107:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800108:	83 ec 08             	sub    $0x8,%esp
  80010b:	68 ff 00 00 00       	push   $0xff
  800110:	8d 43 08             	lea    0x8(%ebx),%eax
  800113:	50                   	push   %eax
  800114:	e8 36 0a 00 00       	call   800b4f <sys_cputs>
		b->idx = 0;
  800119:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	eb db                	jmp    8000ff <putch+0x1f>

00800124 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800134:	00 00 00 
	b.cnt = 0;
  800137:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800141:	ff 75 0c             	pushl  0xc(%ebp)
  800144:	ff 75 08             	pushl  0x8(%ebp)
  800147:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014d:	50                   	push   %eax
  80014e:	68 e0 00 80 00       	push   $0x8000e0
  800153:	e8 1a 01 00 00       	call   800272 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800158:	83 c4 08             	add    $0x8,%esp
  80015b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800161:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	e8 e2 09 00 00       	call   800b4f <sys_cputs>

	return b.cnt;
}
  80016d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80017e:	50                   	push   %eax
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	e8 9d ff ff ff       	call   800124 <vcprintf>
	va_end(ap);

	return cnt;
}
  800187:	c9                   	leave  
  800188:	c3                   	ret    

00800189 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	57                   	push   %edi
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
  80018f:	83 ec 1c             	sub    $0x1c,%esp
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 d6                	mov    %edx,%esi
  800196:	8b 45 08             	mov    0x8(%ebp),%eax
  800199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b0:	39 d3                	cmp    %edx,%ebx
  8001b2:	72 05                	jb     8001b9 <printnum+0x30>
  8001b4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001b7:	77 7a                	ja     800233 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 18             	pushl  0x18(%ebp)
  8001bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001c5:	53                   	push   %ebx
  8001c6:	ff 75 10             	pushl  0x10(%ebp)
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d8:	e8 c3 1f 00 00       	call   8021a0 <__udivdi3>
  8001dd:	83 c4 18             	add    $0x18,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	89 f2                	mov    %esi,%edx
  8001e4:	89 f8                	mov    %edi,%eax
  8001e6:	e8 9e ff ff ff       	call   800189 <printnum>
  8001eb:	83 c4 20             	add    $0x20,%esp
  8001ee:	eb 13                	jmp    800203 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	56                   	push   %esi
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	ff d7                	call   *%edi
  8001f9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	85 db                	test   %ebx,%ebx
  800201:	7f ed                	jg     8001f0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	56                   	push   %esi
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020d:	ff 75 e0             	pushl  -0x20(%ebp)
  800210:	ff 75 dc             	pushl  -0x24(%ebp)
  800213:	ff 75 d8             	pushl  -0x28(%ebp)
  800216:	e8 a5 20 00 00       	call   8022c0 <__umoddi3>
  80021b:	83 c4 14             	add    $0x14,%esp
  80021e:	0f be 80 06 24 80 00 	movsbl 0x802406(%eax),%eax
  800225:	50                   	push   %eax
  800226:	ff d7                	call   *%edi
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5f                   	pop    %edi
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    
  800233:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800236:	eb c4                	jmp    8001fc <printnum+0x73>

00800238 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80023e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800242:	8b 10                	mov    (%eax),%edx
  800244:	3b 50 04             	cmp    0x4(%eax),%edx
  800247:	73 0a                	jae    800253 <sprintputch+0x1b>
		*b->buf++ = ch;
  800249:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024c:	89 08                	mov    %ecx,(%eax)
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	88 02                	mov    %al,(%edx)
}
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    

00800255 <printfmt>:
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80025e:	50                   	push   %eax
  80025f:	ff 75 10             	pushl  0x10(%ebp)
  800262:	ff 75 0c             	pushl  0xc(%ebp)
  800265:	ff 75 08             	pushl  0x8(%ebp)
  800268:	e8 05 00 00 00       	call   800272 <vprintfmt>
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <vprintfmt>:
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	57                   	push   %edi
  800276:	56                   	push   %esi
  800277:	53                   	push   %ebx
  800278:	83 ec 2c             	sub    $0x2c,%esp
  80027b:	8b 75 08             	mov    0x8(%ebp),%esi
  80027e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800281:	8b 7d 10             	mov    0x10(%ebp),%edi
  800284:	e9 21 04 00 00       	jmp    8006aa <vprintfmt+0x438>
		padc = ' ';
  800289:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80028d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800294:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80029b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a7:	8d 47 01             	lea    0x1(%edi),%eax
  8002aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ad:	0f b6 17             	movzbl (%edi),%edx
  8002b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b3:	3c 55                	cmp    $0x55,%al
  8002b5:	0f 87 90 04 00 00    	ja     80074b <vprintfmt+0x4d9>
  8002bb:	0f b6 c0             	movzbl %al,%eax
  8002be:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  8002c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002cc:	eb d9                	jmp    8002a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002d1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002d5:	eb d0                	jmp    8002a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d7:	0f b6 d2             	movzbl %dl,%edx
  8002da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ec:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ef:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f2:	83 f9 09             	cmp    $0x9,%ecx
  8002f5:	77 55                	ja     80034c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002f7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fa:	eb e9                	jmp    8002e5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800304:	8b 45 14             	mov    0x14(%ebp),%eax
  800307:	8d 40 04             	lea    0x4(%eax),%eax
  80030a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800310:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800314:	79 91                	jns    8002a7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800316:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800319:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800323:	eb 82                	jmp    8002a7 <vprintfmt+0x35>
  800325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	ba 00 00 00 00       	mov    $0x0,%edx
  80032f:	0f 49 d0             	cmovns %eax,%edx
  800332:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800338:	e9 6a ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800340:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800347:	e9 5b ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
  80034c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800352:	eb bc                	jmp    800310 <vprintfmt+0x9e>
			lflag++;
  800354:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035a:	e9 48 ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 78 04             	lea    0x4(%eax),%edi
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	53                   	push   %ebx
  800369:	ff 30                	pushl  (%eax)
  80036b:	ff d6                	call   *%esi
			break;
  80036d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800370:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800373:	e9 2f 03 00 00       	jmp    8006a7 <vprintfmt+0x435>
			err = va_arg(ap, int);
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8d 78 04             	lea    0x4(%eax),%edi
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	99                   	cltd   
  800381:	31 d0                	xor    %edx,%eax
  800383:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800385:	83 f8 0f             	cmp    $0xf,%eax
  800388:	7f 23                	jg     8003ad <vprintfmt+0x13b>
  80038a:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  800391:	85 d2                	test   %edx,%edx
  800393:	74 18                	je     8003ad <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800395:	52                   	push   %edx
  800396:	68 1f 28 80 00       	push   $0x80281f
  80039b:	53                   	push   %ebx
  80039c:	56                   	push   %esi
  80039d:	e8 b3 fe ff ff       	call   800255 <printfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a8:	e9 fa 02 00 00       	jmp    8006a7 <vprintfmt+0x435>
				printfmt(putch, putdat, "error %d", err);
  8003ad:	50                   	push   %eax
  8003ae:	68 1e 24 80 00       	push   $0x80241e
  8003b3:	53                   	push   %ebx
  8003b4:	56                   	push   %esi
  8003b5:	e8 9b fe ff ff       	call   800255 <printfmt>
  8003ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c0:	e9 e2 02 00 00       	jmp    8006a7 <vprintfmt+0x435>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	83 c0 04             	add    $0x4,%eax
  8003cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003d3:	85 ff                	test   %edi,%edi
  8003d5:	b8 17 24 80 00       	mov    $0x802417,%eax
  8003da:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e1:	0f 8e bd 00 00 00    	jle    8004a4 <vprintfmt+0x232>
  8003e7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003eb:	75 0e                	jne    8003fb <vprintfmt+0x189>
  8003ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003f9:	eb 6d                	jmp    800468 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	ff 75 d0             	pushl  -0x30(%ebp)
  800401:	57                   	push   %edi
  800402:	e8 ec 03 00 00       	call   8007f3 <strnlen>
  800407:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040a:	29 c1                	sub    %eax,%ecx
  80040c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80040f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800412:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800416:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800419:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80041c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80041e:	eb 0f                	jmp    80042f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	53                   	push   %ebx
  800424:	ff 75 e0             	pushl  -0x20(%ebp)
  800427:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	83 ef 01             	sub    $0x1,%edi
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	85 ff                	test   %edi,%edi
  800431:	7f ed                	jg     800420 <vprintfmt+0x1ae>
  800433:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800436:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800439:	85 c9                	test   %ecx,%ecx
  80043b:	b8 00 00 00 00       	mov    $0x0,%eax
  800440:	0f 49 c1             	cmovns %ecx,%eax
  800443:	29 c1                	sub    %eax,%ecx
  800445:	89 75 08             	mov    %esi,0x8(%ebp)
  800448:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80044b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80044e:	89 cb                	mov    %ecx,%ebx
  800450:	eb 16                	jmp    800468 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800452:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800456:	75 31                	jne    800489 <vprintfmt+0x217>
					putch(ch, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 0c             	pushl  0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	ff 55 08             	call   *0x8(%ebp)
  800462:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800465:	83 eb 01             	sub    $0x1,%ebx
  800468:	83 c7 01             	add    $0x1,%edi
  80046b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80046f:	0f be c2             	movsbl %dl,%eax
  800472:	85 c0                	test   %eax,%eax
  800474:	74 59                	je     8004cf <vprintfmt+0x25d>
  800476:	85 f6                	test   %esi,%esi
  800478:	78 d8                	js     800452 <vprintfmt+0x1e0>
  80047a:	83 ee 01             	sub    $0x1,%esi
  80047d:	79 d3                	jns    800452 <vprintfmt+0x1e0>
  80047f:	89 df                	mov    %ebx,%edi
  800481:	8b 75 08             	mov    0x8(%ebp),%esi
  800484:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800487:	eb 37                	jmp    8004c0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800489:	0f be d2             	movsbl %dl,%edx
  80048c:	83 ea 20             	sub    $0x20,%edx
  80048f:	83 fa 5e             	cmp    $0x5e,%edx
  800492:	76 c4                	jbe    800458 <vprintfmt+0x1e6>
					putch('?', putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	6a 3f                	push   $0x3f
  80049c:	ff 55 08             	call   *0x8(%ebp)
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	eb c1                	jmp    800465 <vprintfmt+0x1f3>
  8004a4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004aa:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b0:	eb b6                	jmp    800468 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 d8 01 00 00       	jmp    8006a7 <vprintfmt+0x435>
  8004cf:	89 df                	mov    %ebx,%edi
  8004d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d7:	eb e7                	jmp    8004c0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004d9:	83 f9 01             	cmp    $0x1,%ecx
  8004dc:	7e 45                	jle    800523 <vprintfmt+0x2b1>
		return va_arg(*ap, long long);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 08             	lea    0x8(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004f9:	79 62                	jns    80055d <vprintfmt+0x2eb>
				putch('-', putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	6a 2d                	push   $0x2d
  800501:	ff d6                	call   *%esi
				num = -(long long) num;
  800503:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800506:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800509:	f7 d8                	neg    %eax
  80050b:	83 d2 00             	adc    $0x0,%edx
  80050e:	f7 da                	neg    %edx
  800510:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800513:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800516:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800519:	ba 0a 00 00 00       	mov    $0xa,%edx
  80051e:	e9 66 01 00 00       	jmp    800689 <vprintfmt+0x417>
	else if (lflag)
  800523:	85 c9                	test   %ecx,%ecx
  800525:	75 1b                	jne    800542 <vprintfmt+0x2d0>
		return va_arg(*ap, int);
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052f:	89 c1                	mov    %eax,%ecx
  800531:	c1 f9 1f             	sar    $0x1f,%ecx
  800534:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800537:	8b 45 14             	mov    0x14(%ebp),%eax
  80053a:	8d 40 04             	lea    0x4(%eax),%eax
  80053d:	89 45 14             	mov    %eax,0x14(%ebp)
  800540:	eb b3                	jmp    8004f5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054a:	89 c1                	mov    %eax,%ecx
  80054c:	c1 f9 1f             	sar    $0x1f,%ecx
  80054f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	eb 98                	jmp    8004f5 <vprintfmt+0x283>
			base = 10;
  80055d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800562:	e9 22 01 00 00       	jmp    800689 <vprintfmt+0x417>
	if (lflag >= 2)
  800567:	83 f9 01             	cmp    $0x1,%ecx
  80056a:	7e 21                	jle    80058d <vprintfmt+0x31b>
		return va_arg(*ap, unsigned long long);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8b 50 04             	mov    0x4(%eax),%edx
  800572:	8b 00                	mov    (%eax),%eax
  800574:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800577:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8d 40 08             	lea    0x8(%eax),%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800583:	ba 0a 00 00 00       	mov    $0xa,%edx
  800588:	e9 fc 00 00 00       	jmp    800689 <vprintfmt+0x417>
	else if (lflag)
  80058d:	85 c9                	test   %ecx,%ecx
  80058f:	75 23                	jne    8005b4 <vprintfmt+0x342>
		return va_arg(*ap, unsigned int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	ba 00 00 00 00       	mov    $0x0,%edx
  80059b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005aa:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005af:	e9 d5 00 00 00       	jmp    800689 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8005d2:	e9 b2 00 00 00       	jmp    800689 <vprintfmt+0x417>
	if (lflag >= 2)
  8005d7:	83 f9 01             	cmp    $0x1,%ecx
  8005da:	7e 42                	jle    80061e <vprintfmt+0x3ac>
		return va_arg(*ap, unsigned long long);
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8b 50 04             	mov    0x4(%eax),%edx
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8d 40 08             	lea    0x8(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f3:	ba 08 00 00 00       	mov    $0x8,%edx
			if ((long long) num < 0) {
  8005f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005fc:	0f 89 87 00 00 00    	jns    800689 <vprintfmt+0x417>
				putch('-', putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	6a 2d                	push   $0x2d
  800608:	ff d6                	call   *%esi
				num = -(long long) num;
  80060a:	f7 5d d8             	negl   -0x28(%ebp)
  80060d:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
  800611:	f7 5d dc             	negl   -0x24(%ebp)
  800614:	83 c4 10             	add    $0x10,%esp
			base = 8;
  800617:	ba 08 00 00 00       	mov    $0x8,%edx
  80061c:	eb 6b                	jmp    800689 <vprintfmt+0x417>
	else if (lflag)
  80061e:	85 c9                	test   %ecx,%ecx
  800620:	75 1b                	jne    80063d <vprintfmt+0x3cb>
		return va_arg(*ap, unsigned int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
  80063b:	eb b6                	jmp    8005f3 <vprintfmt+0x381>
		return va_arg(*ap, unsigned long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
  800656:	eb 9b                	jmp    8005f3 <vprintfmt+0x381>
			putch('0', putdat);
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	53                   	push   %ebx
  80065c:	6a 30                	push   $0x30
  80065e:	ff d6                	call   *%esi
			putch('x', putdat);
  800660:	83 c4 08             	add    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 78                	push   $0x78
  800666:	ff d6                	call   *%esi
			num = (unsigned long long)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	ba 00 00 00 00       	mov    $0x0,%edx
  800672:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800678:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800684:	ba 10 00 00 00       	mov    $0x10,%edx
			printnum(putch, putdat, num, base, width, padc);
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800690:	50                   	push   %eax
  800691:	ff 75 e0             	pushl  -0x20(%ebp)
  800694:	52                   	push   %edx
  800695:	ff 75 dc             	pushl  -0x24(%ebp)
  800698:	ff 75 d8             	pushl  -0x28(%ebp)
  80069b:	89 da                	mov    %ebx,%edx
  80069d:	89 f0                	mov    %esi,%eax
  80069f:	e8 e5 fa ff ff       	call   800189 <printnum>
			break;
  8006a4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006aa:	83 c7 01             	add    $0x1,%edi
  8006ad:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b1:	83 f8 25             	cmp    $0x25,%eax
  8006b4:	0f 84 cf fb ff ff    	je     800289 <vprintfmt+0x17>
			if (ch == '\0')
  8006ba:	85 c0                	test   %eax,%eax
  8006bc:	0f 84 a9 00 00 00    	je     80076b <vprintfmt+0x4f9>
			putch(ch, putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	50                   	push   %eax
  8006c7:	ff d6                	call   *%esi
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	eb dc                	jmp    8006aa <vprintfmt+0x438>
	if (lflag >= 2)
  8006ce:	83 f9 01             	cmp    $0x1,%ecx
  8006d1:	7e 1e                	jle    8006f1 <vprintfmt+0x47f>
		return va_arg(*ap, unsigned long long);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 50 04             	mov    0x4(%eax),%edx
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 08             	lea    0x8(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ea:	ba 10 00 00 00       	mov    $0x10,%edx
  8006ef:	eb 98                	jmp    800689 <vprintfmt+0x417>
	else if (lflag)
  8006f1:	85 c9                	test   %ecx,%ecx
  8006f3:	75 23                	jne    800718 <vprintfmt+0x4a6>
		return va_arg(*ap, unsigned int);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800702:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070e:	ba 10 00 00 00       	mov    $0x10,%edx
  800713:	e9 71 ff ff ff       	jmp    800689 <vprintfmt+0x417>
		return va_arg(*ap, unsigned long);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	ba 00 00 00 00       	mov    $0x0,%edx
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800731:	ba 10 00 00 00       	mov    $0x10,%edx
  800736:	e9 4e ff ff ff       	jmp    800689 <vprintfmt+0x417>
			putch(ch, putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 25                	push   $0x25
  800741:	ff d6                	call   *%esi
			break;
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	e9 5c ff ff ff       	jmp    8006a7 <vprintfmt+0x435>
			putch('%', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 25                	push   $0x25
  800751:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	89 f8                	mov    %edi,%eax
  800758:	eb 03                	jmp    80075d <vprintfmt+0x4eb>
  80075a:	83 e8 01             	sub    $0x1,%eax
  80075d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800761:	75 f7                	jne    80075a <vprintfmt+0x4e8>
  800763:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800766:	e9 3c ff ff ff       	jmp    8006a7 <vprintfmt+0x435>
}
  80076b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076e:	5b                   	pop    %ebx
  80076f:	5e                   	pop    %esi
  800770:	5f                   	pop    %edi
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	83 ec 18             	sub    $0x18,%esp
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800782:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800786:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800789:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800790:	85 c0                	test   %eax,%eax
  800792:	74 26                	je     8007ba <vsnprintf+0x47>
  800794:	85 d2                	test   %edx,%edx
  800796:	7e 22                	jle    8007ba <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800798:	ff 75 14             	pushl  0x14(%ebp)
  80079b:	ff 75 10             	pushl  0x10(%ebp)
  80079e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a1:	50                   	push   %eax
  8007a2:	68 38 02 80 00       	push   $0x800238
  8007a7:	e8 c6 fa ff ff       	call   800272 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007af:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b5:	83 c4 10             	add    $0x10,%esp
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    
		return -E_INVAL;
  8007ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bf:	eb f7                	jmp    8007b8 <vsnprintf+0x45>

008007c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ca:	50                   	push   %eax
  8007cb:	ff 75 10             	pushl  0x10(%ebp)
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	e8 9a ff ff ff       	call   800773 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    

008007db <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	eb 03                	jmp    8007eb <strlen+0x10>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ef:	75 f7                	jne    8007e8 <strlen+0xd>
	return n;
}
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800801:	eb 03                	jmp    800806 <strnlen+0x13>
		n++;
  800803:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800806:	39 d0                	cmp    %edx,%eax
  800808:	74 06                	je     800810 <strnlen+0x1d>
  80080a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80080e:	75 f3                	jne    800803 <strnlen+0x10>
	return n;
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	53                   	push   %ebx
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80081c:	89 c2                	mov    %eax,%edx
  80081e:	83 c1 01             	add    $0x1,%ecx
  800821:	83 c2 01             	add    $0x1,%edx
  800824:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800828:	88 5a ff             	mov    %bl,-0x1(%edx)
  80082b:	84 db                	test   %bl,%bl
  80082d:	75 ef                	jne    80081e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80082f:	5b                   	pop    %ebx
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	53                   	push   %ebx
  800836:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800839:	53                   	push   %ebx
  80083a:	e8 9c ff ff ff       	call   8007db <strlen>
  80083f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	01 d8                	add    %ebx,%eax
  800847:	50                   	push   %eax
  800848:	e8 c5 ff ff ff       	call   800812 <strcpy>
	return dst;
}
  80084d:	89 d8                	mov    %ebx,%eax
  80084f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	56                   	push   %esi
  800858:	53                   	push   %ebx
  800859:	8b 75 08             	mov    0x8(%ebp),%esi
  80085c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085f:	89 f3                	mov    %esi,%ebx
  800861:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800864:	89 f2                	mov    %esi,%edx
  800866:	eb 0f                	jmp    800877 <strncpy+0x23>
		*dst++ = *src;
  800868:	83 c2 01             	add    $0x1,%edx
  80086b:	0f b6 01             	movzbl (%ecx),%eax
  80086e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800871:	80 39 01             	cmpb   $0x1,(%ecx)
  800874:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800877:	39 da                	cmp    %ebx,%edx
  800879:	75 ed                	jne    800868 <strncpy+0x14>
	}
	return ret;
}
  80087b:	89 f0                	mov    %esi,%eax
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	56                   	push   %esi
  800885:	53                   	push   %ebx
  800886:	8b 75 08             	mov    0x8(%ebp),%esi
  800889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088f:	89 f0                	mov    %esi,%eax
  800891:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800895:	85 c9                	test   %ecx,%ecx
  800897:	75 0b                	jne    8008a4 <strlcpy+0x23>
  800899:	eb 17                	jmp    8008b2 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80089b:	83 c2 01             	add    $0x1,%edx
  80089e:	83 c0 01             	add    $0x1,%eax
  8008a1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008a4:	39 d8                	cmp    %ebx,%eax
  8008a6:	74 07                	je     8008af <strlcpy+0x2e>
  8008a8:	0f b6 0a             	movzbl (%edx),%ecx
  8008ab:	84 c9                	test   %cl,%cl
  8008ad:	75 ec                	jne    80089b <strlcpy+0x1a>
		*dst = '\0';
  8008af:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b2:	29 f0                	sub    %esi,%eax
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c1:	eb 06                	jmp    8008c9 <strcmp+0x11>
		p++, q++;
  8008c3:	83 c1 01             	add    $0x1,%ecx
  8008c6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	84 c0                	test   %al,%al
  8008ce:	74 04                	je     8008d4 <strcmp+0x1c>
  8008d0:	3a 02                	cmp    (%edx),%al
  8008d2:	74 ef                	je     8008c3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d4:	0f b6 c0             	movzbl %al,%eax
  8008d7:	0f b6 12             	movzbl (%edx),%edx
  8008da:	29 d0                	sub    %edx,%eax
}
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e8:	89 c3                	mov    %eax,%ebx
  8008ea:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ed:	eb 06                	jmp    8008f5 <strncmp+0x17>
		n--, p++, q++;
  8008ef:	83 c0 01             	add    $0x1,%eax
  8008f2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f5:	39 d8                	cmp    %ebx,%eax
  8008f7:	74 16                	je     80090f <strncmp+0x31>
  8008f9:	0f b6 08             	movzbl (%eax),%ecx
  8008fc:	84 c9                	test   %cl,%cl
  8008fe:	74 04                	je     800904 <strncmp+0x26>
  800900:	3a 0a                	cmp    (%edx),%cl
  800902:	74 eb                	je     8008ef <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800904:	0f b6 00             	movzbl (%eax),%eax
  800907:	0f b6 12             	movzbl (%edx),%edx
  80090a:	29 d0                	sub    %edx,%eax
}
  80090c:	5b                   	pop    %ebx
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    
		return 0;
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	eb f6                	jmp    80090c <strncmp+0x2e>

00800916 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800920:	0f b6 10             	movzbl (%eax),%edx
  800923:	84 d2                	test   %dl,%dl
  800925:	74 09                	je     800930 <strchr+0x1a>
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	74 0a                	je     800935 <strchr+0x1f>
	for (; *s; s++)
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	eb f0                	jmp    800920 <strchr+0xa>
			return (char *) s;
	return 0;
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800941:	eb 03                	jmp    800946 <strfind+0xf>
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800949:	38 ca                	cmp    %cl,%dl
  80094b:	74 04                	je     800951 <strfind+0x1a>
  80094d:	84 d2                	test   %dl,%dl
  80094f:	75 f2                	jne    800943 <strfind+0xc>
			break;
	return (char *) s;
}
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	57                   	push   %edi
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095f:	85 c9                	test   %ecx,%ecx
  800961:	74 13                	je     800976 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800963:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800969:	75 05                	jne    800970 <memset+0x1d>
  80096b:	f6 c1 03             	test   $0x3,%cl
  80096e:	74 0d                	je     80097d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	fc                   	cld    
  800974:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800976:	89 f8                	mov    %edi,%eax
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5f                   	pop    %edi
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    
		c &= 0xFF;
  80097d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800981:	89 d3                	mov    %edx,%ebx
  800983:	c1 e3 08             	shl    $0x8,%ebx
  800986:	89 d0                	mov    %edx,%eax
  800988:	c1 e0 18             	shl    $0x18,%eax
  80098b:	89 d6                	mov    %edx,%esi
  80098d:	c1 e6 10             	shl    $0x10,%esi
  800990:	09 f0                	or     %esi,%eax
  800992:	09 c2                	or     %eax,%edx
  800994:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800996:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800999:	89 d0                	mov    %edx,%eax
  80099b:	fc                   	cld    
  80099c:	f3 ab                	rep stos %eax,%es:(%edi)
  80099e:	eb d6                	jmp    800976 <memset+0x23>

008009a0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	57                   	push   %edi
  8009a4:	56                   	push   %esi
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ae:	39 c6                	cmp    %eax,%esi
  8009b0:	73 35                	jae    8009e7 <memmove+0x47>
  8009b2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b5:	39 c2                	cmp    %eax,%edx
  8009b7:	76 2e                	jbe    8009e7 <memmove+0x47>
		s += n;
		d += n;
  8009b9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bc:	89 d6                	mov    %edx,%esi
  8009be:	09 fe                	or     %edi,%esi
  8009c0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c6:	74 0c                	je     8009d4 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c8:	83 ef 01             	sub    $0x1,%edi
  8009cb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ce:	fd                   	std    
  8009cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d1:	fc                   	cld    
  8009d2:	eb 21                	jmp    8009f5 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	f6 c1 03             	test   $0x3,%cl
  8009d7:	75 ef                	jne    8009c8 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d9:	83 ef 04             	sub    $0x4,%edi
  8009dc:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009df:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009e2:	fd                   	std    
  8009e3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e5:	eb ea                	jmp    8009d1 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e7:	89 f2                	mov    %esi,%edx
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	f6 c2 03             	test   $0x3,%dl
  8009ee:	74 09                	je     8009f9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f0:	89 c7                	mov    %eax,%edi
  8009f2:	fc                   	cld    
  8009f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f5:	5e                   	pop    %esi
  8009f6:	5f                   	pop    %edi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f9:	f6 c1 03             	test   $0x3,%cl
  8009fc:	75 f2                	jne    8009f0 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009fe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a01:	89 c7                	mov    %eax,%edi
  800a03:	fc                   	cld    
  800a04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a06:	eb ed                	jmp    8009f5 <memmove+0x55>

00800a08 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a0b:	ff 75 10             	pushl  0x10(%ebp)
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 87 ff ff ff       	call   8009a0 <memmove>
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a26:	89 c6                	mov    %eax,%esi
  800a28:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2b:	39 f0                	cmp    %esi,%eax
  800a2d:	74 1c                	je     800a4b <memcmp+0x30>
		if (*s1 != *s2)
  800a2f:	0f b6 08             	movzbl (%eax),%ecx
  800a32:	0f b6 1a             	movzbl (%edx),%ebx
  800a35:	38 d9                	cmp    %bl,%cl
  800a37:	75 08                	jne    800a41 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	eb ea                	jmp    800a2b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a41:	0f b6 c1             	movzbl %cl,%eax
  800a44:	0f b6 db             	movzbl %bl,%ebx
  800a47:	29 d8                	sub    %ebx,%eax
  800a49:	eb 05                	jmp    800a50 <memcmp+0x35>
	}

	return 0;
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a50:	5b                   	pop    %ebx
  800a51:	5e                   	pop    %esi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a62:	39 d0                	cmp    %edx,%eax
  800a64:	73 09                	jae    800a6f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a66:	38 08                	cmp    %cl,(%eax)
  800a68:	74 05                	je     800a6f <memfind+0x1b>
	for (; s < ends; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	eb f3                	jmp    800a62 <memfind+0xe>
			break;
	return (void *) s;
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	57                   	push   %edi
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7d:	eb 03                	jmp    800a82 <strtol+0x11>
		s++;
  800a7f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a82:	0f b6 01             	movzbl (%ecx),%eax
  800a85:	3c 20                	cmp    $0x20,%al
  800a87:	74 f6                	je     800a7f <strtol+0xe>
  800a89:	3c 09                	cmp    $0x9,%al
  800a8b:	74 f2                	je     800a7f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a8d:	3c 2b                	cmp    $0x2b,%al
  800a8f:	74 2e                	je     800abf <strtol+0x4e>
	int neg = 0;
  800a91:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a96:	3c 2d                	cmp    $0x2d,%al
  800a98:	74 2f                	je     800ac9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa0:	75 05                	jne    800aa7 <strtol+0x36>
  800aa2:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa5:	74 2c                	je     800ad3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa7:	85 db                	test   %ebx,%ebx
  800aa9:	75 0a                	jne    800ab5 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aab:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ab0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab3:	74 28                	je     800add <strtol+0x6c>
		base = 10;
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aba:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800abd:	eb 50                	jmp    800b0f <strtol+0x9e>
		s++;
  800abf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ac2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac7:	eb d1                	jmp    800a9a <strtol+0x29>
		s++, neg = 1;
  800ac9:	83 c1 01             	add    $0x1,%ecx
  800acc:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad1:	eb c7                	jmp    800a9a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad7:	74 0e                	je     800ae7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad9:	85 db                	test   %ebx,%ebx
  800adb:	75 d8                	jne    800ab5 <strtol+0x44>
		s++, base = 8;
  800add:	83 c1 01             	add    $0x1,%ecx
  800ae0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae5:	eb ce                	jmp    800ab5 <strtol+0x44>
		s += 2, base = 16;
  800ae7:	83 c1 02             	add    $0x2,%ecx
  800aea:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aef:	eb c4                	jmp    800ab5 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800af1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af4:	89 f3                	mov    %esi,%ebx
  800af6:	80 fb 19             	cmp    $0x19,%bl
  800af9:	77 29                	ja     800b24 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800afb:	0f be d2             	movsbl %dl,%edx
  800afe:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b01:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b04:	7d 30                	jge    800b36 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b0d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b0f:	0f b6 11             	movzbl (%ecx),%edx
  800b12:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b15:	89 f3                	mov    %esi,%ebx
  800b17:	80 fb 09             	cmp    $0x9,%bl
  800b1a:	77 d5                	ja     800af1 <strtol+0x80>
			dig = *s - '0';
  800b1c:	0f be d2             	movsbl %dl,%edx
  800b1f:	83 ea 30             	sub    $0x30,%edx
  800b22:	eb dd                	jmp    800b01 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b24:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b27:	89 f3                	mov    %esi,%ebx
  800b29:	80 fb 19             	cmp    $0x19,%bl
  800b2c:	77 08                	ja     800b36 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b2e:	0f be d2             	movsbl %dl,%edx
  800b31:	83 ea 37             	sub    $0x37,%edx
  800b34:	eb cb                	jmp    800b01 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	74 05                	je     800b41 <strtol+0xd0>
		*endptr = (char *) s;
  800b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b41:	89 c2                	mov    %eax,%edx
  800b43:	f7 da                	neg    %edx
  800b45:	85 ff                	test   %edi,%edi
  800b47:	0f 45 c2             	cmovne %edx,%eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b60:	89 c3                	mov    %eax,%ebx
  800b62:	89 c7                	mov    %eax,%edi
  800b64:	89 c6                	mov    %eax,%esi
  800b66:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5f                   	pop    %edi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b73:	ba 00 00 00 00       	mov    $0x0,%edx
  800b78:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7d:	89 d1                	mov    %edx,%ecx
  800b7f:	89 d3                	mov    %edx,%ebx
  800b81:	89 d7                	mov    %edx,%edi
  800b83:	89 d6                	mov    %edx,%esi
  800b85:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b87:	5b                   	pop    %ebx
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b95:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9d:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba2:	89 cb                	mov    %ecx,%ebx
  800ba4:	89 cf                	mov    %ecx,%edi
  800ba6:	89 ce                	mov    %ecx,%esi
  800ba8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800baa:	85 c0                	test   %eax,%eax
  800bac:	7f 08                	jg     800bb6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb6:	83 ec 0c             	sub    $0xc,%esp
  800bb9:	50                   	push   %eax
  800bba:	6a 03                	push   $0x3
  800bbc:	68 ff 26 80 00       	push   $0x8026ff
  800bc1:	6a 23                	push   $0x23
  800bc3:	68 1c 27 80 00       	push   $0x80271c
  800bc8:	e8 4c 14 00 00       	call   802019 <_panic>

00800bcd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bdd:	89 d1                	mov    %edx,%ecx
  800bdf:	89 d3                	mov    %edx,%ebx
  800be1:	89 d7                	mov    %edx,%edi
  800be3:	89 d6                	mov    %edx,%esi
  800be5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <sys_yield>:

void
sys_yield(void)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	57                   	push   %edi
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bfc:	89 d1                	mov    %edx,%ecx
  800bfe:	89 d3                	mov    %edx,%ebx
  800c00:	89 d7                	mov    %edx,%edi
  800c02:	89 d6                	mov    %edx,%esi
  800c04:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c14:	be 00 00 00 00       	mov    $0x0,%esi
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1f:	b8 04 00 00 00       	mov    $0x4,%eax
  800c24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c27:	89 f7                	mov    %esi,%edi
  800c29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2b:	85 c0                	test   %eax,%eax
  800c2d:	7f 08                	jg     800c37 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c37:	83 ec 0c             	sub    $0xc,%esp
  800c3a:	50                   	push   %eax
  800c3b:	6a 04                	push   $0x4
  800c3d:	68 ff 26 80 00       	push   $0x8026ff
  800c42:	6a 23                	push   $0x23
  800c44:	68 1c 27 80 00       	push   $0x80271c
  800c49:	e8 cb 13 00 00       	call   802019 <_panic>

00800c4e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c68:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	7f 08                	jg     800c79 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	50                   	push   %eax
  800c7d:	6a 05                	push   $0x5
  800c7f:	68 ff 26 80 00       	push   $0x8026ff
  800c84:	6a 23                	push   $0x23
  800c86:	68 1c 27 80 00       	push   $0x80271c
  800c8b:	e8 89 13 00 00       	call   802019 <_panic>

00800c90 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
  800c96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca4:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca9:	89 df                	mov    %ebx,%edi
  800cab:	89 de                	mov    %ebx,%esi
  800cad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	7f 08                	jg     800cbb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbb:	83 ec 0c             	sub    $0xc,%esp
  800cbe:	50                   	push   %eax
  800cbf:	6a 06                	push   $0x6
  800cc1:	68 ff 26 80 00       	push   $0x8026ff
  800cc6:	6a 23                	push   $0x23
  800cc8:	68 1c 27 80 00       	push   $0x80271c
  800ccd:	e8 47 13 00 00       	call   802019 <_panic>

00800cd2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
  800cd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce6:	b8 08 00 00 00       	mov    $0x8,%eax
  800ceb:	89 df                	mov    %ebx,%edi
  800ced:	89 de                	mov    %ebx,%esi
  800cef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7f 08                	jg     800cfd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	50                   	push   %eax
  800d01:	6a 08                	push   $0x8
  800d03:	68 ff 26 80 00       	push   $0x8026ff
  800d08:	6a 23                	push   $0x23
  800d0a:	68 1c 27 80 00       	push   $0x80271c
  800d0f:	e8 05 13 00 00       	call   802019 <_panic>

00800d14 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
  800d1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2d:	89 df                	mov    %ebx,%edi
  800d2f:	89 de                	mov    %ebx,%esi
  800d31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7f 08                	jg     800d3f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	50                   	push   %eax
  800d43:	6a 09                	push   $0x9
  800d45:	68 ff 26 80 00       	push   $0x8026ff
  800d4a:	6a 23                	push   $0x23
  800d4c:	68 1c 27 80 00       	push   $0x80271c
  800d51:	e8 c3 12 00 00       	call   802019 <_panic>

00800d56 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
  800d5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6f:	89 df                	mov    %ebx,%edi
  800d71:	89 de                	mov    %ebx,%esi
  800d73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 0a                	push   $0xa
  800d87:	68 ff 26 80 00       	push   $0x8026ff
  800d8c:	6a 23                	push   $0x23
  800d8e:	68 1c 27 80 00       	push   $0x80271c
  800d93:	e8 81 12 00 00       	call   802019 <_panic>

00800d98 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da9:	be 00 00 00 00       	mov    $0x0,%esi
  800dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd1:	89 cb                	mov    %ecx,%ebx
  800dd3:	89 cf                	mov    %ecx,%edi
  800dd5:	89 ce                	mov    %ecx,%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 0d                	push   $0xd
  800deb:	68 ff 26 80 00       	push   $0x8026ff
  800df0:	6a 23                	push   $0x23
  800df2:	68 1c 27 80 00       	push   $0x80271c
  800df7:	e8 1d 12 00 00       	call   802019 <_panic>

00800dfc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e02:	ba 00 00 00 00       	mov    $0x0,%edx
  800e07:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e0c:	89 d1                	mov    %edx,%ecx
  800e0e:	89 d3                	mov    %edx,%ebx
  800e10:	89 d7                	mov    %edx,%edi
  800e12:	89 d6                	mov    %edx,%esi
  800e14:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e21:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800e28:	74 0a                	je     800e34 <set_pgfault_handler+0x19>
		    panic("set_pgfault_handler: %e", r);
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)) != 0) {
  800e34:	a1 08 40 80 00       	mov    0x804008,%eax
  800e39:	8b 40 48             	mov    0x48(%eax),%eax
  800e3c:	83 ec 04             	sub    $0x4,%esp
  800e3f:	6a 07                	push   $0x7
  800e41:	68 00 f0 bf ee       	push   $0xeebff000
  800e46:	50                   	push   %eax
  800e47:	e8 bf fd ff ff       	call   800c0b <sys_page_alloc>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 2f                	jne    800e82 <set_pgfault_handler+0x67>
		if ((r = sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)) != 0) {
  800e53:	a1 08 40 80 00       	mov    0x804008,%eax
  800e58:	8b 40 48             	mov    0x48(%eax),%eax
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	68 94 0e 80 00       	push   $0x800e94
  800e63:	50                   	push   %eax
  800e64:	e8 ed fe ff ff       	call   800d56 <sys_env_set_pgfault_upcall>
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	74 ba                	je     800e2a <set_pgfault_handler+0xf>
		    panic("set_pgfault_handler: %e", r);
  800e70:	50                   	push   %eax
  800e71:	68 2a 27 80 00       	push   $0x80272a
  800e76:	6a 24                	push   $0x24
  800e78:	68 42 27 80 00       	push   $0x802742
  800e7d:	e8 97 11 00 00       	call   802019 <_panic>
		    panic("set_pgfault_handler: %e", r);
  800e82:	50                   	push   %eax
  800e83:	68 2a 27 80 00       	push   $0x80272a
  800e88:	6a 21                	push   $0x21
  800e8a:	68 42 27 80 00       	push   $0x802742
  800e8f:	e8 85 11 00 00       	call   802019 <_panic>

00800e94 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e94:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e95:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e9a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e9c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x30(%esp), %ecx    // save trap-time esp in ecx
  800e9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
	subl $4, %ecx            // enlarge the previous stack for 4 bytes
  800ea3:	83 e9 04             	sub    $0x4,%ecx
	movl %ecx, 0x30(%esp)    // write the modified esp back
  800ea6:	89 4c 24 30          	mov    %ecx,0x30(%esp)
	movl 0x28(%esp), %edx    // save trap-time eip in edx
  800eaa:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %edx, (%ecx)        // save eip at new esp for return
  800eae:	89 11                	mov    %edx,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp            // skip fault_va and tf_err
  800eb0:	83 c4 08             	add    $0x8,%esp
	popal                    // pop PushRegs
  800eb3:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp            // skip eip
  800eb4:	83 c4 04             	add    $0x4,%esp
	popfl                    // pop eflags
  800eb7:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
  800eb8:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800eb9:	c3                   	ret    

00800eba <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	05 00 00 00 30       	add    $0x30000000,%eax
  800ec5:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ed5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eda:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eec:	89 c2                	mov    %eax,%edx
  800eee:	c1 ea 16             	shr    $0x16,%edx
  800ef1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef8:	f6 c2 01             	test   $0x1,%dl
  800efb:	74 2a                	je     800f27 <fd_alloc+0x46>
  800efd:	89 c2                	mov    %eax,%edx
  800eff:	c1 ea 0c             	shr    $0xc,%edx
  800f02:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f09:	f6 c2 01             	test   $0x1,%dl
  800f0c:	74 19                	je     800f27 <fd_alloc+0x46>
  800f0e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f13:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f18:	75 d2                	jne    800eec <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f1a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f20:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f25:	eb 07                	jmp    800f2e <fd_alloc+0x4d>
			*fd_store = fd;
  800f27:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f36:	83 f8 1f             	cmp    $0x1f,%eax
  800f39:	77 36                	ja     800f71 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f3b:	c1 e0 0c             	shl    $0xc,%eax
  800f3e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f43:	89 c2                	mov    %eax,%edx
  800f45:	c1 ea 16             	shr    $0x16,%edx
  800f48:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4f:	f6 c2 01             	test   $0x1,%dl
  800f52:	74 24                	je     800f78 <fd_lookup+0x48>
  800f54:	89 c2                	mov    %eax,%edx
  800f56:	c1 ea 0c             	shr    $0xc,%edx
  800f59:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f60:	f6 c2 01             	test   $0x1,%dl
  800f63:	74 1a                	je     800f7f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f68:	89 02                	mov    %eax,(%edx)
	return 0;
  800f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
		return -E_INVAL;
  800f71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f76:	eb f7                	jmp    800f6f <fd_lookup+0x3f>
		return -E_INVAL;
  800f78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7d:	eb f0                	jmp    800f6f <fd_lookup+0x3f>
  800f7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f84:	eb e9                	jmp    800f6f <fd_lookup+0x3f>

00800f86 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f8f:	ba cc 27 80 00       	mov    $0x8027cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f94:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f99:	39 08                	cmp    %ecx,(%eax)
  800f9b:	74 33                	je     800fd0 <dev_lookup+0x4a>
  800f9d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fa0:	8b 02                	mov    (%edx),%eax
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	75 f3                	jne    800f99 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fa6:	a1 08 40 80 00       	mov    0x804008,%eax
  800fab:	8b 40 48             	mov    0x48(%eax),%eax
  800fae:	83 ec 04             	sub    $0x4,%esp
  800fb1:	51                   	push   %ecx
  800fb2:	50                   	push   %eax
  800fb3:	68 50 27 80 00       	push   $0x802750
  800fb8:	e8 b8 f1 ff ff       	call   800175 <cprintf>
	*dev = 0;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    
			*dev = devtab[i];
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	eb f2                	jmp    800fce <dev_lookup+0x48>

00800fdc <fd_close>:
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
  800fe2:	83 ec 1c             	sub    $0x1c,%esp
  800fe5:	8b 75 08             	mov    0x8(%ebp),%esi
  800fe8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800feb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fee:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fef:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ff5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ff8:	50                   	push   %eax
  800ff9:	e8 32 ff ff ff       	call   800f30 <fd_lookup>
  800ffe:	89 c3                	mov    %eax,%ebx
  801000:	83 c4 08             	add    $0x8,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	78 05                	js     80100c <fd_close+0x30>
	    || fd != fd2)
  801007:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80100a:	74 16                	je     801022 <fd_close+0x46>
		return (must_exist ? r : 0);
  80100c:	89 f8                	mov    %edi,%eax
  80100e:	84 c0                	test   %al,%al
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
  801015:	0f 44 d8             	cmove  %eax,%ebx
}
  801018:	89 d8                	mov    %ebx,%eax
  80101a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801028:	50                   	push   %eax
  801029:	ff 36                	pushl  (%esi)
  80102b:	e8 56 ff ff ff       	call   800f86 <dev_lookup>
  801030:	89 c3                	mov    %eax,%ebx
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	85 c0                	test   %eax,%eax
  801037:	78 15                	js     80104e <fd_close+0x72>
		if (dev->dev_close)
  801039:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103c:	8b 40 10             	mov    0x10(%eax),%eax
  80103f:	85 c0                	test   %eax,%eax
  801041:	74 1b                	je     80105e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	56                   	push   %esi
  801047:	ff d0                	call   *%eax
  801049:	89 c3                	mov    %eax,%ebx
  80104b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80104e:	83 ec 08             	sub    $0x8,%esp
  801051:	56                   	push   %esi
  801052:	6a 00                	push   $0x0
  801054:	e8 37 fc ff ff       	call   800c90 <sys_page_unmap>
	return r;
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	eb ba                	jmp    801018 <fd_close+0x3c>
			r = 0;
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801063:	eb e9                	jmp    80104e <fd_close+0x72>

00801065 <close>:

int
close(int fdnum)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80106b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80106e:	50                   	push   %eax
  80106f:	ff 75 08             	pushl  0x8(%ebp)
  801072:	e8 b9 fe ff ff       	call   800f30 <fd_lookup>
  801077:	83 c4 08             	add    $0x8,%esp
  80107a:	85 c0                	test   %eax,%eax
  80107c:	78 10                	js     80108e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80107e:	83 ec 08             	sub    $0x8,%esp
  801081:	6a 01                	push   $0x1
  801083:	ff 75 f4             	pushl  -0xc(%ebp)
  801086:	e8 51 ff ff ff       	call   800fdc <fd_close>
  80108b:	83 c4 10             	add    $0x10,%esp
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <close_all>:

void
close_all(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	53                   	push   %ebx
  801094:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801097:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	53                   	push   %ebx
  8010a0:	e8 c0 ff ff ff       	call   801065 <close>
	for (i = 0; i < MAXFD; i++)
  8010a5:	83 c3 01             	add    $0x1,%ebx
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	83 fb 20             	cmp    $0x20,%ebx
  8010ae:	75 ec                	jne    80109c <close_all+0xc>
}
  8010b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c1:	50                   	push   %eax
  8010c2:	ff 75 08             	pushl  0x8(%ebp)
  8010c5:	e8 66 fe ff ff       	call   800f30 <fd_lookup>
  8010ca:	89 c3                	mov    %eax,%ebx
  8010cc:	83 c4 08             	add    $0x8,%esp
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	0f 88 81 00 00 00    	js     801158 <dup+0xa3>
		return r;
	close(newfdnum);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	e8 83 ff ff ff       	call   801065 <close>

	newfd = INDEX2FD(newfdnum);
  8010e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e5:	c1 e6 0c             	shl    $0xc,%esi
  8010e8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010ee:	83 c4 04             	add    $0x4,%esp
  8010f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f4:	e8 d1 fd ff ff       	call   800eca <fd2data>
  8010f9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010fb:	89 34 24             	mov    %esi,(%esp)
  8010fe:	e8 c7 fd ff ff       	call   800eca <fd2data>
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801108:	89 d8                	mov    %ebx,%eax
  80110a:	c1 e8 16             	shr    $0x16,%eax
  80110d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801114:	a8 01                	test   $0x1,%al
  801116:	74 11                	je     801129 <dup+0x74>
  801118:	89 d8                	mov    %ebx,%eax
  80111a:	c1 e8 0c             	shr    $0xc,%eax
  80111d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801124:	f6 c2 01             	test   $0x1,%dl
  801127:	75 39                	jne    801162 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801129:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	c1 e8 0c             	shr    $0xc,%eax
  801131:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	25 07 0e 00 00       	and    $0xe07,%eax
  801140:	50                   	push   %eax
  801141:	56                   	push   %esi
  801142:	6a 00                	push   $0x0
  801144:	52                   	push   %edx
  801145:	6a 00                	push   $0x0
  801147:	e8 02 fb ff ff       	call   800c4e <sys_page_map>
  80114c:	89 c3                	mov    %eax,%ebx
  80114e:	83 c4 20             	add    $0x20,%esp
  801151:	85 c0                	test   %eax,%eax
  801153:	78 31                	js     801186 <dup+0xd1>
		goto err;

	return newfdnum;
  801155:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801158:	89 d8                	mov    %ebx,%eax
  80115a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5e                   	pop    %esi
  80115f:	5f                   	pop    %edi
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801162:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801169:	83 ec 0c             	sub    $0xc,%esp
  80116c:	25 07 0e 00 00       	and    $0xe07,%eax
  801171:	50                   	push   %eax
  801172:	57                   	push   %edi
  801173:	6a 00                	push   $0x0
  801175:	53                   	push   %ebx
  801176:	6a 00                	push   $0x0
  801178:	e8 d1 fa ff ff       	call   800c4e <sys_page_map>
  80117d:	89 c3                	mov    %eax,%ebx
  80117f:	83 c4 20             	add    $0x20,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	79 a3                	jns    801129 <dup+0x74>
	sys_page_unmap(0, newfd);
  801186:	83 ec 08             	sub    $0x8,%esp
  801189:	56                   	push   %esi
  80118a:	6a 00                	push   $0x0
  80118c:	e8 ff fa ff ff       	call   800c90 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801191:	83 c4 08             	add    $0x8,%esp
  801194:	57                   	push   %edi
  801195:	6a 00                	push   $0x0
  801197:	e8 f4 fa ff ff       	call   800c90 <sys_page_unmap>
	return r;
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	eb b7                	jmp    801158 <dup+0xa3>

008011a1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	53                   	push   %ebx
  8011a5:	83 ec 14             	sub    $0x14,%esp
  8011a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ae:	50                   	push   %eax
  8011af:	53                   	push   %ebx
  8011b0:	e8 7b fd ff ff       	call   800f30 <fd_lookup>
  8011b5:	83 c4 08             	add    $0x8,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 3f                	js     8011fb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011bc:	83 ec 08             	sub    $0x8,%esp
  8011bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c2:	50                   	push   %eax
  8011c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c6:	ff 30                	pushl  (%eax)
  8011c8:	e8 b9 fd ff ff       	call   800f86 <dev_lookup>
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	78 27                	js     8011fb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d7:	8b 42 08             	mov    0x8(%edx),%eax
  8011da:	83 e0 03             	and    $0x3,%eax
  8011dd:	83 f8 01             	cmp    $0x1,%eax
  8011e0:	74 1e                	je     801200 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e5:	8b 40 08             	mov    0x8(%eax),%eax
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	74 35                	je     801221 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	ff 75 10             	pushl  0x10(%ebp)
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	52                   	push   %edx
  8011f6:	ff d0                	call   *%eax
  8011f8:	83 c4 10             	add    $0x10,%esp
}
  8011fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801200:	a1 08 40 80 00       	mov    0x804008,%eax
  801205:	8b 40 48             	mov    0x48(%eax),%eax
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	53                   	push   %ebx
  80120c:	50                   	push   %eax
  80120d:	68 91 27 80 00       	push   $0x802791
  801212:	e8 5e ef ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121f:	eb da                	jmp    8011fb <read+0x5a>
		return -E_NOT_SUPP;
  801221:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801226:	eb d3                	jmp    8011fb <read+0x5a>

00801228 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	8b 7d 08             	mov    0x8(%ebp),%edi
  801234:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801237:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123c:	39 f3                	cmp    %esi,%ebx
  80123e:	73 25                	jae    801265 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801240:	83 ec 04             	sub    $0x4,%esp
  801243:	89 f0                	mov    %esi,%eax
  801245:	29 d8                	sub    %ebx,%eax
  801247:	50                   	push   %eax
  801248:	89 d8                	mov    %ebx,%eax
  80124a:	03 45 0c             	add    0xc(%ebp),%eax
  80124d:	50                   	push   %eax
  80124e:	57                   	push   %edi
  80124f:	e8 4d ff ff ff       	call   8011a1 <read>
		if (m < 0)
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 08                	js     801263 <readn+0x3b>
			return m;
		if (m == 0)
  80125b:	85 c0                	test   %eax,%eax
  80125d:	74 06                	je     801265 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80125f:	01 c3                	add    %eax,%ebx
  801261:	eb d9                	jmp    80123c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801263:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801265:	89 d8                	mov    %ebx,%eax
  801267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126a:	5b                   	pop    %ebx
  80126b:	5e                   	pop    %esi
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	53                   	push   %ebx
  801273:	83 ec 14             	sub    $0x14,%esp
  801276:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801279:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127c:	50                   	push   %eax
  80127d:	53                   	push   %ebx
  80127e:	e8 ad fc ff ff       	call   800f30 <fd_lookup>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	78 3a                	js     8012c4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801294:	ff 30                	pushl  (%eax)
  801296:	e8 eb fc ff ff       	call   800f86 <dev_lookup>
  80129b:	83 c4 10             	add    $0x10,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 22                	js     8012c4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a9:	74 1e                	je     8012c9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b1:	85 d2                	test   %edx,%edx
  8012b3:	74 35                	je     8012ea <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b5:	83 ec 04             	sub    $0x4,%esp
  8012b8:	ff 75 10             	pushl  0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	50                   	push   %eax
  8012bf:	ff d2                	call   *%edx
  8012c1:	83 c4 10             	add    $0x10,%esp
}
  8012c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c9:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ce:	8b 40 48             	mov    0x48(%eax),%eax
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	53                   	push   %ebx
  8012d5:	50                   	push   %eax
  8012d6:	68 ad 27 80 00       	push   $0x8027ad
  8012db:	e8 95 ee ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e8:	eb da                	jmp    8012c4 <write+0x55>
		return -E_NOT_SUPP;
  8012ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ef:	eb d3                	jmp    8012c4 <write+0x55>

008012f1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012fa:	50                   	push   %eax
  8012fb:	ff 75 08             	pushl  0x8(%ebp)
  8012fe:	e8 2d fc ff ff       	call   800f30 <fd_lookup>
  801303:	83 c4 08             	add    $0x8,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 0e                	js     801318 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80130a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801310:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801313:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	83 ec 14             	sub    $0x14,%esp
  801321:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801324:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801327:	50                   	push   %eax
  801328:	53                   	push   %ebx
  801329:	e8 02 fc ff ff       	call   800f30 <fd_lookup>
  80132e:	83 c4 08             	add    $0x8,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 37                	js     80136c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133f:	ff 30                	pushl  (%eax)
  801341:	e8 40 fc ff ff       	call   800f86 <dev_lookup>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 1f                	js     80136c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801354:	74 1b                	je     801371 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801359:	8b 52 18             	mov    0x18(%edx),%edx
  80135c:	85 d2                	test   %edx,%edx
  80135e:	74 32                	je     801392 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	50                   	push   %eax
  801367:	ff d2                	call   *%edx
  801369:	83 c4 10             	add    $0x10,%esp
}
  80136c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
			thisenv->env_id, fdnum);
  801371:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801376:	8b 40 48             	mov    0x48(%eax),%eax
  801379:	83 ec 04             	sub    $0x4,%esp
  80137c:	53                   	push   %ebx
  80137d:	50                   	push   %eax
  80137e:	68 70 27 80 00       	push   $0x802770
  801383:	e8 ed ed ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801390:	eb da                	jmp    80136c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801392:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801397:	eb d3                	jmp    80136c <ftruncate+0x52>

00801399 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	53                   	push   %ebx
  80139d:	83 ec 14             	sub    $0x14,%esp
  8013a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	ff 75 08             	pushl  0x8(%ebp)
  8013aa:	e8 81 fb ff ff       	call   800f30 <fd_lookup>
  8013af:	83 c4 08             	add    $0x8,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 4b                	js     801401 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c0:	ff 30                	pushl  (%eax)
  8013c2:	e8 bf fb ff ff       	call   800f86 <dev_lookup>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	78 33                	js     801401 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013d5:	74 2f                	je     801406 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013d7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013da:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e1:	00 00 00 
	stat->st_isdir = 0;
  8013e4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013eb:	00 00 00 
	stat->st_dev = dev;
  8013ee:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f4:	83 ec 08             	sub    $0x8,%esp
  8013f7:	53                   	push   %ebx
  8013f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013fb:	ff 50 14             	call   *0x14(%eax)
  8013fe:	83 c4 10             	add    $0x10,%esp
}
  801401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801404:	c9                   	leave  
  801405:	c3                   	ret    
		return -E_NOT_SUPP;
  801406:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140b:	eb f4                	jmp    801401 <fstat+0x68>

0080140d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	6a 00                	push   $0x0
  801417:	ff 75 08             	pushl  0x8(%ebp)
  80141a:	e8 26 02 00 00       	call   801645 <open>
  80141f:	89 c3                	mov    %eax,%ebx
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 1b                	js     801443 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	50                   	push   %eax
  80142f:	e8 65 ff ff ff       	call   801399 <fstat>
  801434:	89 c6                	mov    %eax,%esi
	close(fd);
  801436:	89 1c 24             	mov    %ebx,(%esp)
  801439:	e8 27 fc ff ff       	call   801065 <close>
	return r;
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	89 f3                	mov    %esi,%ebx
}
  801443:	89 d8                	mov    %ebx,%eax
  801445:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801448:	5b                   	pop    %ebx
  801449:	5e                   	pop    %esi
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	56                   	push   %esi
  801450:	53                   	push   %ebx
  801451:	89 c6                	mov    %eax,%esi
  801453:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801455:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80145c:	74 27                	je     801485 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80145e:	6a 07                	push   $0x7
  801460:	68 00 50 80 00       	push   $0x805000
  801465:	56                   	push   %esi
  801466:	ff 35 00 40 80 00    	pushl  0x804000
  80146c:	e8 57 0c 00 00       	call   8020c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801471:	83 c4 0c             	add    $0xc,%esp
  801474:	6a 00                	push   $0x0
  801476:	53                   	push   %ebx
  801477:	6a 00                	push   $0x0
  801479:	e8 e1 0b 00 00       	call   80205f <ipc_recv>
}
  80147e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801481:	5b                   	pop    %ebx
  801482:	5e                   	pop    %esi
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	6a 01                	push   $0x1
  80148a:	e8 92 0c 00 00       	call   802121 <ipc_find_env>
  80148f:	a3 00 40 80 00       	mov    %eax,0x804000
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	eb c5                	jmp    80145e <fsipc+0x12>

00801499 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8014bc:	e8 8b ff ff ff       	call   80144c <fsipc>
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <devfile_flush>:
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8014cf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8014de:	e8 69 ff ff ff       	call   80144c <fsipc>
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <devfile_stat>:
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801504:	e8 43 ff ff ff       	call   80144c <fsipc>
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 2c                	js     801539 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	68 00 50 80 00       	push   $0x805000
  801515:	53                   	push   %ebx
  801516:	e8 f7 f2 ff ff       	call   800812 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80151b:	a1 80 50 80 00       	mov    0x805080,%eax
  801520:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801526:	a1 84 50 80 00       	mov    0x805084,%eax
  80152b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <devfile_write>:
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	53                   	push   %ebx
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8b 40 0c             	mov    0xc(%eax),%eax
  80154e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801553:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801559:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80155f:	77 30                	ja     801591 <devfile_write+0x53>
	memmove(fsipcbuf.write.req_buf, buf, n);
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	53                   	push   %ebx
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	68 08 50 80 00       	push   $0x805008
  80156d:	e8 2e f4 ff ff       	call   8009a0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801572:	ba 00 00 00 00       	mov    $0x0,%edx
  801577:	b8 04 00 00 00       	mov    $0x4,%eax
  80157c:	e8 cb fe ff ff       	call   80144c <fsipc>
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	85 c0                	test   %eax,%eax
  801586:	78 04                	js     80158c <devfile_write+0x4e>
	assert(r <= n);
  801588:	39 d8                	cmp    %ebx,%eax
  80158a:	77 1e                	ja     8015aa <devfile_write+0x6c>
}
  80158c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158f:	c9                   	leave  
  801590:	c3                   	ret    
	assert(n <= PGSIZE - (sizeof(int) + sizeof(size_t)));
  801591:	68 e0 27 80 00       	push   $0x8027e0
  801596:	68 0d 28 80 00       	push   $0x80280d
  80159b:	68 94 00 00 00       	push   $0x94
  8015a0:	68 22 28 80 00       	push   $0x802822
  8015a5:	e8 6f 0a 00 00       	call   802019 <_panic>
	assert(r <= n);
  8015aa:	68 2d 28 80 00       	push   $0x80282d
  8015af:	68 0d 28 80 00       	push   $0x80280d
  8015b4:	68 98 00 00 00       	push   $0x98
  8015b9:	68 22 28 80 00       	push   $0x802822
  8015be:	e8 56 0a 00 00       	call   802019 <_panic>

008015c3 <devfile_read>:
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015d6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8015e6:	e8 61 fe ff ff       	call   80144c <fsipc>
  8015eb:	89 c3                	mov    %eax,%ebx
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 1f                	js     801610 <devfile_read+0x4d>
	assert(r <= n);
  8015f1:	39 f0                	cmp    %esi,%eax
  8015f3:	77 24                	ja     801619 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015fa:	7f 33                	jg     80162f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	50                   	push   %eax
  801600:	68 00 50 80 00       	push   $0x805000
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	e8 93 f3 ff ff       	call   8009a0 <memmove>
	return r;
  80160d:	83 c4 10             	add    $0x10,%esp
}
  801610:	89 d8                	mov    %ebx,%eax
  801612:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801615:	5b                   	pop    %ebx
  801616:	5e                   	pop    %esi
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    
	assert(r <= n);
  801619:	68 2d 28 80 00       	push   $0x80282d
  80161e:	68 0d 28 80 00       	push   $0x80280d
  801623:	6a 7c                	push   $0x7c
  801625:	68 22 28 80 00       	push   $0x802822
  80162a:	e8 ea 09 00 00       	call   802019 <_panic>
	assert(r <= PGSIZE);
  80162f:	68 34 28 80 00       	push   $0x802834
  801634:	68 0d 28 80 00       	push   $0x80280d
  801639:	6a 7d                	push   $0x7d
  80163b:	68 22 28 80 00       	push   $0x802822
  801640:	e8 d4 09 00 00       	call   802019 <_panic>

00801645 <open>:
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	56                   	push   %esi
  801649:	53                   	push   %ebx
  80164a:	83 ec 1c             	sub    $0x1c,%esp
  80164d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801650:	56                   	push   %esi
  801651:	e8 85 f1 ff ff       	call   8007db <strlen>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80165e:	7f 6c                	jg     8016cc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801660:	83 ec 0c             	sub    $0xc,%esp
  801663:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	e8 75 f8 ff ff       	call   800ee1 <fd_alloc>
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	83 c4 10             	add    $0x10,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	78 3c                	js     8016b1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	56                   	push   %esi
  801679:	68 00 50 80 00       	push   $0x805000
  80167e:	e8 8f f1 ff ff       	call   800812 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80168b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168e:	b8 01 00 00 00       	mov    $0x1,%eax
  801693:	e8 b4 fd ff ff       	call   80144c <fsipc>
  801698:	89 c3                	mov    %eax,%ebx
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 19                	js     8016ba <open+0x75>
	return fd2num(fd);
  8016a1:	83 ec 0c             	sub    $0xc,%esp
  8016a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a7:	e8 0e f8 ff ff       	call   800eba <fd2num>
  8016ac:	89 c3                	mov    %eax,%ebx
  8016ae:	83 c4 10             	add    $0x10,%esp
}
  8016b1:	89 d8                	mov    %ebx,%eax
  8016b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b6:	5b                   	pop    %ebx
  8016b7:	5e                   	pop    %esi
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    
		fd_close(fd, 0);
  8016ba:	83 ec 08             	sub    $0x8,%esp
  8016bd:	6a 00                	push   $0x0
  8016bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c2:	e8 15 f9 ff ff       	call   800fdc <fd_close>
		return r;
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	eb e5                	jmp    8016b1 <open+0x6c>
		return -E_BAD_PATH;
  8016cc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016d1:	eb de                	jmp    8016b1 <open+0x6c>

008016d3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016de:	b8 08 00 00 00       	mov    $0x8,%eax
  8016e3:	e8 64 fd ff ff       	call   80144c <fsipc>
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	ff 75 08             	pushl  0x8(%ebp)
  8016f8:	e8 cd f7 ff ff       	call   800eca <fd2data>
  8016fd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016ff:	83 c4 08             	add    $0x8,%esp
  801702:	68 40 28 80 00       	push   $0x802840
  801707:	53                   	push   %ebx
  801708:	e8 05 f1 ff ff       	call   800812 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80170d:	8b 46 04             	mov    0x4(%esi),%eax
  801710:	2b 06                	sub    (%esi),%eax
  801712:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801718:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80171f:	00 00 00 
	stat->st_dev = &devpipe;
  801722:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801729:	30 80 00 
	return 0;
}
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801734:	5b                   	pop    %ebx
  801735:	5e                   	pop    %esi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801742:	53                   	push   %ebx
  801743:	6a 00                	push   $0x0
  801745:	e8 46 f5 ff ff       	call   800c90 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80174a:	89 1c 24             	mov    %ebx,(%esp)
  80174d:	e8 78 f7 ff ff       	call   800eca <fd2data>
  801752:	83 c4 08             	add    $0x8,%esp
  801755:	50                   	push   %eax
  801756:	6a 00                	push   $0x0
  801758:	e8 33 f5 ff ff       	call   800c90 <sys_page_unmap>
}
  80175d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <_pipeisclosed>:
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	57                   	push   %edi
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	83 ec 1c             	sub    $0x1c,%esp
  80176b:	89 c7                	mov    %eax,%edi
  80176d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80176f:	a1 08 40 80 00       	mov    0x804008,%eax
  801774:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801777:	83 ec 0c             	sub    $0xc,%esp
  80177a:	57                   	push   %edi
  80177b:	e8 da 09 00 00       	call   80215a <pageref>
  801780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801783:	89 34 24             	mov    %esi,(%esp)
  801786:	e8 cf 09 00 00       	call   80215a <pageref>
		nn = thisenv->env_runs;
  80178b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801791:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	39 cb                	cmp    %ecx,%ebx
  801799:	74 1b                	je     8017b6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80179b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80179e:	75 cf                	jne    80176f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017a0:	8b 42 58             	mov    0x58(%edx),%eax
  8017a3:	6a 01                	push   $0x1
  8017a5:	50                   	push   %eax
  8017a6:	53                   	push   %ebx
  8017a7:	68 47 28 80 00       	push   $0x802847
  8017ac:	e8 c4 e9 ff ff       	call   800175 <cprintf>
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	eb b9                	jmp    80176f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017b9:	0f 94 c0             	sete   %al
  8017bc:	0f b6 c0             	movzbl %al,%eax
}
  8017bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5f                   	pop    %edi
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <devpipe_write>:
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	57                   	push   %edi
  8017cb:	56                   	push   %esi
  8017cc:	53                   	push   %ebx
  8017cd:	83 ec 28             	sub    $0x28,%esp
  8017d0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017d3:	56                   	push   %esi
  8017d4:	e8 f1 f6 ff ff       	call   800eca <fd2data>
  8017d9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	bf 00 00 00 00       	mov    $0x0,%edi
  8017e3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017e6:	74 4f                	je     801837 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017e8:	8b 43 04             	mov    0x4(%ebx),%eax
  8017eb:	8b 0b                	mov    (%ebx),%ecx
  8017ed:	8d 51 20             	lea    0x20(%ecx),%edx
  8017f0:	39 d0                	cmp    %edx,%eax
  8017f2:	72 14                	jb     801808 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8017f4:	89 da                	mov    %ebx,%edx
  8017f6:	89 f0                	mov    %esi,%eax
  8017f8:	e8 65 ff ff ff       	call   801762 <_pipeisclosed>
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	75 3a                	jne    80183b <devpipe_write+0x74>
			sys_yield();
  801801:	e8 e6 f3 ff ff       	call   800bec <sys_yield>
  801806:	eb e0                	jmp    8017e8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80180f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801812:	89 c2                	mov    %eax,%edx
  801814:	c1 fa 1f             	sar    $0x1f,%edx
  801817:	89 d1                	mov    %edx,%ecx
  801819:	c1 e9 1b             	shr    $0x1b,%ecx
  80181c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80181f:	83 e2 1f             	and    $0x1f,%edx
  801822:	29 ca                	sub    %ecx,%edx
  801824:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801828:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80182c:	83 c0 01             	add    $0x1,%eax
  80182f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801832:	83 c7 01             	add    $0x1,%edi
  801835:	eb ac                	jmp    8017e3 <devpipe_write+0x1c>
	return i;
  801837:	89 f8                	mov    %edi,%eax
  801839:	eb 05                	jmp    801840 <devpipe_write+0x79>
				return 0;
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801840:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <devpipe_read>:
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	57                   	push   %edi
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
  80184e:	83 ec 18             	sub    $0x18,%esp
  801851:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801854:	57                   	push   %edi
  801855:	e8 70 f6 ff ff       	call   800eca <fd2data>
  80185a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	be 00 00 00 00       	mov    $0x0,%esi
  801864:	3b 75 10             	cmp    0x10(%ebp),%esi
  801867:	74 47                	je     8018b0 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801869:	8b 03                	mov    (%ebx),%eax
  80186b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80186e:	75 22                	jne    801892 <devpipe_read+0x4a>
			if (i > 0)
  801870:	85 f6                	test   %esi,%esi
  801872:	75 14                	jne    801888 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801874:	89 da                	mov    %ebx,%edx
  801876:	89 f8                	mov    %edi,%eax
  801878:	e8 e5 fe ff ff       	call   801762 <_pipeisclosed>
  80187d:	85 c0                	test   %eax,%eax
  80187f:	75 33                	jne    8018b4 <devpipe_read+0x6c>
			sys_yield();
  801881:	e8 66 f3 ff ff       	call   800bec <sys_yield>
  801886:	eb e1                	jmp    801869 <devpipe_read+0x21>
				return i;
  801888:	89 f0                	mov    %esi,%eax
}
  80188a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5e                   	pop    %esi
  80188f:	5f                   	pop    %edi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801892:	99                   	cltd   
  801893:	c1 ea 1b             	shr    $0x1b,%edx
  801896:	01 d0                	add    %edx,%eax
  801898:	83 e0 1f             	and    $0x1f,%eax
  80189b:	29 d0                	sub    %edx,%eax
  80189d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018a8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8018ab:	83 c6 01             	add    $0x1,%esi
  8018ae:	eb b4                	jmp    801864 <devpipe_read+0x1c>
	return i;
  8018b0:	89 f0                	mov    %esi,%eax
  8018b2:	eb d6                	jmp    80188a <devpipe_read+0x42>
				return 0;
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b9:	eb cf                	jmp    80188a <devpipe_read+0x42>

008018bb <pipe>:
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c6:	50                   	push   %eax
  8018c7:	e8 15 f6 ff ff       	call   800ee1 <fd_alloc>
  8018cc:	89 c3                	mov    %eax,%ebx
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 5b                	js     801930 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	68 07 04 00 00       	push   $0x407
  8018dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 24 f3 ff ff       	call   800c0b <sys_page_alloc>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 40                	js     801930 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8018f0:	83 ec 0c             	sub    $0xc,%esp
  8018f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f6:	50                   	push   %eax
  8018f7:	e8 e5 f5 ff ff       	call   800ee1 <fd_alloc>
  8018fc:	89 c3                	mov    %eax,%ebx
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	85 c0                	test   %eax,%eax
  801903:	78 1b                	js     801920 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	68 07 04 00 00       	push   $0x407
  80190d:	ff 75 f0             	pushl  -0x10(%ebp)
  801910:	6a 00                	push   $0x0
  801912:	e8 f4 f2 ff ff       	call   800c0b <sys_page_alloc>
  801917:	89 c3                	mov    %eax,%ebx
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	79 19                	jns    801939 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 f4             	pushl  -0xc(%ebp)
  801926:	6a 00                	push   $0x0
  801928:	e8 63 f3 ff ff       	call   800c90 <sys_page_unmap>
  80192d:	83 c4 10             	add    $0x10,%esp
}
  801930:	89 d8                	mov    %ebx,%eax
  801932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    
	va = fd2data(fd0);
  801939:	83 ec 0c             	sub    $0xc,%esp
  80193c:	ff 75 f4             	pushl  -0xc(%ebp)
  80193f:	e8 86 f5 ff ff       	call   800eca <fd2data>
  801944:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801946:	83 c4 0c             	add    $0xc,%esp
  801949:	68 07 04 00 00       	push   $0x407
  80194e:	50                   	push   %eax
  80194f:	6a 00                	push   $0x0
  801951:	e8 b5 f2 ff ff       	call   800c0b <sys_page_alloc>
  801956:	89 c3                	mov    %eax,%ebx
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	85 c0                	test   %eax,%eax
  80195d:	0f 88 8c 00 00 00    	js     8019ef <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	ff 75 f0             	pushl  -0x10(%ebp)
  801969:	e8 5c f5 ff ff       	call   800eca <fd2data>
  80196e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801975:	50                   	push   %eax
  801976:	6a 00                	push   $0x0
  801978:	56                   	push   %esi
  801979:	6a 00                	push   $0x0
  80197b:	e8 ce f2 ff ff       	call   800c4e <sys_page_map>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	83 c4 20             	add    $0x20,%esp
  801985:	85 c0                	test   %eax,%eax
  801987:	78 58                	js     8019e1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801992:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80199e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019a7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b9:	e8 fc f4 ff ff       	call   800eba <fd2num>
  8019be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019c3:	83 c4 04             	add    $0x4,%esp
  8019c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c9:	e8 ec f4 ff ff       	call   800eba <fd2num>
  8019ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019dc:	e9 4f ff ff ff       	jmp    801930 <pipe+0x75>
	sys_page_unmap(0, va);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	56                   	push   %esi
  8019e5:	6a 00                	push   $0x0
  8019e7:	e8 a4 f2 ff ff       	call   800c90 <sys_page_unmap>
  8019ec:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f5:	6a 00                	push   $0x0
  8019f7:	e8 94 f2 ff ff       	call   800c90 <sys_page_unmap>
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	e9 1c ff ff ff       	jmp    801920 <pipe+0x65>

00801a04 <pipeisclosed>:
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 08             	pushl  0x8(%ebp)
  801a11:	e8 1a f5 ff ff       	call   800f30 <fd_lookup>
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	78 18                	js     801a35 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	ff 75 f4             	pushl  -0xc(%ebp)
  801a23:	e8 a2 f4 ff ff       	call   800eca <fd2data>
	return _pipeisclosed(fd, p);
  801a28:	89 c2                	mov    %eax,%edx
  801a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2d:	e8 30 fd ff ff       	call   801762 <_pipeisclosed>
  801a32:	83 c4 10             	add    $0x10,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a3d:	68 5f 28 80 00       	push   $0x80285f
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	e8 c8 ed ff ff       	call   800812 <strcpy>
	return 0;
}
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <devsock_close>:
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	53                   	push   %ebx
  801a55:	83 ec 10             	sub    $0x10,%esp
  801a58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a5b:	53                   	push   %ebx
  801a5c:	e8 f9 06 00 00       	call   80215a <pageref>
  801a61:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a69:	83 f8 01             	cmp    $0x1,%eax
  801a6c:	74 07                	je     801a75 <devsock_close+0x24>
}
  801a6e:	89 d0                	mov    %edx,%eax
  801a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	ff 73 0c             	pushl  0xc(%ebx)
  801a7b:	e8 b7 02 00 00       	call   801d37 <nsipc_close>
  801a80:	89 c2                	mov    %eax,%edx
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	eb e7                	jmp    801a6e <devsock_close+0x1d>

00801a87 <devsock_write>:
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	ff 75 10             	pushl  0x10(%ebp)
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	ff 70 0c             	pushl  0xc(%eax)
  801a9b:	e8 74 03 00 00       	call   801e14 <nsipc_send>
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <devsock_read>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 10             	pushl  0x10(%ebp)
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	ff 70 0c             	pushl  0xc(%eax)
  801ab6:	e8 ed 02 00 00       	call   801da8 <nsipc_recv>
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <fd2sockid>:
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ac3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	e8 63 f4 ff ff       	call   800f30 <fd_lookup>
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	78 10                	js     801ae4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad7:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801add:	39 08                	cmp    %ecx,(%eax)
  801adf:	75 05                	jne    801ae6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ae1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    
		return -E_NOT_SUPP;
  801ae6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aeb:	eb f7                	jmp    801ae4 <fd2sockid+0x27>

00801aed <alloc_sockfd>:
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 1c             	sub    $0x1c,%esp
  801af5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801af7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afa:	50                   	push   %eax
  801afb:	e8 e1 f3 ff ff       	call   800ee1 <fd_alloc>
  801b00:	89 c3                	mov    %eax,%ebx
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 43                	js     801b4c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	68 07 04 00 00       	push   $0x407
  801b11:	ff 75 f4             	pushl  -0xc(%ebp)
  801b14:	6a 00                	push   $0x0
  801b16:	e8 f0 f0 ff ff       	call   800c0b <sys_page_alloc>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	85 c0                	test   %eax,%eax
  801b22:	78 28                	js     801b4c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b27:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b2d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b32:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b39:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	50                   	push   %eax
  801b40:	e8 75 f3 ff ff       	call   800eba <fd2num>
  801b45:	89 c3                	mov    %eax,%ebx
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	eb 0c                	jmp    801b58 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b4c:	83 ec 0c             	sub    $0xc,%esp
  801b4f:	56                   	push   %esi
  801b50:	e8 e2 01 00 00       	call   801d37 <nsipc_close>
		return r;
  801b55:	83 c4 10             	add    $0x10,%esp
}
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    

00801b61 <accept>:
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	e8 4e ff ff ff       	call   801abd <fd2sockid>
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 1b                	js     801b8e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	ff 75 10             	pushl  0x10(%ebp)
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	50                   	push   %eax
  801b7d:	e8 0e 01 00 00       	call   801c90 <nsipc_accept>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 05                	js     801b8e <accept+0x2d>
	return alloc_sockfd(r);
  801b89:	e8 5f ff ff ff       	call   801aed <alloc_sockfd>
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <bind>:
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	e8 1f ff ff ff       	call   801abd <fd2sockid>
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 12                	js     801bb4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	50                   	push   %eax
  801bac:	e8 2f 01 00 00       	call   801ce0 <nsipc_bind>
  801bb1:	83 c4 10             	add    $0x10,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <shutdown>:
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	e8 f9 fe ff ff       	call   801abd <fd2sockid>
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	78 0f                	js     801bd7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	e8 41 01 00 00       	call   801d15 <nsipc_shutdown>
  801bd4:	83 c4 10             	add    $0x10,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <connect>:
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	e8 d6 fe ff ff       	call   801abd <fd2sockid>
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 12                	js     801bfd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	ff 75 10             	pushl  0x10(%ebp)
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	50                   	push   %eax
  801bf5:	e8 57 01 00 00       	call   801d51 <nsipc_connect>
  801bfa:	83 c4 10             	add    $0x10,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <listen>:
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	e8 b0 fe ff ff       	call   801abd <fd2sockid>
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	78 0f                	js     801c20 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	50                   	push   %eax
  801c18:	e8 69 01 00 00       	call   801d86 <nsipc_listen>
  801c1d:	83 c4 10             	add    $0x10,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c28:	ff 75 10             	pushl  0x10(%ebp)
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	e8 3c 02 00 00       	call   801e72 <nsipc_socket>
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	78 05                	js     801c42 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c3d:	e8 ab fe ff ff       	call   801aed <alloc_sockfd>
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	53                   	push   %ebx
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c4d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c54:	74 26                	je     801c7c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c56:	6a 07                	push   $0x7
  801c58:	68 00 60 80 00       	push   $0x806000
  801c5d:	53                   	push   %ebx
  801c5e:	ff 35 04 40 80 00    	pushl  0x804004
  801c64:	e8 5f 04 00 00       	call   8020c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c69:	83 c4 0c             	add    $0xc,%esp
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	e8 e8 03 00 00       	call   80205f <ipc_recv>
}
  801c77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c7c:	83 ec 0c             	sub    $0xc,%esp
  801c7f:	6a 02                	push   $0x2
  801c81:	e8 9b 04 00 00       	call   802121 <ipc_find_env>
  801c86:	a3 04 40 80 00       	mov    %eax,0x804004
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	eb c6                	jmp    801c56 <nsipc+0x12>

00801c90 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	56                   	push   %esi
  801c94:	53                   	push   %ebx
  801c95:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ca0:	8b 06                	mov    (%esi),%eax
  801ca2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ca7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cac:	e8 93 ff ff ff       	call   801c44 <nsipc>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	78 20                	js     801cd7 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	ff 35 10 60 80 00    	pushl  0x806010
  801cc0:	68 00 60 80 00       	push   $0x806000
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	e8 d3 ec ff ff       	call   8009a0 <memmove>
		*addrlen = ret->ret_addrlen;
  801ccd:	a1 10 60 80 00       	mov    0x806010,%eax
  801cd2:	89 06                	mov    %eax,(%esi)
  801cd4:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cf2:	53                   	push   %ebx
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	68 04 60 80 00       	push   $0x806004
  801cfb:	e8 a0 ec ff ff       	call   8009a0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d00:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d06:	b8 02 00 00 00       	mov    $0x2,%eax
  801d0b:	e8 34 ff ff ff       	call   801c44 <nsipc>
}
  801d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d26:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d2b:	b8 03 00 00 00       	mov    $0x3,%eax
  801d30:	e8 0f ff ff ff       	call   801c44 <nsipc>
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <nsipc_close>:

int
nsipc_close(int s)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d45:	b8 04 00 00 00       	mov    $0x4,%eax
  801d4a:	e8 f5 fe ff ff       	call   801c44 <nsipc>
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	53                   	push   %ebx
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d63:	53                   	push   %ebx
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	68 04 60 80 00       	push   $0x806004
  801d6c:	e8 2f ec ff ff       	call   8009a0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d71:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d77:	b8 05 00 00 00       	mov    $0x5,%eax
  801d7c:	e8 c3 fe ff ff       	call   801c44 <nsipc>
}
  801d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d9c:	b8 06 00 00 00       	mov    $0x6,%eax
  801da1:	e8 9e fe ff ff       	call   801c44 <nsipc>
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801db8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dc6:	b8 07 00 00 00       	mov    $0x7,%eax
  801dcb:	e8 74 fe ff ff       	call   801c44 <nsipc>
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	78 1f                	js     801df5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dd6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ddb:	7f 21                	jg     801dfe <nsipc_recv+0x56>
  801ddd:	39 c6                	cmp    %eax,%esi
  801ddf:	7c 1d                	jl     801dfe <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	50                   	push   %eax
  801de5:	68 00 60 80 00       	push   $0x806000
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	e8 ae eb ff ff       	call   8009a0 <memmove>
  801df2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801df5:	89 d8                	mov    %ebx,%eax
  801df7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5e                   	pop    %esi
  801dfc:	5d                   	pop    %ebp
  801dfd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801dfe:	68 6b 28 80 00       	push   $0x80286b
  801e03:	68 0d 28 80 00       	push   $0x80280d
  801e08:	6a 62                	push   $0x62
  801e0a:	68 80 28 80 00       	push   $0x802880
  801e0f:	e8 05 02 00 00       	call   802019 <_panic>

00801e14 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	53                   	push   %ebx
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e26:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e2c:	7f 2e                	jg     801e5c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	53                   	push   %ebx
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	68 0c 60 80 00       	push   $0x80600c
  801e3a:	e8 61 eb ff ff       	call   8009a0 <memmove>
	nsipcbuf.send.req_size = size;
  801e3f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e45:	8b 45 14             	mov    0x14(%ebp),%eax
  801e48:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e4d:	b8 08 00 00 00       	mov    $0x8,%eax
  801e52:	e8 ed fd ff ff       	call   801c44 <nsipc>
}
  801e57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    
	assert(size < 1600);
  801e5c:	68 8c 28 80 00       	push   $0x80288c
  801e61:	68 0d 28 80 00       	push   $0x80280d
  801e66:	6a 6d                	push   $0x6d
  801e68:	68 80 28 80 00       	push   $0x802880
  801e6d:	e8 a7 01 00 00       	call   802019 <_panic>

00801e72 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e83:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e88:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e90:	b8 09 00 00 00       	mov    $0x9,%eax
  801e95:	e8 aa fd ff ff       	call   801c44 <nsipc>
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    

00801ea6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eac:	68 98 28 80 00       	push   $0x802898
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	e8 59 e9 ff ff       	call   800812 <strcpy>
	return 0;
}
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <devcons_write>:
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	57                   	push   %edi
  801ec4:	56                   	push   %esi
  801ec5:	53                   	push   %ebx
  801ec6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ecc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ed1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ed7:	eb 2f                	jmp    801f08 <devcons_write+0x48>
		m = n - tot;
  801ed9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801edc:	29 f3                	sub    %esi,%ebx
  801ede:	83 fb 7f             	cmp    $0x7f,%ebx
  801ee1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ee6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	53                   	push   %ebx
  801eed:	89 f0                	mov    %esi,%eax
  801eef:	03 45 0c             	add    0xc(%ebp),%eax
  801ef2:	50                   	push   %eax
  801ef3:	57                   	push   %edi
  801ef4:	e8 a7 ea ff ff       	call   8009a0 <memmove>
		sys_cputs(buf, m);
  801ef9:	83 c4 08             	add    $0x8,%esp
  801efc:	53                   	push   %ebx
  801efd:	57                   	push   %edi
  801efe:	e8 4c ec ff ff       	call   800b4f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f03:	01 de                	add    %ebx,%esi
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f0b:	72 cc                	jb     801ed9 <devcons_write+0x19>
}
  801f0d:	89 f0                	mov    %esi,%eax
  801f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f12:	5b                   	pop    %ebx
  801f13:	5e                   	pop    %esi
  801f14:	5f                   	pop    %edi
  801f15:	5d                   	pop    %ebp
  801f16:	c3                   	ret    

00801f17 <devcons_read>:
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f26:	75 07                	jne    801f2f <devcons_read+0x18>
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    
		sys_yield();
  801f2a:	e8 bd ec ff ff       	call   800bec <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f2f:	e8 39 ec ff ff       	call   800b6d <sys_cgetc>
  801f34:	85 c0                	test   %eax,%eax
  801f36:	74 f2                	je     801f2a <devcons_read+0x13>
	if (c < 0)
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	78 ec                	js     801f28 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f3c:	83 f8 04             	cmp    $0x4,%eax
  801f3f:	74 0c                	je     801f4d <devcons_read+0x36>
	*(char*)vbuf = c;
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	88 02                	mov    %al,(%edx)
	return 1;
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	eb db                	jmp    801f28 <devcons_read+0x11>
		return 0;
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	eb d4                	jmp    801f28 <devcons_read+0x11>

00801f54 <cputchar>:
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f60:	6a 01                	push   $0x1
  801f62:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f65:	50                   	push   %eax
  801f66:	e8 e4 eb ff ff       	call   800b4f <sys_cputs>
}
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <getchar>:
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f76:	6a 01                	push   $0x1
  801f78:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f7b:	50                   	push   %eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	e8 1e f2 ff ff       	call   8011a1 <read>
	if (r < 0)
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 08                	js     801f92 <getchar+0x22>
	if (r < 1)
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	7e 06                	jle    801f94 <getchar+0x24>
	return c;
  801f8e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    
		return -E_EOF;
  801f94:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f99:	eb f7                	jmp    801f92 <getchar+0x22>

00801f9b <iscons>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa4:	50                   	push   %eax
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	e8 83 ef ff ff       	call   800f30 <fd_lookup>
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	78 11                	js     801fc5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fbd:	39 10                	cmp    %edx,(%eax)
  801fbf:	0f 94 c0             	sete   %al
  801fc2:	0f b6 c0             	movzbl %al,%eax
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <opencons>:
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd0:	50                   	push   %eax
  801fd1:	e8 0b ef ff ff       	call   800ee1 <fd_alloc>
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	78 3a                	js     802017 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	68 07 04 00 00       	push   $0x407
  801fe5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 1c ec ff ff       	call   800c0b <sys_page_alloc>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 21                	js     802017 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fff:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80200b:	83 ec 0c             	sub    $0xc,%esp
  80200e:	50                   	push   %eax
  80200f:	e8 a6 ee ff ff       	call   800eba <fd2num>
  802014:	83 c4 10             	add    $0x10,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	56                   	push   %esi
  80201d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80201e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802021:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802027:	e8 a1 eb ff ff       	call   800bcd <sys_getenvid>
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	ff 75 0c             	pushl  0xc(%ebp)
  802032:	ff 75 08             	pushl  0x8(%ebp)
  802035:	56                   	push   %esi
  802036:	50                   	push   %eax
  802037:	68 a4 28 80 00       	push   $0x8028a4
  80203c:	e8 34 e1 ff ff       	call   800175 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802041:	83 c4 18             	add    $0x18,%esp
  802044:	53                   	push   %ebx
  802045:	ff 75 10             	pushl  0x10(%ebp)
  802048:	e8 d7 e0 ff ff       	call   800124 <vcprintf>
	cprintf("\n");
  80204d:	c7 04 24 58 28 80 00 	movl   $0x802858,(%esp)
  802054:	e8 1c e1 ff ff       	call   800175 <cprintf>
  802059:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80205c:	cc                   	int3   
  80205d:	eb fd                	jmp    80205c <_panic+0x43>

0080205f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	8b 75 08             	mov    0x8(%ebp),%esi
  802067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
  80206d:	85 c0                	test   %eax,%eax
	    pg = (void *)UTOP;
  80206f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802074:	0f 44 c2             	cmove  %edx,%eax
	}
	if ((r = sys_ipc_recv(pg)) < 0) {
  802077:	83 ec 0c             	sub    $0xc,%esp
  80207a:	50                   	push   %eax
  80207b:	e8 3b ed ff ff       	call   800dbb <sys_ipc_recv>
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	85 c0                	test   %eax,%eax
  802085:	78 2b                	js     8020b2 <ipc_recv+0x53>
	    if (perm_store != NULL) {
	        *perm_store = 0;
	    }
	    return r;
	}
	if (from_env_store != NULL) {
  802087:	85 f6                	test   %esi,%esi
  802089:	74 0a                	je     802095 <ipc_recv+0x36>
	    *from_env_store = thisenv->env_ipc_from;
  80208b:	a1 08 40 80 00       	mov    0x804008,%eax
  802090:	8b 40 74             	mov    0x74(%eax),%eax
  802093:	89 06                	mov    %eax,(%esi)
	}
	if (perm_store != NULL) {
  802095:	85 db                	test   %ebx,%ebx
  802097:	74 0a                	je     8020a3 <ipc_recv+0x44>
	    *perm_store = thisenv->env_ipc_perm;
  802099:	a1 08 40 80 00       	mov    0x804008,%eax
  80209e:	8b 40 78             	mov    0x78(%eax),%eax
  8020a1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8020a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8020a8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    
	    if (from_env_store != NULL) {
  8020b2:	85 f6                	test   %esi,%esi
  8020b4:	74 06                	je     8020bc <ipc_recv+0x5d>
	        *from_env_store = 0;
  8020b6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    if (perm_store != NULL) {
  8020bc:	85 db                	test   %ebx,%ebx
  8020be:	74 eb                	je     8020ab <ipc_recv+0x4c>
	        *perm_store = 0;
  8020c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020c6:	eb e3                	jmp    8020ab <ipc_recv+0x4c>

008020c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	57                   	push   %edi
  8020cc:	56                   	push   %esi
  8020cd:	53                   	push   %ebx
  8020ce:	83 ec 0c             	sub    $0xc,%esp
  8020d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020d4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL) {
	    pg = (void *)UTOP;
  8020d7:	85 f6                	test   %esi,%esi
  8020d9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020de:	0f 44 f0             	cmove  %eax,%esi
  8020e1:	eb 09                	jmp    8020ec <ipc_send+0x24>
	do {
	    r = sys_ipc_try_send(to_env, val, pg, perm);
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
	        panic("ipc_send: %e", r);
	    }
	    sys_yield();
  8020e3:	e8 04 eb ff ff       	call   800bec <sys_yield>
	} while(r != 0);
  8020e8:	85 db                	test   %ebx,%ebx
  8020ea:	74 2d                	je     802119 <ipc_send+0x51>
	    r = sys_ipc_try_send(to_env, val, pg, perm);
  8020ec:	ff 75 14             	pushl  0x14(%ebp)
  8020ef:	56                   	push   %esi
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	57                   	push   %edi
  8020f4:	e8 9f ec ff ff       	call   800d98 <sys_ipc_try_send>
  8020f9:	89 c3                	mov    %eax,%ebx
	    if (r < 0 && r != -E_IPC_NOT_RECV) {
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	85 c0                	test   %eax,%eax
  802100:	79 e1                	jns    8020e3 <ipc_send+0x1b>
  802102:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802105:	74 dc                	je     8020e3 <ipc_send+0x1b>
	        panic("ipc_send: %e", r);
  802107:	50                   	push   %eax
  802108:	68 c8 28 80 00       	push   $0x8028c8
  80210d:	6a 45                	push   $0x45
  80210f:	68 d5 28 80 00       	push   $0x8028d5
  802114:	e8 00 ff ff ff       	call   802019 <_panic>
}
  802119:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80212c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80212f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802135:	8b 52 50             	mov    0x50(%edx),%edx
  802138:	39 ca                	cmp    %ecx,%edx
  80213a:	74 11                	je     80214d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80213c:	83 c0 01             	add    $0x1,%eax
  80213f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802144:	75 e6                	jne    80212c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	eb 0b                	jmp    802158 <ipc_find_env+0x37>
			return envs[i].env_id;
  80214d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802150:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802155:	8b 40 48             	mov    0x48(%eax),%eax
}
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    

0080215a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802160:	89 d0                	mov    %edx,%eax
  802162:	c1 e8 16             	shr    $0x16,%eax
  802165:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802171:	f6 c1 01             	test   $0x1,%cl
  802174:	74 1d                	je     802193 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802176:	c1 ea 0c             	shr    $0xc,%edx
  802179:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802180:	f6 c2 01             	test   $0x1,%dl
  802183:	74 0e                	je     802193 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802185:	c1 ea 0c             	shr    $0xc,%edx
  802188:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80218f:	ef 
  802190:	0f b7 c0             	movzwl %ax,%eax
}
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
  802195:	66 90                	xchg   %ax,%ax
  802197:	66 90                	xchg   %ax,%ax
  802199:	66 90                	xchg   %ax,%ax
  80219b:	66 90                	xchg   %ax,%ax
  80219d:	66 90                	xchg   %ax,%ax
  80219f:	90                   	nop

008021a0 <__udivdi3>:
  8021a0:	55                   	push   %ebp
  8021a1:	57                   	push   %edi
  8021a2:	56                   	push   %esi
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 1c             	sub    $0x1c,%esp
  8021a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021b7:	85 d2                	test   %edx,%edx
  8021b9:	75 35                	jne    8021f0 <__udivdi3+0x50>
  8021bb:	39 f3                	cmp    %esi,%ebx
  8021bd:	0f 87 bd 00 00 00    	ja     802280 <__udivdi3+0xe0>
  8021c3:	85 db                	test   %ebx,%ebx
  8021c5:	89 d9                	mov    %ebx,%ecx
  8021c7:	75 0b                	jne    8021d4 <__udivdi3+0x34>
  8021c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ce:	31 d2                	xor    %edx,%edx
  8021d0:	f7 f3                	div    %ebx
  8021d2:	89 c1                	mov    %eax,%ecx
  8021d4:	31 d2                	xor    %edx,%edx
  8021d6:	89 f0                	mov    %esi,%eax
  8021d8:	f7 f1                	div    %ecx
  8021da:	89 c6                	mov    %eax,%esi
  8021dc:	89 e8                	mov    %ebp,%eax
  8021de:	89 f7                	mov    %esi,%edi
  8021e0:	f7 f1                	div    %ecx
  8021e2:	89 fa                	mov    %edi,%edx
  8021e4:	83 c4 1c             	add    $0x1c,%esp
  8021e7:	5b                   	pop    %ebx
  8021e8:	5e                   	pop    %esi
  8021e9:	5f                   	pop    %edi
  8021ea:	5d                   	pop    %ebp
  8021eb:	c3                   	ret    
  8021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	39 f2                	cmp    %esi,%edx
  8021f2:	77 7c                	ja     802270 <__udivdi3+0xd0>
  8021f4:	0f bd fa             	bsr    %edx,%edi
  8021f7:	83 f7 1f             	xor    $0x1f,%edi
  8021fa:	0f 84 98 00 00 00    	je     802298 <__udivdi3+0xf8>
  802200:	89 f9                	mov    %edi,%ecx
  802202:	b8 20 00 00 00       	mov    $0x20,%eax
  802207:	29 f8                	sub    %edi,%eax
  802209:	d3 e2                	shl    %cl,%edx
  80220b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	89 da                	mov    %ebx,%edx
  802213:	d3 ea                	shr    %cl,%edx
  802215:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802219:	09 d1                	or     %edx,%ecx
  80221b:	89 f2                	mov    %esi,%edx
  80221d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802221:	89 f9                	mov    %edi,%ecx
  802223:	d3 e3                	shl    %cl,%ebx
  802225:	89 c1                	mov    %eax,%ecx
  802227:	d3 ea                	shr    %cl,%edx
  802229:	89 f9                	mov    %edi,%ecx
  80222b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80222f:	d3 e6                	shl    %cl,%esi
  802231:	89 eb                	mov    %ebp,%ebx
  802233:	89 c1                	mov    %eax,%ecx
  802235:	d3 eb                	shr    %cl,%ebx
  802237:	09 de                	or     %ebx,%esi
  802239:	89 f0                	mov    %esi,%eax
  80223b:	f7 74 24 08          	divl   0x8(%esp)
  80223f:	89 d6                	mov    %edx,%esi
  802241:	89 c3                	mov    %eax,%ebx
  802243:	f7 64 24 0c          	mull   0xc(%esp)
  802247:	39 d6                	cmp    %edx,%esi
  802249:	72 0c                	jb     802257 <__udivdi3+0xb7>
  80224b:	89 f9                	mov    %edi,%ecx
  80224d:	d3 e5                	shl    %cl,%ebp
  80224f:	39 c5                	cmp    %eax,%ebp
  802251:	73 5d                	jae    8022b0 <__udivdi3+0x110>
  802253:	39 d6                	cmp    %edx,%esi
  802255:	75 59                	jne    8022b0 <__udivdi3+0x110>
  802257:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80225a:	31 ff                	xor    %edi,%edi
  80225c:	89 fa                	mov    %edi,%edx
  80225e:	83 c4 1c             	add    $0x1c,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    
  802266:	8d 76 00             	lea    0x0(%esi),%esi
  802269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802270:	31 ff                	xor    %edi,%edi
  802272:	31 c0                	xor    %eax,%eax
  802274:	89 fa                	mov    %edi,%edx
  802276:	83 c4 1c             	add    $0x1c,%esp
  802279:	5b                   	pop    %ebx
  80227a:	5e                   	pop    %esi
  80227b:	5f                   	pop    %edi
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    
  80227e:	66 90                	xchg   %ax,%ax
  802280:	31 ff                	xor    %edi,%edi
  802282:	89 e8                	mov    %ebp,%eax
  802284:	89 f2                	mov    %esi,%edx
  802286:	f7 f3                	div    %ebx
  802288:	89 fa                	mov    %edi,%edx
  80228a:	83 c4 1c             	add    $0x1c,%esp
  80228d:	5b                   	pop    %ebx
  80228e:	5e                   	pop    %esi
  80228f:	5f                   	pop    %edi
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    
  802292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802298:	39 f2                	cmp    %esi,%edx
  80229a:	72 06                	jb     8022a2 <__udivdi3+0x102>
  80229c:	31 c0                	xor    %eax,%eax
  80229e:	39 eb                	cmp    %ebp,%ebx
  8022a0:	77 d2                	ja     802274 <__udivdi3+0xd4>
  8022a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a7:	eb cb                	jmp    802274 <__udivdi3+0xd4>
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	89 d8                	mov    %ebx,%eax
  8022b2:	31 ff                	xor    %edi,%edi
  8022b4:	eb be                	jmp    802274 <__udivdi3+0xd4>
  8022b6:	66 90                	xchg   %ax,%ax
  8022b8:	66 90                	xchg   %ax,%ax
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__umoddi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8022cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022d7:	85 ed                	test   %ebp,%ebp
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	89 da                	mov    %ebx,%edx
  8022dd:	75 19                	jne    8022f8 <__umoddi3+0x38>
  8022df:	39 df                	cmp    %ebx,%edi
  8022e1:	0f 86 b1 00 00 00    	jbe    802398 <__umoddi3+0xd8>
  8022e7:	f7 f7                	div    %edi
  8022e9:	89 d0                	mov    %edx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	83 c4 1c             	add    $0x1c,%esp
  8022f0:	5b                   	pop    %ebx
  8022f1:	5e                   	pop    %esi
  8022f2:	5f                   	pop    %edi
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    
  8022f5:	8d 76 00             	lea    0x0(%esi),%esi
  8022f8:	39 dd                	cmp    %ebx,%ebp
  8022fa:	77 f1                	ja     8022ed <__umoddi3+0x2d>
  8022fc:	0f bd cd             	bsr    %ebp,%ecx
  8022ff:	83 f1 1f             	xor    $0x1f,%ecx
  802302:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802306:	0f 84 b4 00 00 00    	je     8023c0 <__umoddi3+0x100>
  80230c:	b8 20 00 00 00       	mov    $0x20,%eax
  802311:	89 c2                	mov    %eax,%edx
  802313:	8b 44 24 04          	mov    0x4(%esp),%eax
  802317:	29 c2                	sub    %eax,%edx
  802319:	89 c1                	mov    %eax,%ecx
  80231b:	89 f8                	mov    %edi,%eax
  80231d:	d3 e5                	shl    %cl,%ebp
  80231f:	89 d1                	mov    %edx,%ecx
  802321:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802325:	d3 e8                	shr    %cl,%eax
  802327:	09 c5                	or     %eax,%ebp
  802329:	8b 44 24 04          	mov    0x4(%esp),%eax
  80232d:	89 c1                	mov    %eax,%ecx
  80232f:	d3 e7                	shl    %cl,%edi
  802331:	89 d1                	mov    %edx,%ecx
  802333:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802337:	89 df                	mov    %ebx,%edi
  802339:	d3 ef                	shr    %cl,%edi
  80233b:	89 c1                	mov    %eax,%ecx
  80233d:	89 f0                	mov    %esi,%eax
  80233f:	d3 e3                	shl    %cl,%ebx
  802341:	89 d1                	mov    %edx,%ecx
  802343:	89 fa                	mov    %edi,%edx
  802345:	d3 e8                	shr    %cl,%eax
  802347:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80234c:	09 d8                	or     %ebx,%eax
  80234e:	f7 f5                	div    %ebp
  802350:	d3 e6                	shl    %cl,%esi
  802352:	89 d1                	mov    %edx,%ecx
  802354:	f7 64 24 08          	mull   0x8(%esp)
  802358:	39 d1                	cmp    %edx,%ecx
  80235a:	89 c3                	mov    %eax,%ebx
  80235c:	89 d7                	mov    %edx,%edi
  80235e:	72 06                	jb     802366 <__umoddi3+0xa6>
  802360:	75 0e                	jne    802370 <__umoddi3+0xb0>
  802362:	39 c6                	cmp    %eax,%esi
  802364:	73 0a                	jae    802370 <__umoddi3+0xb0>
  802366:	2b 44 24 08          	sub    0x8(%esp),%eax
  80236a:	19 ea                	sbb    %ebp,%edx
  80236c:	89 d7                	mov    %edx,%edi
  80236e:	89 c3                	mov    %eax,%ebx
  802370:	89 ca                	mov    %ecx,%edx
  802372:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802377:	29 de                	sub    %ebx,%esi
  802379:	19 fa                	sbb    %edi,%edx
  80237b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80237f:	89 d0                	mov    %edx,%eax
  802381:	d3 e0                	shl    %cl,%eax
  802383:	89 d9                	mov    %ebx,%ecx
  802385:	d3 ee                	shr    %cl,%esi
  802387:	d3 ea                	shr    %cl,%edx
  802389:	09 f0                	or     %esi,%eax
  80238b:	83 c4 1c             	add    $0x1c,%esp
  80238e:	5b                   	pop    %ebx
  80238f:	5e                   	pop    %esi
  802390:	5f                   	pop    %edi
  802391:	5d                   	pop    %ebp
  802392:	c3                   	ret    
  802393:	90                   	nop
  802394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802398:	85 ff                	test   %edi,%edi
  80239a:	89 f9                	mov    %edi,%ecx
  80239c:	75 0b                	jne    8023a9 <__umoddi3+0xe9>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f7                	div    %edi
  8023a7:	89 c1                	mov    %eax,%ecx
  8023a9:	89 d8                	mov    %ebx,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f1                	div    %ecx
  8023af:	89 f0                	mov    %esi,%eax
  8023b1:	f7 f1                	div    %ecx
  8023b3:	e9 31 ff ff ff       	jmp    8022e9 <__umoddi3+0x29>
  8023b8:	90                   	nop
  8023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c0:	39 dd                	cmp    %ebx,%ebp
  8023c2:	72 08                	jb     8023cc <__umoddi3+0x10c>
  8023c4:	39 f7                	cmp    %esi,%edi
  8023c6:	0f 87 21 ff ff ff    	ja     8022ed <__umoddi3+0x2d>
  8023cc:	89 da                	mov    %ebx,%edx
  8023ce:	89 f0                	mov    %esi,%eax
  8023d0:	29 f8                	sub    %edi,%eax
  8023d2:	19 ea                	sbb    %ebp,%edx
  8023d4:	e9 14 ff ff ff       	jmp    8022ed <__umoddi3+0x2d>
